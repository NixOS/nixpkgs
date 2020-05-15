{ stdenv
, pkgconfig
, fetchurl
, meson
, ninja
, glib
, gtk3
, python3
, wrapGAppsHook
, gnome3
, libwnck3
, gobject-introspection
, gettext
, itstool
}:

python3.pkgs.buildPythonApplication rec {
  pname = "d-feet";
  version = "0.3.15";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1cgxgpj546jgpyns6z9nkm5k48lid8s36mvzj8ydkjqws2d19zqz";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    itstool
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gnome3.adwaita-icon-theme
    gtk3
    libwnck3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  mesonFlags = [
    "-Dtests=false" # needs dbus
  ];

  # Temporary fix
  # See https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "dfeet";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "D-Feet is an easy to use D-Bus debugger";
    longDescription = ''
      D-Feet can be used to inspect D-Bus interfaces of running programs
      and invoke methods on those interfaces.
    '';
    homepage = "https://wiki.gnome.org/Apps/DFeet";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ktosiek ];
  };
}
