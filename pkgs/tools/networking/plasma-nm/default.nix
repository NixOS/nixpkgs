{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs, networkmanager, libnm-qt, glib }:

let
  pname = "plasma-nm";
  version = "0.9.3.4";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${name}.tar.xz";
    sha256 = "0xj14isvjq8ll70b6q66n8adm8ff4j9ng195ndk2gmavjf6bb751";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/glib-2.0 -I${glib.out}/lib/glib-2.0/include";

  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  buildInputs = [ kdelibs networkmanager libnm-qt ];

  meta = with stdenv.lib; {
    homepage = "https://projects.kde.org/projects/kde/workspace/plasma-nm";
    description = "Plasma applet written in QML for managing network connections";
    license = licenses.lgpl21;
    inherit (kdelibs.meta) platforms;
  };
}
