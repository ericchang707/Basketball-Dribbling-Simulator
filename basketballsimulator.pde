// Eric Chang basketball dribbling simulator

import beads.*;

import java.util.*;
import controlP5.*;


String script = "Complete 5 Dribbles";
int voiceIndex;
int voiceSpeed;

//name of a file to load from the data directory
String normal = "normal.json";
String lefttoright = "lefttoright.json";
String forwardandbackward = "forwardandbackward.json";
JSONEvent currentJSONEvent;

//printwriter
//written output
PrintWriter output;
int totalFiles = 1;

int totalNormalRuns;

int totalSimulatorRuns;
int totalSuccessfulRuns;
boolean failureMessageWritten = false;



int totalTimeSpentUntilSuccess;
boolean recordingTotalTime;

// objects
ControlP5 p5;

// colors
color bg = color(50, 30, 40);
color bw  = color(80,90,67);
color bf = color(110, 40, 30);

color active = color(198, 225, 98);
color fore = color(128, 135, 228);
color back = bg;

// Sliders
Slider dribblingspeed;
Slider dribblingheight;
Slider dribblingX;
Slider horizontalvelocity;
Slider masterVolumeSlider;

RadioButton selector;

Toggle recordModeToggle;
Toggle manualModeToggle;
Toggle gameModeToggle;
Button runSimulatorButton;
Button resetSimulatorButton;
Button helpButton;

// animation
int time;
boolean animationRunning;
int ground = 380;

boolean recordMode;
boolean gameMode = true;
boolean manualMode = false;
boolean showHelp = true;
boolean dribbleCounted = false; // Flag to track if dribble has been counted

// constants
int SCREEN_WIDTH = 1200;
int SCREEN_HEIGHT = 900;
int SCREEN_HEIGHT_EXPANDED = 730;
int GROUND_HEIGHT = 400;
int BASKETBALL_SIZE = 30; // Diameter of basketball
int SUCCESSFUL_DRIBBLE_MIN; // Minimum successful dribble height
int SUCCESSFUL_DRIBBLE_MAX; // Maximum successful dribble height
int MAX_TIME = 500; // Maximum time in milliseconds
int basketball_X_INITIAL;
int basketball_Y_INITIAL;
int DRIBBLE_TIMING = 100; // Timing for dribbles
int Alignment_basketball_SIZE = 20;
int basketballYVelocity = -1;

int basketballX;
int basketballY;
int totalDribbles = 5;
int successfulDribbles;


boolean hasPopped;
boolean playedsinkSound;
boolean basketballHasCleared;
boolean basketballIsAligned;
int basketballAlignment;
color Alignment;

// input
boolean spacePressed;
String failedText;

void setup() {
  size(900, 750);

  ac = new AudioContext();
  setAudio(); 
  ac.start();
 
  currentJSONEvent = new JSONEvent(loadJSONArray(normal).getJSONObject(0));
  basketball_X_INITIAL = currentJSONEvent.getdribblingX();
  basketball_Y_INITIAL = currentJSONEvent.getDribblingHeight();
  SUCCESSFUL_DRIBBLE_MIN = currentJSONEvent.getDribblingHeight() -50;
  SUCCESSFUL_DRIBBLE_MAX = currentJSONEvent.getDribblingHeight()+50;

  createUI();

  playbackSelector(0);
}

