{stdenv, fetchurl, libX11, libXinerama, imlib2}:

stdenv.mkDerivation rec {

  name = "bgs-${version}";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/Gottox/bgs/archive/v${version}.tar.gz";
    sha256 = "1w1zz9nzj0a0r9rlnq5psjj7n2ff1zfghcs6j268i5c7nkyaw28a";
  };

  buildInputs = [ libX11 libXinerama imlib2 ];

  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';

  meta = with stdenv.lib; {
    description = "Extremely fast and small background setter for X";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
