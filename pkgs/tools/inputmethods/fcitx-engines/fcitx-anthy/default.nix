{ stdenv, fetchFcitxSource, cmake, fcitx, anthy, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "fcitx-anthy";
  version = "0.2.2";

  src = fetchFcitxSource {
    inherit pname version;
    sha256 = "0ayrzfx95670k86y19bzl6i6w98haaln3x8dxpb39a5dwgz59pf8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake fcitx anthy gettext ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description   = "Fcitx Wrapper for anthy";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
