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
  toml,
  tomli,
}:

buildPythonPackage rec {
  pname = "setuptools-git-versioning";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dolfinus";
    repo = "setuptools-git-versioning";
    tag = "v${version}";
    hash = "sha256-Slf6tq83LajdTnr98SuCiFIdm/6auzftnARLAOBgyng=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    packaging
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "setuptools_git_versioning" ];

  nativeCheckInputs = [
    build
    coverage
    git
    pytestCheckHook
    pytest-rerunfailures
    toml
  ];

  preCheck = ''
    # so that its built binary is accessible by tests
    export PATH="$out/bin:$PATH"
  '';

  # limit tests because the full suite takes several minutes to run
  pytestFlagsArray = [
    "-m"
    "important"
  ];

  disabledTests = [
    # runs an isolated build that uses internet to download dependencies
    "test_config_not_used"
  ];

  meta = with lib; {
    description = "Use git repo data (latest tag, current commit hash, etc) for building a version number according PEP-440";
    mainProgram = "setuptools-git-versioning";
    homepage = "https://github.com/dolfinus/setuptools-git-versioning";
    changelog = "https://github.com/dolfinus/setuptools-git-versioning/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
