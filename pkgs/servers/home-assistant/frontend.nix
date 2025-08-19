{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20250811.0";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
    hash = "sha256-x//iMjNup4bf3PpvISYkHxOXKH20J2s+6oWQ22gS4BI=";
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
    teams = [ teams.home-assistant ];
  };
}
