{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zxcvbn";
  version = "4.4.28";
  format = "setuptools";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "dwolfhub";
    repo = "zxcvbn-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-etcST7pxlpOH5Q9KtOPGf1vmnkyjEp6Cd5QCmBjW9Hc=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python implementation of Dropbox's realistic password strength estimator";
    homepage = "https://github.com/dwolfhub/zxcvbn-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
