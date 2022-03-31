% plots 1/|airy(z)| 

syms x y;
z = x + 1i*y;
% plotting parameters
xLowerLimit = -50;
xUpperLimit = 10;
yLowerLimit = -10;
yUpperLimit = 10;
zLowerLimit = 0;
zUpperLimit = 10;

% plot
fsurf(abs(1/airy(z)))
a = gca; % axis
a.XLim = [xLowerLimit xUpperLimit];
a.YLim = [yLowerLimit yUpperLimit];
a.ZLim = [zLowerLimit zUpperLimit]; % output
caxis([zLowerLimit zUpperLimit]); % colour range