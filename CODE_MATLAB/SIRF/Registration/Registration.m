function [X, im]=Registration(refim,im, main, optim)

%% Start the main registration
srim = im;

X = main.X;
% im = warpAffine2(im,X);

% Compute the derivatives of the image
[Iu,Iv,ft]=computeDerivatives2(im,refim);
J =  image_Jaco(Iu(:), Iv(:), size(im)-4, main.type, X);

[f,dx,im]=Similarity(im,refim,X,main);
iter=0;
fchange  = inf;

if main.single
    figure(22); imshowpair(im, refim);
    pause(0.5);
end
% do while the relative function difference is below the threshold and
% the meximum number of iterations has not been reached
while (iter<optim.maxsteps) &&(abs(fchange)>optim.fundif)
    
    idx = ~isnan(J(:,1));
    delta_X = eye(3);
    dx = dx(3:end-2,3:end-2);
    idx2 = ~isnan(dx);
    idx =idx & idx2(:) ;
    
    A = J(idx,:);
    b = dx(idx);
    grad = pinv(A)*b;
    
    converge = 0;iit = 0;optim.gamma = 1;
    while ~converge
        iit = iit + 1;
        
        if strcmp( main.type,'TRANSLATION'),
            delta_X(1:2,3) = delta_X(1:2,3) - optim.gamma*grad;
        elseif strcmp( main.type,'AFFINE'),            
            delta_X(1,1:3) = delta_X(1,1:3) - optim.gamma*grad(1:3)';
            delta_X(2,1:3) = delta_X(2,1:3) - optim.gamma*grad(4:6)';
        end
        
        
        [fp,dpx,imb]=Similarity(im,refim,delta_X,main);
        if (fp > f)
            
            if strcmp( main.type,'TRANSLATION'),
                delta_X(1:2,3) = delta_X(1:2,3) + optim.gamma*grad;
            elseif strcmp( main.type,'AFFINE'),               
                delta_X(1,1:3) = delta_X(1,1:3) + optim.gamma*grad(1:3)';
                delta_X(2,1:3) = delta_X(2,1:3) + optim.gamma*grad(4:6)';               
            end
            optim.gamma=optim.gamma*optim.anneal;
        else
            fnew = fp;
            break;
        end
        
        if iit>optim.maxsteps
            converge = 1;
            fnew = inf;
        end
        
    end
    
    X=delta_X*X;
    
    im = warpAffine2(srim,X);
    
    fchange=(fnew-f)/f;
    f=fnew;
    dx = dpx;
    
    if main.single
        figure(22); imshowpair(im, refim);
        pause(0.1);
    end
    
    [Iu,Iv,ft]=computeDerivatives2(im,refim);
    J =  image_Jaco(Iu(:), Iv(:), size(im)-4, main.type, X);
    
    iter=iter+1;
    %     disp([iter, fnew]);
    
    if converge
        break;
    end
end

