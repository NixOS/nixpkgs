{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "srptools";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f6QzclahVC6PW7S+0Z4dmuqY/l/5uvdmkzQqHdasfJY=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "srptools" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Module to implement Secure Remote Password (SRP) authentication";
    mainProgram = "srptools";
    homepage = "https://github.com/idlesign/srptools";
    changelog = "https://github.com/idlesign/srptools/blob/v${version}/CHANGELOG";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
=======
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
