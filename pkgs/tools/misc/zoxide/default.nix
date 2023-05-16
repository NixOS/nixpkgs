{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf
, installShellFiles
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-h/T3McaKKASwQt+0SBBxFXMnYyt+0Xl+5i8IulUAdnU=";
=======
    sha256 = "sha256-qmT/gTkizZpyYN/YdobBq2vunGM5SpNpCHIFmg8nPhk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

<<<<<<< HEAD
  cargoSha256 = "sha256-uu7zi6prnfbi4EQ0+0QcTEo/t5CIwNEQgJkIgxSk5u4=";
=======
  cargoSha256 = "sha256-1sW6bvRJJp+qT5A9+l8wN3TQuzFDiBoeLyY5JvAA7dQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
<<<<<<< HEAD
    mainProgram = "zoxide";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
