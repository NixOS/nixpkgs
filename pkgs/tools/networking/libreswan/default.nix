{ stdenv, fetchurl, makeWrapper,
  pkgconfig, systemd, gmp, unbound, bison, flex, pam, libevent, libcap_ng, curl, nspr,
  bash, iproute, iptables, procps, coreutils, gnused, gawk, nss, which, python,
  docs ? false, xmlto
  }:

let
  optional = stdenv.lib.optional;
  version = "3.18";
  name = "libreswan-${version}";
  binPath = stdenv.lib.makeBinPath [
    bash iproute iptables procps coreutils gnused gawk nss.tools which python
  ];
in

assert docs -> xmlto != null;

stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://download.libreswan.org/${name}.tar.gz";
    sha256 = "0zginnakxw7m79zrdvfdvliaiyg78zgqfqkks9z5d1rjj5w13xig";
  };

  # These flags were added to compile v3.18. Try to lift them when updating.
  NIX_CFLAGS_COMPILE = [ "-Wno-error=redundant-decls" "-Wno-error=format-nonliteral"
    # these flags were added to build with gcc7
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=format-truncation"
    "-Wno-error=pointer-compare"
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ bash iproute iptables systemd coreutils gnused gawk gmp unbound bison flex pam libevent
                  libcap_ng curl nspr nss python ]
                ++ optional docs xmlto;

  prePatch = ''
    # Correct bash path
    sed -i -e 's|/bin/bash|/usr/bin/env bash|' mk/config.mk

    # Fix systemd unit directory, and prevent the makefile from trying to reload the systemd daemon
    sed -i -e 's|UNITDIR=.*$|UNITDIR=$\{out}/etc/systemd/system/|' -e 's|systemctl --system daemon-reload|true|' initsystems/systemd/Makefile

    # Fix the ipsec program from crushing the PATH
    sed -i -e 's|\(PATH=".*"\):.*$|\1:$PATH|' programs/ipsec/ipsec.in

    # Fix python script to use the correct python
    sed -i -e 's|#!/usr/bin/python|#!/usr/bin/env python|' -e 's/^\(\W*\)installstartcheck()/\1sscmd = "ss"\n\0/' programs/verify/verify.in
  '';

  patches = [ ./libreswan-3.18-glibc-2.26.patch ];

  # Set appropriate paths for build
  preBuild = "export INC_USRLOCAL=\${out}";

  makeFlags = [
    "INITSYSTEM=systemd"
    (if docs then "all" else "base")
  ];

  installTargets = [ (if docs then "install" else "install-base") ];
  # Hack to make install work
  installFlags = [
    "FINALVARDIR=\${out}/var"
    "FINALSYSCONFDIR=\${out}/etc"
  ];

  postInstall = ''
    for i in $out/bin/* $out/libexec/ipsec/*; do
      wrapProgram "$i" --prefix PATH ':' "$out/bin:${binPath}"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://libreswan.org;
    description = "A free software implementation of the VPN protocol based on IPSec and the Internet Key Exchange";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.freebsd;
    license = licenses.gpl2;
    maintainers = [ maintainers.afranchuk ];
  };
}
