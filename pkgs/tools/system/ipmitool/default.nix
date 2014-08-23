{ fetchurl, stdenv, openssl, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.13";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "0drkfa1spqh1vlzrx7jwm3cw1qar46a9xvqsgycn92ylgsr395n1";
  };

  buildInputs = [ openssl ];

  preConfigure = ''
    configureFlagsArray=(
      --infodir=$out/share/info
      --mandir=$out/share/man
      ${if static then "LDFLAGS=-static --enable-static --disable-shared" else "--enable-shared"}
    )
  '';
  makeFlags = if static then "AM_LDFLAGS=-all-static" else "";
  dontDisableStatic = static;

  meta = {
    description = ''Command-line interface to IPMI-enabled devices'';
    license = "BSD";
    homepage = "http://ipmitool.sourceforge.net";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
