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
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w7q2hhpzk159wd35hlbwkh80hnglqa475blcd9vjwpkv1kgkpvw";
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
