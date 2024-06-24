{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, gtk3
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = "1.0.0-unstable-2023-09-02";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = pname;
    rev = "b15efe85ef1fe50849a33e5919d53d05f4f66090";
    hash = "sha256-S0WbqY49nKaBUMWfgDKZxFLJuk7uFcnTfV8s86V0Zxs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "osstrtools-0.2.2" = "sha256-Co4pcikfN4vtIVK7ZsRGCWMAhMJWNNVZe/AdN1nMlmQ=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Simple app launcher for wayland written in rust";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
