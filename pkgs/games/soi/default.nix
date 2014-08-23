x@{builderDefsPackage
  , mesa, SDL, cmake, eigen
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="soi";
    fileName="Spheres%20of%20Influence";
    majorVersion="0.1";
    minorVersion="1";
    version="${majorVersion}.${minorVersion}";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}-${majorVersion}/${fileName}-${version}-Source.tar.gz";
    hash="dfc59319d2962033709bb751c71728417888addc6c32cbec3da9679087732a81";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    name = "${sourceInfo.name}.tar.gz";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" "doCmake" "doMakeInstall"];

  setVars = a.noDepEntry ''
    export EIGENDIR=${a.eigen}/include/eigen2
  ''; 
      
  meta = {
    description = "A physics-based puzzle game";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
    broken = true;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/soi/files/";
    };
  };
}) x
