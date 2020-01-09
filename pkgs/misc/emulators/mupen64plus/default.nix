{stdenv, fetchurl, boost, dash, freetype, libpng, pkgconfig, SDL, which, zlib, nasm }:

stdenv.mkDerivation rec {
  pname = "mupen64plus";
  version = "2.5.9";

  src = fetchurl {
    url = "https://github.com/mupen64plus/mupen64plus-core/releases/download/${version}/mupen64plus-bundle-src-${version}.tar.gz";
    sha256 = "1a21n4gqdvag6krwcjm5bnyw5phrlxw6m0mk73jy53iq03f3s96m";
  };

  nativeBuildInputs = [ pkgconfig nasm ];
  buildInputs = [ boost dash freetype libpng SDL which zlib ];

  buildPhase = ''
    dash m64p_build.sh PREFIX="$out" COREDIR="$out/lib/" PLUGINDIR="$out/lib/mupen64plus" SHAREDIR="$out/share/mupen64plus"
  '';
  installPhase = ''
    dash m64p_install.sh DESTDIR="$out" PREFIX=""
  '';

  meta = with stdenv.lib; {
    description = "A Nintendo 64 Emulator";
    license = licenses.gpl2Plus;
    homepage = http://www.mupen64plus.org/;
    maintainers = [ maintainers.sander ];
    platforms = [ "x86_64-linux" ];
  };
}
