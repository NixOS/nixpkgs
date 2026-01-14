{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  click,
  colorclass,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-versions";
  version = "1.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ROFEjET+d2Dfg4DHx0IqUN34oGwY4AGbi7teK4YmR8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    click
    colorclass
    sphinx
  ];

  pythonImportsCheck = [
    "sphinxcontrib.versioning"
  ];

  meta = {
    description = "Sphinx extension that allows building versioned docs for self-hosting";
    homepage = "https://pypi.org/project/sphinx-versions/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
