# This file provides a top-level function that will be used by both nixpkgs and nixos
# to generate mod directories for use at runtime by factorio.
{ lib, stdenv }:

{
  mkModDirDrv = mods: modsDatFile: # a list of mod derivations
    let
      recursiveDeps = modDrv: [modDrv] ++ map recursiveDeps modDrv.deps;
      modDrvs = lib.unique (lib.flatten (map recursiveDeps mods));
    in
    stdenv.mkDerivation {
      name = "factorio-mod-directory";

      preferLocalBuild = true;
      buildCommand = ''
        mkdir -p $out
        for modDrv in ${toString modDrvs}; do
          # NB: there will only ever be a single zip file in each mod derivation's output dir
          ln -s $modDrv/*.zip $out
        done
      '' + (lib.optionalString (modsDatFile != null) ''
       cp ${modsDatFile} $out/mod-settings.dat
      '');
    };

    modDrv = { allRecommendedMods, allOptionalMods }:
      { src
      , name ? null
      , deps ? []
      , optionalDeps ? []
      , recommendedDeps ? []
      }: stdenv.mkDerivation {

        inherit src;

        # Use the name of the zip, but endstrip ".zip" and possibly the querystring that gets left in by fetchurl
        name = lib.replaceStrings ["_"] ["-"] (if name != null then name else lib.removeSuffix ".zip" (lib.head (lib.splitString "?" src.name)));

        deps = deps ++ lib.optionals allOptionalMods optionalDeps
                    ++ lib.optionals allRecommendedMods recommendedDeps;

        preferLocalBuild = true;
        buildCommand = ''
          mkdir -p $out
          srcBase=$(basename $src)
          srcBase=''${srcBase#*-}  # strip nix hash
          srcBase=''${srcBase%\?*} # strip querystring leftover from fetchurl
          cp $src $out/$srcBase
        '';
      };
}
