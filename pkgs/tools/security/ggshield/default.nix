{ lib
, fetchFromGitHub
, git
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ggshield";
  version = "1.19.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "ggshield";
    rev = "refs/tags/v${version}";
    hash = "sha256-yAH1MWviOfo5m7esvnm6KlcQeS62aIqgFD4hzBMbHVU=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    charset-normalizer
    click
    cryptography
    marshmallow
    marshmallow-dataclass
    oauthlib
    pygitguardian
    pyjwt
    python-dotenv
    pyyaml
    requests
    rich
  ];

  nativeCheckInputs = [
    git
  ] ++ (with python3.pkgs; [
    pyfakefs
    pytest-mock
    pytest-voluptuous
    pytestCheckHook
    snapshottest
    vcrpy
  ]);

  pythonImportsCheck = [
    "ggshield"
  ];

  disabledTestPaths = [
    # Don't run functional tests
    "tests/functional/"
  ];

  disabledTests = [
    # No TLS certificate, no .git folder, etc.
    "test_cache_catches"
    "test_is_git_dir"
    "test_is_valid_git_commit_ref"
    "test_check_git_dir"
    "test_does_not_fail_if_cache"
  ];

  meta = with lib; {
    description = "Tool to find and fix various types of hardcoded secrets and infrastructure-as-code misconfigurations";
    homepage = "https://github.com/GitGuardian/ggshield";
    changelog = "https://github.com/GitGuardian/ggshield/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
