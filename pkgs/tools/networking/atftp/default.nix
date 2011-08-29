x@{builderDefsPackage
  , readline, tcp_wrappers, pcre
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="atftp";
    version="0.7";
    name="${baseName}-${version}";
    url="mirror://debian/pool/main/a/atftp/atftp_${version}.dfsg.orig.tar.gz";
    hash="0nd5dl14d6z5abgcbxcn41rfn3syza6s57bbgh4aq3r9cxdmz08q";
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
  phaseNames = ["doPatch" "doConfigure" "doMakeInstall"];
      
  patches = [./debian.patch];

  meta = {
    description = "Advanced tftp tools";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://packages.debian.org/source/sid/atftp";
    };
  };
}) x

