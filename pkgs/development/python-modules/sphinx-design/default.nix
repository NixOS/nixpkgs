{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.6.0";

  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    hash = "sha256-7I48XFn+1ASbOlouIJNg/qsxgpNGtfagx8NCuJQIIZI=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = with lib; {
    description = "Sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
