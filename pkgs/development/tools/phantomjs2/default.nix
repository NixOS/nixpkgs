{ stdenv, fetchFromGitHub, fetchpatch
, bison2, flex, fontconfig, freetype, gperf, icu, openssl, libjpeg
, libpng, perl, python, ruby, sqlite, qtwebkit, qmake, qtbase
, darwin, writeScriptBin, cups
}:

let
  fakeXcrun = writeScriptBin "xcrun" ''
    #!${stdenv.shell}
    echo >&2 "Fake xcrun: ''$@"
    args=()
    while (("$#")); do
      case "$1" in
        -sdk*) shift;;
        -find*) shift;;
        *) args+=("$1");;
      esac
      shift
    done

    if [ "''${#args[@]}" -gt "0" ]; then
      echo >&2 "Fake xcrun: ''${args[@]}"
      exec "''${args[@]}"
    fi
  '';
  fakeClang = writeScriptBin "clang" ''
    #!${stdenv.shell}
    if [[ "$@" == *.c ]]; then
      exec "${stdenv.cc}/bin/clang" "$@"
    else
      exec "${stdenv.cc}/bin/clang++" "$@"
    fi
  '';

in stdenv.mkDerivation rec {
  name = "phantomjs-${version}";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ariya";
    repo = "phantomjs";
    rev = version;
    sha256 = "1zsbpk1sgh9a16f1a5nx3qvk77ibjn812wqkxqck8n6fia85m5iq";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    bison2 flex fontconfig freetype gperf icu openssl
    libjpeg libpng perl python ruby sqlite qtwebkit qtbase
  ] ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AGL ApplicationServices AppKit Cocoa OpenGL
    darwin.libobjc fakeClang cups
  ]);

  patches = [
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/phantomjs.git/plain/debian/patches/build-hardening.patch?id=42c9154d8c87c9fe434908259b0eddde4d892ca3";
      sha256 = "1qs1r76w90qgpw742i7lf0y3b7m9zh5wxcbrhrak6mq1kqaphqb5";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/phantomjs.git/plain/debian/patches/build-qt-components.patch?id=9b5c1ce95a7044ebffc634f773edf7d4eb9b6cd3";
      sha256 = "1fw2q59aqcks3abvwkqg9903yif6aivdsznc0h6frhhjvpp19vsb";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/phantomjs.git/plain/debian/patches/build-qt55-evaluateJavaScript.patch?id=9b5c1ce95a7044ebffc634f773edf7d4eb9b6cd3";
      sha256 = "1avig9cfny8kv3s4mf3mdzvf3xlzgyh351yzwc4bkpnjvzv4fmq6";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/phantomjs.git/plain/debian/patches/build-qt55-no-websecurity.patch?id=9b5c1ce95a7044ebffc634f773edf7d4eb9b6cd3";
      sha256 = "1nykqpxa7lcf9iarz5lywgg3v3b1h19iwvjdg4kgq0ai6idhcab8";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/collab-maint/phantomjs.git/plain/debian/patches/build-qt55-print.patch?id=9b5c1ce95a7044ebffc634f773edf7d4eb9b6cd3";
      sha256 = "1fydmdjxnplglpbd3ypaih5l237jkxjirpdhzz92mcpy29yla6jw";
    })
    ./system-qtbase.patch
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace src/phantomjs.pro \
      --replace "QT_MINOR_VERSION, 5" "QT_MINOR_VERSION, 9"
  '';

  __impureHostDeps = stdenv.lib.optional stdenv.isDarwin "/usr/lib/libicucore.dylib";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/share/doc/phantomjs
    cp -a bin $out
    cp -a ChangeLog examples LICENSE.BSD README.md third-party.txt $out/share/doc/phantomjs
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change \
        ${darwin.CF}/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation \
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation \
      -change \
        ${darwin.configd}/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration \
        /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration \
    $out/bin/phantomjs
  '';

  preFixup = ''
    rm -r ../__nix_qt5__
  '';

  meta = with stdenv.lib; {
    description = "Headless WebKit with JavaScript API";
    longDescription = ''
      PhantomJS2 is a headless WebKit with JavaScript API.
      It has fast and native support for various web standards:
      DOM handling, CSS selector, JSON, Canvas, and SVG.

      PhantomJS is an optimal solution for:
      - Headless Website Testing
      - Screen Capture
      - Page Automation
      - Network Monitoring
    '';

    homepage = http://phantomjs.org/;
    license = licenses.bsd3;

    maintainers = [ maintainers.aflatter ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
