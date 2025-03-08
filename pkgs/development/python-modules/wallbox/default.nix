{
  lib,
  aenum,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S1JP7/D3U853fQU3a2pyL+dt/hVLDP3TB82tcGlcXVQ=";
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

  meta = with lib; {
    description = "Module for interacting with Wallbox EV charger API";
    homepage = "https://github.com/cliviu74/wallbox";
    changelog = "https://github.com/cliviu74/wallbox/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
