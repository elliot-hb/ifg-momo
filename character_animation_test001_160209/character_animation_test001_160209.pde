// character animation test
// 13.02.2016 Noriyuki
//blablabla

//Änderung 16.44 Uhr
//Änderung 16.48 Uhr
//Änderung Lena
//

/////////player
float playerX; // position of playerX
float playerY; // position of playerY
color pC; // color of player


float VX; //speed along x-axis
float VY; //speed along y-axis
float aX; //acceleration along x-axis

float gravity=0.5; // define gravity
int floorHeight; // define the height of the floor


/////////clock
int cX;
int cY;
float cS;
PImage clock;





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
ArrayList <GreyMan> greyMans=new ArrayList<GreyMan>();


void setup() {
  size(800, 500 );
  smooth();
  noStroke();
  imageMode(CENTER);
  playerPhase=0; // initialize the playerPhase

  // initialize the clock position
  cX=width/2;
  cY=150;

  floorHeight=height-25;
  playerX=width/2; // initialize the player X position
  playerY=floorHeight-25; // player-??.png's height is 50px and 50/2=25
  playerImgs=loadImages("images/player-??.png");
  clock=loadImage("clock_001.png");

  // instantiation of the ArrayList of the enemy
  for (int i=0; i<3; i++) {
    greyMans.add(new GreyMan(random(width/2+100, width), 40, color(100)));
  }
}


void draw() {
  background(255);

  //draw floor
  fill(120, 255, 180);
  rect(0, floorHeight, width, height-floorHeight);

  // draw clock
  clock();

  // move enemy
  for (int i=0; i<greyMans.size(); i++) {
    greyMans.get(0).move(playerX, 0.008);
    greyMans.get(1).move(playerX, 0.005);
    greyMans.get(2).move(playerX, 0.003);
  }
  // draw enemy
  for (int i=0; i<greyMans.size(); i++) {
    greyMans.get(i).drawEnemy();
  }

  movePlayer(); // move the player

  // define colision, and in this moment change the playerPhase
  for (int i=0; i<greyMans.size(); i++) {
    greyMans.get(i).eColision();
    if (greyMans.get(i).pColision()==true) {
      fill(255, 100, 100);
      text("scheisse", 15, 50);
      playerPhase=9;
    }
  }

  image(playerImgs.get(playerPhase), playerX, playerY); // depict the player

  /* during the colision, add the white color to the player,
   and change the direction of the clock*/
  for (int i=0; i<greyMans.size(); i++) {
    greyMans.get(i).eColision();
    if (greyMans.get(i).pColision()==true) {
      // add white to player
      fill(255, 70);
      ellipse(playerX, playerY, 52, 52);

      // change the direction and color of the clock
      cS-=1;
      fill(255, 255, 100, 45);
      ellipse(cX, cY, 200, 200);
    }
  }

  // added informations
  println("VX:"+VX);
  println("VY:"+VY);
  println("aX:"+aX);

  fill(100);
  textSize(20);
  text("push arrow buttons", 15, 25);
}