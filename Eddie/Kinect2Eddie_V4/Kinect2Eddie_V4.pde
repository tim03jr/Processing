//Simplified version with only the key components.

//TO DO:
//      get distance data of COM and send to Robo-Ralph. Have Robo-Ralph respond


import processing.serial.*;                                                                  //import serial library
Serial myPort;//Name the Serial object myPort.
import SimpleOpenNI.*;
SimpleOpenNI kinect;   


void setup()
{
  size(640, 480);   
  String portName = Serial.list()[0];                                                       //Creates a string named portName the equals the serial port specfied in brackets.
  myPort = new Serial(this, portName, 9600);    
  kinect = new SimpleOpenNI(this);
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
  image(kinect.userImage(),0,0);       //This draws the depthImage. Could also use image(kinect.depthImage(),0,0); userimage gives colors to tracked users and depthImage doesn't.

  IntVector userList = new IntVector();
  kinect.getUsers(userList);  
  
  for (int i=0; i<userList.size(); i++)
    {
      int userId = userList.get(i);
  
      PVector position = new PVector();
      kinect.getCoM(userId, position);
      
      int integer = int(position.z);
      String STR = str(integer);
      String CR = "\r";
      myPort.write("1700\r"); //A good range seems to be about 1700 - 1800.      
     // myPort.write(CR);
      println(STR);
    }
  

  }







void onNewUser(SimpleOpenNI curContext, int userId) //This is automatically called when a new user is sensed.
                                                    //Not sure what the "SimpleOpenNI curContext" is for?????????????????
                                                    //I'm guessing that we are naming a new object. Not sure what the point of that is though.
{
  //myPort.write('s');
     //When a new skeleton is being tracked, send an 's'.
   myPort.write("1700\r");
  //curContext.startTrackingSkeleton(userId);                 //Calling a SimpleOpenNI function called start tracking skeleton
}










//////////////////////////////////////////////////////////////////////Extra functions////////////////////////////////////////////////////////////////////////////////////////



/*
void drawSkeleton(int userId)
{

}

void onLostUser(SimpleOpenNI curContext, int userId)
{

}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  
}

void keyPressed()
{

}



*/
