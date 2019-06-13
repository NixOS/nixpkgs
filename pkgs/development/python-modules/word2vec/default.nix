{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, numpy
, python
}:

buildPythonPackage rec {
  pname = "word2vec";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40f6f30a5f113ffbfc24c5ad5de23bfac897f4c1210fb93685b7fca5c4dee7db";
  };

  propagatedBuildInputs = [ cython numpy ];

  checkPhase = ''
   cd word2vec/tests;
    ${python.interpreter} test_word2vec.py
  '';

  meta = with stdenv.lib; {
    description = "Tool for computing continuous distributed representations of words";
    homepage = "https://github.com/danielfrg/word2vec";
    license     = licenses.asl20;
    maintainers = with maintainers; [ NikolaMandic ];
  };

}
