{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20211215.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G2w+L+tQi47JOygYZ1+VtC96FBPet5klkW0LUeaxWBY=";
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/home-assistant-polymer";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
