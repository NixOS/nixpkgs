{ fetchurl, stdenv, python }:

stdenv.mkDerivation rec {
  name = "asciidoc-8.6.1";
  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "1c844ahv4naghfv1jabyr8gnv2fsx4k7366vh63zx0h0w2x7ylaq";
  };

  patchPhase = ''
    for n in `find . -name \*.py `; do
      sed -i -e "s,^#!/usr/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
    sed -i -e "s,/etc/vim,,g" Makefile.in
  '';

  preInstall = "ensureDir $out/etc/vim";

  buildInputs = [ python ];

  meta = {
    longDescription = ''
      AsciiDoc is a text-based document generation system.  AsciiDoc
      input files can be translated to HTML and DocBook markups.
    '';
    homepage = http://www.methods.co.nz/asciidoc/;
    license = "GPLv2+";
  };
}
