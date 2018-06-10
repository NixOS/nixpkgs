{stdenv, lib, fetchFromGitHub}:

with builtins;

listToAttrs (map (v: {
  inherit (v) name;
  value = stdenv.mkDerivation {
    name = "${v.name}-${v.version}";
    src = fetchFromGitHub {
      owner = "DFgraphics";
      repo = v.name;
      rev = v.version;
      sha256 = v.sha256;
    };
    installPhase = ''
      mkdir -p $out
      cp -r data raw $out
    '';
    meta = with lib; {
      platforms = platforms.all;
      maintainers = [ maintainers.matthewbauer ];
      license = licenses.free;
    };
  };
}) (fromJSON (readFile ./themes.json)))
