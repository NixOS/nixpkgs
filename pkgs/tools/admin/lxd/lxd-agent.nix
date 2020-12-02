{ lib
, buildGoPackage
, src, version
}:

buildGoPackage rec {
  inherit version src;

  pname = "lxd-agent";

  goPackagePath = "github.com/lxc/lxd";

  buildFlags = [ "-ldflags=-extldflags=-static" "-ldflags=-s" "-ldflags=-w" ];

  subPackages = [ "lxd-agent" ];

  preConfigure = ''
    export CGO_ENABLED=0
  '';

  preBuild = ''
    # unpack vendor
    pushd go/src/github.com/lxc/lxd
    rm _dist/src/github.com/lxc/lxd
    cp -r _dist/src/* ../../..
    popd
  '';
}
