{ stdenv, fetchFromGitHub, substituteAll, libtool, pkgconfig, intltool, gnused
, gnome3, gtk-doc, acl, systemd, glib, libatasmart, polkit, coreutils, bash
, expat, libxslt, docbook_xsl, utillinux, mdadm, libgudev, libblockdev, parted
, gobjectIntrospection, docbook_xml_dtd_412, docbook_xml_dtd_43
, libxfs, f2fs-tools, dosfstools, e2fsprogs, btrfs-progs, exfat, nilfs-utils, ntfs3g
}:

let
  version = "2.8.0";
in stdenv.mkDerivation rec {
  name = "udisks-${version}";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "udisks";
    rev = name;
    sha256 = "110g3vyai3p6vjzy01yd0bbvxk7n7dl5glxf54f3jvqf0zmaqipx";
  };

  outputs = [ "out" "man" "dev" "devdoc" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      bash = "${bash}/bin/bash";
      blkid = "${utillinux}/bin/blkid";
      false = "${coreutils}/bin/false";
      mdadm = "${mdadm}/bin/mdadm";
      sed = "${gnused}/bin/sed";
      sh = "${bash}/bin/sh";
      sleep = "${coreutils}/bin/sleep";
      true = "${coreutils}/bin/true";
    })
    (substituteAll {
      src = ./force-path.patch;
      path = stdenv.lib.makeBinPath [ btrfs-progs coreutils dosfstools e2fsprogs exfat f2fs-tools nilfs-utils libxfs ntfs3g parted utillinux ];
    })
  ];

  nativeBuildInputs = [
    pkgconfig gnome3.gnome-common libtool intltool gobjectIntrospection
    gtk-doc libxslt docbook_xml_dtd_412 docbook_xml_dtd_43 docbook_xsl
  ];

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
      substituteInPlace udisks/udisksclient.c \
        --replace 'defined( __GNUC_PREREQ)' 1 \
        --replace '__GNUC_PREREQ(4,6)' 1
  '';

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

  doCheck = false; # fails

  meta = with stdenv.lib; {
    description = "A daemon, tools and libraries to access and manipulate disks, storage devices and technologies";
    homepage = https://www.freedesktop.org/wiki/Software/udisks/;
    license = licenses.gpl2Plus; # lgpl2Plus for the library, gpl2Plus for the tools & daemon
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
