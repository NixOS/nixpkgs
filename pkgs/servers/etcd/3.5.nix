{ lib, buildGoModule, fetchFromGitHub, symlinkJoin }:

let
  etcdVersion = "3.5.1";
  etcdSrc = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${etcdVersion}";
    sha256 = "sha256-Ip7JAWbZBZcc8MXd+Sw05QmTs448fQXpQ5XXo6RW+Gs=";
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

    vendorSha256 = "sha256-hJzmxCcwN6MTgE0NpjtFlm8pjZ83clQXv1k5YM8Gmes=";

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

    vendorSha256 = "sha256-My0kzsN2i8DgPm2yIkbql3VyMXPaHmQSeaa/uK/RFxo=";

    src = etcdSrc;
    modRoot = "./etcdutl";

    CGO_ENABLED = 0;

    meta = commonMeta;
  };

  etcdctl = buildGoModule rec {
    pname = "etcdutl";
    version = etcdVersion;

    vendorSha256 = "sha256-XZKBA95UrhbiefnDvpaXcBA0wUjnpH+Pb6yXp7yc4HQ=";

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
