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
  version = "1.2.6";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    hash = "sha256-3/wXxcKjbvlXUjvGgMidORVgeo2c5IuPgjLnY2Nj9oU=";
  };

  cargoHash = "sha256-UeMZlBSbeH/dn5j9vxNkZQ3vkNOxIyPLUOcZe2ZllTM=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ sqlite ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoBuildFlags = [ "--package" "arti" ];

  cargoTestFlags = [ "--package" "arti" ];

  meta = with lib; {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ ];
  };
}
