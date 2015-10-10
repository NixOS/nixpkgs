{ stdenv, fetchurl, makeWrapper, python, intltool, pkgconfig
, gnome3, atk, pygobject3, dbus, libnotify, isocodes, gobjectIntrospection, wayland }:

stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/ibus/ibus/releases/download/${version}/${name}.tar.gz";
    sha256 = "1g26llizd26h9sfz4xdq8krhz19hn08pirvfbkk3g89ri8lmm6a9";
  };

  configureFlags = "--disable-gconf --enable-dconf --disable-memconf --enable-ui --enable-python-library";

  buildInputs = [
    makeWrapper python gnome3.glib wayland
    intltool pkgconfig gnome3.gtk2
    gnome3.gtk3 dbus gnome3.dconf gnome3.gconf
    libnotify isocodes gobjectIntrospection
  ];

  preConfigure = ''
    substituteInPlace data/dconf/Makefile.in --replace "dconf update" "echo"
    sed -i "s|PYTHON2_LIBDIR=.*|PYTHON2_LIBDIR=$out/lib/${python.libPrefix}|" configure
  '';

  preFixup = ''
    for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
                       --prefix PYTHONPATH : "$(toPythonPath ${pygobject3})" \
                       --prefix LD_LIBRARY_PATH : "${gnome3.gtk3}/lib:${atk}/lib:$out/lib" \
                       --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
                       --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
    done
  '';

  meta = {
    homepage = https://github.com/ibus/ibus;
    description = "Intelligent Input Bus for Linux / Unix OS";
    platforms = stdenv.lib.platforms.linux;
  };
}
