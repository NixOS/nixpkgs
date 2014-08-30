x@{builderDefsPackage
  , qt4, box2d, which
  ,fetchsvn, cmake
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
    revision="2048";
    version="r${revision}";
    name="${baseName}-${version}";
    url="https://tbe.svn.sourceforge.net/svnroot/tbe/trunk";
    hash="19pqpkil4r5y9j4nszkbs70lq720nvqw8g8magd8nf2n3l9nqm51";
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

  phaseNames = ["setVars" "doCmake" "doMakeInstall" "doDeploy"];

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.box2d}/include/Box2D"
  '';

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out/share/tbe"
    cp -r . "$out/share/tbe/build-dir"
    mkdir -p "$out/bin"
    echo '#!${a.stdenv.shell}' >> "$out/bin/tbe"
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
    license = a.stdenv.lib.licenses.gpl2;
  };
  passthru = {
    inherit srcDrv;
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/tbe/files/";
    };
  };
}) x
