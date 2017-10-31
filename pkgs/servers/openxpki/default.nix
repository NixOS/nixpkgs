{ stdenv, buildPerlPackage, fetchgit, perl, openssl, perlPackages, gettext, python34Packages
# TODO: Remove extra dependencies once it is clear that they are NOT needed somewhere.
, extraDependencies1 ? false, extraDependencies2 ? false, extraDependencies3 ? false }:

buildPerlPackage {
  name = "openxpki-git20150807";

  src = fetchgit {
    url = "https://github.com/openxpki/openxpki";
    rev = "5cb76c553b6b1a81ede380857700628a7521f6e3";
    sha256 = "05bmhani2c7ays488xv3hx5xbxb612bnwq5rdjwmsj51xpaz454p";
  };

  buildInputs = [ perl openssl gettext python34Packages.sphinx ];
  propagatedBuildInputs = with perlPackages;
    [ # dependencies from Makefile.PL
      libintlperl ConfigVersioned LWP TestSimple ClassAccessorChained IOSocketSSL ClassStd
      CGISession ConfigStd ConfigMerge Connector CryptCBC CryptOpenSSLAES CryptPKCS10
      DBDMock DataPassword DataSerializer DateTimeFormatDateParse IOPrompt
      IPCShareLite JSON Log4Perl LWPProtocolconnect LWPProtocolhttps MailRFC822Address
      Moose NetAddrIP NetDNS NetIP NetLDAP NetHTTP NetServer NetSSLeay ParamsValidate PathClass
      ProcProcessTable ProcSafeExec RegexpCommon SOAPLite Switch SysSigAction TemplateToolkit
      TestPod TestPodCoverage TextCSV_XS TimeHiRes Workflow XMLFilterXInclude XMLParser
      XMLSAX XMLSAXWriter XMLSimple XMLValidatorSchema ]
    ++ stdenv.lib.optionals extraDependencies1
    [ # dependencies from parsing through core/server
      ClassAccessor Carp PathTools DataDumper DateTime DateTimeFormatStrptime DBI DigestMD5
      DigestSHA Encode ExceptionClass Exporter FilePath FileTemp Filter GetoptLong HTMLParser
      ScalarListUtils MathBigInt Memoize MIMEBase64 NetSMTP PodUsage RTClientREST Socket
      Storable XSLoader ]
    ++ stdenv.lib.optionals extraDependencies2
    [ # dependencies taken from Debian
      MooseXTypesPathClass DataStreamBulk MooseXStrictConstructor NamespaceAutoclean GitPurePerl
      ConfigGitLike DevelStackTrace TreeDAGNode ClassObservable ClassFactory TimeDate ConfigAny
      CGIFast ClassISA YAML YAMLLibYAML AuthenSASL TextCSV FileFindRulePerl IODigest ]
    ++ stdenv.lib.optionals extraDependencies3
    [ # dependencies taken from http://search.cpan.org/~alech/Bundle-OpenXPKI-0.06/lib/Bundle/OpenXPKI.pm
      AttributeHandlers AttributeParamsValidate AutoLoader BC CGI CPAN CacheCache ClassClassgenclassgen
      ClassContainer ClassDataInheritable ClassSingleton ConvertASN1 DBDSQLite DBIxHTMLViewLATEST
      DBFile DataPage DataSpreadPagination DateTimeLocale DateTimeTimeZone DevelPPPort DevelSelfStubber
      DevelSymdump Digest DigestSHA1 Env Error ExtUtilsCommand ExtUtilsConstant ExtUtilsInstall
      ExtUtilsMakeMaker FileCheckTree FilterSimple GoferTransporthttp HTMLMason HTMLTagset
      HTTPServerSimpleMason I18NCollate IO IPCSysV LocaleCodes LocaleMaketext LogDispatch MathBigRat
      MathComplex MathRound ModuleBuild ModuleBuildDeprecated NetPing PerlIOviaQuotedPrint PodChecker
      PodCoverage PodEscapes PodLaTeX PodParser PodPerldoc PodPlainer PodSimple Safe SearchDict SelfLoader
      SubUplevel SysSyslog TemplatePluginAutoformat TermANSIColor TermCap TermReadKey Test TestException
      TestHTTPServerSimple TestHarness TestHarnessStraps TextAbbrev TextBalanced TextIconv TextSoundex
      TextTabsWrap ThreadQueue ThreadSemaphore TieFile TieRefHash TimeLocal URI UnicodeCollate
      UnicodeNormalize WWWMechanize Want XMLFilterBufferText XMLNamespaceSupport autodie base bignum if_
      lib libapreq2 libnet podlators threads threadsshared version ];

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
