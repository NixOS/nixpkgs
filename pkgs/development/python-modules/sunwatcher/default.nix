{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "sunwatcher";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u0vHCw0h0h6pgadBLPBSwv/4CXNj+3HIJCEtt2rdlWs=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sunwatcher" ];

  meta = with lib; {
    description = "Python module for the SolarLog HTTP API";
    homepage = "https://bitbucket.org/Lavode/sunwatcher/src/master/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
