{ lib
, autoreconfHook
, fetchFromGitHub
, glib
, gobject-introspection
, intltool
, libnotify
, python3
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mpDris2";
  version = "0.8";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = pname;
    rev = version;
    sha256 = "048b8acsd1b8kcxzd9fsh5p9g2an9c4rznicfcpyrsjz5syv894h";
  };

  preConfigure = ''
    intltoolize -f
  '';

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    libnotify
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    mpd2
    mutagen
    pygobject3
  ];

  meta = with lib; {
    description = "MPRIS 2 support for mpd";
    homepage = "https://github.com/eonpatapon/mpDris2/";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
