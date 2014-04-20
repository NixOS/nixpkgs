x@{builderDefsPackage, ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="mtr";
    version="0.85";
    name="${baseName}-${version}";
    url="ftp://ftp.bitwizard.nl/${baseName}/${name}.tar.gz";
    hash="1jqrz8mil3lraaqgc87dyvx8d4bf3vq232pfx9mksxnkbphp4qvd";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  patches = [ ./edd425.patch ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doPatch" "doMakeInstall"];

  meta = {
    description = "A network diagnostics tool";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      unix;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "ftp://ftp.bitwizard.nl/mtr/";
    };
  };
}) x

