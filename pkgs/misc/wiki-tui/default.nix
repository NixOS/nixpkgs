{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ncurses
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-euyg4wYWYerYT3hKdOCjokx8lJldGN7E3PHimDgQy3U=";
=======
    hash = "sha256-pjNXDU1YgzaH4vtdQnnfRCSmbhIgeAiOP/uyhBNG/7s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

<<<<<<< HEAD
  cargoHash = "sha256-rKTR7vKt8woWAn7XgNYFiWu4KSiZYhaH+PLEIOfbNIY=";
=======
  cargoHash = "sha256-RWj1QCHYEtw+QzdX+YlFiMqMhvCfxYzj6SUzfhqrcM8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ lom builditluc matthiasbeyer ];
=======
    maintainers = with maintainers; [ lom builditluc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
