let sha_hash = (import ./sha.nix); in

{ stdenv, fetchurl, git }:

  stdenv.mkDerivation { 
    name = "git-town-7.2.0";
    builder = ./install.bash;
    src = fetchurl {
      url = https://github.com/Originate/git-town/releases/download/v7.2.0/git-town-linux-amd64;
      sha256 = sha_hash;
    };
  }