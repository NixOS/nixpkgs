{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uwr+cHenV38IsTEW/PQB0kCDsyahiQrBh4s8v8SyEn8=";
  };

  cargoSha256 = "sha256-H9oHppG7sew/3JrUtWq2Pip1S9H36qYeHu6x/sPfwV0=";

  # Package tests are currently failing (even upstream) but the package seems to work fine.
  # Relevant issues:
  # https://github.com/pvolok/mprocs/issues/50
  # https://github.com/pvolok/mprocs/issues/61
  doCheck = false;

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = with maintainers; [
      GaetanLepage
      pyrox0
    ];
    mainProgram = "mprocs";
  };
}
