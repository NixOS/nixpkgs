{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.4.5";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf1616d79cb0345849ceff1b89a7c80e26ae19b3c2d818def62d6975665838c1";
  };

  propagatedBuildInputs = [
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
