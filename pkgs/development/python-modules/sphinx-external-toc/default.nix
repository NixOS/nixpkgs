{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  click,
  pyyaml,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-external-toc";
  version = "1.1.0";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx_external_toc";
    hash = "sha256-+BgzhlAG9rSpslUKJHSm49fn8ssjuiMwkmBXfqZVUvY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    pyyaml
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_external_toc" ];

  meta = {
    description = "Sphinx extension that allows the site-map to be defined in a single YAML file";
    mainProgram = "sphinx-etoc";
    homepage = "https://github.com/executablebooks/sphinx-external-toc";
    changelog = "https://github.com/executablebooks/sphinx-external-toc/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
