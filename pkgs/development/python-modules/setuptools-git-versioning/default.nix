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
  setuptools,
  tomli-w,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools-git-versioning";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfinus";
    repo = "setuptools-git-versioning";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rAJ9OvSKhQ3sMN5DlUg2tfR42Ae7jjz9en3gfRnXb3I=";
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
    tomli-w
  ];

  # limit tests because the full suite takes several minutes to run
  enabledTestMarks = [
    "important"
  ];

  disabledTests = [
    # runs an isolated build that uses internet to download dependencies
    "test_config_not_used"
  ];

  meta = {
    description = "Use git repo data (latest tag, current commit hash, etc) for building a version number according PEP-440";
    mainProgram = "setuptools-git-versioning";
    homepage = "https://github.com/dolfinus/setuptools-git-versioning";
    changelog = "https://github.com/dolfinus/setuptools-git-versioning/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
})
