{ stdenv, fetchurl, libsysfs, gnutls, openssl, libcap, sp, docbook_sgml_dtd_31
, SGMLSpm, libgcrypt }:

assert stdenv ? glibc;

let
  time = "20151218";
in
stdenv.mkDerivation rec {
  name = "iputils-${time}";

  src = fetchurl {
    url = "http://www.skbuff.net/iputils/iputils-s${time}.tar.bz2";
    sha256 = "189592jlkhxdgy8jc07m4bsl41ik9r6i6aaqb532prai37bmi7sl";
  };

  prePatch = ''
    sed -i s/sgmlspl/sgmlspl.pl/ doc/Makefile
  '';

  makeFlags = "USE_GNUTLS=no";

  buildInputs = [
    libsysfs openssl libcap sp docbook_sgml_dtd_31 SGMLSpm libgcrypt
  ];

  buildFlags = "man all ninfod";

  installPhase =
    ''
      mkdir -p $out/sbin $out/bin
      cp -p ping ping6 tracepath tracepath6 traceroute6 $out/bin/
      cp -p clockdiff arping rdisc ninfod/ninfod $out/sbin/

      mkdir -p $out/share/man/man8
      cp -p doc/clockdiff.8 doc/arping.8 doc/ping.8 doc/rdisc.8 \
        doc/tracepath.8 doc/ninfod.8 $out/share/man/man8
      ln -s $out/share/man/man8/{ping,ping6}.8
      ln -s $out/share/man/man8/{tracepath,tracepath6}.8
    '';

  meta = {
    homepage = http://www.skbuff.net/iputils/;
    description = "A set of small useful utilities for Linux networking";
    platforms = stdenv.lib.platforms.linux;
  };
}
