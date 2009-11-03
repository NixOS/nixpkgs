{ fetchurl, stdenv, python }:

stdenv.mkDerivation rec {
  name = "asciidoc-8.5.1";
  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "ccb02db04e6e6eff2149435516e88557ca30c85bc4467420f40c895e25f17a20";
  };

  patchPhase = ''
    for n in asciidoc.py a2x.py; do
      sed -i -e "s,^#!/usr/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
  '';

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
