{ stdenv, lib, fetchurl, openssl, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.18";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "0kfh8ny35rvwxwah4yv91a05qwpx74b5slq2lhrh71wz572va93m";
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

  meta = with lib; {
    description = ''Command-line interface to IPMI-enabled devices'';
    license = licenses.bsd3;
    homepage = https://sourceforge.net/projects/ipmitool/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
