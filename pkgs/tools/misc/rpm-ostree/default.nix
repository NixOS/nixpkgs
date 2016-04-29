{ stdenv, fetchFromGitHub, ostree, rpm, which, autoconf, automake, libtool, pkgconfig,
  libcap, glib, libgsystem, json_glib, libarchive, libhif, librepo, gtk_doc, elfutils,
  libxslt, docbook_xsl, docbook_xml_dtd_42, acl }:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "08ae6639e522e9b11765245fbecdbbe474ccde98";
    sha256 = "1k7fbivi2mwb2x5bqqbqc3nbnfjjw1l911hs914197hyqpy21dab";
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
}

