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
  version = "3.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z4489grxc06pxmfy63b6x6h54p05fhbigvrrgr1kvdciy2nvz04";
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
