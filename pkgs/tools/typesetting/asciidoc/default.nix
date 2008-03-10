{ fetchurl, stdenv, python }:

stdenv.mkDerivation rec {
  name = "asciidoc-8.2.5";
  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "1aqmii7qyhnn8pby5rlyrc3sl08br35xsdn7wpx2cy03p46pqr7a";
  };

  patchPhase = ''
    cat "asciidoc.py" | \
      sed -e 's,^#!/usr/bin/env python,#!${python}/bin/python,g' \
      > ,,tmp && mv ,,tmp asciidoc.py && chmod +x asciidoc.py
    cat "a2x" | \
      sed -e 's,^#!/usr/bin/env bash,#!${stdenv.bash}/bin/bash,g' \
      > ,,tmp && mv ,,tmp a2x && chmod +x a2x

    cat "install.sh" | \
      sed -e "s,^CONFDIR=.*,CONFDIR=$out/etc/asciidoc,g" \
      > ,,tmp && mv ,,tmp install.sh
    cat "install.sh" | \
      sed -e "s,^BINDIR=.*,BINDIR=$out/bin,g" \
      > ,,tmp && mv ,,tmp install.sh
    cat "install.sh" | \
      sed -e "s,^MANDIR=.*,MANDIR=$out/man,g" \
      > ,,tmp && mv ,,tmp install.sh
    cat "install.sh" | \
      sed -e "s,^VIM_CONFDIR=.*,VIM_CONFDIR=$out/etc/vim,g" \
      > ,,tmp && mv ,,tmp install.sh

    chmod +x install.sh
  '';

  buildInputs = [ python ];
  configurePhase = ''true'';
  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/etc
    ensureDir $out/etc/vim
    ensureDir $out/man
    ./install.sh
  '';

  meta = {
    description = ''AsciiDoc is a text-based document generation system.
                    AsciiDoc input files can be translated to HTML and
		    DocBook markups'';
    homepage = http://www.methods.co.nz/asciidoc/;
    license = "GPLv2+";
  };
}