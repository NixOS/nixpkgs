{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-freezegun";
  version = "1.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yzotLu6VDqy6rAZzq1BJmCM2XOuMZVursVRKQURkCew=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "freezegun-stubs" ];

<<<<<<< HEAD
  meta = {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
=======
  meta = with lib; {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
