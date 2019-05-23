import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import controlP5.*;

//UI
ControlP5 cp5;

Table table;
ArrayList<Bubble> bubbles = new ArrayList();
Bubble target = new Bubble();

VerletPhysics2D world;

void setup() {
  size(displayWidth, displayHeight);
  smooth();  //smooth out the pixels
  background(255);
  world = new VerletPhysics2D();    //using verlet integration
  
  //set world boundaries
  world.setWorldBounds(new Rect(0, 0, width, height));

  //load csv and intialize bubbles 
  table = loadTable("GDP.csv", "header");
  int i = 0;
  for (TableRow row : table.rows()) {
    bubbles.add(new Bubble(row));
    world.addParticle(bubbles.get(i));
    i++;
  }

  //initalize the text field
  cp5 = new ControlP5(this);
  cp5.addTextfield("Enter country").setPosition(20, 10)
    .setSize(130, 20)
    .setFont(new ControlFont(createFont("arial", 10), 20))
    .setFocus(false)
    .setColor(color(0))
    .setColorBackground(color(255))
    .setColorCaptionLabel(color(175));
}

void draw() {
  background(255);
  //Toxiclibs objects
  for (Bubble b : bubbles) {
    b.run();
    b.display();
  }
  world.update();

  //display current year
  textSize(35);
  fill(0);
  text("GDP Per Capita " + bubbles.get(0).currYear, (width/2)-150, 50);
}

void keyPressed() {
  if (keyCode == UP) {
    int i = 0;
    for (TableRow row : table.rows()) {
      bubbles.get(i).increaseYear(row);
      i++;
    }
  } else if (keyCode == DOWN) {
    int i = 0;
    for (TableRow row : table.rows()) {
      bubbles.get(i).decreaseYear(row);
      i++;
    }
  }
}

void controlEvent(ControlEvent e) {
  String countryName = e.getStringValue();
  //search for the given country name
  int i = search(countryName);
  if (i != -1) {
    target.searched = false;
    (target = bubbles.get(i)).searched = true;
    target.updateLocation(width/2, height/2);
    //lock and unlock to prevent instant acceleration between points
    target.lock();
    target.unlock();
  }
}

int search(String item) {
  //initialize local variables
  int i = 0, result = -1;
  boolean done = false;
  //assume that the item is greater than all the others
  

  while (i < bubbles.size() && !done) {
    if (item.equals(bubbles.get(i).country)) {
      // stop(succ, position)
      result = i; //record position normally for successful search
      done = true; //set done to true for graceful exit
    } else {
      i++;
    }
  }

  return result;
}
