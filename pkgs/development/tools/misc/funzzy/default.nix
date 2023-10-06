{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "funzzy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cristianoliveira";
    repo = "funzzy";
    rev = "v${version}";
    hash = "sha256-Qqj/omtjUVtsjMh2LMmwlJ4d8fIwMT7mdD4odzI49u8=";
  };

  cargoHash = "sha256-pv05r5irKULRvik8kWyuT7/sr7GUDj0oExyyoGrMD6k=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "A lightweight watcher";
    homepage = "https://github.com/cristianoliveira/funzzy";
    changelog = "https://github.com/cristianoliveira/funzzy/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
