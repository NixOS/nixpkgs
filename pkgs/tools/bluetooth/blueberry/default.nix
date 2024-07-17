{
  stdenv,
  lib,
  fetchFromGitHub,
  bluez-tools,
  cinnamon,
  gnome,
  gobject-introspection,
  libnotify,
  pavucontrol,
  python3Packages,
  util-linux,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "blueberry";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-MyIjcTyKn1aC2th6fCOw4cIqrRKatk2s4QD5R9cm83A=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    bluez-tools
    cinnamon.xapp
    gnome.gnome-bluetooth_1_0
    libnotify
    python3Packages.python
    util-linux
  ];

  pythonPath = with python3Packages; [
    dbus-python
    pygobject3
    setproctitle
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a etc usr/* $out

    # Fix paths
    substituteInPlace $out/bin/blueberry \
      --replace /usr/lib/blueberry $out/lib/blueberry
    substituteInPlace $out/bin/blueberry-tray \
      --replace /usr/lib/blueberry $out/lib/blueberry
    substituteInPlace $out/etc/xdg/autostart/blueberry-obex-agent.desktop \
      --replace /usr/lib/blueberry $out/lib/blueberry
    substituteInPlace $out/etc/xdg/autostart/blueberry-tray.desktop \
      --replace Exec=blueberry-tray Exec=$out/bin/blueberry-tray
    substituteInPlace $out/lib/blueberry/blueberry-obex-agent.py \
      --replace /usr/share $out/share
    substituteInPlace $out/lib/blueberry/blueberry-tray.py \
      --replace /usr/share $out/share
    substituteInPlace $out/lib/blueberry/blueberry.py \
      --replace '"bt-adapter"' '"${bluez-tools}/bin/bt-adapter"' \
      --replace /usr/bin/pavucontrol ${pavucontrol}/bin/pavucontrol \
      --replace /usr/lib/blueberry $out/lib/blueberry \
      --replace /usr/share $out/share
    substituteInPlace $out/lib/blueberry/rfkillMagic.py \
      --replace /usr/bin/rfkill ${util-linux}/bin/rfkill \
      --replace /usr/sbin/rfkill ${util-linux}/bin/rfkill \
      --replace /usr/lib/blueberry $out/lib/blueberry
    substituteInPlace $out/share/applications/blueberry.desktop \
      --replace Exec=blueberry Exec=$out/bin/blueberry

    glib-compile-schemas --strict $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonProgramsIn $out/lib "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Bluetooth configuration tool";
    homepage = "https://github.com/linuxmint/blueberry";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      bobby285271
      romildo
    ];
  };
}
