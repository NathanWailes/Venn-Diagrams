class MenuButton {
  float xPos, yPos;
  float bWidth, bHeight;
  color bColor = color(0, 0, 100);
  
  MenuButton(float _xPos, float _yPos, float _bWidth, float _bHeight) {
    xPos = _xPos;
    yPos = _yPos;
    bWidth = _bWidth;
    bHeight = _bHeight;
  }
  
  void drawSelf() {
    noStroke();
    fill(bColor);
    rect(xPos, yPos, bWidth, bHeight);
  }
}

void drawGUI() {
  textFont(BaskOldFace);
  textSize(48);
  fill(255);
  float titleYPos = height/10;
  textAlign(CENTER);
  text("Venn Diagram Teacher", width / 2, titleYPos);
  textAlign(LEFT);
  
  listRelationsBetweenCircles(titleYPos);
  listGoals(titleYPos);
  drawTimer();
  mButton.drawSelf();
}

void drawMenu() {
  if (currentScreen == "In-Game") {

  } else if (currentScreen == "Main Menu") {
    
  }
}

void drawTimer() {
  int time = second();
  text("Timer: " + time, 0, height / 2);
}

void listGoals(float titleYPos) {
  textSize(24);
  color old_color = color(255);//save the old color to replace the fill later
  float yPosOfLastText = titleYPos;
  text("Goals:", width - 300, yPosOfLastText + 30);
  yPosOfLastText += 30;
  for (int i = 0; i < circles.length; i++) {
    for (int j = 0; j < circles.length; j++) {
      if (j == i) {
        continue; //don't compare a circle with itself
      } else {
        String relation = howMuchOfCircle1IsInCircle2(circles[i], circles[j]);
        if (goals[i] == relation) {
          fill(0, 150, 0);
        } else {
          fill(150, 0, 0);
        }
        String name1 = circles[i].name;
        String name2 = circles[j].name;
        String message = goals[i] + " " + name1 + " are " + name2 + ".";
        float x_offset = textWidth(message) + 5;
        text(message, width - x_offset, yPosOfLastText + 30);
        yPosOfLastText += 30;
      }
    }
  }
  fill(old_color);
}

void listRelationsBetweenCircles(float titleYPos) {
  textSize(24);
  fill(255);
  float yPosOfLastText = titleYPos;
  text("Current situation:", 5, yPosOfLastText + 30);
  yPosOfLastText += 30;
  for (int i = 0; i < circles.length; i++) {
    for (int j = 0; j < circles.length; j++) {
      if (j == i) {
        continue; //don't compare a circle with itself
      } else {
        String message = generateMessageBetween(circles[i], circles[j]);
        text(message, 5, yPosOfLastText + 30);
        yPosOfLastText += 30;
      }
    }
  }
}

String generateMessageBetween(Circle circle1, Circle circle2) {
  String relation = howMuchOfCircle1IsInCircle2(circle1, circle2);
  String name1 = circle1.name;
  String name2 = circle2.name;
  String message = relation + " " + name1 + " are " + name2 + ".";
  return message;
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
