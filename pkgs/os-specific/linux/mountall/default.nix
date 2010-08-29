{ stdenv, fetchurl, pkgconfig, libnih, dbus, udev, autoconf, automake, libtool }:
   
stdenv.mkDerivation {
  name = "mountall-2.15";
   
  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/mountall_2.15.tar.gz;
    sha256 = "1ik9r1av0f17byfxr4l2w0qpaijxkfqvxws6gmc98liq6fyyzn4v";
  };

  patches = [ ./no-plymouth.patch ];

  preConfigure = "autoreconf";

  buildInputs = [ pkgconfig libnih dbus.libs udev autoconf automake libtool ];

  meta = {
    homepage = https://launchpad.net/ubuntu/+source/mountall;
    description = "Utility to mount all filesystems and emit Upstart events";
    platforms = stdenv.lib.platforms.linux;    
  };
}
