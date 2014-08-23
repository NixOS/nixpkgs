x@{builderDefsPackage
  , jre
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["jre"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="welkin";
    version="1.1";
    name="${baseName}-${version}";
    url="http://simile.mit.edu/dist/welkin/${name}.tar.gz";
    hash="0hr2xvfz887fdf2ysiqydv6m13gbdl5x0fh4960i655d5imvd5x0";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doDeploy" "createBin"];

  doDeploy = a.simplyShare "welkin";

  createBin = a.fullDepEntry ''
    mkdir -p "$out/bin"
    echo "#! ${a.stdenv.shell}" > "$out/bin/welkin"
    echo "export JAVA_HOME=${jre}" >> "$out/bin/welkin"
    echo "\"$out/share/welkin/welkin.sh\" \"\$@\"" >> "$out/bin/welkin"
    sed -e 's@[.]/lib/welkin[.]jar@"'"$out"'/share/welkin/lib/welkin.jar"@' -i "$out/share/welkin/welkin.sh"
    chmod a+x "$out/bin/welkin"
  '' ["minInit" "defEnsureDir"];
      
  meta = {
    description = "An RDF visualizer";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    hydraPlatforms = [];
    license = "free-noncopyleft";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://simile.mit.edu/dist/welkin/";
    };
  };
}) x

