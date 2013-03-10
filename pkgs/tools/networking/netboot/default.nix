x@{builderDefsPackage
  , fetchurl, yacc, bison, ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="0.10.2";
    baseName="netboot";
    name="${baseName}-${version}";
    url="mirror://sourceforge/netboot/${name}.tar.gz";
    hash="09w09bvwgb0xzn8hjz5rhi3aibysdadbg693ahn8rylnqfq4hwg0";
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
  phaseNames = ["doUnpack" "doConfigure" "doMakeInstall"];

  meta = {
    description = "Mini PXE server";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
  };
  passthru = {
    updateInfo = {
      downloadPage = "https://github.com/ITikhonov/netboot";
    };
  };
}) x

