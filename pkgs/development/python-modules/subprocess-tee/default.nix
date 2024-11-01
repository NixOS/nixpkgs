{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  enrich,
}:

buildPythonPackage rec {
  pname = "subprocess-tee";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "subprocess-tee";
    rev = "refs/tags/v${version}";
    hash = "sha256-rfI4UZdENfSQ9EbQeldv6DDGIQe5yMjboGTCOwed1AU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    enrich
  ];

  disabledTests = [
    # cyclic dependency on `molecule` (see https://github.com/pycontribs/subprocess-tee/issues/50)
    "test_molecule"
    # duplicates in console output, rich issue
    "test_rich_console_ex"
  ];

  pythonImportsCheck = [ "subprocess_tee" ];

  meta = with lib; {
    homepage = "https://github.com/pycontribs/subprocess-tee";
    description = "Subprocess.run drop-in replacement that supports a tee mode";
    changelog = "https://github.com/pycontribs/subprocess-tee/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ putchar ];
  };
}
