x@{builderDefsPackage
  , libX11, xproto, libXt, libICE
  , libSM, libXext
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="xdaliclock";
    version="2.40";
    name="${baseName}-${version}";
    project="${baseName}";
    url="http://www.jwz.org/${project}/${name}.tar.gz";
    hash="03i8vwi9vz3gr938wr4miiymwv283mg11wgfaf2jhl6aqbmz4id7";
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
  phaseNames = ["doConfigure" "prepareDirs" "doMakeInstall"];

  prepareDirs = a.fullDepEntry ''
    mkdir -p "$out/bin" "$out/share" "$out/share/man/man1"
  '' ["minInit" "defEnsureDir"];

  goSrcDir = "cd X11";
      
  meta = {
    description = "A clock application that morphs digits when they are changed";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux ++ freebsd;
    license = "free";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.jwz.org/xdaliclock/";
    };
  };
}) x

