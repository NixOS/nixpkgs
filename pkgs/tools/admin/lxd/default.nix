{ lib, hwdata, pkg-config, lxc, buildGoPackage, fetchurl
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq, attr
, squashfsTools, iproute2, iptables, libcap
, dqlite, raft-canonical, sqlite-replication, udev
, writeShellScriptBin, apparmor-profiles, apparmor-parser
, criu
, bash
, installShellFiles
, nixosTests
}:

buildGoPackage rec {
  pname = "lxd";
  version = "5.5";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    urls = [
      "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz"
      "https://github.com/lxc/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz"
    ];
    sha256 = "sha256-Ri5mwDtesI6vOjtb5L5zBD469jIYx5rxAJib0Bja8ps=";
  };

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [ "test" "lxd/db/generate" ];

  preBuild = ''
    # required for go-dqlite. See: https://github.com/lxc/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"

    makeFlagsArray+=("-tags libsqlite3")
  '';

  postInstall = ''
    wrapProgram $out/bin/lxd --prefix PATH : ${lib.makeBinPath (
      [ iptables ]
      ++ [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute2 bash criu attr ]
      ++ [ (writeShellScriptBin "apparmor_parser" ''
             exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
           '') ]
      )
    }

    installShellCompletion --bash --name lxd go/src/github.com/lxc/lxd/scripts/bash/lxd-client
  '';

  passthru.tests.lxd = nixosTests.lxd;
  passthru.tests.lxd-nftables = nixosTests.lxd-nftables;

  nativeBuildInputs = [ installShellFiles pkg-config makeWrapper ];
  buildInputs = [ lxc acl libcap dqlite.dev raft-canonical.dev
                  sqlite-replication udev.dev ];

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    changelog = "https://github.com/lxc/lxd/releases/tag/lxd-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
    platforms = platforms.linux;
  };
}
