{ lib
, aenum
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "wallbox";
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EDEB7/CkrfYSNcSh55Itrj6rThsNKeuj8lHLAY+Qml4=";
  };

  propagatedBuildInputs = [
    aenum
    requests
    simplejson
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "wallbox"
  ];

  meta = with lib; {
    description = "Module for interacting with Wallbox EV charger api";
    homepage = "https://github.com/cliviu74/wallbox";
    changelog = "https://github.com/cliviu74/wallbox/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
