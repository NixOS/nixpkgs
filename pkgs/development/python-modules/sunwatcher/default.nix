{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sunwatcher";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u0vHCw0h0h6pgadBLPBSwv/4CXNj+3HIJCEtt2rdlWs=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sunwatcher" ];

<<<<<<< HEAD
  meta = {
    description = "Python module for the SolarLog HTTP API";
    homepage = "https://bitbucket.org/Lavode/sunwatcher/src/master/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module for the SolarLog HTTP API";
    homepage = "https://bitbucket.org/Lavode/sunwatcher/src/master/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
