//has to be a class 
class GreyMan {
  
  //constructor
  GreyMan(int ENEMYX, int ENEMYY, int GDIAMETER) {
    enemyX=ENEMYX;
    enemyY=ENEMYY;
    gDiameter=GDIAMETER;
  }

void drawEnemy(/*here should be added arguments to indivdualize gX and gY for several enemies*/) {
  for (int i=0; i<3; i++) {
    ellipse(200-screenLeftX, 200 - screenTopY, gDiameter, gDiameter);
}
}
void moveEnemy() {
  for (int i=0; i<3; i++) {
   gVX[i] = 2;
   gX[i]+=gVX[i];
}
}

}