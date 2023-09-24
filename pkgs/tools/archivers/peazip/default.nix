{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, fpc
, lazarus
, xorg
, libqt5pas
, _7zz
, archiver
, brotli
, upx
, zpaq
, zstd
}:

stdenv.mkDerivation rec {
  pname = "peazip";
  version = "9.9.0";

  src = fetchFromGitHub {
    owner = "peazip";
    repo = pname;
    rev = version;
    hash = "sha256-1UavigwVp/Gna2BOUECQrn/VQjov8wDw5EdPWX3mpvM=";
  };
  sourceRoot = "${src.name}/peazip-sources";

  nativeBuildInputs = [
    wrapQtAppsHook
    lazarus
    fpc
  ];

  buildInputs = [
    xorg.libX11
    libqt5pas
  ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    export HOME=$(mktemp -d)
    cd dev
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt5 --build-all project_pea.lpi && [ -f pea ]
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt5 --build-all project_peach.lpi && [ -f peazip ]
    cd ..
  '';

  installPhase = ''
    runHook preInstall

    # Executables
    ## Main programs
    install -D dev/{pea,peazip} -t $out/lib/peazip
    mkdir -p $out/bin
    ln -s $out/lib/peazip/{pea,peazip} $out/bin/

    ## Symlink the available compression algorithm programs.
    mkdir -p $out/lib/peazip/res/bin/7z
    ln -s ${_7zz}/bin/7zz $out/lib/peazip/res/bin/7z/7z
    mkdir -p $out/lib/peazip/res/bin/arc
    ln -s ${archiver}/bin/arc $out/lib/peazip/res/bin/arc/
    mkdir -p $out/lib/peazip/res/bin/brotli
    ln -s ${brotli}/bin/brotli $out/lib/peazip/res/bin/brotli/
    mkdir -p $out/lib/peazip/res/bin/upx
    ln -s ${upx}/bin/upx $out/lib/peazip/res/bin/upx/
    mkdir -p $out/lib/peazip/res/bin/zpaq
    ln -s ${zpaq}/bin/zpaq $out/lib/peazip/res/bin/zpaq/
    mkdir -p $out/lib/peazip/res/bin/zstd
    ln -s ${zstd}/bin/zstd $out/lib/peazip/res/bin/zstd/

    mkdir -p $out/share/peazip
    ln -s $out/share/peazip $out/lib/peazip/res/share
    cp -r res/share/{icons,lang,themes,presets} $out/share/peazip/
    install -D res/share/batch/freedesktop_integration/peazip.png -t "$out/share/icons/hicolor/256x256/apps"
    install -D res/share/icons/peazip_{7z,rar,zip}.png -t "$out/share/icons/hicolor/256x256/mimetypes"
    install -D res/share/batch/freedesktop_integration/peazip_{add,extract}.png -t "$out/share/icons/hicolor/256x256/actions"
    install -D res/share/batch/freedesktop_integration/*.desktop -t "$out/share/applications"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform file and archive manager";
    longDescription = ''
      Free Zip / Unzip software and Rar file extractor. Cross-platform file and archive manager.

      Features volume spanning, compression, authenticated encryption.

      Supports 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard.
    '';
    license = licenses.gpl3Only;
    homepage = "https://peazip.github.io";
    platforms = platforms.linux;
    maintainers = with maintainers; [ annaaurora ];
  };
}
