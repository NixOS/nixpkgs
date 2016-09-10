{ stdenv, buildGoPackage, go-bindata, goimports, nix-prefetch-git, git, makeWrapper,
  fetchFromGitHub }:

buildGoPackage rec {
  name = "go2nix-${version}";
  version = "1.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/kamilchm/go2nix";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamilchm";
    repo = "go2nix";
    sha256 = "0asbbcyf1hh8khakych0y09rjarjiywr8pyy1v8ghpr1vvg43a09";
  };

  goDeps = ./deps.nix;

  buildInputs = [ go-bindata goimports makeWrapper ];
  preBuild = ''go generate ./...'';

  postInstall = ''
    wrapProgram $bin/bin/go2nix \
      --prefix PATH : ${nix-prefetch-git}/bin \
      --prefix PATH : ${git}/bin
  '';

  allowGoReference = true;
}
