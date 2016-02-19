void movePlayer() {
  playerVX+=playeraX;
  playerX+=playerVX;

  // limitation of speed 
  if (4<playerVX) {
    playerVX=4;
  }
  if (playerVX<-4) {
    playerVX=-4;
  }

  // define acceleration
  if (!keyPressed) {
    if (1<abs(playerVX)) {
      playerVX*=0.9;
    } else {
      playerVX=0;
    }
  }

  if (keyPressed && keyCode==LEFT ) {
    if (0<playerVX && playeraX==0) {
      playeraX=1; //slowly stop
    } else {
      playeraX=-2; // accelate speed
    }
  }
  if (keyPressed && keyCode==RIGHT ) {
    if (playerVX<0 && playeraX==0) {
      playeraX=-1; // slow stop
    } else {
      playeraX=2; // accelate speed
    }
  }

  // constrain the field of player
  //if (playerX<screenLeftX) {
  //  playerX=25;
  //  playerVX=0;
  //} else if (playerX>width-25) {
  //  playerX=width-25;
  //  playerVX=0;
  //}

  playerVY+=gravity*1.3;
  playerY+=playerVY;

  // constrain y-playeraXis field of player
  //if (playerY>floorHeight-25) {
  //playerY=floorHeight-25;
  //playerVY=0;
  //}

  if (keyPressed && keyCode==UP &&  playerVY==0) {
    playerVY=-6;
  }



  // dipict player
  if (playerVX>0 && playerVY==0 ) {
    playerPhase=1;
  } else if (playerVX<0 && playerVY==0) {
    playerPhase=2;
  }

  if (playerVX==0 && playeraX==0 && playerVY<0 ) {
    playerPhase=3;
  } else if (playerVX==0 && playeraX==0 && playerVY>0) {
    playerPhase=4;
  }

  if (playerVX>0 && playerVY<0 ) {
    playerPhase=5;
  } else if (playerVX<0 && playerVY>0) {
    playerPhase=6;
  }

  if (playerVX>0 && playerVY>0 ) {
    playerPhase=7;
  } else if (playerVX<0 && playerVY<0) {
    playerPhase=8;
  }

  if (!keyPressed && playerVX==0 && playeraX==0 && playerVY==0) {
    playerPhase=0;
  }
  
  //collision with enemy
    for (int i=0; i<3; i++) {
 if(dist(playerX, playerY, gX[i], gY[i])<gDiameter) playerPhase=9;
  }
}

void keyReleased() {
  playeraX = 0;
}