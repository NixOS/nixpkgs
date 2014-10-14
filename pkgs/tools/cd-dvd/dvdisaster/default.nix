{ stdenv, fetchurl, pkgconfig, which, gettext, intltool
, glib, gtk2
}:

stdenv.mkDerivation rec {
  name = "dvdisaster-0.72.6";

  src = fetchurl {
    url = "http://dvdisaster.net/downloads/${name}.tar.bz2";
    sha256 = "e9787dea39aeafa38b26604752561bc895083c17b588489d857ac05c58be196b";
  };

  postPatch = ''
    patchShebangs ./
  '';

  buildInputs = [
    pkgconfig which gettext intltool
    glib gtk2
  ];

  meta = {
    homepage = http://dvdisaster.net/;
    description =
      "Stores data on CD/DVD/BD in a way that it is fully recoverable even " +
      "after some read errors have developed";
    license = stdenv.lib.licenses.gpl2;
  };
}
