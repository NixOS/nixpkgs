{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, stups-cli-support
, stups-zign
, pytest
, pytest-cov
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stups-pierone";
  version = "1.1.50";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "pierone-cli";
    rev = version;
    hash = "sha256-YAoj+Ou0Q64QRN5R0CQSxQGP7xDQQNISS6VT5txV0sw=";
  };

  propagatedBuildInputs = [
    requests
    stups-cli-support
    stups-zign
  ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  checkInputs = [
    pytest
    pytest-cov
    hypothesis
  ];

  pythonImportsCheck = [
    "pierone"
  ];

  meta = with lib; {
    description = "Convenient command line client for STUPS' Pier One Docker registry";
    homepage = "https://github.com/zalando-stups/pierone-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
  };
}
