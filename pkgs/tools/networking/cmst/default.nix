{ stdenv, fetchFromGitHub, qtbase, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-2016.01.28";

  src = fetchFromGitHub {
    sha256 = "1zf4jnrnbi05mrq1fnsji5zx60h1knrkr64pwcz2c7q8p59k4646";
    rev    = name;
    repo   = "cmst";
    owner  = "andrew-bibb";
  };

  buildInputs = [ qtbase makeWrapper ];

  configurePhase = ''
    runHook preConfigure
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
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    qmake PREFIX=$out
    make
    runHook postBuild
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
