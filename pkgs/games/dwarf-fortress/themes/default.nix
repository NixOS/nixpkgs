{lib, fetchFromGitHub, ...}:

with builtins;

listToAttrs (map (v: {
  inherit (v) name;
  value = fetchFromGitHub {
    name = "${v.name}-${v.version}";
    owner = "DFgraphics";
    repo = v.name;
    rev = v.version;
    sha256 = v.sha256;
    meta = with lib; {
      platforms = platforms.all;
      maintainers = [ maintainers.matthewbauer ];
      license = licenses.free;
    };
  };
}) (fromJSON (readFile ./themes.json)))
