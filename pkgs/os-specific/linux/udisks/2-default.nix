{ stdenv, fetchurl, pkgconfig, intltool
, expat, acl, udev, glib, libatasmart, polkit
, libxslt, docbook_xsl, utillinux, mdadm
}:

stdenv.mkDerivation rec {
  name = "udisks-2.1.0";

  src = fetchurl {
    url = "http://udisks.freedesktop.org/releases/${name}.tar.bz2";
    sha256 = "1a0mipihilscv9jwy59xrqn2kkri9p12a09anpjdld83l7jhh0ii";
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

  propagatedBuildInputs = [ expat acl udev glib libatasmart polkit ]; # in closure anyway

  buildInputs = [ libxslt docbook_xsl ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/systemd"
    "--with-udevdir=$(out)/lib/udev"
  ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
