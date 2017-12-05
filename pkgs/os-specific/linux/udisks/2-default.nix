{ stdenv, fetchurl, pkgconfig, intltool, gnused
, expat, acl, systemd, glib, libatasmart, polkit
, libxslt, docbook_xsl, utillinux, mdadm, libgudev
}:

stdenv.mkDerivation rec {
  name = "udisks-2.1.6";

  src = fetchurl {
    url = "http://udisks.freedesktop.org/releases/${name}.tar.bz2";
    sha256 = "0spl155k0g2l2hvqf8xyjv08i68gfyhzpjva6cwlzxx0bz4gbify";
  };

  outputs = [ "out" "man" ];

  patches = [ ./force-path.patch ];

  # FIXME remove /var/run/current-system/sw/* references
  # FIXME add references to parted, cryptsetup, etc (see the sources)
  postPatch =
    ''
      substituteInPlace src/main.c --replace \
        "@path@" \
        "${utillinux}/bin:${mdadm}/bin:/run/current-system/sw/bin"
      substituteInPlace data/80-udisks2.rules \
        --replace "/bin/sh" "${stdenv.shell}" \
        --replace "/sbin/mdadm" "${mdadm}/bin/mdadm" \
        --replace " sed " " ${gnused}/bin/sed "
    '';

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ libxslt docbook_xsl libgudev expat acl systemd glib libatasmart polkit ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
  ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
