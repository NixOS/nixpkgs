x@{builderDefsPackage
  , zlib
  , curl, gnutls, fribidi, libpng, SDL, SDL_gfx, SDL_image, SDL_mixer
  , SDL_net, SDL_ttf, libunwind, libX11, xproto, libxml2, pkgconfig
  , gettext, intltool, libtool, perl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="warmux";
    version="11.04.1";
    name="${baseName}-${version}";
    url="http://download.gna.org/${baseName}/${name}.tar.bz2";
    hash="1vp44wdpnb1g6cddmn3nphc543pxsdhjis52mfif0p2c7qslz73q";
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
  phaseNames = ["doConfigure" "doMakeInstall"];

  configureFlags = "CFLAGS=\"-include ${zlib}/include/zlib.h\"";

  meta = {
    description = "Ballistics turn-based battle game between teams";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://download.gna.org/warmux/";
    };
  };
}) x

