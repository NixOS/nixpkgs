{ lib
, fetchFromGitHub
, buildPythonPackage
, clickclick
, dnspython
, requests
, pytest
, pytest-cov
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-cli-support";
  version = "1.1.20";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "stups-cli-support";
    rev = version;
    sha256 = "1r6g29gd009p87m8a6wv4rzx7f0564zdv67qz5xys4wsgvc95bx0";
  };

  propagatedBuildInputs = [
    clickclick
    dnspython
    requests
  ];

  preCheck = "export HOME=$TEMPDIR";

  nativeCheckInputs = [
    pytest
    pytest-cov
  ];

  meta = with lib; {
    description = "Helper library for all STUPS command line tools.";
    homepage = "https://github.com/zalando-stups/stups-cli-support";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
