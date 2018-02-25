{ stdenv, fetchFromGitHub, substituteAll, libtool, pkgconfig, intltool, gnused
, gnome3, gtk-doc, acl, systemd, glib, libatasmart, polkit, coreutils, bash
, expat, libxslt, docbook_xsl, utillinux, mdadm, libgudev, libblockdev, parted
, gobjectIntrospection, docbook_xml_dtd_43
}:

let
  version = "2.7.6";
in stdenv.mkDerivation rec {
  name = "udisks-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "udisks";
    rev = name;
    sha256 = "16kf104vv2xbk8cdgaqygszcl69d7lz9gf3vmi7ggywn7nfbp2ks";
  };

  outputs = [ "out" "man" "dev" "devdoc" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      parted = "${parted}/bin/parted";
      mdadm = "${mdadm}/bin/mdadm";
      blkid = "${utillinux}/bin/blkid";
      sh = "${bash}/bin/sh";
      bash = "${bash}/bin/bash";
      sed = "${gnused}/bin/sed";
      true = "${coreutils}/bin/true";
      sleep = "${coreutils}/bin/sleep";
      false = "${coreutils}/bin/false";
    })
  ];

  nativeBuildInputs = [
    pkgconfig gnome3.gnome-common libtool intltool gobjectIntrospection
    gtk-doc libxslt docbook_xml_dtd_43 docbook_xsl
  ];

  buildInputs = [
    expat libgudev libblockdev acl systemd glib libatasmart polkit
  ];

  preConfigure = "./autogen.sh";

  configureFlags = [
    "--enable-gtk-doc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(dev)/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  meta = with stdenv.lib; {
    description = "A daemon, tools and libraries to access and manipulate disks, storage devices and technologies";
    homepage = https://www.freedesktop.org/wiki/Software/udisks/;
    license = licenses.gpl2Plus; # lgpl2Plus for the library, gpl2Plus for the tools & daemon
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
