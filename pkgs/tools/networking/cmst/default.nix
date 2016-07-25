{ stdenv, fetchFromGitHub, qtbase, qmakeHook, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-${version}";
  version = "2016.04.03";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = name;
    sha256 = "1334ynhq1lxcfqln3bq17hy1awyfnn3zhzpsnymlyp0z3h4ydpp9";
  };

  nativeBuildInputs = [ makeWrapper qmakeHook ];

  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  preConfigure = ''
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
