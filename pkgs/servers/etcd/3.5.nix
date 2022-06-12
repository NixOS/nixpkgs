{ lib, buildGoModule, fetchFromGitHub, symlinkJoin }:

let
  etcdVersion = "3.5.4";
  etcdSrc = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${etcdVersion}";
    sha256 = "sha256-mTQHxLLfNiihvHg5zaTeVNWKuzvE0KBiJdY3qMJHMCM=";
  };

  commonMeta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline zowoq endocrimes ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule rec {
    pname = "etcdserver";
    version = etcdVersion;

    vendorSha256 = "sha256-4djUQvWp9hScua9l1ZTq298zWSeDYRDojEt2AWmarzw=";

    src = etcdSrc;
    modRoot = "./server";

    postBuild = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    CGO_ENABLED = 0;

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];

    meta = commonMeta;
  };

  etcdutl = buildGoModule rec {
    pname = "etcdutl";
    version = etcdVersion;

    vendorSha256 = "sha256-nk56XGpNsDwcGrTKithKGnPCX0NhpQmzNSXHk3vmdtg=";

    src = etcdSrc;
    modRoot = "./etcdutl";

    CGO_ENABLED = 0;

    meta = commonMeta;
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";
    version = etcdVersion;

    vendorSha256 = "sha256-WIMYrXfay6DMz+S/tIc/X4ffMizxub8GS1DDgIR40D4=";

    src = etcdSrc;
    modRoot = "./etcdctl";

    CGO_ENABLED = 0;

    meta = commonMeta;
  };
in
symlinkJoin {
  name = "etcd";
  version = etcdVersion;
  meta = commonMeta;

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
