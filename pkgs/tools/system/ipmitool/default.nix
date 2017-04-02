{ fetchurl, stdenv, openssl, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.17";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "0qcrz1d1dbjg46n3fj6viglzcxlf2q15xa7bx9w1hm2hq1r3jzbi";
  };

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/plugins/ipmi_intf.c --replace "s6_addr16" "s6_addr"
  '';

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
    license = stdenv.lib.licenses.bsd3;
    homepage = http://ipmitool.sourceforge.net;
    platforms = stdenv.lib.platforms.unix;
  };
}
