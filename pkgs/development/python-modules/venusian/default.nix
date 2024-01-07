{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytest-cov
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "3.0.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6842b7242b1039c0c28f6feef29016e7e7dd3caaeb476a193acf737db31ee38";
  };

  nativeCheckInputs = [ pytest pytest-cov ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A library for deferring decorator actions";
    homepage = "https://pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
