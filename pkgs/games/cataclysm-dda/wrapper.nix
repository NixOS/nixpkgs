{
  lib,
  symlinkJoin,
  makeWrapper,
}:

unwrapped:

pkgsSpec:

let
  mods = if lib.isFunction pkgsSpec then pkgsSpec unwrapped.pkgs else pkgsSpec;
in

if mods == [ ] then
  unwrapped
else
  symlinkJoin {
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

      # Launch the wrapped program
      replaceProgram() {
          cp "$1" "''${1}.bk"
          unlink "$1"
          mv "''${1}.bk" "$1"
          sed -i "$1" -e "s,${builtins.storeDir}/.\+\(/bin/cataclysm-tiles\),$out\1,"
      }
      for script in "$out/share/applications/cataclysm-dda.desktop" \
                    "$out/Applications/Cataclysm.app/Contents/MacOS/Cataclysm.sh"
      do
          if [ -e "$script" ]; then
              replaceProgram "$script"
          fi
      done
    '';
  }
