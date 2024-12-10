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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-euyg4wYWYerYT3hKdOCjokx8lJldGN7E3PHimDgQy3U=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      ncurses
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      Security
    ];

  cargoHash = "sha256-rKTR7vKt8woWAn7XgNYFiWu4KSiZYhaH+PLEIOfbNIY=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
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
