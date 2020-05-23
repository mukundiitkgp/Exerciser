function VideoInGUI()

    function videoSrc = createVideoObject(videopath)
        videoSrc = vision.VideoFileReader(videopath,'ImageColorSpace', 'Intensity');   
    end

[hFig, hAxes] = createFigureAndAxes();
imaqreset;

%devices = imaqhwinfo;
%cam = char(devices.InstalledAdaptors());
%depthVid = videoinput(cam,2);
%colorVid = videoinput(cam,1);

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

start(depthVid);
start(colorVid);

SkeletonConnectionMap = [[1 2]; % Spine
                         [2 3];
                         [3 4];
                         [3 5]; %Left Hand
                         [5 6];
                         [6 7];
                         [7 8];
                         [3 9]; %Right Hand
                         [9 10];
                         [10 11];
                         [11 12];
                         [1 17]; % Right Leg
                         [17 18];
                         [18 19];
                         [19 20];
                         [1 13]; % Left Leg
                         [13 14];
                         [14 15];
                         [15 16]];
%
%insertButtons(hFig, hAxes);
insertButtons(hFig, hAxes, createVideoObject('e1.mkv'));
frame = step(createVideoObject('e1.mkv'));
%frame = getAndProcessFrame(createVideoObject('e1.mkv'), 0);
% Display input video frame on axis
showFrameOnAxis(hAxes.axis1, frame);
%showFrameOnAxis(hAxes.axis2, zeros(size(frame)+60,'uint8'));

    function FrameCall(~,~,videoSrc)
        insertButtons(hFig, hAxes, videoSrc);
    end


function [hFig, hAxes] = createFigureAndAxes()

        % Close figure opened by last run
        figTag = 'CVST_VideoOnAxis_9804532';
        close(findobj('tag',figTag));

        % Create new figure
        hFig = figure('numbertitle', 'off', ...
               'name', 'Exercizer', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'tag',figTag, ...
               'renderer','painters', ...
               'position',[100 140 1080 590],...
               'HandleVisibility','callback'); % hide the handle to prevent unintended modifications of our custom UI

        % Create axes and titles
        hAxes.axis1 = createPanelAxisTitle(hFig,[0.01 0.08 0.49 0.9],'Tutor Video'); % [X Y W H]
        hAxes.axis2 = createPanelAxisTitle(hFig,[0.495 0.08 0.49 0.9],'Kinect Video');
end

function hAxis = createPanelAxisTitle(hFig, pos, axisTitle)

        % Create panel
        hPanel = uipanel('parent',hFig,'Position',pos,'Units','Normalized');

        % Create axis
        hAxis = axes('position',[0 0 1 1],'Parent',hPanel);
        hAxis.XTick = [];
        hAxis.YTick = [];
        hAxis.XColor = [1 1 1];
        hAxis.YColor = [1 1 1];
        % Set video title using uicontrol. uicontrol is used so that text
        % can be positioned in the context of the figure, not the axis.
        titlePos = [pos(1)+0.005 0.95 0.09 0.02];
        uicontrol('style','text',...
            'String', axisTitle,...
            'Units','Normalized',...
            'Parent',hFig,'Position', titlePos,...
            'BackgroundColor',hFig.Color);
end
    
function insertButtons(hFig,hAxes,videoSrc)
                
        frame = step(videoSrc);
        showFrameOnAxis(hAxes.axis1, frame);
        
        %showFrameOnAxis(hAxes.axis2, zeros(size(frame)+60,'uint8'));
        % Play button with text Start/Pause/Continue
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Start',...
                'position',[10 10 75 25], 'tag','PBButton123','callback',...
                {@playCallback,videoSrc,hAxes});
            
       
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exercise 1',...
                'position',[90 10 75 25], 'tag','PBButton123','callback',...
                {@FrameCall,createVideoObject('e1.mkv')});
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exercise 2',...
            'position',[170 10 75 25], 'tag','PBButton123','callback',...
            {@FrameCall,createVideoObject('e2.mkv')});
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exercise 3',...
            'position',[250 10 75 25], 'tag','PBButton123','callback',...
            {@FrameCall,createVideoObject('e4.mkv')});
         uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exercise 4',...
            'position',[330 10 75 25], 'tag','PBButton123','callback',...
            {@FrameCall,createVideoObject('e6.mkv')});

        % Exit button with text Exit
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exit',...
                'position',[410 10 50 25],'callback', ...
                {@exitCallback,videoSrc,hFig});
        
end

function playCallback(hObject,~,videoSrc,hAxes)
       try
            % Check the status of play button
            isTextStart = strcmp(hObject.String,'Start');
            isTextCont  = strcmp(hObject.String,'Continue');
            if isTextStart
               % Two cases: (1) starting first time, or (2) restarting
               % Start from first frame
               if isDone(videoSrc)
                  reset(videoSrc);
               end
            end
            if (isTextStart || isTextCont)
                hObject.String = 'Pause';
            else
                hObject.String = 'Continue';
            end

            % Rotate input video frame and display original and rotated
            % frames on figure
            
            while strcmp(hObject.String, 'Pause') && ~isDone(videoSrc)
                % Get input video frame and rotated frame
                frame = step(videoSrc);
                % Display input video frame on axis
                showFrameOnAxis(hAxes.axis1, frame);
                
                
                trigger(depthVid);
                trigger(colorVid);
                [~,~,depthMetaData] = getdata(depthVid);
                [frameDataColor] = getdata(colorVid);
                image1 = frameDataColor(:, :, :, 1);
                image(image1, 'Parent',hAxes.axis2);
                %showFrameOnAxis(hAxes.axis2, image1);
                %image(image1, 'Parent',hAxes.axis2);

                %imshow(image,[0 4096]);


                if sum(depthMetaData.IsSkeletonTracked) > 0
                    jointIndices = depthMetaData.JointDepthIndices(:,:,depthMetaData.IsSkeletonTracked);
                    hold on;
                    %plot(skeletonJoints(:,1),skeletonJoints(:,2),'o');
                    %scatter(skeletonJoints(:,1),skeletonJoints(:,2),'y','filled');
                    skeleton = jointIndices;
                    for i = 1:19


                             X1 = [skeleton(SkeletonConnectionMap(i,1),1,1) skeleton(SkeletonConnectionMap(i,2),1,1)];
                             Y1 = [skeleton(SkeletonConnectionMap(i,1),2,1) skeleton(SkeletonConnectionMap(i,2),2,1)];
                             line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r','Parent',hAxes.axis2);

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

            % When video reaches the end of file, display "Start" on the
            % play button.
            if isDone(videoSrc)
               hObject.String = 'Start';
            end
       catch ME
           % Re-throw error message if it is not related to invalid handle
           if ~strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
               rethrow(ME);
           end
       end
end


function exitCallback(~,~,videoSrc,hFig)

        % Close the video file
        release(videoSrc);
        % Close the figure window
        close(hFig);
end

end