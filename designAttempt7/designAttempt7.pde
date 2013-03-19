import processing.opengl.*;

import com.shigeodayo.ardrone.manager.*;
import com.shigeodayo.ardrone.navdata.*;
import com.shigeodayo.ardrone.utils.*;
import com.shigeodayo.ardrone.processing.*;
import com.shigeodayo.ardrone.command.*;
import com.shigeodayo.ardrone.*;

ARDroneForP5 ardrone;

import SimpleOpenNI.*;
 
SimpleOpenNI  context;

int togDraw = 0;
int reset = 1;
float angle = 0;    //roll
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
PImage animation;
float battery = 0;
float hipHandz = 0;      //pitch
float yawHandZ = 0;
float rotYaw = 0;
float rotPitch = 0;
float rotRoll = 0;

int numFrames = 11;  // The number of frames in the animation
int frame = 0;
PImage[] images = new PImage[numFrames];

int numFramesCube = 4;
int frameCube = 0;
PImage[] cubeimages = new PImage[numFramesCube];
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
  animation = loadImage("1357086152224.gif");
  cubeimages[0] = loadImage("2cubefaceAni0.png");
  cubeimages[1] = loadImage("2cubefaceAni1.png");
  cubeimages[2] = loadImage("2cubefaceAni2.png");
  cubeimages[3] = loadImage("2cubefaceAni3.png");
//  cubeimages[4] = loadImage("cubefaceAni4.png");

  
  
    images[0]  = loadImage("PT_anim0000.png");
  images[1]  = loadImage("PT_anim0001.png"); 
  images[2]  = loadImage("PT_anim0002.png");
  images[3]  = loadImage("PT_anim0003.png"); 
  images[4]  = loadImage("PT_anim0004.png");
  images[5]  = loadImage("PT_anim0005.png"); 
  images[6]  = loadImage("PT_anim0006.png");
  images[7]  = loadImage("PT_anim0007.png"); 
  images[8]  = loadImage("PT_anim0008.png");
  images[9]  = loadImage("PT_anim0009.png"); 
  images[10] = loadImage("PT_anim0010.png");
  //images[11] = loadImage("PT_anim0011.gif"); 
  
  
  textureMode(NORMAL);
  
  ardrone=new ARDroneForP5("192.168.1.1");
  //AR.Droneに接続，操縦するために必要
  ardrone.connect();
  //AR.Droneからのセンサ情報を取得するために必要
  ardrone.connectNav();
  //AR.Droneからの画像情報を取得するために必要
  ardrone.connectVideo();
  //これを宣言すると上でconnectした3つが使えるようになる．
  ardrone.start();

 
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
      fill(0, 0, 0, 255);
      text("roll: " + (int)(angle),450,16);  
      text("pitch: " + (int)(hipHandz),450,32);    
      text("yaw: " + (int)(yawHandZ),450,48);       
      text("height: " + (int)(dy),450,64);  

  }
       
    }

 text("FPS: " + (int)frameRate,450,80); 



