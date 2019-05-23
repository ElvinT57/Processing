class Bubble extends VerletParticle2D {
  String country;
  String code;
  float GDPPC;  //gdp per capita
  int currYear;
  float [] rgb = {0, 0, 0};  //color will be defined by the country code
  Circle body;
  boolean searched;

  //default constructor
  Bubble() {
    super(0, 0);
  }

  Bubble(TableRow row) {
    super(random(width-100), random(height-100));
    //intialize fields
    currYear = 2000;
    country = row.getString("Country Name");
    code = row.getString("Country Code");
    GDPPC = map(float(row.getString(Integer.toString(currYear))), 0, 59927*6, 0, width);
    mapCode();
    body = new Circle(x, y, GDPPC/2);
    //add repulsion behaviors
    world.addBehavior(new AttractionBehavior2D(this, GDPPC, -0.05));
  }

  void run() {
    //update the body
    body.x = this.x;
    body.y = this.y;
    //damp the velocity
    this.scaleVelocity(0.99);
    //bounce();
  }

  void display() {
    if (this.searched)
      stroke(0);
    else
      noStroke();
    fill(rgb[0], rgb[1], rgb[2], 75);
    ellipse(x, y, GDPPC, GDPPC);
    //if the user is hovering over the bubble
    onHover();
  }

  void mapCode() {
    for (int i = 0; i < 3; i++) {
      rgb[i] = map(float(code.charAt(i)), 65, 90, 0, 255);
    }
  }

  void increaseYear(TableRow row) {
    if (currYear != 2017) {
      GDPPC = map(float(row.getString(Integer.toString(currYear++))), 0, 59927*6, 0, width);
      body.setRadius(GDPPC/2);
      world.addBehavior(new AttractionBehavior2D(this, GDPPC/2, -0.2));
    }
  }

  void decreaseYear(TableRow row) {
    if (currYear != 1960) {
      GDPPC = map(float(row.getString(Integer.toString(currYear--))), 0, 59927*6, 0, width);
      body.setRadius(GDPPC/2);
      world.addBehavior(new AttractionBehavior2D(this, GDPPC/2, -0.2));
    }
  }

  void onHover() {
    if (body.containsPoint(new Vec2D(mouseX, mouseY ))) {
      textSize(15);
      fill(0, 0, 0);
      text(country, body.x, body.y);
      text("$" + GDPPC, body.x, body.y+15);
      //move the body and the fixture where the mouse is
      if (mousePressed)
        updateLocation(mouseX, mouseY);
    }
  }

  void updateLocation(float x, float y) {
    body.x = x; 
    body.y = y;
    this.x = x; 
    this.y = y;
  }

  void bounce() {
    if (this.x+body.getRadius() > width)
      this.scaleVelocity(-1); 
    else if (this.x-body.getRadius() < 0)
      this.scaleVelocity(-1);
    else if (this.y+body.getRadius() > height)
      this.scaleVelocity(-1);
    else if(this.y-body.getRadius() < 0)
      this.scaleVelocity(-1);
    }
  }
