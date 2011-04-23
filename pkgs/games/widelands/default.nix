x@{builderDefsPackage
  , libjpeg, boost, SDL, SDL_gfx, SDL_image, SDL_net, SDL_ttf, SDL_sound
  , gettext, zlib, libiconv, libpng, python, expat, lua5, glew, doxygen
  , cmake, ggz_base_libs, mesa, SDL_mixer
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="widelands";
    version="build16";
    name="${baseName}-${version}";
    project="${baseName}";
    url="http://launchpad.net/${project}/${version}/${version}/+download/${name}-src.tar.bz2";
    hash="0pb2d73c6hynhp1x54rcfbibrrri7lyxjybd1hicn503qcakrnyq";
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
  phaseNames = ["killBuildDir" "doCmake" "doMakeInstall" "createScript"];
      
  killBuildDir = a.fullDepEntry ''
    rm -r build
  '' ["minInit" "doUnpack"];

  cmakeFlags = [
    "-DLUA_LIBRARIES=-llua"
  ];

  createScript = a.fullDepEntry ''
    mkdir -p "$out/bin"
    echo '#! ${a.stdenv.shell}' >> "$out/bin/widelands"
    echo "cd \"$out/share/games/widelands\"" >> "$out/bin/widelands"
    echo "\"$out/games/widelands\" \"\$@\"" >> "$out/bin/widelands"
    chmod a+x "$out/bin/widelands"
  '' ["minInit"];

  meta = {
    description = "Widelands RTS with multiple-goods economy";
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
      downloadPage = "https://launchpad.net/widelands/+download";
    };
  };
}) x

