{ lib, buildGoModule, fetchFromGitHub, symlinkJoin }:

let
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-V10aeYwr1ZS990lYZELJjq8NX7cBs0bzlYYzoYWS3zQ=";
  };

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline zowoq endocrimes ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule rec {
    pname = "etcdserver";

    inherit CGO_ENABLED meta src version;

    vendorSha256 = "sha256-BTIrLgUXnV+0d0DTKE3TvvW2JH4oSE+SnJs+yfH26Ms=";

    modRoot = "./server";

    postBuild = ''
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

    vendorSha256 = "sha256-yUgrKIjCtYTLmdZe1p9Rx9MUZzqOAmNF4tUckJgF8Ks=";

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    vendorSha256 = "sha256-qT8OJg4aTzz0p0s6yhmDYcfJ0p9KNbnlRbOCfOao0vk=";

    modRoot = "./etcdctl";
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  passthru = { inherit etcdserver etcdutl etcdctl; };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
