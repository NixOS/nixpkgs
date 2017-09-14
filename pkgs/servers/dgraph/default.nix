{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dgraph-${version}";
  version = "0.8.1";

  goPackagePath = "github.com/dgraph-io/dgraph";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "1gls2pvgcmd364x84gz5fafs7pwkll4k352rg1lmv70wvzyydsdr";
  };

  extraOutputsToInstall = [ "dashboard" ];

  goDeps = ./deps.nix;
  subPackages = [ "cmd/dgraph" "cmd/dgraphloader" ];

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

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    # Somehow on Darwin, $out/lib (which doesn't exist) ends up in RPATH.
    # Removing it fixes cycle between $out and $bin
    install_name_tool -delete_rpath $out/lib $bin/bin/dgraph
    install_name_tool -delete_rpath $out/lib $bin/bin/dgraphloader
  '';
 
  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.agpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
