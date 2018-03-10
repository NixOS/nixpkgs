{ stdenv, lib, fetchhg, cmake, pkgconfig, makeWrapper, callPackage
, soundfont-fluid, SDL, libGLU_combined, glew, bzip2, zlib, libjpeg, fluidsynth, openssl, gtk2, python3
, serverOnly ? false
}:

let
  suffix = lib.optionalString serverOnly "-server";
  fmod = callPackage ./fmod.nix { };
  sqlite = callPackage ./sqlite.nix { };

in stdenv.mkDerivation {
  name = "zandronum${suffix}-3.0";

  src = fetchhg {
    url = "https://bitbucket.org/Torr_Samaho/zandronum-stable";
    rev = "dd3c3b57023f";
    sha256 = "1f8pd8d2zjwdp6v9anp9yrkdbfhd2mp7svmnna0jiqgxjw6wkyls";
  };

  # zandronum tries to download sqlite now when running cmake, don't let it

  # it also needs the current mercurial revision info embedded in gitinfo.h
  # otherwise, the client will fail to connect to servers because the
  # protocol version doesn't match.

  patches = [ ./zan_configure_impurity.patch ./add_gitinfo.patch ./dont_update_gitinfo.patch ];

  # I have no idea why would SDL and libjpeg be needed for the server part!
  # But they are.
  buildInputs = [ openssl bzip2 zlib SDL libjpeg sqlite ]
             ++ lib.optionals (!serverOnly) [ libGLU_combined glew fmod fluidsynth gtk2 ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper python3 ];

  preConfigure = ''
    ln -s ${sqlite}/* sqlite/
    sed -ie 's| restrict| _restrict|g' dumb/include/dumb.h \
                                       dumb/src/it/*.c
  '' + lib.optionalString (!serverOnly) ''
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
  '' + (if (!serverOnly) then
          ''makeWrapper $out/lib/zandronum/zandronum $out/bin/zandronum --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH:${fluidsynth}/lib"''
        else
          ''makeWrapper $out/lib/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}'');

  postFixup = lib.optionalString (!serverOnly) ''
    patchelf --set-rpath $(patchelf --print-rpath $out/lib/zandronum/zandronum):$out/lib/zandronum \
      $out/lib/zandronum/zandronum
  '';

  meta = with stdenv.lib; {
    homepage = http://zandronum.com/;
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    maintainers = with maintainers; [ lassulus MP2E ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
  };
}
