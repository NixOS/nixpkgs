{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, pango, gdk_pixbuf, atk, pep8, python, makeWrapper, gnome3
, pygobject3, gobjectIntrospection, libwnck3 }:

let
  version = "${major}.10";
  major = "0.3";
in

stdenv.mkDerivation rec {
  name = "d-feet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${major}/d-feet-${version}.tar.xz";
    sha256 = "88f0df5fcb862387ff3d1793873c5eb368c3e4db0bbd82ea65f748cbf70a6359";
  };

  buildInputs = [
    pkgconfig libxml2 itstool intltool glib gtk3 pep8 python
    gnome3.defaultIconTheme
    makeWrapper pygobject3 libwnck3
  ];

  preFixup =
    ''
      wrapProgram $out/bin/d-feet \
        --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pygobject3})" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$out/share"
    '';

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
