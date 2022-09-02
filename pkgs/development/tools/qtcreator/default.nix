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
, llvmPackages, elfutils, perf, pkg-config
, withDocumentation ? false, withClangPlugins ? true
}:

with lib;

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "8.0.1";
  baseVersion = builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version));
  src = fetchurl {
    url = "https://download.qt.io/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "sha256-4s4gCnnHTc1jZ9y7g8g5wcILLMB31qZYY56s3opKuGU=";
  };

  buildInputs = [
      qtbase qt5compat qtdeclarative qtquick3d qtquicktimeline qtserialport
      qtsvg qttools elfutils.dev
      #qtwebengine
    ] ++
    optionals withClangPlugins [
      llvmPackages.libclang
      llvmPackages.clang-unwrapped
      llvmPackages.llvm
    ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  doCheck = true;

  buildFlags = optional withDocumentation "docs";

  installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  qtWrapperArgs = [ "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin" ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp share/applications/org.qt-project.qtcreator.desktop $out/share/applications
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
