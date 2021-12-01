{ rustPlatform
, fetchFromGitHub
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "bunyan-rs";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "LukeMathWalker";
    repo = "bunyan";
    rev = "v${version}";
    sha256 = "sha256-oMk17twYfN8BwSfdG59uPOUoHNh7WLUEgIDoWTG15Yw=";
  };

  cargoSha256 = "sha256-nzUFdpRdIVExV8OBdk/LEefj6O/L7yhj4eCpqU5WAJg=";

  meta = with lib; {
    description = "A CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ netcrns ];
    mainProgram = "bunyan";
  };
}
