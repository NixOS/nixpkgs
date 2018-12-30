{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, python3Packages, wrapGAppsHook, gnome3, libwnck3, gobject-introspection }:

let
  pname = "d-feet";
  version = "0.3.14";
in python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1m8lwiwl5jhi0x7y6x5zmd3hjplgvdjrb8a8jg74rvkygslj1p7f";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook libxml2 ];
  buildInputs = [ glib gtk3 gnome3.defaultIconTheme libwnck3 gobject-introspection ];

  propagatedBuildInputs = with python3Packages; [ pygobject3 pep8 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "dfeet";
      versionPolicy = "none";
    };
  };

  meta = {
    description = "D-Feet is an easy to use D-Bus debugger";

    longDescription = ''
      D-Feet can be used to inspect D-Bus interfaces of running programs
      and invoke methods on those interfaces.
    '';

    homepage = https://wiki.gnome.org/Apps/DFeet;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ktosiek ];
  };
}
