{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  ninja,
  python3,
  qtbase,
  qt5compat,
  qtdeclarative,
  qtdoc,
  qtquick3d,
  qtquicktimeline,
  qtserialport,
  qtsvg,
  qttools,
  qtwebengine,
  qtwayland,
  qtshadertools,
  wrapQtAppsHook,
  yaml-cpp,
  litehtml,
  libsecret,
  gumbo,
  llvmPackages,
  rustc-demangle,
  elfutils,
  perf,
}:

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "15.0.0";

  src = fetchurl {
    url = "mirror://qt/official_releases/${pname}/${lib.versions.majorMinor version}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    hash = "sha256-I7HGtHjKdgmX7N3Uxyjw2igLBpYAipvd2aEGjxbUj3I=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    (qttools.override { withClang = true; })
    wrapQtAppsHook
    python3
    ninja
  ];

  buildInputs = [
    qtbase
    qtdoc
    qtsvg
    qtquick3d
    qtwebengine
    qtwayland
    qtserialport
    qtshadertools
    qt5compat
    qtdeclarative
    qtquicktimeline
    yaml-cpp
    litehtml
    libsecret
    gumbo
    llvmPackages.libclang
    llvmPackages.llvm
    rustc-demangle
    elfutils
  ];

  cmakeFlags = [
    # workaround for missing CMAKE_INSTALL_DATAROOTDIR
    # in pkgs/development/tools/build-managers/cmake/setup-hook.sh
    "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"
    # qtdeclarative in nixpkgs does not provide qmlsc
    # fix can't find Qt6QmlCompilerPlusPrivate
    "-DQT_NO_FIND_QMLSC=TRUE"
    "-DWITH_DOCS=ON"
    "-DBUILD_DEVELOPER_DOCS=ON"
    "-DBUILD_QBS=OFF"
    "-DQTC_CLANG_BUILDMODE_MATCH=ON"
    "-DCLANGTOOLING_LINK_CLANG_DYLIB=ON"
  ];

  qtWrapperArgs = [
    "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin"
  ];

  meta = with lib; {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Qt_Creator";
    license = licenses.gpl3Only; # annotated with The Qt Company GPL Exception 1.0
    maintainers = [ maintainers.rewine ];
    platforms = platforms.linux;
  };
}
