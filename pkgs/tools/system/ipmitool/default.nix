{ fetchurl, stdenv, openssl, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.14";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "1avlb0lwqncd28hp6p5w3rkcnhgy84rgv1jdgkyy0gzqhx2wx6zy";
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
