{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "0796384551e3f9d328c57e88577098be05d816c7";
    sha256 = "sha256-lZ8BlFaQcd9H+bom2igbJl4Ty7qmqtpbOpGbqIF8nEo=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
