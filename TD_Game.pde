void setup()
{
  size(800, 500);
  loadMap();
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
}

//arraylist to keep track of all game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
//arraylist for keeping track of all map points
ArrayList<MapPoint> map = new ArrayList<MapPoint>();
ArrayList<Creep> creeps = new ArrayList<Creep>();
boolean[] keys = new boolean[526];

Tower creator;
int frame;
int count;
int score, life, money;
boolean play;
color mouse;
boolean createTower;
int towerCreateDelay;
int waveTimer;


void draw()
{
  //towerCreateDelay is something I added to stop the tower from immediateley being placed onto the creator tower unintentionally
  towerCreateDelay++;
  
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
    text("Costs €150 ", creator.pos.x, creator.pos.y-creator.radius);
    
    if (waveTimer > 0)
    {
      fill(0, 0, 255);
      textSize(50);
      text("WAVE INCOMING IN " + waveTimer/60, width/2, height/2);
    }


    //temporary function to load multiple creeps
    if (frame>=30  && count < 50 && waveTimer <=0)
    {
      loadCreep();
      frame = 0;
      count++;
    }
    for (int i = gameObjects.size() - 1; i >= 0; i --)
    {
      GameObject go = gameObjects.get(i);
      go.update();

      go.render();
    }
    frame++;
    trackCol();
    
    //draws a represantative of a tower so the player can tell where it is they will be placing the tower
    if (createTower)
    {
      noFill();
      stroke(#A403FC);
      line(mouseX- 10, mouseY +10, mouseX, mouseY - 10);
      line(mouseX, mouseY- 10, mouseX + 10, mouseY + 10);
      line(mouseX +10, mouseY +10, mouseX, mouseY);
      line(mouseX- 10, mouseY +10, mouseX, mouseY);
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

//loads creeps
void loadCreep()
{
  float x;
  float y;
  int life = 1;
  float speed = 1.0f;
  int r = 10;

  x = map.get(0).pos.x;
  y = map.get(0).pos.y;

  Creep creep = new Creep(x, y, speed, life, r);
  gameObjects.add(creep);
  creeps.add(creep);
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
            ((Creep)go).life --;
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
  color c3 = color(255);
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
  if (mouseX >= creator.pos.x-creator.radius/2 && mouseX <= creator.pos.x+creator.radius/2
    && mouseY >= creator.pos.y-creator.radius/2 && mouseY<= creator.pos.y+creator.radius/2
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