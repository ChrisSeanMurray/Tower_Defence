class Wave
{
  float speed;
  int spawnNo;
  int lives;

  Wave(String line)
  {
    String[] parts = line.split("\t");

    spawnNo = Integer.parseInt(parts[0]);
    lives = Integer.parseInt(parts[1]);
    speed = Float.parseFloat(parts[2]);
  }

//method to load creeps, it's inside the wave class as the control fields get loaded into instances of the wave class
//from a txt file
  void loadCreep()
  {
    int r = 15;

    float x = map.get(0).pos.x;
    float y = map.get(0).pos.y;

    Creep creep = new Creep(x, y, speed, lives, r);
    gameObjects.add(creep);
    creeps.add(creep);
  }
}