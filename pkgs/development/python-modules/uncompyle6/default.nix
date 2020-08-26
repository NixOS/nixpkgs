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
  version = "3.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a45f98f40edb47c2a0e2786ffe7d68fc2cb4ad05b2efcb50e95c337f6ecae353";
  };

  checkInputs = [ nose pytest hypothesis six ];
  propagatedBuildInputs = [ spark_parser xdis ];

  # six import errors (yet it is supplied...)
  checkPhase = ''
    runHook preCheck
    pytest ./pytest --ignore=pytest/test_function_call.py
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code deparser";
    homepage = "https://github.com/rocky/python-uncompyle6/";
    license = licenses.gpl3;
  };

}
