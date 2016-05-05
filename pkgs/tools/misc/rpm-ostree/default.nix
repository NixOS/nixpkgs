{ stdenv, fetchFromGitHub, ostree, rpm, which, autoconf, automake, libtool, pkgconfig,
  libcap, glib, libgsystem, json_glib, libarchive, libhif, librepo, gtk_doc, elfutils,
  libxslt, docbook_xsl, docbook_xml_dtd_42, acl }:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "85c9dd5c073a8c0d74c4baa2e4a94f5535984e62";
    sha256 = "08m8wxlkymwq5hsc26k7ndwiqiw1ggaaxyi2qfhqznasgbp4g623";
  };
in stdenv.mkDerivation rec {
  rev  = "v2016.1";
  name = "rpm-ostree";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "projectatomic";
    repo   = "rpm-ostree";
    sha256 = "19jvnmy9zinx0j5nvy3h5abfv9d988kvyza09gljx16gll8qkbbf";
  };

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";

  buildInputs = [
    which autoconf automake pkgconfig libtool libcap ostree rpm glib libgsystem
    json_glib libarchive libhif librepo gtk_doc libxslt docbook_xsl docbook_xml_dtd_42
    # FIXME: get rid of this once libarchive properly propagates this
    acl
  ];

  prePatch = ''
    rmdir libglnx
    cp --no-preserve=mode -r ${libglnx-src} libglnx
  '';

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A hybrid image/package system. It uses OSTree as an image format, and uses RPM as a component model";
    homepage    = "https://rpm-ostree.readthedocs.io/en/latest/";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

