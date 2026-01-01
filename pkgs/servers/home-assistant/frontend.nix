{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
<<<<<<< HEAD
  version = "20251203.3";
=======
  version = "20251105.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
<<<<<<< HEAD
    hash = "sha256-jccOeuv1QdU8nRrtAnRNrZu8s5Mw5KpXE+O/XLYhZ+A=";
=======
    hash = "sha256-keqQTQyo06xMUsZLf920n1eyu/iPrI2cNkXYMThhGFI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/home-assistant/frontend/releases/tag/${version}";
    description = "Frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/frontend";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
=======
  meta = with lib; {
    changelog = "https://github.com/home-assistant/frontend/releases/tag/${version}";
    description = "Frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/frontend";
    license = licenses.asl20;
    teams = [ teams.home-assistant ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
