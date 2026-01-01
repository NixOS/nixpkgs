{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.10.0.20250822";
  pyproject = true;

  src = fetchPypi {
    pname = "types_ujson";
    inherit version;
    hash = "sha256-CnlVWOH3hTI3PPPwPzWx8IvGDVLZJBh7l5le41l7oAY=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ujson-stubs" ];

<<<<<<< HEAD
  meta = {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ centromere ];
=======
  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
