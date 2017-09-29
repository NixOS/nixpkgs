{ stdenv, fetchFromGitHub, qtbase, qmake, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-${version}";
  version = "2017.03.18";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = name;
    sha256 = "0lsg8ya36df48ij0jawgli3f63hy6mn9zcla48whb1l4r7cih545";
  };

  nativeBuildInputs = [ makeWrapper qmake ];

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
    homepage = https://github.com/andrew-bibb/cmst;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
