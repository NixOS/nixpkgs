{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, spark_parser
, xdis
, nose
, pytest
, hypothesis
, six
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.7.4";
  disabled = pythonAtLeast "3.9"; # See: https://github.com/rocky/python-uncompyle6/issues/331

  src = fetchPypi {
    inherit pname version;
    sha256 = "af8330861bf940e7a3ae0f06d129b8e645191a36bf73ca15ff51997a837d41f8";
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
