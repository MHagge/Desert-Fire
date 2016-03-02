//Flee class
//Creates an inherited Flee object from the Vehicle class
//Due to the abstract nature of the vehicle class, the Flee
//  must implement the following methods:  
//  calcSteeringForces() and display()

class Flee extends Vehicle {

  //---------------------------------------
  //Class fields
  //---------------------------------------

  //fleeinging target
  //set to null for now
  PVector target = null;

  //PShape to draw this Flee object
  PShape body;

  //overall steering force for this Flee accumulates the steering forces
  //  of which this will be applied to the vehicle's acceleration
  PVector steeringForce;

  PVector closestSPosition;
  PVector closestSVelocity;

  int safeDistance = 400;

  //Pursuit Stuff
  int time = 10; // = distance*c
  PVector futurePosition;

  //Wander
  float cirlceDistance = 30;
  float circleRadius =10;
  float angleChange =.5;

  //Graphics
  PImage weed;

  //---------------------------------------
  //Constructor
  //Flee(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Flee(float x, float y, float r, float ms, float mf) {

    //call the super class' constructor and pass in necessary arguments

    super(x, y, r, ms, mf);

    //instantiate steeringForce vector to (0, 0)
    steeringForce = new PVector(0, 0);

    //PShape initialization
    //draw the Flee "pointing" toward 0 degrees
    fill(255, 255, 255);
    stroke(0);
    body = createShape(ELLIPSE, 0, 0, 20, 5);

    weed = loadImage("Weed.png");
  }


  //--------------------------------
  //Abstract class methods
  //--------------------------------

  //Method: calcSteeringForces()
  //Purpose: Based upon the specific steering behaviors this Flee uses
  //         Calculates all of the resulting steering forces
  //         Applies each steering force to the acceleration
  //         Resets the steering force
  void calcSteeringForces() {

    //get the steering force returned from calling fleeing
    //This Flee's target (for now) is the mouse

    PVector moose = new PVector(0, 0);

    //reset closest to null
    closestSPosition = null;
    closestSVelocity = null;

    //find out which seeker is closest and if it is close enough to worry about
    for (int i = 0; i < sList.size(); i++) {
      float distance = PVector.sub(sList.get(i).position, position).mag();
      if (distance< safeDistance) {
        if (closestSPosition== null|| distance< PVector.sub(closestSPosition, position).mag()) {

          closestSPosition = sList.get(i).position;
          closestSVelocity = sList.get(i).velocity;
        }
      }
    }

    //if there is a seeker closer than the safe distance the evade it's future position
    if (closestSPosition!= null) {
      futurePosition = PVector.mult(closestSVelocity, 30);
      futurePosition.add(closestSPosition);
      moose = fleeing(futurePosition);
    } else {
      steeringForce.add(fWander().mult(.7));
    }

    //add the above fleeinging force to this overall steering force
    steeringForce.add(moose);

    //if fleer get to close to the edge then seek the center of the screen
    if (position.x<100 || position.x>900 || position.y<100 ||position.y> 900) {

      steeringForce.add(seek(new PVector(width/2, height/2)).mult(10));
    }
    
    //obstacle avoidance  force
    for (int i = 0; i<oList.size(); i++) {
      steeringForce.add(avoidObstacle(oList.get(i), 60).mult(5));
    }

    //limit this Flee's steering force to a maximum force
    steeringForce.limit(maxForce);

    //apply this steering force to the vehicle's acceleration
    applyForce(steeringForce);

    //reset the steering force to 0
    steeringForce.set(0, 0);
  }


  //Method: display()
  //Purpose: Finds the angle this Flee should be heading toward
  //         Draws this Flee as a triangle pointing toward 0 degreed
  //         All Vehicles must implement display
  void display() {

    //calculate the direction of the current velocity - this is done for you
    float angle = velocity.heading();   

    //draw this vehicle's body PShape using proper translation and rotation
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    //shape(body);
    pushStyle();
    imageMode(CENTER);
    image(weed, 0, 0, 50, 60);
    popStyle();
    popMatrix();
    
    //forward and right debug lines 
    if(debug){
    pushMatrix();
    translate(position.x, position.y);
    stroke(0, 255, 0);
    line(0, 0, forward.x*50, forward.y*50);
    stroke(255, 0, 0);
    line(0, 0, right.x*50, right.y*50);
    popMatrix();
    }
  }

  PVector fWander() {

    float wanderAngle = 0;
    PVector wander = forward.copy().mult(cirlceDistance);
    wanderAngle += random(-angleChange, angleChange)-5;
    wander.add(PVector.fromAngle(wanderAngle).mult(circleRadius));
    return wander;
  }
  //--------------------------------
  //Class methods
  //--------------------------------
}