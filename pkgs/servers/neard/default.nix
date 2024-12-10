{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  systemd,
  glib,
  dbus,
  libnl,
  python2Packages,
}:

stdenv.mkDerivation rec {
  pname = "neard";
  version = "0.18";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/network/nfc/neard.git/snapshot/neard-${version}.tar.gz";
    sha256 = "wBPjEVMV4uEdFrXw8cjOmvvNuiaACq2RJF/ZtKXck4s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    python2Packages.wrapPython
  ];

  buildInputs =
    [
      systemd
      glib
      dbus
      libnl
    ]
    ++ (with python2Packages; [
      python
    ]);

  pythonPath = with python2Packages; [
    pygobject2
    dbus-python
    pygtk
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-debug"
    "--enable-tools"
    "--enable-ese"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  postInstall = ''
    install -m 0755 tools/snep-send $out/bin/

    install -D -m644 src/main.conf $out/etc/neard/main.conf

    # INFO: the config option "--enable-test" would copy the apps to $out/lib/neard/test/ instead
    install -d $out/lib/neard
    install -m 0755 test/* $out/lib/neard/
    wrapPythonProgramsIn $out/lib/neard "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Near Field Communication manager";
    homepage = "https://01.org/linux-nfc";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    # error: wcwidth-0.2.13 not supported for interpreter python2.7
    broken = true; # Added 2024-03-17
  };
}
