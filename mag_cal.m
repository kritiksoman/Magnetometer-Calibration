%% ********************Script to calibrate magnetometer**********************************

% Author : Kritik Soman
% Time of creation : 24 Nov 2016, 8:30pm
% The script calculates calibration parameters of a MEMS magnetometer by
% performing a spherical fit on the sensor data. The fitting parameters are
% displayed in the command window and a figure showing the calibration
% procedure is plotted.

%% **************************************************************************************

close all; clear all;

%% Read sensor data from all files

[accx,accy,accz,acct] = readSensData('data/data_acc.txt');
[magx,magy,magz,magt] = readSensData('data/data_mag.txt');
acc=struct('x',accx,'y',accy,'z',accz,'t',acct);
mag=struct('x',magx,'y',magy,'z',magz,'t',magt);
sensorData=struct('acc',acc,'mag',mag);% structure containing all sensor data
clearvars -except sensorData

%% Create plot window for output

t=(sensorData.mag.t-min(sensorData.mag.t))*1e-3;%convert time to seconds elapsed
figure('units','normalized','outerposition',[0 .25 1 0.6])%set figure at center of screen

subplot(1,3,1);
plot(sind(0:360),cosd(0:360),1.2*sind(0:360),1.2*cosd(0:360));%plot circle for rolling pebble
axis([-1.5 1.5 -1.5 1.5]);
grid on;
title('Pebble Rolling');
hold on;

subplot(1,3,2);
plot(t,sensorData.mag.x,'r.',t,sensorData.mag.y,'g.',t,sensorData.mag.z,'b.');% plot magnetometer data
legend('Mx','My','Mz');
grid on;
xlabel('Time (in sec.)');
ylabel('Magnetic Field (in uT)');
title('Uncalibrated Magnetometer Data');
hold all;

%% Initialize variables

isCalibrated=0; %assume sensor is not calibrated initially
sensDataLength=length(sensorData.mag.t);
magCalBuff = emptyBuffer(constants.buffSize); %used for calibration

%% Traverse through data

for index=1:sensDataLength
    %% Attempt calibration
    
    if isCalibrated==0
        %% Mark read data in magnetometer data plot
        
        subplot(1,3,2);hold on;
        plot(t(index),sensorData.mag.x(index),'k.');
        plot(t(index),sensorData.mag.y(index),'k.');
        plot(t(index),sensorData.mag.z(index),'k.');
        
        %% Check if current data is suitable for use in calibration
        
        if magCalBuff.N==0
            magCalBuff.x(1)=sensorData.mag.x(index);
            magCalBuff.y(1)=sensorData.mag.y(index);
            magCalBuff.z(1)=sensorData.mag.z(index);
            magCalBuff.t(1)=sensorData.mag.t(index);
            magCalBuff.N = 1;
            
        else
            addToBuff=1;    % assume new mag data is different
            
            for k=1:magCalBuff.N
                dist=(magCalBuff.x(k)-sensorData.mag.x(index))^2+(magCalBuff.y(k)-sensorData.mag.y(index))^2+(magCalBuff.z(k)-sensorData.mag.z(index))^2;
                
                if dist<constants.minDev  % if new data is not far enough from old data, it is not suitable
                    addToBuff=0;break;% no need to add to buffer
                end
                
            end
            
            if addToBuff==1 % Add data to buffer when suitable for calibration
               
                if magCalBuff.N<=magCalBuff.Nmax
                    magCalBuff.N=magCalBuff.N+1;
                    pos=magCalBuff.N;
                    magCalBuff.x(pos)=sensorData.mag.x(index);
                    magCalBuff.y(pos)=sensorData.mag.y(index);
                    magCalBuff.z(pos)=sensorData.mag.z(index);
                    magCalBuff.t(pos)=sensorData.mag.t(index);
                end
                
            end
            
        end
        
        %% Try calibration
        
        if magCalBuff.N>constants.minCalLen
            N=magCalBuff.N;
            maxX=max(magCalBuff.x(1:N));
            minX=min(magCalBuff.x(1:N));
            maxY=max(magCalBuff.y(1:N));
            minY=min(magCalBuff.y(1:N));
            maxZ=max(magCalBuff.z(1:N));
            minZ=min(magCalBuff.z(1:N));
            deltaX=maxX-minX;
            deltaY=maxY-minY;
            deltaZ=maxZ-minZ;
            
            if ((deltaX>constants.minDelta && deltaX<constants.maxDelta && ...
                    deltaY>constants.minDelta && deltaY<constants.maxDelta && ...
                    deltaZ>constants.minDelta && deltaZ<constants.maxDelta))
                
                X=[magCalBuff.x(1:N)' magCalBuff.y(1:N)' magCalBuff.z(1:N)'];
                [center, radius ,residue]=sphereFit(X(:,1),X(:,2),X(:,3));
                
                %% If fitting is good, display results
                
                if (radius>=constants.minRadius && radius<=constants.maxRadius && residue <constants.maxResidue)
                    isCalibrated=1;
                    disp('---- Magnetometer Calibration ----');
                    disp(['Calibration completed at ' num2str(t(index)) ' sec']);
                    disp('Center (in uT) ');disp(center);
                    disp(['Residue (in uT) ' num2str(residue)]);
                    disp(['Radius (in uT) ' num2str(radius)]);
                    disp('----------------------------------');
                    
                    %% Plot results
                    subplot(1,3,3);
                    [px,py,pz] = sphere;% unit radius sphere
                    m=mesh(radius*px+center(1), radius*py+center(2), radius*pz+center(3));
                    set(m,'facecolor','none');% plot the sphere
                    hold on;
                    plot3(X(:,1),X(:,2),X(:,3),'-*')% plot points used for fitting
                    grid on;title('Calibration Completed');
                    xlabel('Mx (in uT)');
                    ylabel('My (in uT)');
                    zlabel('Mz (in uT)');
                    view(-200, 10);
                    plot3(center(1),center(2),center(3),'ks','markerfacecolor',[0 0 0]);% mark center of sphere
                    centerDisp=round(center);
                    text(center(1)-5,center(2)-5,center(3)-5,['(',num2str(centerDisp(1)),',',num2str(centerDisp(2)),',',num2str(centerDisp(3)),')']);
                    hold off;
                    
                else
                    
                    disp(['Calibration failed at ' num2str(t(index)) ' sec']);
                    
                end
            end
        end
        
        %% Find intensity of movement
        
        angle=atan2d(sensorData.acc.y(index),sensorData.acc.x(index));
        z=min(1.25,abs(sensorData.acc.z(index)/9.8));
        z=1.25-z;
        %% Display intensity of movement in pebble plot
        
        angle=round(angle/5)*5;% round off the rotation along z axis to nearest 5 deg.
        subplot(1,3,1);
        if(z>.45)   % if tilt along z axis is high enough, also plot red marker line.
            x=1.2*cosd(angle);
            y=1.2*sind(angle);
            line([x 1.1*x/1.2], [y 1.1*y/1.2],'Color','r','LineWidth',2);hold on;
        end
        x=1*cosd(angle);
        y=1*sind(angle);
        line([x 1.1*x], [y 1.1*y],'Color','b','LineWidth',2);
        pause(0.05);% Intentional delay introduced so that process can be visualized 
    end
end