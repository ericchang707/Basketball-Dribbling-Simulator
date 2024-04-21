class JSONEvent {
  
  int dribblingHeight;
  float dribblingSpeed;
  int dribblingX;
  int horizontalVelocity;


  String comment;
  
  public JSONEvent(JSONObject json) {
    
    this.dribblingHeight = json.getInt("dribblingHeight");
    this.dribblingSpeed = json.getFloat("dribblingSpeed");
    this.dribblingX = json.getInt("dribblingX");
     this.horizontalVelocity = json.getInt("horizontalVelocity");
    

   
  }
  
  public int getDribblingHeight() { return dribblingHeight; }
  public Float getDribblingSpeed()   { return dribblingSpeed; }
  public int getdribblingX()   { return dribblingX; }
   public int getHorizontalVelocity()   { return horizontalVelocity; }
 

  public String toString() {
      String output = "Current Dribbling Event: \n\n";
      output += "Dribbling Height:               " + getDribblingHeight() + "\n";
      output += "Dribbling Speed:                " + getDribblingSpeed() + "\n";
        output += "Horizontal Velocity:           " + getHorizontalVelocity() + "\n";
      output += "Dribbling X Position:                " + getdribblingX() + "\n";
    
      return output;
    }
}
