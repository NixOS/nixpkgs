{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, fuse
, usbmuxd
, libimobiledevice
}:

stdenv.mkDerivation rec {
  pname = "ifuse";
  version = "1.1.4+date=2022-04-04";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "6f5b8e410f9615b3369ca5eb5367745e13d83b92";
    hash = "sha256-KbuJLS2BWua9DnhLv2KtsQObin0PQwXQwEdgi3lSAPk=";
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
    description = "A fuse filesystem implementation to access the contents of iOS devices";
    longDescription = ''
      Mount directories of an iOS device locally using fuse. By default the media
      directory is mounted, options allow to also mount the sandbox container of an
      app, an app's documents folder or even the root filesystem on jailbroken
      devices.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
    mainProgram = "ifuse";
  };
}
