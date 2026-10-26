{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  click,
  pyyaml,
  sphinx,
  sphinx-multitoc-numbering,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-external-toc";
  version = "1.1.0";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "sphinx_external_toc";
    hash = "sha256-+BgzhlAG9rSpslUKJHSm49fn8ssjuiMwkmBXfqZVUvY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    pyyaml
    sphinx
    sphinx-multitoc-numbering
  ];

  pythonImportsCheck = [ "sphinx_external_toc" ];

  meta = {
    description = "Sphinx extension that allows the site-map to be defined in a single YAML file";
    mainProgram = "sphinx-etoc";
    homepage = "https://github.com/executablebooks/sphinx-external-toc";
    changelog = "https://github.com/executablebooks/sphinx-external-toc/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
