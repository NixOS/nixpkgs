{ stdenv, fetchgit, qt5, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-2014.08.23";
  rev = "refs/tags/${name}";
  src = fetchgit {
    url = "git://github.com/andrew-bibb/cmst.git";
    inherit rev;
    sha256 = "07g5i929jxlh6vm0ad8x33qmf2sryiichlv37x7fpn20h3xcsia0";
  };

  buildInputs = [ qt5 makeWrapper ];

  configurePhase = ''
    substituteInPlace ./cmst.pro \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/usr/share"
  '';

  buildPhase = ''
    qmake PREFIX=$out
    make
  '';

  postInstall = ''
    wrapProgram $out/bin/cmst \
      --prefix "QTCOMPOSE" ":" "${libX11}/share/X11/locale"
  '';

  meta = {
    description = "QT GUI for Connman with system tray icon";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
