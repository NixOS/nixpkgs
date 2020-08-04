# This file provides a top-level function that will be used by both nixpkgs and nixos
# to generate mod directories for use at runtime by factorio.
{ stdenv, fetchurl }:
with stdenv.lib;
let
  helpMsg = ''

    ===FETCH FAILED===
    Please ensure you have set the username and token with config.nix, or
    /etc/nix/nixpkgs-config.nix if on NixOS.

    Your token can be seen at https://factorio.com/profile (after logging in). It is
    not as sensitive as your password, but should still be safeguarded. There is a
    link on that page to revoke/invalidate the token, if you believe it has been
    leaked or wish to take precautions.

    Example:
    {
      packageOverrides = pkgs: {
        factorio = pkgs.factorio.override {
          username = "FactorioPlayer1654";
          token = "d5ad5a8971267c895c0da598688761";
        };
      };
    }

    Alternatively, instead of providing the username+token, you may manually
    download the release through https://factorio.com/download , then add it to
    the store using e.g.:

      releaseType=alpha
      version=0.17.74
      nix-prefetch-url file://$HOME/Downloads/factorio_\''${releaseType}_x64_\''${version}.tar.xz --name factorio_\''${releaseType}_x64-\''${version}.tar.xz

    Note the ultimate "_" is replaced with "-" in the --name arg!
  '';
in
{
  fetchurlWithAuth = { name, url, sha1 ? "", sha256 ? "", username, token }:
    stdenv.lib.overrideDerivation
      (fetchurl {
        inherit name url sha1 sha256;
        curlOpts = [
          "--get"
          "--data-urlencode"
          "username@username"
          "--data-urlencode"
          "token@token"
        ];
      })
      (_: {
        # This preHook hides the credentials from /proc
        preHook = ''
          echo -n "${username}" >username
          echo -n "${token}"    >token
        '';
        failureHook = ''
          cat <<EOF
          ${helpMsg}
          EOF
        '';
      });

  mkModDirDrv = mods: # a list of mod derivations
    let
      recursiveDeps = modDrv: [modDrv] ++ map recursiveDeps modDrv.deps;
      modDrvs = unique (flatten (map recursiveDeps mods));
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
      '';
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
        name = replaceStrings ["_"] ["-"] (if name != null then name else removeSuffix ".zip" (head (splitString "?" src.name)));

        deps = deps ++ optionals allOptionalMods optionalDeps
                    ++ optionals allRecommendedMods recommendedDeps;

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
