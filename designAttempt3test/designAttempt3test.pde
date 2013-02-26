import processing.opengl.*;



import SimpleOpenNI.*;
 
SimpleOpenNI  context;
int togDraw = 0;
int reset = 1;
float angle = 0;
String heightString = "";
String angleString = "";
float dy = 0;
//cube = new Cube(this);
float rot = 0;
PGraphics pg;
PImage img;
float len = 0;
PImage topTex;
PImage sideTex;
PImage lengthTex;
PImage bottomTex;
void setup()
{
  // instantiate a new context
  size(640, 480, P3D); 
  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
 
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
  topTex = loadImage("testtexture.png");
  sideTex = loadImage("sidetexture.png");
  lengthTex = loadImage("lengthtexture.png");
  bottomTex = loadImage("bottomtexture.png");
  textureMode(NORMAL);

 
  // create a window the size of the depth information
// size(context.depthWidth() + context.rgbWidth() + 10, context.rgbHeight(), OPENGL); 
 

}
 
void draw()
{
  // update the camera
  context.update();
 
  // draw depth image
 // image(context.depthImage(),context.depthWidth(),0); 

 //  image(context.rgbImage(),0,0);
   img = context.rgbImage();
   background(img);
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

 text("FPS: " + (int)frameRate,450,80); 

// pushMatrix();
//   translate(250,300, 100); 
//rotateY(rot);
//rotateZ(rot);
//noFill();
//box(40);
//popMatrix();

rot = rot + .005;
  }
//  fill(192);
//  rect(20, 20, 40, 40);
//  translate(60, 80);
//  rotateZ(30);
//  translate(130, height/2, 0);
//pushMatrix();
//translate(130, height/2, 0);
//rotateY(1.25);
//rotateX(-0.4);
//noStroke();
//box(100);
//translate(60, 80);
//popMatrix();

//pushMatrix();
//translate(500, height*0.35, -200);
//noFill();
//stroke(255);
//sphere(280);
//popMatrix();
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
  
  len = sqrt((dx*dx)+(dy*dy)+(dz*dz));

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

  // print ("y");
   angle =(dy/len)*90; 
    
  
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
//  ellipse(jointPos_Proj.x,jointPos_Proj.y, distanceScalar*headsize,distanceScalar*headsize);  
 
//  ellipse(jointPos_Proj2.x,jointPos_Proj2.y, distanceScalar*headsize,distanceScalar*headsize); 
  PVector jointPosLeftHip = new PVector();
  PVector jointPosRightHip = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,jointPosLeftHip);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,jointPosRightHip);
 
   float hipHandz =  (((jointPosLeftHip.z - jointPos_Proj.z) - 250)+((jointPosRightHip.z - jointPos_Proj2.z) - 250))/2;
    hipHandz = (hipHandz/700)*90;
  


////////yaw

 float yawHandZ = jointPos_Proj.z - jointPos_Proj2.z;
  println(yawHandZ);
  yawHandZ = (yawHandZ/600)*90;
 pushMatrix();
 float midX = (jointPos_Proj.x + jointPos_Proj2.x)/2;
 float midY = (jointPos_Proj.y + jointPos_Proj2.y)/2;
 float midZ = (jointPos_Proj.z + jointPos_Proj2.z)/2;

   translate(midX,midY, 100); 
rotateY(radians(-yawHandZ*.7));        

rotateZ(radians(-angle));


 // println(radians(hipHandz));
  rotateX(radians(hipHandz));       // not sure if it should be inverted


//noFill();
//noStroke();
//TexturedCube(topTex);
//shape1();

drawDrone();
//box(len/5, 5, 100);

popMatrix();
// pushMatrix();
//translate(jointPos_Proj2.x,jointPos_Proj2.y, 200); 
//rotateY(-rot);
//rotateZ(-rot);
//box(30);
//popMatrix();
}
 
