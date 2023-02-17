{ lib, buildGoModule, fetchFromGitHub, symlinkJoin }:

let
  version = "3.5.7";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-VgWY622RJ8f4yA6TRC5IvatVFw2CP5lN3QBS3Xaevbc=";
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

    vendorHash = "sha256-w/aWrQF/PAWTGMFUcpHiiDef6cvLLdYP06iwBdxrGkQ=";

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

    vendorHash = "sha256-Bq5vOZCflLDAhhmwSww9JCahfL/JHKa3ZT4cwNXzW90=";

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

    vendorHash = "sha256-KUr0SrfuE5sh54THdvJwuMO/U6O+civ6onEPzNGqf18=";

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
