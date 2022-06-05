{ lib
, buildPythonPackage
, fetchPypi
, python
, mock
, sphinx-testing
, sphinx
, blockdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-blockdiag";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa49bf924516f5de8a479994c7be81e077df5599c9da2a082003d5b388e1d450";
  };

  buildInputs = [ mock sphinx-testing ];
  propagatedBuildInputs = [ sphinx blockdiag ];

  # Seems to look for files in the wrong dir
  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = with lib; {
    description = "Sphinx blockdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-blockdiag";
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
  };

}
