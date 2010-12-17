x@{builderDefsPackage
  , qt4, box2d_2_0_1
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="tbe";
    version="8.2";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${baseName}/Milestone%20${version}/TheButterflyEffect-m${version}.src.tgz";
    hash="1s6xxvhw5rplpfmrhvfp4kb5z89lhcnrhawam8v7i51rk5hmjkd0";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" /*"patchBox2d"*/ "doConfigure" "doMakeInstall" "doDeploy"];
  configureCommand = "sh configure";

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.box2d_2_0_1}/include/Box2D"
  '';

  doDeploy = a.fullDepEntry ''
    ensureDir "$out/share/tbe"
    cp -r . "$out/share/tbe/build-dir"
    ensureDir "$out/bin"
    echo '#! /bin/sh' >> "$out/bin/tbe"
    echo "$out/share/tbe/build-dir/tbe \"\$@\"" >> "$out/bin/tbe"
    chmod a+x "$out/bin/tbe"
  '' ["minInit" "doMake" "defEnsureDir"];

  patchBox2d = a.fullDepEntry ''
    find . -exec sed -i '{}' -e s@b2XForm@b2Transform@g ';'
  '' ["minInit" "doUnpack"];
      
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

