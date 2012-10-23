{ fetchhg, stdenv, python, autoconf, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  ver = "8.6.7";
  name = "asciidoc-${ver}";

  src = fetchhg {
    name = "hg";
    url = https://asciidoc.googlecode.com/;
    tag = "${ver}";
    sha256 = "1m0zd9b4qjnhpnhfcn4p3n2ffi1bl39lzh52li0fzxl3xqxqvfq2";
  };

  patchPhase = ''
    for n in `find . -name \*.py `; do
      sed -i -e "s,^#!/usr/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
    sed -i -e "s,/etc/vim,,g" Makefile.in
  '';

  preConfigure = ''autoconf'';

  preInstall = "mkdir -p $out/etc/vim";

  buildInputs = [ python autoconf ];
  propagatedBuildInputs = [ libxml2 libxslt docbook_xsl docbook_xml_dtd_45]; 

  meta = {
    longDescription = ''
      AsciiDoc is a text-based document generation system.  AsciiDoc
      input files can be translated to HTML and DocBook markups.
    '';
    homepage = http://www.methods.co.nz/asciidoc/;
    license = "GPLv2+";
  };
}
