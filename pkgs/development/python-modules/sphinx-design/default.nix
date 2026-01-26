{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.7.0";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    hash = "sha256-0qP1sZwkuRattS+XxfAO+rQAnKM3gSABEJCEp0Dsm3o=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = {
    description = "Sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
