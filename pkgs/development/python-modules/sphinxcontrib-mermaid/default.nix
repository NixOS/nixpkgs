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
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "sphinxcontrib_mermaid";
    hash = "sha256-+NfxsvCtabfr3Vy/Uy+07hB4k7U3O8LQ6WNAicCyz+4=";
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
