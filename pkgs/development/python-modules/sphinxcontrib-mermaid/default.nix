{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
  pyyaml,
  rst2pdf,
  lib,
}:
buildPythonPackage rec {
  pname = "sphinxcontrib-mermaid";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_mermaid";
    hash = "sha256-NUI8E+Vlq7g5sT+VX5ci8Haed+XWB8oHh3zpPhY2wZY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    pyyaml
    rst2pdf
  ];

  pythonImportsCheck = [ "sphinxcontrib.mermaid" ];

  meta = {
    description = "Mermaid diagrams in yours sphinx powered docs";
    homepage = "https://github.com/mgaitan/sphinxcontrib-mermaid";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
