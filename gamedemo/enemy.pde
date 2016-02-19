//has to be a class 
class GreyMan {

  //constructor
  GreyMan() {
    gDiameter=28;
    enemyX[0] = 200-screenLeftX;
    enemyY[0] = 200 - screenTopY ;
  }

  GreyMan(float posX, float posY, float VX) {
    gDiameter=28;
    enemyX[0] = posX;
    enemyY[0] = posY ;
    enemyVX[0] = VX;
  }

  void drawEnemy(/*here should be added arguments to indivdualize gX and gY for several enemies*/) {
    for (int i=0; i<3; i++) {
      ellipse(200-screenLeftX, 200 - screenTopY, gDiameter, gDiameter);
    }
  }
  void moveEnemy() {
    for (int i=0; i<3; i++) {
      enemyVX[i] = 2;
      enemyX[i]+=enemyVX[i];
    }
  }
}