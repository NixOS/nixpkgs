{
  lib,
  aenum,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8taZpC1N5ZsVurh10WosZvg7WDmord+PDfhHpRlfqBE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aenum
    requests
    simplejson
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "wallbox" ];

  meta = with lib; {
    description = "Module for interacting with Wallbox EV charger api";
    homepage = "https://github.com/cliviu74/wallbox";
    changelog = "https://github.com/cliviu74/wallbox/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
