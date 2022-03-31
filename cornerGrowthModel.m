% note: some input values can lead to undefined behaviour due to implementation
rate = 2; % exp(rate) for waiting times
T = 120; % how long in seconds the program should run

keys = {0}; % x-coordinate of point
values = {[0,exprnd(rate),1]}; % [h,t,f] for height h, waiting time t to flip and isMinimum flag f (true/false) for point
% start with only the origin point which a minimum. generate points on a
% need to basis
points = containers.Map(keys,values); 
xMax = 0; % largest x-coordinate of point in absolute value

figure 
hold on
tStart = tic; % make sure to not call toc immediately
currentTime = 0; % track time for determining flips
while currentTime < T % stop when reached prescribed program time
    tComputation = tic; % used to ignore computation time in the whole loop, i.e. flippings are considered instantaneous
    xMaxNew = xMax; % for updating xMax
    % look at each point available and flip minimums when ready,
    % dynamically creating more points when needed
    for i = -xMax:xMax
        if isKey(points,i) % have a point with x-coordinate i
            p = points(i);
            h = p(1);
            t = p(2);
            f = p(3);
            if (currentTime >= t) & f % only look at point if its a minimum
                % check left and right points to see if points exist and create
                % them if they do not
                if ~isKey(points,i-1)
                    xMaxNew = max([xMaxNew abs(i-1)]);
                    points(i-1) = [abs(i-1),0,0]; % waiting time set later
                end
                if ~isKey(points,i+1)
                    xMaxNew = max([xMaxNew abs(i+1)]);
                    points(i+1) = [abs(i+1),0,0];
                end
                % flip the minimum at i 
                xMaxNew = max([xMaxNew abs(i)]);
                p = polyshape([i i+1 i i-1],[h h+1 h+2 h+1]);
                plot(p);
                drawnow
                % make points left and right of p to be minimums if needed
                % get left point
                leftPoint = points(i-1);
                leftHeight = leftPoint(1);
                if ~isKey(points,i-2) % create point if necessary
                    xMaxNew = max([xMaxNew abs(i-2)]);
                    points(i-2) = [abs(i-2),0,0]; % waiting time set when determined a minimum
                end
                % determine if minimum
                leftLeftPoint = points(i-2);
                leftLeftHeight = leftLeftPoint(1);
                if leftLeftHeight > leftHeight 
                    points(i-1) = [leftHeight,currentTime + exprnd(rate),1]; % its a minimum, set waiting time
                end
                % repeat for right point
                rightPoint = points(i+1);
                rightHeight = rightPoint(1);
                if ~isKey(points,i+2) 
                    xMaxNew = max([xMaxNew abs(i+2)]);
                    points(i+2) = [abs(i+2),0,0]; 
                end
                rightRightPoint = points(i+2);
                rightRightHeight = rightRightPoint(1);
                if rightRightHeight > rightHeight
                    points(i+1) = [rightHeight,currentTime + exprnd(rate),1];
                end
                % update point now that it has been flipped
                h = h + 2;
                % no need to set t yet since not a minimum, will be set
                % later
                p = [h,0,0];
                points(i) = p;
            end
        end
    end
    xMax = xMaxNew; % update xMax
    axis([-(xMax+10) xMax+10 0 xMax+10]) % update axis height in figure when needed
    currentTime = toc(tStart) - toc(tComputation); % update currentTime, including removing the computation time from the loop
end