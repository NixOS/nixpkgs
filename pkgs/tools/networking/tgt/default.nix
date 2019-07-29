{ stdenv, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages
, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "tgt";
  version = "1.0.79";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = pname;
    rev = "v${version}";
    sha256 = "18bp7fcpv7879q3ppdxlqj7ayqmlh5zwrkz8gch6rq9lkmmrklrf";
  };

  buildInputs = [ libxslt systemd libaio docbook_xsl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SD_NOTIFY=1"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

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

  meta = with stdenv.lib; {
    description = "iSCSI Target daemon with RDMA support";
    homepage = "http://stgt.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
