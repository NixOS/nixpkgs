{ rustPlatform
, fetchFromGitHub
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "bunyan-rs";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "LukeMathWalker";
    repo = "bunyan";
    rev = "v${version}";
    sha256 = "sha256-NGM8ryOy5bxF53Ak2/UDCf47MBlx/t6wcPlt+K8qvkg=";
  };

  cargoSha256 = "sha256-kzzOEHil7mW+fsstgr4/N4i8c9rzx4TzqGfYDgkzjh0=";

  meta = with lib; {
    description = "A CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ netcrns ];
    mainProgram = "bunyan";
  };
}
