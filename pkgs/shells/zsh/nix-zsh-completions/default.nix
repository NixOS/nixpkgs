{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nix-zsh-completions";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = version;
    sha256 = "1n9whlys95k4wc57cnz3n07p7zpkv796qkmn68a50ygkx6h3afqf";
  };

  # https://github.com/spwhitt/nix-zsh-completions/issues/42
  #
  # _nix completion is broken. Remove it; _nix provided by the nix
  # package will be used instead. It is not sufficient to set low
  # meta.priority below if nix is installed in the system profile and
  # nix-zsh-completions in an user profile. In that case, the broken
  # version takes precedence over the good one.
  postPatch = ''
    rm _nix
  '';

  strictDeps = true;
  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix
  '';

  meta = with lib; {
    homepage = "https://github.com/spwhitt/nix-zsh-completions";
    description = "ZSH completions for Nix, NixOS, and NixOps";
    priority = 6; # prevent collisions with nix 2.4's built-in completions
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt olejorgenb hedning ma27 ];
  };
}
