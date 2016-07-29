{ stdenv, buildGoPackage, go-bindata, goimports, nix-prefetch-git, git, makeWrapper,
  fetchFromGitHub, fetchgit }:

buildGoPackage rec {
  name = "go2nix-${version}";
  version = "1.0.0";
  rev = "v${version}";

  goPackagePath = "github.com/kamilchm/go2nix";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamilchm";
    repo = "go2nix";
    sha256 = "0smvh8yplz191z7i68jbraq251ry378y7zhc9dcwfb61gdyrbcg9";
  };

  goDeps = import ./deps.nix { inherit fetchgit; };

  buildInputs = [ go-bindata goimports makeWrapper ];
  preBuild = ''go generate ./...'';

  postInstall = ''
    wrapProgram $bin/bin/go2nix \
      --prefix PATH : ${nix-prefetch-git}/bin \
      --prefix PATH : ${git}/bin
  '';

  allowGoReference = true;
}