// draw the skeleton with the selected joints
void drawDrone() {
  int halfwidth = 3;
    float xLength = len/7;
  float zDepth = 100;
   pushMatrix();
   translate(-len/7, 0, -100);
  for(int i = 0; i < 2; i++)
  {
   
    
  
  if (i ==  1)
  {
    translate((2*len)/7, 0, 0);
  }

  
  fill(95, 158, 160);
  
 rotateX(-rot); 
 box (15);
 rotateX(rot); 
 
 pushMatrix();
 translate(0, 0, 100);
 rotateY(-rot);
 box (15);
    popMatrix();
    pushMatrix();
    rotateZ(rot*10);
    noStroke();
             beginShape(QUADS); // back
             
  texture(topTex);
    vertex(halfwidth,halfwidth, 0, 0, 0);
  vertex(halfwidth, -halfwidth,  0, 0, 900);
  vertex(-halfwidth, -halfwidth,  0, 300, 900);
  vertex(-halfwidth, halfwidth,  0, 300, 0);
    endShape();
          beginShape(QUADS); // front
  texture(topTex);
    vertex(halfwidth,halfwidth, zDepth, 0, 0);
  vertex(halfwidth, -halfwidth,  zDepth, 0, 900);
  vertex(-halfwidth, -halfwidth,  zDepth, 300, 900);
  vertex(-halfwidth, halfwidth,  zDepth, 300, 0);
    endShape();
              beginShape(QUADS); // bottom
  texture(topTex);
    vertex(halfwidth,halfwidth, zDepth, 0, 0);
  vertex(halfwidth, -halfwidth,  zDepth, 0, 900);
  vertex(halfwidth, -halfwidth,  0, 300, 900);
  vertex(halfwidth, halfwidth,  0, 300, 0);
    endShape();
              beginShape(QUADS); // bottom
  texture(topTex);
    vertex(halfwidth,-halfwidth, zDepth, 0, 0);
  vertex(-halfwidth, -halfwidth,  zDepth, 0, 900);
  vertex(halfwidth, -halfwidth,  0, 300, 900);
  vertex(-halfwidth, -halfwidth,  0, 300, 0);
    endShape();
                  beginShape(QUADS); // bottom
  texture(topTex);
    vertex(-halfwidth,-halfwidth, zDepth, 0, 0);
  vertex(-halfwidth, halfwidth,  zDepth, 0, 900);
  vertex(-halfwidth, -halfwidth,  0, 300, 900);
  vertex(-halfwidth, halfwidth,  0, 300, 0);
    endShape();
                  beginShape(QUADS); // bottom
  texture(topTex);
    vertex(-halfwidth,-halfwidth, zDepth, 0, 0);
  vertex(halfwidth, halfwidth,  zDepth, 0, 900);
  vertex(-halfwidth, -halfwidth,  0, 300, 900);
  vertex(halfwidth, halfwidth,  0, 300, 0);
    endShape();
    
    popMatrix();
    
  }
  popMatrix();
  
  
  if (togDraw == 1)
  {
    pushMatrix();
    fill(95, 158, 160, 100);
                      beginShape(QUADS); // bottom
  translate(-len/7, 0, -100);
    vertex(halfwidth,0, zDepth);
  vertex(halfwidth, 0,  0);
    vertex(halfwidth+(2*len)/7, 0,  0);
  vertex(halfwidth+(2*len)/7,0, zDepth);
    endShape();
    
    popMatrix();
    translate(0,0,-50);
    
    cylinder(20, 10, 16);
    fill(255, 255, 255, 150);
    cylinder(5, 3, 16);
    fill(95, 158, 160, 100);
    pushMatrix();
    translate(0,-50,0);
    rotateX(-HALF_PI);
    
    cone(0, 0, 20, 50);
    popMatrix();
  }
  
  
 
}


static float unitConeX[];
static float unitConeY[];
static int coneDetail;
 
static {
  coneDetail(24);
}
 
// just inits the points of a circle, 
// if you're doing lots of cones the same size 
// then you'll want to cache height and radius too
static void coneDetail(int det) {
  coneDetail = det;
  unitConeX = new float[det+1];
  unitConeY = new float[det+1];
  for (int i = 0; i <= det; i++) {
    float a1 = TWO_PI * i / det;
    unitConeX[i] = (float)Math.cos(a1);
    unitConeY[i] = (float)Math.sin(a1);
  }
}
 
// places a cone with it's base centred at (x,y),
// beight h in positive z, radius r.
void cone(float x, float y, float r, float h) {
  pushMatrix();
  translate(x,y);
  scale(r,r);
  beginShape(TRIANGLES);
  for (int i = 0; i < coneDetail; i++) {
    vertex(unitConeX[i],unitConeY[i],0.0);
    vertex(unitConeX[i+1],unitConeY[i+1],0.0);
    vertex(0,0,h);
  }
  endShape();
  popMatrix();
}



void cylinder(float w, float h, int sides)
{
  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];
 
  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * w;
    z[i] = cos(angle) * w;
  }
 
  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN);
 
  vertex(0,   -h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x[i], h/2, z[i]);
  }
 
  endShape();
 
  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN); 
 
  vertex(0,   h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], h/2, z[i]);
  }
 
  endShape();
}



