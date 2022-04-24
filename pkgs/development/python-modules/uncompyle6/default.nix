{ lib
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
  version = "3.8.0";
  disabled = pythonAtLeast "3.9"; # See: https://github.com/rocky/python-uncompyle6/issues/331

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YgYzYY9t/B8+eBh+Igk014/8Y5wOOdrsofxTWquBcBQ=";
  };

  checkInputs = [ nose pytest hypothesis six ];
  propagatedBuildInputs = [ spark_parser xdis ];

  # six import errors (yet it is supplied...)
  checkPhase = ''
    runHook preCheck
    pytest ./pytest --ignore=pytest/test_function_call.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python cross-version byte-code deparser";
    homepage = "https://github.com/rocky/python-uncompyle6/";
    license = licenses.gpl3;
  };

}
