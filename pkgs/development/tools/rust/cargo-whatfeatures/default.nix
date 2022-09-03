{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YENzXU7sud3gsh32zh1EwGEgfvnIIa4FzHMwGKuI3JA=";
  };

  cargoSha256 = "sha256-mUBqygJBisZl3wJh/pXVLLq7P6EWz0Pd2j+iu2pz7Os=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple cargo plugin to get a list of features for a specific crate";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou ];
  };
}
