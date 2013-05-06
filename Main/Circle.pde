class Circle {
  String name;
  float centerX, centerY;
  float radius;
  boolean centerSelected = false;
  boolean radiusSelected = false;
  
  Circle(String _name, float _centerX, float _centerY, float _radius) {
    name = _name;
    centerX = _centerX;
    centerY = _centerY;
    radius = _radius;
  }
  
  boolean centerHasMouseOverIt() {
    float margin_for_error = radius * .3;
    if (dist(mouseX, mouseY, centerX, centerY) < margin_for_error) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawSelf() {
      smooth();
      stroke(255);
      noFill();
      ellipse(centerX, centerY, radius*2, radius*2);
      
      //draw label
      textFont(BaskOldFace);
      float textSize = 24;
      textSize(textSize);
      float x_offset = name.length() * textSize / 4;
      fill(255);
      text(name, centerX - x_offset, centerY - radius);
  }
  
  boolean radiusHasMouseOverIt() {
    float distance = dist(mouseX, mouseY, centerX, centerY);
    float margin_for_error = radius * .3;
    if (((radius - margin_for_error) < distance) && 
        (distance < (radius + margin_for_error))) {
      return true;
    } else {
      return false;
    }
  }

} //end of class Circle

void checkForSelectedCirclesInArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].radiusHasMouseOverIt()) {
      circles[i].radiusSelected = true;
      break;
    } else if (circleArray[i].centerHasMouseOverIt()) {
      circles[i].centerSelected = true;
      break;
    }
  }
}

void deselectCirclesInArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    circleArray[i].centerSelected = false;
    circleArray[i].radiusSelected = false;
  }
}

void dragSelectedCirclesIn(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerSelected == true) {
      circleArray[i].centerX = mouseX;
      circleArray[i].centerY = mouseY;
    }
  } 
}

void drawCircleArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    circleArray[i].drawSelf();
  }
}

float percentOfCircle1InCircle2(Circle circle1, Circle circle2) {
  float x1 = circle1.centerX;
  float y1 = circle1.centerY;
  float r1 = circle1.radius;
  float x2 = circle2.centerX;
  float y2 = circle2.centerY;
  float r2 = circle2.radius;
  if (dist(x1, y1, x2, y2) > (r1 + r2)) { //no As are Bs
    return 0;
  } else if (dist(x1, y1, x2, y2) < r2-r1) { //all As are Bs
    return 1;
  } else { //some As are Bs
    return 0.5;
  }
}

void resizeSelectedCirclesIn(Circle[] circleArray) {
  for (int i = 0; i < circles.length; i++) {
    if (circleArray[i].radiusSelected == true) {
      float centerX = circleArray[i].centerX;
      float centerY = circleArray[i].centerY;
      float pMouseDistance = dist(pmouseX, pmouseY, centerX, centerY);
      float mouseDistance = dist(mouseX, mouseY, centerX, centerY);
      circleArray[i].radius += (mouseDistance - pMouseDistance);
      circleArray[i].radius = max(circles[i].radius,0);
    }
  }
}
