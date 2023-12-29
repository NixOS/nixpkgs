{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-nYKqPaO7sA9aWPqngLoTq2PkpAi9zCADFZhYwIK1L2s=";
  };

  cargoHash = "sha256-Ybz2hNRMWSRuF6tWKsm0Ka7TOKwKvssA9/i6Hqk1tEE=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
    mainProgram = "krapslog";
  };
}
