{
  lib,
  # Build system
  buildPythonPackage,
  setuptools,
  wheel,
  fetchFromGitHub,
  # Optional dependencies
  flake8,
  flake8-blind-except,
  flake8-bugbear,
  flake8-builtins,
  mypy,
  pytest,
}:
buildPythonPackage rec {
  pname = "unlzw3";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scivision";
    repo = "unlzw3";
    rev = "v${version}";
    hash = "sha256-rBqoSclNMUr4SL6JW3msYfDt9tUGgwyQYvt7ol+aurU=";
  };

  build-system = [
    setuptools
    wheel
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

  meta = {
    description = "Pure Python unlzw to open .Z files on any platform running Python";
    homepage = "https://github.com/scivision/unlzw3";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "unlzw3";
  };
}
