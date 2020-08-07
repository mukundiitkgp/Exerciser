# Exerciser
MATLAB and Python based human skeleton tracking application framework

Demo Links:

https://drive.google.com/open?id=1I3Wwzf0bY1UdXJdK6dUjT7tcLGmQFgDE

Instructions for Python Code (Real-time Skeleton Tracking):

1. Make sure you have the openpose-master folder downloaded in your system 

Clone it from here : https://github.com/CMU-Perceptual-Computing-Lab/openpose

OR

Download the folder 'openpose-master' from here : https://drive.google.com/drive/folders/12xc-wXMdHBcGAYDoa4XmUbC1GFzGdVpt?usp=sharing

2. In this downloaded folder, you need to make sure that you have the .prototxt files and .caffemodels at the following 3 folder locations. (Already taken care in the folder, if you have downloaded it from the above given Drive link)

Three folder locations:

  a. /..../openpose-master\models\pose\body_25 : in this, make sure you have "pose_deploy.prototxt"
  
  
  
  b. /..../openpose-master\models\pose\coco    : in this, make sure you have "pose_deploy_linevec.prototxt" and "pose_iter_440000.caffemodel"
  
  
  
  c. /..../openpose-master\models\pose\mpi     : in this, make sure you have "pose_deploy_linevec.prototxt", "pose_deploy_linevec_faster_4_stages.prototxt" and "pose_iter_160000.caffemodel"
  
  Changes to be made in the code:
  
  Line 8: protoFile = '............' : Here, you need to provide the location of .prototxt file of either coco or mpi (point b. or point c., as above)
  
  
  Line 9: weightsFile = '............' : Here, you need to provide the location of .caffemodel file of either coco or mpi corresponding to the one mentioned in Line 8 (point b. or point c., as above)
  
  
  You're done with the changes, you can run 'multi_openpose.py' now :)
