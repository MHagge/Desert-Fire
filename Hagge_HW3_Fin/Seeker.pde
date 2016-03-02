//Seeker class
//Creates an inherited Seeker object from the Vehicle class
//Due to the abstract nature of the vehicle class, the Seeker
//  must implement the following methods:  
//  calcSteeringForces() and display()

class Seeker/*Pursuit*/ extends Vehicle {

  //---------------------------------------
  //Class fields
  //---------------------------------------

  //seeking target
  //set to null for now
  PVector target = null;

  //PShape to draw this seeker object
  PShape body;

  //overall steering force for this Seeker accumulates the steering forces
  //  of which this will be applied to the vehicle's acceleration
  PVector steeringForce;

  //
  PVector closestFPosition;
  PVector closestFVelocity;

  //Pursuit Stuff
  int time = 10; // = distance*c
  PVector futurePosition;

  ////Wander
  //float cirlceDistance = 30;
  //float circleRadius =10;
  //float angleChange =-.5;

  //Graphics
  PImage fire;

  //---------------------------------------
  //Constructor
  //Seeker(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Seeker(float x, float y, float r, float ms, float mf) {

    //call the super class' constructor and pass in necessary arguments

    super(x, y, r, ms, mf);

    //instantiate steeringForce vector to (0, 0)
    steeringForce = new PVector(0, 0);

    //PShape initialization
    //draw the seeker "pointing" toward 0 degrees
    fill(255, 0, 0);
    stroke(0);
    body = createShape(ELLIPSE, 0, 0, 20, 5);

    //load Fire graphic
    fire = loadImage("Fire.png");
  }


  //--------------------------------
  //Abstract class methods
  //--------------------------------

  //Method: calcSteeringForces()
  //Purpose: Based upon the specific steering behaviors this Seeker uses
  //         Calculates all of the resulting steering forces
  //         Applies each steering force to the acceleration
  //         Resets the steering force
  void calcSteeringForces() {

    //get the steering force returned from calling seek
    //This seeker's target (for now) is the mouse

    PVector moose = new PVector(0, 0);

    for (int i = 0; i < fList.size(); i++) {
      float distance = PVector.sub(fList.get(i).position, position).mag();

      if (closestFPosition == null|| distance< PVector.sub(closestFPosition, position).mag()) {
        closestFPosition = fList.get(i).position;
        closestFVelocity = fList.get(i).velocity;
      }
    }

    if (closestFPosition != null) {
      futurePosition = PVector.mult(closestFVelocity, 30);//could Normalize closestFVelocity
      futurePosition.add(closestFPosition);
      moose = seek(futurePosition);
    }// else {
    //  steeringForce.add(sWander().mult(.7));
    //}

    //add the above seeking force to this overall steering force
    steeringForce.add(moose);

    if (position.x<100 || position.x>900 || position.y<100 ||position.y> 900) {
      steeringForce.add(seek(new PVector(width/2, height/2)).mult(10));
    }


    for (int i = 0; i<oList.size(); i++) {
      steeringForce.add(avoidObstacle(oList.get(i), 60).mult(3));
    }

    //limit this seeker's steering force to a maximum force
    steeringForce.limit(maxForce);

    //apply this steering force to the vehicle's acceleration
    applyForce(steeringForce);

    //reset the steering force to 0
    steeringForce.set(0, 0);
  }


  //Method: display()
  //Purpose: Finds the angle this seeker should be heading toward
  //         Draws this seeker as a triangle pointing toward 0 degreed
  //         All Vehicles must implement display
  void display() {

    //calculate the direction of the current velocity - this is done for you
    //float angle = velocity.heading();   

    //draw this vehicle's body PShape using proper translation and rotation
    pushMatrix();
    translate(position.x, position.y);
    pushStyle();
    imageMode(CENTER);
    image(fire, 0, 0, 50, 60);
    popStyle();
    popMatrix();

    //forward and right debug lines 
    if (debug) {
      pushMatrix();
      translate(position.x, position.y);
      stroke(0, 255, 0);
      line(0, 0, forward.x*50, forward.y*50);
      stroke(255, 0, 0);
      line(0, 0, right.x*50, right.y*50);
      popMatrix();
    }
  }

  //PVector sWander() {

  //  float wanderAngle = 0;
  //  PVector wander = forward.copy().mult(cirlceDistance);
  //  wanderAngle += random(-angleChange, angleChange);
  //  wander.add(PVector.fromAngle(wanderAngle).mult(circleRadius));
  //  return wander;
  //}

  //--------------------------------
  //Class methods
  //--------------------------------
}