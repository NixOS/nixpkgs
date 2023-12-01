{ wrapGAppsHook, lib, python3, fetchFromGitHub, rofi, gobject-introspection }:

python3.pkgs.buildPythonApplication rec{
  pname = "plasma-hud";
  version = "19.10.1";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = pname;
    rev = version;
    sha256 = "19vlc156jfdamw7q1pc78fmlf0h3sff5ar3di9j316vbb60js16l";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    rofi
    dbus-python
    pygobject3
    setproctitle
    xlib
  ];
  format = "other";
  postPatch = ''
    sed -i "s:/usr/lib/plasma-hud:$out/bin:" etc/xdg/autostart/plasma-hud.desktop
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 usr/lib/plasma-hud/plasma-hud -t $out/bin
    cp -r etc -t $out

    runHook postInstall
  '';

  meta = with lib;{
    license = licenses.gpl2Only;
    homepage = "https://github.com/Zren/plasma-hud";
    platforms = platforms.unix;
    description = "Run menubar commands, much like the Unity 7 Heads-Up Display (HUD)";
    maintainers = with maintainers; [ pasqui23 ];
    mainProgram = "plasma-hud";
  };
}
