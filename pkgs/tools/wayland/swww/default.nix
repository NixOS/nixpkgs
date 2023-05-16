<<<<<<< HEAD
{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, lz4
, libxkbcommon
, installShellFiles
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.8.1";
=======
{ config, lib, pkgs, fetchFromGitHub, rustPlatform, pkg-config, lz4, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-9c/qBmk//NpfvPYjK2QscubFneiQYBU/7PLtTvVRmTA=";
  };

  cargoSha256 = "sha256-AE9bQtW5r1cjIsXA7YEP8TR94wBjaM7emOroVFq9ldE=";

  buildInputs = [
    lz4
    libxkbcommon
  ];

  doCheck = false; # Integration tests do not work in sandbox environment

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  postInstall = ''
    for f in doc/*.scd; do
      local page="doc/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd swww \
      --bash <(cat completions/swww.bash) \
      --fish <(cat completions/swww.fish) \
      --zsh <(cat completions/_swww)
  '';
=======
    hash = "sha256-58zUi6tftTvNoc/R/HO4RDC7n+NODKOrBCHH8QntKSY=";
  };

  cargoSha256 = "sha256-hL5rOf0G+UBO8kyRXA1TqMCta00jGSZtF7n8ibjGi9k=";
  buildInputs = [ lz4 libxkbcommon ];
  doCheck = false; # Integration tests do not work in sandbox environment
  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/Horus645/swww";
    license = licenses.gpl3;
<<<<<<< HEAD
    maintainers = with maintainers; [ mateodd25 donovanglover ];
    platforms = platforms.linux;
    mainProgram = "swww";
=======
    maintainers = with maintainers; [ mateodd25 ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
