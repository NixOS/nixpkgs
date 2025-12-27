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
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_mermaid";
    hash = "sha256-NYaZ0OySTvZ5tBhz2e3ZfQdzRG2vl2DHXhjcCt/ZE3E=";
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