void createUI() {
  p5 = new ControlP5(this);

  selector = p5.addRadioButton("playbackSelector")
    .setPosition(150, 530)
    .setSize(20, 20)
    .setSpacingColumn(100)
    .setItemsPerRow(5)
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128))
    .addItem("normal (Press 1)", 0)
    .addItem("lefttoright (Press 2)", 1)
    .addItem("lefttorightfaster (Press 3)", 2)
    .activate(0);

  runSimulatorButton = p5.addButton("runSimulator")
    .setPosition(750, 600)
    .setSize(80, 20)
    .setLabel("Run")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(88, 185, 88))
    .setColorActive(color(178, 235, 128));

  resetSimulatorButton = p5.addButton("resetSimulator")
    .setPosition(850, 600)
    .setSize(80, 20)
    .setLabel("Reset")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(110, 120, 90))
    .setColorActive(color(178, 235, 128));

  recordModeToggle = p5.addToggle("toggleRecordMode")
    .setPosition(650, 530)
    .setSize(80, 20)
    .setLabel("Record Mode")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128));


  manualModeToggle = p5.addToggle("toggleManualMode")
    .setPosition(850, 530)
    .setSize(80, 20)
    .setLabel("Manual Mode")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128));

  gameModeToggle = p5.addToggle("toggleGameMode")
    .setPosition(750, 530)
    .setSize(80, 20)
    .setLabel("Game Mode")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128));

  helpButton = p5.addButton("toggleHelp")
    .setPosition(100, 20)
    .setSize(30, 20)
    .setLabel("?")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128));

  dribblingspeed = p5.addSlider("dribblingspeed")
    .setPosition(150, 600)
    .setSize(200, 20)
    .setRange(1, 3)
    .setValue(2)
    .setLabel("Dribbling Speed")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128))
    .setColorValueLabel(color(90, 100, 70));

  dribblingheight = p5.addSlider("dribblingheight")
    .setPosition(150, 630)
    .setSize(200, 20)
    .setRange(200, 350)
    .setValue(250)
    .setLabel("Dribbling Height")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128))
    .setColorValueLabel(color(90, 100, 70));

  dribblingX = p5.addSlider("dribblingX")
    .setPosition(150, 660)
    .setSize(200, 20)
    .setRange(5, 1000)
    .setValue(15)
    .setLabel("Dribbling X Position")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128))
    .setColorValueLabel(color(90, 100, 70));

  horizontalvelocity = p5.addSlider("horizontalvelocity")
    .setPosition(150, 690)
    .setSize(200, 20)
    .setRange(1, 3)
    .setValue(250)
    .setLabel("Horizontal Velocity")
    .setColorBackground(color(90, 100, 70))
    .setColorForeground(color(148, 235, 128))
    .setColorActive(color(178, 235, 128))
    .setColorValueLabel(color(90, 100, 70));
    
     masterVolumeSlider = p5.addSlider("masterVolumeSlider")
    .setPosition(150, 720)
    .setSize(200, 20)
    .setRange(0, 100.0)
    .setValue(100.0)
    .setLabel("Master Volume")
    .setColorBackground(color(90,100,70))
    .setColorForeground(color(148,235,128))
    .setColorActive(color(178,235,128))
    .setColorValueLabel(color(90,100,7));


}



void dribblingspeed(float val) {
   currentJSONEvent.dribblingSpeed = val;

}

void dribblingheight(int val) {
  currentJSONEvent.dribblingHeight = val;
}

void dribblingX(int val) {
  currentJSONEvent.dribblingX = val;
}

void horizontalvelocity(int val) {
  currentJSONEvent.horizontalVelocity = val;
}
void masterVolumeSlider(float val) {
  masterGainGlide.setValue(val / 100.0);
}

void resetSliderValues() {
  dribblingspeed.setValue(currentJSONEvent.getDribblingSpeed());
  dribblingheight.setValue(currentJSONEvent.getDribblingHeight());
  dribblingX.setValue(currentJSONEvent.getdribblingX());
  horizontalvelocity.setValue(currentJSONEvent.getHorizontalVelocity());
}

void lockSliderValues() {
  dribblingspeed.lock()
    .setColorForeground(color(200, 210, 200));
  dribblingheight.lock()
    .setColorForeground(color(200, 210, 200));
  dribblingX.lock()
    .setColorForeground(color(200, 210, 200));
  horizontalvelocity.lock()
    .setColorForeground(color(200, 210, 200));
}


