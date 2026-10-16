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
    rev = "a930ddee76321bb929989a2edbabb799199f1445";
    sha256 = "sha256-etcN88cIgaVvVAtE+z3zNacpNpwCp+cn2lE1DzeICyk=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-saved-searches";
    license = lib.licenses.mit;
    description = "Allow users to save searches and be notified of new results";
  };
}
