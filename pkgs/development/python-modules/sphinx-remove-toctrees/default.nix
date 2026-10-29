{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  sphinx,
  pre-commit,
  ipython,
  myst-parser,
  sphinx-book-theme,
  pytest,
}:

buildPythonPackage rec {
  pname = "sphinx-remove-toctrees";
  version = "1.0.0.post1";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_remove_toctrees";
    inherit version;
    hash = "sha256-SAjR7fFRwG7/bSw5Iux+vJ/Tqhdi3hsuFnSjf1rJzi0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    sphinx
  ];

  optional-dependencies = {
    code_style = [
      pre-commit
    ];
    docs = [
      ipython
      myst-parser
      sphinx-book-theme
    ];
    tests = [
      ipython
      myst-parser
      pytest
      sphinx-book-theme
    ];
  };

  pythonImportsCheck = [
    "sphinx_remove_toctrees"
  ];

  meta = {
    description = "Reduce your documentation build size by selectively removing toctrees from pages";
    homepage = "https://pypi.org/project/sphinx-remove-toctrees/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
