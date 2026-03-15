{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  # Unwrapped Cataclysm game
  unwrapped,
  # Selector predicate function
  # Attrs Pkgs -> List Pkgs
  selector,
  # The Cataclysm mod packages, not the Nixpkgs set.
  pkgs,
}:
let
  mods = if lib.isFunction selector then selector pkgs else selector;
in
symlinkJoin {
  name = unwrapped.pname + "-with-mods-" + unwrapped.version;

  paths = [ unwrapped ] ++ mods;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''
    wrapProgram "$out/bin/${unwrapped.meta.mainProgram}" \
      --add-flags "--basepath $out"
  '';

  # Remove position so that the derivation position is
  # correct
  meta = builtins.removeAttrs unwrapped.meta [ "position" ];
}
