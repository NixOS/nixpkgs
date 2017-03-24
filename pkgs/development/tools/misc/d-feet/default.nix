{ stdenv, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, pythonPackages, makeWrapper, gnome3, libwnck3 }:

let
  version = "${major}.11";
  major = "0.3";
in pythonPackages.buildPythonApplication rec {
  name = "d-feet-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${major}/d-feet-${version}.tar.xz";
    sha256 = "a3dc940c66f84b996c328531e3034d475ec690d7ff639445ff7ca746aa8cb9c2";
  };

  buildInputs = [ pkgconfig libxml2 itstool intltool glib gtk3
    gnome3.defaultIconTheme makeWrapper libwnck3
  ];

  propagatedBuildInputs = with pythonPackages; [ pygobject3 pep8 ];

  preFixup =
    ''
      wrapProgram $out/bin/d-feet \
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
