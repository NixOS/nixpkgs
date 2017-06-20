{ stdenv, fetchurl, buildPerlPackage, perl, perlPackages, HTMLParser, NetDNS, NetAddrIP, DBFile
, HTTPDate, MailDKIM, LWP, IOSocketSSL, makeWrapper, gnupg1
}:

buildPerlPackage rec {
  name = "SpamAssassin-3.4.1";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${name}.tar.bz2";
    sha256 = "0la6s5ilamf9129kyjckcma8cr6fpb6b5f2fb64v7106iy0ckhd0";
  };

  # https://bz.apache.org/SpamAssassin/show_bug.cgi?id=7434
  patches = [ ./sa-update_add--siteconfigpath.patch ];

  buildInputs = with perlPackages; [ makeWrapper HTMLParser NetDNS NetAddrIP DBFile HTTPDate MailDKIM
    LWP IOSocketSSL DBI EncodeDetect IPCountry NetIdent Razor2ClientAgent MailSPF NetDNSResolverProgrammable ];

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = "PERL_BIN=${perl}/bin/perl PERL_TAINT=no";

  makeMakerFlags = "CONFDIR=/homeless/shelter LOCALSTATEDIR=/var/lib/spamassassin";

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/spamassassin
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
    maintainers = with stdenv.lib.maintainers; [ peti qknight ];
  };
}
