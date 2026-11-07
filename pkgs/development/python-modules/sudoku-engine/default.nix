{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "sudoku-engine";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sudoku_engine";
    inherit version;
    hash = "sha256-5SjxeztClL/jL3bhCG1LoXyv0Op2DuA22qDKzX2Xa0M=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "sudoku"
  ];

  meta = {
    description = "A simple Python package that generates and solves m x n Sudoku puzzles";
    homepage = "https://pypi.org/project/sudoku-engine/";
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.mit;
  };
}
