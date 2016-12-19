{ stdenv, lib, fetchhg, cmake, pkgconfig, makeWrapper, callPackage
, soundfont-fluid, SDL, mesa, bzip2, zlib, libjpeg, fluidsynth, openssl, sqlite-amalgamation, gtk2
, serverOnly ? false
}:

let
  suffix = lib.optionalString serverOnly "-server";
  fmod = callPackage ./fmod.nix { };

# FIXME: drop binary package when upstream fixes their protocol versioning
in stdenv.mkDerivation {
  name = "zandronum${suffix}-2.1.2";

  src = fetchhg {
    url = "https://bitbucket.org/Torr_Samaho/zandronum-stable";
    rev = "a3663b0061d5";
    sha256 = "0qwsnbwhcldwrirfk6hpiklmcj3a7dzh6pn36nizci6pcza07p56";
  };

  # I have no idea why would SDL and libjpeg be needed for the server part!
  # But they are.
  buildInputs = [ openssl bzip2 zlib SDL libjpeg ]
             ++ lib.optionals (!serverOnly) [ mesa fmod fluidsynth gtk2 ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  preConfigure = ''
    ln -s ${sqlite-amalgamation}/* sqlite/
    sed -ie 's| restrict| _restrict|g' dumb/include/dumb.h \
                                       dumb/src/it/*.c
  '' + lib.optionalString serverOnly ''
    sed -i \
      -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
      -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
      src/sound/music_fluidsynth_mididevice.cpp
  '';

  cmakeFlags =
    lib.optional (!serverOnly) "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so"
    ++ lib.optional serverOnly "-DSERVERONLY=ON"
    ;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/zandronum
    cp zandronum${suffix} \
       *.pk3 \
       ${lib.optionalString (!serverOnly) "liboutput_sdl.so"} \
       $out/lib/zandronum

    # For some reason, while symlinks work for binary version, they don't for source one.
    makeWrapper $out/lib/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}
  '';

  postFixup = lib.optionalString (!serverOnly) ''
    patchelf --set-rpath $(patchelf --print-rpath $out/lib/zandronum/zandronum):$out/lib/zandronum \
      $out/lib/zandronum/zandronum
  '';

  meta = with stdenv.lib; {
    homepage = http://zandronum.com/;
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    maintainers = with maintainers; [ lassulus ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
  };
}
