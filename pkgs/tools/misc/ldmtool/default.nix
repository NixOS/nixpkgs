{ stdenv, fetchFromGitHub, autoconf, automake, gtk-doc, pkgconfig, libuuid,
  libtool, readline, gobject-introspection, json-glib, lvm2, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
   name = "ldmtool-${version}";
   version = "0.2.4";

   src = fetchFromGitHub {
     owner = "mdbooth";
     repo = "libldm";
     rev = "libldm-${version}";
     sha256 = "1fy5wbmk8kwl86lzswq0d1z2j5y023qzfm2ppm8knzv9c47kniqk";
   };

   preConfigure = ''
     sed -i docs/reference/ldmtool/Makefile.am \
       -e 's|-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|--nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl|g'
   '';

   # ldm.c:951:5: error: 'g_type_class_add_private' is deprecated [-Werror=deprecated-declarations]
   NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

   configureScript = "sh autogen.sh";

   nativeBuildInputs = [ pkgconfig ];
   buildInputs = [ autoconf automake gtk-doc lvm2 libxslt.bin
     libtool readline gobject-introspection json-glib libuuid
   ];

   meta = with stdenv.lib; {
     description = "Tool and library for managing Microsoft Windows Dynamic Disks";
     homepage = https://github.com/mdbooth/libldm;
     maintainers = with maintainers; [ jensbin ];
     license = licenses.gpl3;
     platforms = platforms.linux;
   };
}
