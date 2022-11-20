{ lib, hwdata, pkg-config, lxc, buildGoModule, fetchurl, makeWrapper, acl, rsync
, gnutar, xz, btrfs-progs, gzip, dnsmasq, attr, squashfsTools, iproute2
, iptables, libcap, dqlite, raft-canonical, sqlite-replication, udev
, writeShellScriptBin, apparmor-profiles, apparmor-parser, criu, bash
, callPackage, installShellFiles, linkFarm, qemu_kvm, qemu-utils, OVMFFull
, nixosTests, useQemu ? true }:
let
  version = "5.8";
  src = fetchurl {
    urls = [
      "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz"
      "https://github.com/lxc/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz"
    ];
    sha256 = "sha256-mYyDYO8k4MVoNa8xfp1vH2nyuhNsDJ93s9F5hjaMftk=";
  };

  binPath = [
    acl
    attr
    bash
    btrfs-progs
    criu
    dnsmasq
    gnutar
    gzip
    iproute2
    iptables
    rsync
    squashfsTools
    xz

    (writeShellScriptBin "apparmor_parser" ''
      exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
    '')
  ] ++ (lib.optionals useQemu [ qemu-utils qemu_kvm ]);

  firmware = linkFarm "lxd-firmware" [
    {
      name = "share/OVMF/OVMF_CODE.fd";
      path = "${OVMFFull.fd}/FV/OVMF_CODE.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.fd";
      path = "${OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.ms.fd";
      path = "${OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
  ];

  LXD_OVMF_PATH = "${firmware}/share/OVMF";

in buildGoModule rec {
  pname = "lxd";
  inherit src version;

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
    sqlite-replication
    udev.dev
  ];

  ldflags = [ "-s" "-w" ];
  tags = [ "libsqlite3" ];

  preBuild = ''
    # required for go-dqlite. See: https://github.com/lxc/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  preCheck = let
    skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ];
  in ''
    # Disable tests requiring local operations
    buildFlagsArray+=("-run" "[^(${
      builtins.concatStringsSep "|" skippedTests
    })]")
  '';

  postInstall = ''
    wrapProgram $out/bin/lxd --prefix PATH : ${lib.makeBinPath binPath} ${
      lib.optionalString useQemu " --set LXD_OVMF_PATH ${LXD_OVMF_PATH}"
    }

    installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
  '';

  passthru.tests = {
    inherit (nixosTests) lxd lxd-nftables lxd-qemu;
  };

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    changelog = "https://github.com/lxc/lxd/releases/tag/lxd-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ifd3f ];
    platforms = platforms.linux;
  };
}
