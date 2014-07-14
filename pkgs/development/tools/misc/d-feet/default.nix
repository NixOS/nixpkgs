{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, pango, gdk_pixbuf, atk, pep8, python, makeWrapper, gnome3
, pygobject3, gobjectIntrospection, libwnck3 }:

let
  version = "${major}.8";
  major = "0.3";
in

stdenv.mkDerivation rec {
  name = "d-feet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${major}/d-feet-${version}.tar.xz";
    sha256 = "e8423feb18fdff9b1465bf8442b78994ba13c12f8fa3b08e6a2f05768b4feee5";
  };

  buildInputs = [
    pkgconfig libxml2 itstool intltool glib gtk3 pep8 python
    gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
    makeWrapper pygobject3 libwnck3
  ];

  preFixup =
    ''
      wrapProgram $out/bin/d-feet \
        --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pygobject3})" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix LD_LIBRARY_PATH : "${gtk3}/lib:${atk}/lib:${libwnck3}/lib" \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$out/share"

      rm $out/share/icons/hicolor/icon-theme.cache
    '';

  meta = {
    description = "D-Feet is an easy to use D-Bus debugger";

    longDescription = ''
      D-Feet can be used to inspect D-Bus interfaces of running programs
      and invoke methods on those interfaces.
    '';

    homepage = https://wiki.gnome.org/action/show/Apps/DFeet;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ ktosiek ];
  };
}
