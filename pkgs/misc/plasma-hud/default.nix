{python3, fetchFromGitHub, rofi, gobject-introspection}:
with python3.pkgs;
buildPythonApplication rec{
  pname = "plasma-hud";
  version = "19.10.1";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = pname;
    rev = version;
    sha256 = "19vlc156jfdamw7q1pc78fmlf0h3sff5ar3di9j316vbb60js16l";
  };

  propagatedBuildInputs = [
    rofi
    dbus-python
    setproctitle
    xlib
    pygobject3
    gobject-introspection
  ];
  format = "other";
  patchPhase = ''
    sed -i "s:/usr/lib/plasma-hud:$out/bin:" etc/xdg/autostart/plasma-hud.desktop
  '';
  installPhase = ''
    patchShebangs
    mkdir -p $out/{bin,etc/xdg/autostart}
    cp -r {$src/usr/lib/plasma-hud,$out/bin}/plasma-hud
    cp -r {$src,$out}/etc
  '';
}
