x@{builderDefsPackage
  , imagemagickBig, pkgconfig, python, pygtk, perl, libX11, libv4l
  , qt4, lzma
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="zbar";
    version="0.10";
    name="${baseName}-${version}";
    pName="${baseName}";
    url="mirror://sourceforge/project/${pName}/${baseName}/${version}/${name}.tar.bz2";
    hash="1imdvf5k34g1x2zr6975basczkz3zdxg6xnci50yyp5yvcwznki3";
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
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Bar code toolset";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl21;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://zbar.sourceforge.net/";
    };
  };
}) x

