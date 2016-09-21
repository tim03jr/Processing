//test to practice delay


int i = 0;
void setup()
{
  size(100,100);
  
  
}


void draw()
{
  
  i += 1;
  delay(1000);
  println(i);
  
  
}

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}
