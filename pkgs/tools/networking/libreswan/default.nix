{ lib, stdenv, fetchurl, makeWrapper,
  pkg-config, systemd, gmp, unbound, bison, flex, pam, libevent, libcap_ng, curl, nspr,
  bash, iproute, iptables, procps, coreutils, gnused, gawk, nss, which, python,
  docs ? false, xmlto, libselinux, ldns
  }:

let
  binPath = lib.makeBinPath [
    bash iproute iptables procps coreutils gnused gawk nss.tools which python
  ];
in

assert docs -> xmlto != null;
assert stdenv.isLinux -> libselinux != null;

stdenv.mkDerivation rec {
  pname = "libreswan";
  version = "4.1";

  src = fetchurl {
    url = "https://download.libreswan.org/${pname}-${version}.tar.gz";
    sha256 = "0z92v5a5j6lx2ahx8aqjnk28zk6rlmpqaj06hbavxrzdlb1l8r11";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ bash iproute iptables systemd coreutils gnused gawk gmp unbound bison flex pam libevent
                  libcap_ng curl nspr nss python ldns ]
                ++ lib.optional docs xmlto
                ++ lib.optional stdenv.isLinux libselinux;

  prePatch = ''
    # Correct bash path
    sed -i -e 's|/bin/bash|/usr/bin/env bash|' mk/config.mk

    # Fix systemd unit directory, and prevent the makefile from trying to reload the
    # systemd daemon or create tmpfiles
    sed -i -e 's|systemctl|true|g' \
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
    "UNITDIR=$(out)/etc/systemd/system/" "TMPFILESDIR=$(out)/tmpfiles.d/"
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

  meta = with lib; {
    homepage = "https://libreswan.org";
    description = "A free software implementation of the VPN protocol based on IPSec and the Internet Key Exchange";
    platforms = platforms.linux ++ platforms.freebsd;
    license = licenses.gpl2;
    maintainers = [ maintainers.afranchuk ];
  };
}
