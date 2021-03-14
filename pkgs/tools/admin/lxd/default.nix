{ lib, hwdata, pkg-config, lxc, buildGoPackage, fetchurl
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq
, squashfsTools, iproute, iptables, ebtables, iptables-nftables-compat, libcap
, libco-canonical, dqlite, raft-canonical, sqlite-replication, udev
, writeShellScriptBin, apparmor-profiles, apparmor-parser
, criu
, bash
, installShellFiles
, nftablesSupport ? false
}:

let
  networkPkgs = if nftablesSupport then
    [ iptables-nftables-compat ]
  else
    [ iptables ebtables ];

in
buildGoPackage rec {
  pname = "lxd";
  version = "4.12";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://github.com/lxc/lxd/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1qgi9ciljq8h3ja9kalfvnxnjymddd5j4agv984137z443mqfnrw";
  };

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  preBuild = ''
    # unpack vendor
    pushd go/src/github.com/lxc/lxd
    rm _dist/src/github.com/lxc/lxd
    cp -r _dist/src/* ../../..
    popd
  '';

  buildFlags = [ "-tags libsqlite3" ];

  postInstall = ''
    # test binaries, code generation
    rm $out/bin/{deps,macaroon-identity,generate}

    wrapProgram $out/bin/lxd --prefix PATH : ${lib.makeBinPath (
      networkPkgs
      ++ [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute bash criu ]
      ++ [ (writeShellScriptBin "apparmor_parser" ''
             exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
           '') ]
      )
    }

    installShellCompletion --bash --name lxd go/src/github.com/lxc/lxd/scripts/bash/lxd-client
  '';

  nativeBuildInputs = [ installShellFiles pkg-config makeWrapper ];
  buildInputs = [ lxc acl libcap libco-canonical.dev dqlite.dev
                  raft-canonical.dev sqlite-replication udev.dev ];

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz wucke13 ];
    platforms = platforms.linux;
  };
}
