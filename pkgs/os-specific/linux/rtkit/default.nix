{ stdenv, fetchurl, pkgconfig, dbus, libcap }:

stdenv.mkDerivation rec {
  name = "rtkit-0.11";
  
  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.xz";
    sha256 = "1l5cb1gp6wgpc9vq6sx021qs6zb0nxg3cn1ba00hjhgnrw4931b8";
  };

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  buildInputs = [ pkgconfig dbus libcap ];

  meta = {
    homepage = http://0pointer.de/blog/projects/rtkit;
    descriptions = "A daemon that hands out real-time priority to processes";
    platforms = stdenv.lib.platforms.linux;
  };
}
