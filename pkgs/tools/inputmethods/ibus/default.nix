{ stdenv, fetchurl, makeWrapper
, intltool, isocodes, pkgconfig
, python3, pygobject3
, gtk2, gtk3, atk, dconf, glib, json_glib
, dbus, libnotify, gobjectIntrospection, wayland
, nodePackages
}:

stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.14";

  src = fetchurl {
    url = "https://github.com/ibus/ibus/releases/download/${version}/${name}.tar.gz";
    sha256 = "0g4x02d7j5w1lfn4zvmzsq93h17lajgn9d7hlvr6pws28vz40ax4";
  };

  postPatch = ''
    # These paths will be set in the wrapper.
    sed -e "/export IBUS_DATAROOTDIR/ s/^.*$//" \
        -e "/export IBUS_LIBEXECDIR/ s/^.*$//" \
        -e "/export IBUS_LOCALEDIR/ s/^.*$//" \
        -e "/export IBUS_PREFIX/ s/^.*$//" \
        -i "setup/ibus-setup.in"
  '';

  configureFlags = [
    "--disable-gconf"
    "--enable-dconf"
    "--disable-memconf"
    "--enable-ui"
    "--enable-python-library"
    "--with-emoji-json-file=${nodePackages.emojione}/lib/node_modules/emojione/emoji.json"
  ];

  buildInputs = [
    python3 pygobject3
    intltool isocodes pkgconfig
    gtk2 gtk3 dconf
    json_glib
    dbus libnotify gobjectIntrospection wayland
  ];

  propagatedBuildInputs = [ glib ];

  nativeBuildInputs = [ makeWrapper ];

  preConfigure = ''
    # Fix hard-coded installation paths, so make does not try to overwrite our
    # Python installation.
    sed -e "/py2overridesdir=/ s|=.*$|=$out/lib/${python3.libPrefix}|" \
        -e "/pyoverridesdir=/ s|=.*$|=$out/lib/${python3.libPrefix}|" \
        -e "/PYTHON2_LIBDIR/ s|=.*|=$out/lib/${python3.libPrefix}|" \
        -i configure

    # Don't try to generate a system-wide dconf database; it wouldn't work.
    substituteInPlace data/dconf/Makefile.in --replace "dconf update" "echo"
  '';

  preFixup = ''
    for f in "$out/bin"/*; do #*/
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/ibus version";

  meta = with stdenv.lib; {
    homepage = https://github.com/ibus/ibus;
    description = "Intelligent Input Bus for Linux / Unix OS";
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };
}
