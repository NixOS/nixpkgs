{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "0.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ef2ebcad2e9dbc4d5155764996835f5c0b65517ad15c4b1edd9ac3b81d0a95a";
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
