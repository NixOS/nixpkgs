{ lib
, asn1crypto
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.4.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    sha256 = "sha256-HEt2QxNHX9Oqx+o0++ZtS61SVHra3nLAqv7NbQWVV+E=";
  };

  propagatedBuildInputs = [
    asn1crypto
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "scramp" ];

  meta = with lib; {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
