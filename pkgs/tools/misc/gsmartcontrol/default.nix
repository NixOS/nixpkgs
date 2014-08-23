{ fetchurl, stdenv, smartmontools, gtk, gtkmm, libglademm, pkgconfig, pcre }:

stdenv.mkDerivation rec {
  version="0.8.7";
  name = "gsmartcontrol-${version}";

  src = fetchurl {
    url = "http://artificialtime.com/gsmartcontrol/gsmartcontrol-${version}.tar.bz2";
    sha256 = "1ipykzqpfvlr84j38hr7q2cag4imrn1gql10slp8bfrs4h1si3vh";
  };

  buildInputs = [ smartmontools gtk gtkmm libglademm pkgconfig pcre ];

  #installTargets = "install datainstall";

  meta = {
    description = "Hard disk drive health inspection tool";
    longDescription = ''
      GSmartControl is a graphical user interface for smartctl (from
      smartmontools package), which is a tool for querying and controlling
      SMART (Self-Monitoring, Analysis, and Reporting Technology) data on
      modern hard disk drives.

      It allows you to inspect the drive's SMART data to determine its health,
      as well as run various tests on it.
    '';
    homepage = http://gsmartcontrol.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
