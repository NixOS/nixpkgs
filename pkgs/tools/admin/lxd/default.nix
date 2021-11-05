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
  version = "4.19";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz";
    sha256 = "0mxbzg8xra0qpd3g3z1b230f0519h56x4jnn09lbbqa92p5zck3f";
  };

  patches = [
    # lxd/checkfeature: check whether the kernel supports core scheduling
    (fetchpatch {
      url = "https://github.com/lxc/lxd/commit/ba6be1043714458b29c4b37687d4f624ee421943.patch";
      sha256 = "0716129n70c6i695fyi1j8q6cls7g62vkdpcrlfrr9i324y3w1dx";
    })
    # feat: add support for nixOS path
    (fetchpatch {
      url = "https://github.com/lxc/lxd/commit/eeace06b2e3151786e94811ada8c658cce479f6d.patch";
      sha256 = "sha256-knXlvcSvMPDeR0KqHFgh6YQZc+CSJ8yEqGE/vQMciEk=";
    })
  ];

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
