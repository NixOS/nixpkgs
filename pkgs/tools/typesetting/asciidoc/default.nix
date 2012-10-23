{ fetchurl, stdenv, python }:

stdenv.mkDerivation rec {
  name = "asciidoc-8.6.8";
  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "ffb67f59dccaf6f15db72fcd04fdf21a2f9b703d31f94fcd0c49a424a9fcfbc4";
  };

  patchPhase = ''
    for n in `find . -name \*.py `; do
      sed -i -e "s,^#!/usr/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
    sed -i -e "s,/etc/vim,,g" Makefile.in
  '';

  preInstall = "mkdir -p $out/etc/vim";

  buildInputs = [ python ];

  meta = {
    homepage = "http://www.methods.co.nz/asciidoc/";
    description = "ASCII text-based document generation system";
    license = "GPLv2+";

    longDescription = ''
      AsciiDoc is a text-based document generation system.  AsciiDoc
      input files can be translated to HTML and DocBook markups.
    '';
  };
}
