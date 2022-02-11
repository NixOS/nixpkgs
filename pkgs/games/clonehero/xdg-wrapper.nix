{ stdenv, clonehero-unwrapped, writeScript }:

# Clone Hero doesn't have an installer, so it just stores configuration & data relative to the binary.
# This wrapper works around that limitation, storing game configuration & data in XDG_CONFIG_HOME.
let
  name = "clonehero";
  desktopName = "Clone Hero";
in
writeScript "${name}-xdg-wrapper-${clonehero-unwrapped.version}" ''
  #!${stdenv.shell} -e
  configDir="''${XDG_CONFIG_HOME:-$HOME/.config}/unity3d/srylain Inc_/${desktopName}"
  mkdir -p "$configDir"

  # Force link shipped clonehero_Data, unless directory already exists (to allow modding)
  if [ ! -d "$configDir/clonehero_Data" ] || [ -L "$configDir/clonehero_Data" ]; then
    ln -snf ${clonehero-unwrapped}/share/clonehero_Data "$configDir"
  fi

  # Fake argv[0] to emulate running in the config directory
  exec -a "$configDir/${name}" ${clonehero-unwrapped}/bin/${name} "$@"
''
