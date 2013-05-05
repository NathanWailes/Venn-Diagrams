//*********************THIS LINE IS 80 CHARACTERS LONG**************************

void setup() {
  size(400, 400);
  frameRate(40);
}

void draw() {
  background(0);
  stroke(255);
  fill(0);
  ellipse(200, 200, 100, 100);
  //ellipse(200, 250, 100, 100);
}

void mousePressed() {
  int circleCenterX = 200;
  int circleCenterY = 200;
  float circleRadius = 50;
  float distanceFromCircleCenter = sqrt(pow((mouseX - circleCenterX), 2) + 
                                  pow((mouseY - circleCenterY), 2));
  if (((circleRadius - 5.0) < distanceFromCircleCenter) && 
      (distanceFromCircleCenter < (circleRadius + 5.0))){
    print(distanceFromCircleCenter + "\n");
  }
}

void mouseDragged() {
  
}
