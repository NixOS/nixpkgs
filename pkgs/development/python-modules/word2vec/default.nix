{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, numpy
, scikitlearn
, six
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "word2vec";
  version = "0.10.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "95aa222ff2d5c2559192414b794870d14a022016ba83f1bef0cf8cc185e41483";
  };

  propagatedBuildInputs = [ cython numpy scikitlearn six ];

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
