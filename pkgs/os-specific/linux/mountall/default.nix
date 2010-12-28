{ stdenv, fetchurl, pkgconfig, libnih, dbus, udev, autoconf, automake, libtool, gettext }:
   
stdenv.mkDerivation {
  name = "mountall-2.15";
   
  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/mountall_2.15.tar.gz;
    sha256 = "1ik9r1av0f17byfxr4l2w0qpaijxkfqvxws6gmc98liq6fyyzn4v";
  };

  patches = [ ./no-plymouth.patch ];

  preConfigure = "rm -R aclocal.m4; gettextize -f; autoreconf -vfi";

  buildInputs = [ pkgconfig libnih dbus.libs udev autoconf automake libtool gettext ];

  meta = {
    homepage = https://launchpad.net/ubuntu/+source/mountall;
    description = "Utility to mount all filesystems and emit Upstart events";
    platforms = stdenv.lib.platforms.linux;    
  };
}
