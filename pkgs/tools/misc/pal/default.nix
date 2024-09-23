{lib, stdenv, fetchurl, glib, gettext, readline, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pal";
  version = "0.4.3";
  src = fetchurl {
    url = "mirror://sourceforge/palcal/pal-${version}.tgz";
    sha256 = "072mahxvd7lcvrayl32y589w4v3vh7bmlcnhiksjylknpsvhqiyf";
  };

  patchPhase = ''
    sed -i -e 's/-o root//' -e 's,ESTDIR}/etc,ESTDIR}'$out/etc, src/Makefile
    sed -i -e 's,/etc/pal\.conf,'$out/etc/pal.conf, src/input.c
  '';

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gettext readline ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://palcal.sourceforge.net/";
    description = "Command-line calendar program that can keep track of events";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
