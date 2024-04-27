{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-80VbQyOg6jvX98QRcCVN/wwhAm4bO/UfHEIv4gP8IlA=";
  };

  cargoHash = "sha256-mp9KUJuwSwRuxQAEilYwNZwqe3ipN4JzsaO5Pi3V9xg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple cargo plugin to get a list of features for a specific crate";
    mainProgram = "cargo-whatfeatures";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou matthiasbeyer ];
  };
}
