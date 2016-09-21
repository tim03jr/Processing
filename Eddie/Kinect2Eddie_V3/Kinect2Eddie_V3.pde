//Modifying the V2 code

//I'm pretty much copying and commenting the example called User.



//TO DO:
//When skeleton is tracked, send a character to Robo-Ralph(Will be in Kinect-mode). 
//When skeleton is tracked, Robo-Ralph should make a noise(like say hi or something).
//Have Robo-Ralph react to the distance of the user who's skeleton is being tracked.



import processing.serial.*;                                                                  //import serial library
Serial myPort;                                                                               //Name the Serial object myPort.
import SimpleOpenNI.*;
SimpleOpenNI kinect;                                                                         //Can name our object whatever we want.
                                                                                             //We are giving a name to our object
                            
color[]  userClr = new color[]{color(255,0,0),                                               //This is an array of colors for skeletons
                               color(0,255,0),
                               color(0,0,255),
                               color(255,255,0),
                               color(255,0,255),
                               color(0,255,255)
                             };
PVector com = new PVector();                                                                //com = Center of Mass. This is an array for storing vectors for moving objects. Position, Velocity, Acceleration.                               
PVector com2d = new PVector(); 

void setup()
{
  size(640, 480);                                                                           //I'd like this to fill the whole screen.
  
  String portName = Serial.list()[1];                                                       //Creates a string named portName the equals the serial port specfied in brackets.
  myPort = new Serial(this, portName, 9600);                                                //Applies parameters to the serial object that we named myPort.
    
  kinect = new SimpleOpenNI(this);
  if(kinect.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();      //Exits the program entirely
     return;  
  }
  kinect.enableDepth();    //Enables the depthmap
  kinect.enableUser();     //Enables skeleton generation for all joints
  kinect.enableRGB();  
  background(200,0,0);    //Sets the background to red.
  stroke(0,0,255);        //Sets the outline to black(Outline of what though?)
  strokeWeight(3);        //Sets the stroke width
  smooth();               //Smooths all the edges of shapes(What shapes?)
  
}

void draw() 
{
  kinect.update();                     //Update all data streams from the kinect
  image(kinect.userImage(),0,0);       //This draws the depthImage. Could also use image(kinect.depthImage(),0,0);
                                       //image(the image to display, x-pos, y-pos)
                                       
    //DRAWING THE SKELETON IF IT'S AVAILABLE.
  int[] userList = kinect.getUsers();  //Sets an array named userList equal to Whatever is returned from the getUsers method.
  for(int i=0; i<userList.length; i++) // Add one to i unless i is less than the length of the user list(# of people in kinect view).
  {
    if(kinect.isTrackingSkeleton(userList[i])) //AKA if (blah blah != 0).  Meaning if there are users detected.....
    {
      stroke(userClr[(userList[i] - 1) % userClr.length]); //This determines the color of the lines for the skeletons.
                                                        //The % is the modulus operator. It returns the remainder of the first
                                                        //divided by the second number. 
                                                        //userClr is the vector of colors created initially. 
                                                        //So basically, I think we're dividing the i'th indice() of the userList array
                                                        //by the length of our userClr array(which in our case is 6).
                                                        //With one user, it becomes: 0/6 has a remainder of 6, so the color that it
                                                        //choses is the 6th indice of the userClr array. Not sure what the point
                                                        //of this convoluted method is.
      drawSkeleton(userList[i]); //Draw a skeleton on this user (Internal function).
    }
    
    //DRAWING THE CENTER OF MASS
    if(kinect.getCoM(userList[i],com)) //Again, if (blah blah != 0)./////////Check pg262 making things see pdf for com info
                                       //COM stands for center of mass. The getCom method takes two arguments: EX) kinect.getCoM(UserID, Pvector)
                                       //We created the Pvectors com and com2d at the beginning of this program.
                                       //Inside of com is stored the position of the C.O.M. in Real world coordinates.
    
    {
      kinect.convertRealWorldToProjective(com,com2d); //Converts "Real world coordinates"(depth image data(com)) to screen coordinates (projective coordinates(com2d)).
                                                      //This allows us to display the data from the depth image.
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);                            //This draws a cross right at the center of mass.
        vertex(com2d.x, com2d.y - 5);               //com2d.x is the x position of the projected coordinates.
        vertex(com2d.x, com2d.y + 5);
        
        vertex(com2d.x - 5, com2d.y);
        vertex(com2d.x+5, com2d.y);
      endShape();
      
      fill(0, 255, 100);
      text(Integer.toString(userList[i]), com2d.x, com2d.y);//Puts the user's number next to the center of mass. 
    }
  }
}

//Draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
   // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);                 //Draws line between joints listed.

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
} 

//--------------------------------------------SIMPLEOPENNI EVENTS------------------------------------------------


void onNewUser(SimpleOpenNI curContext, int userId) //This is automatically called when a new user is sensed.
                                                    //Not sure what the "SimpleOpenNI curContext" is for?????????????????
                                                    //I'm guessing that we are naming a new object. Not sure what the point of that is though.
{
  myPort.write('s');                                                                                 //When a new skeleton is being tracked, send an 's'.
 
  println("onNewUser - userId: " + userId);                 //Print this text to GUI
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);                 //Calling a SimpleOpenNI function called start tracking skeleton
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " +userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

void keyPressed()
{
  switch(key)
  {
    case ' ':
    kinect.setMirror(!kinect.mirror());
    break;
  }
}











