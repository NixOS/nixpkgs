{ lib, buildPythonPackage, fetchFromGitHub
, pytest_3 }:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.27";

  src = fetchFromGitHub {
    owner = "dwolfhub";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w0sx9ssjks8da973cdv5xi87yjsf038jqxmzj2y26xvpyjsg2v2";
  };

  checkInputs = [
    pytest_3
  ];

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}
