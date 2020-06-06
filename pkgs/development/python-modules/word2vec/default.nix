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
  version = "0.11.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "222d8ffb47f385c43eba45e3f308e605fc9736b2b7137d74979adf1a31e7c8b4";
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
