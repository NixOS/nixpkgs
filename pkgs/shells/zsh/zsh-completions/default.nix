{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-completions";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = pname;
    rev = version;
    sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
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
