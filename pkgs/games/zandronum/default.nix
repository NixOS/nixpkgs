{ stdenv, lib, fetchhg, cmake, pkgconfig, makeWrapper
, SDL, mesa, bzip2, zlib, fmod, libjpeg, fluidsynth, openssl, sqlite-amalgamation
, serverOnly ? false
}:

let suffix = lib.optionalString serverOnly "-server";

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
             ++ lib.optionals (!serverOnly) [ mesa fmod fluidsynth ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  preConfigure = ''
    ln -s ${sqlite-amalgamation}/* sqlite/
    sed -ie 's| restrict| _restrict|g' dumb/include/dumb.h \
                                       dumb/src/it/*.c
  '';

  cmakeFlags =
    lib.optional (!serverOnly) "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so"
    ++ lib.optional serverOnly "-DSERVERONLY=ON"
    ;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zandronum
    cp zandronum${suffix} \
       zandronum.pk3 \
       skulltag_actors.pk3 \
       ${lib.optionalString (!serverOnly) "liboutput_sdl.so"} \
       $out/share/zandronum

    # For some reason, while symlinks work for binary version, they don't for source one.
    makeWrapper $out/share/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}
  '';

  postFixup = lib.optionalString (!serverOnly) ''
    patchelf --set-rpath $(patchelf --print-rpath $out/share/zandronum/zandronum):$out/share/zandronum \
      $out/share/zandronum/zandronum
  '';

  meta = with stdenv.lib; {
    homepage = http://zandronum.com/;
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    maintainers = with maintainers; [ lassulus ];
    license = stdenv.lib.licenses.unfree;
    platforms = platforms.linux;
  };
}
