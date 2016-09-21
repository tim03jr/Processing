//This is an attempt to improve V9 by tracking the user's COM instead of thier hand.
//I'd also like to have a picture taken upon completion of a hand-raise gesture. The image should then be sent to a printer immediately. 


//TO DO: 
//Track a user's body not the hand. Can match the user id to hand id. (i.e. the one waving gets thier COM tracked.)
//On raised hand pause for a second and take a picture with webcam. Immediately send picture to printer.



import processing.serial.*;                                                                  //import serial library
Serial myPort;//Name the Serial object myPort.
import SimpleOpenNI.*;//Import the simpleopenNI library.
SimpleOpenNI kinect;//Declares and names our object/library kinect.

PVector com = new PVector(); ////////////////////////////////////////New

void setup() {
 size(640, 480);//The size that the kinect puts out. 
 String portName = Serial.list()[1]; 
 myPort = new Serial(this, portName, 9600);  
 kinect = new SimpleOpenNI(this);//Instantiate the SimpleOpenNI instance that was previously declared. Instantiating is confusing??????????????????????
 kinect.enableDepth();//Enable the depth sensor.
 kinect.enableHand();
 kinect.enableUser(); 
 kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.
}

void draw() {
  kinect.update();                                       //Calls the update method of the kinect object. Probably refreshes the readings or takes new readings.
  PImage depth = kinect.depthImage();                    //A PImage variable is a place to store image data.
  image(depth, 0, 0);   //Would like to have webcam image displayed too.                                 //Our PImage that is our depth image is displayed here. 
  int[] userList = kinect.getUsers();
  
  if (userList.length != 0)
  {
    int i = userList.length;    
    kinect.getCoM(userList[i-1],com);
    
    if (com.z != 0)
    {
      println(com.z);
      //println("New user");
      
      //This is for the x-data.
      int intgr_comx = int(com.x);//Convert float to integer.
      String STR_comx = str(intgr_comx);//Convert integer to string.
      String CR = "\r";
      myPort.write("x"); 
      myPort.write(STR_comx);    
      myPort.write(CR);            
      // println(STR_posx); 
      
      
      //print z-value to serial.
      int intgr_comz = int(com.z);//Convert float to integer.
      String STR_comz = str(intgr_comz);//Convert integer to string.
      myPort.write("z"); 
      myPort.write(STR_comz);     
      myPort.write(CR); 
    }
    
    if (com.z == 0)
    {
      //Print "l" to serial.
      myPort.write("l");
    }
    
  }
  
}

//void onNewUser(SimpleOpenNI curContext, int userId)
//{
// println("Blah"); 
//}

void onLostUser(SimpleOpenNI curContext, int userId)//Takes about 30 seconds to print this.
{
  println("Lost User");
  myPort.write("l");
}

void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)//WAVE gestureType = 0. HAND_RAISE gestureType = 2.
{
 //When hand is waved, take a picture.
 //Send picture to printer.
  println("Hand!");
  
}


















////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)//WAVE gestureType = 0. HAND_RAISE gestureType = 2.
//{
// // /*int handId = */kinect.startTrackingHand(pos);
//  println("Hand!");
//  println(gestureType);
//}


//SAME AS onNewHand exept loops continuously.
//void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos){
  
//                     //This is for the z data.
//    int integer_posz = int(pos.z);//Convert float to integer.
//    String STR_posz = str(integer_posz);//Convert integer to string.
//    String CR = "\r";
//    myPort.write("z"); 
//    myPort.write(STR_posz);     
//    myPort.write(CR);            
//    println(STR_posz);
//    
//       
//                    //This is for the x data.
//    int integer_posx = int(pos.x);//Convert float to integer.
//    String STR_posx = str(integer_posx);//Convert integer to string.
//    myPort.write("x"); 
//    myPort.write(STR_posx);    
//    myPort.write(CR);            
//   // println(STR_posx);                                                            
//}



