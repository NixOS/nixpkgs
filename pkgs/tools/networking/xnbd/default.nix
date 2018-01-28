{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, jansson, asciidoc, libxml2, libxslt, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  name = "xnbd-0.4.0";

  src = fetchurl {
    url = "https://bitbucket.org/hirofuchi/xnbd/downloads/${name}.tgz";
    sha256 = "00wkvsa0yaq4mabczcbfpj6rjvp02yahw8vdrq8hgb3wpm80x913";
  };

  sourceRoot = "${name}/trunk";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ glib jansson asciidoc libxml2 libxslt docbook_xml_dtd_45 ];

  meta = {
    homepage = https://bitbucket.org/hirofuchi/xnbd;
    description = "Yet another NBD (Network Block Device) server program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.volth ];
    platforms = stdenv.lib.platforms.linux;
  };
}
