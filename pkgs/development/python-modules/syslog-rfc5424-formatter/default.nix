{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "syslog-rfc5424-formatter";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "easypost";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-dvRSOMXRmZf0vEEyX6H7OBSfo/PgyOLKuDS8X6g4qe0=";
  };

  # Tests are not picked up, review later again
  doCheck = false;

  pythonImportsCheck = [ "syslog_rfc5424_formatter" ];

  meta = with lib; {
    description = "Python logging formatter for emitting RFC5424 Syslog messages";
    homepage = "https://github.com/easypost/syslog-rfc5424-formatter";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ fab ];
  };
}
