pkgs:
let flip = f: a: b: (f b a);
in
flip (
  modSelect:

  pkgs.makeOverridable
    (
      { minetest-mods
      , minetest
      }:

      let
        mods = modSelect minetest-mods;
        modPaths = builtins.concatStringsSep
          ":"
          (map (mod: "${mod}/share/minetest/mods") mods);
      in
      pkgs.symlinkJoin {
        name = "minetest-with-mods";
        buildInputs = [ pkgs.makeWrapper ];
        paths = [
          minetest
        ] ++ mods;
        postBuild = ''
          wrapProgram $out/bin/minetest \
            --prefix MINETEST_MOD_PATH : ${modPaths}
        '';
      }
    )
)
