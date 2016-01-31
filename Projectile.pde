class Projectile extends GameObject
{
  int life;

  Projectile()
  {
    speed = 50.0f;
    radius = 2;
    life = 1;
  }

  void render()
  {
    pushMatrix();
    stroke(255);
    noFill();
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

    if (pos.x < 0 || pos.y < 0 || pos.x > width || pos.y > height)
    {
      // Im dead!
      gameObjects.remove(this);
    }
    if (life <= 0)
    {
      gameObjects.remove(this);
    }
  }
}