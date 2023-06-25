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
  buildInputs = (with perlPackages; [
    HTMLParser NetCIDRLite NetDNS NetAddrIP DBFile HTTPDate MailDKIM LWP
    LWPProtocolHttps IOSocketSSL DBI EncodeDetect IPCountry NetIdent
    Razor2ClientAgent MailSPF NetDNSResolverProgrammable Socket6
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

  postInstall = ''
    mkdir -p $out/share/spamassassin
    mv "rules/"* $out/share/spamassassin/

    for n in "$out/bin/"*; do
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
