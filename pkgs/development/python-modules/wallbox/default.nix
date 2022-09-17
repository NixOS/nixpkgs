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
  version = "0.4.9";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90e664cf7d99eb1baf20a9ff5fd415dfa14ddafabcefd606e15b5bcd25f969e9";
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
