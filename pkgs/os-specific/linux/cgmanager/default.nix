{ stdenv, fetchurl, pkgconfig, libnih, dbus }:

stdenv.mkDerivation rec {
  name = "cgmanager-0.37";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/cgmanager/${name}.tar.gz";
    sha256 = "0vkv8am6h3x89c1rqb6a1glwz3mik3065jigri96njjzmvrff2c3";
  };

  buildInputs = [ pkgconfig libnih dbus ];

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    homepage = https://linuxcontainers.org/cgmanager/introduction/;
    description = "a central privileged daemon that manages all your cgroups";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
