/* *-*-*-*-*-* DEBUGGING INFORMATIONS *-*-*-*-*-* 
 
 * Display all informations you need in order to try and debug your code
 
 */


float deg;

boolean rgb = false;
boolean colorDepth = false;
boolean mirror = false;
boolean bg=false;
boolean bgRGB=false;

PImage depthImage, rgbImage, result;

void removeBackgroundRGB()
{
  
  kinect.alternativeViewPointDepthToImage();
  int [] userMap;
  kinect.enableRGB();

  rgbImage = kinect.rgbImage();

  result = createImage(rgbImage.width, rgbImage.height, RGB);
  // load the pixel array of the result image
  result.loadPixels();

  int[] userList = kinect.getUsers();
  if (userList.length>0)
  {
    userMap = kinect.userMap();
    // load sketches pixels
    loadPixels();
    for (int i=0; i<userMap.length; i++)
    {
      if (userMap[i]!=0)
      {
        // set the sketch pixel to the color pixel
        result.pixels[i] = rgbImage.pixels[i];
      } else
      {
        result.pixels[i] = color(0);
      }
    }
    // update
    result.updatePixels();
    //display the result
    image(result, 0, 0);
  }
}

void removeBackground()
{
  int [] userMap;
  depthImage = kinect.depthImage();

  result = createImage(depthImage.width, depthImage.height, RGB);
  // load the pixel array of the result image
  result.loadPixels();

  int[] userList = kinect.getUsers();
  if (userList.length>0)
  {
    userMap = kinect.userMap();
    // load sketches pixels
    loadPixels();
    for (int i=0; i<userMap.length; i++)
    {
      if (userMap[i]!=0)
      {
        // set the sketch pixel to the color pixel
        result.pixels[i] = depthImage.pixels[i];
      } else
      {
        result.pixels[i] = color(0);
      }
    }
    // update
    result.updatePixels();
    //display the result
    image(result, 0, 0);
  }
}
void getColorDepth()
{
  
  depthImage = kinect.depthImage();

  // get the depthMap (mm) values
  int[] depthVals = kinect.depthMap();

  result = createImage(depthImage.width, depthImage.height, RGB);

  // load the pixel array of the result image
  result.loadPixels();


  //go through the matrix - for each row go through every column
  for (int y=0; y<depthImage.height; y++)
  {
    //go through each col
    for (int x =0; x<depthImage.width; x++)
    {
      // get the location in the depthVals array
      int loc = x+(y*depthImage.width);
      // if the depth values of the sampled image are in range
      if (depthVals[loc] > 1 && depthVals[loc]< 1000 )
      {

        color randomColor = (int)random(0, userClr.length); 

        //let the pixel value in the result image be white
        result.pixels[loc] = color(userClr[randomColor]);
      } else if (depthVals[loc]> 1000)
      {
        result.pixels[loc] = color(255);
      } else
        //otherwise let the pixel value in the result image be white
        result.pixels[loc] = color(255);
    }
  }
  // update
  result.updatePixels();
  //display the result
  image(result, 0, 0);
}

void displayInfo(boolean active) {



  if (active == true) {

    /* * Display the depth image (great for debugging purpose, but the image is mirrored!)
     * (except if you set.mirror(true), but the skeleton will be mirrored instead!)
     */

    //kinect.enableRGB();
    //image(kinect.rgbImage(), 0, 0);  

    if (rgb)
    {
      kinect.enableRGB();
      image(kinect.rgbImage(), 0, 0);
    } else if (colorDepth)
    {
      getColorDepth();
    } else if (bg)
    {
      removeBackground();
    } 
    else if(bgRGB)
    {
      removeBackgroundRGB();
    }


    textSize(20);
    fill(255);
    text(
      "Press 'i' to enable/disable between video image and IR image,  " +
      "Press 'c' to enable/disable between color depth and gray scale depth,  " +
      "Press 'b' to remove background, "+
      "Press 'r' to remove background RGB, "+
      "Framerate: " + int(frameRate), 10, 515);

    int howMany = kinect.getNumberOfUsers();
    textSize(32);
    fill(255);
    text("Number of users = " + howMany, textPosition, 50);  

    if (visibleUser) {
      textSize(32);
      fill(175, 200, 255);
      text("Someone is in front of the Kinect", textPosition, 100);
    } else {
      textSize(32);
      fill(255, 100, 0);
      text("Nobody is in front of the Kinect...", textPosition, 100);
    }
  }
}

void keyPressed() {

  switch(key)
  {
  case 'i':   
    rgb = !rgb;  
    break;

  case 'c':
    colorDepth = !colorDepth;
    rgb=false;
    break;

  case 'b':
    bg=!bg;   
    break;
    
  case 'r':
    bgRGB=!bgRGB;   
    break;
  }
}


void displaySuccess(boolean active) {
  if (active == true) {
    textSize(32);
    fill(0, 255, 0);
    text("Tracking successful !", textPosition, 150);
  }
}

void displayError(boolean active) {
  if (active == true) {
    textSize(32);
    fill(255, 0, 0);
    text("Nobody is tracked...", textPosition, 150);
  }
}
