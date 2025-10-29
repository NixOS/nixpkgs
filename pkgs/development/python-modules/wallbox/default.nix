{
  lib,
  aenum,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cliviu74";
    repo = "wallbox";
    tag = version;
    hash = "sha256-1/hm0x71YTW3cA11Nw/e4xUol5T9lElgm1bKi1wRi3o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aenum
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "wallbox" ];

  meta = {
    description = "Module for interacting with Wallbox EV charger API";
    homepage = "https://github.com/cliviu74/wallbox";
    changelog = "https://github.com/cliviu74/wallbox/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
