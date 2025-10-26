{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20260128.6";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    format = "wheel";
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
    hash = "sha256-H9MHB4uVhKfPo9zi5XRDl1IjyUWKeXr3lSU8PEcm/7s=";
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

  meta = {
    changelog = "https://github.com/home-assistant/frontend/releases/tag/${version}";
    description = "Frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/frontend";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
