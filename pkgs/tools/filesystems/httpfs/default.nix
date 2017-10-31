{ fetchurl, stdenv, pkgconfig, fuse, openssl, asciidoc
, docbook_xml_dtd_45, docbook_xsl , libxml2, libxslt }:

stdenv.mkDerivation rec {
  name = "httpfs2-0.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/httpfs/httpfs2/${name}.tar.gz";
    sha256 = "1h8ggvhw30n2r6w11n1s458ypggdqx6ldwd61ma4yd7binrlpjq1";
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

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
