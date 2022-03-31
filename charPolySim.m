% plots the inverse of the product of the modulus of 
% (1-z/lambda)exp(z/lambda) as lambda takes on points distributed a general 
% beta ensemble on n points rescaled such that they converge to the 
% eigenvalues of the stochastic airy  operator and that they increase to 
% infinity. n=100 takes a couple minutes but beyond that it gets really 
% slow

b = 5; % beta parameter
n = 100; % number of points
syms x y poly(x);
z = x + 1i*y;
% plotting parameters
xLowerLimit = -10;
xUpperLimit = 50;
yLowerLimit = -10;
yUpperLimit = 10;
zLowerLimit = 0;
zUpperLimit = 10;

% build the polynomial
Ab = stoAiryMatrix(n,b);
e = eig(Ab);
poly(x) = 1;
for i = 1:n
    poly(x) = poly(x)*(1-x/e(i))*exp(x/e(i));
end

% plot
figure(2)
fsurf(abs(1/poly(z)))
a = gca; % axis
a.XLim = [xLowerLimit xUpperLimit];
a.YLim = [yLowerLimit yUpperLimit];
a.ZLim = [zLowerLimit zUpperLimit]; % output
caxis([zLowerLimit zUpperLimit]); % colour range

function Ab = stoAiryMatrix(n, b)
    % creates an nxn matrix approximating the SAO with parameter beta=b.
    % uses the tridiagonal matrix with approximated chi's. b=0 corresponds
    % to beta=infinity
    if b == 0
        Ab = n.^(2/3) * (diag((-1) * ones(1,n-1),1) + diag((-1) * ones(1,n-1),-1) + diag(2 * ones(1,n))) + n.^(-1/3) * diag(1:1:n);
    else
        n1 = [];
        for i = 1:n
            n1 = [n1 normrnd(0,2)];
        end
        n2 = [];
        for i = 1:n-1
            n2 = [n2 normrnd(0,1/2)];
        end
        Ab = n.^(2/3) * (diag((-1) * ones(1,n-1),1) + diag((-1) * ones(1,n-1),-1) + diag(2 * ones(1,n))) + 1/(2*n.^(1/3)) * (diag([1:1:n-1],1) + diag([1:1:n-1],-1)) + n.^(1/6)/sqrt(b) * ((diag(n1)) + diag(n2,1) + diag(n2,-1));
    end
end