{ stdenv, fetchurl, alsaLib, qt48, SDL, fontconfig, freetype, SDL_ttf, xlibs }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  version = "0.151.u0-1";
  name    = "sdlmame-${version}";

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = "ftp://ftp.archlinux.org/community/os/x86_64/${name}-x86_64.pkg.tar.xz";
      sha256 = "1j9vjxhrhsskrlk5wr7al4wk2hh3983kcva42mqal09bmc8qg3m9";
    }
    else fetchurl {
      url    = "ftp://ftp.archlinux.org/community/os/i686/${name}-i686.pkg.tar.xz";
      sha256 = "1i38j9ml66pyxzm0zzf1fv4lb40f6w47cdgaw846q91pzakkkqn7";
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
