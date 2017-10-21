{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dgraph-${version}";
  version = "0.8.2";

  goPackagePath = "github.com/dgraph-io/dgraph";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0zc5bda8m2srjbk0gy1nnm0bya8if0kmk1szqr1qv3xifdzmi4nf";
  };

  extraOutputsToInstall = [ "dashboard" ];

  goDeps = ./deps.nix;
  subPackages = [ "cmd/dgraph" "cmd/dgraphloader" "cmd/bulkloader"];

  # let's move the dashboard to a different output, to prevent $bin from
  # depending on $out
  # TODO: provide a proper npm application for the dashboard.
  postPatch = ''
    mv dashboard/* $dashboard
  '';

  preBuild = ''
    export buildFlagsArray="-ldflags=\
      -X github.com/dgraph-io/dgraph/x.dgraphVersion=${version} \
      -X github.com/dgraph-io/dgraph/cmd/dgraph/main.uiDir=$dashboard/src/assets/"
  '';

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.agpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
