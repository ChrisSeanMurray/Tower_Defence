class Creep extends GameObject
{
  int life;
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
  }
  
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    stroke(125);
    fill(125);
    ellipse(pos.x,pos.y,radius,radius);
    rotate(theta);
    popMatrix();
  }
  
  void update()
  {
  }
}