{ lib, stdenv, fetchFromGitHub, which, ninja, pkg-config, protobuf
, ibus, gtk2, zinnia, qt5, libxcb, tegaki-zinnia-japanese, python3Packages }:

stdenv.mkDerivation rec {
  pname = "ibus-mozc";
  version = "2.26.4660.102";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = "063c41f1d7c1a877f44c1f8caad6be1897350336";
    sha256 = "sha256-sgsfJZALpPHFB5bXu4OkRssViRDaPcgLfEyGhbqvJbI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    which ninja python3Packages.python python3Packages.six
    python3Packages.gyp pkg-config qt5.wrapQtAppsHook
  ];

  buildInputs = [ protobuf ibus gtk2 zinnia qt5.qtbase libxcb ];

  postUnpack = lib.optionalString stdenv.isLinux ''
    sed -i 's/-lc++/-lstdc++/g' $sourceRoot/src/gyp/common.gypi
  '';

  configurePhase = ''
    runHook preConfigure

    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1 ibus_mozc_path=$out/lib/ibus-mozc/ibus-engine-mozc zinnia_model_file=${tegaki-zinnia-japanese}/share/tegaki/models/zinnia/handwriting-ja.model"
    cd src && python build_mozc.py gyp --gypdir=${python3Packages.gyp}/bin --server_dir=$out/lib/mozc

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    PYTHONPATH="$PWD:$PYTHONPATH" python build_mozc.py build -c Release \
      unix/ibus/ibus.gyp:ibus_mozc \
      unix/emacs/emacs.gyp:mozc_emacs_helper \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      renderer/renderer.gyp:mozc_renderer

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d        $out/share/licenses/mozc
    head -n 29 server/mozc_server.cc > $out/share/licenses/mozc/LICENSE
    install -m 644    data/installer/*.html $out/share/licenses/mozc/

    install -D -m 755 out_linux/Release/mozc_server $out/lib/mozc/mozc_server
    install    -m 755 out_linux/Release/mozc_tool   $out/lib/mozc/mozc_tool
    wrapQtApp $out/lib/mozc/mozc_tool

    install -d        $out/share/doc/mozc
    install -m 644    data/installer/*.html $out/share/doc/mozc/

    install -D -m 755 out_linux/Release/ibus_mozc           $out/lib/ibus-mozc/ibus-engine-mozc
    install -D -m 644 out_linux/Release/gen/unix/ibus/mozc.xml $out/share/ibus/component/mozc.xml
    install -D -m 644 data/images/unix/ime_product_icon_opensource-32.png $out/share/ibus-mozc/product_icon.png
    install    -m 644 data/images/unix/ui-tool.png          $out/share/ibus-mozc/tool.png
    install    -m 644 data/images/unix/ui-properties.png    $out/share/ibus-mozc/properties.png
    install    -m 644 data/images/unix/ui-dictionary.png    $out/share/ibus-mozc/dictionary.png
    install    -m 644 data/images/unix/ui-direct.png        $out/share/ibus-mozc/direct.png
    install    -m 644 data/images/unix/ui-hiragana.png      $out/share/ibus-mozc/hiragana.png
    install    -m 644 data/images/unix/ui-katakana_half.png $out/share/ibus-mozc/katakana_half.png
    install    -m 644 data/images/unix/ui-katakana_full.png $out/share/ibus-mozc/katakana_full.png
    install    -m 644 data/images/unix/ui-alpha_half.png    $out/share/ibus-mozc/alpha_half.png
    install    -m 644 data/images/unix/ui-alpha_full.png    $out/share/ibus-mozc/alpha_full.png
    install -D -m 755 out_linux/Release/mozc_renderer       $out/lib/mozc/mozc_renderer

    runHook postInstall
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "Japanese input method from Google";
    homepage = "https://github.com/google/mozc";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ericsagnes ];
  };
}
