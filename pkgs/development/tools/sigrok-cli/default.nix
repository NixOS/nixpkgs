{ stdenv, fetchurl, pkgconfig, glib, libsigrok, libsigrokdecode }:

stdenv.mkDerivation rec {
  name = "sigrok-cli-0.5.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/sigrok-cli/${name}.tar.gz";
    sha256 = "0g3jzspq9iwz2szzxil9ilim1and85qd605f4jbc04sva80hb8vk";
  };

  buildInputs = [ pkgconfig glib libsigrok libsigrokdecode ];

  meta = with stdenv.lib; {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
