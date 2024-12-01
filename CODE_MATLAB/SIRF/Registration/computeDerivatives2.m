function [fx,fy,ft] = computeDerivatives2(im1,im2)
% 
% function [fx,fy,fz] = computeDerivatives2(im1,im2)
%
% im1 and im2 are images
%
% [fx,fy,ft] are images, derivatives of the input images

filter = [0.03504 0.24878 0.43234 0.24878 0.03504];
dfilter = [0.10689 0.28461 0.0  -0.28461  -0.10689];

dx1 = conv2sep(im1,dfilter,filter,'valid');
dy1 = conv2sep(im1,filter,dfilter,'valid');
blur1 = conv2sep(im1,filter,filter,'valid');
dx2 = conv2sep(im2,dfilter,filter,'valid');
dy2 = conv2sep(im2,filter,dfilter,'valid');
blur2 = conv2sep(im2,filter,filter,'valid');

fx=(dx1+dx2)/2;
fy=(dy1+dy2)/2;
ft=(blur2-blur1);
return

function result = conv2sep(im,rowfilt,colfilt,shape)
% CONV2SEP: Separable convolution using conv2.
% 
%      result=conv2sep(im,rowfilt,colfilt,shape)
%
%      im - input image.
%      rowfilt - 1d filter applied to the rows
%      colfilt - 1d filter applied to the cols
%      shape - 'full', 'same', or 'valid' (see doc for conv2).
%
% Example: foo=conv2sep(im,[1 4 6 4 1],[-1 0 1],'valid');


if ~exist('shape')
  shape='full';
end

rowfilt=rowfilt(:)';
colfilt=colfilt(:);

tmp = conv2(im,rowfilt,shape);
result = conv2(tmp,colfilt,shape);
