{
  stdenv,
  lib,
  fetchhg,
  cmake,
  pkg-config,
  makeWrapper,
  callPackage,
  soundfont-fluid,
  SDL_compat,
  libGL,
  glew,
  bzip2,
  zlib,
  libjpeg,
  fluidsynth,
  fmodex,
  openssl,
  gtk2,
  python3,
  game-music-emu,
  serverOnly ? false,
}:

let
  suffix = lib.optionalString serverOnly "-server";
  fmod = fmodex; # fmodex is on nixpkgs now
  sqlite = callPackage ./sqlite.nix { };
  clientLibPath = lib.makeLibraryPath [ fluidsynth ];

in
stdenv.mkDerivation rec {
  pname = "zandronum${suffix}";
  version = "3.1.0";

  src = fetchhg {
    # expired ssl certificate
    url = "http://hg.osdn.net/view/zandronum/zandronum-stable";
    rev = "4178904d7698";
    hash = "sha256-5t36CoRPPjDKQE0DVSv2Qqpqko6JAXBI53tuAYiylHQ=";
  };

  # zandronum tries to download sqlite now when running cmake, don't let it
  # it also needs the current mercurial revision info embedded in gitinfo.h
  # otherwise, the client will fail to connect to servers because the
  # protocol version doesn't match.
  patches = [
    ./zan_configure_impurity.patch
    ./dont_update_gitinfo.patch
    ./add_gitinfo.patch
  ];

  # I have no idea why would SDL and libjpeg be needed for the server part!
  # But they are.
  buildInputs =
    [
      openssl
      bzip2
      zlib
      SDL_compat
      libjpeg
      sqlite
      game-music-emu
    ]
    ++ lib.optionals (!serverOnly) [
      libGL
      glew
      fmod
      fluidsynth
      gtk2
    ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    python3
  ];

  preConfigure =
    ''
      ln -s ${sqlite}/* sqlite/
      sed -ie 's| restrict| _restrict|g' dumb/include/dumb.h \
                                         dumb/src/it/*.c
    ''
    + lib.optionalString (!serverOnly) ''
      sed -i \
        -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
        -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
        src/sound/music_fluidsynth_mididevice.cpp
    '';

  cmakeFlags = [
    "-DFORCE_INTERNAL_GME=OFF"
  ] ++ (if serverOnly then [ "-DSERVERONLY=ON" ] else [ "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so" ]);

  hardeningDisable = [ "format" ];

  # Won't work well without C or en_US. Setting LANG might not be enough if the user is making use of LC_* so wrap with LC_ALL instead
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/zandronum
    cp zandronum${suffix} \
       *.pk3 \
       ${lib.optionalString (!serverOnly) "liboutput_sdl.so"} \
       $out/lib/zandronum
    makeWrapper $out/lib/zandronum/zandronum${suffix} $out/bin/zandronum${suffix}
    wrapProgram $out/bin/zandronum${suffix} \
      --set LC_ALL="C"
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
    mainProgram = "zandronum-server";
    maintainers = with maintainers; [ lassulus ];
    license = licenses.sleepycat;
    platforms = platforms.linux;
  };
}
