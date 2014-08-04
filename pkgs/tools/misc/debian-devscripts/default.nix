{stdenv, fetchurl, perl, CryptSSLeay, LWP, unzip, xz, dpkg, TimeDate, DBFile
  , FileDesktopEntry, libxslt, docbook_xsl, python, setuptools, makeWrapper
}:
stdenv.mkDerivation rec {
  version = "2.12.4";
  name = "debian-devscripts-${version}";
  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.gz";
    sha256 = "34bcbec78bd4fe34d9f1326b9d1477ff2410e20e2dca6b7bfbf2bf92dbb83904";
  };
  buildInputs = [ perl CryptSSLeay LWP unzip xz dpkg TimeDate DBFile 
    FileDesktopEntry libxslt python setuptools makeWrapper ];
  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${dpkg}";
    sed -e "s@/usr/share/sgml/[^ ]*/manpages/docbook.xsl@${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl@" -i scripts/Makefile
    sed -e 's/ translated_manpages//; s/--install-layout=deb//; s@--root="[^ ]*"@--prefix="'"$out"'"@' -i Makefile */Makefile
    tgtpy="$out/lib/${python.libPrefix}/site-packages"
    mkdir -p "$tgtpy"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$tgtpy"
    sed -re "s@/usr( |$|/)@$out\\1@" -i Makefile* */Makefile*
    sed -re "s@/etc( |$|/)@$out/etc\\1@" -i Makefile* */Makefile*
  '';
  postInstall = ''
    sed -re 's@(^|[ !`"])/bin/bash@\1${stdenv.shell}@g' -i "$out/bin"/*
    for i in "$out/bin"/*; do
      wrapProgram "$i" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PERL5LIB : "$out/share/devscripts"
    done
  '';
  meta = {
    description = ''Debian package maintenance scripts'';
    license = "GPL (various)"; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
