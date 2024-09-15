{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20240906.0";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
    hash = "sha256-iWSpwgp5mdAhuZgF+1uNL0aovjM7CZ4SbM0HHQktfAk=";
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/home-assistant/frontend/releases/tag/${version}";
    description = "Frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/frontend";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
