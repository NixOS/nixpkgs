{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  flit-core,
  jinja2,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinxcontrib_confluencebuilder";
    inherit version;
    hash = "sha256-+Z4rsqozJ3DWrg7SYr7dh7CIQlCgpX9Fj6lJmcCxoMk=";
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
