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
  version = "1.2.7";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    hash = "sha256-lyko4xwTn03/Es8icOx8GIrjC4XDXvZPDYHYILw8Opo=";
  };

  cargoHash = "sha256-I45SaawWAK7iTZDFhJT4YVO439D/3NmWLp3FtFmhLC0=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [ sqlite ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  cargoBuildFlags = [ "--package" "arti" ];

  cargoTestFlags = [ "--package" "arti" ];

  checkFlags = [
    # problematic tests that were fixed after the release
    "--skip=reload_cfg::test::watch_single_file"
    "--skip=reload_cfg::test::watch_multiple"
  ];

  meta = with lib; {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ ];
  };
}
