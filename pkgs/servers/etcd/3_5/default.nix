{
  applyPatches,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  k3s,
  lib,
  nixosTests,
  symlinkJoin,
}:

let
  version = "3.5.22";
  etcdSrcHash = "sha256-tS1IFMxfb8Vk9HJTAK+BGPZiVE3ls4Q2DQSerALOQCc=";
  etcdServerVendorHash = "sha256-ul3R0c6RoCqLvlD2dfso1KwfHjsHfzQiUVJZJmz28ks=";
  etcdUtlVendorHash = "sha256-S2pje2fTDaZwf6jnyE2YXWcs/fgqF51nxCVfEwg0Gsw=";
  etcdCtlVendorHash = "sha256-lZ6o0oWUsc3WiCa87ynm7UAG6VxTf81a301QMSPOvW0=";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "etcd-io";
      repo = "etcd";
      tag = "v${version}";
      hash = etcdSrcHash;
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/etcd-io/etcd/commit/31650ab0c8df43af05fc4c13b48ffee59271eec7.patch";
        hash = "sha256-Q94HOLFx2fnb61wMQsAUT4sIBXfxXqW9YEayukQXX18=";
      })
    ];
  };
  env = {
    CGO_ENABLED = 0;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [
      dtomvan
    ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule {
    pname = "etcdserver";

    inherit
      env
      meta
      src
      version
      ;

    __darwinAllowLocalNetworking = true;

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

  etcdutl = buildGoModule {
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

  etcdctl = buildGoModule {
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
    deps = {
      inherit etcdserver etcdutl etcdctl;
    };

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
