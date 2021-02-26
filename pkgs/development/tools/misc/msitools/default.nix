{ lib, stdenv, fetchurl, bison, intltool, glib, pkg-config, libgsf, libuuid, gcab, bzip2, gnome3 }:

stdenv.mkDerivation rec {
  pname = "msitools";
  version = "0.99";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-1HWTml4zayBesxN7rHM96Ambx0gpBA4GWwGxX2yLNjU=";
  };

  nativeBuildInputs = [ bison intltool pkg-config ];
  buildInputs = [ glib libgsf libuuid gcab bzip2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = "https://wiki.gnome.org/msitools";
    license = [ licenses.gpl2 licenses.lgpl21 ];
    maintainers = with maintainers; [ PlushBeaver ];
    platforms = platforms.unix;
  };
}
