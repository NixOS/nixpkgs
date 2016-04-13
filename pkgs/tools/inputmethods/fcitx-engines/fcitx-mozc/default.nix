{ clangStdenv, fetchFromGitHub, fetchurl, fetchpatch, fetchsvn, gyp, which, ninja, 
  python, pkgconfig, protobuf, gtk, zinnia, qt4, libxcb, tegaki-zinnia-japanese,
  fcitx, gettext }:
let
  japanese_usage_dictionary = fetchsvn {
    url    = "http://japanese-usage-dictionary.googlecode.com/svn/trunk";
    rev    = "10";
    sha256 = "0pyrpz9c8nxccwpgyr36w314mi8h132cis8ijvlqmmhqxwsi30hm";
  };
  icons = fetchurl {
    url    = "http://download.fcitx-im.org/fcitx-mozc/fcitx-mozc-icon.tar.gz";
    sha256 = "10bdjn481jsh32vll7r756l392anz44h6207vjqwby3rplk31np1";
  };
in clangStdenv.mkDerivation rec {
  name    = "fcitx-mozc-${version}";
  version = "2.17.2313.102";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "mozc";
    rev    = "3306d3314499a54a4064b8b80bbc1bce3f6cfac4";
    sha256 = "0l7mjlnbm6i1ipni8pg9ym5bjg3rzkaxi9xwmsz2lddv348sqii2";
  };

  nativeBuildInputs = [ gyp which ninja python pkgconfig ];
  buildInputs = [ protobuf gtk zinnia qt4 libxcb fcitx gettext ];

  postUnpack = ''
    rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
    tar -xzf ${icons} -C $sourceRoot
  '';

  patch_version = "2.17.2313.102.1";
  patches = [ 
    (fetchpatch rec {
      name   = "fcitx-mozc-${patch_version}.patch";
      url    = "https://download.fcitx-im.org/fcitx-mozc/${name}";
      sha256 = "172c34jkppibvwr9qf9xwgh2hdrmmhyx7nsdj49krxbfdlsy3yy0";
     })
  ];

  postPatch = ''
    substituteInPlace src/unix/fcitx/mozc.conf \
      --replace "/usr/share/fcitx/mozc/icon/mozc.png" "mozc" 
  '';

  configurePhase = ''
    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1"
    python src/build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc \
    python src/unix/fcitx/fcitx.gyp gyp --gypdir=${gyp}/bin
  '';

  preBuildPhase = ''
    head -n 29 src/server/mozc_server.cc > LICENSE
  '';

  buildPhase = ''
    python src/build_mozc.py build -c Release \
      unix/fcitx/fcitx.gyp:fcitx-mozc \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool
  '';

  checkPhase = ''
    python src/build_mozc.py runtests -c Release
  '';

  installPhase = ''
    install -d        $out/share/licenses/fcitx-mozc/
    install -m 644    LICENSE src/data/installer/*.html     $out/share/licenses/fcitx-mozc/

    install -d        $out/share/doc/mozc
    install -m    644 src/data/installer/*.html             $out/share/doc/mozc/

    install -D -m 755 src/out_linux/Release/mozc_server     $out/lib/mozc/mozc_server
    install    -m 755 src/out_linux/Release/mozc_tool       $out/lib/mozc/mozc_tool

    install -D -m 755 src/out_linux/Release/fcitx-mozc.so   $out/lib/fcitx/fcitx-mozc.so
    install -D -m 644 src/unix/fcitx/fcitx-mozc.conf        $out/share/fcitx/addon/fcitx-mozc.conf
    install -D -m 644 src/unix/fcitx/mozc.conf              $out/share/fcitx/inputmethod/mozc.conf

    install -d        $out/share/doc/mozc

    for mofile in src/out_linux/Release/gen/unix/fcitx/po/*.mo
    do
      filename=`basename $mofile`
      lang=$filename.mo
      install -D -m 644 "$mofile" "$out/share/locale/$lang/LC_MESSAGES/fcitx-mozc.mo"
    done

    install -d        $out/share/fcitx/imicon
    install    -m 644 fcitx-mozc-icons/mozc.png                 $out/share/fcitx/imicon/mozc.png
    install -d        $out/share/fcitx/mozc/icon
    install    -m 644 fcitx-mozc-icons/mozc.png                 $out/share/fcitx/mozc/icon/mozc.png
    install    -m 644 fcitx-mozc-icons/mozc-alpha_full.png      $out/share/fcitx/mozc/icon/mozc-alpha_full.png
    install    -m 644 fcitx-mozc-icons/mozc-alpha_half.png      $out/share/fcitx/mozc/icon/mozc-alpha_half.png
    install    -m 644 fcitx-mozc-icons/mozc-direct.png          $out/share/fcitx/mozc/icon/mozc-direct.png
    install    -m 644 fcitx-mozc-icons/mozc-hiragana.png        $out/share/fcitx/mozc/icon/mozc-hiragana.png
    install    -m 644 fcitx-mozc-icons/mozc-katakana_full.png   $out/share/fcitx/mozc/icon/mozc-katakana_full.png
    install    -m 644 fcitx-mozc-icons/mozc-katakana_half.png   $out/share/fcitx/mozc/icon/mozc-katakana_half.png
    install    -m 644 fcitx-mozc-icons/mozc-dictionary.png      $out/share/fcitx/mozc/icon/mozc-dictionary.png
    install    -m 644 fcitx-mozc-icons/mozc-properties.png      $out/share/fcitx/mozc/icon/mozc-properties.png
    install    -m 644 fcitx-mozc-icons/mozc-tool.png            $out/share/fcitx/mozc/icon/mozc-tool.png
  '';

  meta = with clangStdenv.lib; {
    isFcitxEngine = true;
    description   = "Fcitx engine for Google japanese input method";
    homepage      = http://code.google.com/p/mozc/;
    downloadPage  = "http://download.fcitx-im.org/fcitx-mozc/";
    license       = licenses.free;
    platforms     = platforms.linux;
    maintainers   = [ maintainers.ericsagnes ];
  };

}
