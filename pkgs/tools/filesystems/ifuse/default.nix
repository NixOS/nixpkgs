{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, usbmuxd, fuse, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "ifuse";
  version = "2018-10-08";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "e75d32c34d0e8b80320f0a007d5ecbb3f55ef7f0";
    sha256 = "1b9w2i0sliswlkkb890l9i0rxrf631xywxf8ihygfmjdsfw47h1m";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig fuse usbmuxd libimobiledevice ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/ifuse;
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
