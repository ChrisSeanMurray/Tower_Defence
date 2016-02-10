import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

AudioPlayer popSound;
Minim minim;

void setup()
{
  minim = new Minim(this);  

  popSound = minim.loadFile("bop.wav");

  size(800, 500);
  loadMap();
  loadWave();
  frame = 0;
  count = 0;
  creator = new Tower(width - width/20, height/10, 10, 0);
  gameObjects.add(creator);
  life =  50;
  score = 0;
  money = 300;
  play = true;
  createTower = false;
  towerCreateDelay = 0;
  waveTimer = 330;
  pause = false;
  waveCount = 0;
  timeBetween = 0;
}

//arraylist to keep track of all game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
//arraylist for keeping track of all map points
ArrayList<MapPoint> map = new ArrayList<MapPoint>();
ArrayList<Creep> creeps = new ArrayList<Creep>();
ArrayList<Wave> waves = new ArrayList<Wave>();
boolean[] keys = new boolean[526];

Tower creator;
int frame;
int count;
int score, life, money;
boolean play, pause;
color mouse;
boolean createTower;
int towerCreateDelay;
int waveTimer, waveCount;
int timeBetween;


void draw()
{
  //towerCreateDelay is something I added to stop the tower from immediateley being placed onto the creator tower unintentionally
  towerCreateDelay++;
  int creepCount = 0;

  background(0);

  if (play)
  {

    loadPath();

    stroke(255);
    float lineX = width-width/10;
    line(lineX, 0, lineX, height);
    fill(255, 0, 255);
    textSize(10);
    textAlign(BOTTOM, CENTER);
    text("Lives : "+ life, width/2, 10);
    text("Score : "+score, width/2, 20);
    text("Money : €"+money, width/2, 30);
    textAlign(CENTER);
    text("Costs €150 ", creator.pos.x, creator.pos.y-creator.radius*2);

    if (waveTimer > 0)
    {
      fill(0, 0, 255);
      textSize(50);
      text("WAVE INCOMING IN " + waveTimer/60, width/2, height/2);
    }


    //temporary function to load multiple creeps
    if (frame>=30  && count < waves.get(waveCount).spawnNo && waveTimer <=0 && !pause)
    {
      waves.get(waveCount).loadCreep();
      frame = 0;
      count++;
    }
    for (int i = gameObjects.size() - 1; i >= 0; i --)
    {
      GameObject go = gameObjects.get(i);
      if (!pause)
      {
        go.update();
      }
      go.render();
      if (go instanceof Creep)
      {
        creepCount++;
      }
    }
    frame++;
    trackCol();

    //draws a represantative of a tower so the player can tell where it is they will be placing the tower
    if (createTower)
    {
      noFill();
      stroke(#A403FC);
      ellipse(mouseX, mouseY, 20, 20);
      ellipse(mouseX, mouseY, 150, 150);
    }
    if (!pause && keys['P'])
    {
      pause = true;
    }
    if (pause)
    {
      textSize(50);
      text("PRESS SPACE BAR TO RESUME", width/2, height/2);
      if (keys[' '])
      {
        pause = false;
      }
    }

    //the following statement handles whether to advance onto the next wave or not
    if (count >= waves.get(waveCount).spawnNo - 1 && creepCount == 0 && waveCount < waves.size()-1 && life > 0)
    {
      waveCount++;
      waveTimer = 330;
      count = 0;
    }
  }
  if (waveCount > waves.size()-1 && creepCount <= 0 && life > 0)
  {
    textSize(70);
    text("You Win, Congrats", width/2, height/2);
  }
  if (life <= 0)
  {
    play = false;
    textSize(70);
    text("You Lose, Press 'R' to restart", width/2, height/2);
  }
  if (!play)
  {
    if (keys['R'])
    {
      waveCount = 0;
      waveTimer = 0;
      life = 50;
      for (int i = gameObjects.size() - 1; i >= 0; i --)
      {
        GameObject go = gameObjects.get(i);
        if (go instanceof Tower)
        {
          gameObjects.remove(go);
        }
      }
      creator = new Tower(width - width/20, height/10, 10, 0);
      gameObjects.add(creator);
      play = true;
    }
  }

  waveTimer--;
}


//Loads co-ordinates from a .txt file and creates new map points with them
void loadMap()
{
  String[] lines = loadStrings("Map1.txt");

  for (int i = 0; i <lines.length; i++)
  {
    MapPoint point = new MapPoint(lines[i]);
    map.add(point);
  }
}

//Method for creating new instances of tower
void loadTower(float x, float y, float r, float range)
{
  GameObject tower = new Tower(x, y, r, range);
  gameObjects.add(tower);
  money -= 150;
}


//This method is udes to detect collisions between creeps and projectiles,
//also to determin if a creep makes it to the end
void trackCol()
{
  for (int i = gameObjects.size() - 1; i >= 0; i --)
  {
    GameObject go = gameObjects.get(i);
    if (go instanceof Creep)
    {
      for (int j = gameObjects.size() - 1; j >= 0; j --)
      {
        GameObject other = gameObjects.get(j);

        if (other instanceof Projectile) // Check the type of a object
        {
          if (go.pos.dist(other.pos) < go.radius + other.radius)
          {
            ((Creep)go).life-=  ((Projectile)other).damage;
            ((Projectile)other).life--;
            score += 10;
            money += 3;
          }
        }
      }
    }
  }

  for (int i = creeps.size() - 1; i >= 0; i--)
  {
    Creep cr = creeps.get(i);
    if (cr.pos.dist(map.get(map.size() - 1).pos) < 5)
    {
      life--;
      creeps.remove(cr);
    }
  }
}

void keyPressed()
{ 
  keys[keyCode] = true;
}

void keyReleased()
{
  keys[keyCode] = false;
}


//This method is to create a visual representation of the path the creeps follow
void loadPath()
{
  color c3 = #A7A6A6;
  float theta1, theta2;
  float x1, x2, x3, x4;
  float y1, y2, y3, y4;

  for (int i = 0; i< map.size()-1; i++)
  {
    //I need to calculate theta1 and theta2 in order to calculate the relevant points for plotting a quad

    //theta1 will be the angle between point i and the next point in the list
    theta1 =atan2(map.get(i+1).pos.y - map.get(i).pos.y, map.get(i+1).pos.x - map.get(i).pos.x);
    theta1 += HALF_PI;
    if (theta1 < 0)
    {
      theta1 = map(theta1, -PI, 0, PI, TWO_PI);
    }
    //theta2 will be the oppisite angle to theta1 so 
    theta2 = theta1-PI;


    x1 = ((map.get(i).radius/2) * cos(theta1)) + map.get(i).pos.x;
    x2 = ((map.get(i).radius/2) * cos(theta1-PI)) + map.get(i).pos.x;
    y1 = ((map.get(i).radius/2) * sin(theta1)) + map.get(i).pos.y;
    y2 = ((map.get(i).radius/2) * sin(theta1-PI)) + map.get(i).pos.y;

    x3 = ((map.get(i+1).radius/2) * cos(theta2)) + map.get(i+1).pos.x;
    x4 = ((map.get(i+1).radius/2) * cos(theta2-PI)) + map.get(i+1).pos.x;
    y3 = ((map.get(i+1).radius/2) * sin(theta2)) + map.get(i+1).pos.y;
    y4 = ((map.get(i+1).radius/2) * sin(theta2-PI)) + map.get(i+1).pos.y;

    fill(c3);
    stroke(c3);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);

    //checking to see if this is the first point, if it is set the color to green to visually show it's the first point
    if (i == 0)
    {
      color c1 = color(0, 255, 0);
      map.get(i).c = c1;
    } else //if it's not the first point set the color to be the same color as the path
    {
      color c1 = c3;
      map.get(i).c = c1;
    }
    map.get(i).render();
  }

  //setting the color for the end point and also calling the render for the last point
  color c2 = color(255, 0, 0);
  map.get(map.size()-1).c = c2;
  map.get(map.size()-1).render();
}


void mouseClicked()
{
  //this if statement determines if the mouse is contained within the tower creator
  //when clicked, if it is it toggles the tower create mode so the player can now place a tower on the map
  if (mouseX >= creator.pos.x-creator.radius && mouseX <= creator.pos.x+creator.radius
    && mouseY >= creator.pos.y-creator.radius && mouseY<= creator.pos.y+creator.radius
    && money >= 150)
  {
    createTower = true;
    towerCreateDelay = 0;
  }
  //if tower create mode is toggled true then the player can place a tower on the map
  //when mouse is clicked and will place the tower at the mouses current coordinates
  if (createTower && towerCreateDelay > 20)
  {
    loadTower(mouseX, mouseY, 10, 150);
    createTower = false;
  }
}


//Loads data from a txt file, creates new instances of the wave class which handles creep generation based on the information from the txt file
void loadWave()
{
  String[] lines = loadStrings("wave.txt");

  for (int i = 0; i <lines.length; i++)
  {
    Wave wave = new Wave(lines[i]);
    waves.add(wave);
  }
}