{ stdenv, fetchurl, makeWrapper,
  pkgconfig, systemd, gmp, unbound, bison, flex, pam, libevent, libcap_ng, curl, nspr,
  bash, iproute, iptables, procps, coreutils, gnused, gawk, nss, which, python,
  docs ? false, xmlto, libselinux, ldns
  }:

let
  optional = stdenv.lib.optional;
  version = "3.31";
  name = "libreswan-${version}";
  binPath = stdenv.lib.makeBinPath [
    bash iproute iptables procps coreutils gnused gawk nss.tools which python
  ];
in

assert docs -> xmlto != null;
assert stdenv.isLinux -> libselinux != null;

stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://download.libreswan.org/${name}.tar.gz";
    sha256 = "1wxqsv11nqgfj5and5xzfgh6ayqvl47midcghd5ryynh60mp7naa";
  };

  # These flags were added to compile v3.18. Try to lift them when updating.
  NIX_CFLAGS_COMPILE = toString [ "-Wno-error=redundant-decls" "-Wno-error=format-nonliteral"
    # these flags were added to build with gcc7
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=format-truncation"
    "-Wno-error=pointer-compare"
    "-Wno-error=stringop-truncation"
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ bash iproute iptables systemd coreutils gnused gawk gmp unbound bison flex pam libevent
                  libcap_ng curl nspr nss python ldns ]
                ++ optional docs xmlto
                ++ optional stdenv.isLinux libselinux;

  prePatch = ''
    # Correct bash path
    sed -i -e 's|/bin/bash|/usr/bin/env bash|' mk/config.mk

    # Fix systemd unit directory, and prevent the makefile from trying to reload the
    # systemd daemon or create tmpfiles
    sed -i -e 's|UNITDIR=.*$|UNITDIR=$\{out}/etc/systemd/system/|g' \
      -e 's|TMPFILESDIR=.*$|TMPFILESDIR=$\{out}/tmpfiles.d/|g' \
      -e 's|systemctl|true|g' \
      -e 's|systemd-tmpfiles|true|g' \
      initsystems/systemd/Makefile

    # Fix the ipsec program from crushing the PATH
    sed -i -e 's|\(PATH=".*"\):.*$|\1:$PATH|' programs/ipsec/ipsec.in

    # Fix python script to use the correct python
    sed -i -e 's|#!/usr/bin/python|#!/usr/bin/env python|' -e 's/^\(\W*\)installstartcheck()/\1sscmd = "ss"\n\0/' programs/verify/verify.in
  '';

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
    homepage = "https://libreswan.org";
    description = "A free software implementation of the VPN protocol based on IPSec and the Internet Key Exchange";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.freebsd;
    license = licenses.gpl2;
    maintainers = [ maintainers.afranchuk ];
  };
}
