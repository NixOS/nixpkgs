{stdenv, fetchurl, perl, CryptSSLeay, LWP, unzip, xz, dpkg, TimeDate, DBFile
, FileDesktopEntry, libxslt, docbook_xsl, python3, setuptools, makeWrapper
, perlPackages, curl, gnupg, diffutils
, sendmailPath ? "/var/setuid-wrappers/sendmail"
}:

stdenv.mkDerivation rec {
  version = "2.16.4";
  name = "debian-devscripts-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.xz";
    sha256 = "0hxvxf8fc76lmrf57l9liwx1xjbxk2ldamln8xnwqlg37laxi3v2";
  };

  buildInputs = [ perl CryptSSLeay LWP unzip xz dpkg TimeDate DBFile 
    FileDesktopEntry libxslt python3 setuptools makeWrapper
    perlPackages.ParseDebControl perlPackages.LWPProtocolHttps
    curl gnupg diffutils ];

  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${dpkg}";
    tgtpy="$out/lib/${python3.libPrefix}/site-packages"
    mkdir -p "$tgtpy"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$tgtpy"
    find po4a scripts -type f -exec sed -r \
      -e "s@/usr/bin/gpg(2|)@${gnupg}/bin/gpg2@g" \
      -e "s@/usr/(s|)bin/sendmail@${sendmailPath}@g" \
      -e "s@/usr/bin/diff@${diffutils}/bin/diff@g" \
      -e "s@/usr/bin/gpgv(2|)@${gnupg}/bin/gpgv2@g" \
      -e "s@(command -v|/usr/bin/)curl@${curl.bin}/bin/curl@g" \
      -i {} +
    sed -e "s@/usr/share/sgml/[^ ]*/manpages/docbook.xsl@${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl@" -i scripts/Makefile
    sed -r \
      -e "s@/usr( |$|/)@$out\\1@g" \
      -e "s@/etc( |$|/)@$out/etc\\1@g" \
      -e 's/ translated_manpages//; s/--install-layout=deb//; s@--root="[^ ]*"@--prefix="'"$out"'"@' \
      -i Makefile* */Makefile*
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "COMPL_DIR=/share/bash-completion/completions"
    "PERLMOD_DIR=/share/devscripts"
  ];

  postInstall = ''
    sed -re 's@(^|[ !`"])/bin/bash@\1${stdenv.shell}@g' -i "$out/bin"/*
    for i in "$out/bin"/*; do
      wrapProgram "$i" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PERL5LIB : "$out/share/devscripts" \
        --prefix PYTHONPATH : "$out/lib/python3.4/site-packages"
    done
  '';

  meta = with stdenv.lib; {
    description = ''Debian package maintenance scripts'';
    license = licenses.free; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with maintainers; [raskin];
  };
}
