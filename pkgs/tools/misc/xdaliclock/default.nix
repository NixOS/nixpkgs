x@{builderDefsPackage
  , libX11, xproto, libXt, libICE
  , libSM, libXext
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="xdaliclock";
    version = "2.41";
    name="${baseName}-${version}";
    project="${baseName}";
    url="http://www.jwz.org/${project}/${name}.tar.gz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "1crkjvza692irkqm9vwgn58m8ps93n0rxigm6pasgl5dnx3p6d1d";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "prepareDirs" "doMakeInstall"];

  prepareDirs = a.fullDepEntry ''
    mkdir -p "$out/bin" "$out/share" "$out/share/man/man1"
  '' ["minInit" "defEnsureDir"];

  goSrcDir = "cd X11";

  meta = {
    description = "A clock application that morphs digits when they are changed";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux ++ freebsd;
    license = a.lib.licenses.free; #TODO BSD on Gentoo, looks like MIT
    downloadPage = "http://www.jwz.org/xdaliclock/";
    inherit version;
    updateWalker = true;
  };
}) x
