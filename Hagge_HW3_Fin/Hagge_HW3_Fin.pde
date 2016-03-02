
//Beginning to code autonomous agents
//Will implement inheritance with a Vehicle class and a Seeker class



ArrayList<Flee> fList;
ArrayList<Obstacle> oList;
ArrayList<Seeker> sList;

PImage sand;//bg image

boolean debug;//debug lines

void setup() {
  size(1000, 1000);

  //instantiate list of seekers and add some at random positions
  sList = new ArrayList<Seeker>();
  
  for (int i = 0; i<1; i++) {
    Seeker seeker = new Seeker(random(1000), random(1000), 30, 2, 0.1);
    sList.add(seeker);
  }

  //instantiate list of fleers and add some at random positions
  fList = new ArrayList<Flee>();

  for (int i = 0; i<5; i++) {
    Flee flee = new Flee(random(1000), random(1000), 30, 4, 0.1);  
    fList.add(flee);
  }

  //instantiate list of obstacles and add some at random positions
  oList = new ArrayList<Obstacle>();

  for (int i = 0; i<7; i++) {
    Obstacle obstacle = new Obstacle(random(1000), random(1000), 40);
    oList.add(obstacle);
  }

  //load background sand image
  sand = loadImage("Sand.png");
  
  //bool that makes debug lines show
  debug = false;
}

void draw() {
  background(22, 255, 67);
  image(sand, 0, 0);

  //update the seeker
  for (int i = 0; i<sList.size(); i++) {
    sList.get(i).update();
    sList.get(i).display();

    //pursuit debug lines 
    if (sList.get(i).closestFPosition != null && debug) {
      stroke(0, 0, 255); 
      //line(sList.get(i).position.x, sList.get(i).position.y, sList.get(i).closestFPosition.x, sList.get(i).closestFPosition.y);
      line(sList.get(i).position.x, sList.get(i).position.y, sList.get(i).futurePosition.x, sList.get(i).futurePosition.y);
    }
  }


  //update the flee
  for (int i =0; i<fList.size(); i++) {
    fList.get(i).update();
    fList.get(i).display();

    //evade debug lines
    if (fList.get(i).closestSPosition != null && debug) {
      stroke(0);
      line(fList.get(i).position.x, fList.get(i).position.y, fList.get(i).futurePosition.x, fList.get(i).futurePosition.y);
    }
  }

  //display all obstacles in obstacle list
  for (int i = 0; i<oList.size(); i++) {
    oList.get(i).display();
  }

  //call collision for all seekers
  for (int i = 0; i<sList.size(); i++) {
    if (sList.get(i) != null) {
      collision(sList.get(i));
    }
  }
}


void collision(Seeker s) {
  for (int i= 0; i<fList.size(); i++) {
    if (sqrt(pow((s.position.x-fList.get(i).position.x), 2)+pow((s.position.y-fList.get(i).position.y), 2)) < 30) {
      sList.add(new Seeker(fList.get(i).position.x, fList.get(i).position.y, 30, 2, 0.1));
      for ( Seeker value : sList) {
        if (value.closestFPosition == fList.get(i).position) {
          value.closestFPosition = null;
        }
      }
      fList.remove(i);
    }
  }
}

//Press 'd' to make debug lines appear and disappear
void keyPressed() {  
  if (key=='d' ||key=='D') {
    debug = !debug;
  }
}

//spawn fires and tumbleweeds
void mousePressed() {
  if (mouseButton ==RIGHT) {
    fList.add(new Flee(mouseX, mouseY, 30, 4, 0.1));
  }
  if (mouseButton ==LEFT)
  {  
    sList.add(new Seeker(mouseX, mouseY, 30, 2, 0.1));
  }
}

//make array lists of humans and zombies 
//go to calc steer forces

//humans should check which zombie is cloest then flee from that 
//humans need to special variables, how far away zom should be and how far away the actually are
//loop through zom
//if dis is< safe dis or if null then 
//VARIABLE closestZombie


// zombies do vise versa

//subtract PV from position to center of screen if > then half the screen then seek the center