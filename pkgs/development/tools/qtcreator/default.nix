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

stdenv.mkDerivation (finalAttrs: {
  pname = "qtcreator";
  version = "17.0.2";

  src = fetchurl {
    url = "mirror://qt/official_releases/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.version}/qt-creator-opensource-src-${finalAttrs.version}.tar.xz";
    hash = "sha256-sOEY+fuJvnF2KLP5JRwpX6bfQfqLfYEhbi6tg1XlWhM=";
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

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    # workaround for missing CMAKE_INSTALL_DATAROOTDIR
    # in pkgs/development/tools/build-managers/cmake/setup-hook.sh
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
    # qtdeclarative in nixpkgs does not provide qmlsc
    # fix can't find Qt6QmlCompilerPlusPrivate
    (lib.cmakeBool "QT_NO_FIND_QMLSC" true)
    (lib.cmakeBool "WITH_DOCS" true)
    (lib.cmakeBool "BUILD_DEVELOPER_DOCS" true)
    (lib.cmakeBool "BUILD_QBS" false)
    (lib.cmakeBool "QTC_CLANG_BUILDMODE_MATCH" true)
    (lib.cmakeBool "CLANGTOOLING_LINK_CLANG_DYLIB" true)
  ];

  qtWrapperArgs = [
    "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin"
  ];

  postInstall = ''
    # Small hack to set-up right prefix in cmake modules for header files
    cmake . $cmakeFlags -DCMAKE_INSTALL_PREFIX="''${!outputDev}"

    cmake --install . --prefix "''${!outputDev}" --component Devel
  '';

  # Remove prefix from the QtC config to make sane output path for 3rd-party plug-ins.
  postFixup = ''
    substituteInPlace ''${!outputDev}/lib/cmake/QtCreator/QtCreatorConfig.cmake --replace "$out/" ""
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Qt_Creator";
    license = lib.licenses.gpl3Only; # annotated with The Qt Company GPL Exception 1.0
    maintainers = with lib.maintainers; [
      wineee
      zatm8
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qtcreator";
  };
})
