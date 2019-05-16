class Coordinate{
  float x;
  float y;
  
  Coordinate(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  float distance(Coordinate c){
    return dist(this.x, this.y, c.x, c.y);
  }
  
  boolean same(Coordinate c){
    return(this.x >= c.x - UNIT/4 && this.x <= c.x + UNIT/4 && this.y >= c.y - UNIT/4 && this.y <= c.y + UNIT/4);
  }
}
