x@{builderDefsPackage
  , fuse, samba, pkgconfig, glib
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
    version = "0.6.0";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${dirBaseName}-${version}/${name}.tar.bz2";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "16sikr81ipn8v1a1zrqgnsy2as3zcaxbzkr0bm5vxy012bq0plkd";
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

