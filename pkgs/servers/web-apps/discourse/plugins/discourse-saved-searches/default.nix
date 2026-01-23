{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-saved-searches";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-saved-searches";
    rev = "ba5e374a8d3b05b40f98585e664769fa50677e64";
    sha256 = "sha256-hQufTeIG40Txtiit+XL338P2Hu6TX1E6b/Xcr3SbSbY=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-saved-searches";
    license = lib.licenses.mit;
    description = "Allow users to save searches and be notified of new results";
  };
}
