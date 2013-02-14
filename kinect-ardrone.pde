import SimpleOpenNI.*;
 
SimpleOpenNI  context;
int togDraw = 0;
int reset = 1;
float angle = 0;
String heightString = "";
String angleString = "";
float dy = 0;
void setup()
{
  // instantiate a new context
  context = new SimpleOpenNI(this);
 
  // enable depthMap generation 
  context.enableDepth();
  context.enableRGB();
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  context.setMirror(true);
  background(200,0,0);
  stroke(0,0,255);
  strokeWeight(3);
  smooth();
  PFont font = createFont("monaspace", 16);
  
 
  // create a window the size of the depth information
 size(context.depthWidth() + context.rgbWidth() + 10, context.rgbHeight()); 
}
 
void draw()
{
  // update the camera
  context.update();
 
  // draw depth image
  image(context.depthImage(),context.depthWidth(),0); 

   image(context.rgbImage(),0,0);
  // for all users from 1 to 10
  int i;
  for (i=1; i<=10; i++)
  {
    // check if the skeleton is being tracked
    if(context.isTrackingSkeleton(i))
    {
      // draw the skeleton
      drawSkeleton(i);  
 
      // draw a circle for a head 
      circleForAHead(i);
      angleThreshold();
//      handsTouch(i);
      handDist(i);
      if (togDraw == 0)
  {
      fill(255, 0, 0);
      text("Paused",250,150);  
  }
  else if (togDraw == 1)
  {
      fill(0, 255, 0);
      text("angle: " + (int)(angle),450,16);  
      text("height threshold: " + heightString,450,32);    
      text("average height: " + (int)(dy),450,48);       
      text("angle Threshold: " + angleString,450,64);  
  }
    }



    
  }

}

void angleThreshold()
{
    if (angle < -54)
  {
    angleString = "Sharp Right";
  }  
    if (angle < -18 && angle > -54)
  {
    angleString = "Right";
  }  
  if (angle > -18 && angle < 18)
  {
    angleString = "Level";
  }  
  if (angle > 18 && angle < 54)
  {
    angleString = "Left";
  }
    if (angle > 54)
  {
    angleString = "Sharp Left";
  }

}
// draws a circle at the position of the head
void handDist(int userId)
{
  PVector jointPosLeft = new PVector();
  PVector jointPosRight = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPosLeft);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPosRight);
 
  float dx = jointPosRight.x-jointPosLeft.x;
  float dy = jointPosRight.y-jointPosLeft.y;
  float dz = jointPosRight.z-jointPosLeft.z;
  
  float len = sqrt((dx*dx)+(dy*dy)+(dz*dz));

  if (len > 500)
  {
    reset = 1;
  }
  if (len < 300)
  {
//   print (len);
   println ("close");
   if (togDraw == 0 && reset == 1)
   {
     togDraw = 1;
     reset = 0;
   }else if (togDraw == 1 && reset == 1)
   {
     togDraw = 0;
     reset = 0;
   }

    
  }
  if (togDraw == 1)
  {
  // print ("y");
   angle =(dy/len)*90; 
    
  }
}

void handsTouch(int userId)
{
  PVector jointPosLeft = new PVector();
  PVector jointPosRight = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPosLeft);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointPosRight);
  int range = 100;
  if (abs(jointPosLeft.x - jointPosRight.x) < range && abs(jointPosLeft.y - jointPosRight.y) < range && abs(jointPosLeft.z - jointPosRight.z) < range)
  {

  }
  
  
}

void circleForAHead(int userId)
{
  // get 3D position of a joint
  PVector jointPos = new PVector();
  PVector jointPos2 = new PVector();
  PVector jointPos3 = new PVector();
  PVector jointPos4 = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPos);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointPos2);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos3); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointPos4); 
  //println(jointPos.x);
  //println(jointPos.y);
//  float dz = jointPos2.z-jointPos.z;    //shoulder - hand
  dy = ((jointPos.y-jointPos2.y)+(jointPos3.y-jointPos4.y))/2;     //hand-shoulder
//  float hy = sqrt((dy*dy)+(dz+dz));

//  float sine = dy/hy;
  if (dy < -250) 
  { 
    heightString = "bottom";
  }
    if (dy > -250 && dy < 250) 
  { 
    heightString = "middle";
  }
    if (dy > 250) 
  { 
    heightString = "top";
  }
//  println((jointPos.z-jointPos2.z)/(jointPos.y-jointPos2.y));
 
  // convert real world point to projective space
  PVector jointPos_Proj = new PVector(); 
  PVector jointPos_Proj2 = new PVector(); 
  context.convertRealWorldToProjective(jointPos,jointPos_Proj);    //left
  context.convertRealWorldToProjective(jointPos3,jointPos_Proj2);  //right
 
  // a 200 pixel diameter head
  float headsize = 200;
 
  // create a distance scalar related to the depth (z dimension)
  float distanceScalar = (525/jointPos_Proj.z);
 
  // set the fill colour to make the circle green
  fill(0,255,0); 
 
  // draw the circle at the position of the head with the head size scaled by the distance scalar
  ellipse(jointPos_Proj.x,jointPos_Proj.y, distanceScalar*headsize,distanceScalar*headsize);  
  ellipse(jointPos_Proj2.x,jointPos_Proj2.y, distanceScalar*headsize,distanceScalar*headsize); 
}
 
// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{  
  // draw limbs  
//  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 
//  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 
//  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 
//  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 
// context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 
 // context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
//  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT); 
if (togDraw == 1)
{
  
  
context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_LEFT_HAND);  
}
}
 
// Event-based Methods
 
// when a person ('user') enters the field of view
void onNewUser(int userId)
{
  println("New User Detected - userId: " + userId);
 
 // start pose detection
  context.startPoseDetection("Psi",userId);
}
 
// when a person ('user') leaves the field of view 
void onLostUser(int userId)
{
  println("User Lost - userId: " + userId);
}
 
// when a user begins a pose
void onStartPose(String pose,int userId)
{
  println("Start of Pose Detected  - userId: " + userId + ", pose: " + pose);
 
  // stop pose detection
  context.stopPoseDetection(userId); 
 
  // start attempting to calibrate the skeleton
  context.requestCalibrationSkeleton(userId, true); 
}
 
// when calibration begins
void onStartCalibration(int userId)
{
  println("Beginning Calibration - userId: " + userId);
}
 
// when calibaration ends - successfully or unsucessfully 
void onEndCalibration(int userId, boolean successfull)
{
  println("Calibration of userId: " + userId + ", successfull: " + successfull);
 
  if (successfull) 
  { 
    println("  User calibrated !!!");
 
    // begin skeleton tracking
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
 
    // Start pose detection
    context.startPoseDetection("Psi",userId);
  }
}