rot = rot + .005;
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
  PVector jointPosLeftHip = new PVector();
  PVector jointPosRightHip = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,jointPosLeftHip);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,jointPosRightHip);
 
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
     ardrone.takeOff();
   }else if (togDraw == 1 && reset == 1)
   {
     togDraw = 0;
     reset = 0;
     ardrone.landing();
    

   }

    
  }
  if (keyPressed) {
  if (key == 'l'){

      context.stopTrackingSkeleton(userId); 
      context.startPoseDetection("Psi",userId);
  }
  if (key == 'P'){
    //kill command
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
 
    hipHandz =  (((jointPosLeftHip.z - jointPos_Proj.z) - 250)+((jointPosRightHip.z - jointPos_Proj2.z) - 250))/2;
    hipHandz = (hipHandz/700)*90;
  


////////yaw

  yawHandZ = jointPos_Proj.z - jointPos_Proj2.z;
  
  yawHandZ = (yawHandZ/700)*90;
 pushMatrix();
 float midX = (jointPos_Proj.x + jointPos_Proj2.x)/2;
 float midY = (jointPos_Proj.y + jointPos_Proj2.y)/2;
 float midZ = (jointPos_Proj.z + jointPos_Proj2.z)/2;

   translate(midX,midY, 100); 
rotateY(radians(-yawHandZ*.7));        

rotateZ(radians(-angle));


  rotateX(radians(hipHandz));       // not sure if it should be inverted
  
  
  
  dy = dy+150;
  dy = (dy/400)*90;
  if (dy > 90)
 {
  dy = 90;
 } 
 if (dy < -90)
 {
  dy = -90; 
 }
  println(dy);

drawDrone();

popMatrix();


// This is where the Ardrone instructions will go. -FC

// all are -90 to +90 (approx)
// dy = height
// yawHandZ = yaw
// hipHandz = forward (and back)
// angle = move left (and right)

ARmoveDown = s(0 - dy) //fix direction
ARmoveLeft = s(angle) //temp set to zero
ARturnLeft = 0 //temp set to zero
ARmoveForward = s(hipHandz)

// Scales based on 90 deg = 10 
function s(angle) {
  return angle / 9;
}

if (togDraw == 1) {
    ardrone.move3D(ARmoveForward, ARmoveLeft, ARmoveDown, ARturnLeft);
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
     tint(255,255);        
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
  
                      beginShape(QUADS); // bottom
                      
                      frame = (frame+1) % numFrames;
                      tint(255, 126);
  texture(images[frame]);
  translate(-len/7, 0, -100);
    vertex(halfwidth,0, zDepth, 320, 0);
  vertex(halfwidth, 0,  0, 320, 240);
    vertex(halfwidth+(2*len)/7, 0, 0, 0,  240);
  vertex(halfwidth+(2*len)/7,0, zDepth, 0, 0);
    endShape();
    
     for(int i = 0; i < 2; i++)
  {
   
    
  
  if (i ==  1)
  {
    translate(0, 0, zDepth);
  }
  pushMatrix();
  rotateX(rot*10);
    tint(255, 255);
                      beginShape(QUADS); 
  texture(topTex);
    vertex(0,-halfwidth, halfwidth, 0, 0);
  vertex(0, -halfwidth,  -halfwidth, 0, 900);
  vertex(0, halfwidth,  -halfwidth, 300, 900);
  vertex(0, halfwidth,  halfwidth, 300, 0);
    endShape();
                          beginShape(QUADS); 
  texture(topTex);
    vertex(len/7,-halfwidth, halfwidth, 0, 0);
  vertex(len/7, -halfwidth,  -halfwidth, 0, 900);
  vertex(len/7, halfwidth,  -halfwidth, 300, 900);
  vertex(len/7, halfwidth,  halfwidth, 300, 0);
    endShape();
                              beginShape(QUADS); 
  texture(topTex);
    vertex((len*2)/7,-halfwidth, halfwidth, 0, 0);
  vertex((len*2)/7, -halfwidth,  -halfwidth, 0, 900);
  vertex(0, -halfwidth,  -halfwidth, 300, 900);
  vertex(0, -halfwidth,  halfwidth, 300, 0);
    endShape();
                                  beginShape(QUADS); 
  texture(topTex);
    vertex((len*2)/7,-halfwidth, -halfwidth, 0, 0);
  vertex((len*2)/7, halfwidth,  -halfwidth, 0, 900);
  vertex(0, halfwidth,  -halfwidth, 300, 900);
  vertex(0, -halfwidth,  -halfwidth, 300, 0);
    endShape();
    popMatrix();
  }
  
      popMatrix();
    translate(0,-10,-50);
      
  
  
    for(int i = 0; i < 4; i++)
  {
    
fill(95, 158, 160, 100);
    
            if (i ==  0)
  {
    translate(-45, 0, 0);
    
  }
      
            if (i ==  1)
  {
    translate(90, 0, 20);
    scale(.75);
  }
              if (i ==  2)
  {
    translate(-30, 0, -40);
    
  }
                if (i ==  3)
  {
    translate(-30, 0, 40);
    
  }
    cylinder(20, 10, 16);
    fill(255, 255, 255, 150);
    cylinder(5, 3, 16);
    fill(95, 158, 160, 50);
    pushMatrix();
    translate(0,-50,0);
    rotateX(-HALF_PI);
    
    cone(0, 0, 20, 50);

    popMatrix();
    pushMatrix();
    translate(0,-100,0);  //-65
    cylinder(20, 50, 16); 
    translate(0,20,0);
    battery++;
    if (battery == 100)
    {
      battery = 0;
    }
    rotYaw = rotYaw + (yawHandZ/240);

    rotPitch = rotPitch + (hipHandz/240);
    rotRoll = rotRoll + (angle/240);

  //  stroke(255);
   
 
  if (i == 0)
  {
    
    
    drawControlCube();
  }
   if (i == 1)
  {
    
    
    drawBattery();
  }
    
    popMatrix();
    
  }
  }
  
 
}

void drawControlCube()
{
  pushMatrix();
      rotateY(rotYaw);

    rotateX(rotPitch);
    rotateY(rotRoll);
    fill(255, 0, 0);
  scale(20);
                           beginShape(QUADS); // bottom
                      
                      frameCube = (frameCube+1) % (numFramesCube*10);
           
  texture(cubeimages[frameCube/10]);

  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
    endShape();
    popMatrix();
}

void drawBattery()
{
 pushMatrix();
 
 
 
 rotateY(rot);
 
 translate(0,10,0);
 rotateX(PI/8);
  translate(0,-10,0);
 float bHeight = 20;
 pushMatrix();
 fill(95, 158, 160, 255);
 translate(0, -5,0);
 cylinder(3, 5, 16);
 popMatrix();
 fill(95, 158, 160, 200);
 
 
int empty = (int)(20-(20*(battery/100)));
 
  cylinder(7, empty, 16);
  translate(0,empty,0);
   fill(255-((battery/100)*255),(battery/100)*255, 0, 150);
   int full = (int)(20*(battery/100));
  cylinder(7, full, 16);
  popMatrix();
   
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
 
  vertex(0,   0,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], 0, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], 0, z[i]);
    vertex(x[i], h, z[i]);
  }
 
  endShape();
 
  //draw the bottom of the cylinder
 // beginShape(TRIANGLE_FAN); 
 
//  vertex(0,   h/2,    0);
 
 // for(int i=0; i < x.length; i++){
  //  vertex(x[i], h/2, z[i]);
 // }
 
 // endShape();
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


