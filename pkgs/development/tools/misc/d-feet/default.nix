{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, pythonPackages, wrapGAppsHook, gnome3, libwnck3 }:

let
  version = "${major}.12";
  major = "0.3";
in pythonPackages.buildPythonApplication rec {
  name = "d-feet-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${major}/d-feet-${version}.tar.xz";
    sha256 = "054hl56rii9ff7rzl42h7993ywjbxmhlcd7bk8fi1c2bx98c6s68";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook libxml2 ];
  buildInputs = [ glib gtk3 gnome3.defaultIconTheme libwnck3 ];

  propagatedBuildInputs = with pythonPackages; [ pygobject3 pep8 ];

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
