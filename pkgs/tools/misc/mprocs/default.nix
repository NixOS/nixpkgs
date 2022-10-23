{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CEvQq5tBVRvjgb/yReuGkPk8Uq1oZbrsGilV4ulOPEk=";
  };

  cargoSha256 = "sha256-RK8VmEajfqYXGS8VMCRxhENLbe40CdaC+vS4EKeW958=";

  # Package tests are currently failing (even upstream) but the package seems to work fine.
  # Relevant issues:
  # https://github.com/pvolok/mprocs/issues/50
  # https://github.com/pvolok/mprocs/issues/61
  doCheck = false;

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage thehedgeh0g ];
  };
}
