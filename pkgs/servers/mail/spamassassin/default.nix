{ stdenv, fetchurl, perlPackages, makeWrapper, gnupg }:

perlPackages.buildPerlPackage rec {
  pname = "SpamAssassin";
  version = "3.4.3";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${pname}-${version}.tar.bz2";
    sha256 = "1380cmrgjsyidnznr844c5yr9snz36dw7xchdfryi2s61vjzvf55";
  };

  # https://bz.apache.org/SpamAssassin/show_bug.cgi?id=7434
  patches = [ ./sa-update_add--siteconfigpath.patch ];

  buildInputs = [ makeWrapper ] ++ (with perlPackages; [
    HTMLParser NetCIDRLite NetDNS NetAddrIP DBFile HTTPDate MailDKIM LWP
    IOSocketSSL DBI EncodeDetect IPCountry NetIdent Razor2ClientAgent MailSPF
    NetDNSResolverProgrammable Socket6
  ]);

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = "PERL_BIN=${perlPackages.perl}/bin/perl PERL_TAINT=no";

  makeMakerFlags = "CONFDIR=/homeless/shelter LOCALSTATEDIR=/var/lib/spamassassin";

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/spamassassin
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB" --prefix PATH : "${gnupg}/bin"
    done
  '';

  meta = {
    homepage = http://spamassassin.apache.org/;
    description = "Open-Source Spam Filter";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ peti qknight ];
  };
}
