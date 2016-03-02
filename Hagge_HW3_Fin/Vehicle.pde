//Vehicle class
//Specific autonomous agents will inherit from this class 
//Abstract since there is no need for an actual Vehicle object
//Implements the stuff that each auto agent needs: movement, steering force calculations, and display

abstract class Vehicle {

  //--------------------------------
  //Class fields
  //--------------------------------
  //vectors for moving a vehicle
  PVector position, velocity, acceleration, forward, right;

  //no longer need direction vector - will utilize forward and right
  //these orientation vectors provide a local point of view for the vehicle


  //floats to describe vehicle movement and size
  float maxForce, maxSpeed, radius, mass;

  //--------------------------------
  //Constructor
  //Vehicle(x position, y position, radius, max speed, max force)
  //--------------------------------
  Vehicle(float x, float y, float r, float ms, float mf) {
    //Assign parameters to class fields
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    forward = new PVector(0, 0);
    right = new PVector(0, 0);
    radius = r;
    maxSpeed = ms;
    maxForce = mf;
    mass = 1;
  }

  //--------------------------------
  //Abstract methods
  //--------------------------------
  //every sub-class Vehicle must use these functions
  abstract void calcSteeringForces();
  abstract void display();

  //--------------------------------
  //Class methods
  //--------------------------------

  //Method: update()
  //Purpose: Calculates the overall steering force within calcSteeringForces()
  //         Applies movement "formula" to move the position of this vehicle
  //         Zeroes-out acceleration 
  void update() {
    //calculate steering forces by calling calcSteeringForces()
    calcSteeringForces();

    //add acceleration to velocity, limit the velocity, and add velocity to position
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);

    //calculate forward and right vectors
    forward = (velocity.copy()).normalize();

    right = forward.copy().rotate(PI/2);

    //reset acceleration

    acceleration.set(0, 0);
  }


  //Method: applyForce(force vector)
  //Purpose: Divides the incoming force by the mass of this vehicle
  //         Adds the force to the acceleration vector
  void applyForce(PVector force) {
    acceleration.add(PVector.div(force, mass));
  }


  //--------------------------------
  //Steering Methods
  //--------------------------------

  //Method: seek(target's position vector)
  //Purpose: Calculates the steering force toward a target's position
  PVector seek(PVector target) {

    //write the code to seek a target!

    PVector desiredVelocity = PVector.sub(target, position);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    return steer;
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  PVector avoidObstacle(Obstacle obst, float safeDistance) {
    PVector steer = new PVector(0, 0);
    PVector desiredVelocity = new PVector(0, 0);

    PVector vecToCenter = PVector.sub(obst.oPosition, position);

    float distance = vecToCenter.mag();

    if (distance-(radius+obst.radius) > safeDistance) {
      return steer;
    }
    //print(velocity);
    //print(forward);
    if (PVector.dot(vecToCenter, forward) <0) {
      return steer;
    }

    if (PVector.dot(vecToCenter, right) > radius+obst.radius) {
      return steer;
    }

    // Use the sign of the dot product between the vector to center (vecToCenter) and the
    // vector to the right (right) to determine whether to steer left or right
    if ( PVector.dot(vecToCenter, right)>0) {
      desiredVelocity = PVector.mult(right, -maxSpeed);
    } else {
      desiredVelocity = PVector.mult(right, maxSpeed);
    }

    steer = PVector.sub(desiredVelocity, velocity);

    steer.mult(safeDistance/distance);

    return steer;
  }
  PVector fleeing(PVector target) {

    //write the code to seek a target!

    PVector desiredVelocity = PVector.sub(position, target);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    return steer;
  }
}