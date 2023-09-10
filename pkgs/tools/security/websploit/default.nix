{ lib, buildPythonApplication, fetchFromGitHub
, requests, scapy }:

buildPythonApplication rec {
  pname = "websploit";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "f4rih";
    repo = pname;
    rev = version;
    sha256 = "LpDfJmH2FbL37Fk86CAC/bxFqM035DBN6c6FPfGpaIw=";
  };

  propagatedBuildInputs = [
    requests
    scapy
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "A high level MITM framework";
    homepage = "https://github.com/f4rih/websploit";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
