{ lib, fetchFromGitHub, ... }:

let
  inherit (lib)
    importJSON
    licenses
    listToAttrs
    maintainers
    platforms
    readFile
    ;
in

listToAttrs (
  map (v: {
    inherit (v) name;
    value = fetchFromGitHub {
      name = "${v.name}-theme-${v.version}";
      owner = "DFgraphics";
      repo = v.name;
      rev = v.version;
      sha256 = v.sha256;
      meta = {
        platforms = platforms.all;
        maintainers = [
          maintainers.matthewbauer
          maintainers.shazow
        ];
        license = licenses.unfree;
      };
    };
  }) (importJSON ./themes.json)
)
