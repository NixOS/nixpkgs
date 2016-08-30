{ stdenv, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages
, docbook_xsl }:

let
  version = "1.0.63";
in stdenv.mkDerivation rec {
  name = "tgt-${version}";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = "tgt";
    rev = "v${version}";
    sha256 = "1x3irnbfikdqhlikhwqazg0g0hc1df5r2bp001f13sr0nvw28y1n";
  };

  buildInputs = [ libxslt systemd libaio docbook_xsl ];

  DESTDIR = "$(out)";
  PREFIX = "/";
  SD_NOTIFY="1";

  preConfigure = ''
    sed -i 's|/usr/bin/||' doc/Makefile
    sed -i 's|/usr/include/libaio.h|${libaio}/include/libaio.h|' usr/Makefile
    sed -i 's|/usr/include/sys/|${stdenv.glibc.dev}/include/sys/|' usr/Makefile
    sed -i 's|/usr/include/linux/|${stdenv.glibc.dev}/include/linux/|' usr/Makefile
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
