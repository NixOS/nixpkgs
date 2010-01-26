/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{pkgs}:

rec {

  inherit (pkgs) buildPerlPackage fetchurl stdenv perl;

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

  Boolean = buildPerlPackage rec {
    name = "boolean-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "1xqhzy3m2r08my13alff9bzl8b6xgd68312834x0hf33yir3l1yn";
    };
  };

  CacheFastMmap = buildPerlPackage {
    name = "Cache-FastMmap-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.28.tar.gz;
      sha256 = "1m851bz5025wy24mzsi1i8hdyg8bm7lszx9rnn47llsv6hb9v0da";
    };
    doCheck = false;
  };

  CaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1fm0fvdy9b7z8k1cyah2qbj0gqlv01chxmqmashwj16198yr7vrc";
    };
    propagatedBuildInputs = [HTMLTiny LWP];
    buildInputs = [TestPod];
  };

  CaptureTiny = buildPerlPackage rec {
    name = "Capture-Tiny-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "0qg74sfqc3cj8g21nsbif413c8vzvvs49v4vnqbw1410sa4fxsaw";
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
    name = "Catalyst-Action-RenderView-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1qmjygjb5rzfanvw75czambfk4xmp1bc225mshzc6sddn7fc226s";
    };
    propagatedBuildInputs = [CatalystRuntime HTTPRequestAsCGI DataVisitor];
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
    name = "Catalyst-Devel-1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "0akqzyagx3fzngmnc880wk0z2spnmzs32s2mmpskkrq2yc7spyjn";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystActionRenderView
      CatalystPluginStaticSimple CatalystPluginConfigLoader PathClass
      TemplateToolkit ClassAccessor ConfigGeneral FileCopyRecursive
      Parent FileChangeNotify
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
    name = "Catalyst-Model-DBIC-Schema-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "136m988xkxbjzaj4jix7arb9l65sx6bahbw7v1ma6m4ifpgpj5fq";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystDevel DBIxClass UNIVERSALrequire
      ClassDataAccessor DBIxClassSchemaLoader CatalystXComponentTraits
      TieIxhash
    ];
  };

  CatalystRuntime = buildPerlPackage rec{
    name = "Catalyst-Runtime-5.80012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "1kafxm92b5q2chdrcwqk73gdh3dbvfqa2718sms0md637vqczpip";
    };
    propagatedBuildInputs = [
      LWP ClassAccessor ClassDataInheritable ClassInspector
      CGISimple DataDump FileModified HTTPBody HTTPRequestAsCGI
      PathClass TextSimpleTable TreeSimple TreeSimpleVisitorFactory
      SubExporter MROCompat TestMockObject ClassMOP Moose
      NamespaceClean ScopeUpper MooseXEmulateClassAccessorFast
      ClassC3 ClassC3AdoptNEXT NamespaceAutoclean MooseXMethodAttributes
      StringRewritePrefix ModulePluggable
    ];
  };

  CatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "01hfsxgbpkvcli4hpmzig1hfrjfllwnig6p287v0bc72l6gklzbd";
    };
    propagatedBuildInputs = [CatalystRuntime CatalystPluginSession];
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
    name = "Catalyst-Plugin-ConfigLoader-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICAS/${name}.tar.gz";
      sha256 = "08h72b9hndvfp9m8mpn21m5yiw77wzxvwf2vx6d0i9zbb83k3fk8";
    };
    propagatedBuildInputs = [CatalystRuntime DataVisitor ConfigAny MROCompat];
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
    name = "Catalyst-Plugin-Session-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1sdrcip5ipi2jz9af3ak200l4qdimypljfc55wyp7228s2rlv99s";
    };
    propagatedBuildInputs = [
      CatalystRuntime TestMockObject ObjectSignature
      TestDeep MROCompat
    ];
  };

  CatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1rvxbfnpf9x2pc2zgpazlcgdlr2dijmxgmcs0m5nazs0w6xikssb";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystPluginSession TestMockObject
    ];
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "0h46848mr3i9yadaxvsrdpfn7z22bvk8pa3g71hs7f8m4wd19ns7";
    };
    propagatedBuildInputs = [
      PathClass CatalystPluginSession CacheFastMmap
    ];
  };

  CatalystPluginStackTrace = buildPerlPackage rec {
    name = "Catalyst-Plugin-StackTrace-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1ingivnga1yb4dqsj6icc4a58i9wdalzpn2qflsn8n2skgm223qb";
    };
    propagatedBuildInputs = [CatalystRuntime DevelStackTrace];
  };

  CatalystPluginStaticSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-Static-Simple-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1f457b8sci1wablvzwplp4n5gn8902qz3s1qp40jb4k7y13wq74j";
    };
    propagatedBuildInputs = [CatalystRuntime MIMETypes];
  };

  CatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/${name}.tar.gz";
      sha256 = "0l9jvc4sqchhpmhn70lm46k2avdsdk19i9wgas1awhzyr445c0b3";
    };
    propagatedBuildInputs = [
      CatalystRuntime TestWWWMechanizeCatalyst TestUseOk
      TextCSV XMLSimple
    ];
  };

  CatalystViewTT = buildPerlPackage rec {
    name = "Catalyst-View-TT-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "15r5l0b943x2s863n38g3ir5xazja1s1kj022gs5bm4lw2hnkcvm";
    };
    propagatedBuildInputs = [
      CatalystRuntime TemplateToolkit ClassAccessor
      PathClass TemplateTimer
    ];
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1xsy3i2019rl0mdpzs375al8ckb07s5pzg2h3nv3s4xn4qnn4vnk";
    };
    propagatedBuildInputs = [
      CatalystRuntime NamespaceAutoclean ListMoreUtils MooseXTraitsPluggable
    ];
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
    name = "CGI-Session-4.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/${name}.tar.gz";
      sha256 = "186lqqmfvisw3i74anvnsaqlbp6ww3wyhlsgdpni0mlcnh56h4gw";
    };
    buildInputs = [ DBFile ];
  };

  CGISimple = buildPerlPackage {
    name = "CGI-Simple-1.106";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/CGI-Simple-1.106.tar.gz;
      sha256 = "0r0wc2260jnnch7dv7f6ailjf5w8hpqm2w146flfcchcryfxjlpg";
    };
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
    name = "Class-Accessor-Grouped-0.09002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1r1jbml1zc51x3p3mixq90d27pjlmx9mv4bz1bcp0whm335b1lr6";
    };
    propagatedBuildInputs = [ClassInspector MROCompat SubName SubIdentify];
  };

  ClassAutouse = buildPerlPackage {
    name = "Class-Autouse-1.99_02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-1.99_02.tar.gz;
      sha256 = "1jkhczx2flxrz154ps90fj9wcchkpmnp5sapwc0l92rpn7jpsf08";
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
    name = "Class-C3-Componentised-1.0005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASH/${name}.tar.gz";
      sha256 = "1ka8af8wxypgfkys6dkcp0rh87kx5rsgfm9k582smrjjs0b8zmvv";
    };
    propagatedBuildInputs = [
      ClassC3 ClassInspector TestException MROCompat
    ];
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

  ClassMOP = buildPerlPackage rec {
    name = "Class-MOP-0.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "00y5hl2sx1w0i1gl0cxj8x6k6xi8wagr0gwn388n1d0pv10mw12z";
    };
    propagatedBuildInputs = [
      MROCompat TaskWeaken TestException SubName SubIdentify
      DevelGlobalDestruction
    ];
  };

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

  ClassUnload = buildPerlPackage {
    name = "Class-Unload-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.05.tar.gz;
      sha256 = "01b0j10nxbz37xnnzw3hgmpfgq09mc489kq2d8f5nswsrlk75001";
    };
    propagatedBuildInputs = [ClassInspector];
  };

  Clone = buildPerlPackage rec {
    name = "Clone-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RD/RDF/${name}.tar.gz";
      sha256 = "0fazl71hrc0r56gnc7vzwz9283p7h62gc8wsna7zgyfvrajjnhwl";
    };
  };
  
  CompressRawBzip2 = import ../development/perl-modules/Compress-Raw-Bzip2 {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) bzip2;
  };

  CompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) zlib;
  };

  CompressZlib = buildPerlPackage rec {
    name = "Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "1k1i539fszhxay8yllh687sw06i68g8ikw51pvy1c84p3kg6yk4v";
    };
    propagatedBuildInputs = [
      CompressRawZlib IOCompressBase IOCompressGzip
    ];
  };

  ConfigAny = buildPerlPackage {
    name = "Config-Any-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Config-Any-0.14.tar.gz;
      sha256 = "1vlr4w2m88figac5pblg6ppzrm11x2pm7r05n48s84cp4mizhim1";
    };
  };

  ConfigGeneral = buildPerlPackage rec {
    name = "Config-General-2.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TL/TLINDEN/${name}.tar.gz";
      sha256 = "0r7qj4nhmflcda2r72yysl93ziwzc1qjnjfzi7ifd4fxh53zjy59";
    };
  };

  constant = buildPerlPackage {
    name = "constant-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/constant-1.15.tar.gz;
      sha256 = "1ygz0hd1fd3q88r6dlw14kpyh06zjprksdci7qva6skxz3261636";
    };
  };

  CookieXS = buildPerlPackage rec {
    name = "Cookie-XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    propagatedBuildInputs = [
      TestMore CGICookieXS
    ];
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

  CryptPasswordMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LU/LUISMUNOZ/Crypt-PasswdMD5-1.3.tar.gz;
      sha256 = "13j0v6ihgx80q8jhyas4k48b64gnzf202qajyn097vj8v48khk54";
    };
  };

  CryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "1f0i5y99ly39vf86jpzwqz8mkz1460vryv85jgqmfx007p781s0l";
    };
    makeMakerFlags = "--lib=${pkgs.openssl}/lib";
  };

  DataDump = buildPerlPackage {
    name = "Data-Dump-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.11.tar.gz;
      sha256 = "0h5y40b6drgsf87nhwhqx1dprq70f98ibm03l9al4ndq7mrx97dd";
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

  DataOptList = buildPerlPackage rec {
    name = "Data-OptList-0.104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1k1qvf3ik2rn9mg65ginv3lyy6dlg1z08yddcnzbnizs8vbqqaxd";
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

  DataVisitor = buildPerlPackage rec {
    name = "Data-Visitor-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "11i1svvj57m31w8gh6qp7mvkiff9036qwfljm4hpbyh7f83clzq9";
    };
    propagatedBuildInputs = [
      TestMockObject TaskWeaken TestUseOk TieToObject
      NamespaceClean AnyMoose
    ];
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

  DateTime = buildPerlPackage rec {
    name = "DateTime-0.4501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1hqhc4xfjgcc1r488gjbi498ws3pxiayabl46607lq02qddcv57s";
    };
    propagatedBuildInputs = [DateTimeLocale DateTimeTimeZone];
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
    name = "DateTime-Format-Strptime-1.0800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RICKM/${name}.tgz";
      sha256 = "10vsmwlhnc62krsh5fm2i0ya7bgjgjsm6nmj56f0bfifjh57ya1j";
    };
    propagatedBuildInputs = [
      DateTime DateTimeLocale DateTimeTimeZone ParamsValidate
    ];
  };

  DateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1cvp9a4j6vy3xpbv6ipzcz1paw7gzal7lkrbm5ipiilji47d5gaw";
    };
    propagatedBuildInputs = [ListMoreUtils ParamsValidate];
  };

  DateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-0.84";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0jwbldr3x1cl2ibd9dcshdmpg6s5ddc4qiaxcxyqc82cq09ah2vs";
    };
    propagatedBuildInputs = [ClassSingleton ParamsValidate];
  };

  DBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) sqlite;
  };

  DBDmysql = import ../development/perl-modules/DBD-mysql {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) mysql;
  };

  DBDPg = import ../development/perl-modules/DBD-Pg {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) postgresql;
  };

  DBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db4;
  };

  DBI = buildPerlPackage rec {
    name = "DBI-1.609";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "0hfnd8i696x01a52v6vx97bdwaymai7m0gyr2w64lrsyws7ni6wv";
    };
  };

  DBIxClass = buildPerlPackage rec {
    name = "DBIx-Class-0.08112";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "167fmz4pdlis7k3fj20gngihjgs48smijcxhwh6ywsrv6v3vxd57";
    };
    propagatedBuildInputs = [
      TestNoWarnings TestException DBI ScopeGuard
      PathClass ClassInspector ClassAccessorGrouped
      CarpClan TestWarn DataPage SQLAbstract
      SQLAbstractLimit ClassC3 ClassC3Componentised
      ModuleFind DBDSQLite JSONAny SubName
    ];
    buildInputs = [TestPod TestPodCoverage];
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
    name = "DBIx-Class-Schema-Loader-0.04999_09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1v4lqhjh9b6wwd8rayxmvr4nq44z5yffl5jkfccyhcp8lp84ysmf";
    };
    propagatedBuildInputs = [
      DBI DBDSQLite DataDump UNIVERSALrequire
      ClassAccessor ClassDataAccessor ClassC3 CarpClan
      ClassInspector DBIxClass LinguaENInflectNumber
      ClassUnload
    ];
    doCheck = false; # disabled for now, since some tests fail
  };

  DevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/${name}.tar.gz";
      sha256 = "174m5dx2z89h4308gx6s6vmg93qzaq0bh9m91hp2vqbyialnarhw";
    };
    propagatedBuildInputs = [SubExporter ScopeGuard];
  };

  DevelStackTrace = buildPerlPackage rec {
    name = "Devel-StackTrace-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "15zh9gzhw6gv7l6sklp02pfmiiv8kwmmjsyvirppsca6aagy4603";
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

  DigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.01.tar.gz;
      sha256 = "042d6nknc5icxqsy5asrh8v2shmvg7b3vbj95jyk4sbqlqpacwz3";
    };
    propagatedBuildInputs = [DigestSHA1];
  };

  DigestSHA = buildPerlPackage rec {
    name = "Digest-SHA-5.47";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSHELOR/${name}.tar.gz";
      sha256 = "1xk9hdds4dk5iklxr8fdfbgfvd8cwgcjh5jqmjxhaw57ss2dh5wx";
    };
  };

  DigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.11.tar.gz;
      md5 = "2449bfe21d6589c96eebf94dae24df6b";
    };
  };

  EmailAbstract = buildPerlPackage rec {
    name = "Email-Abstract-3.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1ziy44ibnwg4wjlm5lqdrys8x8xndxkzycnjwp2s6harjy2fqqxw";
    };
    propagatedBuildInputs = [EmailSimple];
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
    name = "Email-Sender-0.091870";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1vr1xigx25ikhljhpc5sv75bpczb7ny625ynzbxvic6qm0a3kaqc";
    };
    propagatedBuildInputs = [
      CaptureTiny EmailAbstract EmailAddress ListMoreUtils Moose
      SysHostnameLong
    ];
    preConfigure =
      ''
        chmod u+x util/sendmail
        patchShebangs util/sendmail
      '';
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
    name = "Encode-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.25.tar.gz;
      sha256 = "0prwmbg3xh1lqskianwrfrgasdfmz4kjm3qpdm27ay110jkk25ak";
    };
  };

  ExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-1.50";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YV/YVES/ExtUtils-Install-1.50.tar.gz;
      sha256 = "18fr056fwnnhvgc646crx2p9mybf69mh5rkcphc7bbvahw9i61jy";
    };
    propagatedBuildInputs = [ExtUtilsMakeMaker];
  };

  ExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-6.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/ExtUtils-MakeMaker-6.44.tar.gz;
      sha256 = "0zyypnlmmyp06qbfdpc14rp5rj63066mjammn6rlcqz2iil9mpcj";
    };
  };

  ExtUtilsManifest = buildPerlPackage {
    name = "ExtUtils-Manifest-1.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKOBES/ExtUtils-Manifest-1.53.tar.gz;
      sha256 = "0xgfzivw0dfy29ydfjkg0c9mvlhjvlhc54s0yvbb4sxb2mdvrfkp";
    };
  };

  FileChangeNotify = buildPerlPackage rec {
    name = "File-ChangeNotify-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0qklyrxii0i651gn42csdc0lhcvrwh0m9d316zc7kl75anwl6hly";
    };
    propagatedBuildInputs = [
      ClassMOP Moose MooseXParamsValidate MooseXSemiAffordanceAccessor
    ];
  };

  Filechdir = buildPerlPackage {
    name = "File-chdir-0.1002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-chdir-0.1002.tar.gz;
      sha256 = "1fc2l754bxsizli3injm4wqf8dn03iq16rmfn62l99nxpibl5k6p";
    };
  };

  FileCopyRecursive = buildPerlPackage {
    name = "File-Copy-Recursive-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.37.tar.gz;
      sha256 = "12j0s01zwm67g4bcgbs0k61jwz59q1lndrnxyywxsz3xd30ki8rr";
    };
  };

  FileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
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

  FreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.43.tar.gz;
      sha256 = "1qamc5aggp35xk590a4hy660f2rhc2l7j65hbyxdya9yvg7z437l";
    };
  };

  GraphViz = buildPerlPackage rec {
    name = "GraphViz-2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "1gxpajd49pb9w9ka7nq5477my8snp3myrgiarnk6hj922jpn62xd";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz ];
    propagatedBuildInputs = [ IPCRun ];

    meta = {
      description = "Perl interface to the GraphViz graphing tool";
      license = [ "Artistic" ];
      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  };

  HTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "03lc4pvygp4wn9rsgdkbwk8zkh8x2z5vp8613c6q74imwrfmmfqy";
    };
    propagatedBuildInputs = [
      ClassAccessorChained ClassC3 ConfigAny
      DateCalc ListMoreUtils LWP EmailValid
      DataVisitor DateTime DateTimeFormatBuilder
      DateTimeFormatStrptime DateTimeFormatNatural
      Readonly YAMLSyck RegexpCopy
      HTMLTokeParserSimple TestNoWarnings RegexpCommon
      CaptchaReCAPTCHA HTMLScrubber FileShareDir
      TemplateToolkit CryptCBC CryptDES
    ];
  };

  HTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.56.tar.gz;
      sha256 = "0x1h42r54aq4yqpwi7mla4jzia9c5ysyqh8ir2nav833f9jm6g2h";
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

  HTMLTagset = buildPerlPackage {
    name = "HTML-Tagset-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.10.tar.gz;
      sha256 = "05k292qy7jzjlmmybis8nncpnwwa4jfkm7q3gq6866ydxrzds9xh";
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

  HTMLTree = buildPerlPackage {
    name = "HTML-Tree-3.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETEK/HTML-Tree-3.23.tar.gz;
      sha256 = "1pn80f4g1wixs030f40b80wrj12kwfinwycrx3f10drg4v7ml5zm";
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
    name = "HTTP-Body-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "0s0496sb9l8jfkdx86vahwgdaaxrqb0j6acyww6nk0ajh82qrzfv";
    };
    propagatedBuildInputs = [LWP YAML];
  };

  HTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  HTTPRequestAsCGI = buildPerlPackage rec {
    name = "HTTP-Request-AsCGI-0.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/${name}.tar.gz";
      sha256 = "1k17bgvscjvr4v96l9vm14mpk4r4b5g9w1gpmwl8qfga3czp6sd4";
    };
    propagatedBuildInputs = [ClassAccessor LWP];
  };

  HTTPResponseEncoding = buildPerlPackage rec {
    name = "HTTP-Response-Encoding-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/${name}.tar.gz";
      sha256 = "04gdl633g0s2ckn7zixcma2krbpfcd46jngg155qpdx5sdwfkm16";
    };
    propagatedBuildInputs = [LWP];
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

  IOCompressBase = buildPerlPackage rec {
    name = "IO-Compress-Base-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "10njlwa50mhs5nqws5yidfmmb7hwmwc6x06gk2vnpyn82g3szgqd";
    };
  };

  IOCompressBzip2 = buildPerlPackage rec {
    name = "IO-Compress-Bzip2-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "1kfksf2bslfkviry228p07m1ksnf06mh8gkmdpbrmlmxlbs2idnc";
    };
    propagatedBuildInputs = [IOCompressBase CompressRawBzip2];
  };

  IOCompressGzip = buildPerlPackage rec {
    name = "IO-Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "0sbnx6xdryaajwpssrfgm5b2zasa4ri8pihqwsx3rm5kmkgzy9cx";
    };
    propagatedBuildInputs = [IOCompressBase CompressRawZlib];
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.10.tar.gz;
      sha256 = "1g6ilxqv2a7spf273v7k0721c6am7pwpjrin3h5zaqxfmd312nav";
    };
    propagatedBuildInputs = [PerlIOviadynamic];
  };

  IOPager = buildPerlPackage {
    name = "IO-Pager-0.06.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
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

  ImageExifTool = buildPerlPackage rec {
      name = "Image-ExifTool-7.83";

      src = fetchurl {
        url = "http://www.sno.phy.queensu.ca/~phil/exiftool/${name}.tar.gz";
        sha256 = "1g3ah646w242649sy77wjff3ykjclihv8zvbs0ch1nwfbqprrbl2";
      };

      meta = {
        description = "ExifTool, a tool to read, write and edit EXIF meta information";

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

        licenses = [ "GPLv1+" "Artistic" ];

        maintainers = [ stdenv.lib.maintainers.ludo ];
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

  JSON = buildPerlPackage rec {
    name = "JSON-2.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "0dijqv5b6gnkmdnysx23229kvfg6mwvrxyjrvzn2j9r4m2hmsgvn";
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

  JSONXS = buildPerlPackage rec {
    name = "JSON-XS-2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "0ir0v87w2fwalcwi2fd49mqzjna7cixn3ri0ai6ysdwnsdvbhyny";
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
    name = "Lingua-EN-Inflect-1.89";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.89.tar.gz;
      sha256 = "1jvj67mvvfqxgxspmblay1c844vvhfwrviiarglkaw6phpg74rby";
    };
  };

  LinguaENInflectNumber = buildPerlPackage {
    name = "Lingua-EN-Inflect-Number-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMON/Lingua-EN-Inflect-Number-1.1.tar.gz;
      sha256 = "13hlr1srp9cd9mcc78snkng9il8iavvylfyh81iadvn2y7wikwfy";
    };
    propagatedBuildInputs = [LinguaENInflect];
  };

  ListMoreUtils = buildPerlPackage {
    name = "List-MoreUtils-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPARSEVAL/List-MoreUtils-0.22.tar.gz;
      sha256 = "1dv21xclh6r1cyy19r34xv2w6pc1jb5pwj7b2739m78xhlk8p55l";
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

  LWP = buildPerlPackage rec {
    name = "libwww-perl-5.825";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1wb7br1n86571xz19l20cc5ysy1lx3rhvlk02g5517919z3jxvhw";
    };
    propagatedBuildInputs = [URI HTMLParser HTMLTagset];
  };

  maatkit = import ../development/perl-modules/maatkit {
    inherit fetchurl buildPerlPackage stdenv DBDmysql;
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

  MIMETypes = buildPerlPackage rec {
    name = "MIME-Types-1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1zhzyb85zbil2jwrh74rg3bnm9wl74fcg2s64y8b57bk04fdfb7l";
    };
    propagatedBuildInputs = [TestPod];
  };

  ModuleBuild = buildPerlPackage {
    name = "Module-Build-0.2808";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Module-Build-0.2808.tar.gz;
      sha256 = "1h8zpf4g2n8v47l9apmdqbdgcg039g70w75hpn84m37pmqkbnj8v";
    };
    propagatedBuildInputs = [ExtUtilsInstall ExtUtilsManifest TestHarness];
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.06.tar.gz;
      sha256 = "1394jk0rn2zmchpl11kim69xh5h5yzg96jdlf76fqrk3dcn0y2ip";
    };
  };

  Moose = buildPerlPackage rec {
    name = "Moose-0.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1fim2kg6hcawbhn26sm1dq0q8ikmq0qwngd3wys7h0n9vs5hqdkb";
    };
    propagatedBuildInputs = [
      TestMore TestException TaskWeaken ListMoreUtils
      ClassMOP SubExporter
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

  MooseXEmulateClassAccessorFast = buildPerlPackage rec {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1sxkhyi44h30ba5ca7fmjpwc2pjwqm2n7ll67dn02dzgh68zaha7";
    };
    propagatedBuildInputs = [Moose NamespaceClean];
  };

  MooseXMethodAttributes = buildPerlPackage rec {
    name = "MooseX-MethodAttributes-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1cfpslsn7kqcbi6rvb5095ba8f4qdjb2bksxdbalpr4yf88hrc5n";
    };
    propagatedBuildInputs = [Moose MooseXTypes TestException];
  };
  
  MooseXParamsValidate = buildPerlPackage rec {
    name = "MooseX-Params-Validate-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "16mjxa72gn41pvrk0fgyi98iw6yc7qafnbzr6v2xfiabp9wf5j5m";
    };
    propagatedBuildInputs = [Moose ParamsValidate SubExporter TestException];
  };
  
  MooseXSemiAffordanceAccessor = buildPerlPackage rec {
    name = "MooseX-SemiAffordanceAccessor-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "073lq5dlwqxbrdzsn5ragjvwgpsfwcdls83n513kscgcq56y7014";
    };
    propagatedBuildInputs = [Moose];
  };
  
  MooseXTraits = buildPerlPackage rec {
    name = "MooseX-Traits-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1iqp4xyyz8v8668v3v1nqf35pi30xvysyjq1d2hz9i7nh2zbvlwf";
    };
    propagatedBuildInputs = [
      ClassMOP Moose TestException TestUseOk
    ];
  };
  
  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1cgkjcfx87kkrfg814fgfwl19cjqwx8wn40308z5p135vlbcbins";
    };
    propagatedBuildInputs = [
      Moose TestException NamespaceAutoclean ClassMOP TestUseOk
      MooseXTraits MooseAutobox
    ];
  };
  
  MooseXTypes = buildPerlPackage rec {
    name = "MooseX-Types-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0b7w9wyh44qqjipw0gy5xsvdb5hwaqjk3vbqiwq07aliwnlfgi9a";
    };
    propagatedBuildInputs = [Moose CarpClan NamespaceClean];
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
    name = "MRO-Compat-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BL/BLBLACK/MRO-Compat-0.09.tar.gz;
      sha256 = "16l37bxd5apax4kyvnadiplz8xmmx76y9pyq9iksqrv0d5rl5vl8";
    };
  };

  NamespaceAutoclean = buildPerlPackage rec {
    name = "namespace-autoclean-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1276incn27dpz955yx44l7rqs27bp1nc4gzqvw1x4aif8kw91185";
    };
    propagatedBuildInputs = [BHooksEndOfScope ClassMOP NamespaceClean];
  };

  NamespaceClean = buildPerlPackage rec {
    name = "namespace-clean-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "00fpj8a5p9z577cha3cgb95r042v7kbz7pwls5p0rl7jqvpax4lb";
    };
    propagatedBuildInputs = [BHooksEndOfScope];
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

  NetIP = buildPerlPackage {
    name = "Net-IP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.25.tar.gz;
      sha256 = "1iv0ka6d8kp9iana6zn51sxbcmz2h3mbn6cd8pald36q5whf5mjc";
    };
  };

  NetServer = buildPerlPackage rec {
    name = "Net-Server-0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "13vhv13w06g6h6iqx440q1h6hwj0kpjdxcc3fl9crkwg5glygg2f";
    };
    doCheck = false; # seems to hang waiting for connections
  };

  NetTwitterLite = buildPerlPackage {
    name = "Net-Twitter-Lite-0.08003";

    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.08003.tar.gz;
      sha256 = "11p8w650cpfplwcrnk3qrz3l5235i37dwgrji8xpgccix4vsrfpl";
    };

    propagatedBuildInputs = [JSONAny Encode LWP];
  };

  ObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.05.tar.gz;
      sha256 = "10k9j18jpb16brv0hs7592r7hx877290pafb8gnk6ydy7hcq9r2j";
    };
  };

  ParamsUtil = buildPerlPackage rec {
    name = "Params-Util-0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1n36vhahbs2mfck5x6g8ab9280zji9zwc5092jiq78s791227cb6";
    };
  };

  ParamsValidate = buildPerlPackage rec {
    name = "Params-Validate-0.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1j0hx3pbfdyggbhrawa9k0wdm6lln3zdkrhjrdg1hzzf6csrlc1v";
    };
  };

  Parent = buildPerlPackage {
    name = "parent-0.221";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.221.tar.gz;
      sha256 = "17jhscpa5p5szh1173pd6wvh2m05an1l941zqq9jkw9bzgk12hm0";
    };
  };

  ParseRecDescent = buildPerlPackage {
    name = "ParseRecDescent-1.96.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Parse-RecDescent-1.96.0.tar.gz;
      sha256 = "1hnsnpzdwcwpbnsspaz55gx7x7h1rpxdk7k1ninnqk1jximl3y9n";
    };
  };

  PathClass = buildPerlPackage {
    name = "Path-Class-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.16.tar.gz;
      sha256 = "0zisxkj58jm84fwcssmdq8g6n37s33v5h7j28m12sbkqib0h76gc";
    };
  };

  Perl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
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

  Readonly = buildPerlPackage rec {
    name = "Readonly-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "1shkyxajh6l87nif47ygnfxjwvqf3d3kjpdvxaff4957vqanii2k";
    };
  };

  RegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "173dnzi3dag88afr4xf5v0hki15cfaffyjimjfmvzv6gbx6fp96f";
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

  ReturnValue = buildPerlPackage {
    name = "Return-Value-1.302";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.302.tar.gz;
      sha256 = "0hf5rmfap49jh8dnggdpvapy5r4awgx5hdc3acc9ff0vfqav8azm";
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
    name = "Scope-Upper-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "1qaf310wbfpjb0lmg3fpmhbfnjxqw3j47rj0w0f0cy4bgihi8l43";
    };
  };

  SetObject = buildPerlPackage {
    name = "Set-Object-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMV/Set-Object-1.26.tar.gz;
      sha256 = "1hx3wrw8xkvaggacc8zyn86hfi3079ahmia1n8vsw7dglp1bbhmj";
    };
  };

  SQLAbstract = buildPerlPackage rec {
    name = "SQL-Abstract-1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "0m9xjp5wiknpibvpav7jf72g3v3x7rpqsdqpnqnma6bws6ci66gf";
    };
    propagatedBuildInputs = [
      TestDeep TestException TestWarn Clone
    ];
  };

  SQLAbstractLimit = buildPerlPackage rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs = [
      SQLAbstract TestException DBI TestDeep
    ];
    buildInputs = [TestPod TestPodCoverage];
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

  SubName = buildPerlPackage {
    name = "Sub-Name-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XM/XMATH/Sub-Name-0.04.tar.gz;
      sha256 = "1nlin0ag2krpmiyapp3lzb6qw2yfqvqmx57iz5zwbhr4pyi46bhb";
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

  TestDeep = buildPerlPackage {
    name = "Test-Deep-0.103";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Deep-0.103.tar.gz;
      sha256 = "0cdl08k5v0wc9w20va5qw98ynlbs9ifwndgsix8qhi7h15sj8a5j";
    };
    propagatedBuildInputs = [TestTester TestNoWarnings];
  };

  TestException = buildPerlPackage {
    name = "Test-Exception-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADIE/Test-Exception-0.27.tar.gz;
      sha256 = "1s921j7yv2szywd1ffi6yz3ngrbq97f9dh38bvvajqnm29g1xb9j";
    };
    propagatedBuildInputs = [TestHarness TestSimple SubUplevel];
  };

  TestHarness = buildPerlPackage rec {
    name = "Test-Harness-3.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "0j390xx6an88gh49n7zz8mj1s3z0xsxc8dynfq71xf7ba7i1afhr";
    };
  };

  TestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "0ln3117nfxzq7yxmfk77nnr7116inbjq4bf5v2p0hqlj4damx03d";
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

  TestSimple = buildPerlPackage rec {
    name = "Test-Simple-0.94";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1sdf9azxdbswbmzxasdp38mi1sznjc2g2ywi5ymbr6dcb3vs94vg";
    };
    propagatedBuildInputs = [TestHarness];
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
    name = "Test-Warn-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/${name}.zip";
      sha256 = "0kc09lgl8irx01m276zndl7rsi0dhpkzdc5i1zm077pcj2z9ccmg";
    };
    propagatedBuildInputs = [TestSimple TestException ArrayCompare TreeDAGNode];
    buildInputs = [TestPod pkgs.unzip];
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
    name = "Test-WWW-Mechanize-Catalyst-0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "0hixz0hibv2z87kdqvrphzgww0xibgg56w7bh299dgw2739hy4yf";
    };
    propagatedBuildInputs = [
      CatalystRuntime TestWWWMechanize WWWMechanize
      CatalystPluginSessionStateCookie
    ];
    buildInputs = [TestPod];
    doCheck = false;
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

  TextMarkdown = buildPerlPackage rec {
    name = "Text-Markdown-1.0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1ch8018yhn8mz38k0mrv5iljji1qqby2gfnvhvcm2vp65pjq2zdn";
    };
    buildInputs = [ FileSlurp ListMoreUtils Encode
      ExtUtilsMakeMaker TestException ];
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

  TieIxhash = buildPerlPackage rec {
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

  TimeHiRes = buildPerlPackage {
    name = "Time-HiRes-1.9715";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHI/Time-HiRes-1.9715.tar.gz;
      sha256 = "0pgqrfkysy3mdcx5nd0x8c80lgqb7rkb3nrkii3vc576dcbpvw0i";
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

  FontTTF = buildPerlPackage {
    name = "perl-Font-TTF-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHOSKEN/Font-TTF-0.43.tar.gz;
      sha256 = "0782mj5n5a2qbghvvr20x51llizly6q5smak98kzhgq9a7q3fg89";
    };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.12.tar.gz;
      sha256 = "1abadbgcy11cmlmj9qf1v73ycic1qhysxv5xx81h8s4p81alialr";
    };
  };

  UNIVERSALisa = stdenv.mkDerivation rec {
    name = "UNIVERSAL-isa-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "0iksklmfhiaxg2rsw827n97k1mris6dg596rdwk2gmrwl0rsk0wz";
    };
    # Urgh, this package doesn't have a Makefile.PL.
    buildInputs = [perl];
    configurePhase = "perl Build.PL --prefix=$out";
    buildPhase = "perl ./Build";
    doCheck = true;
    checkPhase = "perl ./Build test";
    installPhase = "perl ./Build install";
  };

  UNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/UNIVERSAL-require-0.11.tar.gz;
      sha256 = "1rh7i3gva4m96m31g6yfhlqcabszhghbb3k3qwxbgx3mkf5s6x6i";
    };
  };

  URI = buildPerlPackage rec {
    name = "URI-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "0gfdphz0yhm62vn9cbw720i6pm1gingcir15dq8ppbnk6cylnyal";
    };
  };

  VariableMagic = buildPerlPackage rec {
    name = "Variable-Magic-0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "15305b54e948f74a0cf77c1c6bd8aa399caac12d6b1dee8cc4a69ff7d1421db6";
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

  XMLLibXML = buildPerlPackage {
    name = "XML-LibXML-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PA/PAJAS/XML-LibXML-1.66.tar.gz;
      sha256 = "1a0bdiv3px6igxnbbjq10064iahm8f5i310p4y05w6zn5d51awyl";
    };
    buildInputs = [pkgs.libxml2];
    propagatedBuildInputs = [XMLLibXMLCommon XMLSAX];
  };

  XMLLibXMLCommon = buildPerlPackage {
    name = "XML-LibXML-Common-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHISH/XML-LibXML-Common-0.13.tar.gz;
      md5 = "13b6d93f53375d15fd11922216249659";
    };
    buildInputs = [pkgs.libxml2];
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

  XMLWriter = buildPerlPackage {
    name = "XML-Writer-0.602";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOSEPHW/XML-Writer-0.602.tar.gz;
      sha256 = "0kdi022jcn9mwqsxy2fiwl2cjlid4x13r038jvi426fhjknl11nl";
    };
  };

  XSLoader = buildPerlPackage {
    name = "XSLoader-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.08.tar.gz;
      sha256 = "0mr4l3givrpyvz1kg0kap2ds8g0rza2cim9kbnjy8hi64igkixi5";
    };
  };

  YAML = buildPerlPackage rec {
    name = "YAML-0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0yg0pgsjkfczsblx03rxlw4ib92k0gwdyb1a258xb9wdg0w61h34";
    };
  };

  YAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "15acwp2qdxfmhfqj4c1s57xyy48hcfc87lblww3lbvihqbysyzss";
    };
  };

}
