{ lib, stdenv, autoreconfHook, buildEnv, fetchFromGitHub, perl, perlPackages, makeWrapper, gnupg, openssl }:

stdenv.mkDerivation rec {
  pname = "rt";
  version = "5.0.3";

  src = fetchFromGitHub {
    repo = pname;
    rev = "${pname}-${version}";
    owner = "bestpractical";
    hash = "sha256-ZitlueLEbV3mGJg0aDrLa5IReJiOVaEf+JicbA9zUS4=";
  };

  patches = [
    ./dont-check-users_groups.patch  # needed for "make testdeps" to work in the build
    ./override-generated.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  buildInputs = [
    perl
    (buildEnv {
      name = "rt-perl-deps";
      paths = with perlPackages; (requiredPerlModules [
        ApacheSession
        BusinessHours
        CGIEmulatePSGI
        CGIPSGI
        CSSMinifierXS
        CSSSquish
        ConvertColor
        CryptEksblowfish
        CryptSSLeay
        CryptX509
        DBDPg
        DBIxSearchBuilder
        DataGUID
        DataICal
        DataPage
        DataPagePageset
        DateExtract
        DateManip
        DateTimeFormatNatural
        DevelGlobalDestruction
        EmailAddress
        EmailAddressList
        EncodeDetect
        EncodeHanExtra
        FCGI
        FCGIProcManager
        FileShareDir
        FileWhich
        GD
        GDGraph
        GnuPGInterface
        GraphViz
        HTMLFormatExternal
        HTMLFormatTextWithLinks
        HTMLFormatTextWithLinksAndTables
        HTMLGumbo
        HTMLMason
        HTMLMasonPSGIHandler
        HTMLQuoted
        HTMLRewriteAttributes
        HTMLScrubber
        IPCRun
        IPCRun3
        JSON
        JavaScriptMinifierXS
        LWP
        LWPProtocolHttps
        LocaleMaketextFuzzy
        LocaleMaketextLexicon
        LogDispatch
        MIMETools
        MIMETypes
        MailTools
        ModulePath
        ModuleRefresh
        ModuleVersionsReport
        Moose
        MooseXNonMoose
        MooseXRoleParameterized
        MozillaCA
        NetCIDR
        NetIP
        ParallelForkManager
        PathDispatcher
        PerlIOeol
        Plack
        PodParser
        RegexpCommon
        RegexpCommonnetCIDR
        RegexpIPv6
        RoleBasic
        ScopeUpper
        Starlet
        Starman
        StringShellQuote
        SymbolGlobalName
        TermReadKey
        TextPasswordPronounceable
        TextQuoted
        TextTemplate
        TextWikiFormat
        TextWordDiff
        TextWrapper
        TimeParseDate
        TreeSimple
        UNIVERSALrequire
        WebMachine
        XMLRSS
        perlldap
      ]);
    })
  ];

  preAutoreconf = ''
    echo rt-${version} > .tag
  '';
  preConfigure = ''
    configureFlags="$configureFlags --with-web-user=$UID"
    configureFlags="$configureFlags --with-web-group=$(id -g)"
    configureFlags="$configureFlags --with-rt-group=$(id -g)"
    configureFlags="$configureFlags --with-bin-owner=$UID"
    configureFlags="$configureFlags --with-libs-owner=$UID"
    configureFlags="$configureFlags --with-libs-group=$(id -g)"
  '';
  configureFlags = [
    "--enable-graphviz"
    "--enable-gd"
    "--enable-gpg"
    "--enable-smime"
    "--with-db-type=Pg"
  ];

  buildPhase = ''
    make testdeps
  '';

  postFixup = ''
    for i in $(find $out/bin -type f); do
      wrapProgram $i --prefix PERL5LIB ':' $PERL5LIB \
        --prefix PATH ":" "${lib.makeBinPath [ openssl gnupg ]}"
    done

    rm -r $out/var
    mkdir -p $out/var/data
    ln -s /var/log/rt $out/var/log
    ln -s /run/rt/mason_data $out/var/mason_data
    ln -s /var/lib/rt/shredder $out/var/data/RT-Shredder
    ln -s /var/lib/rt/smime $out/var/data/smime
    ln -s /var/lib/rt/gpg $out/var/data/gpg
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
