{ lib
, fetchFromGitHub
, python3Packages
, dnsmasq
, gawk
, getent
, gobject-introspection
, gtk3
, kmod
, lxc
, iproute2
, iptables
, util-linux
<<<<<<< HEAD
=======
, which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapGAppsHook
, xclip
, runtimeShell
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-0AkNzMIumvgnVcLKX72E2+Eg54Y9j7tdIYPsroOTLWA=";
=======
    sha256 = "sha256-0GBob9BUwiE5cFGdK8AdwsTjTOdc+AIWqUGN/gFfOqI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
<<<<<<< HEAD
    dbus-python
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gbinder-python
    pyclip
    pygobject3
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;
  dontWrapPythonPrograms = true;
  dontWrapGApps = true;

  installPhase = ''
    make install PREFIX=$out USE_SYSTEMD=0
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    patchShebangs --host $out/lib/waydroid/data/scripts
    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
      --prefix PATH ":" ${lib.makeBinPath [ dnsmasq getent iproute2 iptables ]}

    wrapPythonProgramsIn $out/lib/waydroid/ "${lib.concatStringsSep " " [
      "$out"
<<<<<<< HEAD
      python3Packages.dbus-python
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      python3Packages.gbinder-python
      python3Packages.pygobject3
      python3Packages.pyclip
      gawk
      kmod
      lxc
      util-linux
<<<<<<< HEAD
=======
      which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      xclip
    ]}"

    substituteInPlace $out/lib/waydroid/tools/helpers/*.py \
      --replace '"sh"' '"${runtimeShell}"'
<<<<<<< HEAD
=======

    substituteInPlace $out/share/applications/*.desktop \
      --replace  "/usr" "$out"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Waydroid is a container-based approach to boot a full Android system on a regular GNU/Linux system like Ubuntu";
    homepage = "https://github.com/waydroid/waydroid";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcaju ];
  };
}
