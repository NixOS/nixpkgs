{ clangStdenv, fetchFromGitHub, fetchsvn, gyp, which, ninja, python, pkgconfig, protobuf, ibus, gtk, zinnia, qt4, libxcb, tegaki-zinnia-japanese }:

let
  japanese_usage_dictionary = fetchsvn {
    url = "http://japanese-usage-dictionary.googlecode.com/svn/trunk";
    rev = "10";
    sha256 = "0pyrpz9c8nxccwpgyr36w314mi8h132cis8ijvlqmmhqxwsi30hm";
  };
in clangStdenv.mkDerivation rec {
  name = "mozc-${version}";
  version = "2015-05-02";

  meta = with clangStdenv.lib; {
    description = "Japanese input method from Google";
    homepage = http://code.google.com/p/mozc/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.gebner ];
  };

  nativeBuildInputs = [ gyp which ninja python pkgconfig ];
  buildInputs = [ protobuf ibus gtk zinnia qt4 libxcb ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = "d9783737ecfcb68c3d98d84e7052d716f4d0e0cb";
    sha256 = "52a83658e2e4a7b38e31a4085682be24c9c5f4c51a01578598a30b9833827b72";
  };
  postUnpack = ''
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
  '';

  configurePhase = ''
    export GYP_DEFINES="ibus_mozc_path=$out/lib/ibus-mozc/ibus-engine-mozc ibus_mozc_icon_path=$out/share/ibus-mozc/product_icon.png document_dir=$out/share/doc/mozc zinnia_model_file=${tegaki-zinnia-japanese}/share/tegaki/models/zinnia/handwriting-ja.model use_libprotobuf=1"
    python src/build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc
  '';

  buildPhase = ''
    python src/build_mozc.py build -c Release \
      unix/ibus/ibus.gyp:ibus_mozc \
      unix/emacs/emacs.gyp:mozc_emacs_helper \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      renderer/renderer.gyp:mozc_renderer
  '';

  checkPhase = ''
    python src/build_mozc.py runtests -c Release
  '';

  installPhase = ''
    install -D -m 755 src/out_linux/Release/mozc_server $out/lib/mozc/mozc_server
    install    -m 755 src/out_linux/Release/mozc_tool   $out/lib/mozc/mozc_tool

    install -d $out/share/doc/mozc
    install -m 644 src/data/installer/*.html $out/share/doc/mozc/

    install -D -m 755 src/out_linux/Release/ibus_mozc       $out/lib/ibus-mozc/ibus-engine-mozc
    install -D -m 644 src/out_linux/Release/gen/unix/ibus/mozc.xml $out/share/ibus/component/mozc.xml
    install -D -m 644 src/data/images/unix/ime_product_icon_opensource-32.png $out/share/ibus-mozc/product_icon.png
    install    -m 644 src/data/images/unix/ui-tool.png          $out/share/ibus-mozc/tool.png
    install    -m 644 src/data/images/unix/ui-properties.png    $out/share/ibus-mozc/properties.png
    install    -m 644 src/data/images/unix/ui-dictionary.png    $out/share/ibus-mozc/dictionary.png
    install    -m 644 src/data/images/unix/ui-direct.png        $out/share/ibus-mozc/direct.png
    install    -m 644 src/data/images/unix/ui-hiragana.png      $out/share/ibus-mozc/hiragana.png
    install    -m 644 src/data/images/unix/ui-katakana_half.png $out/share/ibus-mozc/katakana_half.png
    install    -m 644 src/data/images/unix/ui-katakana_full.png $out/share/ibus-mozc/katakana_full.png
    install    -m 644 src/data/images/unix/ui-alpha_half.png    $out/share/ibus-mozc/alpha_half.png
    install    -m 644 src/data/images/unix/ui-alpha_full.png    $out/share/ibus-mozc/alpha_full.png
    install -D -m 755 src/out_linux/Release/mozc_renderer $out/lib/mozc/mozc_renderer
  '';
}
