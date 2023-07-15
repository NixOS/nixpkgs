{ stdenv, lib, fetchhg, cmake, pkg-config, makeWrapper, callPackage
, soundfont-fluid, SDL, libGL, glew, bzip2, zlib, libjpeg, fluidsynth, openssl, gtk2, python3, game-music-emu
, serverOnly ? false
}:

let
  suffix = lib.optionalString serverOnly "-server";
  fmod = callPackage ./fmod.nix { };
  sqlite = callPackage ./sqlite.nix { };
  clientLibPath = lib.makeLibraryPath [ fluidsynth ];

in stdenv.mkDerivation rec {
  pname = "zandronum${suffix}";
  version = "3.0.1";

  src = fetchhg {
    url = "https://hg.osdn.net/view/zandronum/zandronum-stable";
    rev = "ZA_${version}";
    sha256 = "16v5b6wfrmabs3ky6isbfhlrqdjrr1pvfxlxwk0im02kcpxxw9qw";
  };

  # zandronum tries to download sqlite now when running cmake, don't let it

  # it also needs the current mercurial revision info embedded in gitinfo.h
  # otherwise, the client will fail to connect to servers because the
  # protocol version doesn't match.

  patches = [ ./zan_configure_impurity.patch ./add_gitinfo.patch ./dont_update_gitinfo.patch ];

  # I have no idea why would SDL and libjpeg be needed for the server part!
  # But they are.
  buildInputs = [ openssl bzip2 zlib SDL libjpeg sqlite game-music-emu ]
             ++ lib.optionals (!serverOnly) [ libGL glew fmod fluidsynth gtk2 ];

  nativeBuildInputs = [ cmake pkg-config makeWrapper python3 ];

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
    [ "-DFORCE_INTERNAL_GME=OFF" ]
    ++ (if serverOnly
    then [ "-DSERVERONLY=ON" ]
    else [ "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so" ]);

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/zandronum
    cp zandronum${suffix} \
       *.pk3 \
       ${lib.optionalString (!serverOnly) "liboutput_sdl.so"} \
       $out/lib/zandronum
    makeWrapper $out/lib/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}
  '';

  postFixup = lib.optionalString (!serverOnly) ''
    patchelf --set-rpath $(patchelf --print-rpath $out/lib/zandronum/zandronum):$out/lib/zandronum:${clientLibPath} \
      $out/lib/zandronum/zandronum
  '';

  passthru = {
    inherit fmod sqlite;
  };

  meta = with lib; {
    homepage = "https://zandronum.com/";
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    maintainers = with maintainers; [ lassulus MP2E ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
  };
}
