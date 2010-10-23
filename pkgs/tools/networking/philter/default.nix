x@{builderDefsPackage
  , python, makeWrapper
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="philter";
    version="1.1";
    name="${baseName}-${version}";
    url="http://prdownloads.sourceforge.net/${baseName}/${name}.tar.gz";
    hash="177pqfflhdn2mw9lc1wv9ik32ji69rjqr6dw83hfndwlsva5151l";
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
  phaseNames = ["installProgram" "patchShebangs" "wrapBinContentsPython"];
  patchShebangs = (a.doPatchShebangs "$out/bin");

  installProgram = a.fullDepEntry(''
    mv "$out/share/philter/".*rc "$out/share/philter/philterrc"
    ensureDir "$out/bin"
    cp "$out/share/philter/src/philter.py" "$out/bin/philter"
    chmod a+x "$out/bin/philter"
  '') ["addInputs" "copyToShare" "minInit"];

  copyToShare = (a.simplyShare "philter");
      
  meta = {
    description = "Mail sorter for Maildirs";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://philter.sourceforge.net/";
    };
  };
}) x

