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
  version = "1.1.11";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    sha256 = "sha256-4/qlO+/GY5/U+jEMCuinqAZPyqtBiyaJ4TGkz8JV5AI=";
  };

  cargoHash = "sha256-NNf2iQyqZvBo6yVJo1Co67ivnILqfynjy5HCQxRJNKM=";

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
