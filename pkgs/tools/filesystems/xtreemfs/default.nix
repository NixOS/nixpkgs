x@{builderDefsPackage
  , boost, fuse, openssl, cmake, attr, jdk, ant, which, python, file
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="XtreemFS";
    version="1.4";
    name="${baseName}-${version}";
    url="http://xtreemfs.googlecode.com/files/${name}.tar.gz";
    hash="1hzd6anplxdcl4cg6xwriqk9b34541r7ah1ab2xavv149a2ll25s";
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
  phaseNames = ["setVars" "fixMakefile" "doMakeInstall" "fixInterpreterBin"
    "fixInterpreterEtc"
    "usrIsOut"];

  setVars = a.noDepEntry ''
    export JAVA_HOME="${jdk}"
    export ANT_HOME="${ant}"
    export CMAKE_HOME=${cmake}
  '';

  fixMakefile = a.fullDepEntry ''
    sed -e 's@DESTDIR)/usr@DESTDIR)@g' -i Makefile

    sed -e 's@/usr/bin/@@g' -i cpp/thirdparty/protobuf-*/configure
    sed -e 's@/usr/bin/@@g' -i cpp/thirdparty/protobuf-*/gtest/configure
    sed -e 's@/usr/bin/@@g' -i cpp/thirdparty/gtest-*/configure
  '' ["doUnpack" "minInit"];

  fixInterpreterBin = a.doPatchShebangs "$out/bin";
  fixInterpreterEtc = a.doPatchShebangs "$out/etc/xos/xtreemfs";

  usrIsOut = a.fullDepEntry ''
    sed -e "s@/usr/@$out/@g" -i \
      "$out"/{bin/xtfs_*,etc/xos/xtreemfs/*.*,etc/xos/xtreemfs/*/*,etc/init.d/*}
    sed -e "s@JAVA_HOME=/usr@JAVA_HOME=${jdk}@g" -i \
      "$out"/{bin/xtfs_*,etc/init.d/*}
  '' ["minInit"];

  makeFlags = [
    ''DESTDIR="$out"''
    ''SHELL="${a.stdenv.shell}"''
  ];
      
  meta = {
    description = "A distributed filesystem";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.bsd3;
    broken = true;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://xtreemfs.org/download_sources.php";
    };
  };
}) x

