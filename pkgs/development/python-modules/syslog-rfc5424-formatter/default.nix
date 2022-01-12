{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "syslog-rfc5424-formatter";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "easypost";
    repo = pname;
    rev = "v${version}";
    sha256 = "17ym5ls5r6dd9pg9frdz8myfq5fxyqlwdq1gygc9vnrxbgw2c9kb";
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
