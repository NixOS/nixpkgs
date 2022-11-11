/*  This file defines all OpenRA packages under `openraPackages`,
    e.g. the OpenRA release engine can be found at `openraPackages.engines.release` (see `engines.nix`),
    or the out-of-tree mod "Combined Arms" can be found at `openraPackages.mods.ca` (see `mods.nix`).
    The `openra` package is just an alias to `openraPackages.engines.release`,
    and just provides the mods included in the source code of the engine.
    Additional engines or mods can be added with `openraPackages.buildOpenRAEngine` (function around `engine.nix`)
    and `openraPackages.buildOpenRAMod` (function around `mod.nix`), respectively.
*/
pkgs:

with pkgs.lib;

let
  /*  Building an engine or out-of-tree mod is very similar,
      but different enough not to be able to build them with the same package definition,
      so instaed we define what is common between them in a seperate file.

      Although `callPackage` could be used, it would require undoing `makeOverridable`,
      because `common.nix` does not define a package, but just an attribute set,
      which is directly passed as part of the argument to the engines and mods `callPackage`,
      so either the attributes added by `makeOverridable` have to be removed
      or the engine and mod package definitions will need to add `...` to the argument list.
  */
  common = let f = import ./common.nix; in f (builtins.intersectAttrs (functionArgs f) pkgs // {
    lua = pkgs.lua5_1;
    # It is not necessary to run the game, but it is nicer to be given an error dialog in the case of failure,
    # rather than having to look to the logs why it is not starting.
    inherit (pkgs.gnome) zenity;
  });

  /*  Building a set of engines or mods requires some dependencies as well,
      so the sets will actually be defined as a function instead,
      requiring the dependencies and returning the actual set.

      Not all dependencies for defining a engine or mod set are shared,
      so additional arguments can be passed as well.

      The builders for engines and mods allow to delay specifying the name,
      by returning a function that expects a name, which we use, in this case,
      to base the name on the attribute name instead, preventing the need to specify the name twice
      if the attribute name and engine/mod name are equal.
  */
  callWithName = name: value: if isFunction value then value name else value;
  buildOpenRASet = f: args: pkgs.recurseIntoAttrs (mapAttrs callWithName (f ({
    inherit (pkgs) fetchFromGitHub;
    postFetch = ''
      sed -i 's/curl/curl --insecure/g' $out/thirdparty/{fetch-thirdparty-deps,noget}.sh
      $out/thirdparty/fetch-thirdparty-deps.sh
    '';
  } // args)));

in pkgs.recurseIntoAttrs rec {
  # The whole attribute set is destructered to ensure those (and only those) attributes are given
  # and to provide defaults for those that are optional.
  buildOpenRAEngine = { name ? null, version, description, homepage, mods, src }@engine:
    # Allow specifying the name at a later point if no name has been given.
    let builder = name: pkgs.callPackage ./engine.nix (common // {
      engine = engine // { inherit name; };
    }); in if name == null then builder else builder name;

  # See `buildOpenRAEngine`.
  buildOpenRAMod = { name ? null, version, title, description, homepage, src, engine, assetsError ? "" }@mod: ({ version, mods ? [], src }@engine:
    let builder = name: pkgs.callPackage ./mod.nix (common // {
      mod = mod // { inherit name assetsError; };
      engine = engine // { inherit mods; };
    }); in if name == null then builder else builder name) engine;

  # See `buildOpenRASet`.
  engines = buildOpenRASet (import ./engines.nix) { inherit buildOpenRAEngine; };
  mods = buildOpenRASet (import ./mods.nix) { inherit buildOpenRAMod; };
}
