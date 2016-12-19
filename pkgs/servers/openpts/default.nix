{ stdenv, fetchurl, autoconf, automake, pkgconfig, libtool, trousers, openssl, libxml2, libuuid, gettext, perl }:

stdenv.mkDerivation rec {
  name = "openpts-${version}";
  version = "0.2.6";

  src = fetchurl {
    url = "http://jaist.dl.osdn.jp/openpts/54410/openpts-${version}.tar.gz";
    sha256 = "1b5phshl49fxr5y3g5zz75gm0n4cw8i7n29x5f1a95xkwrjpazi0";
  };

  # patches from https://apps.fedoraproject.org/packages/openpts/sources/patches/
  patches = [ ./bugs.patch ./zlib.patch ./tboot.patch ./ptsc.patch ];

  buildInputs = [ autoconf automake pkgconfig libtool trousers openssl libxml2 libuuid gettext ];

  preConfigure = ''
    substituteInPlace include/Makefile.am --replace "./cvs2msg.pl" "${perl}/bin/perl cvs2msg.pl";
    $SHELL bootstrap.sh
    '';

  configureFlags = [ "--with-tss" "--with-aru" "--with-tboot" "--enable-tnc" "--with-aide" ];

  NIX_CFLAGS_COMPILE = "-I${trousers}/include/trousers -I${trousers}/include/tss -Wno-deprecated-declarations";

  preInstall = ''
    mkdir -p $out
    mkdir -p $out/etc
    cp -p dist/ptsc.conf.in $out/etc/ptsc.conf
    cp -p dist/ptsv.conf.in $out/etc/ptsv.conf
    mkdir -p $out/share/openpts/models
    cp -p models/*.uml $out/share/openpts/models/

    mkdir -p $out/share/openpts/tpm_emulator
    cp dist/tpm_emulator/README.rhel $out/share/openpts/tpm_emulator/README
    cp dist/tpm_emulator/binary_bios_measurements $out/share/openpts/tpm_emulator/
    cp dist/tpm_emulator/tcsd $out/share/openpts/tpm_emulator/

    mkdir -p $out/share/openpts/tboot
    cp dist/tboot/README.fedora15 $out/share/openpts/tboot/README
    cp dist/tboot/ptsc.conf.fedora15 $out/share/openpts/tboot/ptsc.conf
    cp dist/tboot/tcsd.conf.fedora15 $out/share/openpts/tboot/tcsd.conf
    cp dist/tboot/tcsd.fedora15 $out/share/openpts/tboot/tcsd
    '';

  meta = {
    description = "TCG Platform Trust Service (PTS)";
    homepage = "ttp://sourceforge.jp/projects/openpts";
    license = stdenv.lib.licenses.cpl10;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
