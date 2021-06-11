{ rustPlatform
, fetchFromGitHub
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "bunyan-rs";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "LukeMathWalker";
    repo = "bunyan";
    rev = "v${version}";
    sha256 = "sha256-Rj0VoJMcl8UBuVNu88FwTNF1GBx8IEXxwLL8sGz9kVM=";
  };

  cargoSha256 = "sha256-UZAiXLbRhr2J7QFf7x+JbEjc6p2AoVHYMgyARuwaB7E=";

  meta = with lib; {
    description = "A CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ netcrns ];
  };
}
