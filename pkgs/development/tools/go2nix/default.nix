{ stdenv, lib, buildGoPackage, go-bindata, goimports, nix-prefetch-git, git, makeWrapper,
  fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go2nix-${version}";
  version = "20160307-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "4c552dadd855e3694ed3499feb46dca9cd855f60";

  goPackagePath = "github.com/kamilchm/go2nix";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/kamilchm/go2nix";
    sha256 = "1pwnm1vrjxvgl17pk9n1k5chmhgwxkrwp2s1bzi64xf12anibj63";
  };

  goDeps = ./deps.json;

  buildInputs = [ go-bindata goimports makeWrapper ];
  preBuild = ''go generate ./...'';

  postInstall = ''
    wrapProgram $bin/bin/go2nix \
      --prefix PATH : ${nix-prefetch-git}/bin \
      --prefix PATH : ${git}/bin
  '';

  allowGoReference = true;
}
