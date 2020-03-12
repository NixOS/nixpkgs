{stdenv, fetchurl, pkgconfig, libX11, libXinerama, imlib2}:

stdenv.mkDerivation rec {

  pname = "bgs";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/Gottox/bgs/archive/v${version}.tar.gz";
    sha256 = "1rw9ingkkpvvr2dixx126ziim67a54r8k49918h1mbph0fjj08n5";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libX11 libXinerama imlib2 ];

  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';

  meta = with stdenv.lib; {
    description = "Extremely fast and small background setter for X";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
