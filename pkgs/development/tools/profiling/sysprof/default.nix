{ stdenv
, desktop-file-utils
, fetchurl
, gettext
, glib
, gtk3
, itstool
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
let
  version = "3.30.0";
  pname = "sysprof";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qrzcs60m44mmj7ln9815kfgvi2pjlhmk0p4vjc0dw3pw95jrk99";
  };

  nativeBuildInputs = [ desktop-file-utils gettext itstool libxml2 meson ninja pkgconfig shared-mime-info wrapGAppsHook ];
  buildInputs = [ glib gtk3 pango polkit systemd.dev systemd.lib ];

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
  ];

  postInstall = ''
    rm $out/share/applications/mimeinfo.cache
  '';

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
    maintainers = with maintainers; [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
