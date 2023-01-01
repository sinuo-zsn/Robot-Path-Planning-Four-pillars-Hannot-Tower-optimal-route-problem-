% DO NOT CHANGE THE FILE NAME OR IT WILL NOT WORK DURING TESTING
% Author: Sinuo Zhao
% zid: z5375442
% Date: 2022/08/01

%% Default for real robot control
clc;
clear all;

% TCP Host and Port settings
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
rtdeport = 30003;
vacuumport = 63352;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,rtdeport);

% Calling the constructor of vacuum to setup tcp connction
vacuum = vacuum(host,vacuumport);

home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];
start = [-588.53, -133.30, 71.91, 2.2214, -2.2214, 0.00];
rtde.movej(home);
% Remember when you set t, it will have priority over the a and v
% parameters that you have set!

%% Input
% Declare number of parcels = 3
totalNumberOfParcels = 5;
% Change pauseTime. Currently set to 0.5
pauseTime = 0.5;
% Desired positions for the parcels
desiredParcels = [
    [0 0 0 0 0 0];
    [1 2 3 4 5 0];
    [0 0 0 0 0 0];
    [0 0 0 0 0 0];
    ];

%% main code

project2(desiredParcels,totalNumberOfParcels,pauseTime,rtde,vacuum);
rtde.movej(home);

%% TowerOfHanoi algorithm
function project2(desiredParcels, totalNumberOfParcels, pauseTime,rtde,vacuum)
move(desiredParcels,totalNumberOfParcels,pauseTime,rtde,vacuum);
end

% This is just an example function to show the functionality of the
% project2simulator
function move(desiredPosition,totalNumberOfParcels,pauseTime,rtde,vacuum)
global matrix
currentParcels=[[0 0 0 0 0 0];[0 0 0 0 0 0];[0 0 0 0 0 0];[0 0 0 0 0 0];];
for i =1:totalNumberOfParcels
    currentParcels(1,i)=i;
end
matrix = currentParcels;
from_box = 1;
n=totalNumberOfParcels;
while n~=-1
    for i=1:4
        for j=1:6
            if desiredPosition(i,j)==n && i~=from_box
                key_box = i;
                list_box = [1,2,3,4];
                list_box(list_box==key_box) = [];
                list_box(list_box==from_box) = [];
                TowerOfHanoi(n,from_box,key_box,list_box(1),pauseTime,rtde,matrix,vacuum);
                n=n-1;
                from_box=key_box;
            end
            if desiredPosition(i,j)==n && i==from_box
                n=n-1;
            end
        end
    end
end

end

function matrix = TowerOfHanoi(n,from_rod,to_rod,aux_rod,pauseTime,rtde,matrix,vacuum)
if n==0
    return;
end
TowerOfHanoi(n - 1,from_rod,aux_rod,to_rod,pauseTime,rtde,matrix,vacuum);
% disp(from_rod)
% disp(to_rod)
% disp(pauseTime)
matrix = gripper_release(from_rod,to_rod,pauseTime,rtde,matrix,vacuum);
TowerOfHanoi(n-1,aux_rod,to_rod,from_rod,pauseTime,rtde,matrix,vacuum);
end

%% real robot control function
function matrix = gripper_release(from_Box,to_Box,pauseTime,rtde,matrix,vacuum)
    global poses matrix
    % Calling the constructor of vacuum to setup tcp connction
    % vacuum = vacuum(host,vacuumport)
    
    Box1_1 = [-700, -100, 3, 2.2214, -2.2214, 0.00];
    Box2_1 = [-500, -100, 3, 2.2214, -2.2214, 0.00];
    Box3_1 = [-700, -300, 3, 2.2214, -2.2214, 0.00];
    Box4_1 = [-500, -300, 3, 2.2214, -2.2214, 0.00];

    Box1_2 = [-700, -100, 6, 2.2214, -2.2214, 0.00];
    Box2_2 = [-500, -100, 6, 2.2214, -2.2214, 0.00];
    Box3_2 = [-700, -300, 6, 2.2214, -2.2214, 0.00];
    Box4_2 = [-500, -300, 6, 2.2214, -2.2214, 0.00];

    Box1_3 = [-700, -100, 9, 2.2214, -2.2214, 0.00];
    Box2_3 = [-500, -100, 9, 2.2214, -2.2214, 0.00];
    Box3_3 = [-700, -300, 9, 2.2214, -2.2214, 0.00];
    Box4_3 = [-500, -300, 9, 2.2214, -2.2214, 0.00];

    Box1_4 = [-700, -100, 12, 2.2214, -2.2214, 0.00];
    Box2_4 = [-500, -100, 12, 2.2214, -2.2214, 0.00];
    Box3_4 = [-700, -300, 12, 2.2214, -2.2214, 0.00];
    Box4_4 = [-500, -300, 12, 2.2214, -2.2214, 0.00];

    Box1_5 = [-700, -100, 15, 2.2214, -2.2214, 0.00];
    Box2_5 = [-500, -100, 15, 2.2214, -2.2214, 0.00];
    Box3_5 = [-700, -300, 15, 2.2214, -2.2214, 0.00];
    Box4_5 = [-500, -300, 15, 2.2214, -2.2214, 0.00];

    centre = [-600, -200, 50, 2.2214, -2.2214, 0.00];

    position = [Box1_1;Box2_1;Box3_1;Box4_1;
                Box1_2;Box2_2;Box3_2;Box4_2;
                Box1_3;Box2_3;Box3_3;Box4_3;
                Box1_4;Box2_4;Box3_4;Box4_4;
                Box1_5;Box2_5;Box3_5;Box4_5;];
    from_Box_high = high_detect(matrix,from_Box);
    to_Box_high = high_detect(matrix,to_Box);

    drop =   [-588.53, -233.30, 400, 2.2214, -2.2214, 0.00];
    a = 1.0;
    v = 0.1;
    r = 0;
    t = 0;

    position_a = position(from_Box+4*(from_Box_high-1),:);
    position_b = position(to_Box+8,:);
    position_c = (position_b+position_a)/2;
    position_c(3)=15;
%     disp(position_c);
    
    rtde.movej(position_a);

%   Turn on vacuum gripper
    vacuum.grip()
    rtde.movec(position_c,position_b);
%     rtde.movej(position(to_Box,:));
%   Release Vacuum gripper
    vacuum.release()
    pause(pauseTime)



    matrix = revise_matrix(from_Box,to_Box,matrix);
    disp(matrix);
end

function num = high_detect(matrix,box)
    num = 0;
    for i=1:6
        if matrix(box,i)~=0
            num=num+1;
        end
    end
end 

function matrix = revise_matrix(from_box,to_box,matrix)
    global matrix
    for j=6:-1:2
        matrix(to_box,j)=matrix(to_box,j-1);
    end
    matrix(to_box,1)= matrix(from_box,1);
    for i=1:5
        matrix(from_box,i)=matrix(from_box,i+1);
    end
end
    










