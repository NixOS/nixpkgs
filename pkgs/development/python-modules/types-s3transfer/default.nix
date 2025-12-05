{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-Q6Uj4MQ6iORH39pfT2tjvz2oUxb90mJfZQgX8rFwtfc=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "s3transfer-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for s3transfer";
    homepage = "https://github.com/youtype/types-s3transfer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
