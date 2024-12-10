{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  intltool,
  dbus-glib,
  libX11,
  libXScrnSaver,
  libXxf86vm,
  libXext,
  systemd,
  pantheon,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "light-locker";
  version = "1.9.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "the-cavalry";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z5lcd02gqax65qc14hj5khifg7gr53zy3s5i6apba50lbdlfk46";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    glib
    gtk3
    libX11
    libXScrnSaver
    libXext
    libXxf86vm
    systemd
  ];

  mesonFlags = [
    "-Dmit-ext=true"
    "-Ddpms-ext=true"
    "-Dxf86gamma-ext=true"
    "-Dsystemd=true"
    "-Dupower=true"
    "-Dlate-locking=true"
    "-Dlock-on-suspend=true"
    "-Dlock-on-lid=true"
    "-Dgsettings=true"
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/the-cavalry/light-locker";
    description = "A simple session-locker for LightDM";
    longDescription = ''
      A simple locker (forked from gnome-screensaver) that aims to
      have simple, sane, secure defaults and be well integrated with
      the desktop while not carrying any desktop-specific
      dependencies.

      It relies on LightDM for locking and unlocking your session via
      ConsoleKit/UPower or logind/systemd.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ obadz ] ++ teams.pantheon.members;
    platforms = platforms.linux;
  };
}
