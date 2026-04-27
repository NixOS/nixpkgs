{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage (finalAttrs: {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20260325.8";
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) version;
    format = "wheel";
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
    hash = "sha256-+zM6D+mBsBNrx0oj99t83iJb2A8tz6OGe01LTWFvf5s=";
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

  meta = {
    changelog = "https://github.com/home-assistant/frontend/releases/tag/${finalAttrs.version}";
    description = "Frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/frontend";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
})
