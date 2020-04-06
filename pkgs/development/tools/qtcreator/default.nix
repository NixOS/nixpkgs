{ mkDerivation, lib, fetchurl, fetchgit, fetchpatch
, qtbase, qtquickcontrols, qtscript, qtdeclarative, qmake, llvmPackages_8
, withDocumentation ? false, withClangPlugins ? true 
}:

with lib;

let
  # Fetch clang from qt vendor, this contains submodules like this:
  # clang<-clang-tools-extra<-clazy.
  clang_qt_vendor = llvmPackages_8.clang-unwrapped.overrideAttrs (oldAttrs: {
    src = fetchgit {
      url = "https://code.qt.io/clang/clang.git";
      rev = "c12b012bb7465299490cf93c2ae90499a5c417d5";
      sha256 = "0mgmnazgr19hnd03xcrv7d932j6dpz88nhhx008b0lv4bah9mqm0";
    };
    unpackPhase = "";
  });
in

mkDerivation rec {
  pname = "qtcreator";
  version = "4.11.0";
  baseVersion = builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version));

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "0ibn7bapw7m26nmxl26dns1hnpawfdqk1i1mgg0gjssja8famszg";
  };

  buildInputs = [ qtbase qtscript qtquickcontrols qtdeclarative ] ++ 
    optionals withClangPlugins [ llvmPackages_8.libclang 
                                 clang_qt_vendor 
                                 llvmPackages_8.llvm ];

  nativeBuildInputs = [ qmake ];

  # 0001-Fix-clang-libcpp-regexp.patch is for fixing regexp that is used to
  # find clang libc++ library include paths. By default it's not covering paths
  # like libc++-version, which is default name for libc++ folder in nixos.
  # ./0002-Dont-remove-clang-header-paths.patch is for forcing qtcreator to not 
  # remove system clang include paths.
  patches = [ ./0001-Fix-clang-libcpp-regexp.patch
              ./0002-Dont-remove-clang-header-paths.patch ];

  doCheck = true;

  enableParallelBuilding = true;

  buildFlags = optional withDocumentation "docs";

  installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  preConfigure = ''
    substituteInPlace src/plugins/plugins.pro \
      --replace '$$[QT_INSTALL_QML]/QtQuick/Controls' '${qtquickcontrols}/${qtbase.qtQmlPrefix}/QtQuick/Controls' 
    '' + optionalString withClangPlugins ''
    # Fix paths for llvm/clang includes directories.
    substituteInPlace src/shared/clang/clang_defines.pri \
      --replace '$$clean_path($${LLVM_LIBDIR}/clang/$${LLVM_VERSION}/include)' '${clang_qt_vendor}/lib/clang/8.0.0/include' \
      --replace '$$clean_path($${LLVM_BINDIR})' '${clang_qt_vendor}/bin'

    # Fix include path to find clang and clang-c include directories.
    substituteInPlace src/plugins/clangtools/clangtools.pro \
      --replace 'INCLUDEPATH += $$LLVM_INCLUDEPATH' 'INCLUDEPATH += $$LLVM_INCLUDEPATH ${clang_qt_vendor}'

    # Fix paths to libclang library.
    substituteInPlace src/shared/clang/clang_installation.pri \
      --replace 'LIBCLANG_LIBS = -L$${LLVM_LIBDIR}' 'LIBCLANG_LIBS = -L${llvmPackages_8.libclang}/lib' \
      --replace 'LIBCLANG_LIBS += $${CLANG_LIB}' 'LIBCLANG_LIBS += -lclang' \
      --replace 'LIBTOOLING_LIBS = -L$${LLVM_LIBDIR}' 'LIBTOOLING_LIBS = -L${clang_qt_vendor}/lib' \
      --replace 'LLVM_CXXFLAGS ~= s,-gsplit-dwarf,' '${lib.concatStringsSep "\n" ["LLVM_CXXFLAGS ~= s,-gsplit-dwarf," "    LLVM_CXXFLAGS += -fno-rtti"]}'
  '';

  preBuild = optional withDocumentation ''
    ln -s ${getLib qtbase}/$qtDocPrefix $NIX_QT5_TMP/share
  '';

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
    homepage = https://wiki.qt.io/Category:Tools::QtCreator;
    license = "LGPL";
    maintainers = [ maintainers.akaWolf ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
