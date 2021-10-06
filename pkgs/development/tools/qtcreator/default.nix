{ mkDerivation
, lib
, fetchurl
, qtbase
, qtquickcontrols2
, qtscript
, qtdeclarative
, qtwebengine
, qtserialport
, qttools
, qmake
, cmake
, clang
, python3
, llvmPackages_12
, elfutils
, perf
, zstd
, syntax-highlighting
, withDocumentation ? false
, qtdoc
, withClangPlugins ? true
}:

mkDerivation rec {
  pname = "qtcreator";
  version = "5.0.2";
  baseVersion = builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version));

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "sha256-G/BxUCJtpGI38m9eqp8JDOge15ubx14N+mMoBD42AQM=";
  };

  nativeBuildInputs = [ cmake clang python3 qmake ];

  buildInputs = [
    qtbase
    qtscript
    qttools
    qtwebengine
    qtquickcontrols2
    qtserialport
    elfutils.dev
    perf
    zstd
    syntax-highlighting
  ] ++ lib.optionals withDocumentation [ qtdoc ];

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_QBS=OFF"
    "-DQTC_CLANG_BUILDMODE_MATCH=ON"
    "-DBUILD_HELVIEWERBACKEND_QTWEBENGINE=ON"
  ] ++ lib.optionals withDocumentation [ "-DWITH_DOCS=ON" "-DBUILD_DEVELOPER_DOCS=ON" ];

  #installFlags = [ "INSTALL_ROOT=$(out)" ] ++ lib.optional withDocumentation "install_docs";

  #preConfigure = ''
  #  substituteInPlace src/plugins/plugins.pro \
  #    --replace '$$[QT_INSTALL_QML]/QtQuick/Controls' '${qtquickcontrols}/${qtbase.qtQmlPrefix}/QtQuick/Controls'
  #  substituteInPlace src/libs/libs.pro \
  #    --replace '$$[QT_INSTALL_QML]/QtQuick/Controls' '${qtquickcontrols}/${qtbase.qtQmlPrefix}/QtQuick/Controls'
  #'' + optionalString withClangPlugins ''
  #'';

  #preBuild = lib.optionalString withDocumentation ''
  #  ln -s ${lib.getLib qtbase}/$qtDocPrefix $NIX_QT5_TMP/share
  #'';

  postInstall = ''
    # has this comment
    # Use this script if you add paths to LD_LIBRARY_PATH
    # that contain libraries that conflict with the
    # libraries that Qt Creator depends on.
    rm $out/bin/qtcreator.sh

    substituteInPlace $out/share/applications/org.qt-project.qtcreator.desktop \
      --replace "Exec=qtcreator" "Exec=$out/bin/qtcreator"
  '';

  meta = with lib; {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Category:Tools::QtCreator";
    license = "LGPL";
    maintainers = [ maintainers.akaWolf ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
