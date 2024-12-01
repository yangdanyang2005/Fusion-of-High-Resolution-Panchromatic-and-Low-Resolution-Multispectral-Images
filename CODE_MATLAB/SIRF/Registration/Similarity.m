function [f,dx,imsmall]=Similarity(im,refim,X,main)

imsmall =  warpAffine2(im,X);
main.refimsmall = refim;

rbig=imsmall-main.refimsmall;
[y,x]=find_imagebox(rbig); r=rbig(y,x);
r(isnan(r))=nanmean(r(:));

if size(r,1)<5
    f = inf;
    dx = zeros(size(rbig));
    return;
end

gradXY = main.TV*r;
TV = (abs(gradXY(:)).^2 + 1e-15).^(1/2);
f = 0.5*sum(TV);

dd=zeros(size(rbig));
dd(y,x)=gTV(r,main);

ON = ~isnan(rbig);
ON = sum(ON(:));
if ON == 0;
    f = inf;
else
    f = f/ON;
end


dx = dd;


% This subfunctions finds the coordinates of the largest square
% within the image that has no NaNs (not affected by interpolation)
% It can be useful to ignore the border artifacts caused by interpolation,
% or when the actual image has some black border around it, that you don't
% want to take into account.
function [y,x]=find_imagebox(im)
[i,j]=find(~isnan(im));
n=4; % border size
y=min(i)+n:max(i)-n;
x=min(j)+n:max(j)-n;

function grad = gTV(x,main)
% compute gradient of TV operator
Dx = main.TV*x;
Dx2 = Dx.*conj(Dx);
G = Dx.*(Dx2 + 1e-15).^(1/2-1);
grad = main.TV'*G;

