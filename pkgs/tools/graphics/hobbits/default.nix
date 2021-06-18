{ stdenv, mkDerivation, fetchFromGitHub, makeDesktopItem, qmake, python3
, withAutocorrelation ? true, fftw, pkgconfig  }:

mkDerivation rec {
  pname = "hobbits";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "Mahlet-Inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mf12380i6d54vbfh7fcms1lz5nmrlm9k4nf83zwmbz77gvazv3c";
  };

  sourceRoot = "source/src";

  desktopItem = makeDesktopItem {
    name = "hobbits";
    exec = "hobbits";
    icon = "hobbits";
    desktopName = "Hobbits GUI";
  };

  buildInputs = stdenv.lib.optional withAutocorrelation fftw;
  nativeBuildInputs = [ qmake ] ++ stdenv.lib.optional withAutocorrelation pkgconfig;

  qmakeFlags = [
    ''DEFINES+=HOBBITS_GUI_VERSION=\"\\\"${version}\\\"\"''
    ''DEFINES+=HOBBITS_CORE_LIB_VERSION=\"\\\"${version}\\\"\"''
    ''DEFINES+=HOBBITS_RUNNER_VERSION=\"\\\"${version}\\\"\"''
  ];

  postPatch = ''
    substituteInPlace hobbits-core/settingsdata.cpp \
      --replace "../hobbits-plugins:../plugins:plugins" "$out/share/hobbits/plugins"

    substituteInPlace hobbits-plugins/operators/PythonRunner/pythonrunner.cpp \
      --replace "python3" "${python3.out}/bin/python"

    substituteInPlace hobbits-runner/hobbits-runner.pro \
      --replace /opt/\$\$\{TARGET\} $out

    for p in $(find hobbits-plugins -type f -name "*.pro"); do
      substituteInPlace $p \
        --replace \$\$\(HOME\)/.local $out \
        --replace /opt $out/share \
        --replace "target.path = target.path" "target.path"
    done

    # Fix wrong install path
    for p in $(find hobbits-plugins/importerexporters -type f -name "*.pro"); do
      substituteInPlace $p \
        --replace plugins/analyzers plugins/importerexporters
    done
  '';

  postInstall = ''
    install -Dm755 hobbits-gui/hobbits $out/bin
    install -Dm644 hobbits-core/libhobbits-core.so* -t $out/lib
    install -Dm644 ${desktopItem}/share/applications/* -t $out/share/applications
    install -Dm644 hobbits-gui/images/icons/HobbitsRingSmall.png $out/share/pixmaps/hobbits.png
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Mahlet-Inc/hobbits";
    description = "A multi-platform GUI for bit-based analysis, processing, and visualization";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux;
  };
}