void unlockSliderValues() {
  dribblingspeed.unlock()
    .setColorForeground(color(148,235,128));
  dribblingheight.unlock()
    .setColorForeground(color(148,235,128));
  dribblingX.unlock()
    .setColorForeground(color(148,235,128));
  horizontalvelocity.unlock()
    .setColorForeground(color(148,235,128));
}


void toggleRecordMode() {
  

  if (!recordMode) {
    createNewFile();
    writeToFile(currentJSONEvent.toString());

    // lock manual mode while recording
    lockSliderValues();
    manualModeToggle.lock()
      .setColorBackground(color(200, 210, 200));

  } else {



    writeToFile("\n\n\nTotal Runs (overall): " + str(totalSimulatorRuns));
    writeToFile("Total runs (normal): " + str(totalNormalRuns));

    if (totalSimulatorRuns > 0) {
      writeToFile("Success rate (overall): " + str((float) (totalSuccessfulRuns) / totalSimulatorRuns));
    }
    if (totalNormalRuns > 0) {
      writeToFile("Success rate (Normal): " + str((float) totalSuccessfulRuns / totalNormalRuns));
    }
 





    writeToFile("Total time spent (Normal): " + str((float) (totalTimeSpentUntilSuccess)));
    
    if (totalNormalRuns > 0) {
      writeToFile("Avg time spent (Normal): " + str((float) (totalTimeSpentUntilSuccess / totalNormalRuns)));
    }
 


    writeToFile("\nEnd of file");
    closeFile();

    unlockSliderValues();

    manualModeToggle.unlock()
    .setColorBackground(color(90,100,70));
  }

  recordMode = !recordMode;
}



void toggleManualMode() {
  manualMode = !manualMode;
  animationRunning = false;

  if(manualMode) {
    resetSliderValues();
    surface.setSize(SCREEN_WIDTH, SCREEN_HEIGHT_EXPANDED);
    size(SCREEN_WIDTH, SCREEN_HEIGHT_EXPANDED);
    
  } else {
    surface.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
  }
}

void toggleGameMode() {
 gameMode = !gameMode;
  successfulDribbles = 0;
  gameModeToggle.unlock();
  animationRunning = false;

unlockSliderValues();
  
  
}

void toggleHelp() {
  showHelp = !showHelp;
}

void playbackSelector(int selection) {
  animationRunning = false;

  switch(selection){
    case 0: // JSON 1
      currentJSONEvent = new JSONEvent(loadJSONArray(normal).getJSONObject(0));
      println("JSON 1 loaded");
       successfulDribbles = 0;
        basketball_X_INITIAL = currentJSONEvent.getdribblingX();
      break;

    case 1: // JSON 2
      currentJSONEvent = new JSONEvent(loadJSONArray(lefttoright).getJSONObject(0));
      println("JSON 2 loaded");
       successfulDribbles = 0;
        basketball_X_INITIAL = currentJSONEvent.getdribblingX();
      break;

    case 2: // JSON 3
      currentJSONEvent = new JSONEvent(loadJSONArray(forwardandbackward).getJSONObject(0));
      println("JSON 3 loaded");
       successfulDribbles = 0;
        basketball_X_INITIAL = currentJSONEvent.getdribblingX();
      break;

    default:
      println("No selection!");
       successfulDribbles = 0;
      break;
  }

  if (!manualMode) {
    surface.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
  } else {
    resetSliderValues();
    unlockSliderValues();
  }
}

void resetSimulator() {

  time = 0;
  animationRunning = false;
  basketballX = basketball_X_INITIAL;
  basketballY = basketball_Y_INITIAL;
  successfulDribbles = 0;
  basketballYVelocity = 0;
  totalDribbles = 5;
  back = bg;
  hasPopped = false;
  basketballHasCleared = false;

  Alignment = bf;
  basketballIsAligned = false;

  SUCCESSFUL_DRIBBLE_MIN = currentJSONEvent.getDribblingHeight();
  SUCCESSFUL_DRIBBLE_MAX = currentJSONEvent.getDribblingHeight() + 100;
  basketball_X_INITIAL = currentJSONEvent.getdribblingX();
}

