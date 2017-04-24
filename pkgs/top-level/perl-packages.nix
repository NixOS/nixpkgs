/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{pkgs, overrides}:

let self = _self // overrides; _self = with self; {

  inherit (pkgs) buildPerlPackage fetchurl fetchFromGitHub stdenv perl fetchsvn gnused;

  inherit (stdenv.lib) maintainers;

  # Helper functions for packages that use Module::Build to build.
  buildPerlModule = { buildInputs ? [], ... } @ args:
    buildPerlPackage (args // {
      buildInputs = buildInputs ++ [ ModuleBuild ];
      preConfigure = "touch Makefile.PL";
      buildPhase = "perl Build.PL --prefix=$out; ./Build build";
      installPhase = "./Build install";
      checkPhase = "./Build test";
    });


  ack = buildPerlPackage rec {
    name = "ack-2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0ifbmbfvagfi76i7vjpggs2hrbqqisd14f5zizan6cbdn8dl5z2g";
    };
    outputs = ["out" "doc"];
    # use gnused so that the preCheck command passes
    buildInputs = stdenv.lib.optional stdenv.isDarwin gnused;
    propagatedBuildInputs = [ FileNext ];
    meta = with stdenv.lib; {
      description = "A grep-like tool tailored to working with large trees of source code";
      homepage    = http://betterthangrep.com/;
      license     = licenses.artistic2;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
    # tests fails on nixos and hydra because of different purity issues
    doCheck = false;
  };

  AlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [AlgorithmDiff];
  };

  AlgorithmC3 = buildPerlPackage rec {
    name = "Algorithm-C3-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "01hlcaxndls86bl92rkd3fvf9pfa3inxqaimv88bxs95803kmkss";
    };
    meta = {
      description = "A module for merging hierarchies using the C3 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmDiff = let version = "1.1903"; in buildPerlPackage {
    name = "Algorithm-Diff-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-${version}.tar.gz";
      sha256 = "0l8pk7ziz72d022hsn4xldhhb9f5649j5cgpjdibch0xng24ms1h";
    };
    buildInputs = [ pkgs.unzip ];
  };

  AlgorithmMerge = buildPerlPackage rec {
    name = "Algorithm-Merge-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSMITH/Algorithm-Merge-0.08.tar.gz;
      sha256 = "1kqn13wd0lfjrf6h19b9kgdqqwp7k2d9yfq5i0wvii0xi8jqh1lw";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  aliased = buildPerlPackage rec {
    name = "aliased-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1syyqzy462501kn5ma9gl6xbmcahqcn4qpafhsmpz0nd0x2m4l63";
    };
  };

  AlienTidyp = buildPerlModule rec {
    name = "Alien-Tidyp-${version}";
    version = "1.4.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Alien-Tidyp-v${version}.tar.gz";
      sha256 = "0raapwp4155lqag1kzhsd20z4if10hav9wx4d7mc1xpvf7dcnr5r";
    };

    buildInputs = [ FileShareDir ArchiveExtract ];
    TIDYP_DIR = "${pkgs.tidyp}";
  };

  AlienWxWidgets = buildPerlPackage rec {
    name = "Alien-wxWidgets-0.67";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "075m880klf66pbcfk0la2nl60vd37jljizqndrklh5y4zvzdy1nr";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.gtk2 pkgs.wxGTK
      ModulePluggable ModuleBuild ];
  };

  AnyEvent = buildPerlPackage rec {
    name = "AnyEvent-7.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "16nnqzxy5baiar6gxnq5w296mmjgijcn1jq8rp867nksph03mxz8";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  AnyEventCacheDNS = buildPerlModule rec {
    name = "AnyEvent-CacheDNS-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/${name}.tar.gz";
      sha256 = "41c1faf183b61806b55889ceea1237750c1f61b9ce2735fdf33dc05536712dae";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ AnyEvent ];
    doCheck = false; # does an DNS lookup
    meta = {
      homepage = http://github.com/potyl/perl-AnyEvent-CacheDNS;
      description = "Simple DNS resolver with caching";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventHTTP = buildPerlPackage rec {
    name = "AnyEvent-HTTP-2.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "2e3376d03bfa5f172f43d4c615ba496281c9ffe3093a828c539683e17e2fbbcb";
    };
    propagatedBuildInputs = [ AnyEvent CommonSense ];
  };

  AnyEventI3 = buildPerlPackage rec {
    name = "AnyEvent-I3-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "1qwva5vmmn929l6k9wzhp4h80ad4qm4m1g2dyv4nlas624003hig";
    };
    propagatedBuildInputs = [ AnyEvent JSONXS ];
    meta = {
      description = "Communicate with the i3 window manager";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventRabbitMQ = buildPerlPackage {
    name = "AnyEvent-RabbitMQ-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/AnyEvent-RabbitMQ-1.15.tar.gz;
      sha256 = "fda292dfaae10f6d99aafc46831ce507153b58368e3eb2617bbb3f749605805a";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyEvent DevelGlobalDestruction FileShareDir ListMoreUtils NetAMQP Readonly namespaceclean ];
    meta = {
      description = "An asynchronous and multi channel Perl AMQP client";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  AnyMoose = buildPerlPackage rec {
    name = "Any-Moose-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1wcd1lpx38hvxk6k0zpx48hb7yidxnlr34lyk51zxin9ra9f2104";
    };
    propagatedBuildInputs = [ Mouse ];
  };

  ApacheLogFormatCompiler = buildPerlModule rec {
    name = "Apache-LogFormat-Compiler-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "17blk3zhp05azgypn25ydxf3d7fyfgr9bxyiv7xkchhqma96vwqv";
    };
    buildInputs = [ HTTPMessage ModuleBuild TestMockTime TestRequires TryTiny URI ];
    propagatedBuildInputs = [ POSIXstrftimeCompiler ];
    # We cannot change the timezone on the fly.
    prePatch = "rm t/04_tz.t";
    meta = {
      homepage = https://github.com/kazeburo/Apache-LogFormat-Compiler;
      description = "Compile a log format string to perl-code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheSession = buildPerlPackage {
    name = "Apache-Session-1.93";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Apache-Session-1.93.tar.gz;
      sha256 = "8e5a4882ac8ec657d1018d74d3ba37854e2688a41ddd0e1d73955ea59f276e8d";
    };
    buildInputs = [ TestDeep TestException ];
    meta = {
      description = "A persistence framework for session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheTest = buildPerlPackage {
    name = "Apache-Test-1.38";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Apache-Test-1.38.tar.gz;
      sha256 = "321717f58636ed0aa85cba6d69fc01e2ccbc90ba71ec2dcc2134d8401af65145";
    };
  };

  AppCLI = buildPerlPackage {
    name = "App-CLI-0.313";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORNELIUS/App-CLI-0.313.tar.gz;
      sha256 = "0ni1z14xis1b634qjc3zra9c9pl2icfr6sp5qxs0xy8nvib65037";
    };
    propagatedBuildInputs = [LocaleMaketextSimple];
  };

  AppCmd = buildPerlPackage rec {
    name = "App-Cmd-0.330";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "7a7bfd7196f7551a07509b03ea7abddc1fa9aee19a84e3dd5ba939c619cb6011";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CaptureTiny ClassLoad DataOptList GetoptLongDescriptive IOTieCombine ModulePluggable StringRewritePrefix SubExporter SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/App-Cmd;
      description = "Write command line apps with less suffering";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  AppConfig = buildPerlPackage rec {
    name = "AppConfig-1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "03vvi3mk4833mx2c6dkm9zhvakf02mb2b7wz9pk9xc7c4mq04xqi";
    };
    meta = {
      description = "A bundle of Perl5 modules for reading configuration files and parsing command line arguments";
    };
  };

  Appcpanminus = buildPerlPackage rec {
    name = "App-cpanminus-1.7040";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "fc8e5cde17cc5f4cc13aea8781c1e9425f76abc684cc720e9253f47ab3529556";
    };
    meta = {
      homepage = https://github.com/miyagawa/cpanminus;
      description = "Get, unpack, build and install modules from CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  Appperlbrew = buildPerlPackage rec {
    name = "App-perlbrew-0.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GU/GUGOD/${name}.tar.gz";
      sha256 = "0ym7ahjm95igm1hg0qwy29zdcjqdcakcmrn3r8xlbvqkk5xrxg5c";
    };
    buildInputs = [ pkgs.curl IOAll PathClass TestException TestNoWarnings TestOutput TestSpec ];
    propagatedBuildInputs = [ CPANPerlReleases CaptureTiny DevelPatchPerl locallib ];

    preConfigure = ''
      patchShebangs .
    '';

    doCheck = false;

    meta = {
      description = "Manage perl installations in your $HOME";
      license = stdenv.lib.licenses.mit;
    };
  };

  AppSqitch = buildPerlModule rec {
    version = "0.9994";
    name = "App-Sqitch-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "0in602z40s50fdlmws4g0a1pb8p7yn0wx8jgsacz26a4i1q7gpi4";
    };
    buildInputs = [
      CaptureTiny PathClass TestDeep TestDir TestException
      TestFile TestFileContents TestMockModule TestNoWarnings
    ];
    propagatedBuildInputs = [
      Clone ConfigGitLike DBI DateTime
      DevelStackTrace EncodeLocale FileHomeDir HashMerge IOPager IPCRun3
      IPCSystemSimple ListMoreUtils Moo PathClass PerlIOutf8_strict StringFormatter
      StringShellQuote SubExporter TemplateTiny Throwable TryTiny TypeTiny URI
      URIdb libintlperl namespaceautoclean
    ];
    doCheck = false;  # Can't find home directory.
    meta = {
      homepage = http://sqitch.org/;
      description = "Sane database change management";
      license = stdenv.lib.licenses.mit;
    };
  };

  AppSt = buildPerlPackage rec {
    name = "App-St-1.1.2";
    src = fetchurl {
      url = https://github.com/nferraz/st/archive/v1.1.2.tar.gz;
      sha256 = "1j1iwcxl16m4x5kl1vcv0linb93r55ndh3jm0w6qf459jl4x38s6";
    };
    postInstall =
      ''
        sed -e "1 s|\(.*\)|\1 -I $out/lib/perl5/site_perl|" -i $out/bin/st
        ($out/bin/st --help || true) | grep Usage
      '';
    meta = {
      description = "A command that computes simple statistics";
      license = stdenv.lib.licenses.mit;
      homepage = https://github.com/nferraz/st;
      maintainers = [ maintainers.eelco ];
    };
  };

  AttributeHandlers = buildPerlPackage {
    name = "Attribute-Handlers-0.99";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Attribute-Handlers-0.99.tar.gz;
      sha256 = "937ea3ebfc9b14f4a4148bf3c32803709edbd12a387137a26370b38ee1fc9835";
    };
    meta = {
      description = "Simpler definition of attribute handlers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AttributeParamsValidate = buildPerlPackage {
    name = "Attribute-Params-Validate-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Attribute-Params-Validate-1.21.tar.gz;
      sha256 = "586b939ceffdb37188b7c461dd1a8f9f35695184c8703b05c35f6d508c8090f5";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ParamsValidate ];
    doCheck = false;
    meta = {
      homepage = http://metacpan.org/release/Attribute-Params-Validate;
      description = "Define validation through subroutine attributes";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ArrayCompare = buildPerlPackage rec {
    name = "Array-Compare-2.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVECROSS/${name}.tar.gz";
      sha256 = "0f1mg2lpr5jzxy1hciww7vlp4r602vfwpzsqmhkgv1i107pmiwcs";
    };

    buildInputs = [ TestNoWarnings Moo TypeTiny ];
  };

  ListCompare = buildPerlPackage rec {
    name = "List-Compare-0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/${name}.tar.gz";
      sha256 = "fdbf4ff67b3135d44475fef7fcac0cd4706407d5720d26dca914860eb10f8550";
    };
    buildInputs = [ IOCaptureOutput ];
    meta = {
      homepage = http://thenceforward.net/perl/modules/List-Compare/;
      description = "Compare elements of two or more lists";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveCpio = buildPerlPackage rec {
    name = "Archive-Cpio-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PI/PIXEL/${name}.tar.gz";
      sha256 = "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3";
    };
    meta = {
      description = "Module for manipulations of cpio archives";
      # See https://rt.cpan.org/Public/Bug/Display.html?id=43597#txn-569710
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  ArchiveExtract = buildPerlPackage rec {
    name = "Archive-Extract-0.76";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "9ae7080ca70346dd7d9845c581d2e112f4513ec0f7d79c2011c0e0a2ce874cfc";
    };
    propagatedBuildInputs = [ self."if" ];
    meta = {
      description = "Generic archive extracting mechanism";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveTar = buildPerlPackage rec {
    name = "Archive-Tar-2.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "62e34feffd51e21b24f2ba5b15adf3ca3bd084163bfec40fe30f8f8e8963066b";
    };
    meta = {
      description = "Manipulates TAR archives";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.16";
    src = fetchurl {
      url = http://tarballs.nixos.org/Archive-Zip-1.16.tar.gz;
      sha256 = "1ghgs64by3ybjlb0bj65kxysb03k72i7iwmw63g41bj175l44ima";
    };
  };

  ArchiveZip_1_53 = buildPerlPackage {
    name = "Archive-Zip-1.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Archive-Zip-1.53.tar.gz;
      sha256 = "c66f3cdfd1965d47d84af1e37b997e17d3f8c5f2cceffc1e90d04d64001424b9";
    };
    meta = {
      description = "Provide an interface to ZIP archive files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AudioScan = buildPerlPackage rec {
    name = "Audio-Scan-0.93";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "03nwcm234y76jb1p20rlcky6vzv68i46s9mjfr7kzp65w3yg94js";
    };
    buildInputs = [ pkgs.zlib ModuleBuild ModuleBuildPluggablePPPort ];
    propagatedBuildInputs = [ TestWarn ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.zlib.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.zlib.out}/lib -lz";
    meta = {
      description = "Fast C metadata and tag reader for all common audio file formats";
      license = stdenv.lib.licenses.gpl2;
    };
  };

  AuthenDecHpwd = buildPerlPackage rec {
    name = "Authen-DecHpwd-2.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "67f45fef6a23b7548f387b675cbf7881bf9da62d7d007cbf90d3a4b851b99eb7";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ ScalarString DataInteger DigestCRC ];
    meta = {
      description = "DEC VMS password hashing";
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  AuthenHtpasswd = buildPerlPackage rec {
    name = "Authen-Htpasswd-0.171";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Authen/${name}.tar.gz";
      sha256 = "0rw06hwpxg388d26l0jvirczx304f768ijvc20l4b2ll7xzg9ymm";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
    meta = {
      description = "Interface to read and modify Apache .htpasswd files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenPassphrase = buildPerlPackage rec {
    name = "Authen-Passphrase-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "55db4520617d859d88c0ee54965da815b7226d792b8cdc8debf92073559e0463";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ModuleRuntime ParamsClassify CryptPasswdMD5 CryptDES
      DataEntropy CryptUnixCryptXS CryptEksblowfish CryptMySQL DigestMD4 AuthenDecHpwd];
    meta = {
      description = "Hashed passwords/passphrases as objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenSASL = buildPerlPackage rec {
    name = "Authen-SASL-2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "02afhlrdq5hh5g8b32fa79fqq5i76qzwfqqvfi9zi57h31szl536";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      description = "SASL Authentication framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  autobox = buildPerlPackage rec {
    name = "autobox-2.84";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/${name}.tar.gz";
      sha256 = "98dd2754f226684a72ccba3a95956b7eaff2871568e4dd9746e6fb6daae0b96b";
    };
    propagatedBuildInputs = [ ScopeGuard ];
    meta = {
      description = "Call methods on native types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Autobox = self.autobox;

  Autodia = buildPerlPackage rec {
    name = "Autodia-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEEJAY/${name}.tar.gz";
      sha256 = "08pl5y18nsvy8ihfzdsbd8rz6a8al09wqfna07zdjfdyib42b0dc";
    };
    propagatedBuildInputs = [ TemplateToolkit Inline InlineJava GraphViz
      XMLSimple DBI ];

    meta = {
      description = "AutoDia, create UML diagrams from source code";

      longDescription = ''
        AutoDia is a modular application that parses source code, XML or data
        and produces an XML document in Dia format (or images via graphviz
        and vcg).  Its goal is to be a UML / DB Schema diagram autocreation
        package.  The diagrams its creates are standard UML diagrams showing
        dependencies, superclasses, packages, classes and inheritances, as
        well as the methods, etc of each class.

        AutoDia supports any language that a Handler has been written for,
        which includes C, C++, Java, Perl, Python, and more.
      '';

      homepage = http://www.aarontrevena.co.uk/opensource/autodia/;
      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
    };
  };

  autodie = null; # part of Perl

  AutoLoader = buildPerlPackage {
    name = "AutoLoader-5.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/AutoLoader-5.74.tar.gz;
      sha256 = "2fac75b05309f71a6871804cd25e1a3ba0a28f43f294fb54528077558da3aff4";
    };
    meta = {
      description = "Load subroutines only on demand";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  autovivification = buildPerlPackage rec {
    name = "autovivification-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/${name}.tar.gz";
      sha256 = "1422kw9fknv7rbjkgdfflg1q3mb69d3yryszp38dn0bgzkqhwkc1";
    };
    meta = {
      homepage = http://search.cpan.org/dist/autovivification/;
      description = "Lexically disable autovivification";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  base = buildPerlPackage {
    name = "base-2.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/base-2.18.tar.gz;
      sha256 = "55b0d21f8edb5ef6dddcb1fd2457acb19c7584f2dfdea614685cd8ea62a1c306";
    };
  };

  BC = buildPerlPackage rec {
    name = "B-C-1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "d07e5af5fb798fcd3f4eda5e40744a14c1b3ef9e585a7dca55b5db31cb1d28d3";
    };
    propagatedBuildInputs = [ BFlags IPCRun Opcodes ];
    meta = {
      homepage = http://www.perl-compiler.org;
      description = "Perl compiler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BFlags = buildPerlPackage rec {
    name = "B-Flags-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "07inzxvvf4bkl4iliys9rfdiz309nccpbr82a7g57bhcylj7qhzn";
    };
    meta = {
      description = "Friendlier flags for B";
    };
  };

  BerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl;
    inherit (pkgs) db;
  };

  BHooksEndOfScope = buildPerlPackage rec {
    name = "B-Hooks-EndOfScope-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0bllq4077hxbdsh31r3cwpm6mzmc0247rrg1lr7rk7flscif8bhj";
    };
    propagatedBuildInputs = [ ModuleImplementation ModuleRuntime SubExporterProgressive ];
    meta = {
      homepage = http://metacpan.org/release/B-Hooks-EndOfScope;
      description = "Execute code after a scope finished compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPCheck = buildPerlPackage {
    name = "B-Hooks-OP-Check-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/B-Hooks-OP-Check-0.19.tar.gz;
      sha256 = "0pp1piv74pv9irqlvl5xcs2dvzbb74niwjhnj6dsckxf1j34mzrg";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Wrap OP check callbacks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  bignum = buildPerlPackage rec {
    name = "bignum-0.47";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "b084eac6d676d2acc4d60deed58e6e31b2f572b7b0be1aec9b93be92bad8261a";
    };
    buildInputs = [ MathBigInt MathBigRat ];
    meta = {
      description = "Transparent BigNumber support for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BitVector = buildPerlPackage {
    name = "Bit-Vector-7.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-7.3.tar.gz;
      sha256 = "0gcg1173i1bsx2qvyw77kw90xbf03b861jc42hvq744vzc5k6xjs";
    };
    propagatedBuildInputs = [CarpClan];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  BKeywords = buildPerlPackage rec {
    name = "B-Keywords-1.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "1llaqhx6711lsf6mxmvrhjigpy3ymmf3wl8kvn7l0fsppnmn45lw";
    };
    meta = {
      description = "Lists of reserved barewords and symbol names";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
    };
  };

  boolean = buildPerlPackage rec {
    name = "boolean-0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "18hrgldzwnhs0c0r8hxx6r05qvk9p7gwinjwcybixfs2h0n43ypj";
    };
    meta = {
      homepage = https://github.com/ingydotnet/boolean-pm/tree;
      description = "Boolean support for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BoostGeometryUtils = buildPerlModule rec {
    name = "Boost-Geometry-Utils-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/${name}.tar.gz";
      sha256 = "1jnihz3029x51a455nxa0jx2z125x38q3vkkggsgdlrvawzxsm00";
    };
    propagatedBuildInputs = [ ModuleBuildWithXSpp ExtUtilsTypemapsDefault ];
    patches = [
      # Fix out of memory error on Perl 5.19.4 and later.
      ../development/perl-modules/boost-geometry-utils-fix-oom.patch
    ];
  };

  BusinessHours = buildPerlPackage rec {
    name = "Business-Hours-0.12";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/R/RU/RUZ/Business-Hours-0.12.tar.gz";
      sha256 = "15c5g278m1x121blspf4bymxp89vysizr3z6s1g3sbpfdkrn4gyv";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ SetIntSpan TimeLocal ];
    meta = {
      description = "Calculate business hours in a time period";
    };
  };

  BusinessISBN = buildPerlPackage rec {
    name = "Business-ISBN-2.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "0fhjzgwjxypai16vv0bws6pnxgcglcbgza81avkck6w6d3jkki4r";
    };
    propagatedBuildInputs = [ BusinessISBNData URI ];
    meta = {
      description = "Parse and validate ISBNs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISBNData = buildPerlPackage rec {
    name = "Business-ISBN-Data-20140910.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1bnbiv4vsz0hr1bm3nq9pjsjnf0mndp2vahwsvxbnv1gczb1691y";
    };
    meta = {
      description = "Data pack for Business::ISBN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISMN = buildPerlPackage rec {
    name = "Business-ISMN-1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "0cm1v75axg4gp6cnbyavmnqqjscsxh7nc60vcbw34rqivvf9idc9";
    };
    propagatedBuildInputs = [ TieCycle ];
    meta = {
      description = "Work with International Standard Music Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISSN = buildPerlPackage {
    name = "Business-ISSN-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISSN-0.91.tar.gz;
      sha256 = "f15b192c0f547bb2967811072b3d343b94bc5ea58d02704c19122f7ae0a9d6b5";
    };
    meta = {
      description = "Work with International Standard Serial Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheCache = buildPerlPackage rec {
    name = "Cache-Cache-1.08";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "1s6i670dc3yb6ngvdk48y6szdk5n1f4icdcjv2vi1l2xp9fzviyj";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
    doCheck = false; # randomly fails
  };

  CacheFastMmap = buildPerlPackage rec {
    name = "Cache-FastMmap-1.43";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "18k10bhi67iyy8igw8hwb339miwscgnsh9y2pbncw6gdr2b610vi";
    };
  };

  CacheMemcached = buildPerlPackage rec {
    name = "Cache-Memcached-1.30";
    src = fetchurl {
      url =
      mirror://cpan/authors/id/D/DO/DORMANDO/Cache-Memcached-1.30.tar.gz;
      sha256 = "1aa2mjn5767b13063nnsrwcikrnbspby7j1c5q007bzaq0gcbcri";
    };
    propagatedBuildInputs = [ StringCRC32 ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemcachedFast = buildPerlPackage {
    name = "Cache-Memcached-Fast-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KR/KROKI/Cache-Memcached-Fast-0.21.tar.gz;
      sha256 = "0lvwkkyazbb7i6c5ga5ms3gsvy721njpcbc2icxcsvc8bz32nz5i";
    };
    meta = {
      description = "Perl client for B<memcached>, in C language";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemory = buildPerlPackage {
    name = "Cache-Memory-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLEISHMAN/Cache-2.04.tar.gz;
      sha256 = "1zykapgl9lxnlx79xfghzb26qimhry94xfxfyswwfhra1ywd9yyg";
    };
    propagatedBuildInputs = [ TimeDate DBFile DigestSHA1 FileNFSLock HeapFibonacci IOString ];
    doCheck = false; # can time out
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheSimpleTimedExpiry = buildPerlPackage {
    name = "Cache-Simple-TimedExpiry-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Cache-Simple-TimedExpiry-0.27.tar.gz;
      sha256 = "4e78b7e4dd231b5571a48cd0ee1b63953f5e34790c9d020e1595a7c7d0abbe49";
    };
    meta = {
      description = "A lightweight cache with timed expiration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Cairo = buildPerlPackage rec {
    name = "Cairo-1.106";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1i25kks408c54k2zxskvg54l5k3qadzm8n72ffga9jy7ic0h6j76";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.cairo ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the cairo 2D vector graphics library";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  cam_pdf = buildPerlPackage rec {
    name = "CAM-PDF-1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CD/CDOLAN/${name}.tar.gz";
      sha256 = "12dv5ssf3y7yjz9mrrqnfzx8nf4ydk1qijf5fx59495671zzqsp7";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
    buildInputs = [ TestMore ];
  };

  CanaryStability = buildPerlPackage rec {
    name = "Canary-Stability-2012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "fd240b111d834dbae9630c59b42fae2145ca35addc1965ea311edf0d07817107";
    };
    meta = {
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  CaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.97";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Captcha-reCAPTCHA-0.97.tar.gz;
      sha256 = "12f2yh89aji6mnkrqxjcllws5dlg545wvz0j7wamy149xyqi12wq";
    };
    propagatedBuildInputs = [HTMLTiny LWP];
    buildInputs = [TestPod];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CaptureTiny = buildPerlPackage rec {
    name = "Capture-Tiny-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1siswsz63wcvldnq1ns1gm5kbs768agsgcgh1papfzkmg19fbd53";
    };
    meta = {
      homepage = https://metacpan.org/release/Capture-Tiny;
      description = "Capture STDOUT and STDERR from Perl, XS or external programs";
      license = stdenv.lib.licenses.asl20;
    };
  };

  Carp = buildPerlPackage {
    name = "Carp-1.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Carp-1.36.tar.gz;
      sha256 = "dcc789935126461c80df0653f98c1d8d0b936dcc3d04174287cb02767eca123c";
    };
    meta = {
      description = "Alternative warn and die for modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAlways = buildPerlPackage rec {
    name = "Carp-Always-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "0i2rifkr7ybfcdsqana52487z7vxp2l5qdra0f6ik0ddhn6rzii1";
    };
    meta = {
      description = "Warns and dies noisily with stack backtraces";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = stdenv.lib.licenses.artistic2;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystActionRenderView = buildPerlPackage rec {
    name = "Catalyst-Action-RenderView-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "8565203950a057d43ecd64e9593715d565c2fbd8b02c91f43c53b2111acd3948";
    };
    buildInputs = [ HTTPRequestAsCGI ];
    propagatedBuildInputs = [ CatalystRuntime DataVisitor MROCompat ];
    meta = {
      description = "Sensible default end action";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystActionREST = buildPerlPackage rec {
    name = "Catalyst-Action-REST-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Action-REST-1.20.tar.gz;
      sha256 = "c0470541ec0016b837db3186ed77915813c8b856b941db89b86db8602e31ead6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CatalystRuntime ClassInspector JSONMaybeXS MROCompat ModulePluggable Moose ParamsValidate URIFind namespaceautoclean ];
    meta = {
      description = "Automated REST Method Dispatching";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationCredentialHTTP = buildPerlPackage {
    name = "Catalyst-Authentication-Credential-HTTP-1.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Authentication-Credential-HTTP-1.015.tar.gz;
      sha256 = "02gyq0vkhj2psd7hvw4b095mvsz7vbq8kv4k8lq748jnx5kmnfrq";
    };
    buildInputs = [ TestException TestMockObject ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime ClassAccessorFast DataUUID StringEscape URI ];
    meta = {
      description = "HTTP Basic and Digest authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystAuthenticationStoreHtpasswd = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-Htpasswd-1.003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "09mn0wjwfvnfi28y47g816nx50zdpvwvbxp0nrpsap0ir1m80wi3";
    };
    buildInputs = [ TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs =
      [ CatalystPluginAuthentication ClassAccessor CryptPasswdMD5 AuthenHtpasswd HTMLForm ];
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1506";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-DBIx-Class-0.1506.tar.gz;
      sha256 = "0i5ja7690fs9nhxcij6lw51j804sm8s06m5mvk1n8pi8jljrymvw";
    };
    propagatedBuildInputs = [ CatalystModelDBICSchema CatalystPluginAuthentication CatalystRuntime DBIxClass ListMoreUtils Moose namespaceautoclean TryTiny ];
    meta = {
      description = "A storage class for Catalyst Authentication using DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "7f63f930e1e613f15955c9e6d73873675c50c0a3bc2a61a034733361ed26d271";
    };
    propagatedBuildInputs = [ CatalystRuntime Moose ];
    meta = {
      description = "Moose role to create only one instance of component per context";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "84329b287716cdc6d3c5a9ee185458cd2ce7abd9d902eac1c6240ef17572f12c";
    };
    buildInputs = [ CatalystActionRenderView CatalystPluginSession CatalystPluginSessionStateCookie CatalystPluginSessionStoreFile CatalystViewTT TemplateToolkit TestAggregate TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystComponentInstancePerContext CatalystRuntime ConfigAny HTMLFormFu Moose MooseXAttributeChained RegexpAssemble TaskWeaken namespaceautoclean ];
    meta = {
      description = "Catalyst integration for HTML::FormFu";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerPOD = buildPerlPackage rec {
    name = "Catalyst-Controller-POD-1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "ee2a4bb3ed78baa1464335408f284345b6ba0ef6576ad7bfbd7b656c788a39f9";
    };
    buildInputs = [ CatalystRuntime ModuleBuild ModuleInstall TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystPluginStaticSimple CatalystRuntime ClassAccessor FileShareDir FileSlurp JSONXS LWP ListMoreUtils PathClass PodPOM PodPOMViewTOC TestWWWMechanizeCatalyst XMLSimple ];
    meta = {
      homepage = http://search.cpan.org/dist/Catalyst-Controller-POD/;
      description = "Serves PODs right from your Catalyst application";
      license = stdenv.lib.licenses.bsd3;
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystDevel = buildPerlPackage rec {
    name = "Catalyst-Devel-1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "bce371ba801c7d79eff3257e0af907cf62f140de968f0d63bf55be37d702a58a";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CatalystActionRenderView CatalystPluginConfigLoader CatalystPluginStaticSimple CatalystRuntime ConfigGeneral FileChangeNotify FileCopyRecursive FileShareDir ModuleInstall Moose MooseXDaemonize MooseXEmulateClassAccessorFast PathClass TemplateToolkit Starman namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "Catalyst Development Tools";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  CatalystDispatchTypeRegex = buildPerlModule rec {
    name = "Catalyst-DispatchType-Regex-5.90035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGRIMES/${name}.tar.gz";
      sha256 = "06jq1lmpq88rmp9zik5gqczg234xac0hiyc3l698iif7zsgcyb80";
    };
    propagatedBuildInputs = [ Moose TextSimpleTable ];
    meta = {
      description = "Regex DispatchType";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

    meta = {
      # Depends on some old version of Catalyst-Runtime that contains
      # Catalyst::Engine::CGI. But those version do not compile.
      broken = true;
    };
  };

  CatalystManual = buildPerlPackage rec {
    name = "Catalyst-Manual-5.9009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1z6l0vdjxzisqgb5w447m3m73sfvkhwm7qw2l1dpcdng3zaypllh";
    };
    meta = {
      description = "The Catalyst developer's manual";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBJK/Catalyst-Model-DBIC-Schema-0.65.tar.gz;
      sha256 = "26a911ef5ef7ffc81b6ce65c3156f71fb35083c456ad27e6d82d2dc02493eeea";
    };
    buildInputs = [ DBDSQLite TestException TestRequires ];
    propagatedBuildInputs = [ CarpClan CatalystComponentInstancePerContext CatalystRuntime CatalystXComponentTraits DBIxClass DBIxClassSchemaLoader HashMerge ListMoreUtils ModuleRuntime Moose MooseXMarkAsMethods MooseXNonMoose MooseXTypes MooseXTypesLoadableClass TieIxHash TryTiny namespaceautoclean namespaceclean ];
    meta = {
      description = "DBIx::Class::Schema Model Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystRuntime = buildPerlPackage rec {
    name = "Catalyst-Runtime-5.90104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "91d551944beb3a0ae8635c78d5f2e1583ef1e7873d5c8ee407e2f64380ad870b";
    };
    buildInputs = [ DataDump HTTPMessage IOstringy JSONMaybeXS TestFatal TypeTiny ];
    propagatedBuildInputs = [ CGISimple CGIStruct ClassC3AdoptNEXT ClassDataInheritable ClassLoad DataDump DataOptList HTMLParser HTTPBody HTTPMessage HTTPRequestAsCGI HashMultiValue JSONMaybeXS LWP ListMoreUtils MROCompat ModulePluggable Moose MooseXEmulateClassAccessorFast MooseXGetopt MooseXMethodAttributes MooseXRoleWithOverloading PathClass Plack PlackMiddlewareFixMissingBodyInRedirect PlackMiddlewareMethodOverride PlackMiddlewareRemoveRedundantBody PlackMiddlewareReverseProxy PlackTestExternalServer SafeIsa StreamBuffered StringRewritePrefix SubExporter TaskWeaken TextSimpleTable TreeSimple TreeSimpleVisitorFactory TryTiny URI URIws namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "The Catalyst Framework Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  CatalystPluginAccessLog = buildPerlPackage rec {
    name = "Catalyst-Plugin-AccessLog-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/${name}.tar.gz";
      sha256 = "873db8e4e72a994e3e17aeb53d2b837e6d524b4b8b0f3539f262135c88cc2120";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime Moose namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Catalyst-Plugin-AccessLog;
      description = "Request logging from within Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "0v6hb4r1wv3djrnqvnjcn3xx1scgqzx8nyjdg9lfc1ybvamrl0rn";
    };
    buildInputs = [ ClassMOP Moose TestException ];
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime ClassInspector Moose MooseXEmulateClassAccessorFast MROCompat namespaceautoclean StringRewritePrefix TryTiny ];
    meta = {
      description = "Infrastructure plugin for the Catalyst authentication framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthorizationACL = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authorization-ACL-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0z4328rr6l9xi45hyv6q9pwwamp0864q6skcp29jrz9f919ycdra";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassThrowable ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginCache = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Cache-0.12.tar.gz;
      sha256 = "1q23aipvrl888h06ldr4mmjbykz0j4rqwipxg1jv094kki2fspr9";
    };
    buildInputs = [ TestDeep TestException ];
    propagatedBuildInputs = [ CatalystRuntime MROCompat TaskWeaken ];
    meta = {
      description = "Flexible caching support for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCacheHTTP = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-HTTP-0.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRAF/Catalyst-Plugin-Cache-HTTP-0.001000.tar.gz;
      sha256 = "0v5iphbq4csc4r6wkvxnqlh97p8g0yhjky9qqmsdyqczn87agbba";
    };
    buildInputs = [ CatalystRuntime Testuseok TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ ClassAccessorFast HTTPMessage MROCompat ];
    meta = {
      description = "HTTP/1.1 cache validators for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCaptcha = buildPerlPackage {
    name = "Catalyst-Plugin-Captcha-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DIEGOK/Catalyst-Plugin-Captcha-0.04.tar.gz;
      sha256 = "0llyj3v5nx9cx46jdbbvxf1lc9s9cxq5ml22xmx3wkb201r5qgaa";
    };
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession GDSecurityImage HTTPDate ];
    meta = {
      description = "Create and validate Captcha for Catalyst";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "19j7p4v7mbx6wrmpvmrnd974apx7hdl2s095ga3b9zcbdrl77h5q";
    };
    propagatedBuildInputs = [CatalystRuntime DataVisitor ConfigAny MROCompat];
  };

  CatalystPluginFormValidator = buildPerlPackage rec {
    name = "Catalyst-Plugin-FormValidator-0.094";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/${name}.tar.gz";
      sha256 = "5834f11bf5c9f4b5d336d65c7ce6639b76ce7bfe7a2875eb048d7ea1c82ce05a";
    };
    propagatedBuildInputs = [ CatalystRuntime DataFormValidator MROCompat Moose ];
    meta = {
      description = "Data::FormValidator";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginFormValidatorSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-FormValidator-Simple-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/${name}.tar.gz";
      sha256 = "486c6a0e8f410fd017279f4804ab9e35ba46321d33a0a9721fe1e08a391de7a0";
    };
    propagatedBuildInputs = [ CatalystPluginFormValidator CatalystRuntime FormValidatorSimple ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystPluginUnicodeEncoding = buildPerlPackage {
    name = "Catalyst-Plugin-Unicode-Encoding-1.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Unicode-Encoding-1.9.tar.gz;
      sha256 = "1glxkh79zz71bmgk44hnhsi37z2mgxcwf7bkmwlnwv3jh1iaz0ah";
    };
    buildInputs = [ HTTPMessage IOStringy ];
    propagatedBuildInputs = [ CatalystRuntime ClassDataInheritable LWP TryTiny URI ];
    meta = {
      description = "Unicode aware Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginHTMLWidget = buildPerlPackage {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Catalyst-Plugin-HTML-Widget-1.1.tar.gz;
      sha256 = "1zzyfhmzlqvbwk2w930k3mqk8z1lzhrja9ynx9yfq5gmc8qqg95l";
    };
    propagatedBuildInputs = [CatalystRuntime HTMLWidget];
  };

  CatalystPluginLogHandler = buildPerlPackage rec {
    name = "Catalyst-Plugin-Log-Handler-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEPE/${name}.tar.gz";
      sha256 = "0db3c3a57b4ee3d789ba5129890e2858913fef00d8185bdc9c5d7fde31e043ef";
    };
    propagatedBuildInputs = [ ClassAccessor LogHandler MROCompat ];
    meta = {
      description = "Catalyst Plugin for Log::Handler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystPluginSession = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "171vi9xcl775scjaw4fcfdmqvz0rb1nr0xxg2gb3ng6bjzpslhgv";
    };
    buildInputs = [ TestDeep TestException TestWWWMechanizePSGI ];
    propagatedBuildInputs = [ CatalystRuntime Moose MooseXEmulateClassAccessorFast MROCompat namespaceclean ObjectSignature ];
    meta = {
      description = "Generic Session plugin - ties together server side storage and client side state required to maintain session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionDynamicExpiry = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-DynamicExpiry-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "7707c56734cdb1512f733dc400fadf6f4c53cb217b58207857824dad6780a079";
    };
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime MROCompat Moose namespaceautoclean ];
    meta = {
      description = "Per-session custom expiry times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
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
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0x3j6zv3wr41jlwr6yb2jpmcx019ibyn11y8653ffnwhpzbpzsxs";
    };
    propagatedBuildInputs =
      [ PathClass CatalystPluginSession CacheFastMmap MROCompat ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginSessionStoreFile = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-File-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "54738e3ce76f8be8b66947092d28973c73d79d1ee19b5d92b057552f8ff09b4f";
    };
    propagatedBuildInputs = [ CacheCache CatalystPluginSession CatalystRuntime ClassDataInheritable MROCompat ];
    meta = {
      description = "File storage backend for session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-StackTrace-0.12.tar.gz;
      sha256 = "1b2ksz74cpigxqzf63rddar3vfmnbpwpdcbs11v0ml89pb8ar79j";
    };
    propagatedBuildInputs = [ CatalystRuntime DevelStackTrace MROCompat ];
    meta = {
      description = "Display a stack trace on the debug screen";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginStaticSimple = buildPerlPackage rec {
    name = "Catalyst-Plugin-Static-Simple-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "1h8f12bhzh0ssq9gs8r9g3hqn8zn2k0q944vc1vm8j81bns16msy";
    };
    patches = [ ../development/perl-modules/catalyst-plugin-static-simple-etag.patch ];
    propagatedBuildInputs = [ CatalystRuntime MIMETypes Moose MooseXTypes
      namespaceautoclean ];
    meta = {
      description = "Make serving static pages painless";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginStatusMessage = buildPerlPackage rec {
    name = "Catalyst-Plugin-StatusMessage-1.002000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/${name}.tar.gz";
      sha256 = "649c894ab16f9f48ada8f9cc599a7ecbb8891ab3761ff6fd510520c6de407c1f";
    };
    propagatedBuildInputs = [ CatalystRuntime SubName strictures ];
    meta = {
      description = "Handle passing of status messages between screens of a web application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  CatalystViewCSV = buildPerlPackage rec {
    name = "Catalyst-View-CSV-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MC/MCB/${name}.tar.gz";
      sha256 = "e41326b6099891f244b432921ed10096ac619f32b8c4f8b41633313bd54662db";
    };
    buildInputs = [ CatalystActionRenderView CatalystModelDBICSchema CatalystPluginConfigLoader CatalystRuntime CatalystXComponentTraits ConfigGeneral DBDSQLite DBIxClass Moose TestException ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV URI ];
    meta = {
      description = "CSV view class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/${name}.tar.gz";
      sha256 = "1qgq6y9iwfbhbkbgpw9czang2ami6z8jk1zlagrzdisy4igqzkvs";
    };
    buildInputs = [  TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV XMLSimple ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewJSON = buildPerlPackage rec {
    name = "Catalyst-View-JSON-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK//${name}.tar.gz";
      sha256 = "184pyghlrkl7p387bnyvswi2d9myvdg4v3lax6xrd59shskvpmkm";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ CatalystRuntime JSONAny MROCompat YAML ];
    meta = {
      description = "JSON view for your data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewTT = buildPerlPackage rec {
    name = "Catalyst-View-TT-0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "06d1zg4nbb6kcyjbnyxrkf8z4zlscxr8650d94f7187jygfl8rvh";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassAccessor MROCompat PathClass TemplateToolkit TemplateTimer ];
    meta = {
      description = "Template View Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0iq4ci8m6g2c4g01fvdl568y7pjz28f3widk986v3pyhr7ll8j88";
    };
    propagatedBuildInputs =
      [ CatalystRuntime MooseXTraitsPluggable namespaceautoclean ListMoreUtils ];
  };

  CatalystXRoleApplicator = buildPerlPackage rec {
    name = "CatalystX-RoleApplicator-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/${name}.tar.gz";
      sha256 = "0vwaapxn8g5hs2xp63c4dwv9jmapmji4272fakssvgc9frklg3p2";
    };
    buildInputs = [ ];
    propagatedBuildInputs = [ MooseXRelatedClassRoles CatalystRuntime ];
  };

  CatalystTraitForRequestProxyBase = buildPerlPackage {
    name = "Catalyst-TraitFor-Request-ProxyBase-0.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-TraitFor-Request-ProxyBase-0.000005.tar.gz;
      sha256 = "a7bf0faa7e12ca5df625d9f5fc710f11bfd16ba5385837e48d42b3d286c9710a";
    };
    buildInputs = [ CatalystRuntime HTTPMessage ];
    propagatedBuildInputs = [ CatalystXRoleApplicator Moose URI namespaceautoclean ];
    meta = {
      description = "Replace request base with value passed by HTTP proxy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXScriptServerStarman = buildPerlPackage {
    name = "CatalystX-Script-Server-Starman-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/CatalystX-Script-Server-Starman-0.02.tar.gz;
      sha256 = "0h02mpkc4cmi3jpvcd7iw7xyzx55bqvvl1qkf967gqkvpklm0qx5";
    };
    patches = [
      # See Nixpkgs issues #16074 and #17624
      ../development/perl-modules/CatalystXScriptServerStarman-fork-arg.patch
    ];
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime Moose namespaceautoclean Starman ];
    meta = {
      description = "Replace the development server with Starman";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CGI = buildPerlPackage rec {
    name = "CGI-4.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/${name}.tar.gz";
      sha256 = "07gwnlc7vq58fjwmfsrv0hfyirqqdrpjhf89caq34rjrkz2wsd0b";
    };
    buildInputs = [ TestDeep TestWarn ];
    propagatedBuildInputs = [ HTMLParser self."if" ];
    meta = {
      homepage = https://metacpan.org/module/CGI;
      description = "Handle Common Gateway Interface requests and responses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CGICookieXS = buildPerlPackage rec {
    name = "CGI-Cookie-XS-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1iixvnm0l1q24vdlnayb4vd8fns2bdlhm6zb7fpi884ppm5cp6a6";
    };
  };

  CGIEmulatePSGI = buildPerlPackage {
    name = "CGI-Emulate-PSGI-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/CGI-Emulate-PSGI-0.21.tar.gz;
      sha256 = "06b8f1864101de69b2264ad3c3a2b15333e428cf9f5d17a777cfc61f8c64093f";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CGI HTTPMessage ];
    meta = {
      homepage = https://github.com/tokuhirom/p5-cgi-emulate-psgi;
      description = "PSGI adapter for CGI";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIExpand = buildPerlPackage {
    name = "CGI-Expand-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOWMANBS/CGI-Expand-2.04.tar.gz;
      sha256 = "0jk2vvk4mlz7phq3h3wpryix46adi7fkkzvkv0ssn5xkqy3pqlny";
    };
    propagatedBuildInputs = [ TestException ];
    meta = {
      description = "Convert flat hash to nested data using TT2's dot convention";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CGIFast = buildPerlPackage {
    name = "CGI-Fast-2.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEEJO/CGI-Fast-2.10.tar.gz;
      sha256 = "98263afcc9f5d88c7cbbd39651c5431b434c1c815fe284962d887ed7be3a1dd3";
    };
    propagatedBuildInputs = [ FCGI if_ ];
    doCheck = false;
    meta = {
      homepage = https://metacpan.org/module/CGI::Fast;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIFormBuilder = buildPerlPackage rec {
    name = "CGI-FormBuilder-3.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWIGER/${name}.tgz";
      sha256 = "0qx8kxj0iy55ss9kraqr8q2m4igi2ylajff7d6qvphqpfx90fjb5";
    };

    propagatedBuildInputs = [ CGI ];
  };

  CGIPSGI = buildPerlPackage {
    name = "CGI-PSGI-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/CGI-PSGI-0.15.tar.gz;
      sha256 = "c50dcb10bf8486a9843baed032ad89d879ff2f41c993342dead62f947a598d91";
    };
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Adapt CGI.pm to the PSGI protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGISession = buildPerlPackage rec {
    name = "CGI-Session-4.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/${name}.tar.gz";
      sha256 = "1xsl2pz1jrh127pq0b01yffnj4mnp9nvkp88h5mndrscq9hn8xa6";
    };
    buildInputs = [ DBFile ];
    propagatedBuildInputs = [ CGI ];
  };

  CGISimple = buildPerlPackage rec {
    name = "CGI-Simple-1.115";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZABGAB/${name}.tar.gz";
      sha256 = "1nkyb1m1g5r47xykflf68dplanih5p15njv82frbgbsms34kp1sg";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A Simple totally OO CGI interface that is CGI.pm compliant";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIStruct = buildPerlPackage {
    name = "CGI-Struct-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FU/FULLERMD/CGI-Struct-1.21.tar.gz;
      sha256 = "d13d8da7fdcd6d906054e4760fc28a718aec91bd3cf067a58927fb7cb1c09d6c";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Build structures from CGI data";
      license = stdenv.lib.licenses.bsd2;
    };
  };

  CHI = buildPerlPackage rec {
    name = "CHI-0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSWARTZ/${name}.tar.gz";
      sha256 = "c7f1a2b3570a8fede484e933f89ba1729e0abd05935791d146c522dd120ee851";
    };
    buildInputs = [ TestClass TestDeep TestException TestWarn TimeDate ];
    propagatedBuildInputs = [ CarpAssert ClassLoad DataUUID DigestJHash HashMoreUtils JSONMaybeXS ListMoreUtils LogAny Moo MooXTypesMooseLike MooXTypesMooseLikeNumeric StringRewritePrefix TaskWeaken TimeDuration TimeDurationParse TryTiny ];
    meta = {
      description = "Unified cache handling interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.34.tar.gz;
      sha256 = "1z6fqg0yz8gay15r1iasslv8f1n1mzjkrhs47fvbj3rqz36y1cfd";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  ClassAccessorFast = buildPerlPackage {
    name = "Class-Accessor-Fast-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.34.tar.gz;
      sha256 = "1z6fqg0yz8gay15r1iasslv8f1n1mzjkrhs47fvbj3rqz36y1cfd";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ClassAccessorGrouped = buildPerlPackage {
    name = "Class-Accessor-Grouped-0.10012";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/Class-Accessor-Grouped-0.10012.tar.gz;
      sha256 = "c4613ee3307939f47a9afd40e8b173f3a22f501c3b139799aa030f01b627e7fe";
    };
    buildInputs = [ ClassXSAccessor DevelHide PackageStash SubName TestException ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Lets you build groups of accessors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorLite = buildPerlPackage {
    name = "Class-Accessor-Lite-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz;
      sha256 = "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a";
    };
    meta = {
      description = "A minimalistic variant of Class::Accessor";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
    name = "Class-Base-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZABGAB/${name}.tar.gz";
      sha256 = "15mvg1ba0iphjjb90a2fq73hyzcgp8pv0c44pjfcn7vdlzp098z3";
    };
  };

  ClassC3 = buildPerlPackage rec {
    name = "Class-C3-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "0lmgiqv46x9lx8ip23qr8qprips21wiwaks17yb6pk7igvbgdjnc";
    };
    propagatedBuildInputs = [ AlgorithmC3 ];
    meta = {
      description = "A pragma to use the C3 method resolution order algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3AdoptNEXT = buildPerlPackage rec {
    name = "Class-C3-Adopt-NEXT-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1xsbydmiskpa1qbmnf6n39cb83nlb432xgkad9kfhxnvm8jn4rw5";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils MROCompat ];
    meta = {
      homepage = http://search.cpan.org/dist/Class-C3-Adopt-NEXT;
      description = "Make NEXT suck less";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassClassgenclassgen = buildPerlPackage {
    name = "Class-Classgen-classgen-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHLUE/Class-Classgen-classgen-3.03.tar.gz;
      sha256 = "9b65d41b991538992e816b32cc4fa9b4a4a0bb3e9c10e7eebeff82658dbbc8f6";
    };
  };

  ClassContainer = buildPerlPackage {
    name = "Class-Container-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Class-Container-0.12.tar.gz;
      sha256 = "771206f2b7a916ce0dfb93d82200472beaeb910248482734179bf36808e486b1";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Glues object frameworks together transparently";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  ClassFactory = buildPerlPackage {
    name = "Class-Factory-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Class-Factory-1.06.tar.gz;
      sha256 = "c37a2d269eb935f36a23e113480ae0946fa7c12a12781396a1226c8e435f30f5";
    };
  };

  ClassFactoryUtil = buildPerlPackage rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Provide utility methods for factory classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassISA = buildPerlPackage {
    name = "Class-ISA-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-ISA-0.36.tar.gz;
      sha256 = "0r5r574i6wgxm8zsq4bc34d0dzprrh6h6mpp1nhlks1qk97g65l8";
    };
  };

  ClassIterator = buildPerlPackage {
    name = "Class-Iterator-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/Class-Iterator-0.3.tar.gz;
      sha256 = "db1ba87ca9107f161fe9c1e9e7e267c0026defc26fe3e73bcad8ab8ffc18ef9d";
    };
    meta = {
    };
  };

  ClassMakeMethods = buildPerlPackage rec {
    name = "Class-MakeMethods-1.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/${name}.tar.gz";
      sha256 = "10f65j4ywrnwyz0dm1q5ymmpv875drj40mj1xvsjv0bnjinnwzj8";
    };
  };

  ClassMethodMaker = buildPerlPackage rec {
    name = "Class-MethodMaker-2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/${name}.tar.gz";
      sha256 = "0a03i4k3a33qqwhykhz5k437ld5mag2vq52vvsy03gbynb65ivsy";
    };
    # Remove unnecessary, non-autoconf, configure script.
    prePatch = "rm configure";
    meta = {
      description = "A module for creating generic methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodModifiers = buildPerlPackage rec {
    name = "Class-Method-Modifiers-2.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "14nk2gin9cjwpysakli7f0gs4q1w220sn73xzv35rhlspngrggyy";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      homepage = https://github.com/sartak/Class-Method-Modifiers/tree;
      description = "Provides Moose-like method modifiers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMix = buildPerlPackage rec {
    name = "Class-Mix-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "054d0db62df90f22601f2a18fc84e9ca026d81601f5940b2fcc543e39d69b36b";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ ParamsClassify self."if" ];
    meta = {
      description = "Dynamic class mixing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMOP = Moose;

  ClassReturnValue = buildPerlPackage rec {
    name = "Class-ReturnValue-0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/${name}.tar.gz";
      sha256 = "ed3836885d78f734ccd7a98550ec422a616df7c31310c1b7b1f6459f5fb0e4bd";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "A smart return value object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
      sha256 = "0y7ngrjf551bjgmijp5rsidbkq6c8hb5lmy2jcqq0fify020s8iq";
    };
  };

  ClassThrowable = buildPerlPackage rec {
    name = "Class-Throwable-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/${name}.tar.gz";
      sha256 = "1kmwzdxvp9ca2z44vl0ygkfygdbxqkilzjd8vqhc4vdmvbh136nw";
    };
  };

  ClassLoad = buildPerlPackage rec {
    name = "Class-Load-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "13xjfh4fadq4pkq7fcj42b26544jl7gqdg2y3imnra9fwxwsbg7j";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ DataOptList ModuleImplementation ModuleRuntime PackageStash TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A working (require \"Class::Name\") and more";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassLoadXS = buildPerlPackage rec {
    name = "Class-Load-XS-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1aivalms81s3a2cj053ncgnmkpgl7vspna8ajlkqir7rdn8kpv5v";
    };
    buildInputs = [ ModuleImplementation TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "XS implementation of parts of Class::Load";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ClassObservable = buildPerlPackage {
    name = "Class-Observable-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWINTERS/Class-Observable-1.04.tar.gz;
      sha256 = "3ef18733a0f03c113f3bcf8ac50476e09ca1fe6234f4aaacaa24dfca95168094";
    };
    propagatedBuildInputs = [ ClassISA ];
  };

  ClassStd = buildPerlPackage {
    name = "Class-Std-0.013";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz;
      sha256 = "bcd6d82f6c8af0fe069fced7dd165a4795b0b6e92351c7d4e5a1ab9a14fc35c6";
    };
    meta = {
      description = "Support for creating standard 'inside-out' classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassUnload = buildPerlPackage rec {
    name = "Class-Unload-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "1q50hw217kll1vaxp7vz4x84f478ymd4lgz7mhmz8p94l8lxgi5g";
    };
    propagatedBuildInputs = [ ClassInspector ];
  };

  ClassVirtual = buildPerlPackage rec {
    name = "Class-Virtual-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "c6499b42d3b4e5c6488a5e82fbc28698e6c9860165072dddfa6749355a9cfbb2";
    };
    propagatedBuildInputs = [ CarpAssert ClassDataInheritable ClassISA ];
    meta = {
      homepage = https://metacpan.org/release/Class-Virtual;
      description = "Base class for virtual base classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassXSAccessor = buildPerlPackage {
    name = "Class-XSAccessor-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.19.tar.gz;
      sha256 = "1wm6013il899jnm0vn50a7iv9v6r4nqywbqzj0csyf8jbwwnpicr";
    };
    meta = {
      description = "Generate fast XS accessors without runtime compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Clipboard = buildPerlPackage {
    name = "Clipboard-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KI/KING/Clipboard-0.13.tar.gz;
      sha256 = "eebf1c9cb2484be850abdae017147967cf47f8ccd99293771517674b0046ec8a";
    };
    meta = {
      description = "Clipboard - Copy and Paste with any OS";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  Clone = buildPerlPackage rec {
    name = "Clone-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GARU/${name}.tar.gz";
      sha256 = "1s5xrv9zlckqqzyhxi0l9lwj9m6na2bz5hqxrkva2v7gnx5m7c4z";
    };
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CommonSense = buildPerlPackage rec {
    name = "common-sense-3.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "1wxv2s0hbjkrnssvxvsds0k213awg5pgdlrpkr6xkpnimc17s7vp";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  CompressBzip2 = buildPerlPackage {
    name = "Compress-Bzip2-2.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Compress-Bzip2-2.22.tar.gz;
      sha256 = "1603e284e07953415b8eaa132698db8b03f46383f883c0902926f36eecb7e895";
    };
    meta = {
      description = "Interface to Bzip2 compression library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawBzip2 = buildPerlPackage rec {
    name = "Compress-Raw-Bzip2-2.070";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "0rmwpqhnhw5n11gm9mbxrxnardm0jfy7568ln9zw21bq3d7dsmn8";
    };

    # Don't build a private copy of bzip2.
    BUILD_BZIP2 = false;
    BZIP2_LIB = "${pkgs.bzip2.out}/lib";
    BZIP2_INCLUDE = "${pkgs.bzip2.dev}/include";

    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Low-Level Interface to bzip2 compression library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
    name = "Config-Any-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICAS/${name}.tar.gz";
      sha256 = "155521bxiim3dv8d8f69fqd9zxm615fd4pfmv5fki17hq7ai5bpr";
    };
    propagatedBuildInputs = [ ModulePluggable ];
    meta = {
      description = "Load configuration from different file formats, transparently";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigAutoConf = buildPerlPackage rec {
    name = "Config-AutoConf-0.311";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/${name}.tar.gz";
      sha256 = "1zk2xfvxd3yn3299i13vn5wm1c7jxgr7z3h0yh603xs2h9cg79wc";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      description = "A module to implement some of AutoConf macros in pure perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGeneral = buildPerlPackage rec {
    name = "Config-General-2.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TL/TLINDEN/${name}.tar.gz";
      sha256 = "1biqzrvxr9cc8m5jaldnqzmj44q07y4pv6izgb7irsij0rn18m2i";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGitLike = buildPerlPackage {
    name = "Config-GitLike-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Config-GitLike-1.16.tar.gz;
      sha256 = "48c7f7e71405219582a96e5266cbec51c0ff3ec4bf0bb6db1fd12725ee23fe8f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moo MooXTypesMooseLike ];
    meta = {
      description = "Git-compatible config file parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGrammar = buildPerlPackage {
    name = "Config-Grammar-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSCHWEI/Config-Grammar-1.11.tar.gz;
      sha256 = "dd819f89b19c51e9fac6965360cd9db54436e1328968c802416ac34188ca65ee";
    };
    meta = {
      description = "A grammar-based, user-friendly config parser";
      license = "unknown";
    };
  };

  ConfigINI = buildPerlPackage rec {
    name = "Config-INI-0.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "628bf76d5b91f89dde22d4813ec033026ebf71b772bb61ccda909da00c869732";
    };
    propagatedBuildInputs = [ MixinLinewise ];
    meta = {
      homepage = https://github.com/rjbs/Config-INI;
      description = "Simple .ini-file format";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ConfigMerge = buildPerlPackage {
    name = "Config-Merge-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DRTECH/Config-Merge-1.04.tar.gz;
      sha256 = "a932477b43ae5fb04a16f071a891da7bd2086c10c680592f2888fa9d9972cccf";
    };
    buildInputs = [ ConfigAny YAML ];
    propagatedBuildInputs = [ ConfigAny ];
    meta = {
      description = "Load a configuration directory tree containing YAML, JSON, XML, Perl, INI or Config::General files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigMVP = buildPerlPackage {
    name = "Config-MVP-2.200010";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-2.200010.tar.gz;
      sha256 = "bfb5870452a12ead4d3fd485045d1fa92b2a11741c3b93b61eb43f3dcbd6099b";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassLoad ModulePluggable Moose MooseXOneArgNew ParamsUtil RoleHasMessage RoleIdentifiable Throwable TieIxHash TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP;
      description = "Multivalue-property package-oriented configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ConfigMVPReaderINI = buildPerlPackage rec {
    name = "Config-MVP-Reader-INI-2.101463";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0iflnsh0sgihff3ra8sr7awiiscmqvrp1anaskkwksqi6yzidab9";
    };
    propagatedBuildInputs = [ ConfigINI ConfigMVP Moose ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP-Reader-INI;
      description = "An MVP config reader for .ini files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigStd = buildPerlPackage {
    name = "Config-Std-0.901";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICKER/Config-Std-0.901.tar.gz;
      sha256 = "c5c57eb82a37cc41ea152098fc8e5548acfea8861140fbac8fc3beccbb09c243";
    };
    propagatedBuildInputs = [ ClassStd ];
    meta = {
      description = "Load and save configuration files in a standard format";
    };
  };

  ConfigTiny = buildPerlPackage rec {
    name = "Config-Tiny-2.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "037524cpx962cjdgcp1m8sd30s43g3zvwfn4hmjvq322xpind2ls";
    };
  };

  ConfigVersioned = buildPerlPackage {
    name = "Config-Versioned-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSCOTTY/Config-Versioned-1.01.tar.gz;
      sha256 = "bc9a4ae3738bd89f86a07bca673627ca3c92ba969737cd6dbc7ab7ad17cd2348";
    };
    buildInputs = [ DateTime PathClass ];
    propagatedBuildInputs = [ ConfigStd GitPurePerl Moose ];
    doCheck = false;
    meta = {
      description = "Simple, versioned access to configuration data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Connector = buildPerlPackage rec {
    name = "Connector-1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/${name}.tar.gz";
      sha256 = "0rbx4n86y5sdkff37w8djw1ahxrg79bsfgbrph3kjhh4jzd20q09";
    };
    buildInputs = [ Moose ConfigStd YAML PathClass DateTime Log4Perl
      ConfigVersioned TemplateToolkit];
  };

  ConvertASN1 = buildPerlPackage rec {
    name = "Convert-ASN1-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "12nmsca6hzgxq57sx7dp8yq6zxqhl41z5a6018877sf5w25ag93l";
    };
  };

  ConvertColor = buildPerlPackage {
    name = "Convert-Color-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Convert-Color-0.11.tar.gz;
      sha256 = "b41217c72931034ba4417d7a9e1e2999f04580d4e6b31c70993fedccc2440d38";
    };
    buildInputs = [ TestNumberDelta ];
    propagatedBuildInputs = [ ListUtilsBy ModulePluggable ];
    meta = {
      description = "Color space conversions and named lookups";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  constant = buildPerlPackage rec {
    name = "constant-1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "015my616h5l2fswh52x4dp3n007gk5lax83ww9q6cmzb610mv5kr";
    };
  };

  constantboolean = buildPerlPackage {
    name = "constant-boolean-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/constant-boolean-0.02.tar.gz;
      sha256 = "1s8gxfg4xqp543aqanv5lbp64vqqyw6ic4x3fm4imkk1h3amjb6d";
    };
    propagatedBuildInputs = [ SymbolUtil ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  constantdefer = pkgs.perlPackages.constant-defer;

  constant-defer = buildPerlPackage rec {
    name = "constant-defer-6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "1ykgk0rd05p7kyrdxbv047fj7r0b4ix9ibpkzxp6h8nak0qjc8bv";
    };
  };

  ContextPreserve = buildPerlPackage rec {
    name = "Context-Preserve-0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/${name}.tar.gz";
      sha256 = "0gssillawjknqks81x7fg7w2x94bnyklgd8ry2pr1k6ifkjhwz46";
    };
    buildInputs = [ TestException Testuseok ];
  };

  CookieBaker = buildPerlModule rec {
    name = "Cookie-Baker-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "4b1fb173d6977af902fa018242a0b28099e5612a2fa43e0160380781f5d76ea0";
    };
    buildInputs = [ ModuleBuild TestTime ];
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://github.com/kazeburo/Cookie-Baker;
      description = "Cookie string generator / parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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

  CPAN = buildPerlPackage rec {
    name = "CPAN-2.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "090e9e3d9fca83b89341a75c514c7411b743c887743723dbfe80f30d4ee5f3ad";
    };
    propagatedBuildInputs = [ ArchiveZip CompressBzip2 Expect FileHomeDir FileWhich JSONPP LWP ModuleBuild ModuleSignature TermReadKey TextGlob YAML YAMLLibYAML YAMLSyck ];
    meta = {
      description = "Query, download and build perl modules from CPAN sites";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANChanges = buildPerlPackage rec {
    name = "CPAN-Changes-0.400002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "01eedea90d07468cb58e4a50bfa3bb1d4eeda9073596add1118fc359153abe8d";
    };
    meta = {
      description = "Read and write Changes files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  CPANMeta = buildPerlPackage rec {
    name = "CPAN-Meta-2.150005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "04g7cfbx7vi8kqc9pwv7n3z95vimkbv0h7v6p1ky37gzz3nsw66j";
    };
    propagatedBuildInputs = [ ParseCPANMeta CPANMetaYAML CPANMetaRequirements JSONPP ];
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/CPAN-Meta;
      description = "The distribution metadata for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaCheck = buildPerlPackage rec {
    name = "CPAN-Meta-Check-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "1rymh4l6sdh8l1q2q25lncmi4afbh2il0bpk8gxmd13qmjidjk2b";
    };
    buildInputs = [ TestDeep ModuleMetadata ];
    propagatedBuildInputs = [ CPANMeta CPANMetaRequirements ];
    meta = {
      description = "Verify requirements in a CPAN::Meta object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaRequirements = buildPerlPackage {
    name = "CPAN-Meta-Requirements-2.128";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.128.tar.gz;
      sha256 = "ff0ae309ed76d8c7381fdb8436659a594e6884eeac1c9a742ba9aa7ee2a1d52d";
    };
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-Requirements;
      description = "A set of version requirements for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaYAML = buildPerlPackage rec {
    name = "CPAN-Meta-YAML-0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "195v3lrfjzqxfiqi1zp02xmhp6mg9y3p7abmlfk2nj1rb28p0yrl";
    };
    buildInputs = [ JSONPP ];
    doCheck = true;
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-YAML;
      description = "Read and write a subset of YAML for CPAN Meta files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPerlReleases = buildPerlPackage rec {
    name = "CPAN-Perl-Releases-2.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "092nr3x2bs0lb3k8vk0mkghqzcw05s0gyyvfnmvx4fwwza8kya85";
    };
    meta = {
      homepage = https://github.com/bingos/cpan-perl-releases;
      description = "Mapping Perl releases on CPAN to the location of the tarballs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPLUS = buildPerlPackage rec {
    name = "CPANPLUS-0.9154";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "1mz20qlk0wjl4mwi4b9nji4hyh9a0l7m1v5bmypwwmhzpac5rq5c";
    };
    propagatedBuildInputs = [ ArchiveExtract LogMessage ModulePluggable ObjectAccessor PackageConstants ];
    doCheck = false;
    meta = {
      homepage = http://github.com/jib/cpanplus-devel;
      description = "Ameliorated interface to the CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANUploader = buildPerlPackage rec {
    name = "CPAN-Uploader-0.103010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1n57d61q9g37s0pp7sriq8vvqj2cvp3s9v0grpv277s9idvm37x8";
    };
    propagatedBuildInputs = [ FileHomeDir GetoptLongDescriptive HTTPMessage LWP LWPProtocolhttps TermReadKey ];
    meta = {
      homepage = https://github.com/rjbs/cpan-uploader;
      description = "Upload things to the CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptBlowfish = buildPerlPackage rec {
    name = "Crypt-Blowfish-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1cb7g8cyfs9alrfdykxhs8m6azj091fmcycz6p5vkxbbzcgl7cs6";
    };
  };

  CryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0ig698lmpjz7fslnznxm0609lvlnvf4f3s370082nzycnqhxww3a";
    };
  };

  CryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1rypxlhpd1jc0c327aghgl9y6ls47drmpvn0a40b4k3vhfsypc9d";
    };
    buildInputs = [CryptCBC];
  };

  CryptDH = buildPerlPackage rec {
    name = "Crypt-DH-0.07";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/M/MI/MITHALDU/${name}.tar.gz";
      sha256 = "0pvzlgwpx8fzdy64ki15155vhsj30i9zxmw6i4p7irh17d1g7368";
    };
    buildInputs = [ MathBigInt MathBigIntGMP ];
  };

  CryptDHGMP = buildPerlPackage rec {
    name = "Crypt-DH-GMP-0.00012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/${name}.tar.gz";
      sha256 = "0f5gdprcql4kwzgxl2s6ngcfg1jl45lzcqh7dkv5bkwlwmxa9rsi";
    };
    buildInputs = [ DevelChecklib TestRequires pkgs.gmp ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
  };

  CryptEksblowfish = buildPerlPackage rec {
    name = "Crypt-Eksblowfish-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3cc7126d5841107237a9be2dc5c7fbc167cf3c4b4ce34678a8448b850757014c";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ClassMix];
  };

  CryptJWT = buildPerlPackage rec {
    name = "Crypt-JWT-0.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/${name}.tar.gz";
      sha256 = "90e78f7f0ced17e5c2080ad8c7008ce3badd05186e2ff20cf9c7232ed863cdaf";
    };
    propagatedBuildInputs = [ CryptX JSONMaybeXS ];
    meta = {
      description = "JSON Web Token";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPasswdMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Crypt-PasswdMD5-1.40.tgz;
      sha256 = "0j0r74f18nk63phddzqbf7wqma2ci4p4bxvrwrxsy0aklbp6lzdp";
    };
  };

  CryptPKCS10 = buildPerlPackage {
    name = "Crypt-PKCS10-1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GK/GKNOCKE/Crypt-PKCS10-1.0.zip;
      sha256 = "08de199411056df1a1e6374b503574d21089913daa3823ebb21aa399dc59bdb6";
    };
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRandomSource = buildPerlPackage {
    name = "Crypt-Random-Source-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Crypt-Random-Source-0.07.tar.gz;
      sha256 = "0kxcqcpknh9hhfnpiymxrjg74yj7nfr7k4fgrfmd9s2cw9p9mqdv";
    };
    buildInputs = [ Testuseok TestException ];
    propagatedBuildInputs = [ AnyMoose CaptureTiny ModuleFind namespaceclean SubExporter ];
    meta = {
      homepage = http://search.cpan.org/dist/Crypt-Random-Source;
      description = "Get weak or strong random data from pluggable sources";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CryptRC4 = buildPerlPackage rec {
    name = "Crypt-RC4-2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIFUKURT/${name}.tar.gz";
      sha256 = "1sp099cws0q225h6j4y68hmfd1lnv5877gihjs40f8n2ddf45i2y";
    };
  };

  CryptRandPasswd = buildPerlPackage {
    name = "Crypt-RandPasswd-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Crypt-RandPasswd-0.06.tar.gz;
      sha256 = "0ca8544371wp4vvqsa19lnhl02hczpkbwkgsgm65ziwwim3r1gdi";
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
    name = "Crypt-Rijndael-1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "0ki16vkgzvzyjdx6mmvjfpngyvhf7cis46pymy6dr8z0vyk0jwnd";
    };
  };

  CryptUnixCryptXS = buildPerlPackage rec {
    name = "Crypt-UnixCrypt_XS-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "1d3xamq2mm3v2bfb1ay66crljm0bigfbhay1fqglcsrb75b7ls7r";
    };
  };

  CryptSmbHash = buildPerlPackage rec {
    name = "Crypt-SmbHash-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
      sha256 = "0dxivcqmabkhpz5xzph6rzl8fvq9xjy26b2ci77pv5gsmdzari38";
    };
  };

  CryptOpenSSLAES = buildPerlPackage rec {
    name = "Crypt-OpenSSL-AES-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TT/TTAR/${name}.tar.gz";
      sha256 = "b66fab514edf97fc32f58da257582704a210c2b35e297d5c31b7fa2ffd08e908";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
    meta = with stdenv.lib; {
      homepage = https://metacpan.org/release/Crypt-OpenSSL-AES;
      description = "Perl wrapper around OpenSSL's AES library";
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
      platforms = platforms.unix;
    };
  };

  CryptOpenSSLBignum = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Bignum-0.04";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/I/IR/IROBERTS/${name}.tar.gz";
      sha256 = "18vg2bqyhc0ahfdh5dkbgph5nh92qcz5vi99jq8aam4h86if78bk";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptOpenSSLRandom = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Random-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "0yjcabkibrkafywvdkmd1xpi6br48skyk3l15ni176wvlg38335v";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptOpenSSLRSA = buildPerlPackage rec {
    name = "Crypt-OpenSSL-RSA-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "5357f977464bb3a8184cf2d3341851a10d5515b4b2b0dfb88bf78995c0ded7be";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl.out}/lib -lcrypto";
  };

  CryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NANIS/${name}.tar.gz";
      sha256 = "1s7zm6ph37kg8jzaxnhi4ff4snxl7mi5h14arxbri0kp6s0lzlzm";
    };
    makeMakerFlags = "--libpath=${pkgs.openssl.out}/lib --incpath=${pkgs.openssl.dev}/include";
    buildInputs = [ PathClass TryTiny ];
  };

  CSSDOM = buildPerlPackage rec {
    name = "CSS-DOM-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPROUT/${name}.tar.gz";
      sha256 = "0s1gg6jvcxlj87sbbbcn9riw7rrh2n85hkbaim9civki8vj8vg9z";
    };

    buildInputs = [ Clone ];
  };

  CSSMinifierXP = buildPerlPackage rec {
    name = "CSS-Minifier-XS-0.09";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/G/GT/GTERMARS/CSS-Minifier-XS-0.09.tar.gz";
      sha256 = "1myswrmh0sqp5xjpp03x45z8arfmgkjx0srl3r6kjsyzl1zrk9l8";
    };
    meta = {
      description = "XS based CSS minifier";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CSSSquish = buildPerlPackage {
    name = "CSS-Squish-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/CSS-Squish-0.10.tar.gz;
      sha256 = "65fc0d69acd1fa33d9a4c3b09cce0fbd737d747b1fcc4e9d87ebd91050cbcb4e";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Compact many CSS files into one big file";
      license = "unknown";
    };
  };

  Curses = let version = "1.33"; in buildPerlPackage {
    name = "Curses-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GI/GIRAFFED/Curses-${version}.tar.gz";
      sha256 = "126fhcyb822vqhszdrr7nmhrnshf06076shxdr7la0fwqzsfn7zb";
    };
    propagatedBuildInputs = [ pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lncurses";
    meta = {
      inherit version;
      description = "Perl bindings to ncurses";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  CryptX = buildPerlPackage rec {
    name = "CryptX-0.044";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/${name}.tar.gz";
      sha256 = "15e5e6bd7b90af24c7e730751fec7b10d8e22ef4380d527bda242dee7dd20443";
    };
    propagatedBuildInputs = [ JSONMaybeXS ];
    meta = {
      description = "Crypto toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  CwdGuard = buildPerlModule rec {
    name = "Cwd-Guard-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "071k50n1yr48122jjjg50i1s2kwp06dmrisv35f3wjry8m6cqchm";
    };
    meta = {
      description = "Temporary changing working directory (chdir)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataClone = buildPerlPackage {
    name = "Data-Clone-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/Data-Clone-0.003.tar.gz;
      sha256 = "16ldkjfag4dc3gssj051j212rzr2mawy7d001jflcab9g8hg3f1g";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Polymorphic data cloning";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataCompare = buildPerlPackage rec {
    name = "Data-Compare-1.2102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/${name}.tar.gz";
      sha256 = "0v1997gnq3gpcr7f64jmyay2l60s5z6gsiy5hbpn1p2l2hrfnwlj";
    };
    propagatedBuildInputs = [ FileFindRule ];
  };

  DataDump = buildPerlPackage rec {
    name = "Data-Dump-1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "0r9ba52b7p8nnn6nw0ygm06lygi8g68piri78jmlqyrqy5gb0lxg";
    };
    meta = {
      description = "Pretty printing of data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDumper = buildPerlPackage {
    name = "Data-Dumper-2.154";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Data-Dumper-2.154.tar.gz;
      sha256 = "e30fcb6dea290cda85b67fc46d227a2ea890a8bd36c213557adec9c99ebd212f";
    };
  };

  DataDumperConcise = buildPerlPackage rec {
    name = "Data-Dumper-Concise-2.022";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0z7vxgk1f2kw2zpiimdsyf7jq9f4s5dhh3dlimq5yrirypnk03sc";
    };
  };

  DataEntropy = buildPerlPackage rec {
    name = "Data-Entropy-0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "2611c4a1a3038594d79ea4ed14d9e15a9af8f77105f51667795fe4f8a53427e4";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ParamsClassify DataFloat CryptRijndael HTTPLite];
  };

  DataFloat = buildPerlPackage rec {
    name = "Data-Float-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "698ecb092a3284e260cd3c3208408feb791d7d0f06a02673f9125ab2d51cc2d8";
    };
    buildInputs = [ ModuleBuild ];
  };

  DataFormValidator = buildPerlPackage rec {
    name = "Data-FormValidator-4.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DF/DFARRELL/${name}.tar.gz";
      sha256 = "809f15d05434ff5667c3967e71e86308fcfad8fce1057420bd2714300b2a5870";
    };
    propagatedBuildInputs = [ DateCalc EmailValid FileMMagic ImageSize MIMETypes RegexpCommon ];
    meta = {
      description = "Validates user input (usually from an HTML form) based on input profile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataGUID = buildPerlPackage {
    name = "Data-GUID-0.048";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-GUID-0.048.tar.gz;
      sha256 = "cb263b1e6eeecc5797de6f945d42ace2db26c156172883550b73fa2ecdab29dc";
    };
    propagatedBuildInputs = [ DataUUID SubExporter SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/Data-GUID;
      description = "Globally unique identifiers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataHexDump = buildPerlPackage {
    name = "Data-HexDump-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FT/FTASSIN/Data-HexDump-0.02.tar.gz;
      sha256 = "1a9d843e7f667c1c6f77c67af5d77e7462ff23b41937cb17454d03535cd9be70";
    };
    meta = {
      description = "Hexadecimal Dumper";
      maintainers = with stdenv.lib.maintainers; [ AndersonTorres ];
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

  DataICal = buildPerlPackage {
    name = "Data-ICal-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Data-ICal-0.22.tar.gz;
      sha256 = "8ae9d20af244e5a6f606c7325e9d145dd0002676a178357af860a5e156925720";
    };
    buildInputs = [ TestLongString TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassReturnValue TextvFileasData ];
    meta = {
      description = "Generates iCalendar (RFC 2445) calendar files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataInteger = buildPerlPackage rec {
    name = "Data-Integer-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "1dk04jf78sv63lww1qzagxlywcc04cfd3cfvzz168d24db9cr5bz";
    };
    buildInputs = [ ModuleBuild ];
  };

  DataOptList = buildPerlPackage {
    name = "Data-OptList-0.109";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-OptList-0.109.tar.gz;
      sha256 = "1j44rm2spprlq3bc80cxni3dzs3gfjiqv1qc9q7820n1qj0wgmqw";
    };
    propagatedBuildInputs = [ ParamsUtil SubInstall ];
    meta = {
      homepage = http://github.com/rjbs/data-optlist;
      description = "Parse and validate simple name/value option pairs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPage = buildPerlPackage {
    name = "Data-Page-2.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.02.tar.gz;
      sha256 = "1hvi92c4h2angryc6pngw7gbm3ysc2jfmyxk2wh9ia4vdwpbs554";
    };
    propagatedBuildInputs = [TestException ClassAccessorChained];
  };

  DataPagePageset = buildPerlPackage rec {
    name = "Data-Page-Pageset-1.02";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/C/CH/CHUNZI/Data-Page-Pageset-1.02.tar.gz";
      sha256 = "142isi8la383dbjxj7lfgcbmmrpzwckcc4wma6rdl8ryajsipb6f";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ DataPage ];
    meta = {
      description = "change long page list to be shorter and well navigate";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPassword = buildPerlPackage {
    name = "Data-Password-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz;
      sha256 = "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961";
    };
  };

  DataPerl = buildPerlPackage rec {
    name = "Data-Perl-0.002009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTP/${name}.tar.gz";
      sha256 = "b62b2225870c2c3b16fb78c429f8729ddb8ed0e342f4209ec3c261b764c36f8b";
    };
    buildInputs = [ TestDeep TestFatal TestOutput ];
    propagatedBuildInputs = [ ClassMethodModifiers ListMoreUtils ModuleRuntime RoleTiny strictures ];
    meta = {
      homepage = https://github.com/mattp-/Data-Perl;
      description = "Base classes wrapping fundamental Perl data types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSection = buildPerlPackage rec {
    name = "Data-Section-0.200006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0psvsfn5q9y1qkzkq62dr1c6bfrckkkz8hr1sgkdn2mbkpwh319l";
    };
    propagatedBuildInputs = [ MROCompat SubExporter TestFailWarnings ];
    meta = {
      homepage = https://github.com/rjbs/data-section;
      description = "Read multiple hunks of data out of your DATA section";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSerializer = buildPerlPackage {
    name = "Data-Serializer-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEELY/Data-Serializer-0.60.tar.gz;
      sha256 = "0ca4s811l7f2bqkx7vnyxbpp4f0qska89g2pvsfb3k0bhhbk0jdk";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Modules that serialize data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSpreadPagination = buildPerlPackage {
    name = "Data-SpreadPagination-0.1.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KN/KNEW/Data-SpreadPagination-0.1.2.tar.gz;
      sha256 = "74ebfd847132c38cc9e835e14e82c43f1809a95cbc98bb84d1f7ce2e4ef487e3";
    };
    propagatedBuildInputs = [ DataPage MathRound ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStreamBulk = buildPerlPackage {
    name = "Data-Stream-Bulk-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Data-Stream-Bulk-0.11.tar.gz;
      sha256 = "06e08432a6b97705606c925709b99129ad926516e477d58e4461e4b3d9f30917";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose PathClass SubExporter namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/Data-Stream-Bulk;
      description = "N at a time iteration API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataTaxi = buildPerlPackage {
    name = "Data-Taxi-0.96";
    propagatedBuildInputs = [DebugShowStuff];
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Data-Taxi-0.96.tar.gz;
      sha256 = "0y4wls4jlwd6prvd77szymddhq9sfj06kaqnk4frlvd0zh83djxb";
    };
  };

  DataUniqid = buildPerlPackage rec {
    name = "Data-Uniqid-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MW/MWX/${name}.tar.gz";
      sha256 = "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb";
    };
  };

  DataURIEncode = buildPerlPackage rec {
    name = "Data-URIEncode-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "51c9efbf8423853616eaa24841e4d1996b2db0036900617fb1dbc76c75a1f360";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataUUID = buildPerlPackage rec {
    name = "Data-UUID-1.220";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0q7rfi7firwcvkhh9bym3c56hlm63badfli27m77139lwh33nlwr";
    };
  };

  DataUUIDMT = buildPerlPackage {
    name = "Data-UUID-MT-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz;
      sha256 = "0bb7qibq1c5lhaihxa1sck9pb744p8c7172jgx5zh4c32ac4nk1h";
    };
    buildInputs = [ ListAllUtils ];
    propagatedBuildInputs = [ MathRandomMTAuto ];
    meta = {
      homepage = https://metacpan.org/release/Data-UUID-MT;
      description = "Fast random UUID generator using the Mersenne Twister algorithm";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataValidateDomain = buildPerlPackage rec {
    name = "Data-Validate-Domain-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "4470f253b8d2720a4dd3fa3ae550995417c2269f3be7ff030e01afa04a3a9421";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ NetDomainTLD ];
    meta = {
      homepage = http://metacpan.org/release/Data-Validate-Domain;
      description = "Domain and host name validation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataValidateIP = buildPerlPackage rec {
    name = "Data-Validate-IP-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "e1aa92235dcb9c6fd9b6c8cda184d1af73537cc77f4f83a0f88207a8bfbfb7d6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ NetAddrIP ];
    meta = {
      homepage = http://metacpan.org/release/Data-Validate-IP;
      description = "IPv4 and IPv6 validation methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataValidateURI = buildPerlPackage rec {
    name = "Data-Validate-URI-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SO/SONNEN/${name}.tar.gz";
      sha256 = "f06418d2a4603913d1b6ce52b167dd13e787e13bf2be325a065df7d408f79c60";
    };
    propagatedBuildInputs = [ DataValidateDomain DataValidateIP ];
    meta = {
      description = "Common URL validation methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DataVisitor = buildPerlPackage rec {
    name = "Data-Visitor-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0m7d1505af9z2hj5aw020grcmjjlvnkjpvjam457d7k5qfy4m8lf";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs =
      [ ClassLoad Moose TaskWeaken TieToObject namespaceclean ];
  };

  DateCalc = buildPerlPackage {
    name = "Date-Calc-6.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.3.tar.gz;
      sha256 = "14yvbgy9n8icwlm5zi86lskvxd6nsl42i1g9f5dwdaw9my463diy";
    };
    propagatedBuildInputs = [CarpClan BitVector];
    doCheck = false; # some of the checks rely on the year being <2015
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateExtract = buildPerlPackage {
    name = "Date-Extract-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHARYANTO/Date-Extract-0.05.tar.gz;
      sha256 = "ef866b4d596e976a6f4e4b266a6ad7fe4513fad9ae761d7a9ef66f672695fe6d";
    };
    buildInputs = [TestMockTime];
    propagatedBuildInputs = [DateTimeFormatNatural ClassDataInheritable];
  };

  DateManip = buildPerlPackage rec {
    name = "Date-Manip-6.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/${name}.tar.gz";
      sha256 = "0afvr2q2hspd807d6wd7kmrr7ypxdlh8bcnqsqbfwcwd74qadg13";
    };
    # for some reason, parsing /etc/localtime does not work anymore - make sure that the fallback "/bin/date +%Z" will work
    patchPhase = ''
      sed -i "s#/bin/date#${pkgs.coreutils}/bin/date#" lib/Date/Manip/TZ.pm
    '';
    propagatedBuildInputs = [ TestInter ];
    meta = {
      description = "Date manipulation routines";
    };
  };

  DateSimple = buildPerlPackage {
    name = "Date-Simple-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz;
      sha256 = "29a1926314ce1681a312d6155c29590c771ddacf91b7485873ce449ef209dd04";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  DateTime = buildPerlModule rec {
    name = "DateTime-1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1cgnscbh40f783znpq15rkvbfflfm8azdl0v6yqr7minmq6899d3";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone ParamsValidate TryTiny ];
    meta = {
      description = "A date and time object";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeEventICal = buildPerlPackage rec {
    name = "DateTime-Event-ICal-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/${name}.tar.gz";
      sha256 = "1skmykxbrf98ldi72d5s1v6228gfdr5iy4y0gpl0xwswxy247njk";
    };
    propagatedBuildInputs = [ DateTime DateTimeEventRecurrence ];
    meta = {
      description = "DateTime rfc2445 recurrences";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeEventRecurrence = buildPerlPackage {
    name = "DateTime-Event-Recurrence-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-Recurrence-0.16.tar.gz;
      sha256 = "3872e0126cd9527a918d3e537f85342d1fbb1e6a9ae5833262201b31879f8609";
    };
    propagatedBuildInputs = [ DateTime DateTimeSet ];
  };

  DateTimeFormatBuilder = buildPerlPackage {
    name = "DateTime-Format-Builder-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.81.tar.gz;
      sha256 = "7cd58a8cb53bf698407cc992f89e4d49bf3dc55baf4f3f00f1def63a0fff33ef";
    };
    propagatedBuildInputs = [ ClassFactoryUtil DateTime DateTimeFormatStrptime ParamsValidate ];
    meta = {
      description = "Create DateTime parser classes and objects";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeFormatDateParse = buildPerlPackage {
    name = "DateTime-Format-DateParse-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz;
      sha256 = "f6eca4c8be66ce9992ee150932f8fcf07809fd3d1664caf200b8a5fd3a7e5ebc";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ DateTime DateTimeTimeZone TimeDate ];
    meta = {
      description = "Parses Date::Parse compatible formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatFlexible = buildPerlPackage {
    name = "DateTime-Format-Flexible-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THINC/DateTime-Format-Flexible-0.26.tar.gz;
      sha256 = "436efbc5e87cc385112e1c44336427fea32df670caf2b7d6dbb7a113ac6e693d";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder DateTimeTimeZone ListMoreUtils ModulePluggable TestMockTime ];
    meta = {
      description = "Flexibly parse strings and turn them into DateTime objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatHTTP = buildPerlPackage rec {
    name = "DateTime-Format-HTTP-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CK/CKRAS/${name}.tar.gz";
      sha256 = "0h6qqdg1yzqkdxp7hqlp0qa7d1y64nilgimxs79dys2ryjfpcknh";
    };
    propagatedBuildInputs = [ DateTime HTTPDate ];
    meta = {
      description = "Date conversion routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatICal = buildPerlPackage {
    name = "DateTime-Format-ICal-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ICal-0.09.tar.gz;
      sha256 = "8b09f6539f5e9c0df0e6135031699ed4ef9eef8165fc80aefeecc817ef997c33";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ DateTime DateTimeEventICal DateTimeSet DateTimeTimeZone ];
    meta = {
      description = "Parse and format iCal datetime and duration strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatISO8601 = buildPerlPackage {
    name = "DateTime-Format-ISO8601-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-ISO8601-0.08.tar.gz;
      sha256 = "1syccqd5jlwms8v78ksnf68xijzl97jky5vbwhnyhxi5gvgfx8xk";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder ModuleBuild ];
    meta = {
      description = "Parses ISO8601 formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateTimeFormatMail = buildPerlPackage {
    name = "DateTime-Format-Mail-0.402";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOOK/DateTime-Format-Mail-0.402.tar.gz;
      sha256 = "d788c883969e1647ed0524cc130d897276de23eaa3261f3616458ddd3a4a88fb";
    };
    propagatedBuildInputs = [ DateTime ParamsValidate ];
    meta = {
      description = "Convert between DateTime and RFC2822/822 formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatNatural = buildPerlPackage {
    name = "DateTime-Format-Natural-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SC/SCHUBIGER/DateTime-Format-Natural-1.03.tar.gz;
      sha256 = "1m3bmv90kww8xr4dda75isvzigy8y3clgvk58zp0bxc5d7k4qdxi";
    };
    buildInputs = [ ModuleUtil TestMockTime ];
    propagatedBuildInputs = [ Clone DateTime DateTimeTimeZone ListMoreUtils ParamsValidate boolean ];
    meta = {
      description = "Create machine readable date/time with natural parsing logic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatMySQL = buildPerlPackage rec {
    name = "DateTime-Format-MySQL-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XM/XMIKEW/${name}.tar.gz";
      sha256 = "07cgz60gxvrv7xqvngyll60pa8cx93h3jyx9kc9wdkn95qbd864q";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder ModuleBuild ];
    meta = {
      description = "Parse and format MySQL dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DateTimeFormatPg = buildPerlPackage {
    name = "DateTime-Format-Pg-0.16008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMAKI/DateTime-Format-Pg-0.16008.tar.gz;
      sha256 = "0mvh4wp54vh7mnhfd2lndzjfikjify98vaav6vwbraxlhjvwyn3x";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder DateTimeTimeZone ];
    meta = {
      description = "Parse and format PostgreSQL dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateTimeFormatStrptime = buildPerlPackage rec {
    name = "DateTime-Format-Strptime-1.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "d0f97e282b4de61390b5c3a498d3b9ee553f728c169c0845c6de02102d823929";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTime DateTimeLocale DateTimeTimeZone PackageDeprecationManager ParamsValidate TryTiny ];
    meta = {
      homepage = http://metacpan.org/release/DateTime-Format-Strptime;
      description = "Parse and format strp and strf time patterns";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeFormatSQLite = buildPerlPackage rec {
    name = "DateTime-Format-SQLite-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/${name}.tar.gz";
      sha256 = "cc1f4e0ae1d39b0d4c3dddccfd7423c77c67a70950c4b5ecabf8ca553ab294b4";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format SQLite dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatW3CDTF = buildPerlPackage {
    name = "DateTime-Format-W3CDTF-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GW/GWILLIAMS/DateTime-Format-W3CDTF-0.06.tar.gz;
      sha256 = "b9a542bed9c52b0a89dd590a5184e38ee334c824bbe6bac842dd7dd1f88fbd7a";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      homepage = http://search.cpan.org/dist/DateTime-Format-W3CDTF/;
      description = "Parse and format W3CDTF datetime strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "3100568a62a91ca1c09c0aac8e1e4ba34e6f82047ec64f714733a647c040f511";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires TestWarnings ];
    propagatedBuildInputs = [ DistCheckConflicts ListMoreUtils ParamsValidate ];
    meta = {
      homepage = http://metacpan.org/release/DateTime-Locale;
      description = "Localization support for DateTime.pm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeSet = buildPerlPackage rec {
    name = "DateTime-Set-0.3600";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/${name}.tar.gz";
      sha256 = "83503960c773efadfe2b0255e61bc1eb531bb6f497463d3b3880d7a516bc2f13";
    };
    propagatedBuildInputs = [ DateTime SetInfinite ];
    meta = {
      description = "DateTime set objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-1.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "68a5f4b0a77074f9cc96b2c1d2282e2110db74f55e43fbad72926cee0fd434c8";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassSingleton ListAllUtils ModuleRuntime ParamsValidate TryTiny ];
    meta = {
      homepage = http://metacpan.org/release/DateTime-TimeZone;
      description = "Time zone object base class and factory";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeXEasy = buildPerlPackage {
    name = "DateTimeX-Easy-0.089";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/DateTimeX-Easy-0.089.tar.gz;
      sha256 = "17e6d202e7ac6049523048e97bb8f195e3c79208570da1504f4313584e487a79";
    };
    buildInputs = [ TestMost ModuleBuild ];
    propagatedBuildInputs = [ DateTime DateTimeFormatFlexible DateTimeFormatICal DateTimeFormatNatural TimeDate ];
    doCheck = false;
    meta = {
      description = "Parse a date/time string using the best method available";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DebugShowStuff = buildPerlPackage {
    name = "Debug-ShowStuff-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Debug-ShowStuff-1.16.tar.gz;
      sha256 = "1drcrnji3yrd0s3xb69bxnqa51s19c13w68vhvjad3nvswn5vpd4";
    };
    propagatedBuildInputs = [ ClassISA DevelStackTrace StringUtil TermReadKey TextTabularDisplay TieIxHash ];
    meta = {
      description = "A collection of handy debugging routines for displaying the values of variables with a minimum of coding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelChecklib = buildPerlPackage rec {
    name = "Devel-CheckLib-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/${name}.tar.gz";
      sha256 = "0qs7c8jffar2rpvscrd8rcds75zsc46cizp5fi5369821jl4fw3a";
    };
    propagatedBuildInputs = [ IOCaptureOutput ];
  };

  DevelCheckOS = buildPerlPackage rec {
    name = "Devel-CheckOS-1.76";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/${name}.tar.gz";
      sha256 = "f83fb4cb8de060f607214b1e88c98ac6c4e065371e646fe896f16ea887aecb0c";
    };
    propagatedBuildInputs = [ DataCompare FileFindRule ];
  };

  DevelDProf = buildPerlPackage {
    name = "Devel-DProf-20110802.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-DProf-20110802.00.tar.gz;
      sha256 = "b9eec466ab77aa9f6ab48d33134694d1aa5a8cd221b1aa0a00d09c93ab69643c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Devel-DProf;
      description = "A DEPRECATED Perl code profiler";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPatchPerl = buildPerlPackage rec {
    name = "Devel-PatchPerl-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "0997ms4ksvxy0x0bnhrm7mhx3d2rbmgdiv3xdsawb17r2695vrgk";
    };
    propagatedBuildInputs = [ Filepushd ModulePluggable ];
    meta = {
      homepage = https://github.com/bingos/devel-patchperl;
      description = "Patch perl source a la Devel::PPPort's buildperl.pl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPPPort = buildPerlPackage rec {
    name = "Devel-PPPort-3.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WOLFSAGE/${name}.tar.gz";
      sha256 = "257801ef441f317bc79d20cdc72344e5b4ff6f685d65bdf79ff153e733fa3856";
    };
    meta = {
      description = "Perl/Pollution/Portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSelfStubber = buildPerlPackage {
    name = "Devel-SelfStubber-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-SelfStubber-1.05.tar.gz;
      sha256 = "b7bd750e41ec2dbca3f2f1d48e5e8ba594dcc8bc7a923a2565611ab8d0846bf8";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Devel-SelfStubber;
      description = "Generate stubs for a SelfLoading module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSizeMe = buildPerlPackage {
    name = "Devel-SizeMe-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/Devel-SizeMe-0.19.tar.gz;
      sha256 = "546e31ba83c0bf7cef37b38a462860461850473479d7d4ac6c0dadfb78d54717";
    };
    propagatedBuildInputs = [ DBDSQLite DBI DataDumperConcise HTMLParser JSONXS Moo ];
    meta = {
      homepage = https://github.com/timbunce/devel-sizeme;
      description = "Unknown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      # See https://rt.cpan.org/Public/Bug/Display.html?id=92348
      broken = true;
    };
  };

  DevelTrace = buildPerlPackage {
    name = "Devel-Trace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Devel-Trace-0.12.tar.gz;
      sha256 = "0s1q1a05gk3xvwqkya3k05vqjk13rvb489g0frprhzpzfvvwl0gm";
    };
    meta = {
      description = "Print out each line before it is executed (like sh -x)";
      license = stdenv.lib.licenses.publicDomain;
    };
  };

  DBDMock = buildPerlPackage {
    name = "DBD-Mock-1.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DICHI/DBD-Mock/DBD-Mock-1.45.tar.gz;
      sha256 = "40a80c37b31ef14536b58b4a8b483e65953b00b8fa7397817c7eb76d540bd00f";
    };
    propagatedBuildInputs = [ DBI TestException ];
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
    inherit (pkgs) db;
  };

  DBI = buildPerlPackage rec {
    name = "DBI-1.636";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "8f7ddce97c04b4b7a000e65e5d05f679c964d62c8b02c94c1a7d815bb2dd676c";
    };
    meta = {
      homepage = http://dbi.perl.org/;
      description = "Database independent interface for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  DBIxClass = buildPerlPackage rec {
    # tests broken again
    doCheck = false;
    name = "DBIx-Class-0.082840";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "4049afd175e315ebcab945b19030aec40bcec46cc5611b0286a5a267ca7181ef";
    };
    patches = [ ../development/perl-modules/dbiclassx-fix.patch ]; # Remove after next release
    buildInputs = [ DBDSQLite PackageStash SQLTranslator TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped ClassC3Componentised ClassInspector ConfigAny ContextPreserve DBI DataDumperConcise DataPage DevelGlobalDestruction HashMerge MROCompat ModuleFind Moo PathClass SQLAbstract ScopeGuard SubName TryTiny namespaceclean ];
    meta = {
      homepage = http://www.dbix-class.org/;
      description = "Extensible and flexible object <-> relational mapper";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCandy = buildPerlPackage rec {
    name = "DBIx-Class-Candy-0.005002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "fb109e765674a52e9eac03f52403bb3cf717254b8b9fa46f06a6f205392f987d";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ DBIxClass LinguaENInflect MROCompat StringCamelCase SubExporter namespaceclean ];
    meta = {
      homepage = https://github.com/frioux/DBIx-Class-Candy;
      description = "Sugar for your favorite ORM, DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  DBIxClassHelpers = buildPerlPackage rec {
    name = "DBIx-Class-Helpers-2.032001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "c7af96d17e11f0957b7187bb6002341a7b130bb79b61f6d91b39178ef000eff5";
    };
    buildInputs = [ DBDSQLite DateTimeFormatSQLite TestDeep TestFatal TestRoo aliased ];
    propagatedBuildInputs = [ CarpClan DBIxClass DBIxClassCandy DBIxIntrospector LinguaENInflect ModuleRuntime Moo SafeIsa StringCamelCase SubExporterProgressive TextBrew TryTiny namespaceclean ];
    meta = {
      homepage = https://github.com/frioux/DBIx-Class-Helpers;
      description = "Simplify the common case stuff for DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassIntrospectableM2M = buildPerlPackage rec {
    name = "DBIx-Class-IntrospectableM2M-0.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "c6baafb4241693fdb34b29ebd906993add364bf31aafa4462f3e062204cc87f0";
    };
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Introspect many-to-many relationships";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassSchemaLoader = buildPerlPackage rec {
    name = "DBIx-Class-Schema-Loader-0.07045";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "b132c667aa7dfe6f054e097c3e572a7dbf8ad433500f085e372740d5bc23a440";
    };
    buildInputs = [ ConfigAny ConfigGeneral DBDSQLite DBIxClassIntrospectableM2M Moose MooseXMarkAsMethods MooseXNonMoose TestDeep TestDifferences TestException TestPod TestWarn namespaceautoclean ];
    propagatedBuildInputs = [ CarpClan ClassAccessorGrouped ClassC3Componentised ClassInspector ClassUnload DBIxClass DataDump HashMerge LinguaENInflectNumber LinguaENInflectPhrase LinguaENTagger MROCompat ScalarListUtils ScopeGuard StringCamelCase StringToIdentifierEN TryTiny namespaceclean ];
    meta = {
      description = "Create a DBIx::Class::Schema based on a database";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  DBIxConnector = buildPerlModule rec {
    name = "DBIx-Connector-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "57c08d2c1951486cb95cfb83f518f462a3dbf20d353f3eee4f46af44fa19c359";
    };
    buildInputs = [ TestMockModule ];
    propagatedBuildInputs = [ DBI ];
    meta = {
      homepage = http://search.cpan.org/dist/DBIx-Connector/;
      description = "Fast, safe DBI connection and transaction management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  DBIxDBSchema = buildPerlPackage {
    name = "DBIx-DBSchema-0.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IV/IVAN/DBIx-DBSchema-0.45.tar.gz;
      sha256 = "7a2a978fb6d9feaa3e4b109c71c963b26a008a2d130c5876ecf24c5a72338a1d";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Unknown";
      license = "unknown";
    };
  };

  DBIxHTMLViewLATEST = buildPerlPackage {
    name = "DBIx-HTMLView-LATEST";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAKANARDO/DBIx-HTMLView-LATEST.tar.gz;
      sha256 = "b1af44cba329a8f583d174c5e82a7a2e91fe4f3a35cc38cbf028449578114dfa";
    };
    doCheck = false;
  };

  DBIxSearchBuilder = buildPerlPackage {
    name = "DBIx-SearchBuilder-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/DBIx-SearchBuilder-1.66.tar.gz;
      sha256 = "e2703c3f4b38cf232dec48be98aeab6d2dbee077dcf059369b825629c4be702e";
    };
    buildInputs = [ DBDSQLite ];
    propagatedBuildInputs = [ CacheSimpleTimedExpiry ClassAccessor ClassReturnValue Clone DBI DBIxDBSchema Want ];
    meta = {
      description = "Encapsulate SQL queries and rows in simple perl objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxSimple = buildPerlPackage {
    name = "DBIx-Simple-1.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JU/JUERD/DBIx-Simple-1.35.tar.gz;
      sha256 = "445535b3dfab88140c7a0d2776b1e78f254dc7e9c81072d5a01afc95a5db499a";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Very complete easy-to-use OO interface to DBI";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DBIxIntrospector = buildPerlPackage rec {
    name = "DBIx-Introspector-0.001005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "0fp6h71xv4pgb8l815rs6ad4camzhjqf64s1sf7zmhchqqn4vacn";
    };

    propagatedBuildInputs = [ TestFatal TestRoo Moo DBI DBDSQLite ];
  };

  DevelCycle = buildPerlPackage {
    name = "Devel-Cycle-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDS/Devel-Cycle-1.11.tar.gz;
      sha256 = "17c73yx9r32xvrsh8y7q24y0m3b98yihjyf3q4y68j869nh2b4rs";
    };
    meta = {
      description = "Find memory cycles in objects";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelDeclare = buildPerlPackage rec {
    name = "Devel-Declare-0.006018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "bb3607bc7546bcf8d9ac57acd8de4e4ca5567ace836ab823d5f5b450216f466a";
    };
    buildInputs = [ BHooksOPCheck ExtUtilsDepends TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope BHooksOPCheck SubName ];
    meta = {
      description = "Adding keywords to perl, in perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  DevelFindPerl = buildPerlPackage rec {
    name = "Devel-FindPerl-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "0ns95dsgmr8s0f1dfwd1cyv32vmd22w0vs51ppnnzp5zyi499581";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Find the path to your perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "0qn4iszgylnxjdkb6430f6a3ci7bcx9ih1az6bd5cbij1pf2965j";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      homepage = http://search.cpan.org/dist/Devel-GlobalDestruction;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelHide = buildPerlPackage rec {
    name = "Devel-Hide-0.0009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "1phnzbw58v6551nhv6sg86m72nx9w5j4msh1hg4jvkakkq5w9pki";
    };
  };

  DevelPartialDump = buildPerlPackage {
    name = "Devel-PartialDump-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-PartialDump-0.15.tar.gz;
      sha256 = "0xm42030qlbimay5x72sjj0na43ciniai2xdcdx8zf191jw5dz7n";
    };
    propagatedBuildInputs = [ Moose namespaceclean SubExporter Testuseok TestWarn ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelStackTrace = buildPerlPackage {
    name = "Devel-StackTrace-1.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-1.34.tar.gz;
      sha256 = "e882ccd7f4cbab0d0cdad53897f3f3bf29bdcf47d2bdfde1ac07f1bc7d7ebd16";
    };
    meta = {
      homepage = http://metacpan.org/release/Devel-StackTrace;
      description = "An object representing a stack trace";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    name = "Devel-StackTrace-AsHTML-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.14.tar.gz;
      sha256 = "0yl296y0qfwybwjgqjzd4j2w2bj5a2nz342qqgxchnf5bqynl1c9";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "Displays stack trace in HTML";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "76c2a90d31318204ecf1977f0217ce57b142e6681fe2b99fb8789efc5dd86f41";
    };
    meta = {
      description = "Dump symbol names or the symbol table";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Digest = buildPerlPackage {
    name = "Digest-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-1.17.tar.gz;
      sha256 = "2f6a54459fc7f37c0669d548bb224b695eb8d2ddc089aa5547645ce1f5fd86f7";
    };
    meta = {
      description = "Modules that calculate message digests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestCRC = buildPerlPackage rec {
    name = "Digest-CRC-0.22.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLIMAUL/${name}.tar.gz";
      sha256 = "112b50f7fbc6f6baf5d4584ee97f542ced6c9ec03a3147f7902c84b8b26778cb";
    };
    meta = {
      description = "Module that calculates CRC sums of all sorts";
      license = stdenv.lib.licenses.publicDomain;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestHMAC_SHA1 = buildPerlPackage {
    name = "Digest-HMAC_SHA1-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestJHash = buildPerlPackage rec {
    name = "Digest-JHash-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "c746cf0a861a004090263cd54d7728d0c7595a0cf90cbbfd8409b396ee3b0063";
    };
    meta = {
      description = "Perl extension for 32 bit Jenkins Hashing Algorithm";
      license = stdenv.lib.licenses.artistic2;
      maintainers = [ maintainers.rycee ];
    };
  };

  DigestMD4 = buildPerlPackage rec {
    name = "Digest-MD4-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/${name}.tar.gz";
      sha256 = "19ma1hmvgiznq95ngzvm6v4dfxc9zmi69k8iyfcg6w14lfxi0lb6";
    };
  };

  DigestMD5 = buildPerlPackage {
    name = "Digest-MD5-2.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-MD5-2.54.tar.gz;
      sha256 = "90de11e3743ef1c753a5c2032b434e09472046fbcf346996cbe5d135b217f390";
    };
    meta = {
      description = "Perl interface to the MD-5 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestMD5File = buildPerlPackage {
    name = "Digest-MD5-File-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/Digest-MD5-File-0.08.tar.gz;
      sha256 = "060jzf45dlwysw5wsm7av1wvpl06xgk415kwwpvv89r6wda3md5d";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Perl extension for getting MD5 sums for files and urls";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestPerlMD5 = buildPerlPackage rec {
    name = "Digest-Perl-MD5-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DELTA/${name}.tar.gz";
      sha256 = "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1";
    };
    meta = {
      description = "Perl Implementation of Rivest's MD5 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistCheckConflicts = buildPerlPackage rec {
    name = "Dist-CheckConflicts-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "1i7dr9jpdiy2nijl2p4q5zg2q2s9ckbj2hs4kmnnckf9hsb4p17a";
    };
    buildInputs = [ TestFatal ModuleRuntime ];
    propagatedBuildInputs = [ SubExporter ListMoreUtils ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Declare version conflicts for your dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZilla = buildPerlPackage {
    name = "Dist-Zilla-4.300039";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-4.300039.tar.gz;
      sha256 = "10cighwsqp53kbk2gwlnl9m18sbs7ijr2v37vwca9qxbscy2yr21";
    };
    buildInputs = [ FileShareDirInstall SoftwareLicense TestFatal TestFileShareDir TestScript ];
    propagatedBuildInputs = [ AppCmd CPANUploader ClassLoad ConfigINI ConfigMVP ConfigMVPReaderINI DataSection DateTime FileCopyRecursive FileFindRule FileHomeDir FileShareDir FileShareDirInstall Filepushd HashMergeSimple JSON ListAllUtils ListMoreUtils LogDispatchouli Moose MooseAutobox MooseXLazyRequire MooseXRoleParameterized MooseXSetOnce MooseXTypes MooseXTypesPathClass MooseXTypesPerl PPI ParamsUtil PathClass PerlPrereqScanner PerlVersion PodEventual SoftwareLicense StringFormatter StringRewritePrefix SubExporter SubExporterForMethods TermReadKey TestDeep TextGlob TextTemplate TryTiny YAMLTiny autobox namespaceautoclean CPANMetaRequirements ];
    meta = {
      homepage = http://dzil.org/;
      description = "Distribution builder; installer not included!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  DistZillaPluginBundleTestingMania = buildPerlPackage {
    name = "Dist-Zilla-PluginBundle-TestingMania-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-PluginBundle-TestingMania-0.21.tar.gz;
      sha256 = "1cbq7v799bf93iqp19v1ln6bcf6gvmc0qw3gf4bq445wsm7w62wy";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox perl ];
    propagatedBuildInputs = [ DistZilla DistZillaPluginMojibakeTests DistZillaPluginNoTabsTests DistZillaPluginTestCPANChanges DistZillaPluginTestCPANMetaJSON DistZillaPluginTestCompile DistZillaPluginTestDistManifest DistZillaPluginTestEOL DistZillaPluginTestKwalitee DistZillaPluginTestMinimumVersion DistZillaPluginTestPerlCritic DistZillaPluginTestPodLinkCheck DistZillaPluginTestPortability DistZillaPluginTestSynopsis DistZillaPluginTestUnusedVars DistZillaPluginTestVersion JSONPP ListMoreUtils Moose PodCoverageTrustPod TestCPANMeta TestPerlCritic TestVersion namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-PluginBundle-TestingMania/;
      description = "Test your dist with every testing plugin conceivable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginCheckChangeLog = buildPerlPackage {
    name = "Dist-Zilla-Plugin-CheckChangeLog-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Dist-Zilla-Plugin-CheckChangeLog-0.01.tar.gz;
      sha256 = "153dbe5ff8cb3c060901e003237a0515d7b9b5cc870eebfd417a6c91e28edec2";
    };
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Dist::Zilla with Changes check";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginMojibakeTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-MojibakeTests-0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Dist-Zilla-Plugin-MojibakeTests-0.5.tar.gz;
      sha256 = "0630acc9bcb415feba49b55a1b70da6e49a740673b4a483fc8058d03c6a21676";
    };
    propagatedBuildInputs = [ DistZilla Moose TestMojibake UnicodeCheckUTF8 ];
    meta = {
      homepage = https://github.com/creaktive/Dist-Zilla-Plugin-MojibakeTests;
      description = "Release tests for source encoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginNoTabsTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-NoTabsTests-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Dist-Zilla-Plugin-NoTabsTests-0.01.tar.gz;
      sha256 = "fd4ed380de4fc2bad61db377cc50ab26b567e53b3a1efd0b8d8baab80256ef9e";
    };
    propagatedBuildInputs = [ DistZilla Moose TestNoTabs namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-NoTabsTests;
      description = "Release tests making sure hard tabs aren't used";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginPodWeaver = buildPerlPackage {
    name = "Dist-Zilla-Plugin-PodWeaver-3.102000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-Plugin-PodWeaver-3.102000.tar.gz;
      sha256 = "0xayy50fgfc7wlsnygz28ka2ax9pmr0rn845i8d6p40amrkzzlml";
    };
    buildInputs = [ FileFindRule ];
    propagatedBuildInputs = [ DistZilla ListMoreUtils Moose PPI PodElementalPerlMunger PodWeaver namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Dist-Zilla-Plugin-PodWeaver;
      description = "Weave your Pod together from configuration and Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeAnyFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500.tar.gz;
      sha256 = "4d02ce5f185e0d9061019c1925a410931d0c1848db7e5ba5f8e676f04634b06e";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZilla FileSlurp IOstringy Moose MooseAutobox MooseXHasSugar PodMarkdown ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeAnyFromPod;
      description = "Automatically convert POD to a README in any format for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeMarkdownFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120.tar.gz;
      sha256 = "5a3346daab4e2bba850ee4a7898467da9f80bc93cc10d2d625f9880a46092160";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZillaPluginReadmeAnyFromPod Moose ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeMarkdownFromPod;
      description = "Automatically convert POD to a README.mkdn for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANChanges = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-CPAN-Changes-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/${name}.tar.gz";
      sha256 = "215b3a5c3c58c8bab0ea27130441bbdaec737eecc00f0670937f608bdbf64806";
    };
    buildInputs = [ CPANChanges DistZilla ];
    propagatedBuildInputs = [ CPANChanges DataSection DistZilla Moose ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-CPAN-Changes/;
      description = "Release tests for your changelog";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANMetaJSON = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003.tar.gz;
      sha256 = "c76b9f5745f4626969bb9c60e1330ebd0d8b197f8dd33f9a6e6fce63877b4883";
    };
    buildInputs = [ DistZilla ];
    propagatedBuildInputs = [ DistZilla Moose MooseAutobox ];
    meta = {
      homepage = http://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Meta::JSON;
      description = "Release tests for your META.json";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCompile = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-Compile-2.054";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "363fc251785a36a0b2028fda3b38d71d30c7048b09145362bbfac13fc41eab7e";
    };
    buildInputs = [ CPANMetaCheck DistZilla Filepushd ModuleBuildTiny PerlPrereqScanner TestDeep TestMinimumVersion TestWarnings self."if" ];
    propagatedBuildInputs = [ DataSection DistZilla Moose PathTiny SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/Dist-Zilla-Plugin-Test-Compile;
      description = "Common tests to check syntax of your modules, only using core modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestDistManifest = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-DistManifest-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-DistManifest-2.000004.tar.gz;
      sha256 = "a832d9d04f85e9dd09f30af67c5d636efe79847ec3790939de081ee5e412fb68";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestDistManifest ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-DistManifest/;
      description = "Release tests for the manifest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestEOL = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-EOL-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-EOL-0.10.tar.gz;
      sha256 = "1sl7zvjzpwf7wl188a3j13k1qcb63hawx82iy6r3dx2gns8nc0nw";
    };
    buildInputs = [ DistZilla TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestEOL namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-EOL/;
      description = "Author tests making sure correct line endings are used";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DistZillaPluginTestKwalitee = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Kwalitee-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Kwalitee-2.06.tar.gz;
      sha256 = "1723beb96d4048fd4fb0fea2ed36c0c6f3ea4648ce7f93d4cb73e5d49e274bf6";
    };
    buildInputs = [ CaptureTiny DistZilla PathClass perl ];
    propagatedBuildInputs = [ DataSection DistZilla Moose SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-Kwalitee;
      description = "Release tests for kwalitee";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestMinimumVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-MinimumVersion-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-MinimumVersion-2.000005.tar.gz;
      sha256 = "988c71a3158e94e7a0b23f346f19af4a0ed67e101a2653c3185c5ae49981132b";
    };
    buildInputs = [ DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestMinimumVersion ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-MinimumVersion/;
      description = "Release tests for minimum required versions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPerlCritic = buildPerlModule {
    name = "Dist-Zilla-Plugin-Test-Perl-Critic-2.112410";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JQ/JQUELIN/Dist-Zilla-Plugin-Test-Perl-Critic-2.112410.tar.gz;
      sha256 = "3ce59ce3ef6cf56d7de0debb33c26f899492d9742c8b82073e257787fd85630f";
    };
    buildInputs = [ DistZilla MooseAutobox ];
    propagatedBuildInputs = [ DataSection DistZilla Moose namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Perl-Critic/;
      description = "Tests to check your code against best practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPodLinkCheck = buildPerlPackage rec {
    name = "Dist-Zilla-Plugin-Test-Pod-LinkCheck-1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/${name}.tar.gz";
      sha256 = "26f3b257d5037aeec8335910cfdaf76fc8612f38f5d3134f46cd433e116947b0";
    };
#    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ DistZilla Moose TestPodLinkCheck ];
    meta = {
      homepage = https://github.com/rwstauner/Dist-Zilla-Plugin-Test-Pod-LinkCheck;
      description = "Add release tests for POD links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPortability = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Portability-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Portability-2.000005.tar.gz;
      sha256 = "b32d0a4b1d78ba76fabedd299c1a11efed05c3ce9752d7da6babe06d3515242b";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestPortabilityFiles ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-Portability/;
      description = "Release tests for portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestSynopsis = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Synopsis-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Synopsis-2.000004.tar.gz;
      sha256 = "d073de3206c5e588f60f55e4be64fab4c2595f5bc3013cd91307993691598d59";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestSynopsis ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-Synopsis/;
      description = "Release tests for synopses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestUnusedVars = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-UnusedVars-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-UnusedVars-2.000005.tar.gz;
      sha256 = "37ec462dc82f45cfd9d6d92ee59b8fd215a9a14b18d179b05912baee77359804";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestVars namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-UnusedVars/;
      description = "Release tests for unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Version-0.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-Version-0.002004.tar.gz;
      sha256 = "4ae5055071e07442223d07d818e9484430368b59c15966b90b18c8abc06f8e36";
    };
    buildInputs = [ DistZilla TestNoTabs TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestVersion namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Version/;
      description = "Release Test::Version tests";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  EmailAbstract = buildPerlPackage rec {
    name = "Email-Abstract-3.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "fc7169acb6c43df7f005e7ef6ad08ee8ca6eb6796b5d1604593c997337cc8240";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ModulePluggable ];
    meta = {
      homepage = https://github.com/rjbs/Email-Abstract;
      description = "Unified interface to mail representations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailAddress = buildPerlPackage {
    name = "Email-Address-1.908";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.908.tar.gz;
      sha256 = "0i6ljdvpy279hpbqf6lgv4figr376rb2sh4yphj86xkdzsyn1y75";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "RFC 2822 Address Parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddressList = buildPerlPackage {
    name = "Email-Address-List-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Email-Address-List-0.05.tar.gz;
      sha256 = "705c23fc2163c2347ba0aea998450259f7b10577a368c6d310bd4e98b427a033";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ EmailAddress ];
    meta = {
      description = "RFC close address list parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailDateFormat = buildPerlPackage rec {
    name = "Email-Date-Format-1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "579c617e303b9d874411c7b61b46b59d36f815718625074ae6832e7bb9db5104";
    };
    meta = {
      homepage = https://github.com/rjbs/Email-Date-Format;
      description = "Produce RFC 2822 date strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailMessageID = buildPerlPackage {
    name = "Email-MessageID-1.404";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MessageID-1.404.tar.gz;
      sha256 = "0lyq9r3x7cs7cncf0yiazbi7aq4c5d4m3wxwgqdd4r5p9gxdjj4n";
    };
    propagatedBuildInputs = [ EmailAddress ];
    meta = {
      description = "Generate world unique message-ids";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailMIME = buildPerlPackage rec {
    name = "Email-MIME-1.936";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4c0934284da84b8e9ed48ff1060c9719273fac18e776f4c8e888a47c863ee661";
    };
    propagatedBuildInputs = [ EmailAddress EmailMIMEContentType EmailMIMEEncodings EmailMessageID EmailSimple MIMETypes ];
    meta = {
      homepage = https://github.com/rjbs/Email-MIME;
      description = "Easy MIME message handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  EmailMIMEContentType = buildPerlPackage rec {
    name = "Email-MIME-ContentType-1.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "7508cd1227b8f150a403ca49658cb4a0892836dd8f01ff95f049957b2abf10f9";
    };
    meta = {
      homepage = https://github.com/rjbs/Email-MIME-ContentType;
      description = "Parse a MIME Content-Type Header";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  EmailMIMEEncodings = buildPerlPackage rec {
    name = "Email-MIME-Encodings-1.315";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4c71045507b31ec853dd60152b40e33ba3741779c0f49bb143b50cf8d243ab5c";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      homepage = https://github.com/rjbs/Email-MIME-Encodings;
      description = "A unified interface to MIME encoding and decoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ rycee ];
    };
  };

  EmailSend = buildPerlPackage rec {
    name = "Email-Send-2.201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4bbec933558d7cc9b8152bad86dd313de277a21a89b4ea83d84e61587e95dbc6";
    };
    propagatedBuildInputs = [ EmailAbstract EmailAddress EmailSimple ModulePluggable ReturnValue ];
    meta = {
      homepage = https://github.com/rjbs/Email-Send;
      description = "Simply Sending Email";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailSender = buildPerlPackage rec {
    name = "Email-Sender-1.300028";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "4a1cb9386a6b58b589b3183c807e533547a28e596fb15aa4cfd614947ad8ad30";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ libnet EmailAbstract EmailAddress EmailSimple ListMoreUtils ModuleRuntime Moo MooXTypesMooseLike SubExporter Throwable TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Email-Sender;
      description = "A library for sending email";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailSimple = buildPerlPackage rec {
    name = "Email-Simple-2.210";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "c8633fa462538967c036e3077617de9e5e8f6acc68d25546ba1d5bb1e12bd319";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      homepage = https://github.com/rjbs/Email-Simple;
      description = "Simple parsing of RFC2822 message format and headers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  EmailValid = buildPerlPackage rec {
    name = "Email-Valid-1.200";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0nnvbqz0ls451b5p0w6lgqm6kklm115db2p2xf89lw0r5pvmkw54";
    };
    propagatedBuildInputs = [MailTools NetDNS];
    doCheck = false;
  };

  EmailValidLoose = buildPerlPackage rec {
    name = "Email-Valid-Loose-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "e718e76eddee240251c999e139c8cbe6f2cc80192da5af875cbd12fa8ab93a59";
    };
    propagatedBuildInputs = [ EmailValid ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  Encode = buildPerlPackage {
    name = "Encode-2.78";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.78.tar.gz;
      sha256 = "1fc8d5c0e75ef85beeac71d1fe4a3bfcb8207755a46b32f783a3a6682672762a";
    };
    meta = {
      description = "Unknown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeEUCJPASCII = buildPerlPackage {
    name = "Encode-EUCJPASCII-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz;
      sha256 = "f998d34d55fd9c82cf910786a0448d1edfa60bf68e2c2306724ca67c629de861";
    };
    outputs = [ "out" ];
    meta = {
      description = "EucJP-ascii - An eucJP-open mapping";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeHanExtra = buildPerlPackage {
    name = "Encode-HanExtra-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz;
      sha256 = "1fd4b06cada70858003af153f94c863b3b95f2e3d03ba18d0451a81d51db443a";
    };
    meta = {
      description = "Extra sets of Chinese encodings";
      license = stdenv.lib.licenses.mit;
    };
  };

  EncodeJIS2K = buildPerlPackage {
    name = "Encode-JIS2K-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.02.tar.gz;
      sha256 = "5d718add5857f37fc270f24360bc9d100b72e0e13a11ca3149fe4e4d7c7cc4bf";
    };
    outputs = [ "out" ];
    meta = {
    };
  };

  EncodeLocale = buildPerlPackage rec {
    name = "Encode-Locale-1.05";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Encode/${name}.tar.gz";
      sha256 = "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1";
    };
    preCheck = if stdenv.isCygwin then ''
      sed -i"" -e "s@plan tests => 13@plan tests => 10@" t/env.t
      sed -i"" -e "s@ok(env(\"\\\x@#ok(env(\"\\\x@" t/env.t
      sed -i"" -e "s@ok(\$ENV{\"\\\x@#ok(\$ENV{\"\\\x@" t/env.t
    '' else null;
    meta = {
      description = "Determine the locale encoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  enum = buildPerlPackage rec {
    name = "enum-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "d2f36b5015f1e35f640159867b60bf5d5cd66b56cd5e42d33f531be68e5eee35";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Env = buildPerlPackage {
    name = "Env-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Env-1.04.tar.gz;
      sha256 = "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Env;
      description = "Perl module that imports environment variables as scalars or arrays";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EnvPath = buildPerlPackage {
    name = "Env-Path-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz;
      sha256 = "1qhmj15a66h90pjl2dgnxsb9jj3b1r5mpvnr87cafcl8g69z0jr4";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Error = buildPerlPackage rec {
    name = "Error-0.17022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1vzpz6syb82ir8svp2wjh95x6lpf01lgkxn2xy60ixrszc24zdya";
    };
  };

  EV = buildPerlPackage rec {
    name = "EV-4.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "2ae7f8734e2e4945510252152c3bea4be35f4aa58aad3db0504c38844b08a991";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ CommonSense ];
    meta = {
      license = stdenv.lib.licenses.gpl1Plus;
    };
  };

  EvalClosure = buildPerlPackage {
    name = "Eval-Closure-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.11.tar.gz;
      sha256 = "1b3rc9smdyyi0janckfiyg1kwph893sqwx7dr5n4mky0x8x3v4m1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ SubExporter TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Safely and cleanly create closures via string eval";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionBase = buildPerlPackage rec {
    name = "Exception-Base-0.2501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/${name}.tar.gz";
      sha256 = "5723dd78f4ac0b4d262a05ea46af663ea00d8096b2e9c0a43515c210760e1e75";
    };
    buildInputs = [ TestUnitLite ];
    meta = {
      description = "Lightweight exceptions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
    };
  };

  ExceptionClass = buildPerlPackage rec {
    name = "Exception-Class-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1p6f20fi82mr5bz7d2c7nqh0322r8n2kszfw37c77g8b1b4r72w3";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
  };

  ExceptionDied = buildPerlPackage {
    name = "Exception-Died-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Died-0.06.tar.gz;
      sha256 = "1dcajw2m3x5m76fpi3fvy9fjkmfrd171pnx087i5fkgx5ay41i1m";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ constantboolean ExceptionBase ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExceptionWarning = buildPerlPackage {
    name = "Exception-Warning-0.0401";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Warning-0.0401.tar.gz;
      sha256 = "1a6k3sbhkxmz00wrmhv70f9kxjf7fklp1y6mnprfvcdmrsk9qdkv";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterDeclare = buildPerlModule {
    name = "Exporter-Declare-0.113";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Exporter-Declare-0.113.tar.gz;
      sha256 = "724de5e982c8477df14a360c82233f9e0c26b4af9191647f750f5e465ea42dce";
    };
    buildInputs = [ FennecLite TestException ];
    propagatedBuildInputs = [ MetaBuilder aliased ];
    meta = {
      homepage = http://open-exodus.net/projects/Exporter-Declare;
      description = "Exporting done right";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterLite = buildPerlPackage {
    name = "Exporter-Lite-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Exporter-Lite-0.04.tar.gz;
      sha256 = "01g6a2ixgdi825v0l4ny3vx4chzsfxirka741x0i057cf6y5ciir";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    name = "Exporter-Tiny-0.042";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz;
      sha256 = "8f1622c5ebbfbcd519ead81df7917e48cb16cc527b1c46737b0459c3908a023f";
    };
    meta = {
      homepage = https://metacpan.org/release/Exporter-Tiny;
      description = "An exporter with the features of Sub::Exporter but only core dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCommand = buildPerlPackage {
    name = "ExtUtils-Command-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Command-1.20.tar.gz;
      sha256 = "740cccc93ba851aae803695b7a5b65ccbaa78bf4e96aa2e54f3f632c87a98c98";
    };
    meta = {
      homepage = http://search.cpan.org/dist/ExtUtils-Command;
      description = "Utilities to replace common UNIX commands in Makefiles etc";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Expect = buildPerlPackage {
    name = "Expect-1.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SZ/SZABGAB/Expect-1.32.tar.gz;
      sha256 = "d1f96842a5c7dd8516b202b530d87a70b65e7054d3bf975c34f6a42084e54e25";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ IOTty ];
    meta = {
      description = "Automate interactions with command line programs that expose a text terminal interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Exporter = buildPerlPackage {
    name = "Exporter-5.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Exporter-5.72.tar.gz;
      sha256 = "cd13b7a0e91e8505a0ce4b25f40fab2c92bb28a99ef0d03da1001d95a32f0291";
    };
    meta = {
      description = "Implements default import method for modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCBuilder = buildPerlPackage rec {
    name = "ExtUtils-CBuilder-0.280216";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/ExtUtils/${name}.tar.gz";
      sha256 = "09d5sq9mgcnmjf2yp8rwd0cc1fa8kq7nbwjqxiqdykwmavmgm5ml";
    };
    buildInputs = [ PerlOSType ];
  };

  ExtUtilsConfig = buildPerlPackage {
    name = "ExtUtils-Config-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Config-0.007.tar.gz;
      sha256 = "2c1465078b876fd16a90507092805265528c2532d4937b03547a6dbdb8ac0eef";
    };
    meta = {
      description = "A wrapper for perl's configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConstant = buildPerlPackage {
    name = "ExtUtils-Constant-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NW/NWCLARK/ExtUtils-Constant-0.23.tar.gz;
      sha256 = "23b77025c8a5d3b93c586d4f0e712bcca3ef934edbee00a78c3fad4285f48eab";
    };
  };

  ExtUtilsCppGuess = buildPerlModule rec {
    name = "ExtUtils-CppGuess-0.07";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1a77hxf2pa8ia9na72rijv1yhpn2bjrdsybwk2dj2l938pl3xn0w";
    };
    propagatedBuildInputs = [ CaptureTiny ];
  };

  ExtUtilsDepends = buildPerlPackage {
    name = "ExtUtils-Depends-0.306";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.306.tar.gz;
      sha256 = "0s935hmxjl6md47i80abcfaghqwhnv0ikzzqln80w4ydhg5qn9a5";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExtUtilsHelpers = buildPerlPackage {
    name = "ExtUtils-Helpers-0.022";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.022.tar.gz;
      sha256 = "15dalfwmpfmifw312i5pwiai8134pxf7b2804shlqhdk1xqczy6k";
    };
    meta = {
      description = "Various portability utilities for module builders";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Install-2.04.tar.gz;
      sha256 = "1b2e5370bc63d93cf99a75feb2b9b67227b693d16ebfb730ca90a483145de3b6";
    };
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-Install;
      description = "Install files from here to there";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstallPaths = buildPerlPackage {
    name = "ExtUtils-InstallPaths-0.010";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.010.tar.gz;
      sha256 = "0mi1px42in7i442jqncg3gmxd5zn7sw5b2s85h690rz433qvyk6i";
    };
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Build.PL install path logic made easy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsLibBuilder = buildPerlModule {
    name = "ExtUtils-LibBuilder-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMBS/ExtUtils/ExtUtils-LibBuilder-0.04.tar.gz;
      sha256 = "0j4rhx3w6nbvmxqjg6q09gm10nnpkcmqmh29cgxsfc9k14d8bb6w";
    };
    meta = {
      description = "A tool to build C libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-6.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-6.98.tar.gz;
      sha256 = "2eb023189e5fa6b9dcc66858b1fde953d1f1b86f971ec5ab42dd36c172da63ef";
    };
    propagatedBuildInputs =
      [ ParseCPANMeta JSONPP JSONPPCompat5006 CPANMetaYAML FileCopyRecursive ];
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-MakeMaker;
      description = "Create a module Makefile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsManifest = buildPerlPackage rec {
    name = "ExtUtils-Manifest-1.63";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "0p4hj03nb5n6mk7pskpw066n1i3hr80nq7k7rc3fgl329v6syfmg";
    };
  };

  ExtUtilsParseXS = buildPerlPackage rec {
    name = "ExtUtils-ParseXS-3.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "07ipa2ssflw3ais8gbjdk4l8z2k1p65nfjwkxm37g6zw1210pdih";
    };
  };

  ExtUtilsPkgConfig = buildPerlPackage rec {
    name = "ExtUtils-PkgConfig-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1cxh6w8vmyqmhl6afys2q6z6jkp1m6zvacpk70196zmk48p1kcv9";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig ];
    meta = {
      description = "Simplistic interface to pkg-config";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  # From CPAN[1]:
  #   This module exists merely as a compatibility wrapper around
  #   ExtUtils::Typemaps. In a nutshell, ExtUtils::Typemap was renamed to
  #   ExtUtils::Typemaps because the Typemap directory in lib/ could collide with
  #   the typemap file on case-insensitive file systems.
  #
  #   The ExtUtils::Typemaps module is part of the ExtUtils::ParseXS distribution
  #   and ships with the standard library of perl starting with perl version
  #   5.16.
  #
  # [1] http://search.cpan.org/~smueller/ExtUtils-Typemap-1.00/lib/ExtUtils/Typemap.pm:
  ExtUtilsTypemap = buildPerlPackage rec {
    name = "ExtUtils-Typemap-1.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1iqz0xlscg655gnwb2h1wrjj70llblps1zznl29qn1mv5mvibc5i";
    };
    buildInputs = [ ExtUtilsParseXS ];
  };

  ExtUtilsTypemapsDefault = buildPerlModule rec {
    name = "ExtUtils-Typemaps-Default-1.05";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1phmha0ks95kvzl00r1kgnd5hvg7qb1q9jmzjmw01p5zgs1zbyix";
    };
    propagatedBuildInputs = [ ExtUtilsTypemap ExtUtilsParseXS ];
  };

  ExtUtilsXSBuilder = buildPerlPackage {
    name = "ExtUtils-XSBuilder-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz;
      sha256 = "8cced386e3d544c5ec2deb3aed055b72ebcfc2ea9a6c807da87c4245272fe80a";
    };
    propagatedBuildInputs = [ ParseRecDescent TieIxHash ];
  };

  ExtUtilsXSpp = buildPerlModule rec {
    name = "ExtUtils-XSpp-0.1700";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1msp79bdjzi59vignfz1cxwk5a2cjiahblvi0ka60pi8nnn0alrm";
    };
    buildInputs = [ Spiffy TestBase TestDifferences ];
  };

  FatalException = buildPerlPackage {
    name = "Fatal-Exception-0.0204";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Fatal-Exception-0.0204.tar.gz;
      sha256 = "10a9j0fa83s3apv0xgi01l2h6s43my031097hg72wa80n07rgs2c";
    };
    buildInputs = [ ExceptionWarning TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ExceptionDied ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FCGI = buildPerlPackage rec {
    name = "FCGI-0.74";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/FCGI/${name}.tar.gz";
      sha256 = "0m089q07kpsk8y8g2wmi3d8i1jzn5m5m00shs7vnf2lnvvv4d7pm";
    };
    buildInputs = [ ];
  };

  FCGIProcManager = buildPerlPackage {
    name = "FCGI-ProcManager-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARODLAND/FCGI-ProcManager-0.25.tar.gz;
      sha256 = "b9ae1146e2638f3aa477c9ab3ceb728f92c5e36e4cce8f0b5847efad601d024d";
    };
    meta = {
      description = "A perl-based FastCGI process manager";
      license = "unknown";
    };
  };

  FennecLite = buildPerlModule {
    name = "Fennec-Lite-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Fennec-Lite-0.004.tar.gz;
      sha256 = "dce28e3932762c2ff92aa52d90405c06e898e81cb7b164ccae8966ae77f1dcab";
    };
    meta = {
      homepage = http://open-exodus.net/projects/Fennec-Lite;
      description = "Minimalist Fennec, the commonly used bits";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileChangeNotify = buildPerlModule {
    name = "File-ChangeNotify-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/File-ChangeNotify-0.24.tar.gz;
      sha256 = "3c8180169de0f97ad852a55942f74e520cbe433aa0889d0b65548ee38a111124";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs =
      [ ClassLoad ListMoreUtils ModulePluggable Moose MooseXParamsValidate MooseXSemiAffordanceAccessor namespaceautoclean ]
      ++ stdenv.lib.optional stdenv.isLinux LinuxInotify2;
    meta = with stdenv.lib; {
      description = "Watch for changes to files, cross-platform style";
      license = licenses.artistic2;
    };
  };

  Filechdir = buildPerlPackage rec {
    name = "File-chdir-0.1008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "0n8dz80fgk3shfxncyr4aff5hnsd846c5np6d68kc0mxqj2g0flr";
    };
  };

  FileBaseDir = buildPerlPackage rec {
    version = "0.03";
    name = "File-BaseDir-${version}";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "0029cba7a3b5d8aa5f7d03cb1b7ba2bcf2829382f7f26aa3bee06fce8611a886";
    };
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    propagatedBuildInputs = [ ModuleBuild ];
  };

  FileBOM = buildPerlPackage rec {
    name = "File-BOM-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTLAW/${name}.tar.gz";
      sha256 = "431c8b39397fd5ad5b1a1100d3647a06e9f94304d46db44ffc0a0e5c5c06a1c1";
    };
    buildInputs = [ ModuleBuild TestException ];
    propagatedBuildInputs = [ Readonly ];
    meta = {
      description = "Utilities for handling Byte Order Marks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCheckTree = buildPerlPackage {
    name = "File-CheckTree-4.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/File-CheckTree-4.42.tar.gz;
      sha256 = "66fb417f8ff8a5e5b7ea25606156e70e204861c59fa8c3831925b4dd3f155f8a";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      homepage = http://search.cpan.org/dist/File-CheckTree;
      description = "Run many filetest checks on a tree";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  FileFindIterator = buildPerlPackage {
    name = "File-Find-Iterator-0.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/File-Find-Iterator-0.4.tar.gz;
      sha256 = "a2b87ab9756a2e5bb674adbd39937663ed20c28c716bf5a1095a3ca44d54ab2c";
    };
    propagatedBuildInputs = [ ClassIterator ];
    meta = {
    };
  };

  FileFindObject = buildPerlPackage rec {
    name = "File-Find-Object-v0.3.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "7c467b6b7752bff46b7b8b84c9aabeac45bbfdab1e2224108a2e2170adb9f2b7";
    };
    buildInputs = [ ModuleBuild perl ];
    propagatedBuildInputs = [ ClassXSAccessor ];
    meta = {
      description = "An object oriented File::Find replacement";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  FileFindObjectRule = buildPerlModule rec {
    name = "File-Find-Object-Rule-0.0306";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "2ce55766b25fb8799d37b95bca61e8a71d8a437e28541e1cd06b7eb89f7739d1";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ ClassXSAccessor FileFindObject NumberCompare TextGlob ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/File-Find-Object/;
      description = "Alternative interface to File::Find::Object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFindRule = buildPerlPackage rec {
    name = "File-Find-Rule-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "0w73b4jr2fcrd74a1w3b2jryq3mqzc8z5mk7ia9p85xn3qmpa5r4";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob ];
  };

  FileFindRulePerl = buildPerlPackage {
    name = "File-Find-Rule-Perl-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-Find-Rule-Perl-1.13.tar.gz;
      sha256 = "d2ecb270778ddf54c536a78d02fe6ee7a675f7dcb7f3497ba1a76493f1bd2476";
    };
    propagatedBuildInputs = [ FileFindRule ParamsUtil ];
    meta = {
      description = "Common rules for searching for Perl things";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFinder = buildPerlPackage rec {
    name = "File-Finder-0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ME/MERLYN/${name}.tar.gz";
      sha256 = "2ecbc19ac67a9e635c872a807a8d3eaaff5babc054f15a191d47cdfc5f176a74";
    };
    propagatedBuildInputs = [ TextGlob ];
    meta = {
      license = stdenv.lib.licenses.free; # Same as Perl
    };
  };

  FileHandleUnget = buildPerlPackage rec {
    name = "FileHandle-Unget-0.1628";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "9ef4eb765ddfdc35b350905d8dd0a1e12139eabc586652811bfab41972100fdf";
    };
    buildInputs = [ FileSlurp URI ];
    meta = {
      homepage = https://github.com/coppit/filehandle-unget/;
      description = "FileHandle which supports multi-byte unget";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  FileHomeDir = buildPerlPackage {
    name = "File-HomeDir-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-HomeDir-1.00.tar.gz;
      sha256 = "85b94f3513093ec0a25b91f9f2571918519ae6f2b7a1e8546f8f78d09a877143";
    };
    propagatedBuildInputs = [ FileWhich ];
    meta = {
      description = "Find your home and other directories on any platform";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    preCheck = "export HOME=$TMPDIR";
    doCheck = !stdenv.isDarwin;
  };

  FileKeePass = buildPerlPackage rec {
    name = "File-KeePass-2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7";
    };
    propagatedBuildInputs = [ CryptRijndael ];
  };

  FileLibMagic = buildPerlPackage rec {
    name = "File-LibMagic-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "2c7fb54912caf2c22d06b02d6a88edad970e0f8b017634dc30eec46e53763e84";
    };
    buildInputs = [ TestFatal pkgs.file ];
    makeMakerFlags = "--lib=${pkgs.file}/lib";
    preCheck = ''
      substituteInPlace t/oo-api.t \
        --replace "/usr/share/file/magic.mgc" "${pkgs.file}/share/misc/magic.mgc"
    '';
    meta = {
      homepage = http://metacpan.org/release/File::LibMagic;
      description = "Determine MIME types of data or files using libmagic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileListing = buildPerlPackage rec {
    name = "File-Listing-6.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "1xcwjlnxaiwwpn41a5yi6nz95ywh3szq5chdxiwj36kqsvy5000y";
    };
    propagatedBuildInputs = [ HTTPDate ];
  };

  FileMimeInfo = buildPerlPackage rec {
    name = "File-MimeInfo-0.27";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "0d3jcs2fgrrfwl3rxk8xg0varjah2llm66jk6rk2gznpzqkgi72p";
    };
    doCheck = false; # Failed test 'desktop file is the right one'
    propagatedBuildInputs = [ FileBaseDir FileDesktopEntry ];
  };

  FileMMagic = buildPerlPackage rec {
    name = "File-MMagic-1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNOK/${name}.tar.gz";
      sha256 = "cf0c1b1eb29705c02d97c2913648009c0be42ce93ec24b36c696bf2d4f5ebd7e";
    };
    meta = {
      description = "Guess file type from contents";
      license = stdenv.lib.licenses.free; # Some form of BSD4/Apache mix.
    };
  };

  FileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
    };
  };

  FileNext = buildPerlPackage rec {
    name = "File-Next-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "cc3afd8eaf6294aba93b8152a269cc36a9df707c6dc2c149aaa04dabd869e60a";
    };
  };

  FileNFSLock = buildPerlPackage {
    name = "File-NFSLock-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.21.tar.gz;
      sha256 = "1kclhmyha2xijq49darlz82f3bn7gq3saycxpfiz3dndqhr5i9iz";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FilePath = buildPerlPackage rec {
    name = "File-Path-2.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RICHE/${name}.tar.gz";
      sha256 = "bbf61a0d37c135c694e80f4ea344932bdc5474c213025ae307ea52cb6886d17e";
    };
    meta = {
      description = "Create or remove directory trees";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filepushd = buildPerlPackage {
    name = "File-pushd-1.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-pushd-1.005.tar.gz;
      sha256 = "50fdcc33e69a50bab1e32d1a7c96753938f6d95a06015e34e662958c58687842";
    };
    meta = {
      homepage = https://metacpan.org/release/File-pushd;
      description = "Change directory temporarily for a limited scope";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileReadBackwards = buildPerlPackage rec {
    name = "File-ReadBackwards-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UR/URI/${name}.tar.gz";
      sha256 = "82b261af87507cc3e7e66899c457104ebc8d1c09fb85c53f67c1f90f70f18d6e";
    };
    meta = {
      description = "Read a file backwards by lines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileRemove = buildPerlPackage rec {
    name = "File-Remove-1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1p8bal9qhwkjbghivxn1d5m3qdj2qwm1agrjbmakm6la9dbxqm21";
    };
  };

  FileShare = buildPerlPackage {
    name = "File-Share-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOENIO/File-Share-0.03.tar.gz;
      sha256 = "0siy9p6b7zbln5yq6g8z1nwm76ia23kkdj1k5pywsh3n6dn2lxa2";
    };
    propagatedBuildInputs = [ FileShareDir ];
    meta = {
      homepage = http://github.com/ingydotnet/file-share-pm/tree;
      description = "Extend File::ShareDir to Local Libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShareDirInstall = buildPerlPackage {
    name = "File-ShareDir-Install-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GW/GWYN/File-ShareDir-Install-0.08.tar.gz;
      sha256 = "188pgn43wa6hgpcrv997lp3bad50030p4wmrcdzvfrqxj0bx2amf";
    };
    meta = {
      description = "Install shared files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };

  FileSlurper = buildPerlPackage rec {
    name = "File-Slurper-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "3eab340deff6ba5456e7d1156b9cfcc387e1243acfc156ff92b75b3f2e120b91";
    };
    buildInputs = [ TestWarnings ];
    meta = {
      description = "A simple, sane and efficient module to slurp a file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileSlurpTiny = buildPerlPackage rec {
    name = "File-Slurp-Tiny-0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "452995beeabf0e923e65fdc627a725dbb12c9e10c00d8018c16d10ba62757f1e";
    };
    meta = {
      description = "A simple, sane and efficient file slurper [DISCOURAGED]";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileUtil = buildPerlPackage rec {
    name = "File-Util-4.161950";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOMMY/${name}.tar.gz";
      sha256 = "88507b19da580d595b5c25fe6ba75bbd6096b4359e389ead067a216f766c20ee";
    };
    buildInputs = [ ModuleBuild TestNoWarnings ];
    meta = {
      homepage = https://github.com/tommybutler/file-util/wiki;
      description = "Easy, versatile, portable file handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FileWhich = buildPerlPackage rec {
    name = "File-Which-1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "9def5f10316bfd944e56b7f8a2501be1d44c288325309462aa9345e340854bcc";
    };
    meta = {
      homepage = http://perl.wdlabs.com/File-Which;
      description = "Perl implementation of the which utility as an API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filter = buildPerlPackage {
    name = "Filter-1.55";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Filter-1.55.tar.gz;
      sha256 = "7855f5f5f16777c14614b5d907794a170ed4cdeb4382bf03ffca825c8c6bc4a0";
    };
    meta = {
      description = "Source Filters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilterSimple = buildPerlPackage {
    name = "Filter-Simple-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Filter-Simple-0.91.tar.gz;
      sha256 = "c75a4945e94ecfe97e1409f49df036700d2e072e288497e205c4d319a80f694d";
    };
    meta = {
      description = "Simplified source filtering";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FinanceQuote = buildPerlPackage rec {
    name = "Finance-Quote-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EC/ECOCODE/${name}.tar.gz";
      sha256 = "0zhqb27y4vdxn476s2kwm9zl2f970yjcyyybnjm9b406krr2fm59";
    };
    propagatedBuildInputs = [
      CGI CryptSSLeay HTMLTableExtract HTMLTree HTTPMessage LWP LWPProtocolHttps MozillaCA
      DateCalc DateTime JSON ];
    meta = with stdenv.lib; {
      homepage = http://finance-quote.sourceforge.net/;
      description = "Get stock and mutual fund quotes from various exchanges";
      license = licenses.gpl2;
    };
  };

  FontAFM = buildPerlPackage rec {
    name = "Font-AFM-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1";
    };
  };

  FontTTF = buildPerlPackage rec {
    name = "Font-TTF-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/${name}.tar.gz";
      sha256 = "4b697d444259759ea02d2c442c9bffe5ffe14c9214084a01f743693a944cc293";
    };
    propagatedBuildInputs = [ IOString ];
    meta = {
      description = "TTF font support for Perl";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ForksSuper = buildPerlPackage {
    name = "Forks-Super-0.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MO/MOB/Forks-Super-0.72.tar.gz;
      sha256 = "0zyqwyndb3gnbsh43b6xyl3wmlnyi18vz3yrbsvp3lccz4d0v7qp";
    };
    doCheck = false;
    meta = {
      description = "Extensions and convenience methods to manage background processes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FormValidatorSimple = buildPerlPackage rec {
    name = "FormValidator-Simple-0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LY/LYOKATO/${name}.tar.gz";
      sha256 = "fc3a63dc54b962d74586070176adaf5be869f09b561bb30f5fd32ef531792666";
    };
    propagatedBuildInputs = [ CGI ClassAccessor ClassDataAccessor ClassDataInheritable ClassInspector DateCalc DateTimeFormatStrptime EmailValid EmailValidLoose ListMoreUtils MailTools TieIxHash UNIVERSALrequire YAML ];
    meta = {
      description = "Validation with simple chains of constraints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  FreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.5001";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.5001.tar.gz;
      sha256 = "0h8gakd6b9770n2xhld1hhqghdar3hrq2js4mgiwxy86j4r0hpiw";
    };
    doCheck = false;
  };

  GamesSolitaireVerify = buildPerlModule {
    name = "Games-Solitaire-Verify-0.1400";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Games-Solitaire-Verify-0.1400.tar.gz;
      sha256 = "0c897c17f23ed6710d0e3ddfb54cce0f00f5b68c55277181adc94a03b7d8c659";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ ClassXSAccessor ExceptionClass ListMoreUtils MooXlate ];
    meta = {
      description = "Verify solutions for solitaire games";
      license = stdenv.lib.licenses.mit;
    };
  };

  GD = buildPerlPackage rec {
    name = "GD-2.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "1ampz82kf0ixybncfgpvq2bp9nq5sjsmmw4c8srsv0g5jpz02pfh";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype
                    pkgs.libpng pkgs.fontconfig pkgs.xorg.libXpm GetoptLong ];

    # Patch needed to get arguments past the first GetOptions call
    # and to specify libfontconfig search path.
    # Patch has been sent upstream.
    patches = [ ../development/perl-modules/gd-options-passthrough-and-fontconfig.patch ];

    # tests fail
    doCheck = false;

    makeMakerFlags = "--lib_png_path=${pkgs.libpng.out} --lib_jpeg_path=${pkgs.libjpeg.out} --lib_zlib_path=${pkgs.zlib.out} --lib_ft_path=${pkgs.freetype.out} --lib_fontconfig_path=${pkgs.fontconfig.lib} --lib_xpm_path=${pkgs.xorg.libXpm.out}";
  };

  GDGraph = buildPerlPackage rec {
    name = "GDGraph-1.54";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/R/RU/RUZ/GDGraph-1.54.tar.gz";
      sha256 = "0kzsdc07ycxjainmz0dnsclb15w2j1y7g8b5mcb7vhannq85qvxr";
    };
    propagatedBuildInputs = [ GD GDText ];
    buildInputs = [ TestException CaptureTiny ];
    meta = {
      description = "Graph Plotting Module for Perl 5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDSecurityImage = buildPerlPackage {
    name = "GD-SecurityImage-1.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BU/BURAK/GD-SecurityImage-1.72.tar.gz;
      sha256 = "07a025krdaml5ls7gyssfdcsif6cnsnksrxkqk48n9dmv7rz7q1r";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Security image (captcha) generator";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDText = buildPerlPackage rec {
    name = "GDTextUtil-0.86";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/M/MV/MVERB/GDTextUtil-0.86.tar.gz";
      sha256 = "1g0nc7fz4d672ag7brlrrcz7ibm98x49qs75bq9z957ybkwcnvl8";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Text utilities for use with GD";
    };
  };

  GeoIP = buildPerlPackage rec {
    name = "Geo-IP-1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/${name}.tar.gz";
      sha256 = "0qinkq2br1cjicbgqb5bvrhm73h7f9f4fgc6bjfs5r6x7316bdqf";
    };
    makeMakerFlags = "LIBS=-L${pkgs.geoip}/lib INC=-I${pkgs.geoip}/include";
    doCheck = false; # seems to access the network
  };

  GetoptLong = buildPerlPackage rec {
    name = "Getopt-Long-2.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/${name}.tar.gz";
      sha256 = "12c5pvmx0jxx0mls8qll9ixb1lbacs7p1rwvmciv0dvw3w25dmr7";
    };
  };

  GetoptLongDescriptive = buildPerlPackage rec {
    name = "Getopt-Long-Descriptive-0.100";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1451e79310d1630de37690e3aba5c38ea5f01a486c5a43f0cd95bef2a02dffb6";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestWarnings ];
    propagatedBuildInputs = [ ParamsValidate SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/Getopt-Long-Descriptive;
      description = "Getopt::Long, but simpler and more powerful";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  GetoptTabular = buildPerlPackage rec {
    name = "Getopt-Tabular-0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GW/GWARD/${name}.tar.gz";
      sha256 = "0xskl9lcj07sdfx5dkma5wvhhgf5xlsq0khgh8kk34dm6dv0dpwv";
    };
  };

  GitPurePerl = buildPerlPackage {
    name = "Git-PurePerl-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BROQ/Git-PurePerl-0.51.tar.gz;
      sha256 = "3775f385ae566ea392ece0913a06ffec46441a1273c19ba9a6d990574ec34d00";
    };
    buildInputs = [ Testutf8 ];
    propagatedBuildInputs = [ ConfigGitLike DataStreamBulk DateTime FileFindRule IODigest Moose MooseXStrictConstructor MooseXTypesPathClass namespaceautoclean ];
    doCheck = false;
    meta = {
      description = "A Pure Perl interface to Git repositories";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Glib = buildPerlPackage rec {
    name = "Glib-1.321";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0h4cfxrxcf1mrdab5n5kk0smsi8vcrfnmcw1k6xw87r4vbifnxdr";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl wrappers for the GLib utility and Object libraries";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gnome2 = buildPerlPackage rec {
    name = "Gnome2-1.046";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "a6c787232ab7e82a423a9ff5a49cec6bf586c1bb3c04c2052a91cdda5b66ae40";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gnome2Canvas Gnome2VFS Gtk2 ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gnome2Canvas Gnome2VFS Gtk2 Pango pkgs.gnome2.libgnomeui ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net;
      description = "Perl interface to the 2.x series of the GNOME libraries";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gnome2Canvas = buildPerlPackage rec {
    name = "Gnome2-Canvas-1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/${name}.tar.gz";
      sha256 = "47a34204cd5f3a0ef5c8b9e1c9c96f41740edab7e9abf1d0560fa8666ba1916e";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 Pango pkgs.gnome2.libgnomecanvas ];
    meta = {
      license = stdenv.lib.licenses.lgpl2Plus;
    };
  };

  Gnome2VFS = buildPerlPackage rec {
    name = "Gnome2-VFS-1.082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "19dacfedef8770300861cb75f98ca5402e6e56501a888af3c18266a0790911b7";
    };
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib pkgs.gnome2.gnome_vfs ];
    meta = {
      description = "Perl interface to the 2.x series of the GNOME VFS library";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gnome2Wnck = buildPerlPackage rec {
    name = "Gnome2-Wnck-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/${name}.tar.gz";
      sha256 = "604a8ece88ac29f132d59b0caac27657ec31371c1606a4698a2160e88ac586e5";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 Pango pkgs.libwnck pkgs.glib pkgs.gtk2 ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 ];
    meta = {
      description = "Perl interface to the Window Navigator Construction Kit";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  GnuPG = buildPerlPackage {
    name = "GnuPG-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YA/YANICK/GnuPG-0.19.tar.gz;
      sha256 = "af53f2d3f63297e046676eae14a76296afdd2910e09723b6b113708622b7989b";
    };
    buildInputs = [ pkgs.gnupg1orig ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  GnuPGInterface = buildPerlPackage rec {
    name = "GnuPG-Interface-0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/${name}.tar.gz";
      sha256 = "247a9f5a88bb6745281c00d0f7d5d94e8599a92396849fd9571356dda047fd35";
    };
    buildInputs = with pkgs; [ which gnupg1compat ];
    propagatedBuildInputs = [ Moo MooXHandlesVia MooXlate ];
    doCheck = false;
    meta = {
      description = "Supply object methods for interacting with GnuPG";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoferTransporthttp = buildPerlPackage {
    name = "GoferTransport-http-1.017";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/GoferTransport-http-1.017.tar.gz;
      sha256 = "f73effe3ea7afa1907ce8977c87387abb0d4404f85a724ae2637b29a73154a9b";
    };
    propagatedBuildInputs = [ mod_perl2 DBI HTTPMessage LWP URI ];
    doCheck = false; # no make target 'test'
    meta = {
      description = "HTTP transport for DBI stateless proxy driver DBD::Gofer";
    };
  };

  GooCanvas = buildPerlPackage rec {
    name = "Goo-Canvas-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YE/YEWENBIN/${name}.tar.gz";
      sha256 = "0c588c507eed5e62d12ed1cc1e491c6ff3a1f59c4fb3d435e14214b37ab39251";
    };
    propagatedBuildInputs = [ Cairo ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 Pango pkgs.goocanvas pkgs.gtk2 ];
    meta = {
      description = "Perl interface to the GooCanvas";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoogleProtocolBuffers = buildPerlPackage rec {
    name = "Google-ProtocolBuffers-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/protobuf/${name}.tar.gz";
      sha256 = "0k2skcbfzn2aw1f218l47h4kgq5rj9qsam3sd6zw4qq3zyp0amb1";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches =
      [ ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch ];
    meta = {
      description = "Simple interface to Google Protocol Buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Graph = buildPerlPackage rec {
    name = "Graph-0.96";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "09wpiz7v0gv07zb7h8gwgjrwj16cdycs60d08cjlyj1s926zlbl3";
    };

    buildInputs = [ TestPod TestPodCoverage ];
  };

  GraphViz = buildPerlPackage rec {
    name = "GraphViz-2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "1zdgdd42ywg7bklysd8p8dra66q64vlm4fmnj5gjslp98cm02p9h";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz ];
    propagatedBuildInputs = [ IPCRun TestMore ];

    meta = with stdenv.lib; {
      description = "Perl interface to the GraphViz graphing tool";
      license = licenses.artistic2;
      maintainers = [ ];
    };
  };

  grepmail = buildPerlPackage rec {
    name = "grepmail-5.3104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "7969e569ec54b2f569a5af56ac4d884c630ad850974658219b0b6953e97b5d3d";
    };
    buildInputs = [ FileSlurp URI ];
    propagatedBuildInputs = [ DateManip DigestMD5 MailMboxMessageParser TimeDate ];
    outputs = [ "out" ];
    meta = {
      homepage = https://github.com/coppit/grepmail;
      description = "Search mailboxes for mail matching a regular expression";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  GrowlGNTP = buildPerlModule rec {
    name = "Growl-GNTP-0.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Growl/${name}.tar.gz";
      sha256 = "150x65lwf7pfsygcpmvj3679lhlfwx87xylwnrmwll67f9dpkjdi";
    };
    buildInputs = [ DataUUID CryptCBC ];
  };

  Gtk2 = buildPerlPackage rec {
    name = "Gtk2-1.2498";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0gs6lr4clz86838s3klrl37lf48j24zv0p37jlsvsnr927whpq3j";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Pango pkgs.gtk2 ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the 2.x series of the Gimp Toolkit library";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Gtk2AppIndicator = buildPerlPackage rec {
    name = "Gtk2-AppIndicator-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/${name}.tar.gz";
      sha256 = "a25cb071e214fb89b4450aa4605031eae89b7961e149b0d6e8f491c19c14a90a";
    };
    propagatedBuildInputs = [ Gtk2 pkgs.libappindicator-gtk2 pkgs.libdbusmenu-gtk2 pkgs.gtk2 pkgs.pkgconfig Glib Pango ];
    # Tests fail due to no display:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    doCheck = false;
    meta = {
      description = "Perl extension for libappindicator";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  Gtk2ImageView = buildPerlPackage rec {
    name = "Gtk2-ImageView-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/${name}.tar.gz";
      sha256 = "087186c3693acf196451cf59cc8b7f5cf9a7b05abe20d32dcbcba0822953fb80";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 Pango pkgs.gtkimageview pkgs.gtk2 ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gtk2 ];
    # Tests fail due to no display server:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    #   t/animview.t ...........
    doCheck = false;
    meta = {
      description = "Perl bindings for the GtkImageView widget";
      license = stdenv.lib.licenses.free;
    };
  };

  Gtk2Unique = buildPerlPackage rec {
    name = "Gtk2-Unique-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/${name}.tar.gz";
      sha256 = "ae8dfb0f6844ddaa2ce7b5b44553419490c8e83c24fd35c431406a58f6be0f4f";
    };
    propagatedBuildInputs = [ Gtk2 Glib ExtUtilsDepends ExtUtilsPkgConfig pkgs.libunique pkgs.gtk2 Cairo Pango ];
    meta = {
      description = "Use single instance applications";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Guard = buildPerlPackage rec {
    name = "Guard-1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "34c4ddf91fc93d1090d86da14df706d175b1610c67372c01e12ce9555d4dd1dc";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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
    name = "Hash-Merge-0.200";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "0r1a2axz85wn6573zrl9rk8mkfl2cvf1gp9vwya5qndp60rz1ya7";
    };
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Merges arbitrarily deep hashes into a single hash";
    };
  };

  HashMergeSimple = buildPerlPackage {
    name = "Hash-Merge-Simple-0.051";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/Hash-Merge-Simple-0.051.tar.gz;
      sha256 = "1c56327873d2f04d5722777f044863d968910466997740d55a754071c6287b73";
    };
    buildInputs = [ TestMost ];
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Recursively merge two or more hashes, simply";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMoreUtils = buildPerlModule rec {
    name = "Hash-MoreUtils-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "5e9c8458457eb18315a5669e3bef68488cd5ed8c2220011ac7429ff983288ab1";
    };
    meta = {
      description = "Provide the stuff missing in Hash::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  HashMultiValue = buildPerlPackage {
    name = "Hash-MultiValue-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Hash-MultiValue-0.15.tar.gz;
      sha256 = "1jc37kwpa1fl88va8bd1p95h0vjv1gsvmn7pc2pxj62ga6x0wpc0";
    };
    meta = {
      description = "Store multiple values per key";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashUtilFieldHashCompat = buildPerlPackage {
    name = "Hash-Util-FieldHash-Compat-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Hash-Util-FieldHash-Compat-0.07.tar.gz;
      sha256 = "1fbqcjvp5slkfyf63g8scrbdpkpw3g9z9557xvfaxn09aki7g1bn";
    };
    propagatedBuildInputs = [ Testuseok ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HeapFibonacci = buildPerlPackage {
    name = "Heap-Fibonacci-0.80";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz;
      sha256 = "1plv2djbyhvkdcw2ic54rdqb745cwksxckgzvw7ssxiir7rjknnc";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HookLexWrap = buildPerlPackage rec {
    name = "Hook-LexWrap-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "08ab9af6bd9b4560702d9d994ad9d905af0c2fd24090d1480ff640f137c1430d";
    };
    buildInputs = [ ModuleBuildTiny pkgs.unzip ];
    meta = {
      homepage = https://github.com/chorny/Hook-LexWrap;
      description = "Lexically scoped subroutine wrappers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLClean = buildPerlPackage rec {
    name = "HTML-Clean-0.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LI/LINDNER/${name}.tar.gz";
      sha256 = "1h0dzxx034hpshxlpsxhxh051d1p79cjgp4q5kg68kgx7aian85c";
    };
    meta = {
      description = "Cleans up HTML code for web browsers, not humans";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLElementExtended = buildPerlPackage {
    name = "HTML-Element-Extended-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSISK/HTML-Element-Extended-1.18.tar.gz;
      sha256 = "f3ef1af108f27fef15ebec66479f251ce08aa49bd00b0462c9c80c86b4b6b32b";
    };
    propagatedBuildInputs = [ HTMLTree ];
  };

  HTMLEscape = buildPerlModule rec {
    name = "HTML-Escape-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "b1cbac4157ad8dedac6914e1628855e05b8dc885a4007d2e4df8177c6a9b70fb";
    };
    buildInputs = [ ModuleBuild ModuleBuildPluggablePPPort TestRequires ];
    meta = {
      homepage = https://github.com/tokuhirom/HTML-Escape;
      description = "Extremely fast HTML escaping";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFromANSI = buildPerlPackage {
    name = "HTML-FromANSI-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/HTML-FromANSI-2.03.tar.gz;
      sha256 = "21776345ed701b2c04c7b09380af943f9984cc7f99624087aea45db5fc09c359";
    };
    propagatedBuildInputs = [ HTMLParser TermVT102Boundless Testuseok ];
    meta = {
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatter = buildPerlModule {
    name = "HTML-Formatter-2.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NI/NIGELM/HTML-Formatter-2.14.tar.gz;
      sha256 = "d28eeeab48ab5f7bfcc73cc106b0f756073d98d48dfdb91ca2951f832f8e035e";
    };
    buildInputs = [ FileSlurper TestCPANMeta TestEOL TestNoTabs perl ];
    propagatedBuildInputs = [ FontAFM HTMLTree ];
    meta = {
      homepage = https://metacpan.org/release/HTML-Formatter;
      description = "Base class for HTML formatters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatTextWithLinks = buildPerlPackage {
    name = "HTML-FormatText-WithLinks-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STRUAN/HTML-FormatText-WithLinks-0.15.tar.gz;
      sha256 = "7fcc1ab79eb58fb97d43e5bdd14e21791a250a204998918c62d6a171131833b1";
    };
    propagatedBuildInputs = [ HTMLFormatter HTMLTree URI ];
    meta = {
      description = "HTML to text conversion with links as footnotes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatTextWithLinksAndTables = buildPerlPackage {
    name = "HTML-FormatText-WithLinks-AndTables-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DALEEVANS/HTML-FormatText-WithLinks-AndTables-0.06.tar.gz;
      sha256 = "e5b23f0475fb81fd6fed688bb914295a39542b3e5b43c8517494226a52d868fa";
    };
    propagatedBuildInputs = [ HTMLFormatTextWithLinks HTMLFormatter HTMLTree ];
    meta = {
      description = "Converts HTML to Text with tables intact";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-2.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "0fvilng85wc65pna898x7mp4hx73mhahl7j2s10gj76avmxdizsw";
    };
    buildInputs = [ FileShareDirInstall TestAggregate TestException ];
    propagatedBuildInputs = [ CGI Clone ConfigAny DataVisitor DateTime
      DateTimeFormatBuilder DateTimeFormatNatural DateTimeFormatStrptime
      DateTimeLocale EmailValid FileShareDir HTMLScrubber HTMLTokeParserSimple
      HTTPMessage HashFlatten ListMoreUtils ModulePluggable Moose MooseXAliases
      NumberFormat PathClass Readonly RegexpCommon TaskWeaken YAMLLibYAML ];
    meta = {
      description = "HTML Form Creation, Rendering and Validation Framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormHandler = buildPerlPackage {
    name = "HTML-FormHandler-0.40057";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GS/GSHANK/HTML-FormHandler-0.40057.tar.gz;
      sha256 = "1hn9shhbsi4pdp396ia2hky3i0imnxgwvhy57gp0jjhy5qyvafvm";
    };
    # a single test is failing on perl 5.20
    doCheck = false;
    buildInputs = [ FileShareDirInstall PadWalker TestDifferences TestException TestMemoryCycle ];
    propagatedBuildInputs = [ ClassLoad DataClone DateTime DateTimeFormatStrptime EmailValid FileShareDir HTMLTree JSON ListAllUtils Moose MooseXGetopt MooseXTypes MooseXTypesCommon MooseXTypesLoadableClass SubExporter SubName TryTiny aliased namespaceautoclean ];
    meta = {
      description = "HTML forms using Moose";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMason = buildPerlPackage {
    name = "HTML-Mason-1.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.56.tar.gz;
      sha256 = "84ac24fb1d551f998145435265e5b6fd4a52ec61e4fadd3d7755eb648be2c4b2";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ CacheCache CGI ClassContainer ExceptionClass HTMLParser LogAny ParamsValidate ];
    meta = {
      homepage = http://metacpan.org/release/HTML-Mason;
      description = "High-performance, dynamic web site authoring system";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMasonPSGIHandler = buildPerlPackage {
    name = "HTML-Mason-PSGIHandler-0.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RUZ/HTML-Mason-PSGIHandler-0.53.tar.gz;
      sha256 = "eafd7c7655dfa8261df3446b931a283d30306877b83ac4671c49cff74ea7f00b";
    };
    buildInputs = [ Plack ];
    propagatedBuildInputs = [ CGIPSGI HTMLMason ];
    meta = {
      homepage = http://search.cpan.org/dist/HTML-Mason-PSGIHandler/;
      description = "PSGI handler for HTML::Mason";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.71";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.71.tar.gz;
      sha256 = "00nqzdgl7c3jilx7mil19k5jwcw3as14pvkjgxi97zyk94vqp4dy";
    };
    propagatedBuildInputs = [ HTMLTagset ];
    meta = {
      description = "HTML parser class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLQuoted = buildPerlPackage {
    name = "HTML-Quoted-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-Quoted-0.04.tar.gz;
      sha256 = "8b41f313fdc1812f02f6f6c37d58f212c84fdcf7827f7fd4b030907f39dc650c";
    };
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Extract structure of quoted HTML mail message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLRewriteAttributes = buildPerlPackage {
    name = "HTML-RewriteAttributes-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-RewriteAttributes-0.05.tar.gz;
      sha256 = "1808ec7cdf40d2708575fe6155a88f103b17fec77973a5831c2f24c250e7a58c";
    };
    propagatedBuildInputs = [ HTMLParser HTMLTagset URI ];
    meta = {
      description = "Concise attribute rewriting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLSelectorXPath = buildPerlPackage {
    name = "HTML-Selector-XPath-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.16.tar.gz;
      sha256 = "0v12plal866ifcv7m8x22abrddd6cf12gn55qclk53qqa6c8f8m6";
    };
    buildInputs = [ TestBase ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLScrubber = buildPerlPackage rec {
    name = "HTML-Scrubber-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/${name}.tar.gz";
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [ HTMLParser ];
  };

  HTMLTableExtract = buildPerlPackage rec {
    name = "HTML-TableExtract-2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSISK/${name}.tar.gz";
      sha256 = "01jimmss3q68a89696wmclvqwb2ybz6xgabpnbp6mm6jcni82z8a";
    };
    propagatedBuildInputs = [ HTMLElementExtended HTMLParser ];
  };

  HTMLTagset = buildPerlPackage rec {
    name = "HTML-Tagset-3.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "1qh8249wgr4v9vgghq77zh1d2zs176bir223a8gh3k9nksn7vcdd";
    };
  };

  HTMLTemplate = buildPerlPackage rec {
    name = "HTML-Template-2.95";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WONKO/${name}.tar.gz";
      sha256 = "07ahpfgidxsw2yb7y8i7bbr8s64aq6qgq832h9jswmksxbd0l43q";
    };
    propagatedBuildInputs = [ CGI ];
  };

  HTMLTidy = buildPerlPackage rec {
    name = "HTML-Tidy-1.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1zp4wndvr9vadbqjmd8d8ck6hlmr0dqg20vpa8cqfdflqkzqf208";
    };

    propagatedBuildInputs = [ TextDiff ];

    patchPhase = ''
      sed -i "s#/usr/include/tidyp#${pkgs.tidyp}/include/tidyp#" Makefile.PL
      sed -i "s#/usr/lib#${pkgs.tidyp}/lib#" Makefile.PL
    '';
  };

  HTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "d7cdc9d5985e2e44ceba10b756acf1e0d3a1b3ee3b516e5b54adb850fe79fda3";
    };
    meta = {
      description = "Lightweight, dependency free HTML/XML generation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTokeParserSimple = buildPerlPackage rec {
    name = "HTML-TokeParser-Simple-3.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "17aa1v62sp8ycxcicwhankmj4brs6nnfclk9z7mf1rird1f164gd";
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTreeBuilderXPath = buildPerlPackage {
    name = "HTML-TreeBuilder-XPath-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/HTML-TreeBuilder-XPath-0.14.tar.gz;
      sha256 = "1wx4i1scng20n405fp3a4vrwvvq9bvbmg977wnd5j2ja8jrbvsr5";
    };
    propagatedBuildInputs = [ HTMLTree XMLXPathEngine ];
    meta = {
      description = "Add XPath support to HTML::TreeBuilder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    doCheck = false;
    propagatedBuildInputs = [
      TestNoWarnings ClassAccessor ClassAccessorChained
      ClassDataAccessor ModulePluggableFast HTMLTree
      HTMLScrubber EmailValid DateCalc
    ];
  };

  HTTPBody = buildPerlPackage rec {
    name = "HTTP-Body-1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/${name}.tar.gz";
      sha256 = "fc0d2c585b3bd1532d92609965d589e0c87cd380e7cca42fb9ad0a1311227297";
    };
    buildInputs = [ HTTPMessage TestDeep ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP Body Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  HTTPHeadersFast = buildPerlModule rec {
    name = "HTTP-Headers-Fast-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "d2f4c9724618e74f300fc746498fb5849692ef0cfc4af47fe499c4063969e520";
    };
    buildInputs = [ ModuleBuild TestRequires ];
    propagatedBuildInputs = [ HTTPDate ];
    meta = {
      homepage = https://github.com/tokuhirom/HTTP-Headers-Fast;
      description = "Faster implementation of HTTP::Headers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPLite = buildPerlPackage rec {
    name = "HTTP-Lite-2.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "10svyy8r5ca86spz21r0k2mdy8g2slzssin4qbg101zc9kr5r65a";
    };
    buildInputs = [ ModuleBuild ];
  };

  HTTPMessage = buildPerlPackage rec {
    name = "HTTP-Message-6.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "e7b368077ae6a188d99920411d8f52a8e5acfb39574d4f5c24f46fd22533d81b";
    };
    propagatedBuildInputs = [ EncodeLocale HTTPDate IOHTML LWPMediaTypes URI ];
    meta = {
      description = "HTTP style messages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPParserXS = buildPerlPackage rec {
    name = "HTTP-Parser-XS-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/${name}.tar.gz";
      sha256 = "1sp9vllf012paslmn11b7z7fbk3hhkcp7gj59yp6qzh11xzpxlai";
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleMason = buildPerlPackage {
    name = "HTTP-Server-Simple-Mason-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-Mason-0.14.tar.gz;
      sha256 = "b7a49d8e6e55bff0b1f0278d951685466b143243b6f9e59e071f5472ca2a025a";
    };
    propagatedBuildInputs = [ HTMLMason HTTPServerSimple HookLexWrap ];
    meta = {
      description = "A simple mason server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  I18NCollate = buildPerlPackage {
    name = "I18N-Collate-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/I18N-Collate-1.02.tar.gz;
      sha256 = "9174506bc903eda89690394e3f45558ab7e013114227896d8569d6164648fe37";
    };
    meta = {
      homepage = http://search.cpan.org/dist/I18N-Collate;
      description = "Compare 8-bit scalar data according to the current locale";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  "if" = null;

  # For backwards compatibility.
  if_ = self."if";

  ImageInfo = buildPerlPackage rec {
    name = "Image-Info-1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/${name}.tar.gz";
      sha256 = "af155264667a2c22e3e2225195b8f6589329f9567e1789b7ce439ee21178713d";
    };
    propagatedBuildInputs = [ IOstringy ];
    meta = {
      description = "Extract meta information from image files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageScale = buildPerlPackage rec {
    name = "Image-Scale-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "5b2c92dc2dd635b488879461760cd251aa2b1feef41b64f17914a6e4bbe3e442";
    };
    buildInputs = [ pkgs.libpng pkgs.libjpeg ];
    propagatedBuildInputs = [ TestNoWarnings pkgs.zlib ];
    makeMakerFlags = "--with-jpeg-includes=${pkgs.libjpeg.dev}/include --with-jpeg-libs=${pkgs.libjpeg.out}/lib --with-png-includes=${pkgs.libpng.dev}/include --with-png-libs=${pkgs.libpng.out}/lib";
    meta = {
      description = "Fast, high-quality fixed-point image resizing";
      license = stdenv.lib.licenses.gpl2Plus;
    };
  };

  ImageSize = buildPerlPackage rec {
    name = "Image-Size-3.232";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/${name}.tar.gz";
      sha256 = "1mx065134gy75pgdldh65118bpcs6yfbqmr7bf9clwq44zslxhxc";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Read the dimensions of an image in several popular formats";
      license = with stdenv.lib.licenses; [ artistic1 lgpl21Plus ];
    };
  };

  IMAPClient = buildPerlPackage {
    name = "IMAP-Client-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CONTEB/IMAP-Client-0.13.tar.gz;
      sha256 = "15fa4hpw2rqg2iadyz10rnv99hns78wph5qlh3257a3mbfjjyyla";
    };
    propagatedBuildInputs = [IOSocketSSL URIIMAP];
    doCheck = false; # nondeterministic
  };

  Importer = buildPerlPackage rec {
    name = "Importer-0.024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "1d19760ceb366b664985ace9a7ee1b54a438b1e060a5bca6eff0c6a35b07a557";
    };
    meta = {
      description = "Alternative but compatible interface to modules that export symbols";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ImportInto = buildPerlPackage {
    name = "Import-Into-1.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Import-Into-1.002004.tar.gz;
      sha256 = "110hifk3cj14lxgjq2vaa2qfja21gll4lpn8vbimy0gzqadjbjyy";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Import packages into other packages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IO = buildPerlPackage {
    name = "IO-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/IO-1.25.tar.gz;
      sha256 = "89790db8b9281235dc995c1a85d532042ff68a90e1504abd39d463f05623e7b5";
    };
    doCheck = false;
    meta = {
      description = "Perl core IO modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAll = buildPerlPackage {
    name = "IO-All-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/IO-All-0.60.tar.gz;
      sha256 = "1bwsd2f5rlivcqyd7rb0ap5vrzv8s8fappi3b1v553yr5vl5pyq9";
    };
    propagatedBuildInputs = [ IOString ];
    meta = {
      homepage = https://github.com/ingydotnet/io-all-pm/tree;
      description = "IO::All of it to Graham and Damian!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOCaptureOutput = buildPerlPackage rec {
    name = "IO-CaptureOutput-1.1104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "fcc732fcb438f97a72b30e8c7796484bef2562e374553b207028e2fbf73f8330";
    };
    meta = {
      homepage = https://github.com/dagolden/IO-CaptureOutput;
      description = "Capture STDOUT and STDERR from Perl code, subprocesses or XS";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCompress = buildPerlPackage rec {
    name = "IO-Compress-2.070";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "3e761b833c8e55eb811a5eeab07831bb380dcdce256cc45cfe8816602a3574ff";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "IO Interface to compressed data files/buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
    # Same as CompressRawZlib
    doCheck = false && !stdenv.isDarwin;
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.11.tar.gz;
      sha256 = "14kz7z4xw179aya3116wxac29l4y2wmwrba087lya4v2gxdgiz4g";
    };
    propagatedBuildInputs = [PerlIOviadynamic];
  };

  IOHTML = buildPerlPackage {
    name = "IO-HTML-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-1.001.tar.gz;
      sha256 = "ea78d2d743794adc028bc9589538eb867174b4e165d7d8b5f63486e6b828e7e0";
    };
    meta = {
      description = "Open an HTML file with automatic charset detection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  IOInteractive = buildPerlPackage {
    name = "IO-Interactive-0.0.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/IO-Interactive-0.0.6.tar.gz;
      sha256 = "9cc016cbd94b500027e137cb5070d19487e4431bf822f0cb534c38b6b2c1038c";
    };
    meta = {
      description = "Utilities for interactive I/O";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOLockedFile = buildPerlPackage rec {
    name = "IO-LockedFile-0.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "1dgq8zfkaszisdb5hz8jgcl0xc3qpv7bbv562l31xgpiddm7xnxi";
    };
  };

  IOMultiplex = buildPerlPackage {
    name = "IO-Multiplex-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBB/IO-Multiplex-1.16.tar.gz;
      sha256 = "74d22c44b5ad2e7190e2786e8a17d74bbf4cef89b4d1157ba33598b5a2720dad";
    };
  };

  IOPager = buildPerlPackage {
    name = "IO-Pager-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
    };
  };

  IOPrompt = buildPerlPackage {
    name = "IO-Prompt-0.997002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/IO-Prompt-0.997002.tar.gz;
      sha256 = "08ad24f58335ce9696666e4411b2f3cd9c2e1fb72b306b6018c1a13971361ced";
    };
    propagatedBuildInputs = [ TermReadKey Want ];
    doCheck = false; # needs access to /dev/tty
    meta = {
      description = "Interactively prompt for user input";
    };
  };

  IOSocketIP = buildPerlPackage {
    name = "IO-Socket-IP-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/IO-Socket-IP-0.37.tar.gz;
      sha256 = "2adc5f0b641d41f662b4d99c0795780c62f9af9119884d053265fc8858ae6f7b";
    };
    meta = {
      description = "Family-neutral IP socket supporting both IPv4 and IPv6";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketInet6 = buildPerlPackage rec {
    name = "IO-Socket-INET6-2.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1fqypz6qa5rw2d5y2zq7f49frwra0aln13nhq5gi514j2zx21q45";
    };
    propagatedBuildInputs = [Socket6];
    doCheck = false;
  };

  IOSocketSSL = buildPerlPackage rec {
    name = "IO-Socket-SSL-2.039";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SULLR/${name}.tar.gz";
      sha256 = "c6379a76860c724a22b79ebe9e91d26bd8a04e3ce035bacfd15de3d9beaf83ac";
    };
    propagatedBuildInputs = [ NetSSLeay URI ];
    # Fix path to default certificate store.
    postPatch = ''
      substituteInPlace lib/IO/Socket/SSL.pm \
        --replace "\$openssldir/cert.pem" "/etc/ssl/certs/ca-certificates.crt"
    '';
    meta = {
      homepage = https://github.com/noxxi/p5-io-socket-ssl;
      description = "Nearly transparent SSL encapsulation for IO::Socket::INET";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false; # tries to connect to facebook.com etc.
  };

  IOSocketTimeout = buildPerlPackage rec {
    name = "IO-Socket-Timeout-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "edf915d6cc66bee43503aa6dc2b373366f38eaff701582183dad10cb8adf2972";
    };
    buildInputs = [ ModuleBuildTiny TestTCP ];
    propagatedBuildInputs = [ PerlIOviaTimeout ];
    meta = {
      description = "IO::Socket with read/write timeout";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  IOString = buildPerlPackage rec {
    name = "IO-String-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0";
    };
  };

  IOstringy = pkgs.perlPackages.IOStringy;

  IOStringy = buildPerlPackage rec {
    name = "IO-stringy-2.110";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSKOLL/${name}.tar.gz";
      sha256 = "1vh4n0k22hx20rwvf6h7lp25wb7spg0089shrf92d2lkncwg8g3y";
    };
  };

  IOTee = buildPerlPackage rec {
    name = "IO-Tee-0.64";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KENSHAN/${name}.tar.gz";
      sha256 = "1mjy6hmwrzipzxcm33qs7ja89ljk6zkk499wclw16lfkqaqpdliy";
    };
  };

  IOTieCombine = buildPerlPackage {
    name = "IO-TieCombine-1.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.004.tar.gz;
      sha256 = "0awyyjdbjjawdkzs08rfjhfkkm7pni523x3ddmq9ixa82ibnn430";
    };
    meta = {
      homepage = https://github.com/rjbs/io-tiecombine;
      description = "Produce tied (and other) separate but combined variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOTty = buildPerlPackage rec {
    name = "IO-Tty-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "0399anjy3bc0w8xzsc3qx5vcyqryc9gc52lc7wh7i49hsdq8gvx2";
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
  };

  IPCRun3 = buildPerlPackage rec {
    name = "IPC-Run3-0.048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0r9m8q78bg7yycpixd7738jm40yz71p2q7inm766kzsw3g6c709x";
    };
  };

  IPCShareLite = buildPerlPackage rec {
    name = "IPC-ShareLite-0.17";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IPC/${name}.tar.gz";
      sha256 = "1gz7dbwxrzbzdsjv11kb49jlf9q6lci2va6is0hnavd93nwhdm0l";
    };
  };

  IPCSystemSimple = buildPerlPackage {
    name = "IPC-System-Simple-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PJ/PJF/IPC-System-Simple-1.25.tar.gz;
      sha256 = "f1b6aa1dfab886e8e4ea825f46a1cbb26038ef3e727fef5d84444aa8035a4d3b";
    };
    meta = {
      description = "Run commands simply, with detailed diagnostics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCSysV = buildPerlPackage {
    name = "IPC-SysV-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/IPC-SysV-2.04.tar.gz;
      sha256 = "93248930e667034899bf2b09b9a23348e2b800a5437fbb9b4f34c37316da3fcc";
    };
    meta = {
      description = "System V IPC constants and system calls";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageExifTool = buildPerlPackage rec {
    name = "Image-ExifTool-9.27";

    src = fetchurl {
      url = "http://www.sno.phy.queensu.ca/~phil/exiftool/${name}.tar.gz";
      sha256 = "1f37pi7a6fcphp0kkhj7yr9b5c95m2wvy5jcwjq1xdiq74gdi16c";
    };

    meta = with stdenv.lib; {
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

      license = with licenses; [ gpl1Plus /* or */ artistic2 ];

      maintainers = [ ];
      platforms = platforms.unix;
    };
  };

  Inline = buildPerlPackage rec {
    name = "Inline-0.64";

    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/${name}.tar.gz";
      sha256 = "17n3gbc9jigpfwqfhgmxpvbgr9rkdrij8jayxqpzw611ixcxrplw";
    };

    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ParseRecDescent ];

    meta = {
      description = "Inline -- Write Perl subroutines in other programming languages";

      longDescription = ''
        The Inline module allows you to put source code from other
        programming languages directly "inline" in a Perl script or
        module. The code is automatically compiled as needed, and then loaded
        for immediate access from Perl.
      '';

      license = stdenv.lib.licenses.artistic2;

      maintainers = [ ];
    };
  };

  InlineC = buildPerlPackage rec {
    name = "Inline-C-0.76";

    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0dcs39zjiglif3ss8p8yl0jyqk7qvc9g1ad9wi4kq79k9lxp3s92";
    };

    postPatch = ''
      # this test will fail with chroot builds
      rm -f t/08taint.t
      rm -f t/28autowrap.t
    '';

    buildInputs = [ TestWarn FileCopyRecursive FileShareDirInstall IOAll Pegex YAMLLibYAML ];
    propagatedBuildInputs = [ Inline ];

    meta = {
      description = "Write Perl Subroutines in C";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

      license = stdenv.lib.licenses.artistic2;

      maintainers = [ ];
    };
  };

  IPCSignal = buildPerlPackage rec {
    name = "IPC-Signal-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1l3g0zrcwf2whwjhbpwdcridb7c77mydwxvfykqg1h6hqb4gj8bw";
    };
  };

  JavaScriptMinifierXS = buildPerlPackage rec {
    name = "JavaScript-Minifier-XS-0.11";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/G/GT/GTERMARS/JavaScript-Minifier-XS-0.11.tar.gz";
      sha256 = "1vlyhckpjbrg2v4dy9szsxxl0q44n0y1xl763mg2y2ym9g5144hm";
    };
    propagatedBuildInputs = [ ];
    meta = {
      description = "XS based JavaScript minifier";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  JSON = buildPerlPackage {
    name = "JSON-2.90";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz;
      sha256 = "127yppvr17qik9pkd1vy901hs4l13kg6rhp76jdgcyask35v7nsd";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONAny = buildPerlPackage {
    name = "JSON-Any-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/JSON-Any-1.29.tar.gz;
      sha256 = "15v2j9dh58r7r4s7rnnmgnzzbyz61bhyxwpx1z7r811ixs9bkks2";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Wrapper Class for the various JSON classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONMaybeXS = buildPerlPackage rec {
    name = "JSON-MaybeXS-1.003005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "02n8dkj3qpzikkqyki8gvdk1pfdqrs9qcrdr96fla42gar5nkd5x";
    };
    buildInputs = [ TestWithoutModule ];
    propagatedBuildInputs = [ JSONPP ];
    meta = {
      description = "Use L<Cpanel::JSON::XS> with a fallback to L<JSON::XS> and L<JSON::PP>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPP = buildPerlPackage rec {
    name = "JSON-PP-2.27203";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27203.tar.gz;
      sha256 = "0ljwya1fb4969pckcq2j1g6axgx8qh9yscxbs6qf62qxf8wkj1mp";
    };
    meta = {
      description = "JSON::XS compatible pure-Perl module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPPCompat5006 = buildPerlPackage {
    name = "JSON-PP-Compat5006-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-Compat5006-1.09.tar.gz;
      sha256 = "197030df52635f9bbe25af10742eea5bd74971473118c11311fcabcb62e3716a";
    };
    meta = {
      description = "Helper module in using JSON::PP in Perl 5.6";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

 JSONWebToken = buildPerlModule rec {
    name = "JSON-WebToken-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/${name}.tar.gz";
      sha256 = "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b";
    };
    buildInputs = [ TestMockGuard TestRequires ];
    propagatedBuildInputs = [ JSON ];
    meta = {
      homepage = https://github.com/xaicron/p5-JSON-WebToken;
      description = "JSON Web Token (JWT) implementation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONXS = buildPerlPackage {
    name = "JSON-XS-2.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-2.34.tar.gz;
      sha256 = "1sh0i73skxp3rvd9w8phxqncw9m1r5ibnb9qxxm21bmrfwkxybx6";
    };
    propagatedBuildInputs = [ CommonSense ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
  };

  JSONXSVersionOneAndTwo = buildPerlPackage rec {
    name = "JSON-XS-VersionOneAndTwo-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "e6092c4d961fae777acf7fe99fb3cd6e5b710fec85765a6b90417480e4c94a34";
    };
    propagatedBuildInputs = [ JSONXS ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Later = buildPerlPackage rec {
    version = "0.19";
    name = "Object-Realize-Later-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "0ka0qar51kk5wlvd2s3yis3w9qc14h0ngn0ds0v6c8ssmjvfcgbz";
    };
  };

  lib_ = buildPerlPackage {
    name = "lib-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/lib-0.63.tar.gz;
      sha256 = "72f63db9220098e834d7a38231626bd0c9b802c1ec54a628e2df35f3818e5a00";
    };
    meta = {
      description = "Manipulate @INC at compile time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libapreq2 = buildPerlPackage {
    name = "libapreq2-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISAAC/libapreq2-2.13.tar.gz;
      sha256 = "5731e6833b32d88e4a5c690e45ddf20fcf969ce3da666c5627d775e92da0cf6e";
    };
    buildInputs = [ ApacheTest ExtUtilsXSBuilder mod_perl2 pkgs.apacheHttpd pkgs.apr pkgs.aprutil ];
    propagatedBuildInputs = [ mod_perl2 ];
    makeMakerFlags = "--with-apache2-src=${pkgs.apacheHttpd.dev} --with-apache2-apxs=${pkgs.apacheHttpd.dev}/bin/apxs --with-apache2-httpd=${pkgs.apacheHttpd.out}/bin/httpd --with-apr-config=${pkgs.apr.dev}/bin/apr-1-config --with-apu-config=${pkgs.aprutil.dev}/bin/apu-1-config";
    preConfigure = ''
      # override broken prereq check
      substituteInPlace configure --replace "prereq_check=\"\$PERL \$PERL_OPTS build/version_check.pl\"" "prereq_check=\"echo\""
      '';
    preBuild = ''
      substituteInPlace apreq2-config --replace "dirname" "${pkgs.coreutils}/bin/dirname"
      '';
    installPhase = ''
      mkdir $out
      make install DESTDIR=$out
      cp -r $out/${pkgs.apacheHttpd.dev}/. $out/.
      cp -r $out/$out/. $out/.
      rm -r $out/nix
      '';
    doCheck = false; # test would need to start apache httpd
    meta = {
      license = stdenv.lib.licenses.asl20;
    };
  };

  libintlperl = pkgs.perlPackages.libintl_perl;

  libintl_perl = buildPerlPackage rec {
    name = "libintl-perl-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.23.tar.gz;
      sha256 = "1ylz6yhjifblhmnva0k05ch12a4cdii5v0icah69ma1gdhsidnk0";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  libnet = buildPerlPackage rec {
    name = "libnet-3.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
      sha256 = "21ebae642b53336576c370989d238cbe74378944079aca6f97665158c9f1750b";
    };
    meta = {
      description = "Collection of network protocol modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  LinguaENFindNumber = buildPerlPackage {
    name = "Lingua-EN-FindNumber-1.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-FindNumber-1.31.tar.gz;
      sha256 = "f67f4d4983bd29da5cbbff3cb18dd70788692b35e2dabcd4c65bef1cd2bf658f";
    };
    propagatedBuildInputs = [ LinguaENWords2Nums ];
    meta = {
      homepage = https://github.com/neilbowers/Lingua-EN-FindNumber;
      description = "Locate (written) numbers in English text";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflect = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-1.899";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/${name}.tar.gz";
      sha256 = "1599a93020a2fdc0de8db14eea721df8fd772f78dedaf81081081fc93aa6a257";
    };
    meta = {
      description = "Convert singular to plural. Select 'a' or 'an'";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectNumber = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Number-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "66fb33838512746f5c597e80264fea66643f7f26570ec2f9205b6135ad67acbf";
    };
    propagatedBuildInputs = [ LinguaENInflect ];
    meta = {
      homepage = https://github.com/neilbowers/Lingua-EN-Inflect-Number;
      description = "Force number of words to singular or plural";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectPhrase = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Phrase-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "290a5b8fc2be28d6d479517655027a90e944476cb3552f10cbf6db37af79f9a6";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ LinguaENFindNumber LinguaENInflect LinguaENInflectNumber LinguaENNumberIsOrdinal LinguaENTagger ];
    meta = {
      homepage = http://metacpan.org/release/Lingua-EN-Inflect-Phrase;
      description = "Inflect short English Phrases";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENNumberIsOrdinal = buildPerlPackage {
    name = "Lingua-EN-Number-IsOrdinal-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Number-IsOrdinal-0.05.tar.gz;
      sha256 = "28d5695400c0f4e2bd209793cb74f6da2b9257356aacb2947c603425e09618d6";
    };
    buildInputs = [ TestFatal TryTiny ];
    propagatedBuildInputs = [ LinguaENFindNumber ];
    meta = {
      homepage = http://metacpan.org/release/Lingua-EN-Number-IsOrdinal;
      description = "Detect if English number is ordinal or cardinal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENTagger = buildPerlPackage {
    name = "Lingua-EN-Tagger-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.24.tar.gz;
      sha256 = "0qksqh1zi8fz76a29s2ll4g6yr8y6agmzgq7ngccvgj3gza5q241";
    };
    propagatedBuildInputs = [ HTMLParser HTMLTagset LinguaStem /* MemoizeExpireLRU */ ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing";
      license = stdenv.lib.licenses.gpl3;
    };
  };

  LinguaENWords2Nums = buildPerlPackage {
    name = "Lingua-EN-Words2Nums-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOEY/Lingua-EN-Words2Nums-0.18.tar.gz;
      sha256 = "686556797cd2a4eaa066f19bbf03ab25c06278292c9ead2f187dfd9031ea1d85";
    };
    meta = {
      description = "Convert English text to numbers";
      license = "unknown";
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

  LinguaTranslit = buildPerlPackage rec {
    name = "Lingua-Translit-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALINKE/${name}.tar.gz";
      sha256 = "2430b5c84927f15570533eb68c56958c580f16044fc413d48bf44f0460422598";
    };
    doCheck = false;
  };

  LinuxDistribution = buildPerlPackage {
    name = "Linux-Distribution-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Linux-Distribution-0.23.tar.gz;
      sha256 = "603e27da607b3e872a669d7a66d75982f0969153eab2d4b20c341347b4ebda5f";
    };
    # The tests fail if the distro it's built on isn't in the supported list.
    # This includes NixOS.
    doCheck = false;
    meta = {
      description = "Perl extension to detect on which Linux distribution we are running";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinuxInotify2 = buildPerlPackage rec {
    name = "Linux-Inotify2-1.22";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Linux/${name}.tar.gz";
      sha256 = "1l916p8xak6c51x4x1vrzd8wpi55bld74wf0p5w5m4vr80zjb7dw";
    };
    propagatedBuildInputs = [ CommonSense ];
  };

  ListAllUtils = buildPerlPackage {
    name = "List-AllUtils-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/List-AllUtils-0.09.tar.gz;
      sha256 = "4cfe6359cc6c9f4ba0d178e223f4b468d3cf7768d645334962f05de069bdaee2";
    };
    buildInputs = [ TestWarnings ];
    propagatedBuildInputs = [ ListMoreUtils ];
    meta = {
      description = "Combines List::Util and List::MoreUtils in one bite-sized package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ListBinarySearch = pkgs.buildPerlPackage {
    name = "List-BinarySearch-0.20";
    src = pkgs.fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/List-BinarySearch-0.20.tar.gz;
      sha256 = "1piyl65m38bwqaap13wkgs033wiwb6m5zmr5va86ya4696cir7wd";
    };
  };

  ListMoreUtils = buildPerlPackage rec {
    name = "List-MoreUtils-0.413";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "4d6429d5672ce74a59d6490320252cb8b5b8285db8fe9c6551a4162e5375ef37";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    meta = {
      homepage = https://metacpan.org/release/List-MoreUtils;
      description = "Provide the stuff missing in List::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListSomeUtils = buildPerlPackage rec {
    name = "List-SomeUtils-0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1e8c900332ac08c314b78ca1b0d23aba28c146b6133606a817d828d5bd0485ac";
    };
    buildInputs = [ TestLeakTrace ];
    propagatedBuildInputs = [ ExporterTiny ModuleImplementation ];
    meta = {
      homepage = http://metacpan.org/release/List-SomeUtils;
      description = "Provide the stuff missing in List::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListUtilsBy = buildPerlPackage rec {
    name = "List-UtilsBy-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.09.tar.gz;
      sha256 = "1xcsgz8898h670zmwqd8azfn3a2y9nq7z8cva9dsyhzkk8ajmra1";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LocaleCodes = buildPerlPackage {
    name = "Locale-Codes-3.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.35.tar.gz;
      sha256 = "b1a2f944b03972d2b7282767cf88100e3c0d7daa3f4ca7aef8460c1c5e246480";
    };
    meta = {
      description = "A distribution of modules to handle locale codes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleGettext = buildPerlPackage {
    name = "LocaleGettext-1.05";
    buildInputs = stdenv.lib.optional (stdenv.isFreeBSD || stdenv.isDarwin || stdenv.isCygwin) pkgs.gettext;
    NIX_CFLAGS_LINK = stdenv.lib.optional (stdenv.isFreeBSD || stdenv.isDarwin || stdenv.isCygwin) "-lintl";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.05.tar.gz;
      sha256 = "15262a00vx714szpx8p2z52wxkz46xp7acl72znwjydyq4ypydi7";
    };
  };

  LocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Locale-Maketext-1.23.tar.gz;
      sha256 = "1r1sq7djafvk5abzc4l068p39dz44hlpgdldj3igvn2bjz78cli1";
    };
  };

  LocaleMaketextFuzzy = buildPerlPackage {
    name = "Locale-Maketext-Fuzzy-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Fuzzy-0.11.tar.gz;
      sha256 = "3785171ceb78cc7671319a3a6d8ced9b190e097dfcd9b2a9ebc804cd1a282f96";
    };
    meta = {
      description = "Maketext from already interpolated strings";
      license = "unrestricted";
    };
  };

  LocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DRTECH/Locale-Maketext-Lexicon-1.00.tar.gz;
      sha256 = "b73f6b04a58d3f0e38ebf2115a4c1532f1a4eef6fac5c6a2a449e4e14c1ddc7c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Locale-Maketext-Lexicon;
      description = "Use other catalog formats in Maketext";
      license = "mit";
    };
  };

  LocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Locale-Maketext-Simple-0.21.tar.gz;
      sha256 = "1ad9vh45j8c32nzkbjipinawyg1pnjckwlhsjqcqs47vyi8zy2dh";
    };
  };

  LocaleMsgfmt = buildPerlPackage {
    name = "Locale-Msgfmt-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AZ/AZAWAWI/Locale-Msgfmt-0.15.tar.gz;
      sha256 = "c3276831cbeecf58be02081bcc180bd348daa35da21a7737b7b038a59f643ab4";
    };
    meta = {
      description = "Compile .po files to .mo files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocalePO = buildPerlPackage {
    name = "Locale-PO-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/Locale-PO-0.23.tar.gz;
      sha256 = "52e5fdc88ec4eb00512418a938dc5089476ea66c9e744fee3c6bbfdf17a0d302";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Perl module for manipulating .po entries from GNU gettext";
      license = "unknown";
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  locallib = buildPerlPackage rec {
    name = "local-lib-2.000019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "008b9kgvcs9vjvj7ifg0f1s7i7446ff2441c575vhrwn15x35b9n";
    };
    meta = {
      description = "Create and use a local lib/ for perl modules with PERL5LIB";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LockFileSimple = buildPerlPackage rec {
    name = "LockFile-Simple-0.208";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/lockfile-simple/LockFile-Simple-0.208.tar.gz";
      sha256 = "18pk5a030dsg1h6wd8c47wl8pzrpyh9zi9h2c9gs9855nab7iis5";
    };
  };

  LogAny = buildPerlPackage rec {
    name = "Log-Any-1.045";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/${name}.tar.gz";
      sha256 = "d95180c0c2d50d7d3a541e0c79d83ee6b4ad5787e1785b361fed450c2dec8400";
    };
    meta = {
      homepage = https://github.com/preaction/Log-Any;
      description = "Bringing loggers and listeners together";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  LogContextual = buildPerlPackage {
    name = "Log-Contextual-0.006003";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Log-Contextual-0.006003.tar.gz;
      sha256 = "0940s910n67arqvz7aji4z6vgzzl52aq3l3jg8vq4ygnkn7c9k21";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DataDumperConcise ExporterDeclare Moo ];
    meta = {
      description = "Simple logging interface with a contextual log";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LogDispatch = buildPerlPackage {
    name = "Log-Dispatch-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Log-Dispatch-2.41.tar.gz;
      sha256 = "0vsmlkx2g9lc13pl9v96kn575yszfvd79a236b8v0s1di83gm09z";
    };
    propagatedBuildInputs = [ ClassLoad ParamsValidate ];
    meta = {
      description = "Dispatches messages to one or more outputs";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LogHandler = buildPerlPackage rec {
    name = "Log-Handler-0.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BL/BLOONIX/${name}.tar.gz";
      sha256 = "45bf540ab2138ed3ff93afc205b0516dc75755b86acdcc5e75c41347833c293d";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Log messages to several outputs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  LogMessage = buildPerlPackage {
    name = "Log-Message-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-0.08.tar.gz;
      sha256 = "bd697dd62aaf26d118e9f0a0813429deb1c544e4501559879b61fcbdfe99fe46";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      description = "Powerful and flexible message logging mechanism";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogTrace = buildPerlPackage rec {
    name = "Log-Trace-1.070";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Log/${name}.tar.gz";
      sha256 = "1qrnxn9b05cqyw1286djllnj8wzys10754glxx6z5hihxxc85jwy";
    };
  };

  LogLog4perl = buildPerlPackage rec {
    name = "Log-Log4perl-1.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/${name}.tar.gz";
      sha256 = "b739187f519146cb6bebcfc427c64b1f4138b35c5f4c96f46a21ed4a43872e16";
    };
    meta = {
      homepage = https://mschilli.github.io/log4perl/;
      description = "Log4j implementation for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  # For backwards compatibility.
  Log4Perl = self.LogLog4perl;

  LogDispatchArray = buildPerlPackage {
    name = "Log-Dispatch-Array-1.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatch-Array-1.003.tar.gz;
      sha256 = "0dvzp0gsh17jqg02460ndchyapr1haahndq1p9v6mwkv5wf9680c";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ LogDispatch ];
    meta = {
      homepage = https://github.com/rjbs/log-dispatch-array;
      description = "Log events to an array (reference)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatchouli = buildPerlPackage rec {
    name = "Log-Dispatchouli-2.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "214eca0fe77f2dc74675f9aa542778d5d4618c5bf12283540ca1062fcb967fa0";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ LogDispatch LogDispatchArray ParamsUtil StringFlogger SubExporter SubExporterGlobExporter TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Log-Dispatchouli;
      description = "A simple wrapper around Log::Dispatch";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogLogLite = buildPerlPackage rec {
    name = "Log-LogLite-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RANI/${name}.tar.gz";
      sha256 = "0sqsa4750wvhw4cjmxpxqg30i1jjcddadccflisrdb23qn5zn285";
    };
    propagatedBuildInputs = [ IOLockedFile ];
    meta = {
      description = "Helps us create simple logs for our application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWP = buildPerlPackage rec {
    name = "libwww-perl-6.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "6f349d45c21b1ec0501c4437dfcb70570940e6c3d5bff783bd91d4cddead8322";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPMessage HTTPNegotiate LWPMediaTypes NetHTTP URI WWWRobotRules ];
    meta = with stdenv.lib; {
      description = "The World-Wide Web library for Perl";
      license = with licenses; [ artistic1 gpl1Plus ];
      platforms = platforms.unix;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolconnect = pkgs.perlPackages.LWPProtocolConnect;

  LWPProtocolConnect = buildPerlPackage {
    name = "LWP-Protocol-connect-6.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BE/BENNING/LWP-Protocol-connect-6.09.tar.gz;
      sha256 = "9f252394775e23aa42c3176611e5930638ab528d5190110b4731aa5b0bf35a15";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ HTTPMessage IOSocketSSL LWP LWPProtocolhttps URI ];
    meta = {
      description = "Provides HTTP/CONNECT proxy support for LWP::UserAgent";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolhttps = pkgs.perlPackages.LWPProtocolHttps;

  LWPProtocolHttps = buildPerlPackage rec {
    name = "LWP-Protocol-https-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/LWP-Protocol-https-6.04.tar.gz;
      sha256 = "0agnga5dg94222h6rlzqxa0dri2sh3gayncvfb7jad9nxr87gxhy";
    };
    patches = [ ../development/perl-modules/lwp-protocol-https-cert-file.patch ];
    propagatedBuildInputs = [ LWP IOSocketSSL ];
    doCheck = false; # tries to connect to https://www.apache.org/.
    meta = {
      description = "Provide https support for LWP::UserAgent";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };

  LWPUserAgent = buildPerlPackage {
    name = "LWP-UserAgent-6.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/libwww-perl-6.05.tar.gz;
      sha256 = "08wgwyz7748pv5cyngxia0xl6nragfnhrp4p9s78xhgfyygpj9bv";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPNegotiate HTTPMessage LWPMediaTypes NetHTTP URI WWWRobotRules ];
    meta = {
      description = "The World-Wide Web library for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentDetermined = buildPerlPackage {
    name = "LWP-UserAgent-Determined-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/LWP-UserAgent-Determined-1.06.tar.gz;
      sha256 = "c31d8e16dc92e2113c81cdbfb11149cfd19039e789f77cd34333ac9184346fc5";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A virtual browser that retries errors";
      license = "unknown";
    };
  };

  LWPUserAgentMockable = buildPerlPackage {
    name = "LWP-UserAgent-Mockable-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMORGAN/LWP-UserAgent-Mockable-1.10.tgz;
      sha256 = "1z89jszgifvjb8irzd8wrzim7l5m4hypdl9mj4dpkb4jm4189kmn";
    };
    propagatedBuildInputs = [ LWP HookLexWrap ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    # Tests require network connectivity
    # https://rt.cpan.org/Public/Bug/Display.html?id=63966 is the bug upstream,
    # which doesn't look like it will get fixed anytime soon.
    doCheck = false;
  };

  LWPxParanoidAgent = buildPerlPackage rec {
    name = "LWPx-ParanoidAgent-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/lwp/${name}.tar.gz";
      sha256 = "0i306p7mdqx09qfsf6b3rnn5xw9v9r3md4swlbk9z0mskjl0l4w4";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
  };

  maatkit = import ../development/perl-modules/maatkit {
    inherit fetchurl buildPerlPackage stdenv DBDmysql;
  };

  MailMaildir = buildPerlPackage rec {
    version = "1.0.0";
    name = "Mail-Maildir-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEROALTI/Mail-Maildir-100/${name}.tar.bz2";
      sha256 = "1krkqfps6q3ifrhi9450l5gm9199qyfcm6vidllr0dv65kdaqpj4";
    };
  };

  MailBox = buildPerlPackage rec {
    version = "2.118";
    name = "Mail-Box-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1ixi7xpvj8kn2y0l8rxkvdnnl7x5wqg7mi2av0viwdh5l828dcfc";
    };

    doCheck = false;

    propagatedBuildInputs = [
      Later

      DevelGlobalDestruction
      FileRemove
      IOStringy
      MailTools
      MIMETypes
    ];
  };

  MailMboxMessageParser = buildPerlPackage rec {
    name = "Mail-Mbox-MessageParser-1.5105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/${name}.tar.gz";
      sha256 = "641edd8b7ab74de671ab4931311413c1bd037a1c3eaa0a0c97451cd7b104f2d8";
    };
    buildInputs = [ FileSlurp TextDiff URI ];
    propagatedBuildInputs = [ FileHandleUnget ];
    meta = {
      homepage = https://github.com/coppit/mail-mbox-messageparser;
      description = "A fast and simple mbox folder reader";
      license = stdenv.lib.licenses.gpl2;
      maintainers = with maintainers; [ romildo ];
    };
  };

  MailDKIM = buildPerlPackage rec {
    name = "Mail-DKIM-0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JASLONG/${name}.tar.gz";
      sha256 = "1wd6mab4fp47v1nh85jfxsjmysnyv5mwvfv47cn5m2h2lb1s0piw";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA NetDNS MailTools ];
    doCheck = false; # tries to access the domain name system
  };

  MailIMAPClient = buildPerlPackage {
    name = "Mail-IMAPClient-3.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz;
      sha256 = "0qzn8370cr91jnq1kawy6v16bcz49pch6inmw85rhzg87j1h6ica";
    };
    buildInputs = [ParseRecDescent];
  };

  MailRFC822Address = buildPerlPackage {
    name = "Mail-RFC822-Address-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PD/PDWARREN/Mail-RFC822-Address-0.3.tar.gz;
      sha256 = "351ef4104ecb675ecae69008243fae8243d1a7e53c681eeb759e7b781684c8a7";
    };
  };

  MailTools = buildPerlPackage rec {
    name = "MailTools-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1y6zndb4rsn8i65g1bg3b0zb7966cz83q19zg7m7bvxjfkv7wz2b";
    };
    propagatedBuildInputs = [ TimeDate ];
    meta = {
      description = "Various e-mail related modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MathLibm = buildPerlPackage rec {
    name = "Math-Libm-1.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0xn2a950mzzs5q1c4q98ckysn9dz20x7r35g02zvk35chgr0klxz";
    };
  };

  MathCalcUnits = buildPerlPackage rec {
    name = "Math-Calc-Units-1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SF/SFINK/${name}.tar.gz";
      sha256 = "13wgbxv2fmigdj0vf7nwkq1y2q07jgfj8wdrpqkywfxv4zdwzqv1";
    };
    meta = {
      description = "Human-readable unit-aware calculator";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
    };
  };

  MathBigInt = buildPerlPackage rec {
    name = "Math-BigInt-1.999806";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "9b62b2fcfeed5ef42d375778e4ec3b469cab0002b5dc247906dc99f5786fa1fc";
    };
    meta = {
      description = "Arbitrary size integer/float math package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBigIntGMP = buildPerlPackage rec {
    name = "Math-BigInt-GMP-1.38";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "05bg10gg3ksn4h08yyyj7f31rqhdqap8d0jsbq61b3x0274wml0s";
    };
    buildInputs = [ pkgs.gmp ];
    doCheck = false;
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
  };

  MathBigRat = buildPerlPackage rec {
    name = "Math-BigRat-0.2611";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "a8a033d0ccac9ac641c73867d71f2455ecb2339984cd964b1e3cfb2859e9fd81";
    };
    propagatedBuildInputs = [ MathBigInt ];
    meta = {
      description = "Arbitrary big rational numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathClipper = buildPerlModule rec {
    name = "Math-Clipper-1.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0i9wzvig7ayijc9nvh5x5rryk1jrcj1hcvfmlcj449rnnxx24dav";
    };
    propagatedBuildInputs = [ ModuleBuildWithXSpp ExtUtilsXSpp ExtUtilsTypemapsDefault TestDeep ];
  };

  MathComplex = buildPerlPackage {
    name = "Math-Complex-1.59";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Math-Complex-1.59.tar.gz;
      sha256 = "f35eb4987512c51d2c47294a008ede210d8dd759b90b887d04847c69b42dd6d1";
    };
  };

  MathConvexHullMonotoneChain = buildPerlPackage rec {
    name = "Math-ConvexHull-MonotoneChain-0.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "1xcl7cz62ydddji9qzs4xsfxss484jqjlj4iixa4aci611cw92r8";
    };
  };

  MathGeometryVoronoi = buildPerlPackage rec {
    name = "Math-Geometry-Voronoi-1.3";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0b206k2q5cznld45cjhgm0as0clc9hk135ds8qafbkl3k175w1vj";
    };
    propagatedBuildInputs = [ ClassAccessor ParamsValidate ];
  };

  MathPlanePath = buildPerlPackage rec {
    name = "Math-PlanePath-123";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "13by23pzwfa2f3rxiws7blqxb8lr3mfczdfq6jsi1kb3ml2wnxyc";
    };
    propagatedBuildInputs = [ MathLibm constant-defer ];
  };

  MathRandomISAAC = buildPerlPackage {
    name = "Math-Random-ISAAC-1.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz;
      sha256 = "0z1b3xbb3xz71h25fg6jgsccra7migq7s0vawx2rfzi0pwpz0wr7";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      homepage = http://search.cpan.org/dist/Math-Random-ISAAC;
      description = "Perl interface to the ISAAC PRNG algorithm";
      license = with stdenv.lib.licenses; [ publicDomain mit artistic2 gpl3 ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomMTAuto = buildPerlPackage {
    name = "Math-Random-MT-Auto-6.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.22.tar.gz;
      sha256 = "07zha5zjxyvqwnycb1vzk4hk2m46n9yc5lrbvhkc22595dsyjahz";
    };
    propagatedBuildInputs = [ ExceptionClass ObjectInsideOut ];
    meta = {
      description = "Auto-seeded Mersenne Twister PRNGs";
      license = "unrestricted";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomSecure = buildPerlPackage {
    name = "Math-Random-Secure-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MK/MKANAT/Math-Random-Secure-0.06.tar.gz;
      sha256 = "0392h78l3shkba9l2c43rgz6sm5qv7pzdylgb7gp9milprn77crc";
    };
    buildInputs = [ ListMoreUtils TestWarn ];
    propagatedBuildInputs = [ AnyMoose CryptRandomSource MathRandomISAAC ];
    meta = {
      description = "Cryptographically-secure, cross-platform replacement for rand()";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRound = buildPerlPackage rec {
    name = "Math-Round-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "194dvggf1cmzc701j4wma38jgrcv2pwwzk69rnysjjdcjdv6y255";
    };
  };

  Memoize = buildPerlPackage {
    name = "Memoize-1.03.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Memoize-1.03.tgz;
      sha256 = "5239cc5f644a50b0de9ffeaa51fa9991eb06ecb1bf4678873e3ab89af9c0daf3";
    };
  };

  MetaBuilder = buildPerlModule {
    name = "Meta-Builder-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Meta-Builder-0.003.tar.gz;
      sha256 = "e7ac289b88d1662e87708d716877ac66a1a8414660996fe58c1db96d834a5375";
    };
    buildInputs = [ FennecLite TestException ];
    meta = {
      description = "Tools for creating Meta objects to track custom metrics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MethodSignaturesSimple = buildPerlPackage {
    name = "Method-Signatures-Simple-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHESA/Method-Signatures-Simple-1.07.tar.gz;
      sha256 = "1p6sf6iyyn73pc89mfr65bzxvbw1ibcsp4j10iv8ik3p353pvkf8";
    };
    propagatedBuildInputs = [ DevelDeclare ];
    meta = {
      description = "Basic method declarations with signatures, without source filters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MHonArc = buildPerlPackage rec {
    name = "MHonArc-2.6.18";

    src = fetchurl {
      url    = "http://dcssrv1.oit.uci.edu/indiv/ehood/release/MHonArc/tar/${name}.tar.gz";
      sha256 = "1xmf26dfwr8achprc3n1pxgl0mkiyr6pf25wq3dqgzqkghrrsxa2";
    };
    propagatedBuildInputs = [ ];

    installTargets = "install";

    meta = with stdenv.lib; {
      homepage    = http://dcssrv1.oit.uci.edu/indiv/ehood/mhonarch.html;
      description = "A mail-to-HTML converter";
      maintainers = with maintainers; [ lovek323 ];
      license     = licenses.gpl2;
      platforms   = platforms.unix;
    };
  };

  MIMEBase64 = buildPerlPackage rec {
    name = "MIME-Base64-3.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1qbcipxij7pv25qhnfdc2lnkqi2cf60frlhlh86gjxslc8kr8nhj";
    };
  };

  MIMECharset = buildPerlPackage {
    name = "MIME-Charset-1.011.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/MIME-Charset-1.011.1.tar.gz;
      sha256 = "2955a3b617fe12654efc2a13ae1dc7d32aad81d35cfae21f74337213cf2435d5";
    };
    meta = {
      description = "Charset Information for MIME";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mimeConstruct = buildPerlPackage rec {
    name = "mime-construct-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "00wk9950i9q6qwp1vdq9xdddgk54lqd0bhcq2hnijh8xnmhvpmsc";
    };
    outputs = [ "out" ];
    buildInputs = [ ProcWaitStat ];
  };

  MIMETools = buildPerlPackage rec {
    name = "MIME-tools-5.509";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/D/DS/DSKOLL/MIME-tools-5.509.tar.gz";
      sha256 = "0wv9rzx5j1wjm01c3dg48qk9wlbm6iyf91j536idk09xj869ymv4";
    };
    propagatedBuildInputs = [
      MailTools
      FilePath
      FileTemp
      MIMEBase64
    ];
    buildInputs = [
      TestDeep
      TestPod
      TestPodCoverage
    ];
    meta = {
      description = "class for parsed-and-decoded MIME message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMELite = buildPerlPackage rec {
    name = "MIME-Lite-3.030";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "8f39901bc580bc3dce69e10415305e4435ff90264c63d29f707b4566460be962";
    };
    propagatedBuildInputs = [ EmailDateFormat MailTools MIMETypes ];
    meta = {
      description = "Low-calorie MIME generator (DEPRECATED)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MIMEtools = buildPerlPackage {
    name = "MIME-tools-5.507";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSKOLL/MIME-tools-5.507.tar.gz;
      sha256 = "2f43683e1d5bed21179207d81c0caf1d5b5d480d018ac812f4ab950879fe7793";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ MailTools ];
    meta = {
      description = "Tools to manipulate MIME messages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMETypes = buildPerlPackage rec {
    name = "MIME-Types-2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/${name}.tar.gz";
      sha256 = "1y3vnxk4wv4a00lxcp39hw9650cdl455d3y7nv42rqmvaxikghwr";
    };
    meta = {
      description = "Definition of MIME types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MixinLinewise = buildPerlPackage rec {
    name = "Mixin-Linewise-0.108";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "7df20678474c0973930a472b0c55e3f8e85b7790b68ab18ef618f9c453c8aef2";
    };
    propagatedBuildInputs = [ PerlIOutf8_strict SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/mixin-linewise;
      description = "Write your linewise code for handles; this does the rest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ModernPerl = buildPerlPackage {
    name = "Modern-Perl-1.20140107";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20140107.tar.gz;
      sha256 = "9cf66b2f93340dfe1cd7162262a47e7c4ba82475a52dc2a036c2fdc8a65298b8";
    };
    propagatedBuildInputs = [ perl ];
    meta = {
      homepage = https://github.com/chromatic/Modern-Perl;
      description = "Enable all of the features of Modern Perl with one import";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuild = buildPerlPackage rec {
    name = "Module-Build-0.4214";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "0gywap0dfr8sx4wr6wqc23sjag1b4xsw8l55ai4vhkfg324lhyf5";
    };
    buildInputs = [ CPANMeta ExtUtilsCBuilder ];
    meta = {
      description = "Build and install Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildDeprecated = buildPerlModule {
    name = "Module-Build-Deprecated-0.4210";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Deprecated-0.4210.tar.gz;
      sha256 = "be089313fc238ee2183473aca8c86b55fb3cf44797312cbe9b892d6362621703";
    };
    doCheck = false;
    meta = {
      description = "A collection of modules removed from Module-Build";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggable = buildPerlModule rec {
    name = "Module-Build-Pluggable-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "e5bb2acb117792c984628812acb0fec376cb970caee8ede57535e04d762b0e40";
    };
    propagatedBuildInputs = [ ClassAccessorLite ClassMethodModifiers DataOptList ModuleBuild TestSharedFork ];
    meta = {
      homepage = https://github.com/tokuhirom/Module-Build-Pluggable;
      description = "Module::Build meets plugins";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggablePPPort = buildPerlModule rec {
    name = "Module-Build-Pluggable-PPPort-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "44084ba3d8815f343bd391585ac5d8339a4807ce5c0dd84c98db8f310b64c0ea";
    };
    buildInputs = [ ModuleBuild TestRequires ];
    propagatedBuildInputs = [ ClassAccessorLite ModuleBuildPluggable ];
    meta = {
      description = "Generate ppport.h";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildTiny = buildPerlModule {
    name = "Module-Build-Tiny-0.039";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz;
      sha256 = "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c";
    };
    buildInputs = [ ExtUtilsConfig ExtUtilsHelpers ExtUtilsInstallPaths JSONPP TestHarness perl ];
    propagatedBuildInputs = [ ExtUtilsConfig ExtUtilsHelpers ExtUtilsInstallPaths JSONPP TestHarness ];
    meta = {
      description = "A tiny replacement for Module::Build";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildWithXSpp = buildPerlModule rec {
    name = "Module-Build-WithXSpp-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "0d39fjg9c0n820bk3fb50vvlwhdny4hdl69xmlyzql5xzp4cicsk";
    };
    propagatedBuildInputs = [ ExtUtilsXSpp ExtUtilsCppGuess ];
  };

  ModuleBuildXSUtil = buildPerlModule rec {
    name = "Module-Build-XSUtil-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/${name}.tar.gz";
      sha256 = "1323vxp8vf5xdz66lbc1wfciaks93mrbqfsjgb9nz1w9bb21xj36";
    };
    buildInputs = [ FileCopyRecursive CwdGuard CaptureTiny ];
    meta = {
      description = "A Module::Build class for building XS modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleCoreList = buildPerlPackage {
    name = "Module-CoreList-3.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Module-CoreList-3.01.tar.gz;
      sha256 = "10vf18x9qk4hdpwazxq8c0qykals36dxj0bjazqqcbp5xfb4fnyg";
    };
    meta = {
      homepage = http://dev.perl.org/;
      description = "What modules shipped with versions of perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.12.tar.gz;
      sha256 = "1lc33jdv4pgmm7nkr9bff0lhwjhhw91kaf6iiy2n7i7mw8dfv47l";
    };
    meta = {
      description = "Find and use installed modules in a (sub)category";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleImplementation = let version = "0.09"; in buildPerlPackage {
    name = "Module-Implementation-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Module-Implementation-${version}.tar.gz";
      sha256 = "0vfngw4dbryihqhi7g9ks360hyw8wnpy3hpkzyg0q4y2y091lpy1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      inherit version;
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Loads one of several alternate underlying implementations for a module";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ModuleInfo = buildPerlPackage rec {
    name = "Module-Info-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/Module-Info-0.35.tar.gz";
      sha256 = "0r7vxg1iy3lam0jgb2sk8ghgpmp3x5fskvzqlgkb09bssq83s1xb";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Information about Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstall = let version = "1.16"; in buildPerlPackage {
    name = "Module-Install-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Install-${version}.tar.gz";
      sha256 = "0ph242hmz11wv41yh1g8k9zj1bgzkamg2kgq8hnq4kaz4mj15b5g";
    };
    buildInputs = [ YAMLTiny ];
    propagatedBuildInputs = [ FileRemove ModuleScanDeps YAMLTiny ];
    meta = {
      description = "Standalone, extensible Perl module installer";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstallAuthorRequires = buildPerlPackage {
    name = "Module-Install-AuthorRequires-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Module-Install-AuthorRequires-0.02.tar.gz;
      sha256 = "1v2ciw75dj5y8lh10d1vrhwmjx266gpqavr8m21jlpblgm9j2qyc";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Declare author-only dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleInstallAuthorTests = buildPerlPackage {
    name = "Module-Install-AuthorTests-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Module-Install-AuthorTests-0.002.tar.gz;
      sha256 = "121dyggy38316xss06v1zkwx4b59gl7b00c5q99xyzimwqnp49a0";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Designate tests only run by module authors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleManifest = buildPerlPackage {
    name = "Module-Manifest-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Module-Manifest-1.08.tar.gz;
      sha256 = "722ed428afcbe5b5b441b0165cbafbd8534fa63d7856d4089e6e25ac21e6445d";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ ParamsUtil ];
    meta = {
      description = "Parse and examine a Perl distribution MANIFEST file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleMetadata = buildPerlPackage rec {
    name = "Module-Metadata-1.000027";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Module/${name}.tar.gz";
      sha256 = "1rrjj48vvv3i1jrmw97i4mvsmknll7hxga4cq2s9qvc2issdrxz2";
    };
    propagatedBuildInputs = [ version ];
  };

  ModulePath = buildPerlPackage rec {
    name = "Module-Path-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "b33179ce4dd73dfcde7d46808804b9ffbb11db0245fe455a7d001747562feaca";
    };
    buildInputs = [ DevelFindPerl ];
    meta = {
      homepage = https://github.com/neilbowers/Module-Path;
      description = "Get the full path to a locally installed module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggable = buildPerlPackage rec {
    name = "Module-Pluggable-5.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMONW/${name}.tar.gz";
      sha256 = "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
    meta = {
      description = "Automatically give your module the ability to have plugins";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Module-Pluggable-Fast-0.19.tar.gz;
      sha256 = "0pq758wlasmh77xyd2xh75m5b2x14s8pnsv63g5356gib1q5gj08";
    };
    propagatedBuildInputs = [UNIVERSALrequire];
  };

  ModuleRefresh = buildPerlPackage {
    name = "Module-Refresh-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Module-Refresh-0.17.tar.gz;
      sha256 = "6b30a6ceddc6512ab4490c16372ecf309a259f2ca147d622e478ac54e08511c3";
    };
    buildInputs = [ PathClass ];
    meta = {
      description = "Refresh %INC files when updated on disk";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntime = buildPerlPackage {
    name = "Module-Runtime-0.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.014.tar.gz;
      sha256 = "19326f094jmjs6mgpwkyisid54k67w34br8yfh0gvaaml87gwi2c";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Runtime module handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntimeConflicts = buildPerlPackage {
    name = "Module-Runtime-Conflicts-0.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.001.tar.gz;
      sha256 = "0f73d03846575dd1492d3760deeb9627afaa1f8b04d4d526b1775174201be25f";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleRuntime ];
    meta = {
      homepage = https://github.com/karenetheridge/Module-Runtime-Conflicts;
      description = "Provide information on conflicts for Module::Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleScanDeps = let version = "1.20"; in buildPerlPackage {
    name = "Module-ScanDeps-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-${version}.tar.gz";
      sha256 = "14a623b3gzr0mq5n93lrxm6wjmdp8dwj91gb43wk7f3dwd3ka03j";
    };
    buildInputs = [ TestRequires ];
    meta = {
      inherit version;
      description = "Recursively scan Perl code for dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleSignature = buildPerlPackage {
    name = "Module-Signature-0.79";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Module-Signature-0.79.tar.gz;
      sha256 = "22df2ce097fb5d176efa951c782633d8debe594924a25ca66666252512ce462c";
    };
    buildInputs = [ IPCRun ];
    meta = {
      description = "Module signature file manipulation";
      license = stdenv.lib.licenses.cc0;
    };
  };

  ModuleUtil = buildPerlPackage {
    name = "Module-Util-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Module-Util-1.09.tar.gz;
      sha256 = "6cfbcb6a45064446ec8aa0ee1a7dddc420b54469303344187aef84d2c7f3e2c6";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Module name tools and transformations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleVersions = buildPerlPackage {
    name = "Module-Versions-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THW/Module-Versions-0.02.zip;
      sha256 = "0g7qs6vqg91xpwg1cdy91m3kh9m1zbkzyz1qsy453b572xdscf0d";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleVersionsReport = buildPerlPackage {
    name = "Module-Versions-Report-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Module-Versions-Report-1.06.tar.gz;
      sha256 = "a3261d0d84b17678d8c4fd55eb0f892f5144d81ca53ea9a38d75d1a00ad9796a";
    };
    meta = {
      description = "Report versions of all modules in memory";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mod_perl2 = buildPerlPackage {
    name = "mod_perl-2.0.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/mod_perl-2.0.9.tar.gz;
      sha256 = "0azmir4hbb825mfmcxwa1frhnhhf82rl8xf6mmgwkhbinxmg4q02";
    };
    makeMakerFlags = "MP_AP_DESTDIR=$out";
    buildInputs = [ pkgs.apacheHttpd ];
    doCheck = false; # would try to start Apache HTTP server
    meta = {
      description = "Embed a Perl interpreter in the Apache HTTP server";
      license = stdenv.lib.licenses.asl20;
    };
  };
  Mojolicious = buildPerlPackage rec {
    name = "Mojolicious-6.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/${name}.tar.gz";
      sha256 = "82f73553836ac378edf825fd9f24be982653be9e0d78f8ba38b7841aabdafb02";
    };
    propagatedBuildInputs = [ JSONPP ];
    meta = {
      homepage = http://mojolicious.org;
      description = "Real-time web framework";
      license = with stdenv.lib.licenses; [ artistic2 ];
    };
  };

  MojoIOLoopForkCall = buildPerlModule rec {
    name = "Mojo-IOLoop-ForkCall-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/${name}.tar.gz";
      sha256 = "886de5c3b44194a86228471075fac4036073bda19093e776c702aa65c3ef1824";
    };
    propagatedBuildInputs = [ IOPipely Mojolicious ];
    meta = {
      description = "Run blocking functions asynchronously by forking";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MonitoringPlugin = buildPerlPackage rec {
    name = "Monitoring-Plugin-0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIERLEIN/${name}.tar.gz";
      sha256 = "030cw86j8712z8rn66k935gbilb5rcj3lnk4n53vh1b2phrszvjw";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [
      Carp ClassAccessor ConfigTiny
      MathCalcUnits ParamsValidate ];
    meta = {
      description = ''
        A family of perl modules to streamline writing Naemon,
        Nagios, Icinga or Shinken (and compatible) plugins
      '';
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPipely = buildPerlPackage rec {
    name = "IO-Pipely-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/${name}.tar.gz";
      sha256 = "e33b6cf5cb2b46ee308513f51e623987a50a89901e81bf19701dce35179f2e74";
    };
    meta = {
      homepage = http://search.cpan.org/dist/IO-Pipely/;
      description = "Portably create pipe() or pipe-like handles";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moo = buildPerlPackage rec {
    name = "Moo-2.003000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "ccab84b1377e52922026b24b2ed51d83c439757f2b0783fffa73ac22b4fb3dd2";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers DevelGlobalDestruction ModuleRuntime RoleTiny SubQuote ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatibility)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moose = buildPerlPackage {
    name = "Moose-2.1213";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Moose-2.1213.tar.gz;
      sha256 = "0f3b196ae67dc1daaa43c44ae7703f27c4f92c391ad3e252a90e90c50c851e03";
    };
    buildInputs = [ CPANMetaCheck CPANMetaRequirements DistCheckConflicts TestCleanNamespaces TestFatal TestRequires ModuleMetadata ];
    propagatedBuildInputs = [ ClassLoad ClassLoadXS DataOptList DevelGlobalDestruction DevelStackTrace DistCheckConflicts EvalClosure ListMoreUtils MROCompat ModuleRuntime ModuleRuntimeConflicts PackageDeprecationManager PackageStash PackageStashXS ParamsUtil SubExporter SubName TaskWeaken TryTiny ];
    meta = {
      homepage = http://moose.perl.org/;
      description = "A postmodern object system for Perl 5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.eelco ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooXHandlesVia = buildPerlPackage rec {
    name = "MooX-HandlesVia-0.001008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTP/${name}.tar.gz";
      sha256 = "b0946f23b3537763b8a96b8a83afcdaa64fce4b45235e98064845729acccfe8c";
    };
    buildInputs = [ MooXTypesMooseLike TestException TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers DataPerl ModuleRuntime Moo RoleTiny ];
    meta = {
      description = "NativeTrait-like behavior for Moo";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXTypesMooseLike = buildPerlPackage rec {
    name = "MooX-Types-MooseLike-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/${name}.tar.gz";
      sha256 = "1489almsam2zcrs5039sh0y88gjicwna8kws8j2jgfs8bpcf4dgf";
    };
    propagatedBuildInputs = [ Moo TestFatal ];
  };

  MooXTypesMooseLikeNumeric = buildPerlPackage rec {
    name = "MooX-Types-MooseLike-Numeric-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/${name}.tar.gz";
      sha256 = "16adeb617b963d010179922c2e4e8762df77c75232e17320b459868c4970c44b";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ MooXTypesMooseLike ];
    meta = {
      description = "Moo types for numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseAutobox = buildPerlPackage {
    name = "Moose-Autobox-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Moose-Autobox-0.15.tar.gz;
      sha256 = "0xcayrfm08dqas1mq8lnf8nxkvzdgcmv6xs5lqah17bxqxgznrl9";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose SyntaxKeywordJunction autobox ];
    meta = {
      description = "Autoboxed wrappers for Native Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXABC = buildPerlPackage {
    name = "MooseX-ABC-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-ABC-0.06.tar.gz;
      sha256 = "1sky0dpi22wrymmkjmqba4k966zn7vrbpx918wn2nmg48swyrgjf";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-ABC;
      description = "Abstract base classes for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXAliases = buildPerlPackage rec {
    name = "MooseX-Aliases-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0j07zqczjfmng3md6nkha7560i786d0cp3gdmrx49hr64jbhz1f4";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAppCmd = buildPerlPackage rec {
    name = "MooseX-App-Cmd-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "2e3bbf7283a4bee72d91d26eb204436030992bbe55cbd35ec33a546f16f973ff";
    };
    buildInputs = [ ModuleBuildTiny MooseXConfigFromFile TestOutput YAML ];
    propagatedBuildInputs = [ AppCmd GetoptLongDescriptive Moose MooseXGetopt MooseXNonMoose namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-App-Cmd;
      description = "Mashes up MooseX::Getopt and App::Cmd";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  MooX = buildPerlPackage rec {
    name = "MooX-0.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/${name}.tar.gz";
      sha256 = "2ff91a656e78aae0aca42293829d7a7e5acb9bf22b0401635b2ab6c870de32d5";
    };
    propagatedBuildInputs = [ DataOptList ImportInto ModuleRuntime Moo ];
    meta = {
      homepage = https://github.com/Getty/p5-moox;
      description = "Using Moo and MooX:: packages the most lazy way";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXlate = buildPerlPackage {
    name = "MooX-late-0.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/MooX-late-0.015.tar.gz;
      sha256 = "175326af3076fa8698669f289fad1322724978cddaf40ea04e600fcd7f6afbbf";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moo TypeTiny ];
    meta = {
      homepage = https://metacpan.org/release/MooX-late;
      description = "Easily translate Moose code to Moo";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXSimpleConfig = buildPerlPackage {
    name = "MouseX-SimpleConfig-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJGARDNER/MouseX-SimpleConfig-0.11.tar.gz;
      sha256 = "257f384091d33d340373a6153947039c698dc449d1ef989335644fc3d2da0069";
    };
    buildInputs = [ Mouse PathClass ];
    propagatedBuildInputs = [ ConfigAny Mouse MouseXConfigFromFile ];
    meta = {
      description = "A Mouse role for setting attributes from a simple configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestUseAllModules = buildPerlPackage {
    name = "Test-UseAllModules-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Test-UseAllModules-0.17.tar.gz;
      sha256 = "a71f2fe8b96ab8bfc2760aa1d3135ea049a5b20dcb105457b769a1195c7a2509";
    };
    meta = {
      description = "Do use_ok() for all the MANIFESTed modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypesPathClass = buildPerlPackage {
    name = "MouseX-Types-Path-Class-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-Types-Path-Class-0.07.tar.gz;
      sha256 = "228d4b4f3f0ed9547278691d0b7c5fe53d90874a69df709a49703c6af87c09de";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ Mouse MouseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Mouse";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypes = buildPerlPackage {
    name = "MouseX-Types-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Types-0.06.tar.gz;
      sha256 = "77288441fdadd15beeec9a0813ece8aec1542f1d8ceaaec14755b3f316fbcf8b";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyMoose Mouse ];
    meta = {
      description = "Organize your Mouse types in libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXConfigFromFile = buildPerlPackage {
    name = "MouseX-ConfigFromFile-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-ConfigFromFile-0.05.tar.gz;
      sha256 = "921b31cb13fc1f982a602f8e23815b7add23a224257e43790e287504ce879534";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ Mouse MouseXTypesPathClass ];
    meta = {
      description = "An abstract Mouse role for setting attributes from a configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXGetOpt = self.MouseXGetopt;

  MouseXGetopt = buildPerlModule rec {
    name = "MouseX-Getopt-0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "a6221043e7be3217ce56d2a6425a413d9cd28e2f52053995a6ceb118e8e963bc";
    };
    buildInputs = [ ModuleBuildTiny Mouse MouseXConfigFromFile MouseXSimpleConfig TestException TestWarn ];
    propagatedBuildInputs = [ GetoptLongDescriptive Mouse ];
    meta = {
      homepage = https://github.com/gfx/mousex-getopt;
      description = "A Mouse role for processing command line options";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXAttributeChained = buildPerlModule rec {
    name = "MooseX-Attribute-Chained-1.0.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "101kwjzidppcsnyvp9x1vw8vpvkp1cc1csqmzbashwvqy8d0g4af";
    };
    propagatedBuildInputs = [ Moose TryTiny ];
  };

  MooseXAttributeHelpers = buildPerlPackage {
    name = "MooseX-AttributeHelpers-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-AttributeHelpers-0.23.tar.gz;
      sha256 = "3f63f60d94d840a309d9137f78605e15f07c977fd15a4f4b55bd47b65ed52be1";
    };
    patches = [ ../development/perl-modules/MooseXAttributeHelpers-perl-5.20.patch ];
    buildInputs = [ Moose TestException ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Extend your attribute interfaces (deprecated)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXClone = buildPerlPackage {
    name = "MooseX-Clone-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/MooseX-Clone-0.05.tar.gz;
      sha256 = "11pbw3zdbcn54hrj6z74qisnmj9k4qliy6yjj9d71qndq3xg3x0f";
    };
    propagatedBuildInputs = [ DataVisitor HashUtilFieldHashCompat Moose namespaceclean Testuseok ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXConfigFromFile = buildPerlPackage rec {
    name = "MooseX-ConfigFromFile-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "9ad343cd9f86d714be9b54b9c68a443d8acc6501b6ad6b15e9ca0130b2e96f08";
    };
    buildInputs = [ ModuleBuildTiny Moose MooseXGetopt TestDeep TestFatal TestRequires TestWithoutModule self."if" ];
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesPathTiny namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-ConfigFromFile;
      description = "An abstract Moose role for setting attributes from a configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  MooseXDaemonize = buildPerlPackage rec {
    name = "MooseX-Daemonize-0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "111f391221d00f8b09cdcc6c806ab114324cf7f529d12f627fb97d054da42225";
    };
    buildInputs = [ DevelCheckOS ModuleBuildTiny Moose TestFatal ];
    propagatedBuildInputs = [ Moose MooseXGetopt MooseXTypesPathClass SubExporter namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Daemonize;
      description = "Role for daemonizing your Moose based application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXGetopt = buildPerlPackage rec {
    name = "MooseX-Getopt-0.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "de18f8ea0a5650cbbdebecb8f4c028f5f951fc5698332f7b8e20c7874902c259";
    };
    buildInputs = [ ModuleBuildTiny ModuleRuntime Moose PathTiny TestDeep TestFatal TestRequires TestTrap TestWarnings self."if" ];
    propagatedBuildInputs = [ GetoptLongDescriptive Moose MooseXRoleParameterized TryTiny namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Getopt;
      description = "A Moose role for processing command line options";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXHasOptions = buildPerlPackage {
    name = "MooseX-Has-Options-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PS/PSHANGOV/MooseX-Has-Options-0.003.tar.gz;
      sha256 = "07c21cf8ed500b272020ff8da19f194728bb414e0012a2f0cc54ef2ef6222a68";
    };
    buildInputs = [ Moose TestMost namespaceautoclean ];
    propagatedBuildInputs = [ ClassLoad ListMoreUtils PackageStash StringRewritePrefix ];
    meta = {
      homepage = https://github.com/pshangov/moosex-has-options;
      description = "Succinct options for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXHasSugar = buildPerlModule {
    name = "MooseX-Has-Sugar-0.05070421";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/MooseX-Has-Sugar-0.05070421.tar.gz;
      sha256 = "5acf92a6dcac50a6edfcbdb2c38802f8c1f9dc7194a79d0b85a3d4105ebba7df";
    };
    buildInputs = [ Moose MooseXTypes TestFatal namespaceautoclean ];
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = https://github.com/kentfredric/MooseX-Has-Sugar;
      description = "Sugar Syntax for moose 'has' fields";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXLazyRequire = buildPerlPackage {
    name = "MooseX-LazyRequire-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-LazyRequire-0.10.tar.gz;
      sha256 = "a555f80c0e91bc428f040015f00dd98f3c022704ec089516b9b3507f3d437090";
    };
    buildInputs = [ TestCheckDeps TestFatal ModuleMetadata ];
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-lazyrequire;
      description = "Required attributes which fail only when trying to use them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = stdenv.lib.licenses.lgpl21;
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    name = "MooseX-MethodAttributes-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.28.tar.gz;
      sha256 = "0srk85z6py9brw1jfvacd76y6219wycq3dj0wackbkmmbq04ln0g";
    };
    buildInputs = [ namespaceautoclean TestCheckDeps TestException ModuleMetadata ];
    propagatedBuildInputs = [ Moose MooseXTypes namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-methodattributes;
      description = "Code attribute introspection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXNonMoose = buildPerlPackage {
    name = "MooseX-NonMoose-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.26.tar.gz;
      sha256 = "0zdaiphc45s5xj0ax5mkijf5d8v6w6yccb3zplgj6f30y7n55gnb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXOneArgNew = buildPerlPackage {
    name = "MooseX-OneArgNew-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-OneArgNew-0.004.tar.gz;
      sha256 = "1frfrqaj283z1x95cqbbj3cvmb6rj50ngs47jq8myz6d1bg4zwff";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose MooseXRoleParameterized namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/moosex-oneargnew;
      description = "Teach ->new to accept single, non-hashref arguments";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRelatedClassRoles = buildPerlPackage rec {
    name = "MooseX-RelatedClassRoles-0.004";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "17vynkf6m5d039qkr4in1c9lflr8hnwp1fgzdwhj4q6jglipmnrh";
    };
    buildInputs = [ ];
    propagatedBuildInputs = [ MooseXRoleParameterized ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleParameterized = buildPerlPackage {
    name = "MooseX-Role-Parameterized-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/MooseX-Role-Parameterized-1.02.tar.gz;
      sha256 = "089czh2pipvdajjy4rxlix0y20ilp3ldbzi0vs68b7k6k9q3mqdk";
    };
    buildInputs = [ TestFatal TestMoose ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://github.com/sartak/MooseX-Role-Parameterized/tree;
      description = "Roles with composition parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleWithOverloading = buildPerlPackage rec {
    name = "MooseX-Role-WithOverloading-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0rb8k0dp1a55bm2pr6r0vsi5msvjl1dslfidxp1gj80j7zbrbc4j";
    };
    buildInputs = [ TestCheckDeps TestNoWarnings ModuleMetadata];
    propagatedBuildInputs = [ aliased Moose namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Role-WithOverloading;
      description = "Roles which support overloading";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRunnable = buildPerlPackage rec {
    name = "MooseX-Runnable-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "40d8fd1b5524ae965965a1f144d7a0a0c850594c524402b2319b24d5c4af1199";
    };
    buildInputs = [ ModuleBuildTiny MooseXGetopt TestFatal TestSimple TestTableDriven ];
    propagatedBuildInputs = [ ClassLoad ListSomeUtils Moose MooseXTypes MooseXTypesPathTiny ParamsUtil PathTiny namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Runnable;
      description = "Tag a class as a runnable application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
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

  MooseXSetOnce = buildPerlPackage rec {
    name = "MooseX-SetOnce-0.200002";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0ndnl8dj7nh8lvckl6r3jw31d0dmq30qf2pqkgcz0lykzjvhdvfb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSingleton = buildPerlPackage rec {
    name = "MooseX-Singleton-0.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAARE/MooseX-Singleton-0.29.tar.gz;
      sha256 = "0103f0hi7fp3mc0y0ydnz4ghcnag5gwgn2160y2zp6rnydx2p2sc";
    };
    buildInputs = [ Moose TestFatal TestRequires ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXStrictConstructor = buildPerlPackage {
    name = "MooseX-StrictConstructor-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-StrictConstructor-0.19.tar.gz;
      sha256 = "486573c16901e83c081da3d90a544281af1baa40bbf036337d6fa91994e48a31";
    };
    buildInputs = [ Moose TestFatal ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Make your object constructors blow up on unknown attributes";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  MooseXTraits = buildPerlPackage rec {
    name = "MooseX-Traits-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "74afe0c4faf4e3b97c57f289437caa60becca34cd5821f489dd4cc9da4fbe29a";
    };
    buildInputs = [ ModuleBuildTiny Moose MooseXRoleParameterized TestFatal TestRequires TestSimple ];
    propagatedBuildInputs = [ ClassLoad Moose SubExporter namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Traits;
      description = "Automatically apply roles at object creation time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1jjqmcidy4kdgp5yffqqwxrsab62mbhbpvnzdy1rpwnb1savg5mb";
    };
    buildInputs =[ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose namespaceautoclean ListMoreUtils ];
  };

  MooseXTypes = buildPerlPackage rec {
    name = "MooseX-Types-0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "9cd87b3492cbf0be9d2df9317b2adf9fc30663770e69906654bea3f41b17cb08";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires self."if" ];
    propagatedBuildInputs = [ CarpClan ModuleRuntime Moose SubExporter SubExporterForMethods SubInstall SubName namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types;
      description = "Organise your Moose types in libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  MooseXTypesCommon = buildPerlPackage rec {
    name = "MooseX-Types-Common-0.001014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "ef93718b6d2f240d50b5c3acb1a74b4c2a191869651470001a82be1f35d0ef0f";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestWarnings perl ];
    propagatedBuildInputs = [ MooseXTypes self."if" ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-Common;
      description = "A library of commonly used type constraints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTime = buildPerlPackage rec {
    name = "MooseX-Types-DateTime-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "b89fa26636f6a17eaa3868b4514340472b68bbdc2161a1d79a22a1bf5b1d39c6";
    };
    buildInputs = [ ModuleBuildTiny Moose TestFatal TestSimple ];
    propagatedBuildInputs = [ DateTime DateTimeLocale DateTimeTimeZone Moose MooseXTypes namespaceclean self."if" ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-DateTime;
      description = "DateTime related constraints and coercions for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTimeMoreCoercions = buildPerlPackage rec {
    name = "MooseX-Types-DateTime-MoreCoercions-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "21bb3a597719888edb6ceaa132418d5cf92ecb92a50cce37b94259a55e0e3796";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple ];
    propagatedBuildInputs = [ DateTime DateTimeXEasy Moose MooseXTypes MooseXTypesDateTime TimeDurationParse namespaceclean self."if" ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-DateTime-MoreCoercions;
      description = "Extensions to MooseX::Types::DateTime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesLoadableClass = buildPerlPackage {
    name = "MooseX-Types-LoadableClass-0.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-LoadableClass-0.012.tar.gz;
      sha256 = "a1d2b186c2b69f416bb0c9271dc8692c2287c2f6ce144cc3b9b2c922427060df";
    };
    buildInputs = [ ModuleBuildTiny Moose TestFatal ];
    propagatedBuildInputs = [ ClassLoad ModuleRuntime Moose MooseXTypes namespaceautoclean ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      homepage = https://github.com/moose/MooseX-Types-LoadableClass;
      description = "ClassName type constraint with coercion to load the class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathTiny = buildPerlModule {
    name = "MooseX-Types-Path-Tiny-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Tiny-0.006.tar.gz;
      sha256 = "0260c6fbbf84d411b145238ffd92a73f754bd92434448d9f78798fba0a2dfdd6";
    };
    buildInputs = [ Filepushd ModuleBuildTiny TestCheckDeps TestFatal ModuleMetadata ];
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesStringlike PathTiny ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-types-path-tiny;
      description = "Path::Tiny types and coercions for Moose";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesPerl = buildPerlPackage {
    name = "MooseX-Types-Perl-0.101343";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-Types-Perl-0.101343.tar.gz;
      sha256 = "0nijy676q27bvjb8swxrb1j4lq2xq8jbqkaxs1l9q81k7jpvx17h";
    };
    propagatedBuildInputs = [ MooseXTypes ParamsUtil ];
    meta = {
      description = "Moose types that check against Perl syntax";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesStringlike = buildPerlPackage {
    name = "MooseX-Types-Stringlike-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/MooseX-Types-Stringlike-0.002.tar.gz;
      sha256 = "18g07bvhcrhirb1yhcz55y7nsvkw1wq285d1hyb0jxrzgr0ga94k";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      homepage = https://github.com/dagolden/moosex-types-stringlike;
      description = "Moose type constraints for strings or string-like objects";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesStructured = buildPerlPackage {
    name = "MooseX-Types-Structured-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Structured-0.30.tar.gz;
      sha256 = "0svfgbyzwdipywh7bfp954hncm8ihfr8xpppcyy59wr1inx2f55c";
    };
    buildInputs = [ DateTime MooseXTypesDateTime TestFatal ];
    propagatedBuildInputs = [ DevelPartialDump Moose MooseXTypes SubExporter ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Types-Structured;
      description = "MooseX::Types::Structured - Structured Type Constraints for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesURI = buildPerlPackage rec {
    name = "MooseX-Types-URI-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "d310d20fa361fe2dff758236df87949cc7bf98e5cf3a7c79115365eccde6ccc1";
    };
    buildInputs = [ ModuleBuildTiny Moose TestSimple ];
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesPathClass URI URIFromHash namespaceautoclean self."if" ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types-URI;
      description = "URI related types and coercions for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  Mouse = buildPerlModule rec {
    name = "Mouse-v2.4.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/${name}.tar.gz";
      sha256 = "1f4dps68f2w1fwqjfpr4kllbcbwd744v3h1r9rkpwc2fhvq3q8hl";
    };
    buildInputs = [
      ModuleBuildXSUtil TestException TestLeakTrace TestRequires TestOutput
      TestFatal
    ];
  };

  MouseXNativeTraits = buildPerlPackage rec {
    name = "MouseX-NativeTraits-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "0pnbchkxfz9fwa8sniyjqp0mz75b3k2fafq9r09znbbh51dbz9gq";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ AnyMoose ];
    meta = {
      description = "Extend attribute interfaces for Mouse";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MozillaCA = buildPerlPackage rec {
    name = "Mozilla-CA-20160104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABH/${name}.tar.gz";
      sha256 = "27a7069a243162b65ada4194ff9d21b6ebc304af723eb5d3972fb74c11b03f2a";
    };
    meta = {
      description = "Mozilla's CA cert bundle in PEM format";
      license = stdenv.lib.licenses.mpl20;
    };
  };

  MozillaLdap = buildPerlPackage rec {
    name = "Mozilla-Ldap-${version}";
    version = "1.5.3";
    USE_OPENLDAP = 1;
    LDAPSDKDIR = pkgs.openldap.dev;
    LDAPSDKLIBDIR = "${pkgs.openldap.out}/lib";
    src = fetchurl {
      url = "https://ftp.mozilla.org/pub/directory/perldap/releases/${version}/src/perl-mozldap-${version}.tar.gz";
      sha256 = "0s0albdw0zvg3w37s7is7gddr4mqwicjxxsy400n1p96l7ipnw4x";
    };
    meta = {
      description = "Mozilla's ldap client library";
      license = with stdenv.lib.licenses; [ mpl20 lgpl21Plus gpl2Plus ];
    };
  };

  MROCompat = buildPerlPackage {
    name = "MRO-Compat-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/MRO-Compat-0.12.tar.gz;
      sha256 = "1mhma2g83ih9f8nkmg2k9l0x6izhhbb6k5lli4rpllxad4wbk9dv";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
    name = "namespace-autoclean-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "cd410a1681add521a28805da2e138d44f0d542407b50999252a147e553c26c39";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope SubIdentify namespaceclean ];
    meta = {
      homepage = https://github.com/moose/namespace-autoclean;
      description = "Keep imports out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  namespaceclean = buildPerlPackage rec {
    name = "namespace-clean-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "73986e19c4ad0e634e35f4f26e81437f152d8026eb1d91fe795725746ce13eca";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      homepage = http://search.cpan.org/dist/namespace-clean;
      description = "Keep imports and functions out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  # Deprecated.
  NamespaceAutoclean = self.namespaceautoclean;

  # Deprecated.
  NamespaceClean = self.namespaceclean;

  NetAddrIP = buildPerlPackage rec {
    name = "NetAddr-IP-4.079";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/${name}.tar.gz";
      sha256 = "ec5a82dfb7028bcd28bb3d569f95d87dd4166cc19867f2184ed3a59f6d6ca0e7";
    };
    meta = {
      description = "Manages IPv4 and IPv6 addresses and subnets";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  NetAmazonAWSSign = buildPerlPackage {
    name = "Net-Amazon-AWSSign-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NATON/Net-Amazon-AWSSign-0.12.tar.gz;
      sha256 = "0gpdjz5095hd3y1xhnbv45m6q2shw0c9r7spj1jvb8hy7dmhq10x";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Perl extension to create signatures for AWS requests";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAmazonEC2 = buildPerlPackage rec {
    name = "Net-Amazon-EC2-0.14-stanaka-bc66577e13";
    src = fetchFromGitHub {
      owner = "stanaka";
      repo = "net-amazon-ec2";
      rev = "bc66577e1312e828e252937d95f9f5f637af6a0b";
      sha256 = "0x7kac27vp60a0qmvf6zpr2ds7245hncpn2y1qbacmdp092x212k";
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

  NetAmazonS3 = buildPerlPackage rec {
    name = "Net-Amazon-S3-0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCONOVER/${name}.tar.gz";
      sha256 = "efb73dd9a96078742cb8564f7b58f5abe5168277342c7634961d63b4ef278848";
    };
    buildInputs = [ LWP TestException ];
    propagatedBuildInputs = [ DataStreamBulk DateTimeFormatHTTP DigestHMAC DigestMD5File FileFindRule HTTPDate HTTPMessage LWPUserAgentDetermined MIMETypes Moose MooseXStrictConstructor MooseXTypesDateTimeMoreCoercions PathClass RegexpCommon TermEncoding TermProgressBarSimple URI VMEC2SecurityCredentialCache XMLLibXML ];
    meta = {
      homepage = http://search.cpan.org/dist/Net-Amazon-S3/;
      description = "Use the Amazon S3 - Simple Storage Service";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAmazonS3Policy = buildPerlPackage {
    name = "Net-Amazon-S3-Policy-0.1.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/POLETTIX/Net-Amazon-S3-Policy-0.1.6.tar.gz;
      sha256 = "056rhq6vsdpwi2grbmxj8341qjrz0258civpnhs78j37129nxcfj";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Manage Amazon S3 policies for HTTP POST forms";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAMQP = buildPerlModule {
    name = "Net-AMQP-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHIPS/Net-AMQP-0.06.tar.gz;
      sha256 = "0b2ba7de2cd7ddd5fe102a2e2ae7aeba21eaab1078bf3bfd3c5a722937256380";
    };
    doCheck = false; # failures on 32bit
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable XMLLibXML ];
    meta = {
      description = "Advanced Message Queue Protocol (de)serialization and representation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetCIDR = buildPerlPackage {
    name = "Net-CIDR-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSAM/Net-CIDR-0.17.tar.gz;
      sha256 = "4a968e700d382cf0946e47df420d0151fbd8e0135f037d404c7c63713b66daf0";
    };
    meta = {
      description = "Manipulate IPv4/IPv6 netblocks in CIDR notation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  NetCoverArtArchive = buildPerlPackage {
    name = "Net-CoverArtArchive-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Net-CoverArtArchive-1.02.tar.gz;
      sha256 = "1lfx8lrjgb3s11fcm243jp5sghngd9svkgmg7xmssmj34q4f49ap";
    };
    buildInputs = [ FileFindRule TryTiny ];
    propagatedBuildInputs = [ JSONAny LWP Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/metabrainz/CoverArtArchive;
      description = "Query the coverartarchive.org";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetDBus = buildPerlPackage rec {
    name = "Net-DBus-1.1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/${name}.tar.gz";
      sha256 = "8391696db9e96c374b72984c0bad9c7d1c9f3b4efe68f9ddf429a77548e0e269";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.dbus XMLTwig ];
    meta = {
      homepage = http://www.freedesktop.org/wiki/Software/dbus;
      description = "Extension for the DBus bindings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDNS = buildPerlPackage rec {
    name = "Net-DNS-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NL/NLNETLABS/${name}.tar.gz";
      sha256 = "900198014110af96ebac34af019612dd2ddd6af30178600028c3c940d089d5c8";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    makeMakerFlags = "--noonline-tests";
    meta = {
      description = "Perl Interface to the Domain Name System";
      license = stdenv.lib.licenses.mit;
    };
  };

  NetDomainTLD = buildPerlPackage rec {
    name = "Net-Domain-TLD-1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXP/${name}.tar.gz";
      sha256 = "4c37f811184d68ac4179d48c10ea31922dd5fca2c1bffcdcd95c5a2a3b4002ee";
    };
    meta = {
      description = "Work with TLD names";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  NetHTTP = buildPerlPackage rec {
    name = "Net-HTTP-6.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/${name}.tar.gz";
      sha256 = "8565aff76b3d09084642f3a83c654fb4ced8220e8e19d35c78b661519b4c1be6";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://github.com/libwww-perl/Net-HTTP;
      description = "Low-level HTTP connection (client)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIDNEncode = buildPerlPackage {
    name = "Net-IDN-Encode-2.400";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.400.tar.gz;
      sha256 = "0a9knav5f9kjldrkxx1k47ivd3p23zkmi8aqgyhnxidhgasz1dlq";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Internationalizing Domain Names in Applications (IDNA)";
    };
  };

  NetIMAPClient = buildPerlPackage rec {
    name = "Net-IMAP-Client-0.9505";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GANGLION/${name}.tar.gz";
      sha256 = "d3f6a608b85e09a8080a67a9933837aae6f2cd0e8ee39df3380123dc5e3de912";
    };
    buildInputs = [TestPod TestPodCoverage];
    propagatedBuildInputs = [ IOSocketSSL ListMoreUtils ];
    meta = {
      description = "Not so simple IMAP client library";
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
    name = "Net-LDAP-0.4001";
    propagatedBuildInputs = [ ConvertASN1 ];
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/perl-ldap-0.4001.tar.gz;
      sha256 = "0spwid70yxkh5zbad3ldw8yb2m5shkm59a7f0kllw8bb7ccczqps";
    };
  };

  NetOAuth = buildPerlPackage {
    name = "Net-OAuth-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz;
      sha256 = "0k4h4a5048h7qgyx25ih64x0l4airx8a6d9gjq08wmxcl2fk3z3v";
    };
    buildInputs = [ ModuleBuild TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable DigestHMAC DigestSHA1 LWPUserAgent URI ];
    meta = {
      description = "An implementation of the OAuth protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetPing = buildPerlPackage {
    name = "Net-Ping-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMPETERS/Net-Ping-2.41.tar.gz;
      sha256 = "cbff21a8d323f235b70237c7ee56ffa5f22e87511e70608c027e2ec27fce47e0";
    };
    meta = {
      description = "Check a remote host for reachability";
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
    name = "Net-SMTP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/libnet-1.25.tar.gz;
      sha256 = "01f3l4aj3ynl8syyrl122k4bmfds77yw5q36aafrgaq22fnb3b2a";
    };
    patchPhase = "chmod a-x Configure";
    doCheck = false; # The test suite fails, because it requires network access.
  };

  NetSMTPSSL = buildPerlPackage {
    name = "Net-SMTP-SSL-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.03.tar.gz;
      sha256 = "05y94mb1vdw32mvwb0cp2h4ggh32f8j8nwwfjb8kjwxvfkfhyp9h";
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

  NetSMTPTLSButMaintained = buildPerlPackage {
    name = "Net-SMTP-TLS-ButMaintained-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Net-SMTP-TLS-ButMaintained-0.24.tar.gz;
      sha256 = "0vi5cv7f9i96hgp3q3jpxzn1ysn802kh5xc304f8b7apf67w15bb";
    };
    propagatedBuildInputs = [NetSSLeay DigestHMAC IOSocketSSL];
  };

  NetSNMP = buildPerlPackage rec {
    name = "Net-SNMP-6.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
      sha256 = "0hdpn1cw52x8cw24m9ayzpf4rwarm0khygn1sv3wvwxkrg0pphql";
    };
    doCheck = false; # The test suite fails, see https://rt.cpan.org/Public/Bug/Display.html?id=85799
  };

  NetSSLeay = buildPerlPackage rec {
    name = "Net-SSLeay-1.77";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/${name}.tar.gz";
      sha256 = "06h6wbr923jxmazmv5shdg1767s7r60bvzcza52dk31yckks6l31";
    };
    buildInputs = [ pkgs.openssl ];
    doCheck = false; # Test performs network access.
    preConfigure = ''
      mkdir openssl
      ln -s ${pkgs.openssl.out}/lib openssl
      ln -s ${pkgs.openssl.bin}/bin openssl
      ln -s ${pkgs.openssl.dev}/include openssl
      export OPENSSL_PREFIX=$(realpath openssl)
    '';
    meta = {
      description = "Perl extension for using OpenSSL";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  NetStatsd = buildPerlPackage {
    name = "Net-Statsd-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/Net-Statsd-0.11.tar.gz;
      sha256 = "0f56c95846c7e65e6d32cec13ab9df65716429141f106d2dc587f1de1e09e163";
    };
    meta = {
      description = "Sends statistics to the stats daemon over UDP";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetTelnet = buildPerlPackage {
    name = "Net-Telnet-3.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROGERS/Net-Telnet-3.04.tar.gz;
      sha256 = "e64d567a4e16295ecba949368e7a6b8b5ae2a16b3ad682121d9b007dc5d2a37a";
    };
    meta = {
      description = "Interact with TELNET port or other TCP ports";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetTwitterLite = buildPerlPackage {
    name = "Net-Twitter-Lite-0.11002";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.11002.tar.gz;
      sha256 = "032gyn1h3r5d83wvz7nj3k7g50wcf73lbbmjc18466ml90vigys0";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ CryptSSLeay LWPUserAgent NetOAuth URI ];
    doCheck = false;
    meta = {
      homepage = http://github.com/semifor/Net-Twitter-Lite;
      description = "A perl interface to the Twitter API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberCompare = buildPerlPackage rec {
    name = "Number-Compare-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "09q8i0mxvr7q9vajwlgawsi0hlpc119gnhq4hc933d03x0vkfac3";
    };
  };

  NumberFormat = buildPerlPackage rec {
    name = "Number-Format-1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WRW/${name}.tar.gz";
      sha256 = "82d659cb16461764fd44d11a9ce9e6a4f5e8767dc1069eb03467c6e55de257f3";
    };
    meta = {
      description = "Perl extension for formatting numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectAccessor = buildPerlPackage {
    name = "Object-Accessor-0.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz;
      sha256 = "76cb824a27b6b4e560409fcf6fd5b3bfbbd38b72f1f3d37ed0b54bd9c0baeade";
    };
    meta = {
      description = "Per object accessors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectInsideOut = buildPerlPackage {
    name = "Object-InsideOut-3.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Object-InsideOut-3.98.tar.gz;
      sha256 = "1zxfm2797p8b9dsvnbgd6aa4mgpxqxjqzbpfbla1g7f9alxm9f1z";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Comprehensive inside-out object support module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.07.tar.gz;
      sha256 = "0c8l7195bjvx0v6zmkgdnxvwg7yj2zq8hi7xd25a3iikd12dc4f6";
    };
    meta = {
      description = "Generate cryptographic signatures for objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  # For backwards compatibility. Please use OLEStorage_Lite instead.
  OLEStorageLight = OLEStorage_Lite;

  OLEStorage_Lite = buildPerlPackage rec {
    name = "OLE-Storage_Lite-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "179cxwqxb0f9dpx8954nvwjmggxxi5ndnang41yav1dx6mf0abp7";
    };
    meta = {
      description = "Read and write OLE storage files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Opcodes = buildPerlPackage {
    name = "Opcodes-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Opcodes-0.14.tar.gz;
      sha256 = "7f7365447e4d1c5b87b43091448f0488e67c9f036b26c022a5409cd73d343893";
    };
    meta = {
      description = "More Opcodes information from opnames.h and opcode.h";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  OpenGL = buildPerlPackage rec {
    name = "OpenGL-0.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHM/${name}.tar.gz";
      sha256 = "1q3lz168q081iwl9jg21fbzhp9la79gav9mv6nmh2jab83s2l3mj";
    };

    buildInputs = with pkgs; [ mesa mesa_glu freeglut xorg.libX11 xorg.libXi xorg.libXmu xorg.libXext xdummy ];

    patches = [ ../development/perl-modules/perl-opengl.patch ];

    configurePhase = ''
      substituteInPlace Makefile.PL \
        --replace "@@libpaths@@" '${stdenv.lib.concatStringsSep "\n" (map (f: "-L${f}/lib") buildInputs)}'

      cp -v ${../development/perl-modules/perl-opengl-gl-extensions.txt} utils/glversion.txt

      perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags
    '';

    doCheck = false;
  };

  NetOpenIDCommon = buildPerlPackage rec {
    name = "Net-OpenID-Common-1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "13hy5j6hcggb4l2r4pnwdh30p20wwja0chpmqm8y6wnnsp1km07f";
    };
    propagatedBuildInputs = [ CryptDHGMP URI HTMLParser HTTPMessage XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage rec {
    name = "Net-OpenID-Consumer-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "1nh9988436rmmmd6x2zz1fyrqy2005a1gvqzgvnc1pg2ylg61fqf";
    };
    propagatedBuildInputs = [ CGI NetOpenIDCommon JSON LWP ];
  };

  NetOpenSSH = buildPerlPackage rec {
    name = "Net-OpenSSH-0.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/${name}.tar.gz";
      sha256 = "f45a54b3c6015d4dc44cbff9f9be57bc9d54dfb104fb38bcf3c4eb04789582d9";
    };
    meta = {
      description = "Perl SSH client package implemented on top of OpenSSH";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageConstants = buildPerlPackage {
    name = "Package-Constants-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Package-Constants-0.04.tar.gz;
      sha256 = "7e09a88da2c0df24f498eb3a133f7d979404a7bc853f21afa2ba68dfd859a880";
    };
    meta = {
      description = "List constants defined in a package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageDeprecationManager = buildPerlPackage rec {
    name = "Package-DeprecationManager-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "4018a06f7a3ba252c9eccc3fdcad9490cd003dfa6baf261545e96b5a82e784a7";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ PackageStash ParamsUtil SubInstall SubName namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Package-DeprecationManager;
      description = "Manage deprecation warnings for your distribution";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  PackageStash = buildPerlPackage {
    name = "Package-Stash-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-0.37.tar.gz;
      sha256 = "06ab05388f9130cd377c0e1d3e3bafeed6ef6a1e22104571a9e1d7bfac787b2c";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleImplementation ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash;
      description = "Routines for manipulating stashes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageStashXS = buildPerlPackage {
    name = "Package-Stash-XS-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-XS-0.28.tar.gz;
      sha256 = "11nl69n8i56p91pd0ia44ip0vpv2cxwpbfakrv01vvv8az1cbn13";
    };
    buildInputs = [ TestRequires TestFatal ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash-XS;
      description = "Faster and more correct implementation of the Package::Stash API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Pango = buildPerlPackage rec {
    name = "Pango-1.227";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0wdcidnfnb6nm79fzfs39ivawj3x8m98a147fmcxgv1zvwia9c1l";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.pango ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Layout and render international text";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  ParallelPrefork = buildPerlPackage {
    name = "Parallel-Prefork-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Parallel-Prefork-0.17.tar.gz;
      sha256 = "0d81de2632281091bd31297de1906e14cae4e845cf32200953b50406859e763b";
    };
    buildInputs = [ TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ClassAccessorLite ListMoreUtils ProcWait3 ScopeGuard SignalMask ];
    meta = {
      description = "A simple prefork server framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsClassify = buildPerlPackage rec {
    name = "Params-Classify-0.013";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Params/${name}.tar.gz";
      sha256 = "1d4ysd95flszrxrnjgy6s7b80jkagjsb939h42i2hix4q20sy0a1";
    };
    buildInputs = [ ModuleBuild ExtUtilsParseXS ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsValidate = buildPerlModule rec {
    name = "Params-Validate-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1e1576f16e6e01ba63aa73775da563b410b49f26ee44169a45280feb958a5f0d";
    };
    buildInputs = [ ModuleBuild TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      homepage = http://metacpan.org/release/Params-Validate;
      description = "Validate method/function parameters";
      license = stdenv.lib.licenses.artistic2;
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
    name = "parent-0.228";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.228.tar.gz;
      sha256 = "0w0i02y4z8465z050kml57mvhv7c5gl8w8ivplhr3cms0zbaq87b";
    };
  };

  ParseCPANMeta = buildPerlPackage {
    name = "Parse-CPAN-Meta-1.4414";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Parse-CPAN-Meta-1.4414.tar.gz;
      sha256 = "cd7608154dfb72c9e110f012befe6b75d78448cb3e761716b60aa7545e16ca1b";
    };
    propagatedBuildInputs = [ CPANMetaYAML JSONPP ];
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/Parse-CPAN-Meta;
      description = "Parse META.yml and META.json CPAN metadata files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseDebControl = buildPerlPackage rec {
    name = "Parse-DebControl-2.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYBONCI/${name}.tar.gz";
      sha256 = "0ad78qri4sg9agghqdm83xsjgks94yvffs23kppy7mqjy8gwwjxn";
    };
    buildInputs = [ TestPod LWPUserAgent ];
    propagatedBuildInputs = [ IOStringy ];
    meta = with stdenv.lib; {
      homepage = http://search.cpan.org/~jaybonci/Parse-DebControl;
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ nckx ];
    };
  };

  ParseRecDescent = buildPerlPackage rec {
    name = "Parse-RecDescent-1.967009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JT/JTBRAUN/${name}.tar.gz";
      sha256 = "11y6fpz4j6kdimyaz2a6ig0jz0x7csqslhxaipxnjqi5h85hy071";
    };
  };

  ParseSyslog = buildPerlPackage {
    name = "Parse-Syslog-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSCHWEI/Parse-Syslog-1.10.tar.gz;
      sha256 = "659a2145441ef36d9835decaf83da308fcd03f49138cb3d90928e8bfc9f139d9";
    };
  };

  PathClass = buildPerlPackage {
    name = "Path-Class-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.33.tar.gz;
      sha256 = "0xy6s04xpslpzbb90x67yvfv0pjqnj1szxlx16vfx690iskcd36d";
    };
    meta = {
      description = "Cross-platform path specification manipulation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathTiny = buildPerlPackage {
    name = "Path-Tiny-0.104";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.104.tar.gz;
      sha256 = "c69f1dcfeb4aa004086deb9bc14c7d79f45798b947f1efbd634a3442e267aaef";
    };
    buildInputs = [ DevelHide Filepushd TestDeep TestFailWarnings TestFatal perl ];
    propagatedBuildInputs = [ autodie ];
    meta = {
      homepage = https://metacpan.org/release/Path-Tiny;
      description = "File path utility";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
    preConfigure =
      ''
        substituteInPlace lib/Path/Tiny.pm --replace 'use File::Spec 3.40' \
          'use File::Spec 3.39'
      '';
    # This appears to be currently failing tests, though I don't know why.
    # -- ocharles
    doCheck = false;
  };

  PathTools = buildPerlPackage {
    name = "PathTools-3.47";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/PathTools-3.47.tar.gz;
      sha256 = "caa8d4b45372b8cb0ef0f6f696efa3a60b0fd394b115cad39a7fbb8f6bd38026";
    };
  };

  pcscperl = buildPerlPackage {
    name = "pcsc-perl-1.4.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WH/WHOM/pcsc-perl-1.4.14.tar.bz2";
      sha256 = "17f6i16jv6ci6459vh6y3sz94vgcvykjjszcl4xsykryakjvf8i7";
    };
    buildInputs = [ pkgs.pcsclite ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    NIX_CFLAGS_LINK = "-L${pkgs.pcsclite}/lib -lpcsclite";
    # tests fail; look unfinished
    doCheck = false;
    meta = {
      homepage = "http://ludovic.rousseau.free.fr/softwares/pcsc-perl/";
      description = "Communicate with a smart card using PC/SC";
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with maintainers; [ abbradar ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  PDFAPI2 = buildPerlPackage rec {
    name = "PDF-API2-2.030";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SS/SSIMMS/${name}.tar.gz";
      sha256 = "a802c25c1f00b093778223fc7aea94ebd87a9abdb915151746b8ee5d4a358769";
    };
    propagatedBuildInputs = [ FontTTF ];
    meta = {
      description = "Facilitates the creation and modification of PDF files";
      license = stdenv.lib.licenses.lgpl21;
      maintainers = [ maintainers.rycee ];
    };
  };

  Pegex = buildPerlPackage rec {
    name = "Pegex-0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "317347f8c6355e886d87aef4c30fb4cb6cfa3e46adf62f59e6141ec05a97f2cf";
    };
    buildInputs = [ FileShareDirInstall YAMLLibYAML ];
    meta = {
      homepage = https://github.com/ingydotnet/pegex-pm;
      description = "Acmeist PEG Parser Framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Perl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  PerlCritic = buildPerlModule rec {
    name = "Perl-Critic-1.126";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THALJEF/${name}.tar.gz";
      sha256 = "b1a6151cb3603aef8555195b807e831655c83003b81e2f64fff095ff7114f5af";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ BKeywords ConfigTiny EmailAddress ExceptionClass FileHomeDir FileWhich IOString ListMoreUtils ModulePluggable PPI PPIxRegexp PPIxUtilities PerlTidy PodSpell Readonly StringFormat TaskWeaken ];
    meta = {
      homepage = http://perlcritic.com;
      description = "Critique Perl source code for best-practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PerlIOeol = buildPerlPackage rec {
    name = "PerlIO-eol-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "159zrrf44469sjklsi0pb4c005q74d9242q7mqawvbwnxjqbh0a5";
    };
  };

  PerlIOutf8_strict = buildPerlPackage rec {
    name = "PerlIO-utf8_strict-0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "980010e624c43be0a2aac8e1fe5db3fe43035940def75ca70401bb1ca98bd562";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Fast and correct UTF-8 IO";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/PerlIO-via-dynamic-0.14.tar.gz;
      sha256 = "0jbb3xpbqzmr625blvnjszd69l3cwxzi7bhmkj5x48dgv3s7mkca";
    };
  };

  PerlIOviaQuotedPrint = buildPerlPackage {
    name = "PerlIO-via-QuotedPrint-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/PerlIO-via-QuotedPrint-0.08.tar.gz;
      sha256 = "9b999a54134816de5217f7a8cac69fa5d89ab32dc589fcd5c9e84902f608cb9c";
    };
    meta = {
      description = "PerlIO Layer for quoted-printable encoding";
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };

    buildInputs = [ ModuleInstall ];

    postPatch = ''
      # remove outdated inc::Module::Install included with module
      # causes build failure for perl5.18+
      rm -r  inc
    '';
  };

  PerlIOviaTimeout = buildPerlPackage rec {
    name = "PerlIO-via-Timeout-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "9278f9ef668850d913d98fa4c0d7e7d667cff3503391f4a4eae73a246f2e7916";
    };
    buildInputs = [ ModuleBuildTiny TestTCP ];
    meta = {
      description = "A PerlIO layer that adds read & write timeout to a handle";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PerlMagick = buildPerlPackage rec {
    name = "PerlMagick-6.89-1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JC/JCRISTY/${name}.tar.gz";
      sha256 = "0n9afy1z5bhf9phrbahnkwhgcmijn8jggpbzwrivw1zhliliiy68";
    };
    buildInputs = [ pkgs.imagemagick ];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick.dev}/include/ImageMagick";|' Makefile.PL
      '';
    doCheck = false;
  };

  PerlOSType = buildPerlPackage rec {
    name = "Perl-OSType-1.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "01mfvh6x9mgfnwb31bmaw0jkqkxbl8gn50mwqgjwajk1yz4z8p14";
    };
  };

  PerlTidy = buildPerlPackage rec {
    name = "Perl-Tidy-20160302";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/${name}.tar.gz";
      sha256 = "6dd04ed8c315bcfea8fe713de8f9de68955795b6864f3be6c177e802fd30dca7";
    };
    meta = {
      description = "Indent and reformat perl scripts";
      license = stdenv.lib.licenses.gpl2Plus;
    };
  };

  PHPSerialization = buildPerlPackage {
    name = "PHP-Serialization-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/PHP-Serialization-0.34.tar.gz;
      sha256 = "0yphqsgg7zrar2ywk2j2fnjxmi9rq32yf0p5ln8m9fmfx4kd84mr";
    };
    meta = {
      description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
      license = "unknown";
    };
  };

  Plack = buildPerlPackage rec {
    name = "Plack-1.0039";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "d24a572e88644c7d39c7e6ff1af005b728dec94a878cf06d9027ab7d1a2fd0a9";
    };
    buildInputs = [ FileShareDirInstall TestRequires ];
    propagatedBuildInputs = [ ApacheLogFormatCompiler CookieBaker DevelStackTrace DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HTTPBody HTTPHeadersFast HTTPMessage HashMultiValue StreamBuffered TestTCP TryTiny URI ];
    meta = {
      homepage = https://github.com/plack/Plack;
      description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareDebug = buildPerlModule rec {
    name = "Plack-Middleware-Debug-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "e1e4ff6e9b246fe67547ebac8a3e83d4ae77873f889d1f63411c21c8c6bf96d5";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ ClassMethodModifiers DataDump FileShareDir Plack TextMicroTemplate ];
    meta = {
      homepage = https://github.com/miyagawa/Plack-Middleware-Debug;
      description = "Display information about the current request/response";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareFixMissingBodyInRedirect = buildPerlPackage rec {
    name = "Plack-Middleware-FixMissingBodyInRedirect-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWEETKID/${name}.tar.gz";
      sha256 = "6c22d069f5a57ac206d4659b28b8869bb9270640bb955efddd451dcc58cdb391";
    };
    buildInputs = [ HTTPMessage Plack ];
    propagatedBuildInputs = [ HTMLParser Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-FixMissingBodyInRedirect;
      description = "Plack::Middleware which sets body for redirect response, if it's not already set";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareMethodOverride = buildPerlPackage rec {
    name = "Plack-Middleware-MethodOverride-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/${name}.tar.gz";
      sha256 = "2b4a6e67006f97a2b4cf7980900f6a8ababb1cf97d6597319f9897ada3c555bc";
    };
    buildInputs = [ Plack URI ];
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Override REST methods to Plack apps via POST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareRemoveRedundantBody = buildPerlPackage {
    name = "Plack-Middleware-RemoveRedundantBody-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-RemoveRedundantBody-0.05.tar.gz;
      sha256 = "a0676e1c792bea7f25f1d901bee59054d35012d5ea8cd42529d336143fa87cd8";
    };
    buildInputs = [ HTTPMessage Plack ];
    propagatedBuildInputs = [ Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-RemoveRedundantBody;
      description = "Plack::Middleware which sets removes body for HTTP response if it's not required";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackTestExternalServer = buildPerlPackage rec {
    name = "Plack-Test-ExternalServer-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "5baf5c57fe0c06412deec9c5abe7952ab8a04f8c47b4bbd8e9e9982268903ed0";
    };
    buildInputs = [ HTTPMessage Plack TestTCP ];
    propagatedBuildInputs = [ LWP URI ];
    meta = {
      homepage = https://github.com/perl-catalyst/Plack-Test-ExternalServer;
      description = "Run HTTP tests on external live servers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Po4a = buildPerlPackage rec {
    name = "po4a-0.47";
    src = fetchurl {
      url = "https://alioth.debian.org/frs/download.php/file/4142/po4a-0.47.tar.gz";
      sha256 = "5010e1b7df1115cbd475f46587fc05fefc97301f9bba0c2f15106005ca017507";
    };
    propagatedBuildInputs = [ pkgs.docbook_xml_xslt TextWrapI18N LocaleGettext TermReadKey SGMLSpm ModuleBuild UnicodeLineBreak ModuleBuild ];
    buildInputs = [ pkgs.gettext pkgs.libxslt pkgs.glibcLocales pkgs.docbook_xml_dtd_412 pkgs.docbook_sgml_dtd_41 pkgs.texlive.combined.scheme-basic pkgs.jade ];
    LC_ALL="en_US.UTF-8";
    SGML_CATALOG_FILES = "${pkgs.docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml";
    preConfigure = ''
      touch Makefile.PL
      export PERL_MB_OPT="--install_base=$out --prefix=$out"
      substituteInPlace Po4aBuilder.pm --replace "\$self->install_sets(\$self->installdirs)->{'bindoc'}" "'$out/share/man/man1'"
    '';
    buildPhase = "perl Build.PL --install_base=$out; ./Build build";
    installPhase = "./Build install";
    checkPhase = ''
      export SGML_CATALOG_FILES=${pkgs.docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat
      ./Build test
    '';
    meta = {
      homepage = https://po4a.alioth.debian.org/;
      description = "tools for helping translation of documentation";
      license = with stdenv.lib.licenses; [ gpl2 ];
    };
  };

  PPI = buildPerlPackage {
    name = "PPI-1.220";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MITHALDU/PPI-1.220.tar.gz;
      sha256 = "1e15be50e7d95a36d351af8bf5074f6695a2c72165e586d93e616183e7602b83";
    };
    buildInputs = [ ClassInspector FileRemove TestNoWarnings TestObject TestSubCalls ];
    propagatedBuildInputs = [ Clone IOString ListMoreUtils ParamsUtil TaskWeaken ];

    # Remove test that fails due to unexpected shebang after
    # patchShebang.
    preCheck = "rm t/03_document.t";

    meta = {
      homepage = https://github.com/adamkennedy/PPI;
      description = "Parse, Analyze and Manipulate Perl (without perl)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PPIxRegexp = buildPerlPackage rec {
    name = "PPIx-Regexp-0.050";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/${name}.tar.gz";
      sha256 = "fd095fb90826efa3f9b28bf018a099dc51f1d7c7d34ed2f193a28f1087635125";
    };
    propagatedBuildInputs = [ ListMoreUtils PPI TaskWeaken ];
    meta = {
      description = "Parse regular expressions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxUtilities = buildPerlPackage {
    name = "PPIx-Utilities-1.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EL/ELLIOTJS/PPIx-Utilities-1.001000.tar.gz;
      sha256 = "03a483386fd6a2c808f09778d44db06b02c3140fb24ba4bf12f851f46d3bcb9b";
    };
    buildInputs = [ PPI TestDeep ];
    propagatedBuildInputs = [ ExceptionClass PPI Readonly TaskWeaken ];
    meta = {
      description = "Extensions to L<PPI|PPI>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcBackground = buildPerlPackage rec {
    name = "Proc-Background-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BZ/BZAJAC/${name}.tar.gz";
      sha256 = "1ce0dd78c0bb8393a2431b385a27b99fcc623a41ebec57b3cc09cc38cdb708ee";
    };
    meta = {
    };
  };

  ProcProcessTable = buildPerlPackage {
    name = "Proc-ProcessTable-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JW/JWB/Proc-ProcessTable-0.51.tar.gz;
      sha256 = "66636e102985a2a05ef4334b53a7893d627c192fac5dd7ff37dd1a0a50c0128d";
    };
    meta = {
      description = "Perl extension to access the unix process table";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcSafeExec = buildPerlPackage {
    name = "Proc-SafeExec-1.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BILBO/Proc-SafeExec-1.5.tar.gz;
      sha256 = "1b4d0908bcac563d34a7e5be61c5da3eee98e4a6c7fa68c2670cc5844b5a2d78";
    };
  };

  ProcSimple = buildPerlPackage rec {
    name = "Proc-Simple-1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/${name}.tar.gz";
      sha256 = "4c8f0a924b19ad78a13da73fe0fb306d32a7b9d10a332c523087fc83a209a8c4";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWait3 = buildPerlPackage {
    name = "Proc-Wait3-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CT/CTILMES/Proc-Wait3-0.05.tar.gz;
      sha256 = "1a907f5db6933dc2939bbfeffe19eeae7ed39ef1b97a2bc9b723f2f25f81caf3";
    };
    meta = {
      description = "Perl extension for wait3 system call";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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
    name = "PSGI-1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0iqzxs8fv63510knm3zr3jr3ky4x7diwd7y24mlshzci81kl8v55";
    };
  };

  PadWalker = buildPerlPackage rec {
    name = "PadWalker-2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/${name}.tar.gz";
      sha256 = "fc1df2084522e29e892da393f3719d2c1be0da022fdd89cff4b814167aecfea3";
    };
  };

  Perl6Junction = buildPerlPackage rec {
    name = "Perl6-Junction-1.60000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "0r3in9pyrm6wfrhcvxbq5w1617x8x5537lxj9hdzks4pa7l7a8yh";
    };
  };

  PerlMinimumVersion = buildPerlPackage rec {
    name = "Perl-MinimumVersion-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "478b5824791b87fc74c94a892180682bd06ad2cdf34034b1a4b859273927802a";
    };
    buildInputs = [ TestScript ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl PPI PPIxRegexp ParamsUtil PerlCritic ];
    meta = {
      homepage = https://github.com/neilbowers/Perl-MinimumVersion;
      description = "Find a minimum required version of perl for Perl code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlPrereqScanner = buildPerlPackage rec {
    name = "Perl-PrereqScanner-1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "280a1c4710390865fb9f310a861a34720b28b4cbe50609c841af5cf2d3a2bced";
    };
    buildInputs = [ PPI TryTiny ];
    propagatedBuildInputs = [ GetoptLongDescriptive ListMoreUtils ModulePath Moose PPI ParamsUtil StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Perl-PrereqScanner;
      description = "A tool to scan your Perl code for its prerequisites";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlVersion = buildPerlPackage rec {
    name = "Perl-Version-1.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1887414d1c8689d864c840114101e043e99d7dd5b9cca69369a60e821e3ad0f7";
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
    meta = {
      description = "Parse and manipulate Perl version strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodChecker = buildPerlPackage {
    name = "Pod-Checker-1.71";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Checker-1.71.tar.gz;
      sha256 = "4b90e745f4d6357bb7e8999e0e7d192216b98e3f3c8a86fa6ed446f8c36601df";
    };
  };

  PodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "01xifj83dv492lxixijmg6va02rf3ydlxly0a9slmx22r6qa1drh";
    };
    propagatedBuildInputs = [DevelSymdump];
  };

  PodCoverageTrustPod = buildPerlPackage {
    name = "Pod-Coverage-TrustPod-0.100003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Coverage-TrustPod-0.100003.tar.gz;
      sha256 = "19lyc5a5hg3pqhw0k5fnd0q4l2mrdq0ck4kw1smjvwkccp24431z";
    };
    propagatedBuildInputs = [ PodCoverage PodEventual ];
    meta = {
      homepage = https://github.com/rjbs/pod-coverage-trustpod;
      description = "Allow a module's pod to contain Pod::Coverage hints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElemental = buildPerlPackage rec {
    name = "Pod-Elemental-0.103004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "43625cde7241fb174ad9c7eb45387fba410dc141d7de2323855eeab3590072c9";
    };
    buildInputs = [ TestDeep TestDifferences ];
    propagatedBuildInputs = [ ClassLoad MixinLinewise Moose MooseXTypes PodEventual StringRewritePrefix StringTruncate SubExporter SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Elemental;
      description = "Work with nestable Pod elements";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElementalPerlMunger = buildPerlPackage rec {
    name = "Pod-Elemental-PerlMunger-0.200006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "09fd3b5d53119437a01dced66b42eafdcd53895b3c32a2b0f781f36fda0f665b";
    };
    buildInputs = [ Moose PodElemental ];
    propagatedBuildInputs = [ Moose PPI PodElemental namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Elemental-PerlMunger;
      description = "A thing that takes a string of Perl and rewrites its documentation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodEscapes = let version = "1.07"; in buildPerlPackage {
    name = "Pod-Escapes-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Pod-Escapes-${version}.tar.gz";
      sha256 = "0213lmbbw3vy50ahlp2lqmmnkwhrizyl1y87i4jgnla9k0kwixyv";
    };
  };

  PodEventual = buildPerlPackage {
    name = "Pod-Eventual-0.093330";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Eventual-0.093330.tar.gz;
      sha256 = "29de14a69df8a26f7e8ff73daca5afa7acc84cc9b7ae28093a5b1af09a4830b6";
    };
    propagatedBuildInputs = [ MixinLinewise TestDeep ];
    meta = {
      description = "Read a POD document as a series of trivial events";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodParser = buildPerlPackage {
    name = "Pod-Parser-1.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz;
      sha256 = "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd";
    };
    meta = {
      description = "Modules for parsing/translating POD format documents";
      license = stdenv.lib.licenses.artistic1;
    };
  };

  PodPOM = buildPerlPackage rec {
    name = "Pod-POM-2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "1b50fba9bbdde3ead192beeba0eaddd0c614e3afb1743fa6fff805f57c56f7f4";
    };
    buildInputs = [ FileSlurper TestDifferences TextDiff ];
    meta = {
      homepage = https://github.com/neilb/Pod-POM;
      description = "POD Object Model";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodPOMViewTOC = buildPerlPackage rec {
    name = "Pod-POM-View-TOC-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "ccb42272c7503379cb1131394620ee50276d72844e0e80eb4b007a9d58f87623";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ PodPOM ];
    meta = {
      description = "Generate the TOC of a POD with Pod::POM";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodLaTeX = buildPerlModule rec {
    name = "Pod-LaTeX-0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJENNESS/${name}.tar.gz";
      sha256 = "15a840ea1c8a76cd3c865fbbf2fec33b03615c0daa50f9c800c54e0cf0659d46";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ self."if" ];
    meta = {
      homepage = http://github.com/timj/perl-Pod-LaTeX/tree/master;
      description = "Convert Pod data to formatted Latex";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  podlators = buildPerlPackage rec {
    name = "podlators-4.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RR/RRA/${name}.tar.gz";
      sha256 = "0fsb1k88fsqwgmk5fkcz57jf27g6ip4ncikawslm596d1si2h48a";
    };
    meta = {
      description = "Convert POD data to various other formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  podlinkcheck = buildPerlPackage rec {
    name = "podlinkcheck-14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "8ad152bdffbb7f5080616c0c0ae142f75b4c1255ed82b9cd80a5f4e3172fed3d";
    };
    propagatedBuildInputs = [ FileFindIterator FileHomeDir IPCRun constantdefer libintlperl ];
    meta = {
      homepage = http://user42.tuxfamily.org/podlinkcheck/index.html;
      description = "Check POD L<> link references";
      license = stdenv.lib.licenses.gpl3Plus;
    };
  };

  PodPerldoc = buildPerlPackage {
    name = "Pod-Perldoc-3.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MALLEN/Pod-Perldoc-3.25.tar.gz;
      sha256 = "f1a4b3ac7aa244485456b0e8733c773bbb39ae35b01a59515f6cba6bbe293a84";
    };
    meta = {
      description = "Look up Perl documentation in Pod format";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodPlainer = buildPerlPackage {
    name = "Pod-Plainer-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RM/RMBARKER/Pod-Plainer-1.04.tar.gz;
      sha256 = "1bbfbf7d1d4871e5a83bab2137e22d089078206815190eb1d5c1260a3499456f";
    };
    meta = {
      description = "Perl extension for converting Pod to old-style Pod";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodMarkdown = buildPerlPackage {
    name = "Pod-Markdown-2.000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RW/RWSTAUNER/Pod-Markdown-2.000.tar.gz;
      sha256 = "0qix7gmrc2ypm5dl1w5ajnjy32xlmy73wb3zycc1pxl5lipigsx8";
    };
    buildInputs = [ TestDifferences ];
    meta = {
      homepage = https://github.com/rwstauner/Pod-Markdown;
      description = "Convert POD to Markdown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  PodUsage = buildPerlPackage {
    name = "Pod-Usage-1.67";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Usage-1.67.tar.gz;
      sha256 = "c8be6d29b0dfe304c4ddfcc140f93d4c4de7a8362ea6e2651611c288b53cc68a";
    };
    propagatedBuildInputs = [ perl ];
    meta = {
      description = "Pod::Usage extracts POD documentation and shows usage information";
    };
  };

  PodWeaver = buildPerlPackage rec {
    name = "Pod-Weaver-4.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "5af25b29a55783e495a9df5ef6293240e2c9ab02764613d79f1ed50b12dec5ae";
    };
    buildInputs = [ PPI SoftwareLicense TestDifferences ];
    propagatedBuildInputs = [ ConfigMVP ConfigMVPReaderINI DateTime ListMoreUtils LogDispatchouli MixinLinewise ModuleRuntime Moose ParamsUtil PodElemental StringFlogger StringFormatter StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Weaver;
      description = "Weave together a Pod document from an outline";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ProbePerl = buildPerlPackage rec {
    name = "Probe-Perl-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/${name}.tar.gz";
      sha256 = "0c9wiaz0mqqknafr4jdr0g2gdzxnn539182z0icqaqvp5qgd5r6r";
    };
  };

  POSIXstrftimeCompiler = buildPerlModule rec {
    name = "POSIX-strftime-Compiler-0.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "670b89e11500f3808c9e21b1c300089622f68906ff12b1cbfba8e30d3a1c3739";
    };
    # We cannot change timezones on the fly.
    prePatch = "rm t/04_tzset.t";
    meta = {
      homepage = https://github.com/kazeburo/POSIX-strftime-Compiler;
      description = "GNU C library compatible strftime for loggers and servers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Readonly = buildPerlModule rec {
    name = "Readonly-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SANKO/${name}.tar.gz";
      sha256 = "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      homepage = https://github.com/sanko/readonly;
      description = "Facility for creating read-only scalars, arrays, hashes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ReadonlyXS = buildPerlPackage rec {
    name = "Readonly-XS-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "8ae5c4e85299e5c8bddd1b196f2eea38f00709e0dc0cb60454dc9114ae3fff0d";
    };
  };

  Redis = buildPerlPackage rec {
    name = "Redis-1.991";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/${name}.tar.gz";
      sha256 = "f7d1a934fa9360a26e480f896f97be0fd62807f9d9baca65a9aa8d007ff2acaa";
    };
    buildInputs = [ IOString ModuleBuildTiny PodCoverageTrustPod TestCPANMeta TestDeep TestFatal TestSharedFork TestTCP ];
    propagatedBuildInputs = [ IOSocketTimeout TryTiny ];
    meta = {
      homepage = https://github.com/PerlRedis/perl-redis;
      description = "Perl binding for Redis database";
      license = stdenv.lib.licenses.artistic2;
      maintainers = [ maintainers.rycee ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.35";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Regexp/${name}.tar.gz";
      sha256 = "1msxrriq74q8iacn2hkcw6g4qjjwv777avryiyz1w29h55mwq083";
    };
  };

  RegexpCommon = buildPerlPackage {
    name = "Regexp-Common-2013031301";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz;
      sha256 = "729a8198d264aa64ecbb233ff990507f97fbb66bda746b95f3286f50f5f25c84";
    };
    meta = with stdenv.lib; {
      description = "Provide commonly requested regular expressions";
      license = licenses.mit;
    };
  };

  RegexpCommonnetCIDR = buildPerlPackage {
    name = "Regexp-Common-net-CIDR-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BP/BPS/Regexp-Common-net-CIDR-0.03.tar.gz;
      sha256 = "39606a57aab20d4f4468300f2ec3fa2ab557fcc9cb7880ec7c6e07d80162da33";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  RegexpIPv6 = buildPerlPackage {
    name = "Regexp-IPv6-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SALVA/Regexp-IPv6-0.03.tar.gz;
      sha256 = "d542d17d75ce93631de8ba2156da0e0b58a755c409cd4a0d27a3873a26712ce2";
    };
    meta = {
      license = "unknown";
    };
  };

  RegexpParser = buildPerlPackage {
    name = "Regexp-Parser-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Regexp-Parser-0.21.tar.gz;
      sha256 = "d70cb66821f1f67a9b1ff53f0fa33c06aec8693791e0a5943be6760c25d2768d";
    };
    meta = {
      homepage = http://wiki.github.com/toddr/Regexp-Parser;
      description = "Base class for parsing regexes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RESTUtils = buildPerlPackage {
    name = "REST-Utils-0.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JALDHAR/REST-Utils-0.6.tar.gz;
      sha256 = "1zdrf3315rp2b8r9dwwj5h93xky7i33iawf4hzszwcddhzflmsfl";
    };
    buildInputs = [ TestWWWMechanizeCGI ];
    meta = {
      homepage = http://jaldhar.github.com/REST-Utils;
      description = "Utility functions for REST applications";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RpcXML = buildPerlPackage {
    name = "RPC-XML-0.78";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.78.tar.gz;
      sha256 = "0spci3sj2hq9k916sk9k2gchqrbnz9lwmlcnwf1k33wzl8j2gh52";
    };
    propagatedBuildInputs = [LWP XMLLibXML XMLParser];
    doCheck = false;
  };

  ReturnValue = buildPerlPackage {
    name = "Return-Value-1.666004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.666004.tar.gz;
      sha256 = "0xr7ic212p36arzdpph2l2yy1y88c7qaf4nng3gqb29zc9kzy3bc";
    };
  };

  RoleBasic = buildPerlPackage {
    name = "Role-Basic-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Role-Basic-0.13.tar.gz;
      sha256 = "38a0959ef9f193ff76e72c325a9e9211bc4868689bd0e2b005778f53f8b6f36a";
    };
    meta = {
      description = "Just roles. Nothing else";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleHasMessage = buildPerlPackage {
    name = "Role-HasMessage-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-HasMessage-0.006.tar.gz;
      sha256 = "1lylfvarjfy6wy34dfny3032pc6r33mjby5yzzhmxybg8zhdp9pn";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose MooseXRoleParameterized StringErrf TryTiny namespaceclean ];
    meta = {
      description = "A thing with a message method";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleIdentifiable = buildPerlPackage {
    name = "Role-Identifiable-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-Identifiable-0.007.tar.gz;
      sha256 = "1bbkj2wqpbfdw1cbm99vg9d94rvzba19m18xhnylaym0l78lc4sn";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "A thing with a list of tags";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleTiny = buildPerlPackage rec {
    name = "Role-Tiny-2.000005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "593a29b621e029bf0218d0154d5dfdf6ec502afc49adeeadae6afd0c70063115";
    };
    meta = {
      description = "Roles. Like a nouvelle cuisine portion size slice of Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  RSSParserLite = buildPerlPackage {
    name = "RSS-Parser-Lite-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EB/EBOSRUP/RSS-Parser-Lite-0.10.tar.gz;
      sha256 = "1spvi0z62saz2cam8kwk2k561aavw2w42g3ykj38w1kmydvsk8z6";
    };
    propagatedBuildInputs = [ SOAPLite ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RTClientREST = buildPerlPackage {
    name = "RT-Client-REST-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMITRI/RT-Client-REST-0.49.tar.gz;
      sha256 = "832c84b4f19e97781e8902f123a659fdcfef68e0ed9cfe09055852e9d68f7afc";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CGI DateTime DateTimeFormatDateParse Error ExceptionClass HTTPCookies HTTPMessage LWP ParamsValidate URI ];
    meta = {
      description = "Talk to RT installation using REST protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Safe = buildPerlPackage {
    name = "Safe-2.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/Safe-2.35.tar.gz;
      sha256 = "e5d09756580287d7dc183ddaf26e4b2467e6f75b52ad73decdbe62d0750979b1";
    };
  };

  SafeIsa = buildPerlPackage {
    name = "Safe-Isa-1.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Safe-Isa-1.000004.tar.gz;
      sha256 = "0sqwma0xqxrgnsm0jfy17szq87bskzq67cdh7p934qdifh5nfwn9";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Call isa, can, does and DOES safely on things that may not be objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarListUtils = buildPerlPackage {
    name = "Scalar-List-Utils-1.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.42.tar.gz;
      sha256 = "3507f72541f66a2dce850b9b56771e5fccda3d215c52f74946c6e370c0f4a4da";
    };
    meta = {
      description = "Common Scalar and List utility subroutines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarString = buildPerlPackage rec {
    name = "Scalar-String-0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "d3a45cc137bb9f7d8848d5a10a5142d275a98f8dcfd3adb60593cee9d33fa6ae";
    };
    buildInputs = [ ModuleBuild ];
  };

  ScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.20.tar.gz;
      sha256 = "1lsagnz6pli035zvx5c1x4qm9fabi773vns86yd8lzfpldhfv3sv";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeUpper = buildPerlPackage {
    name = "Scope-Upper-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.24.tar.gz;
      sha256 = "159jcwliyb7j80858pi052hkmhgy4cdbjha419kmhhqc9s1rhd5g";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Scope-Upper/;
      description = "Act on upper scopes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SearchDict = buildPerlPackage {
    name = "Search-Dict-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Search-Dict-1.07.tar.gz;
      sha256 = "b128cdae4712fe53e83a219ca65478a84c1b128a2c6c86933e47923cf19c6554";
    };
    meta = {
      description = "Look - search for key in dictionary file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SelfLoader = buildPerlPackage {
    name = "SelfLoader-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/SelfLoader-1.20.tar.gz;
      sha256 = "79b1e2b8e4081854fba666441287c18b6bd822defb5bbee79067370edba1a042";
    };
    meta = {
      description = "Load functions only on demand";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ServerStarter = buildPerlModule {
    name = "Server-Starter-0.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Server-Starter-0.32.tar.gz;
      sha256 = "a8ecc19f05f3c3b079e1c7f2c007a6df2b9a2912b9848a8fb51bd78c7b13ac1a";
    };
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      homepage = https://github.com/kazuho/p5-Server-Starter;
      description = "A superdaemon for hot-deploying server programs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SetInfinite = buildPerlPackage {
    name = "Set-Infinite-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/Set-Infinite-0.65.tar.gz;
      sha256 = "07bc880734492de40b4a3a8b5a331762f64e69b4629029fd9a9d357b25b87e1f";
    };
    meta = {
      description = "Infinite Sets math";
    };
  };

  SetIntSpan = buildPerlPackage rec {
    name = "Set-IntSpan-1.19";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz";
      sha256 = "1l6znd40ylzvfwl02rlqzvakv602rmvwgm2xd768fpgc2fdm9dqi";
    };

    meta = {
      description = "Manages sets of integers";
    };
  };

  SetObject = buildPerlPackage {
    name = "Set-Object-1.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Set-Object-1.34.tar.gz;
      sha256 = "1dipd6k572pzqjzbj9vagb2k347qcg29lsxzx9y214bhnw7fgvjp";
    };
  };

  SetScalar = buildPerlPackage {
    name = "Set-Scalar-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz;
      sha256 = "07aiqkyi1p22drpcyrrmv7f8qq6fhrxh007achy2vryxyck1bp53";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  SGMLSpm = buildPerlPackage {
    name = "SGMLSpm-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz;
      sha256 = "1gdjf3mcz2bxir0l9iljxiz6qqqg3a9gg23y5wjg538w552r432m";
    };
  };

  SignalMask = buildPerlPackage {
    name = "Signal-Mask-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Signal-Mask-0.008.tar.gz;
      sha256 = "043d995b6b249d9ebc04c467db31bb7ddc2e55faa08e885bdb050b1f2336b73f";
    };
    propagatedBuildInputs = [ IPCSignal ];
    meta = {
      description = "Signal masks made easy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SOAPLite = buildPerlPackage {
    name = "SOAP-Lite-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz;
      sha256 = "1zhy06v72r95ih3lx5rlx0bvkq214ndmcmn97m5k2rkxxy4ybpp4";
    };
    propagatedBuildInputs = [ ClassInspector HTTPDaemon LWP TaskWeaken URI XMLParser ];
    meta = {
      description = "Perl's Web Services Toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Socket = buildPerlPackage {
    name = "Socket-2.020";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Socket-2.020.tar.gz;
      sha256 = "9ad4174c45b4c31d5e0b8019ada1fc767093849e77f268f0d1831eeb891dfdd7";
    };
    meta = {
      description = "Networking constants and support functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Socket6 = buildPerlPackage rec {
    name = "Socket6-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UM/UMEMOTO/${name}.tar.gz";
      sha256 = "1ads4k4vvq6pnxkdw0s8gaj03w4h9snxyw7zyikfzd20fy76yx6s";
    };
    setOutputFlags = false;
    buildInputs = [ pkgs.which ];
  };

  SoftwareLicense = buildPerlPackage rec {
    name = "Software-License-0.103012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "47f9acb7f4eeed35e38c1bec37a71b61e651965233d67dadfae6390571517db1";
    };
    propagatedBuildInputs = [ DataSection TextTemplate TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Software-License;
      description = "Packages that provide templated software licenses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SortVersions = buildPerlPackage rec {
    name = "Sort-Versions-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ED/EDAVIS/${name}.tar.gz";
      sha256 = "1yhyxaakyhcffgr9lwd314badhlc2gh9f6n47013ljshbnkgzhh9";
    };
  };

  Spiffy = buildPerlPackage rec {
    name = "Spiffy-0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "18qxshrjh0ibpzjm2314157mxlibh3smyg64nr4mq990hh564n4g";
    };
    buildInputs = [ ExtUtilsMakeMaker ];
  };

  SpreadsheetParseExcel = buildPerlPackage rec {
    name = "Spreadsheet-ParseExcel-0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOUGW/${name}.tar.gz";
      sha256 = "6ec4cb429bd58d81640fe12116f435c46f51ff1040c68f09cc8b7681c1675bec";
    };
    propagatedBuildInputs = [ CryptRC4 DigestPerlMD5 IOstringy OLEStorage_Lite ];
    meta = {
      homepage = http://github.com/runrig/spreadsheet-parseexcel/;
      description = "Read information from an Excel file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetWriteExcel = buildPerlPackage rec {
    name = "Spreadsheet-WriteExcel-2.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "e356aad6866cf135731268ee0e979a197443c15a04878e9cf3e80d022ad6c07e";
    };
    propagatedBuildInputs = [ OLEStorage_Lite ParseRecDescent ];
    meta = {
      description = "Write to a cross platform Excel binary file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstract = buildPerlPackage rec {
    name = "SQL-Abstract-1.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "5f4d5618ce2424d62bbfdb5228b382e8be0e0ccedbb273d6d850e25d07e64f9f";
    };
    buildInputs = [ TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ HashMerge MROCompat Moo ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
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
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SQLTokenizer = buildPerlPackage rec {
    name = "SQL-Tokenizer-0.24";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "1qa2dfbzdlr5qqdam9yn78z5w3al5r8577x06qan8wv58ay6ka7s";
    };
  };

  SQLTranslator = buildPerlPackage rec {
    name = "SQL-Translator-0.11021";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "64cb38a9f78367bc115359a999003bbeb3c32cc75bba8306ec1a938fc441bfd1";
    };
    buildInputs = [ JSON TestDifferences TestException XMLWriter YAML ];
    propagatedBuildInputs = [ CarpClan DBI FileShareDir ListMoreUtils Moo PackageVariant ParseRecDescent TryTiny ];
    meta = {
      description = "SQL DDL transformations and more";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  PackageVariant = buildPerlPackage {
    name = "Package-Variant-1.002002";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Package-Variant-1.002002.tar.gz;
      sha256 = "826780f19522f42c6b3d9f717ab6b5400f198cec08f4aa15b71aef9aa17e9b13";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ImportInto ModuleRuntime strictures ];
    meta = {
      description = "Parameterizable packages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortNaturally = buildPerlPackage rec {
    name = "Sort-Naturally-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746";
    };
  };

  Starlet = buildPerlPackage {
    name = "Starlet-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Starlet-0.28.tar.gz;
      sha256 = "245f606cdc8acadbe12e7e56dfa0752a8e8daa9a094373394fc17a45f5dde850";
    };
    buildInputs = [ LWP TestTCP ];
    propagatedBuildInputs = [ ParallelPrefork Plack ServerStarter ];
    meta = {
      description = "A simple, high-performance PSGI/Plack HTTP server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Starman = let version = "0.4014"; in buildPerlModule {
    name = "Starman-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Starman-${version}.tar.gz";
      sha256 = "1sbb5rb3vs82rlh1fjkgkcmj5pj62b4y9si4ihh45sl9m8c2qxx5";
    };
    buildInputs = [ LWP ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ DataDump HTTPDate HTTPMessage HTTPParserXS NetServer Plack TestTCP ];
    doCheck = false; # binds to various TCP ports
    meta = {
      inherit version;
      homepage = https://github.com/miyagawa/Starman;
      description = "High-performance preforking PSGI/Plack web server";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsBasic = buildPerlPackage {
    name = "Statistics-Basic-1.6607";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JETTERO/Statistics-Basic-1.6607.tar.gz;
      sha256 = "105agxl2581iqmwj1crgz33l5r19snf47h91hnjgm1nf555z79r7";
    };
    propagatedBuildInputs = [ NumberFormat ];
    meta = {
      license = "open_source";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StatisticsDescriptive = buildPerlPackage {
    name = "Statistics-Descriptive-3.0605";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Statistics-Descriptive-3.0605.tar.gz;
      sha256 = "8e7dae184444e27ee959e33b3ae161cc83115d11da189ed5003b004450e04b48";
    };
    meta = {
      #homepage = http://web-cpan.berlios.de/modules/Statistics-Descriptive/; # berlios shut down; I found no replacement
      description = "Module of basic descriptive statistical functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  Storable = buildPerlPackage {
    name = "Storable-2.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMS/Storable-2.51.tar.gz;
      sha256 = "a566b792112bbba21131ec1d7a2bf78170c648484895283ae53c7f0c3dc2f0be";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  strictures = buildPerlPackage rec {
    name = "strictures-2.000002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "0021m9k1f6dfqn88znlp24g7xsqxwwjbj91w474c7n5gngf5a0qk";
    };
    meta = {
      homepage = http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/strictures.git;
      description = "Turn on strict and make all warnings fatal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringApprox = buildPerlPackage rec {
    name = "String-Approx-3.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "2b8c1acd24fa9681ebba0ccb3c49f16289de1d579af8a0c898ea8f8d1baf5d36";
    };
  };

  StringCamelCase = buildPerlPackage rec {
    name = "String-CamelCase-0.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/String/${name}.tar.gz";
      sha256 = "17kh8nap2z5g5rqcvw0m7mvbai7wr7h0al39w8l827zhqad8ss42";
    };
  };

  StringCRC32 = buildPerlPackage rec {
      name = "String-CRC32-1.5";
      src = fetchurl {
        url = mirror://cpan/authors/id/S/SO/SOENKE/String-CRC32-1.5.tar.gz;
        sha256 = "0m3hjk292hnxyi8nkfy8hlr1khnbf2clgkb4kzj0ycq8gcd2z0as";
      };
      meta = {
        maintainers = with maintainers; [ ];
        platforms   = stdenv.lib.platforms.unix;
      };
  };

  StringErrf = buildPerlPackage {
    name = "String-Errf-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Errf-0.007.tar.gz;
      sha256 = "1apnmxdsqwrvn1kkbba4sw6yh6hdfxxar545p6m9dkid7xsiqjfj";
    };
    buildInputs = [ JSON TimeDate ];
    propagatedBuildInputs = [ ParamsUtil StringFormatter SubExporter ];
    meta = {
      description = "A simple sprintf-like dialect";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringEscape = buildPerlPackage rec {
    name = "String-Escape-2010.002";
    src = fetchurl {
        url = mirror://cpan/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz;
        sha256 = "12ls7f7847i4qcikkp3skwraqvjphjiv2zxfhl5d49326f5myr7x";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringFlogger = buildPerlPackage rec {
    name = "String-Flogger-1.101245";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "aa03c08e01f802a358c175c6093c02adf9688659a087a8ddefdc3e9cef72640b";
    };
    propagatedBuildInputs = [ JSONMaybeXS ParamsUtil SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/String-Flogger;
      description = "String munging for loggers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringFormat = buildPerlPackage rec {
    name = "String-Format-1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "0sxfavcsb349rfafxflq2f9h3xpxabrw0q7vhmh9n3hjij8fa1jk";
    };
  };

  StringFormatter = buildPerlPackage {
    name = "String-Formatter-0.102084";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Formatter-0.102084.tar.gz;
      sha256 = "0mlwm0rirv46gj4h072q8gdync5zxxsxy8p028gdyrhczl942dc3";
    };
    propagatedBuildInputs = [ ParamsUtil SubExporter ];
    meta = with stdenv.lib; {
      description = "Build sprintf-like functions of your own";
      license = licenses.gpl2;
    };
  };

  StringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.05.tar.gz;
      sha256 = "15lvcc8c9hp6mg3jx02wd3b85aphn8yl5db62q3pam04c0sgh42k";
    };
  };

  StringRewritePrefix = buildPerlPackage {
    name = "String-RewritePrefix-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.007.tar.gz;
      sha256 = "18nxl1vgkcx0r7ifkmbl9fp73f8ihiqhqqf3vq6sj5b3cgawrfsw";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Rewrite strings based on a set of known prefixes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringShellQuote = buildPerlPackage {
    name = "String-ShellQuote-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz;
      sha256 = "0dfxhr6hxc2majkkrm0qbx3qcbykzpphbj2ms93dc86f7183c1p6";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringToIdentifierEN = buildPerlPackage rec {
    name = "String-ToIdentifier-EN-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1bawghkgkkx7j3avnrj5sg3vix1z5564ks6wf9az3jc2knh8s5nh";
    };
    propagatedBuildInputs =
      [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
  };

  StringTruncate = buildPerlPackage {
    name = "String-Truncate-1.100602";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100602.tar.gz;
      sha256 = "0vjz4fd4cvcy12gk5bdha7z73ifmfpmk748khha94dhiq3pd98xa";
    };
    propagatedBuildInputs = [ SubExporter SubInstall ];
    meta = {
      description = "A module for when strings are too long to be displayed in";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringTT = buildPerlPackage {
    name = "String-TT-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/String-TT-0.03.tar.gz;
      sha256 = "1asjr79wqcl9wk96afxrm1yhpj8lk9bk8kyz78yi5ypr0h55yq7p";
    };
    buildInputs = [ Testuseok TestException TestTableDriven ];
    propagatedBuildInputs = [ PadWalker SubExporter TemplateToolkit ];
    meta = {
      description = "Use TT to interpolate lexical variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringUtil = let version = "1.24"; in buildPerlPackage {
    name = "String-Util-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/String-Util-${version}.tar.gz";
      sha256 = "16c7dbpz87ywq49lnsaml0k28jbkraf1p2njh72jc5xcxys7vykv";
    };
    meta = {
      inherit version;
      description = "String::Util -- String processing utilities";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libfile-stripnondeterminism = buildPerlPackage rec {
    name = "libstrip-nondeterminism-${version}";
    version = "0.016";

    src = fetchurl {
      url = "http://http.debian.net/debian/pool/main/s/strip-nondeterminism/strip-nondeterminism_${version}.orig.tar.gz";
      sha256 = "1y9lfhxgwyysybing72n3hng2db5njpk2dbb80vskdz75r7ffqjp";
    };

    buildInputs = [ ArchiveZip_1_53 pkgs.file ];
  };


  strip-nondeterminism = buildPerlPackage rec {
    name = "strip-nondeterminism-${version}";
    version = "0.016";

    src = fetchurl {
      url = "http://http.debian.net/debian/pool/main/s/strip-nondeterminism/strip-nondeterminism_${version}.orig.tar.gz";
      sha256 = "1y9lfhxgwyysybing72n3hng2db5njpk2dbb80vskdz75r7ffqjp";
    };

    buildInputs = [ ArchiveZip_1_53 libfile-stripnondeterminism pkgs.file ];

    meta = with stdenv.lib; {
      description = "A Perl module for stripping bits of non-deterministic information";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ pSub ];
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterForMethods = buildPerlPackage rec {
    name = "Sub-Exporter-ForMethods-0.100052";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "421fbba4f6ffcf13c4335f2c20630d709e6fa659c07545d094dbc5a558ad3006";
    };
    buildInputs = [ namespaceautoclean ];
    propagatedBuildInputs = [ SubExporter SubName ];
    meta = {
      homepage = https://github.com/rjbs/Sub-Exporter-ForMethods;
      description = "Helper routines for using Sub::Exporter to build methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  SubExporterGlobExporter = buildPerlPackage {
    name = "Sub-Exporter-GlobExporter-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-GlobExporter-0.004.tar.gz;
      sha256 = "025wgjavrbzh52jb4v0w2fxqh7r5181k935h9cyy2rm1qk49fg8p";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter-globexporter;
      description = "Export shared globs with Sub::Exporter collectors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterProgressive = buildPerlPackage {
    name = "Sub-Exporter-Progressive-0.001011";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001011.tar.gz;
      sha256 = "01kwzbqwdhvadpphnczid03nlyj0h4cxaq3m3v2401bckkkcc606";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Only use Sub::Exporter if you need it";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterUtil = let version = "0.987"; in buildPerlPackage {
    name = "Sub-Exporter-Util-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-${version}.tar.gz";
      sha256 = "1ml3n1ck4ln9qjm2mcgkczj1jb5n1fkscz9c4x23v4db0glb4g2l";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      inherit version;
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "83bb785a66113b4a966db0a4186fd1dd07987acdacb4502b1e1558f817dde825";
    };
    meta = {
      description = "Retrieve names of code references";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubInstall = buildPerlPackage {
    name = "Sub-Install-0.927";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Install-0.927.tar.gz;
      sha256 = "0nmgsdbwi8f474jkyd6w9jfnpav99xp8biydcdri8qri623f6plm";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Install subroutines into packages easily";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubName = buildPerlPackage rec {
    name = "Sub-Name-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "b06ba8252ce3b1bb88fa0ea0fe9ec8b572e5ed36c69f55e9e3d9db8a73efe22b";
    };
    buildInputs = [ self."if" ];
    meta = {
      homepage = https://github.com/p5sagit/Sub-Name;
      description = "(Re)name a sub";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
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

  SubQuote = buildPerlPackage rec {
    name = "Sub-Quote-2.003001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/${name}.tar.gz";
      sha256 = "9d471d8e13e7ce4793d5a5ec04a60fface14dd53be78dd94d228871915cfd1f9";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Efficient generation of subroutines via string eval";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SVNSimple = buildPerlPackage rec {
    name = "SVN-Simple-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/${name}.tar.gz";
      sha256 = "1ysgi38zx236cxz539k6d6rw5z0vc70rrglsaf5fk6rnwilw2g6n";
    };
    propagatedBuildInputs = [ pkgs.subversionClient ];
  };

  Swim = buildPerlPackage rec {
    name = "Swim-0.1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "3755ba1a02aee933c8e1de3995aca1523d6175291a1fa60c3f7fd477f5bb2469";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ HTMLEscape HashMerge IPCRun Pegex TextAutoformat YAMLLibYAML ];
    meta = {
      homepage = https://github.com/ingydotnet/swim-pm;
      description = "See What I Mean?!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Switch = buildPerlPackage rec {
    name = "Switch-2.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz";
      sha256 = "0xbdjdgzfj9zwa4j3ipr8bfk7bcici4hk89hq5d27rhg2isljd9i";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
  };

  SymbolGlobalName = buildPerlPackage {
    name = "Symbol-Global-Name-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Symbol-Global-Name-0.05.tar.gz;
      sha256 = "0f7623e9d724760aa64040222da1d82f1188586791329261cc60dad1d60d6a92";
    };
    meta = {
      description = "Finds name and type of a global variable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SymbolUtil = buildPerlPackage {
    name = "Symbol-Util-0.0203";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Symbol-Util-0.0203.tar.gz;
      sha256 = "0cnwwrd5d6i80f33s7n2ak90rh4s53ss7q57wndrpkpr4bfn3djm";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  syntax = buildPerlPackage {
    name = "syntax-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHAYLON/syntax-0.004.tar.gz;
      sha256 = "fe19b6da8a8f43a5aa2ee571441bc0e339fb156d0081c157a1a24e9812c7d365";
    };
    propagatedBuildInputs = [ DataOptList namespaceclean ];
    meta = {
      homepage = https://github.com/phaylon/syntax/wiki;
      description = "Activate syntax extensions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SyntaxKeywordJunction = buildPerlPackage rec {
    name = "Syntax-Keyword-Junction-0.003008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/${name}.tar.gz";
      sha256 = "8b4975f21b1992a7e6c2df5dcc92b254c61925595eddcdfaf0b1498717aa95ef";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ SubExporterProgressive syntax ];
    meta = {
      homepage = https://github.com/frioux/Syntax-Keyword-Junction;
      description = "Perl6 style Junction operators in Perl5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysHostnameLong = buildPerlPackage rec {
    name = "Sys-Hostname-Long-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/${name}.tar.gz";
      sha256 = "0hy1225zg2yg11xhgj0wbiapzjyf6slx17ln36zqvfm07k6widlx";
    };
    doCheck = false; # no `hostname' in stdenv
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SysSigAction = buildPerlPackage {
    name = "Sys-SigAction-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.21.tar.gz;
      sha256 = "e144207a6fd261eb9f98554c76bea66d95870ee1f62d2d346a1ea95fdccf80db";
    };
    meta = {
      description = "Perl extension for Consistent Signal Handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysSyslog = buildPerlPackage {
    name = "Sys-Syslog-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/Sys-Syslog-0.34.tar.gz;
      sha256 = "09cnzk0fpj2i8asi4ba5wzs3i5pmbins87xpgmxcw4ipmn66s7ld";
    };
    meta = {
      description = "Perl interface to the UNIX syslog(3) calls";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysVirt = buildPerlPackage rec {
    name = "Sys-Virt-1.2.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/${name}.tar.gz";
      sha256 = "18v8x0514in0zpvq1rv78hmvhpij1xjh5xn0wa6wmg2swky54sp4";
    };
    propagatedBuildInputs = [XMLXPath];
    buildInputs = [TestPodCoverage TimeHiRes TestPod pkgs.pkgconfig pkgs.libvirt];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TAPParserSourceHandlerpgTAP = buildPerlModule {
    name = "TAP-Parser-SourceHandler-pgTAP-3.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.30.tar.gz;
      sha256 = "08gadqf898r23sx07sn13555cp9zkwp8igjlh1fza2ycfivpfl9f";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Tap-Parser-Sourcehandler-pgTAP/;
      description = "Stream TAP from pgTAP test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };

  TaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "75b1b2d96155647842587146cefd0de30943b85195e8e3eca51e0f0b8642d61e";
    };
    buildInputs = [TestPodCoverage];
    propagatedBuildInputs = [ CatalystAuthenticationStoreDBIxClass CatalystControllerHTMLFormFu CatalystDevel CatalystManual CatalystModelDBICSchema CatalystPluginAuthentication CatalystPluginAuthorizationACL CatalystPluginAuthorizationRoles CatalystPluginSession CatalystPluginSessionStateCookie CatalystPluginSessionStoreFastMmap CatalystPluginStackTrace CatalystRuntime CatalystViewTT DBIxClass ];
    meta = {
      description = "Everything you need to follow the Catalyst Tutorial";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TaskFreecellSolverTesting = buildPerlModule rec {
    name = "Task-FreecellSolver-Testing-v0.0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "ce8960c0250a9947ae5b4485e8a3e807bb2d87b1120096464b3d2247d2c194ff";
    };
    buildInputs = [ ModuleBuild perl ];
    propagatedBuildInputs = [ EnvPath FileWhich GamesSolitaireVerify Inline InlineC ListMoreUtils Moo MooX PathTiny StringShellQuote TaskTestRunAllPlugins TemplateToolkit TestDataSplit TestDifferences TestPerlTidy TestRunPluginTrimDisplayedFilenames TestRunValgrind TestTrailingSpace YAMLLibYAML ];
    meta = {
      homepage = http://metacpan.org/release/Task-FreecellSolver-Testing;
      description = "Install the CPAN dependencies of the Freecell Solver test suite";
      license = stdenv.lib.licenses.mit;
    };
  };

  TaskPlack = buildPerlModule rec {
    name = "Task-Plack-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0ajwkyr9nwn11afi6fz6kx4bi7a3p8awjsldmsakz3sl0s42pmbr";
    };
    propagatedBuildInputs = [ Plack PSGI ModuleBuildTiny ];
  };

  TaskTestRunAllPlugins = buildPerlPackage rec {
    name = "Task-Test-Run-AllPlugins-0.0105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "fd43bd053aa884a5abca851f145a0e29898515dcbfc3512f18cd0d86d28eb0a9";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ TestRun TestRunCmdLine TestRunPluginAlternateInterpreters TestRunPluginBreakOnFailure TestRunPluginColorFileVerdicts TestRunPluginColorSummary TestRunPluginTrimDisplayedFilenames ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Specifications for installing all the Test::Run";
      license = stdenv.lib.licenses.mit;
    };
  };

  TaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.04.tar.gz;
      sha256 = "1i7kd9v8fjsqyhr4rx4a1jv7n5vfjjm1v4agb24pizh0b72p3qk7";
    };
    meta = {
      description = "Ensure that a platform has weaken support";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginAutoformat = buildPerlPackage {
    name = "Template-Plugin-Autoformat-2.77";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KARMAN/Template-Plugin-Autoformat-2.77.tar.gz;
      sha256 = "bddfb4919f0abb2a2be7a9665333e0d4e098032f0e383dbaf04c4d896c7486ed";
    };
    propagatedBuildInputs = [ TemplateToolkit TextAutoformat ];
    meta = {
      homepage = https://github.com/karpet/template-plugin-autoformat;
      description = "TT plugin for Text::Autoformat";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginClass = buildPerlPackage {
    name = "Template-Plugin-Class-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Template-Plugin-Class-0.14.tar.gz;
      sha256 = "1hq7jy6zg1iaslsyi05afz0i944y9jnv3nb4krkxjfmzwy5gw106";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginIOAll = buildPerlPackage {
    name = "Template-Plugin-IO-All-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XERN/Template-Plugin-IO-All-0.01.tar.gz;
      sha256 = "1f7445422a21932e09bbef935766e0af6b7cceb088e9d8e030cd7a84bcdc5ee4";
    };
    propagatedBuildInputs = [ IOAll TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ eelco ];
      description = "Perl Template Toolkit Plugin for IO::All";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginJavaScript = buildPerlPackage {
    name = "Template-Plugin-JavaScript-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Template-Plugin-JavaScript-0.02.tar.gz;
      sha256 = "1mqqqs0dhfr6bp1305j9ns05q4pq1n3f561l6p8848k5ml3dh87a";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginJSONEscape = buildPerlPackage {
    name = "Template-Plugin-JSON-Escape-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NANTO/Template-Plugin-JSON-Escape-0.02.tar.gz;
      sha256 = "051a8b1d3bc601d58fc51e246067d36450cfe970278a0456e8ab61940f13cd86";
    };
    propagatedBuildInputs = [ JSON TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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
      license = with stdenv.lib.licenses; [ artistic2 gpl3 ];
    };
  };

  TemplateTiny = buildPerlPackage {
    name = "Template-Tiny-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Template-Tiny-1.12.tar.gz;
      sha256 = "073e062c630b51dfb725cd6485a329155cb72d5c596e8cb698eb67c4566f0a4a";
    };
    meta = {
      description = "Template Toolkit reimplemented in as little code as possible";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplateToolkit = buildPerlPackage rec {
    name = "Template-Toolkit-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.25.tar.gz;
      sha256 = "048yg07j48rix3cly13j5wzms7kd5argviicj0kwykb004xpc8zl";
    };
    propagatedBuildInputs = [ AppConfig ];
    meta = {
      description = "Comprehensive template processing system";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermANSIColor = buildPerlPackage {
    name = "Term-ANSIColor-4.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RR/RRA/Term-ANSIColor-4.03.tar.gz;
      sha256 = "e89b6992030fa713f928f653dcdb71d66fa2493f873bacf5653aa121ca862450";
    };
    meta = {
      description = "Color output using ANSI escape sequences";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermCap = let version = "1.17"; in buildPerlPackage {
    name = "Term-Cap-${version}";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTOWE/Term-Cap-${version}.tar.gz";
      sha256 = "0qyicyk4aikw6w3fm8c4y6hd7ff70crkl6bf64qmiakbgxy9p6p7";
    };
    meta = {
      inherit version;
      description = "Perl termcap interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermEncoding = buildPerlPackage {
    name = "Term-Encoding-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Term-Encoding-0.02.tar.gz;
      sha256 = "f274e72346a0c0cfacfb53030ac1e38b57425512fc5bdc5cd9ef75ab0f26cfcc";
    };
    meta = {
      description = "Detect encoding of the current terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBar = buildPerlPackage {
    name = "Term-ProgressBar-2.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SZ/SZABGAB/Term-ProgressBar-2.14.tar.gz;
      sha256 = "18cj7mzbis9xk0v32g2700vq9b4p9v5msk02mglf244cj77bflf6";
    };
    buildInputs = [ CaptureTiny TestException ];
    propagatedBuildInputs = [ ClassMethodMaker TermReadKey ];
    meta = {
      description = "Provide a progress meter on a standard terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarQuiet = buildPerlPackage {
    name = "Term-ProgressBar-Quiet-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Term-ProgressBar-Quiet-0.31.tar.gz;
      sha256 = "25675292f588bc29d32e710cf3667da9a2a1751e139801770a9fdb18cd2184a6";
    };
    propagatedBuildInputs = [ IOInteractive TermProgressBar TestMockObject ];
    meta = {
      description = "";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarSimple = buildPerlPackage {
    name = "Term-ProgressBar-Simple-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EV/EVDB/Term-ProgressBar-Simple-0.03.tar.gz;
      sha256 = "a20db3c67d5bdfd0c1fab392c6d1c26880a7ee843af602af4f9b53a7043579a6";
    };
    propagatedBuildInputs = [ TermProgressBarQuiet ];
  };

  TermReadKey = buildPerlPackage {
    name = "TermReadKey-2.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.31.tar.gz;
      sha256 = "1czarrdxgnxmmbaasjnq3sj14nf1cvzhm37padq6xvl7h7r2acb2";
    };
  };

  TermReadLineGnu = buildPerlPackage rec {
    name = "Term-ReadLine-Gnu-1.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/${name}.tar.gz";
      sha256 = "42174b4bc9d3881502d527fc7c8bd1c0a4b266c2f0bbee012e9a604999418f3b";
    };
    buildInputs = [ pkgs.readline pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lreadline -lncursesw";

    # For some crazy reason Makefile.PL doesn't generate a Makefile if
    # AUTOMATED_TESTING is set.
    AUTOMATED_TESTING = false;

    # Makefile.PL looks for ncurses in Glibc's prefix.
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '$Config{libpth}' \
          "'${pkgs.ncurses.out}/lib'"
      '';

    # Tests don't work because they require /dev/tty.
    doCheck = false;

    meta = {
      homepage = http://sourceforge.net/projects/perl-trg/;
      description = "Perl extension for the GNU Readline/History Library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermShellUI = buildPerlPackage rec {
    name = "Term-ShellUI-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRONSON/${name}.tar.gz";
      sha256 = "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb";
    };
  };

  TermSizeAny = buildPerlPackage {
    name = "Term-Size-Any-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz;
      sha256 = "64fa5fdb1ae3a823134aaa95aec75354bc17bdd9ca12ba0a7ae34a7e51b3ded2";
    };
    propagatedBuildInputs = [ DevelHide TermSizePerl ];
    meta = {
      description = "Retrieve terminal size";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermSizePerl = buildPerlPackage {
    name = "Term-Size-Perl-0.029";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Perl-0.029.tar.gz;
      sha256 = "8c1aaab73646ee1d233e827213ea3b5ab8afcf1d02a8f94be7aed306574875e7";
    };
    meta = {
      description = "Perl extension for retrieving terminal size (Perl version)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermVT102 = buildPerlPackage {
    name = "Term-VT102-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AJ/AJWOOD/Term-VT102-0.91.tar.gz;
      sha256 = "f954e0310941d45c0fc3eb4a40f5d3a00d68119e277d303a1e6af11ded6fbd94";
    };
    meta = {
    };
  };

  TermVT102Boundless = buildPerlPackage {
    name = "Term-VT102-Boundless-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Term-VT102-Boundless-0.04.tar.gz;
      sha256 = "5bb88b5aecb44ebf56d3ac7240be80cd26def9dcf1ebeb4e77d9983dfc7a8f19";
    };
    propagatedBuildInputs = [ TermVT102 Testuseok ];
    meta = {
      license = "unknown";
    };
  };

  Test = buildPerlPackage {
    name = "Test-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Test-1.26.tar.gz;
      sha256 = "f7701bd28e05e7f82fe9a181bbab38f53fa6aeae48d2a810da74d1b981d4f392";
    };
    meta = {
      description = "Provides a simple framework for writing test scripts";
    };
  };

  Test2Suite = buildPerlPackage rec {
    name = "Test2-Suite-0.000061";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "b2ef2a59c8864c79f6c6a64c65e12c93f881361e4d9eb54419fcb4785c08ea75";
    };
    propagatedBuildInputs = [ Importer TestSimple13 ];
    meta = {
      description = "Distribution with a rich set of tools built upon the Test2 framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestAssert = buildPerlPackage {
    name = "Test-Assert-0.0504";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Assert-0.0504.tar.gz;
      sha256 = "194bzflmzc0cw5727kznbj1zwzj7gnj7nx1643zk2hshdjlnv8yg";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ constantboolean ExceptionBase SymbolUtil ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestAssertions = buildPerlPackage rec {
    name = "Test-Assertions-1.054";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "10026w4r3yv6k3vc6cby7d61mxddlqh0ls6z39c82f17awfy9p7w";
    };
    buildInputs = [ LogTrace ];
  };

  TestAggregate = buildPerlPackage rec {
    name = "Test-Aggregate-0.373";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/${name}.tar.gz";
      sha256 = "00d218daa7ba29d82bcf364b61d391d3a14356cf3bcb4b12144270108a14fd14";
    };
    buildInputs = [ TestMost TestTrap ];
    propagatedBuildInputs = [ TestNoWarnings ];
    meta = {
      description = "Aggregate C<*.t> tests to make them run faster";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  TestBase = buildPerlPackage rec {
    name = "Test-Base-0.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0fch1cvivnszbnwhpfmwv1rin04j5xkj1n1ylfmlxg6bm72qqdjj";
    };
    propagatedBuildInputs = [ Spiffy ];
  };

  TestCheckDeps = buildPerlPackage rec {
    name = "Test-CheckDeps-0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/${name}.tar.gz";
      sha256 = "1vjinlixxdx6gfcw8y1dw2rla8bfhi8nmgcqr3nffc7kqskcrz36";
    };
    buildInputs = [ ModuleBuildTiny ModuleMetadata ];
    propagatedBuildInputs = [ CPANMetaCheck ];
    meta = {
      description = "Check for presence of dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestClass = buildPerlPackage rec {
    name = "Test-Class-0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "099154ed8caf3ff97c71237fab952264ac1c03d9270737a56071cabe65991350";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ MROCompat ModuleRuntime TryTiny ];
    meta = {
      description = "Easily create test classes in an xUnit/JUnit style";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestCleanNamespaces = buildPerlPackage {
    name = "Test-CleanNamespaces-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-CleanNamespaces-0.16.tar.gz;
      sha256 = "9779378394b9be32cf04129fafe2d40d74f6f200f593f1494998bd128a6ed9fa";
    };
    buildInputs = [ ModuleRuntime TestDeep TestRequires TestTester TestWarnings if_ ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl ModuleRuntime PackageStash SubExporter SubIdentify namespaceclean ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-CleanNamespaces;
      description = "Check for uncleaned imports";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCommand = buildPerlPackage {
    name = "Test-Command-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANBOO/Test-Command-0.11.tar.gz;
      sha256 = "0cwm3c4d49mdrbm6vgh78b3x8mk730l0zg8i7xb9z8bkx9pzr8r8";
    };
    meta = {
      homepage = https://github.com/danboo/perl-test-command;
      description = "Test routines for external commands ";
      license = with stdenv.lib.licenses; [ artistic1 gpl1 ];
    };
  };

  TestCPANMeta = buildPerlPackage {
    name = "Test-CPAN-Meta-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-0.23.tar.gz;
      sha256 = "dda70c5cb61eddc6d3148cb66b6ff5eb4546a065257f4c104112a8a8a3575116";
    };
    meta = {
      description = "Validate your CPAN META.yml files";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestDataSplit = buildPerlModule rec {
    name = "Test-Data-Split-0.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "90811c2af56750bf08eeff39e1e30f2ff8f625e809ed838b5ccb56a256c4b595";
    };
    buildInputs = [ ModuleBuild TestDifferences perl ];
    propagatedBuildInputs = [ IOAll ListMoreUtils MooX MooXlate ];
    meta = {
      description = "Split data-driven tests into several test scripts";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestDeep = buildPerlPackage {
    name = "Test-Deep-0.112";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-0.112.tar.gz;
      sha256 = "1vg1bb1lpqpj0pxk738ykip4kw3agbi88g90wxb3pc11l84nlsan";
    };
    propagatedBuildInputs = [ TestNoWarnings TestTester ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  TestDir = buildPerlPackage {
    name = "Test-Dir-1.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MT/MTHURN/Test-Dir-1.014.tar.gz;
      sha256 = "b36efc286f8127b04fd7bb0dfdf4bd0a090b175872e35b5ce6d4d80c772c28bf";
    };
    meta = {
      description = "Test directory attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDifferences = buildPerlPackage {
    name = "Test-Differences-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCANTRELL/Test-Differences-0.63.tar.gz;
      sha256 = "7c657a178c32f48de3b469f6d4f67b75f018a3a19c1e6d0d8892188b0d261a66";
    };
    propagatedBuildInputs = [ CaptureTiny TextDiff ];
    meta = {
      description = "Test strings and data structures and show differences if not ok";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDistManifest = buildPerlPackage {
    name = "Test-DistManifest-1.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-DistManifest-1.012.tar.gz;
      sha256 = "4b128bef9beea2f03bdca037ceb722de43b4a2c516c3f50c2a26421548a72208";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ ModuleManifest ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-DistManifest;
      description = "Author test that validates a package MANIFEST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestEOL = buildPerlPackage {
    name = "Test-EOL-1.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Test-EOL-1.5.tar.gz;
      sha256 = "0qfdn71562xzmgnhmkkdbpp3vj851ldl1zlmxvharxsr16gjh6s3";
    };
    meta = {
      homepage = http://metacpan.org/release/Test-EOL;
      description = "Check the correct line endings in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestException = buildPerlPackage rec {
    name = "Test-Exception-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADIE/${name}.tar.gz";
      sha256 = "0issbjh5yl62lpaff5zhn28zhbf8sv8n2g79vklfr5s703k2fi5s";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestFailWarnings = buildPerlPackage {
    name = "Test-FailWarnings-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-FailWarnings-0.008.tar.gz;
      sha256 = "0vx9chcp5x8m0chq574p9fnfckh5gl94j7904rh9v17n568fyd6s";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      homepage = https://metacpan.org/release/Test-FailWarnings;
      description = "Add test failures if warnings are caught";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestFatal = buildPerlPackage rec {
    name = "Test-Fatal-0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "bcdcef5c7b2790a187ebca810b0a08221a63256062cfab3c3b98685d91d1cbb0";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Test-Fatal;
      description = "Incredibly simple helpers for testing code with exceptions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestFile = buildPerlPackage {
    name = "Test-File-1.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-File-1.41.tar.gz;
      sha256 = "45ec1b714f64d05e34205c40b08c49549f257910e4966fa28e2ac170d5516316";
    };
    buildInputs = [ Testutf8 ];
    meta = {
      description = "Check file attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFileContents = buildPerlModule {
    name = "Test-File-Contents-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-File-Contents-0.21.tar.gz;
      sha256 = "1b5a13f86f5df625ffd30361f628d34b0ceda80b9f39ca74bf0a4c1105828317";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-File-Contents/;
      description = "Test routines for examining the contents of files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFileShareDir = buildPerlModule {
    name = "Test-File-ShareDir-0.3.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/Test-File-ShareDir-0.3.3.tar.gz;
      sha256 = "877e14afb6f432bd888ef730c0afd776dd149b14bc520bc2ce842d114e5886a2";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ FileCopyRecursive FileShareDir PathTiny ];
    meta = {
      homepage = https://github.com/kentfredric/Test-File-ShareDir;
      description = "Create a Fake ShareDir for your modules for testing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarness = buildPerlPackage {
    name = "Test-Harness-3.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Test-Harness-3.33.tar.gz;
      sha256 = "c22e36287d5cee3c28fd2006e3c8b6e7cc76c6fc39d79c7ab74f1936d35e8fe2";
    };
    doCheck = false; # makes assumptions about path to Perl
    meta = {
      homepage = http://testanything.org/;
      description = "Run Perl standard test scripts with statistics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarnessStraps = buildPerlModule {
    name = "Test-Harness-Straps-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Harness-Straps-0.30.tar.gz;
      sha256 = "8b00efaa35723c1a35c8c8f5fa46a99e4bc528dfa520352b54ac418ef6d1cfa8";
    };
    meta = {
      description = "Detailed analysis of test results";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHTTPServerSimple = buildPerlPackage {
    name = "Test-HTTP-Server-Simple-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Test-HTTP-Server-Simple-0.11.tar.gz;
      sha256 = "85c97ebd4deb805291b17277032da48807228f24f89b1ce2fb3c09f7a896bb78";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Test::More functions for HTTP::Server::Simple";
    };
  };

  TestJSON = buildPerlPackage {
    name = "Test-JSON-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-JSON-0.11.tar.gz;
      sha256 = "1cyp46w3q7dg89qkw31ik2h2a6mdx6pzdz2lmp8m0a61zjr8mh07";
    };
    propagatedBuildInputs = [ JSONAny TestDifferences TestTester ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestLeakTrace = buildPerlPackage rec {
    name = "Test-LeakTrace-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "06cn4g35l2gi9vbsdi2j49cxsji9fvfi7xp4xgdyxxds9vrxydia";
    };
    meta = {
      description = "Traces memory leaks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.15";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0r2i3a35l116ccwx88jwiii2fq4b8wm16sl1lkxm2kh44s4z7s5s";
    };
  };

  TestMemoryCycle = buildPerlPackage rec {
    name = "Test-Memory-Cycle-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "9d53ddfdc964cd8454cb0da4c695b6a3ae47b45839291c34cb9d8d1cfaab3202";
    };
    propagatedBuildInputs = [ DevelCycle PadWalker ];
    meta = {
      description = "Verifies code hasn't left circular references";
      maintainers = with maintainers; [ ];
      platforms = stdenv.lib.platforms.unix;
    };
  };

  TestMockClass = buildPerlPackage {
    name = "Test-Mock-Class-0.0303";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Mock-Class-0.0303.tar.gz;
      sha256 = "00pkfqcz7b34q1mvx15k46sbxs22zcrvrbv15rnbn2na57z54bnd";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase FatalException Moose namespaceclean TestAssert ];
    meta = with stdenv.lib; {
      description = "Simulating other classes";
      license = licenses.lgpl2Plus;
      maintainers = with maintainers; [ ];
      platforms   = platforms.unix;
    };
  };

  TestMockGuard = buildPerlModule rec {
    name = "Test-Mock-Guard-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/${name}.tar.gz";
      sha256 = "7f228a63f8d6ceb92aa784080a13e85073121b2835eca06d794f9709950dbd3d";
    };
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = https://github.com/zigorou/p5-test-mock-guard;
      description = "Simple mock test library using RAII";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockModule = buildPerlModule {
    name = "Test-MockModule-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFRANKS/Test-MockModule-0.11.tar.gz;
      sha256 = "1f8l5y9dzik7a19mdbydqa0yxc4x0ilgpf9yaq6ix0bzlsilnn05";
    };
    propagatedBuildInputs = [ SUPER ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  SUPER = buildPerlPackage rec {
    name = "SUPER-1.20141117";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "1a620e7d60aee9b13b1b26a44694c43fdb2bba1755cfff435dae83c7d42cc0b2";
    };
    propagatedBuildInputs = [ SubIdentify ];
    meta = {
      description = "Control superclass method dispatch";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  TestMockObject = buildPerlPackage rec {
    name = "Test-MockObject-1.20150527";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/${name}.tar.gz";
      sha256 = "adf1357a9014b3a397ff7ecbf1835dec376a67a37bb2e788734a627e17dc1d98";
    };
    buildInputs = [ TestException TestWarn CGI ];
    propagatedBuildInputs = [ UNIVERSALcan UNIVERSALisa ];
    meta = {
      description = "Perl extension for emulating troublesome interfaces";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMoose = Moose;

  TestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "104p9qsqcchfbxh6b6w7q9jhkwb4hc424js0cyivyanjm6bcqvj9";
    };
  };

  TestMojibake = buildPerlPackage {
    name = "Test-Mojibake-0.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Test-Mojibake-0.9.tar.gz;
      sha256 = "0b7jamkmws6k3cvzwrz3r5vcpjrdhr8wndf82i5nx2z19xsy33ym";
    };
    meta = {
      homepage = https://github.com/creaktive/Test-Mojibake;
      description = "Check your source for encoding misbehavior";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMore = TestSimple;

  TestMost = buildPerlPackage {
    name = "Test-Most-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-Most-0.33.tar.gz;
      sha256 = "0jp4jcwk97bgf85wwyjpxfsx4165s6w1v4ymn9gnv03yn77inyij";
    };
    propagatedBuildInputs = [ ExceptionClass TestDeep TestDifferences TestException TestWarn ];
    meta = {
      description = "Most commonly needed test functions and features";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNoTabs = buildPerlPackage {
    name = "Test-NoTabs-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Test-NoTabs-1.3.tar.gz;
      sha256 = "06gvj0pgljc7n9rxhvwb0gq9wk51i3ks41lgh7a5ycqfkh9d0glw";
    };
    meta = {
      description = "Check the presence of tabs in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

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
      license = stdenv.lib.licenses.lgpl21;
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

  TestPerlTidy = buildPerlPackage rec {
    name = "Test-PerlTidy-20130104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LA/LARRYL/${name}.tar.gz";
      sha256 = "3f15d9f3f4811e348594620312258d75095237925b491ada623fa73ac9d2b9c8";
    };
    propagatedBuildInputs = [ FileFinder FileSlurp PerlTidy TextDiff ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPod = buildPerlPackage rec {
    name = "Test-Pod-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1yvy5mc4j3s2h4aizryvark2nm58g2c6zhw9mlx9wmsavz7d78f1";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod/;
      description = "Check for POD errors in files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  TestPodLinkCheck = buildPerlPackage rec {
    name = "Test-Pod-LinkCheck-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/${name}.tar.gz";
      sha256 = "2bfe771173c38b69eeb089504e3f76511b8e45e6a9e6dac3e616e400ea67bcf0";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CaptureTiny Moose TestPod podlinkcheck ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod-LinkCheck/;
      description = "Tests POD for invalid links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPortabilityFiles = buildPerlPackage {
    name = "Test-Portability-Files-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.06.tar.gz;
      sha256 = "3e0fd033387ab82df8aedd42a14a8e64200aebd59447ad62a3bc411ff4a808a8";
    };
    meta = {
      description = "Check file names portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequires = buildPerlPackage rec {
    name = "Test-Requires-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "1d9f481lj12cw1ciil46xq9nq16p6a90nm7yrsalpf8asn8s6s17";
    };
    meta = {
      description = "Checks to see if the module can be loaded";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRoo = buildPerlPackage rec {
    name = "Test-Roo-1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1mnym49j1lj7gzylma5b6nr4vp75rmgz2v71904v01xmxhy9l4i1";
    };

    propagatedBuildInputs = [ strictures Moo MooXTypesMooseLike SubInstall
      CaptureTiny ];
  };

  TestRoutine = buildPerlPackage {
    name = "Test-Routine-0.018";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Routine-0.018.tar.gz;
      sha256 = "1slaljcija2pbsxdyrqsh09pgajxbln68gb47l9fwffb6gsp5f3m";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose namespaceautoclean namespaceclean ParamsUtil SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/Test-Routine;
      description = "Composable units of assertion";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestRun = buildPerlPackage rec {
    name = "Test-Run-0.0304";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "f3feaf9c4494c0b3a5294228cab27efe93653b7e0bbd7fbb99b94b65b247f323";
    };
    buildInputs = [ ModuleBuild TestTrap ];
    propagatedBuildInputs = [ IPCSystemSimple ListMoreUtils MROCompat Moose MooseXStrictConstructor TextSprintfNamed UNIVERSALrequire ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Base class to run standard TAP scripts";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunCmdLine = buildPerlPackage rec {
    name = "Test-Run-CmdLine-0.0131";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "cceeeecd3f4b2f1d2929f3ada351c1ade23a8ac73ef0486dc6e9605ebcdaef18";
    };
    buildInputs = [ ModuleBuild TestTrap ];
    propagatedBuildInputs = [ Moose MooseXGetopt TestRun UNIVERSALrequire YAMLLibYAML ];
    meta = {
      homepage = http://web-cpan.berlios.de/modules/Test-Run/;
      description = "Analyze tests from the command line using Test::Run";
      license = stdenv.lib.licenses.mit;
    };
   };

  TestRunPluginAlternateInterpreters = buildPerlPackage rec {
    name = "Test-Run-Plugin-AlternateInterpreters-0.0124";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "eecb3830d350b5d7853322df4f3090af42ff17e9c31075f8d4f69856c968bff3";
    };
    buildInputs = [ ModuleBuild TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ MROCompat Moose TestRun TestRunCmdLine ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Define different interpreters for different test scripts with Test::Run";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginBreakOnFailure = buildPerlPackage rec {
    name = "Test-Run-Plugin-BreakOnFailure-v0.0.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "e422eb64a2fa6ae59837312e37ab88d68b4945148eb436a3774faed5074f0430";
    };
    buildInputs = [ ModuleBuild TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ MROCompat Moose TestRun TestRunCmdLine ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Stop processing the entire test suite";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginColorFileVerdicts = buildPerlPackage rec {
    name = "Test-Run-Plugin-ColorFileVerdicts-0.0124";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0418f03abe241f5a3c2a2ab3dd2679d11eee42c9e1f5b5a6ea80d9e238374302";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ MROCompat Moose TestRun TestRunCmdLine ] ++ moreInputs;
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Make the file verdict ('ok', 'NOT OK')";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginColorSummary = buildPerlModule rec {
    name = "Test-Run-Plugin-ColorSummary-0.0202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "ea4fb6768c4f6645cedf87d9b7c6baf97364ebc6f4171e4dd5f68939fb2bdd3a";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ TestRun TestRunCmdLine ] ++ moreInputs;
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "A Test::Run plugin that";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunPluginTrimDisplayedFilenames = buildPerlPackage rec {
    name = "Test-Run-Plugin-TrimDisplayedFilenames-0.0125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "2255bc5cb6ab65ee4dfff3bcdf007fb74785ff3bb439a9cef5052c66d80424a5";
    };
    buildInputs = [ ModuleBuild TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ MROCompat Moose TestRun TestRunCmdLine ];
    meta = {
      homepage = http://web-cpan.shlomifish.org/modules/Test-Run/;
      description = "Trim the first components";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestRunValgrind = buildPerlModule rec {
    name = "Test-RunValgrind-0.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "67bf3cf3e7d5d23ec33e592f8b0dbcccfa01205d5bf0a3d73d8c8358d167e83f";
    };
    buildInputs = [ ModuleBuild perl ];
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Tests that an external program is valgrind-clean";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestScript = buildPerlPackage rec {
    name = "Test-Script-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "0wxbia5mmn73n5rkv857fv547kihpg3amizqllyh5flap6kbc7fn";
    };

    buildInputs = [ TestTester ];

    propagatedBuildInputs = [ ProbePerl IPCRun3 ];
  };

  TestSharedFork = buildPerlPackage rec {
    name = "Test-SharedFork-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "1yq4xzify3wqdc07zq33lwgh9gywp3qd8w6wzwrllbjw0hhkm4s8";
    };
    buildInputs = [ TestRequires ];
    meta = {
      homepage = https://github.com/tokuhirom/Test-SharedFork;
      description = "Fork test";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSimple = null;

  TestSimple13 = buildPerlPackage rec {
    name = "Test-Simple-1.302067";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/${name}.tar.gz";
      sha256 = "4d43a1ed9cd43a5ad0e6cb206c0cd86d59f118ad6895220688d7bd918016b2a3";
    };
    meta = {
      description = "Basic utilities for writing tests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestSpec = buildPerlPackage rec {
    name = "Test-Spec-0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYJONES/${name}.tar.gz";
      sha256 = "0n2pzc32q4fr1b9w292ld9gh3yn3saxib3hxrjx6jvcmy3k9jkbi";
    };
    propagatedBuildInputs = [ PackageStash TestDeep TestTrap TieIxHash ];
    meta = {
      description = "Write tests in a declarative specification style";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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

  TestSynopsis = buildPerlPackage rec {
    name = "Test-Synopsis-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZO/ZOFFIX/${name}.tar.gz";
      sha256 = "1jn3vna5r5fa9nv33n1x0bmgc434sk0ggar3jm78xx0zzy5jnsxv";
    };
    meta = {
      description = "Test your SYNOPSIS code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTableDriven = buildPerlPackage {
    name = "Test-TableDriven-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROCKWAY/Test-TableDriven-0.02.tar.gz;
      sha256 = "16l5n6sx3yqdir1rqq21d41znpwzbs8v34gqr93y051arypphn22";
    };
    meta = {
      description = "Write tests, not scripts that run them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestTCP = buildPerlPackage rec {
    name = "Test-TCP-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/${name}.tar.gz";
      sha256 = "00bxgm7qva4fd25phwl8fvv36h8h5k3jk89hz9302a288wv3ysmr";
    };
    propagatedBuildInputs = [ TestSharedFork ];
    meta = {
      description = "Testing TCP program";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTester = buildPerlPackage {
    name = "Test-Tester-0.109";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.109.tar.gz;
      sha256 = "0m9n28z09kq455r5nydj1bnr85lvmbfpcbjdkjfbpmfb5xgciiyk";
    };
  };

  TestTime = buildPerlPackage rec {
    name = "Test-Time-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SATOH/${name}.tar.gz";
      sha256 = "d8c1bc57f9767ae8122fc4ab873bd991cb9ea8e9422c66399acb66770fa5c2ea";
    };
    buildInputs = [ FileSlurp ];
    meta = {
      description = "Overrides the time() and sleep() core functions for testing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTrailingSpace = buildPerlPackage rec {
    name = "Test-TrailingSpace-0.0301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "a28875747adb7a0e7d1ae8a4ffe71869e7ceb3a85d0cb30172959dada7de5970";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ FileFindObjectRule ];
    meta = {
      description = "Test for trailing space in source files";
      license = stdenv.lib.licenses.mit;
    };
  };

  TestUnitLite = buildPerlPackage {
    name = "Test-Unit-Lite-0.1202";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz;
      sha256 = "1a5jym9hjcpdf0rwyn7gwrzsx4xqzwgzx59rgspqlqiif7p2a79m";
    };
    meta = {
      description = "Unit testing without external dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Testuseok = buildPerlPackage {
    name = "Test-use-ok-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Test-use-ok-0.11.tar.gz;
      sha256 = "8410438a2acf127bffcf1ab92205b747a615b487e80a48e8c3d0bb9fa0dbb2a8";
    };
    meta = {
      homepage = http://github.com/audreyt/Test-use-ok/tree;
      description = "Alternative to Test::More::use_ok";
      license = "unrestricted";
    };
  };

  TestWarn = buildPerlPackage {
    name = "Test-Warn-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Test-Warn-0.30.tar.gz;
      sha256 = "0haf2ii7br5z0psmkvlvmx2z2q9qz1c70gx0969r378qjidmb5w1";
    };
    propagatedBuildInputs = [ SubUplevel TreeDAGNode ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Perl extension to test methods for warnings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWarnings = buildPerlPackage rec {
    name = "Test-Warnings-0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "ae2b68b1b5616704598ce07f5118efe42dc4605834453b7b2be14e26f9cc9a08";
    };
    buildInputs = [ TestTester CPANMetaCheck ModuleMetadata ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-Warnings;
      description = "Test for warnings and the lack of them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TestWithoutModule = buildPerlPackage {
    name = "Test-Without-Module-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/Test-Without-Module-0.17.tar.gz;
      sha256 = "a691b0bf6d92dedbacfd547551021389ebc79c51937de2b914e792457da56ff7";
    };
    meta = {
      description = "Test fallback behaviour in absence of modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestWWWMechanize = buildPerlPackage {
    name = "Test-WWW-Mechanize-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.44.tar.gz;
      sha256 = "062pj242vsc73bw11jqpap92ax9wzc9f2m4xhyp1wzrwkfchpl2q";
    };
    buildInputs = [ CGI ];
    propagatedBuildInputs = [ CarpAssertMore HTMLTree HTTPServerSimple LWP TestLongString URI WWWMechanize ];
    meta = {
      homepage = https://github.com/petdance/test-www-mechanize;
      description = "Testing-specific WWW::Mechanize subclass";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestWWWMechanizeCatalyst = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-Catalyst-0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/${name}.tar.gz";
      sha256 = "0nhhfrrai3ndziz873vpa1j0vljjnib4wqafd6yyvkf58ad7v0lv";
    };
    doCheck = false; # listens on an external port
    propagatedBuildInputs = [ CatalystRuntime LWP Moose namespaceclean
      TestWWWMechanize WWWMechanize ];
    meta = {
      description = "Test::WWW::Mechanize for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanizeCGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-CGI-0.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Test-WWW-Mechanize-CGI-0.1.tar.gz;
      sha256 = "0bwwdk0iai5dlvvfpja971qpgvmf6yq67iag4z4szl9v5sra0xm5";
    };
    propagatedBuildInputs = [ CGI TestWWWMechanize WWWMechanizeCGI ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-PSGI-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Test-WWW-Mechanize-PSGI-0.35.tar.gz;
      sha256 = "1hih8s49zf38bisvhnhzrrj0zwyiivkrbs7nmmdqm1qqy27wv7pc";
    };
    buildInputs = [ TestPod CGI ];
    propagatedBuildInputs = [ Plack TestWWWMechanize TryTiny ];
    meta = {
      description = "Test PSGI programs using WWW::Mechanize";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestXPath = buildPerlModule {
    name = "Test-XPath-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-XPath-0.16.tar.gz;
      sha256 = "09s47d5jcrx35dz623gjiqn0qmjrv0wb54czr7h01wffw1w8akxi";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestYAML = buildPerlPackage rec {
    name = "Test-YAML-1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0hxrfs7p9hqkhvv5nhk2hd3kh32smwng4nz47b8xf4iw2q1n2dr7";
    };
  };

  TextAbbrev = buildPerlPackage {
    name = "Text-Abbrev-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Text-Abbrev-1.02.tar.gz;
      sha256 = "9cfb8bea2d5806b72fa1a0e1a3367ce662262eaa2701c6a3143a2a8076917433";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Text-Abbrev;
      description = "Abbrev - create an abbreviation table from a list";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextAligner = buildPerlPackage rec {
    name = "Text-Aligner-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0a6zkchc0apvzkch6z18cx6h97xfiv50r7n4xhg90x8dvk75qzcs";
    };
    meta = {
      description = "Align text in columns";
    };
  };

  TextAspell = buildPerlPackage rec {
    name = "Text-Aspell-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANK/${name}.tar.gz";
      sha256 = "0r9g31rd55934mp6n45b96g934ck4qns8x9i7qckn9wfy44k5sib";
    };
    propagatedBuildInputs = [ pkgs.aspell ];
    ASPELL_CONF = "dict-dir ${pkgs.aspellDicts.en}/lib/aspell";
    NIX_CFLAGS_COMPILE = "-I${pkgs.aspell}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.aspell}/lib -laspell";
  };

  TextAutoformat = buildPerlPackage {
    name = "Text-Autoformat-1.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.72.tar.gz;
      sha256 = "b541152699fcd0f026322f283b7d9184839742aee0edb317a014c195ea26ae51";
    };
    propagatedBuildInputs = [ TextReform ];
    meta = {
      homepage = https://github.com/neilbowers/Text-Autoformat;
      description = "Automatic text wrapping and reformatting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBalanced = buildPerlPackage {
    name = "Text-Balanced-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/Text-Balanced-2.03.tar.gz;
      sha256 = "057753f8f0568b53921f66a60a89c30092b73329bcc61a2c43339ab70c9792c8";
    };
    meta = {
      description = "Extract delimited text sequences from strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBibTeX = buildPerlModule rec {
    name = "Text-BibTeX-0.72";
    buildInputs = [ ConfigAutoConf ExtUtilsLibBuilder ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/${name}.tar.gz";
      sha256 = "0vfnj9ygdjympc8hsf38nc4a1lq45qbq7v6z6mrnfgr3k198b6gw";
    };
    meta = {
      description = "Interface to read and parse BibTeX files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBrew = buildPerlPackage rec {
    name = "Text-Brew-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCIVEY/${name}.tar.gz";
      sha256 = "0k7nxglbx5pxl693zrj1fsi094sf1a3vqsrn73inzz7r3j28a6xa";
    };
  };

  TextCharWidth = buildPerlPackage rec {
    name = "Text-CharWidth-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KUBOTA/${name}.tar.gz";
      sha256 = "abded5f4fdd9338e89fd2f1d8271c44989dae5bf50aece41b6179d8e230704f8";
    };
  };

  TextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "9c5b8fb9baffd58f02ed2b3f0b6d9a6454198f18a80e7f3a049680ddbdb24115";
    };
    meta = {
      description = "Comma-separated values manipulator (using XS or PurePerl)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TextCSVEncoded = buildPerlPackage rec {
    name = "Text-CSV-Encoded-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZA/ZARQUON/${name}.tar.gz";
      sha256 = "1l5rwlmnpnhjszb200a94lwvkwslsvyxm24ycf37gm8dla1mk2i4";
    };
    propagatedBuildInputs = [ TextCSV ];
    meta = {
      description = "Encoding aware Text::CSV";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TextCSV_XS = buildPerlPackage rec {
    name = "Text-CSV_XS-1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HM/HMBRAND/${name}.tgz";
      sha256 = "5714e1c275e7715aee44f820f8ca26c976fbb563668de7eba42a4419a05a4b5a";
    };
    meta = {
      homepage = https://metacpan.org/pod/Text::CSV_XS;
      description = "Comma-Separated Values manipulation routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextDiff = buildPerlPackage rec {
    name = "Text-Diff-1.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "1ampmj1k5cabgcaw2iqwqbmnq6hrnl96f7rk8hh22gsw6my86bac";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perform diffs on files and record sets";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextGlob = buildPerlPackage rec {
    name = "Text-Glob-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "0lr76wrsj8wcxrq4wi8z1640w4dmdbkznp06q744rg3g0bd238d5";
    };
  };

  TextIconv = buildPerlPackage {
    name = "Text-Iconv-1.7";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz;
      sha256 = "5b80b7d5e709d34393bcba88971864a17b44a5bf0f9e4bcee383d029e7d2d5c3";
    };
  };

  TestInter = buildPerlPackage {
    name = "Test-Inter-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Test-Inter-1.05.tar.gz;
      sha256 = "bda95ef503f1c1b39a5cd1ea686d18a67a63b56a8eb458f0614fc2acc51f7988";
    };
    meta = {
      description = "Framework for more readable interactive test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestManifest = buildPerlPackage {
    name = "Test-Manifest-2.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-Manifest-2.02.tar.gz;
      sha256 = "064783ceaf7dd569a5724d40900a3f9d92168ee4c613f7a3cb99a99aa8283396";
    };
    meta = {
      description = "Interact with a t/test_manifest file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMarkdown = buildPerlPackage rec {
    name = "Text-Markdown-1.000031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "06y79lla8adkqhrs41xdddqjs81dcrh266b50mfbg37bxkawd4f1";
    };
    buildInputs = [ FileSlurp ListMoreUtils Encode ExtUtilsMakeMaker
      TestException HTMLTidy TestDifferences ];
  };

  TestMagpie = buildPerlPackage {
    name = "Test-Magpie-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Test-Magpie-0.05.tar.gz;
      sha256 = "0a0c6vcj92spy6ngfdqn9yfym37jwxlds7hlw6xphkdmcklynh0b";
    };
    propagatedBuildInputs = [ aliased DevelPartialDump ListAllUtils Moose MooseXParamsValidate MooseXTypes MooseXTypesStructured namespaceautoclean SetObject SubExporter TestFatal ];
    meta = {
      description = "Spy on objects to achieve test doubles (mock testing)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestMinimumVersion = buildPerlPackage rec {
    name = "Test-MinimumVersion-0.101082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "3fba4e8fcf74806259aa639be7d90e70346ad0e0e4b8b619593490e378241970";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl PerlMinimumVersion ];
    meta = {
      homepage = https://github.com/rjbs/Test-MinimumVersion;
      description = "Does your code require newer perl than you think?";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMicroTemplate = buildPerlPackage {
    name = "Text-MicroTemplate-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Text-MicroTemplate-0.20.tar.gz;
      sha256 = "0da44kd3z4n23wivy99583cscmiay2xv0wq9dzx6mg8vq874kx74";
    };
    meta = {
      description = "Micro template engine with Perl5 language";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestNumberDelta = buildPerlPackage {
    name = "Test-Number-Delta-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz;
      sha256 = "535430919e6fdf6ce55ff76e9892afccba3b7d4160db45f3ac43b0f92ffcd049";
    };
    meta = {
      homepage = https://github.com/dagolden/Test-Number-Delta;
      description = "Compare the difference between numbers against a given tolerance";
      license = "apache";
    };
  };

  TextPasswordPronounceable = buildPerlPackage {
    name = "Text-Password-Pronounceable-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TS/TSIBLEY/Text-Password-Pronounceable-0.30.tar.gz;
      sha256 = "c186a50256e0bedfafb17e7ce157e7c52f19503bb79e18ebf06255911f6ead1a";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextPDF = buildPerlPackage rec {
    name = "Text-PDF-0.29a";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHOSKEN/${name}.tar.gz";
      sha256 = "11jig38vps957zyc9372q2g0jcabxgkql3b5vazc1if1ajhlvc4s";
    };
    propagatedBuildInputs = [ CompressZlib ];
  };

  TextQuoted = buildPerlPackage {
    name = "Text-Quoted-2.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Text-Quoted-2.09.tar.gz;
      sha256 = "446c3e8da7e65f7988cd36e9da1159614eb0b337d6c4c0dec8f6df7673b96c5f";
    };
    propagatedBuildInputs = [ TextAutoformat ];
    meta = {
      description = "Extract the structure of a quoted mail message";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRecordParser = buildPerlPackage rec {
    name = "Text-RecordParser-1.6.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCLARK/${name}.tar.gz";
      sha256 = "0nn33c058bl957v38xhqig4ld34lifl4arqiilhxky339i0q2fys";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ TestException IOStringy ClassAccessor Readonly
      ListMoreUtils TestPod TestPodCoverage GraphViz ReadonlyXS
      TextTabularDisplay];
  };

  TextReform = buildPerlPackage {
    name = "Text-Reform-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Text-Reform-1.20.tar.gz;
      sha256 = "a8792dd8c1aac97001032337b36a356be96e2d74c4f039ef9a363b641db4ae61";
    };
    meta = {
      description = "Manual text wrapping and reformatting";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRoman = buildPerlPackage rec {
    name = "Text-Roman-3.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EC/ECALDER/${name}.tar.gz";
      sha256 = "1ris38kdj15l8l7cl5whdpyyvb0rz8dh9p0w36wgydi3b2pxsa25";
    };
    meta = {
      description = "Allows conversion between Roman and Arabic algarisms";
      license = stdenv.lib.licenses.bsd3;
    };
  };

  TextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Text-SimpleTable-2.03.tar.gz;
      sha256 = "15hpry9jwrf1vbjyk21s65rllxrdvp2fdzzv9gsvczggby2yyzfs";
    };
    meta = {
      description = "Simple eyecandy ASCII tables";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextSoundex = buildPerlPackage {
    name = "Text-Soundex-3.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Text-Soundex-3.04.tar.gz;
      sha256 = "2e56bb4324ee0186b908b3bd78463643affe7295624af0628e81491e910283d9";
    };
    propagatedBuildInputs = [ if_ ];
  };

  TextSprintfNamed = buildPerlPackage rec {
    name = "Text-Sprintf-Named-0.0402";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "951317fce8fa5dd08190ba760182bc71f2b4346fa21df55c76155e6353e2864f";
    };
    buildInputs = [ ModuleBuild TestWarn ];
    meta = {
      description = "Sprintf-like function with named conversions";
      license = stdenv.lib.licenses.mit;
    };
  };

  TextTable = buildPerlPackage rec {
    name = "Text-Table-1.130";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "02c8v38k639r23dgxwgvsy4myjjzvgdb238kpiffsiz25ab3xp5j";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/docmake/;
      description = "Organize Data in Tables";
      license = stdenv.lib.licenses.isc;
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TextTabsWrap = buildPerlPackage {
    name = "Text-Tabs+Wrap-2013.0523";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MU/MUIR/modules/Text-Tabs+Wrap-2013.0523.tar.gz;
      sha256 = "b9cb056fffb737b9c12862099b952bf4ab4b1f599fd34935356ae57dab6f655f";
    };
    meta = {
      description = "Expand tabs and do simple line wrapping";
    };
  };

  TextTabularDisplay = buildPerlPackage rec {
    name = "Text-TabularDisplay-1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "1s46s4pg5mpfllx3icf4vnqz9iadbbdbsr5p7pr6gdjnzbx902gb";
    };
    propagatedBuildInputs = [ TextAligner ];
  };

  TextTemplate = buildPerlPackage {
    name = "Text-Template-1.46";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz;
      sha256 = "77d812cb86e48091bcd59aa8522ef887b33a0ff758f8a269da8c2b733889d580";
    };
    meta = {
      description = "Unknown";
      license = "unknown";
    };
  };

  TestTrap = buildPerlPackage rec {
    name = "Test-Trap-0.3.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EB/EBHANSSEN/${name}.tar.gz";
      sha256 = "1ci5ag9pm850ww55n2929skvw3avy6xcrwmmi2yyn0hifxx9dybs";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ DataDump ];
    meta = {
      description = "Trap exit codes, exceptions, output, etc";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVars = buildPerlModule rec {
    name = "Test-Vars-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1h0kifiia78s3425hvpjs5di5539vsz15mmkkk0cwshwizhcwp7h";
    };

    buildInputs = [ TestTester ];

    meta = {
      homepage = https://github.com/gfx/p5-Test-Vars;
      description = "Detects unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVersion = buildPerlPackage rec {
    name = "Test-Version-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "39c0ec02663da0e56962bdafaef6790cf83d12b4d90e8a4cdc971d57d869d63f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ FileFindRulePerl ];
    meta = {
      homepage = https://metacpan.org/dist/Test-Version;
      description = "Check to see that version's in modules are sane";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextTrim = buildPerlPackage {
    name = "Text-Trim-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Text-Trim-1.02.tar.gz;
      sha256 = "1bnwjl5n04w8nnrzrm75ljn4pijqbijr9csfkjcs79h4gwn9lwqw";
    };
    propagatedBuildInputs = [ CGI ModuleBuild ];
    meta = {
      description = "Remove leading and/or trailing whitespace from strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnaccent = buildPerlPackage {
    name = "Text-Unaccent-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDACHARY/Text-Unaccent-1.08.tar.gz;
      sha256 = "0avk50kia78kxryh2whmaj5l18q2wvmkdyqyjsf6kwr4kgy6x3i7";
    };
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnidecode = buildPerlPackage rec {
    name = "Text-Unidecode-1.24";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "124q1zfiyj70zz691nrfjfmv4i8dyalddhqisp8y28kzfnba9vrh";
    };
  };

  Testutf8 = buildPerlPackage {
    name = "Test-utf8-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.01.tar.gz;
      sha256 = "ef371b1769cd8d36d2d657e8321723d94c8f8d89e7fd7437c6648c5dc6711b7a";
    };
    meta = {
      homepage = https://github.com/2shortplanks/Test-utf8/tree;
      description = "Handy utf8 tests";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextvFileasData = buildPerlPackage rec {
    name = "Text-vFile-asData-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "b291ab5e0f987c5172560a692234711a75e4596d83475f72d01278369532f82a";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    meta = {
      description = "Parse vFile formatted files into data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWikiFormat = buildPerlPackage {
    name = "Text-WikiFormat-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Text-WikiFormat-0.81.tar.gz;
      sha256 = "0cxbgx879bsskmnhjzamgsa5862ddixyx4yr77lafmwimnaxjg74";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextWrapI18N = buildPerlPackage {
    name = "Text-WrapI18N-0.06";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz;
      sha256 = "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488";
    };
    propagatedBuildInputs = [ pkgs.glibc TextCharWidth ];
    preConfigure = ''
      substituteInPlace WrapI18N.pm --replace '/usr/bin/locale' '${pkgs.glibc.bin}/bin/locale'
    '';
    meta = {
      description = "Line wrapping module with support for multibyte, fullwidth, and combining characters and languages without whitespaces between words";
      license = with stdenv.lib.licenses; [ artistic1 gpl2 ];
    };
  };

  TextWrapper = buildPerlPackage {
    name = "Text-Wrapper-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/Text-Wrapper-1.05.tar.gz;
      sha256 = "64268e15983a9df47e1d9199a491f394e89f542e54afb33f4b78f3f318e09ab9";
    };
    meta = {
      description = "Word wrap text by breaking long lines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  threads = buildPerlPackage rec {
    name = "threads-2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "0fgprp2ghrh1ryxmr0y9bpsjl1ifbf4lqml8k017cbl4zbn21lim";
    };
    meta = {
      description = "Perl interpreter-based threads";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  threadsshared = buildPerlPackage rec {
    name = "threads-shared-1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "0qsbl8rx8p09cb5vj1yhwf1h2awvimfyckw1qwrqbk7dxjldrimn";
    };
    meta = {
      description = "Perl extension for sharing data structures between threads";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ThreadQueue = buildPerlPackage rec {
    name = "Thread-Queue-3.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/${name}.tar.gz";
      sha256 = "0f03v10rsasi2j4lh8xw44jac8nfbw66274qgsz5lsmfd6wqvj12";
    };
    meta = {
      description = "Thread-safe queues";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ThreadSemaphore = buildPerlPackage {
    name = "Thread-Semaphore-2.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Thread-Semaphore-2.12.tar.gz;
      sha256 = "e0f8e7057b073003e5a96a55b778abb8ee1cc1b279febedce0166526f2988965";
    };
    meta = {
      description = "Thread-safe semaphores";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Throwable = buildPerlPackage rec {
    name = "Throwable-0.200013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "184gdcwxqwnkrx5md968v1ny70pq6blzpkihccm3bpdxnpgd11wr";
    };
    buildInputs = [ DevelStackTrace ];
    propagatedBuildInputs = [ DevelStackTrace ModuleRuntime Moo ];
    meta = {
      homepage = https://github.com/rjbs/Throwable;
      description = "A role for classes that can be thrown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  TieCacheLRU = buildPerlPackage rec {
    name = "Tie-Cache-LRU-20150301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1bf740450d3a6d7c12b48c25f7da5964e44e7cc38b28572cfb76ff22464f4469";
    };
    propagatedBuildInputs = [ CarpAssert ClassDataInheritable ClassVirtual enum ];
    meta = {
      description = "A Least-Recently Used cache";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieCacheLRUExpires = buildPerlPackage rec {
    name = "Tie-Cache-LRU-Expires-0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/${name}.tar.gz";
      sha256 = "b316d849acd25f24346d55a9950d281fee0746398767c601234122159573eb9a";
    };
    propagatedBuildInputs = [ TieCacheLRU ];
    meta = {
      license = stdenv.lib.licenses.artistic1;
    };
  };

  TieCycle = buildPerlPackage rec {
    name = "Tie-Cycle-1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "0r1mdmd01s42vwlwr2mvr1ywjvvfkc79vz6ysdii5fvcgs6wk50y";
    };
    meta = {
      description = "Cycle through a list of values via a scalar";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieFile = buildPerlPackage {
    name = "Tie-File-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Tie-File-1.00.tar.gz;
      sha256 = "7ca9c8a957cf743d3a98d0eb5deb767b1e14b4f00bc9d03da83d466fcb76bd44";
    };
    meta = {
      description = "Access the lines of a disk file via a Perl array";
    };
  };

  TieIxHash = buildPerlPackage {
    name = "Tie-IxHash-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz;
      sha256 = "0mmg9iyh42syal3z1p2pn9airq65yrkfs66cnqs9nz76jy60pfzs";
    };
    meta = {
      description = "Ordered associative arrays for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieHashIndexed = buildPerlPackage {
    name = "Tie-Hash-Indexed-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/Tie-Hash-Indexed-0.05.tar.gz;
      sha256 = "a8862a4763d58a8c785e34b8b18e5db4ce5c3e36b9b5cf565a3088584eab361e";
    };
    meta = {
      description = "Ordered hashes for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieRefHash = buildPerlPackage {
    name = "Tie-RefHash-1.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Tie-RefHash-1.39.tar.gz;
      sha256 = "b0b80ef571e7dadb726b8214f7352a932a8fa82af29072895aa1aadc89f48bec";
    };
  };

  TieRegexpHash = buildPerlPackage rec {
    name = "Tie-RegexpHash-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALTREUS/${name}.tar.gz";
      sha256 = "0c207850e77efb16618e0aa015507926a3425b34aad5aa6e3e40d83989a085a3";
    };
    meta = {
      license = stdenv.lib.licenses.artistic1;
    };
  };

  TieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
    propagatedBuildInputs = [Testuseok];
  };

  TimeDate = buildPerlPackage {
    name = "TimeDate-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-2.30.tar.gz;
      sha256 = "11lf54akr9nbivqkjrhvkmfdgkbhw85sq0q4mak56n6bf542bgbm";
    };
  };

  TimeDuration = buildPerlPackage rec {
    name = "Time-Duration-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "1f5vkid4pl5iq3hal01hk1zjbbzrqpx4m1djawbp93l152shb0j5";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Rounded or exact English expression of durations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDurationParse = buildPerlPackage rec {
    name = "Time-Duration-Parse-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "0yxfxw7fxs19nncpv54nqh21ak2cmvpz7ks8d9v4lz3mbq6q0q9s";
    };
    buildInputs = [ TimeDuration ];
    propagatedBuildInputs = [ ExporterLite ];
    meta = {
      description = "Parse string that represents time duration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeHiRes = buildPerlPackage rec {
    name = "Time-HiRes-1.9726";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "17hhd53p72z08l1riwz5f6rch6hngby1pympkla5miznn7cjlrpz";
    };
  };

  TimeLocal = buildPerlPackage {
    name = "Time-Local-1.2300";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Time-Local-1.2300.tar.gz;
      sha256 = "b2acca03700a09f8ae737d3084f3f6287e983da9ab7b537c6599c291b669fb49";
    };
    meta = {
      description = "Efficiently compute time from local and GMT time";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeParseDate = buildPerlPackage {
    name = "Time-ParseDate-2015.103";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MU/MUIR/modules/Time-ParseDate-2015.103.tar.gz;
      sha256 = "2c1a06235bf811813caac9eaa9daa71af758667cdf7b082cb59863220fcaeed1";
    };
    doCheck = false;
    meta = {
      description = "Parse and format time values";
      license = "unknown";
    };
  };

  Tk = buildPerlPackage rec {
    name = "Tk-804.033";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/${name}.tar.gz";
      sha256 = "84756e9b07a2555c8eecf88e63d5cbbba9b1aa97b1e71a3d4aa524a7995a88ad";
    };
    makeMakerFlags = "X11INC=${pkgs.xorg.libX11.dev}/include X11LIB=${pkgs.xorg.libX11.out}/lib";
    buildInputs = with pkgs; [ xorg.libX11 libpng ];
    doCheck = false;            # Expects working X11.
    meta = {
      homepage = https://metacpan.org/pod/distribution/Tk/Tk.pod;
      license = stdenv.lib.licenses.tcltk;
    };
  };

  TreeDAGNode = buildPerlPackage rec {
    name = "Tree-DAG_Node-1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "1i2i445gh7720bvv06dz67szk2z6q1pi30kb5p2shsa806sj4vr2";
    };
    buildInputs = [ TestPod FileSlurpTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "An N-ary tree";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimple = buildPerlPackage rec {
    name = "Tree-Simple-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "1xj1n70v4qbx7m9k01bj9aixk77yssliavgvfds3xj755hcan0nr";
    };
    buildInputs = [ TestException TestMemoryCycle ];
    meta = {
      description = "A simple tree object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-VisitorFactory-0.12.tgz;
      sha256 = "1g27xl48q1vr7aikhxg4vvcsj1si8allxz59vmnks61wsw4by7vg";
    };
    propagatedBuildInputs = [TreeSimple];
    buildInputs = [TestException];
  };

  TryTiny = buildPerlPackage {
    name = "Try-Tiny-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Try-Tiny-0.22.tar.gz;
      sha256 = "60fba46f4693d33d54539104f9001df008dabb400b6837e9605c39a6ee6a1b19";
    };
    buildInputs = [ if_ ];
    meta = {
      homepage = http://metacpan.org/release/Try-Tiny;
      description = "Minimal try/catch with proper preservation of $@";
      license = stdenv.lib.licenses.mit;
    };
  };

  TypeTiny = buildPerlPackage {
    name = "Type-Tiny-1.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-1.000005.tar.gz;
      sha256 = "42ed36c011825aa1e6995a4e8638621a1b2103a0970b15764ca3919368042365";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    meta = {
      homepage = https://metacpan.org/release/Type-Tiny;
      description = "Tiny, yet Moo(se)-compatible type constraint";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.20140328";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz;
      sha256 = "522da9f274786fe2cba99bc77cc1c81d2161947903d7fad10bd62dfb7f11990f";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-can;
      description = "Work around buggy code calling UNIVERSAL::can() as a function";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/UNIVERSAL-require-0.17.tar.gz;
      sha256 = "5dc9f13f2d2bbdf852387e2a63c0753728c2bea9125dd628c313db3ef66ec4c3";
    };
    meta = {
      description = "Require() modules from a variable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCaseFold = buildPerlModule rec {
    name = "Unicode-CaseFold-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/${name}.tar.gz";
      sha256 = "c489b5a440e84b0554e866d3fe4077fa1956eeed473e203588e0c24acce1f016";
    };
    meta = {
      homepage = http://metacpan.org/release/Unicode-CaseFold;
      description = "Unicode case-folding for case-insensitive lookups";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ stdenv.lib.maintainers.rycee ];
    };
  };

  UnicodeCheckUTF8 = buildPerlPackage {
    name = "Unicode-CheckUTF8-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRADFITZ/Unicode-CheckUTF8-1.03.tar.gz;
      sha256 = "97f84daf033eb9b49cd8fe31db221fef035a5c2ee1d757f3122c88cf9762414c";
    };
    meta = {
      license = "unknown";
    };
  };

  UnicodeCollate = buildPerlPackage rec {
    name = "Unicode-Collate-1.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SADAHIRO/${name}.tar.gz";
      sha256 = "0ykncvhnwy8ync01ibv0524m0si9ya1ch2v8vx61s778nnrmp2k2";
    };
    meta = {
      description = "Unicode Collation Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeICUCollator = buildPerlPackage {
    name = "Unicode-ICU-Collator-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TONYC/Unicode-ICU-Collator-0.002.tar.gz;
      sha256 = "0gimwydam0mdgm6qjzzxny4gw8zda9kc2843kcl2xrpq7z7ww3f9";
    };
    meta = {
      description = "Wrapper around ICU collation services";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
      broken = true; # tests fail http://hydra.nixos.org/build/25141764/nixlog/1/raw
    };
    buildInputs = [ pkgs.icu ];
  };

  UnicodeLineBreak = buildPerlPackage rec {
    name = "Unicode-LineBreak-2015.07.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/${name}.tar.gz";
      sha256 = "0fycsfc3jhnalad7zvx47f13dpxihdh9c8fy8w7psjlyd5svs6sb";
    };
    propagatedBuildInputs = [ MIMECharset ];
    meta = {
      description = "UAX #14 Unicode Line Breaking Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeNormalize = buildPerlPackage rec {
    name = "Unicode-Normalize-1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KH/KHW/${name}.tar.gz";
      sha256 = "00b33a75d3b356ade2e09391ea2d32fac881671c18b1eb26b9ca31273d5b046c";
    };
    meta = {
      description = "Unicode Normalization Forms";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeString = buildPerlPackage rec {
    name = "Unicode-String-2.09";
    patches = [
      ../development/perl-modules/Unicode-String-perl-5-22.patch
    ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1bgsaf3dgmlgyvi84r42ysc037mr5280amnypa4d98jfjpdvw5y8";
    };
  };

  UnixGetrusage = buildPerlPackage {
    name = "Unix-Getrusage-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TA/TAFFY/Unix-Getrusage-0.03.tar.gz;
      sha256 = "76cde1cee2453260b85abbddc27cdc9875f01d2457e176e03dcabf05fb444d12";
    };
  };

  URI = buildPerlPackage rec {
    name = "URI-1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "9c8eca0d7f39e74bbc14706293e653b699238eeb1a7690cc9c136fb8c2644115";
    };
    meta = {
      description = "Uniform Resource Identifiers (absolute and relative)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  URIdb = buildPerlModule {
    name = "URI-db-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-db-0.15.tar.gz;
      sha256 = "ac3dc3eeb8ca58dc4f7e1dfed6bca5bb8ebbc5dfacee63161490b09a4bfac982";
    };
    propagatedBuildInputs = [ URI URINested ];
    meta = {
      homepage = https://search.cpan.org/dist/URI-db/;
      description = "Database URIs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFind = buildPerlModule rec {
    name = "URI-Find-20140709";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "0czc4h182s7sx3k123m7qlg7yybnwxgh369hap3c3b6xgrglrhy0";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = http://search.cpan.org/dist/URI-Find;
      description = "Find URIs in arbitrary text";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFromHash = buildPerlPackage {
    name = "URI-FromHash-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.04.tar.gz;
      sha256 = "03yckli4fj8cgsyh1l1lmyxj56q9qc04a3r8kv0whbnb37zz1j23";
    };
    propagatedBuildInputs = [ ParamsValidate URI ];
    meta = {
      description = "Build a URI from a set of named parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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

  URIIMAP = buildPerlPackage {
    name = "URI-imap-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWEST/URI-imap-1.01.tar.gz;
      sha256 = "0bdv6mrdijcq46r3lmz801rscs63f8p9qqliy2safd6fds4rj55v";
    };
    propagatedBuildInputs = [URI];
  };

  URINested = buildPerlModule {
    name = "URI-Nested-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-Nested-0.10.tar.gz;
      sha256 = "e1971339a65fbac63ab87142d4b59d3d259d51417753c77cb58ea31a8233efaf";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://metacpan.org/release/URI-Nested/;
      description = "Nested URIs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIws = buildPerlPackage rec {
    name = "URI-ws-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/${name}.tar.gz";
      sha256 = "6e6b0e4172acb6a53c222639c000608c2dd61d50848647482ac8600d50e541ef";
    };
    buildInputs = [ URI ];
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = http://perl.wdlabs.com/URI-ws/;
      description = "WebSocket support for URI package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UUIDTiny = buildPerlPackage rec {
    name = "UUID-Tiny-1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAUGUSTIN/${name}.tar.gz";
      sha256 = "6dcd92604d64e96cc6c188194ae16a9d3a46556224f77b6f3d1d1312b68f9a3d";
    };
    meta = {
      description = "Pure Perl UUID Support With Functional Interface";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  VariableMagic = buildPerlPackage rec {
    name = "Variable-Magic-0.58";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Variable/${name}.tar.gz";
      sha256 = "1yhh3zbawx68sw93xrnvfnqq5pb2pmbk20rckqxbwkq1n8c6lv83";
    };
  };

  version = buildPerlPackage rec {
    name = "version-0.9912";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPEACOCK/${name}.tar.gz";
      sha256 = "03hv7slgqrmzbbjjmxgvq91bjlbjg5xbp8n4h454amyab2adzw7b";
    };
  };

  VMEC2 = buildPerlModule rec {
    name = "VM-EC2-1.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "b2b6b31745c57431fca0efb9b9d0b8f168d6081755e048fd9d6c4469bd108acd";
    };
    buildInputs = [ ModuleBuild ];
    propagatedBuildInputs = [ AnyEvent AnyEventCacheDNS AnyEventHTTP JSON LWP StringApprox URI XMLSimple ];
    meta = {
      description = "Perl interface to Amazon EC2, Virtual Private Cloud, Elastic Load Balancing, Autoscaling, and Relational Database services";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  VMEC2SecurityCredentialCache = buildPerlPackage rec {
    name = "VM-EC2-Security-CredentialCache-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCONOVER/${name}.tar.gz";
      sha256 = "fc7e9c152ff2b721ccb221ac40089934775cf58366aedb5cc1693609f840937b";
    };
    propagatedBuildInputs = [ DateTimeFormatISO8601 VMEC2 ];
    meta = {
      homepage = http://search.cpan.org/dist/VM-EC2-Security-CredentialCache/;
      description = "Cache credentials respecting expiration time for IAM roles";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  W3CLinkChecker = buildPerlPackage rec {
    name = "W3C-LinkChecker-4.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/${name}.tar.gz";
      sha256 = "6239f61b20d91dce7b21e4d4f626ab93a8f1e2f207da5015590d508cf6c66a65";
    };
    outputs = [ "out" ];
    propagatedBuildInputs = [ CGI CSSDOM ConfigGeneral CryptSSLeay EncodeLocale HTMLParser HTTPCookies HTTPMessage LWP LWPProtocolHttps NetHTTP NetIP TermReadKey URI ];
    meta = {
      homepage = http://validator.w3.org/checklink;
      description = "A tool to check links and anchors in Web pages or full Web sites";
      license = stdenv.lib.licenses.w3c;
    };
  };

  WWWCurl = buildPerlPackage rec {
    name = "WWW-Curl-4.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZBALINT/${name}.tar.gz";
      sha256 = "1fmp9aib1kaps9vhs4dwxn7b15kgnlz9f714bxvqsd1j1q8spzsj";
    };
    patches = [ ../development/perl-modules/WWW-Curl-4.17-Skip-preprocessor-symbol-only-CURL_STRICTER.patch ];
    buildInputs = [ pkgs.curl ];
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '"cpp"' '"gcc -E"'
        substituteInPlace Makefile.PL --replace '_LASTENTRY\z' '_LASTENTRY\z|CURL_DID_MEMORY_FUNC_TYPEDEFS\z'
      '';
    NIX_CFLAGS_COMPILE = "-DCURL_STRICTER";
    doCheck = false; # performs network access
  };

  WWWMechanize = buildPerlPackage {
    name = "WWW-Mechanize-1.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/WWW-Mechanize-1.73.tar.gz;
      sha256 = "1zrw8aadhwy48q51x2z2rqlkwf17bya4j4h3hy89mw783j96rmg9";
    };
    propagatedBuildInputs = [ HTMLForm HTMLParser HTMLTree HTTPDaemon HTTPMessage HTTPServerSimple LWP LWPUserAgent TestWarn URI ];
    doCheck = false;
    meta = {
      homepage = https://github.com/bestpractical/www-mechanize;
      description = "Handy web browsing in a Perl object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWMechanizeCGI = buildPerlPackage {
    name = "WWW-Mechanize-CGI-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/WWW-Mechanize-CGI-0.3.tar.gz;
      sha256 = "046jm18liq7rwkdawdh9520cnalkfrk26yqryp7xgw71y65lvq61";
    };
    propagatedBuildInputs = [ HTTPRequestAsCGI WWWMechanize ];
    preConfigure = ''
      substituteInPlace t/cgi-bin/script.cgi \
        --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    '';
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
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
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Want = buildPerlPackage rec {
    name = "Want-0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/${name}.tar.gz";
      sha256 = "1xsjylbxxcbkjazqms49ipi94j1hd2ykdikk29cq7dscil5p9r5l";
    };
  };

  Workflow = buildPerlPackage rec {
    name = "Workflow-1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JONASBN/${name}.tar.gz";
      sha256 = "0d93wc9cgw862x9x5zmbx6l6326dhq8py25yqpw7nqym6yphisnc";
    };
    buildInputs = [ DBDMock ListMoreUtils TestException ];
    propagatedBuildInputs = [ ClassAccessor ClassFactory ClassObservable DBI
      DateTime DateTimeFormatStrptime ExceptionClass FileSlurp LogDispatch
      Log4Perl XMLSimple DataUUID ];
    meta = {
      homepage = https://github.com/jonasbn/perl-workflow;
      description = "Simple, flexible system to implement workflows";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Wx = buildPerlPackage rec {
    name = "Wx-0.9927";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "1fr23nn5cvzydl8nxfv0iljn10pvwbny0nvpjx31fn2md8dvsx51";
    };
    propagatedBuildInputs = [ ExtUtilsXSpp AlienWxWidgets ];
    # Testing requires an X server:
    #   Error: Unable to initialize GTK+, is DISPLAY set properly?"
    doCheck = false;
  };

  WxGLCanvas = buildPerlPackage rec {
    name = "Wx-GLCanvas-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/${name}.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ Wx OpenGL pkgs.mesa_glu ];
    doCheck = false;
  };

  X11IdleTime = buildPerlPackage rec {
    name = "X11-IdleTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWENDT/${name}.tar.gz";
      sha256 = "0j27cb9yy9ymni8cbiyxplbg086b8lv6b330nwqyx0briq3xrzfq";
    };
    buildInputs = [ pkgs.xorg.libXext pkgs.xorg.libXScrnSaver pkgs.xorg.libX11 ];
    propagatedBuildInputs = [ InlineC ];
    patchPhase = ''sed -ie 's,-L/usr/X11R6/lib/,-L${pkgs.xorg.libX11.out}/lib/ -L${pkgs.xorg.libXext.out}/lib/ -L${pkgs.xorg.libXScrnSaver}/lib/,' IdleTime.pm'';
    meta = {
      description = "Get the idle time of X11";
    };
  };

  X11Protocol = buildPerlPackage rec {
    name = "X11-Protocol-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMCCAM/${name}.tar.gz";
      sha256 = "1dq89bh6fqv7l5mbffqcismcljpq5f869bx7g8lg698zgindv5ny";
    };
    buildInputs = [pkgs.xlibsWrapper];
    NIX_CFLAGS_LINK = "-lX11";
    doCheck = false; # requires an X server
  };

  X11GUITest = buildPerlPackage rec {
    name = "X11-GUITest-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/${name}.tar.gz";
      sha256 = "0jznws68skdzkhgkgcgjlj40qdyh9i75r7fw8bqzy406f19xxvnw";
    };
    buildInputs = [pkgs.xlibsWrapper pkgs.xorg.libXtst pkgs.xorg.libXi];
    NIX_CFLAGS_LINK = "-lX11 -lXext -lXtst";
    doCheck = false; # requires an X server
  };

  X11XCB = buildPerlPackage rec {
    name = "X11-XCB-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "14mnvr1001py2z1n43l18yaw0plwvjg5pcsyc7k81sa0amw8ahzw";
    };
    AUTOMATED_TESTING = false;
    buildInputs = [
      ExtUtilsDepends ExtUtilsPkgConfig DataDump
      XMLSimple XMLDescent TestDeep TestException
      pkgs.xorg.libxcb pkgs.xorg.xcbproto pkgs.xorg.xcbutil pkgs.xorg.xcbutilwm
    ];
    propagatedBuildInputs = [ XSObjectMagic Mouse MouseXNativeTraits TryTiny ];
    NIX_CFLAGS_LINK = [ "-lxcb" "-lxcb-util" "-lxcb-xinerama" "-lxcb-icccm" ];
    doCheck = false; # requires an X server
    meta = {
      description = "XCB bindings for X";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDescent = buildPerlPackage rec {
    name = "XML-Descent-1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "0l5xmw2hd95ypppz3lyvp4sn02ccsikzjwacli3ydxfdz1bbh4d7";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ XMLTokeParser ];
    meta = {
      description = "Recursive descent XML parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDOM = buildPerlPackage rec {
    name = "XML-DOM-1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJMATHER/${name}.tar.gz";
      sha256 = "1jvqfi0jm8wh80rd5h9c3k72car8l7x1jywj8rck8w6rm1mlxldy";
    };
    propagatedBuildInputs = [XMLRegExp XMLParser LWP libxml_perl];
  };

  XMLFilterBufferText = buildPerlPackage {
    name = "XML-Filter-BufferText-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz;
      sha256 = "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c";
    };
    doCheck = false;
  };

  XMLFilterXInclude = buildPerlPackage {
    name = "XML-Filter-XInclude-1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Filter-XInclude-1.0.tar.gz;
      sha256 = "98746f3c1f6f049491fec203d455bb8f8c9c6e250f041904dda5d78e21187f93";
    };
    doCheck = false;
  };

  XMLGrove = buildPerlPackage rec {
    name = "XML-Grove-0.46alpha";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "05yis1ms7cgwjh57k57whrmalb3ha0bjr9hyvh7cnadcyiynvdpw";
    };
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ libxml_perl ];

    #patch from https://bugzilla.redhat.com/show_bug.cgi?id=226285
    patches = [ ../development/perl-modules/xml-grove-utf8.patch ];
    meta = {
      description = "Perl-style XML objects";
    };
  };

  XMLHandlerYAWriter = buildPerlPackage rec {
    name = "XML-Handler-YAWriter-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRAEHE/${name}.tar.gz";
      sha256 = "11d45a1sz862va9rry3p2m77pwvq3kpsvgwhc5ramh9mbszbnk77";
    };
    propagatedBuildInputs = [ libxml_perl ];
    meta = {
      description = "Yet another Perl SAX XML Writer";
    };
  };

  XMLLibXML = buildPerlPackage rec {
    name = "XML-LibXML-2.0122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0llgkgifcw7zz7r7f2jiqryi5axymmd3fwzp4aa5gk6j37w66xkn";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ XMLSAX ];
  };

  XMLLibXMLSimple = buildPerlPackage {
    name = "XML-LibXML-Simple-0.93";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-0.93.tar.gz;
      sha256 = "f2eb1c1523d6414cf2a646a289b0325b489954382c862928d165a03a7cce767c";
    };
    propagatedBuildInputs = [ FileSlurp XMLLibXML ];
    meta = {
      description = "XML::LibXML based XML::Simple clone";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLLibXSLT = buildPerlPackage rec {
    name = "XML-LibXSLT-1.89";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0py7ll5vj2k977l4r2g8bbz0hdy0hhkdq0mzblrwizify0825b12";
    };
    buildInputs = [ pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
  };

  XMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.11.tar.gz;
      sha256 = "1sklgcldl3w6gn706vx1cgz6pm4y5lfgsjxnfqyk20pilgq530bd";
    };
  };

  XMLParser = buildPerlPackage {
    name = "XML-Parser-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/XML-Parser-2.41.tar.gz;
      sha256 = "1sadi505g5qmxr36lgcbrcrqh3a5gcdg32b405gnr8k54b6rg0dl";
    };
    patchPhase = if stdenv.isCygwin then ''
      sed -i"" -e "s@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. \$Config{_exe};@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. (\$^O eq 'cygwin' ? \"\" : \$Config{_exe});@" inc/Devel/CheckLib.pm
    '' else null;
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat.out}/lib EXPATINCPATH=${pkgs.expat.dev}/include";
  };

  XMLXPath = buildPerlPackage rec {
    name = "XML-XPath-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/${name}.tar.gz";
      sha256 = "b8ae1196184f794528a9727988dce944ecec7155e6ee1c433b17e12737a22725";
    };
    buildInputs = [ PathTiny ];
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Modules for parsing and evaluating XPath statements";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  XMLXPathEngine = buildPerlPackage {
    name = "XML-XPathEngine-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-XPathEngine-0.14.tar.gz;
      sha256 = "0r72na14bmsxfd16s9nlza155amqww0k8wsa9x2a3sqbpp5ppznj";
    };
    meta = {
      description = "A re-usable XPath engine for DOM-like trees";
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz;
      sha256 = "0m7wj00a2kik7wj0azhs1zagwazqh3hlz4255n75q21nc04r06fz";
    };
  };

  XMLRSS = buildPerlPackage {
    name = "XML-RSS-1.57";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/XML-RSS-1.57.tar.gz;
      sha256 = "c540a1aa7445bf611635537015590575c90c2b07c19529537677a4bcf3a4e6ae";
    };
    buildInputs = [ TestManifest ];
    propagatedBuildInputs = [ DateTime DateTimeFormatMail DateTimeFormatW3CDTF HTMLParser XMLParser ];
    meta = {
      homepage = http://perl-rss.sourceforge.net/;
      description = "Creates and updates RSS files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAX = buildPerlPackage {
    name = "XML-SAX-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-0.96.tar.gz;
      sha256 = "024fbjgg6s87j0y3yik55plzf7d6qpn7slwd03glcb54mw9zdglv";
    };
    propagatedBuildInputs = [XMLNamespaceSupport];
    postInstall = ''
      perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
      '';
  };

  XMLSAXBase = buildPerlPackage {
    name = "XML-SAX-Base-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.08.tar.gz;
      sha256 = "666270318b15f88b8427e585198abbc19bc2e6ccb36dc4c0a4f2d9807330219e";
    };
    meta = {
      description = "Base class for SAX Drivers and Filters";
      homepage = http://github.com/grantm/XML-SAX-Base;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAXWriter = buildPerlPackage {
    name = "XML-SAX-Writer-0.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.56.tar.gz;
      sha256 = "d073f7a25072c8150317b86b99d07031316a15bffab99e63e5afe591c8217d03";
    };
    propagatedBuildInputs = [ XMLFilterBufferText XMLNamespaceSupport XMLSAXBase ];
    meta = {
      homepage = https://github.com/perigrin/xml-sax-writer;
      description = "SAX2 XML Writer";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSemanticDiff = buildPerlPackage {
    name = "XML-SemanticDiff-1.0000";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/XML-SemanticDiff-1.0000.tar.gz;
      sha256 = "05rzm433vvndh49k8p4gqnyw4x4lxa4zr6qdlrlgplqkxvhvk6jk";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      maintainers = with maintainers; [ ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLSimple = buildPerlPackage {
    name = "XML-Simple-2.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.20.tar.gz;
      sha256 = "0jj3jiray1l4pi9wkjcpxjc3v431whdwx5aqnhgdm4i7h3817zsw";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLTokeParser = buildPerlPackage rec {
    name = "XML-TokeParser-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/${name}.tar.gz";
      sha256 = "1hnpwb3lh6cbgwvjjgqzcp6jm4mp612qn6ili38adc9nhkwv8fc5";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Simplified interface to XML::Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTwig = buildPerlPackage rec {
    name = "XML-Twig-3.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIROD/${name}.tar.gz";
      sha256 = "00af6plljrx2dc0js60975wqp725ka4i3gzs4y6gmzkpfj5fy39y";
    };
    propagatedBuildInputs = [XMLParser];
    doCheck = false;  # requires lots of extra packages
  };

  XMLValidatorSchema = buildPerlPackage {
    name = "XML-Validator-Schema-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMTREGAR/XML-Validator-Schema-1.10.tar.gz;
      sha256 = "6142679580150a891f7d32232b5e31e2b4e5e53e8a6fa9cbeecb5c23814f1422";
    };
    buildInputs = [ FileSlurpTiny ];
    propagatedBuildInputs = [ TreeDAGNode XMLFilterBufferText XMLSAX ];
    meta = {
      description = "Validate XML against a subset of W3C XML Schema";
    };
  };

  XMLWriter = buildPerlPackage rec {
    name = "XML-Writer-0.625";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/${name}.tar.gz";
      sha256 = "1gjzs570i67ywbv967g8ylb5sg59clwmyrl2yix3jl70dhn55070";
    };
  };

  XSLoader = buildPerlPackage {
    name = "XSLoader-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.20.tar.gz;
      sha256 = "020fyjhfp385nlkp217fm511sbjz768vqk1lmxz99k4bah740y7i";
    };
    meta = {
      homepage = https://metacpan.org/module/Math::BigInt;
      description = "Dynamically load C libraries into Perl code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XSObjectMagic = buildPerlPackage rec {
    name = "XS-Object-Magic-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "03fghj7hq0fiicmfdxhmzfm4mzv7s097pgkd32ji7jnljvhm9six";
    };
    buildInputs = [ ExtUtilsDepends TestFatal Testuseok ];
    meta = {
      description = "XS pointer backed objects using sv_magic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAML = buildPerlPackage rec {
    name = "YAML-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "06wx1pzc2sb7vidlp17g1x11rrz57ch8q68gjj8fbgd75wr9bx40";
    };

    buildInputs = [ TestBase TestYAML ];

    meta = {
      homepage = https://github.com/ingydotnet/yaml-pm/tree;
      description = "YAML Ain't Markup Language (tm)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "0ff9rzb1gg12iiizjqv6bsxdxk39g3f6sa18znha4476acv7nmnk";
    };
    meta = {
      homepage = http://search.cpan.org/dist/YAML-Syck;
      description = "Fast, lightweight YAML loader and dumper";
      license = stdenv.lib.licenses.mit;
    };
  };

  YAMLTiny = buildPerlPackage rec {
    name = "YAML-Tiny-1.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "14pmhksj68ii3rf4dza8im1i6jw3zafxkvxww5xlz7ib95cv135w";
    };
  };

  YAMLLibYAML = buildPerlPackage rec {
    name = "YAML-LibYAML-0.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0m4zr6gm5rzwvxwd2x7rklr659jl8gsa5bxc5h25904nbvpj9x4x";
    };
  };

}; in self
