Map map;
//// Position of player center in level coordinates
//float playerX, playerY;
//// Velocity of player
//float playerVX, playerVY;
//// Speed at which the player moves
//float playerSpeed = 150;
//// The player is a circle and this is its radius
float playerR = 28;

float playerX; // position of playerX
float playerY; // position of playerY
color pC; // color of player

float cS;

float playerVX; //speed along x-axis
float playerVY; //speed along y-axis
float playeraX; //acceleration along x-axis

float gravity=0.5; // define gravity
float floorHeight;

float gX; //enemyX
float gVX = -2; //enemy velocity on x axis
float gY; //enemyY
int gDiameter=28; //enemy diameter
color gC; // enemy color

//counts the flowers, to set when win
int counter;

// Whether to illustrate special functions of class Map
boolean showSpecialFunctions=false;

// left / top border of the screen in map coordinates
// used for scrolling
float screenLeftX, screenTopY;

float time;
int GAMEWAIT=0, GAMERUNNING=1, GAMEOVER=2, GAMEWON=3;
int gameState;

PImage backgroundImg;
PImage P;

////declare classes
//GreyMan myGreyMen;

///////// Loads a set of numbered images ///////////////
// filenames is a relative filename with TWO 00s
// e.g. images/fox-00.png. The function then tries
// to load images/fox-00.png, images/fox-01.png, ..
// as long as these files exist.
ArrayList<PImage> loadImages (String filePattern) {
  // Count number of question marks
  String qmString="";
  while (filePattern.indexOf (qmString+"?")>=0) qmString += "?";
  // The largest sequence of question marks is qmString
  ArrayList<PImage> images = new ArrayList<PImage>();
  int ctr=0;
  do {
    String fname = filePattern.replace(qmString, nf(ctr, qmString.length()));
    InputStream input = createInput(fname);
    if (input==null) break; 
    PImage img = loadImage (fname);
    if (img==null) break;
    images.add(img);
    ctr++;
  } while (true); 
  return images;
}

// Images of the player animation for different phases
ArrayList<PImage> playerImgs;
// phase of the animation (see finite state machine in slides)
int playerPhase;
//////////////////////////////////////////////

//Enemy Grey man, define the ArrayList

void setup() {
  size( 1000, 780 );
  backgroundImg = loadImage ("images/background.png"); // load the backgroundimage
  playerImgs=loadImages("images/player-??.png");
  //floorHeight=height;

  newGame ();


  //// instantiation of the ArrayList of the enemy
  //for (int i=0; i<3; i++) {
  //  greyMans.add(new GreyMan(random(width/2+100, width), floorHeight-20, 40, color(100)));
  //}
}

void newGame () {
  map = new Map( "demo.map");
  for ( int x = 0; x < map.w; ++x ) {
    for ( int y = 0; y < map.h; ++y ) {
      // put player at 'S' tile and replace with 'F'  
      if ( map.at(x, y) == 'S' ) {
        playerX = map.centerXOfTile (x);
        playerY= map.centerYOfTile (y);
        map.set(x, y, 'F');
      }

      if ( map.at(x, y) == 'H' ) {
        gX = map.centerXOfTile (x);
        gY = map.centerYOfTile (y);
        map.set(x, y, 'F');
      }
    }
  }
  time=0;
  counter=0;
  //playerX=0;
  playerVX = 0;
  playerVY = 0;
  gravity=0;
  gameState = GAMEWAIT;
}

//void keyPressed() {
//  if ( keyCode == UP) {
//    playerVY=-200.0;
//  }
//  if ( keyCode == LEFT ) {
//    playerVX = -playerSpeed;
//  }
//  if ( keyCode == RIGHT ) {
//    playerVX = playerSpeed;
//  } else if ( keyCode == 'S' ) showSpecialFunctions = !showSpecialFunctions;
//}


void updatePlayer() {
  // update player
  gravity=0.5;
  float nextX = playerX + playerVX, 
    nextY = playerY + playerVY;

  //collision bottom-half of player with top of walls
  if ( map.testTileInRect(nextX-playerR, nextY, 2*playerR, playerR, "W" )) {
    playerVX = 0;
    playerVY = 0;
    nextX = playerX;
    nextY = playerY;
    gravity=0;
  }

  //debugging part if hanging with the butt in the wall
  if (keyPressed && keyCode == UP  && map.testTileInRect(nextX-playerR, nextY, 2*playerR, playerR, "W" )) {
    playerY= playerY-5;
    playerVX = 0;
    playerVY = 0;
    nextX = playerX;
    nextY = playerY;
    gravity=0;
  }

  //collision upper-half of player with bottom of walls
  if ( map.testTileInRect( nextX-playerR, nextY-playerR, 2*playerR, playerR, "W" )) {
    playerY = playerY+1;
    playerVX = -playerVX;
    playerVY = -playerVY;
    nextX = playerX;
    nextY = playerY;
    gravity=0;
  }

  //collision left-upper-corner of player with left side of walls
  if ( map.testTileInRect(nextX-playerR, nextY-playerR, playerR, playerR, "W" )) {
    playerX = playerX+10;
    playerVX = -playerVX;
    playerVY = -playerVY;
    nextX = playerX;
    nextY = playerY;
    gravity=0;
  }

  //collision right-upper-corner of player with right side of walls
  if ( map.testTileInRect(nextX, nextY-playerR, playerR, playerR, "W" )) {
    playerX = playerX-10;
    playerVX = -playerVX;
    playerVY = -playerVY;
    nextX = playerX;
    nextY = playerY;
    gravity=0;
  }

Map.TileReference tile =map.findTileInRect(nextX-playerR, nextY-playerR, 2*playerR, 2*playerR, "P");
if (tile!=null) {
  //levitationTimer=5;
  map.set(tile.x, tile.y, 'F');
  counter+=1;
}



  playerX = nextX;
  playerY = nextY;
}

