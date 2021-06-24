{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-spoiler-alert";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-spoiler-alert";
    rev = "e200cfa571d252cab63f3d30d619b370986e4cee";
    sha256 = "0ya69ix5g77wz4c9x9gmng6l25ghb5xxlx3icr6jam16q14dzc33";
  };
}
