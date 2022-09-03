{ symlinkJoin
, makeWrapper
, minetest-mods
, minetest
}:

{
  minetestPackage ? minetest,
  modSelect
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
    minetestPackage
  ] ++ mods;
  postBuild = ''
    wrapProgram $out/bin/minetest \
      --set MINETEST_MOD_PATH ${modPaths}
  '';
}
