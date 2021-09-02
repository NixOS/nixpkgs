{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-cov
, syncserver
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06842b7242b1039c0c28f6feef29016e7e7dd3caaeb476a193acf737db31ee38";
  };

  checkInputs = [ pytest pytest-cov ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A library for deferring decorator actions";
    homepage = "https://pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = syncserver.maintainers;
  };
}
