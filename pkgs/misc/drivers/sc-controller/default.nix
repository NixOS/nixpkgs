{ lib, buildPythonApplication, fetchFromGitHub, wrapGAppsHook
, gtk3, gobject-introspection, libappindicator-gtk3, librsvg
, evdev, pygobject3, pylibacl, pytest, bluez
, linuxHeaders
, libX11, libXext, libXfixes, libusb1, udev
}:

buildPythonApplication rec {
  pname = "sc-controller";
  version = "0.4.6.1";

  src = fetchFromGitHub {
    owner  = "kozec";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1kcqsnrlwl4s94j6ahgkz3w4sy9hsr95y624zab6g10w0fl5sqrc";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ gtk3 gobject-introspection libappindicator-gtk3 librsvg ];

  propagatedBuildInputs = [ evdev pygobject3 pylibacl ];

  checkInputs = [ pytest ];

  postPatch = ''
    substituteInPlace scc/paths.py --replace sys.prefix "'$out'"
    substituteInPlace scc/uinput.py --replace /usr/include ${linuxHeaders}/include
    substituteInPlace scc/device_monitor.py --replace "find_library('bluetooth')" "'libbluetooth.so.3'"
  '';

  LD_LIBRARY_PATH = lib.makeLibraryPath [ libX11 libXext libXfixes libusb1 udev bluez ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH")
    # gdk-pixbuf setup hook can not choose between propagated librsvg
    # and our librsvg with GObject introspection.
    GDK_PIXBUF_MODULE_FILE=$(echo ${librsvg}/lib/gdk-pixbuf-2.0/*/loaders.cache)
  '';

  postFixup = ''
    (
      # scc runs these scripts as programs. (See find_binary() in scc/tools.py.)
      cd $out/lib/python*/site-packages/scc/x11
      patchPythonScript scc-autoswitch-daemon.py
      patchPythonScript scc-osd-daemon.py
    )
  '';

  checkPhase = ''
    PYTHONPATH=. py.test
  '';

  meta = with lib; {
    homepage    = https://github.com/kozec/sc-controller;
    # donations: https://www.patreon.com/kozec
    description = "User-mode driver and GUI for Steam Controller and other controllers";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ orivej rnhmjoj ];
  };
}
