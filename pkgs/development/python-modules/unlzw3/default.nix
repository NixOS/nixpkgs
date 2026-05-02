{
  lib,
  # Build system
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  # Optional dependencies
  flake8,
  flake8-blind-except,
  flake8-bugbear,
  flake8-builtins,
  mypy,
  pytest,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "unlzw3";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scivision";
    repo = "unlzw3";
    tag = "v${version}";
    hash = "sha256-rBqoSclNMUr4SL6JW3msYfDt9tUGgwyQYvt7ol+aurU=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    lint = [
      flake8
      flake8-blind-except
      flake8-bugbear
      mypy
      flake8-builtins
    ];
    tests = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "unlzw3"
  ];

  nativeChecksInputs = [ pytestCheckHook ];

  meta = {
    description = "Pure Python unlzw to open .Z files on any platform running Python";
    homepage = "https://github.com/scivision/unlzw3";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "unlzw3";
  };
}
