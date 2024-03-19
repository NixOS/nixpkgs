{ lib, stdenv, perlPackages, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dkimproxy";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/dkimproxy/${pname}-${version}.tar.gz";
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

  buildInputs = [ perlPackages.perl ];
  propagatedBuildInputs = with perlPackages; [ CryptX Error MailDKIM MIMETools NetServer ];

  meta = with lib; {
    description = "SMTP-proxy that signs and/or verifies emails";
    homepage = "https://dkimproxy.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ekleog ];
    platforms = platforms.all;
  };
}
