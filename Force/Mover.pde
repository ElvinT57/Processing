class Mover{
 PVector location;
 PVector velocity;
 PVector acceleration;
 float topspeed;
 float mass; //adding mass as a float
 PVector home;
 float r, g, b = 255;
 
 Mover(float m, float x, float y){
  location = new PVector(x, y);
  home = new PVector(x, y);
  velocity = new PVector(0,0);
  acceleration = new PVector(0,0.8);
  topspeed = 4;
  mass = m; 
 }
 
 void update(){
   velocity.add(acceleration);
   location.add(velocity);
   //clear out acceleration to prevent accumalation
   acceleration.mult(0);
   acceleration.limit(topspeed);
 }
 
 
 void display(){
   noStroke();
   fill(r,g,b);
   ellipse(location.x, location.y, mass*16,mass*16);
 }
 
 void applyForce(PVector force){
   //Newton's second law F = A/M;
   PVector f = PVector.div(force, mass);
   acceleration.add(f);
 }
 
 void checkEdges(){
   if (location.x > width){
     location.x = 0;
   } 
   else if (location.x < 0){
     location.x = width;
   }
   
   if (location.y > height){
     location.y = 0;
   }
   else if (location.y < 0){
     location.y = height;
   }
 }
 
 void bounce(){
   if(location.x > width){
      location.x = width;
      velocity.x *= -1;
   } else if(location.x < 0){
      location.x = 0;
      velocity.x *= -1;
   }
   if(location.y > height){
      location.y = height;
      velocity.y *= -1;
   } else if(location.y < 0){
      location.y = 0;
      velocity.y *= -1;
   }
 }
}
