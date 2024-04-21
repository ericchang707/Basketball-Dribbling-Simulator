import beads.*;

Glide waveFrequency;
Gain waveGain;

Gain masterGain;
Glide masterGainGlide;

WavePlayer waveTone;

WavePlayer basketballPositionTone;
Glide basketballPositionGlide;
Gain basketballPositionGain;
Glide basketballPositionGainGlide;

Gain spGain;
SamplePlayer sink;
SamplePlayer bun;
SamplePlayer pole;
SamplePlayer ding;
SamplePlayer lose;

BiquadFilter highpassFilter;
Glide highpassGlide;

Envelope envelope;

Panner panner;
Glide pannerGlide;

void setAudio() {
  setupMasterGain();
  setupUgens();
  setupSamplePlayers();
  setupWavePlayers();
}

void setupMasterGain() {
  masterGainGlide = new Glide(ac, 1.0, 1.0);  
  masterGain = new Gain(ac, 2, masterGainGlide);
  ac.out.addInput(masterGain);
}

void setupUgens() {

  highpassGlide = new Glide(ac, 10.0, 500);
  highpassFilter = new BiquadFilter(ac, BiquadFilter.HP, highpassGlide, .5);
  
  masterGain.addInput(highpassFilter);

  highpassGlide.setValue(2200.0);


  envelope = new Envelope(ac);


  pannerGlide = new Glide(ac, 0, 5);
  panner = new Panner(ac, pannerGlide);


}

void setupSamplePlayers() {
 


  sink = getSamplePlayer("sink.mp3");
  bun = getSamplePlayer("bun.mp3");
  pole = getSamplePlayer("pole.mp3");
  ding = getSamplePlayer("ding.wav");
  lose = getSamplePlayer("lose.wav");

  sink.setKillOnEnd(false);
  bun.setKillOnEnd(false);
   ding.setKillOnEnd(false);
  pole.setKillOnEnd(false);
    lose.setKillOnEnd(false);


  sink.pause(true);
  bun.pause(true);
  pole.pause(true);
    ding.pause(true);
    lose.pause(true);

  spGain = new Gain(ac, 2, 0.4); // create the gain object

  // add sounds
  spGain.addInput(sink);
  spGain.addInput(bun);
  spGain.addInput(pole);
    spGain.addInput(ding);
        spGain.addInput(lose);

  
  highpassFilter.addInput(spGain);
}


// play sound using sample player
void playSound(SamplePlayer sp) {
  sp.start();
  sp.setToLoopStart();
}


void setupWavePlayers() {


  resetBaseFrequency();
  
}

void resetBaseFrequency() {


  basketballPositionGlide = new Glide(ac, 210.0, 0);
  basketballPositionTone = new WavePlayer(ac, basketballPositionGlide, Buffer.SINE);

  basketballPositionGainGlide = new Glide(ac, 0, 0);
  basketballPositionGain = new Gain(ac, 2, 0.0 ); 



  basketballPositionGain.addInput(basketballPositionTone);
  panner.addInput(basketballPositionGain);
  masterGain.addInput(panner);

}
