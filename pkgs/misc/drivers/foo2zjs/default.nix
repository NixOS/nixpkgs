x@{builderDefsPackage
  , foomatic_filters, bc, unzip, ghostscript
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="foo2zjs";
    version="20090908";
    name="${baseName}-${version}";
    url="http://ftp.de.debian.org/debian/pool/main/f/foo2zjs/foo2zjs_${version}dfsg.orig.tar.gz";
    hash="1pg4dmckvlx94zxh4gcw7jfmyb10ada7f6vsp5bgz1z95fwwlqjz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["fixMakefile" "doMakeInstall" "deployGetWeb"];
  makeFlags = [
    ''PREFIX=$out/''
    ''UDEVBIN=$out/bin/''
  ];
  fixMakefile = a.fullDepEntry ''
    touch all-test
  '' ["doUnpack" "minInit"];

  deployGetWeb = a.fullDepEntry ''
    ensureDir "$out/bin"
    ensureDir "$out/share"
    cp ./getweb "$out/bin"
    cp -r PPD "$out/share/foo2zjs-ppd"
  '' ["minInit" "defEnsureDir"];
      
  meta = {
    description = "ZjStream printer drivers";
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
      downloadPage = "http://packages.debian.org/sid/foo2zjs";
    };
  };
}) x
