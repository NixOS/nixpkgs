pkgs:

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
  common = let f = import ./common.nix; in f (builtins.intersectAttrs (builtins.functionArgs f) pkgs // {
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
  buildOpenRASet = f: args: builtins.mapAttrs (name: value: if builtins.isFunction value then value name else value) (f ({
    inherit (pkgs) fetchFromGitHub;
    postFetch = ''
      sed -i 's/curl/curl --insecure/g' $out/thirdparty/{fetch-thirdparty-deps,noget}.sh
      $out/thirdparty/fetch-thirdparty-deps.sh
    '';
  } // args));

in rec {
  # The whole attribute set is destructered to ensure those (and only those) attributes are given
  # and to provide defaults for those that are optional.
  buildOpenRAEngine = { name ? null, version, description, homepage, mods, src, installExperimental ? "" }@engine:
    # Allow specifying the name at a later point if no name has been given.
    let builder = name: pkgs.callPackage ./engine.nix (common // {
      engine = engine // { inherit name installExperimental; };
    }); in if name == null then builder else builder name;

  # See `buildOpenRAEngine`.
  buildOpenRAMod = { name ? null, version, title, description, homepage, src, engine }@mod: ({ version, mods ? [], src }@engine:
    let builder = name: pkgs.callPackage ./mod.nix (common // {
      mod = mod // { inherit name; };
      engine = engine // { inherit mods; };
    }); in if name == null then builder else builder name) engine;

  # See `buildOpenRASet`.
  engines = buildOpenRASet (import ./engines.nix) { inherit buildOpenRAEngine; };
  mods = buildOpenRASet (import ./mods.nix) { inherit buildOpenRAMod; };
}
