{ stdenv, fetchurl, libdsk, pkgconfig, glib, libXaw, libX11, libXext, lesstif }:

stdenv.mkDerivation rec {
  version = "20070122";
  name = "xcpc-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/xcpc/${name}.tar.gz";
    sha256 = "0hxsbhmyzyyrlidgg0q8izw55q0z40xrynw5a1c3frdnihj9jf7n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libdsk libXaw libX11 libXext lesstif ];

  meta = with stdenv.lib; {
    description = "A portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = https://www.xcpc-emulator.net;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
