{ stdenv, fetchurl, buildPerlPackage, perl, HTMLParser, NetDNS, NetAddrIP, DBFile
, HTTPDate, MailDKIM, LWP, IOSocketSSL, makeWrapper, gnupg1
}:

# TODO: Add the Perl modules ...
#
#   DBI
#   Encode::Detect
#   IP::Country::Fast
#   Mail::SPF
#   Net::Ident
#   Razor2::Client::Agent
#

buildPerlPackage rec {
  name = "SpamAssassin-3.4.0";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${name}.tar.bz2";
    sha256 = "0527rv6m5qd41l756fqh9q7sm9m2xfhhy2jchlhbmd39x6x3jfsm";
  };

  buildInputs = [ makeWrapper HTMLParser NetDNS NetAddrIP DBFile HTTPDate MailDKIM
    LWP IOSocketSSL ];

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = "PERL_BIN=${perl}/bin/perl PERL_TAINT=no";

  makeMakerFlags = "CONFDIR=/etc/spamassassin LOCALSTATEDIR=/var/lib/spamassassin";

  doCheck = false;

  postInstall = ''
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB" --prefix PATH : "${gnupg1}/bin"
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
