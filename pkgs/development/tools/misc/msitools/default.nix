{ lib
, stdenv
, fetchurl
, intltool
, pkgconfig
, bison
, glib
, libgsf
, libuuid
, gcab
, bzip2
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "msitools";
  version = "0.100";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-u/Gm46nCMjuGCjInrBdnNqPq/EpEpnNGxoRFkfEJeOo=";
  };

  nativeBuildInputs = [ intltool pkgconfig bison ];
  buildInputs = [ glib libgsf libuuid gcab bzip2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = "https://wiki.gnome.org/msitools";
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
    platforms = lib.platforms.unix;
  };
}
