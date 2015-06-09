{ stdenv, fetchgit, cmake, qt5, polkit_qt5, libyamlcpp, python, boost, parted
, extra-cmake-modules, kconfig, ki18n, kcoreaddons, solid, utillinux, libatasmart }:

stdenv.mkDerivation rec {
  name = "calamares-${version}";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/calamares/calamares.git";
    rev = "dabfb68a68cb012a90cd7b94a22e1ea08f7dd8ad";
    sha256 = "2851ce487aaac61d2df342a47f91ec87fe52ff036227ef697caa7056fe5f188c";
  };

  buildInputs = [
    cmake qt5.base qt5.tools libyamlcpp python boost polkit_qt5 parted
    extra-cmake-modules kconfig ki18n kcoreaddons solid utillinux libatasmart
  ];

  cmakeFlags = [
    "-DPYTHON_LIBRARY=${python}/lib/libpython${python.majorVersion}m.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.majorVersion}m"
    "-DWITH_PARTITIONMANAGER=1"
  ];

  preInstall = ''
    substituteInPlace cmake_install.cmake --replace "${polkit_qt5}" "$out"
  '';

  meta = with stdenv.lib; {
    description = "Distribution-independent installer framework";
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
