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
  buildModule = { buildInputs ? [], ... } @ args:
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
      description = "grep-like text finder";
      longDescription = ''
        ack is a grep-like tool tailored to working with large trees of source code.
      '';
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

  AlgorithmDiff = buildPerlPackage rec {
    name = "Algorithm-Diff-1.1901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/${name}.zip";
      sha256 = "0qk60fi49mpyvnfpjd2dzcmya8x3g5zfgb2hrnl7a5krn045g6i2";
    };
    buildInputs = [pkgs.unzip];
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

  BHooksEndOfScope = buildPerlPackage rec {
    name = "B-Hooks-EndOfScope-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "07gbfc36qr8pfwrcskq3bbpwscmi7nkvvw54vz5d9ym1fyn3zf0g";
    };
    propagatedBuildInputs = [SubExporter VariableMagic];
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

  CaptureTiny = buildPerlPackage rec {
    name = "Capture-Tiny-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "09rhfjgryvfap2v6ym7ywl130r3q8a1p2rq70l1jv415qhj0194c";
    };
  };

  CarpAssert = buildPerlPackage rec {
    name = "Carp-Assert-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1wzy4lswvwi45ybsm65zlq17rrqx84lsd7rajvd0jvd5af5lmlqd";
    };
  };

  CarpAssertMore = buildPerlPackage rec {
    name = "Carp-Assert-More-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1m9k6z0m10s03x2hnc9mh5d4r8lnczm9bqd54jmnw0wzm4m33lyr";
    };
    propagatedBuildInputs = [TestException CarpAssert];
  };

  CarpClan = buildPerlPackage {
    name = "Carp-Clan-6.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJORE/Carp-Clan-6.00.tar.gz;
      sha256 = "0lbin4i0vzagcwkywpd5x4gz3a4ira4yn5g5v1ip0pbpyqnjk15h";
    };
    propagatedBuildInputs = [TestException];
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

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYK/${name}.tar.gz";
      sha256 = "1rh5jwqw3fb16ll5id8z0igpqdwr0czi0xbaa2igalxr53hh2cni";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystPluginAuthentication CatalystModelDBICSchema
    ];
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

  CatalystDevel = buildPerlPackage rec {
    name = "Catalyst-Devel-1.33";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0g41rglw460y2n2xbysjbsjb56jkkz2m5jhap2nw3a5jby1ymp07";
    };
    buildInputs = [ TestFatal TestMore ];
    propagatedBuildInputs =
      [ CatalystRuntime CatalystActionRenderView
        CatalystPluginStaticSimple CatalystPluginConfigLoader
        ClassAccessor ConfigGeneral FileChangeNotify FileCopyRecursive
        FileShareDir Parent PathClass TemplateToolkit YAMLTiny
      ];
    CATALYST_DEVEL_NO_510_CHECK = 1; # bug in Perl 5.10.0
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

  CatalystManual = buildPerlPackage rec {
    name = "Catalyst-Manual-5.8000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/${name}.tar.gz";
      sha256 = "0ay4gcprwqw4h5vsk8g0n9ir51sq7n5i2rdahgqdlb8caj4fshz5";
    };
    buildInputs = [TestPod TestPodCoverage];
  };

  CatalystModelDBICSchema = buildPerlPackage rec {
    name = "Catalyst-Model-DBIC-Schema-0.54";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "19iasq94nph33vz4jrk5x6cqd9ivq0db867s524faba8avrrlxz9";
    };
    buildInputs = [ TestMore TestException TestRequires DBDSQLite ];
    propagatedBuildInputs =
      [ DBIxClass CatalystRuntime CatalystXComponentTraits Moose MooseXTypes
        NamespaceAutoclean CarpClan ListMoreUtils TieIxHash TryTiny
        CatalystDevel DBIxClassSchemaLoader MooseXNonMoose
        NamespaceClean HashMerge DBIxClassCursorCached
      ];
    meta.platforms = stdenv.lib.platforms.linux;
  };

  CatalystRuntime = buildPerlPackage rec{
    name = "Catalyst-Runtime-5.90006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "01afjgcc5lqaw6gmzwym8n09q8nksj4jdl2z25m64sfiv1gdyx2w";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs =
      [ ClassDataInheritable ListMoreUtils NamespaceAutoclean NamespaceClean
        BHooksEndOfScope MooseXEmulateClassAccessorFast ClassMOP
        Moose MooseXMethodAttributes MooseXRoleWithOverloading
        ClassC3AdoptNEXT CGISimple DataDump DataOptList
        HTMLParser HTTPBody HTTPRequestAsCGI
        LWP ModulePluggable PathClass SubExporter
        TextSimpleTable TimeHiRes TreeSimple TreeSimpleVisitorFactory
        URI TaskWeaken /* TextBalanced */ MROCompat MooseXTypes
        MooseXGetopt MooseXTypesCommon StringRewritePrefix
        MooseXTypesLoadableClass Plack PlackMiddlewareReverseProxy
      ];
    meta.platforms = stdenv.lib.platforms.linux;
  };

  CatalystPluginAccessLog = buildPerlPackage rec {
    name = "Catalyst-Plugin-AccessLog-1.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "1cbbg6fviyv398lyhmv14ya0v0h0xs04d29zz9r49vzsbw6shy33";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime ];
  };

  CatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10018";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "1znm81baidzhiiyanigy8rs8jq97vh94fiv4xvkrmaxz0k6vppdx";
    };
    propagatedBuildInputs =
      [ CatalystRuntime CatalystPluginSession ClassInspector ];
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
    name = "Catalyst-Plugin-Authorization-Roles-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Catalyst-Plugin-Authorization-Roles-0.07.tar.gz;
      sha256 = "07b8zc7b06p0fprjj68fk7rgh781r9s3q8dx045sk03w0fnk3b4b";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystPluginAuthentication
      TestException SetObject UNIVERSALisa
    ];
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

  CatalystPluginSession = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-0.34";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0vgm3pjymzxqnjn8cj8ld1wprwj3hq15n26djvjmnx6pwyf2ffgz";
    };
    buildInputs = [ TestMockObject TestDeep ];
    propagatedBuildInputs =
      [ CatalystRuntime ObjectSignature MROCompat ];
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

  CatalystPluginStackTrace = buildPerlPackage rec {
    name = "Catalyst-Plugin-StackTrace-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1ingivnga1yb4dqsj6icc4a58i9wdalzpn2qflsn8n2skgm223qb";
    };
    propagatedBuildInputs = [ CatalystRuntime DevelStackTrace MROCompat ];
  };

  CatalystPluginStaticSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-Static-Simple-0.29";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "1wjh1a24gksjxzzl9wblbaar5gjvlm38kndjx8629fm9dcbqvc14";
    };
    propagatedBuildInputs = [CatalystRuntime MIMETypes];
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

  CatalystViewJSON = buildPerlPackage rec {
    name = "Catalyst-View-JSON-0.33";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "03yda9skcfnwkm4hf2a3y7g2rdjdia5hzfnll0h7z4wiyb8kxfii";
    };
    propagatedBuildInputs = [ CatalystRuntime JSONAny YAML ];
  };

  CatalystViewTT = buildPerlPackage rec {
    name = "Catalyst-View-TT-0.37";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "00vv4rkhpablmmfn70nybxy1jlfxhyf72ck3bch2gcfgqqysxvqz";
    };
    propagatedBuildInputs = [
      CatalystRuntime TemplateToolkit ClassAccessor
      PathClass TemplateTimer
    ];
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CatalystX/${name}.tar.gz";
      sha256 = "0a2mhfgv0kqmaxf2crs8mqk44lyhd9qcwlpzhrc0b0dh4z503mr4";
    };
    propagatedBuildInputs =
      [ CatalystRuntime MooseXTraitsPluggable NamespaceAutoclean ListMoreUtils ];
  };

  CatalystXScriptServerStarman = buildPerlPackage rec {
    name = "CatalystX-Script-Server-Starman-0.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CatalystX/${name}.tar.gz";
      sha256 = "18hpp35bjyw65x564m1m82mr0nmff6836vfjqdwf2lwsb4n8s4xr";
    };
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime Starman ];
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

  CGISimple = buildPerlPackage rec {
    name = "CGI-Simple-1.113";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CGI/${name}.tar.gz";
      sha256 = "0g8v0jd7dk310k6ncz47qa1cfrysi8yib1zwkhasv4zhswgqiqjj";
    };
    propagatedBuildInputs = [ IOStringy ];
  };

  ClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.31.tar.gz;
      sha256 = "1a4v5qqdf9bipd6ba5n47mag0cmgwp97cid67i510aw96bcjrsiy";
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

  ClassAccessorGrouped = buildPerlPackage rec {
    name = "Class-Accessor-Grouped-0.10003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class/${name}.tar.gz";
      sha256 = "036cyp74cdz8y5nig2b1iyqk6ps60sbqb0dqy0ybp3j5qiy28mix";
    };
    buildInputs = [ TestMore TestException ];
    propagatedBuildInputs = [ ClassInspector SubName ClassXSAccessor ];
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

  ClassC3 = buildPerlPackage rec {
    name = "Class-C3-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1bl8z095y4js66pwxnm7s853pi9czala4sqc743fdlnk27kq94gz";
    };
  };

  ClassC3AdoptNEXT = buildPerlPackage rec {
    name = "Class-C3-Adopt-NEXT-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1kxbdq10vicrbz3i6hvml3mma5x0r523gfdd649f9bvrsizb0jxj";
    };
    propagatedBuildInputs = [MROCompat TestException ListMoreUtils];
  };

  ClassC3Componentised = buildPerlPackage rec {
    name = "Class-C3-Componentised-1.001000";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class/${name}.tar.gz";
      sha256 = "1nzav8arxll0rya7r2vp032s3acliihbb9mjlfa13rywhh77bzvl";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassC3 ClassInspector MROCompat ];
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

  ClassInspector = buildPerlPackage rec {
    name = "Class-Inspector-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "0rhsn73g516knx5djqzlgygjk8ij6xxjkm1sim0facvd4z0wlw0a";
    };
  };

  ClassMakeMethods = buildPerlPackage rec {
    name = "Class-MakeMethods-1.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/${name}.tar.gz";
      sha256 = "10f65j4ywrnwyz0dm1q5ymmpv875drj40mj1xvsjv0bnjinnwzj8";
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

  ClassLoad = buildPerlPackage rec {
    name = "Class-Load-0.12";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class/${name}.tar.gz";
      sha256 = "0siw8hyqnmn0flk1hbd6fnnfqlhkgfr1d5442rri1d8a0rs1a36r";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DataOptList PackageStash ModuleRuntime ];
  };

  ClassLoadXS = buildModule rec {
    name = "Class-Load-XS-0.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class/${name}.tar.gz";
      sha256 = "1k3fffm4z6hvml5gqh27p7l78xs220s2d7ybd2a42akxrx8gk9r8";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassLoad ];
  };

  ClassUnload = buildPerlPackage rec {
    name = "Class-Unload-0.07";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class//${name}.tar.gz";
      sha256 = "1alvn94j0wgfyyym092g9cq0mbhzin0zf7lfja6578jk5cc788rr";
    };
    propagatedBuildInputs = [ ClassInspector ];
  };

  ClassXSAccessor = buildPerlPackage rec {
    name = "Class-XSAccessor-1.13";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Class/${name}.tar.gz";
      sha256 = "1nj21xq8bqvfz2mafrfskzw2p2j48b5k3rqxgxk99lw5ysmkz834";
    };
  };

  Clone = buildPerlPackage rec {
    name = "Clone-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RD/RDF/${name}.tar.gz";
      sha256 = "0fazl71hrc0r56gnc7vzwz9283p7h62gc8wsna7zgyfvrajjnhwl";
    };
  };

  CommonSense = buildPerlPackage rec {
    name = "common-sense-3.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "0s1lym5519gwdgwd6c6cq9c9iagr7bmb16jklq5iq3nsdyb0qc2l";
    };
  };

  CompressRawBzip2 = import ../development/perl-modules/Compress-Raw-Bzip2 {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) bzip2;
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

  ConfigGeneral = buildPerlPackage rec {
    name = "Config-General-2.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TL/TLINDEN/${name}.tar.gz";
      sha256 = "0ff5qh6dx8qijbkx5yfvn3fhn5m2hkcl8yjmqxwnvcg78h33s3ps";
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

  CPANMeta = buildPerlPackage rec {
    name = "CPAN-Meta-2.112150";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CPAN/${name}.tar.gz";
      sha256 = "0k48ccws3j158mrr348gishh5q7vg4fmx36fgrnnnydv0psic4n0";
    };
    propagatedBuildInputs =
      [ CPANMetaYAML JSONPP ParseCPANMeta VersionRequirements version ];
  };

  CPANMetaYAML = buildPerlPackage rec {
    name = "CPAN-Meta-YAML-0.003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/CPAN/${name}.tar.gz";
      sha256 = "1mdmn9znk60izxdvvawsylv7n85x4y6lx8pa0gnkcp6d96q031af";
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

  DataDump = buildPerlPackage rec {
    name = "Data-Dump-1.21";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "1fcy6q8p406ag8g50l7znns3kxazfb458l6kw8pbsp4axnkz9ydx";
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

  DataOptList = buildPerlPackage rec {
    name = "Data-OptList-0.107";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0r2sbvh1kj69al5crg394v5j5wkffvqdb17fz1rjfgb6h3v93xi8";
    };
    propagatedBuildInputs = [SubInstall ParamsUtil];
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
      [ ClassLoad Moose TaskWeaken TieToObject NamespaceClean ];
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

  DateTime = buildModule rec {
    name = "DateTime-0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0wabln41nk73w4j3lc1ri8jzmxd3yyskdlagv9jflqaz8awcs8qy";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone MathRound ];
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
    inherit (pkgs) postgresql;
  };

  DBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db4;
  };

  DBI = buildPerlPackage rec {
    name = "DBI-1.616";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "0m6hk66xprjl314d5c665hnd1vch9a0b9y6ywvmf04kdqj33kkk0";
    };
  };

  DBIxClass = buildPerlPackage rec {
    name = "DBIx-Class-0.08196";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/${name}.tar.gz";
      sha256 = "15k1kgbrsnkwr0ib6cyr114zk904lisy4k09gfiynag9wjhv47lm";
    };
    buildInputs = [ DBDSQLite TestException TestWarn ];
    propagatedBuildInputs =
      [ PackageStash ClassAccessorGrouped ClassC3Componentised
        ClassInspector ConfigAny ContextPreserve DBI DataCompare
        DataDumperConcise DataPage HashMerge MROCompat ModuleFind
        PathClass SQLAbstract ScopeGuard SubName TryTiny
        NamespaceClean
      ];
  };

  DBIxClassCursorCached = buildPerlPackage rec {
    name = "DBIx-Class-Cursor-Cached-1.001002";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/DBIx/${name}.tar.gz";
      sha256 = "19r7jr6pknxiirrybq0cd0lnr76xiw05arnfqgk9nrhp6c7vvil0";
    };
    buildInputs = [ DBDSQLite ];
    propagatedBuildInputs = [ CacheCache DBIxClass CarpClan ];
  };

  DBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [DBIxClass HTMLWidget];
  };

  DBIxClassSchemaLoader = buildPerlPackage rec {
    name = "DBIx-Class-Schema-Loader-0.07014";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/DBIx/${name}.tar.gz";
      sha256 = "0qrsh6i8p4mpx5bapn40cpsbvnvzivli71gymbiqjd0mjflbsjf6";
    };
    buildInputs = [ TestException TestMore TestWarn DBDSQLite ];
    propagatedBuildInputs =
      [ DataDump LinguaENInflectNumber LinguaENInflectPhrase
        ClassAccessor ClassAccessorGrouped ClassC3Componentised
        MROCompat CarpClan DBIxClass ClassLoad ClassUnload
        ListMoreUtils NamespaceClean ScopeGuard TryTiny TaskWeaken
        StringCamelCase StringToIdentifierEN
      ];
  };

  DevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/${name}.tar.gz";
      sha256 = "174m5dx2z89h4308gx6s6vmg93qzaq0bh9m91hp2vqbyialnarhw";
    };
    propagatedBuildInputs = [SubExporter ScopeGuard];
  };

  DevelHide = buildPerlPackage rec {
    name = "Devel-Hide-0.0008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "14hwwirpc9cnwn50rshb8hb778mia4ni75jv2dih8l9i033m4i26";
    };
  };

  DevelStackTrace = buildPerlPackage rec {
    name = "Devel-StackTrace-1.27";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Devel/${name}.tar.gz";
      sha256 = "01p7b9cmji582bld81c3b84jffhdi59zydnxjj6fh3m29zyysmfs";
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage rec {
    name = "Devel-StackTrace-AsHTML-0.11";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Devel/${name}.tar.gz";
      sha256 = "0y0r42gszp3bxbs9j2nn3xgs8ij1cnadrywwwdc6r0y8m0siyapg";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
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
    name = "Digest-HMAC-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.01.tar.gz;
      sha256 = "042d6nknc5icxqsy5asrh8v2shmvg7b3vbj95jyk4sbqlqpacwz3";
    };
    propagatedBuildInputs = [DigestSHA1];
  };

  DigestMD4 = buildPerlPackage rec {
    name = "Digest-MD4-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/${name}.tar.gz";
      sha256 = "c7d7a32f5c2710c929b5688a7b057ec8ddbc51cf278f623e771fc02dcabd6a1f";
    };
  };

  DigestSHA = buildPerlPackage rec {
    name = "Digest-SHA-5.47";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSHELOR/${name}.tar.gz";
      sha256 = "1xk9hdds4dk5iklxr8fdfbgfvd8cwgcjh5jqmjxhaw57ss2dh5wx";
    };
  };

  DigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.12.tar.gz;
      sha256 = "19gmbb3yb9pr0y02c6rf99zh14a7a67l4frl7cs0lzpxb41484xa";
    };
  };

  DistCheckConflicts = buildPerlPackage rec {
    name = "Dist-CheckConflicts-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "1lh7j20vvsh4dyh74hr0wnabyv8vcdkilfi93m2fbk69qk3w995j";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils SubExporter ];
  };

  EmailAbstract = buildPerlPackage rec {
    name = "Email-Abstract-3.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0fiaagxc2hy5g3qiipv4cspkwbaggdmsxbll1f4jx2qnq5hm668d";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ];
  };

  EmailAddress = buildPerlPackage rec {
    name = "Email-Address-1.889";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0icpln4cs058x5lbqsg4wzb8p02qv7bb1z6ljxh70yd3y1mn0nxn";
    };
  };

  EmailDateFormat = buildPerlPackage rec {
    name = "Email-Date-Format-1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "114fqcnmvzi0z100yx89j6rgwbicb0bslswhyr8z2pzsvwv3czqc";
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

  EmailSender = buildPerlPackage rec {
    name = "Email-Sender-0.120002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1cp735ndmh76xzijsm1hd0yh0m9yj34jc8akjhidkn677h2021dc";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs =
      [ CaptureTiny EmailAbstract EmailAddress ListMoreUtils Moose
        Throwable TryTiny
      ];
  };

  EmailSimple = buildPerlPackage rec {
    name = "Email-Simple-2.100";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1q86p9r5sb1dwdhcbnkfrbx08440cf74vzgrqc05cgi8mmhdfsh9";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
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
    name = "Encode-Locale-1.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Encode/${name}.tar.gz";
      sha256 = "0h2kim6mg236s749wlg35lhv1zdkrkr0bm65spkg005cn0mbmi90";
    };
  };

  Error = buildPerlPackage rec {
    name = "Error-0.17016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1akr35g7nbhch8fgkrqixjy08gx19brp981wyxplscizwcya64zh";
    };
  };

  EvalClosure = buildPerlPackage rec {
    name = "Eval-Closure-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0qjfigd7r3xwizf8wff3g2mhidbqqlb6xy125iwd03f3i5hmnhic";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ SubExporter TryTiny ];
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

  ExtUtilsInstall = buildPerlPackage rec {
    name = "ExtUtils-Install-1.54";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "19igil4iwh3jdyvjm8s0ypm8wxsny6nv4z3b3lkwhq0ccjgd3rp3";
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

  FileChangeNotify = buildModule rec {
    name = "File-ChangeNotify-0.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "000aiiijf16j5cf8gql4vr6l9y561famkfb5qv5d29xz2ad4mmd9";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose MooseXParamsValidate MooseXSemiAffordanceAccessor
        NamespaceAutoclean
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
    name = "File-Listing-6.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "154hp49pcngsqrwi1pbw3fx82v7vql4dc9wh7qfj37vmy8sn1s93";
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

  FileShareDir = buildPerlPackage rec {
    name = "File-ShareDir-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1afr1r1ys2ij8i4r0i85hfrgrbvcha8c7cgkhcrdya1f0lnpw59z";
    };
    propagatedBuildInputs = [ClassInspector ParamsUtil];
  };

  FilesysNotifySimple = buildPerlPackage rec {
    name = "Filesys-Notify-Simple-0.08";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Filesys/${name}.tar.gz";
      sha256 = "042klyvi8fbkhmyg1h7883bbjdhiclmky9w2wfga7piq5il6nxgi";
    };
  };

  FileTemp = buildPerlPackage rec {
    name = "File-Temp-0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJENNESS/${name}.tar.gz";
      sha256 = "11a738swa2as5d6mva798slxnd7ndhqii027ydm0av3y94i957wq";
    };
  };

  FileSlurp = buildPerlPackage rec {
    name = "File-Slurp-9999.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1rdkih4iv77y4xaprwdaw85d8pmja01152ngw66rb1h9rby3n1dv";
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

  GetoptLongDescriptive = buildPerlPackage rec {
    name = "Getopt-Long-Descriptive-0.090";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Getopt/${name}.tar.gz";
      sha256 = "17ghqd50y3627ajc7wl6n7sv055p2gg0h40lavx7qhwyg5rf46lw";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ ParamsValidate SubExporter ];
  };

  GoogleProtocolBuffers = buildPerlPackage rec {
    name = "Google-ProtocolBuffers-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GARIEV/${name}.tar.gz";
      sha256 = "0pxfphg671wh56h59pf0zrj7m1cr0yga95hf3w54563pzcw2vqv3";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches = [
      ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch
    ];
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
  };

  HashMultiValue = buildPerlPackage rec {
    name = "Hash-MultiValue-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Hash/${name}.tar.gz";
      sha256 = "1n9klrg01myij2svcmdc212msmsr3cmsl2yw5k9my8j3s96b5yn1";
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

  HTMLForm = buildPerlPackage rec {
    name = "HTML-Form-6.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "11s9mlybjm14sa6m3wcfjf9pv00yynv0yk4parx44ga9h1a6y6xl";
    };
    propagatedBuildInputs = [ HTMLParser HTTPMessage URI ];
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

  HTMLParser = buildPerlPackage rec {
    name = "HTML-Parser-3.68";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "1hhniqqpvi01vxsyvmcj677yg7a12zy0a3ynwxwg3ig6shn8a3j3";
    };
    propagatedBuildInputs = [HTMLTagset];
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

  HTMLTree = buildPerlPackage rec {
    name = "HTML-Tree-4.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JF/JFEARN/${name}.tar.gz";
      sha256 = "80e4e3caa5e0e025dee5ed383a8d4cc7479ae4802184c4757dafd147a8fca7c9";
    };
    propagatedBuildInputs = [HTMLParser];
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

  HTTPBody = buildPerlPackage rec {
    name = "HTTP-Body-1.12";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "1229hhcm762n9x82jkhl8hmjcaigprcsrhymcdbkqlwch2agm6g2";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ LWP ];
  };

  HTTPCookies = buildPerlPackage rec {
    name = "HTTP-Cookies-6.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "0758c3rj22z1bj7pbypmh1jadgd6w68nn8inhds96r39jhc79d9h";
    };
    propagatedBuildInputs = [ HTTPDate HTTPMessage ];
  };

  HTTPDate = buildPerlPackage rec {
    name = "HTTP-Date-6.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "15nrnfir4xqdd3lm0s0jgh9zwxx5ylmvl63xqmj5wipzl4l76vs6";
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

  HTTPMessage = buildPerlPackage rec {
    name = "HTTP-Message-6.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "10ai2vabbx6yqsyz6rbi7hp4vljmlq9kyn74jvjp95la5v4b6c93";
    };
    propagatedBuildInputs = [ EncodeLocale HTMLParser HTTPDate IOCompress LWPMediaTypes URI ];
  };

  HTTPParserXS = buildPerlPackage rec {
    name = "HTTP-Parser-XS-0.14";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "06srbjc380kvvj76r8n5c2y282j5zfgn0s0zmb9h3shwrynfqj05";
    };
    buildInputs = [ TestMore ];
  };

  HTTPRequest = buildPerlPackage rec {
    name = "HTTP-Message-6.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "c736e083bdf0eea1bb73e2dc3b66db0a8283942c0f69063afadb9a7cfa80011b";
    };
    propagatedBuildInputs = [ HTTPDate URI HTMLParser LWP ];
  };

  HTTPRequestAsCGI = buildPerlPackage rec {
    name = "HTTP-Request-AsCGI-1.2";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "1smwmiarwcgq7vjdblnb6ldi2x1s5sk5p15p7xvm5byiqq3znnwl";
    };
    propagatedBuildInputs = [ ClassAccessor LWP ];
  };

  HTTPResponseEncoding = buildPerlPackage rec {
    name = "HTTP-Response-Encoding-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "1am8lis8107s5npca1xgazdy5sknknzcqyhdmc220s4a4f77n5hh";
    };
    propagatedBuildInputs = [ LWP ];
  };

  HTTPServerSimple = buildPerlPackage rec {
    name = "HTTP-Server-Simple-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/${name}.tar.gz";
      sha256 = "1m1lmpbg0zhiv2vyc3fyyqfsv3jhhb2mbdl5624fqb0va2pnla6n";
    };
    propagatedBuildInputs = [URI];
    doCheck = false;
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

  IOCompress = buildPerlPackage rec {
    name = "IO-Compress-2.037";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "07hs3afzg9ry6ir2f9rf3fg8b129cihs989mr0nh9wdvxgxqmr1q";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    # Work around a self-referencing Makefile variable.
    makeFlags = "INSTALLARCHLIB=$(INSTALLSITEARCH)";
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.10.tar.gz;
      sha256 = "1g6ilxqv2a7spf273v7k0721c6am7pwpjrin3h5zaqxfmd312nav";
    };
    propagatedBuildInputs = [PerlIOviadynamic];
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
    name = "IO-Socket-SSL-1.77";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "2a090167a0d13cdefdac7fb25ca49decd5fd925f37d032bca98c73c4856570a9";
    };
    propagatedBuildInputs = [ URI NetSSLeay ];
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

  IPCRun = buildPerlPackage rec {
    name = "IPC-Run-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1v5yfavvhxscqkdl68xs7i7vcp9drl3y1iawppzwqcl1fprd58ip";
    };
    doCheck = false; /* attempts a network connection to localhost */
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

  JSON = buildPerlPackage rec {
    name = "JSON-2.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "0rfms17d0pkai26kqyzaylbr5wxcrrhyjkyshq85l41xb0g1iplh";
    };
    propagatedBuildInputs = [JSONXS];
  };

  JSONAny = buildPerlPackage rec {
    name = "JSON-Any-1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERIGRIN/${name}.tar.gz";
      sha256 = "16h2p2qcbh0a6wfr5lfspilmjmpdnkn1rrkqw34v8xq1a77fl870";
    };
    propagatedBuildInputs = [JSON];
  };

  JSONPP = buildPerlPackage rec {
    name = "JSON-PP-2.27200";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/JSON/${name}.tar.gz";
      sha256 = "1lv9riws9f72gya2fsp5jvbd1fbzyi8423x38a491ryy9cai2ph3";
    };
  };

  JSONXS = buildPerlPackage rec {
    name = "JSON-XS-2.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "012bf324pf5lnrf6ck2y167i1q1zzzc0w43b381qfnk7v5fcvaik";
    };
    buildInputs = [CommonSense];
  };

  libxml_perl = buildPerlPackage rec {
    name = "libxml-perl-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "1jy9af0ljyzj7wakqli0437zb2vrbplqj4xhab7bfj2xgfdhawa5";
    };
    propagatedBuildInputs = [XMLParser];
  };

  LinguaENInflect = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-1.893";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "1j0jxf3pqnsshakmpdwkgcmlz26hzmkrhg33kz52qzdfys254xmy";
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

  LinguaENTagger = buildPerlPackage rec {
    name = "Lingua-EN-Tagger-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "0nzjgpxd0i5a3sacxsqfvvrfyamxlmzfa9y14r4vs7sc8qm20xd2";
    };
    propagatedBuildInputs = [ HTMLParser LinguaStem ];
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

  ListMoreUtils = buildPerlPackage rec {
    name = "List-MoreUtils-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1bcljhhsk5g0xykvgbxz10ilmj02s58ydiy3g8hbzdr29i20np1i";
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

  LWP = buildPerlPackage rec {
    name = "libwww-perl-6.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/LWP/${name}.tar.gz";
      sha256 = "1zlnz4ylk1y0rw56vlf9knawwjx72b1gm09yp06ccpgmmndif4dg";
    };
    propagatedBuildInputs =
      [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPMessage LWPMediaTypes URI NetHTTP ];
    doCheck = false; # tries to start a daemon
  };

  LWPMediaTypes = buildPerlPackage rec {
    name = "LWP-MediaTypes-6.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/LWP/${name}.tar.gz";
      sha256 = "1fhxql3xnhrlyzkjyss4swvhyh0r58cv2kwjcpj3mdbbg54ah9fz";
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

  MIMETypes = buildPerlPackage rec {
    name = "MIME-Types-1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1zhzyb85zbil2jwrh74rg3bnm9wl74fcg2s64y8b57bk04fdfb7l";
    };
    propagatedBuildInputs = [TestPod];
  };

  ModuleBuild = buildPerlPackage rec {
    name = "Module-Build-0.3800";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Module/${name}.tar.gz";
      sha256 = "1gk0xn5s48f0n3a6k4izw6sigsk84rk06hky7dd48hdmvrq23f4v";
    };
    propagatedBuildInputs =
      [ ExtUtilsInstall ExtUtilsManifest ExtUtilsCBuilder ExtUtilsParseXS
        CPANMeta PerlOSType ModuleMetadata
      ];
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.06.tar.gz;
      sha256 = "1394jk0rn2zmchpl11kim69xh5h5yzg96jdlf76fqrk3dcn0y2ip";
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

  ModuleRuntime = buildPerlPackage rec {
    name = "Module-Runtime-0.011";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Module/${name}.tar.gz";
      sha256 = "0hbpn2jd11gsni77aw189ss4q83jlcvcxr49x9j28bh36hjgif7s";
    };
    propagatedBuildInputs = [ ParamsClassify ];
  };

  Moose = buildPerlPackage rec {
    name = "Moose-2.0401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "07mx4xqfl0bk21kk49gs86ba3wcviarfx9yhxxw96pmaxd0l932i";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs =
      [ DataOptList DevelGlobalDestruction DistCheckConflicts EvalClosure
        ListMoreUtils MROCompat PackageDeprecationManager PackageStash
        PackageStashXS ParamsUtil SubExporter SubName TaskWeaken TryTiny
        ClassLoad ClassLoadXS
      ];
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

  MooseXAttributeChained = buildModule rec {
    name = "MooseX-Attribute-Chained-1.0.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "101kwjzidppcsnyvp9x1vw8vpvkp1cc1csqmzbashwvqy8d0g4af";
    };
    propagatedBuildInputs = [ Moose TryTiny ];
  };

  MooseXEmulateClassAccessorFast = buildPerlPackage rec {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1lkn1h4sxr1483jicsgsgzclbfw63g2i2c3m4v4j9ar75yrb0kh8";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose NamespaceClean ];
  };

  MooseXGetopt = buildPerlPackage rec {
    name = "MooseX-Getopt-0.37";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "161j44v2b4qzv75lk35gvfvs864vcyhkzq6phmhh8zllg3cnfc8k";
    };
    buildInputs = [ TestFatal TestRequires TestWarn ];
    propagatedBuildInputs = [ Moose GetoptLongDescriptive MooseXRoleParameterized ];
  };

  MooseXMethodAttributes = buildPerlPackage rec {
    name = "MooseX-MethodAttributes-0.25";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0rkk0rija7s96747y46qz49g88kymgxvn70mr21id9i8n7cdacww";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose MooseXTypes NamespaceAutoclean NamespaceClean ];
  };

  MooseXNonMoose = buildPerlPackage rec {
    name = "MooseX-NonMoose-0.22";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0mhyabg5f6kngkm1w7hfglkdzjdn5pbgm7vgia0aqy9mwwclbpdp";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
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

  MooseXParamsValidate = buildPerlPackage rec {
    name = "MooseX-Params-Validate-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "16mjxa72gn41pvrk0fgyi98iw6yc7qafnbzr6v2xfiabp9wf5j5m";
    };
    propagatedBuildInputs = [Moose ParamsValidate SubExporter TestException];
  };

  MooseXRoleParameterized = buildPerlPackage rec {
    name = "MooseX-Role-Parameterized-0.26";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "1wfqdkjhwzbzk2cm65r5gz9n6406j8mdq78iga7dnj3mp2csn631";
    };
    buildInputs = [ TestFatal TestMore ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXRoleWithOverloading = buildPerlPackage rec {
    name = "MooseX-Role-WithOverloading-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0qs013vkm0ysykd3hibk4m8bkl0rnysxzralwq19zrvxaqk2krn8";
    };
    propagatedBuildInputs = [ Moose MooseXTypes NamespaceAutoclean aliased ];
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
    propagatedBuildInputs = [ ClassMOP Moose NamespaceAutoclean ];
  };

  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0gv79bsnacrzwpac3dll64zj40qcsbp4kdk8yr9z5bwim7nkvnv3";
    };
    buildInputs =[ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose NamespaceAutoclean ListMoreUtils ];
  };

  MooseXTypes = buildPerlPackage rec {
    name = "MooseX-Types-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1c9z30fbk2h11xkgq8v2idnpaqay3m7ig9bb8scnawgrm49v2f4l";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs =
      [ Moose CarpClan NamespaceClean SubInstall SubName ];
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
    propagatedBuildInputs = [ ClassLoad Moose MooseXTypes NamespaceClean ];
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

  MROCompat = buildPerlPackage rec {
    name = "MRO-Compat-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "0p2hl0cygcds3jjq3awackd72j3vzidfyjacj7gxdlqh65a2fjq7";
    };
  };

  MusicBrainzDiscID = buildModule rec {
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

  NamespaceAutoclean = buildPerlPackage rec {
    name = "namespace-autoclean-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "125g5ny4sqf9kj1sxaqh1jipzyii56p9nsp45jg9fg67i4ljm9pg";
    };
    propagatedBuildInputs = [ BHooksEndOfScope ClassMOP NamespaceClean Moose ];
  };

  NamespaceClean = buildPerlPackage rec {
    name = "namespace-clean-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "0djqishj6mcw1jn9saff4i2glq89dq3rc7slpprcky31jay6jq5i";
    };
    propagatedBuildInputs = [ BHooksEndOfScope DevelHide PackageStash ];
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

  NetHTTP = buildPerlPackage rec {
    name = "Net-HTTP-6.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Net/${name}.tar.gz";
      sha256 = "0ipad5y605fr968snxmp1sxrkvag9r5y0g8qvj9n7ca9nbwq7n3n";
    };
  };

  NetIP = buildPerlPackage {
    name = "Net-IP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.25.tar.gz;
      sha256 = "1iv0ka6d8kp9iana6zn51sxbcmz2h3mbn6cd8pald36q5whf5mjc";
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

  NetServer = buildPerlPackage rec {
    name = "Net-Server-0.99";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Net/${name}.tar.gz";
      sha256 = "0pdf2fvklpcxrdz3wwmhbvjs6kvzcvjw28f3pny8z17188lv06n1";
    };
    doCheck = false; # seems to hang waiting for connections
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
    name = "Net-SSLeay-1.42";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Net/${name}.tar.gz";
      sha256 = "17gxf0d1l0qlxn0d6gqz1dlzl6cdqv0jg47k0h1fcs45rlcpgjmn";
    };
    buildInputs = [ pkgs.openssl ];
    OPENSSL_PREFIX = pkgs.openssl;
    doCheck = false; # Test performs network access.
  };

  NetTwitterLite = buildPerlPackage {
    name = "Net-Twitter-Lite-0.10003";

    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.10003.tar.gz;
      sha256 = "1qh5bw68ad4fqiqbqwhgj859kq35asjmp0fsmrqhlbqy195pwi1i";
    };
    doCheck = false;

    propagatedBuildInputs = [JSONAny Encode LWP CryptSSLeay];
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
    propagatedBuildInputs = [ CryptDHGMP URI HTMLParser HTTPRequest XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage rec {
    name = "Net-OpenID-Consumer-1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "4ab927b6756366fa4cef2b54088645849f32fc7e0cd8de0a50001bbf62946fd8";
    };
    propagatedBuildInputs = [ NetOpenIDCommon JSON ];
  };

  PackageDeprecationManager = buildPerlPackage rec {
    name = "Package-DeprecationManager-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1q2jgq3dfva5wfsl1jn8711bk7fvf5cgpjddd8if9cx3zixnq2n1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ListMoreUtils ParamsUtil SubInstall ];
  };

  PackageStash = buildPerlPackage rec {
    name = "Package-Stash-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0md52rqgcnvspg3l2hvwc31jilq4gkbdwgr5h32gy1hmslaxhpzn";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts PackageDeprecationManager PackageStashXS ];
  };

  PackageStashXS = buildPerlPackage rec {
    name = "Package-Stash-XS-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "1i45mhd17sfq41j62r8kkx2d2f4mi0sp6vl86mmk8a4ssq85i73k";
    };
    buildInputs = [ TestFatal ];
  };

  ParamsClassify = buildPerlPackage rec {
    name = "Params-Classify-0.013";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Params/${name}.tar.gz";
      sha256 = "1d4ysd95flszrxrnjgy6s7b80jkagjsb939h42i2hix4q20sy0a1";
    };
    buildInputs = [ ExtUtilsParseXS ];
  };

  ParamsUtil = buildPerlPackage rec {
    name = "Params-Util-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "6a1613b669f18bf329003c7dbd11435248cffa9c1497645073821a68c0987a40";
    };
  };

  ParamsValidate = buildModule rec {
    name = "Params-Validate-1.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Params/${name}.tar.gz";
      sha256 = "1yziygqb8km28xr3yzzsllzgg7xnxdh4wqfm2kmf2s6qck0dkij4";
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
    name = "Parse-CPAN-Meta-1.4401";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Parse/${name}.tar.gz";
      sha256 = "0g381a0wynh9xc9wf44drw5vhfbd3wa693myy018jwq9vp51pf5q";
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

  PathClass = buildPerlPackage rec {
    name = "Path-Class-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/${name}.tar.gz";
      sha256 = "1g4in1k3nvk7w034hmhix9hjbjgpshwc5m8xvpga84rfzbadpnyc";
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

  Plack = buildPerlPackage rec {
    name = "Plack-0.9985";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0cik1iwpwky7aliwi59z93ykd13ysp4xg5dps1vd4dhqylkn4ns8";
    };
    buildInputs = [ TestRequires TestTCP HTTPRequestAsCGI ];
    propagatedBuildInputs =
      [ LWP FileShareDir TryTiny DevelStackTrace DevelStackTraceAsHTML HTTPBody
        HashMultiValue FilesysNotifySimple
      ];
  };

  PlackMiddlewareReverseProxy = buildPerlPackage rec {
    name = "Plack-Middleware-ReverseProxy-0.10";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Plack/${name}.tar.gz";
      sha256 = "0w9bl1z71frra0dgz4gsxskvj1c8dhjkhrj2gqwdds6jcqyny7mf";
    };
    propagatedBuildInputs = [ Plack YAML ];
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

  PadWalker = buildPerlPackage rec {
    name = "PadWalker-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/${name}.tar.gz";
      sha256 = "0lvh0qlyrpnkssqkhfxhbjpb5lyr4fp6d1p7la8k6w3wv1qmbl1s";
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

  ScalarString = buildPerlPackage rec {
    name = "Scalar-String-0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "d3a45cc137bb9f7d8848d5a10a5142d275a98f8dcfd3adb60593cee9d33fa6ae";
    };
  };

  ScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.03.tar.gz;
      sha256 = "07x966fkqxlwnngxs7a2jrhabh8gzhjfpqq56n9gkwy7f340sayb";
    };
  };

  ScopeUpper = buildPerlPackage rec {
    name = "Scope-Upper-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "1yrjx22hlsv2qdgicnz589j9iipyxl56y6pnks2cfg6icpp97v5w";
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

  SQLAbstract = buildPerlPackage rec {
    name = "SQL-Abstract-1.72";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "12abz50zz51s1f5hvs5xl6smb369sjid1zyjkfygkiglqp4an0kr";
    };
    buildInputs = [ TestDeep TestException TestWarn ];
    propagatedBuildInputs =
      [ ClassAccessorGrouped GetoptLongDescriptive HashMerge ];
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

  Starman = buildPerlPackage rec {
    name = "Starman-0.2014";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Plack/${name}.tar.gz";
      sha256 = "0hf3wpm2q4zcgjahjrpkkzy4fn74vkddg9yqs7p97xb290pvlbki";
    };
    patches = [ ../development/perl-modules/starman-dont-change-name.patch ];
    buildInputs = [ TestRequires TestTCP ];
    propagatedBuildInputs = [ Plack DataDump HTTPParserXS NetServer ];
    doCheck = false; # binds to various TCP ports1
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

  StringRewritePrefix = buildPerlPackage rec {
    name = "String-RewritePrefix-0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "17v0pwiprsz9ibxlhpi789jxg691nz9prpabvb4dn4nb0qbi0yd0";
    };
  };

  StringToIdentifierEN = buildPerlPackage rec {
    name = "String-ToIdentifier-EN-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/String/${name}.tar.gz";
      sha256 = "1rmldr7jf4jvkhzlv8hgp48lrmybvinmhv8kcnrpa8las0ijm4vm";
    };
    propagatedBuildInputs =
      [ LinguaENInflectPhrase TextUnidecode NamespaceClean ];
  };

  SubExporter = buildPerlPackage rec {
    name = "Sub-Exporter-0.982";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0xf8q05k5xs3bw6qy3pnnl5d670njxsxbw2dprl7n50hf488cbvj";
    };
    propagatedBuildInputs = [SubInstall DataOptList ParamsUtil];
  };

  SubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "16g4dkmb4h5hh15jsq0kvsf3irrlrlqdv7qk6605wh5gjjwbcjxy";
    };
  };

  SubInstall = buildPerlPackage rec {
    name = "Sub-Install-0.925";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1sccc4nwp9y24zkr42ww2gwg6zwax4madi9spsdym1pqna3nwnm6";
    };
  };

  SubName = buildPerlPackage rec {
    name = "Sub-Name-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1w9sf51ai2r3i0kv5wnq7h9g3hcd6zb6i51ivvykb3hzx82vilf9";
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
    name = "Sub-Uplevel-0.2002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2002.tar.gz;
      sha256 = "19b2b9xsw7lvvkcmmnhhv8ybxdkbnrky9nnqgjridr108ww9m5rh";
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
    name = "Task-Weaken-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.02.tar.gz;
      sha256 = "10f9kd1lwbscmmjwgbfwa4kkp723mb463lkbmh29rlhbsl7kb5wz";
    };
  };

  TemplateTimer = buildPerlPackage {
    name = "Template-Timer-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-0.04.tar.gz;
      sha256 = "0j0gmxbq1svp0rb4kprwj2fk2mhl07yah08bksfz0a0pfz6lsam4";
    };
    propagatedBuildInputs = [TemplateToolkit];
  };

  TemplateToolkit = buildPerlPackage rec {
    name = "Template-Toolkit-2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "023sb6mf43m085pf8qq1dh1ill66p424mmj66xna5ji1nkw96pm3";
    };
    propagatedBuildInputs = [AppConfig];
    patches = [
      # Needed to make TT works proy on templates in the Nix store.
      # !!! unnecessary with Nix >= 0.13.
      ../development/perl-modules/template-toolkit-nix-store.patch
    ];
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

  TestDeep = buildPerlPackage rec {
    name = "Test-Deep-0.109";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0nqqxj00ln3b4pma47bj2rcpblpvipfrchqbcxahlq9lh1q4p5s6";
    };
    propagatedBuildInputs = [TestTester TestNoWarnings];
  };

  TestDifferences = buildPerlPackage rec {
    name = "Test-Differences-0.500";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "0ha36j6wr1d47zzilb28bvkm5lm5c6i4rqp4aqyknwg4qmagjr4w";
    };
    propagatedBuildInputs = [ TestMore TextDiff ];
  };

  TestException = buildPerlPackage rec {
    name = "Test-Exception-0.31";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "1lyd6mcg00348xsn9fl59spx68a69ybli7h7gd2k0p4y21q8p0ks";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestFatal = buildPerlPackage rec {
    name = "Test-Fatal-0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0laxzphmqwq0rrizv3n7pcnrn345yh70cip61sl8f8mw8dir1jdx";
    };
    propagatedBuildInputs = [ TryTiny ];
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

  TestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "1j2riyikzyfkxsgkfdqirs7xa8q5d06b9klpk7l9sgydwqdvxdv3";
    };
  };

  TestMore = TestSimple;

  TestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-0.084";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-NoWarnings-0.084.tar.gz;
      sha256 = "19g47pa3brr9px3jnwziapvxcnghqqjjwxz1jfch4asawpdx2s8b";
    };
    propagatedBuildInputs = [TestTester];
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
    name = "Test-Pod-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-Pod-1.26.tar.gz;
      sha256 = "025rviipiaa1rf0bp040jlwaxwvx48kdcjriaysvkjpyvilwvqd4";
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

  TestRequires = buildPerlPackage rec {
    name = "Test-Requires-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "1ksyg4npzx5faf2sj80rm74qjra4q679750vfqfvw3kg1d69wvwv";
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

  TestSimple = buildPerlPackage rec {
    name = "Test-Simple-0.98";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "1a0jrl3n2g05qn6c79pv5bnc1wlq36qccwdgf1pjrrvmrgi07cig";
    };
  };

  TestSubCalls = buildPerlPackage rec {
    name = "Test-SubCalls-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "a334b0457da338d79be2dbb62d403701fc90f7607df840115ff45ee1e2bd6e70";
    };
    propagatedBuildInputs = [ HookLexWrap ];
  };

  TestTCP = buildPerlPackage rec {
    name = "Test-TCP-1.13";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "00vbkynkdflqgdvywdxzgg3yx1w7nfb68py8l3lglq9jq4pq9wbb";
    };
    propagatedBuildInputs = [ TestMore TestSharedFork ];
  };

  TestTester = buildPerlPackage {
    name = "Test-Tester-0.107";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.107.tar.gz;
      sha256 = "0qgmsl6s6xm39211lywyzwrlz0gcmax7fb8zipybs9yxfmwcvyx2";
    };
  };

  TestUseOk = buildPerlPackage rec {
    name = "Test-use-ok-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "11inaxiavb35k8zwxwbfbp9wcffvfqas7k9idy822grn2sz5gyig";
    };
  };

  TestWarn = buildPerlPackage rec {
    name = "Test-Warn-0.24";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "12r1mcwrm6cgc3ppgawwv265vmrighj4bl6xc5c41f4c2l6bdxml";
    };
    propagatedBuildInputs = [ TestSimple TestException ArrayCompare TreeDAGNode ];
    buildInputs = [ TestPod ];
  };

  TestWWWMechanize = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "11knym5ppish78rk8r1hymvq1py43h7z8d6nk8p4ig3p246xx5qa";
    };
    propagatedBuildInputs = [
      CarpAssertMore URI TestLongString WWWMechanize
    ];
    doCheck = false;
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

  TextAligner = buildPerlPackage rec {
    name = "Text-Aligner-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANNO/${name}.tar.gz";
      sha256 = "137m8w13ffdm3fbvy6yw0izrl2p87zawp1840qvsdw1nd0plxyp9";
    };
  };

  TextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "0vb0093v3kk7iczb46zzdg7myfyjldwrk8wbk7ibk56gvj350f7c";
    };
  };

  TextDiff = buildPerlPackage rec {
    name = "Text-Diff-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "08das6k4nrf8dgcg2l1jcy8868kgzx976j38rpdndgrgq0nz148n";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
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
    name = "Text-SimpleTable-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Text-SimpleTable-0.05.tar.gz;
      sha256 = "028pdfmr2gnaq8w3iar8kqvrpxcghnag8ls7h4227l9zbxd1k9p9";
    };
  };

  TextTable = buildPerlPackage rec {
    name = "Text-Table-1.114";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANNO/${name}.tar.gz";
      sha256 = "0qnpfyv7l98hyah3bnq19c33m9jh5sg0fmw2xxzaygmnp2pgpmpm";
    };
    propagatedBuildInputs = [TextAligner];
  };

  TextTabularDisplay = buildPerlPackage rec {
    name = "Text-TabularDisplay-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "05r3jvdf8av16hgy0i3wnc581ski08q1bnllq5cq1fnc7h2nm1c7";
    };
    propagatedBuildInputs = [TextAligner];
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

  TieIxHash = buildPerlPackage rec {
    name = "Tie-IxHash-1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GS/GSAR/${name}.tar.gz";
      sha256 = "1xpj2c1dzcp14hfnxahy4r5f19c8afh8k6sfryq9gi76aadvjyk8";
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
    name = "Tree-DAG_Node-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COGENT/Tree-DAG_Node-1.06.tar.gz;
      sha256 = "0anvwfh4vqj41ipq52p65sqlvw3rvm6cla5hbws13gyk9mvp09ah";
    };
  };

  TreeSimple = buildPerlPackage {
    name = "Tree-Simple-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-1.18.tar.gz;
      sha256 = "0bb2hc8q5rwvz8a9n6f49kzx992cxczmrvq82d71757v087dzg6g";
    };
    propagatedBuildInputs = [TestException];
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

  TryTiny = buildPerlPackage rec {
    name = "Try-Tiny-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "1fjhwq347wa74h94nd54lx194s26s7x9whfc0kkpcng2sgs54vvs";
    };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.12.tar.gz;
      sha256 = "1abadbgcy11cmlmj9qf1v73ycic1qhysxv5xx81h8s4p81alialr";
    };
  };

  UNIVERSALisa = buildModule rec {
    name = "UNIVERSAL-isa-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "0iksklmfhiaxg2rsw827n97k1mris6dg596rdwk2gmrwl0rsk0wz";
    };
  };

  UNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/UNIVERSAL-require-0.11.tar.gz;
      sha256 = "1rh7i3gva4m96m31g6yfhlqcabszhghbb3k3qwxbgx3mkf5s6x6i";
    };
  };

  URI = buildPerlPackage rec {
    name = "URI-1.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1inanl9vs6q1bwvig1s8hdwagjw4484gs4s7pjnx5f4xb2dx526b";
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

  WWWMechanize = buildPerlPackage rec {
    name = "WWW-Mechanize-1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1yxvw5xfng5fj4422869p5dwvmrkmqph9gdm2nl12wngydk93lnh";
    };
    propagatedBuildInputs = [LWP HTTPResponseEncoding HTTPServerSimple];
    doCheck = false;
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

  # XSLoader = buildPerlPackage {
  #   name = "XSLoader-0.08";
  #   src = fetchurl {
  #     url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.08.tar.gz;
  #     sha256 = "0mr4l3givrpyvz1kg0kap2ds8g0rza2cim9kbnjy8hi64igkixi5";
  #   };
  # };

  YAML = buildPerlPackage rec {
    name = "YAML-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "81ada73c7eda69dad3cc679b2facba50f2634edcc16c59a7b66bffb9f2fa0e90";
    };
  };

  YAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "15acwp2qdxfmhfqj4c1s57xyy48hcfc87lblww3lbvihqbysyzss";
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
