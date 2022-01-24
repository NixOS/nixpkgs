{ lib, stdenv, fetchFromGitHub, fetchpatch
, bison, flex, fontconfig, freetype, gperf, icu, openssl, libjpeg
, libpng, perl, python2, ruby, sqlite, qtwebkit, qmake, qtbase
, darwin, writeScriptBin, cups, makeWrapper
}:

let
  fakeClang = writeScriptBin "clang" ''
    #!${stdenv.shell}
    if [[ "$@" == *.c ]]; then
      exec "${stdenv.cc}/bin/clang" "$@"
    else
      exec "${stdenv.cc}/bin/clang++" "$@"
    fi
  '';

in stdenv.mkDerivation rec {
  pname = "phantomjs";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ariya";
    repo = "phantomjs";
    rev = version;
    sha256 = "1zsbpk1sgh9a16f1a5nx3qvk77ibjn812wqkxqck8n6fia85m5iq";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    bison flex fontconfig freetype gperf icu openssl
    libjpeg libpng perl python2 ruby sqlite qtwebkit qtbase
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AGL ApplicationServices AppKit Cocoa OpenGL
    darwin.libobjc fakeClang cups
  ]);

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/build-hardening.patch";
      sha256 = "1qs1r76w90qgpw742i7lf0y3b7m9zh5wxcbrhrak6mq1kqaphqb5";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/build-qt-components.patch";
      sha256 = "1fw2q59aqcks3abvwkqg9903yif6aivdsznc0h6frhhjvpp19vsb";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/build-qt55-evaluateJavaScript.patch";
      sha256 = "1avig9cfny8kv3s4mf3mdzvf3xlzgyh351yzwc4bkpnjvzv4fmq6";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/build-qt55-no-websecurity.patch";
      sha256 = "1nykqpxa7lcf9iarz5lywgg3v3b1h19iwvjdg4kgq0ai6idhcab8";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/build-qt55-print.patch";
      sha256 = "1fydmdjxnplglpbd3ypaih5l237jkxjirpdhzz92mcpy29yla6jw";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/phantomjs/raw/0b20f0dd/debian/patches/unlock-qt.patch";
      sha256 = "13bwz4iw17d6hq5pwkbpcckqyw7fhc6648lvs26m39pp31zwyp03";
    })
    ./system-qtbase.patch
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace src/phantomjs.pro \
      --replace "QT_MINOR_VERSION, 5" "QT_MINOR_VERSION, 9"
  '';

  # Avoids error in webpage.cpp:80:89:
  # invalid suffix on literal; C++11 requires a space between litend identifier
  NIX_CFLAGS_COMPILE = "-Wno-reserved-user-defined-literal";

  __impureHostDeps = lib.optional stdenv.isDarwin "/usr/lib/libicucore.dylib";

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/doc/phantomjs
    cp -a bin $out
    cp -a ChangeLog examples LICENSE.BSD README.md third-party.txt $out/share/doc/phantomjs
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change \
        ${darwin.CF}/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation \
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation \
      -change \
        ${darwin.configd}/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration \
        /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration \
    $out/bin/phantomjs
  '' + ''
    wrapProgram $out/bin/phantomjs \
    --set QT_QPA_PLATFORM offscreen \
    --prefix PATH : ${lib.makeBinPath [ qtbase ]}
  '';

  meta = with lib; {
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

    homepage = "https://phantomjs.org/";
    license = licenses.bsd3;

    maintainers = [ maintainers.aflatter ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
