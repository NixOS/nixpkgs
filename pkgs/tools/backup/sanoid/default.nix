{ stdenv, fetchFromGitHub, zfs, procps, openssh, pv, mbuffer, sudo, coreutils, perl, perlPackages, lzop, gzip }:

stdenv.mkDerivation rec {
  name = "sanoid-${version}";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "jimsalterjrs";
    repo = "sanoid";
    rev = "633c5e237d375689a43bc6de4ab78714dcb8d4e1";
    sha256 = "1qfrqb13hscb118z5z1q2bjpxynqlby8xxl14kfza1nvnqnrllk7";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/etc

    install -m 755 findoid $out/bin/findoid
    install -m 755 sanoid $out/bin/sanoid
    install -m 755 sleepymutex $out/bin/sleepymutex
    install -m 755 syncoid $out/bin/syncoid
    install -m 644 sanoid.defaults.conf $out/etc/sanoid.defaults.conf

    substituteInPlace $out/bin/findoid --replace '/sbin/zfs' ${zfs}/bin/zfs
    substituteInPlace $out/bin/findoid --replace '/usr/bin/perl' ${perl}/bin/perl
    substituteInPlace $out/bin/sanoid --replace '/sbin/zfs' ${zfs}/bin/zfs
    substituteInPlace $out/bin/sanoid --replace '/bin/ps' ${procps}/bin/ps
    substituteInPlace $out/bin/sanoid --replace '/etc/sanoid' $out/etc
    substituteInPlace $out/bin/sanoid --replace "\$args{'configdir'}/sanoid.conf" /etc/sanoid.conf
    substituteInPlace $out/bin/sanoid --replace '/usr/bin/perl' "${perl}/bin/perl -I${perlPackages.ConfigIniFiles}/${perl.libPrefix}"
    substituteInPlace $out/bin/syncoid --replace '/sbin/zfs' '/usr/bin/env zfs'
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/ssh' ${openssh}/bin/ssh
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/pv' ${pv}/bin/pv
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/mbuffer' '/usr/bin/env mbuffer'
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/sudo' '/usr/bin/env sudo'
    substituteInPlace $out/bin/syncoid --replace '/bin/ls' ${coreutils}/bin/ls
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/perl' ${perl}/bin/perl
    substituteInPlace $out/bin/syncoid --replace '/bin/gzip' '/usr/bin/env gzip'
    substituteInPlace $out/bin/syncoid --replace '/bin/zcat' '/usr/bin/env zcat'
    substituteInPlace $out/bin/syncoid --replace '/usr/bin/lzop' '/usr/bin/env lzop'
  '';

  meta = {
    description = "Policy-driven snapshot management and replication tools for ZFS";
    homepage    = "http://www.openoid.net/products/";
    license     = stdenv.lib.licenses.gpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ otwieracz ];
  };
}
