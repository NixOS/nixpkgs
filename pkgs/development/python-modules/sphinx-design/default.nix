{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.6.1";

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    hash = "sha256-tE7qNxk4bQTXZcGoJXysorPm+EIdezpedCwP1F+E5jI=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = with lib; {
    description = "Sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
