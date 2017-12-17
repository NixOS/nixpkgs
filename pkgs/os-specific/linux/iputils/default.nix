{ stdenv, fetchFromGitHub, SGMLSpm
, libsysfs, gnutls, openssl
, libcap, libidn2, nettle, libgcrypt
, libxslt, docbook_xsl, docbook_xml_dtd_45 }:


let
  time = "20161105";
in
stdenv.mkDerivation rec {
  name = "iputils-${time}";

  src = fetchFromGitHub {
    owner = "iputils";
    repo = "iputils";
    rev = "9f7f1d4c4fd4fd90d2c5e66d6deb7f87f2eb1cea";
    sha256 = null;
  };

  prePatch = ''
    substituteInPlace doc/Makefile --replace '/usr/bin/xsltproc' 'xsltproc'
  '';

  makeFlags = "USE_GNUTLS=no";

  nativeBuildInputs = [ libxslt docbook_xsl docbook_xml_dtd_45 ];
  buildInputs = [
    libsysfs openssl libcap libgcrypt libidn2 nettle
  ] ++ stdenv.lib.optional (!stdenv.hostPlatform.isMusl) libidn;

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
