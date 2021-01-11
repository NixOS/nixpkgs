{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, usbmuxd, fuse, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "ifuse";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "1r12y3h1j7ikkwk874h9969kr4ksyamvrwywx19ml6rsr01arw84";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig fuse usbmuxd libimobiledevice ];

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
    platforms = platforms.linux;
    maintainers = with maintainers; [ infinisil ];
  };
}