void runSimulator() {
  resetSimulator();

  animationRunning = true;



  if (recordMode) {
    
      writeToFile("\n\nRun #" + Integer.toString(totalSimulatorRuns) + " (Normal)\n");
      totalNormalRuns++;
    

   
    writeToFile("Game mode: " + str(gameMode));
    writeToFile("Manual mode: " + str(manualMode) + "\n");

    totalSimulatorRuns++;

  }

  lockSliderValues();  
}

void update() {


  if(animationRunning) {
    
    time++;

    updateSound();

    updateBasketball();

    updateAlignment();


   // Check if the player did not reach the target dribble count by the end of the time
if (time > 500 && successfulDribbles < totalDribbles || basketballX >=1100) {
    animationRunning = false;
  back = bf;

  unlockSliderValues();

 basketballHasCleared = false;
   playSound(lose);

  failedText = "ran out of time without reaching target dribbles or out of bounds";
  if (recordMode) {
    writeToFile("failed (ran out of time without reaching target dribbles)");
  }
}


      if (recordMode && recordingTotalTime) {
        totalTimeSpentUntilSuccess += time;
      }

    


  } else { 

    unlockSliderValues(); 
    basketballPositionGainGlide.setValue(0);

  }

if (successfulDribbles >= totalDribbles && animationRunning) {
    animationRunning = false;
    println("Successfully completed " + totalDribbles + " dribbles!");
    displayWinningLine();
    basketballHasCleared = true;


    if (recordMode) {

         totalSuccessfulRuns++;
         
        
        writeToFile("Successfully completed " + totalDribbles + " dribbles at time: " + str(time));
        if (recordMode && recordingTotalTime) {
            totalTimeSpentUntilSuccess += time;
            recordingTotalTime = false;
        }
       
    }
} else if (time > MAX_TIME && !animationRunning && !failureMessageWritten) {
   failureMessageWritten = true;
    println("Failed to reach target dribble count within time limit!");
    if (recordMode) {
        writeToFile("Failed to reach target dribble count within time limit at time: 500");
        if (recordMode && recordingTotalTime) {
            totalTimeSpentUntilSuccess += time;
        }
     
    }
}


if (time > MAX_TIME && animationRunning) {
    animationRunning = false;
    println("Time expired!");
    if (recordMode) {
        writeToFile("Time expired at time: " + str(time));
    }
}



}

void updateSound() {

  // while animation running
  if (!basketballHasCleared) {

    // updating the pitch based on basketball's Y value
    float pitch = 850 - (basketballY);
    basketballPositionGlide.setValue(pitch);


    if (basketballPositionGain.getGain() == 0) { 
      envelope.clear();


      int sustain =  320 - (basketballX / 2);
      if (sustain < 110) {
        sustain = 110;
      }

 
      envelope.addSegment(1, 1, 1);      
      envelope.addSegment(0, sustain, 1); 
    }

    basketballPositionGain.setGain(envelope);

    pannerGlide.setValue((float) basketballAlignment / 10);

  } else { 
    envelope.clear();
    basketballPositionGain.setGain(0);


  }
}

