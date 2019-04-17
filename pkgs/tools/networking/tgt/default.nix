{ stdenv, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages
, docbook_xsl }:

let
  version = "1.0.76";
in stdenv.mkDerivation rec {
  name = "tgt-${version}";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = "tgt";
    rev = "v${version}";
    sha256 = "1q01ay0zn5gmy6df1iw1ic11p8zygxlp0r3nd887vvvjvlp3xrvc";
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
