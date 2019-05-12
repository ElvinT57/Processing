class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float mass; //adding mass as a float
  PVector home;
  float [] rgb = {200, 100, 255};
  float opacity;
  float G = 1;

  Mover(float m, float x, float y) {
    location = new PVector(x, y);
    home = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    topspeed = 4;
    mass = m;
    opacity = 25;
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    //clear out acceleration to prevent accumalation
    acceleration.mult(0);
    velocity.limit(topspeed);
  }

  void display() {
    noStroke();
    fill(rgb[0], rgb[1], rgb[2], opacity);
    ellipse(location.x, location.y, mass*5, mass*5);
  }

  void applyForce(PVector force) {
    //Newton's second law F = A/M;
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }

  void bounce() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      location.x = 0;
      velocity.x *= -1;
    }
    if (location.y > height) {
      location.y = height;
      velocity.y *= -1;
    } else if (location.y < 0) {
      location.y = 0;
      velocity.y *= -1;
    }
  }

  void friction() {
    float c = 0.01;
    float normal = 1;
    float frictionMag = c*normal;

    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMag);

    this.applyForce(friction);
  }

  PVector attract(Mover mover) {
    PVector force = PVector.sub(location, mover.location);
    float distance = force.mag();
    //restrain the distance
    distance = constrain(distance, 5, 25);

    float m = (G * mover.mass * mass) / (distance * distance);
    //normalize the force and scale it to the appropriate magnitude
    force.normalize();
    force.mult(m/20);  

    return force;
  }

  /*
      SAME AS ATTRACT, but multiply by -1
      to repel
   */
  PVector Repel(Mover mover) {
    PVector force = PVector.sub(location, mover.location);
    float distance = force.mag();
    //restrain the distance
    distance = constrain(distance, 5, 25);

    float m = (G * mover.mass * mass) / (distance * distance);
    //normalize the force and scale it to the appropriate magnitude
    force.normalize();
    force.mult(m/20);  

    return force.mult(-1);
  }

  void attractToMouse() {
    PVector force = PVector.sub(new PVector(mouseX, mouseY), location);
    float distance = force.mag();
    //restrain the distance
    distance = constrain(distance, 5, 10);

    float m = (G * 1) / (distance * distance);
    //normalize the force and scale it to the appropriate magnitude
    force.normalize();
    force.mult(m/2);  
    this.applyForce(force);
  }

  void attractToRandom(PVector r) {
    PVector force = PVector.sub(r, location);
    float distance = force.mag();
    //restrain the distance
    distance = constrain(distance, 5, 10);

    float m = 1 / (distance * distance);
    //normalize the force and scale it to the appropriate magnitude
    force.normalize();
    force.mult(m/2);  

    this.applyForce(force);
  }
}
