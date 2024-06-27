{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-e15SzlX8CHzWOF4UnPybqYHELuT2vZ+4mkbz413WDr4=";
  };

  cargoHash = "sha256-UZvXoD70f5QHTW9Xr8tRms1wqV9/dpN/u3Mv7/gwyZ4=";

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage pyrox0 ];
    mainProgram = "mprocs";
  };
}
