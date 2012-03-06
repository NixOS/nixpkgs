{ fetchurl, stdenv, python }:

stdenv.mkDerivation rec {
  name = "asciidoc-8.6.6";
  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "9d54c11716e4309ff4d942cf6a6d9745d6a28754ff1de01efed0dc659457ac71";
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
    longDescription = ''
      AsciiDoc is a text-based document generation system.  AsciiDoc
      input files can be translated to HTML and DocBook markups.
    '';
    homepage = http://www.methods.co.nz/asciidoc/;
    license = "GPLv2+";
  };
}
