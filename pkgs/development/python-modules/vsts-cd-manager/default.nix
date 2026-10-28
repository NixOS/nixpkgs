{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "vsts-cd-manager";
  version = "1.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-C7CQWc1VPhwgbpLvMkyw3PkjNIRtZGxExoT2JWuGRHs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    mock
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "vsts_cd_manager" ];

  meta = {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
