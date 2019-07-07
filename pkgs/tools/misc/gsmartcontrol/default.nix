{ fetchurl, stdenv, smartmontools, autoreconfHook, gettext, gtkmm3, pkgconfig, wrapGAppsHook, pcre-cpp, gnome3 }:

stdenv.mkDerivation rec {
  version="1.1.3";
  name = "gsmartcontrol-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gsmartcontrol/gsmartcontrol-${version}.tar.bz2";
    sha256 = "1a8j7dkml9zvgpk83xcdajfz7g6mmpmm5k86dl5sjc24zb7n4kxn";
  };

  patches = [
    ./fix-paths.patch
  ];

  nativeBuildInputs = [ autoreconfHook gettext pkgconfig wrapGAppsHook ];
  buildInputs = [ gtkmm3 pcre-cpp gnome3.adwaita-icon-theme ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${stdenv.lib.makeBinPath [ smartmontools ]}"
    )
  '';

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
    homepage = https://gsmartcontrol.sourceforge.io/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
