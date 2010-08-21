x@{builderDefsPackage
  , libuuid
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version = "2.0.19";
    url = "http://www.nilfs.org/download/nilfs-utils-${version}.tar.bz2";
    hash = "0q9cb6ny0ah1s9rz1rgqka1pxdm3xvg0ywcqyhzcz4yhamfhg100";
    baseName = "nilfs-utils";
    name = "${baseName}-${version}";
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
  phaseNames = ["doFixPaths" "doConfigure" "doMakeInstall"];

  doFixPaths = a.fullDepEntry (''
    sed -e '/sysconfdir=\/etc/d; /sbindir=\/sbin/d' -i configure
    sed -e 's@/sbin/@'"$out"'/sbin/@' -i ./sbin/mount/cleaner_ctl.c
  '') ["doUnpack" "minInit"];

  meta = {
    description = "NILFS utilities";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.nilfs.org/download/?C=M;O=D";
    };
  };
}) x

