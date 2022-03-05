{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, stups-cli-support
, stups-zign
, pytest
, pytest-cov
, hypothesis
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-pierone";
  version = "1.1.50";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "pierone-cli";
    rev = version;
    sha256 = "sha256-YAoj+Ou0Q64QRN5R0CQSxQGP7xDQQNISS6VT5txV0sw=";
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
    pytest-cov
    hypothesis
  ];

  meta = with lib; {
    description = "Convenient command line client for STUPS' Pier One Docker registry";
    homepage = "https://github.com/zalando-stups/pierone-cli";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
