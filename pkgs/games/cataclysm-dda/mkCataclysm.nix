{
  lib,
  stdenv,
  wrapCDDA,
  callPackage,
  runtimeShell,
  cmake,
  ninja,
  pkg-config,
  gettext,
  ncurses,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  libX11,
  freetype,
  zlib,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "isDebug"
    "useCmake"
    "isDebug"
    "useXdgDir"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      makeFlags ? [ ],
      cmakeFlags ? [ ],
      passthru ? { },
      meta ? { },
      hasTiles ? false,
      useCmake ? false,
      isDebug ? false,
      useXdgDir ? true,
      ...
    }@args:
    {
      inherit hasTiles;
      pname = args.pname or "cataclysm-dda";

      __structuredAttrs = true;
      strictDeps = true;
      nativeBuildInputs =
        nativeBuildInputs
        ++ [
          gettext
          pkg-config
        ]
        ++ lib.optionals useCmake [
          cmake
          ninja
        ];

      buildInputs =
        buildInputs
        ++ [
          gettext
          zlib
        ]
        ++ lib.optionals finalAttrs.hasTiles [
          SDL2
          SDL2_image
          SDL2_mixer
          SDL2_ttf
          libX11
          freetype
        ]
        ++ lib.optionals (!finalAttrs.hasTiles) [
          ncurses
        ];

      enableParallelBuilding = true;
      makeFlags =
        makeFlags
        ++ [
          "TESTS=0"
          "ASTYLE=0"
          "DYNAMIC_LINKING=1"
          "VERSION=${finalAttrs.version}"
          "PREFIX=$(out)"
          "LANGUAGES=all"
          (if useXdgDir then "USE_XDG_DIR=1" else "USE_HOME_DIR=1")
        ]
        ++ lib.optionals (!isDebug) [
          "RELEASE=1"
        ]
        ++ lib.optionals finalAttrs.hasTiles [
          "TILES=1"
          "SOUND=1"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "NATIVE=osx"
          "CLANG=1"
          "OSX_MIN=${stdenv.hostPlatform.darwinMinVersion}"
        ];

      cmakeFlags = cmakeFlags ++ [
        (lib.cmakeBool "USE_PREFIX_DATA_DIR" true)
        (lib.cmakeBool "CURSES" (!finalAttrs.hasTiles))
        (lib.cmakeBool "SOUND" finalAttrs.hasTiles)
        (lib.cmakeBool "TILES" finalAttrs.hasTiles)
        (lib.cmakeBool "USE_XDG_DIR" useXdgDir)
        (lib.cmakeBool "USE_HOME_DIR" (!useXdgDir))
      ];

      dontStrip = args.dontStrip or isDebug;

      postInstall = args.postInstall or lib.optionalString stdenv.hostPlatform.isDarwin ''
        app=$out/Applications/Cataclysm.app

        install -D -m 444 build-data/osx/Info.plist -t $app/Contents
        install -D -m 444 build-data/osx/AppIcon.icns -t $app/Contents/Resources

        mkdir $app/Contents/MacOS
        launcher=$app/Contents/MacOS/Cataclysm.sh
        cat << EOF > $launcher
        #!${runtimeShell}
        $out/bin/cataclysm-tiles
        EOF

        chmod 555 $launcher
      '';

      passthru = {
        isTiles = finalAttrs.hasTiles;
        isCurses = !finalAttrs.hasTiles;

        # Creates a derivation with tiles enabled
        withTiles = finalAttrs.finalPackage.overrideAttrs (old: {
          pname = old.pname + "-tiles";
          hasTiles = true;
        });

        # User provides a selector predicate to filter the cataclysm mods
        withMods =
          selector:
          callPackage ./wrapper.nix {
            inherit selector;
            unwrapped = finalAttrs.finalPackage;
          };
      }
      // passthru;

      meta = meta // {
        description = meta.description or "Free, post apocalyptic, zombie infested rogue-like";
        mainProgram = meta.mainProgram or "cataclysm-tiles";
        longDescription =
          meta.longDescription or ''
            Cataclysm: Dark Days Ahead is a roguelike set in a post-apocalyptic world.
            Surviving is difficult: you have been thrown, ill-equipped, into a
            landscape now riddled with monstrosities of which flesh eating zombies are
            neither the strangest nor the deadliest.

            Yet with care and a little luck, many things are possible. You may try to
            eke out an existence in the forests silently executing threats and
            providing sustenance with your longbow. You can ride into town in a
            jerry-rigged vehicle, all guns blazing, to settle matters in a fug of
            smoke from your molotovs. You could take a more measured approach and
            construct an impregnable fortress, surrounded by traps to protect you from
            the horrors without. The longer you survive, the more skilled and adapted
            you will get and the better equipped and armed to deal with the threats
            you are presented with.

            In the course of your ordeal there will be opportunities and temptations
            to improve or change your very nature. There are tales of survivors fitted
            with extraordinary cybernetics giving great power and stories too of
            gravely mutated survivors who, warped by their ingestion of exotic
            substances or radiation, now more closely resemble insects, birds or fish
            than their original form.
          '';
        homepage = meta.homepage or "https://cataclysmdda.org/";
        license = meta.license or lib.licenses.cc-by-sa-30;
        maintainers =
          meta.maintainers or [ ]
          ++ (with lib.maintainers; [
            mnacamura
            DeeUnderscore
            RossSmyth
          ]);
        platforms = meta.platforms or lib.platforms.all;
      };
    };
}
