{ stdenv
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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91fd35b64f1f25db59d80b8a5196ed4ffadf57a81f63ee207e34d53ec36d8f97";
  };

  buildInputs = [ mock sphinx-testing ];
  propagatedBuildInputs = [ sphinx blockdiag ];

  # Seems to look for files in the wrong dir
  doCheck = false;
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = with stdenv.lib; {
    description = "Sphinx blockdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-blockdiag";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.bsd2;
  };

}
