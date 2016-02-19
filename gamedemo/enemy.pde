//has to be a class 
class GreyMan {

void drawEnemy(/*here should be added arguments to indivdualize gX and gY for several enemies*/) {
  
    ellipse(gX-screenLeftX, gY - screenTopY, gDiameter, gDiameter);
}
void moveEnemy() {
   gX+=gVX;
}
}