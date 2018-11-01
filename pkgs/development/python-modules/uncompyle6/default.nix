{ stdenv
, buildPythonPackage
, fetchPypi
, spark_parser
, xdis
, nose
, pytest
, hypothesis
, six
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd882f3c979b49d28ba7accc5ce7380ced8cab12e782e9170769ca15f0b81f8a";
  };

  checkInputs = [ nose pytest hypothesis six ];
  propagatedBuildInputs = [ spark_parser xdis ];

  # six import errors (yet it is supplied...)
  checkPhase = ''
    pytest ./pytest --ignore=pytest/test_build_const_key_map.py \
                    --ignore=pytest/test_grammar.py
  '';

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code deparser";
    homepage = https://github.com/rocky/python-uncompyle6/;
    license = licenses.mit;
  };

}
