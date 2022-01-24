{ lib, hwdata, pkg-config, lxc, buildGoPackage, fetchurl, fetchpatch
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
  version = "4.22";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz";
    sha256 = "119345936fcm1vv06k82k9hvj5yjf9jdrwqm9ccphhl5mswf8xq9";
  };

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  preBuild = ''
    # required for go-dqlite. See: https://github.com/lxc/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"

    makeFlagsArray+=("-tags libsqlite3")
  '';

  postInstall = ''
    # test binaries, code generation
    rm $out/bin/{deps,macaroon-identity,generate}

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

  nativeBuildInputs = [ installShellFiles pkg-config makeWrapper ];
  buildInputs = [ lxc acl libcap dqlite.dev raft-canonical.dev
                  sqlite-replication udev.dev ];

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz wucke13 marsam ];
    platforms = platforms.linux;
  };
}
