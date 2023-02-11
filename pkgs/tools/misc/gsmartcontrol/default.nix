{ fetchurl, lib, stdenv, smartmontools, autoreconfHook, gettext, gtkmm3, pkg-config, wrapGAppsHook, pcre-cpp, gnome }:

stdenv.mkDerivation rec {
  pname = "gsmartcontrol";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/ashaduri/gsmartcontrol/releases/download/v${version}/gsmartcontrol-${version}.tar.bz2";
    sha256 = "sha256-/ECfK4qEzEC7ED1sgkAbnUwBgtWjsiPJOVnHrWYZGEc=";
  };

  patches = [
    ./fix-paths.patch
  ];

  postPatch = ''
    substituteInPlace data/org.gsmartcontrol.policy --replace "/usr/sbin" $out/bin
  '';

  nativeBuildInputs = [ autoreconfHook gettext pkg-config wrapGAppsHook ];
  buildInputs = [ gtkmm3 pcre-cpp gnome.adwaita-icon-theme ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ smartmontools ]}"
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
    homepage = "https://gsmartcontrol.shaduri.dev/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [qknight];
    platforms = with lib.platforms; linux;
  };
}
