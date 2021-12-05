{ stdenv, lib, desktop-file-utils, fetchurl, gettext, glib, gtk3, json-glib
, itstool, libdazzle, libxml2, meson, ninja, pango, pkg-config, polkit
, shared-mime-info, systemd, wrapGAppsHook, gnome }:

stdenv.mkDerivation rec {
  pname = "sysprof";
  version = "3.42.1";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${
        lib.versions.majorMinor version
      }/${pname}-${version}.tar.xz";
    sha256 = "F5a4FATudf0eus9URkrXr/6/YvKFHu9STZ+OrAxKIAE=";
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
    wrapGAppsHook
    gnome.adwaita-icon-theme
  ];

  buildInputs = [ glib gtk3 json-glib pango polkit systemd libdazzle ];

  mesonFlags = [ "-Dsystemdunitdir=lib/systemd/system" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
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
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
