{ stdenv, fetchurl, cmake, extra-cmake-modules, qt5,
  ki18n, kconfig, kiconthemes, kxmlgui, kwindowsystem,
}:

stdenv.mkDerivation rec {
  pname = "kdbg";
  version = "3.0.0";
  src = fetchurl {
    url = "mirror://sourceforge/kdbg/${version}/${pname}-${version}.tar.gz";
    sha256 = "0lxfal6jijdcrf0hc81gmapfmz0kq4569d5qzfm4p72rq9s4r5in";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qt5.qtbase ki18n kconfig kiconthemes kxmlgui kwindowsystem ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.kdbg.org/;
    description = ''
      A graphical user interface to gdb, the GNU debugger. It provides an
      intuitive interface for setting breakpoints, inspecting variables, and
      stepping through code.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.catern ];
  };
}
