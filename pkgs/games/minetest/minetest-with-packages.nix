{ lib
, symlinkJoin
, makeWrapper
, minetest
, minetestPackages
}:

packageSelect:

let selectedPackages = packageSelect minetestPackages; in

assert lib.assertMsg
  (lib.filter (p: (p.drvAttrs.type or "mod") == "txp") selectedPackages == [])
  "Installing texture packs through nix is not yet supported, \
  due to https://github.com/minetest/minetest/issues/12835";

symlinkJoin {
  name = "minetest-with-packages";

  # NOTE: We can't put selectedPackages here, because having symlinks inside
  # minetest mods breaks mod security. Instead, we non-recursively link the
  # package directories in postBuild.
  paths = [
    minetest
  ];

  buildInputs = [
    makeWrapper
  ];

  postBuild = ''
    # Merge packages
    mkdir -p $out/share/minetest/mods
    mkdir -p $out/share/minetest/games
    mkdir -p $out/share/minetest/textures
    for package in ${lib.escapeShellArgs selectedPackages}; do
      for mod in "$package"/share/minetest/mods/*; do
        ln -s "$mod" "$out/share/minetest/mods/$(basename "$mod")"
      done
      for game in "$package"/share/minetest/games/*; do
        ln -s "$game" "$out/share/minetest/games/$(basename "$game")"
      done
      for txp in "$package"/share/minetest/textures/*; do
        ln -s "$txp" "$out/share/minetest/textures/$(basename "$txp")"
      done
    done

    # Point minetest executables to packages
    for bin in $out/bin/{minetest,minetestserver}; do
      if [ -e $bin ]; then
        wrapProgram $bin \
          --prefix MINETEST_MOD_PATH : "$out/share/minetest/mods" \
          --prefix MINETEST_SUBGAME_PATH : "$out/share/minetest/games"
      fi
    done
  '';
}
