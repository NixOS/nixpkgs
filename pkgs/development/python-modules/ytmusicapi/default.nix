{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JstIHc61TFQEgRHr54N4Doq6ML0EcIcDGTEJ/tbrC2A=";
  };

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # requires network access

  pythonImportsCheck = [
    "ytmusicapi"
  ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
