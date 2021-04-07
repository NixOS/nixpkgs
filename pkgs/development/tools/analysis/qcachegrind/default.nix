{ lib, stdenv, qmake, qtbase, perl, python, php, kcachegrind }:

let
  name = lib.replaceStrings ["kcachegrind"] ["qcachegrind"] kcachegrind.name;

in stdenv.mkDerivation {
  inherit name;

  src = kcachegrind.src;

  buildInputs = [ qtbase perl python php ];

  nativeBuildInputs = [ qmake ];

  dontWrapQtApps = true;

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
  '' else ''
    install qcachegrind/qcachegrind cgview/cgview -t "$out/bin"
    install -Dm644 qcachegrind/qcachegrind.desktop -t "$out/share/applications"
    install -Dm644 kcachegrind/32-apps-kcachegrind.png "$out/share/icons/hicolor/32x32/apps/kcachegrind.png"
    install -Dm644 kcachegrind/48-apps-kcachegrind.png "$out/share/icons/hicolor/48x48/apps/kcachegrind.png"
  '');

  meta = with lib; {
    description = "A Qt GUI to visualize profiling data";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ periklis ];
  };
}
