{ stdenv
, desktop-file-utils
, fetchurl
, fetchpatch
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
  version = "3.36.0";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "024i0gzqnm79rpr4gqxdvcj6gvf82xdlcp2p1k9ikcppmi6xnw46";
  };

  patches = [
    # Fix 32-bit builds
    # https://gitlab.gnome.org/GNOME/sysprof/merge_requests/24
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/sysprof/commit/5dea152c7728f5a37370ad8a229115833e36b4f6.patch";
      sha256 = "0c76s7r329pbdlmgvm3grn89iylrxv5wg87craqp937nwk3wb80g";
    })
  ];

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
    platforms = platforms.linux;
  };
}
