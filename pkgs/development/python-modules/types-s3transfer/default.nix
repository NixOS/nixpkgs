{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-F/gAqHx+r6sENOnYdFLICcKQrpBsICTCQmHFZEeenJU=";
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
