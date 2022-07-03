{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchzip
, cython
, numpy
, scikit-learn
, six
, setuptools-scm
, gcc
, pytest
, pytest-cov
, isPy27
}:
let
  testData = fetchzip {
    url = "http://mattmahoney.net/dc/text8.zip";
    sha256 = "0w3l64bww9znmmvd9cqbfmh3dddnlrjicz43y5qq6fhi9cfqjfar";
  };
in
buildPythonPackage rec {
  pname = "word2vec";
  version = "0.11.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "222d8ffb47f385c43eba45e3f308e605fc9736b2b7137d74979adf1a31e7c8b4";
  };

  nativeBuildInputs = [ setuptools-scm gcc ];

  propagatedBuildInputs = [ cython numpy scikit-learn six ];

  checkInputs = [ pytest pytest-cov ];

  # Checks require test data downloaded separately
  # See project source Makefile:test-data rule for reference
  checkPhase = ''
    PATH=$PATH:$out/bin
    mkdir data
    head -c 100000 ${testData}/text8 > data/text8-small
    pytest
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Tool for computing continuous distributed representations of words";
    homepage = "https://github.com/danielfrg/word2vec";
    license = licenses.asl20;
    maintainers = with maintainers; [ NikolaMandic ];
  };

}
