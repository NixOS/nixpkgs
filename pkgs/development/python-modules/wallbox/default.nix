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
  version = "0.4.10";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+LJ0ggRUXFfqmiDbIF2ZWL6qsE6gOzp5OKMFSY3dGG0=";
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
