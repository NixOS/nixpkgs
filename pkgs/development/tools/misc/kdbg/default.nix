{ lib, stdenv, fetchurl, cmake, extra-cmake-modules, qt5,
  ki18n, kconfig, kiconthemes, kxmlgui, kwindowsystem,
  qtbase, makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kdbg";
  version = "3.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/kdbg/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-aLX/0GXof77NqQj7I7FUCZjyDtF1P8MJ4/NHJNm4Yr0=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper ];
  buildInputs = [ qt5.qtbase ki18n kconfig kiconthemes kxmlgui kwindowsystem ];

  postInstall = ''
    wrapProgram $out/bin/kdbg --prefix QT_PLUGIN_PATH : ${qtbase}/${qtbase.qtPluginPrefix}
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://www.kdbg.org/";
    description = ''
      A graphical user interface to gdb, the GNU debugger. It provides an
      intuitive interface for setting breakpoints, inspecting variables, and
      stepping through code.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.catern ];
  };
}
