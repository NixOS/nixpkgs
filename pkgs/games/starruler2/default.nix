{
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  # Path to directory containing music for the game,
  # such as `data/music` from the commercial version.
  musicPath ? null,
  # Paths of mods to add.
  modPaths ? [],
}: let
  data = callPackage ./data.nix {};
  engine = callPackage ./engine.nix {};
in
  # The game is mostly implemented in Angelscript,
  # a scripting language.
  # For security,
  # the Angelscript runtime refuses to load files outside particular directories.
  # If we symlink `data` files,
  # such as by using `buildEnv`,
  # Angelscript will not load those files,
  # and the game will not run.
  # We must instead `cp` files.
  stdenv.mkDerivation {
    pname = "starruler2";
    version = lib.trivial.max data.version engine.version;

    phases = ["installPhase"];

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      game="$out/share/games/starruler2"
      mkdir -p "$out/bin"

      cp -r "${data}/share" "$out/share"

      ${
        lib.optionalString (musicPath != null) ''
          cp -r "${musicPath}" "$game/data/music"
        ''
      }

      ${
        lib.optionalString (modPaths != []) ''
          cp -r ${lib.concatStringsSep " " (map (path: ''"${path}"'') modPaths)} "$game/mods"
        ''
      }

      makeWrapper "${engine}/bin/starruler2" "$out/bin/starruler2" --chdir "$game"

      runHook postInstall
    '';

    meta = with lib; {
      description = "A massive-scale 4X/RTS game set in space";
      homepage = "https://github.com/OpenSRProject";
      license = lib.unique (lib.toList engine.meta.license ++ lib.toList data.meta.license);
      platforms = engine.meta.platforms;
      maintainers = with maintainers; [justinlovinger];
      hydraPlatforms = [];
    };
  }
