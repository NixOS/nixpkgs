{ mkDerivation, lib, fetchurl, fetchgit, fetchpatch
, qtbase, qtquickcontrols, qtscript, qtdeclarative, qmake, llvmPackages_8
, withDocumentation ? false
}:

with lib;

let
  baseVersion = "4.9";
  revision = "1";

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
  version = "${baseVersion}.${revision}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "10ddp1365rf0z4bs7yzc9hajisp3j6mzjshyd0vpi4ki126j5f3r";
  };

  buildInputs = [ qtbase qtscript qtquickcontrols qtdeclarative llvmPackages_8.libclang clang_qt_vendor llvmPackages_8.llvm ];

  nativeBuildInputs = [ qmake ];

  # 0001-Fix-clang-libcpp-regexp.patch is for fixing regexp that is used to
  # find clang libc++ library include paths. By default it's not covering paths
  # like libc++-version, which is default name for libc++ folder in nixos.
  patches = [ ./0001-Fix-clang-libcpp-regexp.patch

    # Fix clazy plugin name. This plugin was renamed with clang8
    # release, and patch didn't make it into 4.9.1 release. Should be removed
    # on qtcreator update, if this problem is fixed.
    (fetchpatch {
      url = "https://code.qt.io/cgit/qt-creator/qt-creator.git/patch/src/plugins/clangcodemodel/clangeditordocumentprocessor.cpp?id=53c407bc0c87e0b65b537bf26836ddd8e00ead82";
      sha256 = "1lanp7jg0x8jffajb852q8p4r34facg41l410xsz6s1k91jskbi9";
    })

    (fetchpatch {
      url = "https://code.qt.io/cgit/qt-creator/qt-creator.git/patch/src/plugins/clangtools/clangtidyclazyrunner.cpp?id=53c407bc0c87e0b65b537bf26836ddd8e00ead82";
      sha256 = "1rl0rc2l297lpfhhawvkkmj77zb081hhp0bbi7nnykf3q9ch0clh";
    })
  ];

  doCheck = true;

  enableParallelBuilding = true;

  buildFlags = optional withDocumentation "docs";

  installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  preConfigure = ''
    substituteInPlace src/plugins/plugins.pro \
      --replace '$$[QT_INSTALL_QML]/QtQuick/Controls' '${qtquickcontrols}/${qtbase.qtQmlPrefix}/QtQuick/Controls'

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
      --replace 'LIBCLANG_LIBS += $${CLANG_LIB}' 'LIBCLANG_LIBS += -lclang'
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
