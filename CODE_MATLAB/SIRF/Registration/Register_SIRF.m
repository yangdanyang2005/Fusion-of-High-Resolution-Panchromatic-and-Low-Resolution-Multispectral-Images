%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This is the demo code for 
%%%% "SIRF: Simultaneous Image Registration and Fusion in a unified
%%%% framework", by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang

%%%% and "Image Fusion with Local Spectral Consistency and Dynamic Gradient Sparsity"
%%%% by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang, CVPR 2014.

%%%% Contact: Chen Chen (cchen@mavs.uta.edu) and Junzhou Huang
%%%% (jzhuang@uta.edu), Department of Computer Science and Engineering,
%%%% University of Texas at Arlington 

%%%% If you used our code, please cite our papers!

%%%% Partial of this code is from:
%%%% MIRT https://sites.google.com/site/myronenko/research/mirt
%%%% RASL http://perception.csl.illinois.edu/matrix-rank/rasl.html
%%%% SparseMRI http://www.eecs.berkeley.edu/~mlustig/Software.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [res, im_int]=Register_SIRF(refim, im, main, optim)
% refim: reference image
% im: source image
% main: registration settings
% optim: optimization settings

% Output--
% res: registration result (including the transform)
% im_int: the image after registration


% checking for the other possible errors
if numel(size(im))~=numel(size(refim)), error('The dimensions of images are not the same.'); end;
if size(im,1)~=size(refim,1), error('The images must be of the same size.'); end;
if size(im,2)~=size(refim,2), error('The images must be of the same size.'); end;

% Original image size
dimen=size(refim);

% Create Pyramid
[fig1, fig2] = createPyramid(refim,im, main.subdivide);

Minitial = eye(3);

% Go across all sub-levels
for level=1:main.subdivide
    
    Minitial(1:2,3)=Minitial(1:2,3)*2;
    ima1 = fig1(main.subdivide-level+1).im;
    ima2 = fig2(main.subdivide-level+1).im;
    main.X = Minitial;
    [M,result] = Registration(ima1,ima2,main,optim);
        
    Minitial = M;
end

% Prepair the output
res.X=M;

% because we have appended the initial images with the border of NaNs during the
% registration, now we want to remove that border and get the result of the
% initial image size
im_int=zeros(dimen); [M,N]=size(result);
im_int(1:min(dimen(1),M),1:min(dimen(2),N))=result(1:min(dimen(1),M),1:min(dimen(2),N));

function [fig1, fig2] = createPyramid(im1,im2, level)
%CREATEPYRAMID Creates two n-level pyramid.
%   [fig1, fig2] = createPyramid(im1,im2,level) creates two pyramid of
%   depth defined by level. Returns two struct arrays. To access array
%   information use: fig1(1).im, fig1(2).im etc
%
%   See also IMRESIZE.
%   Copyright y@s
%   Date: Tuesday, Oct 22nd, 2002

% Assign lowest level of pyramid
fig1(1).im = im1;
fig2(1).im = im2;

% Loop to create pyramid
for i=1: level-1
    fig1(1+i).im = imresize(fig1(i).im, [size(fig1(i).im,1)/2 size(fig1(i).im,2)/2], 'bilinear');
    fig2(1+i).im = imresize(fig2(i).im, [size(fig2(i).im,1)/2 size(fig2(i).im,2)/2], 'bilinear');
end
