/*
THE VERY HUNGRY CATERPILLAR PROCESSING ANIMATION AND GAME
              BY NEIL O CARROLL
                  10/04/2015
                  
                  
               1   MOVE THE CATERPILLAR WITH THE MOUSE
                  
               2   LEFT CLICK TO EAT FOOD WHEN HEAD IS NEAR OR ON FOOD IMAGE
                  
               3   GROW BIGGER
               
               4   TRANSFORM INTO A BEAUTIFUL BUTTERFLY



Interaction: 1D TRANSFORMATION (X-AXIS):          MOUSE POSITION (LEFT AND RIGHT) WHEN CATERPILLAR (Moves character along x-axis and switches images based on direction of movement)
             
             ANIMATION:                           LEFT CLICK TO EAT FOOD (switches image sprites and plays audio)
             
             2D TRANSFORMATION (X/Y-AXIS):        MOUSE POSITION (UP DOWN LEFT RIGHT) WHEN BUTTERFLY (Moves character along x and y-axis)
             
             COLOUR (BUTTERFLY MODE):             X + Y MOUSE POSITION DETERMINES RED COLOUR VALUES OF PSEUDO-RANDOM FLASHING BACKGROUND IMAGE COLOUR
             
             2D TRANSFORMATION (BUTTERFLY MODE):  THE GENERAL LOCATION OF CIRCLES DRAWN IN BACKGROUND IS DETERMINED BY MOUSE X and MOUSE Y POSITION
                                                  
             SCALE:                               CHARACTER GROWS BIGGER WITH EACH FOOD EATEN
             
             IMAGE FILTER A:                      IN BUTTERFLY MODE THE CHARACTER IMAGE COLOURS INVERT WHEN MOUSE IS PRESSED
             
             IMAGE FILTER B:                      IN BUTTERFLY MODE THE BACKGROUND IS FILTERED GRAYSCALE WHEN MOUSE IS PRESSED
                                                   
                                                   
             


*/

//import audio player
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioInput input;
//declare glabal variables
PImage bg;
PImage img;
PImage character;

float imageRotation;

int k = 0;
int foodx = 300;
int foody = 250;


float headx = 40;
float heady = 100;

float s = 1;

float x = 700;
float y = 300;
float easing = 0.05;

float targetX;
float dx;
float colx;

float targetY;
float dy;

boolean onTarget = false;
String foodText = "images/melon";
int newGame = 0;

//setup canvas, images and audio
void setup() {
  
  size(1155, 746);
  
  bg = loadImage("images/leaf.jpeg");
  character = loadImage("images/rightBug.png");
  img = loadImage(foodText + k + ".png");
  
  minim = new Minim(this);
  player = minim.loadFile("audio/bite.wav");
  input = minim.getLineIn();
  
}



void draw() {  
  //get mouse position and move caterpillar to location if not already there
  targetX = mouseX;
  targetY = mouseY;
  //gets range of distance between caterpillar and mouse
  dx = targetX - x;
  dy = targetY - y;
  //gets range of distance between the caterpillar's head and the food  
  colx = (headx+x) - foodx;
  
  //function to check where to move the caterpillar on x axis
  if( abs(dx) > 1) {
    x += dx * easing;
    if((dx > 0) && (newGame < 3)){
      
      //face caterpillar right if difference is positive
      character = loadImage("images/rightBug.png");
      headx = 220;
      heady = 100; 
    }
    else if((dx < 0)  && (newGame < 3)){
      //face caterpillar left if difference is negative
      character = loadImage("images/leftBug.png");
      headx = 40;
      heady = 100; 
    }
  }
  
  //check and move on y axis if the character is a butterfly (after third food is eaten)
  if(newGame == 3){
    if(abs(dy) > 1) {
    y += dy * easing;
    }
  }
  
  //if the collision variable is within this range, the caterpillar is on target and can eat the food
  if( (colx <= 100) && (colx >=-12)){
    onTarget = true;
    
  }
  
  else{
    onTarget = false;
  }
  
  
  
  
  //draw background as leaf while character is a caterpillar but randomise color while butterfly
  if(newGame < 3){
      background(bg);
  }
  else{
    //go crazy with colours and circles
    background(mouseX/2 + mouseY/2, random(255), 155);
    
    float r = random(600);
    float colorG = random(255);
    float colorB = random(255);
    
    
    
    noStroke();
    fill(mouseX/2 + mouseY/2, colorG, colorB);
    ellipse(random(700),mouseY, r, r);
    
    fill(mouseX/2 + mouseY/2, colorG, colorB);
    ellipse(mouseX,random(700), r, r);
    
    fill(mouseX/2 + mouseY/2, colorG, colorB);
    ellipse(random(700),random(700), r, r);
    ellipse(random(700),random(700), r, r);
    ellipse(random(700),random(700), r, r);
  }
  
  //draw food image
 
  image(img, foodx , foody, img.width, img.height);
   
   
    
  if(newGame == 3){
    imageMode(CENTER);
    
    if(mousePressed){
    filter(GRAY);
    }
    
    
  }
  //draw character image
 
  image(character, x , y, character.width*s, character.height*s);
  
  //allow image filter if in butterfly mode
  if(mousePressed && (newGame == 3) ){
    filter(INVERT);
    }
  
  //draw invisible circle over head of character to determine location of eating target
  noStroke();
  fill(255,0,0,0);
  ellipse(x + headx, y + heady,60, 60);
  
  
  
  
}

//handle click events: eating animation and sound
void mouseClicked() {
  
  if(onTarget==true){
    player.play();
    player = minim.loadFile("audio/bite.wav");
  
    //k stores the current image sprite
    k++;
    if (k < 5){
      img = loadImage(foodText + k +".png");
    }
    //last bite of food changes image and resets some variables
    else if(k==5){
      img = loadImage("images/noFood.png");
      k = 0;
      newGame ++;
      //second food is cupcake
      if(newGame == 1){
        s = 1.2;
        foodx = 800;
        foody = 270;
        foodText = "images/cupcake";
        img = loadImage(foodText + k +".png");
        image(img, foodx , foody, img.width, img.height);
      }
      //third food is cheese
      if(newGame == 2){
        s = 1.4;
        foodx = 200;
        foody = 290;
        foodText = "images/cheese";
        img = loadImage(foodText + k +".png");
        image(img, foodx , foody, img.width, img.height);
      }
      //after third food is eaten, caterpillar becomes butterfly and audio file changes
      if(newGame == 3){
        character = loadImage("images/butterfly.png");
        player = minim.loadFile("audio/test.wav");
        player.play(); 
      }
    }
      
  }
  
}







