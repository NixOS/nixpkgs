{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aenum
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.4.12";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/RM1tqtGBCUa1fcqh5yvVQMNzaEqpAUPonciEIE6lC4=";
  };

  propagatedBuildInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
