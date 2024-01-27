{ fetchurl, lib, stdenv, pkg-config, fuse, openssl, asciidoc
, docbook_xml_dtd_45, docbook_xsl , libxml2, libxslt }:

stdenv.mkDerivation rec {
  pname = "httpfs2";
  version = "0.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/httpfs/httpfs2/httpfs2-${version}.tar.gz";
    sha256 = "1h8ggvhw30n2r6w11n1s458ypggdqx6ldwd61ma4yd7binrlpjq1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ fuse openssl
      asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
    ];

  installPhase =
    '' mkdir -p "$out/bin"
       cp -v httpfs2 "$out/bin"

       mkdir -p "$out/share/man/man1"
       cp -v *.1 "$out/share/man/man1"
    '';

  meta = {
    description = "FUSE-based HTTP filesystem for Linux";

    homepage = "https://httpfs.sourceforge.net/";

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