void updateBasketball() {

  basketballY += basketballYVelocity;

if(basketballY < SCREEN_HEIGHT - GROUND_HEIGHT - BASKETBALL_SIZE / 2 ) {
    if(!manualMode) {
      basketballYVelocity += currentJSONEvent.getDribblingSpeed(); 
    } else {
       basketballYVelocity += currentJSONEvent.getDribblingSpeed();
    }
  } else {
    if(!manualMode) {
    basketballYVelocity *= (currentJSONEvent.getDribblingSpeed() * -1);
  
    basketballY = SCREEN_HEIGHT - GROUND_HEIGHT - BASKETBALL_SIZE / 2 - 1;

    playSound(sink);
    playedsinkSound = true;
    } else {
       basketballYVelocity *= dribblingspeed.getValue() * -1;
        basketballY = SCREEN_HEIGHT - GROUND_HEIGHT - BASKETBALL_SIZE / 2 - 1;

    playSound(sink);
    playedsinkSound = true;
    }
  
  }

 
  basketballY = constrain(basketballY, 0, SCREEN_HEIGHT - GROUND_HEIGHT - BASKETBALL_SIZE / 2);


  if (!dribbleCounted  && basketballY > SUCCESSFUL_DRIBBLE_MIN && basketballY < SUCCESSFUL_DRIBBLE_MAX && spacePressed) {
    successfulDribbles++;
    dribbleCounted = true;
    playSound(ding);
    basketballIsAligned = false;
    basketballAlignment = 0;
  }

  basketballX += currentJSONEvent.getHorizontalVelocity(); 

 
  basketballX = constrain(basketballX, 0 + BASKETBALL_SIZE / 2, SCREEN_WIDTH - BASKETBALL_SIZE / 2);
}

void updateAlignment() {



  if(basketballAlignment >= -2 && basketballAlignment <= 2) {
    basketballIsAligned = true;
    Alignment = bg;



  } else {
    Alignment = bf;
    basketballIsAligned = false;
  }

  if (!gameMode) {
    if (time % 10 == 0 && !basketballIsAligned) {
      if (basketballAlignment > 0) {
        basketballAlignment -= 1;
      } else {
        basketballAlignment += 1;
      }
    }
  }


}

void draw() {
  
  update();

voiceIndex = round(map(mouseY, 0, height, 0, TextToSpeech.voices.length - 1));

  voiceSpeed = 100;

    background(back);
    fill(fore);
    stroke(fore);
     fill(255); 
  textSize(20); // Set the text size
  textAlign(RIGHT, TOP); // Align the text to the top-right corner
  text("Successful Dribbles: " + successfulDribbles, width - 20, 10);
 

    if(animationRunning) {
      // UI setup 
      background(back);
       
      drawSideView();
      drawAlignment();
       fill(255); 
  textSize(20);
  textAlign(RIGHT, TOP); 
  text("Successful Dribbles: " + successfulDribbles, width - 20, 10);
   fill(255, 255, 0, 100); 
  noStroke();
  rect(0, SUCCESSFUL_DRIBBLE_MIN, SCREEN_WIDTH, SUCCESSFUL_DRIBBLE_MAX - SUCCESSFUL_DRIBBLE_MIN);

    }

  

  fill(bg);
  rect(10, 500, 1100, 1000);

  if (recordMode) {
    stroke(bg);
    rect(20, 500, 300, 60);
    fill(color(255,255,255));
    text("Recording in session", 350, 520);
    selector.hide();
  } else {
    fill(color(255,255,255));
    text("JSON Files:", 130, 540);
    selector.show();
  }


  // text labels
  fill(color(255,255,255));
  text("Sliders:", 140, 650);
  text("Modes:", 1000, 540);
  
  if (showHelp) {
    if (animationRunning) {
      text("alignment", 865, 145);
    }
    text("Press 1, 2, 3 for demo,          r to run simulation,          g for game mode,          m for manual mode", 970, 15);
    if(gameMode) {
      text("Instructions: Press space to dribble, try and dribble in the target range", 900, 480); 
    }

    // debug text
    text("time: " + str(time), 860, 15 + 620);
     text("Time Remaining: " + str(MAX_TIME- time), 860, 35 + 620);
    text("Successful Dribbles: " + str(successfulDribbles), 860, 55 + 620);
    text("posY: " + str(basketballY), 860, 75 + 620);
    text("posX: " + str(basketballX), 860, 95 + 620);
  }

  if (back == bw) {
    text("success!", SCREEN_WIDTH / 2 +50, SCREEN_HEIGHT / 2 - 200);
  }
  if (back == bf) {
    text(failedText, SCREEN_WIDTH / 2 +200, SCREEN_HEIGHT / 2 - 200);
  }



  //rect(0, 490, 900, 1);


}

