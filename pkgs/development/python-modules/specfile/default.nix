{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flexmock,
  git,
  pytestCheckHook,
  rpm,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "specfile";
  version = "0.37.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "packit";
    repo = "specfile";
    tag = version;
    hash = "sha256-phzvQs49AC9SbmcQHWprfjHssF0ughDJ9KKVnUEB/gg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ rpm ];

  nativeCheckInputs = [
    git
    flexmock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "specfile" ];

  disabledTests = [
    # AssertionError
    "test_update_tag"
    "test_shell_expansions"
  ];

  meta = {
    description = "Library for parsing and manipulating RPM spec files";
    homepage = "https://github.com/packit/specfile";
    changelog = "https://github.com/packit/specfile/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
