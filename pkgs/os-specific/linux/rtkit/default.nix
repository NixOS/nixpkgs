{ stdenv, fetchurl, fetchpatch, pkgconfig, dbus, libcap }:

stdenv.mkDerivation rec {
  name = "rtkit-0.11";

  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.xz";
    sha256 = "1l5cb1gp6wgpc9vq6sx021qs6zb0nxg3cn1ba00hjhgnrw4931b8";
  };

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  patches = [
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-multimedia/rtkit.git/plain/debian/patches/0002-Drop-Removed-ControlGroup-stanza.patch?id=21f2c6be6985c777cbf113c67043353406744050";
      sha256 = "0lsxk5nv08i1wjb4xh20i5fcwg3x0qq0k4f8bc0r9cczph2sv7ck";
    })
  ];

  buildInputs = [ pkgconfig dbus libcap ];

  meta = {
    homepage = http://0pointer.de/blog/projects/rtkit;
    descriptions = "A daemon that hands out real-time priority to processes";
    platforms = stdenv.lib.platforms.linux;
  };
}
