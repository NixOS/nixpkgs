{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, stups-cli-support
, stups-zign
, pytest
, pytestcov
, hypothesis
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-pierone";
  version = "1.1.45";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "pierone-cli";
    rev = version;
    sha256 = "1ggfizw27wpcagbbk15xpfrhq6b250cx4278b5d7y8s438g128cs";
  };

  propagatedBuildInputs = [
    requests
    stups-cli-support
    stups-zign
  ];

  preCheck = "
    export HOME=$TEMPDIR
  ";

  checkInputs = [
    pytest
    pytestcov
    hypothesis
  ];

  meta = with lib; {
    description = "Convenient command line client for STUPS' Pier One Docker registry";
    homepage = "https://github.com/zalando-stups/pierone-cli";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
