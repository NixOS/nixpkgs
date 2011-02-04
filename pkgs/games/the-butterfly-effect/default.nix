x@{builderDefsPackage
  , qt4, box2d
  ,fetchsvn
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchsvn"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="tbe";
    revision="1316";
    version="r${revision}";
    name="${baseName}-${version}";
    url="https://tbe.svn.sourceforge.net/svnroot/tbe/trunk";
    hash="0ag1nl4yf42ixwaly93fg2kcry71nrfq54z4w556qfh0i44fhcvd";
  };
in
rec {
  srcDrv = a.fetchsvn {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.revision;
  };
  src = srcDrv + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" "doConfigure" "doMakeInstall" "doDeploy"];
  configureCommand = "sh configure";

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.box2d}/include/Box2D"
  '';

  doDeploy = a.fullDepEntry ''
    ensureDir "$out/share/tbe"
    cp -r . "$out/share/tbe/build-dir"
    ensureDir "$out/bin"
    echo '#! /bin/sh' >> "$out/bin/tbe"
    echo "$out/share/tbe/build-dir/tbe \"\$@\"" >> "$out/bin/tbe"
    chmod a+x "$out/bin/tbe"
  '' ["minInit" "doMake" "defEnsureDir"];

  meta = {
    description = "A physics-based game vaguely similar to Incredible Machine";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "GPLv2";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/tbe/files/";
    };
  };
}) x

