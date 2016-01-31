void setup()
{
  size(800, 500);
  loadMap();
  frame = 0;
  count = 0;
  loadTower();
  life =  50;
  score = 0;
}

//arraylist to keep track of all game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
//arraylist for keeping track of all map points
ArrayList<MapPoint> map = new ArrayList<MapPoint>();
ArrayList<Creep> creeps = new ArrayList<Creep>();

int frame;
int count;
int life;
int score;

void draw()
{
  background(0);
  fill(255,255,0);
  textAlign(BOTTOM,CENTER);
  text("Lives : "+ life, width/2,10);
  text("Score : "+score, width/2,20);
  

  //this is in temporarily to help me debug
  for (int i = map.size() - 1; i >= 0; i --)
  {
    MapPoint m = map.get(i);
    m.update();
    m.render();
  }

  //temporary function to load multiple creeps
  if (frame>=30  && count < 50)
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
  println(score);
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
  float speed = 3.0f;
  int r = 10;

  x = map.get(0).pos.x;
  y = map.get(0).pos.y;

  Creep creep = new Creep(x, y, speed, life, r);
  gameObjects.add(creep);
  creeps.add(creep);
}

void loadTower()
{
  float x = 100;
  float y = 100;
  int r = 10;
  float range = 150;

  Tower tower = new Tower(x, y, r, range);
  gameObjects.add(tower);
}

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