//******************************************************************************
float screenWidth = 1000;
float screenHeight = 500;
Circle[] circles = {new Circle("bad haircuts", 250, 250, 50),
                    new Circle("absurd things", 300, 300, 50)};
String[] goals = {"No", "Some"};
PFont BaskOldFace;
String currentScreen = "In-Game";
MenuButton mButton = new MenuButton(screenWidth - 50, 5, 50, 20);

void setup() {
  size(1000, 500);
  BaskOldFace = loadFont("BaskOldFace-48.vlw");
}

void draw() {
  background(0);
  drawCircleArray(circles);
  drawGUI();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    checkForSelectedCirclesInArray(circles);
  }
}

void mouseReleased() {
  deselectCirclesInArray(circles);
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    dragSelectedCirclesIn(circles);
    resizeSelectedCirclesIn(circles);
  }
}

