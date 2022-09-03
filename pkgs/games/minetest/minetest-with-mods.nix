pkgs:
let flip = f: a: b: (f b a);
in
flip (
  modSelect:

  pkgs.makeOverridable
    (
      { symlinkJoin
      , makeWrapper
      , minetest-mods
      , minetest
      }:

      let
        mods = modSelect minetest-mods;
        modPaths = builtins.concatStringsSep
          ":"
          (map (mod: "${mod}/share/minetest/mods") mods);
      in
      symlinkJoin {
        name = "minetest-with-mods";
        buildInputs = [ makeWrapper ];
        paths = [
          minetest
        ] ++ mods;
        postBuild = ''
          wrapProgram $out/bin/minetest \
            --set MINETEST_MOD_PATH ${modPaths}
        '';
      }
    )
)
