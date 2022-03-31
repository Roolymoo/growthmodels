% note: some input values can lead to undefined behaviour due to implementation
n = 40; % fixed number of columns
rate = 3; % exp(rate) for waiting times
T = 120; % how long in seconds the program should run

heights = []; % track column heights
waitingTimes = []; % track column waiting times
for i = 1:n
    heights = [heights 0];
    waitingTimes = [waitingTimes exprnd(rate)];
end

figure 
hold on
tStart = tic; % make sure to not call toc immediately
currentTime = 0;
while currentTime < T % stop when reached prescribed program time
    tComputation = tic; % used to ignore computation time, i.e. dropping blocks is considered instantaneous
    % check each column to determine if a block is ready to fall
    % check first column separately 
    i=1;
    t = waitingTimes(i);
    if currentTime >= t % drop block
        h = max([heights(i) heights(i+1)-1]);
        p = polyshape([i-1 i i i-1],[h h h+1 h+1]);
        plot(p);
        drawnow
        heights(i) = h + 1; % update column height
        waitingTimes(i) = waitingTimes(i) + exprnd(rate); % assign new waiting time
    end
    for i = 2:n-1
        t = waitingTimes(i);
        if currentTime >= t
            h = max([heights(i) heights(i+1)-1 heights(i-1)-1]);
            p = polyshape([i-1 i i i-1],[h h h+1 h+1]);
            plot(p);
            drawnow
            heights(i) = h + 1;
            waitingTimes(i) = waitingTimes(i) + exprnd(rate);
        end
    end
    % consider last column separately
    i=n;
    t = waitingTimes(i);
    if currentTime >= t
        h = max([heights(i) heights(i-1)-1]);
        p = polyshape([i-1 i i i-1],[h h h+1 h+1]);
        plot(p);
        drawnow
        heights(i) = h + 1;
        waitingTimes(i) = waitingTimes(i) + exprnd(rate);
    end
    axis([0 n 0 max([n max(heights)])]) % update axis height when needed. note it will vertically squish the figure, can set n larger to remedy
    currentTime = toc(tStart) - toc(tComputation); % update currentTime, including removing the computation time from the loop
end