{ lib
, fetchFromGitHub
, cargo
, rustPlatform
, pkg-config
, gtk3
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = "unstable-2023-09-02";

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = pname;
    rev = "b15efe85ef1fe50849a33e5919d53d05f4f66090";
    sha256 = "sha256-S0WbqY49nKaBUMWfgDKZxFLJuk7uFcnTfV8s86V0Zxs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "osstrtools-0.2.2" = "sha256-Co4pcikfN4vtIVK7ZsRGCWMAhMJWNNVZe/AdN1nMlmQ=";
    };
  };

  cargoSha256 = lib.fakeSha256;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Simple app launcher for wayland written in rust";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ twitchyliquid64 ];
    platforms = platforms.linux;
  };
}
