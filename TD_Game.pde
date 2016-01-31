void setup()
{
  size(800, 500);
  loadMap();
  frame = 0;
  count = 0;
  loadTower();
}

//arraylist to keep track of all game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
//arraylist for keeping track of all map points
ArrayList<MapPoint> map = new ArrayList<MapPoint>();

int frame;
int count;

void draw()
{
  background(0);

  for (int i = gameObjects.size() - 1; i >= 0; i --)
  {
    GameObject go = gameObjects.get(i);
    go.update();
    go.render();
  }

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
  frame++;
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
  float speed = 5;
  int r = 10;

  x = map.get(0).pos.x;
  y = map.get(0).pos.y;

  Creep creep = new Creep(x, y, speed, life, r);
  gameObjects.add(creep);
}

void loadTower()
{
  float x = 100;
  float y = 100;
  int r = 10;
  float range = 150;

  Tower tower = new Tower(x,y,r, range);
  gameObjects.add(tower);
}