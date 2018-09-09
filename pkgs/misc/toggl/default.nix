{ qtbase, poco, fetchFromGitHub, stdenv, makeQtWrapper, perl, readline,
  qtx11extras, qtwebkit, qmakeHook ,uncrustify, libXScrnSaver, scrnsaverproto }:
stdenv.mkDerivation {
  name = "toggl";
  buildInputs = [qtbase poco perl readline qtwebkit qtx11extras uncrustify libXScrnSaver scrnsaverproto];
  nativeBuiltInputs = [makeQtWrapper];
  src = fetchFromGitHub {
    repo = "toggldesktop";
    owner = "toggl";
    sha256="0x9iivb6ixvb4rc5h22pyqvgh3jy7114pijp87n8yyw209ahz690";
    rev="v7.4.45";
  };
  enableParallelBuilding=true;
  installFlags=["INSTALL_ROOT=$(out)"];
  qmakeFlags=["PREFIX=/"];
  prePatch = ''
    sed -i 's@/usr/local/bin/@@' ./third_party/Xcode-formatter/CodeFormatter/scripts/formatAllSources.sh
  '';
  preBuild = ''
    command -v perl
    export POCO_ODBC_LIB=${poco}/lib
    make deps
  '';
  postFixup=''
    wrapQtProgram $out/bin/*
  '';
  installPhase = ''
    # copied some parts from src/ui/linux/package.sh

    mkdir -p $out/bin $out/lib $out/platforms $out/imageformats $out/iconengines
    cp src/ui/linux/README $out/
    cp third_party/bugsnag-qt/build/release/libbugsnag-qt.so.1 $out/lib

    cp third_party/poco/lib/Linux/x86_64/libPocoCrypto.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoData.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoDataSQLite.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoFoundation.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoJSON.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoNet.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoNetSSL.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoUtil.so.31 $out/lib
    cp third_party/poco/lib/Linux/x86_64/libPocoXML.so.31 $out/lib

    cp src/ui/linux/TogglDesktop/build/release/TogglDesktop $out/bin/

    cp src/ui/linux/TogglDesktop.sh $out/bin
    
    cp third_party/openssl/libssl.so.1.0.0 $out/lib/
    cp third_party/openssl/libcrypto.so.1.0.0 $out/lib/
  '';
}
