import SimpleOpenNI.*;

SkeletonKinect  kinect;


boolean visibleUser;
float textPosition;

// * Array of color (put as many color as you want)
color[] userClr = new color[]{
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};

color jointClr = color(0);

PVector com = new PVector();                                   
PVector com2d = new PVector();   

// * Start at the 0 value 
int randomColor = 0;
PFont f;

/*
// * Enable FullScreen 
 boolean sketchFullScreen() {
 return true;
 }
 */

void setup() {

  f = loadFont("AlteDIN1451.vlw");
  textFont(f);

  size(displayWidth, displayHeight, P3D);


  kinect = new SkeletonKinect(this);
  // * kinect.setMirror MUST BE BEFORE enableDepth and enableUser functions!!!
  kinect.setMirror(false);
  kinect.enableDepth();
  // * Turn on user tracking
  kinect.enableUser();

  // * Choose the x position you want to display the debbuging informations
  textPosition = width/1.5;

  smooth();
}

void draw() { 

  kinect.update();
  background(0);
  image(kinect.userImage(), 0, 0);
  // * Put detected users in an IntVector
  // draw the skeleton if it's available

  int[] userList = kinect.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    // * For every user, draw the skeleton
    if ( kinect.isTrackingSkeleton(userList[i])) {
      
      kinect.drawSkeleton(userList[i]);
      // * Set to false to turn off success tracking message   
      displaySuccess(true);

      // draw the center of mass
      if (kinect.getCoM(userList[i], com))
      {
        kinect.convertRealWorldToProjective(com, com2d);
        stroke(100, 255, 0);
        strokeWeight(1);
        beginShape(LINES);
        vertex(com2d.x, com2d.y - 5);
        vertex(com2d.x, com2d.y + 5);

        vertex(com2d.x - 5, com2d.y);
        vertex(com2d.x + 5, com2d.y);
        endShape();

        fill(0, 255, 100);
      }
    } else {      
      // * Set to false to turn off error tracking message
      displayError(true);
    }
  }

  // * Set to false to turn off the debugging informations
  displayInfo(true);
}
