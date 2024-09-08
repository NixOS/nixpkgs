{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ncurses,
  openssl,
  pkg-config,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = "wiki-tui";
    rev = "v${version}";
    hash = "sha256-euyg4wYWYerYT3hKdOCjokx8lJldGN7E3PHimDgQy3U=";
  };

  # Note: bump `time` dependency to be able to build with rust 1.80, should be removed on the next
  # release (see: https://github.com/NixOS/nixpkgs/issues/332957)
  cargoPatches = [ ./time.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-XovbT+KC0va7yC5j7kf6t1SnXe1uyy1KI8FRV1AwkS0=";

  meta = with lib; {
    description = "Simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      lom
      builditluc
      matthiasbeyer
    ];
    mainProgram = "wiki-tui";
  };
}
