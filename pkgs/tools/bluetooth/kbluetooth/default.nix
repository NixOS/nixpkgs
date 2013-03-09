{ stdenv, fetchurl, kdelibs, cmake, qt4, automoc4, phonon, kdebase_workspace, soprano, gettext
, semanticDesktop ? true }:
with stdenv;
mkDerivation rec {
  name = "kbluetooth-${version}";
  version = "0.4.2";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/112110-${name}.tar.bz2";
    sha256 = "0z5clp677g1vgh3dd09ilq1r481y342q2cx5pzjj51y1d9lb5zp5";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon kdebase_workspace soprano gettext]
    ++ lib.optional semanticDesktop soprano;

  patchPhase = ''
      substituteInPlace src/CMakeLists.txt --replace "DESTINATION \''${KDE4_BIN_INSTALL_DIR}" "DESTINATION bin"
      substituteInPlace src/inputwizard/CMakeLists.txt --replace "DESTINATION \''${KDE4_BIN_INSTALL_DIR}" "DESTINATION bin"
      substituteInPlace src/device-manager/CMakeLists.txt  --replace "DESTINATION \''${KDE4_BIN_INSTALL_DIR}" "DESTINATION bin"
  '';

  meta = with stdenv.lib; {
    description = "Bluetooth manager for KDE";
    license = "GPLv2";
    #inherit (kdelibs.meta) platforms; # doesn't build and seems to be dead
    maintainers = [ maintainers.phreedom ];
  };
}
