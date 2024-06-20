{ lib, buildGoModule, fetchFromGitHub, symlinkJoin, nixosTests, k3s }:

let
  version = "3.5.14";
  etcdSrcHash = "sha256-BbrOWAVrUj3LxFGvm1ycnFHglskaZesL0XILLnN8TIE=";
  etcdServerVendorHash = "sha256-LNVRwPaaqpk7PKcgzwNrtBx+Dy9JJS88RT71RBDJ0ug=";
  etcdUtlVendorHash = "sha256-fFERNwaWwdukTtACuihlMZZYpdo0cnZnnFb5xmug2vI=";
  etcdCtlVendorHash = "sha256-cQMWb0PGYUPLlYvILrD2vxcDhcpYdAts9ARTeAh1Wew=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = etcdSrcHash;
  };

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline superherointj ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule rec {
    pname = "etcdserver";

    inherit CGO_ENABLED meta src version;

    vendorHash = etcdServerVendorHash;

    modRoot = "./server";

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];
  };

  etcdutl = buildGoModule rec {
    pname = "etcdutl";

    inherit CGO_ENABLED meta src version;

    vendorHash = etcdUtlVendorHash;

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    vendorHash = etcdCtlVendorHash;

    modRoot = "./etcdctl";
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  passthru = {
    inherit etcdserver etcdutl etcdctl;
    tests = {
      inherit (nixosTests) etcd etcd-cluster;
      k3s = k3s.passthru.tests.etcd;
    };
    updateScript = ./update.sh;
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
