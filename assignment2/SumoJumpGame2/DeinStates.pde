// Jump state
class DeinStateJump extends State {
  SumoJumpPlayer player;

  DeinStateJump(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();

    // check nearest goal point
    float nearestGoalposX = goals.get(0).position.x;
    float nearestGoalposY = goals.get(0).position.y;
    for (int i=0; i<goals.size(); i++) {
      SumoJumpGoalMeasurement g = goals.get(i);
      if (nearestGoalposX > g.position.x) {
        nearestGoalposX = g.position.x;
      }
      if (nearestGoalposY > g.position.y) {
        nearestGoalposY = g.position.y;
      }
    }


    if (!proprio.onFloor) {
      for (SumoJumpGoalMeasurement g : goals) {
        if (g.position.x < 0) {
          println("state : WalkLeft");
          return "WalkLeft";
        }
        if (g.position.x > 0) { 
          println("state : WalkRight");
          return "WalkRight";
        }
      }
    }

    //for (SumoJumpGoalMeasurement g : goals) {
    //  for (SumoJumpPlatformMeasurement p : platforms) {
    //    if (g.position.y < 0 && proprio.onFloor) {
    //      println("state : WalkLeft");
    //      return "WalkLeft";
    //    } else if(g.position.y > 0 && proprio.onFloor) {
    //      println("state : WalkRight");
    //      return "WalkRight";
    //    }
    //  }
    //}
    return name;
  };

  public void action() {
    player.jumpUp(100);
  }
}


class DeinWalkLeft extends State {
  SumoJumpPlayer player;

  DeinWalkLeft(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    // check nearest goal point
    float nearestGoalposX = goals.get(0).position.x;
    float nearestGoalposY = goals.get(0).position.y;
    for (int i=0; i<goals.size(); i++) {
      SumoJumpGoalMeasurement g = goals.get(i);
      if (nearestGoalposX > g.position.x) {
        nearestGoalposX = g.position.x;
      }
      if (nearestGoalposY > g.position.y) {
        nearestGoalposY = g.position.y;
      }
    }

    if (nearestGoalposX > 0 ) {
      println("state : WalkRight");
      return "WalkRight";
    }

    for (SumoJumpGoalMeasurement g : goals) {
      if (g.position.y < 0 && proprio.onFloor) {
        println("state : Jump");
        return "Jump";
      }
    }
    return name;
  }

  public void action() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    for (SumoJumpPlatformMeasurement p : platforms) {
      if (p.left.x < 0 && p.right.x > 0) {
        player.moveSidewards(-40);
        //println("stop");
      }

      if (p.standingOnThisPlatform) {
      }
    }
    player.moveSidewards(-100);
  }
}

class DeinWalkRight extends State {
  SumoJumpPlayer player;

  DeinWalkRight(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    // check nearest goal point
    float nearestGoalposX = goals.get(0).position.x;
    float nearestGoalposY = goals.get(0).position.y;
    for (int i=0; i<goals.size(); i++) {
      SumoJumpGoalMeasurement g = goals.get(i);
      if (nearestGoalposX > g.position.x) {
        nearestGoalposX = g.position.x;
      }
      if (nearestGoalposY > g.position.y) {
        nearestGoalposY = g.position.y;
      }
    }
    
    if (nearestGoalposX > 0 ) {
      println("state : WalkRight");
      return "WalkRight";
    }
    
    for (SumoJumpGoalMeasurement g : goals) {
      if (g.position.y < 0 && proprio.onFloor) {
        println("state : Jump");
        return "Jump";
      }
    }
    return name;
  }

  public void action() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    for (SumoJumpPlatformMeasurement p : platforms) {
      if (p.left.x < 0 && p.right.x > 0) {
        player.moveSidewards(40);
        //println("stop");
      }

      if (p.standingOnThisPlatform) {
      }
    }
    player.moveSidewards(100);
  }
}






















class DeinAttractGoal extends State {
  SumoJumpPlayer player;

  DeinAttractGoal(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    return name;
  }

  public void action() {
    //player.moveSidewards(40);
  }
}



class DeinSeekOpponent extends State {
  SumoJumpGoal goal;
  SumoJumpPlayer player;
  float maxspeed = 40;
  float maxforce = -0.1;    // Maximum steering force

  DeinSeekOpponent(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    return name;
  };

  public void action() {
    ArrayList<SumoJumpOpponentMeasurement> opponents = player.senseOpponents();
    //player.moveSidewards(40);
    for (SumoJumpOpponentMeasurement o : opponents) {
      PVector desired = PVector.sub(o.position, new PVector(0, 0));
      desired.setMag(maxspeed);   
      player.moveSidewards(desired.x);
    }
  }
}

class DeinSeekGoal extends State {
  SumoJumpGoal goal;
  SumoJumpPlayer player;
  float maxspeed = 40;
  float maxforce = 6;    // Maximum steering force

  DeinSeekGoal(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    return name;
  };

  public void action() {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    //player.moveSidewards(40);
    for (SumoJumpGoalMeasurement g : goals) {
      PVector desired = PVector.sub(g.position, new PVector(0, 0));
      desired.setMag(maxspeed);   
      player.moveSidewards(desired.x);
    }
  }
}




//// ******************************************
//// State for walking to the right border

//class FoxStateWalkRight extends State {

//  Fox fox;                    // Reference to fox object (for getting the position)

//  FoxStateWalkRight(String name, Fox fox) {
//    super(name);
//    this.fox = fox;
//  }

//  public String transition() {
//    if (fox.getX() > width - 50)  // State transition when reaching right window border
//      return "WaitRight";
//    else
//      return name;
//  };

//  public void action() {
//    fox.move(fox.RIGHT);
//  };
//}


//// ******************************************
//// State for walking to the left border

//class FoxStateWalkLeft extends State {

//  Fox fox;                    // Reference to fox object (for getting the position)

//  FoxStateWalkLeft(String name, Fox fox) {
//    super(name);
//    this.fox = fox;
//  }

//  public String transition() {
//    if (fox.getX() < 25)       // State transition when reaching left window border
//      return "WaitLeft";
//    else
//      return name;
//  }

//  public void action() {
//    fox.move(fox.LEFT);
//  };
//}


//// ******************************************
//// State for waiting at the right border

//class FoxStateWaitRight extends State {

//  Fox fox;                    // Reference to fox object (for getting the position)

//  FoxStateWaitRight(String name, Fox fox) {
//    super(name);
//    this.fox = fox;
//  }

//  public String transition() {
//    if (millis() - timeOfActivation > 2000 )  // State transition when having waited for 2 seconds
//      return "WalkLeft";
//    else
//      return name;
//  }

//  public void action() {
//    fox.move(fox.STOP);
//  }
//}


//// ******************************************
//// State for waiting at the left border

//class FoxStateWaitLeft extends State {

//  Fox fox;                    // Reference to fox object (for getting the position)

//  FoxStateWaitLeft(String name, Fox fox) {
//    super(name);
//    this.fox = fox;
//  }

//  public String transition() {
//    if (millis() - timeOfActivation > 2000 )  // State transition when having waited for 2 seconds
//      return "WalkRight";
//    else
//      return name;
//  }

//  public void action() {
//    fox.move(fox.STOP);
//  }
//}
