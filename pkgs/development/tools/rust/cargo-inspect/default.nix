{ stdenv, lib, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-inspect";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "mre";
    repo = pname;
    rev = version;
    sha256 = "026vc8d0jkc1d7dlp3ldmwks7svpvqzl0k5niri8a12cl5w5b9hj";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "069i8ydrp1pssnjq7d6mydwr7xh2cmcpzpf8bzd6nfjr6xx1pipr";

  meta = with lib; {
    description = "See what Rust is doing behind the curtains";
    mainProgram = "cargo-inspect";
    homepage = "https://github.com/mre/cargo-inspect";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ minijackson matthiasbeyer ];
  };
}
