{ gdk-pixbuf, glib, gobject-introspection, gtk3, lib, libnotify,
  pythonPackages, wrapGAppsHook
}:

pythonPackages.buildPythonApplication rec {
  pname = "caffeine-ng";
  version = "3.4.2";

  src = pythonPackages.fetchPypi{
    inherit pname version;
    sha256="05k8smjlfjcccgmp8qi04l7106k46fs4p8fl5bdqqjwv6pwl7y4w";
  };

  nativeBuildInputs = [ wrapGAppsHook glib ];
  buildInputs = [ gdk-pixbuf gobject-introspection libnotify gtk3 ];
  pythonPath = with pythonPackages; [
    dbus-python docopt ewmh pygobject3 pyxdg
    setproctitle setuptools setuptools_scm wheel
  ];

  postBuild = ''
    mkdir -p $out/share
    cp -r share $out/
    glib-compile-schemas --strict $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    maintainers = with maintainers; [ marzipankaiser ];
    description = "Status bar application to temporarily inhibit screensaver and sleep mode";
    homepage = "https://github.com/caffeine-ng/caffeine-ng";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
