{ fetchurl, stdenv, pkgconfig, fuse, openssl, asciidoc
, docbook_xml_dtd_45, docbook_xsl , libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "httpfs2-0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/httpfs/httpfs2/${name}.tar.gz";
    sha256 = "0vlp6i119lz4ybnrd26hvvwms3h5d7x3jly5nzyyfcw24ngvpk7p";
  };

  buildInputs =
    [ pkgconfig fuse openssl
      asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
    ];

  installPhase =
    '' mkdir -p "$out/bin"
       cp -v httpfs2 "$out/bin"

       mkdir -p "$out/share/man/man1"
       cp -v *.1 "$out/share/man/man1"
    '';

  meta = {
    description = "HTTPFS2, a FUSE-based HTTP file system for Linux";

    homepage = http://httpfs.sourceforge.net/;

    license = "GPLv2+";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
