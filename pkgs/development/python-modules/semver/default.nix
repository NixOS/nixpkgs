{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "semver";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-semver";
    repo = "python-semver";
    tag = version;
    hash = "sha256-ry6r2cY/DRTiPxT+ZiumgFbQyHNzL8i1QcQbLWjnDVE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "semver" ];

  meta = {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = "https://python-semver.readthedocs.io/";
    changelog = "https://github.com/python-semver/python-semver/releases/tag/3.0.0";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ np ];
    mainProgram = "pysemver";
  };
}
