class Obstacle {

  PShape obs;
  PVector oPosition;
  float radius;
  PImage cactus;

  Obstacle(float x, float y, float r) {
    oPosition = new PVector(x, y);//random(0,500),random(0,500));
    radius = r;

    //load cactus obstacle image
    cactus = loadImage("Cactus.png");
  }
  void display() {

    //shape(obs);
    pushStyle();
    imageMode(CENTER);
    image(cactus, oPosition.x+7, oPosition.y+7);
    popStyle();
  }
}