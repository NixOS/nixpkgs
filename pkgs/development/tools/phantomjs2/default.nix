{ stdenv, fetchgit,
  bison2, flex, fontconfig, freetype, gperf, icu, openssl, libjpeg, libpng, perl, python, ruby, sqlite,
  darwin, writeScriptBin, cups
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

  # needs git submodules, so can't use fetchFromGitHub
  src = fetchgit {
    rev = "refs/tags/${version}";
    url = "https://github.com/ariya/phantomjs.git";
    sha256 = "1gyc8qxn8v4vm4lgd9njrprz46fg1j5ziq0mm888q8ms0p7jy2pi";
  };

  buildInputs = [ bison2 flex fontconfig freetype gperf icu openssl libjpeg libpng perl python ruby sqlite ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AGL ApplicationServices AppKit Cocoa OpenGL
      darwin.libobjc fakeClang cups
    ]);


  patchPhase = ''
    patchShebangs .
    sed -i -e 's|/bin/pwd|pwd|' src/qt/qtbase/configure
    touch src/qt/{qtbase,qtwebkit,3rdparty}/.git
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's,-licucore,/usr/lib/libicucore.dylib,' src/qt/qtwebkit/Source/WTF/WTF.pri
    substituteInPlace src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.pri \
      --replace "ENABLE_3D_RENDERING=1" "ENABLE_3D_RENDERING=0"
    sed -i 88d src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.prf
    echo 'CONFIG -= create_cmake' >> src/qt/qtwebkit/Source/api.pri
    echo 'CONFIG -= create_cmake' >> src/qt/qtwebkit/Source/widgetsapi.pri
    pushd src/qt

      substituteInPlace qtbase/configure \
        --replace /usr/bin/xcode-select true \
        --replace '/usr/bin/xcodebuild -sdk $sdk -version Path 2>/dev/null' 'echo /var/empty' \
        --replace '/usr/bin/xcrun -sdk $sdk -find' 'type -P'
      substituteInPlace qtbase/mkspecs/features/mac/default_pre.prf \
        --replace '/usr/bin/xcode-select --print-path 2>/dev/null' "echo ${stdenv.libc}" \
        --replace '/usr/bin/xcrun -find xcrun 2>/dev/null' 'echo success' \
        --replace '/usr/bin/xcodebuild -version' 'echo Xcode 7.2; echo Build version 7C68' \
        --replace 'sdk rez' ""
      for file in $(grep -rl /usr/bin/xcrun .); do
        substituteInPlace "$file" --replace "/usr/bin/xcrun" ${fakeXcrun}/bin/xcrun
      done
      substituteInPlace qtbase/src/tools/qlalr/lalr.cpp --replace _Nullable Nullable

    popd
  '';

  __impureHostDeps = stdenv.lib.optional stdenv.isDarwin "/usr/lib/libicucore.dylib";

  buildPhase = "./build.py --confirm -j$NIX_BUILD_CORES";

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
