{
  buildPythonApplication,
  fetchFromGitHub,
  lib,
  pandoc-xnos,
  setuptools,
}:

buildPythonApplication rec {
  pname = "pandoc-eqnos";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = "pandoc-eqnos";
    tag = version;
    hash = "sha256-7GQdfGHhtQs6LZK+ZyMmcPSkoFfBWmATTMejMiFcS7Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ pandoc-xnos ];

  # Different pandoc executables are not available
  doCheck = false;

  meta = {
    description = "Standalone pandoc filter from the pandoc-xnos suite for numbering equations and equation references";
    homepage = "https://github.com/tomduck/pandoc-eqnos";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ppenguin ];
    mainProgram = "pandoc-eqnos";
  };
}
