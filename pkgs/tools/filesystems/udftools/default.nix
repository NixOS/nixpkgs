x@{builderDefsPackage
  , ncurses, readline
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="udftools";
    version="1.0.0b3";
    name="${baseName}-${version}";
    project="linux-udf";
    url="mirror://sourceforge/${project}/${baseName}/${version}/${name}.tar.gz";
    hash="180414z7jblby64556i8p24rcaas937zwnyp1zg073jdin3rw1y5";
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
  phaseNames = ["fixIncludes" "doConfigure" "doMakeInstall"];
      
  fixIncludes = a.fullDepEntry ''
    sed -e '1i#include <limits.h>' -i cdrwtool/cdrwtool.c -i pktsetup/pktsetup.c
    sed -e 's@[(]char[*][)]spm [+]=@spm = ((char*) spm) + @' -i wrudf/wrudf.c
  '' ["doUnpack" "minInit"];

  meta = {
    description = "UDF tools";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
  };
}) x

