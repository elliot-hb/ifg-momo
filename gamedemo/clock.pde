 void drawClock() {
  //draw big pointer
  pushMatrix();
  translate(width/2-screenLeftX, height/2-25);
  rotate(radians(cS));
  stroke(0);
  strokeWeight(2);
  line(0, 0, 0, -35);
  noStroke();
  popMatrix();
  //draw small pointer
  pushMatrix();
  translate(width/2-screenLeftX, height/2-25);
  rotate(radians(cS/12));
  stroke(0);
  strokeWeight(4);
  line(0, 0, 0, -20);
  noStroke();
  popMatrix(); 

 if (gameState==GAMERUNNING) cS+=6/frameRate;

  //turn the clock the other way round when collision player and enemy

  for (int i = 0; i < gX.length; i++) {
    if (dist(playerX, playerY, gX[i], gY[i])<gDiameter)  cS-=3;
  }
  
 }