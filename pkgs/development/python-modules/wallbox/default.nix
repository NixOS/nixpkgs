{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.4.6";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "651c61e2264258382d1f54c4f0bf6bcd198482a744d8f1db3dd73084c240d9bb";
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
