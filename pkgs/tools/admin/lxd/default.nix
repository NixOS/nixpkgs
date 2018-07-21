{ stdenv, pkgconfig, lxc, buildGoPackage, fetchurl
, makeWrapper, acl, rsync, gnutar, xz, btrfs-progs, gzip, dnsmasq
, squashfsTools, iproute, iptables, ebtables
}:

buildGoPackage rec {
  name = "lxd-3.0.0";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchurl {
    url = "https://github.com/lxc/lxd/releases/download/${name}/${name}.tar.gz";
    sha256 = "0m5prdf9sk8k5bws1zva4n9ycggmy76wnjr6wb423066pszz24ww";
  };

  preBuild = ''
    # unpack vendor
    pushd go/src/github.com/lxc/lxd
    rm dist/src/github.com/lxc/lxd
    cp -r dist/src/* ../../..
    rm -r dist
    popd
  '';

  postInstall = ''
    # binaries from test/
    rm $bin/bin/{deps,macaroon-identity}

    wrapProgram $bin/bin/lxd --prefix PATH ":" ${stdenv.lib.makeBinPath [
      acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute iptables ebtables
    ]}
  '';

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ lxc acl ];

  meta = with stdenv.lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = https://linuxcontainers.org/lxd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.linux;
  };
}
