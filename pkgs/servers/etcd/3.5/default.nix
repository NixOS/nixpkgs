{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  symlinkJoin,
  nixosTests,
  k3s,
}:

let
  version = "3.5.21";
  etcdSrcHash = "sha256-0L/lA9/9SNKMz74R6UPF1I7gj03/e91EpNr4LxKoisw=";
  etcdServerVendorHash = "sha256-JMxkcDibRcXhU+T7BQMAz95O7xDKefu1YPZK0GU7osk=";
  etcdUtlVendorHash = "sha256-901QcnEQ8PWnkliqwL4CrbCD+0ja8vJlDke0P4ya8cA=";
  etcdCtlVendorHash = "sha256-BJ924wRPQTqbqtNtXL3l/OSdQv1UmU1y6Zqu//EWTHI=";

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
