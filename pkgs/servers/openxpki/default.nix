{ stdenv, fetchgit, perl, openssl, perlPackages, gettext, python3Packages
# TODO: Remove extra dependencies once it is clear that they are NOT needed somewhere.
, extraDependencies1 ? false, extraDependencies2 ? false, extraDependencies3 ? false }:

perlPackages.buildPerlPackage {
  name = "openxpki-git20150807";

  src = fetchgit {
    url = "https://github.com/openxpki/openxpki";
    rev = "5cb76c553b6b1a81ede380857700628a7521f6e3";
    sha256 = "05bmhani2c7ays488xv3hx5xbxb612bnwq5rdjwmsj51xpaz454p";
  };

  buildInputs = [ perl openssl gettext python3Packages.sphinx ];
  propagatedBuildInputs = with perlPackages;
    [ # dependencies from Makefile.PL
      libintl_perl ConfigVersioned LWP ClassAccessorChained IOSocketSSL ClassStd
      CGISession ConfigStd ConfigMerge Connector CryptCBC CryptOpenSSLAES CryptPKCS10
      DBDMock DataPassword DataSerializer DateTimeFormatDateParse IOPrompt
      IPCShareLite JSON LogLog4perl LWPProtocolConnect LWPProtocolHttps MailRFC822Address
      Moose NetAddrIP NetDNS NetIP perlldap NetHTTP NetServer NetSSLeay ParamsValidate PathClass
      ProcProcessTable ProcSafeExec RegexpCommon SOAPLite Switch SysSigAction TemplateToolkit
      TestPod TestPodCoverage TextCSV_XS Workflow XMLFilterXInclude XMLParser
      XMLSAX XMLSAXWriter XMLSimple XMLValidatorSchema ]
    ++ stdenv.lib.optionals extraDependencies1
    [ # dependencies from parsing through core/server
      ClassAccessor PathTools DataDumper DateTime DateTimeFormatStrptime DBI
      Encode ExceptionClass FilePath FileTemp Filter GetoptLong HTMLParser
      ScalarListUtils MathBigInt Memoize libnet RTClientREST
      Storable ]
    ++ stdenv.lib.optionals extraDependencies2
    [ # dependencies taken from Debian
      MooseXTypesPathClass DataStreamBulk MooseXStrictConstructor GitPurePerl
      ConfigGitLike DevelStackTrace TreeDAGNode ClassObservable ClassFactory TimeDate ConfigAny
      CGIFast ClassISA YAML YAMLLibYAML AuthenSASL TextCSV FileFindRulePerl IODigest ]
    ++ stdenv.lib.optionals extraDependencies3
    [ # dependencies taken from https://metacpan.org/pod/release/ALECH/Bundle-OpenXPKI-0.06/lib/Bundle/OpenXPKI.pm
      AttributeParamsValidate BC CGI CPAN CacheCache ClassClassgenclassgen
      ClassContainer ClassDataInheritable ClassSingleton ConvertASN1 DBDSQLite DBIxHTMLViewLATEST
      DBFile DataPage DataSpreadPagination DateTimeLocale DateTimeTimeZone DevelPPPort
      DevelSymdump DigestSHA1 Env Error ExtUtilsConstant ExtUtilsInstall
      ExtUtilsMakeMaker FileCheckTree GoferTransporthttp HTMLMason HTMLTagset
      HTTPServerSimpleMason IO IPCSysV LocaleCodes LogDispatch MathBigRat
      MathRound ModuleBuild ModuleBuildDeprecated NetPing PodChecker
      PodCoverage PodLaTeX PodParser PodPerldoc PodPlainer PodSimple
      SubUplevel SysSyslog TemplatePluginAutoformat TermReadKey TestException
      TestHTTPServerSimple TestHarnessStraps TextBalanced TextIconv TextSoundex
      ThreadQueue TieFile TieRefHash TimeLocal URI
      UnicodeNormalize WWWMechanize Want XMLFilterBufferText XMLNamespaceSupport bignum
      libapreq2 libnet podlators threadsshared version ];

  preConfigure = ''
    substituteInPlace core/server/Makefile.PL \
      --replace "my \$openssl_inc_dir = ''';" "my \$openssl_inc_dir = '${openssl.dev}/include';" \
      --replace "my \$openssl_lib_dir = ''';" "my \$openssl_lib_dir = '${openssl.out}/lib';" \
      --replace "my \$openssl_binary  = ''';" "my \$openssl_binary  = '${openssl.bin}/bin/openssl';"
    substituteInPlace tools/vergen --replace "#!/usr/bin/perl" "#!${perl}/bin/perl"
    cp ${./vergen_revision_state} .vergen_revision_state
    cd core/server
    '';

  postInstall = ''
    mkdir -p $out/share/openxpki
    cp -r ../htdocs_source $out/share/openxpki/.
    cp -r ../../config $out/share/openxpki/.
    cp -r ../../qatest $out/share/openxpki/.
    (cd ../i18n; make scan; make; make install PREFIX=$out)
    (cd ../../clients/perl/OpenXPKI-Client-Enrollment; perl Makefile.PL PREFIX=$out; make; make install PREFIX=$out)
    (cd ../../doc; make html man; cp _build/man/* $out/share/man/man1/.; mkdir -p $out/share/openxpki/doc; cp -r _build/{html,doctrees} $out/share/openxpki/doc/.)
    '';

  doCheck = false;

  meta = {
    homepage = http://www.openxpki.org;
    description = "Enterprise-grade PKI/Trustcenter software";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
