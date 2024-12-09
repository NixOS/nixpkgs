{ lib, buildPythonApplication, fetchFromGitHub, wrapGAppsHook3
, pytestCheckHook
, gtk3, gobject-introspection, libappindicator-gtk3, librsvg
, evdev, pygobject3, pylibacl, bluez, vdf
, linuxHeaders
, libX11, libXext, libXfixes, libusb1, udev
}:

buildPythonApplication rec {
  pname = "sc-controller";
  version = "0.4.8.21";

  src = fetchFromGitHub {
    owner = "C0rn3j";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XakbCuwjIAXYFZxvJsAlDIJEl09pwFPT12h04onXd34=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 gobject-introspection ];

  buildInputs = [ gtk3 libappindicator-gtk3 librsvg ];

  propagatedBuildInputs = [ evdev pygobject3 pylibacl vdf ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace scc/paths.py --replace sys.prefix "'$out'"
    substituteInPlace scc/uinput.py --replace /usr/include ${linuxHeaders}/include
    substituteInPlace scc/device_monitor.py --replace "find_library('bluetooth')" "'libbluetooth.so.3'"
  '';

  LD_LIBRARY_PATH = lib.makeLibraryPath [ libX11 libXext libXfixes libusb1 udev bluez ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH")
  '';

  postFixup = ''
    (
      # scc runs these scripts as programs. (See find_binary() in scc/tools.py.)
      cd $out/lib/python*/site-packages/scc/x11
      patchPythonScript scc-autoswitch-daemon.py
      patchPythonScript scc-osd-daemon.py
    )
  '';

  meta = with lib; {
    homepage    = "https://github.com/C0rn3j/sc-controller";
    # donations: https://www.patreon.com/kozec
    description = "User-mode driver and GUI for Steam Controller and other controllers";
    license     = licenses.gpl2Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ orivej rnhmjoj ];
  };
}
