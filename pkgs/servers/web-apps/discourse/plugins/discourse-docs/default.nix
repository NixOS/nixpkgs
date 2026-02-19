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
    rev = "f755032b6988c217da30025d7e281d07361bbc47";
    sha256 = "sha256-GOwLPbRLZ8F+hY4n+TAbN+DruaQgTzoM7KhVU9hfisM=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
