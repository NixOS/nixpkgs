{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-spoiler-alert";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-spoiler-alert";
    rev = "b57e79343acc15cb2c0a032a2deb29ad4b9d53cc";
    sha256 = "sha256-Ypt6PYCZzArCv9KkCtw5rfT6++dDoUx5q9m/eMvP0Sc=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-spoiler-alert";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Hide spoilers behind the spoiler-alert jQuery plugin";
  };
}
