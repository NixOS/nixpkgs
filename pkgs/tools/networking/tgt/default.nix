{ stdenv, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages
, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "tgt";
  version = "1.0.78";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = pname;
    rev = "v${version}";
    sha256 = "0778silfwvbpqljxdid96nn0vkdii3fszqp6w6w2bn9hdyxhqrjp";
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

  meta = {
    description = "iSCSI Target daemon with rdma support";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
