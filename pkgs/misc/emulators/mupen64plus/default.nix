{stdenv, fetchurl, boost, dash, freetype, libpng, pkgconfig, SDL, which, zlib }:

stdenv.mkDerivation rec {
  pname = "mupen64plus";
  version = "2.5";

  src = fetchurl {
    url = "https://github.com/mupen64plus/mupen64plus-core/releases/download/${version}/mupen64plus-bundle-src-${version}.tar.gz";
    sha256 = "0rmsvfn4zfvbhz6gf1xkb7hnwflv6sbklwjz2xk4dlpj4vcbjxcw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost dash freetype libpng SDL which zlib ];

  buildPhase = ''
    dash m64p_build.sh PREFIX="$out" COREDIR="$out/lib/" PLUGINDIR="$out/lib/mupen64plus" SHAREDIR="$out/share/mupen64plus"
  '';
  installPhase = ''
    dash m64p_install.sh DESTDIR="$out" PREFIX=""
  '';

  meta = {
    description = "A Nintendo 64 Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.mupen64plus.org/;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
