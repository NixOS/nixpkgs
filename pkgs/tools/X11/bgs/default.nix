{stdenv, fetchurl, libX11, libXinerama, imlib2}:

stdenv.mkDerivation rec {

  name = "bgs-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/Gottox/bgs/archive/v${version}.tar.gz";
    sha256 = "1kgm139daz4xrymx11whbmwzsnps9yn4g34a17s34ihi0raf70w8";
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
