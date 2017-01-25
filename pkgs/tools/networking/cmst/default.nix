{ stdenv, fetchFromGitHub, qtbase, qmakeHook, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-${version}";
  version = "2016.10.03";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = name;
    sha256 = "1pvk1jg0fiw0j4f1wrnhgirgziliwa44sxfdmcq9ans4zbig4izh";
  };

  nativeBuildInputs = [ makeWrapper qmakeHook ];

  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace ./cmst.pro \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./cmst.pri \
      --replace "/usr/lib" "$out/lib" \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./apps/cmstapp/cmstapp.pro \
      --replace "/usr/bin" "$out/bin"

    substituteInPlace ./apps/rootapp/rootapp.pro \
      --replace "/etc" "$out/etc" \
      --replace "/usr/share" "$out/share"
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
