{ stdenv, fetchurl, cmake, extra-cmake-modules, qt5,
  ki18n, kconfig, kiconthemes, kxmlgui, kwindowsystem,
  qtbase, makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kdbg";
  version = "3.0.1";
  src = fetchurl {
    url = "mirror://sourceforge/kdbg/${version}/${pname}-${version}.tar.gz";
    sha256 = "1gax6xll8svmngw0z1rzhd77xysv01zp0i68x4n5pq0xgh7gi7a4";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper ];
  buildInputs = [ qt5.qtbase ki18n kconfig kiconthemes kxmlgui kwindowsystem ];

  enableParallelBuilding = true;


  postInstall = ''
    wrapProgram $out/bin/kdbg --prefix QT_PLUGIN_PATH : ${qtbase}/${qtbase.qtPluginPrefix}
  '';

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
