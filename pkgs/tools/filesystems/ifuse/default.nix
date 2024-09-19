{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse,
  usbmuxd,
  libimobiledevice,
}:
stdenv.mkDerivation {
  pname = "ifuse";
  version = "1.1.4-unstable-2023-01-06";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ifuse";
    rev = "814a0e38050850937debd697fcfe6eca3de1b66f";
    hash = "";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fuse
    usbmuxd
    libimobiledevice
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/ifuse";
    description = "Fuse filesystem implementation to access the contents of iOS devices";
    longDescription = ''
      Mount directories of an iOS device locally using fuse. By default the media
      directory is mounted, options allow to also mount the sandbox container of an
      app, an app's documents folder or even the root filesystem on jailbroken
      devices.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
    mainProgram = "ifuse";
  };
}
