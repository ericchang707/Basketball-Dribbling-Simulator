import java.io.IOException;

static class TextToSpeech extends Object {


  static final String VICKI = "Vicki";
  static final String VICTORIA = "Victoria";
  static final String ALBERT = "Albert";
  static final String BAD_NEWS = "Bad News";
  static final String BAHH = "Bahh";


  static String[] voices = {
    VICKI, VICTORIA, ALBERT, BAD_NEWS, BAHH,
  };


  static void say(String script, String voice, int speed) {
    try {
      Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + script});
    }
    catch (IOException e) {
      System.err.println("IOException");
    }
  }



}
