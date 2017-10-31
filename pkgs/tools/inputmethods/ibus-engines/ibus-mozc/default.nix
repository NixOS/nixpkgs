{ clangStdenv, fetchFromGitHub, which, ninja, python, gyp, pkgconfig, protobuf
, ibus, gtk2, zinnia, qt5, libxcb, tegaki-zinnia-japanese }:

let
  japanese_usage_dictionary = fetchFromGitHub {
    owner  = "hiroyuki-komatsu";
    repo   = "japanese-usage-dictionary";
    rev    = "e5b3425575734c323e1d947009dd74709437b684";
    sha256 = "0pyrpz9c8nxccwpgyr36w314mi8h132cis8ijvlqmmhqxwsi30hm";
  };
in clangStdenv.mkDerivation rec {
  name = "ibus-mozc-${version}";
  version = "2.20.2673.102";

  meta = with clangStdenv.lib; {
    isIbusEngine = true;
    description  = "Japanese input method from Google";
    homepage     = http://code.google.com/p/mozc/;
    license      = licenses.free;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ gebner ericsagnes ];
  };

  nativeBuildInputs = [ which ninja python gyp pkgconfig ];
  buildInputs = [ protobuf ibus gtk2 zinnia qt5.qtbase libxcb ];

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "mozc";
    rev    = "280e38fe3d9db4df52f0713acf2ca65898cd697a";
    sha256 = "0s599f817gjgqynm4n1yll1ipd25ai2c55y8k6wvhg9s7qaxnyhs";
  };

  postUnpack = ''
    rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
  '';

  configurePhase = ''
    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1 ibus_mozc_path=$out/lib/ibus-mozc/ibus-engine-mozc"
    cd src && python build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc
  '';

  buildPhase = ''
    PYTHONPATH="$PWD:$PYTHONPATH" python build_mozc.py build -c Release \
      unix/ibus/ibus.gyp:ibus_mozc \
      unix/emacs/emacs.gyp:mozc_emacs_helper \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      renderer/renderer.gyp:mozc_renderer
  '';

  installPhase = ''
    install -d        $out/share/licenses/mozc
    head -n 29 server/mozc_server.cc > $out/share/licenses/mozc/LICENSE
    install -m 644    data/installer/*.html     $out/share/licenses/mozc/

    install -D -m 755 out_linux/Release/mozc_server $out/lib/mozc/mozc_server
    install    -m 755 out_linux/Release/mozc_tool   $out/lib/mozc/mozc_tool

    install -d        $out/share/doc/mozc
    install -m 644    data/installer/*.html         $out/share/doc/mozc/

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
  '';
}
