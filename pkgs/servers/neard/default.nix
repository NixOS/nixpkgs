{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, gobject-introspection
, pkg-config
, wrapGAppsHook3
, glib
, dbus
, libnl
, python3Packages
}:

stdenv.mkDerivation {
  pname = "neard";
  version = "0.19-unstable-2024-07-02";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linux-nfc";
    repo = "neard";
    rev = "a0a7d4d677800a39346f0c89d93d0fe43a95efad";
    hash = "sha256-6BgX7cJwxX+1RX3wU+HY/PIBgzomzOKemnl0SDLJNro=";
  };

  postPatch = ''
    patchShebangs test/*
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    gobject-introspection
    pkg-config
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  configureFlags = [
    "--enable-pie"
    "--enable-test"
    "--enable-tools"
    "--with-sysconfdir=/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  buildInputs = [
    dbus
    glib
    libnl
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  pythonPath = with python3Packages; [
    pygobject3
    dbus-python
  ];

  doCheck = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonProgramsIn "$out/lib/neard" "$pythonPath"
  '';

  meta = with lib; {
    description = "Near Field Communication manager";
    homepage = "https://01.org/linux-nfc";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