void shape1() {
  translate(-len/14, 0, -50);
  
  float xLength = len/7;
  float zDepth = 100;
  beginShape(QUADS); // bottom
  texture(topTex);
    vertex(0, 0, 0, 0, 0);
  vertex(xLength, 0,  0, 0, 900);
  vertex(xLength, 0,  zDepth, 300, 900);
  vertex(0, 0,  zDepth, 300, 0);
    endShape();
    
      beginShape(QUADS); // bottom
  texture(topTex);
    vertex(20, -20, 20, 0, 0);
  vertex(xLength-20, -20,  20, 0, 900);
  vertex(xLength-20, -20,  zDepth-20, 300, 900);
  vertex(20, -20,  zDepth-20, 300, 0);
    endShape();
    
      beginShape(QUADS);  // back
  texture(topTex);
    vertex(0, 0, 0, 0, 0);
  vertex(20, -20,  20, 0, 900);
  vertex(xLength-20, -20,  20, 300, 900);
  vertex(xLength, 0,  0, 300, 0);
      endShape();
      
            beginShape(QUADS);  // front
  texture(topTex);
    vertex(0, 0, zDepth, 0, 0);
  vertex(20, -20,  zDepth-20, 0, 900);
  vertex(xLength-20, -20,  zDepth-20, 300, 900);
  vertex(xLength, 0,  zDepth, 300, 0);
      endShape();
      
      
      beginShape(QUADS);  // left
  texture(topTex);
    vertex(0, 0, 0, 0, 0);
  vertex(20, -20,  20, 0, 900);
  vertex(20, -20,  zDepth-20, 300, 900);
  vertex(0, 0,  zDepth, 300, 0);
      endShape();
      
            beginShape(QUADS);  // right
  texture(topTex);
    vertex(xLength, 0, 0, 0, 0);
  vertex(xLength-20, -20,  20, 0, 900);
  vertex(xLength-20, -20,  zDepth-20, 300, 900);
  vertex(xLength, 0,  zDepth, 300, 0);
      endShape();







pushMatrix();
translate(xLength/2, -60, zDepth/2);

pushMatrix();
rotateX(rot*1);
rotateY(rot*2);
rotateZ(rot*3);
box(30);
popMatrix();


pushMatrix();
noFill();
stroke(148, 0, 211);
rotateX(-rot*1);
rotateY(-rot*2);
rotateZ(-rot*3);
box(50);
stroke(0, 0, 255);
popMatrix();
popMatrix();



fill(255, 0, 0);
pushMatrix();
translate(20, -30, 20);
rotateX(rot*5);
rotateY(rot*5);
box(15);
popMatrix();

pushMatrix();
translate(xLength-20, -30, 20);
rotateX(rot*5);
rotateY(rot*5);
box(15);
popMatrix();

pushMatrix();
translate(20, -30, zDepth-20);
rotateX(rot*5);
rotateY(rot*5);
box(15);
popMatrix();

pushMatrix();
translate(xLength-20, -30, zDepth-20);
rotateX(rot*5);
rotateY(rot*5);
box(15);
popMatrix();
}

void TexturedCube(PImage tex) {
 
  noStroke();
  
  float zCenter = 100/2;
  float xCenter = len/14;
  
  
  beginShape(QUADS);
  texture(topTex);
 
  vertex(-xCenter, 0,  -zCenter, 0, 0);
  vertex(xCenter, 0,  -zCenter, 0, 900);
  vertex(xCenter, 0,  +zCenter, 300, 900);
  vertex(-xCenter, 0,  +zCenter, 300, 0);
    endShape();
      beginShape(QUADS);
  texture(bottomTex);
 
  vertex(-xCenter, 5,  -zCenter, 0, 0);
  vertex(xCenter, 5,  -zCenter, 0, 900);
  vertex(xCenter, 5,  +zCenter, 300, 900);
  vertex(-xCenter, 5,  +zCenter, 300, 0);
    endShape();
    
   beginShape(QUADS);        // Z+
  texture(sideTex);
  
  vertex(-xCenter, 5,  -zCenter, 0, 0);
  vertex(-xCenter, 0,  -zCenter, 0, 100);
  vertex(xCenter, 0,  -zCenter, 900, 100);
  vertex(xCenter, 5,  -zCenter, 900, 0);
  //vertex(0, 0,  0, 300, 0);
  //vertex(len/7, 0,  0, 300, 900);
  //vertex(len/7, 0,  100, 600, 900);
  //vertex(0, 0,  100, 600, 0);
  
  endShape();
     beginShape(QUADS);        // Z-
  texture(sideTex);
  
  vertex(-xCenter, 5,  zCenter, 0, 0);
  vertex(-xCenter, 0,  zCenter, 0, 100);
  vertex(xCenter, 0,  zCenter, 900, 100);
  vertex(xCenter, 5,  zCenter, 900, 0);

  
  endShape();
  
       beginShape(QUADS);        // X+
  texture(lengthTex);
  
  vertex(-xCenter, 5,  zCenter, 0, 0);
  vertex(-xCenter, 0,  zCenter, 0, 100);
  vertex(-xCenter, 0,  -zCenter, 900, 100);
  vertex(-xCenter, 5,  -zCenter, 900, 0);

  
  endShape();
  
         beginShape(QUADS);        // X
  texture(lengthTex);
  
  vertex(xCenter, 5,  zCenter, 0, 0);
  vertex(xCenter, 0,  zCenter, 0, 100);
  vertex(xCenter, 0,  -zCenter, 900, 100);
  vertex(xCenter, 5,  -zCenter, 900, 0);

  
  endShape();
}
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
  
  
//context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_LEFT_HAND);  
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
