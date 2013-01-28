/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{pkgs}:

rec {

  inherit (pkgs) buildPerlPackage fetchurl stdenv perl fetchsvn;

  # Helper functions for packages that use Module::Build to build.
  buildPerlModule = { buildInputs ? [], ... } @ args:
    buildPerlPackage (args // {
      buildInputs = buildInputs ++ [ ModuleBuild ];
      preConfigure = "touch Makefile.PL";
      buildPhase = "perl Build.PL --prefix=$out";
      installPhase = "./Build install";
      checkPhase = "./Build test";
    });


  ack = buildPerlPackage rec {
    name = "ack-1.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "8689156cb0639ff60adee47fc4b77e656cf0fc58e6c123ee6c481d9d48e99b88";
    };
    propagatedBuildInputs = [ FileNext ];
    meta = {
      description = "A grep-like tool tailored to working with large trees of source code";
      homepage = http://betterthangrep.com/;
      license = "free";  # Artistic 2.0
    };
  };

  AlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [AlgorithmDiff];
  };

  AlgorithmC3 = buildPerlModule {
    name = "Algorithm-C3-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Algorithm-C3-0.08.tar.gz;
      sha256 = "016cjr63wivg54ms6sjnxz4g75fafgvgwralamv29phcic2cl2am";
    };
    meta = {
      description = "A module for merging hierarchies using the C3 algorithm";
      license = "perl";
    };
  };

  AlgorithmDiff = buildPerlPackage rec {
    name = "Algorithm-Diff-1.1902";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1902.tar.gz;
      sha256 = "0xc315h7xwq65n9n6nq8flv5d89z6kra69hspnyccw3782zhvd68";
    };
    buildInputs = [ pkgs.unzip ];
  };

  aliased = buildPerlPackage rec {
    name = "aliased-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "1iqcbfv600m31rfvl7r9ckr0hh0vny63q7a6yyhfrh4ppcgj4ig4";
    };
  };

  AnyMoose = buildPerlPackage rec {
    name = "Any-Moose-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SARTAK/${name}.tar.gz";
      sha256 = "1kgksln1vykh0xynawv3pc3nw1yp7kjwbxbb5lh2hm21a4l4h61x";
    };
    propagatedBuildInputs = [Mouse];
  };

  AppCLI = buildPerlPackage {
    name = "App-CLI-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/App-CLI-0.07.tar.gz;
      sha256 = "000866qsm7jck3ini69b02sgbjwp6s297lsds002r7xk2wb6fqcz";
    };
    propagatedBuildInputs = [LocaleMaketextSimple];
  };

  AppConfig = buildPerlPackage {
    name = "AppConfig-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/AppConfig-1.66.tar.gz;
      sha256 = "1p1vs9px20lrq9mdwpzp309a8r6rchibsdmxang4krk90pi2sh4b";
    };
    meta = {
      description = "A bundle of Perl5 modules for reading configuration files and parsing command line arguments";
    };
  };

  ArrayCompare = buildPerlPackage {
    name = "Array-Compare-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-1.16.tar.gz;
      sha256 = "1iwkn7d07a7vgl3jrv4f0glwapxcbdwwsy3aa6apgwam9119hl7q";
    };
  };

  ArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.16";
    src = fetchurl {
      url = http://nixos.org/tarballs/Archive-Zip-1.16.tar.gz;
      md5 = "e28dff400d07b1659d659d8dde7071f1";
    };
  };

  AuthenDecHpwd = buildPerlPackage rec {
    name = "Authen-DecHpwd-2.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "67f45fef6a23b7548f387b675cbf7881bf9da62d7d007cbf90d3a4b851b99eb7";
    };
    propagatedBuildInputs = [ ScalarString DataInteger DigestCRC ];
  };

  AuthenHtpasswd = buildPerlPackage rec {
    name = "Authen-Htpasswd-0.171";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Authen/${name}.tar.gz";
      sha256 = "0rw06hwpxg388d26l0jvirczx304f768ijvc20l4b2ll7xzg9ymm";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
  };

  AuthenPassphrase = buildPerlPackage rec {
    name = "Authen-Passphrase-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "55db4520617d859d88c0ee54965da815b7226d792b8cdc8debf92073559e0463";
    };
    propagatedBuildInputs = [ModuleRuntime ParamsClassify CryptPasswdMD5 CryptDES
      DataEntropy CryptUnixCryptXS CryptEksblowfish CryptMySQL DigestMD4 AuthenDecHpwd];
  };

  AuthenSASL = buildPerlPackage rec {
    name = "Authen-SASL-2.1401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "1vx97xnqj5jqlh767l04jbqmsiqd5qcbw2jnbd3qh7fhh0slff6d";
    };
    propagatedBuildInputs = [DigestHMAC];
  };

  Autobox = buildPerlPackage rec {
    name = "autobox-2.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/${name}.tar.gz";
      sha256 = "1kfn8zqbv9rjri39hh0xvqx74h35iwhix7w6ncajw06br8m9pizh";
    };
    propagatedBuildInputs = [ScopeGuard];
  };

  Autodia = buildPerlPackage rec {
    name = "Autodia-2.03";
    src = fetchurl {
      url = "http://www.aarontrevena.co.uk/opensource/autodia/download/${name}.tar.gz";
      sha256 = "1pzp30lnqkip2yrmnyzrf62g08xwn751nf9gmwdxjc09daaihwaz";
    };
    propagatedBuildInputs = [ TemplateToolkit Inline InlineJava GraphViz ];

    meta = {
      description = "AutoDia, create UML diagrams from source code";

      longDescription = ''
        AutoDia is a modular application that parses source code, XML or data
        and produces an XML document in Dia format (or images via graphviz
        and vcg).  Its goal is to be a UML / DB Schema diagram autocreation
        package.  The diagrams its creates are standard UML diagrams showing
        dependancies, superclasses, packages, classes and inheritances, as
        well as the methods, etc of each class.

        AutoDia supports any language that a Handler has been written for,
        which includes C, C++, Java, Perl, Python, and more.
      '';

      homepage = http://www.aarontrevena.co.uk/opensource/autodia/;
      license = "GPLv2+";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };

  BerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl;
    inherit (pkgs) db4;
  };

  BHooksEndOfScope = buildPerlPackage {
    name = "B-Hooks-EndOfScope-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/B-Hooks-EndOfScope-0.12.tar.gz;
      sha256 = "1gagn8b9zhbwk4f4cllrvir1mspvq0ladsy0pfkwl9w85q1843lj";
    };
    propagatedBuildInputs = [ ModuleImplementation ModuleRuntime SubExporterProgressive ];
    meta = {
      homepage = http://metacpan.org/release/B-Hooks-EndOfScope;
      description = "Execute code after a scope finished compilation";
      license = "perl5";
    };
  };

  BitVector = buildPerlPackage {
    name = "Bit-Vector-6.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-6.4.tar.gz;
      sha256 = "146vr78r6w3cxrm0ji491ylaa1abqh7fs81qhg15g3gzzxfg33bp";
    };
    propagatedBuildInputs = [CarpClan];
  };

  BKeywords = buildPerlPackage rec {
    name = "B-Keywords-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJORE/${name}.tar.gz";
      sha256 = "9a231f54a01a705c574a38702cb3fe8bbb301ea7357a09797e3da876a265d395";
    };
  };

  Boolean = buildPerlPackage rec {
    name = "boolean-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "1xqhzy3m2r08my13alff9bzl8b6xgd68312834x0hf33yir3l1yn";
    };
  };

  CacheCache = buildPerlPackage rec {
    name = "Cache-Cache-1.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "14s75bsm5irisp8wkbwl3ycw160srr1rks7x9jcbvcxh79wr6gbh";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
  };

  CacheFastMmap = buildPerlPackage rec {
    name = "Cache-FastMmap-1.40";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "0h3ckr04cdn6dvl40m4m97vl5ybf30v1lwhw3jvkr92kpksvq4hd";
    };
  };

  cam_pdf = buildPerlPackage rec {
    name = "CAM-PDF-1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CD/CDOLAN/${name}.tar.gz";
      sha256 = "1lamnx0vcqzzcxdmj5038gvyn6z5xcy9756jhndgpggjfkzilwkh";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
    buildInputs = [ TestMore ];
  };

  CaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.94";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "01rnyqsd9b446b2wa1mycrfyiaigqdsjb3kbf7f3rrjgw3rwbf4d";
    };
    propagatedBuildInputs = [HTMLTiny LWP];
    buildInputs = [TestPod];
  };

  CaptureTiny = buildPerlPackage {
    name = "Capture-Tiny-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.21.tar.gz;
      sha256 = "1lvz2639zsjpr3001b2xyidnsd4kcgll5fvaa0pm928wzldb49wg";
    };
    meta = {
      homepage = https://metacpan.org/release/Capture-Tiny;
      description = "Capture STDOUT and STDERR from Perl, XS or external programs";
      license = "apache_2_0";
    };
  };

  CarpAssert = buildPerlPackage {
    name = "Carp-Assert-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Carp-Assert-0.20.tar.gz;
      sha256 = "1wzy4lswvwi45ybsm65zlq17rrqx84lsd7rajvd0jvd5af5lmlqd";
    };
    meta = {
    };
  };

  CarpAssertMore = buildPerlPackage {
    name = "Carp-Assert-More-1.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-1.14.tar.gz;
      sha256 = "0cq7qk4qbhqppm4raby5k24b5mx5qjgy1884nrddhxillnzlq01z";
    };
    propagatedBuildInputs = [ CarpAssert TestException ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      license = "artistic_2";
    };
  };

  CarpClan = buildPerlPackage {
    name = "Carp-Clan-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Carp-Clan-6.04.tar.gz;
      sha256 = "1v71k8s1pi16l5y579gnrg372c6pdvy6qqm6iddm8h1dx7n16bjl";
    };
    propagatedBuildInputs = [ TestException ];
    meta = {
      description = "Report errors from perspective of caller of a \"clan\" of modules";
      license = "perl";
    };
  };

  CatalystActionRenderView = buildPerlPackage rec {
    name = "Catalyst-Action-RenderView-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0j1rrld13cjk7ks92b5hv3xw4rfm2lvmksb4rlzd8mx0a0wj0rc5";
    };
    propagatedBuildInputs =
      [ CatalystRuntime HTTPRequestAsCGI DataVisitor MROCompat ];
  };

  CatalystAuthenticationStoreHtpasswd = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-Htpasswd-1.003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "09mn0wjwfvnfi28y47g816nx50zdpvwvbxp0nrpsap0ir1m80wi3";
    };
    buildInputs = [ TestWWWMechanizeCatalyst TestUseOk ];
    propagatedBuildInputs =
      [ CatalystPluginAuthentication ClassAccessor CryptPasswdMD5 AuthenHtpasswd HTMLForm ];
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1503";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Authentication-Store-DBIx-Class-0.1503.tar.gz;
      sha256 = "1l11if91gjfrga7i7bjxwa0zybhkkrpgg6ps3nxm30vmg7xqaf4d";
    };
    propagatedBuildInputs = [ CatalystModelDBICSchema CatalystPluginAuthentication CatalystRuntime DBIxClass ListMoreUtils Moose namespaceautoclean TryTiny ];
    meta = {
      description = "A storage class for Catalyst Authentication using DBIx::Class";
      license = "perl";
    };
  };

  CatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "0wfj4vnn2cvk6jh62amwlg050p37fcwdgrn9amcz24z6w4qgjqvz";
    };
    propagatedBuildInputs = [CatalystRuntime Moose];
  };

  CatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "1vrd79d0nbqkana5q483fgsr41idlfgjhf7fpd3hc056z5nq8iyn";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystActionRenderView CatalystViewTT
      CatalystPluginConfigLoader ConfigGeneral
      CatalystComponentInstancePerContext Moose
      RegexpAssemble TestWWWMechanize
      TestWWWMechanizeCatalyst HTMLFormFu
    ];
  };

  CatalystDevel = buildPerlPackage {
    name = "Catalyst-Devel-1.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Devel-1.37.tar.gz;
      sha256 = "0yk526py65iy40z10d6w0fspb8fam5rf1hzsxnfyy4lpy91lp7s9";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CatalystRuntime CatalystActionRenderView CatalystPluginConfigLoader CatalystPluginStaticSimple ConfigGeneral FileChangeNotify FileCopyRecursive FileShareDir ModuleInstall Moose MooseXDaemonize MooseXEmulateClassAccessorFast namespaceautoclean namespaceclean PathClass Starman TemplateToolkit ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "Catalyst Development Tools";
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystEngineHTTPPrefork = buildPerlPackage rec {
    name = "Catalyst-Engine-HTTP-Prefork-0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "1ygmrzc9akjaqfxid8br11ajj9qgfvhkimakcv4ffk4s5v7q2sii";
    };
    propagatedBuildInputs = [
      CatalystRuntime HTTPBody NetServer
      CookieXS HTTPHeaderParserXS
    ];
    buildInputs = [TestPod TestPodCoverage];
    patches = [
      # Fix chunked transfers (they were missing the final CR/LF at
      # the end, which makes curl barf).
      ../development/perl-modules/catalyst-fix-chunked-encoding.patch
    ];
  };

  CatalystManual = buildPerlPackage {
    name = "Catalyst-Manual-5.9006";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HK/HKCLARK/Catalyst-Manual-5.9006.tar.gz;
      sha256 = "0cl9nqg5jrqcf2h3pgk6q8408czf5s0k0xh3ra884c9cnx84mr95";
    };
    meta = {
      description = "The Catalyst developer's manual";
      license = "perl";
    };
  };

  CatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Catalyst-Model-DBIC-Schema-0.60.tar.gz;
      sha256 = "176jqvrmhp0wng446m0qlmh1kgqj4z1czg6s418ffr4a7c3jqyld";
    };
    buildInputs = [ DBDSQLite TestException TestRequires ];
    propagatedBuildInputs = [ CarpClan CatalystComponentInstancePerContext CatalystDevel CatalystRuntime CatalystXComponentTraits DBIxClass DBIxClassCursorCached DBIxClassSchemaLoader HashMerge ListMoreUtils Moose MooseXMarkAsMethods MooseXNonMoose MooseXTypes namespaceautoclean namespaceclean TieIxHash TryTiny ];
    meta = {
      description = "DBIx::Class::Schema Model Class";
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystRuntime = buildPerlPackage {
    name = "Catalyst-Runtime-5.90019";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Runtime-5.90019.tar.gz;
      sha256 = "0madnqyzhcvbv6iql6b10dzfqvajj0fyp1sla83csakkbff38mqp";
    };
    buildInputs = [ ClassDataInheritable DataDump HTTPMessage TestException ];
    propagatedBuildInputs = [ CGISimple ClassC3AdoptNEXT ClassLoad ClassMOP DataDump DataOptList HTMLParser HTTPBody HTTPMessage HTTPRequestAsCGI ListMoreUtils LWPUserAgent Moose MooseXEmulateClassAccessorFast MooseXGetopt MooseXMethodAttributes MooseXRoleWithOverloading MROCompat namespaceautoclean namespaceclean PathClass Plack PlackMiddlewareReverseProxy PlackTestExternalServer SafeIsa StringRewritePrefix SubExporter TaskWeaken TextSimpleTable TreeSimple TreeSimpleVisitorFactory TryTiny URI ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "The Catalyst Framework Runtime";
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginAccessLog = buildPerlPackage {
    name = "Catalyst-Plugin-AccessLog-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARODLAND/Catalyst-Plugin-AccessLog-1.05.tar.gz;
      sha256 = "0hqvckaw91q5yc25a33bp0d4qqxlgkp7rxlvi8n8svxd1406r55s";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime Moose namespaceautoclean ];
    meta = {
      description = "Request logging from within Catalyst";
      license = "perl";
    };
  };

  CatalystPluginAuthentication = buildPerlPackage {
    name = "Catalyst-Plugin-Authentication-0.10022";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authentication-0.10022.tar.gz;
      sha256 = "1yxx89j6q10ydmwwhv3zq68gwndcnh4vvdqiv7az5w2rf2w1nvip";
    };
    buildInputs = [ ClassMOP Moose TestException ];
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime ClassInspector Moose MooseXEmulateClassAccessorFast MROCompat namespaceautoclean StringRewritePrefix TryTiny ];
    meta = {
      description = "Infrastructure plugin for the Catalyst authentication framework";
      license = "perl";
    };
  };

  CatalystPluginAuthorizationACL = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authorization-ACL-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "12pj3c8hhm72jzyj83pjmxib0l48s3954spln97n3s0nsvliya98";
    };
    propagatedBuildInputs = [CatalystRuntime ClassThrowable];
  };

  CatalystPluginAuthorizationRoles = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-Roles-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authorization-Roles-0.09.tar.gz;
      sha256 = "0l83lkwmq0lngwh8b1rv3r719pn8w1gdbyhjqm74rnd0wbjl8h7f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime SetObject UNIVERSALisa ];
    meta = {
      description = "Role based authorization for Catalyst based on Catalyst::Plugin::Authentication";
      license = "perl";
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.30";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "1rshgsvs9ngpd4nang4flq6mx9v71w1z5klp1rm8llc88pxlqahm";
    };
    propagatedBuildInputs = [CatalystRuntime DataVisitor ConfigAny MROCompat];
  };

  CatalystPluginUnicodeEncoding = buildPerlPackage rec {
    name = "Catalyst-Plugin-Unicode-Encoding-1.2";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0bz33xnh0wa6py6jz31wr38krad9hcv4gxdsy0lyhqn0k4v6b6dx";
    };
    propagatedBuildInputs = [ CatalystRuntime LWP ];
  };

  CatalystPluginHTMLWidget = buildPerlPackage {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Catalyst-Plugin-HTML-Widget-1.1.tar.gz;
      sha256 = "1zzyfhmzlqvbwk2w930k3mqk8z1lzhrja9ynx9yfq5gmc8qqg95l";
    };
    propagatedBuildInputs = [CatalystRuntime HTMLWidget];
  };

  CatalystPluginSession = buildPerlPackage {
    name = "Catalyst-Plugin-Session-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Session-0.36.tar.gz;
      sha256 = "14wgkrg3w69gwg6zg991k5f611xqsnyx0i0xzhw9rx2j5nf9rj4b";
    };
    buildInputs = [ TestDeep TestException TestWWWMechanizePSGI ];
    propagatedBuildInputs = [ CatalystRuntime Moose MooseXEmulateClassAccessorFast MROCompat namespaceclean ObjectSignature ];
    meta = {
      description = "Generic Session plugin - ties together server side storage and client side state required to maintain session data";
      license = "perl";
    };
  };

  CatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1rvxbfnpf9x2pc2zgpazlcgdlr2dijmxgmcs0m5nazs0w6xikssb";
    };
    buildInputs = [ TestMockObject ];
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession ];
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0x3j6zv3wr41jlwr6yb2jpmcx019ibyn11y8653ffnwhpzbpzsxs";
    };
    propagatedBuildInputs =
      [ PathClass CatalystPluginSession CacheFastMmap MROCompat ];
  };

  CatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Catalyst-Plugin-StackTrace-0.11.tar.gz;
      sha256 = "1ingivnga1yb4dqsj6icc4a58i9wdalzpn2qflsn8n2skgm223qb";
    };
    propagatedBuildInputs = [ CatalystRuntime DevelStackTrace MROCompat ];
    meta = {
      description = "Display a stack trace on the debug screen";
      license = "perl";
    };
  };

  CatalystPluginStaticSimple = buildPerlPackage {
    name = "Catalyst-Plugin-Static-Simple-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/Catalyst-Plugin-Static-Simple-0.30.tar.gz;
      sha256 = "18zar1n4imgnv7b4dr5sxyikry4668ngqgc6f0dr210bqafvwv7w";
    };
    propagatedBuildInputs = [ CatalystRuntime MIMETypes Moose MooseXTypes namespaceautoclean ];
    meta = {
      description = "Make serving static pages painless";
      license = "perl";
    };
  };

  CatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.07";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "1c6k4x6az0fkany16zlyaqhlp7bcx922vl4qzd3z707vs6pc06rz";
    };
    buildInputs = [  TestWWWMechanizeCatalyst TestUseOk ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV XMLSimple ];
  };

  CatalystViewJSON = buildPerlPackage {
    name = "Catalyst-View-JSON-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Catalyst-View-JSON-0.33.tar.gz;
      sha256 = "03yda9skcfnwkm4hf2a3y7g2rdjdia5hzfnll0h7z4wiyb8kxfii";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ CatalystRuntime JSONAny MROCompat YAML ];
    meta = {
      description = "JSON view for your data";
      license = "perl";
    };
  };

  CatalystViewTT = buildPerlPackage {
    name = "Catalyst-View-TT-0.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-View-TT-0.40.tar.gz;
      sha256 = "0j73mk631p9x0b0l24ikavh9nxl6lpya4g46fpanjk396d2zj8bs";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassAccessor MROCompat PathClass TemplateToolkit TemplateTimer ];
    meta = {
      description = "Template View Class";
      license = "perl";
    };
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CatalystX/${name}.tar.gz";
      sha256 = "0a2mhfgv0kqmaxf2crs8mqk44lyhd9qcwlpzhrc0b0dh4z503mr4";
    };
    propagatedBuildInputs =
      [ CatalystRuntime MooseXTraitsPluggable namespaceautoclean ListMoreUtils ];
  };

  CatalystXScriptServerStarman = buildPerlPackage {
    name = "CatalystX-Script-Server-Starman-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/CatalystX-Script-Server-Starman-0.02.tar.gz;
      sha256 = "0h02mpkc4cmi3jpvcd7iw7xyzx55bqvvl1qkf967gqkvpklm0qx5";
    };
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime Moose namespaceautoclean Starman ];
    meta = {
      description = "Replace the development server with Starman";
      license = "perl";
    };
  };

  CGICookieXS = buildPerlPackage rec {
    name = "CGI-Cookie-XS-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1jrd3f11sz17117nvssrrf6r80fr412615n5ffspbsap4n816bnn";
    };
  };

  CGIFormBuilder = buildPerlPackage rec {
    name = "CGI-FormBuilder-3.0501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWIGER/${name}.tgz";
      sha256 = "031sgxifl2dq8d4s4d9vnixvqdd3p952k0jrkyqp823k74glps25";
    };
  };

  CGISession = buildPerlPackage rec {
    name = "CGI-Session-4.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/${name}.tar.gz";
      sha256 = "c04b725be6a1b9bf22387cc6427eb951408ccba1c52471a43a80306f31e68e1b";
    };
    buildInputs = [ DBFile ];
  };

  CGISimple = buildPerlPackage {
    name = "CGI-Simple-1.113";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/CGI-Simple-1.113.tar.gz;
      sha256 = "0g8v0jd7dk310k6ncz47qa1cfrysi8yib1zwkhasv4zhswgqiqjj";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A Simple totally OO CGI interface that is CGI.pm compliant";
      license = "perl";
    };
  };

  ClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.34.tar.gz;
      sha256 = "1z6fqg0yz8gay15r1iasslv8f1n1mzjkrhs47fvbj3rqz36y1cfd";
    };
    meta = {
      license = "perl";
    };
  };

  ClassAccessorChained = buildPerlPackage {
    name = "Class-Accessor-Chained-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz;
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [ClassAccessor];
  };

  ClassAccessorGrouped = buildPerlPackage {
    name = "Class-Accessor-Grouped-0.10009";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/Class-Accessor-Grouped-0.10009.tar.gz;
      sha256 = "1cs6wvng9xxhmrps7qb7ccxswqkqskwj862dp4fqfra14aprlg4c";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassXSAccessor ModuleRuntime SubName ];
    meta = {
      description = "Lets you build groups of accessors";
      license = "perl";
    };
  };

  ClassAutouse = buildPerlPackage {
    name = "Class-Autouse-1.99_02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-1.99_02.tar.gz;
      sha256 = "1jkhczx2flxrz154ps90fj9wcchkpmnp5sapwc0l92rpn7jpsf08";
    };
  };

  ClassBase = buildPerlPackage rec {
    name = "Class-Base-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "149875qzfyayvkb6dm8frg0kmkzyjswwrjz7gyvwi7l8b19kiyk4";
    };
  };

  ClassC3 = buildPerlPackage {
    name = "Class-C3-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Class-C3-0.24.tar.gz;
      sha256 = "1nhwf7bj7z5szk7sxmq0ynqh2k9p42a7zkfyikkairfb78xckpkz";
    };
    propagatedBuildInputs = [ AlgorithmC3 ];
    meta = {
      description = "A pragma to use the C3 method resolution order algortihm";
      license = "perl";
    };
  };

  ClassC3AdoptNEXT = buildPerlPackage {
    name = "Class-C3-Adopt-NEXT-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Class-C3-Adopt-NEXT-0.13.tar.gz;
      sha256 = "1rwgbx6dsy4rpas94p8wakzj7hrla1p15jnbm24kwhsv79gp91ld";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils MROCompat ];
    meta = {
      homepage = http://search.cpan.org/dist/Class-C3-Adopt-NEXT;
      description = "Make NEXT suck less";
      license = "perl";
    };
  };

  ClassC3Componentised = buildPerlPackage {
    name = "Class-C3-Componentised-1.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Class-C3-Componentised-1.001000.tar.gz;
      sha256 = "1nzav8arxll0rya7r2vp032s3acliihbb9mjlfa13rywhh77bzvl";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassC3 ClassInspector MROCompat ];
    meta = {
      license = "perl";
    };
  };

  ClassDataAccessor = buildPerlPackage {
    name = "Class-Data-Accessor-0.04004";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz;
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  ClassDataInheritable = buildPerlPackage {
    name = "Class-Data-Inheritable-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz;
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  ClassFactoryUtil = buildPerlPackage rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
  };

  ClassInspector = buildPerlPackage {
    name = "Class-Inspector-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Inspector-1.28.tar.gz;
      sha256 = "04iij8dbcgaim7g109frpyf7mh4ydsd8zh53r53chk0zxnivg91w";
    };
    meta = {
      description = "Get information about a class and its structure";
      license = "perl";
    };
  };

  ClassMakeMethods = buildPerlPackage rec {
    name = "Class-MakeMethods-1.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/${name}.tar.gz";
      sha256 = "10f65j4ywrnwyz0dm1q5ymmpv875drj40mj1xvsjv0bnjinnwzj8";
    };
  };

  ClassMethodModifiers = buildPerlPackage {
    name = "Class-Method-Modifiers-2.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/Class-Method-Modifiers-2.00.tar.gz;
      sha256 = "0lvj38ahqqyhv9dpi7ks1cq35f19nfw8ygxw22x2mcmagl8mnkhs";
    };
    buildInputs = [ TestFatal ];
    meta = {
      homepage = https://github.com/sartak/Class-Method-Modifiers/tree;
      description = "Provides Moose-like method modifiers";
      license = "perl";
    };
  };

  ClassMix = buildPerlPackage rec {
    name = "Class-Mix-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "054d0db62df90f22601f2a18fc84e9ca026d81601f5940b2fcc543e39d69b36b";
    };
    propagatedBuildInputs = [ParamsClassify];
  };

  ClassMOP = Moose;

  ClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "0l4iwwk91wm2mrrh4irrn6ham9k12iah1ry33k0lzq22r3kwdbyg";
    };
  };

  ClassThrowable = buildPerlPackage {
    name = "Class-Throwable-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Class-Throwable-0.10.tar.gz;
      sha256 = "01hjrfb951c9j83ncg5drnam8vsfdgkjjv0kjshxhkl93sgnlvdl";
    };
  };

  ClassLoad = buildPerlPackage {
    name = "Class-Load-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Class-Load-0.20.tar.gz;
      sha256 = "084cxrm0hcpyz3ly1iqkcjpl4bs03n42na37d3pzwa8xbs44ag42";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ DataOptList ModuleImplementation ModuleRuntime PackageStash TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A working (require \"Class::Name\") and more";
      license = "perl5";
    };
  };

  ClassLoadXS = buildPerlModule {
    name = "Class-Load-XS-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Class-Load-XS-0.06.tar.gz;
      sha256 = "1dl739nnfw2j9rjgqxx24jqbanyvncqfnkwm27af8ik6kiqk50ik";
    };
    buildInputs = [ ModuleImplementation TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "XS implementation of parts of Class::Load";
      license = "artistic_2";
    };
  };

  ClassUnload = buildPerlPackage rec {
    name = "Class-Unload-0.07";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class//${name}.tar.gz";
      sha256 = "1alvn94j0wgfyyym092g9cq0mbhzin0zf7lfja6578jk5cc788rr";
    };
    propagatedBuildInputs = [ ClassInspector ];
  };

  ClassXSAccessor = buildPerlPackage {
    name = "Class-XSAccessor-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.16.tar.gz;
      sha256 = "1yjpw9kssy4m52407k45hxjnqz02494z7x8j44pjzkyi8msafvg5";
    };
    meta = {
      description = "Generate fast XS accessors without runtime compilation";
      license = "perl5";
    };
  };

  Clone = buildPerlPackage {
    name = "Clone-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GARU/Clone-0.34.tar.gz;
      sha256 = "0qk32i2ncmn7wm2dbjpwhwa4js079bgfs4ayb90mnxjhwq5358ix";
    };
    meta = {
      description = "Recursively copy Perl datatypes";
      license = "perl5";
    };
  };

  CommonSense = buildPerlPackage rec {
    name = "common-sense-3.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/common-sense-3.6.tar.gz;
      sha256 = "0nkbp1by0mpvg1x6053fbh9dl8nnswlyfmqp8k2lppd717hw5ql6";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  CompressRawBzip2 = buildPerlPackage {
    name = "Compress-Raw-Bzip2-2.060";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.060.tar.gz;
      sha256 = "02azwhglk2w68aa47sjqhj6vwzi66mv4hwal87jccjfy17gcwvx7";
    };

    # Don't build a private copy of bzip2.
    BUILD_BZIP2 = false;
    BZIP2_LIB = "${pkgs.bzip2}/lib";
    BZIP2_INCLUDE = "${pkgs.bzip2}/include";

    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Low-Level Interface to bzip2 compression library";
      license = "perl5";
    };
  };

  CompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage stdenv;
    inherit (pkgs) zlib;
  };

  CompressZlib = IOCompress;

  CompressUnLZMA = buildPerlPackage rec {
    name = "Compress-unLZMA-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "0sg9gj3rhif6hgmhwpz6w0g52l65vj5hx9818v5cdhvcif0jhg0b";
    };
    propagatedBuildInputs = [ IOCompress ];
  };

  ConfigAny = buildPerlPackage rec {
    name = "Config-Any-0.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Config/${name}.tar.gz";
      sha256 = "17k62vdq3wr7m397ginp8525nqmlcjsmlqqpvnnfm3sr5vcxhjgz";
    };
  };

  ConfigGeneral = buildPerlPackage {
    name = "Config-General-2.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.51.tar.gz;
      sha256 = "1khby072f10jbml0dlh82bg1s91ph8z6xa9bpk0l180q936k1xcg";
    };
    meta = {
      license = "perl";
    };
  };

  ConfigTiny = buildPerlPackage rec {
    name = "Config-Tiny-2.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1a5b7f5e8245a3e7be859df571209353be30abc7292815ee0f459b8dc87cdb5b";
    };
  };

  ConvertASN1 = buildPerlPackage rec {
    name = "Convert-ASN1-0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/Convert-ASN1-0.22.tar.gz";
      sha256 = "1vpny8smwl23rai1kxngi5i31jhp6s6cdls19gjhcwsxf76daqxy";
    };
  };

  constant = buildPerlPackage {
    name = "constant-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/constant-1.15.tar.gz;
      sha256 = "1ygz0hd1fd3q88r6dlw14kpyh06zjprksdci7qva6skxz3261636";
    };
  };

  ContextPreserve = buildPerlPackage rec {
    name = "Context-Preserve-0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/${name}.tar.gz";
      sha256 = "0gssillawjknqks81x7fg7w2x94bnyklgd8ry2pr1k6ifkjhwz46";
    };
    buildInputs = [ TestException TestUseOk ];
  };

  CookieXS = buildPerlPackage rec {
    name = "Cookie-XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ CGICookieXS ];
  };

  CPANMeta = buildPerlPackage {
    name = "CPAN-Meta-2.120921";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-2.120921.tar.gz;
      sha256 = "12cprk636jaklc97vdh55yjvzcr13h3csdnv3dgna84r2jijka79";
    };
    propagatedBuildInputs = [ ParseCPANMeta CPANMetaYAML CPANMetaRequirements ];
    meta = {
      homepage = https://github.com/dagolden/cpan-meta;
      description = "The distribution metadata for a CPAN dist";
      license = "perl5";
    };
  };

  CPANMetaCheck = buildPerlPackage {
    name = "CPAN-Meta-Check-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/CPAN-Meta-Check-0.004.tar.gz;
      sha256 = "0ccybgfc0p41shmc6nmbg20xljq2ygfjcxmyaf6y07yk6wdcyf7s";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ CPANMeta CPANMetaRequirements ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Verify requirements in a CPAN::Meta object";
      license = "perl5";
    };
  };

  CPANMetaRequirements = buildPerlPackage {
    name = "CPAN-Meta-Requirements-2.122";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.122.tar.gz;
      sha256 = "1fq2blw9ynja34fm9ck24m3qcpyk0hp25dhxvgs01k7yz64ryffh";
    };
    buildInputs = [ TestMore ];
    meta = {
      homepage = https://github.com/dagolden/cpan-meta-requirements;
      description = "A set of version requirements for a CPAN dist";
      license = "perl5";
    };
  };

  CPANMetaYAML = buildPerlPackage {
    name = "CPAN-Meta-YAML-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-YAML-0.008.tar.gz;
      sha256 = "1fxc8ybn6mdgzxyq1n69rgihmpfaarfclmbdw2rznya5zg2b0nz0";
    };
    meta = {
      homepage = https://github.com/dagolden/cpan-meta-yaml;
      description = "Read and write a subset of YAML for CPAN Meta files";
      license = "perl5";
    };
  };

  CryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0cvigpxvwn18kb5i40jlp5fgijbhncvlh23xdgs1cnhxa17yrgwx";
    };
  };

  CryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1w12k1b7868v3ql0yprswlz2qri6ja576k9wlda7b8zf2d0rxgmp";
    };
    buildInputs = [CryptCBC];
  };

  CryptDHGMP = buildPerlPackage rec {
    name = "Crypt-DH-GMP-0.00010";
    src = fetchurl {
      url = "mirror://cpan/authors/id//D/DM/DMAKI/${name}.tar.gz";
      sha256 = "7d947cd48a98880df4fb5b0785758bef9ae1357eba7c376ad0fca3fd262a5fe9";
    };
    buildInputs = [ DevelChecklib TestRequires pkgs.gmp ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp}/lib -lgmp";
  };

  CryptEksblowfish = buildPerlPackage rec {
    name = "Crypt-Eksblowfish-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3cc7126d5841107237a9be2dc5c7fbc167cf3c4b4ce34678a8448b850757014c";
    };
    propagatedBuildInputs = [ClassMix];
  };

  CryptPasswdMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LU/LUISMUNOZ/Crypt-PasswdMD5-1.3.tar.gz;
      sha256 = "13j0v6ihgx80q8jhyas4k48b64gnzf202qajyn097vj8v48khk54";
    };
  };

  CryptRC4 = buildPerlPackage rec {
    name = "Crypt-RC4-2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIFUKURT/${name}.tar.gz";
      sha256 = "1sp099cws0q225h6j4y68hmfd1lnv5877gihjs40f8n2ddf45i2y";
    };
  };

  CryptRandPasswd = buildPerlPackage rec {
    name = "Crypt-RandPasswd-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDPORTER/${name}.tar.gz";
      sha256 = "0r5w5i81s02x756alad9psxmpqmcxahzjpqxsb3kacsqj8s5br9b";
    };
  };

  CryptMySQL = buildPerlPackage rec {
    name = "Crypt-MySQL-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEBE/${name}.tar.gz";
      sha256 = "93ebdfaaefcfe9ab683f0121c85f24475d8197f0bcec46018219e4111434dde3";
    };
    propagatedBuildInputs = [DigestSHA1];
  };

  CryptRijndael = buildPerlPackage rec {
    name = "Crypt-Rijndael-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "8f8833bc8839e0d4aa3c26d86d2f39ceb9b13e52a9f5e4fd928da2e71989d3b4";
    };
  };

  CryptUnixCryptXS = buildPerlPackage rec {
    name = "Crypt-UnixCrypt_XS-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "527c32b8b6eb50d52b081ceae4be2d748e718e40ea85940da59a3adeb3a33156";
    };
  };

  CryptSmbHash = buildPerlPackage rec {
    name = "Crypt-SmbHash-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
      sha256 = "0dxivcqmabkhpz5xzph6rzl8fvq9xjy26b2ci77pv5gsmdzari38";
    };
  };

  CryptOpenSSLRandom = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Random-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IR/IROBERTS/${name}.tar.gz";
      sha256 = "acf7eb81023cd1f40d8c60b893096d041513df2be2aefe145cc7ae1a3dcc78c7";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
  };

  CryptOpenSSLRSA = buildPerlPackage rec {
    name = "Crypt-OpenSSL-RSA-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "5357f977464bb3a8184cf2d3341851a10d5515b4b2b0dfb88bf78995c0ded7be";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
  };

  CryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "1f0i5y99ly39vf86jpzwqz8mkz1460vryv85jgqmfx007p781s0l";
    };
    makeMakerFlags = "--lib=${pkgs.openssl}/lib";
  };

  DataCompare = buildPerlPackage rec {
    name = "Data-Compare-1.22";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "1bz8qasp3ndiprxq2l0llbc0xbnjq11lz0l1lfzxiap7v1y2r3yf";
    };
    propagatedBuildInputs = [ FileFindRule ];
  };

  DataDump = buildPerlPackage {
    name = "Data-Dump-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.21.tar.gz;
      sha256 = "1fcy6q8p406ag8g50l7znns3kxazfb458l6kw8pbsp4axnkz9ydx";
    };
    meta = {
      description = "Pretty printing of data structures";
      license = "perl";
    };
  };

  DataDumperConcise = buildPerlPackage rec {
    name = "Data-Dumper-Concise-2.020";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0zb792d2dmpl0dnfmwcgh6wppb5h56hwycdbcf97wqxcgjk3k7hn";
    };
  };

  DataEntropy = buildPerlPackage rec {
    name = "Data-Entropy-0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "2611c4a1a3038594d79ea4ed14d9e15a9af8f77105f51667795fe4f8a53427e4";
    };
    propagatedBuildInputs = [ParamsClassify DataFloat CryptRijndael HTTPLite];
  };

  DataFloat = buildPerlPackage rec {
    name = "Data-Float-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "698ecb092a3284e260cd3c3208408feb791d7d0f06a02673f9125ab2d51cc2d8";
    };
  };

  DataHierarchy = buildPerlPackage {
    name = "Data-Hierarchy-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz;
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    propagatedBuildInputs = [TestException];
  };

  DataInteger = buildPerlPackage rec {
    name = "Data-Integer-0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3a52f7717d1ebda3af40036d72cbcadd1984210737743997abdad141d620f67e";
    };
  };

  DataOptList = buildPerlPackage {
    name = "Data-OptList-0.107";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-OptList-0.107.tar.gz;
      sha256 = "0r2sbvh1kj69al5crg394v5j5wkffvqdb17fz1rjfgb6h3v93xi8";
    };
    propagatedBuildInputs = [ ParamsUtil SubInstall ];
    meta = {
      homepage = http://github.com/rjbs/data-optlist;
      description = "Parse and validate simple name/value option pairs";
      license = "perl5";
    };
  };

  DataPage = buildPerlPackage {
    name = "Data-Page-2.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.01.tar.gz;
      sha256 = "0mvhlid9qx9yd94rgr4lfz9kvflimc1dzcah0x7q5disw39aqrzr";
    };
    propagatedBuildInputs = [TestException ClassAccessorChained];
  };

  DataUUID = buildPerlPackage rec {
    name = "Data-UUID-1.217";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0vgykclw1mn06a53d8y3g7s7vanks8078dh2j4jb84djk0cw9h0q";
    };
  };

  DataVisitor = buildPerlPackage rec {
    name = "Data-Visitor-0.28";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "1998syyprmqnhpgznmk7ia3zd8saw34q7pbaprxarcz7a3bncyjc";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs =
      [ ClassLoad Moose TaskWeaken TieToObject namespaceclean ];
  };

  DateCalc = buildPerlPackage {
    name = "Date-Calc-5.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-5.4.tar.gz;
      sha256 = "1q7d1sy9ka1akpbysgwj673i7wiwb48yjv6wx1v5dhxllyxlxqc8";
    };
    propagatedBuildInputs = [CarpClan BitVector];
  };

  DateManip = buildPerlPackage {
    name = "DateManip-5.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-5.54.tar.gz;
      sha256 = "0ap2jgqx7yvjsyph9zsvadsih41cj991j3jwgz5261sq7q74y7xn";
    };
  };

  DateTime = buildPerlModule {
    name = "DateTime-0.78";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-0.78.tar.gz;
      sha256 = "0gicc3ib42jba989lxwy5i5sp4w3bmakdimgfxqbb57mbdarpxc5";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone ParamsValidate ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A date and time object";
      license = "artistic_2";
    };
  };

  DateTimeFormatBuilder = buildPerlPackage rec {
    name = "DateTime-Format-Builder-0.7901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "08zl89gh5lkff8736fkdnrf6dgppsjbmymnysbc06s7igd4ig8zf";
    };
    propagatedBuildInputs = [
      DateTime ParamsValidate TaskWeaken DateTimeFormatStrptime
      ClassFactoryUtil
    ];
    buildInputs = [TestPod];
  };

  DateTimeFormatNatural = buildPerlPackage rec {
    name = "DateTime-Format-Natural-0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHUBIGER/${name}.tar.gz";
      sha256 = "0hq33s5frfa8cpj2al7qi0sbmimm5sdlxf0h3b57fjm9x5arlkcn";
    };
    propagatedBuildInputs = [
      DateTime ListMoreUtils ParamsValidate DateCalc
      TestMockTime Boolean
    ];
  };

  DateTimeFormatStrptime = buildPerlPackage rec {
    name = "DateTime-Format-Strptime-1.5000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0m55rqbixrsfa6g6mqs8aa0rhcxh6aj2g3n8fgl63wyz9an93w8y";
    };
    propagatedBuildInputs =
      [ DateTime DateTimeLocale DateTimeTimeZone ParamsValidate ];
  };

  DateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "175grkrxiv012n6ch3z1sip4zprcili6m5zqi3njdk5c1gdvi8ca";
    };
    propagatedBuildInputs = [ListMoreUtils ParamsValidate];
  };

  DateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0wnjg6mcpcy7hg79jdsg3vi8ad89rghkcgqjmqiq6pqc0k9sbq2q";
    };
    buildInputs = [ TestOutput ];
    propagatedBuildInputs = [ ClassLoad ClassSingleton ParamsValidate TryTiny ];
  };

  DevelCaller = buildPerlPackage {
    name = "Devel-Caller-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.06.tar.gz;
      sha256 = "1pxpimifzmnjnvf4icclx77myc15ahh0k56sj1djad1855mawwva";
    };
    propagatedBuildInputs = [ PadWalker ];
    meta = {
      description = "Meatier versions of C<caller>";
      license = "perl5";
    };
  };

  DevelChecklib = buildPerlPackage rec {
    name = "Devel-CheckLib-0.98";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/${name}.tar.gz";
      sha256 = "2b6b62665403bcdce67b53eb3bee7b57b6576026640c01aa57c7126e32ce20da";
    };
    propagatedBuildInputs = [ IOCaptureOutput ];
  };

  DBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit stdenv fetchurl buildPerlPackage DBI;
    inherit (pkgs) sqlite;
  };

  DBDmysql = import ../development/perl-modules/DBD-mysql {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) mysql;
  };

  DBDPg = import ../development/perl-modules/DBD-Pg {
    inherit stdenv fetchurl buildPerlPackage DBI;
    postgresql = pkgs.postgresql92;
  };

  DBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db4;
  };

  DBI = buildPerlPackage {
    name = "DBI-1.616";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/DBI-1.616.tar.gz;
      sha256 = "0m6hk66xprjl314d5c665hnd1vch9a0b9y6ywvmf04kdqj33kkk0";
    };
    meta = {
      homepage = http://dbi.perl.org/;
      description = "Database independent interface for Perl";
      license = "perl5";
    };
  };

  DBIxClass = buildPerlPackage {
    name = "DBIx-Class-0.08204";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GE/GETTY/DBIx-Class-0.08204.tar.gz;
      sha256 = "0pghq6b60fyffb233hdk9qi47wcbf2sgp08679v9nxh4i5qp49gx";
    };
    buildInputs = [ DBDSQLite PackageStash TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped ClassC3Componentised ClassInspector ClassMethodModifiers ConfigAny ContextPreserve DataCompare DataDumperConcise DataPage DBI DevelGlobalDestruction HashMerge ModuleFind Moo MROCompat namespaceclean PathClass ScopeGuard SQLAbstract strictures SubName TryTiny ];
    meta = {
      homepage = http://www.dbix-class.org/;
      description = "Extensible and flexible object <-> relational mapper.";
      license = "perl";
    };
  };

  DBIxClassCursorCached = buildPerlPackage {
    name = "DBIx-Class-Cursor-Cached-1.001002";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARCANEZ/DBIx-Class-Cursor-Cached-1.001002.tar.gz;
      sha256 = "19r7jr6pknxiirrybq0cd0lnr76xiw05arnfqgk9nrhp6c7vvil0";
    };
    buildInputs = [ CacheCache DBDSQLite ];
    propagatedBuildInputs = [ CarpClan DBIxClass ];
    meta = {
      description = "Cursor class with built-in caching support";
      license = "perl";
    };
  };

  DBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [DBIxClass HTMLWidget];
  };

  DBIxClassIntrospectableM2M = buildPerlPackage {
    name = "DBIx-Class-IntrospectableM2M-0.001001";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRODITI/DBIx-Class-IntrospectableM2M-0.001001.tar.gz;
      sha256 = "0p9zx1yc1f6jg583l206wilsni2v8mlngc2vf2q8yn10pmy4y6wm";
    };
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Introspect many-to-many relationships";
      license = "perl";
    };
  };

  DBIxClassSchemaLoader = buildPerlPackage {
    name = "DBIx-Class-Schema-Loader-0.07033";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/DBIx-Class-Schema-Loader-0.07033.tar.gz;
      sha256 = "1vrcxxlbvdch5r9v5i6vrb4fqqfbpxybpdqndmlnc2jzlqjwjahi";
    };
    buildInputs = [ ConfigAny ConfigGeneral DBDSQLite DBI DBIxClassIntrospectableM2M Moose MooseXMarkAsMethods MooseXNonMoose namespaceautoclean TestException TestPod TestWarn ];
    propagatedBuildInputs = [ CarpClan ClassAccessorGrouped ClassC3Componentised ClassInspector ClassUnload DataDump DBIxClass HashMerge LinguaENInflectNumber LinguaENInflectPhrase LinguaENTagger ListMoreUtils MROCompat namespaceclean ScopeGuard StringCamelCase StringToIdentifierEN SubName TaskWeaken TryTiny ];
    meta = {
      description = "Create a DBIx::Class::Schema based on a database";
      license = "perl";
    };
  };

  DevelGlobalDestruction = buildPerlPackage {
    name = "Devel-GlobalDestruction-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/Devel-GlobalDestruction-0.09.tar.gz;
      sha256 = "1hvrv88167rc2chqgxpd6q0ir5fki1q6r3w11v3lxfs118fdi65m";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      homepage = http://search.cpan.org/dist/Devel-GlobalDestruction;
      license = "perl5";
    };
  };

  DevelHide = buildPerlPackage rec {
    name = "Devel-Hide-0.0008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "14hwwirpc9cnwn50rshb8hb778mia4ni75jv2dih8l9i033m4i26";
    };
  };

  DevelStackTrace = buildPerlPackage {
    name = "Devel-StackTrace-1.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-1.30.tar.gz;
      sha256 = "1m13wzg4pmbc0f1w2rn9ybqwkqg66zw9zv34ayk7gr3349v7kbzl";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "An object representing a stack trace";
      license = "artistic_2";
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    name = "Devel-StackTrace-AsHTML-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.11.tar.gz;
      sha256 = "0y0r42gszp3bxbs9j2nn3xgs8ij1cnadrywwwdc6r0y8m0siyapg";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "Displays stack trace in HTML";
      license = "perl";
    };
  };

  DevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "0qzj68zw1yypk8jw77h0w5sdpdcrp4xcmgfghcfyddjr2aim60x5";
    };
    propagatedBuildInputs = [
      TestPod /* cyclic dependency: TestPodCoverage */
    ];
  };

  DigestCRC = buildPerlPackage rec {
    name = "Digest-CRC-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLIMAUL/${name}.tar.gz";
      sha256 = "5c5329f37c46eb79835169508583da8767d9839350b69bb2b48ac6f594f70374";
    };
  };

  DigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = "perl";
    };
  };

  DigestMD4 = buildPerlPackage rec {
    name = "Digest-MD4-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/${name}.tar.gz";
      sha256 = "c7d7a32f5c2710c929b5688a7b057ec8ddbc51cf278f623e771fc02dcabd6a1f";
    };
  };

  DigestSHA = null;

  DigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz;
      sha256 = "1k23p5pjk42vvzg8xcn4iwdii47i0qm4awdzgbmz08bl331dmhb8";
    };
    meta = {
      description = "Perl interface to the SHA-1 algorithm";
      license = "perl";
    };
  };

  DistCheckConflicts = buildPerlPackage {
    name = "Dist-CheckConflicts-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Dist-CheckConflicts-0.02.tar.gz;
      sha256 = "1lh7j20vvsh4dyh74hr0wnabyv8vcdkilfi93m2fbk69qk3w995j";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ SubExporter ListMoreUtils ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Declare version conflicts for your dist";
      license = "perl5";
    };
  };

  EmailAbstract = buildPerlPackage {
    name = "Email-Abstract-3.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Abstract-3.004.tar.gz;
      sha256 = "0fiaagxc2hy5g3qiipv4cspkwbaggdmsxbll1f4jx2qnq5hm668d";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ];
    meta = {
      license = "perl";
    };
  };

  EmailAddress = buildPerlPackage {
    name = "Email-Address-1.897";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.897.tar.gz;
      sha256 = "17v5jvwhkd5clyihwsldnh4k7vpmaisn064s3mkxlr9dnz7nd10r";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "RFC 2822 Address Parsing";
      license = "perl5";
    };
  };

  EmailDateFormat = buildPerlPackage {
    name = "Email-Date-Format-1.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Date-Format-1.002.tar.gz;
      sha256 = "114fqcnmvzi0z100yx89j6rgwbicb0bslswhyr8z2pzsvwv3czqc";
    };
    meta = {
      description = "Produce RFC 8822 date strings";
      license = "perl";
    };
  };

  EmailSend = buildPerlPackage rec {
    name = "Email-Send-2.198";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0ffmpqys7yph5lb28m2xan0zd837vywg8c6gjjd9p80dahpqknyx";
    };
    propagatedBuildInputs = [EmailSimple EmailAddress ModulePluggable ReturnValue];
  };

  EmailSender = buildPerlPackage {
    name = "Email-Sender-0.120002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Sender-0.120002.tar.gz;
      sha256 = "1cp735ndmh76xzijsm1hd0yh0m9yj34jc8akjhidkn677h2021dc";
    };
    propagatedBuildInputs = [ CaptureTiny EmailAbstract EmailAddress EmailSimple ListMoreUtils Moose Throwable TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/email-sender;
      description = "A library for sending email";
      license = "perl5";
    };
  };

  EmailSimple = buildPerlPackage {
    name = "Email-Simple-2.102";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.102.tar.gz;
      sha256 = "19da1a06vnixhqfl41mfjrihvvxjgdgkq9bczp8k9mpr29xlbnq4";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      license = "perl5";
    };
  };

  EmailValid = buildPerlPackage {
    name = "Email-Valid-0.179";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-0.179.tar.gz;
      sha256 = "13yfjll63cp1y4xqzdcr1mjhfncn48v6hckk5mvwi47w3ccj934a";
    };
    propagatedBuildInputs = [MailTools NetDNS];
    doCheck = false;
  };

  Encode = buildPerlPackage {
    name = "Encode-2.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.44.tar.gz;
      sha256 = "c121f9c8ae03e718d1b5d5465d66bb3138af429188735966326656f99a9499c6";
    };
  };

  EncodeLocale = buildPerlPackage rec {
    name = "Encode-Locale-1.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Encode/${name}.tar.gz";
      sha256 = "0m9d1vdphlyzybgmdanipwd9ndfvyjgk3hzw250r299jjgh3fqzp";
    };
  };

  Error = buildPerlPackage rec {
    name = "Error-0.17016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1akr35g7nbhch8fgkrqixjy08gx19brp981wyxplscizwcya64zh";
    };
  };

  EvalClosure = buildPerlPackage {
    name = "Eval-Closure-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.08.tar.gz;
      sha256 = "01x449ljj8mhr3jgfvnhzn0zz3xc81krslxiq29srqccsqjf933k";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ SubExporter TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Safely and cleanly create closures via string eval";
      license = "perl5";
    };
  };

  ExceptionClass = buildPerlPackage rec {
    name = "Exception-Class-1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "54e256fdb317c1736c2c257fa63d5b87cfb382870711b24937c36eb5171b3154";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
  };

  ExtUtilsCBuilder = buildPerlPackage rec {
    name = "ExtUtils-CBuilder-0.280202";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "13qjdz1kmrp5mp404by94cdsyydjadg974ykinqga450djjaqpbq";
    };
  };

  ExtUtilsMakeMaker = buildPerlPackage rec{
    name = "ExtUtils-MakeMaker-6.59";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "0fwhb2cf5x7y87xwml66p624iynf0mzvhy1q4aq5yv7l3lhwhaby";
    };
    propagatedBuildInputs =
      [ ParseCPANMeta version JSONPP CPANMetaYAML CPANMeta
        FileCopyRecursive VersionRequirements ExtUtilsManifest
      ];
  };

  ExtUtilsManifest = buildPerlPackage rec {
    name = "ExtUtils-Manifest-1.59";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "0cb7mjmfsk2rlwdr5y91x2w5ffb0yjf9gblibk9wplivlpa48jhs";
    };
  };

  ExtUtilsParseXS = buildPerlPackage rec {
    name = "ExtUtils-ParseXS-3.15";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "06baf0nsmdkfk50p4x9kss4ncm8h49gkzy8hl5cxbxdsab65gmrb";
    };
  };

  FileChangeNotify = buildPerlModule rec {
    name = "File-ChangeNotify-0.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "000aiiijf16j5cf8gql4vr6l9y561famkfb5qv5d29xz2ad4mmd9";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose MooseXParamsValidate MooseXSemiAffordanceAccessor
        namespaceautoclean
      ] ++ stdenv.lib.optional stdenv.isLinux LinuxInotify2;
  };

  Filechdir = buildPerlPackage rec {
    name = "File-chdir-0.1006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "b26e91f8b5480544da599412612ff9287007be9703d41c35251f09c5ff19879a";
    };
  };

  FileBaseDir = buildPerlPackage rec {
    version = "0.03";
    name = "File-BaseDir-${version}";
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "0029cba7a3b5d8aa5f7d03cb1b7ba2bcf2829382f7f26aa3bee06fce8611a886";
    };
  };

  FileCopyRecursive = buildPerlPackage rec {
    name = "File-Copy-Recursive-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/${name}.tar.gz";
      sha256 = "1syyyvylr51iicialdmv0dw06q49xzv8zrkb5cn8ma4l73gvvk44";
    };
  };

  FileDesktopEntry = buildPerlPackage rec {
    version = "0.04";
    name = "File-DesktopEntry-${version}";
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "d7f80d8bd303651a43dc1810c73740d38a0d2b158fb33cd3b6ca4d3a566da7cb";
    };
    propagatedBuildInputs = [ FileBaseDir ];
  };

  FileFindRule = buildPerlPackage rec {
    name = "File-Find-Rule-0.32";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "0fdci3k9j8x69p28jb793gni4y9qbgzpfnnj1avzf8nnib9w1wrd";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob ];
  };

  FileListing = buildPerlPackage rec {
    name = "File-Listing-6.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "1xcwjlnxaiwwpn41a5yi6nz95ywh3szq5chdxiwj36kqsvy5000y";
    };
    propagatedBuildInputs = [ HTTPDate ];
  };

  FileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
    };
  };

  FileNext = buildPerlPackage rec {
    name = "File-Next-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "36cc0a4e5e4e44e04f7bea6f7453db517acc1a1b35a2b5fe5bc14cea0f560662";
    };
  };

  FileRemove = buildPerlPackage rec {
    name = "File-Remove-1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "2ec2643c4e1a721965ed70ce184b72ae831c82b577420612a59eba8a0ce2a504";
    };
  };

  FileShareDir = buildPerlPackage {
    name = "File-ShareDir-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-ShareDir-1.03.tar.gz;
      sha256 = "0fczaqjxyzmzgrmn3ib84cj6pd2085wsvni3wf5b018i21j2wi2r";
    };
    propagatedBuildInputs = [ ClassInspector ];
    meta = {
      description = "Locate per-dist and per-module shared files";
      license = "perl";
    };
  };

  FilesysNotifySimple = buildPerlPackage {
    name = "Filesys-Notify-Simple-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.08.tar.gz;
      sha256 = "042klyvi8fbkhmyg1h7883bbjdhiclmky9w2wfga7piq5il6nxgi";
    };
    meta = {
      description = "Simple and dumb file system watcher";
      license = "perl";
    };
  };

  FileTemp = null;

  FileSlurp = buildPerlPackage {
    name = "File-Slurp-9999.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/U/UR/URI/File-Slurp-9999.19.tar.gz;
      sha256 = "0hrn4nipwx40d6ji8ssgr5nw986z9iqq8cn0kdpbszh9jplynaff";
    };
    meta = {
      description = "Simple and Efficient Reading/Writing/Modifying of Complete Files";
      license = "perl";
    };
  };

  FileWhich = buildPerlPackage rec {
    name = "File-Which-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "b72fec6590160737cba97293c094962adf4f7d44d9e68dde7062ecec13f4b2c3";
    };
    propagatedBuildInputs = [ TestScript ];
  };

  FontAFM = buildPerlPackage rec {
    name = "Font-AFM-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1";
    };
  };

  FontTTF = buildPerlPackage {
    name = "Font-TTF-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHOSKEN/Font-TTF-0.43.tar.gz;
      sha256 = "0782mj5n5a2qbghvvr20x51llizly6q5smak98kzhgq9a7q3fg89";
    };
  };

  FreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.43.tar.gz;
      sha256 = "1qamc5aggp35xk590a4hy660f2rhc2l7j65hbyxdya9yvg7z437l";
    };
  };

  GD = buildPerlPackage rec {
    name = "GD-2.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "1p84585b4iyqa21hbqni0blj8fzd917ynd3y1hwh3mrmyfqj178x";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype
                    pkgs.libpng pkgs.fontconfig pkgs.xlibs.libXpm GetoptLong ];

    # Patch needed to get arguments past the first GetOptions call
    # and to specify libfontconfig search path.
    # Patch has been sent upstream.
    patches = [ ../development/perl-modules/gd-options-passthrough-and-fontconfig.patch ];

    # Remove a failing test.  The test does a binary comparison of a generated
    # file with a file packaged with the source, and these are different
    # ( although the images look the same to my eye ); this is
    # possibly because the source packaged image was generated with a
    # different version of some library ( libpng maybe? ).
    postPatch = "sed -ie 's/if (GD::Image->can(.newFromJpeg.)) {/if ( 0 ) {/' t/GD.t";

    makeMakerFlags = "--lib_png_path=${pkgs.libpng} --lib_jpeg_path=${pkgs.libjpeg} --lib_zlib_path=${pkgs.zlib} --lib_ft_path=${pkgs.freetype} --lib_fontconfig_path=${pkgs.fontconfig} --lib_xpm_path=${pkgs.xlibs.libXpm}";
  };

  GeoIP = buildPerlPackage rec {
    name = "Geo-IP-1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "1yc0rn67nk4z8aq8d82axhfmgi0l91rkksqbf27ylasrhyb6ykx5";
    };
    makeMakerFlags = "LIBS=-L${pkgs.geoip}/lib INC=-I${pkgs.geoip}/include";
    doCheck = false; # seems to access the network
  };

  GetoptLong = buildPerlPackage rec {
    name = "Getopt-Long-2.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/${name}.tar.gz";
      sha256 = "0lrsm8vlqhdnkzfvyaiyfivmaar0rirrnwa2v0qk6l130a497mky";
    };
  };

  GetoptLongDescriptive = buildPerlPackage {
    name = "Getopt-Long-Descriptive-0.093";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.093.tar.gz;
      sha256 = "0iccps0jlcjm68i5yywgs477plfnkc6b2386bzb99blm3jwdfyac";
    };
    propagatedBuildInputs = [ ParamsValidate SubExporter SubExporterUtil ];
    meta = {
      homepage = https://github.com/rjbs/Getopt-Long-Descriptive;
      description = "Getopt::Long, but simpler and more powerful";
      license = "perl5";
    };
  };

  GoogleProtocolBuffers = buildPerlPackage rec {
    name = "Google-ProtocolBuffers-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GARIEV/${name}.tar.gz";
      sha256 = "0pxfphg671wh56h59pf0zrj7m1cr0yga95hf3w54563pzcw2vqv3";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches =
      [ ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch ];
    meta = {
      description = "Simple interface to Google Protocol Buffers";
      license = "perl";
    };
  };

  Graph = buildPerlPackage rec {
    name = "Graph-0.94";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "1lyfl9s4mkhahnpxk2z5v6j750jqb4sls56b9rnkl5lni9ms7xgn";
    };

    buildInputs = [ TestPod TestPodCoverage ];
  };

  GraphViz = buildPerlPackage rec {
    name = "GraphViz-2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "1gxpajd49pb9w9ka7nq5477my8snp3myrgiarnk6hj922jpn62xd";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz ];
    propagatedBuildInputs = [ IPCRun TestMore ];

    meta = {
      description = "Perl interface to the GraphViz graphing tool";
      license = [ "Artistic" ];
      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };

  HashFlatten = buildPerlPackage rec {
    name = "Hash-Flatten-1.19";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Hash/${name}.tar.gz";
      sha256 = "162b9qgkr19f97w4pic6igyk3zd0sbnrhl3s8530fikciffw9ikh";
    };
    buildInputs = [ TestAssertions LogTrace ];
  };

  HashMerge = buildPerlPackage rec {
    name = "Hash-Merge-0.12";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Hash/${name}.tar.gz";
      sha256 = "07h7dyldxwqhq3x4fp9hacnc4vgipp0jk50b5cbvib975nfxx98z";
    };
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Merges arbitrarily deep hashes into a single hash";
    };
  };

  HashMultiValue = buildPerlPackage {
    name = "Hash-MultiValue-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Hash-MultiValue-0.13.tar.gz;
      sha256 = "0flflmk2kxq9sjmhxr1547lidgigibhck912j4ambdwg21sbxjjd";
    };
    meta = {
      description = "Store multiple values per key";
      license = "perl";
    };
  };

  HookLexWrap = buildPerlPackage rec {
    name = "Hook-LexWrap-0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/${name}.zip";
      sha256 = "eda90ba26f8a0cef02d38f08a1786a203beec1309279493c78eed13567d0fa7e";
    };
    buildInputs = [ pkgs.unzip ];
  };

  HTMLForm = buildPerlPackage {
    name = "HTML-Form-6.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Form-6.03.tar.gz;
      sha256 = "0dpwr7yz6hjc3bcqgcbdzjjk9l58ycdjmbam9nfcmm85y2a1vh38";
    };
    propagatedBuildInputs = [ HTMLParser HTTPMessage URI ];
    meta = {
      description = "Class that represents an HTML form element";
      license = "perl";
    };
  };

  HTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-0.09007";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "1yg9fy6s8f1jscfxf7a9hm91x43cjhk3ijw46z94sw8133h50rvy";
    };
    propagatedBuildInputs =
      [ ClassAccessorChained Clone ConfigAny
        DateCalc ListMoreUtils EmailValid
        DataVisitor DateTime DateTimeFormatBuilder
        DateTimeFormatStrptime DateTimeFormatNatural
        Readonly YAMLLibYAML NumberFormat HashFlatten
        HTMLTokeParserSimple RegexpCommon
        CaptchaReCAPTCHA HTMLScrubber FileShareDir
        TemplateToolkit CryptCBC CryptDES PathClass
        MooseXAttributeChained MooseXAliases MooseXSetOnce
      ];
  };

  HTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.69";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.69.tar.gz;
      sha256 = "01i4lj37dgwbj9mna756dzzz5lvx7adcnjk9s0hskqq0cn81r2vl";
    };
    propagatedBuildInputs = [ HTMLTagset ];
    meta = {
      description = "HTML parser class";
      license = "perl";
    };
  };

  HTMLScrubber = buildPerlPackage {
    name = "HTML-Scrubber-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/PODMASTER/HTML-Scrubber-0.08.tar.gz;
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [HTMLParser];
  };

  HTMLTagset = buildPerlPackage rec {
    name = "HTML-Tagset-3.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "1qh8249wgr4v9vgghq77zh1d2zs176bir223a8gh3k9nksn7vcdd";
    };
  };

  HTMLTemplate = buildPerlPackage rec {
    name = "HTML-Template-2.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/${name}.tar.gz";
      sha256 = "0is026jn1731lvfjglv4003dsr8drshvw25zlbjrywk59kx7nsb2";
    };
  };

  HTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1nc9vr0z699jwv8jaxxpkfhspiv7glhdp500hqyzdm2jxfw8azrg";
    };
  };

  HTMLTokeParserSimple = buildPerlPackage rec {
    name = "HTML-TokeParser-Simple-3.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "0ii1ww17h7wps1lcj7bxrjbisa37f6cvlm0xxpgfq1s6iy06q05b";
    };
    propagatedBuildInputs = [HTMLParser SubOverride];
    buildInputs = [TestPod];
  };

  HTMLTree = buildPerlModule {
    name = "HTML-Tree-5.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/HTML-Tree-5.03.tar.gz;
      sha256 = "13qlqbpixw470gnck0xgny8hyjj576m8y24bba2p9ai2lvy76vbx";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ HTMLParser HTMLTagset ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Work with HTML in a DOM-like tree structure";
      license = "perl5";
    };
  };

  HTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    propagatedBuildInputs = [
      TestNoWarnings ClassAccessor ClassAccessorChained
      ClassDataAccessor ModulePluggableFast HTMLTree
      HTMLScrubber EmailValid DateCalc
    ];
  };

  HTTPBody = buildPerlPackage {
    name = "HTTP-Body-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GE/GETTY/HTTP-Body-1.17.tar.gz;
      sha256 = "1476zdcg1cdal3ik6ccwm3rqfgsdac6b63f92wmipvn8lkjdl70k";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP Body Parser";
      license = "perl";
    };
  };

  HTTPCookies = buildPerlPackage {
    name = "HTTP-Cookies-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Cookies-6.01.tar.gz;
      sha256 = "087bqmg22dg3vj7gssh3pcsh9y1scimkbl5h1kc8jqyfhgisvlzm";
    };
    propagatedBuildInputs = [ HTTPDate HTTPMessage ];
    meta = {
      description = "HTTP cookie jars";
      license = "perl";
    };
  };

  HTTPDaemon = buildPerlPackage {
    name = "HTTP-Daemon-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Daemon-6.01.tar.gz;
      sha256 = "1hmd2isrkilf0q0nkxms1q64kikjmcw9imbvrjgky6kh89vqdza3";
    };
    propagatedBuildInputs = [ HTTPDate HTTPMessage LWPMediaTypes ];
    meta = {
      description = "A simple http server class";
      license = "perl";
    };
  };

  HTTPDate = buildPerlPackage {
    name = "HTTP-Date-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz;
      sha256 = "0cz357kafhhzw7w59iyi0wvhw7rlh5g1lh38230ckw7rl0fr9fg8";
    };
    meta = {
      description = "Date conversion routines";
      license = "perl";
    };
  };

  HTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  HTTPLite = buildPerlPackage rec {
    name = "HTTP-Lite-2.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "66f4fc0f93eeb42c09737f83b21de1944212ae9b2acb784d5103e8208491477b";
    };
  };

  HTTPMessage = buildPerlPackage {
    name = "HTTP-Message-6.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Message-6.06.tar.gz;
      sha256 = "0qxdrcak97azjvqyx1anpb2ky6vp6vc37x0wcfjdqfajkh09fzh8";
    };
    propagatedBuildInputs = [ EncodeLocale HTTPDate IOHTML LWPMediaTypes URI ];
    meta = {
      description = "HTTP style messages";
      license = "perl";
    };
  };

  HTTPNegotiate = buildPerlPackage {
    name = "HTTP-Negotiate-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz;
      sha256 = "05p053vjs5g91v5cmjnny7a3xzddz5k7vnjw81wfh01ilqg9qwhw";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "Choose a variant to serve";
      license = "perl";
    };
  };

  HTTPParserXS = buildPerlPackage rec {
    name = "HTTP-Parser-XS-0.14";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "06srbjc380kvvj76r8n5c2y282j5zfgn0s0zmb9h3shwrynfqj05";
    };
    buildInputs = [ TestMore ];
  };

  HTTPRequestAsCGI = buildPerlPackage rec {
    name = "HTTP-Request-AsCGI-1.2";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "1smwmiarwcgq7vjdblnb6ldi2x1s5sk5p15p7xvm5byiqq3znnwl";
    };
    propagatedBuildInputs = [ ClassAccessor LWP ];
  };

  HTTPResponseEncoding = buildPerlPackage {
    name = "HTTP-Response-Encoding-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz;
      sha256 = "1am8lis8107s5npca1xgazdy5sknknzcqyhdmc220s4a4f77n5hh";
    };
    propagatedBuildInputs = [ LWPUserAgent HTTPMessage ];
    meta = {
      description = "Adds encoding() to HTTP::Response";
    };
  };

  HTTPServerSimple = buildPerlPackage {
    name = "HTTP-Server-Simple-0.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-0.44.tar.gz;
      sha256 = "05klpfkss2a6i5ihmvcm27fyar0f2v4ispg2f49agab3va1gix6g";
    };
    doCheck = false;
    meta = {
      license = "perl";
    };
  };

  I18NLangTags = buildPerlPackage {
    name = "I18N-LangTags-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/I18N-LangTags-0.35.tar.gz;
      sha256 = "0idwfi7k8l44d9akpdj6ygdz3q8zxr690m18s7w23ms9d55bh3jy";
    };
  };

  IOCaptureOutput = buildPerlPackage rec {
    name = "IO-CaptureOutput-1.1102";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "2ea16dbecb21a3c2be49a93fb1e7e51275bed3f7ef3ac30cbdbff5d0178d43c7";
    };
  };

  IOCompress = buildPerlPackage {
    name = "IO-Compress-2.060";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PM/PMQS/IO-Compress-2.060.tar.gz;
      sha256 = "03zaq9xzg0z9wcgj1hws8zhzdgdlwiz48nh6sy663bn7rzxm5k28";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "IO Interface to compressed data files/buffers";
      license = "perl5";
    };
    doCheck = !stdenv.isDarwin;
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.10.tar.gz;
      sha256 = "1g6ilxqv2a7spf273v7k0721c6am7pwpjrin3h5zaqxfmd312nav";
    };
    propagatedBuildInputs = [PerlIOviadynamic];
  };

  IOHTML = buildPerlPackage {
    name = "IO-HTML-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-0.04.tar.gz;
      sha256 = "0c4hc76c1gypdwfasnibr2qlf9x3bnhyw357lhqlrczbm6vn8hw5";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Open an HTML file with automatic charset detection";
      license = "perl5";
    };
  };

  IOLockedFile = buildPerlPackage rec {
    name = "IO-LockedFile-0.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "1dgq8zfkaszisdb5hz8jgcl0xc3qpv7bbv562l31xgpiddm7xnxi";
    };
  };

  IOPager = buildPerlPackage {
    name = "IO-Pager-0.06.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
    };
  };

  IOSocketInet6 = buildPerlPackage rec {
    name = "IO-Socket-INET6-2.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "accd565643969d905e199e28e60e833213ccc2026c372432df01e49b044c3045";
    };
    propagatedBuildInputs = [Socket6];
    doCheck = false;
  };

  IOSocketSSL = buildPerlPackage rec {
    name = "IO-Socket-SSL-1.81";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "1vg7jpn7vz3a2j3fxjjkaxiiqg7azqmy7afrpghiqkjcr8b6zs9y";
    };
    propagatedBuildInputs = [ URI NetSSLeay ];
    meta = {
      description = "Nearly transparent SSL encapsulation for IO::Socket::INET";
      license = "perl";
    };
  };

  IOString = buildPerlPackage rec {
    name = "IO-String-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0";
    };
  };

  IOStringy = buildPerlPackage rec {
    name = "IO-stringy-2.110";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSKOLL/${name}.tar.gz";
      sha256 = "1vh4n0k22hx20rwvf6h7lp25wb7spg0089shrf92d2lkncwg8g3y";
    };
  };

  IOTty = buildPerlPackage rec {
    name = "IO-Tty-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "1cgqyv1zg8857inlnfczrrgpqr0r6mmqv29b7jlmxv47s4df59ii";
    };
  };

  IPCRun = buildPerlPackage {
    name = "IPC-Run-0.92";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz;
      sha256 = "1lj6kmr8rs6na77b3v673vvw6qsr511bmhgf257x4xqmvxnv91p1";
    };
    doCheck = false; /* attempts a network connection to localhost */
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "System() and background procs w/ piping, redirs, ptys (Unix, Win32)";
      license = "perl5";
    };
  };

  IPCRun3 = buildPerlPackage rec {
    name = "IPC-Run3-0.043";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "96b534e07e1459529ac12a77393628366f30d122b0dfaaa3ed5ec032079097ad";
    };
  };

  IPCShareLite = buildPerlPackage rec {
    name = "IPC-ShareLite-0.17";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IPC/${name}.tar.gz";
      sha256 = "1gz7dbwxrzbzdsjv11kb49jlf9q6lci2va6is0hnavd93nwhdm0l";
    };
  };

  ImageExifTool = buildPerlPackage rec {
    name = "Image-ExifTool-8.41";

    src = fetchurl {
      url = "http://www.sno.phy.queensu.ca/~phil/exiftool/${name}.tar.gz";
      sha256 = "1fdjic0bhbai8zzl3287i9wcs88khiv8qx5slx9n3gzvbnxacvqg";
    };

    meta = {
      description = "ExifTool, a tool to read, write and edit EXIF meta information";
      homepage = http://www.sno.phy.queensu.ca/~phil/exiftool/;

      longDescription = ''
        ExifTool is a platform-independent Perl library plus a command-line
        application for reading, writing and editing meta information in
        image, audio and video files.  ExifTool supports many different types
        of metadata including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC
        Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker
        notes of many digital cameras by Canon, Casio, FujiFilm, HP,
        JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon,
        Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Ricoh, Sanyo,
        Sigma/Foveon and Sony.
      '';

      licenses = [ "GPLv1+" /* or */ "Artistic" ];

      maintainers = [ stdenv.lib.maintainers.ludo ];
      platforms = stdenv.lib.platforms.unix;
    };
  };

  Inline = buildPerlPackage rec {
    name = "Inline-0.45";

    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SISYPHUS/${name}.tar.gz";
      sha256 = "1k5nrb3nh2y33bs944ri78m1ni60v4cl67ffhxx88azj542y5c9x";
    };

    propagatedBuildInputs = [ ParseRecDescent ];

    meta = {
      description = "Inline -- Write Perl subroutines in other programming languages";

      longDescription = ''
        The Inline module allows you to put source code from other
        programming languages directly "inline" in a Perl script or
        module. The code is automatically compiled as needed, and then loaded
        for immediate access from Perl.
      '';

      license = "Artistic";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };

  InlineJava = buildPerlPackage rec {
    name = "Inline-Java-0.52";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PATL/${name}.tar.gz";
      sha256 = "0xdx1nnjvsih2njcncmwxwdi3w2zf74vqb9wpn1va8ii93mlakff";
    };

    propagatedBuildInputs = [ Inline ];

    makeMakerFlags = "J2SDK=${pkgs.jdk}";

    # FIXME: Apparently tests want to access the network.
    doCheck = false;

    meta = {
      description = "Inline::Java -- Write Perl classes in Java";

      longDescription = ''
        The Inline::Java module allows you to put Java source code directly
        "inline" in a Perl script or module.  A Java compiler is launched and
        the Java code is compiled.  Then Perl asks the Java classes what
        public methods have been defined.  These classes and methods are
        available to the Perl program as if they had been written in Perl.
      '';

      license = "Artistic";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };

  IPCSignal = buildPerlPackage rec {
    name = "IPC-Signal-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1l3g0zrcwf2whwjhbpwdcridb7c77mydwxvfykqg1h6hqb4gj8bw";
    };
  };

  JSON = buildPerlPackage {
    name = "JSON-2.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.53.tar.gz;
      sha256 = "0rfms17d0pkai26kqyzaylbr5wxcrrhyjkyshq85l41xb0g1iplh";
    };
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = "perl";
    };
  };

  JSONAny = buildPerlPackage {
    name = "JSON-Any-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/JSON-Any-1.29.tar.gz;
      sha256 = "15v2j9dh58r7r4s7rnnmgnzzbyz61bhyxwpx1z7r811ixs9bkks2";
    };
    buildInputs = [ JSON ];
    meta = {
      description = "Wrapper Class for the various JSON classes.";
      license = "perl";
    };
  };

  JSONPP = buildPerlPackage rec {
    name = "JSON-PP-2.27200";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27200.tar.gz;
      sha256 = "1lv9riws9f72gya2fsp5jvbd1fbzyi8423x38a491ryy9cai2ph3";
    };
    meta = {
      description = "JSON::XS compatible pure-Perl module.";
      license = "perl";
    };
  };

  JSONXS = buildPerlPackage {
    name = "JSON-XS-2.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-2.33.tar.gz;
      sha256 = "0p68f85xz6xx2c9ydz4bij5x4d1747rxs3jdq53ab915mnc1qfdl";
    };
    propagatedBuildInputs = [ CommonSense ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  libxml_perl = buildPerlPackage rec {
    name = "libxml-perl-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "1jy9af0ljyzj7wakqli0437zb2vrbplqj4xhab7bfj2xgfdhawa5";
    };
    propagatedBuildInputs = [XMLParser];
  };

  LinguaENInflect = buildPerlPackage {
    name = "Lingua-EN-Inflect-1.895";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.895.tar.gz;
      sha256 = "0drzg9a2dkjxgf00n6jg0jzhd8972bh3j4wdnmdxpqi3zmfqhwcy";
    };
    meta = {
      description = "Convert singular to plural";
    };
  };

  LinguaENInflectNumber = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Number-1.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "13hlr1srp9cd9mcc78snkng9il8iavvylfyh81iadvn2y7wikwfy";
    };
    propagatedBuildInputs = [ LinguaENInflect ];
  };

  LinguaENInflectPhrase = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Phrase-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "1l7sjnibnvgb7a73cjhysmrg4j2bfcn0x5yrqmh0v23laj9fsbbm";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs =
      [ LinguaENInflect LinguaENInflectNumber LinguaENTagger ];
  };

  LinguaENTagger = buildPerlPackage {
    name = "Lingua-EN-Tagger-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.23.tar.gz;
      sha256 = "0xq6567gijczxzq72ghfa9jr8zyc1p0ax9s12mv7slibpkfkm2d2";
    };
    propagatedBuildInputs = [ HTMLParser HTMLTagset LinguaStem /* MemoizeExpireLRU */ ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing.";
      license = "gpl_3";
    };
  };

  LinguaStem = buildPerlPackage rec {
    name = "Lingua-Stem-0.84";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "12avh2mnnc7llmmshrr5bgb473fvydxnlqrqbl2815mf2dp4pxcg";
    };
    doCheck = false;
  };

  LinuxInotify2 = buildPerlPackage rec {
    name = "Linux-Inotify2-1.22";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Linux/${name}.tar.gz";
      sha256 = "1l916p8xak6c51x4x1vrzd8wpi55bld74wf0p5w5m4vr80zjb7dw";
    };
    propagatedBuildInputs = [ CommonSense ];
  };

  ListMoreUtils = buildPerlPackage {
    name = "List-MoreUtils-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/List-MoreUtils-0.33.tar.gz;
      sha256 = "1bcljhhsk5g0xykvgbxz10ilmj02s58ydiy3g8hbzdr29i20np1i";
    };
    meta = {
      description = "Provide the stuff missing in List::Util";
      license = "perl";
    };
  };

  LocaleGettext = buildPerlPackage {
    name = "LocaleGettext-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.05.tar.gz;
      sha256 = "15262a00vx714szpx8p2z52wxkz46xp7acl72znwjydyq4ypydi7";
    };
  };

  LocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Locale-Maketext-1.13.tar.gz;
      sha256 = "0qvrhcs1f28ix3v8hcd5xr4z9s7plz4g5a4q1cjp7bs0c3w2yl6z";
    };
    propagatedBuildInputs = [I18NLangTags];
  };

  LocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-0.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Lexicon-0.66.tar.gz;
      sha256 = "1cd2kbcrlyjcmlr7m8kf94mm1hlr7hpv1r80a596f4ljk81f2nvd";
    };
    propagatedBuildInputs = [LocaleMaketext];
  };

  LocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Simple-0.18.tar.gz;
      sha256 = "14kx7vkxyfqndy90rzavrjp2346aidyc7x5dzzdj293qf8s4q6ig";
    };
  };

  LockFileSimple = buildPerlPackage rec {
    name = "LockFile-Simple-0.207";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/LockFile-Simple-0.207.tar.gz";
      sha256 = "171vi9y6jlkny0d4jaavz48d1vbxljknnmbq8h22fi8lnc5kvipa";
    };
  };

  LogTrace = buildPerlPackage rec {
    name = "Log-Trace-1.070";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Log/${name}.tar.gz";
      sha256 = "1qrnxn9b05cqyw1286djllnj8wzys10754glxx6z5hihxxc85jwy";
    };
  };

  LWP = buildPerlPackage {
    name = "libwww-perl-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/libwww-perl-6.04.tar.gz;
      sha256 = "0z92fpwk6lh2gghv050r0qb216jmjl2m0c6zby935q8lv0q5wwgr";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPNegotiate HTTPMessage LWPMediaTypes NetHTTP URI WWWRobotRules ];
    doCheck = false; # tries to start a daemon
    meta = {
      description = "The World-Wide Web library for Perl";
      license = "perl";
    };
  };

  LWPMediaTypes = buildPerlPackage {
    name = "LWP-MediaTypes-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/LWP-MediaTypes-6.02.tar.gz;
      sha256 = "0xmnblp962qy02akah30sji8bxrqcyqlff2w95l199ghql60ny8q";
    };
    meta = {
      description = "Guess media type for a file or a URL";
      license = "perl";
    };
  };

  LWPProtocolHttps = buildPerlPackage rec {
    name = "LWP-Protocol-https-6.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/LWP/${name}.tar.gz";
      sha256 = "0y2an4v7g4jm8fsszk2489m179i28kx79ywwiywkwk1aw3yqh0y5";
    };
    patches = [ ../development/perl-modules/lwp-protocol-https-cert-file.patch ];
    propagatedBuildInputs = [ LWP IOSocketSSL ];
    doCheck = false; # tries to connect to https://www.apache.org/.
  };

  LWPUserAgent = buildPerlPackage {
    name = "LWP-UserAgent-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/libwww-perl-6.04.tar.gz;
      sha256 = "0z92fpwk6lh2gghv050r0qb216jmjl2m0c6zby935q8lv0q5wwgr";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPNegotiate HTTPMessage LWPMediaTypes NetHTTP URI WWWRobotRules ];
    meta = {
      description = "The World-Wide Web library for Perl";
      license = "perl";
    };
  };

  LWPxParanoidAgent = buildPerlPackage rec {
    name = "LWPx-ParanoidAgent-1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRADFITZ/${name}.tar.gz";
      sha256 = "bd7ccbe6ed6b64195a967e9b2b04c185b7b97e8ec5a8835bb45dbcd42a18e76a";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
  };

  maatkit = import ../development/perl-modules/maatkit {
    inherit fetchurl buildPerlPackage stdenv DBDmysql;
  };

  MailDKIM = buildPerlPackage rec {
    name = "Mail-DKIM-0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JASLONG/${name}.tar.gz";
      sha256 = "b1425a540f514c483e80566fb3decc2c1db4162306f6ae8794cef72a2d73557b";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA NetDNS MailTools ];
    doCheck = false; # tries to access the domain name system
  };

  MailIMAPClient = buildPerlPackage {
    name = "Mail-IMAPClient-2.2.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DJ/DJKERNEN/Mail-IMAPClient-2.2.9.tar.gz;
      sha256 = "1jb04mn66d6022xjqmax49cdn55f2fdzp6knfnchmrcmf90a8rzs";
    };
    buildInputs = [ParseRecDescent];
  };

  MailTools = buildPerlPackage {
    name = "MailTools-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.04.tar.gz;
      sha256 = "0w91rcrz4v0pjdnnv2mvlbrm9ww32f7ajhr7xkjdhhr3455p7adx";
    };
    propagatedBuildInputs = [TimeDate TestPod];
  };

  MathRound = buildPerlPackage rec {
    name = "Math-Round-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "194dvggf1cmzc701j4wma38jgrcv2pwwzk69rnysjjdcjdv6y255";
    };
  };

  MIMEBase64 = buildPerlPackage rec {
    name = "MIME-Base64-3.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1gi2zyxwkkmyng8jawfnbxpsybvybz6h6ryq0wfdljmmjpjbmzzc";
    };
  };

  mimeConstruct = buildPerlPackage rec {
    name = "mime-construct-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "00wk9950i9q6qwp1vdq9xdddgk54lqd0bhcq2hnijh8xnmhvpmsc";
    };
    buildInputs = [ ProcWaitStat ];
  };

  MIMETypes = buildPerlPackage {
    name = "MIME-Types-1.38";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-1.38.tar.gz;
      sha256 = "12m8cvj80qbwxckj5jildl5zw6p1jincj3m1s77z6lnw3h59rj4l";
    };
    meta = {
      description = "Definition of MIME types";
      license = "perl5";
    };
  };

  ModuleBuild = buildPerlPackage {
    name = "Module-Build-0.4003";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-0.4003.tar.gz;
      sha256 = "1izx26gfnjffnj0j601hkc008b31y9f25hms1nzidfkb6r3110s2";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Build and install Perl modules";
      license = "perl5";
    };
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.06.tar.gz;
      sha256 = "1394jk0rn2zmchpl11kim69xh5h5yzg96jdlf76fqrk3dcn0y2ip";
    };
  };

  ModuleImplementation = buildPerlPackage {
    name = "Module-Implementation-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Module-Implementation-0.06.tar.gz;
      sha256 = "0v8qajzkpkwb9mfj2p46j352bwiszkg1zk778b008axqb817hfys";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Loads one of several alternate underlying implementations for a module";
      license = "artistic_2";
    };
  };

  ModuleInstall = buildPerlPackage {
    name = "Module-Install-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Module-Install-1.06.tar.gz;
      sha256 = "06a5375q1cr21rzcr07z3n8w6hv611a9p199jrnpsj9vbcwwi7ny";
    };
    buildInputs = [ YAMLTiny ];
    propagatedBuildInputs = [ FileRemove LWPUserAgent ModuleScanDeps PARDist YAMLTiny ];
    meta = {
      description = "Standalone, extensible Perl module installer";
      license = "perl";
    };
  };

  ModuleMetadata = buildPerlPackage rec {
    name = "Module-Metadata-1.000005";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Module/${name}.tar.gz";
      sha256 = "04xxs3542mqdadcs2bdlpyldmbbxdn9x0gwjnyy5p1d5c3ajnq9k";
    };
    propagatedBuildInputs = [ version ];
  };

  ModulePluggable = buildPerlPackage rec {
    name = "Module-Pluggable-3.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMONW/${name}.tar.gz";
      sha256 = "0psryh1dz828zly92db9zcv905n82in2awixzqngqhzg4y7fg4wc";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
  };

  ModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Module-Pluggable-Fast-0.18.tar.gz;
      sha256 = "140c311x2darrc2p1drbkafv7qwhzdcff4ad300n6whsx4dfp6wr";
    };
    propagatedBuildInputs = [UNIVERSALrequire];
  };

  ModuleRuntime = buildPerlPackage {
    name = "Module-Runtime-0.013";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.013.tar.gz;
      sha256 = "08qhqg1qshrispcpzf24jbbpx2gh5ks84amnv9wmd46wj0yy0dzc";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Runtime module handling";
      license = "perl5";
    };
  };

  ModuleScanDeps = buildPerlPackage {
    name = "Module-ScanDeps-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.10.tar.gz;
      sha256 = "0z85zqvqpj2ck80sw91hmzn94q8m3s40anybw324xh3pcrm9cg5s";
    };
    meta = {
      description = "Recursively scan Perl code for dependencies";
      license = "perl";
    };
  };

  Moo = buildPerlPackage {
    name = "Moo-1.000007";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Moo-1.000007.tar.gz;
      sha256 = "02q5j5vsfv8ykzmkqk8zac88svard4g6rl455slgz8y2w3xn41ql";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers DevelGlobalDestruction ModuleRuntime RoleTiny strictures ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatiblity)";
      license = "perl5";
    };
  };

  Moose = buildPerlPackage {
    name = "Moose-2.0604";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Moose-2.0604.tar.gz;
      sha256 = "0nwvklb8dwf8lskwxik3gi9gsqzrix2jhc56zvfzlf1q5q1s07qj";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ClassLoadXS DataOptList DevelGlobalDestruction DistCheckConflicts EvalClosure ListMoreUtils MROCompat PackageDeprecationManager PackageStash PackageStashXS ParamsUtil SubExporter SubName TaskWeaken TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A postmodern object system for Perl 5";
      license = "perl5";
    };
  };

  MooseAutobox = buildPerlPackage rec {
    name = "Moose-Autobox-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "12wsm576mc5sdqc1bhim9iazdx4fy336gz10zwwalygri3arlvgh";
    };
    propagatedBuildInputs = [Moose TestException Autobox Perl6Junction];
  };

  MooseXAliases = buildPerlPackage rec {
    name = "MooseX-Aliases-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "1n3z06x6d7sl2can7gn1q4qpclg6sjl6i8fd9y3yipmaxbk97clz";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAttributeChained = buildPerlModule rec {
    name = "MooseX-Attribute-Chained-1.0.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "101kwjzidppcsnyvp9x1vw8vpvkp1cc1csqmzbashwvqy8d0g4af";
    };
    propagatedBuildInputs = [ Moose TryTiny ];
  };

  MooseXDaemonize = buildPerlPackage {
    name = "MooseX-Daemonize-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MICHAELR/MooseX-Daemonize-0.15.tar.gz;
      sha256 = "1h6rzdmk68q4p0nh2bzmwwvr5iaf7pvdfrpwdxmr3z5pc64wajvd";
    };
    buildInputs = [ TestMoose ];
    propagatedBuildInputs = [ Moose MooseXGetopt MooseXTypesPathClass ];
    meta = {
      description = "Role for daemonizing your Moose based application";
      license = "perl";
    };
  };

  MooseXEmulateClassAccessorFast = buildPerlPackage {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00903";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/MooseX-Emulate-Class-Accessor-Fast-0.00903.tar.gz;
      sha256 = "1lkn1h4sxr1483jicsgsgzclbfw63g2i2c3m4v4j9ar75yrb0kh8";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose namespaceclean ];
    meta = {
      description = "Emulate Class::Accessor::Fast behavior using Moose attributes";
      license = "perl";
    };
  };

  MooseXGetopt = buildPerlPackage {
    name = "MooseX-Getopt-0.50";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Getopt-0.50.tar.gz;
      sha256 = "0fwm5vb8z8q4b6fmf7gz4xzw5z713mmfnxzjph6vfyyymlr5bll9";
    };
    buildInputs = [ PathClass TestCheckDeps TestFatal TestMoose TestNoWarnings TestRequires TestTrap TestWarn ];
    propagatedBuildInputs = [ GetoptLongDescriptive Moose MooseXRoleParameterized ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Getopt;
      description = "A Moose role for processing command line options";
      license = "perl5";
    };
  };

  MooseXMarkAsMethods = buildPerlPackage {
    name = "MooseX-MarkAsMethods-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSRCHBOY/MooseX-MarkAsMethods-0.15.tar.gz;
      sha256 = "1y3yxwcjjajm66pvca54cv9fax7a6dy36xqr92x7vzyhfqrw3v69";
    };
    buildInputs = [ TestMoose ];
    propagatedBuildInputs = [ BHooksEndOfScope Moose namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-MarkAsMethods/;
      description = "Mark overload code symbols as methods";
      license = "lgpl_2_1";
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    name = "MooseX-MethodAttributes-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.28.tar.gz;
      sha256 = "0srk85z6py9brw1jfvacd76y6219wycq3dj0wackbkmmbq04ln0g";
    };
    buildInputs = [ namespaceautoclean TestCheckDeps TestException ];
    propagatedBuildInputs = [ Moose MooseXTypes namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-methodattributes;
      description = "Code attribute introspection";
      license = "perl5";
    };
  };

  MooseXNonMoose = buildPerlPackage {
    name = "MooseX-NonMoose-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.22.tar.gz;
      sha256 = "0mhyabg5f6kngkm1w7hfglkdzjdn5pbgm7vgia0aqy9mwwclbpdp";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      license = "perl5";
    };
  };

  MooseXSetOnce = buildPerlPackage rec {
    name = "MooseX-SetOnce-0.200001";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0qa2i45g2zn4r0wg7hba9va68nin5l63gr9l8b5q3hr4cjn97ll6";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXParamsValidate = buildPerlPackage {
    name = "MooseX-Params-Validate-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Params-Validate-0.18.tar.gz;
      sha256 = "02yim0lmr7p2nzswy97d5ylbs4ksmgklqq350p119i2611x7ai0k";
    };
    buildInputs = [ Moose TestFatal ];
    propagatedBuildInputs = [ DevelCaller Moose ParamsValidate SubExporter ];
    meta = {
      description = "An extension of Params::Validate using Moose's types";
      license = "perl5";
    };
  };

  MooseXRoleParameterized = buildPerlPackage {
    name = "MooseX-Role-Parameterized-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/MooseX-Role-Parameterized-1.00.tar.gz;
      sha256 = "0642h71j90i0jrqxz1snizkw9pch8v1s1w0zndrcl5bb85lx3z7y";
    };
    buildInputs = [ TestFatal TestMoose ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://github.com/sartak/MooseX-Role-Parameterized/tree;
      description = "Roles with composition parameters";
      license = "perl";
    };
  };

  MooseXRoleWithOverloading = buildPerlPackage {
    name = "MooseX-Role-WithOverloading-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-WithOverloading-0.13.tar.gz;
      sha256 = "01mqpvbz7yw993918hgp72vl22i6mgicpq5b3zrrsp6vl8sqj2sw";
    };
    buildInputs = [ TestCheckDeps TestNoWarnings ];
    propagatedBuildInputs = [ aliased Moose namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Role-WithOverloading;
      description = "Roles which support overloading";
      license = "perl5";
    };
  };

  MooseXSemiAffordanceAccessor = buildPerlPackage rec {
    name = "MooseX-SemiAffordanceAccessor-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "1724cxvgy1wh1kfawcj2sanlm90zarfh7k186pgyx1lk8fhnlj4m";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXTraits = buildPerlPackage rec {
    name = "MooseX-Traits-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "0sqmpf2kw25847fwrrwpcfhrq694bgs8jbix7qxp9qyjm769np6n";
    };
    buildInputs = [ TestException TestUseOk ];
    propagatedBuildInputs = [ ClassMOP Moose namespaceautoclean ];
  };

  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0gv79bsnacrzwpac3dll64zj40qcsbp4kdk8yr9z5bwim7nkvnv3";
    };
    buildInputs =[ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose namespaceautoclean ListMoreUtils ];
  };

  MooseXTypes = buildPerlPackage {
    name = "MooseX-Types-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Types-0.35.tar.gz;
      sha256 = "11namg9pjw328ybvj70cgn15aac093jwdm4jv0b173gb7vkflx8a";
    };
    buildInputs = [ TestFatal TestMoose TestRequires ];
    propagatedBuildInputs = [ CarpClan Moose namespaceclean SubInstall SubName ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Organise your Moose types in libraries";
      license = "perl5";
    };
  };

  MooseXTypesCommon = buildPerlPackage rec {
    name = "MooseX-Types-Common-0.001002";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0mddl25gkb3qggdfx9fjzs321bj89y8dr4bw307l1dr3zr082xkr";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose MooseXTypes ];
  };

  MooseXTypesLoadableClass = buildPerlPackage rec {
    name = "MooseX-Types-LoadableClass-0.006";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "035d2gzq1j60skn39jav2jr6sbx1hq9vqmmfjfc3cvhahfzrygs4";
    };
    propagatedBuildInputs = [ ClassLoad Moose MooseXTypes namespaceclean ];
  };

  MooseXTypesPathClass = buildPerlPackage {
    name = "MooseX-Types-Path-Class-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THEPLER/MooseX-Types-Path-Class-0.06.tar.gz;
      sha256 = "02lw86r6pp6saiwc7ns890mlwq93vhkqyri3cipsfwhnhcap847g";
    };
    propagatedBuildInputs = [ ClassMOP Moose MooseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Moose";
      license = "perl";
    };
  };

  Mouse = buildPerlPackage rec {
    name = "Mouse-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "0dpf5qmf1vc8dq5nj6yiriz8v4wl8s9g519v1hnz4yf11n2lnr4x";
    };
    propagatedBuildInputs = [TestException];
    doCheck = false; # check can't find its own Mouse::Tiny module
  };

  MROCompat = buildPerlPackage {
    name = "MRO-Compat-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/MRO-Compat-0.12.tar.gz;
      sha256 = "1mhma2g83ih9f8nkmg2k9l0x6izhhbb6k5lli4rpllxad4wbk9dv";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      license = "perl";
    };
  };

  MusicBrainzDiscID = buildPerlModule rec {
    name = "MusicBrainz-DiscID-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NJ/NJH/${name}.tar.gz";
      sha256 = "0fjph2q3yp0aa87gckv3391s47m13wbyylj7jb7vqx7hv0pzj0jh";
    };
    # Build.PL in this package uses which to find pkg-config -- make it use path instead
    patchPhase = ''sed -ie 's/`which pkg-config`/"pkg-config"/' Build.PL'';
    doCheck = false; # The main test performs network access
    #buildInputs = [ TestMore TestPod ];
    buildInputs = [ pkgs.pkgconfig ];
    propagatedBuildInputs = [ pkgs.libdiscid ];
  };

  MusicBrainz = buildPerlPackage rec {
    name = "WebService-MusicBrainz-0.93";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BF/BFAIST/${name}.tar.gz";
      sha256 = "1gg62x6qv4jj73jsqh0sb237k96i22blj29afpbp1scp3m7i5g61";
    };
    propagatedBuildInputs = [ XMLLibXML LWP ClassAccessor URI ];
    doCheck = false; # Test performs network access.
  };

  namespaceautoclean = buildPerlPackage rec {
    name = "namespace-autoclean-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/namespace-autoclean-0.13.tar.gz;
      sha256 = "1w53k9f9zla90qdn7cyc9dx8zcv26gwy2y87gcazqsq1aj371m04";
    };
    buildInputs = [ Moose SubName ];
    propagatedBuildInputs = [ BHooksEndOfScope ClassMOP namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/namespace-autoclean;
      description = "Keep imports out of your namespace";
      license = "perl5";
    };
  };

  namespaceclean = buildPerlPackage rec {
    name = "namespace-clean-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/namespace-clean-0.24.tar.gz;
      sha256 = "0c0jj44f3y26scybnxp2lnkcydjqh0lfr6l1jsy13r3x9r4d8qd6";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      homepage = http://search.cpan.org/dist/namespace-clean;
      description = "Keep imports and functions out of your namespace";
      license = "perl5";
    };
  };

  NetAddrIP = buildPerlPackage rec {
    name = "NetAddr-IP-4.062";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/${name}.tar.gz";
      sha256 = "08c037afe314ca2e6369f8aa92eb4b8937f493f977f9f1f35ca396c1de8ed0c6";
    };
  };

  NetAmazonEC2 = buildPerlPackage rec {
    name = "Net-Amazon-EC2-0.14-stanaka-bc66577e13";
    src = fetchurl {
      url = https://github.com/stanaka/net-amazon-ec2/zipball/bc66577e1312e828e252937d95f9f5f637af6a0b;
      sha256 = "1c0k3addkaaf4zj7z87svm9xc3c06v0r06rf5rpqmps413lqisbn";
      name  = "${name}.zip";
    };
    buildInputs = [ pkgs.unzip ];
    patches =
      [ # In DescribeInstance requests, say "InstanceId.1" instead of
        # "InstanceId", as required by the Amazon spec.  EC2 tolerates
        # "InstanceId", but Nova doesn't.
        ../development/perl-modules/net-amazon-ec2-nova-compat.patch
        # Support DescribeInstancesV6.
        ../development/perl-modules/net-amazon-ec2-ipv6.patch
      ];
    propagatedBuildInputs =
      [ DigestHMAC LWP LWPProtocolHttps Moose URI ParamsValidate XMLSimple ];
    doCheck = false; # wants to create actual EC2 instances (for $$$)
  };

  NetAmazonMechanicalTurk = buildPerlPackage rec {
    name = "Net-Amazon-MechanicalTurk-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MT/MTURK/${name}.tar.gz";
      sha256 = "17xh6qcp2sw721r8cpcal80an49264db497namms4k139fsr1yig";
    };
    patches =
      [ ../development/perl-modules/net-amazon-mechanicalturk.patch ];
    propagatedBuildInputs =
      [ DigestHMAC LWP LWPProtocolHttps URI XMLParser IOString ];
    buildInputs = [ DBI DBDSQLite ];
  };

  NetDNS = buildPerlPackage {
    name = "Net-DNS-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OL/OLAF/Net-DNS-0.63.tar.gz;
      sha256 = "1pswrwhkav051xahm3k4cbyhi8kqpfmaz85lw44kwi2wc7mz4prk";
    };
    propagatedBuildInputs = [NetIP DigestHMAC];
    doCheck = false;
  };

  NetHTTP = buildPerlPackage {
    name = "Net-HTTP-6.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Net-HTTP-6.05.tar.gz;
      sha256 = "1r2bv3cw4m054qfsm6i7rpvhrql1d78izpc36prv3xvahfsqxawc";
    };
    meta = {
      description = "Low-level HTTP connection (client)";
      license = "perl";
    };
  };

  NetIP = buildPerlPackage {
    name = "Net-IP-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz;
      sha256 = "0ffn2xqqbkfi7v303sp5dwgbv36jah3vg8r4nxhxfiv60vric3q4";
    };
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
    };
  };

  NetLDAP = buildPerlPackage {
    name = "Net-LDAP-0.43";
    propagatedBuildInputs = [ ConvertASN1 ];
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/perl-ldap-0.43.tar.gz;
      sha256 = "0ak7393zs8ps6r6in5ilr9l1mzxxh529jr768sjzx4273p7li3m0";
    };
  };

  NetOAuth = buildPerlPackage {
    name = "Net-OAuth-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz;
      sha256 = "0k4h4a5048h7qgyx25ih64x0l4airx8a6d9gjq08wmxcl2fk3z3v";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable DigestHMAC DigestSHA1 LWPUserAgent URI ];
    meta = {
      description = "An implementation of the OAuth protocol";
      license = "perl";
    };
  };

  NetServer = buildPerlPackage {
    name = "Net-Server-2.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHANDOM/Net-Server-2.007.tar.gz;
      sha256 = "0a03m237cw6j5bvm2yxk2b2gbfx7wj0w2x5zivi9ddqvbcad6vqw";
    };
    doCheck = false; # seems to hang waiting for connections
    meta = {
      description = "Extensible, general Perl server engine";
    };
  };

  NetSMTP = buildPerlPackage {
    name = "Net-SMTP-1.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/libnet-1.22.tar.gz;
      sha256 = "113c36qilbvd69yhkm2i2ba20ajff7cdpgvlqx96j9bb1hfmhb1p";
    };
    patchPhase = "chmod a-x Configure";
    doCheck = false; # The test suite fails, because it requires network access.
  };

  NetSMTPSSL = buildPerlPackage {
    name = "Net-SMTP-SSL-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWEST/Net-SMTP-SSL-1.01.tar.gz;
      sha256 = "12b2xvrd253ngvzwf81s9han4jr94l39vs5ca70pzr3wpi39qn8k";
    };
    propagatedBuildInputs = [IOSocketSSL];
  };

  NetSMTPTLS = buildPerlPackage {
    name = "Net-SMTP-TLS-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AW/AWESTHOLM/Net-SMTP-TLS-0.12.tar.gz;
      sha256 = "19g48kabj22v66jbf69q78xplhi7r1y2kdbddfwh4xy3g9k75rzg";
    };
    propagatedBuildInputs = [IOSocketSSL DigestHMAC];
  };

  NetSSLeay = buildPerlPackage rec {
    name = "Net-SSLeay-1.52";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Net/${name}.tar.gz";
      sha256 = "1fkpdlpg99rdq2vlm6bgmqc8iazhcrfzvbpwxnn20k0viwpy7v28";
    };
    buildInputs = [ pkgs.openssl ];
    OPENSSL_PREFIX = pkgs.openssl;
    doCheck = false; # Test performs network access.
    meta = {
      description = "Perl extension for using OpenSSL";
      license = "SSLeay";
    };
  };

  NetTwitterLite = buildPerlPackage {
    name = "Net-Twitter-Lite-0.11002";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.11002.tar.gz;
      sha256 = "032gyn1h3r5d83wvz7nj3k7g50wcf73lbbmjc18466ml90vigys0";
    };
    propagatedBuildInputs = [ CryptSSLeay LWPUserAgent NetOAuth URI ];
    doCheck = false;
    meta = {
      homepage = http://github.com/semifor/Net-Twitter-Lite;
      description = "A perl interface to the Twitter API";
      license = "perl";
    };
  };

  NumberCompare = buildPerlPackage rec {
    name = "Number-Compare-0.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Number/${name}.tar.gz";
      sha256 = "1vs95lbax3f63jg98jwkiahlvg1jhmd0xyyzmbxxifsl7fkv1d9j";
    };
  };

  NumberFormat = buildPerlPackage rec {
    name = "Number-Format-1.73";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Number/${name}.tar.gz";
      sha256 = "0v74hscnc807kf65x0am0rddk74nz7nfk3gf16yr5ar1xwibg8l4";
    };
  };

  ObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.05.tar.gz;
      sha256 = "10k9j18jpb16brv0hs7592r7hx877290pafb8gnk6ydy7hcq9r2j";
    };
  };

  OLEStorageLight = buildPerlPackage rec {
    name = "OLE-Storage_Lite-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "179cxwqxb0f9dpx8954nvwjmggxxi5ndnang41yav1dx6mf0abp7";
    };
  };

  NetOpenIDCommon = buildPerlPackage rec {
    name = "Net-OpenID-Common-1.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "24ac83539b188d85bd2c7bd67e355aab0ede3f98170b23cb50bd30b11b4387ff";
    };
    propagatedBuildInputs = [ CryptDHGMP URI HTMLParser HTTPMessage XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage rec {
    name = "Net-OpenID-Consumer-1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "4ab927b6756366fa4cef2b54088645849f32fc7e0cd8de0a50001bbf62946fd8";
    };
    propagatedBuildInputs = [ NetOpenIDCommon JSON LWP ];
  };

  PackageDeprecationManager = buildPerlPackage {
    name = "Package-DeprecationManager-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.13.tar.gz;
      sha256 = "0fkvq3xxwc3l5hg64dr9sj3l12dl59i44cg407qx9sd6r51j3qfi";
    };
    buildInputs = [ TestRequires TestFatal ];
    propagatedBuildInputs = [ ParamsUtil SubInstall ListMoreUtils ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Manage deprecation warnings for your distribution";
      license = "artistic_2";
    };
  };

  PackageStash = buildPerlPackage {
    name = "Package-Stash-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-0.34.tar.gz;
      sha256 = "1674zs96ndq3czs6v8xkdqqz4fnka0i2835nnns9zbw2q01yirj6";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleImplementation PackageDeprecationManager ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash;
      description = "Routines for manipulating stashes";
      license = "perl5";
    };
  };

  PackageStashXS = buildPerlPackage {
    name = "Package-Stash-XS-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-XS-0.26.tar.gz;
      sha256 = "1pfdpb3x40f5ldp5kp0d9xvrz4wk2fc3ww53wrq4dp326s08h7r9";
    };
    buildInputs = [ TestRequires TestFatal ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash-XS;
      description = "Faster and more correct implementation of the Package::Stash API";
      license = "perl5";
    };
  };

  ParamsClassify = buildPerlPackage rec {
    name = "Params-Classify-0.013";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Params/${name}.tar.gz";
      sha256 = "1d4ysd95flszrxrnjgy6s7b80jkagjsb939h42i2hix4q20sy0a1";
    };
    buildInputs = [ ExtUtilsParseXS ];
  };

  ParamsUtil = buildPerlPackage {
    name = "Params-Util-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Params-Util-1.07.tar.gz;
      sha256 = "0v67sx93yhn7xa0nh9mnbf8mixf54czk6wzrjsp6dzzr5hzyrw9h";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Simple, compact and correct param-checking functions";
      license = "perl5";
    };
  };

  ParamsValidate = buildPerlModule {
    name = "Params-Validate-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Params-Validate-1.07.tar.gz;
      sha256 = "15mz2wxarxjlr3365m1hhcnfs6d2mw3m0yimnlv06j13cxs39py1";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Validate method/function parameters";
      license = "artistic_2";
    };
  };

  PARDist = buildPerlPackage {
    name = "PAR-Dist-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSCHUPP/PAR-Dist-0.49.tar.gz;
      sha256 = "078ycyn8pw3rba4k3qwcqrqfcym5c1pivymwa0bvs9sab45j4iwy";
    };
    meta = {
      description = "Create and manipulate PAR distributions";
    };
  };

  Parent = buildPerlPackage {
    name = "parent-0.221";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.221.tar.gz;
      sha256 = "17jhscpa5p5szh1173pd6wvh2m05an1l941zqq9jkw9bzgk12hm0";
    };
  };

  ParseCPANMeta = buildPerlPackage rec {
    name = "Parse-CPAN-Meta-1.4404";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Parse/${name}.tar.gz";
      sha256 = "1y4mr5hmkkl405x4v31kx2nmlahpg0c38k8s65vgqc4s28wxafmh";
    };
    propagatedBuildInputs = [ CPANMetaYAML JSONPP ];
  };

  ParseRecDescent = buildPerlPackage rec {
    name = "Parse-RecDescent-1.965001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/${name}.tar.gz";
      sha256 = "0r4dnrjgxv5irkyx1kgkg8vj6wqx67q5hbkifpb54906kc1n7yh0";
    };
  };

  PathClass = buildPerlPackage {
    name = "Path-Class-0.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.29.tar.gz;
      sha256 = "1z3wvci2qcb1m9qrkxphbnfnr4jqgxbxnxrmdb25ks8gap98hk4z";
    };
    meta = {
      description = "Cross-platform path specification manipulation";
      license = "perl";
    };
  };

  Perl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  PerlCritic = buildPerlPackage rec {
    name = "Perl-Critic-1.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EL/ELLIOTJS/${name}.tar.gz";
      sha256 = "3e1bd5ab4912ebe20cd3cb81b36ee28dbdd8d410374a31025dc9fb289921ff27";
    };
    propagatedBuildInputs = [
      PPI BKeywords ConfigTiny ExceptionClass Readonly StringFormat
      EmailAddress FileWhich PerlTidy PodSpell ReadonlyXS RegexpParser
    ];
  };

  PerlIOeol = buildPerlPackage {
    name = "PerlIO-eol-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/PerlIO-eol-0.14.tar.gz;
      sha256 = "1rwj0r075jfvvd0fnzgdqldc7qdb94wwsi21rs2l6yhcv0380fs2";
    };
  };

  PerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-dynamic-0.12.tar.gz;
      sha256 = "140hay9q8q9sz1fa2s57ijp5l2448fkcg7indgn6k4vc7yshmqz2";
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };
  };

  PerlMagick = buildPerlPackage {
    name = "PerlMagick-6.77";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JC/JCRISTY/PerlMagick-6.77.tar.gz;
      sha256 = "0axbj3n5avjxvlxradjs9zxiv84i00drmnjsb7hq9sjn9fzggngg";
    };
    buildInputs = [pkgs.imagemagick];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick}/include/ImageMagick";|' Makefile.PL
      '';
    doCheck = false;
  };

  PerlOSType = buildPerlPackage rec {
    name = "Perl-OSType-1.002";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Perl/${name}.tar.gz";
      sha256 = "0clbfgq0800dip3821ibh29vrwcc159qnakidbiqrmhcisd95xbs";
    };
  };

  PerlTidy = buildPerlPackage rec {
    name = "Perl-Tidy-20090616";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/${name}.tar.gz";
      sha256 = "c7ca21e287d23c769c235f6742fab7b5779b7c7bf58b6a55ba8cdc492e50a118";
    };
  };

  Plack = buildPerlPackage {
    name = "Plack-1.0015";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-1.0015.tar.gz;
      sha256 = "1zg30bb55ws8fka5iawmfqnc3wg6ggigl0wljgvw0mk466sr3lxf";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ DevelStackTrace DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HashMultiValue HTTPBody HTTPMessage LWPUserAgent StreamBuffered TestTCP TryTiny URI ];
    meta = {
      homepage = http://plackperl.org;
      description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
      license = "perl";
    };
  };

  PlackMiddlewareReverseProxy = buildPerlPackage {
    name = "Plack-Middleware-ReverseProxy-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ReverseProxy-0.15.tar.gz;
      sha256 = "1zmsccdy6wr5hxzj07r1nsmaymyibk87p95z0wzknjw10lwmqs9f";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Supports app to run as a reverse proxy backend";
      license = "perl";
    };
  };

  PlackTestExternalServer = buildPerlPackage {
    name = "Plack-Test-ExternalServer-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Plack-Test-ExternalServer-0.01.tar.gz;
      sha256 = "1dbg1p3rgvvbkkpvca5jlc2mzx8iqyiybk88al93pvbca65h1g7h";
    };
    propagatedBuildInputs = [ HTTPMessage LWPUserAgent Plack TestTCP URI ];
    meta = {
      description = "Run HTTP tests on external live servers";
      license = "perl";
    };
  };

  PPI = buildPerlPackage rec {
    name = "PPI-1.210";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "6c851e86475242fa0def2f02565743d41ab703ff6df3e826166ee9df5b961c7a";
    };
    propagatedBuildInputs = [
      ClassInspector
      Clone
      FileRemove
      IOString
      ListMoreUtils
      ParamsUtil
      TaskWeaken
      TestNoWarnings TestObject TestSubCalls
    ];
    doCheck = false;
  };

  ProcWaitStat = buildPerlPackage rec {
    name = "Proc-WaitStat-1.00";
    src = fetchurl {
      url = "mirror://cpan//authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1g3l8jzx06x4l4p0x7fyn4wvg6plfzl420irwwb9v447wzsn6xfh";
    };
    propagatedBuildInputs = [ IPCSignal ];
  };

  PSGI = buildPerlPackage rec {
    name = "PSGI-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0b1k7smg50xfdhrjifa2gkkm52vna41alvbw8vb2pk99jmgnngh6";
    };
  };

  PadWalker = buildPerlPackage {
    name = "PadWalker-1.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBIN/PadWalker-1.96.tar.gz;
      sha256 = "180c72l3ssnsdbyifl9lzdz83x4zidf3nfgyx6l0j41a5wj0w9fz";
    };
    meta = {
    };
  };

  Perl6Junction = buildPerlPackage rec {
    name = "Perl6-Junction-1.40000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "0sgv8hqrkhx73bcb5jyi8a0b3v5bxqr3aziram1zndx43i1knzp4";
    };
  };

  PodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "1krsz4zwmnmq3z29p5vmyr5fdzrn8v0sg6rf3qxk7xpxw4z5np84";
    };
    propagatedBuildInputs = [DevelSymdump];
  };

  PodEscapes = buildPerlPackage {
    name = "Pod-Escapes-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/Pod-Escapes-1.04.tar.gz;
      sha256 = "1wrg5dnsl785ygga7bp6qmakhjgh9n4g3jp2l85ab02r502cagig";
    };
  };

  PodSimple = buildPerlPackage {
    name = "Pod-Simple-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARANDAL/Pod-Simple-3.05.tar.gz;
      sha256 = "1j0kqcvr9ykcqlkr797j1npkbggykb3p4w5ri73s8mi163lzxkqb";
    };
    propagatedBuildInputs = [constant PodEscapes];
  };

  PodSpell = buildPerlPackage rec {
    name = "Pod-Spell-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBURKE/${name}.tar.gz";
      sha256 = "938648dca5b62e591783347f9d4d4e2a5239f9629c6adfed9a581b9457ef7d2e";
    };
  };

  ProbePerl = buildPerlPackage rec {
    name = "Probe-Perl-0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/${name}.tar.gz";
      sha256 = "9b7d211139e42b2a2952c9a4b9f55ac12705e256f4a0acd4ac6ff665aeaddd87";
    };
  };

  Readonly = buildPerlPackage rec {
    name = "Readonly-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "1shkyxajh6l87nif47ygnfxjwvqf3d3kjpdvxaff4957vqanii2k";
    };
  };

  ReadonlyXS = buildPerlPackage rec {
    name = "Readonly-XS-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "8ae5c4e85299e5c8bddd1b196f2eea38f00709e0dc0cb60454dc9114ae3fff0d";
    };
  };

  RegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.35";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Regexp/${name}.tar.gz";
      sha256 = "1msxrriq74q8iacn2hkcw6g4qjjwv777avryiyz1w29h55mwq083";
    };
  };

  RegexpCommon = buildPerlPackage rec {
    name = "Regexp-Common-2.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/${name}.tar.gz";
      sha256 = "1mi411nfsx58nfsgjsbyck50x9d0yfvwqpw63iavajlpx1z38n8r";
    };
  };

  RegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  RegexpParser = buildPerlPackage rec {
    name = "Regexp-Parser-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PI/PINYAN/${name}.tar.gz";
      sha256 = "0dfdbe060724396697303c5522e697679ab6e74151f3c3ef8df49f3bda30a2a5";
    };
  };

  RpcXML = buildPerlPackage {
    name = "RPC-XML-0.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.73.tar.gz;
      sha256 = "a023649603240e7a19fc52a8316a41c854639c0600058ea4d1e436fe1b1b7734";
    };
    propagatedBuildInputs = [LWP XMLLibXML XMLParser];
    doCheck = false;
  };

  ReturnValue = buildPerlPackage {
    name = "Return-Value-1.302";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.302.tar.gz;
      sha256 = "0hf5rmfap49jh8dnggdpvapy5r4awgx5hdc3acc9ff0vfqav8azm";
    };
  };

  RoleTiny = buildPerlPackage {
    name = "Role-Tiny-1.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Role-Tiny-1.002004.tar.gz;
      sha256 = "0n126kazifmx6grdk4rmq226xklfc996cqw4ix26z9jcccl4v756";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Roles, like a nouvelle cuisine portion size slice of Moose";
      license = "perl5";
    };
  };

  SafeIsa = buildPerlPackage {
    name = "Safe-Isa-1.000002";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Safe-Isa-1.000002.tar.gz;
      sha256 = "07jr4fy6zbw9zwpalxzxlkn4nym6fd0304fsrb5ag0v156ygpwvl";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Call isa, can, does and DOES safely on things that may not be objects";
      license = "perl5";
    };
  };

  ScalarString = buildPerlPackage rec {
    name = "Scalar-String-0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "d3a45cc137bb9f7d8848d5a10a5142d275a98f8dcfd3adb60593cee9d33fa6ae";
    };
  };

  ScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.20.tar.gz;
      sha256 = "1lsagnz6pli035zvx5c1x4qm9fabi773vns86yd8lzfpldhfv3sv";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = "perl";
    };
  };

  ScopeUpper = buildPerlPackage {
    name = "Scope-Upper-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.21.tar.gz;
      sha256 = "058nfnzp31k7hmdvbsr72nvrw0i23gwjplb6g6pag3s18m7fl1p6";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Scope-Upper/;
      description = "Act on upper scopes";
      license = "perl5";
    };
  };

  SetObject = buildPerlPackage {
    name = "Set-Object-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMV/Set-Object-1.26.tar.gz;
      sha256 = "1hx3wrw8xkvaggacc8zyn86hfi3079ahmia1n8vsw7dglp1bbhmj";
    };
  };

  Socket6 = buildPerlPackage rec {
    name = "Socket6-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UM/UMEMOTO/${name}.tar.gz";
      sha256 = "eda753f0197e8c3c8d4ab20a634561ce84011fa51aa5ff40d4dbcb326ace0833";
    };
    buildInputs = [ pkgs.which ];
  };

  SortVersions = buildPerlPackage rec {
    name = "Sort-Versions-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ED/EDAVIS/${name}.tar.gz";
      sha256 = "1yhyxaakyhcffgr9lwd314badhlc2gh9f6n47013ljshbnkgzhh9";
    };
  };

  SpreadsheetParseExcel = buildPerlPackage rec {
    name = "Spreadsheet-ParseExcel-0.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "1ha32kfgf0b9mk00dvsx0jq72xsx0qskmgrnixcdfh044lcxzk17";
    };

    propagatedBuildInputs = [ IOStringy OLEStorageLight ];
  };

  SQLAbstract = buildPerlPackage {
    name = "SQL-Abstract-1.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/SQL-Abstract-1.73.tar.gz;
      sha256 = "081ppyvsc66yshmfr9q9v7hp9g58725nnibd771i9g153vzs49kb";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped GetoptLongDescriptive HashMerge ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = "perl";
    };
  };

  SQLAbstractLimit = buildPerlPackage rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs =
      [ SQLAbstract TestException DBI TestDeep ];
    buildInputs = [ TestPod TestPodCoverage ];
  };

  SQLSplitStatement = buildPerlPackage rec {
    name = "SQL-SplitStatement-1.00020";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "0bqg45k4c9qkb2ypynlwhpvzsl4ssfagmsalys18s5c79ps30z7p";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassAccessor ListMoreUtils RegexpCommon SQLTokenizer ];
  };

  SQLTokenizer = buildPerlPackage rec {
    name = "SQL-Tokenizer-0.24";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "1qa2dfbzdlr5qqdam9yn78z5w3al5r8577x06qan8wv58ay6ka7s";
    };
  };

  SQLTranslator = buildPerlPackage rec {
    name = "SQL-Translator-0.11006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "0ifnzap3pgkxvkv2gxpmv02637pfraza5m4zk99braw319ra4mla";
    };
    propagatedBuildInputs = [
      ClassBase ClassDataInheritable ClassMakeMethods DigestSHA1 CarpClan IOStringy
      ParseRecDescent ClassAccessor DBI FileShareDir XMLWriter YAML TestDifferences
      TemplateToolkit GraphViz XMLLibXML TestPod TextRecordParser HTMLParser
      SpreadsheetParseExcel Graph GD
    ];
  };

  Starman = buildPerlPackage {
    name = "Starman-0.3006";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Starman-0.3006.tar.gz;
      sha256 = "0dlwrrq570v5mbpzsi4pmj6n2sjm3xpcilhh6dvpq8qbp550wixy";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ DataDump HTTPDate HTTPParserXS HTTPMessage NetServer Plack TestTCP ];
    doCheck = false; # binds to various TCP ports1
    meta = {
      description = "High-performance preforking PSGI/Plack web server";
      license = "perl";
    };
  };

  StatisticsDescriptive = buildPerlPackage rec {
    name = "Statistics-Descriptive-3.0202";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Statistics/${name}.tar.gz";
      sha256 = "0y8l3dkhfc2gqwfigrg363ac7pxcyshdna66afpdvs8r1gd53a1i";
    };
  };

  StatisticsDistributions = buildPerlPackage rec {
    name = "Statistics-Distributions-1.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Statistics/${name}.tar.gz";
      sha256 = "1j1kswl98f4i9dn176f9aa3y9bissx2sscga5jm3gjl4pxm3k7zr";
    };
  };

  StatisticsTTest = buildPerlPackage rec {
    name = "Statistics-TTest-1.1.0";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Statistics/${name}.tar.gz";
      sha256 = "0rkifgzm4rappiy669dyi6lyxn2sdqaf0bl6gndlfa67b395kndj";
    };
    propagatedBuildInputs = [ StatisticsDescriptive StatisticsDistributions ];
  };

  StreamBuffered = buildPerlPackage {
    name = "Stream-Buffered-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.02.tar.gz;
      sha256 = "0bfa3h2pryrbrcd1r7235k0ik4gw35r5ig8h8y3dfmk9l3y96vjr";
    };
    meta = {
      homepage = http://plackperl.org;
      description = "Temporary buffer to save bytes";
      license = "perl";
    };
  };

  strictures = buildPerlPackage {
    name = "strictures-1.004004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/strictures-1.004004.tar.gz;
      sha256 = "0d7fanr4ggmlqvdxf63ci7nxba2vrdz9558xy35hfpm8max7s48j";
    };
    meta = {
      homepage = http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/strictures.git;
      description = "Turn on strict and make all warnings fatal";
      license = "perl5";
    };
  };

  StringCamelCase = buildPerlPackage rec {
    name = "String-CamelCase-0.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/String/${name}.tar.gz";
      sha256 = "17kh8nap2z5g5rqcvw0m7mvbai7wr7h0al39w8l827zhqad8ss42";
    };
  };

  StringFormat = buildPerlPackage rec {
    name = "String-Format-1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "edb27dd055ad71012a439f262f9394517adb585a5c27ba72c1819bae2c23729a";
    };
  };

  StringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.02.tar.gz;
      sha256 = "0si4xfgf8c2pfag1cqbr9jbyvg3hak6wkmny56kn2qwa4ljp9bk6";
    };
  };

  StringRewritePrefix = buildPerlPackage {
    name = "String-RewritePrefix-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.006.tar.gz;
      sha256 = "1b9fg805g0agsyij28w8hhmnf485bii8zl03i092mv1p2hqrpxll";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Rewrite strings based on a set of known prefixes";
      license = "perl5";
    };
  };

  StringToIdentifierEN = buildPerlPackage rec {
    name = "String-ToIdentifier-EN-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/String/${name}.tar.gz";
      sha256 = "1rmldr7jf4jvkhzlv8hgp48lrmybvinmhv8kcnrpa8las0ijm4vm";
    };
    propagatedBuildInputs =
      [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
  };

  SubExporter = buildPerlPackage {
    name = "Sub-Exporter-0.984";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.984.tar.gz;
      sha256 = "190qly7nv7zf17c1v0gnqhyf25p6whhh2m132mh4xzs5mqadwq0f";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = "perl5";
    };
  };

  SubExporterProgressive = buildPerlPackage {
    name = "Sub-Exporter-Progressive-0.001006";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Sub-Exporter-Progressive-0.001006.tar.gz;
      sha256 = "0s13fz86c8slhgban10sywp2skjdxnl3nvkqqy7pbwg81g3v9rr2";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Only use Sub::Exporter if you need it";
      license = "perl5";
    };
  };

  SubExporterUtil = buildPerlPackage {
    name = "Sub-Exporter-Util-0.984";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.984.tar.gz;
      sha256 = "190qly7nv7zf17c1v0gnqhyf25p6whhh2m132mh4xzs5mqadwq0f";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = "perl5";
    };
  };

  SubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "16g4dkmb4h5hh15jsq0kvsf3irrlrlqdv7qk6605wh5gjjwbcjxy";
    };
  };

  SubInstall = buildPerlPackage {
    name = "Sub-Install-0.926";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Install-0.926.tar.gz;
      sha256 = "0gkns6p11j46j6yzacanhbqgd4ws5r0ppg6yivz7cjbq8dk4kcmc";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Install subroutines into packages easily";
      license = "perl5";
    };
  };

  SubName = buildPerlPackage {
    name = "Sub-Name-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Sub-Name-0.05.tar.gz;
      sha256 = "1w9sf51ai2r3i0kv5wnq7h9g3hcd6zb6i51ivvykb3hzx82vilf9";
    };
    meta = {
      description = "(Re)name a sub";
    };
  };

  SubOverride = buildPerlPackage rec {
    name = "Sub-Override-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "13s5zi6qz02q50vv4bmwdmhn9gvg0988fydjlrrv500g6hnyzlkj";
    };
    propagatedBuildInputs = [SubUplevel TestException];
  };

  SubUplevel = buildPerlPackage {
    name = "Sub-Uplevel-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.24.tar.gz;
      sha256 = "1yzxqsim8vpavzqm2wfksh8dpmy6qbr9s3hdqqicp38br3lzd4qg";
    };
    meta = {
      homepage = https://github.com/dagolden/sub-uplevel;
      description = "Apparently run a function in a higher stack frame";
      license = "perl5";
    };
  };

  SVK = buildPerlPackage {
    name = "SVK-v2.0.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVK-v2.0.2.tar.gz;
      sha256 = "0c4m2q7cvzwh9kk1nc1vd8lkxx2kss5nd4k20dpkal4c7735jns0";
    };
    propagatedBuildInputs = [
      AlgorithmDiff AlgorithmAnnotate AppCLI
      ClassDataInheritable DataHierarchy Encode FileTemp
      IODigest ListMoreUtils PathClass PerlIOeol
      PerlIOviadynamic PerlIOviasymlink PodEscapes
      PodSimple SVNMirror TimeHiRes UNIVERSALrequire
      URI YAMLSyck ClassAutouse IOPager
      LocaleMaketextLexicon FreezeThaw
    ];
  };

  SVNMirror = buildPerlPackage {
    name = "SVN-Mirror-0.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Mirror-0.73.tar.gz;
      sha256 = "1scjaq7qjz6jlsk1c2l5q15yxf0sqbydvf22mb2xzy1bzaln0x2c";
    };
    propagatedBuildInputs = [
      ClassAccessor Filechdir pkgs.subversion URI
      TermReadKey TimeDate SVNSimple
    ];
  };

  SVNSimple = buildPerlPackage {
    name = "SVN-Simple-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Simple-0.27.tar.gz;
      sha256 = "0p7p52ja6sf4j0w3b05i0bbqi5wiambckw2m5dsr63bbmlhv4a71";
    };
    propagatedBuildInputs = [pkgs.subversion];
  };

  Switch = buildPerlPackage rec {
    name = "Switch";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/Switch-2.16.tar.gz";
      sha256 = "1n7rgp1q3zwglv1pka3bnhq5g41334lwc53g31w6g44my8kqz31h";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
  };

  SysHostnameLong = buildPerlPackage rec {
    name = "Sys-Hostname-Long-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/${name}.tar.gz";
      sha256 = "0hy1225zg2yg11xhgj0wbiapzjyf6slx17ln36zqvfm07k6widlx";
    };
    doCheck = false; # no `hostname' in stdenv
  };

  TaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "07nn8a30n3qylpnf7s4ma6w462g31pywwikib117hr2mc7cv5cbm";
    };
    propagatedBuildInputs = [
      CatalystManual CatalystRuntime CatalystDevel
      CatalystPluginSession CatalystPluginAuthentication
      CatalystAuthenticationStoreDBIxClass
      CatalystPluginAuthorizationRoles
      CatalystPluginAuthorizationACL
      CatalystPluginHTMLWidget
      CatalystPluginSessionStoreFastMmap
      CatalystPluginStackTrace
      CatalystViewTT
      DBIxClass DBIxClassHTMLWidget
      CatalystControllerHTMLFormFu
    ];
    buildInputs = [TestPodCoverage];
    meta.platforms = stdenv.lib.platforms.linux;
  };

  TaskPlack = buildPerlPackage rec {
    name = "Task-Plack-0.25";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Task/${name}.tar.gz";
      sha256 = "1mk3z7xis1akf8245qgw5mnnsl7570kdidx83nj81kv410pw2v43";
    };
    propagatedBuildInputs = [ Plack PSGI ];
  };

  TaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.04.tar.gz;
      sha256 = "1i7kd9v8fjsqyhr4rx4a1jv7n5vfjjm1v4agb24pizh0b72p3qk7";
    };
    meta = {
      description = "Ensure that a platform has weaken support";
      license = "perl";
    };
  };

  TemplateTimer = buildPerlPackage {
    name = "Template-Timer-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-1.00.tar.gz;
      sha256 = "1d3pbcx1kz73ncg8s8lx3ifwphz838qy0m40gdar7790cnrlqcdp";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Rudimentary profiling for Template Toolkit";
      license = "null";
    };
  };

  TemplateToolkit = buildPerlPackage rec {
    name = "Template-Toolkit-2.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.24.tar.gz;
      sha256 = "1j01kpsdpwxrwbsz2y1d8xyyliw9l23g0f3jigxvgxs9qal4m0rq";
    };
    propagatedBuildInputs = [ AppConfig ];
    meta = {
      description = "Comprehensive template processing system";
      license = "perl5";
    };
  };

  TermReadKey = buildPerlPackage {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  TermReadLineGnu = buildPerlPackage rec {
    name = "Term-ReadLine-Gnu-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/${name}.tar.gz";
      sha256 = "00fvkqbnpmyld59jv2vbfw1szr5d0xxmbgl59gr7qijp9c497ni5";
    };
    buildInputs = [ pkgs.readline pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lreadline";

    # For some crazy reason Makefile.PL doesn't generate a Makefile if
    # AUTOMATED_TESTING is set.
    AUTOMATED_TESTING = false;

    # Makefile.PL looks for ncurses in Glibc's prefix.
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '$Config{libpth}' \
          "'${pkgs.ncurses}/lib'"
      '';

    # Tests don't work because they require /dev/tty.
    doCheck = false;
  };

  TestAssertions = buildPerlPackage rec {
    name = "Test-Assertions-1.054";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "10026w4r3yv6k3vc6cby7d61mxddlqh0ls6z39c82f17awfy9p7w";
    };
    buildInputs = [ LogTrace ];
  };

  TestCheckDeps = buildPerlPackage {
    name = "Test-CheckDeps-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Test-CheckDeps-0.002.tar.gz;
      sha256 = "0fmm9xsgial599bqb6rcrc6xp0627rcdp0ivx8wsy807py5jk5i6";
    };
    propagatedBuildInputs = [ CPANMetaCheck ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Check for presence of dependencies";
      license = "perl5";
    };
  };

  TestDeep = buildPerlPackage {
    name = "Test-Deep-0.110";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-0.110.tar.gz;
      sha256 = "12rd9fknm778685ypyc599lcmzbqvbqnjhcrkybgpq2siai9q4h5";
    };
    propagatedBuildInputs = [ TestNoWarnings TestTester ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  TestDifferences = buildPerlPackage {
    name = "Test-Differences-0.61";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-Differences-0.61.tar.gz;
      sha256 = "044wg7nqmhvh5ms8z305f9bzldhigr020l1a7iqycxqv05h6b6vm";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      description = "Test strings and data structures and show differences if not ok";
      license = "perl";
    };
  };

  TestException = buildPerlPackage rec {
    name = "Test-Exception-0.31";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "1lyd6mcg00348xsn9fl59spx68a69ybli7h7gd2k0p4y21q8p0ks";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestFatal = buildPerlPackage {
    name = "Test-Fatal-0.010";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Fatal-0.010.tar.gz;
      sha256 = "01ck4wyrj4nqyr1cz3lcff6g9nryadsflpf85jmsa6vcl2bq8pl0";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/test-fatal;
      description = "Incredibly simple helpers for testing code with exceptions";
      license = "perl5";
    };
  };

  TestHarness = buildPerlPackage rec {
    name = "Test-Harness-3.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "0j390xx6an88gh49n7zz8mj1s3z0xsxc8dynfq71xf7ba7i1afhr";
    };
  };

  TestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.15";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0r2i3a35l116ccwx88jwiii2fq4b8wm16sl1lkxm2kh44s4z7s5s";
    };
  };

  TestMockObject = buildPerlPackage {
    name = "Test-MockObject-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.09.tar.gz;
      sha256 = "1cz385x0jrkj84nmfs6qyzwwvv8m9v8r2isagfj1zxvhdw49wdyy";
    };
    propagatedBuildInputs = [TestException UNIVERSALisa UNIVERSALcan];
  };

  TestMoose = buildPerlPackage {
    name = "Test-Moose-2.0604";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Moose-2.0604.tar.gz;
      sha256 = "0nwvklb8dwf8lskwxik3gi9gsqzrix2jhc56zvfzlf1q5q1s07qj";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ClassLoadXS DataOptList DevelGlobalDestruction DistCheckConflicts EvalClosure ListMoreUtils MROCompat PackageDeprecationManager PackageStash PackageStashXS ParamsUtil SubExporter SubName TaskWeaken TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A postmodern object system for Perl 5";
      license = "perl5";
    };
  };

  TestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "1j2riyikzyfkxsgkfdqirs7xa8q5d06b9klpk7l9sgydwqdvxdv3";
    };
  };

  TestMore = TestSimple;

  TestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Test-NoWarnings-1.04.tar.gz;
      sha256 = "0v385ch0hzz9naqwdw2az3zdqi15gka76pmiwlgsy6diiijmg2k3";
    };
    buildInputs = [ TestTester ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Make sure you didn't emit any warnings while testing";
      license = "open_source";
    };
  };

  TestObject = buildPerlPackage rec {
    name = "Test-Object-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "d142a91b039928dc5d616c7bd9bb62ffb06e58991f00c54e26ef7e62ed61032a";
    };
  };

  TestOutput = buildPerlPackage rec {
    name = "Test-Output-1.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0hg2hv6sify6qcx4865m4gyfdfbi96aw7fx39zpvnrivk3i2jdcd";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ SubExporter ];
  };

  TestPerlCritic = buildPerlPackage rec {
    name = "Test-Perl-Critic-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THALJEF/${name}.tar.gz";
      sha256 = "89b242ff539034336ed87c11ef3e5ecac47c333a6ab8b46aab4cc449e3739a89";
    };
    propagatedBuildInputs = [ PerlCritic ];
  };

  TestPod = buildPerlPackage {
    name = "Test-Pod-1.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-Pod-1.45.tar.gz;
      sha256 = "0yv0bglm4b9zfi9l5z6x2dy6pzlh8n5z9yl7py5v6h48mwgk74fk";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod/;
      description = "Check for POD errors in files";
      license = "perl5";
    };
  };

  TestPodCoverage = buildPerlPackage rec {
    name = "Test-Pod-Coverage-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0y2md932zhbxdjwzskx0vmw2qy7jxkn87f9lb5h3f3vxxg1kcqz0";
    };
    propagatedBuildInputs = [PodCoverage];
  };

  TestRequires = buildPerlPackage {
    name = "Test-Requires-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/Test-Requires-0.06.tar.gz;
      sha256 = "1ksyg4npzx5faf2sj80rm74qjra4q679750vfqfvw3kg1d69wvwv";
    };
    meta = {
      description = "Checks to see if the module can be loaded";
      license = "perl";
    };
  };

  TestScript = buildPerlPackage rec {
    name = "Test-Script-1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "e21e5ee43a27b4c51b54ded5c92e60b817309778117a1d98ae6354abff27eb96";
    };
    propagatedBuildInputs = [ProbePerl IPCRun3];
  };

  TestSharedFork = buildPerlPackage rec {
    name = "Test-SharedFork-0.18";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "1wc41jzi780w75m2ry1038mzxyz7386r8rmhbnmj3krcdxy676cc";
    };
  };

  TestSimple = null;

  TestSubCalls = buildPerlPackage rec {
    name = "Test-SubCalls-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "a334b0457da338d79be2dbb62d403701fc90f7607df840115ff45ee1e2bd6e70";
    };
    propagatedBuildInputs = [ HookLexWrap ];
  };

  TestTCP = buildPerlPackage {
    name = "Test-TCP-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/Test-TCP-1.18.tar.gz;
      sha256 = "0flm7x0z7amppi9y6s8mxm0pkrgfihfpfjs0w4i6s80jiss1gfld";
    };
    propagatedBuildInputs = [ TestSharedFork ];
    meta = {
      description = "Testing TCP program";
      license = "perl";
    };
  };

  TestTester = buildPerlPackage {
    name = "Test-Tester-0.108";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.108.tar.gz;
      sha256 = "1pby9w41b7z0cgnxpgkh397x7z68855sjg5yda48r6lck3lga62h";
    };
  };

  TestUseOk = buildPerlPackage rec {
    name = "Test-use-ok-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "11inaxiavb35k8zwxwbfbp9wcffvfqas7k9idy822grn2sz5gyig";
    };
  };

  TestWarn = buildPerlPackage {
    name = "Test-Warn-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Test-Warn-0.24.tar.gz;
      sha256 = "12r1mcwrm6cgc3ppgawwv265vmrighj4bl6xc5c41f4c2l6bdxml";
    };
    propagatedBuildInputs = [ SubUplevel TreeDAGNode ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Perl extension to test methods for warnings";
      license = "perl5";
    };
  };

  TestWWWMechanize = buildPerlPackage {
    name = "Test-WWW-Mechanize-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.44.tar.gz;
      sha256 = "062pj242vsc73bw11jqpap92ax9wzc9f2m4xhyp1wzrwkfchpl2q";
    };
    propagatedBuildInputs = [ CarpAssertMore HTMLTree HTTPServerSimple LWP TestLongString URI WWWMechanize ];
    meta = {
      homepage = https://github.com/petdance/test-www-mechanize;
      description = "Testing-specific WWW::Mechanize subclass";
      license = "artistic_2";
    };
  };

  TestWWWMechanizeCatalyst = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-Catalyst-0.55";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0zdg4sxx231dj3qgbr58i63927gl4qzh0krignqxp8q6ck3hr63f";
    };
    propagatedBuildInputs =
      [ CatalystRuntime TestWWWMechanize WWWMechanize
        CatalystPluginSessionStateCookie HTMLForm
      ];
    buildInputs = [ TestPod ];
    doCheck = false; # listens on an external port
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-PSGI-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Test-WWW-Mechanize-PSGI-0.35.tar.gz;
      sha256 = "1hih8s49zf38bisvhnhzrrj0zwyiivkrbs7nmmdqm1qqy27wv7pc";
    };
    propagatedBuildInputs = [ Plack TestWWWMechanize TryTiny ];
    meta = {
      description = "Test PSGI programs using WWW::Mechanize";
      license = "perl";
    };
  };

  TextAligner = buildPerlPackage {
    name = "Text-Aligner-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANNO/Text-Aligner-0.07.tar.gz;
      sha256 = "1vpb87binmmysr4sxfjinxg4bh3rb4rmrx48yyczgmyddmda9rik";
    };
    meta = {
      description = "Align text in columns";
    };
  };

  TextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "0vb0093v3kk7iczb46zzdg7myfyjldwrk8wbk7ibk56gvj350f7c";
    };
  };

  TextDiff = buildPerlPackage {
    name = "Text-Diff-1.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Text-Diff-1.41.tar.gz;
      sha256 = "1ynjsa4sr1yvyh65sdfvahaafglibz70j8b6rj01cg1iisj50zx6";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perform diffs on files and record sets";
      license = "perl";
    };
  };

  TextGlob = buildPerlPackage rec {
    name = "Text-Glob-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "0lr76wrsj8wcxrq4wi8z1640w4dmdbkznp06q744rg3g0bd238d5";
    };
  };

  TextMarkdown = buildPerlPackage rec {
    name = "Text-Markdown-1.0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1ch8018yhn8mz38k0mrv5iljji1qqby2gfnvhvcm2vp65pjq2zdn";
    };
    buildInputs = [ FileSlurp ListMoreUtils Encode
      ExtUtilsMakeMaker TestException ];
  };

  TextPDF = buildPerlPackage rec {
    name = "Text-PDF-0.29a";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHOSKEN/${name}.tar.gz";
      sha256 = "11jig38vps957zyc9372q2g0jcabxgkql3b5vazc1if1ajhlvc4s";
    };
    propagatedBuildInputs = [ CompressZlib ];
  };

  TextRecordParser = buildPerlPackage rec {
    name = "Text-RecordParser-v1.5.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCLARK/${name}.tar.gz";
      sha256 = "0zlwpayjnpjani3v3hgi77207i3n5fppcxww20chdldx98dkj7jm";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ TestException IOStringy ClassAccessor Readonly ListMoreUtils
                              TestPod TestPodCoverage GraphViz ReadonlyXS TextTabularDisplay];
  };

  TextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Text-SimpleTable-2.03.tar.gz;
      sha256 = "15hpry9jwrf1vbjyk21s65rllxrdvp2fdzzv9gsvczggby2yyzfs";
    };
    meta = {
      description = "Simple eyecandy ASCII tables";
      license = "artistic_2";
    };
  };

  TextTable = buildPerlPackage {
    name = "Text-Table-1.126";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Table-1.126.tar.gz;
      sha256 = "18v9ll360q4hlhmpks175da7y8nf6ywygd39archnw3zpn1cv7h1";
    };
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/docmake/;
      description = "Organize Data in Tables";
      license = "bsd";
    };
  };

  TextTabularDisplay = buildPerlPackage rec {
    name = "Text-TabularDisplay-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "05r3jvdf8av16hgy0i3wnc581ski08q1bnllq5cq1fnc7h2nm1c7";
    };
    propagatedBuildInputs = [TextAligner];
  };

  TestTrap = buildPerlPackage {
    name = "Test-Trap-v0.2.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.2.2.tar.gz;
      sha256 = "1ci5ag9pm850ww55n2929skvw3avy6xcrwmmi2yyn0hifxx9dybs";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ DataDump ];
    meta = {
      description = "Trap exit codes, exceptions, output, etc.";
      license = "perl";
    };
  };

  TextUnidecode = buildPerlPackage rec {
    name = "Text-Unidecode-0.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "01kbw5xshs906ikg0rgf51y9m6m26a4msv7ghcqwx7w2shgs0ga7";
    };
  };

  Throwable = buildPerlPackage rec {
    name = "Throwable-0.102080";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0vjzlh23rpmgr5h8qfh9pb3kqw0j8sxn2bpbc1p2306dwqwbymm5";
    };
    propagatedBuildInputs = [ DevelStackTrace Moose ];
  };

  TieIxHash = buildPerlPackage {
    name = "Tie-IxHash-1.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.22.tar.gz;
      sha256 = "0f0m0x8nkidxd0pxnls1i8kc8d7bd89dqgihz29wj3ggk43qffr7";
    };
    meta = {
      description = "Ordered associative arrays for Perl";
      license = "perl";
    };
  };

  TieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
    propagatedBuildInputs = [TestUseOk];
  };

  TimeDate = buildPerlPackage {
    name = "TimeDate-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-1.16.tar.gz;
      sha256 = "1cvcpaghn7dc14m9871sfw103g3m3a00m2mrl5iqb0mmh40yyhkr";
    };
  };

  TimeHiRes = buildPerlPackage rec {
    name = "Time-HiRes-1.9724";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Time/${name}.tar.gz";
      sha256 = "0lrwfixr3qg8j4vkfax1z4gqiccq0v0jyvc7db40qpvi88655gjs";
    };
  };

  TreeDAGNode = buildPerlPackage {
    name = "Tree-DAG_Node-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-DAG_Node-1.09.tgz;
      sha256 = "1k2byyk7dnm8l6i1igagpfr58b02zsq5hwd9jcdp8yrlih7dzii3";
    };
    buildInputs = [ TestPod ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "An N-ary tree";
      license = "perl5";
    };
  };

  TreeSimple = buildPerlPackage {
    name = "Tree-Simple-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-1.18.tar.gz;
      sha256 = "0bb2hc8q5rwvz8a9n6f49kzx992cxczmrvq82d71757v087dzg6g";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "A simple tree object";
      license = "perl";
    };
  };

  TreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-VisitorFactory-0.10.tar.gz;
      sha256 = "1ghcgnb3xvqjyh4h4aa37x98613aldnpj738z9b80p33bbfxq158";
    };
    propagatedBuildInputs = [TreeSimple];
    buildInputs = [TestException];
  };

  TryTiny = buildPerlPackage {
    name = "Try-Tiny-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Try-Tiny-0.12.tar.gz;
      sha256 = "0awv2w33jb1xw3bsrfwsz53dgwm8s8vnpk4ssxxp3n89i7116p2g";
    };
    meta = {
      homepage = https://github.com/doy/try-tiny.git;
    };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.12.tar.gz;
      sha256 = "1abadbgcy11cmlmj9qf1v73ycic1qhysxv5xx81h8s4p81alialr";
    };
  };

  UNIVERSALisa = buildPerlPackage {
    name = "UNIVERSAL-isa-1.20120726";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-isa-1.20120726.tar.gz;
      sha256 = "1qal99sp888b50kwank9ffyprv7kqx42p4vyfahdabf915lyzc61";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-isa;
      description = "Attempt to recover from people calling UNIVERSAL::isa as a function";
      license = "perl";
    };
  };

  UNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/UNIVERSAL-require-0.11.tar.gz;
      sha256 = "1rh7i3gva4m96m31g6yfhlqcabszhghbb3k3qwxbgx3mkf5s6x6i";
    };
  };

  URI = buildPerlPackage {
    name = "URI-1.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/URI-1.60.tar.gz;
      sha256 = "0xr31mf7lfrwhyvlx4pzp6p7alls5gi4bj8pk5g89f5cckfd74hz";
    };
    meta = {
      description = "Uniform Resource Identifiers (absolute and relative)";
      license = "perl";
    };
  };

  UriGoogleChart = buildPerlPackage rec {
    name = "URI-GoogleChart-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "00hq5cpsk7sa04n0wg52qhpqf9i2849yyvw2zk83ayh1qqpc50js";
    };
    buildInputs = [URI TestMore];
  };

  VariableMagic = buildPerlPackage rec {
    name = "Variable-Magic-0.48";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Variable/${name}.tar.gz";
      sha256 = "124isksyw52br0y304dq4fcm26jk1v44s6ni1xd10nnl26fwmzbw";
    };
  };

  version = buildPerlPackage rec {
    name = "version-0.93";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/version/${name}.tar.gz";
      sha256 = "1lfq27hshq1gvdqksicp22ag8n1aiijhjw68q3r254kp6zimrz69";
    };
  };

  VersionRequirements = buildPerlPackage rec {
    name = "Version-Requirements-0.101020";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "18bcfxwn21gcih0bc6p1sp42iis8lwnqh7fpprkniflj8q0ps0x4";
    };
  };

  W3CLinkChecker = buildPerlPackage rec {
    name = "W3C-LinkChecker-4.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/${name}.tar.gz";
      sha256 = "0j2zlg57g0y9hqy8n35x5rfkpm7rnfjlwny5g0zaxwrl62ndkbm9";
    };
    propagatedBuildInputs = [
      LWP ConfigGeneral NetIP TermReadKey Perl5lib
      CryptSSLeay
    ];
    meta = {
      homepage = http://validator.w3.org/checklink;
      description = "A tool to check links and anchors in Web pages or full Web sites";
    };
  };

  WWWCurl = buildPerlPackage rec {
    name = "WWW-Curl-4.15";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/WWW/${name}.tar.gz";
      sha256 = "18az7k0jsr642lp6dfy0b2s7vx0cd7sj9dgk93wff73safa09x1y";
    };
    buildInputs = [ pkgs.curl ];
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '"cpp"' '"gcc -E"'
      '';
    doCheck = false; # performs network access
  };

  WWWMechanize = buildPerlPackage {
    name = "WWW-Mechanize-1.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/WWW-Mechanize-1.72.tar.gz;
      sha256 = "0vs3p2697675bswjayfmm37lg3xsxm94z1mif18s732kwvnpg6m6";
    };
    propagatedBuildInputs = [ HTMLForm HTMLParser HTMLTree HTTPDaemon HTTPMessage HTTPServerSimple LWP LWPUserAgent TestWarn URI ];
    doCheck = false;
    meta = {
      homepage = https://github.com/bestpractical/www-mechanize;
      description = "Handy web browsing in a Perl object";
      license = "perl5";
    };
  };

  WWWRobotRules = buildPerlPackage {
    name = "WWW-RobotRules-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz;
      sha256 = "07m50dp5n5jxv3m93i55qvnd67a6g7cvbvlik115kmc8lbkh5da6";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Database of robots.txt-derived permissions";
      license = "perl";
    };
  };

  X11GUITest = buildPerlPackage rec {
    name = "X11-GUITest-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/${name}.tar.gz";
      sha256 = "0akjk2x2d3j1f95wn93mh6nvq8p6c9jcqmvkh1mli5jxr1rmhjx8";
    };
    buildInputs = [pkgs.x11 pkgs.xorg.libXtst pkgs.xorg.libXi];
    NIX_CFLAGS_LINK = "-lX11 -lXext -lXtst";
    doCheck = false; # requires an X server
  };

  XMLDOM = buildPerlPackage {
    name = "XML-DOM-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.44.tar.gz;
      sha256 = "1r0ampc88ni3sjpzr583k86076qg399arfm9xirv3cw49k3k5bzn";
    };
    propagatedBuildInputs = [XMLRegExp XMLParser LWP libxml_perl];
  };

  XMLLibXML = buildPerlPackage rec {
    name = "XML-LibXML-2.0001";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/XML/${name}.tar.gz";
      sha256 = "1zx4fqi531yzaf1c5cw1qwb9vy37fksz35a7pp6pic9v8jvz09x6";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ XMLSAX ];
  };

  XMLLibXSLT = buildPerlPackage rec {
    name = "XML-LibXSLT-1.70";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/XML/${name}.tar.gz";
      sha256 = "0x8lqlxr6xhgwwa6zj4shrwrqlgbgs0piripc1fsnw4z1yl2gf9p";
    };
    buildInputs = [ pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
  };

  XMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-NamespaceSupport-1.09.tar.gz;
      sha256 = "0ny2i4pf6j8ggfj1x02rm5zm9a37hfalgx9w9kxnk69xsixfwb51";
    };
  };

  XMLParser = buildPerlPackage {
    name = "XML-Parser-2.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz;
      sha256 = "0gyp5qfbflhkin1zv8l6wlkjwfjvsf45a3py4vc6ni82fj32kmcz";
    };
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat}/lib EXPATINCPATH=${pkgs.expat}/include";
  };

  XMLXPath = buildPerlPackage {
    name = "XML-XPath-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-XPath-1.13.tar.gz;
      sha256 = "0xjmfwda7m3apj7yrjzmkm4sjwnz4bqyaynzgcwqhx806kgw4j9a";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.03.tar.gz;
      sha256 = "1gkarylvdk3mddmchcwvzq09gpvx5z26nybp38dg7mjixm5bs226";
    };
  };

  XMLSAX = buildPerlPackage {
    name = "XML-SAX-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-0.96.tar.gz;
      sha256 = "024fbjgg6s87j0y3yik55plzf7d6qpn7slwd03glcb54mw9zdglv";
    };
    propagatedBuildInputs = [XMLNamespaceSupport];
  };

  XMLSimple = buildPerlPackage {
    name = "XML-Simple-2.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.18.tar.gz;
      sha256 = "09k8fvc9m5nd5rqq00rwm3m0wx7iwd6vx0vc947y58ydi30nfjd5";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLTwig = buildPerlPackage {
    name = "XML-Twig-3.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.32.tar.gz;
      sha256 = "07zdsfzw9dlrx6ril9clf1jfif09vpf27rz66laja7mvih9izd1v";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLWriter = buildPerlPackage rec {
    name = "XML-Writer-0.612";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/${name}.tar.gz";
      sha256 = "1prvgbjxynxg6061qxzfbbimjvil04513hf3hsilv0hdg58nb9jk";
    };
  };

  YAML = buildPerlPackage {
    name = "YAML-0.84";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/YAML-0.84.tar.gz;
      sha256 = "03349n2z32gwjqiq7l3g57avvphl2rw3lmwc8i5cl9hmfw51yd8a";
    };
    meta = {
      homepage = https://github.com/ingydotnet/yaml-pm/tree;
      description = "YAML Ain't Markup Language (tm)";
      license = "perl";
    };
  };

  YAMLSyck = buildPerlPackage {
    name = "YAML-Syck-1.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/YAML-Syck-1.22.tar.gz;
      sha256 = "0n3k71i0b8mhdrl5kp1cwyvjbkqahyqkhp81wl3qnkfhyi39f55y";
    };
    meta = {
      homepage = http://search.cpan.org/dist/YAML-Syck;
      description = "Fast, lightweight YAML loader and dumper";
      license = "mit";
    };
  };

  YAMLTiny = buildPerlPackage rec {
    name = "YAML-Tiny-1.50";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/YAML/${name}.tar.gz";
      sha256 = "0ag1llgf0qn3sxy832xhvc1mq6s0bdv13ij7vh7df8nv0jnxyyd3";
    };
  };

  YAMLLibYAML = buildPerlPackage rec {
    name = "YAML-LibYAML-0.38";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/YAML/${name}.tar.gz";
      sha256 = "eb98f304d14f6557b07adfa24da16e00cfa54a9d9484b6e898e35f919c5eb7ba";
    };
  };

}
