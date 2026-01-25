{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  build,
  coverage,
  git,
  packaging,
  pytestCheckHook,
  pytest-rerunfailures,
  pythonOlder,
  setuptools,
  tomli,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "setuptools-git-versioning";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfinus";
    repo = "setuptools-git-versioning";
    tag = "v${version}";
    hash = "sha256-rAJ9OvSKhQ3sMN5DlUg2tfR42Ae7jjz9en3gfRnXb3I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    packaging
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  dependencies = [
    packaging
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "setuptools_git_versioning" ];

  nativeCheckInputs = [
    build
    coverage
    git
    pytestCheckHook
    pytest-rerunfailures
    tomli-w
  ];

  preCheck = ''
    # so that its built binary is accessible by tests
    export PATH="$out/bin:$PATH"
  '';

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
    changelog = "https://github.com/dolfinus/setuptools-git-versioning/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
}
