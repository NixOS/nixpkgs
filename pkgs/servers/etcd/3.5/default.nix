{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  symlinkJoin,
  nixosTests,
  k3s,
}:

let
  version = "3.5.19";
  etcdSrcHash = "sha256-UulUIjl4HS1UHJnlamhtgVqzyH+UroCQ9zarxO5Hp6M=";
  etcdServerVendorHash = "sha256-0AXw44BpMlDQMML4HFQwdORetNrAZHlN2QG9aZwq5Ks=";
  etcdUtlVendorHash = "sha256-RZEsk79wQJnv/8W7tVCehNsqK2awkycd6gV/4OwqdFM=";
  etcdCtlVendorHash = "sha256-RESLrpgsWQV1Fm0vkQedlDowo+yWS4KipiwIcsCB34Y=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = etcdSrcHash;
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGo123Module {
    pname = "etcdserver";

    inherit
      env
      meta
      src
      version
      ;

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

  etcdutl = buildGo123Module rec {
    pname = "etcdutl";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdUtlVendorHash;

    modRoot = "./etcdutl";
  };

  etcdctl = buildGo123Module rec {
    pname = "etcdctl";

    inherit
      env
      meta
      src
      version
      ;

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
