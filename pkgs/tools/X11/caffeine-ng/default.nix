{ gdk-pixbuf, glib, gobject-introspection, gtk3, lib, libnotify,
  python3Packages, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "caffeine-ng";
  version = "3.4.2";

  src = python3Packages.fetchPypi{
    inherit pname version;
    sha256="05k8smjlfjcccgmp8qi04l7106k46fs4p8fl5bdqqjwv6pwl7y4w";
  };

  nativeBuildInputs = [ wrapGAppsHook glib ];
  buildInputs = [ 
    gdk-pixbuf gobject-introspection libnotify gtk3 
    python3Packages.setuptools_scm
  ];
  pythonPath = with python3Packages; [
    dbus-python docopt ewmh pygobject3 pyxdg
    setproctitle 
  ];

  doCheck = false; # There are no tests.

  postInstall = ''
    mkdir -p $out/share
    cp -r share $out/
    # autostart file
    cp -r $out/lib/python*/site-packages/etc $out/etc/
    glib-compile-schemas --strict $out/share/glib-2.0/schemas
    for i in $(find $out -name "*.desktop"); do
      substituteInPlace $i --replace /usr $out
    done
  '';

  meta = with lib; {
    maintainers = with maintainers; [ marzipankaiser ];
    description = "Status bar application to temporarily inhibit screensaver and sleep mode";
    homepage = "https://github.com/caffeine-ng/caffeine-ng";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
