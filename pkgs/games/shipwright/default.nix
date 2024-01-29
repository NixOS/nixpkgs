{ stdenv
, cmake
, lsb-release
, ninja
, lib
, fetchFromGitHub
, fetchurl
, makeDesktopItem
, python3
, libX11
, libXrandr
, libXinerama
, libXcursor
, libXi
, libXext
, glew
, boost
, SDL2
, SDL2_net
, pkg-config
, libpulseaudio
, libpng
, imagemagick
, requireFile

, oot ? rec {
    enable = true;
    variant = "debug";

    rom = requireFile {
      name = "oot-${variant}.z64";
      message = ''
        This nix expression requires that oot-${variant}.z64 is already part of the store.
        To get this file you can dump your Ocarina of Time's cartridge to a file,
        and add it to the nix store with nix-store --add-fixed sha1 <FILE>, or override the package:
          shipwright.override { oot = { enable = true; variant = "debug"; rom = path/to/oot-debug-mq.z64; } }

        The supported variants are:
         - debug: Ocarina of Time Debug PAL GC (not Master Quest)
         - pal-gc: Ocarina of Time PAL GameCube (may lead to crashes and instability)

        This is optional if you have imported an Ocarina of Time Master Quest ROM.
        If so, please set oot.enable to false and ootMq.enable to true.
        If both are enabled, Ship of Harkinian will be built with both ROMs.
      '';

      # From upstream: https://github.com/HarbourMasters/Shipwright/blob/e46c60a7a1396374e23f7a1f7122ddf9efcadff7/README.md#1-check-your-sha1
      sha1 = {
        debug = "cee6bc3c2a634b41728f2af8da54d9bf8cc14099";
        pal-gc = "0227d7c0074f2d0ac935631990da8ec5914597b4";
      }.${variant} or (throw "Unsupported romVariant ${variant}. Valid options are 'debug' and 'pal-gc'.");
    };
  }

, ootMq ? rec {
    enable = false;
    variant = "debug-mq";

    rom = requireFile {
      name = "oot-${variant}.z64";
      message = ''
        This nix expression requires that oot-${variant}.z64 is already part of the store.
        To get this file you can dump your Ocarina of Time Master Quest's cartridge to a file,
        and add it to the nix store with nix-store --add-fixed sha1 <FILE>, or override the package:
          shipwright.override { ootMq = { enable = true; variant = "debug-mq"; rom = path/to/oot-debug-mq.z64; } }

        The supported variants are:
         - debug-mq: Ocarina of Time Debug PAL GC MQ (Dungeons will be Master Quest)
         - debug-mq-alt: Alternate ROM, not produced by decompilation.

        This is optional if you have imported an Ocarina of Time ROM.
        If so, please set oot.enable to true and ootMq.enable to false.
        If both are enabled, Ship of Harkinian will be built with both ROMs.
      '';

      # From upstream: https://github.com/HarbourMasters/Shipwright/blob/e46c60a7a1396374e23f7a1f7122ddf9efcadff7/README.md#1-check-your-sha1
      sha1 = {
        debug-mq = "079b855b943d6ad8bd1eb026c0ed169ecbdac7da";
        debug-mq-alt = "50bebedad9e0f10746a52b07239e47fa6c284d03";
      }.${variant} or (throw "Unsupported mqRomVariant ${variant}. Valid options are 'debug-mq' and 'debug-mq-alt'.");
    };
  }
}:

let
  checkAttrs = attrs:
    let
      validAttrs = [ "enable" "rom" "variant" ];
    in
    lib.all (name: lib.elem name validAttrs) (lib.attrNames attrs);
in
assert (lib.assertMsg (checkAttrs oot) "oot must have the attributes 'enable' and 'rom', and none other");
assert (lib.assertMsg (checkAttrs ootMq) "ootMq must have the attributes 'enable' and 'rom', and none other");
assert (lib.assertMsg (oot.enable || ootMq.enable) "At least one of 'oot.enable' and 'ootMq.enable' must be true");

stdenv.mkDerivation rec {
  pname = "shipwright";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "harbourmasters";
    repo = "shipwright";
    rev = version;
    hash = "sha256-zgxJj65wKsQWvVxeCspyHG9YqoYqZxd6GrYptOA8Byk=";
    fetchSubmodules = true;
  };

  # This would get fetched at build time otherwise, see:
  # https://github.com/HarbourMasters/Shipwright/blob/e46c60a7a1396374e23f7a1f7122ddf9efcadff7/soh/CMakeLists.txt#L736
  gamecontrollerdb = fetchurl {
    name = "gamecontrollerdb.txt";
    url = "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/c5b4df0e1061175cb11e3ebbf8045178339864a5/gamecontrollerdb.txt";
    hash = "sha256-2VFCsaalXoe+JYWCH6IbgjnLXNKxe0UqSyJNGZMn5Ko=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    lsb-release
    python3
    imagemagick
  ];

  buildInputs = [
    boost
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    glew
    SDL2
    SDL2_net
    libpulseaudio
    libpng
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/lib"
  ];

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  postBuild = ''
    cp ${gamecontrollerdb} ${gamecontrollerdb.name}

    pushd ../OTRExporter
    ${lib.optionalString oot.enable "python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out ${oot.rom}"}
    ${lib.optionalString ootMq.enable "python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out ${ootMq.rom}"}
    popd
  '';

  preInstall = ''
    # Cmake likes it here for its install paths
    cp ../OTRExporter/soh.otr ..
  '';

  postInstall = ''
    mkdir -p $out/bin

    # Copy the extracted assets, required to be in the same directory as the executable
    ${lib.optionalString oot.enable "cp ../OTRExporter/oot.otr $out/lib"}
    ${lib.optionalString ootMq.enable "cp ../OTRExporter/oot-mq.otr $out/lib"}

    ln -s $out/lib/soh.elf $out/bin/soh
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "soh";
      icon = "soh";
      exec = "soh";
      genericName = "Ship of Harkinian";
      desktopName = "soh";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/HarbourMasters/Shipwright";
    description = "A PC port of Ocarina of Time with modern controls, widescreen, high-resolution, and more";
    longDescription = ''
      An PC port of Ocarina of Time with modern controls, widescreen, high-resolution and more, based off of decompilation.
      Note that you must supply an OoT rom yourself to use this package because propietary assets are extracted from it.

      You can change the game variant like this:
        shipwright.override { oot.enable = false; ootMq.enable = true }

      The default ROM variants for Oot and OotMq are debug and debug-mq respectively.
      If you have a pal-gc rom, you should override like this:
        shipwright.override { oot = { enable = true; variant = "pal-gc"; rom = path/to/oot-pal-gc.z64; } }

      The supported Oot variants are:
       - debug: Ocarina of Time Debug PAL GC (not Master Quest)
       - pal-gc: Ocarina of Time PAL GameCube (may lead to crashes and instability)

      The supported OotMq variants are:
       - debug-mq: Ocarina of Time Debug PAL GC MQ (Dungeons will be Master Quest)
       - debug-mq-alt: Alternate ROM, not produced by decompilation.
    '';
    mainProgram = "soh";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ivar j0lol ];
    license = with licenses; [
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
      # Ship of Harkinian itself
      unfree
    ];
  };
}
