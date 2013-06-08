x@{builderDefsPackage
  , freeglut, freealut, mesa, libICE, libjpeg, openal, openscenegraph, plib
  , libSM, libunwind, libX11, xproto, libXext, xextproto, libXi, inputproto
  , libXmu, libXt, simgear, zlib, boost, cmake, libpng
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="flightgear";
    version="2.10.0";
    name="${baseName}-${version}";
    extension="tar.bz2";
    url="http://ftp.linux.kiev.ua/pub/fgfs/Source/${name}.${extension}";
    hash="0pq5nwyxwp8ar5rr0jh8p04bv0i9i841m374jwd748csnsn28zh6";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  datasrc = a.fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/flightgear/ftp/Shared/FlightGear-data-2.0.0.tar.bz2";
    sha256 = "0kvmvh5qycbpdjx12l20cbhljwimmcgww2dg4lkc2sky0kg14ic1";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall" "deployData"];

  deployData = a.fullDepEntry ''
    mkdir -p "$out/share/FlightGear"
    cd "$out/share/FlightGear"
    tar xvf ${datasrc}
  '' ["minInit" "defEnsureDir"];

  meta = {
    description = "A flight simulator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
  };
}) x

