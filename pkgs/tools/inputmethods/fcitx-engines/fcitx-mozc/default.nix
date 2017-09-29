{ clangStdenv, fetchFromGitHub, fetchurl, fetchpatch, gyp, which, ninja,
  python, pkgconfig, protobuf, gtk2, zinnia, qt5, libxcb, tegaki-zinnia-japanese,
  fcitx, gettext }:
let
  japanese_usage_dictionary = fetchFromGitHub {
    owner  = "hiroyuki-komatsu";
    repo   = "japanese-usage-dictionary";
    rev    = "e5b3425575734c323e1d947009dd74709437b684";
    sha256 = "0pyrpz9c8nxccwpgyr36w314mi8h132cis8ijvlqmmhqxwsi30hm";
  };
  icons = fetchurl {
    url    = "http://download.fcitx-im.org/fcitx-mozc/fcitx-mozc-icon.tar.gz";
    sha256 = "10bdjn481jsh32vll7r756l392anz44h6207vjqwby3rplk31np1";
  };
in clangStdenv.mkDerivation rec {
  name    = "fcitx-mozc-${version}";
  version = "2.20.2673.102";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "mozc";
    rev    = "280e38fe3d9db4df52f0713acf2ca65898cd697a";
    sha256 = "0s599f817gjgqynm4n1yll1ipd25ai2c55y8k6wvhg9s7qaxnyhs";
  };

  nativeBuildInputs = [ gyp which ninja python pkgconfig ];
  buildInputs = [ protobuf gtk2 zinnia qt5.qtbase libxcb fcitx gettext ];

  postUnpack = ''
    rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
    tar -xzf ${icons} -C $sourceRoot/src
  '';

  patch_version = "2.18.2612.102.1";
  patches = [ 
    (fetchpatch rec {
      name   = "fcitx-mozc-${patch_version}.patch";
      url    = "https://download.fcitx-im.org/fcitx-mozc/${name}";
      sha256 = "1f9m4310kz09v5qvnv75ka2vq63m7by023qrkpddgq4dv7gxx3ca";
     })
  ];

  postPatch = ''
    substituteInPlace src/unix/fcitx/mozc.conf \
      --replace "/usr/share/fcitx/mozc/icon/mozc.png" "mozc" 
  '';

  configurePhase = ''
    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1"
    cd src && python build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc
  '';

  buildPhase = ''
    PYTHONPATH="$PWD:$PYTHONPATH" python build_mozc.py build -c Release \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      unix/fcitx/fcitx.gyp:fcitx-mozc
  '';

  installPhase = ''
    install -d        $out/share/licenses/fcitx-mozc
    head -n 29 server/mozc_server.cc > $out/share/licenses/fcitx-mozc/LICENSE
    install -m 644    data/installer/*.html             $out/share/licenses/fcitx-mozc/

    install -d        $out/share/doc/mozc
    install -m    644 data/installer/*.html             $out/share/doc/mozc/

    install -D -m 755 out_linux/Release/mozc_server     $out/lib/mozc/mozc_server
    install    -m 755 out_linux/Release/mozc_tool       $out/lib/mozc/mozc_tool

    install -D -m 755 out_linux/Release/fcitx-mozc.so   $out/lib/fcitx/fcitx-mozc.so
    install -D -m 644 unix/fcitx/fcitx-mozc.conf        $out/share/fcitx/addon/fcitx-mozc.conf
    install -D -m 644 unix/fcitx/mozc.conf              $out/share/fcitx/inputmethod/mozc.conf

    install -d        $out/share/doc/mozc

    for mofile in out_linux/Release/gen/unix/fcitx/po/*.mo
    do
      filename=`basename $mofile`
      lang=$filename.mo
      install -D -m 644 "$mofile" "$out/share/locale/$lang/LC_MESSAGES/fcitx-mozc.mo"
    done

    install -d        $out/share/fcitx/imicon
    install    -m 644 fcitx-mozc-icons/mozc.png      $out/share/fcitx/imicon/mozc.png
    install -d        $out/share/fcitx/mozc/icon
    install    -m 644 fcitx-mozc-icons/*.png                 $out/share/fcitx/mozc/icon/
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
