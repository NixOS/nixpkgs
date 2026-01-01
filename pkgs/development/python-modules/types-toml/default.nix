{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.8.20240310";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PUFQEwKXJDamuLI5yFCyZollfiUoG0j/DsBjRbiDAzE=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "toml-stubs" ];

<<<<<<< HEAD
  meta = {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
