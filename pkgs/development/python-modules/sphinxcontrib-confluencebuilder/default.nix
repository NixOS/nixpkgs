{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  flit-core,
  jinja2,
  pythonOlder,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
  version = "2.16.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_confluencebuilder";
    inherit version;
    hash = "sha256-/DAmVxbqFbEuYp0wpJXL/orw8GMDeDkLrXq2XAHTKOA=";
  };

  build-system = [ flit-core ];

  dependencies = [
    docutils
    sphinx
    requests
    jinja2
  ];

  # Tests are disabled due to a circular dependency on Sphinx
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.confluencebuilder" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Confluence builder for sphinx";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    changelog = "https://github.com/sphinx-contrib/confluencebuilder/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd1;
    maintainers = with lib.maintainers; [ graysonhead ];
    mainProgram = "sphinx-build-confluence";
  };
}
