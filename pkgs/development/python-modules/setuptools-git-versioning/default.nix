{ lib
, buildPythonPackage
, fetchFromGitHub
, build
, coverage
, git
, packaging
, pytestCheckHook
, pytest-rerunfailures
, pythonOlder
, setuptools
, toml
, wheel
}:

buildPythonPackage rec {
  pname = "setuptools-git-versioning";
  version = "1.13.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dolfinus";
    repo = "setuptools-git-versioning";
    rev = "refs/tags/v${version}";
    hash = "sha256-YUIh+dK4Sj85vhvI7u15a734tbQsox5VZ2WEAB/mpgc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    packaging
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [
    toml
  ];

  pythonImportsCheck = [
    "setuptools_git_versioning"
  ];

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
  pytestFlagsArray = [ "-m" "important" ];

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
