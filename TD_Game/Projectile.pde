class Projectile extends GameObject
{
  int life;
  int damage;
  float range;
  PVector start;

  Projectile(float x, float y, int life, int damage, int radius, float range, color c)
  {
    pos.x = x;
    pos.y = y;
    speed = 20.0f;
    this.radius = radius;
    this.life = life;
    this.range = range;
    start = new PVector(x, y);
    this.c = c;
  }

  void render()
  {
    pushMatrix();
    stroke(c);
    fill(c);
    translate(pos.x, pos.y);
    rotate(theta);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }

  void update()
  {
    forward.x = sin(theta);
    forward.y = - cos(theta);

    forward.mult(speed);
    pos.add(forward);

    float dist = PVector.dist(pos, start);
    if (dist > range/2)
    {
      gameObjects.remove(this);
    }
    if (life <= 0)
    {
      gameObjects.remove(this);
    }
  }
}