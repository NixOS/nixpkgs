{ stdenv, fetchurl, dpkg, gawk, perl, wget, coreutils, utillinux
, gnugrep, gnutar, gnused, gzip, makeWrapper }:
# USAGE like this: debootstrap sid /tmp/target-chroot-directory
# There is also cdebootstrap now. Is that easier to maintain?
let binPath = stdenv.lib.makeBinPath [
    coreutils
    dpkg
    gawk
    gnugrep
    gnused
    gnutar
    gzip
    perl
    wget
  ];
in stdenv.mkDerivation rec {
  pname = "debootstrap";
  version = "1.0.117";

  src = fetchurl {
    # git clone git://git.debian.org/d-i/debootstrap.git
    # I'd like to use the source. However it's lacking the lanny script ? (still true?)
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.tar.gz";
    sha256 = "0rsdw1yjkx35jd1i45646l07glnwsn9gzd6k8sjccv2xvhcljq77";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace debootstrap \
      --replace 'CHROOT_CMD="chroot '  'CHROOT_CMD="${coreutils}/bin/chroot ' \
      --replace 'CHROOT_CMD="unshare ' 'CHROOT_CMD="${utillinux}/bin/unshare ' \
      --replace /usr/bin/dpkg ${dpkg}/bin/dpkg \
      --replace '#!/bin/sh' '#!/bin/bash' \
      --subst-var-by VERSION ${version}

    d=$out/share/debootstrap
    mkdir -p $out/{share/debootstrap,bin}

    mv debootstrap $out/bin

    cp -r . $d

    wrapProgram $out/bin/debootstrap \
      --set PATH ${binPath} \
      --set-default DEBOOTSTRAP_DIR $d

    mkdir -p $out/man/man8
    mv debootstrap.8 $out/man/man8

    rm -rf $d/debian

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tool to create a Debian system in a chroot";
    homepage = https://wiki.debian.org/Debootstrap;
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
