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
    rev = "89bae0e929387ed5697fd3c5eedf9b3dbe85bead";
    hash = "sha256-ycDyYRi7uab4vxHY8K2kUytWBmTuFTFHYGD1AHpzC+0=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
