{lib, stdenv, fetchurl, xz, dpkg
, libxslt, docbook_xsl, makeWrapper, writeShellScript
, python3Packages
, perlPackages, curl, gnupg, diffutils, nano, pkg-config, bash-completion, help2man
, sendmailPath ? "/run/wrappers/bin/sendmail"
}:

let
  inherit (python3Packages) python setuptools;
  sensible-editor = writeShellScript "sensible-editor" ''
    exec ''${EDITOR-${nano}/bin/nano} "$@"
  '';
in stdenv.mkDerivation rec {
  version = "2.23.5";
  pname = "debian-devscripts";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.xz";
    hash = "sha256-j0fUVTS/lPKFdgeMhksiJz2+E5koB07IK2uEj55EWG0=";
  };

  postPatch = ''
    substituteInPlace scripts/Makefile --replace /usr/share/dpkg ${dpkg}/share/dpkg
    substituteInPlace scripts/debrebuild.pl --replace /usr/bin/perl ${perlPackages.perl}/bin/perl
    patchShebangs scripts
  '';

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ xz dpkg libxslt python setuptools curl gnupg diffutils bash-completion help2man ] ++
    (with perlPackages; [ perl CryptSSLeay LWP TimeDate DBFile FileDesktopEntry ParseDebControl LWPProtocolHttps Moo FileHomeDir IPCRun FileDirList FileTouch ]);

  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${dpkg}";
    tgtpy="$out/lib/${python.libPrefix}/site-packages"
    mkdir -p "$tgtpy"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$tgtpy"
    find lib po4a scripts -type f -exec sed -r \
      -e "s@/usr/bin/gpg(2|)@${gnupg}/bin/gpg@g" \
      -e "s@/usr/(s|)bin/sendmail@${sendmailPath}@g" \
      -e "s@/usr/bin/diff@${diffutils}/bin/diff@g" \
      -e "s@/usr/bin/gpgv(2|)@${gnupg}/bin/gpgv@g" \
      -e "s@(command -v|/usr/bin/)curl@${curl.bin}/bin/curl@g" \
      -e "s@sensible-editor@${sensible-editor}@g" \
      -e "s@(^|\W)/bin/bash@\1${stdenv.shell}@g" \
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
        --prefix PYTHONPATH : "$out/${python.sitePackages}" \
        --prefix PATH : "${dpkg}/bin"
    done
    ln -s cvs-debi $out/bin/cvs-debc
    ln -s debchange $out/bin/dch
    ln -s pts-subscribe $out/bin/pts-unsubscribe
  '';

  meta = with lib; {
    description = "Debian package maintenance scripts";
    license = licenses.free; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with maintainers; [raskin];
    platforms = with platforms; linux;
  };
}
