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
  version = "3.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lv0ks7w5bsl8bndm6ikl4yprkq2ps23y409ldlycrvlggjg44y5";
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
