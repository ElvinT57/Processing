Mover [] movers = new Mover[100];
void setup(){
  size(500,500);
  background(0);
  
  int i = 0;
  for(float y = 20; y < width; y += 50){
   for(float x = 15; x < height; x += 50){
     if(i != 100)
       movers[i] = new Mover(1,x,y);
     i++;
   }
  }
}

void draw(){
 background(0);
  
 for(Mover m : movers){
    m.applyForce(gravity(m));
    m.update();
    m.bounce();
    m.display();
 }
 
}

PVector gravity(Mover m){
  // create a direction vector with no value
   PVector dir = new PVector(0,0);
   // If the mouse has been pressed, apply gravity force
   if(mousePressed){
      dir = PVector.sub(new PVector(mouseX, mouseY), m.location);
      mapColors(m, dir, 100,100,255,false);
      dir.normalize();
      
      arrive(m, dir);
   }
   else{
     dir = PVector.sub(m.home, m.location);
      mapColors(m, dir, 255,255,255,true);
      dir.normalize();
      
      arrive(m, dir);
   }
   return dir;
}

void mapColors(Mover m, PVector dir, float r, float g, float b, boolean inverse){
  if(!inverse){
      m.r = map(dir.mag(), 0, 100, 0, r);
      m.g = map(dir.mag(), 0, 100, 0, g);
      m.b = map(dir.mag(), 0, 100, 0, b);
  } else{
      m.r = map(dir.mag(), 0, 800, r, 0);
      m.g = map(dir.mag(), 0, 800, g, 0);
      m.b = map(dir.mag(), 0, 800, b, 0);
  }
}

void arrive(Mover m, PVector dir){
  if(dir.mag() < 100){
         float mappedM = map(dir.mag(), 0, 100, 0, m.topspeed);  
         dir.mult(mappedM*2);
      }
      else {
        dir.mult(m.topspeed);
      }
      PVector steer = PVector.sub(dir, m.velocity);
      steer.limit(.05);
      m.applyForce(steer);
}
