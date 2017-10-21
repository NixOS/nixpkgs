{ stdenv, perl, fetchurl, Error, MailDKIM, MIMEtools, NetServer }:

let
  pkg = "dkimproxy";
  version = "1.4.1";
in
stdenv.mkDerivation rec {
  name = "${pkg}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dkimproxy/${name}.tar.gz";
    sha256 = "1gc5c7lg2qrlck7b0lvjfqr824ch6jkrzkpsn0gjvlzg7hfmld75";
  };

  # Idea taken from pkgs/development/perl-modules/generic/builder.sh
  preFixup = ''
    perlFlags=
    for i in $(IFS=:; echo $PERL5LIB); do
      perlFlags="$perlFlags -I$i"
    done
    for f in $(ls $out/bin); do
      sed -i $out/bin/$f -e "s|#\!\(.*/perl.*\)$|#\! \1 $perlFlags|"
    done
  '';

  buildInputs = [ perl ];
  propagatedBuildInputs = [ Error MailDKIM MIMEtools NetServer ];

  meta = with stdenv.lib; {
    description = "SMTP-proxy that signs and/or verifies emails";
    homepage = http://dkimproxy.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ekleog ];
    platforms = platforms.all;
  };
}
