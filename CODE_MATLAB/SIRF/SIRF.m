
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This is the demo code for
%%%% "SIRF: Simultaneous Image Registration and Fusion in a unified
%%%% framework", by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang

%%%% and "Image Fusion with Local Spectral Consistency and Dynamic Gradient Sparsity"
%%%% by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang, CVPR 2014.

%%%% Contact: Chen Chen (chenchen.cn87@gmail.com) and Junzhou Huang
%%%% (jzhuang@uta.edu), Department of Computer Science and Engineering,
%%%% University of Texas at Arlington
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y,P,trans]= SIRF(M,P, divK, lambda, iter, iterReg, display)
%%%% min |RX-M|_2^2/(2*lambda) + |X-T(P)|_VTV
% M : multispectral image
% P : Pan image
% divK: the resolution difference between the Pan and MS
% lambda: regularization parameter
% iter: the number of iterations one does to minimize the energy
% display: display the registration process or not
% iterReg: number of iterations for registration

% Output----
% Y: the fused image
% P: the Pan image after registration
% trans: the estimated transformation

if ~exist('display','var')
    display = 0;
end
if ~exist('iterReg','var')
    iterReg = 0;
end

%%% registration settings
main.type = 'TRANSLATION'; %translation
main.TV = TVOP;
main.subdivide=3;       % use 3 hierarchical levels
main.single=display;          % show transformation at every iteration
% Optimization settings for registration
optim.maxsteps = 200;   % maximum number of iterations at each hierarchical level
optim.fundif = 1e-6;    % tolerance (stopping criterion)
optim.gamma = 1;       % initial optimization step size
optim.anneal=0.8;       % annealing rate on the optimization step

%%% TV settings
parsin.MAXITER=3; parsin.tv='iso';
l = min(min(P)); u =max(max(P));
if((l==-Inf)&&(u==Inf))
    project=@(x)x;
elseif (isfinite(l)&&(u==Inf))
    project=@(x)(((l<x).*x)+(l*(x<=l)));
elseif (isfinite(u)&&(l==-Inf))
    project=@(x)(((x<u).*x)+((x>=u)*u));
elseif ((isfinite(u)&&isfinite(l))&&(l<u))
    project=@(x)(((l<x)&(x<u)).*x)+((x>=u)*u)+(l*(x<=l));
else
    error('lower and upper bound l,u should satisfy l<u');
end

T = size(M,3);
M = double(M);
P = double(P);
[m,n] = size(P);
[c1]=find(isnan(P));
P(c1) = zeros(size(c1));
for t=1:T
    P3(:,:,t) = P;
end
L=1;
x = zeros(m,n,T);
x = imresize(M,[m,n]);
y = x;
tnew=1;

if display
    figure(22);
    imshow(x(:,:,1:3)/255,[]);
end

for k=1:iter
    
    told=tnew;
    xp=x;
    
    dd = imresize(x,[m/divK,n/divK]) - M;
    df2 = imresize(dd,[m,n]);
    
    yg = y - df2/L;
    
    % 使用 denoise_TV_MT 方法进行图像去噪
    if (k==1)
        [x, P1, P2]=denoise_TV_MT(yg-P3, 1/(L*lambda),-inf,inf,[],[], parsin);
    else
        [x, P1, P2]=denoise_TV_MT(yg-P3, 1/(L*lambda),-inf,inf,P1, P2,parsin);
    end
    
    x = project(x+P3);
    
    tnew=(1+sqrt(1+4*told^2))/2;
    y=x+((told-1)/tnew)*(x-xp);
    
    if k <iterReg+1
        fprintf(1,'Registering...\n');
        [res, P]=Register_SIRF(mean(y,3),P, main, optim);
        if k == 1
            trans{k} = res.X;
        else
            trans{k} = trans{k-1}*res.X;
        end
        [c1]=find(isnan(P));        
        P(c1) = zeros(size(c1));
               
        for t=1:T
            P3(:,:,t) = P;
        end
    end
end
Y = x;
