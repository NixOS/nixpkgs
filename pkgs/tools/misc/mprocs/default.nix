{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ob1d8ZbWSArDhFuIvy+VlPyhkRJ7moMtIvn/odEoP2Y=";
  };

  cargoSha256 = "sha256-q3elc20w0RFCFxZchZyves/5dGY9O9+TnXUw7MIfSOw=";

  meta = with lib; {
    description = "A TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage thehedgeh0g ];
  };
}
