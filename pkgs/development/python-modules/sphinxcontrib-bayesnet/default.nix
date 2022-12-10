{ stdenv, lib, buildPythonPackage, fetchPypi, sphinx, sphinxcontrib-tikz }:

buildPythonPackage rec {
  pname = "sphinxcontrib-bayesnet";
  version = "0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x1kisvj7221cxfzmwplx3xlwbavl636fpncnjh7gghp1af71clw";
  };

  propagatedBuildInputs = [ sphinx sphinxcontrib-tikz ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "sphinxcontrib.bayesnet" ];

  meta = with lib; {
    homepage = "https://github.com/jluttine/sphinx-bayesnet";
    description = "Bayesian networks and factor graphs in Sphinx using TikZ syntax";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
    broken = true; # relies on 2to3 conversion, which was removed from setuptools>=58.0
  };
}
