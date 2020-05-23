%colorVid = videoinput('kinect',1);
imaqreset;
depthVid = videoinput('kinect',2);
colorVid = videoinput('kinect',1);

depthSrc = getselectedsource(depthVid);
depthSrc.TrackingMode = 'Skeleton';
triggerconfig([colorVid depthVid],'manual');

%colorVid.FramesPerTrigger = 500;
colorVid.FramesPerTrigger = 1;
colorVid.TriggerRepeat = inf;
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;

%preview(colorVid);
%start([colorVid depthVid]);
%trigger([colorVid depthVid]);

viewer = vision.DeployableVideoPlayer();
start(depthVid);
start(colorVid);
himg = figure;

SkeletonConnectionMap = [ %Spine
                         [1 2];[2 3];[3 4]; 
                         %Left Hand
                         [3 5];[5 6];[6 7];[7 8]; 
                         %Right Hand
                         [3 9];[9 10];[10 11];[11 12]; 
                         % Right Leg
                         [1 17];[17 18];[18 19];[19 20]; 
                         % Left Leg
                         [1 13];[13 14];[14 15];[15 16]];

while ishandle(himg)
    trigger(depthVid);
    trigger(colorVid);
    [~,~,depthMetaData] = getdata(depthVid);
    [frameDataColor] = getdata(colorVid);
    image = frameDataColor(:, :, :, 1);
    imshow(image,[0 4096]);   


    if sum(depthMetaData.IsSkeletonTracked) > 0
        jointIndices = depthMetaData.JointDepthIndices(:,:,depthMetaData.IsSkeletonTracked);
        hold on;
        %plot(skeletonJoints(:,1),skeletonJoints(:,2),'o');
        %scatter(skeletonJoints(:,1),skeletonJoints(:,2),'y','filled');
        skeleton = jointIndices;
        for i = 1:19

              
                 X1 = [skeleton(SkeletonConnectionMap(i,1),1,1) skeleton(SkeletonConnectionMap(i,2),1,1)];
                 Y1 = [skeleton(SkeletonConnectionMap(i,1),2,1) skeleton(SkeletonConnectionMap(i,2),2,1)];
                 line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
             
             %if nSkeleton > 1
             %    X2 = [skeleton(SkeletonConnectionMap(i,1),1,2) skeleton(SkeletonConnectionMap(i,2),1,2)];
              %   Y2 = [skeleton(SkeletonConnectionMap(i,1),2,2) skeleton(SkeletonConnectionMap(i,2),2,2)];     
                 % line(X2,Y2, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
             %end
            hold on;
        end
        hold off;
    end
end
stop(depthVid);

