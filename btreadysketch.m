clc;
close all;
clear all;
vid=videoinput('winvideo',1);preview(vid);
i=0;
[startup fs1]=wavread('C:\Users\Thinker\Desktop\startup.wav');
[instr fs2]=wavread('C:\Users\Thinker\Desktop\instruction.wav');
[closeeye fs3]=wavread('C:\Users\Thinker\Desktop\closeeye.wav');
[instr2 fs4]=wavread('C:\Users\Thinker\Desktop\instruction2.wav');
[hault fs5]=wavread('C:\Users\Thinker\Desktop\hault.wav');
player_startup=audioplayer(startup,fs1);
player_instr=audioplayer(instr,fs2);
player_closeeye=audioplayer(closeeye,fs3);
player_instr2=audioplayer(instr2,fs4);
player_hault=audioplayer(hault,fs5);
playblocking(player_startup);
pause(2)
playblocking(player_instr);
pause(2)
frame=getsnapshot(vid);
mulind=480/size(frame,1);
frame=imresize(frame,mulind);
frame=rgb2gray(frame);
frame=imadjust(frame);
frame=medfilt2(frame,[15 15]);
frame=histeq(frame);
[center radii]=imfindcircles(frame,[83 86],'ObjectPolarity','dark','Sensitivity',1);
maincenter=center(1,:);
radiistrong=radii(1);
fprintf('We have recorded succesfully the straighteye position !!!\n')
pause(5)
thresholdleft=28;
thresholdright=-13;
fprintf('we now will do startup program');
pause(2);
fprintf('we will record close eye position\n');
playblocking(player_closeeye);
pause(5)
closed=getsnapshot(vid);
closed=rgb2gray(closed);
closed=imadjust(closed);
averageclosed=mean(closed,2);
maxclosed=max(averageclosed);
pause(2)
fprintf('we will record open eye position\n');
playblocking(player_instr);;

open=getsnapshot(vid);
open=rgb2gray(open);
open=imadjust(open);
averageopen=mean(open,2);
maxopen=max(averageopen);
threshold=maxopen+(maxclosed-maxopen)/2;
blink=0;
fprintf('program begins');
playblocking(player_instr2);
while blink<25
    
    eye=getsnapshot(vid);
    eye=rgb2gray(eye);
    eye=imadjust(eye);
   
    averageeye=mean(eye,2);
    maxaverageeye=max(averageeye);
    
    if maxaverageeye<threshold;
        blink=blink;
    else
        
        blink=blink+1;
    end
    
    
end
fprintf('blinks are more than 8 the chair will start\n');
pause(2)
timerstop=0;






   
while timerstop<2
    
    frame=getsnapshot(vid);
    
    
    mulind=480/size(frame,1);
    frame=imresize(frame,mulind);
    
    frame=rgb2gray(frame);
    frame=imadjust(frame);
    eye=frame;
    averageeye=mean(eye,2);
    maxaverageeye=max(averageeye);
    if maxaverageeye>threshold
        timerstop=timerstop+1;
    end
    
    frame=medfilt2(frame,[15 15]);
    frame=histeq(frame);
    
    
    [center radii]=imfindcircles(frame,[83 86],'ObjectPolarity','dark','Sensitivity',1);
    currentcenter=center(1,:);radiistrong=radii(1);
    
    movement=currentcenter-maincenter;
    if movement(1,1)>thresholdleft
        fprintf('moving left \n');
        
    elseif movement(1,1)<thresholdright
        fprintf('moving right \n');
       
    else
        fprintf('movint forward \n');
    end
    
    pause(0.25)
    
end
playblocking(player_hault);
        
    
    
if timerstop>2
    fprintf('chair will stop now');
end

    

   