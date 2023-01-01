% Author: Raghav Hariharan
% DO NOT CHANGE OR MODIFY THIS FILE!
% This is an example tesing file for 3 Parcels!
% This is the format that will be used by the demonstrators for marking.
% Make sure you test that this file accepts your solution format before
% submiting. Otherwise you will get 0 when the automark happens.
% This file is just an example. More tests will be done after submission!

% Declare number of parcels = 3
totalNumberOfParcels = 5;

% Change pauseTime. Currently set to 0.5
pauseTime = 0;

% Creating the various test cases.
desiredParcels = {
[
[0 0 0 0 0 0];
[1 2 3 4 5 0];
[0 0 0 0 0 0];
[0 0 0 0 0 0];
];

[
[0 0 0 0 0 0];
[0 0 0 0 0 0];
[1 2 3 4 5 0];
[0 0 0 0 0 0];
];

[
[0 0 0 0 0 0];
[0 0 0 0 0 0];
[0 0 0 0 0 0];
[1 2 3 4 5 0];
];

[
[0 0 0 0 0 0];
[1 0 0 0 0 0];
[2 5 0 0 0 0];
[3 4 0 0 0 0];
];

[
[0 0 0 0 0 0];
[1 5 0 0 0 0];
[3 0 0 0 0 0];
[2 4 0 0 0 0];
];

[
[0 0 0 0 0 0];
[1 2 0 0 0 0];
[3 4 0 0 0 0];
[5 0 0 0 0 0];
];

[
[0 0 0 0 0 0];
[1 3 5 0 0 0];
[2 0 0 0 0 0];
[4 0 0 0 0 0];
];

[
[0 0 0 0 0 0];
[5 0 0 0 0 0];
[2 4 0 0 0 0];
[1 3 0 0 0 0];
];

};


% Identifying how many tests there are.
[row, col] = size(desiredParcels);
totalTests = row;
testsPassed = 0;
testsFailed = 0;

% Calling your function with each test case.
for i = 1:row
    clf(); % Clear any figure with the project2sim.

    % Calling the student's project2 function from the project2 file.
    % If the file name or the function name have changed it will not work.
    % All testing will be done with this format, so it must be strictly
    % followed!

    sim = project2(desiredParcels{i},totalNumberOfParcels,pauseTime);
    finalPositions = sim.positions();
    % Checking the final positions from the sim, to check if they match 
    % the input
    if finalPositions == desiredParcels{i} % If match. Test passed.
        disp("Test Passed");
        testsPassed = testsPassed + 1;
    else % IF no match. Test Failed.
        disp("Test Failed");
        testsFailed = testsFailed + 1;
    end    
    delete(sim);
end

% Calculate total number of tests passed.
mark = testsPassed/totalTests;
fprintf("Final Mark = %d \n",mark);
