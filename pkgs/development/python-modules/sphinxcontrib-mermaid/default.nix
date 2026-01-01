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
<<<<<<< HEAD
  version = "1.2.3";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_mermaid";
<<<<<<< HEAD
    hash = "sha256-NYaZ0OySTvZ5tBhz2e3ZfQdzRG2vl2DHXhjcCt/ZE3E=";
=======
    hash = "sha256-Loq2fT4eKBZmP5NH0Cao3uSoWKzdStMt0cgIiT24gUY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
