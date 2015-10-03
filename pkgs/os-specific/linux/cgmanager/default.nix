{ stdenv, fetchurl, pkgconfig, libnih, dbus, pam }:

stdenv.mkDerivation rec {
  name = "cgmanager-0.39";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/cgmanager/${name}.tar.gz";
    sha256 = "0ysv8klnybp727aad2k0aa67s05q027pzfl7rmm0map4nizlhrcy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnih dbus pam ];

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
