{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  addBinToPathHook,
  build,
  coverage,
  git,
  packaging,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pytest-rerunfailures,
  pytest-xdist,
  scikit-build-core,
  setuptools,
  tomli-w,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools-git-versioning";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfinus";
    repo = "setuptools-git-versioning";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6d8taSSAjvirivf1WaEICq0XbrYQzC2LB//LpGpHhI=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    packaging
    setuptools
  ];

  pythonImportsCheck = [ "setuptools_git_versioning" ];

  nativeCheckInputs = [
    addBinToPathHook
    build
    coverage
    git
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    scikit-build-core
    tomli-w
  ];

  disabledTests = [
    # runs an isolated build that uses internet to download dependencies
    "test_config_not_used"
  ];

  meta = {
    description = "Use git repo data (latest tag, current commit hash, etc) for building a version number according PEP-440";
    mainProgram = "setuptools-git-versioning";
    homepage = "https://github.com/dolfinus/setuptools-git-versioning";
    changelog = "https://setuptools-git-versioning.readthedocs.io/en/${finalAttrs.src.tag}/changelog.html";
    license = lib.licenses.mit;
  };
})
