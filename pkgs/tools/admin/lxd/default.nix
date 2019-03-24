{ stdenv, pkgconfig, lxc, buildGoPackage, fetchurl, fetchpatch
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq
, squashfsTools, iproute, iptables, ebtables, libcap, dqlite
, sqlite-replication
, writeShellScriptBin, apparmor-profiles, apparmor-parser
, bash
}:

buildGoPackage rec {
  pname = "lxd";
  version = "3.11";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://github.com/lxc/lxd/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0xxzrwhyzzp23arj57vjs1yh91gy3r4wpd5qy9ksifzd390clf2x";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/CanonicalLtd/go-dqlite/commit/88a96df66e3e3bdc290fd4a0d41615d284d2c92c.patch;
      sha256 = "0z6r4shh1rlf0in9xk1gi6ms2kcvplc3878106d2zzzfz7ad83a4";
      extraPrefix = "dist/src/github.com/CanonicalLtd/go-dqlite/";
      stripLen = 1;
    })
  ];

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
