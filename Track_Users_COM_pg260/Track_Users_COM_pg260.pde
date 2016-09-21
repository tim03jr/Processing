


//This puts the user ID at the center of mass.



import processing.serial.*;
import SimpleOpenNI.*;

Serial myPort;//Name the Serial object myPort.
SimpleOpenNI kinect;

int user_wave = 0;
PVector com = new PVector(); 
int wave_time = 0;
int Num = 0;


void setup() {
size(640, 480);
 String portName = Serial.list()[1]; /////////////////////////////////////////////////////////////////////////////ALWAYS CHECK THIS IF NOT WORKING/////////////////////////////////////////////////////////////////////////////////////
 myPort = new Serial(this, portName, 9600);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
//kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE); 
kinect.enableRGB();
kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.
}


void draw() {
kinect.update();
image(kinect.depthImage(), 0, 0);
IntVector userList = new IntVector();
kinect.getUsers(userList);
int time = millis();


for (int i=0; i<userList.size(); i++) { 
  int userId = userList.get(i);
  PVector position = new PVector();
  kinect.getCoM(userId, position); 
  kinect.convertRealWorldToProjective(position, position);
  fill(255, 0, 0);////////////////////////////////////////////////////////////////////Might want to remove this so that ther aren't numbers in the picuture.
  textSize(40); 
  text(userId, position.x, position.y);
  
  if (user_wave == userId){////////////////////////////////////////////////////////////////////
  //Send com data
  kinect.getCoM(userId,com);///////////////////////////////////////////////////Might not need this.
  
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
      ///////////////////////////////////////////////////////////////////////////////////////
   }
  }
  
if (wave_time != 0)//WAVE_TIME IS SET IN THE WAVE FUNCTION.
  {
    int delay = time - wave_time;//DELAY = CURRENT CLOCK NUMBER MINUS THE CLOCK NUMBER WHEN WAVE WAS INITIATED.
 
    if (delay > 3000)
    {
      // take a picture.
      println("Picture");
      println(delay);
      Num = Num + 1;//Allows for picture files to have different names.
      save("Pict" + Num + ".jpg");  
      wave_time = 0;  
    } 
  }  
}


void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)//WAVE gestureType = 0. HAND_RAISE gestureType = 2. HANDRAISE IS TOO SENSITIVE
{
  IntVector userList_1 = new IntVector();
  int userId = userList_1.get(0);//////////////////////////////Not sure if we can leave it blank
  user_wave = userId;/////////////////////////////////////////////////////Might not work
  println("Hand!");
  //When hand is waved, send notification to Eddie.
  myPort.write("p");  
  wave_time = millis();
  userList_1.remove(userId);
}





