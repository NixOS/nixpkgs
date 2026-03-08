{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  jeepney,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "secretstorage";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitya57";
    repo = "secretstorage";
    tag = finalAttrs.version;
    hash = "sha256-oDna9i6ny/mKHpOzrtfaYPnd12qsZ84TTxl4g+RWE24=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    jeepney
  ];

  # Needs a D-Bus session
  doCheck = false;

  pythonImportsCheck = [ "secretstorage" ];

  meta = {
    changelog = "https://github.com/mitya57/secretstorage/blob/${finalAttrs.src.tag}/changelog";
    description = "Python bindings to FreeDesktop.org Secret Service API";
    homepage = "https://github.com/mitya57/secretstorage";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teto ];
  };
})
