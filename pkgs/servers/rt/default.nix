{ stdenv, buildEnv, fetchurl, perl, perlPackages, makeWrapper }:

# This package isn't extremely useful as it is, but is getting close.
# After running:
#
#   nix-build . -A rt
#
# I created a config file named myconfig.pm with:
#
#   use utf8;
#   Set($rtname, '127.0.0.1');
#   # These dirs need to be pre-created:
#   Set($MasonSessionDir, '/home/grahamc/foo/sessiondir/');
#   Set($MasonDataDir, '/home/grahamc/foo/localstate/');
#   Set($WebPort, 8080);
#
#   Set($DatabaseType, "SQLite");
#   Set( $DatabaseName, '/home/grahamc/projects/foo/my.db' );
#
#   1;
#
# and ran
#
#  RT_SITE_CONFIG=$(pwd)/myconfig.pm ./result/bin/rt-setup-database --action init
#
# Then:
#
#   RT_SITE_CONFIG=$(pwd)/myconfig.pm ./result/bin/rt-server
#
# Make sure to check out result/etc/RT_Config.pm
#
# Good luck.
stdenv.mkDerivation rec {
  name = "rt-${version}";

  version = "4.4.3";

  src = fetchurl {
    url = "https://download.bestpractical.com/pub/rt/release/${name}.tar.gz";
    sha256 = "1cddgp3j7qm7r3v5j1l1hl6i6laxa64f4nalaarj094hmhyb92kk";
  };

  patches = [ ./override-generated.patch ];

  buildInputs = [
    makeWrapper
    perl
    (buildEnv {
      name = "rt-perl-deps";
      paths = (with perlPackages; [
        ApacheSession BusinessHours CGIEmulatePSGI CGIPSGI
        CSSMinifierXP CSSSquish ConvertColor CryptEksblowfish
        CryptSSLeay DBDSQLite DBDmysql DBIxSearchBuilder DataGUID
        DataICal DataPagePageset DateExtract DateManip
        DateTimeFormatNatural DevelGlobalDestruction EmailAddress
        EmailAddressList FCGI FCGIProcManager FileShareDir FileWhich
        GD GDGraph GnuPGInterface GraphViz HTMLFormatTextWithLinks
        HTMLFormatTextWithLinksAndTables HTMLMason
        HTMLMasonPSGIHandler HTMLQuoted HTMLRewriteAttributes
        HTMLScrubber IPCRun IPCRun3 JSON JavaScriptMinifierXS LWP
        LWPProtocolHttps LocaleMaketextFuzzy LocaleMaketextLexicon
        LogDispatch MIMETools MIMETypes MailTools ModuleRefresh
        ModuleVersionsReport MozillaCA NetCIDR NetIP PerlIOeol Plack
        RegexpCommon RegexpCommonnetCIDR RegexpIPv6 RoleBasic
        ScopeUpper Starlet SymbolGlobalName TermReadKey
        TextPasswordPronounceable TextQuoted TextTemplate
        TextWikiFormat TextWrapper TimeParseDate TreeSimple
        UNIVERSALrequire XMLRSS
      ]);
    })
  ];

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
    "--with-db-type=SQLite"
  ];

  buildPhase = ''
    make testdeps | grep -i missing | sort
  '';

  preFixup = ''
    for i in $(find $out/bin -type f; find $out/sbin -type f); do
      wrapProgram $i \
          --prefix PERL5LIB ':' $PERL5LIB
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
