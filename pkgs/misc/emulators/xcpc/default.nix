{ stdenv, fetchurl, pkgconfig, glib, libXaw, libX11, libXext
  , libDSKSupport ? true, libdsk
  , motifSupport ? false, lesstif
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "20070122";
  pname = "xcpc";

  src = fetchurl {
    url = "mirror://sourceforge/xcpc/${pname}-${version}.tar.gz";
    sha256 = "0hxsbhmyzyyrlidgg0q8izw55q0z40xrynw5a1c3frdnihj9jf7n";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib libdsk libXaw libX11 libXext ]
    ++ optional libDSKSupport libdsk
    ++ optional motifSupport lesstif;

  meta = {
    description = "A portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = "https://www.xcpc-emulator.net";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
