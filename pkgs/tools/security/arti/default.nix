{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, sqlite
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "arti";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    sha256 = "sha256-BHYzthKjD1JFYcZDCjI5/w82q2rsgGhrEorPF5RExhQ=";
  };

  cargoSha256 = "sha256-BBQfefi1ZT9qIUx7xK/fH4WNgxvowl/Yvu7LgLXd4bM=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ sqlite ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoBuildFlags = [ "--package" "arti" ];

  cargoTestFlags = [ "--package" "arti" ];

  meta = with lib; {
    description = "An implementation of Tor in Rust";
    homepage = "https://gitlab.torproject.org/tpo/core/arti";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/raw/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ marsam ];
  };
}
