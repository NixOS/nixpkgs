{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sphinx-multitoc-numbering";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yWB2caxREjb6XWGnSRwQMecA6NSYydJBjmxh0SUSCa4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_multitoc_numbering" ];

  meta = {
    description = "Supporting continuous HTML section numbering";
    homepage = "https://github.com/executablebooks/sphinx-multitoc-numbering";
    changelog = "https://github.com/executablebooks/sphinx-multitoc-numbering/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
