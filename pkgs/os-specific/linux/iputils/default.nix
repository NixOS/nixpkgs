{ stdenv, fetchurl
, libsysfs, gnutls, openssl
, libcap, sp, docbook_sgml_dtd_31
, libidn, nettle
, SGMLSpm, libgcrypt }:

assert stdenv ? glibc;

let
  time = "20161105";
in
stdenv.mkDerivation rec {
  name = "iputils-${time}";

  src = fetchurl {
    url = "https://github.com/iputils/iputils/archive/s${time}.tar.gz";
    sha256 = "12mdmh4qbf5610csaw3rkzhpzf6djndi4jsl4gyr8wni0cphj4zq";
  };

  prePatch = ''
    sed -i s/sgmlspl/sgmlspl.pl/ doc/Makefile
  '';

  makeFlags = "USE_GNUTLS=no";

  buildInputs = [
    libsysfs openssl libcap sp docbook_sgml_dtd_31 SGMLSpm libgcrypt libidn nettle
  ];

  buildFlags = "man all ninfod";

  installPhase =
    ''
      mkdir -p $out/bin
      cp -p ping tracepath clockdiff arping rdisc ninfod/ninfod $out/bin/

      mkdir -p $out/share/man/man8
      cp -p \
        doc/clockdiff.8 doc/arping.8 doc/ping.8 doc/rdisc.8 doc/tracepath.8 doc/ninfod.8 \
        $out/share/man/man8
    '';

  meta = {
    homepage = https://github.com/iputils/iputils;
    description = "A set of small useful utilities for Linux networking";
    platforms = stdenv.lib.platforms.linux;
  };
}
