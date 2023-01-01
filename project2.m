% DO NOT CHANGE THE FILE NAME OR IT WILL NOT WORK DURING TESTING
% Author: Sinuo Zhao
% zid: z5375442
% Date: 2022/08/13
% final vision

% DO NOT CHANGE THE FUNCTION DEFINITION. OR IT WILL FAIL THE TESTS
% You are welcome to call other functions from this main function.
function sim = project2(desiredPosition, totalNumberOfParcesl, pauseTime)
    % This line needs to be the very first line. Do not remove it.
    sim = project2simulator(totalNumberOfParcesl,pauseTime);
    
    % prepare for initial currentParcels
    currentParcels=[[0 0 0 0 0 0];[0 0 0 0 0 0];[0 0 0 0 0 0];[0 0 0 0 0 0];];
    for i =1:totalNumberOfParcesl
        currentParcels(1,i)=totalNumberOfParcesl-i;
    end
    
    % call the function (New_Hanoi, trace_revise) get the final trace
    trace = trace_revise(New_Hanoi(desiredPosition,totalNumberOfParcesl));
    % do the pickup and putdown action
    for i= length(trace):-1:1
        sim.pickup(trace(i,2))
        sim.putdown(trace(i,1))
    end
end

% get the box position for parcel
function a = get_parcel_idx(parcel,desiredParcels,totalNumberOfParcesl)
    for i = 1:4
        for j = 1:totalNumberOfParcesl
            if (desiredParcels(i,j)==parcel)
                a=i;
                return;
            end
        end
    end
end

% main function get the total trace
function trace = New_Hanoi(desiredParcels, totalNumberOfParcesl)
% set the initial trace and height
trace = [];
height = [0 0 0 0];
% get the Parcels number for each box
for i = 1:4
        for j = 1:totalNumberOfParcesl
            if (desiredParcels(i,j)==0)
                break;
            end
            height(i)=height(i)+1;
        end
end
% desiredParcels transform
for i = 1:4
for j=1:ceil(height(i)/2)
temp = desiredParcels(i,j);
desiredParcels(i,j)=desiredParcels(i,height(i)-j+1);
desiredParcels(i,height(i)-j+1) = temp;
end
end

current_Parcel = totalNumberOfParcesl;
while (current_Parcel>0)
    idx = get_parcel_idx(current_Parcel,desiredParcels,totalNumberOfParcesl);
    while (height(idx)>1)
        left = idx - 1;
        right = idx + 1;
        if (left<2)
            left = 4;
        end
        if (right>4)
            right = 2;
        end
        height(idx)=height(idx)-1;
        % 
        if (height(left)==0)
            desiredParcels(left,1) = desiredParcels(idx,height(idx)+1);
            trace=[trace;[idx left]];
            desiredParcels(idx,height(idx)+1)=0;
            height(left)=height(left)+1;
        elseif (height(right)==0)
            desiredParcels(right,1) = desiredParcels(idx,height(idx)+1);
            trace=[trace;[idx right]];
            desiredParcels(idx,height(idx)+1)=0;
            height(right)=height(right)+1;
        else
            can_left = desiredParcels(idx,height(idx)+1)<desiredParcels(left,height(left));
            can_right = desiredParcels(idx,height(idx)+1)<desiredParcels(right,height(right));
            if (can_left && ~can_right)
                desiredParcels(left,height(left)+1) = desiredParcels(idx,height(idx)+1);
                trace=[trace;[idx left]];
                desiredParcels(idx,height(idx)+1)=0;
                height(left)=height(left)+1;
            elseif(~can_left && can_right)
                desiredParcels(right,height(right)+1) = desiredParcels(idx,height(idx)+1);
                trace=[trace;[idx right]];
                desiredParcels(idx,height(idx)+1)=0;
                height(right)=height(right)+1;
            elseif(can_left && can_right)
                if desiredParcels(right,1)<desiredParcels(left,1)
                    desiredParcels(right,height(right)+1) = desiredParcels(idx,height(idx)+1);
                    trace=[trace;[idx right]];
                    desiredParcels(idx,height(idx)+1) = 0;
                    height(right)=height(right)+1;
                else
                    desiredParcels(left,height(left)+1) = desiredParcels(idx,height(idx)+1);
                    trace=[trace;[idx left]];
                    desiredParcels(idx,height(idx)+1) = 0;
                    height(left)=height(left)+1;
                end
            else
                if (height(left)==1)
                    if (desiredParcels(left,height(left))<desiredParcels(right,height(right)))
                        desiredParcels(right,height(right)+1) = desiredParcels(left,height(left));
                        trace=[trace;[left right]];
                        height(right)=height(right)+1;
                        
                        desiredParcels(left,height(left)) = desiredParcels(idx,height(idx)+1);
                        trace=[trace;[idx left]];
                        desiredParcels(idx,height(idx)+1) = 0;

                    else
                        trace=[trace;[left 1]];
                        trace=[trace;[idx left]];
                        trace=[trace;[1 left]];
                        desiredParcels(left,height(left)+1) = desiredParcels(left,height(left));
                        desiredParcels(left,height(left)) = desiredParcels(idx,height(idx)+1);
                        desiredParcels(idx,height(idx)+1) = 0;
                        height(left)=height(left)+1;
                    end
                elseif(height(right)==1)
                    if (desiredParcels(right,height(right))<desiredParcels(left,height(left)))
                        desiredParcels(left,height(left)+1) = desiredParcels(right,height(right));
                        height(left)=height(left)+1;
                        trace=[trace;[right left]];
                        desiredParcels(right,height(right)) = desiredParcels(idx,height(idx)+1);
                        trace=[trace;[idx right]];
                        desiredParcels(idx,height(idx)+1) = 0;

                    else
                        trace=[trace;[right 1]];
                        trace=[trace;[idx right]];
                        trace=[trace;[1 right]];
                        desiredParcels(right,height(right)+1) = desiredParcels(right,height(right));
                        desiredParcels(right,height(right)) = desiredParcels(idx,height(idx)+1);
                        desiredParcels(idx,height(idx)+1) = 0;
                        height(right)=height(right)+1;
                    end
                else
                    disp('No solution');
                end
            end
        end
    end

height(idx) = 0;
desiredParcels(idx,1)=0;
desiredParcels(1,height(1)+1)=current_Parcel;
trace=[trace;[idx 1]];
height(1) = height(1)+1;
current_Parcel = current_Parcel-1;
end
end


function trace = trace_revise(trace)
i = 1;
while i<length(trace)-1
    if (trace(i,2) ==trace(i+1,1))
        trace(i+1,1)=trace(i,1);
        trace(i,:)=[];
        % need to revise
    end
    i = i+1;

end
end