// Maps x to an output y = map(x,xRef,yRef,factor), such that
//     - x0 is mapped to y0
//     - increasing x by 1 increases y by factor
float map (float x, float xRef, float yRef, float factor) {
  return factor*(x-xRef)+yRef;
}

void updateEnemy() {
    float nextgX = gX + gVX;

  //collision left-upper-corner of enemy with left side of walls
  if ( map.testTileInRect(nextgX-14, gY-14, gDiameter/2, gDiameter, "W" )) {
    gVX = 2;
    nextgX = gX;
  }

  //collision right-upper-corner of player with right side of walls
  if ( map.testTileInRect(nextgX+14, gY-14, gDiameter/2, gDiameter, "W" )) {
    gVX = -2;
    nextgX = gX;
  }


  gX = nextgX;
}


void drawBackground() {
  // Explanation to the computation of x and y:
  // If screenLeftX increases by 1, i.e. the main level moves 1 to the left on screen,
  // we want the background map to move 0.5 to the left, i.e. x decrease by 0.5
  // Further, imagine the center of the screen (width/2) corresponds to the center of the level
  // (map.widthPixel), i.e. screenLeftX=map.widthPixel()/2-width/2. Then we want
  // the center of the background image (backgroundImg.width/2) also correspond to the screen
  // center (width/2), i.e. x=-backgroundImg.width/2+width/2.
  float x = map (screenLeftX, map.widthPixel()/2-width/2, -backgroundImg.width/2+width/2, -0.5);
  float y = map (screenTopY, map.heightPixel()/2-height/2, -backgroundImg.height/2+height/2, -0.5);
  image (backgroundImg, x, y);
}


void drawMap() {   
  // The left border of the screen is at screenLeftX in map coordinates
  // so we draw the left border of the map at -screenLeftX in screen coordinates
  // Same for screenTopY.
  map.draw( -screenLeftX, -screenTopY );
}


void drawPlayer() {
  // draw player
  noStroke();
  //fill(0, 255, 255);
  imageMode(CENTER);
  image(playerImgs.get(playerPhase), playerX- screenLeftX, playerY - screenTopY); // depict the player
  fill(gC);
  ellipse(gX-screenLeftX, gY - screenTopY, gDiameter, gDiameter);

  //ellipse( playerX - screenLeftX, playerY - screenTopY, 2*playerR, 2*playerR );

  // understanding this is optional, skip at first sight
  if (showSpecialFunctions) {
    // draw a line to the next hole   
    Map.TileReference nextHole = map.findClosestTileInRect (playerX-100, playerY-100, 200, 200, "H");
    stroke(255, 0, 255);
    if (nextHole!=null) line (playerX-screenLeftX, playerY-screenTopY, 
      nextHole.centerX-screenLeftX, nextHole.centerY-screenTopY);

}
}

void drawText() { 
  textAlign(CENTER, CENTER);
  fill(0, 255, 0);  
  textSize(40);  
  if (gameState==GAMEWAIT) text ("collect 3 flowers, press space to start", width/2, height/2);
  else if (gameState==GAMEOVER) text ("game over", width/2, height/2);
  else if (gameState==GAMEWON) text ("won in "+ round(time) + " seconds", width/2, height/2);
}


void draw() {
  if (gameState==GAMERUNNING) {
    updatePlayer();
    updateEnemy();
    movePlayer();
  moveEnemy();
    time+=1/frameRate;
  } else if (keyPressed && key==' ') {
    if (gameState==GAMEWAIT) gameState=GAMERUNNING;
    else if (gameState==GAMEOVER || gameState==GAMEWON) newGame();
  }
  screenLeftX = playerX - width/2;
  screenTopY  = (map.heightPixel() - height)/2;

  drawBackground();
  drawMap();
  drawPlayer();
  drawText();
  
  //win when 3 flowers collected
  if (counter==3) gameState=GAMEWON;
  //lose when collision with enemy
 
  
  
 // clock
 //big pointer
  pushMatrix();
  translate(width/2-screenLeftX, height/2-25);
  rotate(radians(cS));
  stroke(0);
  strokeWeight(2);
  line(0, 0, 0, -35);
  noStroke();
  popMatrix();
//small pointer
  pushMatrix();
  translate(width/2-screenLeftX, height/2-25);
  rotate(radians(cS/12));
  stroke(0);
  strokeWeight(4);
  line(0, 0, 0, -20);
  noStroke();
  popMatrix(); 
  
  cS+=6/frameRate;
  
  //turn the clock the other way round when collision player and enemy
 if(dist(playerX, playerY, gX, gY)<gDiameter)  cS-=3;
 
 if (cS<=0) gameState=GAMEOVER ;
 
 
 println(cS);
  
}