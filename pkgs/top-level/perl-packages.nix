/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{pkgs}:

rec {

  inherit (pkgs) buildPerlPackage fetchurl stdenv perl;

  perlAlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [perlAlgorithmDiff];
  };

  perlAlgorithmDiff = buildPerlPackage rec {
    name = "Algorithm-Diff-1.1901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/${name}.zip";
      sha256 = "0qk60fi49mpyvnfpjd2dzcmya8x3g5zfgb2hrnl7a5krn045g6i2";
    };
    buildInputs = [pkgs.unzip];
  };

  perlAppCLI = buildPerlPackage {
    name = "App-CLI-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/App-CLI-0.07.tar.gz;
      sha256 = "000866qsm7jck3ini69b02sgbjwp6s297lsds002r7xk2wb6fqcz";
    };
    propagatedBuildInputs = [perlLocaleMaketextSimple];
  };

  perlAppConfig = buildPerlPackage {
    name = "AppConfig-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/AppConfig-1.66.tar.gz;
      sha256 = "1p1vs9px20lrq9mdwpzp309a8r6rchibsdmxang4krk90pi2sh4b";
    };
  };

  perlArrayCompare = buildPerlPackage {
    name = "Array-Compare-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-1.16.tar.gz;
      sha256 = "1iwkn7d07a7vgl3jrv4f0glwapxcbdwwsy3aa6apgwam9119hl7q";
    };
  };

  perlArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.16";
    src = fetchurl {
      url = http://nixos.org/tarballs/Archive-Zip-1.16.tar.gz;
      md5 = "e28dff400d07b1659d659d8dde7071f1";
    };
  };

  perlBerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl;
    inherit (pkgs) db4;
  };

  perlBitVector = buildPerlPackage {
    name = "Bit-Vector-6.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-6.4.tar.gz;
      sha256 = "146vr78r6w3cxrm0ji491ylaa1abqh7fs81qhg15g3gzzxfg33bp";
    };
    propagatedBuildInputs = [perlCarpClan];
  };

  perlBoolean = buildPerlPackage rec {
    name = "boolean-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "1xqhzy3m2r08my13alff9bzl8b6xgd68312834x0hf33yir3l1yn";
    };
  };

  perlCacheFastMmap = buildPerlPackage {
    name = "Cache-FastMmap-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.28.tar.gz;
      sha256 = "1m851bz5025wy24mzsi1i8hdyg8bm7lszx9rnn47llsv6hb9v0da";
    };
  };

  perlCaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1fm0fvdy9b7z8k1cyah2qbj0gqlv01chxmqmashwj16198yr7vrc";
    };
    propagatedBuildInputs = [perlHTMLTiny perlLWP];
    buildInputs = [perlTestPod];
  };

  perlCarpAssert = buildPerlPackage rec {
    name = "Carp-Assert-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1wzy4lswvwi45ybsm65zlq17rrqx84lsd7rajvd0jvd5af5lmlqd";
    };
  };

  perlCarpAssertMore = buildPerlPackage rec {
    name = "Carp-Assert-More-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1m9k6z0m10s03x2hnc9mh5d4r8lnczm9bqd54jmnw0wzm4m33lyr";
    };
    propagatedBuildInputs = [perlTestException perlCarpAssert];
  };

  perlCarpClan = buildPerlPackage {
    name = "Carp-Clan-6.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJORE/Carp-Clan-6.00.tar.gz;
      sha256 = "0lbin4i0vzagcwkywpd5x4gz3a4ira4yn5g5v1ip0pbpyqnjk15h";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlCatalystActionRenderView = buildPerlPackage rec {
    name = "Catalyst-Action-RenderView-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "06bxbdfjgnwp8zz4mqq2x7n5ng02h94m27l610icsps7r9iwi8f9";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlHTTPRequestAsCGI perlDataVisitor];
  };

  perlCatalystAuthenticationStoreDBIxClass = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYK/${name}.tar.gz";
      sha256 = "1rh5jwqw3fb16ll5id8z0igpqdwr0czi0xbaa2igalxr53hh2cni";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginAuthentication perlCatalystModelDBICSchema
    ];
  };

  perlCatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "0wfj4vnn2cvk6jh62amwlg050p37fcwdgrn9amcz24z6w4qgjqvz";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlMoose];
  };

  perlCatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "1vrd79d0nbqkana5q483fgsr41idlfgjhf7fpd3hc056z5nq8iyn";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystActionRenderView perlCatalystViewTT
      perlCatalystPluginConfigLoader perlConfigGeneral
      perlCatalystComponentInstancePerContext perlMoose
      perlRegexpAssemble perlTestWWWMechanize
      perlTestWWWMechanizeCatalyst perlHTMLFormFu
    ];
  };

  perlCatalystDevel = buildPerlPackage rec {
    name = "Catalyst-Devel-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "19ylkx55gaq9xxxcl4a55284in7hdrr2sb6lqz64daq3xp29n73h";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystActionRenderView
      perlCatalystPluginStaticSimple perlCatalystPluginConfigLoader
      perlPathClass perlTemplateToolkit perlClassAccessor
      perlConfigGeneral perlFileCopyRecursive perlParent
    ];
  };

  perlCatalystEngineHTTPPrefork = buildPerlPackage rec {
    name = "Catalyst-Engine-HTTP-Prefork-0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "1p8mnxqaxd6sxyy9q4f0h5gy4mcnvb3y93y49ziq6kmcvy6yw2p7";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlHTTPBody perlNetServer
      perlCookieXS perlHTTPHeaderParserXS
    ];
    buildInputs = [perlTestPod perlTestPodCoverage];
    patches = [
      # Fix chunked transfers (they were missing the final CR/LF at
      # the end, which makes curl barf).
      ../development/perl-modules/catalyst-fix-chunked-encoding.patch
    ];
  };

  perlCatalystManual = buildPerlPackage rec {
    name = "Catalyst-Manual-5.7016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/${name}.tar.gz";
      sha256 = "0axin80dca3xb0n7frn9w8lj43l7dykpwrf7jj44n1v1kyzw813f";
    };
    buildInputs = [perlTestPod perlTestPodCoverage];
  };

  perlCatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Catalyst-Model-DBIC-Schema-0.23.tar.gz;
      sha256 = "1rzs4czrwr8pnrj0mvfpzc8i2cbw95rx2xirw9bhqs77z2722ym4";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystDevel perlDBIxClass
      perlUNIVERSALrequire perlClassDataAccessor
      perlDBIxClassSchemaLoader
    ];
  };

  perlCatalystRuntime = buildPerlPackage rec{
    name = "Catalyst-Runtime-5.71001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "1j3xsh7zi5xd8zdc63r83mwzhjfj30vhd39kgir53mq47v0y07jr";
    };
    propagatedBuildInputs = [
      perlLWP perlClassAccessor perlClassDataInheritable perlClassInspector
      perlCGISimple perlDataDump perlFileModified perlHTTPBody perlHTTPRequestAsCGI
      perlPathClass perlTextSimpleTable perlTreeSimple perlTreeSimpleVisitorFactory
      perlSubExporter perlMROCompat perlTestMockObject perlClassMOP perlMoose
      perlNamespaceClean perlScopeUpper perlMooseXEmulateClassAccessorFast
      perlClassC3 perlClassC3AdoptNEXT
    ];
  };

  perlCatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1jjdmyccsq0k8ysl9ppm7rddf6w4l2yhwjr60c0x4lp5iafzmf4z";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlCatalystPluginSession];
  };

  perlCatalystPluginAuthorizationACL = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-ACL-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Catalyst-Plugin-Authorization-ACL-0.10.tar.gz;
      sha256 = "1y9pj0scpc4nd7m1xqy7yvjsffhfadzl0z5r4jjv2srndcv4xj1p";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlClassThrowable];
  };

  perlCatalystPluginAuthorizationRoles = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-Roles-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Catalyst-Plugin-Authorization-Roles-0.07.tar.gz;
      sha256 = "07b8zc7b06p0fprjj68fk7rgh781r9s3q8dx045sk03w0fnk3b4b";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginAuthentication
      perlTestException perlSetObject perlUNIVERSALisa
    ];
  };

  perlCatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICAS/${name}.tar.gz";
      sha256 = "13ir2l0pvjn4myp7wfh2bxcdd4hp0b3ln28mz1kvlshhxl032lqn";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlDataVisitor perlConfigAny perlMROCompat];
  };

  perlCatalystPluginHTMLWidget = buildPerlPackage {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Catalyst-Plugin-HTML-Widget-1.1.tar.gz;
      sha256 = "1zzyfhmzlqvbwk2w930k3mqk8z1lzhrja9ynx9yfq5gmc8qqg95l";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlHTMLWidget];
  };

  perlCatalystPluginSession = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1p72hf68qi038gayhsxbbx3l3hg7b1njjii510alxqyw3a10y9sj";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTestMockObject perlObjectSignature
      perlTestDeep perlMROCompat
    ];
  };

  perlCatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1630shg23cpk6v26fwf7xr53ml1s6l2mgirxw524nmciliczgldj";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginSession perlTestMockObject
    ];
  };

  perlCatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KARMAN/${name}.tar.gz";
      sha256 = "0by8w1zbp2802f9n3sqp0cmm2q0pwnycf0jgzvvv75riicq1m9pn";
    };
    propagatedBuildInputs = [
      perlPathClass perlCatalystPluginSession perlCacheFastMmap
    ];
  };

  perlCatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Catalyst-Plugin-StackTrace-0.09.tar.gz;
      sha256 = "1pywxjhvn5zmcpnxj9ba77pz1jxq4d037yd43y0ks9sc31p01ydh";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlDevelStackTrace];
  };

  perlCatalystPluginStaticSimple = buildPerlPackage {
    name = "Catalyst-Plugin-Static-Simple-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AG/AGRUNDMA/Catalyst-Plugin-Static-Simple-0.20.tar.gz;
      sha256 = "1qpicgfha81ykxzg4kjll2qw8b1rwzdgvj4s3q9s20zl86gmfr3p";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlMIMETypes];
  };

  perlCatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/${name}.tar.gz";
      sha256 = "1d5ck28db6vbks7cwkj1qh0glhxskl3vymksv3izfzbk6xnjrabi";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTestWWWMechanizeCatalyst perlTestUseOk
      perlTextCSV
    ];
  };

  perlCatalystViewTT = buildPerlPackage rec {
    name = "Catalyst-View-TT-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "18chdzgv0fvq65kfp8am2f5cayxpzg355q7jin4xlzygbgh2a5vg";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTemplateToolkit perlClassAccessor
      perlPathClass perlTemplateTimer
    ];
  };

  perlCGICookieXS = buildPerlPackage rec {
    name = "CGI-Cookie-XS-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1jrd3f11sz17117nvssrrf6r80fr412615n5ffspbsap4n816bnn";
    };
  };

  perlCGISession = buildPerlPackage {
    name = "CGI-Session-3.95";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHERZODR/CGI-Session-3.95.tar.gz;
      md5 = "fe9e46496c7c711c54ca13209ded500b";
    };
  };

  perlCGISimple = buildPerlPackage {
    name = "CGI-Simple-1.106";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/CGI-Simple-1.106.tar.gz;
      sha256 = "0r0wc2260jnnch7dv7f6ailjf5w8hpqm2w146flfcchcryfxjlpg";
    };
  };

  perlClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.31.tar.gz;
      sha256 = "1a4v5qqdf9bipd6ba5n47mag0cmgwp97cid67i510aw96bcjrsiy";
    };
  };

  perlClassAccessorChained = buildPerlPackage {
    name = "Class-Accessor-Chained-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz;
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [perlClassAccessor];
  };

  perlClassAccessorGrouped = buildPerlPackage rec {
    name = "Class-Accessor-Grouped-0.08003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLACO/${name}.tar.gz";
      sha256 = "0lvxj8fp79338p52ich0p7hi4gvvf572ks76g9kgkgfyqvmp732k";
    };
    propagatedBuildInputs = [perlClassInspector perlMROCompat];
  };

  perlClassAutouse = buildPerlPackage {
    name = "Class-Autouse-1.99_02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-1.99_02.tar.gz;
      sha256 = "1jkhczx2flxrz154ps90fj9wcchkpmnp5sapwc0l92rpn7jpsf08";
    };
  };

  perlClassC3 = buildPerlPackage rec {
    name = "Class-C3-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1bl8z095y4js66pwxnm7s853pi9czala4sqc743fdlnk27kq94gz";
    };
  };

  perlClassC3AdoptNEXT = buildPerlPackage rec {
    name = "Class-C3-Adopt-NEXT-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1kxbdq10vicrbz3i6hvml3mma5x0r523gfdd649f9bvrsizb0jxj";
    };
    propagatedBuildInputs = [perlMROCompat perlTestException perlListMoreUtils];
  };

  perlClassC3Componentised = buildPerlPackage rec {
    name = "Class-C3-Componentised-1.0004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASH/${name}.tar.gz";
      sha256 = "0xql73jkcdbq4q9m0b0rnca6nrlvf5hyzy8is0crdk65bynvs8q1";
    };
    propagatedBuildInputs = [
      perlClassC3 perlClassInspector perlTestException perlMROCompat
    ];
  };

  perlClassDataAccessor = buildPerlPackage {
    name = "Class-Data-Accessor-0.04004";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz;
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  perlClassDataInheritable = buildPerlPackage {
    name = "Class-Data-Inheritable-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz;
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  perlClassFactoryUtil = buildPerlPackage rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
  };

  perlClassInspector = buildPerlPackage {
    name = "Class-Inspector-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Inspector-1.23.tar.gz;
      sha256 = "0d15b5wls14gqcd6v2k4kbc0v0a1qfb794h49wfc4vwjk5gnpbw1";
    };
  };

  perlClassMOP = buildPerlPackage rec {
    name = "Class-MOP-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1fmimzzbfkw7vrr57p8xa3y9v55i72bknix2qk3cdrn0jmg6h648";
    };
    propagatedBuildInputs = [
      perlMROCompat perlTaskWeaken perlTestException perlSubName perlSubIdentify
      perlDevelGlobalDestruction
    ];
  };

  perlClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "0l4iwwk91wm2mrrh4irrn6ham9k12iah1ry33k0lzq22r3kwdbyg";
    };
  };

  perlClassThrowable = buildPerlPackage {
    name = "Class-Throwable-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Class-Throwable-0.10.tar.gz;
      sha256 = "01hjrfb951c9j83ncg5drnam8vsfdgkjjv0kjshxhkl93sgnlvdl";
    };
  };

  perlClassUnload = buildPerlPackage {
    name = "Class-Unload-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.05.tar.gz;
      sha256 = "01b0j10nxbz37xnnzw3hgmpfgq09mc489kq2d8f5nswsrlk75001";
    };
    propagatedBuildInputs = [perlClassInspector];
  };

  perlCompressRawBzip2 = import ../development/perl-modules/Compress-Raw-Bzip2 {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) bzip2;
  };

  perlCompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) zlib;
  };

  perlCompressZlib = buildPerlPackage rec {
    name = "Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "1k1i539fszhxay8yllh687sw06i68g8ikw51pvy1c84p3kg6yk4v";
    };
    propagatedBuildInputs = [
      perlCompressRawZlib perlIOCompressBase perlIOCompressGzip
    ];
  };

  perlConfigAny = buildPerlPackage {
    name = "Config-Any-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Config-Any-0.14.tar.gz;
      sha256 = "1vlr4w2m88figac5pblg6ppzrm11x2pm7r05n48s84cp4mizhim1";
    };
  };

  perlConfigGeneral = buildPerlPackage {
    name = "Config-General-2.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.40.tar.gz;
      sha256 = "0wf6dpaanaiy0490dlgs3pi3xvvijs237x9izb00cnzggxcfmsnz";
    };
  };

  perlconstant = buildPerlPackage {
    name = "constant-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/constant-1.15.tar.gz;
      sha256 = "1ygz0hd1fd3q88r6dlw14kpyh06zjprksdci7qva6skxz3261636";
    };
  };

  perlCookieXS = buildPerlPackage rec {
    name = "Cookie-XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    propagatedBuildInputs = [
      perlTestMore perlCGICookieXS
    ];
  };

  perlCryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0cvigpxvwn18kb5i40jlp5fgijbhncvlh23xdgs1cnhxa17yrgwx";
    };
  };

  perlCryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1w12k1b7868v3ql0yprswlz2qri6ja576k9wlda7b8zf2d0rxgmp";
    };
    buildInputs = [perlCryptCBC];
  };

  perlCryptPasswordMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LU/LUISMUNOZ/Crypt-PasswdMD5-1.3.tar.gz;
      sha256 = "13j0v6ihgx80q8jhyas4k48b64gnzf202qajyn097vj8v48khk54";
    };
  };

  perlCryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "1f0i5y99ly39vf86jpzwqz8mkz1460vryv85jgqmfx007p781s0l";
    };
    makeMakerFlags = "--lib=${pkgs.openssl}/lib";
  };

  perlDataDump = buildPerlPackage {
    name = "Data-Dump-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.11.tar.gz;
      sha256 = "0h5y40b6drgsf87nhwhqx1dprq70f98ibm03l9al4ndq7mrx97dd";
    };
  };

  perlDataHierarchy = buildPerlPackage {
    name = "Data-Hierarchy-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz;
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlDataOptList = buildPerlPackage rec {
    name = "Data-OptList-0.104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1k1qvf3ik2rn9mg65ginv3lyy6dlg1z08yddcnzbnizs8vbqqaxd";
    };
    propagatedBuildInputs = [perlSubInstall perlParamsUtil];
  };

  perlDataPage = buildPerlPackage {
    name = "Data-Page-2.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.01.tar.gz;
      sha256 = "0mvhlid9qx9yd94rgr4lfz9kvflimc1dzcah0x7q5disw39aqrzr";
    };
    propagatedBuildInputs = [perlTestException perlClassAccessorChained];
  };

  perlDataVisitor = buildPerlPackage {
    name = "Data-Visitor-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Data-Visitor-0.21.tar.gz;
      sha256 = "10cjh3rrqi4gwrmkpzilzmaqdrh71wr59035s6b4p2dzd117p931";
    };
    propagatedBuildInputs = [
      perlTestMockObject perlMouse perlTaskWeaken perlTestUseOk perlTieToObject
      perlNamespaceClean
    ];
  };

  perlDateCalc = buildPerlPackage {
    name = "Date-Calc-5.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-5.4.tar.gz;
      sha256 = "1q7d1sy9ka1akpbysgwj673i7wiwb48yjv6wx1v5dhxllyxlxqc8";
    };
    propagatedBuildInputs = [perlCarpClan perlBitVector];
  };

  perlDateManip = buildPerlPackage {
    name = "DateManip-5.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-5.54.tar.gz;
      sha256 = "0ap2jgqx7yvjsyph9zsvadsih41cj991j3jwgz5261sq7q74y7xn";
    };
  };

  perlDateTime = buildPerlPackage rec {
    name = "DateTime-0.4501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1hqhc4xfjgcc1r488gjbi498ws3pxiayabl46607lq02qddcv57s";
    };
    propagatedBuildInputs = [perlDateTimeLocale perlDateTimeTimeZone];
  };

  perlDateTimeFormatBuilder = buildPerlPackage rec {
    name = "DateTime-Format-Builder-0.7901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "08zl89gh5lkff8736fkdnrf6dgppsjbmymnysbc06s7igd4ig8zf";
    };
    propagatedBuildInputs = [
      perlDateTime perlParamsValidate perlTaskWeaken perlDateTimeFormatStrptime
      perlClassFactoryUtil
    ];
    buildInputs = [perlTestPod];
  };

  perlDateTimeFormatNatural = buildPerlPackage rec {
    name = "DateTime-Format-Natural-0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHUBIGER/${name}.tar.gz";
      sha256 = "0hq33s5frfa8cpj2al7qi0sbmimm5sdlxf0h3b57fjm9x5arlkcn";
    };
    propagatedBuildInputs = [
      perlDateTime perlListMoreUtils perlParamsValidate perlDateCalc
      perlTestMockTime perlBoolean
    ];
  };

  perlDateTimeFormatStrptime = buildPerlPackage rec {
    name = "DateTime-Format-Strptime-1.0800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RICKM/${name}.tgz";
      sha256 = "10vsmwlhnc62krsh5fm2i0ya7bgjgjsm6nmj56f0bfifjh57ya1j";
    };
    propagatedBuildInputs = [
      perlDateTime perlDateTimeLocale perlDateTimeTimeZone perlParamsValidate
    ];
  };

  perlDateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1cvp9a4j6vy3xpbv6ipzcz1paw7gzal7lkrbm5ipiilji47d5gaw";
    };
    propagatedBuildInputs = [perlListMoreUtils perlParamsValidate];
  };

  perlDateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-0.84";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0jwbldr3x1cl2ibd9dcshdmpg6s5ddc4qiaxcxyqc82cq09ah2vs";
    };
    propagatedBuildInputs = [perlClassSingleton perlParamsValidate];
  };

  perlDBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit fetchurl buildPerlPackage perlDBI;
    inherit (pkgs) sqlite;
  };

  perlDBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db4;
  };

  perlDBI = buildPerlPackage {
    name = "DBI-1.607";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/DBI-1.607.tar.gz;
      sha256 = "053ysk2a4njhzq5p59v5s6jzyi0yqr8l6wkswbvy4fyil3ka343h";
    };
  };

  perlDBIxClass = buildPerlPackage rec {
    name = "DBIx-Class-0.08099_08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "12kn3jylxi7n2c6ccqyrjaxxmk3lajvjv19j6rlifp4crn24cbpy";
    };
    propagatedBuildInputs = [
      perlTestNoWarnings perlTestException perlDBI perlScopeGuard
      perlPathClass perlClassInspector perlClassAccessorGrouped
      perlCarpClan perlTestWarn perlDataPage perlSQLAbstract
      perlSQLAbstractLimit perlClassC3 perlClassC3Componentised
      perlModuleFind perlDBDSQLite perlJSONAny perlSubName
    ];
    buildInputs = [perlTestPod perlTestPodCoverage];
  };

  perlDBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [perlDBIxClass perlHTMLWidget];
  };

  perlDBIxClassSchemaLoader = buildPerlPackage rec {
    name = "DBIx-Class-Schema-Loader-0.04999_06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "169ydwjarq6qk48jdxcn5ks8rx9aksk9fnx07gl5mz7banw5cs6y";
    };
    propagatedBuildInputs = [
      perlDBI perlDBDSQLite perlDataDump perlUNIVERSALrequire
      perlClassAccessor perlClassDataAccessor perlClassC3 perlCarpClan
      perlClassInspector perlDBIxClass perlLinguaENInflectNumber
      perlClassUnload
    ];
    doCheck = false; # disabled for now, since some tests fail
  };

  perlDevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/${name}.tar.gz";
      sha256 = "174m5dx2z89h4308gx6s6vmg93qzaq0bh9m91hp2vqbyialnarhw";
    };
    propagatedBuildInputs = [perlSubExporter perlScopeGuard];
  };

  perlDevelStackTrace = buildPerlPackage rec {
    name = "Devel-StackTrace-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "15zh9gzhw6gv7l6sklp02pfmiiv8kwmmjsyvirppsca6aagy4603";
    };
  };

  perlDevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "0qzj68zw1yypk8jw77h0w5sdpdcrp4xcmgfghcfyddjr2aim60x5";
    };
    propagatedBuildInputs = [
      perlTestPod /* cyclic dependency: perlTestPodCoverage */
    ];
  };

  perlDigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.01.tar.gz;
      sha256 = "042d6nknc5icxqsy5asrh8v2shmvg7b3vbj95jyk4sbqlqpacwz3";
    };
    propagatedBuildInputs = [perlDigestSHA1];
  };

  perlDigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.11.tar.gz;
      md5 = "2449bfe21d6589c96eebf94dae24df6b";
    };
  };

  perlEmailAddress = buildPerlPackage {
    name = "Email-Address-1.888";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.888.tar.gz;
      sha256 = "0c6b8djnmiy0niskrvywd6867xd1qmn241ffdwj957dkqdakq9yx";
    };
  };

  perlEmailSend = buildPerlPackage {
    name = "Email-Send-2.185";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Send-2.185.tar.gz;
      sha256 = "0pbgnnbmv6z3zzqaiq1sdcv5d26ijhw4p8k8kp6ac7arvldblamz";
    };
    propagatedBuildInputs = [perlEmailSimple perlEmailAddress perlModulePluggable perlReturnValue];
  };

  perlEmailSimple = buildPerlPackage {
    name = "Email-Simple-2.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.003.tar.gz;
      sha256 = "0h8873pidhkqy7415s5sx8z614d0haxiknbjwrn65icrr2m0b8g6";
    };
  };

  perlEmailValid = buildPerlPackage {
    name = "Email-Valid-0.179";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-0.179.tar.gz;
      sha256 = "13yfjll63cp1y4xqzdcr1mjhfncn48v6hckk5mvwi47w3ccj934a";
    };
    propagatedBuildInputs = [perlMailTools perlNetDNS];
    doCheck = false;
  };

  perlEncode = buildPerlPackage {
    name = "Encode-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.25.tar.gz;
      sha256 = "0prwmbg3xh1lqskianwrfrgasdfmz4kjm3qpdm27ay110jkk25ak";
    };
  };

  perlExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-1.50";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YV/YVES/ExtUtils-Install-1.50.tar.gz;
      sha256 = "18fr056fwnnhvgc646crx2p9mybf69mh5rkcphc7bbvahw9i61jy";
    };
    propagatedBuildInputs = [perlExtUtilsMakeMaker];
  };

  perlExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-6.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/ExtUtils-MakeMaker-6.44.tar.gz;
      sha256 = "0zyypnlmmyp06qbfdpc14rp5rj63066mjammn6rlcqz2iil9mpcj";
    };
  };

  perlExtUtilsManifest = buildPerlPackage {
    name = "ExtUtils-Manifest-1.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKOBES/ExtUtils-Manifest-1.53.tar.gz;
      sha256 = "0xgfzivw0dfy29ydfjkg0c9mvlhjvlhc54s0yvbb4sxb2mdvrfkp";
    };
  };

  perlFilechdir = buildPerlPackage {
    name = "File-chdir-0.1002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-chdir-0.1002.tar.gz;
      sha256 = "1fc2l754bxsizli3injm4wqf8dn03iq16rmfn62l99nxpibl5k6p";
    };
  };

  perlFileCopyRecursive = buildPerlPackage {
    name = "File-Copy-Recursive-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.37.tar.gz;
      sha256 = "12j0s01zwm67g4bcgbs0k61jwz59q1lndrnxyywxsz3xd30ki8rr";
    };
  };

  perlFileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
    };
  };

  perlFileShareDir = buildPerlPackage rec {
    name = "File-ShareDir-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1afr1r1ys2ij8i4r0i85hfrgrbvcha8c7cgkhcrdya1f0lnpw59z";
    };
    propagatedBuildInputs = [perlClassInspector perlParamsUtil];
  };

  perlFileTemp = buildPerlPackage {
    name = "File-Temp-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJENNESS/File-Temp-0.20.tar.gz;
      sha256 = "0n7lr7mpdvwgznw469qdpdmac627a26wp615dkpzanc452skad4v";
    };
  };

  perlFreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.43.tar.gz;
      sha256 = "1qamc5aggp35xk590a4hy660f2rhc2l7j65hbyxdya9yvg7z437l";
    };
  };

  perlHTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "03lc4pvygp4wn9rsgdkbwk8zkh8x2z5vp8613c6q74imwrfmmfqy";
    };
    propagatedBuildInputs = [
      perlClassAccessorChained perlClassC3 perlConfigAny
      perlDateCalc perlListMoreUtils perlLWP perlEmailValid
      perlDataVisitor perlDateTime perlDateTimeFormatBuilder
      perlDateTimeFormatStrptime perlDateTimeFormatNatural
      perlReadonly perlYAMLSyck perlRegexpCopy
      perlHTMLTokeParserSimple perlTestNoWarnings perlRegexpCommon
      perlCaptchaReCAPTCHA perlHTMLScrubber perlFileShareDir
      perlTemplateToolkit perlCryptCBC perlCryptDES
    ];
  };

  perlHTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.56.tar.gz;
      sha256 = "0x1h42r54aq4yqpwi7mla4jzia9c5ysyqh8ir2nav833f9jm6g2h";
    };
    propagatedBuildInputs = [perlHTMLTagset];
  };

  perlHTMLScrubber = buildPerlPackage {
    name = "HTML-Scrubber-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/PODMASTER/HTML-Scrubber-0.08.tar.gz;
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [perlHTMLParser];
  };

  perlHTMLTagset = buildPerlPackage {
    name = "HTML-Tagset-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.10.tar.gz;
      sha256 = "05k292qy7jzjlmmybis8nncpnwwa4jfkm7q3gq6866ydxrzds9xh";
    };
  };

  perlHTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1nc9vr0z699jwv8jaxxpkfhspiv7glhdp500hqyzdm2jxfw8azrg";
    };
  };

  perlHTMLTokeParserSimple = buildPerlPackage rec {
    name = "HTML-TokeParser-Simple-3.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "0ii1ww17h7wps1lcj7bxrjbisa37f6cvlm0xxpgfq1s6iy06q05b";
    };
    propagatedBuildInputs = [perlHTMLParser perlSubOverride];
    buildInputs = [perlTestPod];
  };

  perlHTMLTree = buildPerlPackage {
    name = "HTML-Tree-3.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETEK/HTML-Tree-3.23.tar.gz;
      sha256 = "1pn80f4g1wixs030f40b80wrj12kwfinwycrx3f10drg4v7ml5zm";
    };
    propagatedBuildInputs = [perlHTMLParser];
  };

  perlHTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    propagatedBuildInputs = [
      perlTestNoWarnings perlClassAccessor perlClassAccessorChained
      perlClassDataAccessor perlModulePluggableFast perlHTMLTree
      perlHTMLScrubber perlEmailValid perlDateCalc
    ];
  };

  perlHTTPBody = buildPerlPackage rec {
    name = "HTTP-Body-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "0s0496sb9l8jfkdx86vahwgdaaxrqb0j6acyww6nk0ajh82qrzfv";
    };
    propagatedBuildInputs = [perlLWP perlYAML];
  };

  perlHTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  perlHTTPRequestAsCGI = buildPerlPackage {
    name = "HTTP-Request-AsCGI-0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHANSEN/HTTP-Request-AsCGI-0.5.tar.gz;
      sha256 = "164159iiyk0waqayplchkisxg2ldamx8iifrccx32p344714qcrh";
    };
    propagatedBuildInputs = [perlClassAccessor perlLWP];
  };

  perlHTTPResponseEncoding = buildPerlPackage rec {
    name = "HTTP-Response-Encoding-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/${name}.tar.gz";
      sha256 = "04gdl633g0s2ckn7zixcma2krbpfcd46jngg155qpdx5sdwfkm16";
    };
    propagatedBuildInputs = [perlLWP];
  };

  perlHTTPServerSimple = buildPerlPackage rec {
    name = "HTTP-Server-Simple-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/${name}.tar.gz";
      sha256 = "1m1lmpbg0zhiv2vyc3fyyqfsv3jhhb2mbdl5624fqb0va2pnla6n";
    };
    propagatedBuildInputs = [perlURI];
    doCheck = false;
  };

  perlI18NLangTags = buildPerlPackage {
    name = "I18N-LangTags-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/I18N-LangTags-0.35.tar.gz;
      sha256 = "0idwfi7k8l44d9akpdj6ygdz3q8zxr690m18s7w23ms9d55bh3jy";
    };
  };

  perlIOCompressBase = buildPerlPackage rec {
    name = "IO-Compress-Base-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "10njlwa50mhs5nqws5yidfmmb7hwmwc6x06gk2vnpyn82g3szgqd";
    };
  };

  perlIOCompressBzip2 = buildPerlPackage rec {
    name = "IO-Compress-Bzip2-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "1kfksf2bslfkviry228p07m1ksnf06mh8gkmdpbrmlmxlbs2idnc";
    };
    propagatedBuildInputs = [perlIOCompressBase perlCompressRawBzip2];
  };

  perlIOCompressGzip = buildPerlPackage rec {
    name = "IO-Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "0sbnx6xdryaajwpssrfgm5b2zasa4ri8pihqwsx3rm5kmkgzy9cx";
    };
    propagatedBuildInputs = [perlIOCompressBase perlCompressRawZlib];
  };

  perlIODigest = buildPerlPackage {
    name = "IO-Digest-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.10.tar.gz;
      sha256 = "1g6ilxqv2a7spf273v7k0721c6am7pwpjrin3h5zaqxfmd312nav";
    };
    propagatedBuildInputs = [perlPerlIOviadynamic];
  };

  perlIOPager = buildPerlPackage {
    name = "IO-Pager-0.06.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
    };
  };

  perlIPCRun = buildPerlPackage rec {
    name = "IPC-Run-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1v5yfavvhxscqkdl68xs7i7vcp9drl3y1iawppzwqcl1fprd58ip";
    };
    doCheck = false; /* attempts a network connection to localhost */
  };

  perlJSON = buildPerlPackage {
    name = "JSON-2.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.12.tar.gz;
      sha256 = "0qbxfwvfsx8s50h2dzpb0z7qi22k9ghygfzbfk8v08kkpmrkls47";
    };
    propagatedBuildInputs = [perlJSONXS];
  };

  perlJSONAny = buildPerlPackage {
    name = "JSON-Any-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/JSON-Any-1.17.tar.gz;
      sha256 = "07y6zb0vzb4c87k2lflxafb69zc4a29bxhzh6xdcpjhplf4vbifb";
    };
    propagatedBuildInputs = [perlJSON];
  };

  perlJSONXS = buildPerlPackage {
    name = "JSON-XS-2.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-2.23.tar.gz;
      sha256 = "0yd1j5d9b0ymfzfaxyi9zgca3vqwjb3dl8pg14m1qwsx3pidd5j7";
    };
  };

  perlLinguaENInflect = buildPerlPackage {
    name = "Lingua-EN-Inflect-1.89";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.89.tar.gz;
      sha256 = "1jvj67mvvfqxgxspmblay1c844vvhfwrviiarglkaw6phpg74rby";
    };
  };

  perlLinguaENInflectNumber = buildPerlPackage {
    name = "Lingua-EN-Inflect-Number-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMON/Lingua-EN-Inflect-Number-1.1.tar.gz;
      sha256 = "13hlr1srp9cd9mcc78snkng9il8iavvylfyh81iadvn2y7wikwfy";
    };
    propagatedBuildInputs = [perlLinguaENInflect];
  };

  perlListMoreUtils = buildPerlPackage {
    name = "List-MoreUtils-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPARSEVAL/List-MoreUtils-0.22.tar.gz;
      sha256 = "1dv21xclh6r1cyy19r34xv2w6pc1jb5pwj7b2739m78xhlk8p55l";
    };
  };

  perlLocaleGettext = buildPerlPackage {
    name = "LocaleGettext-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.05.tar.gz;
      sha256 = "15262a00vx714szpx8p2z52wxkz46xp7acl72znwjydyq4ypydi7";
    };
  };

  perlLocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Locale-Maketext-1.13.tar.gz;
      sha256 = "0qvrhcs1f28ix3v8hcd5xr4z9s7plz4g5a4q1cjp7bs0c3w2yl6z";
    };
    propagatedBuildInputs = [perlI18NLangTags];
  };

  perlLocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-0.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Lexicon-0.66.tar.gz;
      sha256 = "1cd2kbcrlyjcmlr7m8kf94mm1hlr7hpv1r80a596f4ljk81f2nvd";
    };
    propagatedBuildInputs = [perlLocaleMaketext];
  };

  perlLocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Simple-0.18.tar.gz;
      sha256 = "14kx7vkxyfqndy90rzavrjp2346aidyc7x5dzzdj293qf8s4q6ig";
    };
  };

  perlLWP = buildPerlPackage rec {
    name = "libwww-perl-5.825";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1wb7br1n86571xz19l20cc5ysy1lx3rhvlk02g5517919z3jxvhw";
    };
    propagatedBuildInputs = [perlURI perlHTMLParser perlHTMLTagset];
  };

  perlMailTools = buildPerlPackage {
    name = "MailTools-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.04.tar.gz;
      sha256 = "0w91rcrz4v0pjdnnv2mvlbrm9ww32f7ajhr7xkjdhhr3455p7adx";
    };
    propagatedBuildInputs = [perlTimeDate perlTestPod];
  };

  perlMIMETypes = buildPerlPackage {
    name = "MIME-Types-1.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-1.24.tar.gz;
      sha256 = "1j89kjv9lipv6r3bq6dp0k9b8y1f8z9vrmhi7b8h7cs1yc8g7qz9";
    };
    propagatedBuildInputs = [perlTestPod];
  };

  perlModuleBuild = buildPerlPackage {
    name = "Module-Build-0.2808";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Module-Build-0.2808.tar.gz;
      sha256 = "1h8zpf4g2n8v47l9apmdqbdgcg039g70w75hpn84m37pmqkbnj8v";
    };
    propagatedBuildInputs = [perlExtUtilsInstall perlExtUtilsManifest perlTestHarness];
  };

  perlModuleFind = buildPerlPackage {
    name = "Module-Find-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.06.tar.gz;
      sha256 = "1394jk0rn2zmchpl11kim69xh5h5yzg96jdlf76fqrk3dcn0y2ip";
    };
  };

  perlMoose = buildPerlPackage rec {
    name = "Moose-0.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1h1d551fbrsbr0knvcah4jyg999667ykhgbldl5rv4h7kdzsqsvz";
    };
    propagatedBuildInputs = [
      perlTestMore perlTestException perlTaskWeaken perlListMoreUtils
      perlClassMOP perlSubExporter
    ];
  };

  perlMooseXEmulateClassAccessorFast = buildPerlPackage rec {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "1z2sld2sw1mlwxwzxxanik3086cw14rdsx2wwnzrfy7prsnigcl2";
    };
    propagatedBuildInputs = [perlMoose perlNamespaceClean];
  };

  perlMouse = buildPerlPackage {
    name = "Mouse-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/Mouse-0.09.tar.gz;
      sha256 = "1akymbjim6w6i1q8h97izah26ndmcbnl1lwdsw9fa22hnhm0axg0";
    };
  };

  perlMROCompat = buildPerlPackage {
    name = "MRO-Compat-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BL/BLBLACK/MRO-Compat-0.09.tar.gz;
      sha256 = "16l37bxd5apax4kyvnadiplz8xmmx76y9pyq9iksqrv0d5rl5vl8";
    };
  };

  perlNamespaceClean = buildPerlPackage {
    name = "namespace-clean-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHAYLON/namespace-clean-0.08.tar.gz;
      sha256 = "1jwc15zz1j6indqgz64l09ayg0db4gfaasq74x0vyi1yx3d9x2yx";
    };
    propagatedBuildInputs = [perlScopeGuard];
  };

  perlNetDNS = buildPerlPackage {
    name = "Net-DNS-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OL/OLAF/Net-DNS-0.63.tar.gz;
      sha256 = "1pswrwhkav051xahm3k4cbyhi8kqpfmaz85lw44kwi2wc7mz4prk";
    };
    propagatedBuildInputs = [perlNetIP perlDigestHMAC];
    doCheck = false;
  };

  perlNetIP = buildPerlPackage {
    name = "Net-IP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.25.tar.gz;
      sha256 = "1iv0ka6d8kp9iana6zn51sxbcmz2h3mbn6cd8pald36q5whf5mjc";
    };
  };

  perlNetServer = buildPerlPackage rec {
    name = "Net-Server-0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "13vhv13w06g6h6iqx440q1h6hwj0kpjdxcc3fl9crkwg5glygg2f";
    };
    doCheck = false; # seems to hang waiting for connections
  };

  perlObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.05.tar.gz;
      sha256 = "10k9j18jpb16brv0hs7592r7hx877290pafb8gnk6ydy7hcq9r2j";
    };
  };

  perlParamsUtil = buildPerlPackage rec {
    name = "Params-Util-0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1n36vhahbs2mfck5x6g8ab9280zji9zwc5092jiq78s791227cb6";
    };
  };

  perlParamsValidate = buildPerlPackage rec {
    name = "Params-Validate-0.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1j0hx3pbfdyggbhrawa9k0wdm6lln3zdkrhjrdg1hzzf6csrlc1v";
    };
  };

  perlParent = buildPerlPackage {
    name = "parent-0.221";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.221.tar.gz;
      sha256 = "17jhscpa5p5szh1173pd6wvh2m05an1l941zqq9jkw9bzgk12hm0";
    };
  };

  perlPathClass = buildPerlPackage {
    name = "Path-Class-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.16.tar.gz;
      sha256 = "0zisxkj58jm84fwcssmdq8g6n37s33v5h7j28m12sbkqib0h76gc";
    };
  };

  perlPerl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  perlPerlIOeol = buildPerlPackage {
    name = "PerlIO-eol-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/PerlIO-eol-0.14.tar.gz;
      sha256 = "1rwj0r075jfvvd0fnzgdqldc7qdb94wwsi21rs2l6yhcv0380fs2";
    };
  };

  perlPerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-dynamic-0.12.tar.gz;
      sha256 = "140hay9q8q9sz1fa2s57ijp5l2448fkcg7indgn6k4vc7yshmqz2";
    };
  };

  perlPerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };
  };

  perlModulePluggable = buildPerlPackage {
    name = "Module-Pluggable-3.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMONW/Module-Pluggable-3.5.tar.gz;
      sha256 = "08rywi79pqn2c8zr17fmd18lpj5hm8lxd1j4v2k002ni8vhl43nv";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
  };

  perlModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Module-Pluggable-Fast-0.18.tar.gz;
      sha256 = "140c311x2darrc2p1drbkafv7qwhzdcff4ad300n6whsx4dfp6wr";
    };
    propagatedBuildInputs = [perlUNIVERSALrequire];
  };

  perlPodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "1krsz4zwmnmq3z29p5vmyr5fdzrn8v0sg6rf3qxk7xpxw4z5np84";
    };
    propagatedBuildInputs = [perlDevelSymdump];
  };

  perlPodEscapes = buildPerlPackage {
    name = "Pod-Escapes-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/Pod-Escapes-1.04.tar.gz;
      sha256 = "1wrg5dnsl785ygga7bp6qmakhjgh9n4g3jp2l85ab02r502cagig";
    };
  };

  perlPodSimple = buildPerlPackage {
    name = "Pod-Simple-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARANDAL/Pod-Simple-3.05.tar.gz;
      sha256 = "1j0kqcvr9ykcqlkr797j1npkbggykb3p4w5ri73s8mi163lzxkqb";
    };
    propagatedBuildInputs = [perlconstant perlPodEscapes];
  };

  perlReadonly = buildPerlPackage rec {
    name = "Readonly-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "1shkyxajh6l87nif47ygnfxjwvqf3d3kjpdvxaff4957vqanii2k";
    };
  };

  perlRegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "173dnzi3dag88afr4xf5v0hki15cfaffyjimjfmvzv6gbx6fp96f";
    };
  };

  perlRegexpCommon = buildPerlPackage rec {
    name = "Regexp-Common-2.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/${name}.tar.gz";
      sha256 = "1mi411nfsx58nfsgjsbyck50x9d0yfvwqpw63iavajlpx1z38n8r";
    };
  };

  perlRegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  perlReturnValue = buildPerlPackage {
    name = "Return-Value-1.302";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.302.tar.gz;
      sha256 = "0hf5rmfap49jh8dnggdpvapy5r4awgx5hdc3acc9ff0vfqav8azm";
    };
  };

  perlScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.03.tar.gz;
      sha256 = "07x966fkqxlwnngxs7a2jrhabh8gzhjfpqq56n9gkwy7f340sayb";
    };
  };

  perlScopeUpper = buildPerlPackage rec {
    name = "Scope-Upper-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "1qaf310wbfpjb0lmg3fpmhbfnjxqw3j47rj0w0f0cy4bgihi8l43";
    };
  };

  perlSetObject = buildPerlPackage {
    name = "Set-Object-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMV/Set-Object-1.26.tar.gz;
      sha256 = "1hx3wrw8xkvaggacc8zyn86hfi3079ahmia1n8vsw7dglp1bbhmj";
    };
  };

  perlSQLAbstract = buildPerlPackage rec {
    name = "SQL-Abstract-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1q77yfdrkadf738zvdgarkv0136zs2shz3fdmwaaf03bhvhcbap2";
    };
    propagatedBuildInputs = [
      perlTestDeep perlTestException perlTestWarn
    ];
  };

  perlSQLAbstractLimit = buildPerlPackage rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs = [
      perlSQLAbstract perlTestException perlDBI perlTestDeep
    ];
    buildInputs = [perlTestPod perlTestPodCoverage];
  };

  perlStringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.02.tar.gz;
      sha256 = "0si4xfgf8c2pfag1cqbr9jbyvg3hak6wkmny56kn2qwa4ljp9bk6";
    };
  };

  perlSubExporter = buildPerlPackage rec {
    name = "Sub-Exporter-0.982";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0xf8q05k5xs3bw6qy3pnnl5d670njxsxbw2dprl7n50hf488cbvj";
    };
    propagatedBuildInputs = [perlSubInstall perlDataOptList perlParamsUtil];
  };

  perlSubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "16g4dkmb4h5hh15jsq0kvsf3irrlrlqdv7qk6605wh5gjjwbcjxy";
    };
  };

  perlSubInstall = buildPerlPackage rec {
    name = "Sub-Install-0.925";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1sccc4nwp9y24zkr42ww2gwg6zwax4madi9spsdym1pqna3nwnm6";
    };
  };

  perlSubName = buildPerlPackage {
    name = "Sub-Name-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XM/XMATH/Sub-Name-0.04.tar.gz;
      sha256 = "1nlin0ag2krpmiyapp3lzb6qw2yfqvqmx57iz5zwbhr4pyi46bhb";
    };
  };

  perlSubOverride = buildPerlPackage rec {
    name = "Sub-Override-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "13s5zi6qz02q50vv4bmwdmhn9gvg0988fydjlrrv500g6hnyzlkj";
    };
    propagatedBuildInputs = [perlSubUplevel perlTestException];
  };

  perlSubUplevel = buildPerlPackage {
    name = "Sub-Uplevel-0.2002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2002.tar.gz;
      sha256 = "19b2b9xsw7lvvkcmmnhhv8ybxdkbnrky9nnqgjridr108ww9m5rh";
    };
  };

  perlSVK = buildPerlPackage {
    name = "SVK-v2.0.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVK-v2.0.2.tar.gz;
      sha256 = "0c4m2q7cvzwh9kk1nc1vd8lkxx2kss5nd4k20dpkal4c7735jns0";
    };
    propagatedBuildInputs = [
      perlAlgorithmDiff perlAlgorithmAnnotate perlAppCLI
      perlClassDataInheritable perlDataHierarchy perlEncode perlFileTemp
      perlIODigest perlListMoreUtils perlPathClass perlPerlIOeol
      perlPerlIOviadynamic perlPerlIOviasymlink perlPodEscapes
      perlPodSimple perlSVNMirror perlTimeHiRes perlUNIVERSALrequire
      perlURI perlYAMLSyck perlClassAutouse perlIOPager
      perlLocaleMaketextLexicon perlFreezeThaw
    ];
  };

  perlSVNMirror = buildPerlPackage {
    name = "SVN-Mirror-0.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Mirror-0.73.tar.gz;
      sha256 = "1scjaq7qjz6jlsk1c2l5q15yxf0sqbydvf22mb2xzy1bzaln0x2c";
    };
    propagatedBuildInputs = [
      perlClassAccessor perlFilechdir pkgs.subversion perlURI
      perlTermReadKey perlTimeDate perlSVNSimple
    ];
  };

  perlSVNSimple = buildPerlPackage {
    name = "SVN-Simple-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Simple-0.27.tar.gz;
      sha256 = "0p7p52ja6sf4j0w3b05i0bbqi5wiambckw2m5dsr63bbmlhv4a71";
    };
    propagatedBuildInputs = [pkgs.subversion];
  };

  perlTaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "07nn8a30n3qylpnf7s4ma6w462g31pywwikib117hr2mc7cv5cbm";
    };
    propagatedBuildInputs = [
      perlCatalystManual perlCatalystRuntime perlCatalystDevel
      perlCatalystPluginSession perlCatalystPluginAuthentication
      perlCatalystAuthenticationStoreDBIxClass
      perlCatalystPluginAuthorizationRoles
      perlCatalystPluginAuthorizationACL
      perlCatalystPluginHTMLWidget
      perlCatalystPluginSessionStoreFastMmap
      perlCatalystPluginStackTrace
      perlCatalystViewTT
      perlDBIxClass perlDBIxClassHTMLWidget
      perlCatalystControllerHTMLFormFu
    ];
    buildInputs = [perlTestPodCoverage];
  };

  perlTaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.02.tar.gz;
      sha256 = "10f9kd1lwbscmmjwgbfwa4kkp723mb463lkbmh29rlhbsl7kb5wz";
    };
  };

  perlTemplateTimer = buildPerlPackage {
    name = "Template-Timer-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-0.04.tar.gz;
      sha256 = "0j0gmxbq1svp0rb4kprwj2fk2mhl07yah08bksfz0a0pfz6lsam4";
    };
    propagatedBuildInputs = [perlTemplateToolkit];
  };

  perlTemplateToolkit = buildPerlPackage {
    name = "Template-Toolkit-2.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.20.tar.gz;
      sha256 = "13wbh06a76k4ag14lhszmpwv4hb8hlj1d9glizhp8izazl3xf1zg";
    };
    propagatedBuildInputs = [perlAppConfig];
    patches = [
      # Needed to make TT works properly on templates in the Nix store.
      ../development/perl-modules/template-toolkit-nix-store.patch
    ];
  };

  perlTermReadKey = buildPerlPackage {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlTestDeep = buildPerlPackage {
    name = "Test-Deep-0.103";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Deep-0.103.tar.gz;
      sha256 = "0cdl08k5v0wc9w20va5qw98ynlbs9ifwndgsix8qhi7h15sj8a5j";
    };
    propagatedBuildInputs = [perlTestTester perlTestNoWarnings];
  };

  perlTestException = buildPerlPackage {
    name = "Test-Exception-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADIE/Test-Exception-0.27.tar.gz;
      sha256 = "1s921j7yv2szywd1ffi6yz3ngrbq97f9dh38bvvajqnm29g1xb9j";
    };
    propagatedBuildInputs = [perlTestHarness perlTestSimple perlSubUplevel];
  };

  perlTestHarness = buildPerlPackage {
    name = "Test-Harness-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/Test-Harness-3.10.tar.gz;
      sha256 = "1qd217yzppj1vbjhny06v8niqhz85pam996ry6bzi08z0jidr2wh";
    };
  };

  perlTestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "0ln3117nfxzq7yxmfk77nnr7116inbjq4bf5v2p0hqlj4damx03d";
    };
  };

  perlTestMockObject = buildPerlPackage {
    name = "Test-MockObject-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.09.tar.gz;
      sha256 = "1cz385x0jrkj84nmfs6qyzwwvv8m9v8r2isagfj1zxvhdw49wdyy";
    };
    propagatedBuildInputs = [perlTestException perlUNIVERSALisa perlUNIVERSALcan];
  };

  perlTestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "1j2riyikzyfkxsgkfdqirs7xa8q5d06b9klpk7l9sgydwqdvxdv3";
    };
  };

  perlTestMore = perlTestSimple;

  perlTestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-0.084";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-NoWarnings-0.084.tar.gz;
      sha256 = "19g47pa3brr9px3jnwziapvxcnghqqjjwxz1jfch4asawpdx2s8b";
    };
    propagatedBuildInputs = [perlTestTester];
  };

  perlTestPod = buildPerlPackage {
    name = "Test-Pod-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-Pod-1.26.tar.gz;
      sha256 = "025rviipiaa1rf0bp040jlwaxwvx48kdcjriaysvkjpyvilwvqd4";
    };
  };

  perlTestPodCoverage = buildPerlPackage rec {
    name = "Test-Pod-Coverage-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0y2md932zhbxdjwzskx0vmw2qy7jxkn87f9lb5h3f3vxxg1kcqz0";
    };
    propagatedBuildInputs = [perlPodCoverage];
  };

  perlTestSimple = buildPerlPackage {
    name = "Test-Simple-0.84";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Simple-0.84.tar.gz;
      sha256 = "030j47q3p46jfk60dsh2d5m7ip4nqz0fl4inqr8hx8b8q0f00r4l";
    };
    propagatedBuildInputs = [perlTestHarness];
  };

  perlTestTester = buildPerlPackage {
    name = "Test-Tester-0.107";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.107.tar.gz;
      sha256 = "0qgmsl6s6xm39211lywyzwrlz0gcmax7fb8zipybs9yxfmwcvyx2";
    };
  };

  perlTestUseOk = buildPerlPackage rec {
    name = "Test-use-ok-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "11inaxiavb35k8zwxwbfbp9wcffvfqas7k9idy822grn2sz5gyig";
    };
  };

  perlTestWarn = buildPerlPackage {
    name = "Test-Warn-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Test-Warn-0.11.tar.gz;
      sha256 = "1y9g13bzvjsmg5v555zrl7w085jq40a47hfs4gc3k78s0bkwxbyi";
    };
    propagatedBuildInputs = [perlTestSimple perlTestException perlArrayCompare perlTreeDAGNode];
    buildInputs = [perlTestPod];
  };

  perlTestWWWMechanize = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "11knym5ppish78rk8r1hymvq1py43h7z8d6nk8p4ig3p246xx5qa";
    };
    propagatedBuildInputs = [
      perlCarpAssertMore perlURI perlTestLongString perlWWWMechanize
    ];
    doCheck = false;
  };

  perlTestWWWMechanizeCatalyst = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-Catalyst-0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "0hixz0hibv2z87kdqvrphzgww0xibgg56w7bh299dgw2739hy4yf";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTestWWWMechanize perlWWWMechanize
      perlCatalystPluginSessionStateCookie
    ];
    buildInputs = [perlTestPod];
    doCheck = false;
  };

  perlTextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "0vb0093v3kk7iczb46zzdg7myfyjldwrk8wbk7ibk56gvj350f7c";
    };
  };

  perlTextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Text-SimpleTable-0.05.tar.gz;
      sha256 = "028pdfmr2gnaq8w3iar8kqvrpxcghnag8ls7h4227l9zbxd1k9p9";
    };
  };

  perlTieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
    propagatedBuildInputs = [perlTestUseOk];
  };

  perlTimeDate = buildPerlPackage {
    name = "TimeDate-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-1.16.tar.gz;
      sha256 = "1cvcpaghn7dc14m9871sfw103g3m3a00m2mrl5iqb0mmh40yyhkr";
    };
  };

  perlTimeHiRes = buildPerlPackage {
    name = "Time-HiRes-1.9715";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHI/Time-HiRes-1.9715.tar.gz;
      sha256 = "0pgqrfkysy3mdcx5nd0x8c80lgqb7rkb3nrkii3vc576dcbpvw0i";
    };
  };

  perlTreeDAGNode = buildPerlPackage {
    name = "Tree-DAG_Node-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COGENT/Tree-DAG_Node-1.06.tar.gz;
      sha256 = "0anvwfh4vqj41ipq52p65sqlvw3rvm6cla5hbws13gyk9mvp09ah";
    };
  };

  perlTreeSimple = buildPerlPackage {
    name = "Tree-Simple-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-1.18.tar.gz;
      sha256 = "0bb2hc8q5rwvz8a9n6f49kzx992cxczmrvq82d71757v087dzg6g";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlTreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-VisitorFactory-0.10.tar.gz;
      sha256 = "1ghcgnb3xvqjyh4h4aa37x98613aldnpj738z9b80p33bbfxq158";
    };
    propagatedBuildInputs = [perlTreeSimple];
    buildInputs = [perlTestException];
  };

  perlFontTTF = buildPerlPackage {
    name = "perl-Font-TTF-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHOSKEN/Font-TTF-0.43.tar.gz;
      sha256 = "0782mj5n5a2qbghvvr20x51llizly6q5smak98kzhgq9a7q3fg89";
    };
  };

  perlUNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.12.tar.gz;
      sha256 = "1abadbgcy11cmlmj9qf1v73ycic1qhysxv5xx81h8s4p81alialr";
    };
  };

  perlUNIVERSALisa = stdenv.mkDerivation rec {
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

  perlUNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/UNIVERSAL-require-0.11.tar.gz;
      sha256 = "1rh7i3gva4m96m31g6yfhlqcabszhghbb3k3qwxbgx3mkf5s6x6i";
    };
  };

  perlURI = buildPerlPackage rec {
    name = "URI-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "0amwbss2gz00fkdfnfixf1afmqal1246xhmj27g5c0ny7ahcid0j";
    };
  };

  perlW3CLinkChecker = buildPerlPackage rec {
    name = "W3C-LinkChecker-4.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/${name}.tar.gz";
      sha256 = "0j2zlg57g0y9hqy8n35x5rfkpm7rnfjlwny5g0zaxwrl62ndkbm9";
    };
    propagatedBuildInputs = [
      perlLWP perlConfigGeneral perlNetIP perlTermReadKey perlPerl5lib
      perlCryptSSLeay
    ];
    meta = {
      homepage = http://validator.w3.org/checklink;
      description = "A tool to check links and anchors in Web pages or full Web sites";
    };
  };

  perlWWWMechanize = buildPerlPackage rec {
    name = "WWW-Mechanize-1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1yxvw5xfng5fj4422869p5dwvmrkmqph9gdm2nl12wngydk93lnh";
    };
    propagatedBuildInputs = [perlLWP perlHTTPResponseEncoding perlHTTPServerSimple];
    doCheck = false;
  };

  perlXMLDOM = buildPerlPackage {
    name = "XML-DOM-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.44.tar.gz;
      sha256 = "1r0ampc88ni3sjpzr583k86076qg399arfm9xirv3cw49k3k5bzn";
    };
    #buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLRegExp perlXMLParser perlLWP];
  };

  perlXMLLibXML = buildPerlPackage {
    name = "XML-LibXML-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PA/PAJAS/XML-LibXML-1.66.tar.gz;
      sha256 = "1a0bdiv3px6igxnbbjq10064iahm8f5i310p4y05w6zn5d51awyl";
    };
    buildInputs = [pkgs.libxml2];
    propagatedBuildInputs = [perlXMLLibXMLCommon perlXMLSAX];
  };

  perlXMLLibXMLCommon = buildPerlPackage {
    name = "XML-LibXML-Common-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHISH/XML-LibXML-Common-0.13.tar.gz;
      md5 = "13b6d93f53375d15fd11922216249659";
    };
    buildInputs = [pkgs.libxml2];
  };

  perlXMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-NamespaceSupport-1.09.tar.gz;
      sha256 = "0ny2i4pf6j8ggfj1x02rm5zm9a37hfalgx9w9kxnk69xsixfwb51";
    };
  };

  perlXMLParser = buildPerlPackage {
    name = "XML-Parser-2.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz;
      sha256 = "0gyp5qfbflhkin1zv8l6wlkjwfjvsf45a3py4vc6ni82fj32kmcz";
    };
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat}/lib EXPATINCPATH=${pkgs.expat}/include";
  };

  perlXMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.03.tar.gz;
      sha256 = "1gkarylvdk3mddmchcwvzq09gpvx5z26nybp38dg7mjixm5bs226";
    };
  };

  perlXMLSAX = buildPerlPackage {
    name = "XML-SAX-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-0.96.tar.gz;
      sha256 = "024fbjgg6s87j0y3yik55plzf7d6qpn7slwd03glcb54mw9zdglv";
    };
    propagatedBuildInputs = [perlXMLNamespaceSupport];
  };

  perlXMLSimple = buildPerlPackage {
    name = "XML-Simple-2.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.18.tar.gz;
      sha256 = "09k8fvc9m5nd5rqq00rwm3m0wx7iwd6vx0vc947y58ydi30nfjd5";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLTwig = buildPerlPackage {
    name = "XML-Twig-3.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.32.tar.gz;
      sha256 = "07zdsfzw9dlrx6ril9clf1jfif09vpf27rz66laja7mvih9izd1v";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLWriter = buildPerlPackage {
    name = "XML-Writer-0.602";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOSEPHW/XML-Writer-0.602.tar.gz;
      sha256 = "0kdi022jcn9mwqsxy2fiwl2cjlid4x13r038jvi426fhjknl11nl";
    };
  };

  perlXSLoader = buildPerlPackage {
    name = "XSLoader-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.08.tar.gz;
      sha256 = "0mr4l3givrpyvz1kg0kap2ds8g0rza2cim9kbnjy8hi64igkixi5";
    };
  };

  perlYAML = buildPerlPackage rec {
    name = "YAML-0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0yg0pgsjkfczsblx03rxlw4ib92k0gwdyb1a258xb9wdg0w61h34";
    };
  };

  perlYAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "15acwp2qdxfmhfqj4c1s57xyy48hcfc87lblww3lbvihqbysyzss";
    };
  };

}
