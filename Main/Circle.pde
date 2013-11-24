class Circle {
  String name;
  float centerX, centerY;
  float radius;
  float name_degree, name_x_offset, name_y_offset;
  boolean centerSelected = false;
  boolean radiusSelected = false;
  color circle_color = color(255, 255, 255);

  Circle(String _name, float _centerX, float _centerY, float _radius) {
    name = _name;
    centerX = _centerX;
    centerY = _centerY;
    radius = _radius;
  }

  boolean centerHasMouseOverIt() {
    float margin_for_error = radius * .3;
    if (dist(mouseX, mouseY, centerX, centerY) < margin_for_error) {
      circle_color = color(255, 80, 80);
      return true;
    } else {
      circle_color = color(255, 255, 255);
      return false;
    }
  }



  void drawSelf() {
      smooth();
      stroke(circle_color);
      noFill();
      ellipse(centerX, centerY, radius*2, radius*2);
      
      //draw label
      textFont(BaskOldFace);
      float txtSize = 24;
      textSize(txtSize);
      float x_offset = name.length() * txtSize / 4;
      fill(255);
      x_offset = x_offset + cos(name_degree) * radius;
      float y_offset = sin(name_degree) * radius;
      //text(name, centerX - x_offset, centerY - y_offset);
      text(name, centerX + name_x_offset, centerY + name_y_offset);
  }




  boolean radiusHasMouseOverIt() {
    float distance = dist(mouseX, mouseY, centerX, centerY);
    float margin_for_error = radius * .3;
    if ((max((radius - margin_for_error), radius - 20) < distance) && 
        (distance < min((radius + margin_for_error), radius + 20))) {
      circle_color = color(255, 80, 80);
      return true;
    } else {
      circle_color = color(255, 255, 255);
      return false;
    }
  }
} //end of class Circle

boolean aCircleCenterIsBeingHoveredOver(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerHasMouseOverIt()) {
      return true;
    }
  }
  return false;
}

boolean aCircleRadiusIsBeingHoveredOver(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].radiusHasMouseOverIt()) {
      return true;
    }
  }
  return false;
}

void checkForSelectedCirclesInArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerHasMouseOverIt()) {
      circles[i].centerSelected = true;
      click.play();
      click = minim.loadFile("click.wav");
      return;
    }
  }
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].radiusHasMouseOverIt()) {
      circles[i].radiusSelected = true;
      click.play();
      click = minim.loadFile("click.wav");
      return;
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
  if (circle1 == circle2) {
    return 1;
  } else if (dist(x1, y1, x2, y2) > (r1 + r2)) { //no As are Bs
    return 0;
  } else if (dist(x1, y1, x2, y2) <= r2-r1) { //all As are Bs
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


void rotateNameOfSelectedCircleIn(Circle[] circleArray) {
  for (int i = 0; i < circles.length; i++) {
    if (circleArray[i].radiusSelected == true) {
      float centerX = circleArray[i].centerX;
      float centerY = circleArray[i].centerY;
      float radius = circleArray[i].radius;
      
      float opposite_side = mouseY - centerY;
      float adjacent_side = mouseX - centerX;
      float hypotenuse = dist(mouseX, mouseY, centerX, centerY);
      
      float cosine_of_angle = adjacent_side / hypotenuse;
      float sine_of_angle = opposite_side / hypotenuse;
      
      circleArray[i].name_x_offset = radius * cosine_of_angle;
      circleArray[i].name_y_offset = radius * sine_of_angle;
    }
  }
}


String howMuchOfCircle1IsInCircle2(Circle circle1, Circle circle2) {
  float percent = percentOfCircle1InCircle2(circle1, circle2);
  String relation;
  if (percent == 0) {
    relation = "No";
  } else if (percent == 1) {
    relation = "All";
  } else {
    relation = "Some";
  }
  return relation;
}
