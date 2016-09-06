{ stdenv, fetchurl, makeWrapper
, qtbase, makeQtWrapper, qtquickcontrols, qtscript, qtdeclarative, qmakeHook
, withDocumentation ? false
}:

with stdenv.lib;

let
  baseVersion = "4.1";
  revision = "0";
  version = "${baseVersion}.${revision}";
in

stdenv.mkDerivation rec {
  name = "qtcreator-${version}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qtcreator/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.gz";
    sha256 = "00xlzw01ngza54ssmwz2ryahjlrbniy2q3p174xri1pxvcih4b21";
  };

  buildInputs = [ qtbase qtscript qtquickcontrols qtdeclarative ];

  nativeBuildInputs = [ qmakeHook makeQtWrapper makeWrapper ];

  doCheck = true;

  enableParallelBuilding = true;

  buildFlags = optional withDocumentation "docs";

  installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  postInstall = ''
    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/qtcreator.desktop" << __EOF__
    [Desktop Entry]
    Exec=$out/bin/qtcreator
    Name=Qt Creator
    GenericName=Cross-platform IDE for Qt
    Icon=QtProject-qtcreator.png
    Terminal=false
    Type=Application
    Categories=Qt;Development;IDE;
    __EOF__
    wrapQtProgram $out/bin/qtcreator
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Category:Tools::QtCreator";
    license = "LGPL";
    maintainers = [ maintainers.akaWolf maintainers.bbenoist ];
    platforms = platforms.all;
  };
}
