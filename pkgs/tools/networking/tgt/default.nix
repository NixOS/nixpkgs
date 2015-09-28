{ stdenv, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages }:

let
  version = "1.0.60";
in stdenv.mkDerivation rec {
  name = "tgt-${version}";
  src = fetchFromGitHub {
    owner = "fujita";
    repo = "tgt";
    rev = "ab51727a361bf296b1c2036375b5e45479059921";
    sha256 = "1bf8rn3mavjrzkp5k23akqn5ilw43g8mpfr68z1bi8s9lr2gkf37";
  };

  buildInputs = [ libxslt systemd libaio ];

  DESTDIR = "$(out)";
  PREFIX = "/";
  SD_NOTIFY="1";

  preConfigure = ''
    sed -i 's|/usr/bin/||' doc/Makefile
    sed -i 's|/usr/include/libaio.h|${libaio}/include/libaio.h|' usr/Makefile
    sed -i 's|/usr/include/sys/|${stdenv.glibc}/include/sys/|' usr/Makefile
    sed -i 's|/usr/include/linux/|${stdenv.glibc}/include/linux/|' usr/Makefile
  '';

  postInstall = ''
    sed -i 's|#!/usr/bin/perl|#! ${perl}/bin/perl -I${perlPackages.ConfigGeneral}/${perl.libPrefix}|' $out/sbin/tgt-admin
  '';

  enableParallelBuilding = true;
  meta = {
    description = "iSCSI Target daemon with rdma support";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}