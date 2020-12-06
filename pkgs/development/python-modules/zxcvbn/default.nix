{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage {
  pname = "zxcvbn";
  version = "4.4.28";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "dwolfhub";
    repo = "zxcvbn-python";
    rev = "45afdf0d3dd8477bc7e457629bb4bc9680794cd7"; # not tagged in repository
    sha256 = "0w0sx9ssjks8da973cdv5xi87yjsf038jqxmzj2y26xvpyjsg2v2";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python implementation of Dropbox's realistic password strength estimator";
    homepage = "https://github.com/dwolfhub/zxcvbn-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
