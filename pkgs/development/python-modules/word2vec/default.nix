{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, numpy
, python
}:

buildPythonPackage rec {
  pname = "word2vec";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a811e3e98a8e6dfe7bc851ebbbc2d6e5ab5142f2a134dd3c03daac997b546faa";
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
