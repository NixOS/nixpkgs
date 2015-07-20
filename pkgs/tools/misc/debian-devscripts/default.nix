{stdenv, fetchurl, perl, CryptSSLeay, LWP, unzip, xz, dpkg, TimeDate, DBFile
, FileDesktopEntry, libxslt, docbook_xsl, python3, setuptools, makeWrapper
, perlPackages
}:
stdenv.mkDerivation rec {
  version = "2.15.4";
  name = "debian-devscripts-${version}";
  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.xz";
    sha256 = "03ldbx07ga9df7z9yiq6grb6cms1dr8hlbis2hvbmfcs6gcr3q72";
  };
  buildInputs = [ perl CryptSSLeay LWP unzip xz dpkg TimeDate DBFile 
    FileDesktopEntry libxslt python3 setuptools makeWrapper
    perlPackages.ParseDebControl ];
  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${dpkg}";
    sed -e "s@/usr/share/sgml/[^ ]*/manpages/docbook.xsl@${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl@" -i scripts/Makefile
    sed -e 's/ translated_manpages//; s/--install-layout=deb//; s@--root="[^ ]*"@--prefix="'"$out"'"@' -i Makefile */Makefile
    tgtpy="$out/lib/${python3.libPrefix}/site-packages"
    mkdir -p "$tgtpy"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$tgtpy"
    sed -re "s@/usr( |$|/)@$out\\1@" -i Makefile* */Makefile*
    sed -re "s@/etc( |$|/)@$out/etc\\1@" -i Makefile* */Makefile*

    # Completion currently spams every shell startup with an error. Disable for now:
    sed "/\/bash_completion\.d/d" -i scripts/Makefile
  '';
  postInstall = ''
    sed -re 's@(^|[ !`"])/bin/bash@\1${stdenv.shell}@g' -i "$out/bin"/*
    for i in "$out/bin"/*; do
      wrapProgram "$i" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PERL5LIB : "$out/share/devscripts" \
        --prefix PYTHONPATH : "$out/lib/python3.4/site-packages"
    done
  '';
  meta = {
    description = ''Debian package maintenance scripts'';
    license = "GPL (various)"; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
