{ lib
, hwdata
, pkg-config
, lxc
, buildGoModule
, fetchurl
<<<<<<< HEAD
, acl
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libcap
, dqlite
, raft-canonical
, sqlite
, udev
<<<<<<< HEAD
, installShellFiles
, nixosTests
, gitUpdater
, callPackage
}:

buildGoModule rec {
  pname = "lxd-unwrapped";
  version = "5.17";

  src = fetchurl {
    url = "https://github.com/canonical/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz";
    hash = "sha256-21pw8Q8UYjuxdaKzNXoTanxxyTNRXXbuerIZPIQK4yg=";
=======
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
  version = "5.13";

  src = fetchurl {
    urls = [
      "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz"
      "https://github.com/lxc/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz"
    ];
    hash = "sha256-kys8zfqhkpJqq4ICg6dOsoJEoxJ209GwdjGRrfrZ7j0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

<<<<<<< HEAD
  excludedPackages = [ "test" "lxd/db/generate" "lxd-agent" "lxd-migrate" ];

  nativeBuildInputs = [ installShellFiles pkg-config ];
=======
  excludedPackages = [ "test" "lxd/db/generate" ];

  nativeBuildInputs = [ installShellFiles pkg-config makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # required for go-dqlite. See: https://github.com/canonical/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  # build static binaries: https://github.com/canonical/lxd/blob/6fd175c45e65cd475d198db69d6528e489733e19/Makefile#L43-L51
  postBuild = ''
    make lxd-agent lxd-migrate
  '';

=======
    # required for go-dqlite. See: https://github.com/lxc/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    wrapProgram $out/bin/lxd --prefix PATH : ${lib.makeBinPath (
      [ iptables ]
      ++ [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute2 bash criu attr ]
      ++ [ (writeShellScriptBin "apparmor_parser" ''
             exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
           '') ]
      )
    }

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
  '';

  passthru.tests.lxd = nixosTests.lxd;
<<<<<<< HEAD
  passthru.ui = callPackage ./ui.nix { };
  passthru.updateScript = gitUpdater {
    url = "https://github.com/canonical/lxd.git";
    rev-prefix = "lxd-";
  };

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://ubuntu.com/lxd";
    changelog = "https://github.com/canonical/lxd/releases/tag/lxd-${version}";
=======
  passthru.tests.lxd-nftables = nixosTests.lxd-nftables;

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    changelog = "https://github.com/lxc/lxd/releases/tag/lxd-${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam adamcstephens ];
    platforms = platforms.linux;
  };
}
