class Creep extends GameObject
{
  int life;
  int progress;
  PVector temp;
  Creep()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

  Creep(float x, float y, float speed, int life, int radius)
  {
    pos.x = x;
    pos.y = y;
    this.speed = speed;
    this.radius = radius;
    this.life = life;
    progress = 0;
  }

  void render()
  {
    temp = pos.sub( map.get(1).pos);
    pushMatrix();
    translate(pos.x, pos.y);
    theta = PVector.angleBetween(pos, map.get(1).pos);
    println(theta);
    if (theta < 0)
    {
      theta = map(theta, -PI, 0, PI, TWO_PI);
    }
    pos.rotate(theta);
    stroke(125);
    fill(125);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }

  void update()
  {
    forward.x = sin(theta);
    forward.y = - cos(theta); 
    pos.add(PVector.mult(forward, speed));
    line(pos.x, pos.y, map.get(1).pos.x, map.get(1).pos.y);
  }

  float calT(int place)
  {
    float coords;
    coords = atan2(map.get(place).pos.y - pos.y,map.get(place).pos.x - pos.x);
    if (theta < 0)
    {
      theta = map(coords, -PI, 0, PI, TWO_PI);
    }


    return coords;
  }
}