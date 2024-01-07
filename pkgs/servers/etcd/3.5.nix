{ lib, buildGoModule, fetchFromGitHub, symlinkJoin, nixosTests }:

let
  version = "3.5.11";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-OjAWi5EXy1d1O6HLBzHcSfeCNmZZLNtrQXpTJ075B0I=";
  };

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline endocrimes ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule rec {
    pname = "etcdserver";

    inherit CGO_ENABLED meta src version;

    vendorHash = "sha256-1/ma737hGdek+263w5OuO5iN5DTA8fpb6m0Fefyww20=";

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

    vendorHash = "sha256-AMN8iWTIFeT0HLqxYrp7sieT0nEKBNwFXV9mZG3xG5I=";

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    vendorHash = "sha256-zwafVpNBvrRUbL0qkDK9TOyo8KCiGjpZhvdUrgklG5Y=";

    modRoot = "./etcdctl";
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  passthru = {
    inherit etcdserver etcdutl etcdctl;
    tests = { inherit (nixosTests) etcd etcd-cluster; };
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
