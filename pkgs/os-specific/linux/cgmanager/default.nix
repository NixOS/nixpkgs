{ stdenv, fetchurl, pkgconfig, libnih, dbus, pam }:

stdenv.mkDerivation rec {
  name = "cgmanager-0.41";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/cgmanager/${name}.tar.gz";
    sha256 = "0n5l4g78ifvyfnj8x9xz06mqn4y8j73sgg4xsbak7hiszfz5bc99";
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
    description = "A central privileged daemon that manages all your cgroups";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
