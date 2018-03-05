{ stdenv, fetchurl, pkgconfig, glib, python3, libsigrok, check }:

stdenv.mkDerivation rec {
  name = "libsigrokdecode-0.5.0";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libsigrokdecode/${name}.tar.gz";
    sha256 = "1hfigfj1976qk11kfsgj75l20qvyq8c9p2h4mjw23d59rsg5ga2a";
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
