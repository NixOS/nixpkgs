<<<<<<< HEAD
{ lib, fetchurl, perlPackages, makeBinaryWrapper, gnupg, re2c, gcc, gnumake, libxcrypt, openssl, coreutils, poppler_utils, tesseract, iana-etc }:

perlPackages.buildPerlPackage rec {
  pname = "SpamAssassin";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${pname}-${version}.tar.bz2";
    hash = "sha256-5aoXBQowvHK6qGr9xgSMrepNHsLsxh14dxegWbgxnog=";
  };

  patches = [
    ./satest-no-clean-path.patch
    ./sa_compile-use-perl5lib.patch
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
=======
{ lib, fetchurl, perlPackages, makeWrapper, gnupg, re2c, gcc, gnumake }:

perlPackages.buildPerlPackage rec {
  pname = "SpamAssassin";
  version = "3.4.6";

  src = fetchurl {
    url = "mirror://apache/spamassassin/source/Mail-${pname}-${version}.tar.bz2";
    sha256 = "044ng2aazqy8g0m17q0a4939ck1ca4x230q2q7q7jndvwkrpaj5w";
  };

  # ExtUtil::MakeMaker is bundled with Perl, but the bundled version
  # causes build errors for aarch64-darwin, so we override it with the
  # latest version.  We can drop the dependency to go back to the
  # bundled version when the version that comes with Perl is ≥7.57_02.
  #
  # Check the version bundled with Perl like this:
  #   perl -e 'use ExtUtils::MakeMaker qw($VERSION); print "$VERSION\n"'
  nativeBuildInputs = [ makeWrapper perlPackages.ExtUtilsMakeMaker ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = (with perlPackages; [
    HTMLParser NetCIDRLite NetDNS NetAddrIP DBFile HTTPDate MailDKIM LWP
    LWPProtocolHttps IOSocketSSL DBI EncodeDetect IPCountry NetIdent
    Razor2ClientAgent MailSPF NetDNSResolverProgrammable Socket6
<<<<<<< HEAD
    ArchiveZip EmailAddressXS NetLibIDN2 MaxMindDBReader GeoIP MailDMARC
    MaxMindDBReaderXS
  ]) ++ [
    openssl
  ];

  makeFlags = [ "PERL_BIN=${perlPackages.perl}/bin/perl" "ENABLE_SSL=yes" ];

  makeMakerFlags = [ "SYSCONFDIR=/etc LOCALSTATEDIR=/var/lib/spamassassin" ];

  checkInputs = (with perlPackages; [
    TextDiff  # t/strip2.t
  ]) ++ [
    coreutils  # date, t/basic_meta.t
    poppler_utils  # pdftotext, t/extracttext.t
    tesseract  # tesseract, t/extracttext.t
    iana-etc  # t/dnsbl_subtests.t (/etc/protocols used by Net::DNS::Nameserver)
    re2c gcc gnumake
  ];
  preCheck = ''
    substituteInPlace t/spamc_x_e.t \
      --replace "/bin/echo" "${coreutils}/bin/echo"
    export C_INCLUDE_PATH='${lib.makeSearchPathOutput "include" "include" [ libxcrypt ]}'
    export HARNESS_OPTIONS="j''${NIX_BUILD_CORES}"

    export HOME=$NIX_BUILD_TOP/home
    mkdir -p $HOME
    mkdir t/log  # pre-create to avoid race conditions
  '';
=======
  ]);

  # Enabling 'taint' mode is desirable, but that flag disables support
  # for the PERL5LIB environment variable. Needs further investigation.
  makeFlags = [ "PERL_BIN=${perlPackages.perl}/bin/perl" "PERL_TAINT=no" ];

  makeMakerFlags = [ "SYSCONFDIR=/etc LOCALSTATEDIR=/var/lib/spamassassin" ];

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mkdir -p $out/share/spamassassin
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
<<<<<<< HEAD
      # Skip if this isn't a perl script
      if ! head -n1 "$n" | grep -q bin/perl; then
        continue
      fi
      echo "Wrapping $n for taint mode"
      orig="$out/bin/.$(basename "$n")-wrapped"
      mv "$n" "$orig"
      # We don't inherit argv0 so that $^X works properly in e.g. sa-compile
      makeWrapper "${perlPackages.perl}/bin/perl" "$n" \
        --add-flags "-T $perlFlags $orig" \
        --prefix PATH : ${lib.makeBinPath [ gnupg re2c gcc gnumake ]} \
        --prefix C_INCLUDE_PATH : ${lib.makeSearchPathOutput "include" "include" [ libxcrypt ]}
=======
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB" --prefix PATH : ${lib.makeBinPath [ gnupg re2c gcc gnumake ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
