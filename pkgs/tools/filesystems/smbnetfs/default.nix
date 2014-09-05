x@{builderDefsPackage
  , fuse, samba, pkgconfig
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="smbnetfs";
    dirBaseName="SMBNetFS";
    version = "0.5.3b";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${dirBaseName}-${version}/${name}.tar.bz2";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "1j9b30kh4ymv4nr8c1qc7hfg6pscgyj75ib16pqa0zljjk1klx18";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A FUSE FS for mounting Samba shares";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
    downloadPage = "http://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    updateWalker = true;
    inherit version;
  };
}) x

