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
    version="build17";
    name="${baseName}-${version}";
    project="${baseName}";
    url="https://launchpadlibrarian.net/102893896/widelands-build17-src.tar.bz2";
    hash="be48b3b8f342a537b39a3aec2f7702250a6a47e427188ba3bece67d7d90f3cc5";
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
  phaseNames = ["killBuildDir" "doPatch"  "doCmake" "doMakeInstall" "createScript"];

  patches = [ ./boost_and_cmake_die_die_die.patch ]; 
      
  killBuildDir = a.fullDepEntry ''
    rm -r build
  '' ["minInit" "doUnpack"];

  cmakeFlags = [
    "-DLUA_LIBRARIES=-llua"
    "-DWL_PORTABLE=true"
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
    longDescription = ''
      Widelands is a real time strategy game based on "The Settlers" and "The
      Settlers II". It has a single player campaign mode, as well as a networked
      multiplayer mode. 
    '';

    maintainers = with a.lib.maintainers;
    [
      raskin
      jcumming
    ];
    #platforms = a.lib.platforms.linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "https://launchpad.net/widelands/+download";
    };
  };
}) x

