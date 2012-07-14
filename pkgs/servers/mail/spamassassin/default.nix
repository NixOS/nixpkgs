{ stdenv, fetchurl, buildPerlPackage, perl, HTMLParser, NetDNS, NetAddrIP, DBFile
, HTTPDate, MailDKIM
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

  propagatedBuildInputs = [ HTMLParser NetDNS NetAddrIP DBFile
    HTTPDate MailDKIM ];

  makeFlags = "PERL_BIN=${perl}/bin/perl";

  doCheck = false;

  meta = {
    homepage = "http://spamassassin.apache.org/";
    description = "Open-Source Spam Filter";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
