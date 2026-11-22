{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-comments";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ABcK//JwGfrQjkIdoa5JxoGDH7J1l4bwfIJuiayUzyE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_comments" ];

  meta = {
    description = "Add comments and annotation to your documentation";
    homepage = "https://github.com/executablebooks/sphinx-comments";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
