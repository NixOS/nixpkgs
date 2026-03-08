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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_mermaid";
    hash = "sha256-z099RT0AETLqul0f31PUIEnwLpEyE8+DN0J0g7/KJvQ=";
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
