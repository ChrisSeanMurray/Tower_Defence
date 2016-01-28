void setup()
{
  size(800,500);
  background(0);
  loadMap();
}

//arraylist to keep track of all game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();

void draw()
{
  for (int i = gameObjects.size() - 1; i >= 0; i --)
  {
    GameObject go = gameObjects.get(i);
    go.update();
    go.render();
  }
}

void loadMap()
{
  String[] lines = loadStrings("Map1.txt");
  
  for(int i = 0; i <lines.length; i++)
  {
    MapPoint point = new MapPoint(lines[i]);
    gameObjects.add(point);
  }
  
}