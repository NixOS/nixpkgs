{ stdenv, fetchurl, cmake, qmakeHook, makeQtWrapper, qtbase, perl, python, php }:

stdenv.mkDerivation rec {
  name = "qcachegrind-${version}";
  version = "16.12.3";

  src = fetchurl {
    url = "http://download.kde.org/stable/applications/${version}/src/kcachegrind-${version}.tar.xz";
    sha256 = "109y94nz96izzsjjdpj9c6g344rcr86srp5w0433mssbyvym4x7q";
  };

  buildInputs = [ qtbase perl python php ];

  nativeBuildInputs = [ qmakeHook makeQtWrapper ];

  postInstall = ''
     mkdir -p $out/bin
     cp -p converters/dprof2calltree $out/bin/dprof2calltree
     cp -p converters/hotshot2calltree.cmake $out/bin/hotshot2calltree
     cp -p converters/memprof2calltree $out/bin/memprof2calltree
     cp -p converters/op2calltree $out/bin/op2calltree
     cp -p converters/pprof2calltree $out/bin/pprof2calltree
     chmod -R +x $out/bin/
  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp cgview/cgview.app/Contents/MacOS/cgview $out/bin
    cp -a qcachegrind/qcachegrind.app $out/Applications
    wrapQtProgram $out/Applications/qcachegrind.app/Contents/MacOS/qcachegrind
  '' else ''
    install qcachegrind/qcachegrind cgview/cgview -t "$out/bin"
    wrapQtProgram "$out/bin/qcachegrind"
    install -Dm644 qcachegrind/qcachegrind.desktop -t "$out/share/applications"
    install -Dm644 kcachegrind/hi32-app-kcachegrind.png "$out/share/icons/hicolor/32x32/apps/kcachegrind.png"
    install -Dm644 kcachegrind/hi48-app-kcachegrind.png "$out/share/icons/hicolor/48x48/apps/kcachegrind.png"
  '');

  meta = with stdenv.lib; {
    description = "A Qt GUI to visualize profiling data";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ periklis ];
  };
}
