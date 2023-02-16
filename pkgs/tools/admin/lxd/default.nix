{ lib
, hwdata
, pkg-config
, lxc
, buildGoModule
, fetchurl
, makeWrapper
, acl
, rsync
, gnutar
, xz
, btrfs-progs
, gzip
, dnsmasq
, attr
, squashfsTools
, iproute2
, iptables
, libcap
, dqlite
, raft-canonical
, sqlite
, udev
, writeShellScriptBin
, apparmor-profiles
, apparmor-parser
, criu
, bash
, installShellFiles
, nixosTests
}:

buildGoModule rec {
  pname = "lxd";
  version = "5.10";

  src = fetchurl {
    urls = [
      "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz"
      "https://github.com/lxc/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz"
    ];
    hash = "sha256-sYJkPr/tE22xJEjKX7fMjOLQ9zBDm52UjqbVLrm39zU=";
  };

  vendorSha256 = null;

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [ "test" "lxd/db/generate" ];

  nativeBuildInputs = [ installShellFiles pkg-config makeWrapper ];
  buildInputs = [
    lxc
    acl
    libcap
    dqlite.dev
    raft-canonical.dev
    sqlite
    udev.dev
  ];

  ldflags = [ "-s" "-w" ];
  tags = [ "libsqlite3" ];

  preBuild = ''
    # required for go-dqlite. See: https://github.com/lxc/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  preCheck =
    let skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ]; in
    ''
      # Disable tests requiring local operations
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
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

    installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
  '';

  passthru.tests.lxd = nixosTests.lxd;
  passthru.tests.lxd-nftables = nixosTests.lxd-nftables;

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    changelog = "https://github.com/lxc/lxd/releases/tag/lxd-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam adamcstephens ];
    platforms = platforms.linux;
  };
}
