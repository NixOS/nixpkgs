{ stdenv, pkgconfig, lxc, buildGoPackage, fetchurl, fetchpatch
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq
, squashfsTools, iproute, iptables, ebtables, libcap, dqlite
, sqlite-replication
, writeShellScriptBin, apparmor-profiles, apparmor-parser
, bash
}:

buildGoPackage rec {
  pname = "lxd";
  version = "3.12";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://github.com/lxc/lxd/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0m2cq41mz5209csr07gsnmslqvqdxk2p1l2saa23ddnaybqnjy16";
  };

  preBuild = ''
    # unpack vendor
    pushd go/src/github.com/lxc/lxd
    rm dist/src/github.com/lxc/lxd
    cp -r dist/src/* ../../..
    rm -r dist
    popd
  '';

  buildFlags = [ "-tags libsqlite3" ];

  postInstall = ''
    # test binaries, code generation
    rm $bin/bin/{deps,macaroon-identity,generate}

    wrapProgram $bin/bin/lxd --prefix PATH : ${stdenv.lib.makeBinPath [
      acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute iptables ebtables bash
      (writeShellScriptBin "apparmor_parser" ''
        exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
      '')
    ]}
  '';

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ lxc acl libcap dqlite sqlite-replication ];

  meta = with stdenv.lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = https://linuxcontainers.org/lxd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.linux;
  };
}
