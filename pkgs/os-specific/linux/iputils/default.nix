{ stdenv, fetchurl
, libsysfs, gnutls, openssl
, libcap, opensp, docbook_sgml_dtd_31
, libidn, nettle
, SGMLSpm, libgcrypt }:

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
    sed -e s/sgmlspl/sgmlspl.pl/ \
        -e s/nsgmls/onsgmls/ \
      -i doc/Makefile
  '';

  # Disable idn usage w/musl: https://github.com/iputils/iputils/pull/111
  makeFlags = [ "USE_GNUTLS=no" ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "USE_IDN=no";

  depsBuildBuild = [ opensp SGMLSpm docbook_sgml_dtd_31 ];
  buildInputs = [
    libsysfs openssl libcap libgcrypt nettle
  ] ++ stdenv.lib.optional (!stdenv.hostPlatform.isMusl) libidn;

  # ninfod probably could build on cross, but the Makefile doesn't pass --host etc to the sub configure...
  buildFlags = "man all" + stdenv.lib.optionalString (!stdenv.isCross) " ninfod";

  installPhase =
    ''
      mkdir -p $out/bin
      cp -p ping tracepath clockdiff arping rdisc rarpd $out/bin/
      if [ -x ninfod/ninfod ]; then
        cp -p ninfod/ninfod $out/bin
      fi

      mkdir -p $out/share/man/man8
      cp -p \
        doc/clockdiff.8 doc/arping.8 doc/ping.8 doc/rdisc.8 doc/rarpd.8 doc/tracepath.8 doc/ninfod.8 \
        $out/share/man/man8
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/iputils/iputils;
    description = "A set of small useful utilities for Linux networking";
    platforms = platforms.linux;
    maintainers = with maintainers; [ lheckemann ];
  };
}
