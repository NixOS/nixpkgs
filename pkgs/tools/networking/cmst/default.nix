{ stdenv, fetchgit, qtbase, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-2014.12.05";
  rev = "refs/tags/${name}";
  src = fetchgit {
    url = "git://github.com/andrew-bibb/cmst.git";
    inherit rev;
    sha256 = "070rxv3kyn41ra7nnk1wbqvy6fjg38h7hrdv4dn71b201kmzd194";
  };

  buildInputs = [ qtbase makeWrapper ];

  configurePhase = ''
    substituteInPlace ./cmst.pro \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/usr/share"

    substituteInPlace ./cmst.pri \
      --replace "/usr/lib" "$out/lib" \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./apps/cmstapp/cmstapp.pro \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./apps/rootapp/rootapp.pro \
      --replace "/etc" "$out/etc" \
      --replace "/usr/share" "$out/share"

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
