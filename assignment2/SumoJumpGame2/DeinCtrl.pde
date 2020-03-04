class DeinCtrl extends SumoJumpController {

  DeinStateMachine stateMachine;
  DeinStateJump jump;
  DeinSeekOpponent seekOpponent;
  DeinSeekGoal seekGoal;
  DeinAttractGoal deinAttractGoal;
  DeinWalkLeft walkLeft;
  DeinWalkRight walkRight;


  DeinCtrl() {
    super();
    //platforms = player.sensePlatforms();
  }

  void act() {
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    PVector positionInPixelWorld  = player.sensePositionInPixelWorld();

    if (stateMachine == null) {
      stateMachine = new DeinStateMachine();
      jump = new DeinStateJump("Jump", player);
      seekOpponent = new DeinSeekOpponent("Opponent", player);
      seekGoal = new DeinSeekGoal("Goal", player);
      deinAttractGoal = new DeinAttractGoal("AttractGoal", player);
      walkLeft = new DeinWalkLeft("WalkLeft", player);
      walkRight = new DeinWalkRight("WalkRight", player);

      stateMachine.addState(jump);
      //stateMachine.addState(seekOpponent);
      stateMachine.addState(seekGoal);
      stateMachine.addState(deinAttractGoal);
      stateMachine.addState(walkLeft);
      stateMachine.addState(walkRight);

      stateMachine.setStartState(walkLeft);
    }
    stateMachine.step();
  }

  String getName() {
    return "Dein";
  }

  char getLetter() {
    return 'D';
  }

  color getColor() {
    return color(100, 100, 100);
  }

  void draw() {

    // Test drawing: sense the goals and draw lines to the goals:
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    strokeWeight(5);
    stroke(255, 0, 0, 150);
    for (SumoJumpGoalMeasurement goal : goals) {
      line(0, 0, goal.position.x, goal.position.y);
    }

    // Test drawing visualize perception radius:
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    noStroke();
    fill(0, 0, 255, 50);
    ellipseMode(RADIUS);
    ellipse(0, 0, proprio.perceptionRadius, proprio.perceptionRadius);

    // Test drawing visualizing the perceived platforms:
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    strokeWeight(10);
    for (SumoJumpPlatformMeasurement p : platforms) {
      if (p.standingOnThisPlatform)
        stroke(150, 255, 155, 200);
      else
        stroke(255, 0, 0, 200);
      line(p.left.x, p.left.y, p.right.x, p.right.y);
    }

    // Test drawing: Relative velocity
    stroke(0, 0, 0, 120);
    strokeWeight(6);
    line(0, 0, proprio.velocity.x, proprio.velocity.y);

    noStroke();
    fill(255);

    // get state name
    //text(stateMachine.getName(), width - 100, 40);
  }
}
