{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-paramiko";
  version = "5.1.0.20261030";
  pyproject = true;

  src = fetchPypi {
    pname = "types_paramiko";
    inherit (finalAttrs) version;
    hash = "sha256-+7LnuNkBU31Q6Fq134qxmuxMeLXw7G//E0iNcMis9E8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
  ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "paramiko-stubs" ];

  meta = {
    description = "Typing stubs for paramiko";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
