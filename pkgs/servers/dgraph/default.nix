{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dgraph-${version}";
  version = "1.0.11";

  goPackagePath = "github.com/dgraph-io/dgraph";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0201bq10hl34xasmpmz6l0w3gk7c31jgawa1j65f6csca3kldq78";
  };

  goDeps = ./deps.nix;
  subPackages = [ "dgraph" ];

  buildFlagsArray = [ "-ldflags=-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}" ];
  preBuild = "cp -r go/src/github.com/dgraph-io/dgraph/vendor/* go/src/";

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.agpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