void keyPressed() {
  



  if (!recordMode) {

    if (int(key) > 48 && int(key) < 54) {
      playbackSelector(int(key) - 49);
      selector.activate(int(key) - 49);
    }

    if (key == 'm' || key == 'M') {
      manualModeToggle.setValue(!manualMode);
    }

  }
  

  if (key == 'g' || key == 'G') {
    gameModeToggle.setValue(!gameMode);
  }



  if (keyCode == 8) {
    resetSimulator();
  }

 if (key == 'r' || key == 'R') {
    if (animationRunning) {
      if (successfulDribbles < totalDribbles) {
        // If player has lost, reset the simulation
        resetSimulator();
      } else {
        // If simulation is already running and player has won, stop the simulation
           resetSimulator();
        animationRunning = false;
      }
    } else {
      // Otherwise, start the simulation
      resetSimulator();
      runSimulator();
    }
  }

  // close program with ESCAPE key
  if (keyCode == 27) {
    exit();
  }


  if (animationRunning) {

    if (keyCode == 32) { // space bar
  
    spacePressed = true;
      dribbleCounted = false; 
  }


  }

}


void keyReleased() {

    if (keyCode == 32) {
      spacePressed = false;
      basketballYVelocity = 5;


      if (recordMode) {
        writeToFile("Y position of dribble " + str(basketballY));
   
 
      }
      playSound(bun);
      playedsinkSound = false;


  }
}


void drawAlignment() {

  fill(Alignment);
  stroke(fore);
  pushMatrix();
  translate(0, 0);
  rect(900 - 130, 30, 100, 100);

  fill(back);
  rect(
    900 - 130 + 50 - 20, 
    50 + 20 , 
    40 , 
    20 );
  
  // basketball
  fill(fore);
  stroke(fore);
  rect(
    900 - 130 + 50 - 10 + (((float) basketballAlignment / 10) * 40), 
    50 + 20 + (basketballY + BASKETBALL_SIZE - ground) / 6, 
    20, 
    20);
  
  fill(color(255,255,255));
  popMatrix();



}


void drawSideView() {


    fill(color(90, 100, 70));
    stroke(color(90, 100, 70));
    drawGround(0, ground, 0);
    drawBasketball();

    fill(fore);
    stroke(fore);

}



void drawGround(int x, int y, int rotation) {
    // draws ground
    pushMatrix();
    translate(x, y);
    rotate(radians(rotation));
      fill(color(78,90,70));
      stroke(fore);
    rect(10, 0, 1100, 500);
    popMatrix();
}




void drawBasketball() {
  fill(255, 165, 0); // Orange

  ellipse(basketballX, basketballY, 30, 40);
}
void displayWinningLine() {
    back = bw;
     animationRunning = false;
}

void mousePressed() {
  // say something
  TextToSpeech.say(script, TextToSpeech.voices[voiceIndex], voiceSpeed);
}



void createNewFile() {
  // Create a new file in the sketch directory

  output = createWriter("results/trial" + Integer.toString(totalFiles) + ".txt"); 
  totalFiles++;
  totalSimulatorRuns = 0;
  totalNormalRuns = 0;
  totalSuccessfulRuns = 0;
  totalTimeSpentUntilSuccess = 0;
  recordingTotalTime = true;
}

void writeToFile(String note) {
    output.println(note);
}

void closeFile() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}
void exit() {
  println("stopping program...");
  if (recordMode) {
    closeFile();
  }
  super.exit();
}
