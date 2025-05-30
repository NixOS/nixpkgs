{
  lib,
  buildEnv,
  writeShellScriptBin,
  fetchurl,
  jre,
}:

let
  name = "legends-browser-${version}";
  version = "1.19.2";

  jar = fetchurl {
    url = "https://github.com/robertjanetzko/LegendsBrowser/releases/download/${version}/legendsbrowser-${version}.jar";
    hash = "sha256-jkv7InwaRn0K3VAa0LqkYpH6TnrT/tGYBtbvNGM6t98=";
  };

  script = writeShellScriptBin "legends-browser" ''
    set -eu
    BASE="$HOME/.local/share/df_linux/legends-browser/"
    mkdir -p "$BASE"
    cd "$BASE"
    if [[ ! -e legendsbrowser.properties ]]; then
      echo 'Creating initial configuration for legends-browser'
      echo "last=$(cd ..; pwd)" > legendsbrowser.properties
    fi
    exec ${jre}/bin/java -jar ${jar}
  '';
in

buildEnv {
  inherit name;
  paths = [ script ];

  meta = with lib; {
    description = "Multi-platform, open source, java-based legends viewer for dwarf fortress";
    maintainers = with maintainers; [
      Baughn
      numinit
    ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = "https://github.com/robertjanetzko/LegendsBrowser";
  };
}
