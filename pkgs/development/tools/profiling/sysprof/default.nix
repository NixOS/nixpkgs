{ stdenv
, lib
, desktop-file-utils
, fetchurl
, fetchpatch
, gettext
, glib
, gtk3
, json-glib
, itstool
, libdazzle
, libxml2
, meson, ninja
, pango
, pkg-config
, polkit
, shared-mime-info
, systemd
, wrapGAppsHook
, gnome
}:

stdenv.mkDerivation rec {
  pname = "sysprof";
  version = "3.42.0";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "PBbgPv3+XT5xxNI5xndBrTf3LOiXHi9/rxaNvV6T6IY=";
  };

  patches = [
    # Fix missing unistd.h include.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/sysprof/commit/b113c89af1de2f87589175795a197f6384852a78.patch";
      sha256 = "3Q8d6IZYNJl/vbyzRgoRR2sdl4aRkbcKPeVjSSqxb98=";
    })
  ];

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

  buildInputs = [
    glib
    gtk3
    json-glib
    pango
    polkit
    systemd
    libdazzle
  ];

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
  ];

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
