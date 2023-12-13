{ lib, buildGoModule, fetchFromGitHub, symlinkJoin, nixosTests }:

let
  version = "3.5.10";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-X/de8YA55SZ6p8r/pV8CGxfDKN8voJlyA0r4ckan6ZE=";
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

    vendorHash = "sha256-kFR6RvHoNM4SZOgJd7inUuw5GfRLM+3WsKU73We8UzU=";

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

    vendorHash = "sha256-oVabZ2JZlLKHFCuAeeWRTrcSCxzz05HlvDu/YSMKuCs=";

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    vendorHash = "sha256-0j35caQfLh7kwDKgmTe1novqKfz/3JlQLbUk3+GFPhk=";

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
