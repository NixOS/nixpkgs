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
, wrapGAppsHook
, xclip
, runtimeShell
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.4.1";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-0AkNzMIumvgnVcLKX72E2+Eg54Y9j7tdIYPsroOTLWA=";
  };

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
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
      python3Packages.dbus-python
      python3Packages.gbinder-python
      python3Packages.pygobject3
      python3Packages.pyclip
      gawk
      kmod
      lxc
      util-linux
      xclip
    ]}"

    substituteInPlace $out/lib/waydroid/tools/helpers/*.py \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = with lib; {
    description = "Waydroid is a container-based approach to boot a full Android system on a regular GNU/Linux system like Ubuntu";
    homepage = "https://github.com/waydroid/waydroid";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcaju ];
  };
}
