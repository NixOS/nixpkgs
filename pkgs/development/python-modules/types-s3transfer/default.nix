{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.19.2";
  pyproject = true;

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-KnioBsCbEfxtWXVkAq3ia0m5OoWsbyCaOeJJghHGpBs=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "s3transfer-stubs" ];

  meta = {
    description = "Type annotations and code completion for s3transfer";
    homepage = "https://github.com/youtype/types-s3transfer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
