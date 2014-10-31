{ lib, stdenv, fetchurl, pkgconfig, cmake, intltool, gettext, which
, libxml2, enchant, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, libXau, libXdmcp
, dbus, gtk2, gtk3, qt4
, plugins ? [ ]
, enableAnthy ? false
}:

let
  plugs = plugins;
in
  stdenv.mkDerivation rec {
    name = "fcitx-4.2.8.5";

    src = fetchurl {
      url = "http://download.fcitx-im.org/fcitx/${name}_dict.tar.xz";
      sha256 = "0whv7mnzig4l5v518r200psa1fp3dyl1jkr5z0q13ijzh1bnyggy";
    };

    # Anthy plugin
    anthyPluginName = "fcitx-anthy-0.2.1";
    anthyPluginSrc = lib.optional enableAnthy (fetchurl {
      url = "http://download.fcitx-im.org/fcitx-anthy/${anthyPluginName}.tar.xz";
      sha256 = "13fpfhhxkzbq53h10i3hifa37nngm47jq361i70z22bgcrs8887x";
    });

    patchPhase = ''
      substituteInPlace src/frontend/qt/CMakeLists.txt \
        --replace $\{QT_PLUGINS_DIR} $out/lib/qt4/plugins
    '';

    buildInputs = with lib; [
      cmake enchant pango gettext libxml2 isocodes pkgconfig libxkbfile
      intltool cairo icu libpthreadstubs libXau libXdmcp
      dbus gtk2 gtk3 qt4
      ] 
      ++ plugs;

    cmakeFlags = ''
      -DENABLE_QT_IM_MODULE=ON
      -DENABLE_GTK2_IM_MODULE=ON
      -DENABLE_GTK3_IM_MODULE=ON
      -DENABLE_GIR=OFF
      -DENABLE_OPENCC=OFF
      -DENABLE_PRESAGE=OFF
      -DENABLE_XDGAUTOSTART=OFF
    '';

    postInstall = ''
      set -e
      function installPlugin () {
        pluginSearchString="$1"
        pluginSrc="$2"
        pluginName="$3"

        if [[ "$plugins" == *$pluginSearchString* ]] ; then
          cd $NIX_BUILD_TOP
          unpackFile "$pluginSrc"
          cd "$pluginName"

          cmakeConfigurePhase
          buildPhase
          make install
        fi
      }

      export cmakeFlags="$cmakeFlags -DCMAKE_MODULE_PATH=$prefix/share/cmake/fcitx -DCMAKE_PREFIX_PATH=$prefix -DCMAKE_C_FLAGS=-I$prefix/include -DCMAKE_CXX_FLAGS=-I$prefix/include "

      installPlugin "anthy" "$anthyPluginSrc" "$anthyPluginName"
    '';

    plugins = plugs;

    meta = {
      homepage = "https://code.google.com/p/fcitx/";
      description = "A Flexible Input Method Framework";
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [cdepillabout iyzsong];
    };
  }
