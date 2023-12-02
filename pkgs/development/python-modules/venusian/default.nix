{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytest-cov
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-63LNym8xOaFdyA+cldPBD4pUoLqIHu744uxbQtPuOpU=";
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
