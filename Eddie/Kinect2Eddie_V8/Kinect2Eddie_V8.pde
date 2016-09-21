//Tracks a user's hand when they give the wave gesture.
//When they give the wave gesture, the depth data is sent via serial to the Eddie board.


//TO DO:
//Hand x/y data to Eddie board.
//Should only send data from one hand at a time.


import processing.serial.*;                                                                  //import serial library
Serial myPort;//Name the Serial object myPort.
import SimpleOpenNI.*;//Import the simpleopenNI library.
SimpleOpenNI kinect;//Declares and names our object/library kinect.

void setup() {
 size(640, 480);//The size that the kinect puts out. 
 String portName = Serial.list()[1]; 
 myPort = new Serial(this, portName, 9600);  
 kinect = new SimpleOpenNI(this);//Instantiate the SimpleOpenNI instance that was previously declared. Instantiating is confusing??????????????????????
 kinect.enableDepth();//Enable the depth sensor.
 kinect.enableHand();
 kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.
}
void draw() {
  kinect.update();                                       //Calls the update method of the kinect object. Probably refreshes the readings or takes new readings.
  PImage depth = kinect.depthImage();                    //A PImage variable is a place to store image data.
  image(depth, 0, 0);                                    //Our PImage that is our depth image is displayed here. 
}
void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
{
  /*int handId = */kinect.startTrackingHand(pos);
  println("Hand!");
}
                                      //void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)//These parameters are where onNewHand stores data. loops only one time.
                                      //{
                                      //  println("OMG");
                                      //  println(pos.z);
                                      //}

//SAME AS onNewHand exept loops continuously.
void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos){
 
 
 
                     //This is for the z data.
    int integer_posz = int(pos.z);//Convert float to integer.
    String STR_posz = str(integer_posz);//Convert integer to string.
    String CR = "\r";
    myPort.write("z"); 
    myPort.write(STR_posz);     
    myPort.write(CR);            
    println(STR_posz);
    // myPort.write("1700\r"); //A good range seems to be about 1700 - 1800. 
    
    
    
    
                    //This is for the x data.
    int integer_posx = int(pos.x);//Convert float to integer.
    String STR_posx = str(integer_posx);//Convert integer to string.
    myPort.write("x"); 
    myPort.write(STR_posx);    
    myPort.write(CR);            
   // println(STR_posx);                   
                                        
                    
}

void onLostHand(SimpleOpenNI curContext,int handId)//Would like to empty the handId array.
{
  println("Hand lost");
}



