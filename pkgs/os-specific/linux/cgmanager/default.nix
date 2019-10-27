{ stdenv, fetchurl, pkgconfig, libnih, dbus, pam, popt }:

stdenv.mkDerivation rec {
  pname = "cgmanager";
  version = "0.42";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/${pname}/${pname}-${version}.tar.gz";
    sha256 = "15np08h9jrvc1y1iafr8v654mzgsv5hshzc0n4p3pbf0rkra3h7c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnih dbus pam popt ];

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    homepage = https://linuxcontainers.org/cgmanager/introduction/;
    description = "A central privileged daemon that manages all your cgroups";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
