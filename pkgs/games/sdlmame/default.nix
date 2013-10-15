{ stdenv, fetchurl, alsaLib, qt48, SDL, fontconfig, freetype, SDL_ttf, xlibs }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "1686-linux";

stdenv.mkDerivation rec {
  version = "0.150.u0-1";
  name    = "sdlmame-${version}";

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = "ftp://ftp.archlinux.org/community/os/x86_64/${name}-x86_64.pkg.tar.xz";
      sha256 = "0393xnzrzq53szmicn96lvapm66wmlykdxaa1n7smx8a0mcz0kah";
    }
    else fetchurl {
      url    = "ftp://ftp.archlinux.org/community/os/i686/${name}-i686.pkg.tar.xz";
      sha256 = "0js67w2szd0qs7ycgxb3bbmcdziv1fywyd9ihra2f6bq5rhcs2jp";
    };

  buildPhase = ''
    sed -i "s|/usr|$out|" bin/sdlmame
  '';

  installPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "${alsaLib}/lib:${qt48}/lib:${SDL}/lib:${fontconfig}/lib:${freetype}/lib:${SDL_ttf}/lib:${xlibs.libX11}/lib:${xlibs.libXinerama}/lib:${stdenv.gcc.gcc}/lib" \
      share/sdlmame/sdlmame

    mkdir -p "$out/bin"
    cp -r bin/sdlmame "$out/bin"
    cp -r share "$out"
  '';

  dontPatchELF = true;
  dontStrip    = true;

  meta = with stdenv.lib; {
    homepage    = http://sdlmame.lngn.net;
    description = "A port of the popular Multiple Arcade Machine Emulator using SDL with OpenGL support.";
    license     = "MAME";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
