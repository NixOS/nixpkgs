{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wavinsentio";
<<<<<<< HEAD
  version = "0.5.5";
=======
  version = "0.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Xw21JeQA0OMtyATey+LYmf3tRDcSME1bkQeAK0wFhHU=";
=======
    hash = "sha256-FlxeOaqQkJBWQtEUudbwlCzkK6HWmWTIxjgaI80BlxQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "wavinsentio" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to interact with the Wavin Sentio underfloor heating system";
    homepage = "https://github.com/djerik/wavinsentio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to interact with the Wavin Sentio underfloor heating system";
    homepage = "https://github.com/djerik/wavinsentio";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
