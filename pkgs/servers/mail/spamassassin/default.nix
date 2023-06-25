{ lib, fetchurl, perlPackages, makeWrapper, gnupg, re2c, gcc, gnumake, libxcrypt }:

perlPackages.buildPerlPackage rec {
  pname = "SpamAssassin";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${pname}-${version}.tar.bz2";
    hash = "sha256-5aoXBQowvHK6qGr9xgSMrepNHsLsxh14dxegWbgxnog=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (with perlPackages; [
    HTMLParser NetCIDRLite NetDNS NetAddrIP DBFile HTTPDate MailDKIM LWP
    LWPProtocolHttps IOSocketSSL DBI EncodeDetect IPCountry NetIdent
    Razor2ClientAgent MailSPF NetDNSResolverProgrammable Socket6
  ]);

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = [ "PERL_BIN=${perlPackages.perl}/bin/perl" "PERL_TAINT=no" ];

  makeMakerFlags = [ "SYSCONFDIR=/etc LOCALSTATEDIR=/var/lib/spamassassin" ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/spamassassin
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB" --prefix PATH : ${lib.makeBinPath [ gnupg re2c gcc gnumake ]} --prefix C_INCLUDE_PATH : ${lib.makeSearchPathOutput "include" "include" [ libxcrypt ]}
    done
  '';

  meta = {
    homepage = "https://spamassassin.apache.org/";
    description = "Open-Source Spam Filter";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qknight qyliss ];
  };
}
