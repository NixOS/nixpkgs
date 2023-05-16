{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-completions";
<<<<<<< HEAD
  version = "0.35.0";
=======
  version = "0.34.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
=======
    sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  installPhase = ''
    install -D --target-directory=$out/share/zsh/site-functions src/*

    # tmuxp install it so avoid collision
    rm $out/share/zsh/site-functions/_tmuxp
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.olejorgenb ];
  };
}
