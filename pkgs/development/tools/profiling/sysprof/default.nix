{ stdenv
, lib
, desktop-file-utils
, fetchurl
, gettext
, glib
, gtk4
, json-glib
, itstool
, libadwaita
, libdex
, libpanel
, libunwind
, libxml2
, meson
, ninja
, pkg-config
, polkit
, shared-mime-info
, systemd
, wrapGAppsHook4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "sysprof";
  version = "45.1";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "Mju51YVhPWDEOUYDMUUAEfK5Cz1ScmJb2FjaTBnfLPk=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    polkit
    systemd
    libadwaita
    libdex
    libpanel
    libunwind
  ];

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
    # In a separate libsysprof-capture package
    "-Dinstall-static=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "System-wide profiler for Linux";
    homepage = "https://wiki.gnome.org/Apps/Sysprof";
    longDescription = ''
      Sysprof is a sampling CPU profiler for Linux that uses the perf_event_open
      system call to profile the entire system, not just a single
      application.  Sysprof handles shared libraries and applications
      do not need to be recompiled.  In fact they don't even have to
      be restarted.
    '';
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
