Mover[] movers = new Mover[400];
void setup() {
  size(800, 700);
  background(0);
  smooth();
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(5, random(width), random(height));
  }
}

void draw() {
  if (keyPressed) {
    if (key == ' ')
      background(0);
  }
  //background(0);
  for (Mover m : movers) {
    for (Mover m1 : movers) {
      if(m1 != m){
        PVector force = m1.attract(m);
        m.applyForce(force);
        
      }
      m.attractToMouse();
    }
    m.update();
    m.bounce();
   if (mousePressed)
      m.display();
  }
}
