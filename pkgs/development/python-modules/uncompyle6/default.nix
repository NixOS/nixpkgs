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
  version = "3.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a40f4f4b8b02a8687bd98c598980bed38a4770e3de253847eafed4b7167d07f";
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
    license = licenses.gpl3;
  };

}
