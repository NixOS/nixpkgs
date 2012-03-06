x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="dd_rescue";
    version="1.22";
    name="${baseName}-${version}";
    url="http://www.garloff.de/kurt/linux/ddrescue/${name}.tar.gz";
    hash="0n0vs4cn5csdcsmlndg3z36ws68zlckj17zrbm6wynrbs8iirclp";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };
  dd_rhelp_src = a.fetchurl {
    url = "http://www.kalysto.org/pkg/dd_rhelp-0.1.2.tar.gz";
    sha256 = "0fhzkflg1ygiaj5ha0bf594d76vlgjsfwlpcmwrbady9frxvlkvv";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall" "install_dd_rhelp" "fixPaths"];
  makeFlags=[
    ''prefix="$out"''
    ''DESTDIR="$out"''
    ''INSTASROOT=''
  ];

  fixPaths = a.doPatchShebangs ''$out/bin'';

  install_dd_rhelp = a.fullDepEntry (''
    mkdir -p "$out/share/dd_rescue" "$out/bin"
    tar xf "${dd_rhelp_src}" -C "$out/share/dd_rescue"
    cp "$out/share/dd_rescue"/dd_rhelp*/dd_rhelp "$out/bin"
  '') ["minInit" "defEnsureDir"];
      
  meta = {
    description = "A tool to copy data from a damaged block device";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.garloff.de/kurt/linux/ddrescue/";
    };
  };
}) x

