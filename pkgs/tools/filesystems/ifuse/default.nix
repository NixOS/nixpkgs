{ stdenv, fetchurl, pkgconfig, usbmuxd, fuse, gnutls, libgcrypt,
  libplist, libimobiledevice }:

stdenv.mkDerivation rec {
  name = "ifuse-1.1.3";

  nativeBuildInputs = [ pkgconfig fuse libplist usbmuxd gnutls libgcrypt libimobiledevice ];

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.bz2";
    sha256 = "1p9a4n36jb194cnp6v57cz2bggwbywaz8pbpb95ch83pzdkdx257";
  };

  meta = {
    homepage = http://www.libimobiledevice.org;
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "A fuse filesystem implementation to access the contents of iOS devices";
    longDescription = ''
    Mount directories of an iOS device locally using fuse. By default the media
    directory is mounted, options allow to also mount the sandbox container of an
    app, an app's documents folder or even the root filesystem on jailbroken
    devices.'';
    inherit (usbmuxd.meta) platforms maintainers;
  };
}
