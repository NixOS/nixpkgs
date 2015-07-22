{ stdenv, fetchurl, pkgconfig, libnih, dbus }:

stdenv.mkDerivation rec {
  name = "cgmanager-0.36";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/cgmanager/${name}.tar.gz";
    sha256 = "039azd4ghpmiccd95ki8fna321kccapff00rib6hrdgg600pyw7l";
  };

  buildInputs = [ pkgconfig libnih dbus ];

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc/"
    "--localstatedir=/var"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://linuxcontainers.org/cgmanager/introduction/;
    description = "a central privileged daemon that manages all your cgroups";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
