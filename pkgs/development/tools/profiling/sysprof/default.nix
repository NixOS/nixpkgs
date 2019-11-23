{ stdenv
, desktop-file-utils
, fetchurl
, gettext
, glib
, gtk3
, itstool
, libdazzle
, libxml2
, meson, ninja
, pango
, pkgconfig
, polkit
, shared-mime-info
, systemd
, wrapGAppsHook
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "sysprof";
  version = "3.34.1";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1l4kr1av7933vb4zql9c5lgzivlw64hyky4nr8xin1v5if6vnjw4";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkgconfig
    shared-mime-info
    wrapGAppsHook
    gnome3.adwaita-icon-theme
  ];
  buildInputs = [ glib gtk3 pango polkit systemd.dev systemd.lib libdazzle ];

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "System-wide profiler for Linux";
    homepage = https://wiki.gnome.org/Apps/Sysprof;
    longDescription = ''
      Sysprof is a sampling CPU profiler for Linux that uses the perf_event_open
      system call to profile the entire system, not just a single
      application.  Sysprof handles shared libraries and applications
      do not need to be recompiled.  In fact they don't even have to
      be restarted.
    '';
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
