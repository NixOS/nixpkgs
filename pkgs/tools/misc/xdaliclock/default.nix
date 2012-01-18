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
    version="2.35";
    name="${baseName}-${version}";
    project="${baseName}";
    url="http://www.jwz.org/${project}/${name}.tar.gz";
    hash="0iybha2d0wqb4wkpw7l1zi3zhw57kqh3y7p4ja1k0fmvrzqc08g7";
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

