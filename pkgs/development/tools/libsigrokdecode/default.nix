{ stdenv, fetchurl, pkgconfig, glib, python3, libsigrok, check }:

stdenv.mkDerivation rec {
  name = "libsigrokdecode-0.5.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libsigrokdecode/${name}.tar.gz";
    sha256 = "07mmb6s62ncqqgsc6szilj2yxixf6gg99ggbzsjlbhp4b9aqnga9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib python3 libsigrok check ];

  meta = with stdenv.lib; {
    description = "Protocol decoding library for the sigrok signal analysis software suite";
    homepage = https://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
