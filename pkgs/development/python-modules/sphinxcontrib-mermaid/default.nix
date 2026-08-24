{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pyyaml,
  rst2pdf,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-mermaid";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "sphinxcontrib_mermaid";
    hash = "sha256-E8X5rDlctqv0A+yjTiKNyfs6MMnZYNvz5A6ajO+WlUk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    sphinx
    pyyaml
    rst2pdf
  ];

  pythonImportsCheck = [ "sphinxcontrib.mermaid" ];

  meta = {
    description = "Mermaid diagrams in yours sphinx powered docs";
    homepage = "https://github.com/mgaitan/sphinxcontrib-mermaid";
    changelog = "https://github.com/mgaitan/sphinxcontrib-mermaid/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
