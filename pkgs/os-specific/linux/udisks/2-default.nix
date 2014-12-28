{ stdenv, fetchurl, pkgconfig, intltool
, expat, acl, systemd, glib, libatasmart, polkit
, libxslt, docbook_xsl, utillinux, mdadm
}:

stdenv.mkDerivation rec {
  name = "udisks-2.1.4";

  src = fetchurl {
    url = "http://udisks.freedesktop.org/releases/${name}.tar.bz2";
    sha256 = "1fqrwmdyn5vc5r7wixh2f013ca1qf3kwy4ia8mh9282a7bfliqd4";
  };

  patches = [ ./force-path.patch ];

  # FIXME remove /var/run/current-system/sw/* references
  # FIXME add references to parted, cryptsetup, etc (see the sources)
  postPatch =
    ''
      substituteInPlace src/main.c --replace \
        "@path@" \
        "${utillinux}/bin:${mdadm}/sbin:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin"
    '';

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [ expat acl systemd glib libatasmart polkit ]; # in closure anyway

  buildInputs = [ libxslt docbook_xsl ];

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
