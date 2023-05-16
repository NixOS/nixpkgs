{ lib, buildPythonApplication, fetchFromGitHub, wrapGAppsHook
, pytestCheckHook
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gtk3, gobject-introspection, libappindicator-gtk3, librsvg
, evdev, pygobject3, pylibacl, bluez, vdf
, linuxHeaders
, libX11, libXext, libXfixes, libusb1, udev
}:

buildPythonApplication rec {
  pname = "sc-controller";
<<<<<<< HEAD
  version = "0.4.8.11";
=======
  version = "0.4.8.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "Ryochan7";
    repo   = pname;
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "xu9QqddJf0cXkhNPrOnE+L8CV5AfgcCyk9DSh+G94c0=";
=======
    sha256 = "sha256-ym5fkOTRhibBaUqT0+p/jyqqKOVsyMz5INgfkoz0IJA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];

  buildInputs = [ gtk3 libappindicator-gtk3 librsvg ];

  propagatedBuildInputs = [ evdev pygobject3 pylibacl vdf ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
=======
  patches = [
    # Fix a broken test
    (fetchpatch {
      url = "https://github.com/Ryochan7/sc-controller/pull/73.patch";
      sha256 = "sha256-qU8hIReZE3cEPCMOFc4RCUCIhiS0gJ3PushMkfDlPns=";
     })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage    = "https://github.com/Ryochan7/sc-controller";
    # donations: https://www.patreon.com/kozec
    description = "User-mode driver and GUI for Steam Controller and other controllers";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ orivej rnhmjoj ];
  };
}
