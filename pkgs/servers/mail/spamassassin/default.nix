{ stdenv, fetchurl, buildPerlPackage, perl, HTMLParser, NetDNS, NetAddrIP, DBFile
, HTTPDate, MailDKIM, makeWrapper
}:

# TODO:
#
#  - Mail::SPF
#  - IP::Country
#  - Razor2
#  - Net::Ident
#  - DBI
#  - LWP::UserAgent
#  - Encode::Detect

buildPerlPackage rec {
  name = "SpamAssassin-3.3.2";

  src = fetchurl {
    url = "http://apache.imsam.info/spamassassin/source/Mail-${name}.tar.bz2";
    sha256 = "01d2jcpy423zfnhg123wlhzysih1hmb93nxfspiaajzh9r5rn8y7";
  };

  buildInputs = [ makeWrapper HTMLParser NetDNS NetAddrIP DBFile HTTPDate
    MailDKIM ];

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = "PERL_BIN=${perl}/bin/perl PERL_TAINT=no";

  makeMakerFlags = "CONFDIR=/etc/spamassassin LOCALSTATEDIR=/var/lib/spamassassin";

  doCheck = false;

  postInstall = ''
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  meta = {
    homepage = "http://spamassassin.apache.org/";
    description = "Open-Source Spam Filter";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
