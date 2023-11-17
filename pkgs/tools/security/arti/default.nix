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
  version = "1.1.10";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    sha256 = "sha256-/O13n9YPY0RhSnSM9vJzLTXNuXT6iWrPo7S8EnnKIkw=";
  };

  cargoHash = "sha256-LfqieUMWRL+86p0DyitxdfUGVwPtfhcwiwKYMqOZtdc=";

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
