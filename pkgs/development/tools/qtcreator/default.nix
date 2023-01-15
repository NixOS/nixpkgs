/*
  FIXME

  -- The following packages have not been found:

  * Qt6QmlCompilerPlusPrivate
  * litehtml
  * Qt6WebEngineWidgets
  * LibRustcDemangle, Demangling for Rust symbols, written in Rust., <https://github.com/alexcrichton/rustc-demangle>
    Demangling of Rust symbols

  -- The following features have been disabled:

  * Build documentation
  * Build online documentation
  * Build tests
  * Build with sanitize, SANITIZE_FLAGS=''
  * Build with Crashpad
  * Library Nanotrace
  * Build Qbs
  * Native WebKit help viewer, with CONDITION FWWebKit AND FWAppKit AND Qt5_VERSION VERSION_LESS 6.0.0
  * QtWebEngine help viewer, with CONDITION BUILD_HELPVIEWERBACKEND_QTWEBENGINE AND TARGET Qt5::WebEngineWidgets
  * multilanguage-support in qml2puppet, with CONDITION TARGET QtCreator::multilanguage-support
  * Include developer documentation
*/

{ stdenv, lib, fetchurl, fetchgit, fetchpatch
, cmake, qtbase, qt5compat, qtdeclarative, qtquick3d, qtquicktimeline
, qtserialport, qtsvg, qttools, wrapQtAppsHook
#, qtwebengine
, llvmPackages, elfutils, rustc-demangle, perf, pkg-config
, withDocumentation ? false, withClangPlugins ? true
}:

with lib;

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "9.0.1";
  baseVersion = builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version));
  src = fetchurl {
    url = "https://download.qt.io/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "sha256-4e4e881b2635bac07e785c9e889ab9a253ad47a00074e260cbccdb3c0aef189f";
  };

  buildInputs = [
      qtbase qt5compat
      #qtdeclarative qtquick3d qtquicktimeline qtserialport
      #qtsvg qttools elfutils.dev rustc-demangle
      #qtwebengine
    ] ++
    optionals withClangPlugins [
      /*
      llvmPackages.libclang
      llvmPackages.clang-unwrapped
      llvmPackages.llvm
      */
    ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  doCheck = true;

  postPatch = ''
    stat src/libs/extensionsystem/pluginmanager.cpp
    cp ${./src/qt-creator-opensource-src-8.0.1/src/libs/extensionsystem/pluginmanager.cpp} src/libs/extensionsystem/pluginmanager.cpp
    cp ${./src/qt-creator-opensource-src-8.0.1/src/plugins/welcome/welcomeplugin.cpp} src/plugins/welcome/welcomeplugin.cpp
  '';

  #buildFlags = optional withDocumentation "docs";

  cmakeBuildType = "Debug";

  #installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  #qtWrapperArgs = [ "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin" ];

  postInstall = ''
    substituteInPlace $out/share/applications/org.qt-project.qtcreator.desktop \
      --replace "Exec=qtcreator" "Exec=$out/bin/qtcreator"
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Qt_Creator";
    license = "LGPL";
    maintainers = [ maintainers.akaWolf ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
