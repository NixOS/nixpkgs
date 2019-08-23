{ stdenv, fetchurl, libdvdread, pkgconfig }:

let
  version = "0.17";
in
stdenv.mkDerivation {
  name = "lsdvd-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/lsdvd/lsdvd-${version}.tar.gz";
    sha256 = "1274d54jgca1prx106iyir7200aflr70bnb1kawndlmcckcmnb3x";
  };

  buildInputs = [ libdvdread ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/lsdvd/;
    description = "Display information about audio, video, and subtitle tracks on a DVD";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
