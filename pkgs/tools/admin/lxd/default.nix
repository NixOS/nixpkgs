{ lib, symlinkJoin, fetchurl, callPackage
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq
, squashfsTools, iproute2, iptables, ebtables, iptables-nftables-compat
, qemu_kvm, qemu-utils, OVMF-secureBoot
, writeShellScriptBin, apparmor-profiles, apparmor-parser
, criu
, bash
, installShellFiles
, nftablesSupport ? false
, useQemu ? false
}:

let
  networkPkgs = if nftablesSupport then
    [ iptables-nftables-compat ]
  else
    [ iptables ebtables ];

  pname = "lxd";
  version = "4.13";

  src = fetchurl {
    url = "https://github.com/lxc/lxd/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0w2r80wf86jijgfxbkv06lgfhz4p2aaidsqd96bx3q1382nrbzcf";
  };

  lxdAgent = callPackage ./lxd-agent.nix {
    inherit src version;
  };

  lxdBin = callPackage ./lxd.nix {
    inherit src version;
  };

  apparmor_parser = writeShellScriptBin "apparmor_parser" ''
    exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
  '';

  binPath = lib.makeBinPath (
    networkPkgs
    ++ [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute2 bash criu ]
    ++ lib.optionals useQemu [ qemu-utils qemu_kvm lxdAgent ]
    ++ [ apparmor_parser ]
    ++ [ "$out" ]
  );

in
symlinkJoin {
  name = "${pname}-${version}";

  paths = [ lxdBin ];

  postBuild = "wrapProgram $out/bin/lxd --prefix PATH : ${binPath}"
    + lib.optionalString useQemu " --set LXD_OVMF_PATH $out/share/OVMF"
    + lib.optionalString useQemu ''

      mkdir -p $out/share/OVMF

      ln -s ${OVMF-secureBoot.fd}/FV/OVMF_CODE.fd $out/share/OVMF/OVMF_CODE.fd
      ln -s ${OVMF-secureBoot.fd}/FV/OVMF_VARS.fd $out/share/OVMF/OVMF_VARS.fd
      ln -s ${OVMF-secureBoot.fd}/FV/OVMF_VARS.fd $out/share/OVMF/OVMF_VARS.ms.fd
    '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz wucke13 ];
    platforms = platforms.linux;
  };
}
