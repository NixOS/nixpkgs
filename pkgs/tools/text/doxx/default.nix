{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, xorg
, wayland
, libxkbcommon
}:

rustPlatform.buildRustPackage rec {
  pname = "doxx";
  # Pin to a known-good commit until upstream publishes releases.
  # (Aug 19, 2025: fix multilevel lists and numbered headings; see upstream changelog)
  # https://github.com/bgreenwell/doxx/commit/ccb407983be5f7da44f8576955e3c115a6da0c9b
  version = "unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "doxx";
    rev = "ccb407983be5f7da44f8576955e3c115a6da0c9b";
    sha256 = "sha256-RtB+CD7nd2AwMhZZAv7RWw0xOnJG1Twjm7HYM0cHQso=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config ];

  doCheck = true;

  meta = with lib; {
    description = "Terminal-native .docx viewer with TUI, search, table rendering, and export";
    homepage = "https://github.com/bgreenwell/doxx";
    license = licenses.mit;
    mainProgram = "doxx";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jonochang ];
  };
}
