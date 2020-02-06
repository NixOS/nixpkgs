{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dgraph";
  version = "1.0.17";

  goPackagePath = "github.com/dgraph-io/dgraph";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "05z1xwbd76q49zyqahh9krvq78dgkzr22qc6srr4djds0l7y6x5i";
  };

  # see licensing
  buildFlags = [ "-tags oss" ];

  goDeps = ./deps.nix;
  subPackages = [ "dgraph"];

  preBuild = ''
    export buildFlagsArray="-ldflags=\
      -X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}"
  '';

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    # Apache 2.0 because we use only build tag "oss"
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
