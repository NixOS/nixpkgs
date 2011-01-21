x@{builderDefsPackage
  , openssl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ipmiutil";
    version="2.7.3";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${name}.tar.gz";
    hash="0z6ykz5db4ws7hpi25waf9vznwsh0vp819h5s7s8r054vxslrfpq";
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
  phaseNames = ["doConfigure" "fixMakefile" "doMakeInstall"];

  fixMakefile = a .fullDepEntry ''
    sed -e "s@/usr@$out@g" -i Makefile */Makefile */*/Makefile
    sed -e "s@/etc@$out/etc@g" -i Makefile */Makefile
    sed -e "s@/var@$out/var@g" -i Makefile */Makefile
  '' ["minInit" "doConfigure"];
      
  meta = {
    description = "IPMI utilities";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.bsd3;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/ipmiutil/files/ipmiutil/";
    };
  };
}) x

