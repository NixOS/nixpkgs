{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9wac2jlh8MLggcYuEHVUPYPjhfzGN+4o1XT8B9pj4f8=";
  };

  cargoSha256 = "sha256-vGhoM5VMJO+ppLk8DetNZ8UteU6ifdtRe1HNJ0dSB+0=";

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = [ maintainers.GaetanLepage ];
  };
}
