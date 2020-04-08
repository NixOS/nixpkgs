{ lib, symlinkJoin, makeWrapper }:

unwrapped:

pkgsSpec:

let
  mods = if lib.isFunction pkgsSpec
         then pkgsSpec unwrapped.pkgs
         else pkgsSpec;
in

if builtins.length mods == 0
then unwrapped
else symlinkJoin {
  name = unwrapped.name + "-with-mods";

  paths = [ unwrapped ] ++ mods;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    if [ -x $out/bin/cataclysm ]; then
        wrapProgram $out/bin/cataclysm \
            --add-flags "--datadir $out/share/cataclysm-dda/"
    fi
    if [ -x $out/bin/cataclysm-tiles ]; then
        wrapProgram $out/bin/cataclysm-tiles \
            --add-flags "--datadir $out/share/cataclysm-dda/"
    fi
  '';
}
