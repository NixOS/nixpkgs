{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, python3Packages, wrapGAppsHook, gnome3, libwnck3 }:

let
  version = "${major}.13";
  major = "0.3";
in python3Packages.buildPythonApplication rec {
  name = "d-feet-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${major}/d-feet-${version}.tar.xz";
    sha256 = "1md3lzs55sg04ds69dbginpxqvgg3qnf1lfx3vmsxph6bbd2y6ll";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook libxml2 ];
  buildInputs = [ glib gtk3 gnome3.defaultIconTheme libwnck3 ];

  propagatedBuildInputs = with python3Packages; [ pygobject3 pep8 ];

  meta = {
    description = "D-Feet is an easy to use D-Bus debugger";

    longDescription = ''
      D-Feet can be used to inspect D-Bus interfaces of running programs
      and invoke methods on those interfaces.
    '';

    homepage = https://wiki.gnome.org/action/show/Apps/DFeet;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ktosiek ];
  };
}
