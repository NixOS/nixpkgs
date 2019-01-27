let 
  sha_hash = (import ./sha.nix);
  version = (import ./version.nix);
in

{ stdenv, fetchurl, go}:

  stdenv.mkDerivation { 
    name = "git-town-7.2.0";
    builder = ./install.bash;
    src = fetchurl {
      url = https://github.com/Originate/git-town/archive/v7.2.0.tar.gz;
      sha256 = sha_hash;
    };
    go = go;
    version = version;
  }