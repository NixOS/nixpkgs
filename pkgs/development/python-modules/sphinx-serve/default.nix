{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sphinx-serve";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d90f6595114108500b1f935d3f4d07bf5192783c67ce83f944ef289099669c9";
  };

  doCheck = false; # No tests

  pythonImportsCheck = [ "sphinx_serve" ];

  meta = with lib; {
    description = "Spawns a simple HTTP server to preview your sphinx documents";
    mainProgram = "sphinx-serve";
    homepage = "https://github.com/tlatsas/sphinx-serve";
    maintainers = with maintainers; [ FlorianFranzen ];
    license = licenses.mit;
  };
}
