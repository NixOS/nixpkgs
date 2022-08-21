/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as much code as the function itself. */

{ config
, stdenv, lib, buildPackages, pkgs, darwin
, fetchurl, fetchgit, fetchpatch, fetchFromGitHub, fetchFromGitLab
, perl, overrides, buildPerl, shortenPerlShebang
, nixosTests
}:

# cpan2nix assumes that perl-packages.nix will be used only with perl 5.30.3 or above
assert lib.versionAtLeast perl.version "5.30.3";
let
  inherit (lib) maintainers teams;
  self = _self // (overrides pkgs);
  _self = with self; {

  inherit perl;
  perlPackages = self;

  callPackage = pkgs.newScope self;

  # Check whether a derivation provides a perl module.
  hasPerlModule = drv: drv ? perlModule ;

  requiredPerlModules = drvs: let
    modules = lib.filter hasPerlModule drvs;
  in lib.unique ([perl] ++ modules ++ lib.concatLists (lib.catAttrs "requiredPerlModules" modules));

  # Convert derivation to a perl module.
  toPerlModule = drv:
    drv.overrideAttrs( oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {}) // {
        perlModule = perl;
        requiredPerlModules = requiredPerlModules drv.propagatedBuildInputs;
      };
    });

  buildPerlPackage = callPackage ../development/perl-modules/generic {
    inherit buildPerl;
  };

  # Helper functions for packages that use Module::Build to build.
  buildPerlModule = args:
    buildPerlPackage ({
      buildPhase = ''
        runHook preBuild
        perl Build.PL --prefix=$out; ./Build build
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        ./Build install
        runHook postInstall
      '';
      checkPhase = ''
        runHook preCheck
        ./Build test
        runHook postCheck
      '';
    } // args // {
      preConfigure = ''
        touch Makefile.PL
        ${args.preConfigure or ""}
      '';
      buildInputs = (args.buildInputs or []) ++ [ ModuleBuild ];
    });

  /* Construct a perl search path (such as $PERL5LIB)

     Example:
       pkgs = import <nixpkgs> { }
       makePerlPath [ pkgs.perlPackages.libnet ]
       => "/nix/store/n0m1fk9c960d8wlrs62sncnadygqqc6y-perl-Net-SMTP-1.25/lib/perl5/site_perl"
  */
  makePerlPath = lib.makeSearchPathOutput "lib" perl.libPrefix;

  /* Construct a perl search path recursively including all dependencies (such as $PERL5LIB)

     Example:
       pkgs = import <nixpkgs> { }
       makeFullPerlPath [ pkgs.perlPackages.CGI ]
       => "/nix/store/fddivfrdc1xql02h9q500fpnqy12c74n-perl-CGI-4.38/lib/perl5/site_perl:/nix/store/8hsvdalmsxqkjg0c5ifigpf31vc4vsy2-perl-HTML-Parser-3.72/lib/perl5/site_perl:/nix/store/zhc7wh0xl8hz3y3f71nhlw1559iyvzld-perl-HTML-Tagset-3.20/lib/perl5/site_perl"
  */
  makeFullPerlPath = deps: makePerlPath (lib.misc.closePropagation deps);


  ack = buildPerlPackage {
    pname = "ack";
    version = "3.5.0";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/ack-v3.5.0.tar.gz";
      sha256 = "sha256-ZgU+iE6AM4egLd7g1oq/KhAjn6tlQ2TaszKHMJpyVSE=";
    };

    outputs = ["out" "man"];

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [ FileNext ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/ack
    '';

    # tests fails on nixos and hydra because of different purity issues
    doCheck = false;

    meta = with lib; {
      description = "A grep-like tool tailored to working with large trees of source code";
      homepage = "https://beyondgrep.com";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ActionCircuitBreaker = buildPerlPackage {
    pname = "Action-CircuitBreaker";
    version = "0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANGY/Action-CircuitBreaker-0.1.tar.gz";
      sha256 = "3f8f5d726fae537ab336e00a6819ae4a8596e4c5f243e772a536ef2eb6e606b1";
    };
    buildInputs = [ ActionRetry TryTiny ];
    propagatedBuildInputs = [ Moo ];
    meta = {
      description = "Module to try to perform an action, with an option to suspend execution after a number of failures";
      homepage = "https://github.com/hangy/Action-CircuitBreaker";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ActionRetry = buildPerlPackage {
    pname = "Action-Retry";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/Action-Retry-0.24.tar.gz";
      sha256 = "a3759742c5bef2d1975ab73d35499d8113324919b24936130255cff07d0294f7";
    };
    propagatedBuildInputs = [ MathFibonacci ModuleRuntime Moo ];
    meta = {
      description = "Module to try to perform an action, with various ways of retrying and sleeping between retries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmAnnotate = buildPerlPackage {
    pname = "Algorithm-Annotate";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz";
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
  };

  AlgorithmC3 = buildPerlPackage {
    pname = "Algorithm-C3";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Algorithm-C3-0.11.tar.gz";
      sha256 = "02ck52cf0yyk57354rd1rp5l0kbfwi1pvg2lh3jadvjxfrkq9x5a";
    };
    meta = {
      description = "A module for merging hierarchies using the C3 algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmCheckDigits = buildPerlModule {
    pname = "Algorithm-CheckDigits";
    version = "1.3.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAMAWE/Algorithm-CheckDigits-v1.3.5.tar.gz";
      sha256 = "a956d0517180d6d9042f47d73aa6a2728b75fcbd546940d2dbe0a7e7cf428f73";
    };
    buildInputs = [ ProbePerl ];
    meta = {
      description = "Perl extension to generate and test check digits";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "checkdigits.pl";
    };
  };

  AlgorithmDiff = buildPerlPackage {
    pname = "Algorithm-Diff";
    version = "1.1903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz";
      sha256 = "0l8pk7ziz72d022hsn4xldhhb9f5649j5cgpjdibch0xng24ms1h";
    };
    buildInputs = [ pkgs.unzip ];
  };

  AlgorithmLCSS = buildPerlPackage {
    pname = "Algorithm-LCSS";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JF/JFREEMAN/Algorithm-LCSS-0.01.tar.gz";
      sha256 = "0y0zc3sq283zpv67vy7a3h3dyvjn5svjxwknanmp38a2g36fyz3i";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AlgorithmMerge = buildPerlPackage {
    pname = "Algorithm-Merge";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSMITH/Algorithm-Merge-0.08.tar.gz";
      sha256 = "1kqn13wd0lfjrf6h19b9kgdqqwp7k2d9yfq5i0wvii0xi8jqh1lw";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
  };

  AlienBaseModuleBuild = buildPerlModule {
    pname = "Alien-Base-ModuleBuild";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-Base-ModuleBuild-1.15.tar.gz";
      sha256 = "13c9432cf41b34cb14df2454a03e540e2bd5dc9eb9c82824b6ad0f4c67793afd";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ AlienBuild ArchiveExtract CaptureTiny Filechdir PathTiny ShellConfigGenerate ShellGuess SortVersions URI ];
    meta = {
      description = "A Module::Build subclass for building Alien:: modules and their libraries";
      homepage = "https://metacpan.org/pod/Alien::Base::ModuleBuild";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienBuild = buildPerlPackage {
    pname = "Alien-Build";
    version = "2.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-Build-2.37.tar.gz";
      sha256 = "0lgdr4d4hpv9q6i8lzs5lrilrwj8zm1cxzxwdgvl69j8k2zbq01h";
    };
    propagatedBuildInputs = [ CaptureTiny FFICheckLib FileWhich Filechdir PathTiny PkgConfig ];
    buildInputs = [ DevelHide Test2Suite ];
    meta = {
      description = "Build external dependencies for use in CPAN";
      homepage = "https://metacpan.org/pod/Alien::Build";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienGMP = buildPerlPackage {
    pname = "Alien-GMP";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-GMP-1.16.tar.gz";
      sha256 = "199x24pl6jnqshgnl066lhdf2fkqa6l1fml9g3qn5grmwn7d8309";
    };
    propagatedBuildInputs = [ AlienBuild ];
    buildInputs = [ pkgs.gmp Alienm4 DevelChecklib IOSocketSSL MojoDOM58 NetSSLeay SortVersions Test2Suite URI ];
    meta = {
      description = "Alien package for the GNU Multiple Precision library";
      homepage = "https://metacpan.org/pod/Alien::GMP";
      license = with lib.licenses; [ lgpl3Plus ];
    };
  };

  AlienLibGumbo = buildPerlModule {
    pname = "Alien-LibGumbo";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RUZ/Alien-LibGumbo-0.05.tar.gz";
      sha256 = "0fbe916ab11f680e5c28cd1ac800372323e2a0e06affc6c8b36279fc64d76517";
    };
    buildInputs = [ AlienBaseModuleBuild ];
    propagatedBuildInputs = [ AlienBuild FileShareDir PathClass ];
    meta = {
      description = "Gumbo parser library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.AlienLibGumbo.x86_64-darwin
    };
  };

  AlienLibxml2 = buildPerlPackage {
    pname = "Alien-Libxml2";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.17.tar.gz";
      sha256 = "1cwdqspbq0r0bmw0079z4qzc7chs5aw6jdf3699nxhxmy1255d3k";
    };
    propagatedBuildInputs = [ AlienBuild ];
    buildInputs = [ pkgs.libxml2 MojoDOM58 SortVersions Test2Suite URI ];
    meta = {
      description = "Install the C libxml2 library on your system";
      homepage = "https://metacpan.org/pod/Alien::Libxml2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  aliased = buildPerlModule {
    pname = "aliased";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/aliased-0.34.tar.gz";
      sha256 = "1syyqzy462501kn5ma9gl6xbmcahqcn4qpafhsmpz0nd0x2m4l63";
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  asa = buildPerlPackage {
    pname = "asa";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/asa-1.04.tar.gz";
      sha256 = "0pk783s1h2f45zbmm6a62yfgy71w4sqh8ppgs4cyxfikwxs3p0z5";
    };
    meta = {
      description = "Lets your class/object say it works like something else";
      homepage = "https://github.com/karenetheridge/asa";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienSDL = buildPerlModule {
    pname = "Alien-SDL";
    version = "1.446";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FROGGS/Alien-SDL-1.446.tar.gz";
      sha256 = "c9aa2c9dc3c63d89773c7d7203f2a46d1b924d0c72d9f801af147a3dc8bc512a";
    };
    patches = [ ../development/perl-modules/alien-sdl.patch ];

    installPhase = "./Build install --prefix $out";

    SDL_INST_DIR = lib.getDev pkgs.SDL;
    buildInputs = [ pkgs.SDL ArchiveExtract ArchiveZip TextPatch ];
    propagatedBuildInputs = [ CaptureTiny FileShareDir FileWhich ];

    meta = {
      description = "Get, Build and Use SDL libraries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienTidyp = buildPerlModule {
    pname = "Alien-Tidyp";
    version = "1.4.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Alien-Tidyp-v1.4.7.tar.gz";
      sha256 = "0raapwp4155lqag1kzhsd20z4if10hav9wx4d7mc1xpvf7dcnr5r";
    };

    buildInputs = [ ArchiveExtract ];
    TIDYP_DIR = pkgs.tidyp;
    propagatedBuildInputs = [ FileShareDir ];
  };

  AlienWxWidgets = buildPerlModule {
    pname = "Alien-wxWidgets";
    version = "0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/Alien-wxWidgets-0.69.tar.gz";
      sha256 = "0jg2dmkzhj03f6b0vmv597yryfw9cclsdn9ynvvlrzzgpd5lw8jk";
    };
    propagatedBuildInputs = [ pkgs.pkg-config pkgs.gtk2 pkgs.wxGTK30 ModulePluggable ];
    buildInputs = [ LWPProtocolHttps ];
  };

  Alienm4 = buildPerlPackage {
    pname = "Alien-m4";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-m4-0.19.tar.gz";
      sha256 = "1xnh8qa99dcvqcqzbpy0s5jrxvn7wa5ydz3lfd56n358l5jfzns9";
    };
    propagatedBuildInputs = [ AlienBuild ];
    buildInputs = [ pkgs.gnum4 Alienpatch IOSocketSSL MojoDOM58 NetSSLeay SortVersions Test2Suite URI ];
    meta = {
      description = "Find or build GNU m4";
      homepage = "https://metacpan.org/pod/Alien::m4";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Alienpatch = buildPerlPackage {
    pname = "Alien-patch";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-patch-0.15.tar.gz";
      sha256 = "1l00mq56596wn09nn7fv552j2aa7sgh46bvx5xlncsnrn8jp5mpy";
    };
    propagatedBuildInputs = [ AlienBuild ];
    buildInputs = [ IOSocketSSL MojoDOM58 NetSSLeay SortVersions Test2Suite URI ];
    meta = {
      description = "Find or build patch";
      homepage = "https://metacpan.org/pod/Alien::patch";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AltCryptRSABigInt = buildPerlPackage {
    pname = "Alt-Crypt-RSA-BigInt";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Alt-Crypt-RSA-BigInt-0.06.tar.gz";
      sha256 = "76f434cab36999cdf09811345bb39d6b7cbed7e085b02338328c7f46e08b38f3";
    };
    propagatedBuildInputs = [ ClassLoader ConvertASCIIArmour DataBuffer DigestMD2 MathBigIntGMP MathPrimeUtil SortVersions TieEncryptedHash ];
    meta = {
      description = "RSA public-key cryptosystem, using Math::BigInt";
      homepage = "https://github.com/danaj/Alt-Crypt-RSA-BigInt";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AnyEvent = buildPerlPackage {
    pname = "AnyEvent";
    version = "7.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-7.17.tar.gz";
      sha256 = "50beea689c098fe4aaeb83806c40b9fe7f946d5769acf99f849f099091a4b985";
    };
    buildInputs = [ CanaryStability ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventAIO = buildPerlPackage {
    pname ="AnyEvent-AIO";
    version = "1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-AIO-1.1.tar.gz";
      sha256 = "0svh0mlp17g0ypq8bgs3h3axg8v7h0z45hryacgn6q8mcj65n43b";
    };
    propagatedBuildInputs = [ AnyEvent IOAIO ];
    meta = {
      description = "Truly asynchronous file and directory I/O";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventBDB = buildPerlPackage rec {
    pname = "AnyEvent-BDB";
    version = "1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${pname}-${version}.tar.gz";
      sha256 = "93e36010940464626e5f31b9faedd65e12ed8d1abf16ce052febf23f495aefc8";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ BDB AnyEvent ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventCacheDNS = buildPerlModule {
    pname = "AnyEvent-CacheDNS";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/AnyEvent-CacheDNS-0.08.tar.gz";
      sha256 = "41c1faf183b61806b55889ceea1237750c1f61b9ce2735fdf33dc05536712dae";
    };
    propagatedBuildInputs = [ AnyEvent ];
    doCheck = false; # does an DNS lookup
    meta = {
      description = "Simple DNS resolver with caching";
      homepage = "http://github.com/potyl/perl-AnyEvent-CacheDNS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventFastPing = buildPerlPackage {
    pname = "AnyEvent-FastPing";
    version = "2.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-FastPing-2.1.tar.gz";
      sha256 = "0b3ha864nw0qk22ybhzfgz0r0p69iyj01bi500x9hp6kga7ip4p5";
    };
    propagatedBuildInputs = [ AnyEvent commonsense ];
    meta = {
      description = "Quickly ping a large number of hosts";
      license = with lib.licenses; [ artistic1 gpl2Plus ];
      mainProgram = "fastping";
    };
  };

  AnyEventHTTP = buildPerlPackage {
    pname = "AnyEvent-HTTP";
    version = "2.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-HTTP-2.25.tar.gz";
      sha256 = "5cfa53416124176f6f4cd32b00ea8ca79a2d5df51258683989cd04fe86e25013";
    };
    propagatedBuildInputs = [ AnyEvent commonsense ];
  };

  AnyEventI3 = buildPerlPackage {
    pname = "AnyEvent-I3";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/AnyEvent-I3-0.17.tar.gz";
      sha256 = "5382c984c9f138395f29f0c00af81aa0c8f4b765582055c73ede4b13f04a6d63";
    };
    propagatedBuildInputs = [ AnyEvent JSONXS ];
    meta = {
      description = "Communicate with the i3 window manager";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventIRC = buildPerlPackage rec {
    pname = "AnyEvent-IRC";
    version = "0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EL/ELMEX/${pname}-${version}.tar.gz";
      sha256 = "bfd7cf645c3c8c611471057128611447e20f1adf01516c69624cbd8bc77f5bf0";
    };
    propagatedBuildInputs = [ AnyEvent ObjectEvent commonsense ];
    meta = {
      description = "An event based IRC protocol client API";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventRabbitMQ = buildPerlPackage {
    pname = "AnyEvent-RabbitMQ";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAMBLEY/AnyEvent-RabbitMQ-1.22.tar.gz";
      sha256 = "98c52a1fe700710f3e5bc55a38b25de625e9b2e8341d278dcf9e1b3f3d19acee";
    };
    buildInputs = [ FileShareDirInstall TestException ];
    propagatedBuildInputs = [ AnyEvent DevelGlobalDestruction FileShareDir ListMoreUtils NetAMQP Readonly namespaceclean ];
    meta = {
      description = "An asynchronous and multi channel Perl AMQP client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyMoose = buildPerlPackage {
    pname = "Any-Moose";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Any-Moose-0.27.tar.gz";
      sha256 = "0dc55mpayrixwx8dwql0vj0jalg4rlb3k64rprc84bl0z8vkx9m8";
    };
    propagatedBuildInputs = [ Moose Mouse ];
  };

  AnyURIEscape = buildPerlPackage {
    pname = "Any-URI-Escape";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/Any-URI-Escape-0.01.tar.gz";
      sha256 = "0k4c20bmw32yxksgkc2i44j4vfmzhqcqrq36pv0ab3qhkzn3r0g3";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Load URI::Escape::XS preferentially over URI::Escape";
      license = with lib.licenses; [ unfree ];
    };
  };

  URIEscapeXS = buildPerlPackage {
    pname = "URI-Escape-XS";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/URI-Escape-XS-0.14.tar.gz";
      sha256 = "c39ac50c6c2b831ae4bf08692e6ca5d4a3f9c57dc4d7f9c4cb0663e2c86c2759";
    };
    meta = {
      description = "Drop-In replacement for URI::Escape";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheAuthCookie = buildPerlPackage {
    pname = "Apache-AuthCookie";
    version = "3.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Apache-AuthCookie-3.30.tar.gz";
      sha256 = "1f71b94d3d55a950a4b32dae4e90f6e76c8157508a7e2aee50621b179aadb1fb";
    };
    buildInputs = [ ApacheTest ];
    propagatedBuildInputs = [ ClassLoad HTTPBody HashMultiValue WWWFormUrlEncoded ];

    # Fails because /etc/protocols is not available in sandbox and make
    # getprotobyname('tcp') in ApacheTest fail.
    doCheck = !stdenv.isLinux;

    meta = {
      description = "Perl Authentication and Authorization via cookies";
      homepage = "https://github.com/mschout/apache-authcookie";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheDB = buildPerlPackage {
    pname = "Apache-DB";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LZ/LZE/Apache-DB-0.18.tar.gz";
      sha256 = "6527f4f1598270bea07bec787b71bdf0ec2b572548be7438cf74f2b9a600bfed";
    };
    meta = {
      description = "Run the interactive Perl debugger under mod_perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheLogFormatCompiler = buildPerlModule {
    pname = "Apache-LogFormat-Compiler";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Apache-LogFormat-Compiler-0.36.tar.gz";
      sha256 = "05xcl7j65vakx7x79jqjikyw0nzf60bc2w6hhc0q5sklxq1ral4l";
    };
    buildInputs = [ HTTPMessage ModuleBuildTiny TestMockTime TestRequires TryTiny URI ];
    propagatedBuildInputs = [ POSIXstrftimeCompiler ];
    # We cannot change the timezone on the fly.
    prePatch = "rm t/04_tz.t";
    meta = {
      description = "Compile a log format string to perl-code";
      homepage = "https://github.com/kazeburo/Apache-LogFormat-Compiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheSession = buildPerlModule {
    pname = "Apache-Session";
    version = "1.94";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Apache-Session-1.94.tar.gz";
      sha256 = "17z9cdsk3vxah1dlix1pi68dlnjplymf4bdqwn50psdgk5lbfsgy";
    };
    buildInputs = [ TestDeep TestException ];
    meta = {
      description = "A persistence framework for session data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheTest = buildPerlPackage {
    pname = "Apache-Test";
    version = "1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/Apache-Test-1.42.tar.gz";
      sha256 = "1sxk7dmpg3ib1dkl58ddh7zffnv5danwba7qxp82k54agmyz1086";
    };
    doCheck = false;
    meta = {
      description = "Test.pm wrapper with helpers for testing Apache";
      license = with lib.licenses; [ asl20 ];
    };
  };

  AppCLI = buildPerlPackage {
    pname = "App-CLI";
    version = "0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PT/PTC/App-CLI-0.50.tar.gz";
      sha256 = "0ick5agl02rx2pjfxl97d0f9qksy8pjn0asmwm3gn6dm7a1zblsi";
    };
    propagatedBuildInputs = [ CaptureTiny ClassLoad ];
    buildInputs = [ TestKwalitee TestPod ];
  };

  AppClusterSSH = buildPerlModule {
    pname = "App-ClusterSSH";
    version = "4.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DU/DUNCS/App-ClusterSSH-4.16.tar.gz";
      sha256 = "0y2mzprv47ff4sig2fkvd10jwz2h4x6srncbvx528mk8c2mvhz0v";
    };
    propagatedBuildInputs = [ ExceptionClass Tk X11ProtocolOther XMLSimple ];
    buildInputs = [ DataDump FileWhich Readonly TestDifferences TestTrap ];
    preCheck = "rm t/30cluster.t"; # do not run failing tests
    postInstall = ''
      mkdir -p $out/share/bash-completion/completions
      mv $out/bin/clusterssh_bash_completion.dist \
        $out/share/bash-completion/completions/clusterssh_bash_completion
      substituteInPlace $out/share/bash-completion/completions/clusterssh_bash_completion \
        --replace '/bin/true' '${pkgs.coreutils}/bin/true' \
        --replace 'grep' '${pkgs.gnugrep}/bin/grep' \
        --replace 'sed' '${pkgs.gnused}/bin/sed'
    '';
    meta = {
      description = "Cluster administration tool";
      homepage = "http://github.com/duncs/clusterssh/wiki";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cssh";
    };
  };

  AppCmd = buildPerlPackage {
    pname = "App-Cmd";
    version = "0.331";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/App-Cmd-0.331.tar.gz";
      sha256 = "4a5d3df0006bd278880d01f4957aaa652a8f91fe8f66e93adf70fba0c3ecb680";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CaptureTiny ClassLoad GetoptLongDescriptive IOTieCombine ModulePluggable StringRewritePrefix ];
    meta = {
      description = "Write command line apps with less suffering";
      homepage = "https://github.com/rjbs/App-Cmd";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AppConfig = buildPerlPackage {
    pname = "AppConfig";
    version = "1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/AppConfig-1.71.tar.gz";
      sha256 = "03vvi3mk4833mx2c6dkm9zhvakf02mb2b7wz9pk9xc7c4mq04xqi";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "A bundle of Perl5 modules for reading configuration files and parsing command line arguments";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AppFatPacker = buildPerlPackage {
    pname = "App-FatPacker";
    version = "0.010008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/App-FatPacker-0.010008.tar.gz";
      sha256 = "1kzcbpsf1p7ww45d9fl2w0nfn5jj5pz0r0c649c1lrj5r1nv778j";
    };
    meta = {
      description = "Pack your dependencies onto your script file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "fatpack";
    };
  };

  Appcpanminus = buildPerlPackage {
    pname = "App-cpanminus";
    version = "1.7045";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7045.tar.gz";
      sha256 = "1779w07zxlgfk35s24ksr7k9azd5yl8sbb48y1aaph7y4gf4lkmc";
    };
    # Use TLS endpoints for downloads and metadata by default
    preConfigure = ''
      substituteInPlace bin/cpanm \
        --replace http://www.cpan.org https://www.cpan.org \
        --replace http://backpan.perl.org https://backpan.perl.org \
        --replace http://fastapi.metacpan.org https://fastapi.metacpan.org \
        --replace http://cpanmetadb.plackperl.org https://cpanmetadb.plackperl.org
    '';
    propagatedBuildInputs = [ IOSocketSSL ];
    meta = {
      description = "Get, unpack, build and install modules from CPAN";
      homepage = "https://github.com/miyagawa/cpanminus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cpanm";
    };
  };

  Appcpm = buildPerlModule {
    pname = "App-cpm";
    version = "0.997011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/App-cpm-0.997011.tar.gz";
      sha256 = "sha256-YyECxuZ958nP9R1vqg2dA7/vvtNbXMXZaRn3uSAlAck=";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CPAN02PackagesSearch CPANCommonIndex CPANDistnameInfo ClassTiny CommandRunner ExtUtilsInstall ExtUtilsInstallPaths FileCopyRecursive Filepushd HTTPTinyish MenloLegacy Modulecpmfile ModuleCPANfile ParsePMFile ParallelPipes locallib ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/cpm
    '';
    meta = {
      description = "A fast CPAN module installer";
      homepage = "https://github.com/skaji/cpm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
      mainProgram = "cpm";
    };
  };

  Applify = buildPerlPackage {
    pname = "Applify";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Applify-0.22.tar.gz";
      sha256 = "0y644rr7gl49awn27xj556q9i86fddkkn26gnfn52wm19d7aa94a";
    };
    meta = {
      description = "Write object oriented scripts with ease";
      homepage = "https://github.com/jhthorsen/applify";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AppMusicChordPro = buildPerlPackage {
    pname = "App-Music-ChordPro";
    version = "0.977";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/App-Music-ChordPro-0.977.tar.gz";
      sha256 = "0ggip43cddi5f6rylb07f56dhkfhbcbm621lvcnjfadnn9lrbwqh";
    };
    buildInputs = [ PodParser ];
    propagatedBuildInputs = [ AppPackager FileLoadLines IOString ImageInfo PDFAPI2 StringInterpolateNamed TextLayout ]
      ++ lib.optional (!stdenv.isDarwin) [ Wx ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/chordpro
      rm $out/bin/wxchordpro # Wx not supported on darwin
    '';
    meta = {
      description = "A lyrics and chords formatting program";
      homepage = "http://www.chordpro.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "chordpro";
    };
  };

  AppPackager =  buildPerlPackage {
    pname = "App-Packager";
    version = "1.430.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/App-Packager-1.430.1.tar.gz";
      sha256 = "57f4d014458387f9e2ed2dfd8615d1e2545b8a6504b10af22486578d8be374a3";
    };
    meta = {
      description = "Abstraction for Packagers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Appperlbrew = buildPerlModule {
    pname = "App-perlbrew";
    version = "0.89";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GU/GUGOD/App-perlbrew-0.89.tar.gz";
      sha256 = "00krymnsvz5qx7fkn4hpfqlgrqmbkbf45f9jr3vl4yqcyrsmiyhg";
    };
    buildInputs = [ pkgs.curl FileWhich IOAll ModuleBuildTiny PathClass TestException TestNoWarnings TestOutput TestSpec TestTempDirTiny ];
    propagatedBuildInputs = [ CPANPerlReleases CaptureTiny DevelPatchPerl PodParser locallib ];

    doCheck = false;

    meta = {
      description = "Manage perl installations in your $HOME";
      license = with lib.licenses; [ mit ];
      mainProgram = "perlbrew";
    };
  };

  ArchiveAnyLite = buildPerlPackage {
    pname = "Archive-Any-Lite";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Archive-Any-Lite-0.11.tar.gz";
      sha256 = "0w2i50fd81ip674zmnrb15nadw162fdpiw4rampbd94k74jqih8m";
    };
    propagatedBuildInputs = [ ArchiveZip ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestUseAllModules ];
    meta = {
      description = "Simple CPAN package extractor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AppSqitch = buildPerlModule {
    version = "1.1.0";
    pname = "App-Sqitch";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/App-Sqitch-v1.1.0.tar.gz";
      sha256 = "ee146cd75d6300837e6ca559bb0bde247d42123c96b2c5d4b2800f38d3e3d1ab";
    };
    buildInputs = [ CaptureTiny TestDeep TestDir TestException TestFile TestFileContents TestMockModule TestMockObject TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ Clone ConfigGitLike DBI DateTime EncodeLocale HashMerge IOPager IPCRun3 IPCSystemSimple ListMoreUtils PathClass PerlIOutf8_strict PodParser StringFormatter StringShellQuote TemplateTiny Throwable TypeTiny URIdb libintl-perl ];
    doCheck = false;  # Can't find home directory.
    meta = {
      description = "Sensible database change management";
      homepage = "https://sqitch.org";
      license = with lib.licenses; [ mit ];
      mainProgram = "sqitch";
    };
  };

  AppSt = buildPerlPackage {
    pname = "App-St";
    version = "1.1.4";
    src = fetchurl {
      url = "https://github.com/nferraz/st/archive/v1.1.4.tar.gz";
      sha256 = "1f4bqm4jiazcxgzzja1i48671za96621k0s3ln87cdacgvv1can0";
    };
    postInstall =
      ''
        ($out/bin/st --help || true) | grep Usage
      '';
    meta = {
      description = "Simple Statistics";
      homepage = "https://github.com/nferraz/st";
      license = with lib.licenses; [ mit ];
      maintainers = [ maintainers.eelco ];
      mainProgram = "st";
    };
  };

  AttributeParamsValidate = buildPerlPackage {
    pname = "Attribute-Params-Validate";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Attribute-Params-Validate-1.21.tar.gz";
      sha256 = "586b939ceffdb37188b7c461dd1a8f9f35695184c8703b05c35f6d508c8090f5";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ParamsValidate ];
    doCheck = false;
    meta = {
      description = "Validate method/function parameters";
      homepage = "https://metacpan.org/release/Params-Validate";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ArrayCompare = buildPerlModule {
    pname = "Array-Compare";
    version = "3.0.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-v3.0.7.tar.gz";
      sha256 = "1p2kv4p2p5i6a665ax4b8iq1wal4x0g259yv32cc2ypbk7v11qs4";
    };

    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ Moo TypeTiny ];
  };

  ArrayDiff = buildPerlPackage {
    pname = "Array-Diff";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Array-Diff-0.09.tar.gz";
      sha256 = "0xsh8k312spzl90xds075qprcaz4r0b93g1bgi9l3rv1k0p3j1l0";
    };
    propagatedBuildInputs = [ AlgorithmDiff ClassAccessor ];
    meta = {
      description = "Find the differences between two arrays";
      homepage = "https://github.com/neilb/array-diff-perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArrayFIFO = buildPerlPackage {
    pname = "Array-FIFO";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBURKE/Array-FIFO-0.13.tar.gz";
      sha256 = "be2aeb5f5a9af1a96f0033508a569ca93ad19ad15dc7c6b998e6d7bc740c66f7";
    };
    buildInputs = [ TestDeep TestSpec TestTrap ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "A Simple limitable FIFO array, with sum and average methods";
      homepage = "https://github.com/dwburke/perl-Array-FIFO";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ArrayRefElem = buildPerlPackage {
    pname = "Array-RefElem";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id//G/GA/GAAS/Array-RefElem-1.00.tar.gz";
      sha256 = "sha256-U7iAo67AQ+TjcM4SaCtHVt5F3XQtq1cpT+IaFUU87+M=";
    };
    meta = {
      description = "Set up array elements as aliases";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AsyncPing = buildPerlPackage {
    pname = "AsyncPing";
    version = "2016.1207";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XI/XINFWANG/AsyncPing-2016.1207.tar.gz";
      sha256 = "0nn9k79gihzr9wfksi03jmdgc2ihsb4952ddz1v70xvsq7z9mgkg";
    };
    meta = {
      description = "Ping a huge number of servers in several seconds";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ArchiveCpio = buildPerlPackage {
    pname = "Archive-Cpio";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PI/PIXEL/Archive-Cpio-0.10.tar.gz";
      sha256 = "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3";
    };
    meta = {
      description = "Module for manipulations of cpio archives";
      license = with lib.licenses; [ artistic1 gpl1Plus ]; # See https://rt.cpan.org/Public/Bug/Display.html?id=43597#txn-569710
      mainProgram = "cpio-filter";
    };
  };

  ArchiveExtract = buildPerlPackage {
    pname = "Archive-Extract";
    version = "0.86";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Archive-Extract-0.86.tar.gz";
      sha256 = "9acd09cdb8e8cf0b6d08210a3b80342300c89a359855319bf6b00c14c4aab687";
    };
    meta = {
      description = "Generic archive extracting mechanism";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArchiveTar = buildPerlPackage {
    pname = "Archive-Tar";
    version = "2.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Archive-Tar-2.38.tar.gz";
      sha256 = "c5e48f53514288185830ced93bf3e16fbdf5cddce97ded1d1d8a9b0a21ea287b";
    };
    meta = {
      description = "Manipulates TAR archives";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "ptar";
    };
  };

  ArchiveTarWrapper = buildPerlPackage {
    pname = "Archive-Tar-Wrapper";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARFREITAS/Archive-Tar-Wrapper-0.38.tar.gz";
      sha256 = "0ymknznhk5ky7f835l0l5wfkx8kl0vfm0hvhijvgyp5rm3dd1wqr";
    };
    propagatedBuildInputs = [ FileWhich IPCRun LogLog4perl ];
    meta = {
      description = "API wrapper around the 'tar' utility";
      license = with lib.licenses; [ gpl3 ];
    };
  };

  ArchiveZip = buildPerlPackage {
    pname = "Archive-Zip";
    version = "1.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz";
      sha256 = "0l663s3a68p8r2qjy4pn1g05lx0i8js8wpz7qqln3bsvg1fihklq";
    };
    buildInputs = [ TestMockModule ];
    meta = {
      description = "Provide an interface to ZIP archive files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "crc32";
    };
  };

  AstroFITSHeader = buildPerlModule rec {
    pname = "Astro-FITS-Header";
    version = "3.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJENNESS/${pname}-${version}.tar.gz";
      sha256 = "530d59ef0c0935f9862d187187a2d7583b12c639bb67db14f983322b161892d9";
    };
    meta = {
      description = "Object-oriented interface to FITS HDUs";
      homepage = "https://github.com/timj/perl-Astro-FITS-Header";
      license = with lib.licenses; [ gpl3 ];
    };
  };

  AudioFLACHeader = buildPerlPackage {
    pname = "Audio-FLAC-Header";
    version = "2.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANIEL/Audio-FLAC-Header-2.4.tar.gz";
      sha256 = "fba5911d6c22d81506565cd9a1438e8605420ff7986cf03d1a12d006a4070543";
    };
    meta = {
      description = "Interface to FLAC header metadata";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AudioScan = buildPerlPackage {
    pname = "Audio-Scan";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/Audio-Scan-1.01.tar.gz";
      sha256 = "0jk3djnk6yf0jsjh8qk3mj8bkx4avp6i4czcpr5xrbf7f41744l3";
    };
    buildInputs = [ pkgs.zlib TestWarn ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.zlib.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.zlib.out}/lib -lz";
    meta = {
      description = "Fast C metadata and tag reader for all common audio file formats";
      license = with lib.licenses; [ gpl2 ];
    };
  };

  AuthenDecHpwd = buildPerlModule {
    pname = "Authen-DecHpwd";
    version = "2.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Authen-DecHpwd-2.007.tar.gz";
      sha256 = "f43a93bb02b41f7327d92f9e963b69505f67350a52e8f50796f98afc4fb3f177";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    propagatedBuildInputs = [ DataInteger DigestCRC ScalarString ];
    meta = {
      description = "DEC VMS password hashing";
      license = with lib.licenses; [ gpl1Plus ];
    };
  };

  AuthenHtpasswd = buildPerlPackage {
    pname = "Authen-Htpasswd";
    version = "0.171";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/Authen-Htpasswd-0.171.tar.gz";
      sha256 = "0rw06hwpxg388d26l0jvirczx304f768ijvc20l4b2ll7xzg9ymm";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
    meta = {
      description = "Interface to read and modify Apache .htpasswd files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenKrb5 = buildPerlModule {
    pname = "Authen-Krb5";
    version = "1.905";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IO/IOANR/Authen-Krb5-1.905.tar.gz";
      sha256 = "0kgpl0x1qxq1p2ccxy8qqkrvqba2gq6aq6p931qnz9812nxh0yyp";
    };
    perlPreHook = "export LD=$CC";
    propagatedBuildInputs = [ pkgs.libkrb5 ];
    buildInputs = [ DevelChecklib FileWhich PkgConfig ];
    meta = {
      description = "XS bindings for Kerberos 5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenKrb5Admin = buildPerlPackage rec {
    pname = "Authen-Krb5-Admin";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SJ/SJQUINNEY/Authen-Krb5-Admin-0.17.tar.gz";
      sha256 = "5dd49cacd983efd61a8c3f1a56571bb73785eb155908b5d7bec97eed78df0c54";
    };
    propagatedBuildInputs = [ pkgs.krb5Full.dev AuthenKrb5 ];
    # The following ENV variables are required by Makefile.PL to find
    # programs in krb5Full.dev. It is not enough to just specify the
    # path to krb5-config as this tool returns the prefix of krb5Full,
    # which implies a working value for KRB5_LIBDIR, but not the others.
    perlPreHook = ''
      export KRB5_CONFTOOL=${pkgs.krb5Full.dev}/bin/krb5-config
      export KRB5_BINDIR=${pkgs.krb5Full.dev}/bin
      export KRB5_INCDIR=${pkgs.krb5Full.dev}/include
    '';
    # Tests require working Kerberos infrastructure so replace with a
    # simple attempt to exercise the module.
    checkPhase = ''
      perl -I blib/lib -I blib/arch -MAuthen::Krb5::Admin -e 'print "1..1\nok 1\n"'
    '';
    meta = {
      description = "Perl extension for MIT Kerberos 5 admin interface";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  AuthenModAuthPubTkt = buildPerlPackage {
    pname = "Authen-ModAuthPubTkt";
    version = "0.1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGORDON/Authen-ModAuthPubTkt-0.1.1.tar.gz";
      sha256 = "7996e1a42c51216003ccf03c4b5250286b4c55684257971851f5ece9161dc7dd";
    };
    propagatedBuildInputs = [ pkgs.openssl IPCRun3 ];
    patchPhase = ''
      sed -i 's|my $openssl_bin = "openssl";|my $openssl_bin = "${pkgs.openssl}/bin/openssl";|' lib/Authen/ModAuthPubTkt.pm
      # -dss1 doesn't exist for dgst in openssl 1.1, -sha1 can also handle DSA keys now
      sed -i 's|-dss1|-sha1|' lib/Authen/ModAuthPubTkt.pm
    '';
    meta = {
      description = "Generate Tickets (Signed HTTP Cookies) for mod_auth_pubtkt protected websites";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mod_auth_pubtkt.pl";
    };
  };

  AuthenOATH = buildPerlPackage {
    pname = "Authen-OATH";
    version = "2.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/Authen-OATH-2.0.1.tar.gz";
      sha256 = "1a813dbdc05c3fbd9dd39dbcfd85e2cfb0ba3d0f652cf6b26ec83ab8146ddc77";
    };
    buildInputs = [ TestNeeds ];
    propagatedBuildInputs = [ DigestHMAC Moo TypeTiny ];
    meta = {
      description = "OATH One Time Passwords";
      homepage = "https://github.com/oalders/authen-oath";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AuthenPassphrase = buildPerlModule {
    pname = "Authen-Passphrase";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Authen-Passphrase-0.008.tar.gz";
      sha256 = "55db4520617d859d88c0ee54965da815b7226d792b8cdc8debf92073559e0463";
    };
    propagatedBuildInputs = [ AuthenDecHpwd CryptDES CryptEksblowfish CryptMySQL CryptPasswdMD5 CryptUnixCryptXS DataEntropy DigestMD4 ModuleRuntime ];
    meta = {
      description = "Hashed passwords/passphrases as objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenRadius = buildPerlPackage {
    pname = "Authen-Radius";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PORTAONE/Authen-Radius-0.32.tar.gz";
      sha256 = "0h0p4djscwixpbgbxrs9vsyx1vl7cm9r4j15cx11hfn86yc8y83v";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ DataHexDump NetIP ];
    meta = {
      description = "Provide simple Radius client facilities";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  AuthenSASL = buildPerlPackage {
    pname = "Authen-SASL";
    version = "2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/Authen-SASL-2.16.tar.gz";
      sha256 = "02afhlrdq5hh5g8b32fa79fqq5i76qzwfqqvfi9zi57h31szl536";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      description = "SASL Authentication framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenSASLSASLprep = buildPerlModule {
    pname = "Authen-SASL-SASLprep";
    version = "1.100";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/Authen-SASL-SASLprep-1.100.tar.gz";
      sha256 = "a4cccc34bb3f53acf0ba78c9fc61af8d156d109d1c10487ba5988a55077d1f70";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ UnicodeStringprep ];
    meta = {
      description = "A Stringprep Profile for User Names and Passwords (RFC 4013)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AuthenSCRAM = buildPerlPackage {
    pname = "Authen-SCRAM";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Authen-SCRAM-0.011.tar.gz";
      sha256 = "45108c239a7373d00941dcf0d171acd03e7c16a63ce6f7d9568ff052b17cf5a8";
    };
    buildInputs = [ TestFailWarnings TestFatal ];
    propagatedBuildInputs = [ AuthenSASLSASLprep CryptURandom Moo PBKDF2Tiny TypeTiny namespaceclean ];
    meta = {
      description = "Salted Challenge Response Authentication Mechanism (RFC 5802)";
      homepage = "https://github.com/dagolden/Authen-SCRAM";
      license = with lib.licenses; [ asl20 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AuthenSimple = buildPerlPackage {
    pname = "Authen-Simple";
    version = "0.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Authen-Simple-0.5.tar.gz";
      sha256 = "02cddab47f8bf1a1cbd4c9bf8d258f6d05111499c33f8315e7244812f72613aa";
    };
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable CryptPasswdMD5 ParamsValidate ];
    meta = {
      description = "Simple Authentication";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AuthenSimplePasswd = buildPerlModule {
    pname = "Authen-Simple-Passwd";
    version = "0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Authen-Simple-Passwd-0.6.tar.gz";
      sha256 = "1ckl2ry9r5nb1rcn1ik2l5b5pp1i3g4bmllsmzb0zpwy4lvbqmfg";
    };
    propagatedBuildInputs = [ AuthenSimple ];
    meta = {
      description = "Simple Passwd authentication";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  autobox = buildPerlPackage {
    pname = "autobox";
    version = "3.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/autobox-v3.0.1.tar.gz";
      sha256 = "c303b7fccfaa1ff4d4c429ab3f15e5ca2a77554ef8c9fc3b8c62ba859e874c98";
    };
    propagatedBuildInputs = [ ScopeGuard ];
    buildInputs = [ IPCSystemSimple TestFatal ];
    meta = {
      description = "Call methods on native types";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  Autodia = buildPerlPackage {
    pname = "Autodia";
    version = "2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEEJAY/Autodia-2.14.tar.gz";
      sha256 = "08pl5y18nsvy8ihfzdsbd8rz6a8al09wqfna07zdjfdyib42b0dc";
    };
    propagatedBuildInputs = [ TemplateToolkit XMLSimple ];
    buildInputs = [ DBI ];

    meta = {
      description = "AutoDia, create UML diagrams from source code";
      homepage = "http://www.aarontrevena.co.uk/opensource/autodia/";
      license = with lib.licenses; [ gpl2Plus ];
      mainProgram = "autodia.pl";
    };
  };

  AWSSignature4 = buildPerlModule {
    pname = "AWS-Signature4";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/AWS-Signature4-1.02.tar.gz";
      sha256 = "20bbc16cb3454fe5e8cf34fe61f1a91fe26c3f17e449ff665fcbbb92ab443ebd";
    };
    propagatedBuildInputs = [ LWP TimeDate URI ];
    meta = {
      description = "Create a version4 signature for Amazon Web Services";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  autovivification = buildPerlPackage {
    pname = "autovivification";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz";
      sha256 = "01giacr2sx6b9bgfz6aqw7ndcnf08j8n6kwhm7880a94hmb9g69d";
    };
    meta = {
      description = "Lexically disable autovivification";
      homepage = "http://search.cpan.org/dist/autovivification";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BarcodeZBar = buildPerlPackage {
    pname = "Barcode-ZBar";
    version = "0.04pre";
    # The meta::cpan version of this module has been unmaintained from 2009
    # This uses an updated version from the ZBar repo that works with the current ZBar library
    src = "${pkgs.zbar.src}/perl";
    postPatch = ''
      substituteInPlace Makefile.PL --replace "-lzbar" "-L${pkgs.zbar.lib}/lib -lzbar"
      rm t/Processor.t
    '';
    buildInputs =[ ExtUtilsMakeMaker ];
    propagatedBuildInputs = [ pkgs.zbar PerlMagick ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Perl interface to the ZBar Barcode Reader";
      homepage = "https://metacpan.org/pod/Barcode::ZBar";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  BC = buildPerlPackage {
    pname = "B-C";
    version = "1.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/B-C-1.57.tar.gz";
      sha256 = "1zs9a4gl63icja055kncgyny6xk1nsk6payfbzczkba3sc8sclh4";
    };
    propagatedBuildInputs = [ BFlags IPCRun Opcodes ];
    doCheck = false; /* test fails */
    meta = {
      description = "Perl compiler";
      homepage = "https://github.com/rurban/perl-compiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perlcc";
    };
  };

  BCOW = buildPerlPackage {
    pname = "B-COW";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/B-COW-0.004.tar.gz";
      sha256 = "0lazb25jzhdha4dmrkdxn1pw1crc6iqzspvcq315p944xmsvgbzw";
    };
    meta = {
      description = "B::COW additional B helpers to check COW status";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BFlags = buildPerlPackage {
    pname = "B-Flags";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/B-Flags-0.17.tar.gz";
      sha256 = "1chhgkaw2h3qniz71dykynggqp0r6b6mi2f4nh4x3ghm2g89gny1";
    };
    meta = {
      description = "Friendlier flags for B";
      license = with lib.licenses; [ unfree ];
    };
  };

  BeanstalkClient = buildPerlPackage {
    pname = "Beanstalk-Client";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/Beanstalk-Client-1.07.tar.gz";
      sha256 = "3188ab1127f2caba97df65c84f69db0ec70c64e5d70f296f9a2674fa79c112cc";
    };
    propagatedBuildInputs = [ ClassAccessor YAMLSyck ];
    meta = {
      description = "Client to communicate with beanstalkd server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BerkeleyDB = buildPerlPackage {
    pname = "BerkeleyDB";
    version = "0.64";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/BerkeleyDB-0.64.tar.gz";
      sha256 = "0jvllgyk7ai8zxziaxpxar0n2054y01dq3qn40xc86lwakl8ap2k";
    };

    preConfigure = ''
      echo "LIB = ${pkgs.db.out}/lib" > config.in
      echo "INCLUDE = ${pkgs.db.dev}/include" >> config.in
    '';
  };

  BDB = buildPerlPackage rec {
    pname = "BDB";
    version = "1.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${pname}-${version}.tar.gz";
      sha256 = "a3f2ca9d2baefc1aaa40908b2f9cb9292fda3e7d797e38bbd78eabb9d9daeb6b";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.db4.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.db4.out}/lib -ldb";
    buildInputs = [ pkgs.db4 ];
    propagatedBuildInputs = [ commonsense ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksEndOfScope = buildPerlPackage {
    pname = "B-Hooks-EndOfScope";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.24.tar.gz";
      sha256 = "1imcqxp23yc80a7p0h56sja9glbrh4qyhgzljqd4g9habpz3vah3";
    };
    propagatedBuildInputs = [ ModuleImplementation SubExporterProgressive ];
    meta = {
      description = "Execute code after a scope finished compilation";
      homepage = "https://github.com/karenetheridge/B-Hooks-EndOfScope";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPAnnotation = buildPerlPackage {
    pname = "B-Hooks-OP-Annotation";
    version = "0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/B-Hooks-OP-Annotation-0.44.tar.gz";
      sha256 = "6e26f99367f4ea944169cf6e05cf4d067832082424ca8ecefccb7b5a63217b16";
    };
    propagatedBuildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Annotate and delegate hooked OPs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPCheck = buildPerlPackage {
    pname = "B-Hooks-OP-Check";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz";
      sha256 = "1kfdv25gn6yik8jrwik4ajp99gi44s6idcvyyrzhiycyynzd3df7";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Wrap OP check callbacks";
      homepage = "https://github.com/karenetheridge/B-Hooks-OP-Check";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BioPerl = buildPerlPackage {
    pname = "BioPerl";
    version = "1.7.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz";
      sha256 = "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738";
    };
    buildInputs = [ ModuleBuild TestMemoryCycle TestWeaken TestDeep TestWarn TestException TestDifferences ];
    propagatedBuildInputs = [ DataStag Error Graph HTTPMessage IOString IOStringy IPCRun LWP ListMoreUtils SetScalar TestMost TestRequiresInternet URI XMLDOM XMLLibXML XMLSAX XMLSAXBase XMLSAXWriter XMLTwig XMLWriter YAML DBFile libxml_perl ];
    meta = {
      description = "Perl modules for biology";
      homepage = "https://metacpan.org/release/BioPerl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BitVector = buildPerlPackage {
    pname = "Bit-Vector";
    version = "7.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-7.4.tar.gz";
      sha256 = "09m96p8c0ipgz42li2ywdgy0vxb57mb5nf59j9gw7yzc3xkslv9w";
    };
    propagatedBuildInputs = [ CarpClan ];
  };

  BKeywords = buildPerlPackage rec {
    pname = "B-Keywords";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/B-Keywords-1.24.tar.gz";
      sha256 = "sha256-pc9rsoXQbRfO4id4O3I7snQhP9QVOl3uMR0kDhFpYG4=";
    };
    meta = {
      description = "Lists of reserved barewords and symbol names";
      license = with lib.licenses; [ artistic1 gpl2 ];
    };
  };

  boolean = buildPerlPackage {
    pname = "boolean";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/boolean-0.46.tar.gz";
      sha256 = "95c088085c3e83bf680fe6ce16d8264ec26310490f7d1680e416ea7a118f156a";
    };
    meta = {
      description = "Boolean support for Perl";
      homepage = "https://github.com/ingydotnet/boolean-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BoostGeometryUtils = buildPerlModule {
    pname = "Boost-Geometry-Utils";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/Boost-Geometry-Utils-0.15.tar.gz";
      sha256 = "1jnihz3029x51a455nxa0jx2z125x38q3vkkggsgdlrvawzxsm00";
    };
    patches = [
      # Fix out of memory error on Perl 5.19.4 and later.
      ../development/perl-modules/boost-geometry-utils-fix-oom.patch
    ];
    perlPreHook = "export LD=$CC";
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp ];
  };

  BotTraining = buildPerlPackage {
    pname = "Bot-Training";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-0.07.tar.gz";
      sha256 = "ee66bbf814f0dc3d1e80680e050fad10b1e018fed7929f653ed40e088b2aa295";
    };
    buildInputs = [ FileSlurp ];
    propagatedBuildInputs = [ ClassLoad DirSelf FileShareDir ModulePluggable MooseXGetopt namespaceclean  ];
    meta = {
      description = "Plain text training material for bots like Hailo and AI::MegaHAL";
      homepage = "http://metacpan.org/release/Bot-Training";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "bot-training";
    };
  };

  BotTrainingMegaHAL = buildPerlPackage {
    pname = "Bot-Training-MegaHAL";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-MegaHAL-0.03.tar.gz";
      sha256 = "956072aff04f216e5c3b8196965b5d80d4d47695d77ecaabd56e59d65f22bf60";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ BotTraining ];
    meta = {
      description = "Provide megahal.trn via Bot::Training";
      homepage = "http://metacpan.org/release/Bot-Training-MegaHAL";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BotTrainingStarCraft = buildPerlPackage {
    pname = "Bot-Training-StarCraft";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-StarCraft-0.03.tar.gz";
      sha256 = "e7ceb8d01c62e732dd89bfe5f4d83e781c1cd912542d177c22e761b7c8614d5e";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ BotTraining ];
    meta = {
      description = "Provide starcraft.trn via Bot::Training";
      homepage = "http://metacpan.org/release/Bot-Training-StarCraft";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BSDResource = buildPerlPackage {
    pname = "BSD-Resource";
    version = "1.2911";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/BSD-Resource-1.2911.tar.gz";
      sha256 = "0g8c7825ng2m0yz5sy6838rvfdl8j3vm29524wjgf66ccfhgn74x";
    };
    meta = {
      description = "BSD process resource limit and priority functions";
      license = with lib.licenses; [ artistic2 ];
      maintainers = teams.deshaw.members;
    };
  };

  BSON = buildPerlPackage {
    pname = "BSON";
    version = "1.12.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MONGODB/BSON-v1.12.2.tar.gz";
      sha256 = "f4612c0c354310741b99ab6d26451226823150ca27109b1b391232d5cfdda6db";
    };
    buildInputs = [ JSONMaybeXS PathTiny TestDeep TestFatal ];
    propagatedBuildInputs = [ CryptURandom Moo TieIxHash boolean namespaceclean ];
    meta = {
      description = "BSON serialization and deserialization (EOL)";
      homepage = "https://github.com/mongodb-labs/mongo-perl-bson";
      license = with lib.licenses; [ asl20 ];
    };
  };

  BSONXS = buildPerlPackage {
    pname = "BSON-XS";
    version = "0.8.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MONGODB/BSON-XS-v0.8.4.tar.gz";
      sha256 = "28f7d338fd78b6f9c9a6080be9de3f5cb23d888b96ebf6fcbface9f2966aebf9";
    };
    buildInputs = [ ConfigAutoConf JSONMaybeXS PathTiny TestDeep TestFatal TieIxHash ];
    propagatedBuildInputs = [ BSON boolean JSONXS JSONPP CpanelJSONXS ];
    meta = {
      description = "XS implementation of MongoDB's BSON serialization (EOL)";
      homepage = "https://github.com/mongodb-labs/mongo-perl-bson-xs";
      license = with lib.licenses; [ asl20 ];
      platforms = lib.platforms.linux; # configure phase fails with "ld: unknown option: -mmacosx-version-min=10.12"
    };
  };

  BUtils = buildPerlPackage {
    pname = "B-Utils";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Utils-0.27.tar.gz";
      sha256 = "1spzhmk3z6c4blmra3kn84nq20fira2b3vjg86m0j085lgv56zzr";
    };
    propagatedBuildInputs = [ TaskWeaken ];
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Helper functions for op tree manipulation";
      homepage = "http://search.cpan.org/dist/B-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessHours = buildPerlPackage {
    pname = "Business-Hours";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Business-Hours-0.13.tar.gz";
      sha256 = "1hiybixagj3i1hsnfr134jgs9wv4azkwq6kijr9zlkxqzczzw1x8";
    };
    propagatedBuildInputs = [ SetIntSpan ];
    meta = {
      description = "Calculate business hours in a time period";
      license = with lib.licenses; [ unfree ];
    };
  };

  BusinessISBN = buildPerlPackage {
    pname = "Business-ISBN";
    version = "3.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-3.005.tar.gz";
      sha256 = "0aifzqj3xvxi8x0103ddpb2bagfsz15c71k69vdpcqy582pgnc35";
    };
    propagatedBuildInputs = [ BusinessISBNData ];
    meta = {
      description = "Work with International Standard Book Numbers";
      homepage = "https://github.com/briandfoy/business-isbn";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  BusinessISBNData = buildPerlPackage {
    pname = "Business-ISBN-Data";
    version = "20191107";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-Data-20191107.tar.gz";
      sha256 = "03faqnxx7qxgr2dcdra2iq60ziilpkas2ra41cs8klwky5j4yk44";
    };
    meta = {
      description = "Data pack for Business::ISBN";
      homepage = "https://github.com/briandfoy/business-isbn-data";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  BusinessISMN = buildPerlPackage {
    pname = "Business-ISMN";
    version = "1.201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISMN-1.201.tar.gz";
      sha256 = "1cpcfyaz1fl6fnm076jx2jsphw147wj6aszj2yzqrgsncjhk2cja";
    };
    propagatedBuildInputs = [ TieCycle ];
    meta = {
      description = "Work with International Standard Music Numbers";
      homepage = "https://github.com/briandfoy/business-ismn";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  BusinessISSN = buildPerlPackage {
    pname = "Business-ISSN";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISSN-1.004.tar.gz";
      sha256 = "97ecab15d24d11e2852bf0b28f84c8798bd38402a0a69e17be0e6689b272715e";
    };
    meta = {
      description = "Perl extension for International Standard Serial Numbers";
      homepage = "https://github.com/briandfoy/business-issn";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  BytesRandomSecure = buildPerlPackage {
    pname = "Bytes-Random-Secure";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVIDO/Bytes-Random-Secure-0.29.tar.gz";
      sha256 = "53bbd339e6a11efca07c619a615c7c188a68bb2be849a1cb7efc3dd4d9ae85ae";
    };
    propagatedBuildInputs = [ CryptRandomSeed MathRandomISAAC ];
    meta = {
      description = "Perl extension to generate cryptographically-secure random bytes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  BytesRandomSecureTiny = buildPerlPackage {
    pname = "Bytes-Random-Secure-Tiny";
    version = "1.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVIDO/Bytes-Random-Secure-Tiny-1.011.tar.gz";
      sha256 = "03d967b5f82846909137d5ab9984ac570ac10a4401e0c602f3d2208c465ac982";
    };
    meta = {
      description = "A tiny Perl extension to generate cryptographically-secure random bytes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CacheCache = buildPerlPackage {
    pname = "Cache-Cache";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Cache-Cache-1.08.tar.gz";
      sha256 = "1s6i670dc3yb6ngvdk48y6szdk5n1f4icdcjv2vi1l2xp9fzviyj";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
    doCheck = false; # randomly fails
  };

  CacheFastMmap = buildPerlPackage {
    pname = "Cache-FastMmap";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.54.tar.gz";
      sha256 = "0lkrsr582h714jpmh5dv4szz5f7rm466xqxbavj7l9w0p40f4him";
    };
    buildInputs = [ TestDeep ];
  };

  CacheKyotoTycoon = buildPerlModule {
    pname = "Cache-KyotoTycoon";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Cache-KyotoTycoon-0.16.tar.gz";
      sha256 = "0z4lnc3jfqx8rykm998q2jy5wkhb8p5pir80g9lqpi4lb0ilic6c";
    };
    propagatedBuildInputs = [ Furl URI ];
    buildInputs = [ FileWhich TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "KyotoTycoon client library";
      homepage = "https://github.com/tokuhirom/Cache-KyotoTycoon";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheMemcached = buildPerlPackage {
    pname = "Cache-Memcached";
    version = "1.30";
    src = fetchurl {
      url =
      "mirror://cpan/authors/id/D/DO/DORMANDO/Cache-Memcached-1.30.tar.gz";
      sha256 = "1aa2mjn5767b13063nnsrwcikrnbspby7j1c5q007bzaq0gcbcri";
    };
    propagatedBuildInputs = [ StringCRC32 ];
  };

  CacheMemcachedFast = buildPerlPackage {
    pname = "Cache-Memcached-Fast";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RAZ/Cache-Memcached-Fast-0.26.tar.gz";
      sha256 = "16m0xafidycrlcvbv3zmbr5pzvqyqyr2qb0khpry99nc4bcld3jy";
    };
    meta = {
      description = "Perl client for memcached, in C language";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheMemory = buildPerlModule {
    pname = "Cache";
    version = "2.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Cache-2.11.tar.gz";
      sha256 = "14m513f4g02daklmnvdm7vqh3w3ick65wvmvqnmnc4cqfybdilp1";
    };
    propagatedBuildInputs = [ DBFile FileNFSLock HeapFibonacci IOString TimeDate ];
    doCheck = false; # can time out
  };

  CacheSimpleTimedExpiry = buildPerlPackage {
    pname = "Cache-Simple-TimedExpiry";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Cache-Simple-TimedExpiry-0.27.tar.gz";
      sha256 = "4e78b7e4dd231b5571a48cd0ee1b63953f5e34790c9d020e1595a7c7d0abbe49";
    };
    meta = {
      description = "A lightweight cache with timed expiration";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Cairo = buildPerlPackage {
    pname = "Cairo";
    version = "1.108";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Cairo-1.108.tar.gz";
      sha256 = "1nh5iya63q6j2w0cdi24x2ygpi8k8wwccnbh8cisnx8nqmywnhk0";
    };
    buildInputs = [ pkgs.cairo ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
    meta = {
      description = "Perl interface to the cairo 2d vector graphics library";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  CairoGObject = buildPerlPackage {
    pname = "Cairo-GObject";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Cairo-GObject-1.005.tar.gz";
      sha256 = "0l2wcz77ndmbgvxx34gdm919a3dxh9fixqr47p50n78ysx2692cd";
    };
    buildInputs = [ pkgs.cairo ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      description = "Integrate Cairo into the Glib type system";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  CallContext = buildPerlPackage {
    pname = "Call-Context";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Call-Context-0.03.tar.gz";
      sha256 = "0ee6bf46bc72755adb7a6b08e79d12e207de5f7809707b3c353b58cb2f0b5a26";
    };
    meta = {
      description = "Sanity-check calling context";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  cam_pdf = buildPerlModule {
    pname = "CAM-PDF";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CD/CDOLAN/CAM-PDF-1.60.tar.gz";
      sha256 = "12dv5ssf3y7yjz9mrrqnfzx8nf4ydk1qijf5fx59495671zzqsp7";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
  };

  capitalization = buildPerlPackage {
    pname = "capitalization";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/capitalization-0.03.tar.gz";
      sha256 = "0g7fpckydzxsf8mjkfbyj0pv42dzym4hwbizqahnh7wlfbaicdgi";
    };
    propagatedBuildInputs = [ DevelSymdump ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  CanaryStability = buildPerlPackage {
    pname = "Canary-Stability";
    version = "2013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz";
      sha256 = "a5c91c62cf95fcb868f60eab5c832908f6905221013fea2bce3ff57046d7b6ea";
    };
    meta = {
      license = with lib.licenses; [ gpl1Plus ];
    };
  };

  CaptchaReCAPTCHA = buildPerlPackage {
    pname = "Captcha-reCaptcha";
    version = "0.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SUNNYP/Captcha-reCaptcha-0.99.tar.gz";
      sha256 = "14j3lk6fhfzda5d3d7z6f373ng3fzxazzwpjyziysrhic1v3b4mq";
    };
    propagatedBuildInputs = [ HTMLTiny LWP ];
  };

  CaptureTiny = buildPerlPackage {
    pname = "Capture-Tiny";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
      sha256 = "069yrikrrb4vqzc3hrkkfj96apsh7q0hg8lhihq97lxshwz128vc";
    };
    meta = {
      description = "Capture STDOUT and STDERR from Perl, XS or external programs";
      homepage = "https://github.com/dagolden/Capture-Tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  CarpAlways = buildPerlPackage {
    pname = "Carp-Always";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Carp-Always-0.16.tar.gz";
      sha256 = "1wb6b0qjga7kvn4p8df6k4g1pl2yzaqiln1713xidh3i454i3alq";
    };
    buildInputs = [ TestBase ];
    meta = {
      description = "Warns and dies noisily with stack backtraces";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAssert = buildPerlPackage {
    pname = "Carp-Assert";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Carp-Assert-0.21.tar.gz";
      sha256 = "0km5fc6r6whxh6h5yd7g1j0bi96sgk0gkda6cardicrw9qmqwkwj";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAssertMore = buildPerlPackage {
    pname = "Carp-Assert-More";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-1.24.tar.gz";
      sha256 = "0axjfl1hp7s4lcfxjj41zcp397dzhjqzd95innzxnz914xkc2p5s";
    };
    propagatedBuildInputs = [ CarpAssert ];
    buildInputs = [ TestException ];
    meta = {
      license = with lib.licenses; [ artistic2 ];
    };
  };

  CarpClan = buildPerlPackage {
    pname = "Carp-Clan";
    version = "6.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Carp-Clan-6.08.tar.gz";
      sha256 = "0237xx3rqa72sr4vdvws9r1m453h5f25bl85mdjmmk128kir4py7";
    };
    meta = {
      description = "Report errors from perspective of caller of a \"clan\" of modules";
      homepage = "https://github.com/karenetheridge/Carp-Clan";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Carton = buildPerlPackage {
    pname = "Carton";
    version = "1.0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Carton-v1.0.34.tar.gz";
      sha256 = "77d42b92732bcfc18a59d341e56ce476205b1c4d380eab3a07224f5745c23e45";
    };
    propagatedBuildInputs = [ MenloLegacy PathTiny TryTiny ];
    meta = {
      description = "Perl module dependency manager (aka Bundler for Perl)";
      homepage = "https://github.com/perl-carton/carton";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "carton";
    };
  };

  CatalystActionRenderView = buildPerlPackage {
    pname = "Catalyst-Action-RenderView";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Action-RenderView-0.16.tar.gz";
      sha256 = "8565203950a057d43ecd64e9593715d565c2fbd8b02c91f43c53b2111acd3948";
    };
    propagatedBuildInputs = [ CatalystRuntime DataVisitor ];
    buildInputs = [ HTTPRequestAsCGI ];
    meta = {
      description = "Sensible default end action";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystActionREST = buildPerlPackage {
    pname = "Catalyst-Action-REST";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Action-REST-1.21.tar.gz";
      sha256 = "ccf81bba5200d3a0ad6901f923af173a3d4416618aea08a6938baaffdef4cb20";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CatalystRuntime URIFind ];
    meta = {
      description = "Automated REST Method Dispatching";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationCredentialHTTP = buildPerlModule {
    pname = "Catalyst-Authentication-Credential-HTTP";
    version = "1.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Catalyst-Authentication-Credential-HTTP-1.018.tar.gz";
      sha256 = "0ad5clfiyllnf37an99n139cxhhxf5g5rh8cxashsjv4xrnq38bg";
    };
    buildInputs = [ ModuleBuildTiny TestException TestMockObject TestNeeds ];
    propagatedBuildInputs = [ CatalystPluginAuthentication ClassAccessor DataUUID StringEscape ];
    meta = {
      description = "HTTP Basic and Digest authentication for Catalyst";
      homepage = "https://github.com/perl-catalyst/Catalyst-Authentication-Credential-HTTP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationStoreHtpasswd = buildPerlModule {
    pname = "Catalyst-Authentication-Store-Htpasswd";
    version = "1.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Catalyst-Authentication-Store-Htpasswd-1.006.tar.gz";
      sha256 = "0kw0w2g1qmym896bgnqr1bfhvgb6xja39mv10701ipp8fmi8bzf7";
    };
    buildInputs = [ ModuleBuildTiny TestLongString TestSimple13 TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ AuthenHtpasswd CatalystPluginAuthentication ];
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    pname = "Catalyst-Authentication-Store-DBIx-Class";
    version = "0.1506";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-DBIx-Class-0.1506.tar.gz";
      sha256 = "0i5ja7690fs9nhxcij6lw51j804sm8s06m5mvk1n8pi8jljrymvw";
    };
    propagatedBuildInputs = [ CatalystModelDBICSchema CatalystPluginAuthentication ];
    buildInputs = [ TestWarn ];
    meta = {
      description = "Extensible and flexible object <-> relational mapper";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationStoreLDAP = buildPerlPackage {
    pname = "Catalyst-Authentication-Store-LDAP";
    version = "1.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-LDAP-1.016.tar.gz";
      sha256 = "0cm399vxqqf05cjgs1j5v3sk4qc6nmws5nfhf52qvpbwc4m82mq8";
    };
    propagatedBuildInputs = [ perlldap CatalystPluginAuthentication ClassAccessor ];
    buildInputs = [ TestMockObject TestException NetLDAPServerTest ];
    doCheck = !stdenv.isDarwin; # t/02-realms_api.t and t/50.auth.case.sensitivity.t
    meta = {
      description = "Authenticate Users against LDAP Directories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystComponentInstancePerContext = buildPerlPackage {
    pname = "Catalyst-Component-InstancePerContext";
    version = "0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/Catalyst-Component-InstancePerContext-0.001001.tar.gz";
      sha256 = "7f63f930e1e613f15955c9e6d73873675c50c0a3bc2a61a034733361ed26d271";
    };
    propagatedBuildInputs = [ CatalystRuntime ];
    meta = {
      description = "Moose role to create only one instance of component per context";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerHTMLFormFu = buildPerlPackage {
    pname = "Catalyst-Controller-HTML-FormFu";
    version = "2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIGELM/Catalyst-Controller-HTML-FormFu-2.04.tar.gz";
      sha256 = "f13fb9b3b3b00b35f06abc31614461c8d7346fbe07fb569c71e8d586e5eb5ddc";
    };
    buildInputs = [ CatalystActionRenderView CatalystPluginSession CatalystPluginSessionStateCookie CatalystPluginSessionStoreFile CatalystViewTT CodeTidyAllPluginPerlAlignMooseAttributes PodCoverageTrustPod PodTidy TemplateToolkit TestCPANMeta TestDifferences TestEOL TestKwalitee TestLongString TestMemoryCycle TestNoTabs TestPAUSEPermissions TestPod TestPodCoverage TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystComponentInstancePerContext HTMLFormFuMultiForm RegexpAssemble ];
    doCheck = false; /* fails with 'open3: exec of .. perl .. failed: Argument list too long at .../TAP/Parser/Iterator/Process.pm line 165.' */
    meta = {
      description = "HTML Form Creation, Rendering and Validation Framework";
      homepage = "https://github.com/FormFu/HTML-FormFu";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystControllerPOD = buildPerlModule {
    pname = "Catalyst-Controller-POD";
    version = "1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/Catalyst-Controller-POD-1.0.0.tar.gz";
      sha256 = "ee2a4bb3ed78baa1464335408f284345b6ba0ef6576ad7bfbd7b656c788a39f9";
    };
    buildInputs = [ ModuleInstall TestLongString TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystPluginStaticSimple ClassAccessor FileSlurp JSONXS ListMoreUtils PodPOMViewTOC XMLSimple ];
    meta = {
      description = "Serves PODs right from your Catalyst application";
      homepage = "http://search.cpan.org/dist/Catalyst-Controller-POD";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  CatalystDevel = buildPerlPackage {
    pname = "Catalyst-Devel";
    version = "1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Devel-1.42.tar.gz";
      sha256 = "1gcaqivyxwsdq87v9za1ijjibh6llirzqsbpwjbw1f5mravg1iky";
    };
    buildInputs = [ FileShareDirInstall TestFatal ];
    propagatedBuildInputs = [ CatalystActionRenderView CatalystPluginConfigLoader CatalystPluginStaticSimple ConfigGeneral FileChangeNotify FileCopyRecursive ModuleInstall TemplateToolkit ];
    meta = {
      description = "Catalyst Development Tools";
      homepage = "http://dev.catalyst.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystDispatchTypeRegex = buildPerlModule {
    pname = "Catalyst-DispatchType-Regex";
    version = "5.90035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGRIMES/Catalyst-DispatchType-Regex-5.90035.tar.gz";
      sha256 = "06jq1lmpq88rmp9zik5gqczg234xac0hiyc3l698iif7zsgcyb80";
    };
    propagatedBuildInputs = [ CatalystRuntime ];
    meta = {
      description = "Regex DispatchType";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystManual = buildPerlPackage {
    pname = "Catalyst-Manual";
    version = "5.9011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Manual-5.9011.tar.gz";
      sha256 = "0g61za6844ya0lk0bpvw43sj0jd553aks3hqw21hbh03b6b377mk";
    };
    meta = {
      description = "The Catalyst developer's manual";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystModelDBICSchema = buildPerlPackage {
    pname = "Catalyst-Model-DBIC-Schema";
    version = "0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBJK/Catalyst-Model-DBIC-Schema-0.65.tar.gz";
      sha256 = "26a911ef5ef7ffc81b6ce65c3156f71fb35083c456ad27e6d82d2dc02493eeea";
    };
    buildInputs = [ DBDSQLite TestException TestRequires ];
    propagatedBuildInputs = [ CatalystComponentInstancePerContext CatalystXComponentTraits DBIxClassSchemaLoader MooseXMarkAsMethods MooseXNonMoose MooseXTypesLoadableClass TieIxHash ];
    meta = {
      description = "DBIx::Class::Schema Model Class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystRuntime = buildPerlPackage {
    pname = "Catalyst-Runtime";
    version = "5.90128";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Runtime-5.90128.tar.gz";
      sha256 = "1yb0caagdrl7c1ldkwaz6w2qpgj8wcibzhqh6yscarjzmw6kppx6";
    };
    buildInputs = [ TestFatal TypeTiny ];
    propagatedBuildInputs = [ CGISimple CGIStruct ClassC3AdoptNEXT DataDump HTTPBody ModulePluggable MooseXEmulateClassAccessorFast MooseXGetopt MooseXMethodAttributes MooseXRoleWithOverloading PathClass PerlIOutf8_strict PlackMiddlewareFixMissingBodyInRedirect PlackMiddlewareMethodOverride PlackMiddlewareRemoveRedundantBody PlackMiddlewareReverseProxy PlackTestExternalServer SafeIsa StringRewritePrefix TaskWeaken TextSimpleTable TreeSimpleVisitorFactory URIws ];
    meta = {
      description = "The Catalyst Framework Runtime";
      homepage = "http://dev.catalyst.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "catalyst.pl";
    };
  };

  CatalystPluginAccessLog = buildPerlPackage {
    pname = "Catalyst-Plugin-AccessLog";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/Catalyst-Plugin-AccessLog-1.10.tar.gz";
      sha256 = "873db8e4e72a994e3e17aeb53d2b837e6d524b4b8b0f3539f262135c88cc2120";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime ];
    meta = {
      description = "Request logging from within Catalyst";
      homepage = "http://metacpan.org/release/Catalyst-Plugin-AccessLog";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthentication = buildPerlPackage {
    pname = "Catalyst-Plugin-Authentication";
    version = "0.10023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authentication-0.10023.tar.gz";
      sha256 = "0v6hb4r1wv3djrnqvnjcn3xx1scgqzx8nyjdg9lfc1ybvamrl0rn";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CatalystPluginSession ];
    meta = {
      description = "Infrastructure plugin for the Catalyst authentication framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthorizationACL = buildPerlPackage {
    pname = "Catalyst-Plugin-Authorization-ACL";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/Catalyst-Plugin-Authorization-ACL-0.16.tar.gz";
      sha256 = "0z4328rr6l9xi45hyv6q9pwwamp0864q6skcp29jrz9f919ycdra";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassThrowable ];
    buildInputs = [ CatalystPluginAuthentication CatalystPluginAuthorizationRoles CatalystPluginSession CatalystPluginSessionStateCookie TestWWWMechanizeCatalyst ];
  };

  CatalystPluginAuthorizationRoles = buildPerlPackage {
    pname = "Catalyst-Plugin-Authorization-Roles";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authorization-Roles-0.09.tar.gz";
      sha256 = "0l83lkwmq0lngwh8b1rv3r719pn8w1gdbyhjqm74rnd0wbjl8h7f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CatalystPluginAuthentication SetObject UNIVERSALisa ];
    meta = {
      description = "Role based authorization for Catalyst based on Catalyst::Plugin::Authentication";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginCache = buildPerlPackage {
    pname = "Catalyst-Plugin-Cache";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Cache-0.12.tar.gz";
      sha256 = "1q23aipvrl888h06ldr4mmjbykz0j4rqwipxg1jv094kki2fspr9";
    };
    buildInputs = [ ClassAccessor TestDeep TestException ];
    propagatedBuildInputs = [ CatalystRuntime ];
    meta = {
      description = "Flexible caching support for Catalyst";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginCacheHTTP = buildPerlPackage {
    pname = "Catalyst-Plugin-Cache-HTTP";
    version = "0.001000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRAF/Catalyst-Plugin-Cache-HTTP-0.001000.tar.gz";
      sha256 = "0v5iphbq4csc4r6wkvxnqlh97p8g0yhjky9qqmsdyqczn87agbba";
    };
    buildInputs = [ CatalystRuntime TestLongString TestSimple13 TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ ClassAccessor HTTPMessage MROCompat ];
    meta = {
      description = "HTTP/1.1 cache validators for Catalyst";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginCaptcha = buildPerlPackage {
    pname = "Catalyst-Plugin-Captcha";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DI/DIEGOK/Catalyst-Plugin-Captcha-0.04.tar.gz";
      sha256 = "0llyj3v5nx9cx46jdbbvxf1lc9s9cxq5ml22xmx3wkb201r5qgaa";
    };
    propagatedBuildInputs = [ CatalystPluginSession GDSecurityImage ];
    meta = {
      description = "Create and validate Captcha for Catalyst";
      license = with lib.licenses; [ unfree ];
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage {
    pname = "Catalyst-Plugin-ConfigLoader";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Plugin-ConfigLoader-0.35.tar.gz";
      sha256 = "0w8r3bbxqnlykvra6sx3sh3wh8ylkj914xg5ql6nw11ddy56jaly";
    };
    propagatedBuildInputs = [ CatalystRuntime ConfigAny DataVisitor ];
  };

  CatalystPluginFormValidator = buildPerlPackage {
    pname = "Catalyst-Plugin-FormValidator";
    version = "0.094";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/Catalyst-Plugin-FormValidator-0.094.tar.gz";
      sha256 = "5834f11bf5c9f4b5d336d65c7ce6639b76ce7bfe7a2875eb048d7ea1c82ce05a";
    };
    propagatedBuildInputs = [ CatalystRuntime DataFormValidator ];
    meta = {
      description = "Data::FormValidator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginFormValidatorSimple = buildPerlPackage {
    pname = "Catalyst-Plugin-FormValidator-Simple";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/Catalyst-Plugin-FormValidator-Simple-0.15.tar.gz";
      sha256 = "486c6a0e8f410fd017279f4804ab9e35ba46321d33a0a9721fe1e08a391de7a0";
    };
    propagatedBuildInputs = [ CatalystPluginFormValidator FormValidatorSimple ];
    meta = {
      description = "Validation with simple chains of constraints ";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginLogHandler = buildPerlModule {
    pname = "Catalyst-Plugin-Log-Handler";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEPE/Catalyst-Plugin-Log-Handler-0.08.tar.gz";
      sha256 = "0db3c3a57b4ee3d789ba5129890e2858913fef00d8185bdc9c5d7fde31e043ef";
    };
    propagatedBuildInputs = [ ClassAccessor LogHandler MROCompat ];
    meta = {
      description = "Log messages to several outputs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginPrometheusTiny = buildPerlPackage {
    pname = "Catalyst-Plugin-PrometheusTiny";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYSPETE/Catalyst-Plugin-PrometheusTiny-0.006.tar.gz";
      sha256 = "1hd2nv21c2mq3yvhsys4a276bdwr5igs4b73m99v7ymzpabvjf9b";
    };
    buildInputs = [ HTTPMessage Plack SubOverride TestDeep ];
    propagatedBuildInputs = [ CatalystRuntime Moose PrometheusTiny PrometheusTinyShared ];
    meta = {
      description = "A tiny Prometheus client";
      homepage = "https://github.com/robn/Prometheus-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSession = buildPerlPackage {
    pname = "Catalyst-Plugin-Session";
    version = "0.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Plugin-Session-0.41.tar.gz";
      sha256 = "0a451997zc2vjx7rvndgx1ldbrpic8sfbddyvncynh0zr8bhlqc5";
    };
    buildInputs = [ TestDeep TestException TestWWWMechanizePSGI ];
    propagatedBuildInputs = [ CatalystRuntime ObjectSignature ];
    meta = {
      description = "Generic Session plugin - ties together server side storage and client side state required to maintain session data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionDynamicExpiry = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-DynamicExpiry";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Session-DynamicExpiry-0.04.tar.gz";
      sha256 = "7707c56734cdb1512f733dc400fadf6f4c53cb217b58207857824dad6780a079";
    };
    propagatedBuildInputs = [ CatalystPluginSession ];
    meta = {
      description = "Per-session custom expiry times";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionStateCookie = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-State-Cookie";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Plugin-Session-State-Cookie-0.18.tar.gz";
      sha256 = "1skvw3i9wv02kz1bz937zh7wfxvhf54i8zppln3ly6bcp6rcgcg9";
    };
    propagatedBuildInputs = [ CatalystPluginSession ];
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-Store-FastMmap";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Session-Store-FastMmap-0.16.tar.gz";
      sha256 = "0x3j6zv3wr41jlwr6yb2jpmcx019ibyn11y8653ffnwhpzbpzsxs";
    };
    propagatedBuildInputs = [ CacheFastMmap CatalystPluginSession ];
  };

  CatalystPluginSessionStoreFile = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-Store-File";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Catalyst-Plugin-Session-Store-File-0.18.tar.gz";
      sha256 = "54738e3ce76f8be8b66947092d28973c73d79d1ee19b5d92b057552f8ff09b4f";
    };
    propagatedBuildInputs = [ CacheCache CatalystPluginSession ClassDataInheritable ];
    meta = {
      description = "File storage backend for session data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSmartURI = buildPerlPackage {
    pname = "Catalyst-Plugin-SmartURI";
    version = "0.041";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/Catalyst-Plugin-SmartURI-0.041.tar.gz";
      sha256 = "0msz3w2vfdb5w4ixi5llq66xlhm0181gjz9xj8yj0lalk232326b";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassC3Componentised ];
    buildInputs = [ CatalystActionREST TestWarnings TimeOut URISmartURI ];
    meta = {
      description = "Configurable URIs for Catalyst";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginStackTrace = buildPerlPackage {
    pname = "Catalyst-Plugin-StackTrace";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-StackTrace-0.12.tar.gz";
      sha256 = "1b2ksz74cpigxqzf63rddar3vfmnbpwpdcbs11v0ml89pb8ar79j";
    };
    propagatedBuildInputs = [ CatalystRuntime ];
    meta = {
      description = "Display a stack trace on the debug screen";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginStaticSimple = buildPerlPackage {
    pname = "Catalyst-Plugin-Static-Simple";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Plugin-Static-Simple-0.36.tar.gz";
      sha256 = "0m4l627p2fvzr4i6sgdxhdvsx4wpa6qmaibsbxlg5x5yjs7k7drn";
    };
    patches = [ ../development/perl-modules/catalyst-plugin-static-simple-etag.patch ];
    propagatedBuildInputs = [ CatalystRuntime MIMETypes MooseXTypes ];
    meta = {
      description = "Make serving static pages painless";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginStatusMessage = buildPerlPackage {
    pname = "Catalyst-Plugin-StatusMessage";
    version = "1.002000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/Catalyst-Plugin-StatusMessage-1.002000.tar.gz";
      sha256 = "649c894ab16f9f48ada8f9cc599a7ecbb8891ab3761ff6fd510520c6de407c1f";
    };
    propagatedBuildInputs = [ CatalystRuntime strictures ];
    meta = {
      description = "Handle passing of status (success and error) messages between screens of a web application";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewCSV = buildPerlPackage {
    pname = "Catalyst-View-CSV";
    version = "1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MC/MCB/Catalyst-View-CSV-1.7.tar.gz";
      sha256 = "e41326b6099891f244b432921ed10096ac619f32b8c4f8b41633313bd54662db";
    };
    buildInputs = [ CatalystActionRenderView CatalystModelDBICSchema CatalystPluginConfigLoader CatalystXComponentTraits ConfigGeneral DBDSQLite DBIxClass TestException ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV ];
    meta = {
      description = "CSV view class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewDownload = buildPerlPackage {
    pname = "Catalyst-View-Download";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/Catalyst-View-Download-0.09.tar.gz";
      sha256 = "1qgq6y9iwfbhbkbgpw9czang2ami6z8jk1zlagrzdisy4igqzkvs";
    };
    buildInputs = [ CatalystRuntime TestLongString TestSimple13 TestWWWMechanize TestWWWMechanizeCatalyst TextCSV XMLSimple ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewJSON = buildPerlPackage {
    pname = "Catalyst-View-JSON";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-View-JSON-0.37.tar.gz";
      sha256 = "1v4xkzazs743sc7cd1kxkbi99cf00a4dadyyancckcbpi9p3znn5";
    };
    propagatedBuildInputs = [ CatalystRuntime ];
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewTT = buildPerlPackage {
    pname = "Catalyst-View-TT";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-View-TT-0.45.tar.gz";
      sha256 = "0jzgpkgq5pwq82zlb0nykdyk40dfpsyn9ilz91d0wpixgi9i5pr8";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassAccessor TemplateTimer ];
    meta = {
      description = "Template View Class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystXComponentTraits = buildPerlPackage {
    pname = "CatalystX-Component-Traits";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/CatalystX-Component-Traits-0.19.tar.gz";
      sha256 = "0iq4ci8m6g2c4g01fvdl568y7pjz28f3widk986v3pyhr7ll8j88";
    };
    propagatedBuildInputs = [ CatalystRuntime MooseXTraitsPluggable ];
  };

  CatalystXRoleApplicator = buildPerlPackage {
    pname = "CatalystX-RoleApplicator";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/CatalystX-RoleApplicator-0.005.tar.gz";
      sha256 = "0vwaapxn8g5hs2xp63c4dwv9jmapmji4272fakssvgc9frklg3p2";
    };
    propagatedBuildInputs = [ CatalystRuntime MooseXRelatedClassRoles ];
  };

  CatalystTraitForRequestProxyBase = buildPerlPackage {
    pname = "Catalyst-TraitFor-Request-ProxyBase";
    version = "0.000005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-TraitFor-Request-ProxyBase-0.000005.tar.gz";
      sha256 = "a7bf0faa7e12ca5df625d9f5fc710f11bfd16ba5385837e48d42b3d286c9710a";
    };
    buildInputs = [ CatalystRuntime CatalystXRoleApplicator HTTPMessage ];
    propagatedBuildInputs = [ Moose URI namespaceautoclean ];
    meta = {
      description = "Replace request base with value passed by HTTP proxy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystXScriptServerStarman = buildPerlPackage {
    pname = "CatalystX-Script-Server-Starman";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABRAXXA/CatalystX-Script-Server-Starman-0.03.tar.gz";
      sha256 = "08jvibq4v8xjj0c3cr93h0w8w0c88ajwjn37xjy7ygxl9krlffp6";
    };
    patches = [
      # See Nixpkgs issues #16074 and #17624
      ../development/perl-modules/CatalystXScriptServerStarman-fork-arg.patch
    ];
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime MooseXTypes PodParser Starman ];
    meta = {
      description = "Replace the development server with Starman";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CDB_File = buildPerlPackage {
    pname = "CDB_File";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/CDB_File-1.05.tar.gz";
      sha256 = "0jzbm59b9q51k00djr1b8c4vjvjkwb577r946vi5s09rasfq8r45";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ BCOW ];
    meta = {
      description = "Perl extension for access to cdb databases";
      homepage = "https://github.com/toddr/CDB_File";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Catmandu = buildPerlModule {
    pname = "Catmandu";
    version = "1.2013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NICS/Catmandu-1.2013.tar.gz";
      sha256 = "0sh4qqjh53rhqcpbvq3pyg0k1ybs8qxivhc1an6w5hjar2bihwiq";
    };
    propagatedBuildInputs = [ AnyURIEscape AppCmd CGIExpand ConfigOnion CpanelJSONXS DataCompare DataUtil IOHandleUtil LWP ListMoreUtils LogAny MIMETypes ModuleInfo MooXAliases ParserMGC PathIteratorRule PathTiny StringCamelCase TextCSV TextHogan Throwable TryTinyByClass URITemplate UUIDTiny YAMLLibYAML namespaceclean ];
    buildInputs = [ LogAnyAdapterLog4perl LogLog4perl TestDeep TestException TestLWPUserAgent TestPod ];
    meta = {
      description = "A data toolkit";
      homepage = "https://github.com/LibreCat/Catmandu";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "catmandu";
    };
  };

  CDDB_get = buildPerlPackage {
    pname = "CDDB_get";
    version = "2.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FO/FONKIE/CDDB_get-2.28.tar.gz";
      sha256 = "1jfrwvfasylcafbvb0jjm94ad4v6k99a7rf5i4qwzhg4m0gvmk5x";
    };
    meta = {
      description = "Get the CDDB info for an audio cd";
      license = with lib.licenses; [ artistic1 ];
      maintainers = [ maintainers.endgame ];
      mainProgram = "cddb.pl";
    };
  };

  CDDBFile = buildPerlPackage {
    pname = "CDDB-File";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMTM/CDDB-File-1.05.tar.gz";
      sha256 = "1jf7xhd4w9iwabhz2wajh6fid3nyvkid9q5gdhyff52w86f45rpb";
    };
    meta = {
      description = "Parse a CDDB/freedb data file";
      license = with lib.licenses; [ artistic1 ];
    };
  };


  CGI = buildPerlPackage {
    pname = "CGI";
    version = "4.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/CGI-4.51.tar.gz";
      sha256 = "02k0p8zwbn0fz9r39rg8jvbmky8fwdg6kznklzk557rg07kiblhb";
    };
    buildInputs = [ TestDeep TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Handle Common Gateway Interface requests and responses";
      homepage = "https://metacpan.org/module/CGI";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  CGICompile = buildPerlModule {
    pname = "CGI-Compile";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/CGI-Compile-0.25.tar.gz";
      sha256 = "198f94r9xjxgn0hvwy5f93xfa8jlw7d9v3v8z7qbh7mxvzp78jzl";
    };
    propagatedBuildInputs = [ Filepushd SubName ];
    buildInputs = [ CGI CaptureTiny ModuleBuildTiny SubIdentify Switch TestNoWarnings TestRequires TryTiny ];
    meta = {
      description = "Compile .cgi scripts to a code reference like ModPerl::Registry";
      homepage = "https://github.com/miyagawa/CGI-Compile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGICookieXS = buildPerlPackage {
    pname = "CGI-Cookie-XS";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/CGI-Cookie-XS-0.18.tar.gz";
      sha256 = "1iixvnm0l1q24vdlnayb4vd8fns2bdlhm6zb7fpi884ppm5cp6a6";
    };
  };

  CGIEmulatePSGI = buildPerlPackage {
    pname = "CGI-Emulate-PSGI";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/CGI-Emulate-PSGI-0.23.tar.gz";
      sha256 = "dd5b6c353f08fba100dae09904284f7f73f8328d31f6a67b2c136fad728d158b";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "PSGI adapter for CGI";
      homepage = "https://github.com/tokuhirom/p5-cgi-emulate-psgi";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIExpand = buildPerlPackage {
    pname = "CGI-Expand";
    version = "2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOWMANBS/CGI-Expand-2.05.tar.gz";
      sha256 = "1ad48nd067j5irjampxpw3zvzpg8wpnpan6szkdc5h64wccd30kf";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Convert flat hash to nested data using TT2's dot convention";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIFast = buildPerlPackage {
    pname = "CGI-Fast";
    version = "2.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/CGI-Fast-2.15.tar.gz";
      sha256 = "e5342df3dc593edfb724c7afe850b1a0ee753f4d733f5193e037b04633dfeece";
    };
    propagatedBuildInputs = [ CGI FCGI ];
    doCheck = false;
    meta = {
      homepage = "https://metacpan.org/module/CGI::Fast";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIFormBuilder = buildPerlPackage {
    pname = "CGI-FormBuilder";
    version = "3.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGPRESH/CGI-FormBuilder-3.10.tar.gz";
      sha256 = "163ixq9kninqq094z2rnkg9pv3bcmvjphlww4vksfrzhq3h9pjdf";
    };

    propagatedBuildInputs = [ CGI ];
  };

  CGIMinimal = buildPerlModule {
    pname = "CGI-Minimal";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SN/SNOWHARE/CGI-Minimal-1.30.tar.gz";
      sha256 = "b94d50821b02611da6ee5423193145078c4dbb282f2b162a4b0d58094997bc47";
    };
    meta = {
      description = "A lightweight CGI form processing package";
      homepage = "https://github.com/JerilynFranz/perl-CGI-Minimal";
      license = with lib.licenses; [ mit ];
    };
  };

  CGIPSGI = buildPerlPackage {
    pname = "CGI-PSGI";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/CGI-PSGI-0.15.tar.gz";
      sha256 = "c50dcb10bf8486a9843baed032ad89d879ff2f41c993342dead62f947a598d91";
    };
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Adapt CGI.pm to the PSGI protocol";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGISession = buildPerlModule {
    pname = "CGI-Session";
    version = "4.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/CGI-Session-4.48.tar.gz";
      sha256 = "1xsl2pz1jrh127pq0b01yffnj4mnp9nvkp88h5mndrscq9hn8xa6";
    };
    propagatedBuildInputs = [ CGI ];
  };

  CGISimple = buildPerlModule {
    pname = "CGI-Simple";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/CGI-Simple-1.25.tar.gz";
      sha256 = "0zpl7sa8jvv3zba2vcxf3qsrjk7kk2vcznfdpmxydw06x8vczrp5";
    };
    propagatedBuildInputs = [ IOStringy ];
    buildInputs = [ TestException TestNoWarnings ];
    meta = {
      description = "A Simple totally OO CGI interface that is CGI.pm compliant";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIStruct = buildPerlPackage {
    pname = "CGI-Struct";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FU/FULLERMD/CGI-Struct-1.21.tar.gz";
      sha256 = "d13d8da7fdcd6d906054e4760fc28a718aec91bd3cf067a58927fb7cb1c09d6c";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Build structures from CGI data";
      license = with lib.licenses; [ bsd2 ];
    };
  };

  CHI = buildPerlPackage {
    pname = "CHI";
    version = "0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSWARTZ/CHI-0.60.tar.gz";
      sha256 = "c7f1a2b3570a8fede484e933f89ba1729e0abd05935791d146c522dd120ee851";
    };
    buildInputs = [ TestClass TestDeep TestException TestWarn TimeDate ];
    propagatedBuildInputs = [ CarpAssert ClassLoad DataUUID DigestJHash HashMoreUtils JSONMaybeXS ListMoreUtils LogAny Moo MooXTypesMooseLikeNumeric StringRewritePrefix TaskWeaken TimeDuration TimeDurationParse ];
    meta = {
      description = "Unified cache handling interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Chart = buildPerlPackage {
    pname = "Chart";
    version = "2.4.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHARTGRP/Chart-2.4.10.tar.gz";
      sha256 = "84bd99a1a0ce72477b15e35881e6120398bb3f553aeeb5e8d72b088520e4f6bf";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "A series of charting modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CiscoIPPhone = buildPerlPackage {
    pname = "Cisco-IPPhone";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRPALMER/Cisco-IPPhone-0.05.tar.gz";
      sha256 = "b03ca263f8f41a6ec545c5393213a3146d36bd45335ade99af51dd42ab6ee16d";
    };
    meta = {
      description = "Package for creating Cisco IPPhone XML objects";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  CLASS = buildPerlPackage {
    pname = "CLASS";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/CLASS-1.00.tar.gz";
      sha256 = "c5185620815701b3fec21314ccd8c5693e6bfd519431527da3370a8164220671";
    };
    meta = {
      description = "Alias for __PACKAGE__";
      homepage = "https://metacpan.org/pod/CLASS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ClassAccessor = buildPerlPackage {
    pname = "Class-Accessor";
    version = "0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz";
      sha256 = "07215zzr4ydf49832vn54i3gf2q5b97lydkv8j56wb2svvjs64mz";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorChained = buildPerlModule {
    pname = "Class-Accessor-Chained";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz";
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [ ClassAccessor ];
  };

  ClassAccessorGrouped = buildPerlPackage {
    pname = "Class-Accessor-Grouped";
    version = "0.10014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Class-Accessor-Grouped-0.10014.tar.gz";
      sha256 = "35d5b03efc09f67f3a3155c9624126c3e162c8e3ca98ff826db358533a44c4bb";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Lets you build groups of accessors";
      homepage = "https://metacpan.org/release/Class-Accessor-Grouped";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorLite = buildPerlPackage {
    pname = "Class-Accessor-Lite";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz";
      sha256 = "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a";
    };
    meta = {
      description = "A minimalistic variant of Class::Accessor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAutouse = buildPerlPackage {
    pname = "Class-Autouse";
    version = "2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-2.01.tar.gz";
      sha256 = "c05b3236c05719d819c20db0fdeb6d0954747e43d7a738294eed7fbcf36ecf1b";
    };
    meta = {
      description = "Run-time load a class the first time you call a method in it";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassBase = buildPerlPackage {
    pname = "Class-Base";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/Class-Base-0.09.tar.gz";
      sha256 = "117dmsrb30a09zlrv919fb5h5rg8r4asa24i99k04n2habgbv9g1";
    };
    propagatedBuildInputs = [ Clone ];
  };

  ClassC3 = buildPerlPackage {
    pname = "Class-C3";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Class-C3-0.35.tar.gz";
      sha256 = "0gp3czp6y0jxx4448kz37f7gdxq4vw514bvc0l98rk4glvqkq1c4";
    };
    propagatedBuildInputs = [ AlgorithmC3 ];
    meta = {
      description = "A pragma to use the C3 method resolution order algorithm";
      homepage = "https://metacpan.org/release/Class-C3";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3AdoptNEXT = buildPerlModule {
    pname = "Class-C3-Adopt-NEXT";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Class-C3-Adopt-NEXT-0.14.tar.gz";
      sha256 = "1xsbydmiskpa1qbmnf6n39cb83nlb432xgkad9kfhxnvm8jn4rw5";
    };
    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ MROCompat ];
    meta = {
      description = "Make NEXT suck less";
      homepage = "https://github.com/karenetheridge/Class-C3-Adopt-NEXT";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3Componentised = buildPerlPackage {
    pname = "Class-C3-Componentised";
    version = "1.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Class-C3-Componentised-1.001002.tar.gz";
      sha256 = "14wn1g45z3b5apqq7dcai5drk01hfyqydsd2m6hsxzhyvi3b2l9h";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassC3 ClassInspector MROCompat ];
    meta = {
      description = "Load mix-ins or components to your C3-based class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassClassgenclassgen = buildPerlPackage {
    pname = "Class-Classgen-classgen";
    version = "3.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHLUE/Class-Classgen-classgen-3.03.tar.gz";
      sha256 = "9b65d41b991538992e816b32cc4fa9b4a4a0bb3e9c10e7eebeff82658dbbc8f6";
    };
    meta = {
      description = "Simplifies creation, manipulation and usage of complex objects.";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "classgen";
    };
  };

  ClassContainer = buildPerlModule {
    pname = "Class-Container";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Class-Container-0.13.tar.gz";
      sha256 = "f5d495b1dfb826d5c0c45d03b4d0e6b6047cbb06cdbf6be15fd4dc902aeeb70b";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Glues object frameworks together transparently";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassDataAccessor = buildPerlPackage {
    pname = "Class-Data-Accessor";
    version = "0.04004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz";
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  ClassDataInheritable = buildPerlPackage {
    pname = "Class-Data-Inheritable";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz";
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  ClassEHierarchy = buildPerlPackage {
    pname = "Class-EHierarchy";
    version = "2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORLISS/Class-EHierarchy/Class-EHierarchy-2.01.tar.gz";
      sha256 = "637ab76beb3832a9b071b999a1b15bf05d297df6a662ccb1a8004f2987308382";
    };
    meta = {
      description = "Base class for hierarchally ordered objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  ClassFactory = buildPerlPackage {
    pname = "Class-Factory";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/Class-Factory-1.06.tar.gz";
      sha256 = "c37a2d269eb935f36a23e113480ae0946fa7c12a12781396a1226c8e435f30f5";
    };
  };

  ClassFactoryUtil = buildPerlModule {
    pname = "Class-Factory-Util";
    version = "1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Class-Factory-Util-1.7.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
    meta = {
      description = "Provide utility methods for factory classes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassGomor = buildPerlModule {
    pname = "Class-Gomor";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GO/GOMOR/Class-Gomor-1.03.tar.gz";
      sha256 = "02r0zylv8c5cb34j0w2kmf8hfw6g6bymfif7z65skzz9kkm3rns7";
    };
    meta = {
      description = "Another class and object builder";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  ClassInspector = buildPerlPackage {
    pname = "Class-Inspector";
    version = "1.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz";
      sha256 = "0kk900bp8iq7bw5jyllfb31gvf93mmp24n4x90j7qs3jlhimsafc";
    };
    meta = {
      description = "Get information about a class and its structure";
      homepage = "https://metacpan.org/pod/Class::Inspector";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassISA = buildPerlPackage {
    pname = "Class-ISA";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Class-ISA-0.36.tar.gz";
      sha256 = "0r5r574i6wgxm8zsq4bc34d0dzprrh6h6mpp1nhlks1qk97g65l8";
    };
  };

  ClassIterator = buildPerlPackage {
    pname = "Class-Iterator";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEXMEC/Class-Iterator-0.3.tar.gz";
      sha256 = "db1ba87ca9107f161fe9c1e9e7e267c0026defc26fe3e73bcad8ab8ffc18ef9d";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  ClassLoader = buildPerlPackage rec {
    pname = "Class-Loader";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Class-Loader-2.03.tar.gz";
      sha256 = "4fef2076ead60423454ff1f4e82859a9a9b9942b5fb8eee0c98b9c63c9f2b8e7";
    };
    meta = {
      description = "Load modules and create objects on demand";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMakeMethods = buildPerlPackage {
    pname = "Class-MakeMethods";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/Class-MakeMethods-1.01.tar.gz";
      sha256 = "0ricb0mn0i06ngfhq5y035yx8i7ahlx83yyqwixqmv6hg4p79b5c";
    };
  };

  ClassMethodMaker = buildPerlPackage {
    pname = "Class-MethodMaker";
    version = "2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz";
      sha256 = "0a03i4k3a33qqwhykhz5k437ld5mag2vq52vvsy03gbynb65ivsy";
    };
    # Remove unnecessary, non-autoconf, configure script.
    prePatch = "rm configure";
    meta = {
      description = "A module for creating generic methods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodModifiers = buildPerlPackage {
    pname = "Class-Method-Modifiers";
    version = "2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.13.tar.gz";
      sha256 = "0qzx83mgd71hlc2m1kpw15dqsjzjq7b2cj3sdgg45a0q23vhfn5b";
    };
    buildInputs = [ TestFatal TestNeeds ];
    meta = {
      description = "Provides Moose-like method modifiers";
      homepage = "https://github.com/moose/Class-Method-Modifiers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMix = buildPerlModule {
    pname = "Class-Mix";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Class-Mix-0.006.tar.gz";
      sha256 = "8747f643893914f8c44979f1716d0c1ec8a41394796555447944e860f1ff7c0b";
    };
    propagatedBuildInputs = [ ParamsClassify ];
    meta = {
      description = "Dynamic class mixing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassReturnValue = buildPerlPackage {
    pname = "Class-ReturnValue";
    version = "0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Class-ReturnValue-0.55.tar.gz";
      sha256 = "ed3836885d78f734ccd7a98550ec422a616df7c31310c1b7b1f6459f5fb0e4bd";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "(deprecated) polymorphic return values";
      homepage = "https://github.com/rjbs/Return-Value";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassSingleton = buildPerlPackage {
    pname = "Class-Singleton";
    version = "1.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz";
      sha256 = "1942j9g0b4c88nvs3jghh3y31mlhbpwrx35xdcb2jaaiv7q17fi7";
    };
  };

  ClassThrowable = buildPerlPackage {
    pname = "Class-Throwable";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Class-Throwable-0.13.tar.gz";
      sha256 = "1kmwzdxvp9ca2z44vl0ygkfygdbxqkilzjd8vqhc4vdmvbh136nw";
    };
  };

  ClassTiny = buildPerlPackage {
    pname = "Class-Tiny";
    version = "1.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.008.tar.gz";
      sha256 = "05anh4hn8va46xwbdx7rqxnhb8i1lingb614lywzr89gj5iql1gf";
    };
    meta = {
      description = "Minimalist class construction";
      homepage = "https://github.com/dagolden/Class-Tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  ClassLoad = buildPerlPackage {
    pname = "Class-Load";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Class-Load-0.25.tar.gz";
      sha256 = "2a48fa779b5297e56156380e8b32637c6c58decb4f4a7f3c7350523e11275f8f";
    };
    buildInputs = [ TestFatal TestNeeds ];
    propagatedBuildInputs = [ DataOptList PackageStash ];
    meta = {
      description = "A working (require \"Class::Name\") and more";
      homepage = "https://github.com/moose/Class-Load";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassLoadXS = buildPerlPackage {
    pname = "Class-Load-XS";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Class-Load-XS-0.10.tar.gz";
      sha256 = "5bc22cf536ebfd2564c5bdaf42f0d8a4cee3d1930fc8b44b7d4a42038622add1";
    };
    buildInputs = [ TestFatal TestNeeds ];
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      description = "XS implementation of parts of Class::Load";
      homepage = "https://github.com/moose/Class-Load-XS";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ClassObservable = buildPerlPackage {
    pname = "Class-Observable";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CW/CWINTERS/Class-Observable-1.04.tar.gz";
      sha256 = "3ef18733a0f03c113f3bcf8ac50476e09ca1fe6234f4aaacaa24dfca95168094";
    };
    propagatedBuildInputs = [ ClassISA ];
  };

  ClassStd = buildPerlModule {
    pname = "Class-Std";
    version = "0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz";
      sha256 = "bcd6d82f6c8af0fe069fced7dd165a4795b0b6e92351c7d4e5a1ab9a14fc35c6";
    };
    meta = {
      description = "Support for creating standard 'inside-out' classes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassStdFast = buildPerlModule {
    pname = "Class-Std-Fast";
    version = "0.0.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AC/ACID/Class-Std-Fast-v0.0.8.tar.gz";
      sha256 = "1057rz95jsr66gam472i4zdv04v7bmzph3m3jwq1hwx3qrikgm0v";
    };
    propagatedBuildInputs = [ ClassStd ];
    checkInputs = [ TestPod TestPodCoverage ];
    meta = with lib; {
      description = "Faster but less secure than Class::Std";
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassUnload = buildPerlPackage {
    pname = "Class-Unload";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.11.tar.gz";
      sha256 = "0pqa98z3ij6a3v9wkmvc8b410kv30y0xxqf0i6if3lp4lx3rgqjj";
    };
    propagatedBuildInputs = [ ClassInspector ];
    buildInputs = [ TestRequires ];
  };

  ClassVirtual = buildPerlPackage {
    pname = "Class-Virtual";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Class-Virtual-0.08.tar.gz";
      sha256 = "c6499b42d3b4e5c6488a5e82fbc28698e6c9860165072dddfa6749355a9cfbb2";
    };
    propagatedBuildInputs = [ CarpAssert ClassDataInheritable ClassISA ];
    meta = {
      description = "Base class for virtual base classes";
      homepage = "https://metacpan.org/release/Class-Virtual";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassXSAccessor = buildPerlPackage {
    pname = "Class-XSAccessor";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.19.tar.gz";
      sha256 = "1wm6013il899jnm0vn50a7iv9v6r4nqywbqzj0csyf8jbwwnpicr";
    };
    meta = {
      description = "Generate fast XS accessors without runtime compilation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CLDRNumber = buildPerlModule {
    pname = "CLDR-Number";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PATCH/CLDR-Number-0.19.tar.gz";
      sha256 = "c6716488e65fe779ff79a83f0f2036ad94463efe3d0f349c6b99112975bd85fc";
    };
    buildInputs = [ SoftwareLicense TestDifferences TestException TestWarn ];
    propagatedBuildInputs =
      [ ClassMethodModifiers MathRound Moo namespaceclean ];
    meta = {
      description = "Localized number formatters using the Unicode CLDR";
      homepage = "https://github.com/patch/cldr-number-pm5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CLIHelpers = buildPerlPackage {
    pname = "CLI-Helpers";
    version = "1.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BL/BLHOTSKY/CLI-Helpers-1.8.tar.gz";
      sha256 = "1hgiynpy7q4gbx1d9pwnzdzil36k13vjxhscalj710ikcddvjz92";
    };
    buildInputs = [ PodCoverageTrustPod TestPerlCritic ];
    propagatedBuildInputs = [ CaptureTiny RefUtil SubExporter TermReadKey YAML ];
    meta = {
      description = "Subroutines for making simple command line scripts";
      homepage = "https://github.com/reyjrar/CLI-Helpers";
      license = with lib.licenses; [ bsd ];
    };
  };

  Clipboard = buildPerlModule {
    pname = "Clipboard";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Clipboard-0.26.tar.gz";
      sha256 = "886ae43dc8538f9bfc4e07fdbcf09b7fbd6ee59c31f364618c859de14953c58a";
    };
    propagatedBuildInputs = [ CGI ];
    # Disable test on darwin because MacPasteboard fails when not logged in interactively.
    # Mac OS error -4960 (coreFoundationUnknownErr): The unknown error at lib/Clipboard/MacPasteboard.pm line 3.
    # Mac-Pasteboard-0.009.readme: 'NOTE that Mac OS X appears to restrict pasteboard access to processes that are logged in interactively.
    #     Ssh sessions and cron jobs can not create the requisite pasteboard handles, giving coreFoundationUnknownErr (-4960)'
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Copy and paste with any OS";
      homepage = "http://metacpan.org/release/Clipboard";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  Clone = buildPerlPackage {
    pname = "Clone";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz";
      sha256 = "1rm9g68fklni63jdkrlgqq6yfj95fm33p2bq90p475gsi8sfxdnb";
    };
    buildInputs = [ BCOW ];
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CloneChoose = buildPerlPackage {
    pname = "Clone-Choose";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz";
      sha256 = "0cin2bjn5z8xhm9v4j7pwlkx88jnvz8al0njdjwyvs6fb0glh8sn";
    };
    buildInputs = [ Clone ClonePP TestWithoutModule ];
    meta = {
      description = "Choose appropriate clone utility";
      homepage = "https://metacpan.org/release/Clone-Choose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClonePP = buildPerlPackage {
    pname = "Clone-PP";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Clone-PP-1.08.tar.gz";
      sha256 = "0y7m25fksiavzg4xj4cm9zkz8rmnk4iqy7lm01m4nmyqlna3082p";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CodeTidyAll = buildPerlPackage {
    pname = "Code-TidyAll";
    version = "0.78";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Code-TidyAll-0.78.tar.gz";
      sha256 = "1dmr6zkgcnc6cam204f00g5yly46cplbn9k45ginw02rv10vnpij";
    };
    propagatedBuildInputs = [ CaptureTiny ConfigINI FileWhich Filepushd IPCRun3 IPCSystemSimple ListCompare ListSomeUtils LogAny Moo ScopeGuard SpecioLibraryPathTiny TextDiff TimeDate TimeDurationParse ];
    buildInputs = [ TestClass TestClassMost TestDeep TestDifferences TestException TestFatal TestMost TestWarn TestWarnings librelative ];
    meta = {
      description = "Engine for tidyall, your all-in-one code tidier and validator";
      homepage = "https://metacpan.org/release/Code-TidyAll";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "tidyall";
    };
  };

  CodeTidyAllPluginPerlAlignMooseAttributes = buildPerlPackage {
    pname = "Code-TidyAll-Plugin-Perl-AlignMooseAttributes";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSWARTZ/Code-TidyAll-Plugin-Perl-AlignMooseAttributes-0.01.tar.gz";
      sha256 = "1r8w5kfm17j1dyrrsjhwww423zzdzhx1i3d3brl32wzhasgf47cd";
    };
    propagatedBuildInputs = [ CodeTidyAll TextAligner ];
    meta = {
      description = "TidyAll plugin to sort and align Moose-style attributes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ColorLibrary = buildPerlPackage {
    pname = "Color-Library";
    version = "0.021";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROKR/Color-Library-0.021.tar.gz";
      sha256 = "58cbf7e333d3a4a40297abc43412b321da449c6816020e4fa6625ab079fc90a5";
    };
    buildInputs = [ TestMost TestWarn TestException TestDeep TestDifferences ModulePluggable ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable ];
    meta = {
      description = "An easy-to-use and comprehensive named-color library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CommandRunner = buildPerlModule {
    pname = "Command-Runner";
    version = "0.200";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Command-Runner-0.200.tar.gz";
      sha256 = "sha256-WtJtBhEb/s1TyPW7XeqUvyAl9seOlfbYAS5M+oninyY=";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CaptureTiny Filepushd StringShellQuote Win32ShellQuote ];
    meta = {
      description = "Run external commands and Perl code refs";
      homepage = "https://github.com/skaji/Command-Runner";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  commonsense = buildPerlPackage {
    pname = "common-sense";
    version = "3.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/common-sense-3.75.tar.gz";
      sha256 = "0zhfp8f0czg69ycwn7r6ayg6idm5kyh2ai06g5s6s07kli61qsm8";
    };
    meta = {
      description = "Implements some sane defaults for Perl programs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressBzip2 = buildPerlPackage {
    pname = "Compress-Bzip2";
    version = "2.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Compress-Bzip2-2.28.tar.gz";
      sha256 = "859f835c3f5c998810d8b2a6f9e282ff99d6cb66ccfa55cae7e66dafb035116e";
    };
    meta = {
      description = "Interface to Bzip2 compression library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressLZF = buildPerlPackage rec {
    pname = "Compress-LZF";
    version = "3.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${pname}-${version}.tar.gz";
      sha256 = "5d1f5df48ce13b4dee1cc9f278ecdbf8177877b0b98815a4eb3c91c3466716f2";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawBzip2 = buildPerlPackage {
    pname = "Compress-Raw-Bzip2";
    version = "2.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.101.tar.gz";
      sha256 = "1n5q01akpsw1skn59c3nivwjfqcn00wzdj8gx4q0wac8sd7i76qc";
    };

    # Don't build a private copy of bzip2.
    BUILD_BZIP2 = false;
    BZIP2_LIB = "${pkgs.bzip2.out}/lib";
    BZIP2_INCLUDE = "${pkgs.bzip2.dev}/include";

    meta = {
      description = "Low-Level Interface to bzip2 compression library";
      homepage = "https://github.com/pmqs/Compress-Raw-Bzip2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawLzma = buildPerlPackage {
    pname = "Compress-Raw-Lzma";
    version = "2.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Lzma-2.101.tar.gz";
      sha256 = "bb267fd31981eda11f444038f8a0fca4b94a51ae61b2db71246abf6a4d322a36";
    };
    preConfigure = ''
      cat > config.in <<EOF
        INCLUDE      = ${pkgs.xz.dev}/include
        LIB          = ${pkgs.xz.out}/lib
      EOF
    '';
    meta = {
      description = "Low-Level Interface to lzma compression library";
      homepage = "https://github.com/pmqs/Compress-Raw-Lzma";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawZlib = buildPerlPackage {
    pname = "Compress-Raw-Zlib";
    version = "2.103";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Zlib-2.103.tar.gz";
      sha256 = "sha256-1p0mIMoCTcG0JPf0Io/hFpsrd0FrswMQ6JDTvn2kff8=";
    };

    preConfigure = ''
      cat > config.in <<EOF
        BUILD_ZLIB   = False
        INCLUDE      = ${pkgs.zlib.dev}/include
        LIB          = ${pkgs.zlib.out}/lib
        OLD_ZLIB     = False
        GZIP_OS_CODE = AUTO_DETECT
      EOF
    '';

    doCheck = !stdenv.isDarwin;

    meta = {
      homepage = "https://github.com/pmqs/Compress-Raw-Zlib";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressUnLZMA = buildPerlPackage {
    pname = "Compress-unLZMA";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Compress-unLZMA-0.05.tar.gz";
      sha256 = "1f0pcpcjjj60whqc5sc5jd0dd7z3si4fnp268w4ykmcjini03s2d";
    };
  };

  ConfigAny = buildPerlPackage {
    pname = "Config-Any";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Config-Any-0.32.tar.gz";
      sha256 = "0l31sg7dwh4dwwnql42hp7arkhcm15bhsgfg4i6xvbjzy9f2mnk8";
    };
    propagatedBuildInputs = [ ModulePluggable ];
    meta = {
      description = "Load configuration from different file formats, transparently";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigAutoConf = buildPerlPackage {
    pname = "Config-AutoConf";
    version = "0.319";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/Config-AutoConf-0.319.tar.gz";
      sha256 = "0gm3l0qyrgiia67lsmzjfb6ihgbdx1lidli7w47lq9jk4v66ckrh";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      description = "A module to implement some of AutoConf macros in pure perl";
      homepage = "https://metacpan.org/release/Config-AutoConf";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGeneral = buildPerlPackage {
    pname = "Config-General";
    version = "2.63";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.63.tar.gz";
      sha256 = "1bbg3wp0xcpj04cmm86j1x0j5968jqi5s2c87qs7dgmap1vzk6qa";
    };
    meta = {
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ConfigGitLike = buildPerlPackage {
    pname = "Config-GitLike";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Config-GitLike-1.18.tar.gz";
      sha256 = "f7ae7440f3adab5b9ff9aa57216d84fd4a681009b9584e32da42f8bb71e332c5";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moo MooXTypesMooseLike ];
    meta = {
      description = "Git-compatible config file parsing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGrammar = buildPerlPackage {
    pname = "Config-Grammar";
    version = "1.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSCHWEI/Config-Grammar-1.13.tar.gz";
      sha256 = "a8b3a3a2c9c8c43b92dc401bf2709d6514f15b467fd4f72c48d356335771d6e3";
    };
    meta = {
      description = "A grammar-based, user-friendly config parser";
      homepage = "https://github.com/schweikert/Config-Grammar";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigINI = buildPerlPackage {
    pname = "Config-INI";
    version = "0.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Config-INI-0.025.tar.gz";
      sha256 = "628bf76d5b91f89dde22d4813ec033026ebf71b772bb61ccda909da00c869732";
    };
    propagatedBuildInputs = [ MixinLinewise ];
    meta = {
      description = "Simple .ini-file format";
      homepage = "https://github.com/rjbs/Config-INI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigIdentity = buildPerlPackage {
    pname = "Config-Identity";
    version = "0.0019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Config-Identity-0.0019.tar.gz";
      sha256 = "1a0jx12pxwpbnkww4xg4lav8j6ls89hrdimhj4a697k56zdhnli9";
    };
    propagatedBuildInputs = [ FileHomeDir IPCRun ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "Load (and optionally decrypt via GnuPG) user/pass identity information ";
      homepage = "https://github.com/dagolden/Config-Identity";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigIniFiles = buildPerlPackage {
    pname = "Config-IniFiles";
    version = "3.000003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Config-IniFiles-3.000003.tar.gz";
      sha256 = "3c457b65d98e5ff40bdb9cf814b0d5983eb0c53fb8696bda3ba035ad2acd6802";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A module for reading .ini-style configuration files";
      homepage = "http://metacpan.org/release/Config-IniFiles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  ConfigMerge = buildPerlPackage {
    pname = "Config-Merge";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/Config-Merge-1.04.tar.gz";
      sha256 = "a932477b43ae5fb04a16f071a891da7bd2086c10c680592f2888fa9d9972cccf";
    };
    buildInputs = [ YAML ];
    propagatedBuildInputs = [ ConfigAny ];
    meta = {
      description = "Load a configuration directory tree containing YAML, JSON, XML, Perl, INI or Config::General files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigOnion = buildPerlPackage {
    pname = "Config-Onion";
    version = "1.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSHEROH/Config-Onion-1.007.tar.gz";
      sha256 = "1bx81nakvgj9m7x1q7pnra2cm1rzfdyf7fm2wmlj92qkivvdszrj";
    };
    propagatedBuildInputs = [ ConfigAny HashMergeSimple Moo ];
    buildInputs = [ TestException YAML ];
    meta = {
      description = "Layered configuration, because configs are like ogres";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigMVP = buildPerlPackage {
    pname = "Config-MVP";
    version = "2.200011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-2.200011.tar.gz";
      sha256 = "23c95666fc43c4adaebcc093b1b56091efc2a6aa2d75366a216d18eda96ad716";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModulePluggable MooseXOneArgNew RoleHasMessage RoleIdentifiable Throwable TieIxHash ];
    meta = {
      description = "Multivalue-property package-oriented configuration";
      homepage = "https://github.com/rjbs/Config-MVP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigMVPReaderINI = buildPerlPackage {
    pname = "Config-MVP-Reader-INI";
    version = "2.101463";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-Reader-INI-2.101463.tar.gz";
      sha256 = "0iflnsh0sgihff3ra8sr7awiiscmqvrp1anaskkwksqi6yzidab9";
    };
    propagatedBuildInputs = [ ConfigINI ConfigMVP ];
    meta = {
      description = "An MVP config reader for .ini files";
      homepage = "https://github.com/rjbs/Config-MVP-Reader-INI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigProperties = buildPerlPackage {
    pname = "Config-Properties";
    version = "1.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Config-Properties-1.80.tar.gz";
      sha256 = "5d04395be7e14e970a03ea952fb7629ae304d97c031f90cc1c29bd0a6a62fc40";
    };
    meta = {
      description = "Read and write property files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigSimple = buildPerlPackage {
    pname = "Config-Simple";
    version = "4.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHERZODR/Config-Simple-4.58.tar.gz";
      sha256 = "1d7dhvis1i03xlj8z3g5l8mz88kf7dn13zngbjhq94qgdxq9b6fx";
    };
    meta = {
      description = "Simple configuration file class";
      license = with lib.licenses; [ unfree ];
    };
  };

  ConfigStd = buildPerlModule {
    pname = "Config-Std";
    version = "0.903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICKER/Config-Std-0.903.tar.gz";
      sha256 = "b7709ff663bd279d264ab9c2f51e9e9588479a3367a8c4cfc18659c2a11480fe";
    };
    propagatedBuildInputs = [ ClassStd ];
    meta = {
      description = "Load and save configuration files in a standard format";
      license = with lib.licenses; [ unfree ];
    };
  };

  ConfigTiny = buildPerlPackage {
    pname = "Config-Tiny";
    version = "2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Config-Tiny-2.24.tgz";
      sha256 = "0cjj2f0pj9y3cx1lgk2qp6arsnyaacf7kj6v33iqczn59f798r0h";
    };
    buildInputs = [ TestPod ];
  };

  ConfigVersioned = buildPerlPackage {
    pname = "Config-Versioned";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Config-Versioned-1.01.tar.gz";
      sha256 = "bc9a4ae3738bd89f86a07bca673627ca3c92ba969737cd6dbc7ab7ad17cd2348";
    };
    propagatedBuildInputs = [ ConfigStd GitPurePerl ];
    doCheck = false;
    meta = {
      description = "Simple, versioned access to configuration data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cfgver";
    };
  };

  Connector = buildPerlPackage {
    pname = "Connector";
    version = "1.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Connector-1.35.tar.gz";
      sha256 = "0jnwcvjibywdfq4x5n3np9fxvpsgqq6vjpn72sfa2xfdwrp7dna1";
    };
    buildInputs = [ ConfigMerge ConfigStd ConfigVersioned DBDSQLite DBI IOSocketSSL JSON LWP LWPProtocolHttps ProcSafeExec TemplateToolkit YAML ];
    propagatedBuildInputs = [ LogLog4perl Moose ];
    prePatch = ''
      # Attempts to use network.
      rm t/01-proxy-http.t
      rm t/01-proxy-proc-safeexec.t
    '';
    meta = {
      description = "A generic connection to a hierarchical-structured data set";
      homepage = "https://github.com/whiterabbitsecurity/connector";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConstFast = buildPerlModule {
    pname = "Const-Fast";
    version = "0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Const-Fast-0.014.tar.gz";
      sha256 = "1nwlldgrx86yn7y6a53cqgvzm2ircsvxg1addahlcy6510x9a1gq";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    buildInputs = [ ModuleBuildTiny TestFatal ];
    meta = {
      description = "Facility for creating read-only scalars, arrays, and hashes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConvertASCIIArmour = buildPerlPackage {
    pname = "Convert-ASCII-Armour";
    version = "1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Convert-ASCII-Armour-1.4.tar.gz";
      sha256 = "97e8acb6eb2a2a91af7d6cf0d2dff6fa42aaf939fc7d6d1c6057a4f0df52c904";
    };
    meta = {
      description = "Convert binary octets into ASCII armoured messages";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ConvertASN1 = buildPerlPackage {
    pname = "Convert-ASN1";
    version = "0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMLEGGE/Convert-ASN1-0.33.tar.gz";
      sha256 = "0xk0s2rnwjb7ydhwfinpjcbw25im54b8cs7r9hj3m7n7412h1pqz";
    };
  };

  ConvertBase32 = buildPerlPackage {
    pname = "Convert-Base32";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEGAMI/Convert-Base32-0.06.tar.gz";
      sha256 = "4ba82c167c41f455aa8284738727e4c94a2ebcb1c4ce797f6fda07245a642115";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Encoding and decoding of base32 strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ConvertBencode = buildPerlPackage rec {
    pname = "Convert-Bencode";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OR/ORCLEV/Convert-Bencode-1.03.tar.gz";
      sha256 = "0v2ywj18px67mg97xnrdq9mnlzgqvj92pr2g47g9c9b9cpw3v7r6";
    };
    meta = {
      description = "Functions for converting to/from bencoded strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConvertColor = buildPerlModule {
    pname = "Convert-Color";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Convert-Color-0.11.tar.gz";
      sha256 = "b41217c72931034ba4417d7a9e1e2999f04580d4e6b31c70993fedccc2440d38";
    };
    buildInputs = [ TestNumberDelta ];
    propagatedBuildInputs = [ ListUtilsBy ModulePluggable ];
    meta = {
      description = "Color space conversions and named lookups";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConvertUU = buildPerlPackage rec {
    pname = "Convert-UU";
    version = "0.5201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/Convert-UU-0.5201.tar.gz";
      sha256 = "92329ce1c32b5952c48e1223db018c8c58ceafef03bfa0fd4817cd89c355a3bd";
    };
    meta = {
      description = "Perl module for uuencode and uudecode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  constantboolean = buildPerlModule {
    pname = "constant-boolean";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/constant-boolean-0.02.tar.gz";
      sha256 = "1s8gxfg4xqp543aqanv5lbp64vqqyw6ic4x3fm4imkk1h3amjb6d";
    };
    propagatedBuildInputs = [ SymbolUtil ];
  };

  curry = buildPerlPackage {
    pname = "curry";
    version = "1.001000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/curry-1.001000.tar.gz";
      sha256 = "1m2n3w67cskh8ic6vf6ik0fmap9zma875kr5rhyznr1041wn064b";
    };
    meta = {
      description = "Create automatic curried method call closures for any class or object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  constant-defer = buildPerlPackage {
    pname = "constant-defer";
    version = "6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/constant-defer-6.tar.gz";
      sha256 = "1ykgk0rd05p7kyrdxbv047fj7r0b4ix9ibpkzxp6h8nak0qjc8bv";
    };
  };

  ContextPreserve = buildPerlPackage {
    pname = "Context-Preserve";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Context-Preserve-0.03.tar.gz";
      sha256 = "07zxgmb11bn4zj3w9g1zwbb9iv4jyk5q7hc0nv59knvv5i64m489";
    };
    buildInputs = [ TestException TestSimple13 ];
  };

  CookieBaker = buildPerlModule {
    pname = "Cookie-Baker";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cookie-Baker-0.11.tar.gz";
      sha256 = "59275f474e07c0aa3611e3e684b894e7db913333d8214420be63f12ec18cd7ab";
    };
    buildInputs = [ ModuleBuildTiny TestTime ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Cookie string generator / parser";
      homepage = "https://github.com/kazeburo/Cookie-Baker";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CookieXS = buildPerlPackage {
    pname = "Cookie-XS";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/Cookie-XS-0.11.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    propagatedBuildInputs = [ CGICookieXS ];
  };

  Coro = buildPerlPackage {
    pname = "Coro";
    version = "6.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Coro-6.57.tar.gz";
      sha256 = "1ihl2zaiafr2k5jzj46j44j8vxqs23fqcsahypmi23jl6f0f8a0r";
    };
    propagatedBuildInputs = [ AnyEvent Guard commonsense ];
    buildInputs = [ CanaryStability ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  CoroEV = buildPerlPackage rec {
    pname = "CoroEV";
    version = "6.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Coro-${version}.tar.gz";
      sha256 = "43d79c027170fcda4ca0ee92734605bc95e122686f5071b94d90764c81ae8a30";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ AnyEvent Coro EV Guard commonsense ];
    preConfigure = ''
      cd EV
    '';
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Corona = buildPerlPackage {
    pname = "Corona";
    version = "0.1004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Corona-0.1004.tar.gz";
      sha256 = "0g5gpma3998rn61qfjv5csv2nrdi4sc84ipkb4k6synyhfgd3xgz";
    };
    propagatedBuildInputs = [ NetServerCoro Plack ];
    buildInputs = [ TestSharedFork TestTCP ];
    meta = {
      description = "Coro based PSGI web server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "corona";
    };
  };

  CPAN = buildPerlPackage {
    pname = "CPAN";
    version = "2.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/CPAN-2.29.tar.gz";
      sha256 = "1f55672efd505a9baacfa1924d115362120aa6bf8efab7a17c7cb090b17ccc41";
    };
    propagatedBuildInputs = [ ArchiveZip CPANChecksums CPANPerlReleases CompressBzip2 Expect FileHomeDir FileWhich LWP LogLog4perl ModuleSignature TermReadKey TextGlob YAML YAMLLibYAML YAMLSyck IOSocketSSL ];
    meta = {
      description = "Query, download and build perl modules from CPAN sites";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cpan";
    };
  };

  CPANMini = buildPerlPackage {
    pname = "CPAN-Mini";
    version = "1.111016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/CPAN-Mini-1.111016.tar.gz";
      sha256 = "5a297afc3e367ad80811464d4eb7e4dd3caff8ba499cdd2b558f6279443a7657";
    };
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [ FileHomeDir LWPProtocolHttps ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/minicpan
    '';

    meta = {
      description = "Create a minimal mirror of CPAN";
      homepage = "https://github.com/rjbs/CPAN-Mini";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      mainProgram = "minicpan";
    };
  };

  CpanelJSONXS = buildPerlPackage {
    pname = "Cpanel-JSON-XS";
    version = "4.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Cpanel-JSON-XS-4.31.tar.gz";
      sha256 = "sha256-AqZ6zuPeJKcow5ZIaADiojVZGlQ9B5REmtOI/j1c/yk=";
    };
    meta = {
      description = "CPanel fork of JSON::XS, fast and correct serializing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cpanel_json_xs";
    };
  };

  CPAN02PackagesSearch = buildPerlModule {
    pname = "CPAN-02Packages-Search";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/CPAN-02Packages-Search-0.001.tar.gz";
      sha256 = "02dgqplar99a2i2b08pnapznyp4il70wsvpm8163ywwfwqn1ap37";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ TieHandleOffset ];
    meta = {
      description = "Search packages in 02packages.details.txt";
      homepage = "https://github.com/skaji/CPAN-02Packages-Search";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  CPANChanges = buildPerlPackage {
    pname = "CPAN-Changes";
    version = "0.400002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/CPAN-Changes-0.400002.tar.gz";
      sha256 = "01eedea90d07468cb58e4a50bfa3bb1d4eeda9073596add1118fc359153abe8d";
    };
    meta = {
      description = "Read and write Changes files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "tidy_changelog";
    };
  };

  CPANChecksums = buildPerlPackage {
    pname = "CPAN-Checksums";
    version = "2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/CPAN-Checksums-2.14.tar.gz";
      sha256 = "4080716c5da7e03b504e3cc0ea1fd5ef9ed6915f6fb737564e9e13d355a89e39";
    };
    propagatedBuildInputs = [ CompressBzip2 DataCompare ModuleSignature ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANCommonIndex = buildPerlPackage {
    pname = "CPAN-Common-Index";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Common-Index-0.010.tar.gz";
      sha256 = "c43ddbb22fd42b06118fe6357f53700fbd77f531ba3c427faafbf303cbf4eaf0";
    };
    buildInputs = [ TestDeep TestFailWarnings TestFatal ];
    propagatedBuildInputs = [ CPANDistnameInfo ClassTiny TieHandleOffset URI ];
    meta = {
      description = "Common library for searching CPAN modules, authors and distributions";
      homepage = "https://github.com/Perl-Toolchain-Gang/CPAN-Common-Index";
      license = with lib.licenses; [ asl20 ];
    };
  };

  CPANDistnameInfo = buildPerlPackage {
    pname = "CPAN-DistnameInfo";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/CPAN-DistnameInfo-0.12.tar.gz";
      sha256 = "0d94kx596w7k328cvq4y96z1gz12hdhn3z1mklkbrb7fyzlzn91g";
    };
    meta = {
      description = "Extract distribution name and version from a distribution filename";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaCheck = buildPerlPackage {
    pname = "CPAN-Meta-Check";
    version = "0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/CPAN-Meta-Check-0.014.tar.gz";
      sha256 = "07rmdbz1rbnb7w33vswn1wixlyh947sqr93xrvcph1hwzhmmg818";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Verify requirements in a CPAN::Meta object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPerlReleases = buildPerlPackage {
    pname = "CPAN-Perl-Releases";
    version = "5.20201120";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-5.20201120.tar.gz";
      sha256 = "1qsjm26556kqxyvj85c7j37mh2xw78fm3i7f58mpqkfawxip4q3k";
    };
    meta = {
      description = "Mapping Perl releases on CPAN to the location of the tarballs";
      homepage = "https://github.com/bingos/cpan-perl-releases";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPLUS = buildPerlPackage {
    pname = "CPANPLUS";
    version = "0.9908";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/CPANPLUS-0.9908.tar.gz";
      sha256 = "1m4xas67fax947kahvg4jsnsr2r1i58c5g3f1bixh7krgnsarxjq";
    };
    propagatedBuildInputs = [ ArchiveExtract ModulePluggable ObjectAccessor PackageConstants TermUI ];
    meta = {
      description = "Ameliorated interface to the CPAN";
      homepage = "https://github.com/jib/cpanplus-devel";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cpanp";
    };
  };

  CPANUploader = buildPerlPackage {
    pname = "CPAN-Uploader";
    version = "0.103015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/CPAN-Uploader-0.103015.tar.gz";
      sha256 = "1idvkxqzc53hjs808gc6z6873bg4gn6zz499df0wppi56vz7w24f";
    };
    propagatedBuildInputs = [ FileHomeDir GetoptLongDescriptive LWPProtocolHttps TermReadKey ];
    meta = {
      description = "Upload things to the CPAN";
      homepage = "https://github.com/rjbs/CPAN-Uploader";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cpan-upload";
    };
  };

  CryptArgon2 = buildPerlModule {
    pname = "Crypt-Argon2";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Argon2-0.010.tar.gz";
      sha256 = "3ea1c006f10ef66fd417e502a569df15c4cc1c776b084e35639751c41ce6671a";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    meta = {
      description = "Perl interface to the Argon2 key derivation functions";
      license = with lib.licenses; [ cc0 ];
    };
  };

  CryptBlowfish = buildPerlPackage {
    pname = "Crypt-Blowfish";
    version = "2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/Crypt-Blowfish-2.14.tar.gz";
      sha256 = "1cb7g8cyfs9alrfdykxhs8m6azj091fmcycz6p5vkxbbzcgl7cs6";
    };
  };

  CryptCAST5_PP = buildPerlPackage {
    pname = "Crypt-CAST5_PP";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBMATH/Crypt-CAST5_PP-1.04.tar.gz";
      sha256 = "cba98a80403fb898a14c928f237f44816b4848641840ce2517363c2c071b5327";
    };
    meta = {
      description = "CAST5 block cipher in pure Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptCBC = buildPerlPackage {
    pname = "Crypt-CBC";
    version = "2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/Crypt-CBC-2.33.tar.gz";
      sha256 = "0ig698lmpjz7fslnznxm0609lvlnvf4f3s370082nzycnqhxww3a";
    };
  };

  CryptCurve25519 = buildPerlPackage {
    pname = "Crypt-Curve25519";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AJ/AJGB/Crypt-Curve25519-0.06.tar.gz";
      sha256 = "1ir0gfxm8i7r9zyfs2zvil5jgwirl7j6cb9cm1p2kjpfnhyp0j4z";
    };
    patches = [
      (fetchpatch {
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-perl/Crypt-Curve25519/files/Crypt-Curve25519-0.60.0-fmul-fixedvar.patch?id=cec727ad614986ca1e6b9468eea7f1a5a9183382";
        sha256 = "0l005jzxp6q6vyl3p43ji47if0v9inscnjl0vxaqzf6c17akgbhf";
      })
    ];
    meta = {
      description = "Generate shared secret using elliptic-curve Diffie-Hellman function";
      homepage = "https://metacpan.org/release/Crypt-Curve25519";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptDES = buildPerlPackage {
    pname = "Crypt-DES";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/Crypt-DES-2.07.tar.gz";
      sha256 = "1rypxlhpd1jc0c327aghgl9y6ls47drmpvn0a40b4k3vhfsypc9d";
    };
  };

  CryptDES_EDE3 = buildPerlPackage {
    pname = "Crypt-DES_EDE3";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BT/BTROTT/Crypt-DES_EDE3-0.01.tar.gz";
      sha256 = "9cb2e04b625e9cc0833cd499f76fd12556583ececa782a9758a55e3f969748d6";
    };
    propagatedBuildInputs = [ CryptDES ];
    meta = {
      description = "Triple-DES EDE encryption/decryption";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptDH = buildPerlPackage {
    pname = "Crypt-DH";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHALDU/Crypt-DH-0.07.tar.gz";
      sha256 = "0pvzlgwpx8fzdy64ki15155vhsj30i9zxmw6i4p7irh17d1g7368";
    };
    propagatedBuildInputs = [ MathBigIntGMP ];
  };

  CryptDHGMP = buildPerlPackage {
    pname = "Crypt-DH-GMP";
    version = "0.00012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/Crypt-DH-GMP-0.00012.tar.gz";
      sha256 = "0f5gdprcql4kwzgxl2s6ngcfg1jl45lzcqh7dkv5bkwlwmxa9rsi";
    };
    buildInputs = [ pkgs.gmp DevelChecklib TestRequires ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
  };

  CryptDSA = buildPerlPackage {
    pname = "Crypt-DSA";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Crypt-DSA-1.17.tar.gz";
      sha256 = "d1b8585f6bf746f76e5dc5da3641d325ed656bc2e5f344b54514b55c31009a03";
    };
    propagatedBuildInputs = [ DataBuffer DigestSHA1 FileWhich ];
    meta = {
      description = "DSA Signatures and Key Generation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptECB = buildPerlPackage {
    pname = "Crypt-ECB";
    version = "2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APPEL/Crypt-ECB-2.22.tar.gz";
      sha256 = "f5af62e908cd31a34b2b813135a0718016fd003ffa0021ffbdd84c50158267aa";
    };
    meta = with lib; {
      description = "Use block ciphers using ECB mode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptEksblowfish = buildPerlModule {
    pname = "Crypt-Eksblowfish";
    version = "0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Crypt-Eksblowfish-0.009.tar.gz";
      sha256 = "3cc7126d5841107237a9be2dc5c7fbc167cf3c4b4ce34678a8448b850757014c";
    };
    propagatedBuildInputs = [ ClassMix ];
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
  };

  CryptFormat = buildPerlPackage {
    pname = "Crypt-Format";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Crypt-Format-0.10.tar.gz";
      sha256 = "89ddc010a6c91d5be7a1874a528eed6eda39f2c401c18e63d80ddfbf7127e2dd";
    };
    buildInputs = [ TestException TestFailWarnings ];
    meta = {
      description = "Conversion utilities for encryption applications";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptIDEA = buildPerlPackage {
    pname = "Crypt-IDEA";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/Crypt-IDEA-1.10.tar.gz";
      sha256 = "0690lzlyjqgmnb94dq7dm5n6pgybg10fkpgfycgzr814370pig9k";
    };
  };

  CryptJWT = buildPerlPackage {
    pname = "Crypt-JWT";
    version = "0.029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/Crypt-JWT-0.029.tar.gz";
      sha256 = "0fccff29065a0098eef151deeb33c12c0d68e16a1cb4e7465b26ebbd4c18cd2f";
    };
    propagatedBuildInputs = [ CryptX JSON ];
    meta = {
      description = "JSON Web Token";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPassphrase = buildPerlPackage {
    pname = "Crypt-Passphrase";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Passphrase-0.003.tar.gz";
      sha256 = "685aa090f8179a86d6896212ccf8ccfde7a79cce857199bb14e2277a10d240ad";
    };
    meta = {
      description = "A module for managing passwords in a cryptographically agile manner";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPassphraseArgon2 = buildPerlPackage {
    pname = "Crypt-Passphrase-Argon2";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Passphrase-Argon2-0.003.tar.gz";
      sha256 = "sha256-cCkLtb3GfBcBKN8+UWexfQS7eTkzqubAWnWGfao/OTg=";
    };
    propagatedBuildInputs = with perlPackages; [ CryptArgon2 CryptPassphrase ];
    meta = {
      description = "An Argon2 encoder for Crypt::Passphrase";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPassphraseBcrypt = buildPerlPackage {
    pname = "Crypt-Passphrase-Bcrypt";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Passphrase-Bcrypt-0.001.tar.gz";
      sha256 = "sha256-M44nA4RH/eAjznyaC1dPR+4zeQRKDAgxrJRx8UMNxMU=";
    };
    propagatedBuildInputs = [ CryptEksblowfish CryptPassphrase ];
    meta = {
      description = "A bcrypt encoder for Crypt::Passphrase";
      homepage = "https://github.com/Leont/crypt-passphrase-bcrypt";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPasswdMD5 = buildPerlModule {
    pname = "Crypt-PasswdMD5";
    version = "1.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Crypt-PasswdMD5-1.40.tgz";
      sha256 = "0j0r74f18nk63phddzqbf7wqma2ci4p4bxvrwrxsy0aklbp6lzdp";
    };
  };

  CryptPKCS10 = buildPerlModule {
    pname = "Crypt-PKCS10";
    version = "2.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Crypt-PKCS10-2.001.tar.gz";
      sha256 = "f7945b76a2d8f4d8ecf627b2eb8ea4f41d001e6a915efe82e71d6b97fea3ffa9";
    };
    buildInputs = [ pkgs.unzip ModuleBuildTiny ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "Parse PKCS #10 certificate requests";
      homepage = "https://github.com/openxpki/Crypt-PKCS10";
      license = with lib.licenses; [ gpl1 ];
    };
  };

  CryptRandomSeed = buildPerlPackage {
    pname = "Crypt-Random-Seed";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Crypt-Random-Seed-0.03.tar.gz";
      sha256 = "593da54b522c09cc26bbcc0e4e49c1c8e688a6fd33b0726af801d722a5c8d0f1";
    };
    propagatedBuildInputs = [ CryptRandomTESHA2 ];
    meta = {
      description = "Provide strong randomness for seeding";
      homepage = "https://github.com/danaj/Crypt-Random-Seed";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptRandom = buildPerlPackage rec {
    pname = "Crypt-Random";
    version = "1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Crypt-Random-1.52.tar.gz";
      sha256 = "a93c06de409e6f2eb2e9868ea6d4e653d99f2f7900b2c1831e1f65ace0c4ef84";
    };
    propagatedBuildInputs = [ ClassLoader MathPari StatisticsChiSquare ];
    meta = {
      description = "Interface to /dev/random and /dev/urandom";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "makerandom";
    };
  };

  CryptRandomSource = buildPerlModule {
    pname = "Crypt-Random-Source";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Crypt-Random-Source-0.14.tar.gz";
      sha256 = "1rpdds3sy5l1fhngnkrsgwsmwd54wpicx3i9ds69blcskwkcwkpc";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 ];
    propagatedBuildInputs = [ CaptureTiny ModuleFind Moo SubExporter TypeTiny namespaceclean ];
    meta = {
      description = "Get weak or strong random data from pluggable sources";
      homepage = "https://github.com/karenetheridge/Crypt-Random-Source";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRandomTESHA2 = buildPerlPackage {
    pname = "Crypt-Random-TESHA2";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Crypt-Random-TESHA2-0.01.tar.gz";
      sha256 = "a0912b42c52be173da528d5527e40d967324bc04ac78d9fc2ddc91ff16fe9633";
    };
    meta = {
      description = "Random numbers using timer/schedule entropy, aka userspace voodoo entropy";
      homepage = "https://github.com/danaj/Crypt-Random-TESHA2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRC4 = buildPerlPackage {
    pname = "Crypt-RC4";
    version = "2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIFUKURT/Crypt-RC4-2.02.tar.gz";
      sha256 = "1sp099cws0q225h6j4y68hmfd1lnv5877gihjs40f8n2ddf45i2y";
    };
  };

  CryptRandPasswd = buildPerlPackage {
    pname = "Crypt-RandPasswd";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Crypt-RandPasswd-0.06.tar.gz";
      sha256 = "0ca8544371wp4vvqsa19lnhl02hczpkbwkgsgm65ziwwim3r1gdi";
    };
  };

  CryptRIPEMD160 = buildPerlPackage {
    pname = "Crypt-RIPEMD160";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Crypt-RIPEMD160-0.08.tar.gz";
      sha256 = "0cmj620kfg08yvh81bq1sbabdyyc3g9pc6vlngxdxjgn0xvcil9l";
    };
    meta = {
      description = "Perl extension for the RIPEMD-160 Hash function";
      homepage = "http://wiki.github.com/toddr/Crypt-RIPEMD160";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptMySQL = buildPerlModule {
    pname = "Crypt-MySQL";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEBE/Crypt-MySQL-0.04.tar.gz";
      sha256 = "93ebdfaaefcfe9ab683f0121c85f24475d8197f0bcec46018219e4111434dde3";
    };
    propagatedBuildInputs = [ DigestSHA1 ];
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
  };

  CryptRijndael = buildPerlPackage {
    pname = "Crypt-Rijndael";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Rijndael-1.15.tar.gz";
      sha256 = "0qs1b6ma4sj0ip5d8544fzgc1bbankc4qlmznp8hay8dk5arp650";
    };
  };

  CryptUnixCryptXS = buildPerlPackage {
    pname = "Crypt-UnixCrypt_XS";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/Crypt-UnixCrypt_XS-0.11.tar.gz";
      sha256 = "1ajg3x6kwxy4x9p3nw1j36qjxpjvdpi9wkca5gfd86y9q8939sv2";
    };
  };

  CryptURandom = buildPerlPackage {
    pname = "Crypt-URandom";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/Crypt-URandom-0.36.tar.gz";
      sha256 = "81fec9921adc5d3c91cbe0ad8cb2bb89b045c4fb0de9cb3c43f17e58e477f8a1";
    };
    meta = {
      description = "Provide non blocking randomness";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptScryptKDF = buildPerlModule {
    pname = "Crypt-ScryptKDF";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/Crypt-ScryptKDF-0.010.tar.gz";
      sha256 = "7d16ee95cce3eb54c174673a7299f4c086fba3ac85f847d0e134feed5f776017";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    perlPreHook = "export LD=$CC";
    meta = {
      description = "Scrypt password based key derivation function";
      homepage = "https://github.com/DCIT/perl-Crypt-ScryptKDF";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptSmbHash = buildPerlPackage {
    pname = "Crypt-SmbHash";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
      sha256 = "0dxivcqmabkhpz5xzph6rzl8fvq9xjy26b2ci77pv5gsmdzari38";
    };
  };

  CryptSodium = buildPerlPackage {
    pname = "Crypt-Sodium";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGREGORO/Crypt-Sodium-0.11.tar.gz";
      sha256 = "0y3c24zv4iwnvlf9zwxambk8ddram54fm6l1m5yhbskc0nhp6z4h";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.libsodium.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.libsodium.out}/lib -lsodium";
    meta = {
      description = "Perl bindings for libsodium (NaCL)";
      homepage = "https://metacpan.org/release/Crypt-Sodium";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptTwofish = buildPerlPackage {
    pname = "Crypt-Twofish";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMS/Crypt-Twofish-2.18.tar.gz";
      sha256 = "00fms8v94wr3lmn1nqjcfw30p5scsyr4s3dah8ijm5w7c5fmb0aq";
    };
    meta = {
      description = "The Twofish Encryption Algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptOpenPGP = buildPerlPackage {
    pname = "Crypt-OpenPGP";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SROMANOV/Crypt-OpenPGP-1.12.tar.gz";
      sha256 = "e8a7ff2a993b76a69ad6dffdbe55755be5678b84e6ec494dcd9ab966f766f50e";
    };
    patches = [
      # See https://github.com/NixOS/nixpkgs/pull/93599
      ../development/perl-modules/crypt-openpgp-remove-impure-keygen-tests.patch
    ];
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AltCryptRSABigInt CryptCAST5_PP CryptDES_EDE3 CryptDSA CryptIDEA CryptRIPEMD160 CryptRijndael CryptTwofish FileHomeDir LWP ];

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/pgplet
    '';
    doCheck = false; /* test fails with 'No random source available!' */

    meta = {
      description = "Pure-Perl OpenPGP implementation";
      homepage = "https://github.com/btrott/Crypt-OpenPGP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      mainProgram = "pgplet";
    };
  };

  CryptOpenSSLAES = buildPerlPackage {
    pname = "Crypt-OpenSSL-AES";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TT/TTAR/Crypt-OpenSSL-AES-0.02.tar.gz";
      sha256 = "b66fab514edf97fc32f58da257582704a210c2b35e297d5c31b7fa2ffd08e908";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    meta = with lib; {
      description = "Perl wrapper around OpenSSL's AES library";
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLBignum = buildPerlPackage {
    pname = "Crypt-OpenSSL-Bignum";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz";
      sha256 = "1p22znbajq91lbk2k3yg12ig7hy5b4vy8igxwqkmbm4nhgxp4ki3";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
  };

  CryptOpenSSLGuess = buildPerlPackage {
    pname = "Crypt-OpenSSL-Guess";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.11.tar.gz";
      sha256 = "0rvi9l4ljcbhwwvspq019nfq2h2v746dk355h2nwnlmqikiihsxa";
    };
    meta = {
      description = "Guess OpenSSL include path";
      homepage = "https://github.com/akiym/Crypt-OpenSSL-Guess";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLRandom = buildPerlPackage {
    pname = "Crypt-OpenSSL-Random";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Crypt-OpenSSL-Random-0.15.tar.gz";
      sha256 = "1x6ffps8q7mnawmcfq740llzy7i10g3319vap0wiw4d33fm6z1zh";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    buildInputs = [ CryptOpenSSLGuess ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin && stdenv.isAarch64; # errors with: 74366 Abort trap: 6
    };
  };

  CryptOpenSSLRSA = buildPerlPackage {
    pname = "Crypt-OpenSSL-RSA";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Crypt-OpenSSL-RSA-0.31.tar.gz";
      sha256 = "4173403ad4cf76732192099f833fbfbf3cd8104e0246b3844187ae384d2c5436";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    buildInputs = [ CryptOpenSSLGuess ];
  };

  CryptOpenSSLX509 = buildPerlPackage rec {
    pname = "Crypt-OpenSSL-X509";
    version = "1.813";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JONASBN/Crypt-OpenSSL-X509-1.813.tar.gz";
      sha256 = "684bd888d2ed4c748f8f6dd8e87c14afa2974b12ee01faa082ad9cfa1e321e62";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    meta = {
      description = "Perl extension to OpenSSL's X509 API";
      homepage = "https://github.com/dsully/perl-crypt-openssl-x509";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptPBKDF2 = buildPerlPackage {
    pname = "Crypt-PBKDF2";
    version = "0.161520";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/Crypt-PBKDF2-0.161520.tar.gz";
      sha256 = "97dfa79a309a086e184a4e61047f8a10ffb3db051025e7d222a25f19130ba417";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DigestHMAC DigestSHA3 Moo TypeTiny namespaceautoclean strictures ];
    meta = {
      description = "The PBKDF2 password hash algorithm";
      homepage = "http://metacpan.org/release/Crypt-PBKDF2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptPerl = buildPerlPackage {
    pname = "Crypt-Perl";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Crypt-Perl-0.34.tar.gz";
      sha256 = "0e1cb223df0041f6d9b010f11e6f97a97ab55a118a273938eb4fe85d403f1b11";
    };
    checkInputs = [ pkgs.openssl MathBigIntGMP ];
    buildInputs = [ CallContext FileSlurp FileWhich TestClass TestDeep TestException TestFailWarnings TestNoWarnings ];
    propagatedBuildInputs = [ BytesRandomSecureTiny ClassAccessor ConvertASN1 CryptFormat MathProvablePrime SymbolGet TryTiny ];
    meta = {
      description = "Cryptography in pure Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptEd25519 = buildPerlPackage {
    pname = "Crypt-Ed25519";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Crypt-Ed25519-1.04.tar.gz";
      sha256 = "1jwh6b8b2ppvzxaljz287zakj4q3ip4zq121i23iwh26wxhlll2q";
    };

    nativeBuildInputs = [ CanaryStability ];
    buildInputs = [ CanaryStability ];

    meta = {
      description = "Minimal Ed25519 bindings";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  CryptSSLeay = buildPerlPackage {
    pname = "Crypt-SSLeay";
    version = "0.73_06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NANIS/Crypt-SSLeay-0.73_06.tar.gz";
      sha256 = "0b159lw3ia5r87qsgff3qhdnz3l09xcz04rbk4ji7fbyr12wmv7q";
    };

    makeMakerFlags = "--libpath=${lib.getLib pkgs.openssl}/lib --incpath=${pkgs.openssl.dev}/include";
    buildInputs = [ PathClass ];
    propagatedBuildInputs = [ BytesRandomSecure LWPProtocolHttps ];
  };

  CSSDOM = buildPerlPackage {
    pname = "CSS-DOM";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPROUT/CSS-DOM-0.17.tar.gz";
      sha256 = "09phb6c9czpcp9imq06khm54kspsx6hnvfrjxramx663ygmpifb5";
    };
    propagatedBuildInputs = [ Clone ];
  };

  CSSMinifier = buildPerlPackage {
    pname = "CSS-Minifier";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMICHAUX/CSS-Minifier-0.01.tar.gz";
      sha256 = "0Kk0m46LfoOrcM+IVM+7Qv8pwfbHyCmPIlfdIaoMf+8=";
    };
    meta = with lib; {
      description = "Perl extension for minifying CSS";
      license = licenses.artistic1;
      maintainers = teams.determinatesystems.members;
    };
  };

  CSSMinifierXS = buildPerlModule {
    pname = "CSS-Minifier-XS";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GT/GTERMARS/CSS-Minifier-XS-0.09.tar.gz";
      sha256 = "1myswrmh0sqp5xjpp03x45z8arfmgkjx0srl3r6kjsyzl1zrk9l8";
    };
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "XS based CSS minifier";
      homepage = "http://metacpan.org/release/CSS-Minifier-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CSSSquish = buildPerlPackage {
    pname = "CSS-Squish";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSIBLEY/CSS-Squish-0.10.tar.gz";
      sha256 = "65fc0d69acd1fa33d9a4c3b09cce0fbd737d747b1fcc4e9d87ebd91050cbcb4e";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Compact many CSS files into one big file";
      license = with lib.licenses; [ unfree ];
    };
  };

  Curses = buildPerlPackage {
    pname = "Curses";
    version = "1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GI/GIRAFFED/Curses-1.37.tar.gz";
      sha256 = "086vaj4wh5473hbp5f4amk6l0yzm66yxdcd2znz5pcqrmpiplw3l";
    };
    propagatedBuildInputs = [ pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lncurses";
    meta = {
      description = "Perl bindings to ncurses";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  CursesUI = buildPerlPackage {
    pname = "Curses-UI";
    version = "0.9609";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDXI/Curses-UI-0.9609.tar.gz";
      sha256 = "1bqf4h8z70f78nzqq5yj4ahvsbhxxal6bc2g301l9qdn2fjjgf0a";
    };
    propagatedBuildInputs = [ Curses TermReadKey ];
    meta = {
      description = "A curses based OO user interface framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CursesUIGrid = buildPerlPackage {
    pname = "Curses-UI-Grid";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADRIANWIT/Curses-UI-Grid-0.15.tar.gz";
      sha256 = "0820ca4a9fb949ba8faf97af574018baeffb694e980c5087bb6522aa70b9dbec";
    };
    propagatedBuildInputs = [ CursesUI TestPod TestPodCoverage ];
    meta = {
      description = "Create and manipulate data in grid model";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptX = buildPerlPackage {
    pname = "CryptX";
    version = "0.076";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/CryptX-0.076.tar.gz";
      sha256 = "sha256-u4SsASQ4x87NtRpab/+08f7jsOrgAi6WzrwuFnUiYhw=";
    };
    meta = {
      description = "Cryptographic toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptX509 = buildPerlPackage {
    pname = "Crypt-X509";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Crypt-X509-0.53.tar.gz";
      sha256 = "d2ff614f9457dc87ab277b81bced3532c3ed309b73b9a61aaefbe9488c9e660f";
    };
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "Parse a X.509 certificate";
      license = with lib.licenses; [ unfree ];
    };
  };

  CwdGuard = buildPerlModule {
    pname = "Cwd-Guard";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cwd-Guard-0.05.tar.gz";
      sha256 = "0xwf4rmii55k3lp19mpbh00mbgby7rxdk2lk84148bjhp6i7rz3s";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Temporary changing working directory (chdir)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataClone = buildPerlPackage {
    pname = "Data-Clone";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/Data-Clone-0.004.tar.gz";
      sha256 = "0g1qhi5qyk4fp0pwyaw90vxiyyn8las0i8ghzrnr4srai1wy3r9g";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Polymorphic data cloning";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataCompare = buildPerlPackage {
    pname = "Data-Compare";
    version = "1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Data-Compare-1.27.tar.gz";
      sha256 = "1gg8rqbv3x6a1lrpabv6vnlab53zxmpwz2ygad9fcx4gygqj12l1";
    };
    propagatedBuildInputs = [ Clone FileFindRule ];
  };

  DataDump = buildPerlPackage {
    pname = "Data-Dump";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.23.tar.gz";
      sha256 = "0r9ba52b7p8nnn6nw0ygm06lygi8g68piri78jmlqyrqy5gb0lxg";
    };
    meta = {
      description = "Pretty printing of data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDumperAutoEncode = buildPerlModule {
    pname = "Data-Dumper-AutoEncode";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BAYASHI/Data-Dumper-AutoEncode-1.00.tar.gz";
      sha256 = "2d9a0262ad443d321dc489ef6dfa7b3eed11a2708a75d397d371bb2585e5eca1";
    };
    buildInputs = [ ModuleBuildPluggable ModuleBuildPluggableCPANfile ];
    propagatedBuildInputs = [ IOInteractiveTiny ];
    meta = {
      description = "Dump with recursive encoding";
      license = with lib.licenses; [ artistic2 ];
      mainProgram = "edumper";
    };
  };

  DataDumperConcise = buildPerlPackage {
    pname = "Data-Dumper-Concise";
    version = "2.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Dumper-Concise-2.023.tar.gz";
      sha256 = "a6c22f113caf31137590def1b7028a7e718eface3228272d0672c25e035d5853";
    };
    meta = {
      description = "Less indentation and newlines plus sub deparsing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataEntropy = buildPerlModule {
    pname = "Data-Entropy";
    version = "0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Entropy-0.007.tar.gz";
      sha256 = "2611c4a1a3038594d79ea4ed14d9e15a9af8f77105f51667795fe4f8a53427e4";
    };
    propagatedBuildInputs = [ CryptRijndael DataFloat HTTPLite ParamsClassify ];
  };

  DataFloat = buildPerlModule {
    pname = "Data-Float";
    version = "0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Float-0.013.tar.gz";
      sha256 = "e2b1523d858930b8bbdbd196f08235f5e678b84919ba87712e26313b9c27518a";
    };
  };

  DataFormValidator = buildPerlPackage {
    pname = "Data-FormValidator";
    version = "4.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DF/DFARRELL/Data-FormValidator-4.88.tar.gz";
      sha256 = "c1a539f91c92cbcd8a8d83597ec9a7643fcd8ccf5a94e15382c3765289170066";
    };
    propagatedBuildInputs = [ DateCalc EmailValid FileMMagic ImageSize MIMETypes RegexpCommon ];
    buildInputs = [ CGI ];
    meta = {
      description = "Validates user input (usually from an HTML form) based on input profile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataGUID = buildPerlPackage {
    pname = "Data-GUID";
    version = "0.049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-GUID-0.049.tar.gz";
      sha256 = "0yx7d4qwsr9n85gslip0y3mdwr5fkncfbwxz7si2a17x95yl7bxq";
    };
    propagatedBuildInputs = [ DataUUID SubExporter ];
    meta = {
      description = "Globally unique identifiers";
      homepage = "https://github.com/rjbs/Data-GUID";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataHexDump = buildPerlPackage {
    pname = "Data-HexDump";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FT/FTASSIN/Data-HexDump-0.02.tar.gz";
      sha256 = "1a9d843e7f667c1c6f77c67af5d77e7462ff23b41937cb17454d03535cd9be70";
    };
    meta = {
      description = "Hexadecial Dumper";
      homepage = "https://github.com/neilb/Data-HexDump";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ AndersonTorres ];
      mainProgram = "hexdump";
    };
  };

  DataHexdumper = buildPerlPackage {
    pname = "Data-Hexdumper";
    version = "3.0001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Data-Hexdumper-3.0001.tar.gz";
      sha256 = "f9243cbe8affed5045fe4df505726a7a7289471e30c51ac065b3ed6ce0d1a604";
    };
    meta = {
      description = "Make binary data human-readable";
      license = with lib.licenses; [ artistic1 gpl2 ];
    };
  };

  DataHierarchy = buildPerlPackage {
    pname = "Data-Hierarchy";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz";
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    buildInputs = [ TestException ];
  };

  DataICal = buildPerlPackage {
    pname = "Data-ICal";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Data-ICal-0.24.tar.gz";
      sha256 = "7331c7c84886c53337c0db823615e0e7134a8f13efd284e5c20726d5bcd52dff";
    };
    buildInputs = [ TestLongString TestNoWarnings TestWarn ];
    propagatedBuildInputs = [ ClassReturnValue TextvFileasData ];
    meta = {
      description = "Generates iCalendar (RFC 2445) calendar files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataIEEE754 = buildPerlPackage {
    pname = "Data-IEEE754";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/Data-IEEE754-0.02.tar.gz";
      sha256 = "07b73dlxd0qmxgkkrpa2xr61y18v3adlf1qgnl9k90kj8q9spx66";
    };
    buildInputs = [ TestBits ];
    meta = {
      description = "Pack and unpack big-endian IEEE754 floats and doubles";
      homepage = "http://metacpan.org/release/Data-IEEE754";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DataInteger = buildPerlModule {
    pname = "Data-Integer";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Integer-0.006.tar.gz";
      sha256 = "0m53zxhx9sn49yqh7azlpyy9m65g54v8cd2ha98y77337gg7xdv3";
    };
  };

  DataMessagePack = buildPerlModule {
    pname = "Data-MessagePack";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Data-MessagePack-1.01.tar.gz";
      sha256 = "8fa0ed0101d04e661821a7b78e8d62ce3e19b299275bbfed178e2ba8912663ea";
    };
    buildInputs = [ ModuleBuildXSUtil TestRequires ];
    meta = {
      description = "A grep-like program for searching source code";
      homepage = "https://github.com/msgpack/msgpack-perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.DataMessagePack.x86_64-darwin
    };
  };

  DataOptList = buildPerlPackage {
    pname = "Data-OptList";
    version = "0.110";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-OptList-0.110.tar.gz";
      sha256 = "1hzmgr2imdg1fc3hmwx0d56fhsdfyrgmgx7jb4jkyiv6575ifq9n";
    };
    propagatedBuildInputs = [ ParamsUtil SubInstall ];
    meta = {
      description = "Parse and validate simple name/value option pairs";
      homepage = "https://github.com/rjbs/Data-OptList";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPage = buildPerlPackage {
    pname = "Data-Page";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Page-2.03.tar.gz";
      sha256 = "12rxrr2b11qjk0c437cisw2kfqkafw1awcng09cv6yhzglb55yif";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    buildInputs = [ TestException ];
  };

  DataPagePageset = buildPerlModule {
    pname = "Data-Page-Pageset";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHUNZI/Data-Page-Pageset-1.02.tar.gz";
      sha256 = "142isi8la383dbjxj7lfgcbmmrpzwckcc4wma6rdl8ryajsipb6f";
    };
    buildInputs = [ ClassAccessor DataPage TestException ];
    meta = {
      description = "Change long page list to be shorter and well navigate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPassword = buildPerlPackage {
    pname = "Data-Password";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz";
      sha256 = "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961";
    };
  };

  DataPerl = buildPerlPackage {
    pname = "Data-Perl";
    version = "0.002011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Data-Perl-0.002011.tar.gz";
      sha256 = "8d34dbe314cfa2d99bd9aae546bbde94c38bb05b74b07c89bde1673a6f6c55f4";
    };
    buildInputs = [ TestDeep TestFatal TestOutput ];
    propagatedBuildInputs = [ ClassMethodModifiers ListMoreUtils ModuleRuntime RoleTiny strictures ];
    meta = {
      description = "Base classes wrapping fundamental Perl data types";
      homepage = "https://github.com/tobyink/Data-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPrinter = buildPerlPackage {
    pname = "Data-Printer";
    version = "0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GARU/Data-Printer-0.40.tar.gz";
      sha256 = "0njjh8zp5afc4602jrnmg89icj7gfsil6i955ypcqxc2gl830sb0";
    };
    propagatedBuildInputs = [ ClonePP FileHomeDir PackageStash SortNaturally ];
    meta = {
      description = "Colored & full-featured pretty print of Perl data structures and objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataRandom = buildPerlPackage {
    pname = "Data-Random";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BAREFOOT/Data-Random-0.13.tar.gz";
      sha256 = "eb590184a8db28a7e49eab09e25f8650c33f1f668b6a472829de74a53256bfc0";
    };
    buildInputs = [ FileShareDirInstall TestMockTime ];
    meta = {
      description = "Perl module to generate random data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSection = buildPerlPackage {
    pname = "Data-Section";
    version = "0.200007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-Section-0.200007.tar.gz";
      sha256 = "1pmlxca0a8sv2jjwvhwgqavq6iwys6kf457lby4anjp3f1dpx4yd";
    };
    propagatedBuildInputs = [ MROCompat SubExporter ];
    buildInputs = [ TestFailWarnings ];
    meta = {
      description = "Read multiple hunks of data out of your DATA section";
      homepage = "https://github.com/rjbs/Data-Section";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSectionSimple = buildPerlPackage {
    pname = "Data-Section-Simple";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Data-Section-Simple-0.07.tar.gz";
      sha256 = "0b3035ffdb909aa1f7ded6b608fa9d894421c82c097d51e7171170d67579a9cb";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Read data from __DATA__";
      homepage = "https://github.com/miyagawa/Data-Section-Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSerializer = buildPerlModule {
    pname = "Data-Serializer";
    version = "0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEELY/Data-Serializer-0.65.tar.gz";
      sha256 = "048zjy8valnil8yawa3vrxr005rz95gpfwvmy2jq0g830195l58j";
    };
    meta = {
      description = "Modules that serialize data structures";
      homepage = "http://metacpan.org/release/Data-Serializer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSExpression = buildPerlPackage {
    pname = "Data-SExpression";
    version = "0.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NELHAGE/Data-SExpression-0.41.tar.gz";
      sha256 = "8162426a4285a094385fdfaf6d09ced106d5af57553f953acb1d56867dd0149b";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSpreadPagination = buildPerlPackage {
    pname = "Data-SpreadPagination";
    version = "0.1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNEW/Data-SpreadPagination-0.1.2.tar.gz";
      sha256 = "74ebfd847132c38cc9e835e14e82c43f1809a95cbc98bb84d1f7ce2e4ef487e3";
    };
    propagatedBuildInputs = [ DataPage MathRound ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStag = buildPerlPackage {
    pname = "Data-Stag";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CM/CMUNGALL/Data-Stag-0.14.tar.gz";
      sha256 = "4ab122508d2fb86d171a15f4006e5cf896d5facfa65219c0b243a89906258e59";
    };
    propagatedBuildInputs = [ IOString ];
    meta = {
      description = "Structured Tags";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStreamBulk = buildPerlPackage {
    pname = "Data-Stream-Bulk";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Data-Stream-Bulk-0.11.tar.gz";
      sha256 = "06e08432a6b97705606c925709b99129ad926516e477d58e4461e4b3d9f30917";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose PathClass namespaceclean ];
    meta = {
      description = "N at a time iteration API";
      homepage = "http://metacpan.org/release/Data-Stream-Bulk";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStructureUtil = buildPerlPackage {
    pname = "Data-Structure-Util";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/Data-Structure-Util-0.16.tar.gz";
      sha256 = "9cd42a13e65cb15f3a76296eb9a134da220168ec747c568d331a50ae7a2ddbc6";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "Change nature of data within a structure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataTaxi = buildPerlPackage {
    pname = "Data-Taxi";
    version = "0.96";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/Data-Taxi-0.96.tar.gz";
      sha256 = "0y4wls4jlwd6prvd77szymddhq9sfj06kaqnk4frlvd0zh83djxb";
    };
    buildInputs = [ DebugShowStuff ];
  };

  DataULID = buildPerlPackage {
    pname = "Data-ULID";
    version = "1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BALDUR/Data-ULID-1.0.0.tar.gz";
      sha256 = "4d757475893dbad5165f0a65c446d38b47f39019d36f77da9d29c98cbf27206f";
    };
    propagatedBuildInputs = [ DateTime EncodeBase32GMP MathRandomSecure ];
    meta = {
      description = "Universally Unique Lexicographically Sortable Identifier";
      homepage = "https://metacpan.org/release/Data-ULID";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  DataUniqid = buildPerlPackage {
    pname = "Data-Uniqid";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz";
      sha256 = "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb";
    };
  };

  DataUtil = buildPerlModule {
    pname = "Data-Util";
    version = "0.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Data-Util-0.66.tar.gz";
      sha256 = "1x662pqjg9p0wcigi7pwf969b2ymk66ncm2vd5dfm5i08pdkjpf3";
    };
    buildInputs = [ HashUtilFieldHashCompat ModuleBuildXSUtil ScopeGuard TestException ];
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "A selection of utilities for data and data types";
      homepage = "https://github.com/gfx/Perl-Data-Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.DataUtil.x86_64-darwin
    };
  };

  DataURIEncode = buildPerlPackage {
    pname = "Data-URIEncode";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/Data-URIEncode-0.11.tar.gz";
      sha256 = "51c9efbf8423853616eaa24841e4d1996b2db0036900617fb1dbc76c75a1f360";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataUUID = buildPerlPackage {
    pname = "Data-UUID";
    version = "1.226";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-UUID-1.226.tar.gz";
      sha256 = "0lv4k4ibxwkw7zz9hw97s34za9nvjxb4kbmgmx5sj4fll3zmfg89";
    };
  };

  DataUUIDMT = buildPerlPackage {
    pname = "Data-UUID-MT";
    version = "1.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz";
      sha256 = "0bb7qibq1c5lhaihxa1sck9pb744p8c7172jgx5zh4c32ac4nk1h";
    };
    buildInputs = [ ListAllUtils ];
    propagatedBuildInputs = [ MathRandomMTAuto ];
    meta = {
      description = "Fast random UUID generator using the Mersenne Twister algorithm";
      homepage = "https://metacpan.org/release/Data-UUID-MT";
      license = with lib.licenses; [ asl20 ];
    };
  };

  DataValidateDomain = buildPerlPackage {
    pname = "Data-Validate-Domain";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Data-Validate-Domain-0.14.tar.gz";
      sha256 = "4470f253b8d2720a4dd3fa3ae550995417c2269f3be7ff030e01afa04a3a9421";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ NetDomainTLD ];
    meta = {
      description = "Domain and host name validation";
      homepage = "https://metacpan.org/release/Data-Validate-Domain";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataValidateIP = buildPerlPackage {
    pname = "Data-Validate-IP";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Data-Validate-IP-0.27.tar.gz";
      sha256 = "e1aa92235dcb9c6fd9b6c8cda184d1af73537cc77f4f83a0f88207a8bfbfb7d6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ NetAddrIP ];
    meta = {
      description = "IPv4 and IPv6 validation methods";
      homepage = "https://metacpan.org/release/Data-Validate-IP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataValidateURI = buildPerlPackage {
    pname = "Data-Validate-URI";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SO/SONNEN/Data-Validate-URI-0.07.tar.gz";
      sha256 = "f06418d2a4603913d1b6ce52b167dd13e787e13bf2be325a065df7d408f79c60";
    };
    propagatedBuildInputs = [ DataValidateDomain DataValidateIP ];
    meta = {
      description = "Common URL validation methods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataVisitor = buildPerlPackage {
    pname = "Data-Visitor";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Visitor-0.31.tar.gz";
      sha256 = "0vjcsc2hbhml1w126673z31z9rr0hxz64f5rvk7drlmwicr6kc9b";
    };
    buildInputs = [ TestNeeds ];
    propagatedBuildInputs = [ Moose TieToObject namespaceclean ];
  };

  DateCalc = buildPerlPackage {
    pname = "Date-Calc";
    version = "6.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.4.tar.gz";
      sha256 = "1barz0jgdaan3jm7ciphs5n3ahwkl42imprs3y8c1dwpwyr3gqbw";
    };
    propagatedBuildInputs = [ BitVector ];
    doCheck = false; # some of the checks rely on the year being <2015
  };

  DateExtract = buildPerlPackage {
    pname = "Date-Extract";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Date-Extract-0.06.tar.gz";
      sha256 = "bc7658d5c50c3525ec0efcb55236a5de2d5d4fc06fc147fa3929c8f0953cda2b";
    };
    buildInputs = [ TestMockTime ];
    propagatedBuildInputs = [ DateTimeFormatNatural ];
  };

  DateManip = buildPerlPackage {
    pname = "Date-Manip";
    version = "6.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-6.83.tar.gz";
      sha256 = "1ylrj6g1sccnyd5k0dq3xl3l40y1jgcbpcb3jnjj5hknv3hv54gl";
    };
    # for some reason, parsing /etc/localtime does not work anymore - make sure that the fallback "/bin/date +%Z" will work
    patchPhase = ''
      sed -i "s#/bin/date#${pkgs.coreutils}/bin/date#" lib/Date/Manip/TZ.pm
    '';
    doCheck = !stdenv.isi686; # build freezes during tests on i686
    buildInputs = [ TestInter ];
    meta = {
      description = "Date manipulation routines";
      homepage = "https://github.com/SBECK-github/Date-Manip";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateSimple = buildPerlPackage {
    pname = "Date-Simple";
    version = "3.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz";
      sha256 = "29a1926314ce1681a312d6155c29590c771ddacf91b7485873ce449ef209dd04";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  DateTime = buildPerlPackage {
    pname = "DateTime";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-1.54.tar.gz";
      sha256 = "1rxjagwmkdlmksz1cbxwx2ad51pv5q7dri2djqkz44q7j1nxlbmi";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone ];
    meta = {
      description = "A date and time object for Perl";
      homepage = "https://metacpan.org/release/DateTime";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DateTimeCalendarJulian = buildPerlPackage {
    pname = "DateTime-Calendar-Julian";
    version = "0.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/DateTime-Calendar-Julian-0.102.tar.gz";
      sha256 = "0j95dhma66spjyb04zi6rwy7l33hibnrx02mn0znd9m89aiq52s6";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      description = "DateTime object in the Julian calendar";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeEventICal = buildPerlPackage {
    pname = "DateTime-Event-ICal";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-ICal-0.13.tar.gz";
      sha256 = "1skmykxbrf98ldi72d5s1v6228gfdr5iy4y0gpl0xwswxy247njk";
    };
    propagatedBuildInputs = [ DateTimeEventRecurrence ];
    meta = {
      description = "DateTime rfc2445 recurrences";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeEventRecurrence = buildPerlPackage {
    pname = "DateTime-Event-Recurrence";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-Recurrence-0.19.tar.gz";
      sha256 = "f9408789a461107766ca1a232bb3ec1e702eec7ca8167401ea6ec3f4b6d0b5a5";
    };
    propagatedBuildInputs = [ DateTimeSet ];
  };

  DateTimeFormatBuilder = buildPerlPackage {
    pname = "DateTime-Format-Builder";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz";
      sha256 = "61ffb23d85b3ca1786b2da3289e99b57e0625fe0e49db02a6dc0cb62c689e2f2";
    };
    propagatedBuildInputs = [ DateTimeFormatStrptime ParamsValidate ];
    meta = {
      description = "Create DateTime parser classes and objects";
      homepage = "https://metacpan.org/release/DateTime-Format-Builder";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DateTimeFormatDateParse = buildPerlModule {
    pname = "DateTime-Format-DateParse";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz";
      sha256 = "f6eca4c8be66ce9992ee150932f8fcf07809fd3d1664caf200b8a5fd3a7e5ebc";
    };
    propagatedBuildInputs = [ DateTime TimeDate ];
    meta = {
      description = "Parses Date::Parse compatible formats";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatFlexible = buildPerlPackage {
    pname = "DateTime-Format-Flexible";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THINC/DateTime-Format-Flexible-0.32.tar.gz";
      sha256 = "50a7b9feb287bb14b27323a53c2324486181a3ab6cb3f4c7662d42be901ad8ee";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ListMoreUtils ModulePluggable ];
    buildInputs = [ TestException TestMockTime TestNoWarnings ];
    meta = {
      description = "Flexibly parse strings and turn them into DateTime objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatHTTP = buildPerlModule {
    pname = "DateTime-Format-HTTP";
    version = "0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CK/CKRAS/DateTime-Format-HTTP-0.42.tar.gz";
      sha256 = "0h6qqdg1yzqkdxp7hqlp0qa7d1y64nilgimxs79dys2ryjfpcknh";
    };
    propagatedBuildInputs = [ DateTime HTTPDate ];
    meta = {
      description = "Date conversion routines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatICal = buildPerlModule {
    pname = "DateTime-Format-ICal";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ICal-0.09.tar.gz";
      sha256 = "8b09f6539f5e9c0df0e6135031699ed4ef9eef8165fc80aefeecc817ef997c33";
    };
    propagatedBuildInputs = [ DateTimeEventICal ];
    meta = {
      description = "Parse and format iCal datetime and duration strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatISO8601 = buildPerlPackage {
    pname = "DateTime-Format-ISO8601";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ISO8601-0.15.tar.gz";
      sha256 = "1afslsr2axkamdfjqk6i3w092hp20dznqffk4lgpxmxrd31ni5ql";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    buildInputs = [ Test2Suite ];
    meta = {
      description = "Parses ISO8601 formats";
      homepage = "https://metacpan.org/release/DateTime-HiRes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatMail = buildPerlPackage {
    pname = "DateTime-Format-Mail";
    version = "0.403";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/DateTime-Format-Mail-0.403.tar.gz";
      sha256 = "8df8e35c4477388ff5c7ce8b3e8b6ae4ed30209c7a5051d41737bd14d755fcb0";
    };
    propagatedBuildInputs = [ DateTime ParamsValidate ];
    meta = {
      description = "Convert between DateTime and RFC2822/822 formats";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatNatural = buildPerlModule {
    pname = "DateTime-Format-Natural";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHUBIGER/DateTime-Format-Natural-1.11.tar.gz";
      sha256 = "0lj5yh1k4dl06p9ydyscd4ic330w8ygz88m38bhzlbz42kxv13vk";
    };
    buildInputs = [ ModuleUtil TestMockTime ];
    propagatedBuildInputs = [ Clone DateTime ListMoreUtils ParamsValidate boolean ];
    meta = {
      description = "Parse informal natural language date/time strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dateparse";
    };
  };

  DateTimeFormatMySQL = buildPerlModule {
    pname = "DateTime-Format-MySQL";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XM/XMIKEW/DateTime-Format-MySQL-0.06.tar.gz";
      sha256 = "07cgz60gxvrv7xqvngyll60pa8cx93h3jyx9kc9wdkn95qbd864q";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format MySQL dates and times";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatPg = buildPerlModule {
    pname = "DateTime-Format-Pg";
    version = "0.16013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/DateTime-Format-Pg-0.16013.tar.gz";
      sha256 = "16siw0f3a0ilzv5fnfas5s9n92drjy271yf6qvmmpm0vwnjjx1kz";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Parse and format PostgreSQL dates and times";
      homepage = "https://github.com/lestrrat-p5/DateTime-Format-Pg";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatStrptime = buildPerlPackage {
    pname = "DateTime-Format-Strptime";
    version = "1.77";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.77.tar.gz";
      sha256 = "2fa43c838ecf5356f221a91a41c81dba22e7860c5474b4a61723259898173e4a";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTime ];
    meta = {
      description = "Parse and format strp and strf time patterns";
      homepage = "https://metacpan.org/release/DateTime-Format-Strptime";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DateTimeFormatSQLite = buildPerlPackage {
    pname = "DateTime-Format-SQLite";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/DateTime-Format-SQLite-0.11.tar.gz";
      sha256 = "cc1f4e0ae1d39b0d4c3dddccfd7423c77c67a70950c4b5ecabf8ca553ab294b4";
    };
    propagatedBuildInputs = [ DateTimeFormatBuilder ];
    meta = {
      description = "Parse and format SQLite dates and times";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatW3CDTF = buildPerlPackage {
    pname = "DateTime-Format-W3CDTF";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GW/GWILLIAMS/DateTime-Format-W3CDTF-0.07.tar.gz";
      sha256 = "69a02b661bbf1daa14a4813cb6786eaa66dbdf2743f0b3f458e30234c3a26268";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      description = "Parse and format W3CDTF datetime strings";
      homepage = "https://metacpan.org/release/DateTime-Format-W3CDTF";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeLocale = buildPerlPackage {
    pname = "DateTime-Locale";
    version = "1.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Locale-1.28.tar.gz";
      sha256 = "6c604d8c5c9c2739b78e0538a402283b82b1df419e60bef20b04843e4584bade";
    };
    buildInputs = [ CPANMetaCheck FileShareDirInstall IPCSystemSimple PathTiny Test2PluginNoWarnings Test2Suite TestFileShareDir ];
    propagatedBuildInputs = [ FileShareDir ParamsValidationCompiler Specio namespaceautoclean ];
    meta = {
      description = "Localization support for DateTime.pm";
      homepage = "https://metacpan.org/release/DateTime-Locale";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatRFC3339 = buildPerlPackage rec {
    pname = "DateTime-Format-RFC3339";
    version = "1.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEGAMI/DateTime-Format-RFC3339-v${version}.tar.gz";
      sha256 = "1xqdbbiksy6kapc3mv3ayjahmxxlzmb5x7rad4by1iii9hif2vhk";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      description = "Parse and format RFC3339 datetime strings";
      homepage = "http://search.cpan.org/dist/DateTime-Format-RFC3339";
      license = with lib.licenses; [ cc0 ];
    };
  };

  DateTimeSet = buildPerlModule {
    pname = "DateTime-Set";
    version = "0.3900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Set-0.3900.tar.gz";
      sha256 = "94f41c3924aafde4ef7fa6b58e0595d4038d8ac5ffd62ba111b13c5f4dbc0946";
    };
    propagatedBuildInputs = [ DateTime ParamsValidate SetInfinite ];
    meta = {
      description = "DateTime set objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeTimeZone = buildPerlPackage {
    pname = "DateTime-TimeZone";
    version = "2.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.44.tar.gz";
      sha256 = "09j5rqid1mv0cgm1vc89l2anbb3q8w4bzlm7sqrkiz9dk82x8gap";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassSingleton ParamsValidationCompiler Specio namespaceautoclean ];
    meta = {
      description = "Time zone object base class and factory";
      homepage = "https://metacpan.org/release/DateTime-TimeZone";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeXEasy = buildPerlPackage {
    pname = "DateTimeX-Easy";
    version = "0.089";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROKR/DateTimeX-Easy-0.089.tar.gz";
      sha256 = "17e6d202e7ac6049523048e97bb8f195e3c79208570da1504f4313584e487a79";
    };
    buildInputs = [ TestMost ];
    propagatedBuildInputs = [ DateTimeFormatFlexible DateTimeFormatICal DateTimeFormatNatural TimeDate ];
    doCheck = false;
    meta = {
      description = "Parse a date/time string using the best method available";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DebugShowStuff = buildPerlModule {
    pname = "Debug-ShowStuff";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/Debug-ShowStuff-1.16.tar.gz";
      sha256 = "1drcrnji3yrd0s3xb69bxnqa51s19c13w68vhvjad3nvswn5vpd4";
    };
    propagatedBuildInputs = [ ClassISA DevelStackTrace StringUtil TermReadKey TextTabularDisplay TieIxHash ];
    meta = {
      description = "A collection of handy debugging routines for displaying the values of variables with a minimum of coding";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Deliantra = buildPerlPackage rec {
    pname = "Deliantra";
    version = "2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${pname}-${version}.tar.gz";
      sha256 = "2716d9b1f05627d60942ce0634b9c1a25109b164818285d45b609ae8596e2b17";
    };
    propagatedBuildInputs = [ AnyEvent CompressLZF JSONXS commonsense ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCaller = buildPerlPackage {
    pname = "Devel-Caller";
    version = "2.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.06.tar.gz";
      sha256 = "1pxpimifzmnjnvf4icclx77myc15ahh0k56sj1djad1855mawwva";
    };
    propagatedBuildInputs = [ PadWalker ];
    meta = {
      description = "Meatier versions of caller";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCheckBin = buildPerlPackage {
    pname = "Devel-CheckBin";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Devel-CheckBin-0.04.tar.gz";
      sha256 = "1r735yzgvsxkj4m6ks34xva5m21cfzp9qiis2d4ivv99kjskszqm";
    };
    meta = {
      description = "Check that a command is available";
      homepage = "https://github.com/tokuhirom/Devel-CheckBin";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCheckCompiler = buildPerlModule {
    pname = "Devel-CheckCompiler";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Devel-CheckCompiler-0.07.tar.gz";
      sha256 = "1db973a4dbyknjxq608hywil5ai6vplnayshqxrd7m5qnjbpd2vn";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Check the compiler's availability";
      homepage = "https://github.com/tokuhirom/Devel-CheckCompiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelChecklib = buildPerlPackage {
    pname = "Devel-CheckLib";
    version = "1.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz";
      sha256 = "15621qh5gaan1sgmk9y9svl70nm8viw17x5h1kf0zknkk8lmw77j";
    };
    buildInputs = [ CaptureTiny MockConfig ];
  };

  DevelCheckOS = buildPerlPackage {
    pname = "Devel-CheckOS";
    version = "1.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Devel-CheckOS-1.85.tar.gz";
      sha256 = "1jjqwrx8mydyhqwwjlgimribz0yq0b6q66xnr6mgvyn63pdajhvg";
    };
    propagatedBuildInputs = [ FileFindRule ];
  };

  DevelLeak = buildPerlPackage rec {
    pname = "Devel-Leak";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NI-S/Devel-Leak-0.03.tar.gz";
      sha256 = "0lkj2xwc3lhxv7scl43r8kfmls4am0b98sqf5vmf7d72257w6hkg";
    };
    meta = {
      description = "Utility for looking for perl objects that are not reclaimed";
      homepage = "https://metacpan.org/release/Devel-Leak";
      license = with lib.licenses; [ artistic1 gpl1Plus ]; # According to Debian
    };
  };

  DevelPatchPerl = buildPerlPackage {
    pname = "Devel-PatchPerl";
    version = "2.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Devel-PatchPerl-2.08.tar.gz";
      sha256 = "06bl2qqf5mv53l7k81xgynfx99in5fa8yi3ykn7403r62rqfkik9";
    };
    propagatedBuildInputs = [ Filepushd ModulePluggable ];
    meta = {
      description = "Patch perl source a la Devel::PPPort's buildperl.pl";
      homepage = "https://github.com/bingos/devel-patchperl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "patchperl";
    };
  };

  DevelRefcount = buildPerlModule {
    pname = "Devel-Refcount";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Devel-Refcount-0.10.tar.gz";
      sha256 = "0jnaraqkigyinhwz4nqk1ndq7ssjizr98nd1dd183a6icdlx8m5n";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Obtain the REFCNT value of a referent";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPPPort = buildPerlPackage {
    pname = "Devel-PPPort";
    version = "3.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/Devel-PPPort-3.62.tar.gz";
      sha256 = "16w1mmx304bhql27mgy0l1qjwjr86vn7j0133i0hln9fdz2097gi";
    };
    meta = {
      description = "Perl/Pollution/Portability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelTrace = buildPerlPackage {
    pname = "Devel-Trace";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJD/Devel-Trace-0.12.tar.gz";
      sha256 = "0s1q1a05gk3xvwqkya3k05vqjk13rvb489g0frprhzpzfvvwl0gm";
    };
    meta = {
      description = "Print out each line before it is executed (like sh -x)";
      license = with lib.licenses; [ publicDomain ];
    };
  };

  DeviceMAC = buildPerlPackage {
    pname = "Device-MAC";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JASONK/Device-MAC-1.00.tar.gz";
      sha256 = "c42182a9a8489a314cbfe6e1c8452f32b3b626aa6c89fee1d8925e6dfb64fad5";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ DeviceOUI Moose ];
    meta = {
      description = "Handle hardware MAC Addresses (EUI-48 and EUI-64)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DeviceOUI = buildPerlPackage {
    pname = "Device-OUI";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JASONK/Device-OUI-1.04.tar.gz";
      sha256 = "4b367e61b1fadde77fb6fb729f3cd5acd1d46e71218d96f406bcba38d43b4bef";
    };
    buildInputs = [ TestException ];
    patches = [ ../development/perl-modules/Device-OUI-1.04-hash.patch ];
    propagatedBuildInputs = [ ClassAccessorGrouped LWP SubExporter ];
    meta = {
      description = "Resolve an Organizationally Unique Identifier";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBDCSV = buildPerlPackage {
    pname = "DBD-CSV";
    version = "0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HM/HMBRAND/DBD-CSV-0.56.tgz";
      sha256 = "16rhgchwlnnvjklca0d4sa3lmlj29zc0iwclk41y5fz6kg8c2qjs";
    };
    propagatedBuildInputs = [ DBI SQLStatement TextCSV_XS ];
  };

  DBDMock = buildPerlModule {
    pname = "DBD-Mock";
    version = "1.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JL/JLCOOPER/DBD-Mock-1.58.tar.gz";
      sha256 = "0g67r5i5qad5knjph4ybfpqxabgi2h7svpl3pgjrc4qh4h0vy7mv";
    };
    propagatedBuildInputs = [ DBI ];
    buildInputs = [ ModuleBuildTiny TestException ];
  };

  DBDSQLite = buildPerlPackage {
    pname = "DBD-SQLite";
    version = "1.70";

    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.70.tar.gz";
      sha256 = "0gpyv89p3yfwifbm005bz5ci8c63jikkfvafg8x7f3lyaggqvza0";
    };

    propagatedBuildInputs = [ DBI ];
    buildInputs = [ pkgs.sqlite ];

    patches = [
      # Support building against our own sqlite.
      ../development/perl-modules/DBD-SQLite/external-sqlite.patch

      # Pull upstream fix for test failures against sqlite-3.37.
      (fetchpatch {
        name = "sqlite-3.37-compat.patch";
        url = "https://github.com/DBD-SQLite/DBD-SQLite/commit/ba4f472e7372dbf453444c7764d1c342e7af12b8.patch";
        sha256 = "02lg1y6px7h89pfvgrf23anhbl3v050gn0kmaajvv5h6layhjzly";
      })
    ];

    makeMakerFlags = "SQLITE_INC=${pkgs.sqlite.dev}/include SQLITE_LIB=${pkgs.sqlite.out}/lib";

    postInstall = ''
      # Get rid of a pointless copy of the SQLite sources.
      rm -rf $out/${perl.libPrefix}/*/*/auto/share
    '';

    preCheck = "rm t/65_db_config.t"; # do not run failing tests

    meta = with lib; {
      description = "Self Contained SQLite RDBMS in a DBI Driver";
      license = with licenses; [ artistic1 gpl1Plus ];
      platforms = platforms.unix;
    };
  };

  DBDMariaDB = buildPerlPackage {
    pname = "DBD-MariaDB";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PALI/DBD-MariaDB-1.22.tar.gz";
      sha256 = "sha256-C2j9VCuWU/FbIFhXgZhjSNcehafjhD8JGZdwR6F5scY=";
    };
    buildInputs = [ pkgs.mariadb-connector-c DevelChecklib TestDeep TestDistManifest TestPod ];
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "MariaDB and MySQL driver for the Perl5 Database Interface (DBI)";
      homepage = "https://github.com/gooddata/DBD-MariaDB";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBDmysql = buildPerlPackage {
    pname = "DBD-mysql";
    version = "4.050";

    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz";
      sha256 = "0y4djb048i09dk19av7mzfb3khr72vw11p3ayw2p82jsy4gm8j2g";
    };

    buildInputs = [ pkgs.libmysqlclient DevelChecklib TestDeep TestDistManifest TestPod ];
    propagatedBuildInputs = [ DBI ];

    doCheck = false;

  #  makeMakerFlags = "MYSQL_HOME=${mysql}";
  };

  DBDOracle = buildPerlPackage {
    pname = "DBD-Oracle";
    version = "1.80";

    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJEVANS/DBD-Oracle-1.80.tar.gz";
      sha256 = "1rza36dywbsaync99ibscpqdp53m0yg2748bbib16gbf4cl2apph";
    };

    ORACLE_HOME = "${pkgs.oracle-instantclient.lib}/lib";

    buildInputs = [ pkgs.oracle-instantclient TestNoWarnings ];
    propagatedBuildInputs = [ DBI ];

    postBuild = lib.optionalString stdenv.isDarwin ''
      install_name_tool -add_rpath "${pkgs.oracle-instantclient.lib}/lib" blib/arch/auto/DBD/Oracle/Oracle.bundle
    '';
  };

  DBDPg = buildPerlPackage {
    pname = "DBD-Pg";
    version = "3.14.2";

    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TU/TURNSTEP/DBD-Pg-3.14.2.tar.gz";
      sha256 = "0kcfqq7g3832wiix0sbyvlc885qghjrp2ah3akn7h2lnb22fjwy9";
    };

    buildInputs = [ pkgs.postgresql ];
    propagatedBuildInputs = [ DBI ];

    makeMakerFlags = "POSTGRES_HOME=${pkgs.postgresql}";

    # tests freeze in a sandbox
    doCheck = false;

    meta = {
      description = "DBI PostgreSQL interface";
      homepage = "http://search.cpan.org/dist/DBD-Pg";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.unix;
    };
  };

  DBDsybase = buildPerlPackage {
    pname = "DBD-Sybase";
    version = "1.16";

    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ME/MEWP/DBD-Sybase-1.16.tar.gz";
      sha256 = "1k6n261nrrcll9wxn5xwi4ibpavqv1il96687k62mbpznzl2gx37";
    };

    SYBASE = pkgs.freetds;

    buildInputs = [ pkgs.freetds ];
    propagatedBuildInputs = [ DBI ];

    doCheck = false;

    meta = {
      description = "DBI driver for Sybase datasources";
      license = with lib.licenses; [ unfree ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.DBDsybase.x86_64-darwin
    };
  };

  DBFile = buildPerlPackage {
    pname = "DB_File";
    version = "1.855";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/DB_File-1.855.tar.gz";
      sha256 = "0q599h7g4jkzks5dxf1zifx9k7l9vif26r2dlgkzxkg6bfif5zyr";
    };

    preConfigure = ''
      cat > config.in <<EOF
      PREFIX = size_t
      HASH = u_int32_t
      LIB = ${pkgs.db.out}/lib
      INCLUDE = ${pkgs.db.dev}/include
      EOF
    '';
  };

  DBI = buildPerlPackage {
    pname = "DBI";
    version = "1.643";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/DBI-1.643.tar.gz";
      sha256 = "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa";
    };
    postInstall = lib.optionalString (perl ? crossVersion) ''
      mkdir -p $out/${perl.libPrefix}/cross_perl/${perl.version}/DBI
      cat > $out/${perl.libPrefix}/cross_perl/${perl.version}/DBI.pm <<EOF
      package DBI;
      BEGIN {
      our \$VERSION = "$version";
      }
      1;
      EOF

      autodir=$(echo $out/${perl.libPrefix}/${perl.version}/*/auto/DBI)
      cat > $out/${perl.libPrefix}/cross_perl/${perl.version}/DBI/DBD.pm <<EOF
      package DBI::DBD;
      use Exporter ();
      use vars qw (@ISA @EXPORT);
      @ISA = qw(Exporter);
      @EXPORT = qw(dbd_postamble);
      sub dbd_postamble {
          return '
      # --- This section was generated by DBI::DBD::dbd_postamble()
      DBI_INSTARCH_DIR=$autodir
      DBI_DRIVER_XST=$autodir/Driver.xst

      # The main dependency (technically correct but probably not used)
      \$(BASEEXT).c: \$(BASEEXT).xsi

      # This dependency is needed since MakeMaker uses the .xs.o rule
      \$(BASEEXT)\$(OBJ_EXT): \$(BASEEXT).xsi

      \$(BASEEXT).xsi: \$(DBI_DRIVER_XST) $autodir/Driver_xst.h
      ''\t\$(PERL) -p -e "s/~DRIVER~/\$(BASEEXT)/g" \$(DBI_DRIVER_XST) > \$(BASEEXT).xsi

      # ---
      ';
      }
      1;
      EOF
    '';
    meta = {
      description = "Database independent interface for Perl";
      homepage = "http://dbi.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBICxTestDatabase = buildPerlPackage {
    pname = "DBICx-TestDatabase";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/DBICx-TestDatabase-0.05.tar.gz";
      sha256 = "8e3bc2530b01216188c3aa65acdbd2f59c4e631f3ae085dfc439abd89f8f0acf";
    };
    buildInputs = [ DBIxClass TestSimple13 ];
    propagatedBuildInputs = [ DBDSQLite SQLTranslator ];
    meta = {
      description = "Create a temporary database from a DBIx::Class::Schema";
      homepage = "https://metacpan.org/pod/DBICx::TestDatabase";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBIxClass = buildPerlPackage {
    pname = "DBIx-Class";
    version = "0.082843";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/DBIx-Class-0.082843.tar.gz";
      sha256 = "sha256-NB4Lbssp2MSRdKbAnXxtvzhym6QBXuf9cDYKT/7h8lE=";
    };
    buildInputs = [ DBDSQLite TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped ClassC3Componentised ConfigAny ContextPreserve DBI DataDumperConcise DataPage DevelGlobalDestruction ModuleFind PathClass SQLAbstractClassic ScopeGuard SubName namespaceclean ];
    meta = {
      description = "Extensible and flexible object <-> relational mapper";
      homepage = "https://metacpan.org/pod/DBIx::Class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dbicadmin";
    };
  };

  DBIxClassCandy = buildPerlPackage {
    pname = "DBIx-Class-Candy";
    version = "0.005003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/DBIx-Class-Candy-0.005003.tar.gz";
      sha256 = "b8a229a7b15f559095d4561cf8220460128541ba7fc3545ed35869923d46565c";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ DBIxClass LinguaENInflect SubExporter ];
    meta = {
      description = "Sugar for your favorite ORM, DBIx::Class";
      homepage = "https://github.com/frioux/DBIx-Class-Candy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCursorCached = buildPerlPackage {
    pname = "DBIx-Class-Cursor-Cached";
    version = "1.001004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARCANEZ/DBIx-Class-Cursor-Cached-1.001004.tar.gz";
      sha256 = "09b2jahn2x12qm4f7qm1jzsxbz7qn1czp6a3fnl5l2i3l4r5421p";
    };
    buildInputs = [ CacheCache DBDSQLite ];
    propagatedBuildInputs = [ CarpClan DBIxClass ];
    meta = {
      description = "Cursor class with built-in caching support";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassDynamicDefault = buildPerlPackage {
    pname = "DBIx-Class-DynamicDefault";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/DBIx-Class-DynamicDefault-0.04.tar.gz";
      sha256 = "228f51ab224642584b4dc63db6de2667c5bfae2a894a9376b210a104806a5afb";
    };
    buildInputs = [ DBICxTestDatabase ];
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Automatically set and update fields";
      homepage = "https://metacpan.org/pod/DBIx::Class::DynamicDefault";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBIxClassHTMLWidget = buildPerlPackage {
    pname = "DBIx-Class-HTMLWidget";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/DBIx-Class-HTMLWidget-0.16.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [ DBIxClass HTMLWidget ];
  };

  DBIxClassHelpers = buildPerlPackage {
    pname = "DBIx-Class-Helpers";
    version = "2.036000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/DBIx-Class-Helpers-2.036000.tar.gz";
      sha256 = "b7b8b4891a983c034ef0b45f4112404a0a40550c4e217daeb7a22ca16861efdb";
    };
    buildInputs = [ DBDSQLite DateTimeFormatSQLite TestDeep TestFatal TestRoo aliased ];
    propagatedBuildInputs = [ CarpClan DBIxClassCandy DBIxIntrospector SafeIsa TextBrew ];
    meta = {
      description = "Simplify the common case stuff for DBIx::Class";
      homepage = "https://github.com/frioux/DBIx-Class-Helpers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassInflateColumnSerializer = buildPerlPackage {
    pname = "DBIx-Class-InflateColumn-Serializer";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRUIZ/DBIx-Class-InflateColumn-Serializer-0.09.tar.gz";
      sha256 = "6262b4871db6a6c45a0cbe7cde8f1b890b22c291add4ecc40caaeeab5a3a6f50";
    };
    buildInputs = [ DBDSQLite TestException ];
    propagatedBuildInputs = [ DBIxClass JSONMaybeXS YAML ];
    meta = {
      description = "Inflators to serialize data structures for DBIx::Class";
      homepage = "http://metacpan.org/release/DBIx-Class-InflateColumn-Serializer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBIxClassIntrospectableM2M = buildPerlPackage {
    pname = "DBIx-Class-IntrospectableM2M";
    version = "0.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/DBIx-Class-IntrospectableM2M-0.001002.tar.gz";
      sha256 = "c6baafb4241693fdb34b29ebd906993add364bf31aafa4462f3e062204cc87f0";
    };
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Introspect many-to-many relationships";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassSchemaLoader = buildPerlPackage {
    pname = "DBIx-Class-Schema-Loader";
    version = "0.07049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/DBIx-Class-Schema-Loader-0.07049.tar.gz";
      sha256 = "e869cdde1378cfebccf229b0cde58d2746dc6080b75f56d072aa5f1fce76a764";
    };
    buildInputs = [ DBDSQLite TestDeep TestDifferences TestException TestWarn ];
    propagatedBuildInputs = [ CarpClan ClassUnload DBIxClass DataDump StringToIdentifierEN curry ];
    meta = {
      description = "Create a DBIx::Class::Schema based on a database";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dbicdump";
    };
  };

  DBIxConnector = buildPerlModule {
    pname = "DBIx-Connector";
    version = "0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/DBIx-Connector-0.56.tar.gz";
      sha256 = "57c08d2c1951486cb95cfb83f518f462a3dbf20d353f3eee4f46af44fa19c359";
    };
    buildInputs = [ TestMockModule ];
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Fast, safe DBI connection and transaction management";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxDBSchema = buildPerlPackage {
    pname = "DBIx-DBSchema";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IV/IVAN/DBIx-DBSchema-0.45.tar.gz";
      sha256 = "7a2a978fb6d9feaa3e4b109c71c963b26a008a2d130c5876ecf24c5a72338a1d";
    };
    propagatedBuildInputs = [ DBI ];
  };

  DBIxSearchBuilder = buildPerlPackage {
    pname = "DBIx-SearchBuilder";
    version = "1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/DBIx-SearchBuilder-1.71.tar.gz";
      sha256 = "1ga2sjis6lg51z58il8q165klc38dmb3wj3phyxjfjg6yskdsbz4";
    };
    buildInputs = [ DBDSQLite ];
    propagatedBuildInputs = [ CacheSimpleTimedExpiry ClassAccessor ClassReturnValue Clone DBIxDBSchema Want capitalization ];
    meta = {
      description = "Encapsulate SQL queries and rows in simple perl objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxSimple = buildPerlPackage {
    pname = "DBIx-Simple";
    version = "1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JU/JUERD/DBIx-Simple-1.37.tar.gz";
      sha256 = "46d311aa2ce08907401c56119658426dbb044c5a40de73d9a7b79bf50390cae3";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Very complete easy-to-use OO interface to DBI";
      license = with lib.licenses; [ unfree ];
    };
  };

  DBMDeep = buildPerlPackage {
    pname = "DBM-Deep";
    version = "2.0016";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/S/SP/SPROUT/DBM-Deep-2.0016.tar.gz";
      sha256 = "sha256-kCp8eqBIjY0KDops89oOlrQJOuRx5rdy8MbViY5HDk0=";
    };
    buildInputs = [ TestDeep TestException TestPod TestPodCoverage TestWarn ];
    meta = {
      description = "A pure perl multi-level hash/array DBM that supports transactions";
      homepage = "https://github.com/robkinyon/dbm-deep";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataBinary = buildPerlPackage {
    pname = "Data-Binary";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SN/SNKWATT/Data-Binary-0.01.tar.gz";
      sha256 = "0wwdrgkz4yqpzdmfvid63v5v10b9hwdsg15jvks0hwdc23ga48a8";
    };
    meta = {
      description = "Simple detection of binary versus text in strings";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DataBuffer = buildPerlPackage {
    pname = "Data-Buffer";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BT/BTROTT/Data-Buffer-0.04.tar.gz";
      sha256 = "2b3d09b7bcf389fc116207b283bee250e348d44c9c63460bee67efab4dd21bb4";
    };
    meta = {
      description = "Read/write buffer class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBIxIntrospector = buildPerlPackage {
    pname = "DBIx-Introspector";
    version = "0.001005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/DBIx-Introspector-0.001005.tar.gz";
      sha256 = "0fp6h71xv4pgb8l815rs6ad4camzhjqf64s1sf7zmhchqqn4vacn";
    };

    propagatedBuildInputs = [ DBI Moo ];
    buildInputs = [ DBDSQLite TestFatal TestRoo ];
  };

  DevelCamelcadedb = buildPerlPackage {
    pname = "Devel-Camelcadedb";
    version = "2021.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HU/HURRICUP/Devel-Camelcadedb-v2021.2.tar.gz";
      sha256 = "88a1d9e95d398ffe4d4114861e21c36f7c22315b3d03e7f764ccbce018ab3e47";
    };
    propagatedBuildInputs = [ HashStoredIterator JSONXS PadWalker ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Perl side of the Perl debugger for IntelliJ IDEA and other JetBrains IDEs";
      license = with lib.licenses; [ mit ];
    };
  };

  DevelCycle = buildPerlPackage {
    pname = "Devel-Cycle";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/Devel-Cycle-1.12.tar.gz";
      sha256 = "1hhb77kz3dys8yaik452j22cm3510zald2mpvfyv5clqv326aczx";
    };
    meta = {
      description = "Find memory cycles in objects";
      license = with lib.licenses; [ unfree ];
    };
  };

  DevelDeclare = buildPerlPackage {
    pname = "Devel-Declare";
    version = "0.006022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-Declare-0.006022.tar.gz";
      sha256 = "72f29ca35646a593be98311ffddb72033ae1e8a9d8254c62aa248bd6260e596e";
    };
    buildInputs = [ ExtUtilsDepends TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope BHooksOPCheck SubName ];
    meta = {
      description = "(DEPRECATED) Adding keywords to perl, in perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelFindPerl = buildPerlPackage {
    pname = "Devel-FindPerl";
    version = "0.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Devel-FindPerl-0.015.tar.gz";
      sha256 = "1z1xfj3178w632mqddyklk355a19bsgzkilznrng3rvg4bfbfxaj";
    };
    meta = {
      description = "Find the path to your perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalDestruction = buildPerlPackage {
    pname = "Devel-GlobalDestruction";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz";
      sha256 = "1aslj6myylsvzr0vpqry1cmmvzbmpbdcl4v9zrl18ccik7rabf1l";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      description = "Provides function returning the equivalent of \${^GLOBAL_PHASE} eq 'DESTRUCT' for older perls";
      homepage = "https://metacpan.org/release/Devel-GlobalDestruction";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalPhase = buildPerlPackage {
    pname = "Devel-GlobalPhase";
    version = "0.003003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Devel-GlobalPhase-0.003003.tar.gz";
      sha256 = "1x9jzy3l7gwikj57swzl94qsq03j9na9h1m69azzs7d7ghph58wd";
    };
    meta = {
      description = "Detect perl's global phase on older perls";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelHide = buildPerlPackage {
    pname = "Devel-Hide";
    version = "0.0013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Devel-Hide-0.0013.tar.gz";
      sha256 = "1jvyy3yasiwyjsn9ay9sja3ch4wcjc4wk5l22vjsclq29z7vphvg";
    };
  };

  DevelNYTProf = buildPerlPackage {
    pname = "Devel-NYTProf";
    version = "6.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/Devel-NYTProf-6.10.tar.gz";
      sha256 = "24ac4174f1f01322063fa4e119b247d371d3260ddca6e778c6c1a0e3f905f58e";
    };
    propagatedBuildInputs = [ FileWhich JSONMaybeXS ];
    buildInputs = [ CaptureTiny TestDifferences ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/*
    '';
    meta = {
      description = "Powerful fast feature-rich Perl source code profiler";
      homepage = "https://code.google.com/p/perl-devel-nytprof";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelOverloadInfo = buildPerlPackage {
    pname = "Devel-OverloadInfo";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Devel-OverloadInfo-0.005.tar.gz";
      sha256 = "1rx6g8pyhi7lx6z130b7vlf8syzrq92w9ky8mpw4d6bwlkzy5zcb";
    };
    propagatedBuildInputs = [ MROCompat PackageStash SubIdentify ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Introspect overloaded operators";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPartialDump = buildPerlPackage {
    pname = "Devel-PartialDump";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-PartialDump-0.20.tar.gz";
      sha256 = "01yrsdpn9ns9iwwc92bhjn2605b7ys7i3198gjb935lsllzgzw5f";
    };
    propagatedBuildInputs = [ ClassTiny SubExporter namespaceclean ];
    buildInputs = [ TestSimple13 TestWarnings ];
  };

  DevelStackTrace = buildPerlPackage {
    pname = "Devel-StackTrace";
    version = "2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.04.tar.gz";
      sha256 = "cd3c03ed547d3d42c61fa5814c98296139392e7971c092e09a431f2c9f5d6855";
    };
    meta = {
      description = "An object representing a stack trace";
      homepage = "http://metacpan.org/release/Devel-StackTrace";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DevelSize = buildPerlPackage {
    pname = "Devel-Size";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWCLARK/Devel-Size-0.83.tar.gz";
      sha256 = "757a67e0aa59ae103ea5ca092cbecc025644ebdc326731688ffab6f8823ef4b3";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    pname = "Devel-StackTrace-AsHTML";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.15.tar.gz";
      sha256 = "0iri5nb2lb76qv5l9z0vjpfrq5j2fyclkd64kh020bvy37idp0v2";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "Displays stack trace in HTML";
      homepage = "https://github.com/miyagawa/Devel-StackTrace-AsHTML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSymdump = buildPerlPackage {
    pname = "Devel-Symdump";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/Devel-Symdump-2.18.tar.gz";
      sha256 = "826f81a107f5592a2516766ed43beb47e10cc83edc9ea48090b02a36040776c0";
    };
    meta = {
      description = "Dump symbol names or the symbol table";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestCRC = buildPerlPackage {
    pname = "Digest-CRC";
    version = "0.22.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLIMAUL/Digest-CRC-0.22.2.tar.gz";
      sha256 = "112b50f7fbc6f6baf5d4584ee97f542ced6c9ec03a3147f7902c84b8b26778cb";
    };
    meta = {
      description = "Module that calculates CRC sums of all sorts";
      license = with lib.licenses; [ publicDomain ];
    };
  };

  DigestHMAC = buildPerlPackage {
    pname = "Digest-HMAC";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz";
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      homepage = "http://metacpan.org/release/Digest-HMAC";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestJHash = buildPerlPackage {
    pname = "Digest-JHash";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Digest-JHash-0.10.tar.gz";
      sha256 = "c746cf0a861a004090263cd54d7728d0c7595a0cf90cbbfd8409b396ee3b0063";
    };
    meta = {
      description = "Perl extension for 32 bit Jenkins Hashing Algorithm";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DigestMD2 = buildPerlPackage {
    pname = "Digest-MD2";
    version = "2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Digest-MD2-2.04.tar.gz";
      sha256 = "d0aabf4834c20ac411bea427c4a308b59a5fcaa327679ef5294c1d68ab71eed3";
    };
    meta = {
      description = "Perl interface to the MD2 Algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DigestMD4 = buildPerlPackage {
    pname = "Digest-MD4";
    version = "1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/Digest-MD4-1.9.tar.gz";
      sha256 = "19ma1hmvgiznq95ngzvm6v4dfxc9zmi69k8iyfcg6w14lfxi0lb6";
    };
  };

  DigestMD5File = buildPerlPackage {
    pname = "Digest-MD5-File";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/Digest-MD5-File-0.08.tar.gz";
      sha256 = "060jzf45dlwysw5wsm7av1wvpl06xgk415kwwpvv89r6wda3md5d";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Perl extension for getting MD5 sums for files and urls";
      license = with lib.licenses; [ unfree ];
    };
  };

  DigestPerlMD5 = buildPerlPackage {
    pname = "Digest-Perl-MD5";
    version = "1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DELTA/Digest-Perl-MD5-1.9.tar.gz";
      sha256 = "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1";
    };
    meta = {
      description = "Perl Implementation of Rivest's MD5 algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestSHA1 = buildPerlPackage {
    pname = "Digest-SHA1";
    version = "2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz";
      sha256 = "1k23p5pjk42vvzg8xcn4iwdii47i0qm4awdzgbmz08bl331dmhb8";
    };
    meta = {
      description = "Perl interface to the SHA-1 algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestSHA3 = buildPerlPackage {
    pname = "Digest-SHA3";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSHELOR/Digest-SHA3-1.04.tar.gz";
      sha256 = "4a68b67c5034f40fbb1344b304cd66caaa5e320eb523005201cc24f76d470c14";
    };
    meta = {
      description = "Perl extension for SHA-3";
      homepage = "https://metacpan.org/release/Digest-SHA3";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      mainProgram = "sha3sum";
    };
  };

  DigestSRI = buildPerlPackage {
    pname = "Digest-SRI";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAUKEX/Digest-SRI-0.02.tar.gz";
      sha256 = "sha256-VITN/m68OYwkZfeBx3w++1OKOULNSyDWiBjG//kHT8c=";
    };
    meta = {
      description = "Calculate and verify Subresource Integrity hashes (SRI)";
      homepage = "https://github.com/haukex/Digest-SRI";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  DirManifest = buildPerlModule {
    pname = "Dir-Manifest";
    version = "0.6.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Dir-Manifest-0.6.1.tar.gz";
      sha256 = "01g54wlvp647zvhn0sxl2pqajly17044qd3pxib8cpixhwk75zw4";
    };
    propagatedBuildInputs = [ Moo PathTiny ];
    meta = {
      description = "Treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs";
      homepage = "http://metacpan.org/release/Dir-Manifest";
      license = with lib.licenses; [ mit ];
    };
  };

  DirSelf = buildPerlPackage {
    pname = "Dir-Self";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Dir-Self-0.11.tar.gz";
      sha256 = "e251a51abc7d9ba3e708f73c2aa208e09d47a0c528d6254710fa78cc8d6885b5";
    };
    meta = {
      description = "A __DIR__ constant for the directory your source file is in";
      homepage = "https://github.com/mauke/Dir-Self";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DispatchClass = buildPerlPackage {
    pname = "Dispatch-Class";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Dispatch-Class-0.02.tar.gz";
      sha256 = "10k5l4n2mp0hfn9jwn785k211n75y56zwny1zx3bvs7r38xv8kfp";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    meta = {
      description = "Dispatch on the type (class) of an argument";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistCheckConflicts = buildPerlPackage {
    pname = "Dist-CheckConflicts";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Dist-CheckConflicts-0.11.tar.gz";
      sha256 = "1i7dr9jpdiy2nijl2p4q5zg2q2s9ckbj2hs4kmnnckf9hsb4p17a";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Declare version conflicts for your dist";
      homepage = "http://metacpan.org/release/Dist-CheckConflicts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZilla = buildPerlPackage {
    pname = "Dist-Zilla";
    version = "6.017";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-6.017.tar.gz";
      sha256 = "1vkg5cyazhy2kdffwlcr2k52awlyfzxgr0vggs9mx2xc6g7313aw";
    };
    buildInputs = [ CPANMetaCheck TestDeep TestFailWarnings TestFatal TestFileShareDir ];
    propagatedBuildInputs = [ AppCmd CPANUploader ConfigMVPReaderINI DateTime FileCopyRecursive FileFindRule FileShareDirInstall Filepushd LogDispatchouli MooseXLazyRequire MooseXSetOnce MooseXTypesPerl PathTiny PerlPrereqScanner SoftwareLicense TermEncoding TermUI YAMLTiny ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/dzil
    '';
    doCheck = false;
    meta = {
      description = "Distribution builder; installer not included!";
      homepage = "http://dzil.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dzil";
    };
  };

  DistZillaPluginBundleTestingMania = buildPerlModule {
    pname = "Dist-Zilla-PluginBundle-TestingMania";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-PluginBundle-TestingMania-0.25.tar.gz";
      sha256 = "072rsilh88xnk18ldbr8d0svji72r79sabyird6xc3ql1z0b42sy";
    };
    buildInputs = [ MooseAutobox TestCPANMeta TestPerlCritic TestVersion ];
    propagatedBuildInputs = [ DistZillaPluginMojibakeTests DistZillaPluginTestCPANChanges DistZillaPluginTestCPANMetaJSON DistZillaPluginTestCompile DistZillaPluginTestDistManifest DistZillaPluginTestEOL DistZillaPluginTestKwalitee DistZillaPluginTestMinimumVersion DistZillaPluginTestNoTabs DistZillaPluginTestPerlCritic DistZillaPluginTestPodLinkCheck DistZillaPluginTestPortability DistZillaPluginTestSynopsis DistZillaPluginTestUnusedVars DistZillaPluginTestVersion PodCoverageTrustPod ];
    doCheck = false; /* fails with 'open3: exec of .. perl .. failed: Argument list too long at .../TAP/Parser/Iterator/Process.pm line 165.' */
    meta = {
      description = "Test your dist with every testing plugin conceivable";
      homepage = "http://metacpan.org/release/Dist-Zilla-PluginBundle-TestingMania";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginCheckChangeLog = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-CheckChangeLog";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FA/FAYLAND/Dist-Zilla-Plugin-CheckChangeLog-0.05.tar.gz";
      sha256 = "b0b34d6d70b56f1944d03c5f0dc3b8f6f24474c816d07b657a116c692c2e052a";
    };
    propagatedBuildInputs = [ DistZilla ];
    buildInputs = [ PathClass PodCoverage PodCoverageTrustPod PodMarkdown TestDeep TestException TestPod TestPodCoverage ];
    meta = {
      description = "Dist::Zilla with Changes check";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginMojibakeTests = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-MojibakeTests";
    version = "0.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYP/Dist-Zilla-Plugin-MojibakeTests-0.8.tar.gz";
      sha256 = "f1fff547ea24a8f7a483406a72ed6c4058d746d9dae963725502ddba025ab380";
    };
    propagatedBuildInputs = [ DistZilla ];
    buildInputs = [ TestMojibake ];
    meta = {
      description = "Author tests for source encoding";
      homepage = "https://github.com/creaktive/Dist-Zilla-Plugin-MojibakeTests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginPodWeaver = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-PodWeaver";
    version = "4.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-Plugin-PodWeaver-4.008.tar.gz";
      sha256 = "0ff1i26s54z292j8w8vm3gw3p7w1yq35wi8g978c84ia7y1y7n8z";
    };
    propagatedBuildInputs = [ DistZilla PodElementalPerlMunger PodWeaver ];
    meta = {
      description = "Weave your Pod together from configuration and Dist::Zilla";
      homepage = "https://github.com/rjbs/Dist-Zilla-Plugin-PodWeaver";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeAnyFromPod = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-ReadmeAnyFromPod";
    version = "0.163250";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeAnyFromPod-0.163250.tar.gz";
      sha256 = "d44f2799922f78b2a7961ed89123e11bdd77abfe85ba2040d82b80ad72ed13bc";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestFatal TestMost TestRequires TestSharedFork TestWarn ];
    propagatedBuildInputs = [ DistZillaRoleFileWatcher MooseXHasSugar PodMarkdownGithub ];
    meta = {
      description = "Automatically convert POD to a README in any format for Dist::Zilla";
      homepage = "https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeAnyFromPod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeMarkdownFromPod = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-ReadmeMarkdownFromPod";
    version = "0.141140";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.141140.tar.gz";
      sha256 = "9caad7b366ea59119ad73cdd99dcdd53f877a515bd0164fc28b339c01739a801";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ DistZillaPluginReadmeAnyFromPod ];
    meta = {
      description = "Automatically convert POD to a README.mkdn for Dist::Zilla";
      homepage = "https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeMarkdownFromPod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANChanges = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-Test-CPAN-Changes";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Changes-0.012.tar.gz";
      sha256 = "215b3a5c3c58c8bab0ea27130441bbdaec737eecc00f0670937f608bdbf64806";
    };
    buildInputs = [ CPANChanges TestDeep ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for your changelog";
      homepage = "http://metacpan.org/release/Dist-Zilla-Plugin-Test-CPAN-Changes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANMetaJSON = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-CPAN-Meta-JSON";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.004.tar.gz";
      sha256 = "0a573e1d5640374e6ee4d56d4fb94a3c67d4e75d52b3ddeae70cfa6450e1af22";
    };
    buildInputs = [ MooseAutobox TestCPANMetaJSON TestDeep ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Validate your CPAN META.json files";
      homepage = "http://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Meta::JSON";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DistZillaPluginTestCompile = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-Compile";
    version = "2.058";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Compile-2.058.tar.gz";
      sha256 = "d0cf93e525f102eca0f7f3967124d2e59d0a212f738ce54c1ddd91dda268d88a";
    };
    buildInputs = [ CPANMetaCheck ModuleBuildTiny TestDeep TestMinimumVersion TestWarnings ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Assert that your Perl files compile OK";
      homepage = "https://github.com/karenetheridge/Dist-Zilla-Plugin-Test-Compile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestDistManifest = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-DistManifest";
    version = "2.000005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-DistManifest-2.000005.tar.gz";
      sha256 = "4f0af27bb38745d2dec7d941bcf749e6d7fbeaf8e7bcf8a79a1310a9639b0f65";
    };
    buildInputs = [ TestDeep TestDistManifest TestOutput ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Author test that validates a package MANIFEST";
      homepage = "https://github.com/jawnsy/Test-DistManifest";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestEOL = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-EOL";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-EOL-0.19.tar.gz";
      sha256 = "0f23g931azz1k41xdfxw7kayy4snhw4qdr9ysknk5k1cl33mkfd2";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestEOL TestWarnings ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Check the correct line endings in your project";
      homepage = "https://github.com/karenetheridge/Test-EOL";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestKwalitee = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-Kwalitee";
    version = "2.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Kwalitee-2.12.tar.gz";
      sha256 = "bddbcfcc75e8eb2d2d9c8611552f00cdc1b051f0f00798623b8692ff5030af2f";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestFatal TestKwalitee ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Test the Kwalitee of a distribution before you release it";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestMinimumVersion = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-MinimumVersion";
    version = "2.000010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-MinimumVersion-2.000010.tar.gz";
      sha256 = "b8b71f4b64b689f4b647a3a87d6aaaae45a68892d35e36baa976f605736370fb";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestMinimumVersion TestOutput ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for minimum required versions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestNoTabs = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-NoTabs";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-NoTabs-0.15.tar.gz";
      sha256 = "196hchmn8y591533v3p7kl75nlhpaygbfdiw2iqbnab9j510qq8v";
    };
    propagatedBuildInputs = [ DistZilla ];
    buildInputs = [ ModuleBuildTiny TestDeep TestNoTabs TestRequires ];
    meta = {
      description = "Check the presence of tabs in your project";
      homepage = "https://github.com/karenetheridge/Dist-Zilla-Plugin-Test-NoTabs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPerlCritic = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-Perl-Critic";
    version = "3.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Perl-Critic-3.001.tar.gz";
      sha256 = "9250b59d5dc1ae4c6893ba783bd3f05131b14ff9e91afb4555314f55268a3825";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestPerlCritic ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Tests to check your code against best practices";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPodLinkCheck = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-Test-Pod-LinkCheck";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/Dist-Zilla-Plugin-Test-Pod-LinkCheck-1.004.tar.gz";
      sha256 = "325d236da0940388d2aa86ec5c1326516b4ad45adef8e7a4f83bb91d5ee15490";
    };
    # buildInputs = [ TestPodLinkCheck ];
    propagatedBuildInputs = [ DistZilla ];
    buildInputs = [ TestPodLinkCheck ];
    meta = {
      description = "Add release tests for POD links";
      homepage = "https://github.com/rwstauner/Dist-Zilla-Plugin-Test-Pod-LinkCheck";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPortability = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-Portability";
    version = "2.001000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Portability-2.001000.tar.gz";
      sha256 = "e08ff5bd9e24cf9503055330148913808d91a3dfe320a2bdf8b0fc638719b179";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestPortabilityFiles TestWarnings ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Author tests for portability";
      homepage = "https://github.com/karenetheridge/Dist-Zilla-Plugin-Test-Portability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestSynopsis = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-Test-Synopsis";
    version = "2.000007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Synopsis-2.000007.tar.gz";
      sha256 = "e7d5e2530cd8a5bb5aadf3e1669a653aaa96e32cad7bd6b9caba6b425ceab563";
    };
    buildInputs = [ TestDeep TestOutput TestSynopsis ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for synopses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestUnusedVars = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-UnusedVars";
    version = "2.000007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-UnusedVars-2.000007.tar.gz";
      sha256 = "ea0199a3a0043213ddc132508b9ed9b131ef717735b8f93d78291191d04b43c2";
    };
    buildInputs = [ TestDeep TestOutput TestVars ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for unused variables";
      homepage = "http://metacpan.org/release/Dist-Zilla-Plugin-Test-UnusedVars";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestVersion = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-Test-Version";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Dist-Zilla-Plugin-Test-Version-1.09.tar.gz";
      sha256 = "7240508731bc1bf6dfad7701ec65450a18ef9245a521ab26ebd6acb39a9ebe17";
    };
    buildInputs = [ Filechdir TestDeep TestEOL TestNoTabs TestScript TestVersion ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release Test::Version tests";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DistZillaRoleFileWatcher = buildPerlModule {
    pname = "Dist-Zilla-Role-FileWatcher";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Role-FileWatcher-0.006.tar.gz";
      sha256 = "15jfpr257xxp27gz156npgpj7kh2dchzgfmvzivi5bvdb2wl8fpy";
    };
    propagatedBuildInputs = [ DistZilla SafeIsa ];
    buildInputs = [ ModuleBuildTiny TestDeep TestFatal ];
    meta = {
      description = "Receive notification when something changes a file's contents";
      homepage = "https://github.com/karenetheridge/Dist-Zilla-Role-FileWatcher";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Dotenv = buildPerlPackage {
    pname = "Dotenv";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/Dotenv-0.002.tar.gz";
      sha256 = "04c7a7cc4511617d7a70c4ca410d10707dc496248cdad20240ae242223212454";
    };
    buildInputs = [ TestCPANMeta TestPod TestPodCoverage ];
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Support for dotenv in Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Dumbbench = buildPerlPackage {
    pname = "Dumbbench";
    version = "0.111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Dumbbench-0.111.tar.gz";
      sha256 = "1ixjb9y9d0k1vd4mzbi4sgvr99ay4z9jkgychf0r5gbjsskkq7fk";
    };
    propagatedBuildInputs = [ CaptureTiny ClassXSAccessor DevelCheckOS NumberWithError StatisticsCaseResampling ];
    meta = {
      description = "More reliable benchmarking with the least amount of thinking";
      homepage = "https://github.com/briandfoy/dumbbench";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dumbbench";
    };
  };

  EmailAbstract = buildPerlPackage {
    pname = "Email-Abstract";
    version = "3.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Abstract-3.008.tar.gz";
      sha256 = "fc7169acb6c43df7f005e7ef6ad08ee8ca6eb6796b5d1604593c997337cc8240";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ModulePluggable ];
    meta = {
      description = "Unified interface to mail representations";
      homepage = "https://github.com/rjbs/Email-Abstract";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddress = buildPerlPackage {
    pname = "Email-Address";
    version = "1.912";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.912.tar.gz";
      sha256 = "1vzr0vx4zsw4zbc9xdffc31wnkc1raqmyfiyws06fbyck197i8qg";
    };
    meta = {
      description = "RFC 2822 Address Parsing and Creation";
      homepage = "https://github.com/rjbs/Email-Address";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddressList = buildPerlPackage {
    pname = "Email-Address-List";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Email-Address-List-0.06.tar.gz";
      sha256 = "305b94c778011cee70d9f21514d92e985fa9dccbb84c64798f0c1f0b24eb870e";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ EmailAddress ];
    meta = {
      description = "RFC close address list parsing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailAddressXS = buildPerlPackage {
    pname = "Email-Address-XS";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PALI/Email-Address-XS-1.04.tar.gz";
      sha256 = "0gjrrl81z3sfwavgx5kwjd87gj44mlnbbqsm3dgdv1xllw26spwr";
    };
    meta = {
      description = "Parse and format RFC 5322 email addresses and groups";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailDateFormat = buildPerlPackage {
    pname = "Email-Date-Format";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Date-Format-1.005.tar.gz";
      sha256 = "579c617e303b9d874411c7b61b46b59d36f815718625074ae6832e7bb9db5104";
    };
    meta = {
      description = "Produce RFC 2822 date strings";
      homepage = "https://github.com/rjbs/Email-Date-Format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailReply = buildPerlPackage {
    pname = "Email-Reply";
    version = "1.204";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Reply-1.204.tar.gz";
      sha256 = "ba4fd80ac5017d6d132e0358c786b0ecd1c7adcbeee5c19fb3da2964791a56f0";
    };
    propagatedBuildInputs = [ EmailAbstract EmailAddress EmailMIME ];
    meta = {
      description = "Reply to an email message";
      homepage = "https://github.com/Perl-Email-Project/Email-Reply";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMessageID = buildPerlPackage {
    pname = "Email-MessageID";
    version = "1.406";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MessageID-1.406.tar.gz";
      sha256 = "1f22sdnfq169qw1l0lg7y74pmiam7j9v95bggjnf3q4mygdmshpc";
    };
    meta = {
      description = "Generate world unique message-ids";
      homepage = "https://github.com/rjbs/Email-MessageID";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMIME = buildPerlPackage {
    pname = "Email-MIME";
    version = "1.949";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-1.949.tar.gz";
      sha256 = "3b0adf6bb413cfe51d75f8ba79aca80deafc98dc1179aa7b2d7a79aff5a6ab9c";
    };
    propagatedBuildInputs = [ EmailAddressXS EmailMIMEContentType EmailMIMEEncodings EmailMessageID EmailSimple MIMETypes ModuleRuntime ];
    meta = {
      description = "Easy MIME message handling";
      homepage = "https://github.com/rjbs/Email-MIME";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMIMEAttachmentStripper = buildPerlPackage {
    pname = "Email-MIME-Attachment-Stripper";
    version = "1.317";
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ EmailAbstract EmailMIME ];

    src = fetchurl {
        url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-Attachment-Stripper-1.317.tar.gz";
        sha256 = "dcb98b09dc3e8f757ec3882a4234548108bb2d12e3cfadf95a26cef381a9e789";
    };
    meta = {
      description = "Strip the attachments from an email";
      homepage = "https://github.com/rjbs/Email-MIME-Attachment-Stripper";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMIMEContentType = buildPerlPackage {
    pname = "Email-MIME-ContentType";
    version = "1.024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-ContentType-1.024.tar.gz";
      sha256 = "42d164ac7ff4dc2ea848e710fe21fa85509a3bcbb91ed2d356e4aba951ed8835";
    };
    propagatedBuildInputs = [ TextUnidecode ];
    meta = {
      description = "Parse and build a MIME Content-Type or Content-Disposition Header";
      homepage = "https://github.com/rjbs/Email-MIME-ContentType";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMIMEEncodings = buildPerlPackage {
    pname = "Email-MIME-Encodings";
    version = "1.315";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-Encodings-1.315.tar.gz";
      sha256 = "4c71045507b31ec853dd60152b40e33ba3741779c0f49bb143b50cf8d243ab5c";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      description = "A unified interface to MIME encoding and decoding";
      homepage = "https://github.com/rjbs/Email-MIME-Encodings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailSend = buildPerlPackage {
    pname = "Email-Send";
    version = "2.201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Send-2.201.tar.gz";
      sha256 = "4bbec933558d7cc9b8152bad86dd313de277a21a89b4ea83d84e61587e95dbc6";
    };
    propagatedBuildInputs = [ EmailAbstract EmailAddress ReturnValue ];
    buildInputs = [ MIMETools MailTools ];
    meta = {
      description = "Simply Sending Email";
      homepage = "https://github.com/rjbs/Email-Send";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailOutlookMessage = buildPerlModule {
    pname = "Email-Outlook-Message";
    version = "0.920";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MV/MVZ/Email-Outlook-Message-0.920.tar.gz";
      sha256 = "1063wpdf90k1f6vcqvs92cwm93zvmh3l09pfnrrsp6vqkyah48lj";
    };
    propagatedBuildInputs = [ EmailMIME EmailSender IOAll IOString OLEStorage_Lite ];
    preCheck = "rm t/internals.t t/plain_jpeg_attached.t"; # these tests expect EmailMIME version 1.946 and fail with 1.949 (the output difference in benign)
    meta = with lib; {
      homepage = "https://www.matijs.net/software/msgconv/";
      description = "A .MSG to mbox converter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ peterhoeg ];
      mainProgram = "msgconvert";
    };
  };

  EmailSender = buildPerlPackage {
    pname = "Email-Sender";
    version = "1.300035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Sender-1.300035.tar.gz";
      sha256 = "0yfssp3rqdx1dmgvnygarzgkpkhqm28r5sd0gh87ksk8yxndhjql";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ EmailAbstract EmailAddress MooXTypesMooseLike SubExporter Throwable TryTiny ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postPatch = ''
      patchShebangs --build util
    '';
    preCheck = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang util/sendmail
    '';
    meta = {
      description = "A library for sending email";
      homepage = "https://github.com/rjbs/Email-Sender";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailSimple = buildPerlPackage {
    pname = "Email-Simple";
    version = "2.216";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.216.tar.gz";
      sha256 = "d85f63cd1088d11311103676a8cf498fff564a201b538de52cd753b5e5ca8bd4";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      description = "Simple parsing of RFC2822 message format and headers";
      homepage = "https://github.com/rjbs/Email-Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailStuffer = buildPerlPackage {
    pname = "Email-Stuffer";
    version = "0.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Stuffer-0.018.tar.gz";
      sha256 = "02wapphmcqbl1sg32x2az863lz5bb2dlckibxfqrjdlny27a406h";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ EmailMIME EmailSender ModuleRuntime ParamsUtil ];
    meta = {
      description = "A more casual approach to creating and sending Email:: emails";
      homepage = "https://github.com/rjbs/Email-Stuffer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  EmailValid = buildPerlPackage {
    pname = "Email-Valid";
    version = "1.202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-1.202.tar.gz";
      sha256 = "18hkmhddzbd23s6ak64d4j6q8ijykjyp5nxbr2hfcq1acsdhh8fh";
    };
    propagatedBuildInputs = [ IOCaptureOutput MailTools NetDNS NetDomainTLD ];
    doCheck = false;
  };

  EmailValidLoose = buildPerlPackage {
    pname = "Email-Valid-Loose";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Email-Valid-Loose-0.05.tar.gz";
      sha256 = "e718e76eddee240251c999e139c8cbe6f2cc80192da5af875cbd12fa8ab93a59";
    };
    propagatedBuildInputs = [ EmailValid ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Encode = buildPerlPackage {
    pname = "Encode";
    version = "3.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-3.19.tar.gz";
      sha256 = "sha256-kWP4SO72nk1MyIODl/CGH9nqft4AERfb2WlPjZUFLvU=";
    };
    meta = {
      description = "Character encodings in Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "piconv";
    };
  };

  EncodeBase32GMP = buildPerlPackage {
    pname = "Encode-Base32-GMP";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JW/JWANG/Encode-Base32-GMP-0.02.tar.gz";
      sha256 = "454206fa7d82e55e03274698732341b607150f00e8e2aec58f35326a030832dc";
    };
    buildInputs = [ TestBase ];
    propagatedBuildInputs = [ MathGMPz ];
    meta = {
      description = "High speed Base32 encoding using GMP with BigInt and MD5 support";
      homepage = "https://metacpan.org/release/Encode-Base32-GMP";
      license = with lib.licenses; [ mit ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  EncodeDetect = buildPerlModule {
    pname = "Encode-Detect";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JG/JGMYERS/Encode-Detect-1.01.tar.gz";
      sha256 = "834d893aa7db6ce3f158afbd0e432d6ed15a276e0940db0a74be13fd9c4bbbf1";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    meta = {
      description = "An Encode::Encoding subclass that detects the encoding of data";
      license = with lib.licenses; [ free ];
    };
  };


  EncodeEUCJPASCII = buildPerlPackage {
    pname = "Encode-EUCJPASCII";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz";
      sha256 = "f998d34d55fd9c82cf910786a0448d1edfa60bf68e2c2306724ca67c629de861";
    };
    outputs = [ "out" ];
    meta = {
      description = "EucJP-ascii - An eucJP-open mapping";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeHanExtra = buildPerlPackage {
    pname = "Encode-HanExtra";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz";
      sha256 = "1fd4b06cada70858003af153f94c863b3b95f2e3d03ba18d0451a81d51db443a";
    };
    meta = {
      description = "Extra sets of Chinese encodings";
      license = with lib.licenses; [ mit ];
    };
  };

  EncodeJIS2K = buildPerlPackage {
    pname = "Encode-JIS2K";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz";
      sha256 = "1ec84d72db39deb4dad6fca95acfcc21033f45a24d347c20f9a1a696896c35cc";
    };
    outputs = [ "out" ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  EncodeLocale = buildPerlPackage {
    pname = "Encode-Locale";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz";
      sha256 = "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1";
    };
    preCheck = if stdenv.isCygwin then ''
      sed -i"" -e "s@plan tests => 13@plan tests => 10@" t/env.t
      sed -i"" -e "s@ok(env(\"\\\x@#ok(env(\"\\\x@" t/env.t
    '' else null;
    meta = {
      description = "Determine the locale encoding";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeNewlines = buildPerlPackage {
    pname = "Encode-Newlines";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Encode-Newlines-0.05.tar.gz";
      sha256 = "1gipd3wnma28w5gjbzycfkpi6chksy14lhxkp4hwizf8r351zcrl";
    };
    meta = {
      description = "Normalize line ending sequences";
      homepage = "https://github.com/neilb/Encode-Newlines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodePunycode = buildPerlPackage {
    pname = "Encode-Punycode";
    version = "1.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/Encode-Punycode-1.002.tar.gz";
      sha256 = "ca3aceecdb80b5d45aa10e1cde8fec4e90b4f8c9189c7504dd8658f071f77194";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ NetIDNEncode ];
    meta = {
      description = "Encode plugin for Punycode (RFC 3492)";
      homepage = "http://search.cpan.org/dist/Encode-Punycode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  enum = buildPerlPackage {
    pname = "enum";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/enum-1.11.tar.gz";
      sha256 = "d2f36b5015f1e35f640159867b60bf5d5cd66b56cd5e42d33f531be68e5eee35";
    };
    meta = {
      description = "C style enumerated types and bitmask flags in Perl";
      homepage = "https://github.com/neilb/enum";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Env = buildPerlPackage {
    pname = "Env";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Env-1.04.tar.gz";
      sha256 = "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0";
    };
    meta = {
      description = "Perl module that imports environment variables as scalars or arrays";
      homepage = "http://search.cpan.org/dist/Env";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EnvPath = buildPerlPackage {
    pname = "Env-Path";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz";
      sha256 = "1qhmj15a66h90pjl2dgnxsb9jj3b1r5mpvnr87cafcl8g69z0jr4";
    };
    meta = {
      description = "Advanced operations on path variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "envpath";
    };
  };

  EnvSanctify = buildPerlPackage {
    pname = "Env-Sanctify";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Env-Sanctify-1.12.tar.gz";
      sha256 = "0prj51c9w4k6nrpnpfw6an96953vna74g698kyk78m163ikbbqr0";
    };
    meta = {
      description = "Lexically scoped sanctification of %ENV";
      homepage = "https://github.com/bingos/env-sanctify";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Error = buildPerlModule {
    pname = "Error";
    version = "0.17029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Error-0.17029.tar.gz";
      sha256 = "1p3spyarrh8y14d3j9s71xcndjlr70x3f8c3nvaddbij628zf8qs";
    };
  };

  EV = buildPerlPackage {
    pname = "EV";
    version = "4.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/EV-4.33.tar.gz";
      sha256 = "4aee8391b88113b42187f91fd49245fdc8e9b193a15ac202f519caae2aa8ea35";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ commonsense ];
    meta = {
      license = with lib.licenses; [ gpl1Plus ];
    };
  };

  EvalClosure = buildPerlPackage {
    pname = "Eval-Closure";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz";
      sha256 = "1bcc47r6zm3hfr6ccsrs72kgwxm3wkk07mgnpsaxi67cypr482ga";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      description = "Safely and cleanly create closures via string eval";
      homepage = "http://metacpan.org/release/Eval-Closure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExcelWriterXLSX = buildPerlPackage {
    pname = "Excel-Writer-XLSX";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/Excel-Writer-XLSX-1.09.tar.gz";
      sha256 = "d679c6ac19e93c32ab77594c793e41b948c7bb3873b600e70ad637d093dca187";
    };
    propagatedBuildInputs = [ ArchiveZip ];
    meta = {
      description = "Create a new file in the Excel 2007+ XLSX format";
      homepage = "http://jmcnamara.github.com/excel-writer-xlsx";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "extract_vba";
    };
  };

  ExceptionBase = buildPerlModule {
    pname = "Exception-Base";
    version = "0.2501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Base-0.2501.tar.gz";
      sha256 = "5723dd78f4ac0b4d262a05ea46af663ea00d8096b2e9c0a43515c210760e1e75";
    };
    buildInputs = [ TestUnitLite ];
    meta = {
      description = "Lightweight exceptions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionClass = buildPerlPackage {
    pname = "Exception-Class";
    version = "1.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Exception-Class-1.44.tar.gz";
      sha256 = "03gf4cdgrjnljgrlxkvbh2cahsyzn0zsh2zcli7b1lrqn7wgpwrk";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
  };

  ExceptionDied = buildPerlModule {
    pname = "Exception-Died";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Died-0.06.tar.gz";
      sha256 = "1dcajw2m3x5m76fpi3fvy9fjkmfrd171pnx087i5fkgx5ay41i1m";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
  };

  ExceptionWarning = buildPerlModule {
    pname = "Exception-Warning";
    version = "0.0401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Warning-0.0401.tar.gz";
      sha256 = "1a6k3sbhkxmz00wrmhv70f9kxjf7fklp1y6mnprfvcdmrsk9qdkv";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ];
  };

  ExporterDeclare = buildPerlModule {
    pname = "Exporter-Declare";
    version = "0.114";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Exporter-Declare-0.114.tar.gz";
      sha256 = "4bd70d6ca76f6f6ba7e4c618d4ac93b8593a58f1233ccbe18b10f5f204f1d4e4";
    };
    buildInputs = [ FennecLite TestException ];
    propagatedBuildInputs = [ MetaBuilder aliased ];
    meta = {
      description = "Exporting done right";
      homepage = "http://open-exodus.net/projects/Exporter-Declare";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterLite = buildPerlPackage {
    pname = "Exporter-Lite";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz";
      sha256 = "1hns15imih8z2h6zv3m1wwmv9fiysacsb52y94v6zf2cmw4kjny0";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    pname = "Exporter-Tiny";
    version = "1.002002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz";
      sha256 = "00f0b95716b18157132c6c118ded8ba31392563d19e490433e9a65382e707101";
    };
    meta = {
      description = "An exporter with the features of Sub::Exporter but only core dependencies";
      homepage = "https://metacpan.org/release/Exporter-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Expect = buildPerlPackage {
    pname = "Expect";
    version = "1.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JACOBY/Expect-1.35.tar.gz";
      sha256 = "09d92761421decd495853103379165a99efbf452c720f30277602cf23679fd06";
    };
    propagatedBuildInputs = [ IOTty ];
    meta = {
      description = "Automate interactions with command line programs that expose a text terminal interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExpectSimple = buildPerlPackage {
    pname = "Expect-Simple";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DJ/DJERIUS/Expect-Simple-0.04.tar.gz";
      sha256 = "af83b92185e642695913ff138efe819752e80857759996deafcaab2700ad5db5";
    };
    propagatedBuildInputs = [ Expect ];
    meta = {
      description = "Wrapper around the Expect module";
      license = with lib.licenses; [ free ];
    };
  };

  ExtUtilsCChecker = buildPerlModule {
    pname = "ExtUtils-CChecker";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/ExtUtils-CChecker-0.11.tar.gz";
      sha256 = "1x8vafpff5nma18svxp1h3mp069fjmzlsdvnbcgn3z1pgrkkcxqi";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Configure-time utilities for using C headers,";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConfig = buildPerlPackage {
    pname = "ExtUtils-Config";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz";
      sha256 = "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c";
    };
    meta = {
      description = "A wrapper for perl's configuration";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConstant = buildPerlPackage {
    pname = "ExtUtils-Constant";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWCLARK/ExtUtils-Constant-0.25.tar.gz";
      sha256 = "6933d0e963b62281ef7561068e6aecac8c4ac2b476b2bba09ab0b90fbac9d757";
    };
  };

  ExtUtilsCppGuess = buildPerlPackage {
    pname = "ExtUtils-CppGuess";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/ExtUtils-CppGuess-0.21.tar.gz";
      sha256 = "0ls1y9bb2nff9djli91s86541r7ajcjp22gqhcdmj7hs69w92qpz";
    };
    doCheck = !stdenv.isDarwin;
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    propagatedBuildInputs = [ CaptureTiny ];
    buildInputs = [ ModuleBuild ];
  };

  ExtUtilsDepends = buildPerlPackage {
    pname = "ExtUtils-Depends";
    version = "0.8000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.8000.tar.gz";
      sha256 = "165y1cjirbq64w39svkz82cb5jjqkjm8f4c0wqi2lk6050hzf3vq";
    };
    meta = {
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ artistic1 gpl1Plus artistic1 gpl1Plus ];
    };
  };

  ExtUtilsF77 = buildPerlPackage rec {
    pname = "ExtUtils-F77";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KG/KGB/ExtUtils-F77-1.24.tar.gz";
      sha256 = "355878a4a7f901eb18d21f9e21be8c8bfc6aaf9665d34b241bc1d43e32c5b730";
    };
    buildInputs = [ pkgs.gfortran ];
    propagatedBuildInputs = [ FileWhich ];
    meta = {
      description = "A simple interface to F77 libs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsHelpers = buildPerlPackage {
    pname = "ExtUtils-Helpers";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz";
      sha256 = "05ilqcj1rg5izr09dsqmy5di4fvq6ph4k0chxks7qmd4j1kip46y";
    };
    meta = {
      description = "Various portability utilities for module builders";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstall = buildPerlPackage {
    pname = "ExtUtils-Install";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Install-2.18.tar.gz";
      sha256 = "1i9hgvk3wcyshigfwvlrm2qilh8xvb7lfk3qdjrbnrrvl9xqgpg5";
    };
    meta = {
      description = "Install files from here to there";
      homepage = "https://metacpan.org/release/ExtUtils-Install";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstallPaths = buildPerlPackage {
    pname = "ExtUtils-InstallPaths";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz";
      sha256 = "1v9lshfhm9ck4p0v77arj5f7haj1mmkqal62lgzzvcds6wq5www4";
    };
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Build.PL install path logic made easy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsLibBuilder = buildPerlModule {
    pname = "ExtUtils-LibBuilder";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/ExtUtils-LibBuilder-0.08.tar.gz";
      sha256 = "1lmmfcjxvsvhn4f3v2lyylgr8dzcf5j7mnd1pkq3jc75dph724f5";
    };
    perlPreHook = "export LD=$CC";
    meta = {
      description = "A tool to build C libraries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsMakeMaker = buildPerlPackage {
    pname = "ExtUtils-MakeMaker";
    version = "7.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.62.tar.gz";
      sha256 = "5022ad857fd76bd3f6b16af099fe2324639d9932e08f21e891fb313d9cae1705";
    };
    meta = {
      description = "Create a module Makefile";
      homepage = "https://metacpan.org/release/ExtUtils-MakeMaker";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "instmodsh";
    };
  };

  ExtUtilsMakeMakerCPANfile = buildPerlPackage {
    pname = "ExtUtils-MakeMaker-CPANfile";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/ExtUtils-MakeMaker-CPANfile-0.09.tar.gz";
      sha256 = "0xg2z100vjhcndwaz9m3mmi90rb8h5pggpvlj1b0i8dhsh3pc1rc";
    };
    propagatedBuildInputs = [ ModuleCPANfile ];
    meta = {
      description = "Cpanfile support for EUMM";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsPkgConfig = buildPerlPackage {
    pname = "ExtUtils-PkgConfig";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-PkgConfig-1.16.tar.gz";
      sha256 = "bbeaced995d7d8d10cfc51a3a5a66da41ceb2bc04fedcab50e10e6300e801c6e";
    };
    nativeBuildInputs = [ buildPackages.pkg-config ];
    propagatedBuildInputs = [ pkgs.pkg-config ];
    postPatch = ''
      # no pkg-config binary when cross-compiling so the check fails
      substituteInPlace Makefile.PL \
        --replace "pkg-config" "$PKG_CONFIG"
    '';
    doCheck = false; # expects test_glib-2.0.pc in PKG_CONFIG_PATH
    meta = {
      description = "Simplistic interface to pkg-config";
      license = with lib.licenses; [ lgpl21Plus ];
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
  # [1] https://metacpan.org/pod/release/SMUELLER/ExtUtils-Typemap-1.00/lib/ExtUtils/Typemap.pm:
  ExtUtilsTypemap = buildPerlPackage {
    pname = "ExtUtils-Typemap";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-Typemap-1.00.tar.gz";
      sha256 = "1iqz0xlscg655gnwb2h1wrjj70llblps1zznl29qn1mv5mvibc5i";
    };
  };

  ExtUtilsTypemapsDefault = buildPerlModule {
    pname = "ExtUtils-Typemaps-Default";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-Typemaps-Default-1.05.tar.gz";
      sha256 = "1phmha0ks95kvzl00r1kgnd5hvg7qb1q9jmzjmw01p5zgs1zbyix";
    };
  };

  ExtUtilsXSBuilder = buildPerlPackage {
    pname = "ExtUtils-XSBuilder";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz";
      sha256 = "8cced386e3d544c5ec2deb3aed055b72ebcfc2ea9a6c807da87c4245272fe80a";
    };
    propagatedBuildInputs = [ ParseRecDescent TieIxHash ];
  };

  ExtUtilsXSpp = buildPerlModule {
    pname = "ExtUtils-XSpp";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-XSpp-0.18.tar.gz";
      sha256 = "1zx84f93lkymqz7qa4d63gzlnhnkxm5i3gvsrwkvvqr9cxjasxli";
    };
    buildInputs = [ TestBase TestDifferences ];
    meta = {
      description = "XS for C++";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "xspp";
    };
  };

  FatalException = buildPerlModule {
    pname = "Fatal-Exception";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Fatal-Exception-0.05.tar.gz";
      sha256 = "0kzfwc44vpxla3j637kfmnwmv57g6x4899ijqb4ljamk7whms298";
    };
    buildInputs = [ ExceptionWarning TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionDied ];
  };

  FCGI = buildPerlPackage {
    pname = "FCGI";
    version = "0.79";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/FCGI-0.79.tar.gz";
      sha256 = "1r1lzd74lzzdl2brcanw4n70m37nd8n6gv9clb55m3gv2hdlxylc";
    };
    postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      sed -i '/use IO::File/d' Makefile.PL
    '';
  };

  FCGIClient = buildPerlModule {
    pname = "FCGI-Client";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/FCGI-Client-0.09.tar.gz";
      sha256 = "1s11casbv0jmkcl5dk8i2vhfy1nc8rg43d3bg923zassrq4wndym";
    };
    propagatedBuildInputs = [ Moo TypeTiny ];
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Client library for fastcgi protocol";
      homepage = "https://github.com/tokuhirom/p5-fcgi-client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FCGIProcManager = buildPerlPackage {
    pname = "FCGI-ProcManager";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/FCGI-ProcManager-0.28.tar.gz";
      sha256 = "e1c958c042427a175e051e0008f2025e8ec80613d3c7750597bf8e529b04420e";
    };
    meta = {
      description = "A perl-based FastCGI process manager";
      license = with lib.licenses; [ unfree ];
    };
  };

  FFICheckLib = buildPerlPackage {
    pname = "FFI-CheckLib";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.27.tar.gz";
      sha256 = "0x1dk4hlhvcbgwivf345phbqz0v5hawxxnby21h8bkagq93jfi4d";
    };
    buildInputs = [ Test2Suite ];
    meta = {
      description = "Check that a library is available for FFI";
      homepage = "https://metacpan.org/pod/FFI::CheckLib";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FennecLite = buildPerlModule {
    pname = "Fennec-Lite";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Fennec-Lite-0.004.tar.gz";
      sha256 = "dce28e3932762c2ff92aa52d90405c06e898e81cb7b164ccae8966ae77f1dcab";
    };
    meta = {
      description = "Minimalist Fennec, the commonly used bits";
      homepage = "http://open-exodus.net/projects/Fennec-Lite";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileChangeNotify = buildPerlPackage {
    pname = "File-ChangeNotify";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/File-ChangeNotify-0.31.tar.gz";
      sha256 = "192bdb1ce76266c6a694a8e962d039e3adeeb829b6ac1e23f5057f2b506392bd";
    };
    buildInputs = [ Test2Suite TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ ModulePluggable Moo TypeTiny namespaceautoclean ];
    meta = with lib; {
      description = "Watch for changes to files, cross-platform style";
      license = licenses.artistic2;
    };
  };

  Filechdir = buildPerlPackage {
    pname = "File-chdir";
    version = "0.1010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz";
      sha256 = "009b8p2fzj4nhl03fpkhrn0rsh7myxqbrf69iqpzd86p1gs23hgg";
    };
  };

  FileBaseDir = buildPerlModule {
    version = "0.08";
    pname = "File-BaseDir";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KI/KIMRYAN/File-BaseDir-0.08.tar.gz";
      sha256 = "c065fcd3e2f22ae769937bcc971b91f80294d5009fac140bfba83bf7d35305e3";
    };
    configurePhase = ''
      runHook preConfigure
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    propagatedBuildInputs = [ IPCSystemSimple ];
    buildInputs = [ FileWhich ];
  };

  FileBOM = buildPerlModule {
    pname = "File-BOM";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTLAW/File-BOM-0.18.tar.gz";
      sha256 = "28edc43fcb118e11bc458c9ae889d56d388c1d9bc29997b00b1dffd8573823a3";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Readonly ];
    meta = {
      description = "Utilities for handling Byte Order Marks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCheckTree = buildPerlPackage {
    pname = "File-CheckTree";
    version = "4.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/File-CheckTree-4.42.tar.gz";
      sha256 = "66fb417f8ff8a5e5b7ea25606156e70e204861c59fa8c3831925b4dd3f155f8a";
    };
    meta = {
      description = "Run many filetest checks on a tree";
      homepage = "http://search.cpan.org/dist/File-CheckTree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filechmod = buildPerlPackage {
    pname = "File-chmod";
    version = "0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XE/XENO/File-chmod-0.42.tar.gz";
      sha256 = "6cafafff68bc84215168b55ede0d191dcb57f9a3201b51d61edb2858a2407795";
    };
    meta = {
      description = "Implements symbolic and ls chmod modes";
      homepage = "https://metacpan.org/dist/File-chmod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilechmodRecursive = buildPerlPackage {
    pname = "File-chmod-Recursive";
    version = "1.0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHUN/File-chmod-Recursive-v1.0.3.tar.gz";
      sha256 = "9348ca5c5b88deadcc483b9399ef7c2e0fc2504f9058db65f3c3c53c41139aa7";
    };
    propagatedBuildInputs = [ Filechmod ];
    meta = {
      description = "Run chmod recursively against directories";
      homepage = "https://github.com/mithun/perl-file-chmod-recursive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCopyRecursive = buildPerlPackage {
    pname = "File-Copy-Recursive";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.45.tar.gz";
      sha256 = "0mqivx4nbzagl3s2kxka72050sfb75xvn25j8a0f6ic3ibvir5yk";
    };
    buildInputs = [ PathTiny TestDeep TestFatal TestFile TestWarnings ];
  };

  FileCopyRecursiveReduced = buildPerlPackage {
    pname = "File-Copy-Recursive-Reduced";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/File-Copy-Recursive-Reduced-0.006.tar.gz";
      sha256 = "0b3yf33bahaf4ipfqipn8y5z4296k3vgzzsqbhh5ahwzls9zj676";
    };
    buildInputs = [ CaptureTiny PathTiny ];
    meta = {
      description = "Recursive copying of files and directories within Perl 5 toolchain";
      homepage = "http://thenceforward.net/perl/modules/File-Copy-Recursive-Reduced";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCountLines = buildPerlPackage {
    pname = "File-CountLines";
    version = "0.0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MORITZ/File-CountLines-v0.0.3.tar.gz";
      sha256 = "cfd97cce7c9613e4e569d47874a2b5704f1be9eced2f0739c870725694382a62";
    };
    meta = {
      description = "Efficiently count the number of line breaks in a file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileDesktopEntry = buildPerlPackage {
    version = "0.22";
    pname = "File-DesktopEntry";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MICHIELB/File-DesktopEntry-0.22.tar.gz";
      sha256 = "169c01e3dae2f629767bec1a9f1cdbd6ec6d713d1501e0b2786e4dd1235635b8";
    };
    propagatedBuildInputs = [ FileBaseDir URI ];
  };

  FileFindIterator = buildPerlPackage {
    pname = "File-Find-Iterator";
    version = "0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEXMEC/File-Find-Iterator-0.4.tar.gz";
      sha256 = "a2b87ab9756a2e5bb674adbd39937663ed20c28c716bf5a1095a3ca44d54ab2c";
    };
    propagatedBuildInputs = [ ClassIterator ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  FileFindObject = buildPerlModule {
    pname = "File-Find-Object";
    version = "0.3.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-0.3.5.tar.gz";
      sha256 = "dc4124abe64dc1274e8e8a5e5bf9e17a2a9269debace458115b57469f1e16a91";
    };
    propagatedBuildInputs = [ ClassXSAccessor ];
    meta = {
      description = "An object oriented File::Find replacement";
      homepage = "http://metacpan.org/release/File-Find-Object";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  FileFindObjectRule = buildPerlModule {
    pname = "File-Find-Object-Rule";
    version = "0.0312";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-Rule-0.0312.tar.gz";
      sha256 = "3e0b6c8dadf6362e65f2310530b1be637ed6aac113399d10c6f9129e734afff9";
    };
    propagatedBuildInputs = [ FileFindObject NumberCompare TextGlob ];
    # restore t/sample-data which is corrupted by patching shebangs
    preCheck = ''
      tar xf $src */t/sample-data --strip-components=1
    '';
    meta = {
      description = "Alternative interface to File::Find::Object";
      homepage = "http://www.shlomifish.org/open-source/projects/File-Find-Object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "findorule";
    };
  };

  FileFindRule = buildPerlPackage {
    pname = "File-Find-Rule";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz";
      sha256 = "1znachnhmi1w5pdqx8dzgfa892jb7x8ivrdy4pzjj7zb6g61cvvy";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob ];
    meta = {
      description = "File::Find::Rule is a friendlier interface to File::Find";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "findrule";
    };
  };

  FileFindRulePerl = buildPerlPackage {
    pname = "File-Find-Rule-Perl";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/File-Find-Rule-Perl-1.15.tar.gz";
      sha256 = "9a48433f86e08ce18e03526e2982de52162eb909d19735460f07eefcaf463ea6";
    };
    propagatedBuildInputs = [ FileFindRule ParamsUtil ];
    meta = {
      description = "Common rules for searching for Perl things";
      homepage = "https://github.com/karenetheridge/File-Find-Rule-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFinder = buildPerlPackage {
    pname = "File-Finder";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ME/MERLYN/File-Finder-0.53.tar.gz";
      sha256 = "2ecbc19ac67a9e635c872a807a8d3eaaff5babc054f15a191d47cdfc5f176a74";
    };
    propagatedBuildInputs = [ TextGlob ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Pluartistic1 gpl1Plus ];
    };
  };

  FileFnMatch = buildPerlPackage {
    pname = "File-FnMatch";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJP/File-FnMatch-0.02.tar.gz";
      sha256 = "05p9m7kpmjv8bmmbs5chb5fqyshcgmskbbzq5c9qpskbx2w5894n";
    };
    meta = {
      description = "Simple filename and pathname matching";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  FileGrep = buildPerlPackage {
    pname = "File-Grep";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MN/MNEYLON/File-Grep-0.02.tar.gz";
      sha256 = "462e15274eb6278521407ea302d9eea7252cd44cab2382871f7de833d5f85632";
    };
    meta = {
      description = "Find matches to a pattern in a series of files and related functions";
      license = with lib.licenses; [ unfree ];
      maintainers = teams.deshaw.members;
    };
  };

  FileHandleUnget = buildPerlPackage {
    pname = "FileHandle-Unget";
    version = "0.1634";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/FileHandle-Unget-0.1634.tar.gz";
      sha256 = "380f34ad3ce5e9ec661d4c468bb3392231c162317d4172df378146b42aab1785";
    };
    buildInputs = [ FileSlurper TestCompile UNIVERSALrequire URI ];
    meta = {
      description = "FileHandle which supports multi-byte unget";
      homepage = "https://github.com/coppit/filehandle-unget";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  FileHomeDir = buildPerlPackage {
    pname = "File-HomeDir";
    version = "1.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/File-HomeDir-1.006.tar.gz";
      sha256 = "0ll8akqmwrh9q3nkxhv2caxlaya1fr20nbhjsjsxmxph5p33fdsr";
    };
    propagatedBuildInputs = [ FileWhich ];
    preCheck = "export HOME=$TMPDIR";
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Find your home and other directories on any platform";
      homepage = "https://metacpan.org/release/File-HomeDir";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileKeePass = buildPerlPackage {
    pname = "File-KeePass";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz";
      sha256 = "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7";
    };
    propagatedBuildInputs = [ CryptRijndael ];
  };

  Filelchown = buildPerlModule {
    pname = "File-lchown";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/File-lchown-0.02.tar.gz";
      sha256 = "a02fbf285406a8a4d9399284f032f2d55c56975154c2e1674bd109837b8096ec";
    };
    buildInputs = [ ExtUtilsCChecker ];
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Modify attributes of symlinks without dereferencing them";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileLibMagic = buildPerlPackage {
    pname = "File-LibMagic";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/File-LibMagic-1.23.tar.gz";
      sha256 = "52e6b1dc7cb2d87a4cdf439ba145e0b9e8cf28cc26a48a3cf9977c83463967ee";
    };
    buildInputs = [ pkgs.file ConfigAutoConf TestFatal ];
    makeMakerFlags = "--lib=${pkgs.file}/lib";
    preCheck = ''
      substituteInPlace t/oo-api.t \
        --replace "/usr/share/file/magic.mgc" "${pkgs.file}/share/misc/magic.mgc"
    '';
    meta = {
      description = "Determine MIME types of data or files using libmagic";
      homepage = "https://metacpan.org/release/File::LibMagic";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.FileLibMagic.x86_64-darwin
    };
  };

  FileListing = buildPerlPackage {
    pname = "File-Listing";
    version = "6.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/File-Listing-6.14.tar.gz";
      sha256 = "1zs8gfngqsd6jbsqajf95kql3bshsis1nf16y8v4l5i33s3s9cqm";
    };
    propagatedBuildInputs = [ HTTPDate ];
  };

  FileLoadLines = buildPerlPackage {
    pname = "File-LoadLines";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/File-LoadLines-1.01.tar.gz";
      sha256 = "1lar8s1mc4d36lhxgqyk3hpwdc1bk6j6dfdzzacbjz4zlim6x33f";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Load lines from file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileMimeInfo = buildPerlPackage {
    pname = "File-MimeInfo";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MICHIELB/File-MimeInfo-0.30.tar.gz";
      sha256 = "0wm87gpagb35d7c4nyaf9z3ry0jb3g5xpyjfzcxqcfxyj2zy9ip2";
    };
    doCheck = false; # Failed test 'desktop file is the right one'
    buildInputs = [ FileBaseDir FileDesktopEntry EncodeLocale ];
  };

  FileMMagic = buildPerlPackage {
    pname = "File-MMagic";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNOK/File-MMagic-1.30.tar.gz";
      sha256 = "cf0c1b1eb29705c02d97c2913648009c0be42ce93ec24b36c696bf2d4f5ebd7e";
    };
    meta = {
      description = "Guess file type from contents";
      license = with lib.licenses; [ unfree ];
    };
  };

  FileMap = buildPerlModule {
    pname = "File-Map";
    version = "0.67";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/File-Map-0.67.tar.gz";
      sha256 = "1hpv4aprgypjxjx1kzbjnf6r29a98rw7mndlinixzk62vyz5sy0j";
    };
    perlPreHook = "export LD=$CC";
    propagatedBuildInputs = [ PerlIOLayers SubExporterProgressive ];
    buildInputs = [ TestFatal TestWarnings ];
    meta = {
      description = "Memory mapping made simple and safe";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileModified = buildPerlPackage {
    pname = "File-Modified";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/File-Modified-0.10.tar.gz";
      sha256 = "6b50b1aab6ec6998a017f6403c2735b3bc1e1cf46187bd134d7eb6df3fc45144";
    };
    meta = {
      description = "Checks intelligently if files have changed";
      homepage = "https://github.com/neilbowers/File-Modified";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileNext = buildPerlPackage {
    pname = "File-Next";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/File-Next-1.18.tar.gz";
      sha256 = "1vy2dqpc1nbjrnga08xr2hcxxfzifc5s2lfam5lf3djya0wwn07r";
    };
  };

  FileNFSLock = buildPerlPackage {
    pname = "File-NFSLock";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.29.tar.gz";
      sha256 = "0dzssj15faz9cn1w3xi7jwm64gyjyazapv4bkgglw5l1njcibm31";
    };
  };

  FilePath = buildPerlPackage {
    pname = "File-Path";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/File-Path-2.18.tar.gz";
      sha256 = "1pddss5hwzng0rxgsi8cz3hcsaarkxzkayydx53dylxkxlbhl3wq";
    };
    meta = {
      description = "Create or remove directory trees";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilePid = buildPerlPackage {
    pname = "File-Pid";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CW/CWEST/File-Pid-1.01.tar.gz";
      sha256 = "bafeee8fdc96eb06306a0c58bbdb7209b6de45f850e75fdc6b16db576e05e422";
    };
    patches = [(fetchpatch {
      name = "missing-pidfile.patch";
      url = "https://sources.debian.org/data/main/libf/libfile-pid-perl/1.01-2/debian/patches/missing-pidfile.patch";
      sha256 = "1wvax2qdpfs9mgksnc12dhby9b9w19isp50dc55wd3d741ihh6sl";
    })];
    propagatedBuildInputs = [ ClassAccessor ];
    meta = {
      description = "Pid File Manipulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  Filepushd = buildPerlPackage {
    pname = "File-pushd";
    version = "1.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/File-pushd-1.016.tar.gz";
      sha256 = "d73a7f09442983b098260df3df7a832a5f660773a313ca273fa8b56665f97cdc";
    };
    meta = {
      description = "Change directory temporarily for a limited scope";
      homepage = "https://github.com/dagolden/File-pushd";
      license = with lib.licenses; [ asl20 ];
    };
  };

  FileReadBackwards = buildPerlPackage {
    pname = "File-ReadBackwards";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UR/URI/File-ReadBackwards-1.05.tar.gz";
      sha256 = "82b261af87507cc3e7e66899c457104ebc8d1c09fb85c53f67c1f90f70f18d6e";
    };
    meta = {
      description = "Read a file backwards by lines";
      homepage = "https://metacpan.org/pod/File::ReadBackwards";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileRemove = buildPerlModule {
    pname = "File-Remove";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Remove-1.60.tar.gz";
      sha256 = "19lc9xr8w38i4bq3mbr0hadmyjm1dgyh6587gmlxbipdzx02lvp8";
    };
  };

  FileShare = buildPerlPackage {
    pname = "File-Share";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/File-Share-0.25.tar.gz";
      sha256 = "0w3h800qqcf1sn79h84zngnn788rg2jx4jjb70l44f6419p2b7cf";
    };
    propagatedBuildInputs = [ FileShareDir ];
    meta = {
      description = "Extend File::ShareDir to Local Libraries";
      homepage = "https://github.com/ingydotnet/file-share-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShareDir = buildPerlPackage {
    pname = "File-ShareDir";
    version = "1.118";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz";
      sha256 = "0n69h793jxz1zkp8ng6yqjwdh0yr0py0c8sg1bf5iyaxlc5s5civ";
    };
    propagatedBuildInputs = [ ClassInspector ];
    buildInputs = [ FileShareDirInstall ];
    meta = {
      description = "Locate per-dist and per-module shared files";
      homepage = "https://metacpan.org/release/File-ShareDir";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShareDirInstall = buildPerlPackage {
    pname = "File-ShareDir-Install";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/File-ShareDir-Install-0.13.tar.gz";
      sha256 = "1yc0wlkav2l2wr36a53n4mnhsy2zv29z5nm14mygxgjwv7qgvgj5";
    };
    meta = {
      description = "Install shared files";
      homepage = "https://github.com/Perl-Toolchain-Gang/File-ShareDir-Install";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilesysDf = buildPerlPackage {
    pname = "Filesys-Df";
    version = "0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IG/IGUTHRIE/Filesys-Df-0.92.tar.gz";
      sha256 = "fe89cbb427e0e05f1cd97c2dd6d3866ac6b21bc7a85734ede159bdc35479552a";
    };
    meta = {
      description = "Perl extension for filesystem disk space information.";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilesysNotifySimple = buildPerlPackage {
    pname = "Filesys-Notify-Simple";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.14.tar.gz";
      sha256 = "192m0l4cnfskdmhgaxk3bm1rvbmzxzwgcdgdb60qdqd59cnp3nhz";
    };
    buildInputs = [ TestSharedFork ];
    meta = {
      description = "Simple and dumb file system watcher";
      homepage = "https://github.com/miyagawa/Filesys-Notify-Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FilesysDiskUsage = buildPerlPackage {
    pname = "Filesys-DiskUsage";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/Filesys-DiskUsage-0.13.tar.gz";
      sha256 = "fd3e52c6f6241271a281348d1d43c44154c2f61a32543db46aa9e15692d1b713";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Estimate file space usage (similar to `du`)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "fdu";
    };
  };

  FileSlurp = buildPerlPackage {
    pname = "File-Slurp";
    version = "9999.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz";
      sha256 = "1c655gxs0pjm5yd50rcx4rbq1lr77p4a6x6xg4xbwhlx5acj2g2c";
    };
    meta = {
      description = "Simple and Efficient Reading/Writing/Modifying of Complete Files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileSlurper = buildPerlPackage {
    pname = "File-Slurper";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/File-Slurper-0.012.tar.gz";
      sha256 = "4efb2ea416b110a1bda6f8133549cc6ea3676402e3caf7529fce0313250aa578";
    };
    buildInputs = [ TestWarnings ];
    meta = {
      description = "A simple, sane and efficient module to slurp a file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileSlurpTiny = buildPerlPackage {
    pname = "File-Slurp-Tiny";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/File-Slurp-Tiny-0.004.tar.gz";
      sha256 = "452995beeabf0e923e65fdc627a725dbb12c9e10c00d8018c16d10ba62757f1e";
    };
    meta = {
      description = "A simple, sane and efficient file slurper [DISCOURAGED]";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileTail = buildPerlPackage {
    pname = "File-Tail";
    version = "1.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGRABNAR/File-Tail-1.3.tar.gz";
      sha256 = "1ixg6kn4h330xfw3xgvqcbzfc3v2wlzjim9803jflhvfhf0rzl16";
    };
    meta = {
      description = "Perl extension for reading from continously updated files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  FileTouch = buildPerlPackage {
    pname = "File-Touch";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/File-Touch-0.11.tar.gz";
      sha256 = "e379a5ff89420cf39906e5ceff309b8ce958f99f9c3e57ad52b5002a3982d93c";
    };
    meta = {
      description = "Update file access and modification times, optionally creating files if needed";
      homepage = "https://github.com/neilb/File-Touch";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  FileType = buildPerlModule {
    pname = "File-Type";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMISON/File-Type-0.22.tar.gz";
      sha256 = "0hfkaafp6wb0nw19x47wc6wc9mwlw8s2rxiii3ylvzapxxgxjp6k";
    };
    meta = {
      description = "Uses magic numbers (typically at the start of a file) to determine the MIME type of that file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileUtil = buildPerlModule {
    pname = "File-Util";
    version = "4.201720";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOMMY/File-Util-4.201720.tar.gz";
      sha256 = "d4491021850d5c5cbd702c7e4744858079841d2fa93f1c2d09ddc9a7863608df";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Easy, versatile, portable file handling";
      homepage = "https://github.com/tommybutler/file-util/wiki";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileUtilTempdir = buildPerlPackage {
    pname = "File-Util-Tempdir";
    version = "0.034";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/File-Util-Tempdir-0.034.tar.gz";
      sha256 = "076wdwbvqsg64wr5np8j6pnmmhs9li64g9mw2h33zbbgbv7f47fi";
    };
    buildInputs = [ Perlosnames TestException ];
    meta = {
      description = "Cross-platform way to get system-wide & user private temporary directory";
      homepage = "https://metacpan.org/release/File-Util-Tempdir";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  FileWhich = buildPerlPackage {
    pname = "File-Which";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz";
      sha256 = "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078";
    };
    meta = {
      description = "Perl implementation of the which utility as an API";
      homepage = "https://metacpan.org/pod/File::Which";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileZglob = buildPerlPackage {
    pname = "File-Zglob";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/File-Zglob-0.11.tar.gz";
      sha256 = "16v61rn0yimpv5kp6b20z2f1c93n5kpsyjvr0gq4w2dc43gfvc8w";
    };
    meta = {
      description = "Extended globs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filter = buildPerlPackage {
    pname = "Filter";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Filter-1.60.tar.gz";
      sha256 = "e11ef2f2ee8727b7f666fd249a3226f768e6eadfd51d9cdb49b3c3f1a35464f9";
    };
    meta = {
      description = "Source Filters";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FinanceQuote = buildPerlPackage {
    pname = "Finance-Quote";
    version = "1.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EC/ECOCODE/Finance-Quote-1.49.tar.gz";
      sha256 = "0lxz9fsm4ld3l900zxh2w91wjygk0ifn4miw6q5k4mm67d2c9nwm";
    };
    propagatedBuildInputs = [ CGI DateTimeFormatStrptime HTMLTableExtract JSON JSONParse LWPProtocolHttps StringUtil TextTemplate ];
    buildInputs = [ TestPod ];
    meta = with lib; {
      homepage = "http://finance-quote.sourceforge.net/";
      description = "Get stock and mutual fund quotes from various exchanges";
      license = licenses.gpl2;
    };
  };

  FindLib = buildPerlPackage {
    pname = "Find-Lib";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANNK/Find-Lib-1.04.tar.gz";
      sha256 = "0lg88v0sqfpq4d3jwvk6c9blqnpxbz8f4s22zr3b1qb160g94wqx";
    };
    meta = with lib; {
      description = "Helper to smartly find libs to use in the filesystem tree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FontAFM = buildPerlPackage {
    pname = "Font-AFM";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Font-AFM-1.20.tar.gz";
      sha256 = "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1";
    };
  };

  FontTTF = buildPerlPackage {
    pname = "Font-TTF";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/Font-TTF-1.06.tar.gz";
      sha256 = "4b697d444259759ea02d2c442c9bffe5ffe14c9214084a01f743693a944cc293";
    };
    buildInputs = [ IOString ];
    meta = {
      description = "TTF font support for Perl";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ForksSuper = buildPerlPackage {
    pname = "Forks-Super";
    version = "0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MOB/Forks-Super-0.97.tar.gz";
      sha256 = "0kias11b4zchxy5x9ns2wwjzvzxlzsbap8sq587z9micw5bl7nrk";
    };
    doCheck = false;
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Extensions and convenience methods to manage background processes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FormValidatorSimple = buildPerlPackage {
    pname = "FormValidator-Simple";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LY/LYOKATO/FormValidator-Simple-0.29.tar.gz";
      sha256 = "fc3a63dc54b962d74586070176adaf5be869f09b561bb30f5fd32ef531792666";
    };
    propagatedBuildInputs = [ ClassAccessor ClassDataAccessor DateCalc DateTimeFormatStrptime EmailValidLoose ListMoreUtils TieIxHash UNIVERSALrequire YAML ];
    buildInputs = [ CGI ];
    meta = {
      description = "Validation with simple chains of constraints";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FreezeThaw = buildPerlPackage {
    pname = "FreezeThaw";
    version = "0.5001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.5001.tar.gz";
      sha256 = "0h8gakd6b9770n2xhld1hhqghdar3hrq2js4mgiwxy86j4r0hpiw";
    };
    doCheck = false;
  };

  FunctionParameters = buildPerlPackage {
    pname = "Function-Parameters";
    version = "2.001003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Function-Parameters-2.001003.tar.gz";
      sha256 = "eaa22c6b43c02499ec7db0758c2dd218a3b2ab47a714b2bdf8010b5ee113c242";
    };
    buildInputs = [ DirSelf TestFatal ];
    meta = {
      description = "Define functions and methods with parameter lists (\"subroutine signatures\")";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Furl = buildPerlModule {
    pname = "Furl";
    version = "3.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Furl-3.13.tar.gz";
      sha256 = "1wxa2v9yjzvnzp62p1jvcx8x61z5qvlvzyah853vvaywpjxwyyl8";
    };
    propagatedBuildInputs = [ ClassAccessorLite HTTPParserXS MozillaCA ];
    buildInputs = [ HTTPCookieJar HTTPProxy ModuleBuildTiny Plack Starlet TestFakeHTTPD TestRequires TestSharedFork TestTCP TestValgrind URI ];
    meta = {
      description = "Lightning-fast URL fetcher";
      homepage = "https://github.com/tokuhirom/Furl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Future = buildPerlModule {
    pname = "Future";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Future-0.48.tar.gz";
      sha256 = "sha256-D+ixXBQvKjBKMXGKIKEFA6m0TMASw69eN7i34koHUqM=";
    };
    buildInputs = [ TestFatal TestIdentity TestRefcount ];
    meta = {
      description = "Represent an operation awaiting completion";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FutureAsyncAwait = buildPerlModule rec {
    pname = "Future-AsyncAwait";
    version = "0.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Future-AsyncAwait-0.58.tar.gz";
      sha256 = "sha256-OLtJ9jabBUrAUuaNomR/4i0Io605rgNuJ6KRELtOQi4=";
    };
    buildInputs = [ TestRefcount TestFatal ];
    propagatedBuildInputs = [ Future XSParseKeyword XSParseSublike ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Deferred subroutine syntax for futures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  FutureIO = buildPerlModule {
    pname = "Future-IO";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Future-IO-0.11.tar.gz";
      sha256 = "sha256-dVM2JvgfdoxfIxyXAhBsJbV3KotplcqixYvMSsyRB8k=";
    };
    buildInputs = [ TestIdentity ];
    propagatedBuildInputs = [ Future StructDumb ];
    preCheck = "rm t/06connect.t"; # this test fails in sandbox
    meta = {
      description = "Future-returning IO methods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  GamesSolitaireVerify = buildPerlModule {
    pname = "Games-Solitaire-Verify";
    version = "0.2403";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Games-Solitaire-Verify-0.2403.tar.gz";
      sha256 = "e5ab475c82ba1cb088ad28f423ca514d46944d6ae3c3eb55e9636e9e7f1dc893";
    };
    buildInputs = [ DirManifest TestDifferences ];
    propagatedBuildInputs = [ ClassXSAccessor ExceptionClass PathTiny ];
    meta = {
      description = "Verify solutions for solitaire games";
      homepage = "http://metacpan.org/release/Games-Solitaire-Verify";
      license = with lib.licenses; [ mit ];
      mainProgram = "verify-solitaire-solution";
    };
  };

  GD = buildPerlPackage {
    pname = "GD";
    version = "2.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/GD-2.73.tar.gz";
      sha256 = "0arjpa8id6k5yjxfq0j2hsinhhjzjch5lwk6gscf48l54drrw729";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype pkgs.libpng pkgs.fontconfig pkgs.xorg.libXpm ExtUtilsPkgConfig TestFork ];

    # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
    hardeningDisable = [ "format" ];

    makeMakerFlags = "--lib_png_path=${pkgs.libpng.out} --lib_jpeg_path=${pkgs.libjpeg.out} --lib_zlib_path=${pkgs.zlib.out} --lib_ft_path=${pkgs.freetype.out} --lib_fontconfig_path=${pkgs.fontconfig.lib} --lib_xpm_path=${pkgs.xorg.libXpm.out}";

    meta = {
      description = "Perl interface to the gd2 graphics library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "bdf2gdfont.pl";
    };
  };

  GDGraph = buildPerlPackage {
    pname = "GDGraph";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RUZ/GDGraph-1.54.tar.gz";
      sha256 = "0kzsdc07ycxjainmz0dnsclb15w2j1y7g8b5mcb7vhannq85qvxr";
    };
    propagatedBuildInputs = [ GDText ];
    buildInputs = [ CaptureTiny TestException ];
    meta = {
      description = "Graph Plotting Module for Perl 5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDSecurityImage = buildPerlPackage {
    pname = "GD-SecurityImage";
    version = "1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BU/BURAK/GD-SecurityImage-1.75.tar.gz";
      sha256 = "19lf1kzdavrkkx3f900jnpynr55d5kjd2sdmwpfir5dsmkcj9pix";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Security image (captcha) generator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GDText = buildPerlPackage {
    pname = "GDTextUtil";
    version = "0.86";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MV/MVERB/GDTextUtil-0.86.tar.gz";
      sha256 = "1g0nc7fz4d672ag7brlrrcz7ibm98x49qs75bq9z957ybkwcnvl8";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Text utilities for use with GD";
      license = with lib.licenses; [ unfree ];
    };
  };

  GeoIP = buildPerlPackage {
    pname = "Geo-IP";
    version = "1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/Geo-IP-1.51.tar.gz";
      sha256 = "1fka8fr7fw6sh3xa9glhs1zjg3s2gfkhi7n7da1l2m2wblqj0c0n";
    };
    makeMakerFlags = "LIBS=-L${pkgs.geoip}/lib INC=-I${pkgs.geoip}/include";
    doCheck = false; # seems to access the network
  };

  GeoIP2 = buildPerlPackage {
    pname = "GeoIP2";
    version = "2.006002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/GeoIP2-2.006002.tar.gz";
      sha256 = "0d4qq0k0pd0xd83iykr0jkyizl499ii6ajwwwl93rgg9xsl44189";
    };
    propagatedBuildInputs = [ JSONMaybeXS LWPProtocolHttps MaxMindDBReader ParamsValidate Throwable ];
    buildInputs = [ PathClass TestFatal TestNumberDelta ];
    meta = {
      description = "Perl API for MaxMind's GeoIP2 web services and databases";
      homepage = "http://metacpan.org/release/GeoIP2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "web-service-request";
    };
  };

  GetoptArgvFile = buildPerlPackage {
    pname = "Getopt-ArgvFile";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTENZEL/Getopt-ArgvFile-1.11.tar.gz";
      sha256 = "3709aa513ce6fd71d1a55a02e34d2f090017d5350a9bd447005653c9b0835b22";
    };
    meta = {
      license = with lib.licenses; [ artistic1 ];
      maintainers = [ maintainers.pSub ];
    };
  };

  GetoptLong = buildPerlPackage {
    pname = "Getopt-Long";
    version = "2.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/Getopt-Long-2.52.tar.gz";
      sha256 = "1yh5fykxrw68pvdvhvjh3wfs7a1s29xqwm5fxw2mqg9mfg1sgiwx";
    };
  };

  GetoptLongDescriptive = buildPerlPackage {
    pname = "Getopt-Long-Descriptive";
    version = "0.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.105.tar.gz";
      sha256 = "a71cdbcf4043588b26a42a13d151c243f6eccf38e8fc0b18ffb5b53651ab8c15";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestWarnings ];
    propagatedBuildInputs = [ ParamsValidate SubExporter ];
    meta = {
      description = "Getopt::Long, but simpler and more powerful";
      homepage = "https://github.com/rjbs/Getopt-Long-Descriptive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GetoptTabular = buildPerlPackage {
    pname = "Getopt-Tabular";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz";
      sha256 = "0xskl9lcj07sdfx5dkma5wvhhgf5xlsq0khgh8kk34dm6dv0dpwv";
    };
  };

  Git = buildPerlPackage {
    pname = "Git";
    version = "0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSOUTH/Git-0.42.tar.gz";
      sha256 = "9469a9f398f3a2bf2b0500566ee41d3ff6fae460412a137185767a1cc4783a6d";
    };
    propagatedBuildInputs = [ Error ];
    meta = {
      description = "This is the Git.pm, plus the other files in the perl/Git directory, from github's git/git";
      license = with lib.licenses; [ free ];
      maintainers = teams.deshaw.members;
    };
  };

  GitAutofixup = buildPerlPackage rec {
    pname = "App-Git-Autofixup";
    version = "0.003001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TORBIAK/App-Git-Autofixup-0.003001.tar.gz";
      sha256 = "1q7im0zj238k5agwi7d1mz26a8r0wrxwfwp1l8n5k777gx3b5xhp";
    };
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/git-autofixup
    '';
    meta = {
      description = "Create fixup commits for topic branches";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.DamienCassou ];
      mainProgram = "git-autofixup";
    };
  };

  GitPurePerl = buildPerlPackage {
    pname = "Git-PurePerl";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BROQ/Git-PurePerl-0.53.tar.gz";
      sha256 = "987c74366cc4c37ee084050f985fa254359c89c12507f5b8bfc6607de538d5a8";
    };
    buildInputs = [ Testutf8 ];
    propagatedBuildInputs = [ ArchiveExtract ConfigGitLike DataStreamBulk DateTime FileFindRule IODigest MooseXStrictConstructor MooseXTypesPathClass ];
    doCheck = false;
    meta = {
      description = "A Pure Perl interface to Git repositories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GitRepository = buildPerlPackage {
    pname = "Git-Repository";
    version = "1.324";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/Git-Repository-1.324.tar.gz";
      sha256 = "814dfad104a9546349f9e0fd492c86137de827ebc284017a91a5267c120ad4f6";
    };
    buildInputs = [ TestRequiresGit ];
    propagatedBuildInputs = [ GitVersionCompare SystemCommand namespaceclean ];
    meta = {
      description = "Perl interface to Git repositories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GitVersionCompare = buildPerlPackage {
    pname = "Git-Version-Compare";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/Git-Version-Compare-1.004.tar.gz";
      sha256 = "63e8264ed351cb2371b47852a72366214164b5f3fad9dbd68309c7fc63d06491";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Functions to compare Git versions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Glib = buildPerlPackage {
    pname = "Glib";
    version = "1.3293";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Glib-1.3293.tar.gz";
      sha256 = "005m3inz12xcsd5sr056cm1kbhmxsx2ly88ifbdv6p6cwz0s05kk";
    };
    buildInputs = [ pkgs.glib ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
    meta = {
      description = "Perl wrappers for the GLib utility and Object libraries";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  GlibObjectIntrospection = buildPerlPackage {
    pname = "Glib-Object-Introspection";
    version = "0.049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Glib-Object-Introspection-0.049.tar.gz";
      sha256 = "0mxg6pz8qfyipw0ypr54alij0c4adzg94f62702b2a6hkp5jhij6";
    };
    checkInputs = [ pkgs.cairo CairoGObject ];
    propagatedBuildInputs = [ pkgs.gobject-introspection Glib ];
    preCheck = ''
      # Our gobject-introspection patches make the shared library paths absolute
      # in the GIR files. When running tests, the library is not yet installed,
      # though, so we need to replace the absolute path with a local one during build.
      # We are using a symlink that we will delete after the execution of the tests.
      mkdir -p $out/lib
      ln -s $PWD/build/*.so $out/lib/
    '';
    postCheck = ''
      rm -r $out/lib
    '';
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Dynamically create Perl language bindings";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  Gnome2 = buildPerlPackage {
    pname = "Gnome2";
    version = "1.047";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gnome2-1.047.tar.gz";
      sha256 = "ccc85c5dc3c14f915ed1a186d238681d83fef3d17eed1c20001499ff56b6390c";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gnome2Canvas Gnome2VFS Gtk2 ];
    propagatedBuildInputs = [ pkgs.gnome2.libgnomeui ];
    meta = {
      description = "(DEPRECATED) Perl interface to the 2.x series of the GNOME libraries";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Gnome2Canvas.x86_64-darwin
    };
  };

  Gnome2Canvas = buildPerlPackage {
    pname = "Gnome2-Canvas";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gnome2-Canvas-1.004.tar.gz";
      sha256 = "0g42bfmqq5395m55np95pfj4i1qbrmx2ml4zhi4cw4sx4fdv7drr";
    };
    buildInputs = [ pkgs.gnome2.libgnomecanvas ];
    propagatedBuildInputs = [ Gtk2 ];
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "(DEPRECATED) A structured graphics canvas";
      license = with lib.licenses; [ lgpl2Plus ];
    };
  };

  Gnome2VFS = buildPerlPackage {
    pname = "Gnome2-VFS";
    version = "1.083";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gnome2-VFS-1.083.tar.gz";
      sha256 = "eca974669df4e7f21b4fcedb96c8a328422369c68b8c2cd99b9ce9cc5d7a7979";
    };
    propagatedBuildInputs = [ pkgs.gnome2.gnome_vfs Glib ];
    meta = {
      description = "(DEPRECATED) Perl interface to the 2.x series of the GNOME VFS";
      license = with lib.licenses; [ gpl21Plus ];
    };
  };

  Gnome2Wnck = buildPerlPackage {
    pname = "Gnome2-Wnck";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/Gnome2-Wnck-0.16.tar.gz";
      sha256 = "604a8ece88ac29f132d59b0caac27657ec31371c1606a4698a2160e88ac586e5";
    };
    buildInputs = [ pkgs.libwnck2 pkgs.glib pkgs.gtk2 ];
    propagatedBuildInputs = [ Gtk2 ];
    meta = {
      description = "(DEPRECATED) Perl interface to the Window Navigator";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  GnuPG = buildPerlPackage {
    pname = "GnuPG";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/GnuPG-0.19.tar.gz";
      sha256 = "af53f2d3f63297e046676eae14a76296afdd2910e09723b6b113708622b7989b";
    };
    buildInputs = [ pkgs.gnupg1orig ];
    doCheck = false;
    meta = {
      description = "Perl interface to the GNU Privacy Guard";
      license = with lib.licenses; [ unfree ];
      mainProgram = "gpgmailtunl";
    };
  };

  GnuPGInterface = buildPerlPackage {
    pname = "GnuPG-Interface";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/GnuPG-Interface-1.02.tar.gz";
      sha256 = "c27a48c3d48e1a9205e362eeea66d46b032bd84637991fdf0b13828bcafdd3e6";
    };
    buildInputs = [ pkgs.which pkgs.gnupg1compat ];
    propagatedBuildInputs = [ MooXHandlesVia MooXlate ];
    doCheck = false;
    meta = {
      description = "Supply object methods for interacting with GnuPG";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoferTransporthttp = buildPerlPackage {
    pname = "GoferTransport-http";
    version = "1.017";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/GoferTransport-http-1.017.tar.gz";
      sha256 = "f73effe3ea7afa1907ce8977c87387abb0d4404f85a724ae2637b29a73154a9b";
    };
    propagatedBuildInputs = [ DBI LWP mod_perl2 ];
    doCheck = false; # no make target 'test'
    meta = {
      description = "HTTP transport for DBI stateless proxy driver DBD::Gofer";
      license = with lib.licenses; [ unfree ];
    };
  };

  GooCanvas = buildPerlPackage {
    pname = "Goo-Canvas";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YE/YEWENBIN/Goo-Canvas-0.06.tar.gz";
      sha256 = "0c588c507eed5e62d12ed1cc1e491c6ff3a1f59c4fb3d435e14214b37ab39251";
    };
    propagatedBuildInputs = [ pkgs.goocanvas pkgs.gtk2 Gtk2 ];
    meta = {
      description = "Perl interface to the GooCanvas";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GooCanvas2 = buildPerlPackage {
    pname = "GooCanvas2";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLMAX/GooCanvas2-0.06.tar.gz";
      sha256 = "0l1vsvyv9hjxhsxrahq4h64axh7qmk50kiz2spa3s1hr7s3qfk72";
    };
    buildInputs = [ pkgs.gtk3 ];
    propagatedBuildInputs = [ pkgs.goocanvas2 Gtk3 ];
    meta = {
      description = "Perl binding for GooCanvas2 widget using Glib::Object::Introspection";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GooCanvas2CairoTypes = buildPerlPackage rec {
    pname = "GooCanvas2-CairoTypes";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASOKOLOV/GooCanvas2-CairoTypes-${version}.tar.gz";
      sha256 = "sha256-uoBnNuvMnePYFBp2Omgr3quxy4cCveKZrf1XSs6HUFI=";
    };
    propagatedBuildInputs = [ pkgs.goocanvas2 Gtk3 ];
    meta = {
      description = "Bridge between GooCanvas2 and Cairo types";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GoogleProtocolBuffers = buildPerlPackage {
    pname = "Google-ProtocolBuffers";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/protobuf/Google-ProtocolBuffers-0.12.tar.gz";
      sha256 = "0wad56n12h9yhnrq1m1z3jna1ch3mg3mqj41wkfi49ws1g34k15k";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches =
      [ ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch ];
    meta = {
      description = "Simple interface to Google Protocol Buffers";
      homepage = "https://github.com/csirtgadgets/google-protocolbuffers-perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "protoc-perl";
    };
  };

  gotofile = buildPerlPackage {
    pname = "goto-file";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/goto-file-0.005.tar.gz";
      sha256 = "c6cdd5ee4a6cdcbdbf314d92a4f9985dbcdf9e4258048cae76125c052aa31f77";
    };
    buildInputs = [ Test2Suite ];
    meta = {
      description = "Stop parsing the current file and move on to a different one";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Graph = buildPerlPackage {
    pname = "Graph";
    version = "0.9722";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/Graph-0.9722.tar.gz";
      sha256 = "c113633833f3a1bef8fa8eb96680be36d00e41ef404bddd7fc0bb98703e28d4d";
    };
    propagatedBuildInputs = [ HeapFibonacci SetObject ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GraphicsColor = buildPerlPackage {
    pname = "Graphics-Color";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GP/GPHAT/Graphics-Color-0.31.tar.gz";
      sha256 = "faa8fed5b2d80e5160af976e5db2242c0b3555542ce1042575ff6b694587a33d";
    };
    buildInputs = [ TestNumberDelta ModulePluggable ];
    propagatedBuildInputs = [ ColorLibrary Moose MooseXAliases MooseXClone MooseXStorage MooseXTypes ];
    meta = {
      description = "Device and library agnostic color spaces";
      homepage = "https://github.com/gphat/graphics-color";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GraphicsTIFF = buildPerlPackage {
    pname = "Graphics-TIFF";
    version = "16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/Graphics-TIFF-9.tar.gz";
      sha256 = "Kv0JTCBGnvp8+cMmDjzuqd4Qw9r+BjOo0eJC405OOdg=";
    };
    buildInputs = [ pkgs.libtiff ExtUtilsDepends ExtUtilsPkgConfig ];
    propagatedBuildInputs = [ Readonly ];
    checkInputs = [ TestRequires TestDeep pkgs.hexdump ];
    meta = {
      description = "Perl extension for the libtiff library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GraphViz = buildPerlPackage {
    pname = "GraphViz";
    version = "2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/GraphViz-2.24.tgz";
      sha256 = "1bgm4a8kan53r30qiknr4kasvhar1khf7vq064l1inzfrp2glpnr";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz TestPod ];
    propagatedBuildInputs = [ FileWhich IPCRun ParseRecDescent XMLTwig XMLXPath ];

    meta = with lib; {
      description = "Perl interface to the GraphViz graphing tool";
      license = licenses.artistic2;
    };
  };

  grepmail = buildPerlPackage {
    pname = "grepmail";
    version = "5.3111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/grepmail-5.3111.tar.gz";
      sha256 = "d0984e3f7a1be17ae014575f70c1678151a5bcc9622185dc5a052cb63271a761";
    };
    buildInputs = [ FileHomeDir FileSlurper TestCompile UNIVERSALrequire URI ];
    propagatedBuildInputs = [ MailMboxMessageParser TimeDate ];
    outputs = [ "out" ];
    meta = {
      description = "Search mailboxes for mail matching a regular expression";
      homepage = "https://github.com/coppit/grepmail";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  GrowlGNTP = buildPerlModule {
    pname = "Growl-GNTP";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/Growl-GNTP-0.21.tar.gz";
      sha256 = "0gq8ypam6ifp8f3s2mf5d6sw53m7h3ki1zfahh2p41kl8a77yy98";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CryptCBC DataUUID ];
  };

  GSSAPI = buildPerlPackage {
    pname = "GSSAPI";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGROLMS/GSSAPI-0.28.tar.gz";
      sha256 = "1mkhwxjjlhr58pd770i9gnf7zy7jj092iv6jfbnb8bvnc5xjr3vx";
    };
    propagatedBuildInputs = [ pkgs.krb5Full.dev ];
    makeMakerFlags = "--gssapiimpl ${pkgs.krb5Full.dev}";
    meta = {
      description = "Perl extension providing access to the GSSAPIv2 library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  Gtk2 = buildPerlPackage {
    pname = "Gtk2";
    version = "1.24993";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gtk2-1.24993.tar.gz";
      sha256 = "0ry9jfvfgdwzalxcvwsgr7plhk3agx7p40l0fqdf3vrf7ds47i29";
    };
    buildInputs = [ pkgs.gtk2 ];
    # https://rt.cpan.org/Public/Bug/Display.html?id=130742
    # doCheck = !stdenv.isDarwin;
    doCheck = false;
    propagatedBuildInputs = [ Pango ];
    meta = {
      description = "Perl interface to the 2.x series of the Gimp Toolkit library";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  Gtk2TrayIcon = buildPerlPackage {
    pname = "Gtk2-TrayIcon";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORUP/Gtk2-TrayIcon-0.06.tar.gz";
      sha256 = "cbb7632b75d7f41554dfe8ee9063dbfd1d8522291077c65d0d82e9ceb5e94ae2";
    };
    propagatedBuildInputs = [ pkgs.gtk2 Gtk2 ];
    meta = {
      description = "(DEPRECATED) Perl interface to the EggTrayIcon library";
      license = with lib.licenses; [ gpl2 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Gtk2TrayIcon.x86_64-darwin
    };
  };

  Gtk2AppIndicator = buildPerlPackage {
    pname = "Gtk2-AppIndicator";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/Gtk2-AppIndicator-0.15.tar.gz";
      sha256 = "a25cb071e214fb89b4450aa4605031eae89b7961e149b0d6e8f491c19c14a90a";
    };
    propagatedBuildInputs = [ pkgs.libappindicator-gtk2 pkgs.libdbusmenu-gtk2 pkgs.gtk2 pkgs.pkg-config Gtk2 ];
    # Tests fail due to no display:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    doCheck = false;
    meta = {
      description = "Perl extension for libappindicator";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  Gtk2ImageView = buildPerlPackage {
    pname = "Gtk2-ImageView";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/Gtk2-ImageView-0.05.tar.gz";
      sha256 = "087186c3693acf196451cf59cc8b7f5cf9a7b05abe20d32dcbcba0822953fb80";
    };
    buildInputs = [ pkgs.gtkimageview pkgs.gtk2 ];
    propagatedBuildInputs = [ Gtk2 ];
    # Tests fail due to no display server:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    #   t/animview.t ...........
    doCheck = false;
    meta = {
      description = "Perl bindings for the GtkImageView widget";
      license = with lib.licenses; [ free ];
    };
  };

  Gtk2Unique = buildPerlPackage {
    pname = "Gtk2-Unique";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/Gtk2-Unique-0.05.tar.gz";
      sha256 = "ae8dfb0f6844ddaa2ce7b5b44553419490c8e83c24fd35c431406a58f6be0f4f";
    };
    propagatedBuildInputs = [ pkgs.libunique pkgs.gtk2 Gtk2 ];
    meta = {
      description = "(DEPRECATED) Use single instance applications";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Gtk2Unique.x86_64-darwin
    };
  };

  Gtk3 = buildPerlPackage rec {
    pname = "Gtk3";
    version = "0.038";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gtk3-${version}.tar.gz";
      sha256 = "sha256-cNxL8qp0mBx54V/SmNmY4FqS66SBHxrVyfH03jdzesw=";
    };
    propagatedBuildInputs = [ pkgs.gtk3 CairoGObject GlibObjectIntrospection ];
    preCheck = lib.optionalString stdenv.isDarwin "rm t/overrides.t"; # Currently failing on macOS
    meta = {
      description = "Perl interface to the 3.x series of the gtk+ toolkit";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  Gtk3ImageView = buildPerlPackage rec {
    pname = "Gtk3-ImageView";
    version = "10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASOKOLOV/Gtk3-ImageView-${version}.tar.gz";
      sha256 = "sha256-vHfnBgaeZPK7hBgZcP1KjepG+IvsDE3XwrH9U4xoN+Y=";
    };
    buildInputs = [ pkgs.gtk3 ];
    propagatedBuildInputs = [ Readonly Gtk3 ];
    checkInputs = [ TestDifferences TestDeep ImageMagick TryTiny TestMockObject CarpAlways pkgs.librsvg ];
    checkPhase = ''
      ${pkgs.xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' \
        make test
    '';
    meta = {
      description = "Image viewer widget for Gtk3";
      homepage = "https://github.com/carygravel/gtk3-imageview";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Gtk3SimpleList = buildPerlPackage {
    pname = "Gtk3-SimpleList";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TV/TVIGNAUD/Gtk3-SimpleList-0.21.tar.gz";
      sha256 = "1158mnr2ldq02098hqbkwfv64d83zl3a8scll9s09g7k1c86ai0x";
    };
    propagatedBuildInputs = [ Gtk3 ];
    meta = {
      description = "A simple interface to Gtk3's complex MVC list widget";
      homepage = "https://github.com/soig/Gtk3-SimpleList";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  Guard = buildPerlPackage {
    pname = "Guard";
    version = "1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Guard-1.023.tar.gz";
      sha256 = "34c4ddf91fc93d1090d86da14df706d175b1610c67372c01e12ce9555d4dd1dc";
    };
  };

  HamAPRSFAP = buildPerlPackage {
    pname = "Ham-APRS-FAP";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HE/HESSU/Ham-APRS-FAP-1.21.tar.gz";
      sha256 = "e01b455d46f44710dbcf21b6fa843f09358ce60eee1c4141bc74e0a204d3a020";
    };
    propagatedBuildInputs = [ DateCalc ];
    meta = with lib; {
      description = "Finnish APRS Parser (Fabulous APRS Parser)";
      maintainers = with maintainers; [ andrew-d ];
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  Hailo = buildPerlPackage {
    pname = "Hailo";
    version = "0.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Hailo-0.75.tar.gz";
      sha256 = "bba99cb0cfa3ee8632dd89906c6e6fa05fe6bb367f2282e88909cefd8f9174c2";
    };
    buildInputs = [ BotTrainingMegaHAL BotTrainingStarCraft DataSection FileSlurp PodSection TestException TestExpect TestOutput TestScript TestScriptRun ];
    propagatedBuildInputs = [ ClassLoad DBDSQLite DataDump DirSelf FileCountLines GetoptLongDescriptive IOInteractive IPCSystemSimple ListMoreUtils Moose MooseXGetopt MooseXStrictConstructor MooseXTypes RegexpCommon TermSk namespaceclean ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postPatch = ''
      patchShebangs bin
    '';
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/hailo
    '';
    meta = {
      description = "A pluggable Markov engine analogous to MegaHAL";
      homepage = "http://hailo.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "hailo";
    };
  };

  HashDiff = buildPerlPackage {
    pname = "Hash-Diff";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOLAV/Hash-Diff-0.010.tar.gz";
      sha256 = "1ig0l859gq00k0r9l85274r2lbvwl7wsndcy52c0m3y9isilm6mw";
    };
    propagatedBuildInputs = [ HashMerge ];
    buildInputs = [ TestSimple13 ];

    meta = {
      description = "Return difference between two hashes as a hash";
      homepage = "https://github.com/bolav/hash-diff";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ham = callPackage ../development/perl-modules/ham { };

  HashFlatten = buildPerlPackage {
    pname = "Hash-Flatten";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBC/Hash-Flatten-1.19.tar.gz";
      sha256 = "162b9qgkr19f97w4pic6igyk3zd0sbnrhl3s8530fikciffw9ikh";
    };
    buildInputs = [ TestAssertions ];
    propagatedBuildInputs = [ LogTrace ];
  };

  HashMerge = buildPerlPackage {
    pname = "Hash-Merge";
    version = "0.302";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HE/HERMES/Hash-Merge-0.302.tar.gz";
      sha256 = "0i46agids6pk445gfck80f8z7q3pjvkp0ip1vmhqnq1rcpvj41df";
    };
    propagatedBuildInputs = [ CloneChoose ];
    buildInputs = [ Clone ClonePP ];
    meta = {
      description = "Merges arbitrarily deep hashes into a single hash";
      homepage = "https://metacpan.org/release/Hash-Merge";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMergeSimple = buildPerlPackage {
    pname = "Hash-Merge-Simple";
    version = "0.051";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROKR/Hash-Merge-Simple-0.051.tar.gz";
      sha256 = "1c56327873d2f04d5722777f044863d968910466997740d55a754071c6287b73";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Recursively merge two or more hashes, simply";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMoreUtils = buildPerlPackage {
    pname = "Hash-MoreUtils";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/Hash-MoreUtils-0.06.tar.gz";
      sha256 = "db9a8fb867d50753c380889a5e54075651b5e08c9b3b721cb7220c0883547de8";
    };
    meta = {
      description = "Provide the stuff missing in Hash::Util";
      homepage = "https://metacpan.org/release/Hash-MoreUtils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMultiValue = buildPerlPackage {
    pname = "Hash-MultiValue";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARISTOTLE/Hash-MultiValue-0.16.tar.gz";
      sha256 = "1x3k7h542xnigz0b8vsfiq580p5r325wi5b8mxppiqk8mbvis636";
    };
    meta = {
      description = "Store multiple values per key";
      homepage = "https://github.com/miyagawa/Hash-MultiValue";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashSharedMem = buildPerlModule {
    pname = "Hash-SharedMem";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Hash-SharedMem-0.005.tar.gz";
      sha256 = "324776808602f7bdc44adaa937895365454029a926fa611f321c9bf6b940bb5e";
    };
    buildInputs = [ ScalarString ];
    meta = {
      description = "Efficient shared mutable hash";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.HashSharedMem.x86_64-darwin
    };
  };

  HashStoredIterator = buildPerlModule {
    pname = "Hash-StoredIterator";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Hash-StoredIterator-0.008.tar.gz";
      sha256 = "b9cbc4dcd8233e8d1d7f1481ddb79a4a5f9db7180cb3ef02b4bcbee05e65ea0c";
    };
    buildInputs = [ Test2Suite ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Functions for accessing a hashes internal iterator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashUtilFieldHashCompat = buildPerlPackage {
    pname = "Hash-Util-FieldHash-Compat";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Hash-Util-FieldHash-Compat-0.11.tar.gz";
      sha256 = "06vlygjyk7rkkw0di3252mma141w801qn3xk40aa2yskbfklcbk4";
    };
  };

  HeapFibonacci = buildPerlPackage {
    pname = "Heap";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz";
      sha256 = "1plv2djbyhvkdcw2ic54rdqb745cwksxckgzvw7ssxiir7rjknnc";
    };
  };

  HookLexWrap = buildPerlPackage {
    pname = "Hook-LexWrap";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Hook-LexWrap-0.26.tar.gz";
      sha256 = "b60bdc5f98f94f9294b06adef82b1d996da192d5f183f9f434b610fd1137ec2d";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      description = "Lexically scoped subroutine wrappers";
      homepage = "https://github.com/karenetheridge/Hook-LexWrap";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLClean = buildPerlPackage {
    pname = "HTML-Clean";
    version = "1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AZ/AZJADFTRE/HTML-Clean-1.4.tar.gz";
      sha256 = "01l7g2hr0kjbh1wk7cv03ijmpjlbm1vm661m99mkrz2ilyyllzd6";
    };
    meta = {
      description = "Cleans up HTML code for web browsers, not humans";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "htmlclean";
    };
  };

  HTMLElementExtended = buildPerlPackage {
    pname = "HTML-Element-Extended";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSISK/HTML-Element-Extended-1.18.tar.gz";
      sha256 = "f3ef1af108f27fef15ebec66479f251ce08aa49bd00b0462c9c80c86b4b6b32b";
    };
    propagatedBuildInputs = [ HTMLTree ];
  };

  HTMLEscape = buildPerlModule {
    pname = "HTML-Escape";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/HTML-Escape-1.10.tar.gz";
      sha256 = "b1cbac4157ad8dedac6914e1628855e05b8dc885a4007d2e4df8177c6a9b70fb";
    };
    buildInputs = [ ModuleBuildPluggablePPPort TestRequires ];
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Extremely fast HTML escaping";
      homepage = "https://github.com/tokuhirom/HTML-Escape";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.HTMLEscape.x86_64-darwin
    };
  };

  HTMLFromANSI = buildPerlPackage {
    pname = "HTML-FromANSI";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/HTML-FromANSI-2.03.tar.gz";
      sha256 = "21776345ed701b2c04c7b09380af943f9984cc7f99624087aea45db5fc09c359";
    };
    propagatedBuildInputs = [ HTMLParser TermVT102Boundless ];
    meta = {
      description = "Mark up ANSI sequences as HTML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "ansi2html";
    };
  };

  HTMLForm = buildPerlPackage {
    pname = "HTML-Form";
    version = "6.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTML-Form-6.07.tar.gz";
      sha256 = "09v29cdzwjm139c67y1np3kvx2ymg3s8n723qc0ma07lmxz8rakx";
    };
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Class that represents an HTML form element";
      homepage = "https://github.com/libwww-perl/HTML-Form";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatter = buildPerlPackage {
    pname = "HTML-Formatter";
    version = "2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIGELM/HTML-Formatter-2.16.tar.gz";
      sha256 = "cb0a0dd8aa5e8ba9ca214ce451bf4df33aa09c13e907e8d3082ddafeb30151cc";
    };
    buildInputs = [ FileSlurper TestWarnings ];
    propagatedBuildInputs = [ FontAFM HTMLTree ];
    meta = {
      description = "Base class for HTML formatters";
      homepage = "https://metacpan.org/release/HTML-Formatter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatExternal = buildPerlPackage {
    pname = "HTML-FormatExternal";
    version = "26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/HTML-FormatExternal-26.tar.gz";
      sha256 = "3c59f233d0b10686a85aed0c994011cec68626da0128dea90b5c4fdc1746cfc3";
    };
    propagatedBuildInputs = [ IPCRun URI constant-defer ];
    meta = {
      description = "HTML to text formatting using external programs";
      homepage = "http://user42.tuxfamily.org/html-formatexternal/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  HTMLFormatTextWithLinks = buildPerlModule {
    pname = "HTML-FormatText-WithLinks";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STRUAN/HTML-FormatText-WithLinks-0.15.tar.gz";
      sha256 = "7fcc1ab79eb58fb97d43e5bdd14e21791a250a204998918c62d6a171131833b1";
    };
    propagatedBuildInputs = [ HTMLFormatter ];
    meta = {
      description = "HTML to text conversion with links as footnotes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormatTextWithLinksAndTables = buildPerlPackage {
    pname = "HTML-FormatText-WithLinks-AndTables";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DALEEVANS/HTML-FormatText-WithLinks-AndTables-0.07.tar.gz";
      sha256 = "809ee2f11705706b33c54312b5c7bee674838f2beaaedaf8cb945e702aae39b6";
    };
    propagatedBuildInputs = [ HTMLFormatTextWithLinks ];
    meta = {
      description = "Converts HTML to Text with tables intact";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormFu = buildPerlPackage {
    pname = "HTML-FormFu";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/HTML-FormFu-2.07.tar.gz";
      sha256 = "0cpbcrip95rvihc7i8dywca6lx9ws67ch1hjx6vgnm47g9zh2bsg";
    };
    buildInputs = [ CGI FileShareDirInstall RegexpAssemble TestException TestMemoryCycle TestRequiresInternet ];
    propagatedBuildInputs = [ ConfigAny DataVisitor DateTimeFormatBuilder DateTimeFormatNatural EmailValid HTMLScrubber HTMLTokeParserSimple HashFlatten JSONMaybeXS MooseXAliases MooseXAttributeChained NumberFormat PathClass Readonly RegexpCommon TaskWeaken YAMLLibYAML ];
    meta = {
      description = "HTML Form Creation, Rendering and Validation Framework";
      homepage = "https://github.com/FormFu/HTML-FormFu";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormFuMultiForm = buildPerlPackage {
    pname = "HTML-FormFu-MultiForm";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIGELM/HTML-FormFu-MultiForm-1.03.tar.gz";
      sha256 = "17qm94hwhn6jyhd2am4gqxq7yrlhv3jv0ayx17df95mqdgbhrw1n";
    };
    propagatedBuildInputs = [ CryptCBC CryptDES HTMLFormFu ];
    meta = {
      description = "Handle multi-page/stage forms with FormFu";
      homepage = "https://github.com/FormFu/HTML-FormFu-MultiForm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormHandler = buildPerlPackage {
    pname = "HTML-FormHandler";
    version = "0.40068";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GS/GSHANK/HTML-FormHandler-0.40068.tar.gz";
      sha256 = "09z8rpb3avdd8984rm6j6gd2igbzjz9rc0ycig654mqjlgfphyzb";
    };
    # a single test is failing on perl 5.20
    doCheck = false;
    buildInputs = [ FileShareDirInstall PadWalker TestDifferences TestException TestMemoryCycle TestWarn ];
    propagatedBuildInputs = [ CryptBlowfish CryptCBC DataClone DateTimeFormatStrptime EmailValid HTMLTree JSONMaybeXS MooseXGetopt MooseXTypesCommon MooseXTypesLoadableClass aliased ];
    meta = {
      description = "HTML forms using Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLGumbo = buildPerlModule {
    pname = "HTML-Gumbo";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RUZ/HTML-Gumbo-0.18.tar.gz";
      sha256 = "bf50b61c24656cc3fc958602d80a9c7d017247af38d8dbfa0e9dec5b75425d5f";
    };
    propagatedBuildInputs = [ AlienLibGumbo ];
    meta = {
      description = "HTML5 parser based on gumbo C library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMason = buildPerlPackage {
    pname = "HTML-Mason";
    version = "1.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.59.tar.gz";
      sha256 = "95bed2a6c488370046aa314be4b592bd65a6522f8845da8b36a6aff9a8b439d0";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ CGI CacheCache ClassContainer ExceptionClass LogAny ];
    meta = {
      description = "High-performance, dynamic web site authoring system";
      homepage = "https://metacpan.org/release/HTML-Mason";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMasonPSGIHandler = buildPerlPackage {
    pname = "HTML-Mason-PSGIHandler";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RUZ/HTML-Mason-PSGIHandler-0.53.tar.gz";
      sha256 = "eafd7c7655dfa8261df3446b931a283d30306877b83ac4671c49cff74ea7f00b";
    };
    buildInputs = [ Plack ];
    propagatedBuildInputs = [ CGIPSGI HTMLMason ];
    meta = {
      description = "PSGI handler for HTML::Mason";
      homepage = "http://search.cpan.org/dist/HTML-Mason-PSGIHandler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLParser = buildPerlPackage {
    pname = "HTML-Parser";
    version = "3.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/HTML-Parser-3.75.tar.gz";
      sha256 = "1ack2799azfciyiw3vccq126gaxrbz2927i0hm4gaynzm0jmwsxc";
    };
    propagatedBuildInputs = [ HTMLTagset HTTPMessage ];
    meta = {
      description = "HTML parser class";
      homepage = "https://github.com/libwww-perl/HTML-Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTagCloud = buildPerlModule {
    pname = "HTML-TagCloud";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBERTSD/HTML-TagCloud-0.38.tar.gz";
      sha256 = "05bhnrwwlwd6cj3cn91zw5r99xddvy142bznid26p1pg5m3rk029";
    };
    meta = {
      description = "Generate An HTML Tag Cloud";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLQuoted = buildPerlPackage {
    pname = "HTML-Quoted";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-Quoted-0.04.tar.gz";
      sha256 = "8b41f313fdc1812f02f6f6c37d58f212c84fdcf7827f7fd4b030907f39dc650c";
    };
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Extract structure of quoted HTML mail message";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLRewriteAttributes = buildPerlPackage {
    pname = "HTML-RewriteAttributes";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-RewriteAttributes-0.05.tar.gz";
      sha256 = "1808ec7cdf40d2708575fe6155a88f103b17fec77973a5831c2f24c250e7a58c";
    };
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Concise attribute rewriting";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLSelectorXPath = buildPerlPackage {
    pname = "HTML-Selector-XPath";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.25.tar.gz";
      sha256 = "1qbad8ayffpx7wj76ip05p6rh9p1lkir6qknpl76zy679ghlsp8s";
    };
    buildInputs = [ TestBase ];
  };

  HTMLScrubber = buildPerlPackage {
    pname = "HTML-Scrubber";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIGELM/HTML-Scrubber-0.19.tar.gz";
      sha256 = "1c9b4r9x96a8fbz2zy52fxgq7djp9dq38hiyqra92psnz1w5aa5f";
    };
    propagatedBuildInputs = [ HTMLParser ];
    buildInputs = [ TestDifferences TestMemoryCycle ];
  };

  HTMLStripScripts = buildPerlPackage {
    pname = "HTML-StripScripts";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/HTML-StripScripts-1.06.tar.gz";
      sha256 = "222bfb7ec1fdfa465e32da3dc4abed2edc7364bbe19e8e3c513c7d585b0109ad";
    };
    meta = {
      description = "Strip scripting constructs out of HTML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLStripScriptsParser = buildPerlPackage {
    pname = "HTML-StripScripts-Parser";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/HTML-StripScripts-Parser-1.03.tar.gz";
      sha256 = "478c1a4e46eb77fa7bce96ba288168f0b98c27f250e00dc6312365081aed3407";
    };
    propagatedBuildInputs = [ HTMLParser HTMLStripScripts ];
    meta = {
      description = "XSS filter using HTML::Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTableExtract = buildPerlPackage {
    pname = "HTML-TableExtract";
    version = "2.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSISK/HTML-TableExtract-2.15.tar.gz";
      sha256 = "1kry9igbcjyiwpwivq5in41dmx02zfhgaqjyv9sa2g6sb2frric6";
    };
    preCheck = ''
      # https://rt.cpan.org/Public/Bug/Display.html?id=121920
      rm t/30_tree.t
    '';
    propagatedBuildInputs = [ HTMLElementExtended ];
  };

  HTMLTagset = buildPerlPackage {
    pname = "HTML-Tagset";
    version = "3.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz";
      sha256 = "1qh8249wgr4v9vgghq77zh1d2zs176bir223a8gh3k9nksn7vcdd";
    };
  };

  HTMLTemplate = buildPerlPackage {
    pname = "HTML-Template";
    version = "2.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/HTML-Template-2.97.tar.gz";
      sha256 = "17qjw8swj2q4b1ic285pndgrkmvpsqw0j68nhqzpk1daydhsyiv5";
    };
    propagatedBuildInputs = [ CGI ];
    buildInputs = [ TestPod ];
  };

  HTMLTidy = buildPerlPackage {
    pname = "HTML-Tidy";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tidy-1.60.tar.gz";
      sha256 = "1iyp2fd6j75cn1xvcwl2lxr8qpjxssy2360cyqn6g3kzd1fzdyxw";
    };

    patchPhase = ''
      sed -i "s#/usr/include/tidyp#${pkgs.tidyp}/include/tidyp#" Makefile.PL
      sed -i "s#/usr/lib#${pkgs.tidyp}/lib#" Makefile.PL
    '';
    buildInputs = [ TestException ];
    meta = {
      description = "(X)HTML validation in a Perl object";
      homepage = "http://github.com/petdance/html-tidy";
      license = with lib.licenses; [ artistic2 ];
      mainProgram = "webtidy";
    };
  };

  HTMLTiny = buildPerlPackage {
    pname = "HTML-Tiny";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/HTML-Tiny-1.05.tar.gz";
      sha256 = "d7cdc9d5985e2e44ceba10b756acf1e0d3a1b3ee3b516e5b54adb850fe79fda3";
    };
    meta = {
      description = "Lightweight, dependency free HTML/XML generation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTokeParserSimple = buildPerlModule {
    pname = "HTML-TokeParser-Simple";
    version = "3.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/HTML-TokeParser-Simple-3.16.tar.gz";
      sha256 = "17aa1v62sp8ycxcicwhankmj4brs6nnfclk9z7mf1rird1f164gd";
    };
    propagatedBuildInputs = [ HTMLParser SubOverride ];
  };

  HTMLTree = buildPerlModule {
    pname = "HTML-Tree";
    version = "5.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KENTNL/HTML-Tree-5.07.tar.gz";
      sha256 = "1gyvm4qlwm9y6hczkpnrdfl303ggbybr0nqxdjw09hii8yw4sdzh";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ HTMLParser ];
    meta = {
      description = "Work with HTML in a DOM-like tree structure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "htmltree";
    };
  };

  HTMLTreeBuilderXPath = buildPerlPackage {
    pname = "HTML-TreeBuilder-XPath";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIROD/HTML-TreeBuilder-XPath-0.14.tar.gz";
      sha256 = "1wx4i1scng20n405fp3a4vrwvvq9bvbmg977wnd5j2ja8jrbvsr5";
    };
    propagatedBuildInputs = [ HTMLTree XMLXPathEngine ];
    meta = {
      description = "Add XPath support to HTML::TreeBuilder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLWidget = buildPerlPackage {
    pname = "HTML-Widget";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz";
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    doCheck = false;
    propagatedBuildInputs = [ ClassAccessorChained ClassDataAccessor DateCalc EmailValid HTMLScrubber HTMLTree ModulePluggableFast ];
    buildInputs = [ TestNoWarnings ];
  };

  HTTPAcceptLanguage = buildPerlModule {
    pname = "HTTP-AcceptLanguage";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YAPPO/HTTP-AcceptLanguage-0.02.tar.gz";
      sha256 = "1bs29r72ibp0kmr3l1ypzszflpcw7z4yxxcgaijspsy99rb5yq1f";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Accept-Language header parser and find available language";
      homepage = "https://github.com/yappo/p5-HTTP-AcceptLanguage";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPBody = buildPerlPackage {
    pname = "HTTP-Body";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/HTTP-Body-1.22.tar.gz";
      sha256 = "fc0d2c585b3bd1532d92609965d589e0c87cd380e7cca42fb9ad0a1311227297";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP Body Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPCookieJar = buildPerlPackage {
    pname = "HTTP-CookieJar";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/HTTP-CookieJar-0.010.tar.gz";
      sha256 = "1l7mqsca4fmls7agzwmp6yq1x16y9jwq4114i6i75n654gl37qsn";
    };
    propagatedBuildInputs = [ HTTPDate ];
    buildInputs = [ TestDeep TestRequires URI ];
    # Broken on Hydra since 2021-06-17: https://hydra.nixos.org/build/146507373
    doCheck = false;
    meta = {
      description = "A minimalist HTTP user agent cookie jar";
      homepage = "https://github.com/dagolden/HTTP-CookieJar";
      license = with lib.licenses; [ asl20 ];
    };
  };

  HTTPCookies = buildPerlPackage {
    pname = "HTTP-Cookies";
    version = "6.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Cookies-6.09.tar.gz";
      sha256 = "1q0z3n3bl5lg5z0bhvk3zgmw536cri7c3vwhrjcqbdx5z9x02gwh";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP cookie jars";
      homepage = "https://github.com/libwww-perl/HTTP-Cookies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDaemon = buildPerlPackage {
    pname = "HTTP-Daemon";
    version = "6.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Daemon-6.14.tar.gz";
      sha256 = "sha256-8HZ+fzy7gLITE8dh8HrY7SU7zp+i0LqAaz+3LTCbLh0=";
    };
    patches = [
      # Patches for CVE-2022-3108, from upstream pre 6.15
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/331d5c1d1f0e48e6b57ef738c2a8509b1eb53376.patch";
        sha256 = "sha256-vRSyiO38jnsSeKeGbCnKi+VLaTqQSB349eybl1Wa8SQ=";
        name = "HTTP-Daemon-CVE-2022-3108-pre.patch";
      })
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/e84475de51d6fd7b29354a997413472a99db70b2.patch";
        sha256 = "sha256-z8RXcbVEpjSZcm8dUZcDWYeQHtVZODOGCdcDTfXQpfA=";
        name = "HTTP-Daemon-CVE-2022-3108-1.patch";
      })
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/8dc5269d59e2d5d9eb1647d82c449ccd880f7fd0.patch";
        sha256 = "sha256-e1lxt+AJGfbjNOZoKj696H2Ftkx9wlTF557WkZCLE5Q=";
        name = "HTTP-Daemon-CVE-2022-3108-2.patch";
      })
    ];
    buildInputs = [ ModuleBuildTiny TestNeeds ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "A simple http server class";
      homepage = "https://github.com/libwww-perl/HTTP-Daemon";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDate = buildPerlPackage {
    pname = "HTTP-Date";
    version = "6.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz";
      sha256 = "0awjdbz7x0jd5pna55dwxhs3k6xp3sw6b2zg3p2yndxxvya64p9n";
    };
    propagatedBuildInputs = [ TimeDate ];
    meta = {
      description = "Date conversion routines";
      homepage = "https://github.com/libwww-perl/HTTP-Date";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPEntityParser = buildPerlModule {
    pname = "HTTP-Entity-Parser";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/HTTP-Entity-Parser-0.25.tar.gz";
      sha256 = "0fpchgj6jgxmjkmljjnrpmyj9anz85rjvs2fq3c7rld3rgcd131s";
    };
    propagatedBuildInputs = [ HTTPMultiPartParser HashMultiValue JSONMaybeXS StreamBuffered WWWFormUrlEncoded ];
    buildInputs = [ HTTPMessage ModuleBuildTiny ];
    meta = {
      description = "PSGI compliant HTTP Entity Parser";
      homepage = "https://github.com/kazeburo/HTTP-Entity-Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDAV = buildPerlPackage {
    pname = "HTTP-DAV";
    version = "0.49";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/COSIMO/HTTP-DAV-0.49.tar.gz";
      sha256 = "0z4mgb8mc6l5nfsm3ihndjqgpk43q39x1kq9hryy6v8hxkwrscrk";
    };
    propagatedBuildInputs = [ XMLDOM ];
    meta = {
      description = "WebDAV client library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dave";
    };
  };

  HTTPHeadersActionPack = buildPerlPackage {
    pname = "HTTP-Headers-ActionPack";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/HTTP-Headers-ActionPack-0.09.tar.gz";
      sha256 = "c78111ab857e48c69824903d4b6ce8293feffc6b5d670db550a767f853acc7da";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ HTTPDate HTTPMessage ModuleRuntime SubExporter URI ];
    meta = {
      description = "HTTP Action, Adventure and Excitement";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPHeaderParserXS = buildPerlPackage {
    pname = "HTTP-HeaderParser-XS";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/HTTP-HeaderParser-XS-0.20.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
      broken = stdenv.isi686 || stdenv.isDarwin; # loadable library and perl binaries are mismatched (got handshake key 0x7d40080, needed 0x7dc0080)
    };
  };

  HTTPHeadersFast = buildPerlModule {
    pname = "HTTP-Headers-Fast";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/HTTP-Headers-Fast-0.22.tar.gz";
      sha256 = "cc431db68496dd884db4bc0c0b7112c1f4a4f1dc68c4f5a3caa757a1e7481b48";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ HTTPDate ];
    meta = {
      description = "Faster implementation of HTTP::Headers";
      homepage = "https://github.com/tokuhirom/HTTP-Headers-Fast";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPLite = buildPerlPackage {
    pname = "HTTP-Lite";
    version = "2.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/HTTP-Lite-2.44.tar.gz";
      sha256 = "0z77nflj8zdcfg70kc93glq5kmd6qxn2nf7h70x4xhfg25wkvr1q";
    };
    buildInputs = [ CGI ];
  };

  HTTPMessage = buildPerlPackage {
    pname = "HTTP-Message";
    version = "6.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Message-6.26.tar.gz";
      sha256 = "1q952w7r1yj4s2v2cly5zzir7v45nj4h2fbad63bphvmvrcw7rkc";
    };
    buildInputs = [ TryTiny ];
    propagatedBuildInputs = [ EncodeLocale HTTPDate IOHTML LWPMediaTypes URI ];
    meta = {
      description = "HTTP style message (base class)";
      homepage = "https://github.com/libwww-perl/HTTP-Message";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPMultiPartParser = buildPerlPackage {
    pname = "HTTP-MultiPartParser";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/HTTP-MultiPartParser-0.02.tar.gz";
      sha256 = "04hbs0b1lzv2c8dqfcc9qjm5akh25fn40903is36zlalkwaxmpay";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "HTTP MultiPart Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPNegotiate = buildPerlPackage {
    pname = "HTTP-Negotiate";
    version = "6.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz";
      sha256 = "05p053vjs5g91v5cmjnny7a3xzddz5k7vnjw81wfh01ilqg9qwhw";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "Choose a variant to serve";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPParserXS = buildPerlPackage {
    pname = "HTTP-Parser-XS";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/HTTP-Parser-XS-0.17.tar.gz";
      sha256 = "02d84xq1mm53c7jl33qyb7v5w4372vydp74z6qj0vc96wcrnhkkr";
    };
  };

  HTTPProxy = buildPerlPackage {
    pname = "HTTP-Proxy";
    version = "0.304";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/HTTP-Proxy-0.304.tar.gz";
      sha256 = "b05290534ec73625c21a0565fc35170890dab163843d95331c292c23f504c69d";
    };
    propagatedBuildInputs = [ LWP ];
    # tests fail because they require network access
    doCheck = false;
    meta = {
      description = "A pure Perl HTTP proxy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPRequestAsCGI = buildPerlPackage {
    pname = "HTTP-Request-AsCGI";
    version = "1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/HTTP-Request-AsCGI-1.2.tar.gz";
      sha256 = "1smwmiarwcgq7vjdblnb6ldi2x1s5sk5p15p7xvm5byiqq3znnwl";
    };
    propagatedBuildInputs = [ ClassAccessor HTTPMessage ];
  };

  HTTPResponseEncoding = buildPerlPackage {
    pname = "HTTP-Response-Encoding";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz";
      sha256 = "1am8lis8107s5npca1xgazdy5sknknzcqyhdmc220s4a4f77n5hh";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    buildInputs = [ LWP ];
    meta = {
      description = "Adds encoding() to HTTP::Response";
      license = with lib.licenses; [ unfree ];
    };
  };

  HTTPServerSimple = buildPerlPackage {
    pname = "HTTP-Server-Simple";
    version = "0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz";
      sha256 = "0k6bg7k6mjixfzxdkkdrhqvaqmdhjszx0zsk8g0bimiby6j9z4yq";
    };
    doCheck = false;
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Lightweight HTTP server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleAuthen = buildPerlPackage {
    pname = "HTTP-Server-Simple-Authen";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Server-Simple-Authen-0.04.tar.gz";
      sha256 = "2dddc8ab9dc8986980151e4ba836a6bbf091f45cf195be1768ebdb4a993ed59b";
    };
    propagatedBuildInputs = [ AuthenSimple HTTPServerSimple ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleMason = buildPerlPackage {
    pname = "HTTP-Server-Simple-Mason";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-Mason-0.14.tar.gz";
      sha256 = "b7a49d8e6e55bff0b1f0278d951685466b143243b6f9e59e071f5472ca2a025a";
    };
    propagatedBuildInputs = [ HTMLMason HTTPServerSimple HookLexWrap ];
    meta = {
      description = "A simple mason server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimplePSGI = buildPerlPackage {
    pname = "HTTP-Server-Simple-PSGI";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Server-Simple-PSGI-0.16.tar.gz";
      sha256 = "1fhx2glycd66m4l4m1gja81ixq8nh4r5g9wjhhkrffq4af2cnz2z";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Perl Web Server Gateway Interface Specification";
      homepage = "https://github.com/miyagawa/HTTP-Server-Simple-PSGI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPTinyCache = buildPerlPackage {
    pname = "HTTP-Tiny-Cache";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/HTTP-Tiny-Cache-0.002.tar.gz";
      sha256 = "08c6274x7fxl9r7cw1yiq21wv2mjgxw7db0wv5r80dyw377vfzbk";
    };
    propagatedBuildInputs = [ FileUtilTempdir Logger ];
    meta = {
      description = "Cache HTTP::Tiny responses";
      homepage = "https://metacpan.org/release/HTTP-Tiny-Cache";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  HTTPTinyish = buildPerlPackage {
    pname = "HTTP-Tinyish";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.17.tar.gz";
      sha256 = "47bd111e474566d733c41870e2374c81689db5e0b5a43adc48adb665d89fb067";
    };
    propagatedBuildInputs = [ FileWhich IPCRun3 ];
    meta = {
      description = "HTTP::Tiny compatible HTTP client wrappers";
      homepage = "https://github.com/miyagawa/HTTP-Tinyish";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  iCalParser = buildPerlPackage {
    pname = "iCal-Parser";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIXED/iCal-Parser-1.21.tar.gz";
      sha256 = "0d7939a644a8e67017ec7239d3d9604f3986bb9a4ff80be68fe7299ebfd2270c";
    };
    propagatedBuildInputs = [ DateTimeFormatICal FreezeThaw IOString TextvFileasData ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImagePNGLibpng = buildPerlPackage {
    pname = "Image-PNG-Libpng";
    version = "0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/Image-PNG-Libpng-0.56.tar.gz";
      sha256 = "+vu/6/9CP3u4XvJ6MEH7YpG1AzbHpYIiSlysQzHDx9k=";
    };
    buildInputs = [ pkgs.libpng ];
    meta = {
      description = "Perl interface to libpng";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pnginspect";
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.ImagePNGLibpng.x86_64-darwin
    };
  };

  Imager = buildPerlPackage {
    pname = "Imager";
    version = "1.019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TONYC/Imager-1.019.tar.gz";
      sha256 = "sha256-dNRNcBwfFPxLmE+toelVcmtQTC2LBtJl56hh+llDy0g=";
    };
    buildInputs = [ pkgs.freetype pkgs.fontconfig pkgs.libjpeg pkgs.libpng ];
    makeMakerFlags = "--incpath ${pkgs.libjpeg.dev}/include --libpath ${pkgs.libjpeg.out}/lib --incpath ${pkgs.libpng.dev}/include --libpath ${pkgs.libpng.out}/lib";
    meta = {
      description = "Perl extension for Generating 24 bit Images";
      homepage = "http://imager.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImagerQRCode = buildPerlPackage {
    pname = "Imager-QRCode";
    version = "0.035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KURIHARA/Imager-QRCode-0.035.tar.gz";
      sha256 = "2a848deba29eb3942c44709a6853e318acab0c468cbfedbb9baae54760032513";
    };
    propagatedBuildInputs = [ Imager ];
    meta = {
      description = "Generate QR Code with Imager using libqrencode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  ImageInfo = buildPerlPackage {
    pname = "Image-Info";
    version = "1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/Image-Info-1.42.tar.gz";
      sha256 = "2bca560c3f71b3c1cd63ac3a974e62f3baeb986b7ffaa026b929081b914a8f4f";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "Extract meta information from image files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageSane = buildPerlPackage {
    pname = "Image-Sane";
    version = "5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/Image-Sane-5.tar.gz";
      sha256 = "229aa0e9f049efa760f3c2f6e61d9d539af43d8f764b50a6e03064b4729a35ff";
    };
    buildInputs = [ pkgs.sane-backends ExtUtilsDepends ExtUtilsPkgConfig TestRequires TryTiny ];
    propagatedBuildInputs = [ ExceptionClass Readonly ];
    meta = {
      description = "Perl extension for the SANE (Scanner Access Now Easy) Project";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImageScale = buildPerlPackage {
    pname = "Image-Scale";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/Image-Scale-0.14.tar.gz";
      sha256 = "f09c5f0663b87738365ac2819e186b909abeb9ed85d83bc15ee76872c947cdf8";
    };
    buildInputs = [ pkgs.libpng pkgs.libjpeg TestNoWarnings ];
    propagatedBuildInputs = [ pkgs.zlib ];
    makeMakerFlags = "--with-jpeg-includes=${pkgs.libjpeg.dev}/include --with-jpeg-libs=${pkgs.libjpeg.out}/lib --with-png-includes=${pkgs.libpng.dev}/include --with-png-libs=${pkgs.libpng.out}/lib";
    meta = {
      description = "Fast, high-quality fixed-point image resizing";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  ImageSize = buildPerlPackage {
    pname = "Image-Size";
    version = "3.300";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz";
      sha256 = "0sq2kwdph55h4adx50fmy86brjkkv8grsw33xrhf1k9icpwb3jak";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "A library to extract height/width from images";
      homepage = "http://search.cpan.org/dist/Image-Size";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "imgsize";
    };
  };

  ImageOCRTesseract = buildPerlPackage {
    pname = "Image-OCR-Tesseract";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEOCHARRE/Image-OCR-Tesseract-1.26.tar.gz";
      sha256 = "98d904266a7062f09c9b46f77c4e94529e1fe99339e3f83fda1f92013f007cea";
    };
    nativeBuildInputs = [ pkgs.which pkgs.makeWrapper pkgs.tesseract pkgs.imagemagick ];
    propagatedBuildInputs = [ FileFindRule FileWhich LEOCHARRECLI StringShellQuote ];
    postPatch = ''
      substituteInPlace lib/Image/OCR/Tesseract.pm \
        --replace "which('tesseract')" "\"${pkgs.tesseract}/bin/tesseract\"" \
        --replace "which('convert')" "\"${pkgs.imagemagick}/bin/convert"\"
    '';
    postInstall = ''
      wrapProgram $out/bin/ocr --prefix PATH : ${lib.makeBinPath [ pkgs.tesseract pkgs.imagemagick ]}
    '';
    meta = {
      description = "Read an image with tesseract ocr and get output";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "ocr";
    };
  };

  IMAPClient = buildPerlPackage {
    pname = "IMAP-Client";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CONTEB/IMAP-Client-0.13.tar.gz";
      sha256 = "15fa4hpw2rqg2iadyz10rnv99hns78wph5qlh3257a3mbfjjyyla";
    };
    doCheck = false; # nondeterministic
  };

  Importer = buildPerlPackage {
    pname = "Importer";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Importer-0.026.tar.gz";
      sha256 = "e08fa84e13cb998b7a897fc8ec9c3459fcc1716aff25cc343e36ef875891b0ef";
    };
    meta = {
      description = "Alternative but compatible interface to modules that export symbols";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImportInto = buildPerlPackage {
    pname = "Import-Into";
    version = "1.002005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Import-Into-1.002005.tar.gz";
      sha256 = "0rq5kz7c270q33jq6hnrv3xgkvajsc62ilqq7fs40av6zfipg7mx";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Import packages into other packages";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IO = buildPerlPackage {
    pname = "IO";
    version = "1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IO-1.42.tar.gz";
      sha256 = "eec5cc33a6cddba8b5d2425b60752882add7e4d41b7431a0ea4dcd73cc1f8cca";
    };
    doCheck = false;
    meta = {
      description = "Perl core IO modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAIO = buildPerlPackage {
    pname = "IO-AIO";
    version = "4.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/IO-AIO-4.73.tar.gz";
      sha256 = "0nmcwj385zdk65z8b9ivsvbm1d7a3d5gfnhy7mkbgyi4h33lfnws";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ commonsense ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/treescan
    '';
    meta = {
      description = "Asynchronous/Advanced Input/Output";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "treescan";
    };
  };

  IOAll = buildPerlPackage {
    pname = "IO-All";
    version = "0.87";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/IO-All-0.87.tar.gz";
      sha256 = "0nsd9knlbd7if2v6zwj4q978axq0w5hk8ymp61z14a821hjivqjl";
    };
    meta = {
      description = "IO::All of it to Graham and Damian!";
      homepage = "https://github.com/ingydotnet/io-all-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAsync = buildPerlModule {
    pname = "IO-Async";
    version = "0.801";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/IO-Async-0.801.tar.gz";
      sha256 = "sha256-ieRZuhe3alcrsbS7EgMBVB6MyTJCQXFmI2tsbbDhybk=";
    };
    preCheck = "rm t/50resolver.t"; # this test fails with "Temporary failure in name resolution" in sandbox
    propagatedBuildInputs = [ Future StructDumb ];
    buildInputs = [ FutureIO TestFatal TestIdentity TestMetricsAny TestRefcount ];
    meta = {
      description = "Asynchronous event-driven programming";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAsyncSSL = buildPerlModule {
    pname = "IO-Async-SSL";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/IO-Async-SSL-0.23.tar.gz";
      sha256 = "sha256-0vyuFuJ+F6yjkDpK1aK/L7wmjQZRzn8ARabQVG9YTy4=";
    };
    buildInputs = [ TestIdentity ];
    propagatedBuildInputs = [ Future IOAsync IOSocketSSL ];
    meta = {
      description = "Use SSL/TLS with IO::Async";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  IOCapture = buildPerlPackage {
    pname = "IO-Capture";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REYNOLDS/IO-Capture-0.05.tar.gz";
      sha256 = "c2c15a254ca74fb8c57d25d7b6cbcaff77a3b4fb5695423f1f80bb423abffea9";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCaptureOutput = buildPerlPackage {
    pname = "IO-CaptureOutput";
    version = "1.1105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/IO-CaptureOutput-1.1105.tar.gz";
      sha256 = "ae99009fca1273800f169ecb82f4ed1cc6c76795f156bee5c0093005d572f487";
    };
    meta = {
      description = "(DEPRECATED) capture STDOUT and STDERR from Perl code, subprocesses or XS";
      homepage = "https://github.com/dagolden/IO-CaptureOutput";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCompress = buildPerlPackage {
    pname = "IO-Compress";
    version = "2.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/IO-Compress-2.102.tar.gz";
      sha256 = "193jvi4800cbcac5n1swj9zgwwqck9c47g0g592ldr7fbfd7zynn";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    # Same as CompressRawZlib
    doCheck = false && !stdenv.isDarwin;
    meta = {
      description = "IO Interface to compressed data files/buffers";
      homepage = "https://github.com/pmqs/IO-Compress";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "streamzip";
    };
  };

  IODigest = buildPerlPackage {
    pname = "IO-Digest";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.11.tar.gz";
      sha256 = "14kz7z4xw179aya3116wxac29l4y2wmwrba087lya4v2gxdgiz4g";
    };
    propagatedBuildInputs = [ PerlIOviadynamic ];
  };

  IOHTML = buildPerlPackage {
    pname = "IO-HTML";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz";
      sha256 = "1xcbplf8rxb3z4wz66h5w7vy1g83bkxksxwnjp1z5fv3jksjsyy8";
    };
    meta = {
      description = "Open an HTML file with automatic charset detection";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOHandleUtil = buildPerlModule {
    pname = "IO-Handle-Util";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/IO-Handle-Util-0.02.tar.gz";
      sha256 = "1vncvsx53iiw1yy3drlk44hzx2pk5cial0h74djf9i6s2flndfcd";
    };
    propagatedBuildInputs = [ IOString SubExporter asa ];
    buildInputs = [ ModuleBuildTiny TestSimple13 ];
    meta = {
      description = "Functions for working with IO::Handle like objects";
      homepage = "https://github.com/karenetheridge/IO-Handle-Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOInteractive = buildPerlPackage {
    pname = "IO-Interactive";
    version = "1.022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/IO-Interactive-1.022.tar.gz";
      sha256 = "0ed53b8ae93ae877e98e0d89b7b429e29ccd1ee4c28e952c4ea9aa73d01febdc";
    };
    meta = {
      description = "Utilities for interactive I/O";
      homepage = "https://github.com/briandfoy/io-interactive";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  IOInteractiveTiny = buildPerlPackage {
    pname = "IO-Interactive-Tiny";
    version = "0.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/IO-Interactive-Tiny-0.2.tar.gz";
      sha256 = "45c0696505c7e4347845f5cd2512b7b1bc78fbce4cbed2b58008283fc95ea5f9";
    };
    meta = {
      description = "Is_interactive() without large deps";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  IOLockedFile = buildPerlPackage {
    pname = "IO-LockedFile";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RANI/IO-LockedFile-0.23.tar.gz";
      sha256 = "1dgq8zfkaszisdb5hz8jgcl0xc3qpv7bbv562l31xgpiddm7xnxi";
    };
  };

  IOMultiplex = buildPerlPackage {
    pname = "IO-Multiplex";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBB/IO-Multiplex-1.16.tar.gz";
      sha256 = "74d22c44b5ad2e7190e2786e8a17d74bbf4cef89b4d1157ba33598b5a2720dad";
    };
  };

  IOPager = buildPerlPackage {
    version = "2.10";
    pname = "IO-Pager";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-2.10.tgz";
      sha256 = "15dimh3i61y6kybhbap91kwh9837xfww072rh95h7j40sb1did5w";
    };
    propagatedBuildInputs = [ pkgs.more FileWhich TermReadKey ]; # `more` used in tests
    meta = {
      description = "Select a pager (possibly perl-based) & pipe it text if a TTY";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "tp";
    };
  };

  IOPty = buildPerlModule {
    pname = "IO-Pty";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Tty-1.16.tar.gz";
      sha256 = "sha256-jxoJwHBzitxpXfkD8uf3QwjdjZkbkUwLw5Cg5gISlN0=";
    };
    buildPhase = "make";
    checkPhase = "make test";
    installPhase = "make install";
    meta = {
      homepage = "https://github.com/toddr/IO-Tty";
      description = "Pseudo TTY object class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPrompt = buildPerlModule {
    pname = "IO-Prompt";
    version = "0.997004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/IO-Prompt-0.997004.tar.gz";
      sha256 = "f17bb305ee6ac8b5b203e6d826eb940c4f3f6d6f4bfe719c3b3a225f46f58615";
    };
    propagatedBuildInputs = [ TermReadKey Want ];
    doCheck = false; # needs access to /dev/tty
    meta = {
      description = "Interactively prompt for user input";
      license = with lib.licenses; [ unfree ];
    };
  };

  IOSessionData = buildPerlPackage {
    pname = "IO-SessionData";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/IO-SessionData-1.03.tar.gz";
      sha256 = "1p9d77pqy9a8dbgw7h7vmmkg0rlckk19dchd4c8gvcyv7qm73934";
    };
    outputs = [ "out" "dev" ]; # no "devdoc"
    meta = {
      description = "Supporting module for SOAP::Lite";
      license = with lib.licenses; [ unfree ];
    };
  };

  IOSocketInet6 = buildPerlModule {
    pname = "IO-Socket-INET6";
    version = "2.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.72.tar.gz";
      sha256 = "1fqypz6qa5rw2d5y2zq7f49frwra0aln13nhq5gi514j2zx21q45";
    };
    propagatedBuildInputs = [ Socket6 ];
    doCheck = false;
  };

  IOSocketSSL = buildPerlPackage {
    pname = "IO-Socket-SSL";
    version = "2.068";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SULLR/IO-Socket-SSL-2.068.tar.gz";
      sha256 = "4420fc0056f1827b4dd1245eacca0da56e2182b4ef6fc078f107dc43c3fb8ff9";
    };
    propagatedBuildInputs = [ MozillaCA NetSSLeay ];
    # Fix path to default certificate store.
    postPatch = ''
      substituteInPlace lib/IO/Socket/SSL.pm \
        --replace "\$openssldir/cert.pem" "/etc/ssl/certs/ca-certificates.crt"
    '';
    doCheck = false; # tries to connect to facebook.com etc.
    meta = {
      description = "Nearly transparent SSL encapsulation for IO::Socket::INET";
      homepage = "https://github.com/noxxi/p5-io-socket-ssl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketTimeout = buildPerlModule {
    pname = "IO-Socket-Timeout";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/IO-Socket-Timeout-0.32.tar.gz";
      sha256 = "edf915d6cc66bee43503aa6dc2b373366f38eaff701582183dad10cb8adf2972";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork TestTCP ];
    propagatedBuildInputs = [ PerlIOviaTimeout ];
    meta = {
      description = "IO::Socket with read/write timeout";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOString = buildPerlPackage {
    pname = "IO-String";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz";
      sha256 = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0";
    };
  };

  IOStringy = buildPerlPackage {
    pname = "IO-Stringy";
    version = "2.113";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz";
      sha256 = "0kpycb56l6ilvmdx9swx9wpj1x3vfnqdflfjd6dn6spnz750y8ji";
    };
  };

  IOStty = buildPerlModule {
    pname = "IO-Stty";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Stty-0.04.tar.gz";
      sha256 = "sha256-XJUJ8ahpPYKH+gE97wv4eqZM2ScThGHvjetVUDxmUcI=";
    };
    buildPhase = "make";
    checkPhase = "make test";
    installPhase = "make install";
    meta = {
      description = "Change and print terminal line settings";
      homepage = "http://wiki.github.com/toddr/IO-Stty";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOTee = buildPerlPackage {
    pname = "IO-Tee";
    version = "0.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/IO-Tee-0.66.tar.gz";
      sha256 = "1q2jhp02rywrbyhvl2lv6qp70dcv5cfalrx3cc4c7y8nclhfg71d";
    };
  };

  IOTieCombine = buildPerlPackage {
    pname = "IO-TieCombine";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.005.tar.gz";
      sha256 = "1bv9ampayf4bvyxg4ivy18l8k79jvq55x6gl68b2fg8b62w4sba0";
    };
    meta = {
      description = "Produce tied (and other) separate but combined variables";
      homepage = "https://github.com/rjbs/IO-TieCombine";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOTty = buildPerlPackage {
    pname = "IO-Tty";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Tty-1.15.tar.gz";
      sha256 = "06mmyr4fkkix1z0j8hnhrccn93isnabf3408kqavn2v2hw7wrya3";
    };
    doCheck = !stdenv.isDarwin;  # openpty fails in the sandbox
  };

  IPCConcurrencyLimit = buildPerlPackage {
    pname = "IPC-ConcurrencyLimit";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTK/IPC-ConcurrencyLimit-0.17.tar.gz";
      sha256 = "sha256-Lk11vlLpD8YFg31ajp+yacCofdPTYfMBLA/5Sl+9z+8=";
    };
    buildInputs = [ ExtUtilsMakeMaker ];
    propagatedBuildInputs = [ FilePath IO ];
    meta = {
      description = "Lock-based limits on cooperative multi-processing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCountry = buildPerlPackage {
    pname = "IP-Country";
    version = "2.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWETTERS/IP-Country-2.28.tar.gz";
      sha256 = "88db833a5ab22ed06cb53d6f205725e3b5371b254596053738885e91fa105f75";
    };
    propagatedBuildInputs = [ GeographyCountries ];
    meta = {
      description = "Fast lookup of country codes from IP addresses";
      license = with lib.licenses; [ mit ];
      mainProgram = "ip2cc";
    };
  };

  GeographyCountries = buildPerlPackage {
    pname = "Geography-Countries";
    version = "2009041301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/Geography-Countries-2009041301.tar.gz";
      sha256 = "48c42e40e8281ba7c981743a854c48e6def2d51eb0925ea6c96e25c74497f20f";
    };
    meta = {
      description = "2-letter, 3-letter, and numerical codes for countries";
      license = with lib.licenses; [ mit ];
    };
  };


  IPCRun = buildPerlPackage {
    pname = "IPC-Run";
    version = "20200505.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IPC-Run-20200505.0.tar.gz";
      sha256 = "00f9wjvhn55zbk3n9il76xvsqy7ddk60lg6phg2rkpx0gwhvyvl1";
    };
    doCheck = false; /* attempts a network connection to localhost */
    propagatedBuildInputs = [ IOTty ];
    buildInputs = [ Readonly ];
    meta = {
      description = "System() and background procs w/ piping, redirs, ptys (Unix, Win32)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCRun3 = buildPerlPackage {
    pname = "IPC-Run3";
    version = "0.048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz";
      sha256 = "0r9m8q78bg7yycpixd7738jm40yz71p2q7inm766kzsw3g6c709x";
    };
  };

  IPCShareLite = buildPerlPackage {
    pname = "IPC-ShareLite";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/IPC-ShareLite-0.17.tar.gz";
      sha256 = "1gz7dbwxrzbzdsjv11kb49jlf9q6lci2va6is0hnavd93nwhdm0l";
    };
  };

  IPCSystemSimple = buildPerlPackage {
    pname = "IPC-System-Simple";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz";
      sha256 = "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e";
    };
    meta = {
      description = "Run commands simply, with detailed diagnostics";
      homepage = "http://thenceforward.net/perl/modules/IPC-System-Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCSysV = buildPerlPackage {
    pname = "IPC-SysV";
    version = "2.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHX/IPC-SysV-2.09.tar.gz";
      sha256 = "1g9ddlba4w2jpasn4sh5v1spag4x87rhfv7b0w8gsj6mfhf595qq";
    };
    meta = {
      description = "System V IPC constants and system calls";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IRCUtils = buildPerlPackage {
    pname = "IRC-Utils";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HINRIK/IRC-Utils-0.12.tar.gz";
      sha256 = "c7d6311eb6c79e983833c9e6b4e8d426d07a9874d20f4bc641b313b99c9bc8a0";
    };
    meta = {
      description = "Common utilities for IRC-related tasks";
      homepage = "http://metacpan.org/release/IRC-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  ImageExifTool = buildPerlPackage rec {
    pname = "Image-ExifTool";
    version = "12.39";

    src = fetchurl {
      url = "https://exiftool.org/Image-ExifTool-${version}.tar.gz";
      sha256 = "sha256-QDq1KTpEcl8EWj9a/bxF0TwghUulH30O5yDV0wsxy6I=";
    };

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/exiftool
    '';

    meta = with lib; {
      description = "A tool to read, write and edit EXIF meta information";
      homepage = "https://exiftool.org/";

      license = with licenses; [ gpl1Plus /* or */ artistic2 ];
      maintainers = [ maintainers.kiloreux ];
      mainProgram = "exiftool";
    };
  };

  Inline = buildPerlPackage {
    pname = "Inline";
    version = "0.86";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Inline-0.86.tar.gz";
      sha256 = "510a7de2d011b0db80b0874e8c0f7390010991000ae135cff7474df1e6d51e3a";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Write Perl Subroutines in Other Programming Languages";
      homepage = "https://github.com/ingydotnet/inline-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineC = buildPerlPackage {
    pname = "Inline-C";
    version = "0.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/Inline-C-0.81.tar.gz";
      sha256 = "f185258d9050d7f79b4f00f12625cc469c2f700ff62d3e831cb18d80d2c87aac";
    };
    buildInputs = [ FileCopyRecursive TestWarn YAMLLibYAML ];
    propagatedBuildInputs = [ Inline ParseRecDescent Pegex ];
    postPatch = ''
      # this test will fail with chroot builds
      rm -f t/08taint.t
      rm -f t/28autowrap.t
    '';
    meta = {
      description = "C Language Support for Inline";
      homepage = "https://github.com/ingydotnet/inline-c-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineJava = buildPerlPackage {
    pname = "Inline-Java";
    version = "0.66";

    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/Inline-Java-0.66.tar.gz";
      sha256 = "0j6r6gxdn3wzx36cgcx4znj4ihp5fjl4gzk1623vvwgnwrlf0hy7";
    };

    propagatedBuildInputs = [ Inline ];

    # TODO: upgrade https://github.com/NixOS/nixpkgs/pull/89731
    makeMakerFlags = "J2SDK=${pkgs.jdk8}";

    # FIXME: Apparently tests want to access the network.
    doCheck = false;

    meta = {
      description = "Write Perl classes in Java";
      license = with lib.licenses; [ artistic2 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.InlineJava.x86_64-darwin
    };
  };

  IPCSignal = buildPerlPackage {
    pname = "IPC-Signal";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/IPC-Signal-1.00.tar.gz";
      sha256 = "1l3g0zrcwf2whwjhbpwdcridb7c77mydwxvfykqg1h6hqb4gj8bw";
    };
  };

  JavaScriptMinifierXS = buildPerlModule {
    pname = "JavaScript-Minifier-XS";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GT/GTERMARS/JavaScript-Minifier-XS-0.11.tar.gz";
      sha256 = "1vlyhckpjbrg2v4dy9szsxxl0q44n0y1xl763mg2y2ym9g5144hm";
    };
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "XS based JavaScript minifier";
      homepage = "http://metacpan.org/release/JavaScript-Minifier-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JavaScriptValueEscape = buildPerlModule {
    pname = "JavaScript-Value-Escape";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/JavaScript-Value-Escape-0.07.tar.gz";
      sha256 = "1p5365lvnax8kbcfrj169lx05af3i3qi5wg5x9mizqgd10vxmjws";
    };
    meta = {
      description = "Avoid XSS with JavaScript value interpolation";
      homepage = "https://github.com/kazeburo/JavaScript-Value-Escape";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSON = buildPerlPackage {
    pname = "JSON";
    version = "4.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz";
      sha256 = "0z32x2lijij28c9fhmzgxc41i9nw24fyvd2a8ajs5zw9b9sqhjj4";
    };
    # Do not abort cross-compilation on failure to load native JSON module into host perl
    preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Makefile.PL --replace "exit 0;" ""
    '';
    buildInputs = [ TestPod ];
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONAny = buildPerlPackage {
    pname = "JSON-Any";
    version = "1.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/JSON-Any-1.39.tar.gz";
      sha256 = "1hspg6khjb38syn59cysnapc1q77qgavfym3fqr6l2kiydf7ajdf";
    };
    buildInputs = [ TestFatal TestRequires TestWarnings TestWithoutModule ];
    meta = {
      description = "(DEPRECATED) Wrapper Class for the various JSON classes";
      homepage = "https://github.com/karenetheridge/JSON-Any";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONCreate = buildPerlPackage {
    pname = "JSON-Create";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/JSON-Create-0.35.tar.gz";
      sha256 = "5faefe0d833b8132568865308f3239d3cdaa1b8a1ecc9b5624dcf1efbe10683e";
    };
    propagatedBuildInputs = [ JSONParse UnicodeUTF8 ];
    meta = {
      description = "Create JSON";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONMaybeXS = buildPerlPackage {
    pname = "JSON-MaybeXS";
    version = "1.004003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/JSON-MaybeXS-1.004003.tar.gz";
      sha256 = "1grg8saa318bs4x2wqnww7y0nra7azrzg35bk5pgvkwxzwbkpvjv";
    };
    buildInputs = [ TestNeeds ];
    meta = {
      description = "Use Cpanel::JSON::XS with a fallback to JSON::XS and JSON::PP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPP = buildPerlPackage {
    pname = "JSON-PP";
    version = "4.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/JSON-PP-4.05.tar.gz";
      sha256 = "1kphifz5zzyjnn4s9d8dynvinm76bbsf1b7a7bs48kfgpjkbr8nm";
    };
    meta = {
      description = "JSON::XS compatible pure-Perl module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "json_pp";
    };
  };

  JSONPPCompat5006 = buildPerlPackage {
    pname = "JSON-PP-Compat5006";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-Compat5006-1.09.tar.gz";
      sha256 = "197030df52635f9bbe25af10742eea5bd74971473118c11311fcabcb62e3716a";
    };
    meta = {
      description = "Helper module in using JSON::PP in Perl 5.6";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONParse = buildPerlPackage {
    pname = "JSON-Parse";
    version = "0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/JSON-Parse-0.61.tar.gz";
      sha256 = "ce8e55e70bef9bcbba2e96af631d10a605900961a22cad977e71aab56c3f2806";
    };
    meta = {
      description = "Parse JSON";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "validjson";
    };
  };

  JSONValidator = buildPerlPackage {
    pname = "JSON-Validator";
    version = "5.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/JSON-Validator-5.08.tar.gz";
      sha256 = "sha256-QPaWjtcfxv1Ij6Q1Ityhk5NDhUCSth/eZgHwcWZHeFg=";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ DataValidateDomain DataValidateIP Mojolicious NetIDNEncode YAMLLibYAML ];
    meta = {
      description = "Validate data against a JSON schema";
      homepage = "https://github.com/mojolicious/json-validator";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  JSONWebToken = buildPerlModule {
    pname = "JSON-WebToken";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/JSON-WebToken-0.10.tar.gz";
      sha256 = "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b";
    };
    buildInputs = [ TestMockGuard TestRequires ];
    propagatedBuildInputs = [ JSON ModuleRuntime ];
    meta = {
      description = "JSON Web Token (JWT) implementation";
      homepage = "https://github.com/xaicron/p5-JSON-WebToken";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONXS = buildPerlPackage {
    pname = "JSON-XS";
    version = "4.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz";
      sha256 = "0s4hdfjwi1sq3cx4bjxrg8k1s4nhb0vm6948iklag89gbzs3cmai";
    };
    propagatedBuildInputs = [ TypesSerialiser ];
    buildInputs = [ CanaryStability ];
    meta = {
      description = "JSON serialising/deserialising, done correctly and fast";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "json_xs";
    };
  };

  JSONXSVersionOneAndTwo = buildPerlPackage {
    pname = "JSON-XS-VersionOneAndTwo";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/JSON-XS-VersionOneAndTwo-0.31.tar.gz";
      sha256 = "e6092c4d961fae777acf7fe99fb3cd6e5b710fec85765a6b90417480e4c94a34";
    };
    propagatedBuildInputs = [ JSONXS ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Later = buildPerlPackage {
    version = "0.21";
    pname = "Object-Realize-Later";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Object-Realize-Later-0.21.tar.gz";
      sha256 = "1nfqssld7pcdw9sj4mkfnh75w51wl14i1h7npj9fld4fri09cywg";
    };
  };

  LaTeXML = buildPerlPackage rec {
    pname = "LaTeXML";
    version = "0.8.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRMILLER/${pname}-${version}.tar.gz";
      sha256 = "1ccvdq7asxq6iw8x8ihwf5xs2mp7fkwm467xy7g8spkznr8wcacm";
    };
    patches = [
      (fetchpatch {
        # https://github.com/brucemiller/LaTeXML/issues/1669
        name = "downgrade-security-FileTemp.patch";
        url = "https://github.com/brucemiller/LaTeXML/commit/c3d6b9b88f9eafce6eee52b1634ea33085ba9ec6.patch";
        sha256 = "12w6nfv0bkj2mr4xwcqzkdngrpbq4fn52n85r9njdg913cvfirm7";
      })
    ];
    outputs = [ "out" "tex" ];
    propagatedBuildInputs = [ ArchiveZip DBFile FileWhich IOString ImageMagick ImageSize JSONXS LWP ParseRecDescent PodParser TextUnidecode XMLLibXSLT ];
    nativeBuildInputs = [ pkgs.makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;
    makeMakerFlags = "TEXMF=\${tex} NOMKTEXLSR";
    # shebangs need to be patched before executables are copied to $out
    preBuild = ''
      patchShebangs bin/
    '' + lib.optionalString stdenv.isDarwin ''
      for file in bin/*; do
        shortenPerlShebang "$file"
      done
    '';
    postInstall = ''
      for file in latexmlc latexmlmath latexmlpost ; do
        # add runtime dependencies that cause silent failures when missing
        wrapProgram $out/bin/$file --prefix PATH : ${lib.makeBinPath [ pkgs.ghostscript pkgs.potrace ]}
      done
    '';
    passthru = {
      tlType = "run";
      pkgs = [ LaTeXML.tex ];
    };
    meta = {
      description = "Transforms TeX and LaTeX into XML/HTML/MathML";
      homepage = "https://dlmf.nist.gov/LaTeXML/";
      license = with lib.licenses; [ publicDomain ];
      maintainers = with maintainers; [ xworld21 ];
      mainProgram = "latexml";
    };
  };

  LEOCHARRECLI = buildPerlPackage {
    pname = "LEOCHARRE-CLI";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEOCHARRE/LEOCHARRE-CLI-1.19.tar.gz";
      sha256 = "37835f11ee35326241b4d30368ae1bc195a50414b3662db3e13b865bd52fcde9";
    };
    propagatedBuildInputs = [ FileWhich Filechmod LEOCHARREDebug Linuxusermod YAML ];
    meta = {
      description = "Useful subs for coding cli scripts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LEOCHARREDebug = buildPerlPackage {
    pname = "LEOCHARRE-Debug";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEOCHARRE/LEOCHARRE-Debug-1.03.tar.gz";
      sha256 = "c1665aa3abd457cc8624b8c418c6f8bdf58fb3a686f8eed515cf7e93514df192";
    };
    meta = {
      description = "Debug sub";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LexicalSealRequireHints = buildPerlModule {
    pname = "Lexical-SealRequireHints";
    version = "0.0011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Lexical-SealRequireHints-0.011.tar.gz";
      sha256 = "sha256-npGO0RjvaF1uCdqxzW5m7gox13b+JLumPlJDkG9WATo=";
    };
    meta = {
      description = "Prevent leakage of lexical hints";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libapreq2 = buildPerlPackage {
    pname = "libapreq2";
    version = "2.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/libapreq2-2.16.tar.gz";
      sha256 = "e04c855a3ea070b8863569fbae02fe828f534ac88755b23e24d3863cc9598349";
    };
    outputs = [ "out" ];
    buildInputs = [ pkgs.apacheHttpd pkgs.apr pkgs.aprutil ApacheTest ExtUtilsXSBuilder ];
    propagatedBuildInputs = [ (pkgs.apacheHttpdPackages.mod_perl.override { inherit perl; }) ];
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

      # install the library
      make install DESTDIR=$out
      cp -r $out/${pkgs.apacheHttpd.dev}/. $out/.
      cp -r $out/$out/. $out/.

      # install the perl module
      pushd glue/perl
      perl Makefile.PL
      make install DESTDIR=$out
      cp -r $out/${perl}/lib/perl5 $out/lib/
      popd

      # install the apache module
      # https://computergod.typepad.com/home/2007/06/webgui_and_suse.html
      # NOTE: if using the apache module you must use "apreq" as the module name, not "apreq2"
      # services.httpd.extraModules = [ { name = "apreq"; path = "''${pkgs.perlPackages.libapreq2}/modules/mod_apreq2.so"; } ];
      pushd module
      make install DESTDIR=$out
      cp -r $out/${pkgs.apacheHttpd.out}/modules $out/
      popd

      rm -r $out/nix
    '';
    doCheck = false; # test would need to start apache httpd
    meta = {
      license = with lib.licenses; [ asl20 ];
    };
  };

  libintl-perl = buildPerlPackage {
    pname = "libintl-perl";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.32.tar.gz";
      sha256 = "19gbbh9w3rl805mv6mg1q80fsrg610h098qhf7ycnkjnyac84440";
    };
  };

  libnet = buildPerlPackage {
    pname = "libnet";
    version = "3.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/libnet-3.13.tar.gz";
      sha256 = "sha256-WjX7Hy1KopFoDrGvOImfq0U8IsKOcffHvTdHtaPbNIw=";
    };
    patches = [
      (fetchpatch {
        name = "deterministic-libnet.cfg";
        url = "https://github.com/steve-m-hay/perl-libnet/commit/7d076c4352f67ee4ed64092cfad3963a2321bd53.patch";
        sha256 = "0pg9w2m08janqn5nrp4x9w5hbcsyxz87hfskd21zzfrzjk8z28qv";
      })
    ];
    meta = {
      description = "Collection of network protocol modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  librelative = buildPerlPackage {
    pname = "lib-relative";
    version = "1.000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/lib-relative-1.000.tar.gz";
      sha256 = "1mvcdl87d3kyrdx4y6x79k3n5qdd1x5m1hp8lwjxvgfqbw0cgq6z";
    };
    meta = {
      description = "Add paths relative to the current file to @INC";
      homepage = "https://github.com/Grinnz/lib-relative";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  libxml_perl = buildPerlPackage {
    pname = "libxml-perl";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/libxml-perl-0.08.tar.gz";
      sha256 = "1jy9af0ljyzj7wakqli0437zb2vrbplqj4xhab7bfj2xgfdhawa5";
    };
    propagatedBuildInputs = [ XMLParser ];
  };

  LinguaENFindNumber = buildPerlPackage {
    pname = "Lingua-EN-FindNumber";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-FindNumber-1.32.tar.gz";
      sha256 = "1d176d1c863fb9844bd19d2c2a4e68a0ed73da158f724a89405b90db7e8dbd04";
    };
    propagatedBuildInputs = [ LinguaENWords2Nums ];
    meta = {
      description = "Locate (written) numbers in English text ";
      homepage = "https://github.com/neilb/Lingua-EN-FindNumber";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflect = buildPerlPackage {
    pname = "Lingua-EN-Inflect";
    version = "1.905";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.905.tar.gz";
      sha256 = "15ij4rk1nznnd9hyg2hzy1ydpi9h1cdii8hdlq9j6mrf931rxhh5";
    };
    meta = {
      description = "Convert singular to plural. Select 'a' or 'an'";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectNumber = buildPerlPackage {
    pname = "Lingua-EN-Inflect-Number";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-Inflect-Number-1.12.tar.gz";
      sha256 = "66fb33838512746f5c597e80264fea66643f7f26570ec2f9205b6135ad67acbf";
    };
    propagatedBuildInputs = [ LinguaENInflect ];
    meta = {
      description = "Force number of words to singular or plural";
      homepage = "https://github.com/neilbowers/Lingua-EN-Inflect-Number";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENInflectPhrase = buildPerlPackage {
    pname = "Lingua-EN-Inflect-Phrase";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Inflect-Phrase-0.20.tar.gz";
      sha256 = "55058911a99f1755de3eb449a99ffbeb92d88c01ff5dc60511a24679050ddea8";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ LinguaENInflectNumber LinguaENNumberIsOrdinal LinguaENTagger ];
    meta = {
      description = "Inflect short English Phrases";
      homepage = "http://metacpan.org/release/Lingua-EN-Inflect-Phrase";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENNumberIsOrdinal = buildPerlPackage {
    pname = "Lingua-EN-Number-IsOrdinal";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Number-IsOrdinal-0.05.tar.gz";
      sha256 = "28d5695400c0f4e2bd209793cb74f6da2b9257356aacb2947c603425e09618d6";
    };
    buildInputs = [ TestFatal TryTiny ];
    propagatedBuildInputs = [ LinguaENFindNumber ];
    meta = {
      description = "Detect if English number is ordinal or cardinal";
      homepage = "http://metacpan.org/release/Lingua-EN-Number-IsOrdinal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENTagger = buildPerlPackage {
    pname = "Lingua-EN-Tagger";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.31.tar.gz";
      sha256 = "14z9fbl3mf6lxhp0v2apdlxy1fw1y07j4ydrjsh7p3w0wj3qr7ll";
    };
    propagatedBuildInputs = [ HTMLParser LinguaStem MemoizeExpireLRU ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing";
      license = with lib.licenses; [ gpl3 ];
    };
  };

  LinguaENWords2Nums = buildPerlPackage {
    pname = "Lingua-EN-Words2Nums";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOEY/Lingua-EN-Words2Nums-0.18.tar.gz";
      sha256 = "686556797cd2a4eaa066f19bbf03ab25c06278292c9ead2f187dfd9031ea1d85";
    };
    meta = {
      description = "Convert English text to numbers";
      license = with lib.licenses; [ unfree ];
    };
  };

  LinguaPTStemmer = buildPerlPackage {
    pname = "Lingua-PT-Stemmer";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-PT-Stemmer-0.02.tar.gz";
      sha256 = "17c48sfbgwd2ivlgf59sr6jdhwa3aim8750f8pyzz7xpi8gz0var";
    };
    meta = {
      description = "Portuguese language stemming";
      homepage = "https://github.com/neilb/Lingua-PT-Stemmer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaStem = buildPerlModule {
    pname = "Lingua-Stem";
    version = "2.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SN/SNOWHARE/Lingua-Stem-2.31.tar.gz";
      sha256 = "0r02cf5p09r09ivxhn4xmsgmbk041p6qq6p6af15jzj2nqr9j6ma";
    };
    doCheck = false;
    propagatedBuildInputs = [ LinguaPTStemmer LinguaStemFr LinguaStemIt LinguaStemRu LinguaStemSnowballDa SnowballNorwegian SnowballSwedish TextGerman ];
  };

  LinguaStemFr = buildPerlPackage {
    pname = "Lingua-Stem-Fr";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SD/SDP/Lingua-Stem-Fr-0.02.tar.gz";
      sha256 = "0vyrspwzaqjxm5mqshf4wvwa3938mkajd1918d9ii2l9m2rn8kwx";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  LinguaStemIt = buildPerlPackage {
    pname = "Lingua-Stem-It";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AC/ACALPINI/Lingua-Stem-It-0.02.tar.gz";
      sha256 = "1207r183s5hlh4mfwa6p46vzm0dhvrs2dnss5s41a0gyfkxp7riq";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  LinguaStemRu = buildPerlPackage {
    pname = "Lingua-Stem-Ru";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-Stem-Ru-0.04.tar.gz";
      sha256 = "0a2jmdz7jn32qj5hyiw5kbv8fvlpmws8i00a6xcbkzb48yvwww0j";
    };
    meta = {
      description = "Porter's stemming algorithm for Russian (KOI8-R only)";
      homepage = "https://github.com/neilb/Lingua-Stem-Ru";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaStemSnowballDa = buildPerlPackage {
    pname = "Lingua-Stem-Snowball-Da";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CI/CINE/Lingua-Stem-Snowball-Da-1.01.tar.gz";
      sha256 = "0mm0m7glm1s6i9f6a78jslw6wh573208arxhq93yriqmw17bwf9f";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  LinguaTranslit = buildPerlPackage {
    pname = "Lingua-Translit";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALINKE/Lingua-Translit-0.28.tar.gz";
      sha256 = "113f91d8fc2c630437153a49fb7a52b023af8f6278ed96c070b1f60824b8eae1";
    };
    doCheck = false;
    meta = {
      description = "Transliterates text between writing systems";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "translit";
    };
  };

  LinkEmbedder = buildPerlPackage {
    pname = "LinkEmbedder";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/LinkEmbedder-1.20.tar.gz";
      sha256 = "19fwr3y8dd1bya2z86x3904s4dxfx15h7b777529j8n74m78ppmi";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "Embed / expand oEmbed resources and other URL / links";
      homepage = "https://github.com/jhthorsen/linkembedder";
      license = with lib.licenses; [ artistic2 ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  LinuxACL = buildPerlPackage {
    pname = "Linux-ACL";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NAZAROV/Linux-ACL-0.05.tar.gz";
      sha256 = "312940c1f60f47c4fc93fa0a9d2a626425faa837040c8c2f1ad58ee09f62f371";
    };
    buildInputs = [ pkgs.acl ];
    NIX_CFLAGS_LINK = "-L${pkgs.acl.out}/lib -lacl";
    meta = {
      description = "Perl extension for reading and setting Access Control Lists for files by libacl linux library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  LinuxDesktopFiles = buildPerlModule {
    pname = "Linux-DesktopFiles";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TR/TRIZEN/Linux-DesktopFiles-0.25.tar.gz";
      sha256 = "60377a74fba90fa465200ee1c7430dbdde69d454d85f9ee101c039803a07e5f5";
    };
    meta = {
      description = "Fast parsing of the Linux desktop files";
      homepage = "https://github.com/trizen/Linux-DesktopFiles";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  LinuxDistribution = buildPerlModule {
    pname = "Linux-Distribution";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Linux-Distribution-0.23.tar.gz";
      sha256 = "603e27da607b3e872a669d7a66d75982f0969153eab2d4b20c341347b4ebda5f";
    };
    # The tests fail if the distro it's built on isn't in the supported list.
    # This includes NixOS.
    doCheck = false;
    meta = {
      description = "Perl extension to detect on which Linux distribution we are running";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux;
    };
  };

  LinuxFD = buildPerlModule {
    pname = "Linux-FD";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Linux-FD-0.011.tar.gz";
      sha256 = "6bb579d47644cb0ed35626ff77e909ae69063073c6ac09aa0614fef00fa37356";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ SubExporter ];
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Linux specific special filehandles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux;
    };
  };

  LinuxInotify2 = buildPerlPackage {
    pname = "Linux-Inotify2";
    version = "2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Linux-Inotify2-2.2.tar.gz";
      sha256 = "0crlxmaa4lsgdjm5p9ib8rdxiy70qj1s68za3q3v57v8ll6s4hfx";
    };
    propagatedBuildInputs = [ commonsense ];

    meta = {
      description = "Scalable directory/file change notification for Perl on Linux";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux;
    };
  };

  Linuxusermod = buildPerlPackage {
    pname = "Linux-usermod";
    version = "0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIDUL/Linux-usermod-0.69.tar.gz";
      sha256 = "97ca186a3c416bf69ed62da046f1a60d88d89b8e6ed25008b2f96e787dee9d60";
    };
    meta = {
      description = "This module adds, removes and modify user and group accounts according to the passwd and shadow files syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux;
    };
  };

  ListAllUtils = buildPerlPackage {
    pname = "List-AllUtils";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/List-AllUtils-0.18.tar.gz";
      sha256 = "b7c4bf80090b281c4a1560c76a1a819094c3a1294302f77afb8c60ca4862ecf9";
    };
    propagatedBuildInputs = [ ListSomeUtils ListUtilsBy ];
    meta = {
      description = "Combines List::Util, List::SomeUtils and List::UtilsBy in one bite-sized package";
      homepage = "https://metacpan.org/release/List-AllUtils";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ListBinarySearch = buildPerlPackage {
    pname = "List-BinarySearch";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVIDO/List-BinarySearch-0.25.tar.gz";
      sha256 = "0ap8y9rsjxg75887klgij90mf459f8dwy0dbx1g06h30pmqk04f8";
    };
  };

  ListCompare = buildPerlPackage {
    pname = "List-Compare";
    version = "0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/List-Compare-0.55.tar.gz";
      sha256 = "cc719479836579d52b02bc328ed80a98f679df043a99b5710ab2c191669eb837";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      description = "Compare elements of two or more lists";
      homepage = "http://thenceforward.net/perl/modules/List-Compare";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListMoreUtils = buildPerlPackage {
    pname = "List-MoreUtils";
    version = "0.430";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz";
      sha256 = "09v5cipjf634a1176wy2wicibzz51lry0d0yim9rnbfl5j2ggcb3";
    };
    propagatedBuildInputs = [ ExporterTiny ListMoreUtilsXS ];
    buildInputs = [ TestLeakTrace ];
    meta = {
      description = "Provide the stuff missing in List::Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListMoreUtilsXS = buildPerlPackage {
    pname = "List-MoreUtils-XS";
    version = "0.430";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz";
      sha256 = "0hmjkhmk1qlzbg8skq7g1zral07k1x0fk4w2fpcfr7hpgkaldkp8";
    };
    preConfigure = ''
      export LD=$CC
    '';
    meta = {
      description = "Provide the stuff missing in List::Util in XS";
      homepage = "https://metacpan.org/release/List-MoreUtils-XS";
      license = with lib.licenses; [ asl20 ];
    };
  };

  ListSomeUtils = buildPerlPackage {
    pname = "List-SomeUtils";
    version = "0.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/List-SomeUtils-0.58.tar.gz";
      sha256 = "96eafb359339d22bf2a2de421298847a3c40f6a28b6d44005d0965da86a5469d";
    };
    buildInputs = [ TestLeakTrace ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      description = "Provide the stuff missing in List::Util";
      homepage = "http://metacpan.org/release/List-SomeUtils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListUtilsBy = buildPerlModule {
    pname = "List-UtilsBy";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.11.tar.gz";
      sha256 = "0nkpylkqccxanr8wc7j9wg6jdrizybjjd6p8q3jbh7f29cxz9pgs";
    };
  };

  LocaleCodes = buildPerlPackage {
    pname = "Locale-Codes";
    version = "3.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.66.tar.gz";
      sha256 = "1rspbig3zb7l7s1mlsk9n0rrisy8qrzwn0ix6a7sd372arnwvylr";
    };
    buildInputs = [ TestInter ];
    meta = {
      description = "A distribution of modules to handle locale codes";
      homepage = "https://github.com/SBECK-github/Locale-Codes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleGettext = buildPerlPackage {
    pname = "gettext";
    version = "1.07";
    strictDeps = true;
    buildInputs = [ pkgs.gettext ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz";
      sha256 = "05cwqjxxary11di03gg3fm6j9lbvg1dr2wpr311c1rwp8salg7ch";
    };
    LANG="C";
  };

  LocaleMaketextLexiconGetcontext = buildPerlPackage {
    pname = "Locale-Maketext-Lexicon-Getcontext";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAPER/Locale-Maketext-Lexicon-Getcontext-0.05.tar.gz";
      sha256 = "75cb33df9472a5962de54082f42c6a76b260fc405ba10ca53246fb1f82c09208";
    };
    propagatedBuildInputs = [ LocaleMaketextLexicon ];
    meta = {
      description = "PO file parser for Maketext";
      license = with lib.licenses; [ mit ];
    };
  };

  LocaleMOFile = buildPerlPackage {
    pname = "Locale-MO-File";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-MO-File-0.09.tar.gz";
      sha256 = "0gsaaqimsh5bdhns2v67j1nvb178hx2536lxmr971cwxy31ns0wp";
    };
    propagatedBuildInputs = [ ConstFast MooXStrictConstructor MooXTypesMooseLike ParamsValidate namespaceautoclean ];
    buildInputs = [ TestDifferences TestException TestHexDifferences TestNoWarnings ];
    meta = {
      description = "Write or read gettext MO files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleMaketextFuzzy = buildPerlPackage {
    pname = "Locale-Maketext-Fuzzy";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Fuzzy-0.11.tar.gz";
      sha256 = "3785171ceb78cc7671319a3a6d8ced9b190e097dfcd9b2a9ebc804cd1a282f96";
    };
    meta = {
      description = "Maketext from already interpolated strings";
      license = with lib.licenses; [ free ];
    };
  };

  LocaleMaketextLexicon = buildPerlPackage {
    pname = "Locale-Maketext-Lexicon";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/Locale-Maketext-Lexicon-1.00.tar.gz";
      sha256 = "b73f6b04a58d3f0e38ebf2115a4c1532f1a4eef6fac5c6a2a449e4e14c1ddc7c";
    };
    meta = {
      description = "Use other catalog formats in Maketext";
      homepage = "http://search.cpan.org/dist/Locale-Maketext-Lexicon";
      license = with lib.licenses; [ mit ];
      mainProgram = "xgettext.pl";
    };
  };

  LocaleMsgfmt = buildPerlPackage {
    pname = "Locale-Msgfmt";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AZ/AZAWAWI/Locale-Msgfmt-0.15.tar.gz";
      sha256 = "c3276831cbeecf58be02081bcc180bd348daa35da21a7737b7b038a59f643ab4";
    };
    meta = {
      description = "Compile .po files to .mo files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocalePO = buildPerlPackage {
    pname = "Locale-PO";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/COSIMO/Locale-PO-0.27.tar.gz";
      sha256 = "3c994a4b63e6e4e836c6f79a93f51921cab77c90c9753fe0f8b5429220d516b9";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Perl module for manipulating .po entries from GNU gettext";
      license = with lib.licenses; [ unfree ];
    };
  };

  LocaleTextDomainOO = buildPerlPackage {
    pname = "Locale-TextDomain-OO";
    version = "1.036";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-TextDomain-OO-1.036.tar.gz";
      sha256 = "0f0fajq4k1sgyywsb7qypsf6xa1sxjx4agm8l8z2284nm3hq65xm";
    };
    propagatedBuildInputs = [ ClassLoad Clone JSON LocaleMOFile LocalePO LocaleTextDomainOOUtil LocaleUtilsPlaceholderBabelFish LocaleUtilsPlaceholderMaketext LocaleUtilsPlaceholderNamed MooXSingleton PathTiny TieSub ];
    buildInputs = [ TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Locale::TextDomain::OO - Perl OO Interface to Uniforum Message Translation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleTextDomainOOUtil = buildPerlPackage {
    pname = "Locale-TextDomain-OO-Util";
    version = "4.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-TextDomain-OO-Util-4.002.tar.gz";
      sha256 = "1826pl11vr9p7zv7vqs7kcd8y5218086l90dw8lw0xzdcmzs0prw";
    };
    propagatedBuildInputs = [ namespaceautoclean ];
    buildInputs = [ TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Locale::TextDomain::OO::Util - Lexicon utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleUtilsPlaceholderBabelFish = buildPerlPackage {
    pname = "Locale-Utils-PlaceholderBabelFish";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-Utils-PlaceholderBabelFish-0.006.tar.gz";
      sha256 = "1k54njj8xz19c8bjb0iln1mnfq55j3pvbff7samyrab3k59h071f";
    };
    propagatedBuildInputs = [ HTMLParser MooXStrictConstructor MooXTypesMooseLike namespaceautoclean ];
    buildInputs = [ TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Locale::Utils::PlaceholderBabelFish - Utils to expand BabelFish palaceholders";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleUtilsPlaceholderMaketext = buildPerlPackage {
    pname = "Locale-Utils-PlaceholderMaketext";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-Utils-PlaceholderMaketext-1.005.tar.gz";
      sha256 = "1srlbp8sfnzhndgh9s4d8bglpzw0vb8gnab9r8r8sggkv15n0a2h";
    };
    propagatedBuildInputs = [ MooXStrictConstructor MooXTypesMooseLike namespaceautoclean ];
    buildInputs = [ TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Locale::Utils::PlaceholderMaketext - Utils to expand maketext placeholders";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleUtilsPlaceholderNamed = buildPerlPackage {
    pname = "Locale-Utils-PlaceholderNamed";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-Utils-PlaceholderNamed-1.004.tar.gz";
      sha256 = "1gd68lm5w5c6ndcilx91rn84zviqyrk3fx92jjx5khxm76i8xmvg";
    };
    propagatedBuildInputs = [ MooXStrictConstructor MooXTypesMooseLike namespaceautoclean ];
    buildInputs = [ TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Locale::Utils::PlaceholderNamed - Utils to expand named placeholders";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  locallib = buildPerlPackage {
    pname = "local-lib";
    version = "2.000024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/local-lib-2.000024.tar.gz";
      sha256 = "01cav7m6qc1x96wna1viiw6n212f94ks7cik4vj1a1lasixr36rf";
    };
    propagatedBuildInputs = [ ModuleBuild ];
    meta = {
      description = "Create and use a local lib/ for perl modules with PERL5LIB";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LockFileSimple = buildPerlPackage {
    pname = "LockFile-Simple";
    version = "0.208";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/lockfile-simple/LockFile-Simple-0.208.tar.gz";
      sha256 = "18pk5a030dsg1h6wd8c47wl8pzrpyh9zi9h2c9gs9855nab7iis5";
    };
  };

  LogAny = buildPerlPackage {
    pname = "Log-Any";
    version = "1.708";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/Log-Any-1.708.tar.gz";
      sha256 = "e1407759dc9462ab096d4ddc89feaac8abb341c5429e38cf6f7b8a996a35ecd9";
    };
    # Syslog test fails.
    preCheck = "rm t/syslog.t";
    meta = {
      description = "Bringing loggers and listeners together";
      homepage = "https://github.com/preaction/Log-Any";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogAnyAdapterLog4perl = buildPerlPackage {
    pname = "Log-Any-Adapter-Log4perl";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/Log-Any-Adapter-Log4perl-0.09.tar.gz";
      sha256 = "19f1drqnzr6g4xwjm6jk4iaa3zmiax8bzxqch04f4jr12bjd75qi";
    };
    propagatedBuildInputs = [ LogAny LogLog4perl ];
    meta = {
      description = "Log::Any adapter for Log::Log4perl";
      homepage = "https://github.com/preaction/Log-Any-Adapter-Log4perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogAnyAdapterTAP = buildPerlPackage {
    pname = "Log-Any-Adapter-TAP";
    version = "0.003003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NERDVANA/Log-Any-Adapter-TAP-0.003003.tar.gz";
      sha256 = "131f0689b2b42b1b31449714c6eda8f811dd96a7c86748f1e03b239cfd0121c0";
    };
    propagatedBuildInputs = [ LogAny TryTiny ];
    meta = {
      description = "Logger suitable for use with TAP test files";
      homepage = "https://github.com/silverdirk/perl-Log-Any-Adapter-TAP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogContextual = buildPerlPackage {
    pname = "Log-Contextual";
    version = "0.008001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/Log-Contextual-0.008001.tar.gz";
      sha256 = "b93cbcfbb8796d51c836e3b00243cda5630808c152c14eee5f20ca09c9451993";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DataDumperConcise ExporterDeclare Moo ];
    meta = {
      description = "Simple logging interface with a contextual log";
      homepage = "https://github.com/frioux/Log-Contextual";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatch = buildPerlPackage {
    pname = "Log-Dispatch";
    version = "2.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Log-Dispatch-2.70.tar.gz";
      sha256 = "089z5723lwa8jhl57xa5b901xmvj8kgz60rid33a7lv74k2irnd3";
    };
    propagatedBuildInputs = [ DevelGlobalDestruction ParamsValidationCompiler Specio namespaceautoclean ];
    buildInputs = [ IPCRun3 TestFatal TestNeeds ];
    meta = {
      description = "Dispatches messages to one or more outputs";
      homepage = "https://metacpan.org/release/Log-Dispatch";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  LogDispatchFileRotate = buildPerlPackage {
    pname = "Log-Dispatch-FileRotate";
    version = "1.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Log-Dispatch-FileRotate-1.36.tar.gz";
      sha256 = "0vlmi17p7fky3x58rs7r5mdxi6l5jla8zhlb55kvssxc1w5v2b27";
    };
    propagatedBuildInputs = [ DateManip LogDispatch ];
    buildInputs = [ PathTiny TestWarn ];
    meta = {
      description = "Log to Files that Archive/Rotate Themselves";
      homepage = "https://github.com/mschout/perl-log-dispatch-filerotate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Logger = buildPerlPackage {
    pname = "Log-ger";
    version = "0.037";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/Log-ger-0.037.tar.gz";
      sha256 = "0f5078g8lkyw09ijpz7dna5xw6yvpd0m283fdrw3s152xmr43qn2";
    };
    meta = {
      description = "A lightweight, flexible logging framework";
      homepage = "https://metacpan.org/release/Log-ger";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  LogHandler = buildPerlModule {
    pname = "Log-Handler";
    version = "0.90";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BL/BLOONIX/Log-Handler-0.90.tar.gz";
      sha256 = "0kgp3frz0y51j8kw67d6b4yyrrbh7syqraxchc7pfm442bkq0p1s";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Log messages to several outputs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogMessage = buildPerlPackage {
    pname = "Log-Message";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-0.08.tar.gz";
      sha256 = "bd697dd62aaf26d118e9f0a0813429deb1c544e4501559879b61fcbdfe99fe46";
    };
    meta = {
      description = "Powerful and flexible message logging mechanism";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogMessageSimple = buildPerlPackage {
    pname = "Log-Message-Simple";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-Simple-0.10.tar.gz";
      sha256 = "15nxi935nfrf8dkdrgvcrf2qlai4pbz03yj8sja0n9mcq2jd24ma";
    };
    propagatedBuildInputs = [ LogMessage ];
    meta = {
      description = "Simplified interface to Log::Message";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogTrace = buildPerlPackage {
    pname = "Log-Trace";
    version = "1.070";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBC/Log-Trace-1.070.tar.gz";
      sha256 = "1qrnxn9b05cqyw1286djllnj8wzys10754glxx6z5hihxxc85jwy";
    };
  };

  MCE = buildPerlPackage {
    pname = "MCE";
    version = "1.874";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARIOROY/MCE-1.874.tar.gz";
      sha256 = "1l6khsmwzfr88xb81kdvmdskxgz3pm4yz2ybxkbml4bmhh0y62fq";
    };
    meta = {
      description = "Many-Core Engine for Perl providing parallel processing capabilities";
      homepage = "https://github.com/marioroy/mce-perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogLog4perl = buildPerlPackage {
    pname = "Log-Log4perl";
    version = "1.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/Log-Log4perl-1.53.tar.gz";
      sha256 = "13n39byny3yif3x6nrj9iriw8jhbhxqavwrrlm277v3f066v9gwg";
    };
    meta = {
      description = "Log4j implementation for Perl";
      homepage = "https://mschilli.github.io/log4perl/";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "l4p-tmpl";
    };
  };

  LogDispatchArray = buildPerlPackage {
    pname = "Log-Dispatch-Array";
    version = "1.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatch-Array-1.003.tar.gz";
      sha256 = "0dvzp0gsh17jqg02460ndchyapr1haahndq1p9v6mwkv5wf9680c";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ LogDispatch ];
    meta = {
      description = "Log events to an array (reference)";
      homepage = "https://github.com/rjbs/Log-Dispatch-Array";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatchouli = buildPerlPackage {
    pname = "Log-Dispatchouli";
    version = "2.022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatchouli-2.022.tar.gz";
      sha256 = "2a2a4176adafb85a1eb9c9dc389052919e8c2c9df99aaba538c06b8da964a5df";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ LogDispatchArray StringFlogger SubExporterGlobExporter ];
    meta = {
      description = "A simple wrapper around Log::Dispatch";
      homepage = "https://github.com/rjbs/Log-Dispatchouli";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogJournald = buildPerlModule rec {
    pname = "Log-Journald";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LK/LKUNDRAK/Log-Journald-0.30.tar.gz";
      sha256 = "55992cf9a1e1fb833f428300525bfa7cf7ed46b83ec414f82a091789b37d08a3";
    };
    buildInputs = [ pkgs.pkg-config pkgs.systemd ];
    postPatch = ''
      substituteInPlace Build.PL \
        --replace "libsystemd-journal" "libsystemd"
    '';
    meta = {
      description = "Send messages to a systemd journal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogLogLite = buildPerlPackage {
    pname = "Log-LogLite";
    version = "0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RANI/Log-LogLite-0.82.tar.gz";
      sha256 = "0sqsa4750wvhw4cjmxpxqg30i1jjcddadccflisrdb23qn5zn285";
    };
    propagatedBuildInputs = [ IOLockedFile ];
    meta = {
      description = "Helps us create simple logs for our application";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LongJump = buildPerlPackage {
    pname = "Long-Jump";
    version = "0.000001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Long-Jump-0.000001.tar.gz";
      sha256 = "d5d6456d86992b559d8f66fc90960f919292cd3803c13403faac575762c77af4";
    };
    buildInputs = [ Test2Suite ];
    meta = {
      description = "Mechanism for returning to a specific point from a deeply nested stack";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWP = buildPerlPackage {
    pname = "libwww-perl";
    version = "6.67";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/libwww-perl-6.67.tar.gz";
      sha256 = "sha256-lu7ECj/QqhvYNBF75eshxDj3MJTYYaGn5XdPCxImtyM=";
    };
    propagatedBuildInputs = [ FileListing HTMLParser HTTPCookies HTTPNegotiate NetHTTP TryTiny WWWRobotRules ];
    # support cross-compilation by avoiding using `has_module` which does not work in miniperl (it requires B native module)
    postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Makefile.PL --replace 'if has_module' 'if 0; #'
    '';
    doCheck = !stdenv.isDarwin;
    checkInputs = [ HTTPDaemon TestFatal TestNeeds TestRequiresInternet ];
    meta = with lib; {
      description = "The World-Wide Web library for Perl";
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPAuthenOAuth = buildPerlPackage {
    pname = "LWP-Authen-OAuth";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMBRODY/LWP-Authen-OAuth-1.02.tar.gz";
      sha256 = "e78e0bd7de8002cfb4760073258d555ef55b2c27c07a94b3d8a2166a17fd96bc";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Generate signed OAuth requests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPMediaTypes = buildPerlPackage {
    pname = "LWP-MediaTypes";
    version = "6.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz";
      sha256 = "1n8rg6csv3dsvymg06cmxipimr6cb1g9r903ghm1qsmiv89cl6wg";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Guess media type for a file or a URL";
      homepage = "https://github.com/libwww-perl/lwp-mediatypes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolConnect = buildPerlPackage {
    pname = "LWP-Protocol-connect";
    version = "6.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BE/BENNING/LWP-Protocol-connect-6.09.tar.gz";
      sha256 = "9f252394775e23aa42c3176611e5930638ab528d5190110b4731aa5b0bf35a15";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ LWPProtocolHttps ];
    meta = {
      description = "Provides HTTP/CONNECT proxy support for LWP::UserAgent";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolHttps = buildPerlPackage {
    pname = "LWP-Protocol-https";
    version = "6.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.09.tar.gz";
      sha256 = "14pm785cgyrnppks6ccasb2vkqifh0a8fz36nmnhc2v926jy3kqn";
    };
    patches = [ ../development/perl-modules/lwp-protocol-https-cert-file.patch ];
    propagatedBuildInputs = [ IOSocketSSL LWP ];
    doCheck = false; # tries to connect to https://www.apache.org/.
    buildInputs = [ TestRequiresInternet ];
    meta = {
      description = "Provide https support for LWP::UserAgent";
      homepage = "https://github.com/libwww-perl/LWP-Protocol-https";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolhttp10 = buildPerlPackage {
    pname = "LWP-Protocol-http10";
    version = "6.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/LWP-Protocol-http10-6.03.tar.gz";
      sha256 = "1lxq40qfwfai9ryhzhsdnycc4189c8kfl43rf7qq34fmz48skzzk";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Legacy HTTP/1.0 support for LWP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentCached = buildPerlPackage {
    pname = "LWP-UserAgent-Cached";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLEG/LWP-UserAgent-Cached-0.08.tar.gz";
      hash = "sha256-Pc5atMeAQWVs54Vk92Az5b0ew4b1TS57MHQK5I7nh8M=";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "LWP::UserAgent with simple caching mechanism";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentDNSHosts = buildPerlModule {
    pname = "LWP-UserAgent-DNS-Hosts";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MASAKI/LWP-UserAgent-DNS-Hosts-0.14.tar.gz";
      sha256 = "07w741r98synwnrh9hkv47wr67arhr2bmnvb6s5zqvq87x27jscr";
    };
    propagatedBuildInputs = [ LWP ScopeGuard ];
    buildInputs = [ ModuleBuildTiny TestFakeHTTPD TestSharedFork TestTCP TestUseAllModules ];
    meta = {
      description = "Override LWP HTTP/HTTPS request's host like /etc/hosts";
      homepage = "https://github.com/masaki/p5-LWP-UserAgent-DNS-Hosts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentDetermined = buildPerlPackage {
    pname = "LWP-UserAgent-Determined";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/LWP-UserAgent-Determined-1.07.tar.gz";
      sha256 = "06d8d50e8cd3692a11cb4fb44a2f84e5476a98f0e2e6a4a0dfce9f67e55ddb53";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A virtual browser that retries errors";
      license = with lib.licenses; [ unfree ];
    };
  };

  LWPUserAgentMockable = buildPerlModule {
    pname = "LWP-UserAgent-Mockable";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJEMMESON/LWP-UserAgent-Mockable-1.18.tar.gz";
      sha256 = "0923ahl22c0gdzrihj7dqnrawia9hmcl462asf4ry8d5wd84z1i5";
    };
    propagatedBuildInputs = [ HookLexWrap LWP SafeIsa ];
    # Tests require network connectivity
    # https://rt.cpan.org/Public/Bug/Display.html?id=63966 is the bug upstream,
    # which doesn't look like it will get fixed anytime soon.
    doCheck = false;
    buildInputs = [ ModuleBuildTiny TestRequiresInternet ];
  };

  LWPxParanoidAgent = buildPerlPackage {
    pname = "LWPx-ParanoidAgent";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/lwp/LWPx-ParanoidAgent-1.12.tar.gz";
      sha256 = "0gfhw3jbs25yya2dryv8xvyn9myngcfcmsybj7gkq62fnznil16c";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
  };

  maatkit = callPackage ../development/perl-modules/maatkit { };

  MacPasteboard = buildPerlPackage {
    pname = "Mac-Pasteboard";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/Mac-Pasteboard-0.011.tar.gz";
      sha256 = "1a82pacp6pph3y2agdihzr4vc0phx85mq5am9czc81g8n484b35x";
    };
    buildInputs = [ pkgs.darwin.apple_sdk.frameworks.ApplicationServices ];
    meta = with lib; {
      description = "Manipulate Mac OS X pasteboards";
      license = with licenses; [ artistic1 gpl1Plus ];
      platforms = platforms.darwin;
      mainProgram = "pbtool";
    };
  };

  MailAuthenticationResults = buildPerlPackage {
    pname = "Mail-AuthenticationResults";
    version = "1.20200824.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-AuthenticationResults-1.20200824.1.tar.gz";
      sha256 = "16hyl631yk1d5g3jns0n4mkjawlzqnf003brnk6qc3mbkziaifik";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Object Oriented Authentication-Results Headers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailBox = buildPerlPackage {
    version = "3.009";
    pname = "Mail-Box";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Box-3.009.tar.gz";
      sha256 = "0rcig7mzp8c5r4dxnynjaryyv4claljraxl44gn1kj8l1rmj31ci";
    };

    doCheck = false;

    propagatedBuildInputs = [ DevelGlobalDestruction FileRemove Later MailTransport ];
  };

  MailMboxMessageParser = buildPerlPackage {
    pname = "Mail-Mbox-MessageParser";
    version = "1.5111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/Mail-Mbox-MessageParser-1.5111.tar.gz";
      sha256 = "5723c0aa9cc10bab9ed1e3bfd9d5c95f7159e71c1a475414eb1af1dee3a46237";
    };
    buildInputs = [ FileSlurper TestCompile TestPod TestPodCoverage TextDiff UNIVERSALrequire URI ];
    propagatedBuildInputs = [ FileHandleUnget ];
    meta = {
      description = "A fast and simple mbox folder reader";
      homepage = "https://github.com/coppit/mail-mbox-messageparser";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  MailMessage = buildPerlPackage {
    pname = "Mail-Message";
    version = "3.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Message-3.010.tar.gz";
      sha256 = "04wblxrkcjwn7hw6vkvf307lbpc9blj1glqmm59q3642wcd4nhaq";
    };
    propagatedBuildInputs = [ IOStringy MIMETypes MailTools URI UserIdentity ];
    meta = {
      description = "Processing MIME messages";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailDKIM = buildPerlPackage {
    pname = "Mail-DKIM";
    version = "1.20200907";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-DKIM-1.20200907.tar.gz";
      sha256 = "1x8v4pa0447c1xqri1jn96i8vlyjpl6jmz63nb1vifbp16yi3zxb";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA MailAuthenticationResults MailTools NetDNS ];
    doCheck = false; # tries to access the domain name system
    buildInputs = [ NetDNSResolverMock TestRequiresInternet YAMLLibYAML ];
  };

  MailIMAPClient = buildPerlPackage {
    pname = "Mail-IMAPClient";
    version = "3.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.42.tar.gz";
      sha256 = "0znf035ikaxyfishv507qq6g691xvbnziqlcwfikkj2l1kan88hw";
    };
    propagatedBuildInputs = [ ParseRecDescent ];
  };

  MailPOP3Client = buildPerlPackage {
    pname = "Mail-POP3Client";
    version = "2.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SD/SDOWD/Mail-POP3Client-2.19.tar.gz";
      sha256 = "1142d6247a93cb86b23ed8835553bb2d227ff8213ee2743e4155bb93f47acb59";
    };
    meta = {
      description = "Perl 5 module to talk to a POP3 (RFC1939) server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailRFC822Address = buildPerlPackage {
    pname = "Mail-RFC822-Address";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PD/PDWARREN/Mail-RFC822-Address-0.3.tar.gz";
      sha256 = "351ef4104ecb675ecae69008243fae8243d1a7e53c681eeb759e7b781684c8a7";
    };
  };

  MailSender = buildPerlPackage {
    pname = "Mail-Sender";
    version = "0.903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/Mail-Sender-0.903.tar.gz";
      sha256 = "4413eb49f520a8318151811ccb05a8d542973aada20aa503ad32f9ffc98a39bf";
    };
    meta = {
      description = "(DEPRECATED) module for sending mails with attachments through an SMTP server";
      homepage = "https://github.com/Perl-Email-Project/Mail-Sender";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailSendmail = buildPerlPackage {
    pname = "Mail-Sendmail";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Mail-Sendmail-0.80.tar.gz";
      sha256 = "1r38qbkj7jwj8cqy1rnqzkk81psxi08b1aiq392817f3bk5ri2jv";
    };
    # The test suite simply loads the module and attempts to send an email to
    # the module's author, the latter of which is a) more of an integration
    # test, b) impossible to verify, and c) won't work from a sandbox. Replace
    # it in its entirety with the following simple smoke test.
    checkPhase = ''
      perl -I blib/lib -MMail::Sendmail -e 'print "1..1\nok 1\n"'
    '';
    meta = {
      description = "Simple platform independent mailer";
      homepage = "https://github.com/neilb/Mail-Sendmail";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  MailSPF = buildPerlPackage {
    pname = "Mail-SPF";
    version = "2.9.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMEHNLE/mail-spf/Mail-SPF-v2.9.0.tar.gz";
      sha256 = "61cb5915f1c7acc7a931ffc1bfc1291bdfac555e2a46eb2391b995ea9ecb6162";
    };
    # remove this patch patches = [ ../development/perl-modules/Mail-SPF.patch ];

    buildInputs = [ ModuleBuild NetDNSResolverProgrammable ];
    propagatedBuildInputs = [ Error NetAddrIP NetDNS URI ];

    buildPhase = "perl Build.PL --install_base=$out --install_path=\"sbin=$out/bin\" --install_path=\"lib=$out/${perl.libPrefix}\"; ./Build build ";

    doCheck = false; # The main test performs network access
    meta = {
      description = "An object-oriented implementation of Sender Policy Framework";
      license = with lib.licenses; [ bsd3 ];
      mainProgram = "spfquery";
    };
  };


  MailTools = buildPerlPackage {
    pname = "MailTools";
    version = "2.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz";
      sha256 = "1js43bp2dnd8n2rv8clsv749166jnyqnc91k4wkkmw5n4rlbvnaa";
    };
    propagatedBuildInputs = [ TimeDate ];
    meta = {
      description = "Various ancient e-mail related modules";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailTransport = buildPerlPackage {
    pname = "Mail-Transport";
    version = "3.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Transport-3.005.tar.gz";
      sha256 = "18wna71iyrgn63l7samacvnx2a5ydpcffkg313c8a4jwf0zvkp6h";
    };
    propagatedBuildInputs = [ MailMessage ];
    meta = {
      description = "Email message exchange";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBase85 = buildPerlPackage {
    pname = "Math-Base85";
    version = "0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PT/PTC/Math-Base85-0.4.tar.gz";
      sha256 = "03cbp5ls98zcj183wjzlzjcrhbc96mw3p1hagzy1yplj1xh5ia4y";
    };
    meta = {
      description = "Perl extension for base 85 numbers, as referenced by RFC 1924";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBaseConvert = buildPerlPackage {
    pname = "Math-Base-Convert";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/Math-Base-Convert-0.11.tar.gz";
      sha256 = "8c0971355f24c93b79e77ad54a4570090a1a598fcb9b86f5c17eba42f38b40e0";
    };
  };

  MathLibm = buildPerlPackage {
    pname = "Math-Libm";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSLEWART/Math-Libm-1.00.tar.gz";
      sha256 = "0xn2a950mzzs5q1c4q98ckysn9dz20x7r35g02zvk35chgr0klxz";
    };
  };

  MathCalcParser = buildPerlPackage {
    pname = "Math-Calc-Parser";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Math-Calc-Parser-1.005.tar.gz";
      sha256 = "afc3eb496ab3a3a301b3437af07e197eb743c06090f0101dacf820302f2b7f75";
    };
    buildInputs = [ TestNeeds ];
    meta = {
      description = "Parse and evaluate mathematical expressions";
      homepage = "https://github.com/Grinnz/Math-Calc-Parser";
      license = with lib.licenses; [ artistic2 ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  MathCalcUnits = buildPerlPackage {
    pname = "Math-Calc-Units";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SF/SFINK/Math-Calc-Units-1.07.tar.gz";
      sha256 = "13wgbxv2fmigdj0vf7nwkq1y2q07jgfj8wdrpqkywfxv4zdwzqv1";
    };
    meta = {
      description = "Human-readable unit-aware calculator";
      license = with lib.licenses; [ artistic1 gpl2 ];
      mainProgram = "ucalc";
    };
  };

  MathBigInt = buildPerlPackage {
    pname = "Math-BigInt";
    version = "1.999818";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-1.999818.tar.gz";
      sha256 = "b27634356ce2af9b7c0123ac8395a89a32fb15aeae82fcd39de8156cad278c15";
    };
    meta = {
      description = "Arbitrary size integer/float math package";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBigIntGMP = buildPerlPackage {
    pname = "Math-BigInt-GMP";
    version = "1.6007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-GMP-1.6007.tar.gz";
      sha256 = "07y0akadx2nm1bsp17v12785s3ni1l5qyqkk4q3pxcyc41nmwwjx";
    };
    buildInputs = [ pkgs.gmp ];
    doCheck = false;
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    propagatedBuildInputs = [ MathBigInt ];
  };

  MathBigIntLite = buildPerlPackage {
    pname = "Math-BigInt-Lite";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-Lite-0.19.tar.gz";
      sha256 = "06hm4vgihxr7m4jrq558phnnxy4am6ifba447j0h4p6jym5h7xih";
    };
    propagatedBuildInputs = [ MathBigInt ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathClipper = buildPerlModule {
    pname = "Math-Clipper";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHELDRAKE/Math-Clipper-1.29.tar.gz";
      sha256 = "14vmz1x8hwnlk239dcsh0n39kd7cd7v5g1iikgbyjvc66gqw89sk";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp TestDeep ];
  };

  MathConvexHullMonotoneChain = buildPerlPackage {
    pname = "Math-ConvexHull-MonotoneChain";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Math-ConvexHull-MonotoneChain-0.01.tar.gz";
      sha256 = "1xcl7cz62ydddji9qzs4xsfxss484jqjlj4iixa4aci611cw92r8";
    };
  };

  MathFibonacci = buildPerlPackage {
    pname = "Math-Fibonacci";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Math-Fibonacci-1.5.tar.gz";
      sha256 = "70a8286e94558df99dc92f52d83e1e20a7b8f7852bcc3a1de7d9e338260b99ba";
    };
    meta = {
      description = "This module provides a few functions related to Fibonacci numbers";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MathGMP = buildPerlPackage {
    pname = "Math-GMP";
    version = "2.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Math-GMP-2.20.tar.gz";
      sha256 = "0psmpj3j8cw02b5bzb7qnkd4rcpxm82891rwpdi2hx2jxy0mznhn";
    };
    buildInputs = [ pkgs.gmp AlienGMP ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    meta = {
      description = "High speed arbitrary size integer math";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  MathGMPz = buildPerlPackage {
    pname = "Math-GMPz";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SISYPHUS/Math-GMPz-0.48.tar.gz";
      sha256 = "f4459ed32fb9bb793e2504fd442c515fd468a4a34d2a1f98e46ca41e275c73cb";
    };
    buildInputs = [ pkgs.gmp ];
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    meta = {
      description = "Perl interface to the GMP integer functions";
      homepage = "https://github.com/sisyphus/math-gmpz";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  MathGeometryVoronoi = buildPerlPackage {
    pname = "Math-Geometry-Voronoi";
    version = "1.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/Math-Geometry-Voronoi-1.3.tar.gz";
      sha256 = "0b206k2q5cznld45cjhgm0as0clc9hk135ds8qafbkl3k175w1vj";
    };
    propagatedBuildInputs = [ ClassAccessor ParamsValidate ];
  };

  MathInt128 = buildPerlPackage {
    pname = "Math-Int128";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Math-Int128-0.22.tar.gz";
      sha256 = "1g0ra7ldv4fz3kqqg45dlrfavi2abfmlhf0py5ank1jk2x0clc56";
    };
    propagatedBuildInputs = [ MathInt64 ];
    meta = {
      description = "Manipulate 128 bits integers in Perl";
      homepage = "http://metacpan.org/release/Math-Int128";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.is32bit; # compiler doesn't support a 128-bit integer type
    };
  };

  MathInt64 = buildPerlPackage {
    pname = "Math-Int64";
    version = "0.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Math-Int64-0.54.tar.gz";
      sha256 = "0lfkc0cry65lnsi28gjyz2kvdkanbhhpc0pyrswsczj3k3k53z6w";
    };
    meta = {
      description = "Manipulate 64 bits integers in Perl";
      homepage = "http://metacpan.org/release/Math-Int64";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathPari = buildPerlPackage rec {
    pname = "Math-Pari";
    version = "2.030518";
    nativeBuildInputs = [ pkgs.unzip ];
    pariversion = "2.1.7";
    pari_tgz = fetchurl {
      url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.1/pari-${pariversion}.tgz";
      sha256 = "1yjml5z1qdn258qh6329v7vib2gyx6q2np0s5ybci0rhmz6z4hli";
    };
    # Workaround build failure on -fno-common toolchains:
    #   ld: libPARI/libPARI.a(compat.o):(.bss+0x8): multiple definition of
    #   `overflow'; Pari.o:(.bss+0x80): first defined here
    NIX_CFLAGS_COMPILE = "-fcommon";
    preConfigure = "cp ${pari_tgz} pari-${pariversion}.tgz";
    makeMakerFlags = "pari_tgz=pari-${pariversion}.tgz";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILYAZ/modules/Math-Pari-2.030518.zip";
      sha256 = "dc38955a9690be6bafa8de2526212377c3ec9fe8da5ec02263a9caf94b58bb91";
    };
    meta = {
      description = "Perl interface to PARI";
      license = with lib.licenses; [ artistic1 gpl1Plus gpl2 ];
    };
  };

  MathPlanePath = buildPerlPackage {
    pname = "Math-PlanePath";
    version = "129";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/Math-PlanePath-129.tar.gz";
      sha256 = "0zirgq9n422wc1j95pijkr88wwmzhll5nxh3sb2vcxsh9l75v8cd";
    };
    propagatedBuildInputs = [ MathLibm constant-defer ];
    buildInputs = [ DataFloat MathBigIntLite NumberFraction ];
  };

  MathPrimeUtil = buildPerlPackage {
    pname = "Math-Prime-Util";
    version = "0.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Math-Prime-Util-0.73.tar.gz";
      sha256 = "4afa6dd8cdb97499bd4eca6925861812c29d9f5a0f1ac27ad9d2d9c9b5602894";
    };
    propagatedBuildInputs = [ MathPrimeUtilGMP ];
    buildInputs = [ TestWarn ];
    meta = {
      description = "Utilities related to prime numbers, including fast sieves and factoring";
      homepage = "https://github.com/danaj/Math-Prime-Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MathPrimeUtilGMP = buildPerlPackage {
    pname = "Math-Prime-Util-GMP";
    version = "0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Math-Prime-Util-GMP-0.52.tar.gz";
      sha256 = "2697c7fd5c7e35fdec7f50ed56a67be807a2f22657589e637dad3592744003be";
    };
    buildInputs = [ pkgs.gmp ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    meta = {
      description = "Utilities related to prime numbers, using GMP";
      homepage = "https://github.com/danaj/Math-Prime-Util-GMP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MathProvablePrime = buildPerlPackage {
    pname = "Math-ProvablePrime";
    version = "0.045";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Math-ProvablePrime-0.045.tar.gz";
      sha256 = "32dce42861ce065a875a91ec14c6557e89af07df10cc450d1c4ded13dcbe3dd5";
    };
    buildInputs = [ FileWhich TestClass TestDeep TestException TestNoWarnings ];
    propagatedBuildInputs = [ BytesRandomSecureTiny ];
    meta = {
      description = "Generate a provable prime number, in pure Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MathRandom = buildPerlPackage {
    pname = "Math-Random";
    version = "0.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GROMMEL/Math-Random-0.72.tar.gz";
      sha256 = "0k15pk2qx9wrp5xqzhymm1ph4nb314ysrsyr0pjnvn8ii0r241dy";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  MathRandomISAAC = buildPerlPackage {
    pname = "Math-Random-ISAAC";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz";
      sha256 = "0z1b3xbb3xz71h25fg6jgsccra7migq7s0vawx2rfzi0pwpz0wr7";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Perl interface to the ISAAC PRNG algorithm";
      homepage = "http://search.cpan.org/dist/Math-Random-ISAAC";
      license = with lib.licenses; [ publicDomain mit artistic2 gpl3 ];
    };
  };

  MathRandomMTAuto = buildPerlPackage {
    pname = "Math-Random-MT-Auto";
    version = "6.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.23.tar.gz";
      sha256 = "04v3fxbqg6bs7dpljw64v62jqb10l2xdrln4l3slz5k266nvbg2q";
    };
    propagatedBuildInputs = [ ObjectInsideOut ];
    meta = {
      description = "Auto-seeded Mersenne Twister PRNGs";
      license = with lib.licenses; [ free ];
    };
  };

  MathRandomSecure = buildPerlPackage {
    pname = "Math-Random-Secure";
    version = "0.080001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/Math-Random-Secure-0.080001.tar.gz";
      sha256 = "0dgbf4ncll4kmgkyb9fsaxn0vf2smc9dmwqzgh3259zc2zla995z";
    };
    buildInputs = [ ListMoreUtils TestSharedFork TestWarn ];
    propagatedBuildInputs = [ CryptRandomSource MathRandomISAAC ];
    meta = {
      description = "Cryptographically-secure, cross-platform replacement for rand()";
      homepage = "https://github.com/frioux/Math-Random-Secure";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MathRound = buildPerlPackage {
    pname = "Math-Round";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GROMMEL/Math-Round-0.07.tar.gz";
      sha256 = "09wkvqj4hfq9y0fimri967rmhnq90dc2wf20lhlmqjp5hsd359vk";
    };
  };

  MathVecStat = buildPerlPackage {
    pname = "Math-VecStat";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASPINELLI/Math-VecStat-0.08.tar.gz";
      sha256 = "03bdcl9pn2bc9b50c50nhnr7m9wafylnb3v21zlch98h9c78x6j0";
    };
  };

  MaxMindDBCommon = buildPerlPackage {
    pname = "MaxMind-DB-Common";
    version = "0.040001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Common-0.040001.tar.gz";
      sha256 = "1mqvnabskhyvi2f10f602gisfk39ws51ky55lixd0033sd5xzikb";
    };
    propagatedBuildInputs = [ DataDumperConcise DateTime ListAllUtils MooXStrictConstructor ];
    meta = {
      description = "Code shared by the MaxMind DB reader and writer modules";
      homepage = "http://metacpan.org/release/MaxMind-DB-Common";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MaxMindDBReader = buildPerlPackage {
    pname = "MaxMind-DB-Reader";
    version = "1.000014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Reader-1.000014.tar.gz";
      sha256 = "1a9rrvarw3q6378w3sqv632w36a9bsh0r90yfa49lzwnkj7hf81q";
    };
    propagatedBuildInputs = [ DataIEEE754 DataPrinter DataValidateIP MaxMindDBCommon ];
    buildInputs = [ PathClass TestBits TestFatal TestNumberDelta TestRequires ];
    meta = {
      description = "Read MaxMind DB files and look up IP addresses";
      homepage = "http://metacpan.org/release/MaxMind-DB-Reader";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MaxMindDBReaderXS = buildPerlModule {
    pname = "MaxMind-DB-Reader-XS";
    version = "1.000008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Reader-XS-1.000008.tar.gz";
      sha256 = "11y71m77y38mi68gw5dqx54z9syvax42x3m9v7mgx35c5z4gpal4";
    };
    propagatedBuildInputs = [ pkgs.libmaxminddb MathInt128 MaxMindDBReader ];
    buildInputs = [ NetWorks PathClass TestFatal TestNumberDelta TestRequires ];
    meta = {
      description = "Fast XS implementation of MaxMind DB reader";
      homepage = "http://metacpan.org/release/MaxMind-DB-Reader-XS";
      license = with lib.licenses; [ artistic2 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.MaxMindDBReaderXS.x86_64-darwin
    };
  };

  MaxMindDBWriter = buildPerlModule {
    pname = "MaxMind-DB-Writer";
    version = "0.300003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Writer-0.300003.tar.gz";
      sha256 = "0gpbrlmxjl45k0wg5v9ghw415hd0fns9fk8ncxzlfyjzjsxgalxs";
    };
    propagatedBuildInputs = [ DigestSHA1 MaxMindDBReader MooseXParamsValidate MooseXStrictConstructor NetWorks SerealDecoder SerealEncoder ];
    buildInputs = [ DevelRefcount JSON TestBits TestDeep TestFatal TestHexDifferences TestRequires TestWarnings ];
    hardeningDisable = [ "format" ];
    meta = {
      description = "Create MaxMind DB database files";
      homepage = "http://metacpan.org/release/MaxMind-DB-Writer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.MaxMindDBWriter.x86_64-darwin
    };
  };

  Memoize = buildPerlPackage {
    pname = "Memoize";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJD/Memoize-1.03.tgz";
      sha256 = "5239cc5f644a50b0de9ffeaa51fa9991eb06ecb1bf4678873e3ab89af9c0daf3";
    };
  };

  MemoizeExpireLRU = buildPerlPackage {
    pname = "Memoize-ExpireLRU";
    version = "0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Memoize-ExpireLRU-0.56.tar.gz";
      sha256 = "1xnp3jqabl4il5kfadlqimbxhzsbm7gpwrgw0m5s5fdsrc0n70zf";
    };
    meta = {
      description = "Expiry plug-in for Memoize that adds LRU cache expiration";
      homepage = "https://github.com/neilb/Memoize-ExpireLRU";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Menlo = buildPerlPackage {
    pname = "Menlo";
    version = "1.9019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Menlo-1.9019.tar.gz";
      sha256 = "3b573f68e7b3a36a87c860be258599330fac248b518854dfb5657ac483dca565";
    };
    propagatedBuildInputs = [ CPANCommonIndex CPANMetaCheck CaptureTiny ExtUtilsHelpers ExtUtilsInstallPaths Filepushd HTTPTinyish ModuleCPANfile ParsePMFile StringShellQuote Win32ShellQuote locallib ];
    meta = {
      description = "A CPAN client";
      homepage = "https://github.com/miyagawa/cpanminus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MenloLegacy = buildPerlPackage {
    pname = "Menlo-Legacy";
    version = "1.9022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Menlo-Legacy-1.9022.tar.gz";
      sha256 = "a6acac3fee318a804b439de54acbc7c27f0b44cfdad8551bbc9cd45986abc201";
    };
    propagatedBuildInputs = [ Menlo ];
    meta = {
      description = "Legacy internal and client support for Menlo";
      homepage = "https://github.com/miyagawa/cpanminus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MetaBuilder = buildPerlModule {
    pname = "Meta-Builder";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Meta-Builder-0.004.tar.gz";
      sha256 = "acb499aa7206eb9db21eb85357a74521bfe3bdae4a6416d50a7c75b939cf56fe";
    };
    buildInputs = [ FennecLite TestException ];
    meta = {
      description = "Tools for creating Meta objects to track custom metrics";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MetaCPANClient = buildPerlPackage {
    pname = "MetaCPAN-Client";
    version = "2.029000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MICKEY/MetaCPAN-Client-2.029000.tar.gz";
      sha256 = "0z75qzrr6r9ijp469majavq8la2jbgn1dq02vdm5m6ip7f887n65";
    };

    # Most tests are online, so we only include offline tests
    postPatch = ''
      substituteInPlace Makefile.PL \
        --replace '"t/*.t t/api/*.t"' \
        '"t/00-report-prereqs.t t/api/_get.t t/api/_get_or_search.t t/api/_search.t t/entity.t t/request.t t/resultset.t"'
    '';

    buildInputs = [ LWPProtocolHttps TestFatal TestNeeds ];
    propagatedBuildInputs = [ IOSocketSSL JSONMaybeXS Moo RefUtil SafeIsa TypeTiny URI ];
    meta = {
      description = "A comprehensive, DWIM-featured client to the MetaCPAN API";
      homepage = "https://github.com/metacpan/metacpan-client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  MethodSignaturesSimple = buildPerlPackage {
    pname = "Method-Signatures-Simple";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHESA/Method-Signatures-Simple-1.07.tar.gz";
      sha256 = "1p6sf6iyyn73pc89mfr65bzxvbw1ibcsp4j10iv8ik3p353pvkf8";
    };
    propagatedBuildInputs = [ DevelDeclare ];
    meta = {
      description = "Basic method declarations with signatures, without source filters";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MetricsAny = buildPerlModule {
    pname = "Metrics-Any";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Metrics-Any-0.06.tar.gz";
      sha256 = "0dwqzd40f6isb2sxn7lymsp0ism7s4xwfhb2ilavnxx2x3w9sllw";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Abstract collection of monitoring metrics";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  # TODO: use CPAN version
  MHonArc = buildPerlPackage rec {
    pname = "MHonArc";
    version = "2.6.19";

    src = fetchurl {
      url = "https://www.mhonarc.org/release/MHonArc/tar/MHonArc-${version}.tar.gz";
      sha256 = "0ll3v93yji334zqp6xfzfxc0127pmjcznmai1l5q6dzawrs2igzq";
    };

    patches = [ ../development/perl-modules/mhonarc.patch ];

    outputs = [ "out" "dev" ]; # no "devdoc"

    installTargets = [ "install" ];

    meta = with lib; {
      homepage = "https://www.mhonarc.org/";
      description = "A mail-to-HTML converter";
      mainProgram = "mhonarc";
      license = licenses.gpl2;
    };
  };

  MIMECharset = buildPerlPackage {
    pname = "MIME-Charset";
    version = "1.012.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-Charset-1.012.2.tar.gz";
      sha256 = "878c779c0256c591666bd06c0cde4c0d7820eeeb98fd1183082aee9a1e7b1d13";
    };
    meta = {
      description = "Charset Information for MIME";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mimeConstruct = buildPerlPackage {
    pname = "mime-construct";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/mime-construct-1.11.tar.gz";
      sha256 = "00wk9950i9q6qwp1vdq9xdddgk54lqd0bhcq2hnijh8xnmhvpmsc";
    };
    outputs = [ "out" ];
    buildInputs = [ ProcWaitStat ];
    meta = {
      description = "Construct and optionally mail MIME messages";
      license = lib.licenses.gpl2Plus;
    };
  };

  MIMEEncWords = buildPerlPackage {
    pname = "MIME-EncWords";
    version = "1.014.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-EncWords-1.014.3.tar.gz";
      sha256 = "e9afb548611d4e7e6c50b7f06bbd2b1bb2808e37a810deefb537c67af5485238";
    };
    propagatedBuildInputs = [ MIMECharset ];
    meta = {
      description = "Deal with RFC 2047 encoded words (improved)";
      homepage = "https://metacpan.org/pod/MIME::EncWords";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MIMELite = buildPerlPackage {
    pname = "MIME-Lite";
    version = "3.031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MIME-Lite-3.031.tar.gz";
      sha256 = "f1235866482b67f00858b3edaa4ff4cf909ef900f1d15d889948bf9c03a591e0";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      description = "Low-calorie MIME generator (DEPRECATED)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMELiteHTML = buildPerlPackage {
    pname = "MIME-Lite-HTML";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALIAN/MIME-Lite-HTML-1.24.tar.gz";
      sha256 = "db603ccbf6653bcd28cfa824d72e511ead019fc8afb9f1854ec872db2d3cd8da";
    };
    doCheck = false;
    propagatedBuildInputs = [ LWP MIMELite ];
    meta = {
      description = "Provide routine to transform a HTML page in a MIME-Lite mail";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMETools = buildPerlPackage {
    pname = "MIME-tools";
    version = "5.509";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSKOLL/MIME-tools-5.509.tar.gz";
      sha256 = "0wv9rzx5j1wjm01c3dg48qk9wlbm6iyf91j536idk09xj869ymv4";
    };
    propagatedBuildInputs = [ MailTools ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "Tools to manipulate MIME messages";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MIMETypes = buildPerlPackage {
    pname = "MIME-Types";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-2.18.tar.gz";
      sha256 = "1glml03gyj5xkadn3vcxzm06bvi343j1jg6ksz69is9a3yj3bjii";
    };
    meta = {
      description = "Definition of MIME types";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Minion = buildPerlPackage {
    pname = "Minion";
    version = "10.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Minion-10.25.tar.gz";
      sha256 = "sha256-C+CoN1N2iJ2gRgRpY4TAz5iyYh0mUNnrAwf25LlAra0=";
    };
    propagatedBuildInputs = [ Mojolicious YAMLLibYAML ];
    meta = {
      description = "A high performance job queue for Perl";
      homepage = "https://github.com/mojolicious/minion";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MinionBackendSQLite = buildPerlModule {
    pname = "Minion-Backend-SQLite";
    version = "5.0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Minion-Backend-SQLite-v5.0.6.tar.gz";
      sha256 = "sha256-/uDUEe9WsAkru8BTN5InaH3hQZUoy2t0T3U9vcH7FNk=";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ Minion MojoSQLite ];
    meta = {
      description = "SQLite backend for Minion job queue";
      homepage = "https://github.com/Grinnz/Minion-Backend-SQLite";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MinionBackendmysql = buildPerlPackage {
    pname = "Minion-Backend-mysql";
    version = "1.000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/Minion-Backend-mysql-1.000.tar.gz";
      sha256 = "sha256-cGS+CHHxmbSwTl1yQprfNbLkr2qHGorM0Mm1wqP9E00=";
    };
    buildInputs = [ Testmysqld ];
    propagatedBuildInputs = [ Minion Mojomysql ];
    meta = {
      description = "MySQL backend for the Minion job queue";
      homepage = "https://github.com/preaction/Minion-Backend-mysql";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MixinLinewise = buildPerlPackage {
    pname = "Mixin-Linewise";
    version = "0.108";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Mixin-Linewise-0.108.tar.gz";
      sha256 = "7df20678474c0973930a472b0c55e3f8e85b7790b68ab18ef618f9c453c8aef2";
    };
    propagatedBuildInputs = [ PerlIOutf8_strict SubExporter ];
    meta = {
      description = "Write your linewise code for handles; this does the rest";
      homepage = "https://github.com/rjbs/Mixin-Linewise";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MLDBM = buildPerlModule {
    pname = "MLDBM";
    version = "2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/MLDBM-2.05.tar.gz";
      sha256 = "586880ed0c20801abbf6734747e13e0203edefece6ebc4f20ddb5059f02a17a2";
    };
    meta = {
      description = "Store multi-level Perl hash structure in single level tied hash";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MNI-Perllib = callPackage ../development/perl-modules/MNI {};

  Mo = buildPerlPackage {
    pname = "Mo";
    version = "0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/Mo-0.40.tar.gz";
      sha256 = "1fff81awg9agfawf3wxx0gpf6vgav8w920rmxsbjg30z75943lli";
    };
    meta = {
      description = "Micro Objects. Mo is less";
      homepage = "https://github.com/ingydotnet/mo-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mo-inline";
    };
  };

  MockConfig = buildPerlPackage {
    pname = "Mock-Config";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Mock-Config-0.03.tar.gz";
      sha256 = "06q0xkg5cwdwafzmb9rkaa305ddv7vli9gpm6n9jnkyaaxbk9f55";
    };
    meta = {
      description = "Temporarily set Config or XSConfig values";
      license = with lib.licenses; [ artistic1 gpl1Plusartistic1 gpl1Plus  artistic2 ];
    };
  };

  ModernPerl = buildPerlPackage {
    pname = "Modern-Perl";
    version = "1.20200211";

    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20200211.tar.gz";
      sha256 = "da1c83cee84fab9edb9e31d7f7abac43e1337b2e66015191ec4b6da59298c480";
    };
    meta = {
      description = "Enable all of the features of Modern Perl with one import";
      homepage = "https://github.com/chromatic/Modern-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Modulecpmfile = buildPerlModule {
    pname = "Module-cpmfile";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Module-cpmfile-0.002.tar.gz";
      sha256 = "18dxc5wgds1way0dvd6dx5rhc2siyaa38nhpy4gb5v7ldnj3yjc8";
    };
    buildInputs = [ ModuleBuildTiny ModuleCPANfile Test2Suite ];
    propagatedBuildInputs = [ YAMLPP ];
    meta = {
      description = "Parse cpmfile";
      homepage = "https://github.com/skaji/cpmfile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  ModuleBuild = buildPerlPackage {
    pname = "Module-Build";
    version = "0.4231";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz";
      sha256 = "05xpn8qg814y49vrih16zfr9iiwb7pmdf57ahjnc2h0p5illq3vy";
    };
    meta = {
      description = "Build and install Perl modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "config_data";
    };
  };

  ModuleBuildDeprecated = buildPerlModule {
    pname = "Module-Build-Deprecated";
    version = "0.4210";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Deprecated-0.4210.tar.gz";
      sha256 = "be089313fc238ee2183473aca8c86b55fb3cf44797312cbe9b892d6362621703";
    };
    doCheck = false;
    meta = {
      description = "A collection of modules removed from Module-Build";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggable = buildPerlModule {
    pname = "Module-Build-Pluggable";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Module-Build-Pluggable-0.10.tar.gz";
      sha256 = "e5bb2acb117792c984628812acb0fec376cb970caee8ede57535e04d762b0e40";
    };
    propagatedBuildInputs = [ ClassAccessorLite ClassMethodModifiers DataOptList ];
    buildInputs = [ TestSharedFork ];
    meta = {
      description = "Module::Build meets plugins";
      homepage = "https://github.com/tokuhirom/Module-Build-Pluggable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggableCPANfile = buildPerlModule {
    pname = "Module-Build-Pluggable-CPANfile";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Module-Build-Pluggable-CPANfile-0.05.tar.gz";
      sha256 = "4aec6cba240cb6e78016406b6a3a875634cc2aec08ffc5f1572da1cdc40e1e7c";
    };
    buildInputs = [ CaptureTiny TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ModuleBuildPluggable ModuleCPANfile ];
    meta = {
      description = "Include cpanfile";
      homepage = "https://github.com/kazeburo/Module-Build-Pluggable-CPANfile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildPluggablePPPort = buildPerlModule {
    pname = "Module-Build-Pluggable-PPPort";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Module-Build-Pluggable-PPPort-0.04.tar.gz";
      sha256 = "44084ba3d8815f343bd391585ac5d8339a4807ce5c0dd84c98db8f310b64c0ea";
    };
    buildInputs = [ TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ModuleBuildPluggable ];
    meta = {
      description = "Generate ppport.h";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildTiny = buildPerlModule {
    pname = "Module-Build-Tiny";
    version = "0.039";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz";
      sha256 = "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c";
    };
    buildInputs = [ FileShareDir ];
    propagatedBuildInputs = [ ExtUtilsHelpers ExtUtilsInstallPaths ];
    meta = {
      description = "A tiny replacement for Module::Build";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildWithXSpp = buildPerlModule {
    pname = "Module-Build-WithXSpp";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Module-Build-WithXSpp-0.14.tar.gz";
      sha256 = "0d39fjg9c0n820bk3fb50vvlwhdny4hdl69xmlyzql5xzp4cicsk";
    };
    propagatedBuildInputs = [ ExtUtilsCppGuess ExtUtilsXSpp ];
  };

  ModuleBuildXSUtil = buildPerlModule {
    pname = "Module-Build-XSUtil";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/Module-Build-XSUtil-0.19.tar.gz";
      sha256 = "004ly9xxjlsbrr2vhxsa1n84z3034gxrzr7z0wl45szd8v1v6qwh";
    };
    buildInputs = [ CaptureTiny CwdGuard FileCopyRecursiveReduced ];
    propagatedBuildInputs = [ DevelCheckCompiler ];
    perlPreHook = "export LD=$CC";
    meta = {
      description = "A Module::Build class for building XS modules";
      homepage = "https://github.com/hideo55/Module-Build-XSUtil";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleCompile = buildPerlPackage rec {
    pname = "Module-Compile";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Module-Compile-0.38.tar.gz";
      sha256 = "8090cfbb61123437eefec3e3bed86005d1f7c5a529fb6fda2ebebc6564b9aa10";
    };
    propagatedBuildInputs = [ CaptureTiny DigestSHA1 ];
    meta = {
      description = "Perl Module Compilation";
      homepage = "https://github.com/ingydotnet/module-compile-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleCPANTSAnalyse = buildPerlPackage {
    pname = "Module-CPANTS-Analyse";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Module-CPANTS-Analyse-1.01.tar.gz";
      sha256 = "0jf83v9ylw7s9i2zv0l1v11gafp3k4389asc52r6s6q5s2j0p6dx";
    };
    propagatedBuildInputs = [ ArchiveAnyLite ArrayDiff DataBinary FileFindObject PerlPrereqScannerNotQuiteLite SoftwareLicense ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestFailWarnings ];
    meta = {
      description = "Generate Kwalitee ratings for a distribution";
      homepage = "https://cpants.cpanauthors.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleCPANfile = buildPerlPackage {
    pname = "Module-CPANfile";
    version = "1.1004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Module-CPANfile-1.1004.tar.gz";
      sha256 = "08a9a5mybf0llwlfvk7n0q7az6lrrzgzwc3432mcwbb4k8pbxvw8";
    };
    buildInputs = [ Filepushd ];
    meta = {
      description = "Parse cpanfile";
      homepage = "https://github.com/miyagawa/cpanfile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleExtractUse = buildPerlModule {
    pname = "Module-ExtractUse";
    version = "0.343";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOMM/Module-ExtractUse-0.343.tar.gz";
      sha256 = "00hcggwnqk953s4zbvkcabd5mfidg60hawlqsw6146in91dlclj8";
    };
    propagatedBuildInputs = [ ParseRecDescent PodStrip ];
    buildInputs = [ TestDeep TestNoWarnings ];
    meta = {
      description = "Find out what modules are used";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleFind = buildPerlPackage {
    pname = "Module-Find";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.15.tar.gz";
      sha256 = "0pm8v398rv4sy7sn7zzfbq4szxw6p1q4963ancsi17iyzskq4m2w";
    };
    meta = {
      description = "Find and use installed modules in a (sub)category";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleImplementation = buildPerlPackage {
    pname = "Module-Implementation";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz";
      sha256 = "0vfngw4dbryihqhi7g9ks360hyw8wnpy3hpkzyg0q4y2y091lpy1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      description = "Loads one of several alternate underlying implementations for a module";
      homepage = "http://metacpan.org/release/Module-Implementation";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ModuleInfo = buildPerlPackage {
    pname = "Module-Info";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Module-Info-0.37.tar.gz";
      sha256 = "0j143hqxgdkdpj5qssppq72gjr0n73c4f7is6wgrrcchjx905a4f";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ BUtils ];
    meta = {
      description = "Information about Perl modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "module_info";
    };
  };

  ModuleInstall = buildPerlPackage {
    pname = "Module-Install";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Install-1.19.tar.gz";
      sha256 = "06q12cm97yh4p7qbm0a2p96996ii6ss59qy57z0f7f9svy6sflqs";
    };
    propagatedBuildInputs = [ FileRemove ModuleBuild ModuleScanDeps YAMLTiny ];
    meta = {
      description = "Standalone, extensible Perl module installer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstallAuthorRequires = buildPerlPackage {
    pname = "Module-Install-AuthorRequires";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Module-Install-AuthorRequires-0.02.tar.gz";
      sha256 = "1v2ciw75dj5y8lh10d1vrhwmjx266gpqavr8m21jlpblgm9j2qyc";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Declare author-only dependencies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstallAuthorTests = buildPerlPackage {
    pname = "Module-Install-AuthorTests";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Module-Install-AuthorTests-0.002.tar.gz";
      sha256 = "121dyggy38316xss06v1zkwx4b59gl7b00c5q99xyzimwqnp49a0";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Designate tests only run by module authors";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstallGithubMeta = buildPerlPackage {
    pname = "Module-Install-GithubMeta";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Module-Install-GithubMeta-0.30.tar.gz";
      sha256 = "2ead44c973c748d72d9f199e41c44dc1801fe9ae06b0fadc59447693a3c98281";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "A Module::Install extension to include GitHub meta information in META.yml";
      homepage = "https://github.com/bingos/module-install-githubmeta";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ModuleInstallReadmeFromPod = buildPerlPackage {
    pname = "Module-Install-ReadmeFromPod";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Module-Install-ReadmeFromPod-0.30.tar.gz";
      sha256 = "79f6df5536619faffbda696bdd25ccad17c469bf32e51cd3e613366d49400169";
    };
    buildInputs = [ TestInDistDir ];
    propagatedBuildInputs = [ CaptureTiny IOAll ModuleInstall PodMarkdown ];
    meta = {
      description = "A Module::Install extension to automatically convert POD to a README";
      homepage = "https://github.com/bingos/module-install-readmefrompod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ModuleInstallReadmeMarkdownFromPod = buildPerlPackage {
    pname = "Module-Install-ReadmeMarkdownFromPod";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/Module-Install-ReadmeMarkdownFromPod-0.04.tar.gz";
      sha256 = "300b2e244f83b9a54a95f8404c1cd3af0635b4fae974ca65390ee428ec668591";
    };
    buildInputs = [ URI ];
    propagatedBuildInputs = [ ModuleInstall PodMarkdown ];
    meta = {
      description = "Create README.mkdn from POD";
      homepage = "http://search.cpan.org/dist/Module-Install-ReadmeMarkdownFromPod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ModuleInstallRepository = buildPerlPackage {
    pname = "Module-Install-Repository";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Module-Install-Repository-0.06.tar.gz";
      sha256 = "00e2590d09339ccccbdaa328d12ad8ec77e831a38c9ad663705e59ecbb18722b";
    };
    buildInputs = [ PathClass ];
    meta = {
      description = "Automatically sets repository URL from svn/svk/Git checkout";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ModuleInstallXSUtil = buildPerlPackage {
    pname = "Module-Install-XSUtil";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/Module-Install-XSUtil-0.45.tar.gz";
      sha256 = "fe71e53320bee13197749a0b17609aa263f71ff46e5e2c130e94742ea6abdf56";
    };
    buildInputs = [ BHooksOPAnnotation ];
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Utility functions for XS modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleManifest = buildPerlPackage {
    pname = "Module-Manifest";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Manifest-1.09.tar.gz";
      sha256 = "a395f80ff15ea0e66fd6c453844b6787ed4a875a3cd8df9f7e29280250bd539b";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ ParamsUtil ];
    meta = {
      description = "Parse and examine a Perl distribution MANIFEST file";
      homepage = "https://github.com/karenetheridge/Module-Manifest";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePath = buildPerlPackage {
    pname = "Module-Path";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Module-Path-0.19.tar.gz";
      sha256 = "b33179ce4dd73dfcde7d46808804b9ffbb11db0245fe455a7d001747562feaca";
    };
    buildInputs = [ DevelFindPerl ];
    meta = {
      description = "Get the full path to a locally installed module";
      homepage = "https://github.com/neilbowers/Module-Path";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mpath";
    };
  };

  ModulePluggable = buildPerlPackage {
    pname = "Module-Pluggable";
    version = "5.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz";
      sha256 = "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
    buildInputs = [ AppFatPacker ];
    meta = {
      description = "Automatically give your module the ability to have plugins";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggableFast = buildPerlPackage {
    pname = "Module-Pluggable-Fast";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/Module-Pluggable-Fast-0.19.tar.gz";
      sha256 = "0pq758wlasmh77xyd2xh75m5b2x14s8pnsv63g5356gib1q5gj08";
    };
    propagatedBuildInputs = [ UNIVERSALrequire ];
  };

  ModuleRefresh = buildPerlPackage {
    pname = "Module-Refresh";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Module-Refresh-0.17.tar.gz";
      sha256 = "6b30a6ceddc6512ab4490c16372ecf309a259f2ca147d622e478ac54e08511c3";
    };
    buildInputs = [ PathClass ];
    meta = {
      description = "Refresh %INC files when updated on disk";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntime = buildPerlModule {
    pname = "Module-Runtime";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz";
      sha256 = "097hy2czwkxlppri32m599ph0xfvfsbf0a5y23a4fdc38v32wc38";
    };
    meta = {
      description = "Runtime module handling";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntimeConflicts = buildPerlPackage {
    pname = "Module-Runtime-Conflicts";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.003.tar.gz";
      sha256 = "707cdc75038c70fe91779b888ac050f128565d3967ba96680e1b1c7cc9733875";
    };
    propagatedBuildInputs = [ DistCheckConflicts ];
    meta = {
      description = "Provide information on conflicts for Module::Runtime";
      homepage = "https://github.com/karenetheridge/Module-Runtime-Conflicts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleScanDeps = buildPerlPackage {
    pname = "Module-ScanDeps";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.29.tar.gz";
      sha256 = "0kl8p0006j52vq4bd59fyv7pm3yyv0h7pwaalrkn4brs6n8wxc7f";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Recursively scan Perl code for dependencies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "scandeps.pl";
    };
  };

  ModuleSignature = buildPerlPackage {
    pname = "Module-Signature";
    version = "0.87";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/Module-Signature-0.87.tar.gz";
      sha256 = "214e8055c50fec371a95743520fe26940004e76169063b2b44ec90a0d45d6982";
    };
    buildInputs = [ IPCRun ];
    meta = {
      description = "Module signature file manipulation";
      license = with lib.licenses; [ cc0 ];
      mainProgram = "cpansign";
    };
  };

  ModuleUtil = buildPerlModule {
    pname = "Module-Util";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTLAW/Module-Util-1.09.tar.gz";
      sha256 = "6cfbcb6a45064446ec8aa0ee1a7dddc420b54469303344187aef84d2c7f3e2c6";
    };
    meta = {
      description = "Module name tools and transformations";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pm_which";
    };
  };

  ModuleVersions = buildPerlPackage {
    pname = "Module-Versions";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THW/Module-Versions-0.02.zip";
      sha256 = "0g7qs6vqg91xpwg1cdy91m3kh9m1zbkzyz1qsy453b572xdscf0d";
    };
    buildInputs = [ pkgs.unzip ];
  };

  ModuleVersionsReport = buildPerlPackage {
    pname = "Module-Versions-Report";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Module-Versions-Report-1.06.tar.gz";
      sha256 = "a3261d0d84b17678d8c4fd55eb0f892f5144d81ca53ea9a38d75d1a00ad9796a";
    };
    meta = {
      description = "Report versions of all modules in memory";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MojoDOM58 = buildPerlPackage {
    pname = "Mojo-DOM58";
    version = "2.000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Mojo-DOM58-2.000.tar.gz";
      sha256 = "1wsy0j6jpd06gc1ay6isyzqh5cdc834g5w0amslqcjgvf4snlk46";
    };
    meta = {
      description = "Minimalistic HTML/XML DOM parser with CSS selectors";
      homepage = "https://github.com/Grinnz/Mojo-DOM58";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  mod_perl2 = buildPerlPackage {
    pname = "mod_perl";
    version = "2.0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/mod_perl-2.0.11.tar.gz";
      sha256 = "0x3gq4nz96y202cymgrf56n8spm7bffkd1p74dh9q3zrrlc9wana";
    };

    patches = [
      # Fix build on perl-5.34.0, https://github.com/Perl/perl5/issues/18617
      ../development/perl-modules/mod_perl2-PL_hash_seed.patch
    ];

    makeMakerFlags = "MP_AP_DESTDIR=$out";
    buildInputs = [ pkgs.apacheHttpd ];
    doCheck = false; # would try to start Apache HTTP server
    passthru.tests = nixosTests.mod_perl;
    meta = {
      license = with lib.licenses; [ asl20 ];
      mainProgram = "mp2bug";
    };
  };

  Mojolicious = buildPerlPackage {
    pname = "Mojolicious";
    version = "9.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-9.26.tar.gz";
      sha256 = "sha256-nkKMVRJpjwXhUTONj6Eq7eKHqzpeQp7D04yApKgsjYg=";
    };
    meta = {
      description = "Real-time web framework";
      homepage = "https://mojolicious.org";
      license = with lib.licenses; [ artistic2 ];
      maintainers = with maintainers; [ thoughtpolice sgo ];
      mainProgram = "mojo";
    };
  };

  MojoliciousPluginAssetPack = buildPerlPackage {
    pname = "Mojolicious-Plugin-AssetPack";
    version = "2.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-Plugin-AssetPack-2.13.tar.gz";
      sha256 = "1254yy70c7wv3p64pjyxc2h1p9czs65jm6lzl42qmn1x19i8fggj";
    };
    propagatedBuildInputs = [ FileWhich IPCRun3 Mojolicious ];
    meta = {
      description = "Compress and convert css, less, sass, javascript and coffeescript files";
      homepage = "https://github.com/jhthorsen/mojolicious-plugin-assetpack";
      license = with lib.licenses; [ artistic2 ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  MojoliciousPluginGravatar = buildPerlPackage {
    pname = "Mojolicious-Plugin-Gravatar";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KO/KOORCHIK/Mojolicious-Plugin-Gravatar-0.04.tar.gz";
      sha256 = "a49f970c6c70f9930b304a752163cb95f1d998712f79cb13640832e4b7b675dd";
    };
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "Globally Recognized Avatars for Mojolicious";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  MojoliciousPluginMail = buildPerlModule {
    pname = "Mojolicious-Plugin-Mail";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHARIFULN/Mojolicious-Plugin-Mail-1.5.tar.gz";
      sha256 = "56f0d341ebc3a7acf3919f5add43e98216ea1285aa0d87e7fb00c02bb0eff146";
    };
    propagatedBuildInputs = [ MIMEEncWords MIMELite Mojolicious ];
    meta = {
      description = "Mojolicious Plugin for send mail";
      homepage = "https://github.com/sharifulin/Mojolicious-Plugin-Mail";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoliciousPluginOpenAPI = buildPerlPackage {
    pname = "Mojolicious-Plugin-OpenAPI";
    version = "5.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Mojolicious-Plugin-OpenAPI-5.05.tar.gz";
      sha256 = "sha256-xH+I0c434/YT9uizV9grenEEX/wKSXOVUS67zahlYV0=";
    };
    propagatedBuildInputs = [ JSONValidator ];
    meta = {
      description = "OpenAPI / Swagger plugin for Mojolicious";
      homepage = "https://github.com/jhthorsen/mojolicious-plugin-openapi";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoliciousPluginStatus = buildPerlPackage {
    pname = "Mojolicious-Plugin-Status";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-Plugin-Status-1.17.tar.gz";
      sha256 = "1d475ch43vbfn3h4lsmr3n6rhgxgz670xqj4rcdjd4g1wfpiyasc";
    };
    propagatedBuildInputs = [ BSDResource CpanelJSONXS FileMap Mojolicious Sereal ];
    meta = {
      description = "Mojolicious server status";
      homepage = "https://mojolicious.org";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  MojoliciousPluginSyslog = buildPerlPackage {
    pname = "Mojolicious-Plugin-Syslog";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Mojolicious-Plugin-Syslog-0.06.tar.gz";
      sha256 = "sha256-IuxL9TYwDseyAYuoV3C9g2ZFDBAwVDZ9srFp9Mh3QRM=";
    };
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "A plugin for enabling a Mojolicious app to log to syslog";
      homepage = "https://github.com/jhthorsen/mojolicious-plugin-syslog";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoliciousPluginTextExceptions = buildPerlPackage {
    pname = "Mojolicious-Plugin-TextExceptions";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/Mojolicious-Plugin-TextExceptions-0.02.tar.gz";
      sha256 = "0x7qkd9nmarzb7kvk4dvhka4s44mfcd026zz3ikfwk3qql2p86rs";
    };
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "Render exceptions as text in command line user agents";
      homepage = "https://github.com/marcusramberg/mojolicious-plugin-textexceptions";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoliciousPluginWebpack = buildPerlPackage {
    pname = "Mojolicious-Plugin-Webpack";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Mojolicious-Plugin-Webpack-1.01.tar.gz";
      sha256 = "1w6dr7yb8lvvx5z2xsmshp2cf4b7dynv05yhq0rk7zwif5v6gsvm";
    };
    propagatedBuildInputs = [ Mojolicious Filechdir ];
    meta = {
      description = "Mojolicious <3 Webpack";
      homepage = "https://github.com/jhthorsen/mojolicious-plugin-webpack";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoRedis = buildPerlPackage {
    pname = "Mojo-Redis";
    version = "3.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Mojo-Redis-3.29.tar.gz";
      sha256 = "sha256-oDMZpF0uYTpsfS1ZrAD9SwtHiGVi5ish3pG0r4llgII=";
    };
    propagatedBuildInputs = [ Mojolicious ProtocolRedisFaster ];
    meta = {
      description = "Redis driver based on Mojo::IOLoop";
      homepage = "https://github.com/jhthorsen/mojo-redis";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoSAML = buildPerlModule {
    pname = "Mojo-SAML";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/Mojo-SAML-0.07.tar.gz";
      sha256 = "03biykpz281z9nmd846jlxwzbaqlqwvh987aw9spl7bgvfn4rhkj";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CryptOpenSSLRSA CryptOpenSSLX509 DataGUID Mojolicious XMLCanonicalizeXML ];
    meta = {
      description = "A SAML2 toolkit using the Mojo toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoSQLite = buildPerlModule {
    pname = "Mojo-SQLite";
    version = "3.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Mojo-SQLite-3.005.tar.gz";
      sha256 = "0appzyhr5adzdfxns31lj568hz18bkmxmcv7fpafrx67b98cpza1";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ DBDSQLite Mojolicious SQLAbstract URIdb ];
    meta = {
      description = "A tiny Mojolicious wrapper for SQLite";
      homepage = "https://github.com/Grinnz/Mojo-SQLite";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  Mojomysql = buildPerlPackage rec {
    pname = "Mojo-mysql";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/Mojo-mysql-1.25.tar.gz";
      sha256 = "sha256-YC14GXw0HdCPLLH1XZg31P3gFHQz1k2+vxloaAtVzMs=";
    };
    propagatedBuildInputs = [ DBDmysql Mojolicious SQLAbstract ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "Mojolicious and Async MySQL/MariaDB";
      homepage = "https://github.com/jhthorsen/mojo-mysql";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoIOLoopDelay = buildPerlModule {
    pname = "Mojo-IOLoop-Delay";
    version = "8.76";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/Mojo-IOLoop-Delay-8.76.tar.gz";
      sha256 = "1vd9s1r82wfxh8y1g2ninsyvzkawx7n6ncll8lhdj89p91hw1jwf";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "(DISCOURAGED) Promises/A+ and flow-control helpers";
      homepage = "https://github.com/jberger/Mojo-IOLoop-Delay";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.zakame ];
    };
  };

  MojoIOLoopForkCall = buildPerlModule {
    pname = "Mojo-IOLoop-ForkCall";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/Mojo-IOLoop-ForkCall-0.21.tar.gz";
      sha256 = "sha256-8dpdh4RxvdhvAcQjhQgAgE9ttCtUU8IW8Jslt5RYS3g=";
    };
    propagatedBuildInputs = [ IOPipely Mojolicious MojoIOLoopDelay ];
    preBuild = ''
      # This module needs the deprecated Mojo::IOLoop::Delay
      substituteInPlace lib/Mojo/IOLoop/ForkCall.pm \
        --replace "use Mojo::IOLoop;" "use Mojo::IOLoop; use Mojo::IOLoop::Delay;"
    '';
    meta = {
      description = "(DEPRECATED) run blocking functions asynchronously by forking";
      homepage = "https://github.com/jberger/Mojo-IOLoop-ForkCall";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  MojoJWT = buildPerlModule {
    pname = "Mojo-JWT";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/Mojo-JWT-0.09.tar.gz";
      sha256 = "11jqm2sbgf5nikkb0d56xxwrd74757ks53nh8p72nvqc7sc06kn0";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ Mojolicious ];
    meta = {
      description = "JSON Web Token the Mojo way";
      homepage = "https://github.com/jberger/Mojo-JWT";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoPg = buildPerlPackage {
    pname = "Mojo-Pg";
    version = "4.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojo-Pg-4.27.tar.gz";
      sha256 = "sha256-oyLI3wDj5WVf300LernXmSiTIOKfZP6ZrHrxJEhO+dg=";
    };
    propagatedBuildInputs = [ DBDPg Mojolicious SQLAbstractPg ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "Mojolicious ♥ PostgreSQL";
      homepage = "https://mojolicious.org";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MojoUserAgentCached = buildPerlPackage {
    pname = "Mojo-UserAgent-Cached";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NICOMEN/Mojo-UserAgent-Cached-1.19.tar.gz";
      sha256 = "sha256-wlmZ2qqCHkZUhLWjINFVqlJZAMh4Ml2aiSAfSnWBxd8=";
    };
    buildInputs = [ ModuleInstall ];
    propagatedBuildInputs = [ AlgorithmLCSS CHI DataSerializer DevelStackTrace Mojolicious Readonly StringTruncate ];
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Caching, Non-blocking I/O HTTP, Local file and WebSocket user agent";
      homepage = "https://github.com/nicomen/mojo-useragent-cached";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  MongoDB = buildPerlPackage {
    pname = "MongoDB";
    version = "2.2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MONGODB/MongoDB-v2.2.2.tar.gz";
      sha256 = "201935f92dac94f39c35de73661e8b252439e496f228657db85ff93257c3268f";
    };
    buildInputs = [ JSONMaybeXS PathTiny TestDeep TestFatal TimeMoment ];
    propagatedBuildInputs = [ AuthenSASLSASLprep AuthenSCRAM BSON IOSocketSSL NetSSLeay ClassXSAccessor BSONXS TypeTinyXS MozillaCA Moo NetDNS SafeIsa SubQuote TieIxHash TypeTiny UUIDURandom boolean namespaceclean ];
    meta = {
      description = "Official MongoDB Driver for Perl (EOL)";
      homepage = "https://github.com/mongodb-labs/mongo-perl-driver";
      license = with lib.licenses; [ asl20 ];
    };
  };

  MonitoringPlugin = buildPerlPackage {
    pname = "Monitoring-Plugin";
    version = "0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIERLEIN/Monitoring-Plugin-0.40.tar.gz";
      sha256 = "0vr3wwdn3zs246qwi04bqk8jir6l88j5m59jk97hmfyj4xz6pfpq";
    };
    propagatedBuildInputs = [ ClassAccessor ConfigTiny MathCalcUnits ParamsValidate ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPipely = buildPerlPackage {
    pname = "IO-Pipely";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/IO-Pipely-0.005.tar.gz";
      sha256 = "e33b6cf5cb2b46ee308513f51e623987a50a89901e81bf19701dce35179f2e74";
    };
    meta = {
      description = "Portably create pipe() or pipe-like handles, one way or another";
      homepage = "http://search.cpan.org/dist/IO-Pipely";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moo = buildPerlPackage {
    pname = "Moo";
    version = "2.004004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Moo-2.004004.tar.gz";
      sha256 = "0ii2rzzs0wfc697d7v3s76fi1y3kl7p1hvxbv330i1vq2nqpfjvi";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers ModuleRuntime RoleTiny SubQuote ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatibility)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moose = buildPerlPackage {
    pname = "Moose";
    version = "2.2013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Moose-2.2013.tar.gz";
      sha256 = "df74dc78088921178edf72d827017d6c92737c986659f2dadc533ae24675e77c";
    };
    buildInputs = [ CPANMetaCheck TestCleanNamespaces TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoadXS DevelGlobalDestruction DevelOverloadInfo DevelStackTrace EvalClosure ModuleRuntimeConflicts PackageDeprecationManager PackageStashXS SubExporter ];
    preConfigure = ''
      export LD=$CC
    '';
    meta = {
      description = "A postmodern object system for Perl 5";
      homepage = "http://moose.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.eelco ];
      mainProgram = "moose-outdated";
    };
  };

  MooXHandlesVia = buildPerlPackage {
    pname = "MooX-HandlesVia";
    version = "0.001009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/MooX-HandlesVia-0.001009.tar.gz";
      sha256 = "04kcyflg49rclxa1nm035c05jpyvhdacjyy1wklbgv4li3im6qvi";
    };
    buildInputs = [ MooXTypesMooseLike TestException TestFatal ];
    propagatedBuildInputs = [ DataPerl Moo ];
    meta = {
      description = "NativeTrait-like behavior for Moo";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXLocalePassthrough = buildPerlPackage {
    pname = "MooX-Locale-Passthrough";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/MooX-Locale-Passthrough-0.001.tar.gz";
      sha256 = "04h5xhqdvydd4xk9ckb6a79chn0ygf915ix55vg1snmba9z841bs";
    };
    propagatedBuildInputs = [ Moo ];
    meta = {
      description = "Provide API used in translator modules without translating";
      homepage = "https://metacpan.org/release/MooX-Locale-Passthrough";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXLocaleTextDomainOO = buildPerlPackage {
    pname = "MooX-Locale-TextDomain-OO";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/MooX-Locale-TextDomain-OO-0.001.tar.gz";
      sha256 = "0g8pwj45ccqrzvs9cqyhw29nm68vai1vj46ad39rajnqzp7m53jv";
    };
    propagatedBuildInputs = [ LocaleTextDomainOO MooXLocalePassthrough ];
    meta = {
      description = "Provide API used in translator modules without translating";
      homepage = "https://metacpan.org/release/MooX-Locale-TextDomain-OO";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXOptions = buildPerlPackage {
    pname = "MooX-Options";
    version = "4.103";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/MooX-Options-4.103.tar.gz";
      sha256 = "0v9j0wxx4f6z6lrmdqf2k084b2c2f2jbvh86pwib0vgjz1sdbyad";
    };
    propagatedBuildInputs = [ GetoptLongDescriptive MROCompat MooXLocalePassthrough PathClass UnicodeLineBreak strictures ];
    buildInputs = [ Mo MooXCmd MooXLocaleTextDomainOO Moose TestTrap ];
    preCheck = "rm t/16-namespace_clean.t"; # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=942275
    meta = {
      description = "Explicit Options eXtension for Object Class";
      homepage = "https://metacpan.org/celogeek/MooX-Options";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXSingleton = buildPerlModule {
    pname = "MooX-Singleton";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AJ/AJGB/MooX-Singleton-1.20.tar.gz";
      sha256 = "03i1wfag279ldjjkwi9gvpfs8fgi05my47icq5ggi66yzxpn5mzp";
    };
    propagatedBuildInputs = [ RoleTiny ];
    buildInputs = [ Moo ];
    meta = {
      description = "Turn your Moo class into singleton";
      homepage = "http://search.cpan.org/dist/MooX-Singleton";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXStrictConstructor = buildPerlPackage {
    pname = "MooX-StrictConstructor";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HARTZELL/MooX-StrictConstructor-0.011.tar.gz";
      sha256 = "1qjkqrmzgz7lxhv14klsv0v9v6blf8js86d47ah24kpw5y12yf6s";
    };
    propagatedBuildInputs = [ Moo strictures ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Make your Moo-based object constructors blow up on unknown attributes";
      homepage = "https://metacpan.org/release/MooX-StrictConstructor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXTypesMooseLike = buildPerlPackage {
    pname = "MooX-Types-MooseLike";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-0.29.tar.gz";
      sha256 = "1d6jg9x3p7gm2r0xmbcag374a44gf5pcga2swvxhlhzakfm80dqx";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    buildInputs = [ Moo TestFatal ];
  };

  MooXTypesMooseLikeNumeric = buildPerlPackage {
    pname = "MooX-Types-MooseLike-Numeric";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-Numeric-1.03.tar.gz";
      sha256 = "16adeb617b963d010179922c2e4e8762df77c75232e17320b459868c4970c44b";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ MooXTypesMooseLike ];
    meta = {
      description = "Moo types for numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXTypeTiny = buildPerlPackage {
    pname = "MooX-TypeTiny";
    version = "0.002003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/MooX-TypeTiny-0.002003.tar.gz";
      sha256 = "d81e26ff6f8db10261f0087f96dc54367dcb49a9f3de8d53238f834ece19624b";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moo TypeTiny ];
    meta = {
      description = "Tiny, yet Moo(se)-compatible type constraint";
      homepage = "https://typetiny.toby.ink";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseAutobox = buildPerlModule {
    pname = "Moose-Autobox";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Moose-Autobox-0.16.tar.gz";
      sha256 = "0mbhd0p7gf6qdhaylldl0ahq59zghs0vd5n1iqcbfkj8ryj1sh4j";
    };
    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ ListMoreUtils Moose SyntaxKeywordJunction autobox namespaceautoclean ];
    meta = {
      description = "Autoboxed wrappers for Native Perl datatypes";
      homepage = "https://github.com/moose/Moose-Autobox";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXABC = buildPerlPackage {
    pname = "MooseX-ABC";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-ABC-0.06.tar.gz";
      sha256 = "1sky0dpi22wrymmkjmqba4k966zn7vrbpx918wn2nmg48swyrgjf";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Abstract base classes for Moose";
      homepage = "http://metacpan.org/release/MooseX-ABC";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXAliases = buildPerlPackage {
    pname = "MooseX-Aliases";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-Aliases-0.11.tar.gz";
      sha256 = "0j07zqczjfmng3md6nkha7560i786d0cp3gdmrx49hr64jbhz1f4";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAppCmd = buildPerlModule {
    pname = "MooseX-App-Cmd";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-App-Cmd-0.32.tar.gz";
      sha256 = "2e3bbf7283a4bee72d91d26eb204436030992bbe55cbd35ec33a546f16f973ff";
    };
    buildInputs = [ ModuleBuildTiny MooseXConfigFromFile TestOutput YAML ];
    propagatedBuildInputs = [ AppCmd MooseXGetopt MooseXNonMoose ];
    meta = {
      description = "Mashes up MooseX::Getopt and App::Cmd";
      homepage = "https://github.com/moose/MooseX-App-Cmd";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXStorageFormatJSONpm = buildPerlPackage {
    pname = "MooseX-Storage-Format-JSONpm";
    version = "0.093093";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-Storage-Format-JSONpm-0.093093.tar.gz";
      sha256 = "ebe0407a7eb1870270e0e2579f097dfd7df2aea3307fb71f324fb69e242cc58f";
    };
    buildInputs = [ Moose TestDeepJSON TestWithoutModule DigestHMAC MooseXTypes ];
    propagatedBuildInputs = [ JSON MooseXRoleParameterized MooseXStorage namespaceautoclean ];
    meta = {
      description = "A format role for MooseX::Storage using JSON.pm";
      homepage = "https://github.com/rjbs/MooseX-Storage-Format-JSONpm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooX = buildPerlPackage {
    pname = "MooX";
    version = "0.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GE/GETTY/MooX-0.101.tar.gz";
      sha256 = "2ff91a656e78aae0aca42293829d7a7e5acb9bf22b0401635b2ab6c870de32d5";
    };
    propagatedBuildInputs = [ DataOptList ImportInto Moo ];
    meta = {
      description = "Using Moo and MooX:: packages the most lazy way";
      homepage = "https://github.com/Getty/p5-moox";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXAliases = buildPerlPackage {
    pname = "MooX-Aliases";
    version = "0.001006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/MooX-Aliases-0.001006.tar.gz";
      sha256 = "0rrqqsm8i6rckzxgzcj2p2s4cfszzddzwbcm04yjcqdcihkk2q01";
    };
    propagatedBuildInputs = [ Moo strictures ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Easy aliasing of methods and attributes in Moo";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXCmd = buildPerlPackage {
    pname = "MooX-Cmd";
    version = "0.017";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/MooX-Cmd-0.017.tar.gz";
      sha256 = "1xbhmq07v9z371ygkyghva9aryhc22kwbzn5qwkp72c0ma6z4gwl";
    };
    propagatedBuildInputs = [ ListMoreUtils ModulePluggable Moo PackageStash ParamsUtil RegexpCommon ];
    buildInputs = [ CaptureTiny ];
    meta = {
      description = "Giving an easy Moo style way to make command organized CLI apps";
      homepage = "https://metacpan.org/release/MooX-Cmd";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXlate = buildPerlPackage {
    pname = "MooX-late";
    version = "0.100";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/MooX-late-0.100.tar.gz";
      sha256 = "2ae5b1e3da5abc0e4006278ecbcfa8fa7c224ea5529a6a688acbb229c09e6a5f";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moo SubHandlesVia ];
    meta = {
      description = "Easily translate Moose code to Moo";
      homepage = "https://metacpan.org/release/MooX-late";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXSimpleConfig = buildPerlPackage {
    pname = "MouseX-SimpleConfig";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJGARDNER/MouseX-SimpleConfig-0.11.tar.gz";
      sha256 = "257f384091d33d340373a6153947039c698dc449d1ef989335644fc3d2da0069";
    };
    propagatedBuildInputs = [ ConfigAny MouseXConfigFromFile ];
    meta = {
      description = "A Mouse role for setting attributes from a simple configfile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPostgreSQL = buildPerlModule {
    pname = "Test-PostgreSQL";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJC/Test-PostgreSQL-1.29.tar.gz";
      sha256 = "sha256-GKz35YnKTMqc3kdgm1NsnYI8hWLRqlIQwWjl6xuOT54=";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork pkgs.postgresql ];
    propagatedBuildInputs = [ DBDPg DBI FileWhich FunctionParameters Moo TieHashMethod TryTiny TypeTiny ];

    makeMakerFlags = "POSTGRES_HOME=${pkgs.postgresql}";

    meta = {
      description = "PostgreSQL runner for tests";
      homepage = "https://github.com/TJC/Test-postgresql";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestUseAllModules = buildPerlPackage {
    pname = "Test-UseAllModules";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Test-UseAllModules-0.17.tar.gz";
      sha256 = "a71f2fe8b96ab8bfc2760aa1d3135ea049a5b20dcb105457b769a1195c7a2509";
    };
    meta = {
      description = "Do use_ok() for all the MANIFESTed modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestValgrind = buildPerlPackage {
    pname = "Test-Valgrind";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/Test-Valgrind-1.19.tar.gz";
      sha256 = "06w1c0ddmmdkhhvv9pxq2nv5i40nbqf4cssfkq38yypfbyhsff0q";
    };
    propagatedBuildInputs = [ EnvSanctify FileHomeDir PerlDestructLevel XMLTwig ];
    meta = {
      description = "Generate suppressions, analyse and test any command with valgrind";
      homepage = "http://search.cpan.org/dist/Test-Valgrind";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypesPathClass = buildPerlPackage {
    pname = "MouseX-Types-Path-Class";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MASAKI/MouseX-Types-Path-Class-0.07.tar.gz";
      sha256 = "228d4b4f3f0ed9547278691d0b7c5fe53d90874a69df709a49703c6af87c09de";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ MouseXTypes PathClass ];
    meta = {
      description = "Cross-platform path specification manipulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypes = buildPerlPackage {
    pname = "MouseX-Types";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Types-0.06.tar.gz";
      sha256 = "77288441fdadd15beeec9a0813ece8aec1542f1d8ceaaec14755b3f316fbcf8b";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyMoose ];
    meta = {
      description = "Organize your Mouse types in libraries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXConfigFromFile = buildPerlPackage {
    pname = "MouseX-ConfigFromFile";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MASAKI/MouseX-ConfigFromFile-0.05.tar.gz";
      sha256 = "921b31cb13fc1f982a602f8e23815b7add23a224257e43790e287504ce879534";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ MouseXTypesPathClass ];
    meta = {
      description = "An abstract Mouse role for setting attributes from a configfile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXGetopt = buildPerlModule {
    pname = "MouseX-Getopt";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Getopt-0.38.tar.gz";
      sha256 = "de3ea8ef452dd9501ea8c4eda8744b7224602602b04692607edd7d62b79f038f";
    };
    buildInputs = [ ModuleBuildTiny MouseXConfigFromFile MouseXSimpleConfig TestException TestWarn ];
    propagatedBuildInputs = [ GetoptLongDescriptive Mouse ];
    meta = {
      description = "A Mouse role for processing command line options";
      homepage = "https://github.com/gfx/mousex-getopt";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXAttributeChained = buildPerlModule {
    pname = "MooseX-Attribute-Chained";
    version = "1.0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOMHUKINS/MooseX-Attribute-Chained-1.0.3.tar.gz";
      sha256 = "0kjydmkxh8hpkbbmsgd5wrkhgq7w69lgfg6lx4s5g2xpqfkqmqz7";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAttributeHelpers = buildPerlModule {
    pname = "MooseX-AttributeHelpers";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-AttributeHelpers-0.25.tar.gz";
      sha256 = "b0c819ec83999b258b248f82059fa5975a0cee365423abbee0efaca5401c5ec6";
    };
    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "(DEPRECATED) Extend your attribute interfaces";
      homepage = "https://github.com/moose/MooseX-AttributeHelpers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXClone = buildPerlModule {
    pname = "MooseX-Clone";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Clone-0.06.tar.gz";
      sha256 = "19wd74dihybnz1lbbsqn0clwxzb6y0aa0i25a8zhajz7p5fq5myb";
    };
    propagatedBuildInputs = [ DataVisitor HashUtilFieldHashCompat namespaceautoclean ];
    buildInputs = [ ModuleBuildTiny ];
  };

  MooseXConfigFromFile = buildPerlModule {
    pname = "MooseX-ConfigFromFile";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-ConfigFromFile-0.14.tar.gz";
      sha256 = "9ad343cd9f86d714be9b54b9c68a443d8acc6501b6ad6b15e9ca0130b2e96f08";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestFatal TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ MooseXTypesPathTiny ];
    meta = {
      description = "An abstract Moose role for setting attributes from a configfile";
      homepage = "https://github.com/moose/MooseX-ConfigFromFile";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXDaemonize = buildPerlModule {
    pname = "MooseX-Daemonize";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Daemonize-0.22.tar.gz";
      sha256 = "8a7fb999dca9b802a85136a10141b2d3378a3ecde0527c1df73d55edb28e59b3";
    };
    buildInputs = [ DevelCheckOS ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXGetopt MooseXTypesPathClass ];
    meta = {
      description = "Role for daemonizing your Moose based application";
      homepage = "https://github.com/moose/MooseX-Daemonize";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXEmulateClassAccessorFast = buildPerlPackage {
    pname = "MooseX-Emulate-Class-Accessor-Fast";
    version = "0.009032";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/MooseX-Emulate-Class-Accessor-Fast-0.009032.tar.gz";
      sha256 = "153r30nggcyyx7ai15dbnba2h5145f8jdsh6wj54298d3zpvgvl2";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose namespaceclean ];
    meta = {
      description = "Emulate Class::Accessor::Fast behavior using Moose attributes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXGetopt = buildPerlModule {
    pname = "MooseX-Getopt";
    version = "0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Getopt-0.74.tar.gz";
      sha256 = "1de0df3b431ebe9f3563bdf4569eacd7e07e865a8397f2a990d0cb57d4cb2c24";
    };
    buildInputs = [ ModuleBuildTiny MooseXStrictConstructor PathTiny TestDeep TestFatal TestNeeds TestTrap TestWarnings ];
    propagatedBuildInputs = [ GetoptLongDescriptive MooseXRoleParameterized ];
    meta = {
      description = "A Moose role for processing command line options";
      homepage = "https://github.com/moose/MooseX-Getopt";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXHasOptions = buildPerlPackage {
    pname = "MooseX-Has-Options";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PS/PSHANGOV/MooseX-Has-Options-0.003.tar.gz";
      sha256 = "07c21cf8ed500b272020ff8da19f194728bb414e0012a2f0cc54ef2ef6222a68";
    };
    buildInputs = [ Moose TestDeep TestDifferences TestException TestMost TestWarn namespaceautoclean ];
    propagatedBuildInputs = [ ClassLoad ListMoreUtils StringRewritePrefix ];
    meta = {
      description = "Succinct options for Moose";
      homepage = "https://github.com/pshangov/moosex-has-options";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXHasSugar = buildPerlPackage {
    pname = "MooseX-Has-Sugar";
    version = "1.000006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KENTNL/MooseX-Has-Sugar-1.000006.tar.gz";
      sha256 = "efeed3ddb3a8ea18f416d485f3c2b0427145d267e63368c651d488eaa8c28d09";
    };
    buildInputs = [ TestFatal namespaceclean ];
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      description = "Sugar Syntax for moose 'has' fields";
      homepage = "https://github.com/kentnl/MooseX-Has-Sugar";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXLazyRequire = buildPerlModule {
    pname = "MooseX-LazyRequire";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-LazyRequire-0.11.tar.gz";
      sha256 = "ef620c1e019daf9cf3f23a943d25a94c91e93ab312bcd63be2e9740ec0b94288";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      description = "Required attributes which fail only when trying to use them";
      homepage = "https://github.com/moose/MooseX-LazyRequire";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXMarkAsMethods = buildPerlPackage {
    pname = "MooseX-MarkAsMethods";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSRCHBOY/MooseX-MarkAsMethods-0.15.tar.gz";
      sha256 = "1y3yxwcjjajm66pvca54cv9fax7a6dy36xqr92x7vzyhfqrw3v69";
    };
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Mark overload code symbols as methods";
      homepage = "http://metacpan.org/release/MooseX-MarkAsMethods";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    pname = "MooseX-MethodAttributes";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.32.tar.gz";
      sha256 = "0yqrihv609j2q0hrmpmvgpn0mnxc0z3ws39cqhwxvlmpfijqhcyb";
    };
    buildInputs = [ MooseXRoleParameterized TestFatal TestNeeds ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Code attribute introspection";
      homepage = "https://github.com/moose/MooseX-MethodAttributes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXNonMoose = buildPerlPackage {
    pname = "MooseX-NonMoose";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.26.tar.gz";
      sha256 = "0zdaiphc45s5xj0ax5mkijf5d8v6w6yccb3zplgj6f30y7n55gnb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      homepage = "http://metacpan.org/release/MooseX-NonMoose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXOneArgNew = buildPerlPackage {
    pname = "MooseX-OneArgNew";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-OneArgNew-0.005.tar.gz";
      sha256 = "0gqhqdkwsnxmni0xv43iplplgp6g55khdwc5117j9i569r3wykvy";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized ];
    meta = {
      description = "Teach ->new to accept single, non-hashref arguments";
      homepage = "https://github.com/rjbs/MooseX-OneArgNew";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRelatedClassRoles = buildPerlPackage {
    pname = "MooseX-RelatedClassRoles";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/MooseX-RelatedClassRoles-0.004.tar.gz";
      sha256 = "17vynkf6m5d039qkr4in1c9lflr8hnwp1fgzdwhj4q6jglipmnrh";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized ];
  };

  MooseXParamsValidate = buildPerlPackage {
    pname = "MooseX-Params-Validate";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Params-Validate-0.21.tar.gz";
      sha256 = "1n9ry6gnskkp9ir6s7d5jirn3mh14ydgpmwqz6wcp6d9md358ac8";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DevelCaller Moose ParamsValidate ];
    meta = {
      description = "An extension of Params::Validate using Moose's types";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleParameterized = buildPerlModule {
    pname = "MooseX-Role-Parameterized";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-Parameterized-1.11.tar.gz";
      sha256 = "17pc5dly7ba0p50p2xcmp7bar8m262jcqgbkgyswl3kzbmn7dzhw";
    };
    buildInputs = [ CPANMetaCheck ModuleBuildTiny TestFatal TestNeeds ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Moose roles with composition parameters";
      homepage = "https://github.com/moose/MooseX-Role-Parameterized";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleWithOverloading = buildPerlPackage {
    pname = "MooseX-Role-WithOverloading";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-WithOverloading-0.17.tar.gz";
      sha256 = "0rb8k0dp1a55bm2pr6r0vsi5msvjl1dslfidxp1gj80j7zbrbc4j";
    };
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      description = "(DEPRECATED) Roles which support overloading";
      homepage = "https://github.com/moose/MooseX-Role-WithOverloading";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRunnable = buildPerlModule {
    pname = "MooseX-Runnable";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Runnable-0.10.tar.gz";
      sha256 = "40d8fd1b5524ae965965a1f144d7a0a0c850594c524402b2319b24d5c4af1199";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 TestTableDriven ];
    propagatedBuildInputs = [ ListSomeUtils MooseXTypesPathTiny ];
    meta = {
      description = "Tag a class as a runnable application";
      homepage = "https://github.com/moose/MooseX-Runnable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mx-run";
    };
  };

  MooseXSemiAffordanceAccessor = buildPerlPackage {
    pname = "MooseX-SemiAffordanceAccessor";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-SemiAffordanceAccessor-0.10.tar.gz";
      sha256 = "1mdil9ckgmgr78z59p8wfa35ixn5855ndzx14y01dvfxpiv5gf55";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSetOnce = buildPerlPackage {
    pname = "MooseX-SetOnce";
    version = "0.200002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-SetOnce-0.200002.tar.gz";
      sha256 = "0ndnl8dj7nh8lvckl6r3jw31d0dmq30qf2pqkgcz0lykzjvhdvfb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSingleton = buildPerlModule {
    pname = "MooseX-Singleton";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Singleton-0.30.tar.gz";
      sha256 = "0hb5s1chsgbx2nlb0f112mdh2v1zwww8f4i3gvfvcghx3grv5135";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires TestWarnings ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXStorage = buildPerlPackage {
    pname = "MooseX-Storage";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Storage-0.53.tar.gz";
      sha256 = "8704bfe505f66b340f62e85c9ff319c19e9670b26d4b012c91f4e103b1daace0";
    };
    buildInputs = [ TestDeep TestDeepType TestFatal TestNeeds TestDeepJSON TestWithoutModule DigestHMAC MooseXTypes ];
    propagatedBuildInputs = [ ModuleRuntime Moose MooseXRoleParameterized PodCoverage StringRewritePrefix namespaceautoclean IOStringy JSON JSONXS JSONMaybeXS CpanelJSONXS YAML YAMLOld YAMLTiny YAMLLibYAML YAMLSyck ];
    meta = {
      description = "A serialization framework for Moose classes";
      homepage = "https://github.com/moose/MooseX-Storage";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXStrictConstructor = buildPerlPackage {
    pname = "MooseX-StrictConstructor";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-StrictConstructor-0.21.tar.gz";
      sha256 = "c72a5ae9583706ccdec71d401dcb3054013a7536b750df1436613d858ea2920d";
    };
    buildInputs = [ Moo TestFatal TestNeeds ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Make your object constructors blow up on unknown attributes";
      homepage = "http://metacpan.org/release/MooseX-StrictConstructor";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MooseXTraits = buildPerlModule {
    pname = "MooseX-Traits";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Traits-0.13.tar.gz";
      sha256 = "74afe0c4faf4e3b97c57f289437caa60becca34cd5821f489dd4cc9da4fbe29a";
    };
    buildInputs = [ ModuleBuildTiny MooseXRoleParameterized TestFatal TestRequires TestSimple13 ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Automatically apply roles at object creation time";
      homepage = "https://github.com/moose/MooseX-Traits";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTraitsPluggable = buildPerlPackage {
    pname = "MooseX-Traits-Pluggable";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/MooseX-Traits-Pluggable-0.12.tar.gz";
      sha256 = "1jjqmcidy4kdgp5yffqqwxrsab62mbhbpvnzdy1rpwnb1savg5mb";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils Moose namespaceautoclean ];
  };

  MooseXTypes = buildPerlModule {
    pname = "MooseX-Types";
    version = "0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-0.50.tar.gz";
      sha256 = "9cd87b3492cbf0be9d2df9317b2adf9fc30663770e69906654bea3f41b17cb08";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires ];
    propagatedBuildInputs = [ CarpClan Moose SubExporterForMethods namespaceautoclean ];
    meta = {
      description = "Organise your Moose types in libraries";
      homepage = "https://github.com/moose/MooseX-Types";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesCommon = buildPerlModule {
    pname = "MooseX-Types-Common";
    version = "0.001014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Common-0.001014.tar.gz";
      sha256 = "ef93718b6d2f240d50b5c3acb1a74b4c2a191869651470001a82be1f35d0ef0f";
    };
    buildInputs = [ ModuleBuildTiny TestDeep TestWarnings ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      description = "A library of commonly used type constraints";
      homepage = "https://github.com/moose/MooseX-Types-Common";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTime = buildPerlModule {
    pname = "MooseX-Types-DateTime";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-DateTime-0.13.tar.gz";
      sha256 = "b89fa26636f6a17eaa3868b4514340472b68bbdc2161a1d79a22a1bf5b1d39c6";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 ];
    propagatedBuildInputs = [ DateTime MooseXTypes ];
    meta = {
      description = "DateTime related constraints and coercions for Moose";
      homepage = "https://github.com/moose/MooseX-Types-DateTime";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesDateTimeMoreCoercions = buildPerlModule {
    pname = "MooseX-Types-DateTime-MoreCoercions";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-DateTime-MoreCoercions-0.15.tar.gz";
      sha256 = "21bb3a597719888edb6ceaa132418d5cf92ecb92a50cce37b94259a55e0e3796";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestSimple13 ];
    propagatedBuildInputs = [ DateTimeXEasy MooseXTypesDateTime TimeDurationParse ];
    meta = {
      description = "Extensions to MooseX::Types::DateTime";
      homepage = "https://github.com/moose/MooseX-Types-DateTime-MoreCoercions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesLoadableClass = buildPerlModule {
    pname = "MooseX-Types-LoadableClass";
    version = "0.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-LoadableClass-0.015.tar.gz";
      sha256 = "e037d3778253dcf92946435715bada0e6449c0a2808fa3ff32a965064d5a3bf4";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      description = "ClassName type constraint with coercion to load the class";
      homepage = "https://github.com/moose/MooseX-Types-LoadableClass";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathClass = buildPerlModule {
    pname = "MooseX-Types-Path-Class";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Class-0.09.tar.gz";
      sha256 = "0zpgwzxj6d9k2lbg6v6zd1bcbzjz2h336rm816krbblq6ssvm177";
    };
    propagatedBuildInputs = [ MooseXTypes PathClass ];
    buildInputs = [ ModuleBuildTiny TestNeeds ];
    meta = {
      description = "A Path::Class type library for Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathTiny = buildPerlModule {
    pname = "MooseX-Types-Path-Tiny";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Tiny-0.012.tar.gz";
      sha256 = "19eede02dd654e70f73e34cd7af0063765173bcaefeeff1bdbe21318ecfd9158";
    };
    buildInputs = [ Filepushd ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ MooseXGetopt MooseXTypesStringlike PathTiny ];
    meta = {
      description = "Path::Tiny types and coercions for Moose";
      homepage = "https://github.com/karenetheridge/moosex-types-path-tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  MooseXTypesPerl = buildPerlPackage {
    pname = "MooseX-Types-Perl";
    version = "0.101343";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-Types-Perl-0.101343.tar.gz";
      sha256 = "0nijy676q27bvjb8swxrb1j4lq2xq8jbqkaxs1l9q81k7jpvx17h";
    };
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      description = "Moose types that check against Perl syntax";
      homepage = "https://github.com/rjbs/MooseX-Types-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesStringlike = buildPerlPackage {
    pname = "MooseX-Types-Stringlike";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/MooseX-Types-Stringlike-0.003.tar.gz";
      sha256 = "06fgamdiz0n7cgghb8ycjd5mcidj8w769zs2gws6z6jjbkn4kqrf";
    };
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      description = "Moose type constraints for strings or string-like objects";
      homepage = "https://github.com/dagolden/MooseX-Types-Stringlike";
      license = with lib.licenses; [ asl20 ];
    };
  };

  MooseXTypesStructured = buildPerlModule {
    pname = "MooseX-Types-Structured";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Structured-0.36.tar.gz";
      sha256 = "0mrxc00sid7526c6brrnjr6288468sszic3wazij71v3z59bdka3";
    };
    buildInputs = [ DateTime ModuleBuildTiny MooseXTypesDateTime TestFatal TestNeeds ];
    propagatedBuildInputs = [ DevelPartialDump MooseXTypes ];
    meta = {
      description = "Structured Type Constraints for Moose";
      homepage = "https://github.com/moose/MooseX-Types-Structured";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesURI = buildPerlModule {
    pname = "MooseX-Types-URI";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-URI-0.08.tar.gz";
      sha256 = "d310d20fa361fe2dff758236df87949cc7bf98e5cf3a7c79115365eccde6ccc1";
    };
    buildInputs = [ ModuleBuildTiny TestSimple13 ];
    propagatedBuildInputs = [ MooseXTypesPathClass URIFromHash ];
    meta = {
      description = "URI related types and coercions for Moose";
      homepage = "https://github.com/moose/MooseX-Types-URI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MP3Info = buildPerlPackage {
    pname = "MP3-Info";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMERELO/MP3-Info-1.26.tar.gz";
      sha256 = "1rwbrsdw6y6jgcjvrlji6fbcvwl4wlka3mkhlw12a7s2683k8qjp";
    };
    meta = {
      description = "Manipulate / fetch info from MP3 audio files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MP3Tag = buildPerlPackage {
    pname = "MP3-Tag";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILYAZ/modules/MP3-Tag-1.15.zip";
      sha256 = "1lanbwv97sfsb7h4vsg1v0dv3yghpz01nf3rzl4a9p3ycgs4ib5a";
    };
    buildInputs = [ pkgs.unzip ];

    postPatch = ''
      substituteInPlace Makefile.PL --replace "'PL_FILES'" "#'PL_FILES'"
    '';
    postFixup = ''
      perl data_pod.PL PERL5LIB:$PERL5LIB
    '';
    outputs = [ "out" ];
    meta = {
      description = "Module for reading tags of MP3 audio files";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  Mouse = buildPerlModule {
    pname = "Mouse";
    version = "2.5.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Mouse-v2.5.10.tar.gz";
      sha256 = "1vijm8wkyws1jhnqmx104585q3srw9z1crcpy1zlcfhm8qww53ff";
    };
    buildInputs = [ ModuleBuildXSUtil TestException TestFatal TestLeakTrace TestOutput TestRequires TryTiny ];
    perlPreHook = "export LD=$CC";
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-fno-stack-protector";
    hardeningDisable = lib.optional stdenv.isi686 "stackprotector";
  };

  MouseXNativeTraits = buildPerlPackage {
    pname = "MouseX-NativeTraits";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/MouseX-NativeTraits-1.09.tar.gz";
      sha256 = "0pnbchkxfz9fwa8sniyjqp0mz75b3k2fafq9r09znbbh51dbz9gq";
    };
    buildInputs = [ AnyMoose TestFatal ];
    propagatedBuildInputs = [ Mouse ];
    meta = {
      description = "Extend your attribute interfaces for Mouse";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MozillaCA = buildPerlPackage {
    pname = "Mozilla-CA";
    version = "20200520";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABH/Mozilla-CA-20200520.tar.gz";
      sha256 = "b3ca0002310bf24a16c0d5920bdea97a2f46e77e7be3e7377e850d033387c726";
    };

    postPatch = ''
      ln -s --force ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt lib/Mozilla/CA/cacert.pem
    '';

    meta = {
      description = "Mozilla's CA cert bundle in PEM format";
      homepage = "https://github.com/gisle/mozilla-ca";
      license = with lib.licenses; [ mpl20 ];
    };
  };

  MozillaLdap = callPackage ../development/perl-modules/Mozilla-LDAP { };

  MROCompat = buildPerlPackage {
    pname = "MRO-Compat";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/MRO-Compat-0.13.tar.gz";
      sha256 = "1y547lr6zccf7919vx01v22zsajy528psanhg5aqschrrin3nb4a";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      homepage = "https://metacpan.org/release/MRO-Compat";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MusicBrainzDiscID = buildPerlPackage {
    pname = "MusicBrainz-DiscID";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NJ/NJH/MusicBrainz-DiscID-0.06.tar.gz";
      sha256 = "1azc91jnwa3gdmy9pc8mflakgvsvf69ywwlqllxmdzwpk386w2xs";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    # Makefile.PL in this package uses which to find pkg-config -- make it use path instead
    patchPhase = ''sed -ie 's/`which pkg-config`/"pkg-config"/' Makefile.PL'';
    doCheck = false; # The main test performs network access
    nativeBuildInputs = [ pkgs.pkg-config ];
    propagatedBuildInputs = [ pkgs.libdiscid ];
  };

  MusicBrainz = buildPerlModule {
    pname = "WebService-MusicBrainz";
    version = "1.0.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BF/BFAIST/WebService-MusicBrainz-1.0.5.tar.gz";
      sha256 = "16chs1l58cf000d5kalkyph3p31ci73p1rlyx98mfv10d2cq6fsj";
    };
    propagatedBuildInputs = [ Mojolicious ];
    doCheck = false; # Test performs network access.
  };

  MustacheSimple = buildPerlPackage {
    pname = "Mustache-Simple";
    version = "1.3.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CM/CMS/Mustache-Simple-v1.3.6.tar.gz";
      sha256 = "51db5d51ff4b25a670d8bfabe3902b6d45434ecf78b29bc1fff19af6e7383003";
    };
    propagatedBuildInputs = [ YAMLLibYAML ];
    meta = {
      description = "A simple Mustache Renderer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MySQLDiff = buildPerlPackage rec {
    pname = "MySQL-Diff";
    version = "0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ES/ESTRABD/MySQL-Diff-0.60.tar.gz";
      sha256 = "5d7080a4bd5714ff9ef536aa774a7adb3c6f0e760215ca6c39d8a3545344f956";
    };
    propagatedBuildInputs = [ pkgs.mariadb.client FileSlurp StringShellQuote ];
    meta = {
      description = "Generates a database upgrade instruction set";
      homepage = "https://github.com/estrabd/mysqldiff";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      mainProgram = "mysqldiff";
    };
  };

  namespaceautoclean = buildPerlPackage {
    pname = "namespace-autoclean";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz";
      sha256 = "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804";
    };
    buildInputs = [ TestNeeds ];
    propagatedBuildInputs = [ SubIdentify namespaceclean ];
    meta = {
      description = "Keep imports out of your namespace";
      homepage = "https://github.com/moose/namespace-autoclean";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  namespaceclean = buildPerlPackage {
    pname = "namespace-clean";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz";
      sha256 = "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      description = "Keep imports and functions out of your namespace";
      homepage = "http://search.cpan.org/dist/namespace-clean";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIdent = buildPerlPackage {
    pname = "Net-Ident";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Net-Ident-1.25.tar.gz";
      sha256 = "2e5bd58b01c2a66e8049a2f8d9c93e1b5f6dce53e0ee3a481ce6a6f411f2c8f8";
    };
    meta = {
      description = "Lookup the username on the remote end of a TCP/IP connection";
      homepage = "https://github.com/toddr/Net-Ident";
      license = with lib.licenses; [ mit ];
    };
  };

  NetINET6Glue = buildPerlPackage {
    pname = "Net-INET6Glue";
    version = "0.604";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SULLR/Net-INET6Glue-0.604.tar.gz";
      sha256 = "05xvbdrqq88npzg14bjm9wmjykzplwirzcm8rp61852hz6c67hwh";
    };
    meta = {
      description = "Make common modules IPv6 ready by hotpatching";
      homepage = "https://github.com/noxxi/p5-net-inet6glue";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAddrIP = buildPerlPackage {
    pname = "NetAddr-IP";
    version = "4.079";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/NetAddr-IP-4.079.tar.gz";
      sha256 = "ec5a82dfb7028bcd28bb3d569f95d87dd4166cc19867f2184ed3a59f6d6ca0e7";
    };
    meta = {
      description = "Manages IPv4 and IPv6 addresses and subnets";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAmazonAWSSign = buildPerlPackage {
    pname = "Net-Amazon-AWSSign";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NATON/Net-Amazon-AWSSign-0.12.tar.gz";
      sha256 = "0gpdjz5095hd3y1xhnbv45m6q2shw0c9r7spj1jvb8hy7dmhq10x";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Perl extension to create signatures for AWS requests";
      license = with lib.licenses; [ unfree ];
    };
  };

  NetAmazonEC2 = buildPerlPackage {
    pname = "Net-Amazon-EC2";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MALLEN/Net-Amazon-EC2-0.36.tar.gz";
      sha256 = "1wbjgmxjzr8mjpwj3mglan9hyh327cz27sfsir0w4rphwy93ca2f";
    };
    propagatedBuildInputs = [ LWPProtocolHttps Moose ParamsValidate XMLSimple ];
    buildInputs = [ TestException ];
    meta = {
      description = "Perl interface to the Amazon Elastic Compute Cloud (EC2) environment";
      homepage = "https://metacpan.org/dist/Net-Amazon-EC2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAmazonMechanicalTurk = buildPerlModule {
    pname = "Net-Amazon-MechanicalTurk";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MT/MTURK/Net-Amazon-MechanicalTurk-1.02.tar.gz";
      sha256 = "13hgggfchhp4m3l2rn3d1v6g6ccwmwf9xiyc9izv5570930mw2cd";
    };
    patches =
      [ ../development/perl-modules/net-amazon-mechanicalturk.patch ];
    propagatedBuildInputs = [ DigestHMAC LWPProtocolHttps XMLParser ];
    doCheck = false; /* wants network */
  };

  NetAmazonS3 = buildPerlPackage {
    pname = "Net-Amazon-S3";
    version = "0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BARNEY/Net-Amazon-S3-0.97.tar.gz";
      sha256 = "0d6yg0l6r6ziqjvgsswr484l66nznmj0b9rx4jnsygj8s1vmdn03";
    };
    buildInputs = [ TestDeep TestException TestLWPUserAgent TestMockTime TestWarnings ];
    propagatedBuildInputs = [ DataStreamBulk DateTimeFormatHTTP DigestHMAC DigestMD5File FileFindRule LWPUserAgentDetermined MIMETypes MooseXRoleParameterized MooseXStrictConstructor MooseXTypesDateTimeMoreCoercions RefUtil RegexpCommon SafeIsa SubOverride TermEncoding TermProgressBarSimple XMLLibXML ];
    meta = {
      description = "Use the Amazon S3 - Simple Storage Service";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "s3cl";
    };
  };

  NetAmazonS3Policy = buildPerlModule {
    pname = "Net-Amazon-S3-Policy";
    version = "0.1.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POLETTIX/Net-Amazon-S3-Policy-0.1.6.tar.gz";
      sha256 = "056rhq6vsdpwi2grbmxj8341qjrz0258civpnhs78j37129nxcfj";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Manage Amazon S3 policies for HTTP POST forms";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAsyncHTTP = buildPerlModule {
    pname = "Net-Async-HTTP";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Net-Async-HTTP-0.48.tar.gz";
      sha256 = "0gpp46lg7sr5xpsjhqkb022f9v88wy73carsrn5pvbmwjpwxcjwx";
    };
    buildInputs = [ HTTPCookies TestIdentity TestMetricsAny TestRefcount ];
    propagatedBuildInputs = [ Future HTTPMessage IOAsync MetricsAny StructDumb URI ];
    preCheck = lib.optionalString stdenv.isDarwin ''
      # network tests fail on Darwin/sandbox, so disable these
      rm -f t/20local-connect.t t/22local-connect-pipeline.t t/23local-connect-redir.t
      rm -f t/90rt75615.t t/90rt75616.t t/90rt93232.t
    '';
    meta = {
      description = "Use HTTP with IO::Async";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  NetAsyncPing = buildPerlPackage {
    pname = "Net-Async-Ping";
    version = "0.004001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABRAXXA/Net-Async-Ping-0.004001.tar.gz";
      sha256 = "0nz9i9fp7wp620f4i9z8fip1zhcaz34ckhd00ymksw8cfr8fhmwh";
    };
    propagatedBuildInputs = [ IOAsync Moo NetFrameLayerIPv6 namespaceclean ];
    buildInputs = [ TestFatal ];
    preCheck = "rm t/icmp_ps.t t/icmpv6_ps.t"; # ping socket tests fail
    meta = {
      description = "Asyncronously check remote host for reachability";
      homepage = "https://github.com/frioux/Net-Async-Ping";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAsyncWebSocket = buildPerlModule {
    pname = "Net-Async-WebSocket";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Net-Async-WebSocket-0.13.tar.gz";
      sha256 = "000nw7gnj7ks55nib3fiikxx9bfmbla6fimxrbn2z2n7sd187b0d";
    };
    propagatedBuildInputs = [ IOAsync ProtocolWebSocket URI ];
    preCheck = lib.optionalString stdenv.isDarwin ''
      # network tests fail on Darwin/sandbox, so disable these
      rm -f t/02server.t t/03cross.t
    '';
    meta = {
      description = "Use WebSockets with IO::Async";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  NetAMQP = buildPerlModule {
    pname = "Net-AMQP";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHIPS/Net-AMQP-0.06.tar.gz";
      sha256 = "0b2ba7de2cd7ddd5fe102a2e2ae7aeba21eaab1078bf3bfd3c5a722937256380";
    };
    doCheck = false; # failures on 32bit
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable XMLLibXML ];
    meta = {
      description = "Advanced Message Queue Protocol (de)serialization and representation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetCIDR = buildPerlPackage {
    pname = "Net-CIDR";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSAM/Net-CIDR-0.20.tar.gz";
      sha256 = "c75edc6818bb360d71c139169fd64ad65c35fff6d2b9fac7b9f9e6c467f187b5";
    };
    meta = {
      description = "Manipulate IPv4/IPv6 netblocks in CIDR notation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.bjornfor ];
    };
  };

  NetCIDRLite = buildPerlPackage {
    pname = "Net-CIDR-Lite";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STIGTSP/Net-CIDR-Lite-0.22.tar.gz";
      sha256 = "05w57db2lx4djb4vixzdr6qgrzyzkk047nl812g7nq8s6k5xh5s3";
    };
    meta = {
      description = "Perl extension for merging IPv4 or IPv6 CIDR addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  NetCoverArtArchive = buildPerlPackage {
    pname = "Net-CoverArtArchive";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CY/CYCLES/Net-CoverArtArchive-1.02.tar.gz";
      sha256 = "1lfx8lrjgb3s11fcm243jp5sghngd9svkgmg7xmssmj34q4f49ap";
    };
    buildInputs = [ FileFindRule ];
    propagatedBuildInputs = [ JSONAny LWP Moose namespaceautoclean ];
    meta = {
      description = "Query the coverartarchive.org";
      homepage = "https://github.com/metabrainz/CoverArtArchive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDBus = buildPerlPackage {
    pname = "Net-DBus";
    version = "1.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/Net-DBus-1.2.0.tar.gz";
      sha256 = "e7a1ac9ef4a1235b3fdbd5888f86c347182306467bd79abc9b0756a64b441cbc";
    };
    nativeBuildInputs = [ buildPackages.pkg-config ];
    buildInputs = [ pkgs.dbus TestPod TestPodCoverage ];
    propagatedBuildInputs = [ XMLTwig ];

    # https://gitlab.com/berrange/perl-net-dbus/-/merge_requests/19
    patches = fetchpatch {
      url = "https://gitlab.com/berrange/perl-net-dbus/-/commit/6bac8f188fb06e5e5edd27aee672d66b7c28caa4.patch";
      sha256 = "19nf4xn9xhyd0sd2az9iliqldjj0k6ah2dmkyqyvq4rp2d9k5jgb";
    };

    postPatch = ''
      substituteInPlace Makefile.PL --replace pkg-config $PKG_CONFIG
    '';

    meta = {
      description = "Extension for the DBus bindings";
      homepage = "http://www.freedesktop.org/wiki/Software/dbus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDNS = buildPerlPackage {
    pname = "Net-DNS";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NL/NLNETLABS/Net-DNS-1.29.tar.gz";
      sha256 = "1ia35l9bdnwic6fb5knkvn6bl939np5q2r824d1023cggvl6wbc5";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    makeMakerFlags = "--noonline-tests";
    meta = {
      description = "Perl Interface to the Domain Name System";
      license = with lib.licenses; [ mit ];
    };
  };

  NetDNSResolverMock = buildPerlPackage {
    pname = "Net-DNS-Resolver-Mock";
    version = "1.20200215";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Net-DNS-Resolver-Mock-1.20200215.tar.gz";
      sha256 = "1rv745c16l3m3w6xx2hjmmgzkdklmzm9imdfiddmdr9hwm8g3xxy";
    };
    propagatedBuildInputs = [ NetDNS ];
    buildInputs = [ TestException ];
    meta = {
      description = "Mock a DNS Resolver object for testing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDomainTLD = buildPerlPackage {
    pname = "Net-Domain-TLD";
    version = "1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXP/Net-Domain-TLD-1.75.tar.gz";
      sha256 = "4c37f811184d68ac4179d48c10ea31922dd5fca2c1bffcdcd95c5a2a3b4002ee";
    };
    meta = {
      description = "Work with TLD names";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetFastCGI = buildPerlPackage {
    pname = "Net-FastCGI";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Net-FastCGI-0.14.tar.gz";
      sha256 = "0sjrnlzci21sci5m52zz0x9bf889j67i6vnhrjlypsfm9w5914qi";
    };
    buildInputs = [ TestException TestHexString ];
    meta = {
      description = "FastCGI Toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetFrame = buildPerlModule {
    pname = "Net-Frame";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GO/GOMOR/Net-Frame-1.21.tar.gz";
      sha256 = "0ffphcw52dgn07k7q02di77zq2zzc0p3vlv2gnphr7v3ifi5gcxw";
    };
    propagatedBuildInputs = [ BitVector ClassGomor NetIPv6Addr ];
    preCheck = "rm t/13-gethostsubs.t"; # it performs DNS queries
    meta = {
      description = "The base framework for frame crafting";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  NetFrameLayerIPv6 = buildPerlModule {
    pname = "Net-Frame-Layer-IPv6";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GO/GOMOR/Net-Frame-Layer-IPv6-1.08.tar.gz";
      sha256 = "1mzp778jmjn23990gj0mibhr9mrwmaw85nh7wf25hzzkx0mqabds";
    };
    propagatedBuildInputs = [ NetFrame ];
    meta = {
      description = "Internet Protocol v6 layer object";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  NetFreeDB = buildPerlPackage {
    pname = "Net-FreeDB";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSHULTZ/Net-FreeDB-0.10.tar.gz";
      sha256 = "11dfi14qnzsnmr71cygir85zfj15n08b7d5g0i4cj5pb70if2hzp";
    };
    buildInputs = [ TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ CDDBFile Moo ];
    meta = {
      description = "OOP Interface to FreeDB Server(s)";
      license = with lib.licenses; [ artistic1 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.NetFreeDB.x86_64-darwin
    };
  };

  NetHTTP = buildPerlPackage {
    pname = "Net-HTTP";
    version = "6.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/Net-HTTP-6.19.tar.gz";
      sha256 = "52b76ec13959522cae64d965f15da3d99dcb445eddd85d2ce4e4f4df385b2fc4";
    };
    propagatedBuildInputs = [ URI ];
    __darwinAllowLocalNetworking = true;
    doCheck = false; /* wants network */
    meta = {
      description = "Low-level HTTP connection (client)";
      homepage = "https://github.com/libwww-perl/Net-HTTP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetHTTPSNB = buildPerlPackage {
    pname = "Net-HTTPS-NB";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLEG/Net-HTTPS-NB-0.15.tar.gz";
      sha256 = "0kwc4z8pqnbc396wjnlgdmri10zdh91f2bi6saxkpfjzlm7wysba";
    };
    propagatedBuildInputs = [ IOSocketSSL NetHTTP ];
    meta = {
      description = "Non-blocking HTTPS client";
      homepage = "https://github.com/olegwtf/p5-Net-HTTPS-NB";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIDNEncode = buildPerlModule {
    pname = "Net-IDN-Encode";
    version = "2.500";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.500.tar.gz";
      sha256 = "1aiy7adirk3wpwlczd8sldi9k1dray0jrg1lbcrcw97zwcrkciam";
    };
    buildInputs = [ TestNoWarnings ];
    perlPreHook = "export LD=$CC";
    meta = {
      description = "Internationalizing Domain Names in Applications (UTS #46)";
      homepage = "https://metacpan.org/release/Net-IDN-Encode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIMAPClient = buildPerlPackage {
    pname = "Net-IMAP-Client";
    version = "0.9505";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GANGLION/Net-IMAP-Client-0.9505.tar.gz";
      sha256 = "d3f6a608b85e09a8080a67a9933837aae6f2cd0e8ee39df3380123dc5e3de912";
    };
    propagatedBuildInputs = [ IOSocketSSL ListMoreUtils ];
    meta = {
      description = "Not so simple IMAP client library";
      license = with lib.licenses; [ unfree ];
    };
  };

  NetIP = buildPerlPackage {
    pname = "Net-IP";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz";
      sha256 = "0ffn2xqqbkfi7v303sp5dwgbv36jah3vg8r4nxhxfiv60vric3q4";
    };
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
      license = with lib.licenses; [ unfree ];
    };
  };

  NetIPLite = buildPerlPackage {
    pname = "Net-IP-Lite";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXKOM/Net-IP-Lite-0.03.tar.gz";
      sha256 = "c9916e6cfaa53be275379ce4b2a550ae176ddfab50dad43b43ed43e8267802a9";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
      homepage = "https://metacpan.org/pod/Net::IP::Lite";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  NetIPv4Addr = buildPerlPackage {
    pname = "Net-IPv4Addr";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FRAJULAC/Net-IPv4Addr-0.10.tar.gz";
      sha256 = "1zk3591822dg187sgkwjjvg18qmvkn3yib1c34mq8z5i617xwi9q";
    };
    meta = {
      description = "Perl extension for manipulating IPv4 addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "ipv4calc";
    };
  };

  NetIPv6Addr = buildPerlPackage {
    pname = "Net-IPv6Addr";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/Net-IPv6Addr-1.01.tar.gz";
      sha256 = "008blh52k8g3syfk4dlmg7wclhdmksqkb5vk2qaxjpxmzq1pzqi7";
    };
    propagatedBuildInputs = [ MathBase85 NetIPv4Addr ];
    meta = {
      description = "Check and manipulate IPv6 addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetLDAPServer = buildPerlPackage {
    pname = "Net-LDAP-Server";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/Net-LDAP-Server-0.43.tar.gz";
      sha256 = "0qmh3cri3fpccmwz6bhwp78yskrb3qmalzvqn0a23hqbsfs4qv6x";
    };
    propagatedBuildInputs = [ perlldap ConvertASN1 ];
    meta = {
      description = "LDAP server side protocol handling";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetLDAPSID = buildPerlPackage {
    pname = "Net-LDAP-SID";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KARMAN/Net-LDAP-SID-0.001.tar.gz";
      sha256 = "1mnnpkmj8kpb7qw50sm8h4sd8py37ssy2xi5hhxzr5whcx0cvhm8";
    };
    meta = {
      description = "Active Directory Security Identifier manipulation";
      homepage = "https://github.com/karpet/net-ldap-sid";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetLDAPServerTest = buildPerlPackage {
    pname = "Net-LDAP-Server-Test";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KARMAN/Net-LDAP-Server-Test-0.22.tar.gz";
      sha256 = "13idip7jky92v4adw60jn2gcc3zf339gsdqlnc9nnvqzbxxp285i";
    };
    propagatedBuildInputs = [ perlldap NetLDAPServer DataDump NetLDAPSID ];
    meta = {
      description = "Test Net::LDAP code";
      homepage = "https://github.com/karpet/net-ldap-server-test";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetNetmask = buildPerlPackage {
    pname = "Net-Netmask";
    version = "2.0001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMASLAK/Net-Netmask-2.0001.tar.gz";
      sha256 = "0waiix46wv93a5zzjjv7ypdnfdf7lizwrhx12128rcvzcvw6wd8p";
    };
    buildInputs = [ Test2Suite TestUseAllModules ];
    meta = {
      description = "Understand and manipulate IP netmasks";
      homepage = "http://search.cpan.org/~jmaslak/Net-Netmask";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetMQTTSimple = buildPerlPackage {
    pname = "Net-MQTT-Simple";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JU/JUERD/Net-MQTT-Simple-1.26.tar.gz";
      sha256 = "sha256-ERxNNnu1AgXci8AjFfDGuw3mDRwwfQLnUuQuwRtPiLQ=";
    };
    meta = {
      description = "Minimal MQTT version 3 interface";
      license = with lib.licenses; [ free ];
    };
  };

  NetOAuth = buildPerlModule {
    pname = "Net-OAuth";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz";
      sha256 = "0k4h4a5048h7qgyx25ih64x0l4airx8a6d9gjq08wmxcl2fk3z3v";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable DigestHMAC DigestSHA1 LWP ];
    meta = {
      description = "An implementation of the OAuth protocol";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetPatricia = buildPerlPackage {
    pname = "Net-Patricia";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRUBER/Net-Patricia-1.22.tar.gz";
      sha256 = "70835a926e1c5a8d0324c72fffee82eeb7ec6c141dee04fd446820b64f71c552";
    };
    propagatedBuildInputs = [ NetCIDRLite Socket6 ];
  };

  NetPing = buildPerlPackage {
    pname = "Net-Ping";
    version = "2.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Net-Ping-2.74.tar.gz";
      sha256 = "04bxfglhxvffbwcg32rm1bzv54h183jyazhih5apqppdpdcqjami";
    };
    meta = {
      description = "Check a remote host for reachability";
      license = with lib.licenses; [ unfree ];
    };
  };

  NetDNSResolverProgrammable = buildPerlPackage {
    pname = "Net-DNS-Resolver-Programmable";
    version = "0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGPRESH/Net-DNS-Resolver-Programmable-0.009.tar.gz";
      sha256 = "8080a2ab776629585911af1179bdb7c4dc2bebfd4b5efd77b11d1dac62454bf8";
    };
    propagatedBuildInputs = [ NetDNS ];
    meta = {
      description = "Programmable DNS resolver class for offline emulation of DNS";
      homepage = "https://github.com/bigpresh/Net-DNS-Resolver-Programmable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetPrometheus = buildPerlModule {
    pname = "Net-Prometheus";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Net-Prometheus-0.11.tar.gz";
      sha256 = "0skjkz6q68y8g9blm7i03k4wprac3djq15akmlv1kmgag3i0ky12";
    };
    propagatedBuildInputs = [ RefUtil StructDumb URI ];
    buildInputs = [ HTTPMessage TestFatal ];
    meta = {
      description = "Export monitoring metrics for prometheus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSCP = buildPerlPackage {
    pname = "Net-SCP";
    version = "0.08.reprise";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IV/IVAN/Net-SCP-0.08.reprise.tar.gz";
      sha256 = "88a9b2df69e769e5855a408b19f61915b82e8fe070ab5cf4d525dd3b8bbe31c1";
    };
    propagatedBuildInputs = [ pkgs.openssl ];
    patchPhase = ''
      sed -i 's|$scp = "scp";|$scp = "${pkgs.openssh}/bin/scp";|' SCP.pm
    '';
    buildInputs = [ NetSSH StringShellQuote ];
    meta = {
      description = "Simple wrappers around ssh and scp commands";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetServer = buildPerlPackage {
    pname = "Net-Server";
    version = "2.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/Net-Server-2.009.tar.gz";
      sha256 = "0gw1k9gcw7habbkxvsfa2gz34brlbwcidk6khgsf1qjm0dbccrw2";
    };
    doCheck = false; # seems to hang waiting for connections
    meta = {
      description = "Extensible Perl internet server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "net-server";
    };
  };

  NetSFTPForeign = buildPerlPackage {
    pname = "Net-SFTP-Foreign";
    version = "1.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Net-SFTP-Foreign-1.91.tar.gz";
      sha256 = "b7395081314f26f3b93c857d65e9c80a04a63709df698583f22a360ffce7e178";
    };
    propagatedBuildInputs = [ pkgs.openssl ];
    patchPhase = ''
      sed -i "s|$ssh_cmd = 'ssh'|$ssh_cmd = '${pkgs.openssh}/bin/ssh'|" lib/Net/SFTP/Foreign/Backend/Unix.pm
    '';
    meta = {
      description = "Secure File Transfer Protocol client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetServerCoro = buildPerlPackage {
    pname = "Net-Server-Coro";
    version = "1.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Net-Server-Coro-1.3.tar.gz";
      sha256 = "11pvfxsi0q37kd17z597wb8r9dv3r96fiagq57kc746k1lmp06hy";
    };
    propagatedBuildInputs = [ Coro NetServer ];
    meta = {
      description = "A co-operative multithreaded server using Coro";
      license = with lib.licenses; [ mit ];
    };
  };

  NetServerSSPrefork = buildPerlPackage {
    pname = "Net-Server-SS-PreFork";
    version = "0.06pre";
    src = fetchFromGitHub {
      owner = "kazuho";
      repo = "p5-Net-Server-SS-PreFork";
      rev = "5fccc0c270e25c65ef634304630af74b48807d21";
      sha256 = "0z02labw0dd76sdf301bhrmgnsjds0ddsg22138g8ys4az49bxx6";
    };
    checkInputs = [ HTTPMessage LWP TestSharedFork HTTPServerSimple TestTCP TestUNIXSock ];
    buildInputs = [ ModuleInstall ];
    propagatedBuildInputs = [ NetServer ServerStarter ];
    meta = {
      description = "A hot-deployable variant of Net::Server::PreFork";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSMTPSSL = buildPerlPackage {
    pname = "Net-SMTP-SSL";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.04.tar.gz";
      sha256 = "001a6dcfahf7kkyirqkc8jd4fh4fkal7n7vm9c4dblqrvmdc8abv";
    };
    propagatedBuildInputs = [ IOSocketSSL ];
  };

  NetSMTPTLS = buildPerlPackage {
    pname = "Net-SMTP-TLS";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWESTHOLM/Net-SMTP-TLS-0.12.tar.gz";
      sha256 = "19g48kabj22v66jbf69q78xplhi7r1y2kdbddfwh4xy3g9k75rzg";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
  };

  NetSMTPTLSButMaintained = buildPerlPackage {
    pname = "Net-SMTP-TLS-ButMaintained";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FA/FAYLAND/Net-SMTP-TLS-ButMaintained-0.24.tar.gz";
      sha256 = "0vi5cv7f9i96hgp3q3jpxzn1ysn802kh5xc304f8b7apf67w15bb";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
  };

  NetSNMP = buildPerlModule {
    pname = "Net-SNMP";
    version = "6.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
      sha256 = "0hdpn1cw52x8cw24m9ayzpf4rwarm0khygn1sv3wvwxkrg0pphql";
    };
    doCheck = false; # The test suite fails, see https://rt.cpan.org/Public/Bug/Display.html?id=85799
    meta = {
      description = "Object oriented interface to SNMP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "snmpkey";
    };
  };

  NetSNPP = buildPerlPackage rec {
    pname = "Net-SNPP";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBEYA/Net-SNPP-1.17.tar.gz";
      sha256 = "06b851d64596625e866359fb017dd0d08973e0ebc50c323f4a1d50ecdd868e76";
    };

    doCheck = false;
    meta = {
      description = "Simple Network Pager Protocol Client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSSH = buildPerlPackage {
    pname = "Net-SSH";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IV/IVAN/Net-SSH-0.09.tar.gz";
      sha256 = "7c71c7c3cbe953234dfe25bcc1ad7edb0e1f5a0578601f5523bc6070262a3817";
    };
    propagatedBuildInputs = [ pkgs.openssl ];
    patchPhase = ''
      sed -i 's|$ssh = "ssh";|$ssh = "${pkgs.openssh}/bin/ssh";|' SSH.pm
    '';
    meta = {
      description = "Simple wrappers around ssh commands";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSSHPerl = buildPerlPackage {
    pname = "Net-SSH-Perl";
    version = "2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/Net-SSH-Perl-2.14.tar.gz";
      sha256 = "2b5d1bb13590b5870116704e7f1dce9a9823c4f80ff5461b97bb26a317393017";
    };
    propagatedBuildInputs = [ CryptCurve25519 CryptIDEA CryptX FileHomeDir MathGMP StringCRC32 ];
    preCheck = "export HOME=$TMPDIR";
    meta = {
      description = "Perl client interface to SSH";
      homepage = "http://search.cpan.org/dist/Net-SSH-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSSLeay = buildPerlPackage {
    pname = "Net-SSLeay";
    version = "1.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz";
      sha256 = "sha256-R8LyswDy5xYtcdaZ9jPdajWwYloAy9qMUKwBFEqTlqk=";
    };
    buildInputs = [ pkgs.openssl pkgs.zlib ];
    doCheck = false; # Test performs network access.
    preConfigure = ''
      mkdir openssl
      ln -s ${lib.getLib pkgs.openssl}/lib openssl
      ln -s ${pkgs.openssl.bin}/bin openssl
      ln -s ${pkgs.openssl.dev}/include openssl
      export OPENSSL_PREFIX=$(realpath openssl)
    '';
    meta = {
      description = "Perl bindings for OpenSSL and LibreSSL";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  NetStatsd = buildPerlPackage {
    pname = "Net-Statsd";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/COSIMO/Net-Statsd-0.12.tar.gz";
      sha256 = "63e453603da165bc6d1c4ca0b55eda3d2204f040c59304a47782c5aa7886565c";
    };
    meta = {
      description = "Perl client for Etsy's statsd daemon";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "benchmark.pl";
    };
  };

  NetTelnet = buildPerlPackage {
    pname = "Net-Telnet";
    version = "3.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROGERS/Net-Telnet-3.04.tar.gz";
      sha256 = "e64d567a4e16295ecba949368e7a6b8b5ae2a16b3ad682121d9b007dc5d2a37a";
    };
    meta = {
      description = "Interact with TELNET port or other TCP ports";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetTwitterLite = buildPerlModule {
    pname = "Net-Twitter-Lite";
    version = "0.12008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.12008.tar.gz";
      sha256 = "13j69a6nqq8mh5b4qk021db55rkfnk1ppwk0rpg68b1z58gvxsmj";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ JSON LWPProtocolHttps ];
    doCheck = false;
    meta = {
      description = "A perl API library for the Twitter API";
      homepage = "https://github.com/semifor/net-twitter-lite";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetWhoisIP = buildPerlPackage {
    pname = "Net-Whois-IP";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BS/BSCHMITZ/Net-Whois-IP-1.19.tar.gz";
      sha256 = "08kj2h9qiyfvv3jfz619xl796j93cslg7d96919mnrnjy6hdz6zh";
    };
    doCheck = false;

    # https://rt.cpan.org/Public/Bug/Display.html?id=99377
    postPatch = ''
      substituteInPlace IP.pm --replace " AutoLoader" ""
    '';
    buildInputs = [ RegexpIPv6 ];
  };

  NetWorks = buildPerlPackage {
    pname = "Net-Works";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/Net-Works-0.22.tar.gz";
      sha256 = "1zz91vn1kdxljnlwllf4dzdsm4v6pja5694vf8l4w66azcyv5j8a";
    };
    propagatedBuildInputs = [ ListAllUtils MathInt128 Moo namespaceautoclean ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Sane APIs for IP addresses and networks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberBytesHuman = buildPerlPackage {
    pname = "Number-Bytes-Human";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Number-Bytes-Human-0.11.tar.gz";
      sha256 = "0b3gprpbcrdwc2gqalpys5m2ngilh5injhww8y0gf3dln14rrisz";
    };
  };

  NumberCompare = buildPerlPackage {
    pname = "Number-Compare";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Number-Compare-0.03.tar.gz";
      sha256 = "09q8i0mxvr7q9vajwlgawsi0hlpc119gnhq4hc933d03x0vkfac3";
    };
  };

  NumberFormat = buildPerlPackage {
    pname = "Number-Format";
    version = "1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WRW/Number-Format-1.75.tar.gz";
      sha256 = "82d659cb16461764fd44d11a9ce9e6a4f5e8767dc1069eb03467c6e55de257f3";
    };
    meta = {
      description = "Perl extension for formatting numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberFraction = buildPerlModule {
    pname = "Number-Fraction";
    version = "3.0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVECROSS/Number-Fraction-v3.0.3.tar.gz";
      sha256 = "1vqhd6ngrxhfykf4qz358divjhcnp9v688fp3zi6n5757x1sl01v";
    };
    propagatedBuildInputs = [ Moo MooXTypesMooseLike ];
    meta = {
      description = "Perl extension to model fractions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberMisc = buildPerlModule {
    pname = "Number-Misc";
    version = "1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/Number-Misc-1.2.tar.gz";
      sha256 = "1n4ivj4ydplanwbxn3jbsfyfcl91ngn2d0addzqrq1hac26bdfbp";
    };
    meta = {
      description = "Number::Misc - handy utilities for numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberPhone = buildPerlPackage {
    pname = "Number-Phone";
    version = "3.8004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Number-Phone-3.8004.tar.gz";
      sha256 = "sha256-ZY7hyNGXTvSwV+B4L0mTi/PelA6QY/2bYecY6siwO+8=";
    };
    buildInputs = [ DevelHide FileShareDirInstall ParallelForkManager TestDifferences TestPod TestPodCoverage TestWarnings ];
    propagatedBuildInputs = [ DataDumperConcise DBMDeep DevelCheckOS FileFindRule FileShareDir ];
    meta = {
      description = "Large suite of perl modules for parsing and dealing with phone numbers";
      homepage = "https://github.com/DrHyde/perl-modules-Number-Phone";
      license = with lib.licenses; [ artistic1 gpl2 ];
    };
  };

  NumberWithError = buildPerlPackage {
    pname = "Number-WithError";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Number-WithError-1.01.tar.gz";
      sha256 = "0m7my372rcj2d3j8xvhqdlhnnvxqabasvpvvhdkyli3qgrra1xnz";
    };
    propagatedBuildInputs = [ ParamsUtil prefork ];
    buildInputs = [ TestLectroTest ];
    meta = {
      description = "Numbers with error propagation and scientific rounding";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NTLM = buildPerlPackage {
    pname = "NTLM";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz";
      sha256 = "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.pSub ];
    };
  };

  ObjectAccessor = buildPerlPackage {
    pname = "Object-Accessor";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz";
      sha256 = "76cb824a27b6b4e560409fcf6fd5b3bfbbd38b72f1f3d37ed0b54bd9c0baeade";
    };
    meta = {
      description = "Per object accessors";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectEvent = buildPerlPackage rec {
    pname = "Object-Event";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EL/ELMEX/${pname}-${version}.tar.gz";
      sha256 = "ab6bb80508f4fddaf2d51b20ca876aab038582a86b5228e6435411348af53c82";
    };
    propagatedBuildInputs = [ AnyEvent commonsense ];
    meta = {
      description = "A class that provides an event callback interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectInsideOut = buildPerlModule {
    pname = "Object-InsideOut";
    version = "4.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/Object-InsideOut-4.05.tar.gz";
      sha256 = "1i6aif37ji91nsyncp5d0d3q29clf009sxdn1rz38917hai6rzcx";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Comprehensive inside-out object support module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectPad = buildPerlModule {
    pname = "Object-Pad";
    version = "0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Object-Pad-0.68.tar.gz";
      sha256 = "sha256-xN5jBIQxMJZNrskozF99HphTnu/X7azHvn4Yg0XhnXE=";
    };
    buildInputs = [ TestFatal TestRefcount ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    propagatedBuildInputs = [ XSParseKeyword XSParseSublike ];
    meta = {
      description = "A simple syntax for lexical field-based objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  ObjectSignature = buildPerlPackage {
    pname = "Object-Signature";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Object-Signature-1.08.tar.gz";
      sha256 = "12k90c19ly93ib1p6sm3k7sbnr2h5dbywkdmnff2ngm99p4m68c4";
    };
    meta = {
      description = "Generate cryptographic signatures for objects";
      homepage = "https://github.com/karenetheridge/Object-Signature";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  OggVorbisHeaderPurePerl = buildPerlPackage {
    pname = "Ogg-Vorbis-Header-PurePerl";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVECROSS/Ogg-Vorbis-Header-PurePerl-1.05.tar.gz";
      sha256 = "0gm5zl1zdi7wra64qz5mm93rkhypwvmaccvcn2k24w9dyh43h7aj";
    };

    # The testing mechanism is erorrneous upstream. See http://matrix.cpantesters.org/?dist=Ogg-Vorbis-Header-PurePerl+1.0
    doCheck = false;
    meta = {
      description = "Access Ogg Vorbis info and comment fields";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  OLEStorage_Lite = buildPerlPackage {
    pname = "OLE-Storage_Lite";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/OLE-Storage_Lite-0.20.tar.gz";
      sha256 = "1fpqhhgb8blj4hhs97fsbnbhk29s9yms057a9s9yl20f3hbsc65b";
    };
    meta = {
      description = "Read and write OLE storage files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Opcodes = buildPerlPackage {
    pname = "Opcodes";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Opcodes-0.14.tar.gz";
      sha256 = "7f7365447e4d1c5b87b43091448f0488e67c9f036b26c022a5409cd73d343893";
    };
    meta = {
      description = "More Opcodes information from opnames.h and opcode.h";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  OpenAPIClient = buildPerlPackage rec {
    pname = "OpenAPI-Client";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHTHORSEN/OpenAPI-Client-1.04.tar.gz";
      sha256 = "sha256-szo5AKzdLO5hAHu5MigNjDzslJkpnUNyud+Yd0vXTAo=";
    };
    propagatedBuildInputs = [ MojoliciousPluginOpenAPI ];
    meta = {
      description = "A client for talking to an Open API powered server";
      homepage = "https://github.com/jhthorsen/openapi-client";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  OpenGL = buildPerlPackage rec {
    pname = "OpenGL";
    version = "0.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHM/OpenGL-0.70.tar.gz";
      sha256 = "1q3lz168q081iwl9jg21fbzhp9la79gav9mv6nmh2jab83s2l3mj";
    };

    # FIXME: try with libGL + libGLU instead of libGLU libGL
    buildInputs = [ pkgs.libGLU pkgs.libGL pkgs.libGLU pkgs.freeglut pkgs.xorg.libX11 pkgs.xorg.libXi pkgs.xorg.libXmu pkgs.xorg.libXext pkgs.xdummy ];

    patches = [ ../development/perl-modules/perl-opengl.patch ];

    configurePhase = ''
      substituteInPlace Makefile.PL \
        --replace "@@libpaths@@" '${lib.concatStringsSep "\n" (map (f: "-L${f}/lib") buildInputs)}'

      cp -v ${../development/perl-modules/perl-opengl-gl-extensions.txt} utils/glversion.txt

      perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags
    '';

    doCheck = false;
  };

  OpenOfficeOODoc = buildPerlPackage {
    pname = "OpenOffice-OODoc";
    version = "2.125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMGDOC/OpenOffice-OODoc-2.125.tar.gz";
      sha256 = "1dnsj63svxq0hi3aci4x7binql8kr754inlkks5jmi4k0sblh561";
    };
    propagatedBuildInputs = [ ArchiveZip XMLTwig ];
    meta = {
      description = "The Perl Open OpenDocument Connector";
      license = with lib.licenses; [ lgpl21 ];
      maintainers = [ maintainers.wentasah ];
    };
  };

  NetOpenIDCommon = buildPerlPackage {
    pname = "Net-OpenID-Common";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/Net-OpenID-Common-1.20.tar.gz";
      sha256 = "1jdbkp18ka2m4akjp9b0dbw2lqnzgwpq435cnh6hwwa79bbrfkmb";
    };
    propagatedBuildInputs = [ CryptDHGMP XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage {
    pname = "Net-OpenID-Consumer";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/Net-OpenID-Consumer-1.18.tar.gz";
      sha256 = "0f2g6sczvbpyjmy14pabmrj0d48hlsndqswrvmqk1161wxpkh70f";
    };
    propagatedBuildInputs = [ JSON NetOpenIDCommon ];
    buildInputs = [ CGI ];
  };

  NetOpenSSH = buildPerlPackage {
    pname = "Net-OpenSSH";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Net-OpenSSH-0.80.tar.gz";
      sha256 = "1cxfipxfmgzfwpn1i0gf39gbrr56i2aqb0i9593n3czjgmjr7q7y";
    };
    meta = {
      description = "Perl SSH client package implemented on top of OpenSSH";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetZooKeeper = buildPerlPackage {
    pname = "Net-ZooKeeper";
    version = "0.42pre";
    src = fetchFromGitHub {
      owner = "mark-5";
      repo = "p5-net-zookeeper";
      rev = "66e1a360aff9c39af728c36092b540a4b6045f70";
      sha256 = "0xl8lcv9gfv0nn8vrrxa4az359whqdhmzw4r51nn3add8pn3s9ip";
    };
    buildInputs = [ pkgs.zookeeper_mt ];
    # fix "error: format not a string literal and no format arguments [-Werror=format-security]"
    hardeningDisable = [ "format" ];
    # Make the async API accessible
    NIX_CFLAGS_COMPILE = "-DTHREADED";
    NIX_CFLAGS_LINK = "-L${pkgs.zookeeper_mt.out}/lib -lzookeeper_mt";
    # Most tests are skipped as no server is available in the sandbox.
    # `t/35_log.t` seems to suffer from a race condition; remove it.  See
    # https://github.com/NixOS/nixpkgs/pull/104889#issuecomment-737144513
    preCheck = ''
      rm t/35_log.t
    '' + lib.optionalString stdenv.isDarwin ''
      rm t/30_connect.t
      rm t/45_class.t
    '';
    meta = {
      homepage = "https://github.com/mark-5/p5-net-zookeeper";
      license = with lib.licenses; [ asl20 ];
      maintainers = teams.deshaw.members ++ [ maintainers.ztzg ];
    };
  };

  PackageConstants = buildPerlPackage {
    pname = "Package-Constants";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Package-Constants-0.06.tar.gz";
      sha256 = "0b58be78706ccc4e4bd9bbad41767470427fd7b2cfad749489de101f85bc5df5";
    };
    meta = {
      description = "List constants defined in a package";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageDeprecationManager = buildPerlPackage {
    pname = "Package-DeprecationManager";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.17.tar.gz";
      sha256 = "1d743ada482b5c9871d894966e87d4c20edc96931bb949fb2638b000ddd6684b";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ PackageStash ParamsUtil SubInstall SubName ];
    meta = {
      description = "Manage deprecation warnings for your distribution";
      homepage = "http://metacpan.org/release/Package-DeprecationManager";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  PatchReader = buildPerlPackage {
    pname = "PatchReader";
    version = "0.9.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMANNERM/PatchReader-0.9.6.tar.gz";
      sha256 = "b8de37460347bb5474dc01916ccb31dd2fe0cd92242c4a32d730e8eb087c323c";
    };
    meta = {
      description = "Utilities to read and manipulate patches and CVS";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  PackageStash = buildPerlPackage {
    pname = "Package-Stash";
    version = "0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Package-Stash-0.39.tar.gz";
      sha256 = "1d914qnnpiyimfi57crzb6r31nl613g2k48frs9h821f25azarci";
    };
    buildInputs = [ CPANMetaCheck TestFatal TestNeeds TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleImplementation ];
    meta = {
      description = "Routines for manipulating stashes";
      homepage = "https://github.com/moose/Package-Stash";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "package-stash-conflicts";
    };
  };

  PackageStashXS = buildPerlPackage {
    pname = "Package-Stash-XS";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Package-Stash-XS-0.29.tar.gz";
      sha256 = "1akqk10qxwk798qppajqbczwmhy4cs9g0lg961m3vq218slnnryk";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      description = "Faster and more correct implementation of the Package::Stash API";
      homepage = "https://github.com/moose/Package-Stash-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Pango = buildPerlPackage {
    pname = "Pango";
    version = "1.227";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Pango-1.227.tar.gz";
      sha256 = "0wdcidnfnb6nm79fzfs39ivawj3x8m98a147fmcxgv1zvwia9c1l";
    };
    buildInputs = [ pkgs.pango ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      description = "Layout and render international text";
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  ParallelForkManager = buildPerlPackage {
    pname = "Parallel-ForkManager";
    version = "2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz";
      sha256 = "c1b2970a8bb666c3de7caac4a8f4dbcc043ab819bbc337692ec7bf27adae4404";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ Moo ];
    meta = {
      description = "A simple parallel processing fork manager";
      homepage = "https://github.com/dluxhu/perl-parallel-forkmanager";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParallelPipes = buildPerlModule {
    pname = "Parallel-Pipes";
    version = "0.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Parallel-Pipes-0.102.tar.gz";
      sha256 = "sha256-JjZfgQXcYGsUC9HUX41w1cMFQ5D3Xk/bdISj5ZHL+pc=";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Parallel processing using pipe(2) for communication and synchronization";
      homepage = "https://github.com/skaji/Parallel-Pipes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  ParallelPrefork = buildPerlPackage {
    pname = "Parallel-Prefork";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Parallel-Prefork-0.18.tar.gz";
      sha256 = "f1c1f48f1ae147a58bc88f9cb2f570d6bb15ea4c0d589abd4c3084ddc961596e";
    };
    buildInputs = [ TestRequires TestSharedFork ];
    propagatedBuildInputs = [ ClassAccessorLite ListMoreUtils ProcWait3 ScopeGuard SignalMask ];
    meta = {
      description = "A simple prefork server framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsClassify = buildPerlModule {
    pname = "Params-Classify";
    version = "0.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Params-Classify-0.015.tar.gz";
      sha256 = "052r198xyrsv8wz21gijdigz2cgnidsa37nvyfzdiz4rv1fc33ir";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
  };

  ParamsUtil = buildPerlPackage {
    pname = "Params-Util";
    version = "1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/Params-Util-1.102.tar.gz";
      sha256 = "00kl154zisf2zsl8yl6xa6yw54nhd9cja5d5fyigs96vhasb36s9";
    };
    meta = {
      description = "Simple, compact and correct param-checking functions";
      homepage = "https://metacpan.org/release/Params-Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsValidate = buildPerlModule {
    pname = "Params-Validate";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Params-Validate-1.30.tar.gz";
      sha256 = "04nqfgib2w529na6wjfxfrp54zdyyn91yb40iizd099i7mc3afls";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleImplementation ];
    perlPreHook = "export LD=$CC";
    meta = {
      description = "Validate method/function parameters";
      homepage = "https://metacpan.org/release/Params-Validate";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ParamsValidationCompiler = buildPerlPackage {
    pname = "Params-ValidationCompiler";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.30.tar.gz";
      sha256 = "1jqn1l4m4i341g14kmjsf3a1kn7vv6z89cix0xjjgr1v70iywnyw";
    };
    propagatedBuildInputs = [ EvalClosure ExceptionClass ];
    buildInputs = [ Specio Test2PluginNoWarnings Test2Suite TestWithoutModule ];
    meta = {
      description = "Build an optimized subroutine parameter validator once, use it forever";
      homepage = "http://metacpan.org/release/Params-ValidationCompiler";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  Paranoid = buildPerlPackage {
    pname = "Paranoid";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORLISS/Paranoid/Paranoid-2.07.tar.gz";
      sha256 = "b55cfd8c6d5f181e218efd012f711a50cd14e4dbc8804650b95477178f43b7fc";
    };
    patches = [ ../development/perl-modules/Paranoid-blessed-path.patch ];
    preConfigure = ''
      # Capture the path used when compiling this module as the "blessed"
      # system path, analogous to the module's own use of '/bin:/sbin'.
      sed -i "s#__BLESSED_PATH__#${pkgs.coreutils}/bin#" lib/Paranoid.pm t/01_init_core.t
    '';
    meta = {
      description = "General function library for safer, more secure programming";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  PARDist = buildPerlPackage {
    pname = "PAR-Dist";
    version = "0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSCHUPP/PAR-Dist-0.51.tar.gz";
      sha256 = "1y6z6fpp6wclmk4x3nzsxv869i56668y1i74828g72dnz4nhchnj";
    };
    meta = {
      description = "Create and manipulate PAR distributions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PAUSEPermissions = buildPerlPackage {
    pname = "PAUSE-Permissions";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/PAUSE-Permissions-0.17.tar.gz";
      sha256 = "021ink414w4mdk6rd54cc1f23kfqg0zk4njx4ngr0bw3wc6r4kks";
    };
    propagatedBuildInputs = [ FileHomeDir HTTPDate MooXOptions TimeDurationParse ];
    buildInputs = [ PathTiny ];
    meta = {
      description = "Interface to PAUSE's module permissions file (06perms.txt)";
      homepage = "https://github.com/neilb/PAUSE-Permissions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pause-permissions";
    };
  };

  Parent = buildPerlPackage {
    pname = "parent";
    version = "0.238";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/parent-0.238.tar.gz";
      sha256 = "1lfjqjxsvgpsn6ycah4z0qygkykj4v8ca3cdki61k2p2ygg8zx9q";
    };
  };

  ParseDebControl = buildPerlPackage {
    pname = "Parse-DebControl";
    version = "2.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYBONCI/Parse-DebControl-2.005.tar.gz";
      sha256 = "0ad78qri4sg9agghqdm83xsjgks94yvffs23kppy7mqjy8gwwjxn";
    };
    propagatedBuildInputs = [ IOStringy LWP ];
    meta = with lib; {
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseIRC = buildPerlPackage {
    pname = "Parse-IRC";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Parse-IRC-1.22.tar.gz";
      sha256 = "457b09897f37d38a7054f9563247365427fe24101622ed4c7f054723a45b58d5";
    };
    meta = {
      description = "A parser for the IRC protocol";
      homepage = "https://github.com/bingos/parse-irc";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  ParseLocalDistribution = buildPerlPackage {
    pname = "Parse-LocalDistribution";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Parse-LocalDistribution-0.19.tar.gz";
      sha256 = "17p92nj4k3acrqqjnln1j5x8hbra9jkx5hdcybrq37ld9qnc62vb";
    };
    propagatedBuildInputs = [ ParsePMFile ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestUseAllModules ];
    meta = {
      description = "Parses local .pm files as PAUSE does";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParsePlainConfig = buildPerlPackage {
    pname = "Parse-PlainConfig";
    version = "3.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORLISS/Parse-PlainConfig/Parse-PlainConfig-3.05.tar.gz";
      sha256 = "6b78a8552398b0d2d7063505c93b3cfed0432c5b2cf6e00b8e51febf411c1efa";
    };
    propagatedBuildInputs = [ ClassEHierarchy Paranoid ];
    meta = {
      description = "Parser/Generator of human-readable conf files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  ParsePMFile = buildPerlPackage {
    pname = "Parse-PMFile";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Parse-PMFile-0.43.tar.gz";
      sha256 = "08q6j1lw5l49yhzx8gm4zal7zp1gk58iacpda86cyf27403yhqdy";
    };
    buildInputs = [ ExtUtilsMakeMakerCPANfile ];
    meta = {
      description = "Parses .pm file as PAUSE does";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseRecDescent = buildPerlModule {
    pname = "Parse-RecDescent";
    version = "1.967015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz";
      sha256 = "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37";
    };
    meta = {
      description = "Generate Recursive-Descent Parsers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseSyslog = buildPerlPackage {
    pname = "Parse-Syslog";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSCHWEI/Parse-Syslog-1.10.tar.gz";
      sha256 = "659a2145441ef36d9835decaf83da308fcd03f49138cb3d90928e8bfc9f139d9";
    };
  };

  ParserMGC = buildPerlModule {
    pname = "Parser-MGC";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Parser-MGC-0.16.tar.gz";
      sha256 = "14bv2fwg59q4s3kv0vf11hh222anlm181ig87cph2f68y32n2i3l";
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
    meta = {
      description = "Build simple recursive-descent parsers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseYapp = buildPerlPackage {
    pname = "Parse-Yapp";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz";
      sha256 = "1r8kbyk0qd4ficmabj753kjpq0ib0csk01169w7jxflg62cfj41q";
    };
    meta = {
      description = "Perl extension for generating and using LALR parsers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "yapp";
    };
  };

  PathClass = buildPerlModule {
    pname = "Path-Class";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.37.tar.gz";
      sha256 = "1kj8q8dmd8jci94w5arav59nkp0pkxrkliz4n8n6yf02hsa82iv5";
    };
    meta = {
      description = "Cross-platform path specification manipulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathDispatcher = buildPerlPackage {
    pname = "Path-Dispatcher";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Path-Dispatcher-1.08.tar.gz";
      sha256 = "79a9f61c27408b4fd1ed234dac246974ddeafa7fe635a18fe41ec7783130ae2a";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    propagatedBuildInputs = [ Moo MooXTypeTiny TryTiny TypeTiny ];
    meta = {
      description = "Flexible and extensible dispatch";
      homepage = "https://github.com/karenetheridge/Path-Dispatcher";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathIteratorRule = buildPerlPackage {
    pname = "Path-Iterator-Rule";
    version = "1.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Iterator-Rule-1.014.tar.gz";
      sha256 = "19mik0r5v1cmxfxm0h4lwqyj0nmq6jgnvvq96hqcjgylpvc02x1z";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob TryTiny ];
    buildInputs = [ Filepushd PathTiny TestDeep TestFilename ];
    meta = {
      description = "Iterative, recursive file finder";
      homepage = "https://github.com/dagolden/Path-Iterator-Rule";
      license = with lib.licenses; [ asl20 ];
    };
  };

  PathTiny = buildPerlPackage {
    pname = "Path-Tiny";
    version = "0.114";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.114.tar.gz";
      sha256 = "cd0f88f37a58fc3667ec065767fe01e73ee6efa18a112bfd3508cf6579ca00e1";
    };
    preConfigure =
      ''
        substituteInPlace lib/Path/Tiny.pm --replace 'use File::Spec 3.40' \
          'use File::Spec 3.39'
      '';
    # This appears to be currently failing tests, though I don't know why.
    # -- ocharles
    doCheck = false;
    meta = {
      description = "File path utility";
      homepage = "https://github.com/dagolden/Path-Tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  PathTools = buildPerlPackage {
    pname = "PathTools";
    version = "3.75";
    preConfigure = ''
      substituteInPlace Cwd.pm --replace '/usr/bin/pwd' '${pkgs.coreutils}/bin/pwd'
    '';
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XS/XSAWYERX/PathTools-3.75.tar.gz";
      sha256 = "a558503aa6b1f8c727c0073339081a77888606aa701ada1ad62dd9d8c3f945a2";
    };
  };

  PBKDF2Tiny = buildPerlPackage {
    pname = "PBKDF2-Tiny";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/PBKDF2-Tiny-0.005.tar.gz";
      sha256 = "b4e21dc59b30265eaaa41b705087ec03447d9c655a14ac40ff46e4de29eabf8e";
    };
    meta = {
      description = "Minimalist PBKDF2 (RFC 2898) with HMAC-SHA1 or HMAC-SHA2";
      homepage = "https://github.com/dagolden/PBKDF2-Tiny";
      license = with lib.licenses; [ asl20 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  pcscperl = buildPerlPackage {
    pname = "pcsc-perl";
    version = "1.4.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WH/WHOM/pcsc-perl-1.4.14.tar.bz2";
      sha256 = "17f6i16jv6ci6459vh6y3sz94vgcvykjjszcl4xsykryakjvf8i7";
    };
    buildInputs = [ pkgs.pcsclite ];
    nativeBuildInputs = [ pkgs.pkg-config ];
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.pcsclite}/lib -lpcsclite";
    # tests fail; look unfinished
    doCheck = false;
    meta = {
      description = "Communicate with a smart card using PC/SC";
      homepage = "http://ludovic.rousseau.free.fr/softwares/pcsc-perl/";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = with maintainers; [ abbradar ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.pcscperl.x86_64-darwin
    };
  };

  PDFAPI2 = buildPerlPackage {
    pname = "PDF-API2";
    version = "2.042";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SS/SSIMMS/PDF-API2-2.042.tar.gz";
      sha256 = "0p9wsnn60mcxr4032ahai0d56x8gw76ydym2l4qxq086a10jk6db";
    };
    buildInputs = [ TestException TestMemoryCycle ];
    propagatedBuildInputs = [ FontTTF ];
    meta = {
      description = "Create, modify, and examine PDF files";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  PDFBuilder = buildPerlPackage {
    pname = "PDF-Builder";
    version = "3.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMPERRY/PDF-Builder-3.022.tar.gz";
      sha256 = "SCskaQxxhfLn+7r5pIKz0SieJduAC/SPKVn1Epl3yjE=";
    };
    checkInputs = [ TestException TestMemoryCycle ];
    propagatedBuildInputs = [ FontTTF ];
    meta = {
      description = "Facilitates the creation and modification of PDF files";
      homepage = "https://metacpan.org/pod/PDF::Builder";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  PDL = buildPerlPackage rec {
    pname = "PDL";
    version = "2.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/PDL-2.025.tar.gz";
      sha256 = "1mlab95ij5a4q5pkrmgfas8x46cms2vqwzyjvaajsxr7mmz1cnhv";
    };
    patchPhase = ''
      substituteInPlace perldl.conf \
        --replace 'POSIX_THREADS_LIBS => undef' 'POSIX_THREADS_LIBS => "-L${pkgs.glibc.dev}/lib"' \
        --replace 'POSIX_THREADS_INC  => undef' 'POSIX_THREADS_INC  => "-I${pkgs.glibc.dev}/include"' \
        --replace 'WITH_MINUIT => undef' 'WITH_MINUIT => 0' \
        --replace 'WITH_SLATEC => undef' 'WITH_SLATEC => 0' \
        --replace 'WITH_HDF => undef' 'WITH_HDF => 0' \
        --replace 'WITH_GD => undef' 'WITH_GD => 0' \
        --replace 'WITH_PROJ => undef' 'WITH_PROJ => 0'
    '';

    nativeBuildInputs = with pkgs; [ autoPatchelfHook libGL.dev glibc.dev mesa_glu.dev ];

    buildInputs = [ DevelChecklib TestDeep TestException TestWarn ] ++
                  (with pkgs; [ gsl freeglut xorg.libXmu xorg.libXi ]);

    propagatedBuildInputs = [
      AstroFITSHeader
      ConvertUU
      ExtUtilsF77
      FileMap
      Inline
      InlineC
      ListMoreUtils
      ModuleCompile
      OpenGL
      PodParser
      TermReadKey
    ];

    meta = {
      description = "Perl Data Language";
      homepage = "http://pdl.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pdl2";
      platforms = lib.platforms.linux;
    };
  };

  Pegex = buildPerlPackage {
    pname = "Pegex";
    version = "0.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Pegex-0.75.tar.gz";
      sha256 = "4dc8d335de80b25247cdb3f946f0d10d9ba0b3c34b0ed7d00316fd068fd05edc";
    };
    buildInputs = [ TestPod TieIxHash ];
    propagatedBuildInputs = [ FileShareDirInstall XXX ];
    meta = {
      description = "Acmeist PEG Parser Framework";
      homepage = "https://github.com/ingydotnet/pegex-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerconaToolkit = callPackage ../development/perl-modules/Percona-Toolkit { };

  Perl5lib = buildPerlPackage {
    pname = "perl5lib";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/perl5lib-1.02.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  Perlosnames = buildPerlPackage {
    pname = "Perl-osnames";
    version = "0.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/Perl-osnames-0.122.tar.gz";
      sha256 = "7075939d747e375178d00348d00c52ff9db2cebb18bae7473dcb09df825118a0";
    };
    meta = {
      description = "List possible $^O ($OSNAME) values, with description";
      homepage = "https://metacpan.org/release/Perl-osnames";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlCritic = buildPerlModule {
    pname = "Perl-Critic";
    version = "1.140";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Perl-Critic-1.140.tar.gz";
      sha256 = "1nzxpn71mrpp85yxrxlraj52q2skvf9ja887ls11d57h6smg1vmz";
    };
    buildInputs = [ TestDeep ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [ BKeywords ConfigTiny FileWhich ListMoreUtils ModulePluggable PPIxQuoteLike PPIxRegexp PPIxUtilities PerlTidy PodSpell StringFormat ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/perlcritic
    '';
    meta = {
      description = "Critique Perl source code for best-practices";
      homepage = "http://perlcritic.com";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perlcritic";
    };
  };

  PerlCriticCommunity = buildPerlModule {
    pname = "Perl-Critic-Community";
    version = "1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Perl-Critic-Community-v1.0.0.tar.gz";
      sha256 = "311b775da4193e9de94cf5225e993cc54dd096ae1e7ef60738cdae1d9b8854e7";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ PPI PathTiny PerlCritic PerlCriticPolicyVariablesProhibitLoopOnHash PerlCriticPulp ];
    meta = {
      description = "Community-inspired Perl::Critic policies";
      homepage = "https://github.com/Grinnz/Perl-Critic-Community";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  PerlCriticMoose = buildPerlPackage rec {
    pname = "Perl-Critic-Moose";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Perl-Critic-Moose-${version}.tar.gz";
      sha256 = "0092z583c3q3gqry693ck3ibkzby04a1g8lpw9zz2hr6qhi8xssj";
    };
    propagatedBuildInputs = [ PerlCritic Readonly namespaceautoclean ];
    meta = {
      description = "Policies for Perl::Critic concerned with using Moose";
      homepage = "http://metacpan.org/release/Perl-Critic-Moose";
      license = with lib.licenses; [ artistic1 ]];
    };
  };

  PerlCriticPolicyVariablesProhibitLoopOnHash = buildPerlPackage {
    pname = "Perl-Critic-Policy-Variables-ProhibitLoopOnHash";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XS/XSAWYERX/Perl-Critic-Policy-Variables-ProhibitLoopOnHash-0.008.tar.gz";
      sha256 = "12f5f0be96ea1bdc7828058577bd1c5c63ca23c17fac9c3709452b3dff5b84e0";
    };
    propagatedBuildInputs = [ PerlCritic ];
    meta = {
      description = "Don't write loops on hashes, only on keys and values of hashes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlCriticPulp = buildPerlPackage {
    pname = "Perl-Critic-Pulp";
    version = "99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/Perl-Critic-Pulp-99.tar.gz";
      sha256 = "b8fda842fcbed74d210257c0a284b6dc7b1d0554a47a3de5d97e7d542e23e7fe";
    };
    propagatedBuildInputs = [ IOString ListMoreUtils PPI PerlCritic PodMinimumVersion ];
    meta = {
      description = "Some add-on policies for Perl::Critic";
      homepage = "http://user42.tuxfamily.org/perl-critic-pulp/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  PerlDestructLevel = buildPerlPackage {
    pname = "Perl-Destruct-Level";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/Perl-Destruct-Level-0.02.tar.gz";
      sha256 = "0fyiysrq874ncscgdjg522fs29gvqads6ynyhwxwwq1b545srd20";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  PerlIOLayers = buildPerlModule {
    pname = "PerlIO-Layers";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/PerlIO-Layers-0.012.tar.gz";
      sha256 = "1psaq3kwlk7g9rxvgsacfjk2mh6cscqf4xl7ggfkzfrnz91aabal";
    };
    perlPreHook = "export LD=$CC";
    meta = {
      description = "Querying your filehandle's capabilities";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOeol = buildPerlPackage {
    pname = "PerlIO-eol";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/PerlIO-eol-0.17.tar.gz";
      sha256 = "1fayp27vcmypqyzcd4003036h3g5zy6jk1ia25frdca58pzcpk6f";
    };
  };

  PerlIOgzip = buildPerlPackage {
    pname = "PerlIO-gzip";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz";
      sha256 = "4848679a3f201e3f3b0c5f6f9526e602af52923ffa471a2a3657db786bd3bdc5";
    };
    buildInputs = [ pkgs.zlib ];
    NIX_CFLAGS_LINK = "-L${pkgs.zlib.out}/lib -lz";
    meta = {
      description = "Perl extension to provide a PerlIO layer to gzip/gunzip";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOutf8_strict = buildPerlPackage {
    pname = "PerlIO-utf8_strict";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.008.tar.gz";
      sha256 = "0ngl9p3kh7as1yx1az66yhbxhrh664vzhl3qnlhx9iywa3nqsyaz";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Fast and correct UTF-8 IO";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOviadynamic = buildPerlPackage {
    pname = "PerlIO-via-dynamic";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/PerlIO-via-dynamic-0.14.tar.gz";
      sha256 = "0jbb3xpbqzmr625blvnjszd69l3cwxzi7bhmkj5x48dgv3s7mkca";
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    pname = "PerlIO-via-symlink";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz";
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };

    buildInputs = [ ModuleInstall ];

    postPatch = ''
      # remove outdated inc::Module::Install included with module
      # causes build failure for perl5.18+
      rm -r  inc
    '';
  };

  PerlIOviaTimeout = buildPerlModule {
    pname = "PerlIO-via-Timeout";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.32.tar.gz";
      sha256 = "9278f9ef668850d913d98fa4c0d7e7d667cff3503391f4a4eae73a246f2e7916";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork TestTCP ];
    meta = {
      description = "A PerlIO layer that adds read & write timeout to a handle";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  perlldap = buildPerlPackage {
    pname = "perl-ldap";
    version = "0.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARSCHAP/perl-ldap-0.66.tar.gz";
      sha256 = "09263ce6166e80c98d689d41d09995b813389fd069b784601f6dc57f8e2b4102";
    };
    buildInputs = [ TextSoundex ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "LDAP client library";
      homepage = "http://ldap.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  PerlMagick = ImageMagick; # added 2021-08-02
  ImageMagick = buildPerlPackage rec {
    pname = "Image-Magick";
    version = "7.0.11-1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JC/JCRISTY/Image-Magick-${version}.tar.gz";
      sha256 = "sha256-c0vuFmVq9bypQABBnZElGIQrpkYKwtD/B+PloBAycuI=";
    };
    buildInputs = [ pkgs.imagemagick ];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick.dev}/include/ImageMagick";|' Makefile.PL
      '';
  };

  PerlTidy = buildPerlPackage rec {
    pname = "Perl-Tidy";
    version = "20211029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/Perl-Tidy-20211029.tar.gz";
      sha256 = "1nhfi3gb8gif9p34m4ycqw0k8992yy42c21hk9b99l2pdbiv20zc";
    };
    meta = {
      description = "Indent and reformat perl scripts";
      license = with lib.licenses; [ gpl2Plus ];
      mainProgram = "perltidy";
    };
  };

  PHPSerialization = buildPerlPackage {
    pname = "PHP-Serialization";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/PHP-Serialization-0.34.tar.gz";
      sha256 = "0yphqsgg7zrar2ywk2j2fnjxmi9rq32yf0p5ln8m9fmfx4kd84mr";
    };
    meta = {
      description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
      license = with lib.licenses; [ unfree ];
    };
  };

  PkgConfig = buildPerlPackage rec {
    pname = "PkgConfig";
    version = "0.25026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/PkgConfig-0.25026.tar.gz";
      sha256 = "1862hzlkibqsgynrnwg43acycp4rlsv19gsybjwq39nnqb9mxfjd";
    };
    # support cross-compilation by simplifying the way we get version during build
    postPatch = ''
      substituteInPlace Makefile.PL --replace \
        'do { require "./lib/PkgConfig.pm"; $PkgConfig::VERSION; }' \
        '"${version}"'
    '';
    meta = {
      description = "Pure-Perl Core-Only replacement for pkg-config";
      homepage = "https://metacpan.org/pod/PkgConfig";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
      mainProgram = "ppkg-config";
    };
  };

  Plack = buildPerlPackage {
    pname = "Plack";
    version = "1.0048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-1.0048.tar.gz";
      sha256 = "19j2wnzsl0wl31ww4c2p1pahidwsr9hnylm2as8qadxl35gg5x9h";
    };
    buildInputs = [ AuthenSimplePasswd CGIEmulatePSGI FileShareDirInstall HTTPRequestAsCGI HTTPServerSimplePSGI IOHandleUtil LWP LWPProtocolhttp10 LogDispatchArray MIMETypes TestMockTimeHiRes TestRequires TestSharedFork TestTCP ];
    propagatedBuildInputs = [ ApacheLogFormatCompiler CookieBaker DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HTTPEntityParser HTTPHeadersFast HTTPMessage TryTiny ];
    meta = {
      description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
      homepage = "https://github.com/plack/Plack";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "plackup";
    };
  };

  PlackAppProxy = buildPerlPackage {
    pname = "Plack-App-Proxy";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEDO/Plack-App-Proxy-0.29.tar.gz";
      sha256 = "03x6yb6ykz1ms90jp1s0pq19yplf7wswljvhzqkr16jannfrmah4";
    };
    propagatedBuildInputs = [ AnyEventHTTP LWP Plack ];
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "Proxy requests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareAuthDigest = buildPerlModule {
    pname = "Plack-Middleware-Auth-Digest";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-Auth-Digest-0.05.tar.gz";
      sha256 = "1sqm23kfsl3ac4060zcclc3r86x1vxzhsgvgzg6mxk9njj93zgcs";
    };
    propagatedBuildInputs = [ DigestHMAC Plack ];
    buildInputs = [ LWP ModuleBuildTiny TestSharedFork TestTCP ];
    meta = {
      description = "Digest authentication";
      homepage = "https://github.com/miyagawa/Plack-Middleware-Auth-Digest";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareConsoleLogger = buildPerlModule {
    pname = "Plack-Middleware-ConsoleLogger";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ConsoleLogger-0.05.tar.gz";
      sha256 = "1ngvhwdw9ll4cwnvf0i89ppa9pbyiwng6iba04scrqjda353lrsm";
    };
    propagatedBuildInputs = [ JavaScriptValueEscape Plack ];
    buildInputs = [ ModuleBuildTiny TestRequires ];
    meta = {
      description = "Write logs to Firebug or Webkit Inspector";
      homepage = "https://github.com/miyagawa/Plack-Middleware-ConsoleLogger";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareDebug = buildPerlModule {
    pname = "Plack-Middleware-Debug";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-Debug-0.18.tar.gz";
      sha256 = "192ef79e521c90c6eff6f4149ad2e4bfc911d2c95df78935855e90d659e9ac9a";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ ClassMethodModifiers DataDump DataDumperConcise Plack TextMicroTemplate ];
    meta = {
      description = "Display information about the current request/response";
      homepage = "https://github.com/miyagawa/Plack-Middleware-Debug";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareDeflater = buildPerlPackage {
    pname = "Plack-Middleware-Deflater";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Plack-Middleware-Deflater-0.12.tar.gz";
      sha256 = "0xf2visi16hgwgyp9q0cjr10ikbn474hjia5mj8mb2scvbkrbni8";
    };
    propagatedBuildInputs = [ Plack ];
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "Compress response body with Gzip or Deflate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareFixMissingBodyInRedirect = buildPerlPackage {
    pname = "Plack-Middleware-FixMissingBodyInRedirect";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-FixMissingBodyInRedirect-0.12.tar.gz";
      sha256 = "6c22d069f5a57ac206d4659b28b8869bb9270640bb955efddd451dcc58cdb391";
    };
    propagatedBuildInputs = [ HTMLParser Plack ];
    meta = {
      description = "Plack::Middleware which sets body for redirect response, if it's not already set";
      homepage = "https://github.com/Sweet-kid/Plack-Middleware-FixMissingBodyInRedirect";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareHeader = buildPerlPackage {
    pname = "Plack-Middleware-Header";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHIBA/Plack-Middleware-Header-0.04.tar.gz";
      sha256 = "0pjxxbnilphn38s3mmv0fmg9q2hm4z02ngp2a1lxblzjfbzvkdjy";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Modify HTTP response headers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareMethodOverride = buildPerlPackage {
    pname = "Plack-Middleware-MethodOverride";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-MethodOverride-0.20.tar.gz";
      sha256 = "dbfb5a2efb48bfeb01cb3ae1e1c677e155dc7bfe210c7e7f221bae3cb6aab5f1";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Override REST methods to Plack apps via POST";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareRemoveRedundantBody = buildPerlPackage {
    pname = "Plack-Middleware-RemoveRedundantBody";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-RemoveRedundantBody-0.09.tar.gz";
      sha256 = "80d45f93d6b7290b0bd8b3cedd84a37fc501456cc3dec02ec7aad81c0018087e";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Plack::Middleware which removes body for HTTP response if it's not required";
      homepage = "https://github.com/upasana-me/Plack-Middleware-RemoveRedundantBody";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareReverseProxy = buildPerlPackage {
    pname = "Plack-Middleware-ReverseProxy";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ReverseProxy-0.16.tar.gz";
      sha256 = "0a512n62pnk5ayj3zdzyj50iy1qi8nwh6ygks2h7nrh7gp9k2jc7";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Supports app to run as a reverse proxy backend";
      homepage = "https://github.com/lopnor/Plack-Middleware-ReverseProxy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareSession = buildPerlModule {
    pname = "Plack-Middleware-Session";
    version = "0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-Session-0.33.tar.gz";
      sha256 = "1vm4a66civdzh7xvl5hy5wn1w8j1vndppwyz8ndh9n4as74s5yag";
    };
    propagatedBuildInputs = [ DigestHMAC Plack ];
    buildInputs = [ HTTPCookies LWP ModuleBuildTiny TestFatal TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "Middleware for session management";
      homepage = "https://github.com/plack/Plack-Middleware-Session";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackTestExternalServer = buildPerlPackage {
    pname = "Plack-Test-ExternalServer";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Plack-Test-ExternalServer-0.02.tar.gz";
      sha256 = "5baf5c57fe0c06412deec9c5abe7952ab8a04f8c47b4bbd8e9e9982268903ed0";
    };
    buildInputs = [ Plack TestSharedFork TestTCP ];
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Run HTTP tests on external live servers";
      homepage = "https://github.com/perl-catalyst/Plack-Test-ExternalServer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PLS = buildPerlPackage {
    pname = "PLS";
    version = "0.897";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MREISNER/PLS-0.897.tar.gz";
      sha256 = "0278anidj7bgassj32g20cbki2kkqakkr3axyq4k90nj4snw7p6x";
    };
    propagatedBuildInputs = [ Future IOAsync PPI PPR PathTiny PerlCritic PerlTidy PodMarkdown URI ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/pls
    '';
    meta = {
      description = "Perl Language Server";
      homepage = "https://github.com/FractalBoy/perl-language-server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.artturin ];
      mainProgram = "pls";
    };
  };

  Po4a = callPackage ../development/perl-modules/Po4a { };

  PodMinimumVersion = buildPerlPackage {
    pname = "Pod-MinimumVersion";
    version = "50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/Pod-MinimumVersion-50.tar.gz";
      sha256 = "0bd2812d9aacbd99bb71fa103a4bb129e955c138ba7598734207dc9fb67b5a6f";
    };
    propagatedBuildInputs = [ IOString PodParser ];
    meta = {
      description = "Determine minimum Perl version of POD directives";
      homepage = "http://user42.tuxfamily.org/pod-minimumversion/index.html";
      license = with lib.licenses; [ free ];
      mainProgram = "pod-minimumversion";
    };
  };

  POE = buildPerlPackage {
    pname = "POE";
    version = "1.368";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/POE-1.368.tar.gz";
      sha256 = "08g1vzxamqg0gmkirdcx7fycq3pwv9vbajc30qwqpm1n3rvdrcdp";
    };
    # N.B. removing TestPodLinkCheck from buildInputs because tests requiring
    # this module don't disable themselves when "run_network_tests" is
    # not present (see below).
    propagatedBuildInputs = [ pkgs.cacert IOPipely IOTty POETestLoops ];
    preCheck = ''
      set -x

      : Makefile.PL touches the following file as a "marker" to indicate
      : it should perform tests which use the network. Delete this file
      : for sandbox builds.
      rm -f run_network_tests

      : Certs are required if not running in a sandbox.
      export SSL_CERT_FILE=${pkgs.cacert.out}/etc/ssl/certs/ca-bundle.crt

      : The following flag enables extra tests not normally performed.
      export RELEASE_TESTING=1

      set +x
    '';
    meta = {
      description = "Portable, event-loop agnostic eventy networking and multitasking";
      homepage = "http://poe.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  POETestLoops = buildPerlPackage {
    pname = "POE-Test-Loops";
    version = "1.360";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/POE-Test-Loops-1.360.tar.gz";
      sha256 = "0yx4wsljfmdzsiv0ni98x6lw975cm82ahngbwqvzv60wx5pwkl5y";
    };
    meta = {
      description = "Reusable tests for POE::Loop authors";
      homepage = "http://search.cpan.org/dist/POE-Test-Loops";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
      mainProgram = "poe-gen-tests";
    };
  };

  PPI = buildPerlPackage {
    pname = "PPI";
    version = "1.270";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHALDU/PPI-1.270.tar.gz";
      sha256 = "622a698c781bb85d2bdf7bbfe040fe70d33b79774c9ae01fce2375dc73faf457";
    };
    buildInputs = [ ClassInspector TestDeep TestNoWarnings TestObject TestSubCalls ];
    propagatedBuildInputs = [ Clone IOString ParamsUtil TaskWeaken ];

    # Remove test that fails due to unexpected shebang after
    # patchShebang.
    preCheck = "rm t/03_document.t";

    meta = {
      description = "Parse, Analyze and Manipulate Perl (without perl)";
      homepage = "https://github.com/Perl-Critic/PPI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxQuoteLike = buildPerlModule {
    pname = "PPIx-QuoteLike";
    version = "0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/PPIx-QuoteLike-0.013.tar.gz";
      sha256 = "05qq5lk7a91jzn2vld906nvrpqbhxvy40s2qdymm5lkqha1k67ld";
    };
    propagatedBuildInputs = [ PPI Readonly ];
    meta = {
      description = "Parse Perl string literals and string-literal-like things";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxRegexp = buildPerlModule {
    pname = "PPIx-Regexp";
    version = "0.076";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/PPIx-Regexp-0.076.tar.gz";
      sha256 = "0jh1g83s4m7qlj6c99myvbqayfd9nkff37y0chvlp33j4a9psq0h";
    };
    propagatedBuildInputs = [ PPI ];
    meta = {
      description = "Parse regular expressions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxUtilities = buildPerlModule {
    pname = "PPIx-Utilities";
    version = "1.001000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EL/ELLIOTJS/PPIx-Utilities-1.001000.tar.gz";
      sha256 = "03a483386fd6a2c808f09778d44db06b02c3140fb24ba4bf12f851f46d3bcb9b";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ExceptionClass PPI Readonly ];
    meta = {
      description = "Extensions to PPI|PPI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPR = buildPerlPackage {
    pname = "PPR";
    version = "0.000028";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/PPR-0.000028.tar.gz";
      sha256 = "1adrd189rnfl1fgv14inchvrgjqjbpnviisqsz3y8ds3gisafzfk";
    };
    meta = {
      description = "Pattern-based Perl Recognizer";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.artturin ];
    };
  };

  ProcBackground = buildPerlPackage {
    pname = "Proc-Background";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NERDVANA/Proc-Background-1.21.tar.gz";
      sha256 = "91b6a5aeb841b1c313498c78fad08e37d17595702dc6205b5ad38ef69949b7ee";
    };
    meta = {
      description = "Run asynchronous child processes under Unix or Windows";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "timed-process";
    };
  };

  ProcProcessTable = buildPerlPackage {
    pname = "Proc-ProcessTable";
    version = "0.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JW/JWB/Proc-ProcessTable-0.59.tar.gz";
      sha256 = "f8cc5054d78c35a0ce39fb75430b4ef402e2a99013d2ec37e7997f316594606c";
    };
    meta = {
      description = "Perl extension to access the unix process table";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ProcFind = buildPerlPackage {
    pname = "Proc-Find";
    version = "0.051";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/Proc-Find-0.051.tar.gz";
      sha256 = "64d39071ec94d7b66a7cab5a950246f0fff013b5a200a63d1176432987e5a135";
    };
    propagatedBuildInputs = [ ProcProcessTable ];
    meta = {
      description = "Find processes by name, PID, or some other attributes";
      homepage = "https://metacpan.org/release/Proc-Find";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcSafeExec = buildPerlPackage {
    pname = "Proc-SafeExec";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BILBO/Proc-SafeExec-1.5.tar.gz";
      sha256 = "1b4d0908bcac563d34a7e5be61c5da3eee98e4a6c7fa68c2670cc5844b5a2d78";
    };
  };

  ProcSimple = buildPerlPackage {
    pname = "Proc-Simple";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/Proc-Simple-1.32.tar.gz";
      sha256 = "4c8f0a924b19ad78a13da73fe0fb306d32a7b9d10a332c523087fc83a209a8c4";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWait3 = buildPerlPackage {
    pname = "Proc-Wait3";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTILMES/Proc-Wait3-0.05.tar.gz";
      sha256 = "1a907f5db6933dc2939bbfeffe19eeae7ed39ef1b97a2bc9b723f2f25f81caf3";
    };
    meta = {
      description = "Perl extension for wait3 system call";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWaitStat = buildPerlPackage {
    pname = "Proc-WaitStat";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/Proc-WaitStat-1.00.tar.gz";
      sha256 = "1g3l8jzx06x4l4p0x7fyn4wvg6plfzl420irwwb9v447wzsn6xfh";
    };
    propagatedBuildInputs = [ IPCSignal ];
  };

  PrometheusTiny = buildPerlPackage {
    pname = "Prometheus-Tiny";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBN/Prometheus-Tiny-0.008.tar.gz";
      sha256 = "17d7b69chkcq8fprww6m15glndyb0lms2l0xjbnbw04q7f8ncskk";
    };
    buildInputs = [ HTTPMessage Plack TestException ];
    meta = {
      description = "A tiny Prometheus client";
      homepage = "https://github.com/robn/Prometheus-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PrometheusTinyShared = buildPerlPackage {
    pname = "Prometheus-Tiny-Shared";
    version = "0.024";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBN/Prometheus-Tiny-Shared-0.024.tar.gz";
      sha256 = "02w24r4amk8dqlavg6abxap48hzxrbda48f1pmrqypgx1cz59g4g";
    };
    buildInputs = [ DataRandom HTTPMessage Plack TestDifferences TestException ];
    propagatedBuildInputs = [ HashSharedMem JSONXS PrometheusTiny ];
    meta = {
      description = "A tiny Prometheus client with a shared database behind it";
      homepage = "https://github.com/robn/Prometheus-Tiny-Shared";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProtocolRedis = buildPerlPackage {
    pname = "Protocol-Redis";
    version = "1.0011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UN/UNDEF/Protocol-Redis-1.0011.tar.gz";
      sha256 = "7ceb6bd80067c904465d4fd1f1715724388c9bdc37c6c2c003a20ce569b7f4e8";
    };
    meta = {
      description = "Redis protocol parser/encoder with asynchronous capabilities";
      homepage = "https://github.com/und3f/protocol-redis";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ProtocolRedisFaster = buildPerlPackage {
    pname = "Protocol-Redis-Faster";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Protocol-Redis-Faster-0.003.tar.gz";
      sha256 = "6b9afb3de94ec1ccd7db4f9e6a2eaba254a57790301c17bcb13bb3edfe1850b7";
    };
    propagatedBuildInputs = [ ProtocolRedis ];
    meta = {
      description = "Optimized pure-perl Redis protocol parser/encoder";
      homepage = "https://github.com/Grinnz/Protocol-Redis-Faster";
      license = with lib.licenses; [ artistic2 ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ProtocolWebSocket = buildPerlModule {
    pname = "Protocol-WebSocket";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VT/VTI/Protocol-WebSocket-0.26.tar.gz";
      sha256 = "08jmazvrmvp8jn15p2n3c1h3f2cbkr07xjzy197jb8x724vx0dsq";
    };
    buildInputs = [ ModuleBuildTiny ];
  };

  ProtocolHTTP2 = buildPerlModule {
    pname = "Protocol-HTTP2";
    version = "1.10";

    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CR/CRUX/Protocol-HTTP2-1.10.tar.gz";
      sha256 = "0jm6jq1wszjrrcypyi642m2i8wgni50wdnzh9dzfkyjazdc00sn2";
    };
    buildInputs = [ AnyEvent ModuleBuildTiny NetSSLeay TestLeakTrace TestSharedFork TestTCP ];
  };

  PSGI = buildPerlPackage {
    pname = "PSGI";
    version = "1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/PSGI-1.102.tar.gz";
      sha256 = "0iqzxs8fv63510knm3zr3jr3ky4x7diwd7y24mlshzci81kl8v55";
    };
  };

  PadWalker = buildPerlPackage {
    pname = "PadWalker";
    version = "2.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/PadWalker-2.5.tar.gz";
      sha256 = "1l0cga0ny43x5xpqw9nrdwbznvqpj35ni39a0wrayihihjxnmch7";
    };
  };

  Perl6Junction = buildPerlPackage {
    pname = "Perl6-Junction";
    version = "1.60000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/Perl6-Junction-1.60000.tar.gz";
      sha256 = "0r3in9pyrm6wfrhcvxbq5w1617x8x5537lxj9hdzks4pa7l7a8yh";
    };
  };

  PerlMinimumVersion = buildPerlPackage {
    pname = "Perl-MinimumVersion";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Perl-MinimumVersion-1.38.tar.gz";
      sha256 = "478b5824791b87fc74c94a892180682bd06ad2cdf34034b1a4b859273927802a";
    };
    buildInputs = [ TestScript ];
    propagatedBuildInputs = [ FileFindRulePerl PerlCritic ];
    meta = {
      description = "Find a minimum required version of perl for Perl code";
      homepage = "https://github.com/neilbowers/Perl-MinimumVersion";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perlver";
    };
  };

  PerlPrereqScanner = buildPerlPackage {
    pname = "Perl-PrereqScanner";
    version = "1.023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Perl-PrereqScanner-1.023.tar.gz";
      sha256 = "280a1c4710390865fb9f310a861a34720b28b4cbe50609c841af5cf2d3a2bced";
    };
    propagatedBuildInputs = [ GetoptLongDescriptive ListMoreUtils ModulePath Moose PPI StringRewritePrefix namespaceautoclean ];
    meta = {
      description = "A tool to scan your Perl code for its prerequisites";
      homepage = "https://github.com/rjbs/Perl-PrereqScanner";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "scan-perl-prereqs";
    };
  };

  PerlPrereqScannerNotQuiteLite = buildPerlPackage {
    pname = "Perl-PrereqScanner-NotQuiteLite";
    version = "0.9913";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Perl-PrereqScanner-NotQuiteLite-0.9913.tar.gz";
      sha256 = "13alrwwh36wsqn0gliwdpp2a9kymjk8gx30gfkqw0f29w72ry3cp";
    };
    propagatedBuildInputs = [ DataDump ModuleCPANfile ModuleFind RegexpTrie URIcpan ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestFailWarnings TestUseAllModules ];
    meta = {
      description = "A tool to scan your Perl code for its prerequisites";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "scan-perl-prereqs-nqlite";
    };
  };

  PerlVersion = buildPerlPackage {
    pname = "Perl-Version";
    version = "1.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Perl-Version-1.013.tar.gz";
      sha256 = "1887414d1c8689d864c840114101e043e99d7dd5b9cca69369a60e821e3ad0f7";
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
    meta = {
      description = "Parse and manipulate Perl version strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perl-reversion";
    };
  };

  PodAbstract = buildPerlPackage {
    pname = "Pod-Abstract";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BL/BLILBURNE/Pod-Abstract-0.20.tar.gz";
      sha256 = "956ef7bb884c55456e2fb6e7f229f9a87dd50a61d700500c738db8f2ba277f87";
    };
    propagatedBuildInputs = [ IOString TaskWeaken PodParser ];
    meta = {
      description = "An abstract, tree-based interface to perl POD documents";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "paf";
    };
  };

  PodChecker = buildPerlPackage {
    pname = "Pod-Checker";
    version = "1.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAREKR/Pod-Checker-1.74.tar.gz";
      sha256 = "12559997r7wbhhs0p6cdxdzv7rzviv0nx1hq0dby8q481apn489f";
    };
    meta = {
      description = "Verifies POD documentation contents for compliance with the POD format specifications";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "podchecker";
    };
  };

  PodCoverage = buildPerlPackage {
    pname = "Pod-Coverage";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Pod-Coverage-0.23.tar.gz";
      sha256 = "01xifj83dv492lxixijmg6va02rf3ydlxly0a9slmx22r6qa1drh";
    };
    propagatedBuildInputs = [ DevelSymdump PodParser ];
    meta = {
      description = "Checks if the documentation of a module is comprehensive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pod_cover";
    };
  };

  PodCoverageTrustPod = buildPerlPackage {
    pname = "Pod-Coverage-TrustPod";
    version = "0.100005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Coverage-TrustPod-0.100005.tar.gz";
      sha256 = "08bk6lfimr2pwi6c92xg5cw1cxmi5fqhls3yasqzpjnd4if86s3c";
    };
    propagatedBuildInputs = [ PodCoverage PodEventual ];
    meta = {
      description = "Allow a module's pod to contain Pod::Coverage hints";
      homepage = "https://github.com/rjbs/Pod-Coverage-TrustPod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElemental = buildPerlPackage {
    pname = "Pod-Elemental";
    version = "0.103005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Elemental-0.103005.tar.gz";
      sha256 = "824336ec18326e3b970e7815922b3921b0a821d2ee0e50b0c5b2bc327f99615e";
    };
    buildInputs = [ TestDeep TestDifferences ];
    propagatedBuildInputs = [ MooseXTypes PodEventual StringRewritePrefix StringTruncate ];
    meta = {
      description = "Work with nestable Pod elements";
      homepage = "https://github.com/rjbs/Pod-Elemental";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElementalPerlMunger = buildPerlPackage {
    pname = "Pod-Elemental-PerlMunger";
    version = "0.200006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Elemental-PerlMunger-0.200006.tar.gz";
      sha256 = "09fd3b5d53119437a01dced66b42eafdcd53895b3c32a2b0f781f36fda0f665b";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ PPI PodElemental ];
    meta = {
      description = "A thing that takes a string of Perl and rewrites its documentation";
      homepage = "https://github.com/rjbs/Pod-Elemental-PerlMunger";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodEventual = buildPerlPackage {
    pname = "Pod-Eventual";
    version = "0.094001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Eventual-0.094001.tar.gz";
      sha256 = "be9fb8910b108e5d1a66f002b659ad22576e88d779b703dff9d15122c3f80834";
    };
    propagatedBuildInputs = [ MixinLinewise ];
    buildInputs = [ TestDeep ];
    meta = {
      description = "Read a POD document as a series of trivial events";
      homepage = "https://github.com/rjbs/Pod-Eventual";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodParser = buildPerlPackage {
    pname = "Pod-Parser";
    version = "1.63";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz";
      sha256 = "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd";
    };
    meta = {
      description = "Modules for parsing/translating POD format documents";
      license = with lib.licenses; [ artistic1 ];
      mainProgram = "podselect";
    };
  };

  PodPOM = buildPerlPackage {
    pname = "Pod-POM";
    version = "2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Pod-POM-2.01.tar.gz";
      sha256 = "1b50fba9bbdde3ead192beeba0eaddd0c614e3afb1743fa6fff805f57c56f7f4";
    };
    buildInputs = [ FileSlurper TestDifferences TextDiff ];
    meta = {
      description = "POD Object Model";
      homepage = "https://github.com/neilb/Pod-POM";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pom2";
    };
  };

  PodPOMViewTOC = buildPerlPackage {
    pname = "Pod-POM-View-TOC";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/Pod-POM-View-TOC-0.02.tar.gz";
      sha256 = "ccb42272c7503379cb1131394620ee50276d72844e0e80eb4b007a9d58f87623";
    };
    propagatedBuildInputs = [ PodPOM ];
    meta = {
      description = "Generate the TOC of a POD with Pod::POM";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodSection = buildPerlModule {
    pname = "Pod-Section";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KT/KTAT/Pod-Section-0.02.tar.gz";
      sha256 = "c9d1d75292f321881184ec56983c16f408fd2d312d5a720f8fb0d2cafa729238";
    };
    propagatedBuildInputs = [ PodAbstract ];
    meta = {
      description = "Select specified section from Module's POD";
      homepage = "https://github.com/ktat/Pod-Section";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "podsection";
    };
  };

  PodLaTeX = buildPerlModule {
    pname = "Pod-LaTeX";
    version = "0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJENNESS/Pod-LaTeX-0.61.tar.gz";
      sha256 = "15a840ea1c8a76cd3c865fbbf2fec33b03615c0daa50f9c800c54e0cf0659d46";
    };
    propagatedBuildInputs = [ PodParser ];
    meta = {
      description = "Convert Pod data to formatted Latex";
      homepage = "http://github.com/timj/perl-Pod-LaTeX/tree/master";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pod2latex";
    };
  };

  podlators = buildPerlPackage {
    pname = "podlators";
    version = "4.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RR/RRA/podlators-4.14.tar.gz";
      sha256 = "10hgvdyp0969a1222hk1y5n2p72lhxrrv8h0yyzlsbjbwcfw9wbs";
    };
    preCheck = ''
      # remove failing spdx check
      rm t/docs/spdx-license.t
    '';
    meta = {
      description = "Convert POD data to various other formats";
      homepage = "https://www.eyrie.org/~eagle/software/podlators";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  podlinkcheck = buildPerlPackage {
    pname = "podlinkcheck";
    version = "15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/podlinkcheck-15.tar.gz";
      sha256 = "4e3bebec1bf82dbf850a94ae26a253644cf5806ec41afc74e43e1710a37321db";
    };
    propagatedBuildInputs = [ FileFindIterator FileHomeDir IPCRun PodParser constant-defer libintl-perl ];
    meta = {
      description = "Check POD L<> link references";
      homepage = "http://user42.tuxfamily.org/podlinkcheck/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  prefork = buildPerlPackage {
    pname = "prefork";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/prefork-1.05.tar.gz";
      sha256 = "01ckn45ij3nbrsc0yc4wl4z0wndn36jh6247zbycwa1vlvgvr1vd";
    };
    meta = {
      description = "Optimized module loading for forking or non-forking processes";
      homepage = "https://github.com/karenetheridge/prefork";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodPerldoc = buildPerlPackage {
    pname = "Pod-Perldoc";
    version = "3.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MALLEN/Pod-Perldoc-3.28.tar.gz";
      sha256 = "0kf6xwdha8jl0nxv60r2v7xsfnvv6i3gy135xsl40g71p02ychfc";
    };
    meta = {
      description = "Look up Perl documentation in Pod format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perldoc";
    };
  };

  PodPlainer = buildPerlPackage {
    pname = "Pod-Plainer";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RM/RMBARKER/Pod-Plainer-1.04.tar.gz";
      sha256 = "1bbfbf7d1d4871e5a83bab2137e22d089078206815190eb1d5c1260a3499456f";
    };
    propagatedBuildInputs = [ PodParser ];
    meta = {
      description = "Perl extension for converting Pod to old-style Pod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodMarkdown = buildPerlPackage {
    pname = "Pod-Markdown";
    version = "3.300";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/Pod-Markdown-3.300.tar.gz";
      sha256 = "0y8vk7wprair2fjqbkjl7g9jv0dn7rv58l7b9yf7819nia8fjygc";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Convert POD to Markdown";
      homepage = "https://github.com/rwstauner/Pod-Markdown";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pod2markdown";
    };
  };

  PodMarkdownGithub = buildPerlPackage {
    pname = "Pod-Markdown-Github";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MINIMAL/Pod-Markdown-Github-0.04.tar.gz";
      sha256 = "04y67c50hpf1vb9cwsza3fbj4rshdqa47vi3zcj4kkjckh02yzmk";
    };
    propagatedBuildInputs = [ PodMarkdown ];
    buildInputs = [ TestDifferences ];
    meta = {
      description = "Convert POD to Github's specific markdown";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pod2github";
    };
  };

  PodSimple = buildPerlPackage {
    pname = "Pod-Simple";
    version = "3.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KH/KHW/Pod-Simple-3.42.tar.gz";
      sha256 = "1icagrjqw1azmff82h17cbrhqgql7rg21gz64mjpiqqq0cpfpz59";
    };
  };

  PodSpell = buildPerlPackage {
    pname = "Pod-Spell";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOLMEN/Pod-Spell-1.20.tar.gz";
      sha256 = "6383f7bfe22bc0d839a08057a0ce780698b046184aea935be4833d94986dd03c";
    };
    propagatedBuildInputs = [ ClassTiny FileShareDir LinguaENInflect PathTiny PodParser ];
    buildInputs = [ FileShareDirInstall TestDeep ];
    meta = {
      description = "A formatter for spellchecking Pod";
      homepage = "https://github.com/perl-pod/Pod-Spell";
      license = with lib.licenses; [ artistic2 ];
      mainProgram = "podspell";
    };
  };

  PodStrip = buildPerlModule {
    pname = "Pod-Strip";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOMM/Pod-Strip-1.02.tar.gz";
      sha256 = "1zsjfw2cjq1bd3ppl67fdvrx46vj9lina0c3cv9qgk5clzvaq3fq";
    };
    meta = {
      description = "Remove POD from Perl code";
      homepage = "https://github.com/domm/Pod-Strip";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodTidy = buildPerlModule {
    pname = "Pod-Tidy";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHOBLITT/Pod-Tidy-0.10.tar.gz";
      sha256 = "1gcxjplgksnc5iggi8dzbkbkcryii5wjhypd7fs3kmbwx91y2vl8";
    };
    propagatedBuildInputs = [ EncodeNewlines IOString PodWrap TextGlob ];
    buildInputs = [ TestCmd ];
    meta = {
      description = "A reformatting Pod Processor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "podtidy";
    };
  };

  PodWeaver = buildPerlPackage {
    pname = "Pod-Weaver";
    version = "4.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Pod-Weaver-4.015.tar.gz";
      sha256 = "5af25b29a55783e495a9df5ef6293240e2c9ab02764613d79f1ed50b12dec5ae";
    };
    buildInputs = [ PPI SoftwareLicense TestDifferences ];
    propagatedBuildInputs = [ ConfigMVPReaderINI DateTime ListMoreUtils LogDispatchouli PodElemental ];
    meta = {
      description = "Weave together a Pod document from an outline";
      homepage = "https://github.com/rjbs/Pod-Weaver";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodWrap = buildPerlModule {
    pname = "Pod-Wrap";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/Pod-Wrap-0.01.tar.gz";
      sha256 = "0qwb5hp26f85xnb3zivf8ccfdplabiyl5sd53c6wgdgvzzicpjjh";
    };
    propagatedBuildInputs = [ PodParser ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "podwrap";
    };
  };

  ProbePerl = buildPerlPackage {
    pname = "Probe-Perl";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Probe-Perl-0.03.tar.gz";
      sha256 = "0c9wiaz0mqqknafr4jdr0g2gdzxnn539182z0icqaqvp5qgd5r6r";
    };
  };

  POSIXAtFork = buildPerlPackage {
    pname = "POSIX-AtFork";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors//id/N/NI/NIKOLAS/POSIX-AtFork-0.04.tar.gz";
      sha256 = "sha256-wuIpOobUhxRLyPe6COfEt2sRsOTf3EGAmEXTDvoH5g4=";
    };
    buildInputs = [ TestSharedFork ];
    meta = {
      description = "Hook registrations at fork(2)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  POSIXstrftimeCompiler = buildPerlModule {
    pname = "POSIX-strftime-Compiler";
    version = "0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/POSIX-strftime-Compiler-0.44.tar.gz";
      sha256 = "dfd3c97398dcfe51c8236b85e3dc28035667b76531f7aa0a6535f3aa5405b35a";
    };
    # We cannot change timezones on the fly.
    prePatch = "rm t/04_tzset.t";
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "GNU C library compatible strftime for loggers and servers";
      homepage = "https://github.com/kazeburo/POSIX-strftime-Compiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Apprainbarf = buildPerlModule {
    pname = "App-rainbarf";
    version = "1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYP/App-rainbarf-1.4.tar.gz";
      sha256 = "4f139ad35faaf2de0623dc0bb1dd89fa5a431e548bfec87dee194cf0e25cc97d";
    };
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/rainbarf
    '';
    meta = {
      description = "CPU/RAM/battery stats chart bar for tmux (and GNU screen)";
      homepage = "https://github.com/creaktive/rainbarf";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "rainbarf";
    };
  };

  Razor2ClientAgent = buildPerlPackage {
    pname = "Razor2-Client-Agent";
    version = "2.86";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Razor2-Client-Agent-2.86.tar.gz";
      sha256 = "5e062e02ebb65e24b708e7eefa5300c43d6f657bf20d08fec4ca8a0a3b94845f";
    };
    propagatedBuildInputs = [ DigestSHA1 URI ];
    meta = {
      description = "Collaborative, content-based spam filtering network agent";
      homepage = "http://razor.sourceforge.net/";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  Readonly = buildPerlModule {
    pname = "Readonly";
    version = "2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz";
      sha256 = "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Facility for creating read-only scalars, arrays, hashes";
      homepage = "https://github.com/sanko/readonly";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ReadonlyX = buildPerlModule {
    pname = "ReadonlyX";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SANKO/ReadonlyX-1.04.tar.gz";
      sha256 = "81bb97dba93ac6b5ccbce04a42c3590eb04557d75018773ee18d5a30fcf48188";
    };
    buildInputs = [ ModuleBuildTiny TestFatal ];
    meta = {
      description = "Faster facility for creating read-only scalars, arrays, hashes";
      homepage = "https://github.com/sanko/readonly";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ReadonlyXS = buildPerlPackage {
    pname = "Readonly-XS";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/Readonly-XS-1.05.tar.gz";
      sha256 = "8ae5c4e85299e5c8bddd1b196f2eea38f00709e0dc0cb60454dc9114ae3fff0d";
    };
    propagatedBuildInputs = [ Readonly ];
  };

  Redis = buildPerlModule {
    pname = "Redis";
    version = "1.998";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/Redis-1.998.tar.gz";
      sha256 = "59f3bb176c3a7a54cb3779497b89a7bae1fb217565c68711d585fc1f09d79c87";
    };
    buildInputs = [ IOString ModuleBuildTiny TestDeep TestFatal TestSharedFork TestTCP ];
    propagatedBuildInputs = [ IOSocketTimeout TryTiny ];
    meta = {
      description = "Perl binding for Redis database";
      homepage = "https://github.com/PerlRedis/perl-redis";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  RefUtil = buildPerlPackage {
    pname = "Ref-Util";
    version = "0.204";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARC/Ref-Util-0.204.tar.gz";
      sha256 = "1q85y5lzgl8wz5qnz3j6mch2fmllr668h54wszaz6i6gp8ysfps1";
    };
    meta = {
      description = "Utility functions for checking references";
      license = with lib.licenses; [ mit ];
    };
  };

  RegexpAssemble = buildPerlPackage {
    pname = "Regexp-Assemble";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Regexp-Assemble-0.38.tgz";
      sha256 = "0hp4v8mghmpflq9l9fqrkjg4cw0d3ha2nrmnsnzwjwqvmvwyfsx0";
    };
  };

  RegexpCommon = buildPerlPackage {
    pname = "Regexp-Common";
    version = "2017060201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz";
      sha256 = "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b";
    };
    meta = with lib; {
      description = "Provide commonly requested regular expressions";
      license = licenses.mit;
    };
  };

  RegexpCommonnetCIDR = buildPerlPackage {
    pname = "Regexp-Common-net-CIDR";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Regexp-Common-net-CIDR-0.03.tar.gz";
      sha256 = "39606a57aab20d4f4468300f2ec3fa2ab557fcc9cb7880ec7c6e07d80162da33";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpCommontime = buildPerlPackage {
    pname = "Regexp-Common-time";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/Regexp-Common-time-0.16.tar.gz";
      sha256 = "1jjay5gybbls3xn5ihc6q5ig3kf4i28nq4gvg2zp4p5m1ajhg08w";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      description = "Date and time regexps";
      homepage = "https://github.com/manwar/Regexp-Common-time";
      license = with lib.licenses; [ free ];
      maintainers = [ maintainers.artturin ];
    };
  };

  RegexpGrammars = buildPerlModule {
    pname = "Regexp-Grammars";
    version = "1.057";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/Regexp-Grammars-1.057.tar.gz";
      sha256 = "af53c19818461cd701aeb57c49dffdb463edc4bf8f658d9ea4e6d534ac177041";
    };
    meta = {
      description = "Add grammatical parsing features to Perl 5.10 regexes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpIPv6 = buildPerlPackage {
    pname = "Regexp-IPv6";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Regexp-IPv6-0.03.tar.gz";
      sha256 = "d542d17d75ce93631de8ba2156da0e0b58a755c409cd4a0d27a3873a26712ce2";
    };
  };

  RegexpParser = buildPerlPackage {
    pname = "Regexp-Parser";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Regexp-Parser-0.23.tar.gz";
      sha256 = "f739dab8df2b06aae5c48f9971251b73704464a32d07d8d025f3c0f869544e89";
    };
    meta = {
      description = "Base class for parsing regexes";
      homepage = "http://wiki.github.com/toddr/Regexp-Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpTrie = buildPerlPackage {
    pname = "Regexp-Trie";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Regexp-Trie-0.02.tar.gz";
      sha256 = "1yn5l6x3xyic9jxw9jggqsbggcv7rc8ggj4zbnlz9hfvv17gjazv";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  RESTClient = buildPerlPackage {
    pname = "REST-Client";
    version = "273";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KK/KKANE/REST-Client-273.tar.gz";
      sha256 = "a8652a2214308faff2c68be5ce64c904dcccc5e86be7f32376c1590869d01844";
    };
    propagatedBuildInputs = [ LWPProtocolHttps ];
    meta = {
      description = "A simple client for interacting with RESTful http/https resources";
      homepage = "https://github.com/milescrawford/cpan-rest-client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RESTUtils = buildPerlModule {
    pname = "REST-Utils";
    version = "0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JALDHAR/REST-Utils-0.6.tar.gz";
      sha256 = "1zdrf3315rp2b8r9dwwj5h93xky7i33iawf4hzszwcddhzflmsfl";
    };
    buildInputs = [ TestLongString TestWWWMechanize TestWWWMechanizeCGI ];
    meta = {
      description = "Utility functions for REST applications";
      homepage = "http://jaldhar.github.com/REST-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RpcXML = buildPerlPackage {
    pname = "RPC-XML";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.80.tar.gz";
      sha256 = "1xvy9hs7bqsjnk0663kf7zk2qjg0pzv96n6z2wlc2w5bgal7q3ga";
    };
    propagatedBuildInputs = [ XMLParser ];
    doCheck = false;
    meta = {
      description = "Data, client and server classes for XML-RPC";
      homepage = "http://github.com/rjray/rpc-xml";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "make_method";
    };
  };

  ReturnValue = buildPerlPackage {
    pname = "Return-Value";
    version = "1.666005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.666005.tar.gz";
      sha256 = "1b2hfmdl19zi1z3npzv9wf6dh1g0xd88i70b4233ds9icnln08lf";
    };
  };

  RoleBasic = buildPerlModule {
    pname = "Role-Basic";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Role-Basic-0.13.tar.gz";
      sha256 = "38a0959ef9f193ff76e72c325a9e9211bc4868689bd0e2b005778f53f8b6f36a";
    };
    meta = {
      description = "Just roles. Nothing else";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleHasMessage = buildPerlPackage {
    pname = "Role-HasMessage";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Role-HasMessage-0.006.tar.gz";
      sha256 = "1lylfvarjfy6wy34dfny3032pc6r33mjby5yzzhmxybg8zhdp9pn";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized StringErrf ];
    meta = {
      description = "A thing with a message method";
      homepage = "https://github.com/rjbs/Role-HasMessage";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleIdentifiable = buildPerlPackage {
    pname = "Role-Identifiable";
    version = "0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Role-Identifiable-0.007.tar.gz";
      sha256 = "1bbkj2wqpbfdw1cbm99vg9d94rvzba19m18xhnylaym0l78lc4sn";
    };
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "A thing you can identify somehow";
      homepage = "https://github.com/rjbs/Role-Identifiable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleTiny = buildPerlPackage {
    pname = "Role-Tiny";
    version = "2.001004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Role-Tiny-2.001004.tar.gz";
      sha256 = "92ba5712850a74102c93c942eb6e7f62f7a4f8f483734ed289d08b324c281687";
    };
    meta = {
      description = "Roles: a nouvelle cuisine portion size slice of Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RPCEPCService = buildPerlModule {
    pname = "RPC-EPC-Service";
    version = "0.0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KI/KIWANAMI/RPC-EPC-Service-v0.0.11.tar.gz";
      sha256 = "975f4134365258fb47fa921919053513adb9101f2bd420fcefe345f209128be3";
    };
    propagatedBuildInputs = [ AnyEvent DataSExpression ];
    meta = {
      description = "An Asynchronous Remote Procedure Stack";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

    RPM2 = buildPerlModule {
    pname = "RPM2";
    version = "1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LK/LKUNDRAK/RPM2-1.4.tar.gz";
      sha256 = "5ecb42aa69324e6f4088abfae07313906e5aabf2f46f1204f3f1de59155bb636";
    };
    buildInputs = [ pkgs.pkg-config pkgs.rpm ];
    doCheck = false; # Tries to open /var/lib/rpm
    meta = {
      description = "Perl bindings for the RPM Package Manager API";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux;
    };
  };

  RSSParserLite = buildPerlPackage {
    pname = "RSS-Parser-Lite";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TF/TFPBL/RSS-Parser-Lite-0.12.tar.gz";
      sha256 = "1fcmp4qp7q3xr2mw7clqqwph45icbvgfs2n41gp9zamim2y39p49";
    };
    propagatedBuildInputs = [ locallib ];
    doCheck = false; /* creates files in HOME */
  };

  RTClientREST = buildPerlModule {
    pname = "RT-Client-REST";
    version = "0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DJ/DJZORT/RT-Client-REST-0.60.tar.gz";
      sha256 = "0e6f2da3d96903491b43b19c61221cbeea88414264f907312f277daaf144248b";
    };
    buildInputs = [ CGI HTTPServerSimple TestException ];
    propagatedBuildInputs = [ DateTimeFormatDateParse Error LWP ParamsValidate ];
    meta = {
      description = "Client for RT using REST API";
      homepage = "https://github.com/RT-Client-REST/RT-Client-REST";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SafeIsa = buildPerlPackage {
    pname = "Safe-Isa";
    version = "1.000010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Safe-Isa-1.000010.tar.gz";
      sha256 = "0sm6p1kw98s7j6n92vvxjqf818xggnmjwci34xjmw7gzl2519x47";
    };
    meta = {
      description = "Call isa, can, does and DOES safely on things that may not be objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarListUtils = buildPerlPackage {
    pname = "Scalar-List-Utils";
    version = "1.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.55.tar.gz";
      sha256 = "4d2bdc1c72a7bc4d69d6a5cc85bc7566497c3b183c6175b832784329d58feb4b";
    };
    meta = {
      description = "Common Scalar and List utility subroutines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarString = buildPerlModule {
    pname = "Scalar-String";
    version = "0.003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Scalar-String-0.003.tar.gz";
      sha256 = "f54a17c9b78713b02cc43adfadf60b49467e7634d31317e8b9e9e97c26d68b52";
    };
  };

  SCGI = buildPerlModule {
    pname = "SCGI";
    version = "0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPERCODE/SCGI-0.6.tar.gz";
      sha256 = "196rj47mh4fq2vlnw595q391zja5v6qg7s3sy0vy8igfyid8rdsq";
    };
    preConfigure = "export HOME=$(mktemp -d)";
  };

  ScopeGuard = buildPerlPackage {
    pname = "Scope-Guard";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.21.tar.gz";
      sha256 = "0y6jfzvxiz8h5yfz701shair0ilypq2mvimd7wn8wi2nbkm1p6wc";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeUpper = buildPerlPackage {
    pname = "Scope-Upper";
    version = "0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.33.tar.gz";
      sha256 = "sha256-XzO+Aa1o/L7G74HusDs1EaL18HUq1RPZk6TBOl+xpkg=";
    };
    meta = {
      description = "Act on upper scopes";
      homepage = "http://search.cpan.org/dist/Scope-Upper";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SDL = buildPerlModule {
    pname = "SDL";
    version = "2.548";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FROGGS/SDL-2.548.tar.gz";
      sha256 = "252a192bfa9c2070a4883707d139c3a45d9c4518ccd66a1e699b5b7959bd4fb5";
    };
    perlPreHook = "export LD=$CC";
    preCheck = "rm t/core_audiospec.t";
    buildInputs = [ pkgs.SDL pkgs.SDL_gfx pkgs.SDL_mixer pkgs.SDL_image pkgs.SDL_ttf pkgs.SDL_Pango pkgs.SDL_net AlienSDL CaptureTiny TestDeep TestDifferences TestException TestMost TestWarn ];
    propagatedBuildInputs = [ FileShareDir TieSimple ];
    meta = {
      description = "SDL bindings to Perl";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  SearchXapian = buildPerlPackage rec {
    pname = "Search-Xapian";
    version = "1.2.25.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLLY/Search-Xapian-1.2.25.4.tar.gz";
      sha256 = "1pbl8pbgmbs3i8yik4p63g4pd9bhn0dp3d7l667dkvw0kccl66c7";
    };
    buildInputs = [ pkgs.xapian DevelLeak ];
    meta = {
      description = "Perl XS frontend to the Xapian C++ search library";
      homepage = "https://xapian.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SerealDecoder = buildPerlPackage {
    pname = "Sereal-Decoder";
    version = "4.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-Decoder-4.025.tar.gz";
      sha256 = "sha256-jg47mprxp3i33iFQb6MHl/sbUg3NAC8/KebctSRG3qU=";
    };
    buildInputs = [ TestDeep TestDifferences TestLongString TestWarn ];
    preBuild = "ls";
    meta = {
      description = "Fast, compact, powerful binary deserialization";
      homepage = "https://github.com/Sereal/Sereal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  SerealEncoder = buildPerlPackage {
    pname = "Sereal-Encoder";
    version = "4.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-Encoder-4.025.tar.gz";
      sha256 = "sha256-D9UbpggwJmUNCFJnWCYRc8GKuCNMVSb6x+25GtnGAm4=";
    };
    buildInputs = [ SerealDecoder TestDeep TestDifferences TestLongString TestWarn ];
    meta = {
      description = "Fast, compact, powerful binary serialization";
      homepage = "https://github.com/Sereal/Sereal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  Sereal = buildPerlPackage {
    pname = "Sereal";
    version = "4.025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-4.025.tar.gz";
      sha256 = "sha256-C+X+VStQtnhjk+Q+qczldzpItf80o6zyopWqdgmgYrk=";
    };
    buildInputs = [ TestDeep TestLongString TestWarn ];
    propagatedBuildInputs = [ SerealDecoder SerealEncoder ];
    meta = {
      description = "Fast, compact, powerful binary (de-)serialization";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.thoughtpolice ];
    };
  };

  DeviceSerialPort = buildPerlPackage rec {
    pname = "Device-SerialPort";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/COOK/Device-SerialPort-1.04.tar.gz";
      sha256 = "1mz9a2qzkz6fbz76wcwmp48h6ckjxpcazb70q03acklvndy5d4nk";
    };
    meta = with lib; {
      description = "Linux/POSIX emulation of Win32::SerialPort functions.";
      license = with licenses; [ artistic1 gpl1Plus ];
      mainProgram = "modemtest";
    };
  };

  ServerStarter = buildPerlModule {
    pname = "Server-Starter";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Server-Starter-0.35.tar.gz";
      sha256 = "676dc0d6cff4648538332c63c32fb88ad09ed868213ea9e62e3f19fad41b9c40";
    };
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "A superdaemon for hot-deploying server programs";
      homepage = "https://github.com/kazuho/p5-Server-Starter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "start_server";
    };
  };

  SessionToken = buildPerlPackage rec {
    pname = "Session-Token";
    version = "1.503";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FRACTAL/Session-Token-1.503.tar.gz";
      sha256 = "32c3df96ef455c71870363acd950ddc4fbc848c594f4bc55b21b44cf979f79a1";
    };
    meta = {
      description = "Secure, efficient, simple random session token generation";
      homepage = "https://github.com/hoytech/Session-Token";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  SetInfinite = buildPerlPackage {
    pname = "Set-Infinite";
    version = "0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/Set-Infinite-0.65.tar.gz";
      sha256 = "07bc880734492de40b4a3a8b5a331762f64e69b4629029fd9a9d357b25b87e1f";
    };
    meta = {
      description = "Infinite Sets math";
      license = with lib.licenses; [ unfree ];
    };
  };

  SetIntSpan = buildPerlPackage {
    pname = "Set-IntSpan";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz";
      sha256 = "1l6znd40ylzvfwl02rlqzvakv602rmvwgm2xd768fpgc2fdm9dqi";
    };

    meta = {
      description = "Manages sets of integers, newsrc style";
      license = with lib.licenses; [ unfree ];
    };
  };

  SetObject = buildPerlPackage {
    pname = "Set-Object";
    version = "1.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Set-Object-1.40.tar.gz";
      sha256 = "1c4d8464c13e6d94957cf021ce603c961b08f52db6a9eaf5a5b0d37868cd37b7";
    };
    meta = {
      description = "Unordered collections (sets) of Perl Objects";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  SetScalar = buildPerlPackage {
    pname = "Set-Scalar";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz";
      sha256 = "07aiqkyi1p22drpcyrrmv7f8qq6fhrxh007achy2vryxyck1bp53";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SmartComments = buildPerlPackage rec {
    pname = "Smart-Comments";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Smart-Comments-1.06.tar.gz";
      sha256 = "dcf8a312134a7c6b82926a0115d93b692472a662d28cdc3a9bdf28984ada9ee3";
    };
    meta = {
      description = "Comments that do more than just sit there";
      homepage = "https://github.com/neilb/Smart-Comments";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  SGMLSpm = buildPerlModule {
    pname = "SGMLSpm";
    version = "1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz";
      sha256 = "1gdjf3mcz2bxir0l9iljxiz6qqqg3a9gg23y5wjg538w552r432m";
    };
    meta = {
      description = "Library for parsing the output from SGMLS and NSGMLS parsers";
      license = with lib.licenses; [ gpl2Plus ];
      mainProgram = "sgmlspl.pl";
    };
  };

  SignalMask = buildPerlPackage {
    pname = "Signal-Mask";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Signal-Mask-0.008.tar.gz";
      sha256 = "043d995b6b249d9ebc04c467db31bb7ddc2e55faa08e885bdb050b1f2336b73f";
    };
    propagatedBuildInputs = [ IPCSignal ];
    meta = {
      description = "Signal masks made easy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SnowballNorwegian = buildPerlModule {
    pname = "Snowball-Norwegian";
    version = "1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASKSH/Snowball-Norwegian-1.2.tar.gz";
      sha256 = "0675v45bbsh7vr7kpf36xs2q79g02iq1kmfw22h20xdk4rzqvkqx";
    };
    meta = {
      description = "Porters stemming algorithm for norwegian";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "stemmer-no.pl";
    };
  };

  SnowballSwedish = buildPerlModule {
    pname = "Snowball-Swedish";
    version = "1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASKSH/Snowball-Swedish-1.2.tar.gz";
      sha256 = "0agwc12jk5kmabnpsplw3wf4ii5w1zb159cpin44x3srb0sr5apg";
    };
    meta = {
      description = "Porters stemming algorithm for swedish";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "stemmer-se.pl";
    };
  };

  SOAPLite = buildPerlPackage {
    pname = "SOAP-Lite";
    version = "1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz";
      sha256 = "00fkvmnxiy5mr45rj5qmxmflw0xdkw2gihm48iha2i8smdmi0ng3";
    };
    propagatedBuildInputs = [ ClassInspector IOSessionData LWPProtocolHttps TaskWeaken XMLParser ];
    buildInputs = [ TestWarn XMLParserLite ];
    checkInputs = [ HTTPDaemon ];
    meta = {
      description = "Perl's Web Services Toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Socket6 = buildPerlPackage {
    pname = "Socket6";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UM/UMEMOTO/Socket6-0.29.tar.gz";
      sha256 = "468915fa3a04dcf6574fc957eff495915e24569434970c91ee8e4e1459fc9114";
    };
    setOutputFlags = false;
    buildInputs = [ pkgs.which ];
    patches = [ ../development/perl-modules/Socket6-sv_undef.patch ];
    meta = {
      description = "IPv6 related part of the C socket.h defines and structure manipulators";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  SoftwareLicense = buildPerlPackage {
    pname = "Software-License";
    version = "0.103014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Software-License-0.103014.tar.gz";
      sha256 = "eb45ea602d75006683789fbba57a01c0a1f7037371de95ea54b91577535d1789";
    };
    buildInputs = [ TryTiny ];
    propagatedBuildInputs = [ DataSection TextTemplate ];
    meta = {
      description = "Packages that provide templated software licenses";
      homepage = "https://github.com/Perl-Toolchain-Gang/Software-License";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SoftwareLicenseCCpack = buildPerlPackage {
    pname = "Software-License-CCpack";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBYRD/Software-License-CCpack-1.11.tar.gz";
      sha256 = "1cakbn7am8mhalwas5h33l7c6avdqpg42z478p6rav11pim5qksr";
    };
    propagatedBuildInputs = [ SoftwareLicense ];
    buildInputs = [ TestCheckDeps ];
    meta = {
      description = "Software::License pack for Creative Commons' licenses";
      homepage = "https://github.com/SineSwiper/Software-License-CCpack";
      license = with lib.licenses; [ lgpl3Plus ];
    };
  };

  SortKey = buildPerlPackage {
    pname = "Sort-Key";
    version = "1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Sort-Key-1.33.tar.gz";
      sha256 = "1kqs10s2plj6c96srk0j8d7xj8dxk1704r7mck8rqk09mg7lqspd";
    };
    meta = {
      description = "The fastest way to sort anything in Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortVersions = buildPerlPackage {
    pname = "Sort-Versions";
    version = "1.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Sort-Versions-1.62.tar.gz";
      sha256 = "1aifzm79ky03gi2lwxyx4mk6yky8x215j0kz4f0jbgkf803k6pxz";
    };
  };

  Specio = buildPerlPackage {
    pname = "Specio";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Specio-0.46.tar.gz";
      sha256 = "15lmxffbzj1gq7n9m80a3ka8nqxmmk3p4azp33y6wv872shjmx0b";
    };
    propagatedBuildInputs = [ DevelStackTrace EvalClosure MROCompat ModuleRuntime RoleTiny SubQuote TryTiny ];
    buildInputs = [ TestFatal TestNeeds ];
    meta = {
      description = "Type constraints and coercions for Perl";
      homepage = "https://metacpan.org/release/Specio";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  SpecioLibraryPathTiny = buildPerlPackage {
    pname = "Specio-Library-Path-Tiny";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Specio-Library-Path-Tiny-0.04.tar.gz";
      sha256 = "0cyfx8gigsgisdwynjamh8jkpad23sr8v6a98hq285zmibm16s7g";
    };
    propagatedBuildInputs = [ PathTiny Specio ];
    buildInputs = [ Filepushd TestFatal ];
    meta = {
      description = "Path::Tiny types and coercions for Specio";
      homepage = "https://metacpan.org/release/Specio-Library-Path-Tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  Spiffy = buildPerlPackage {
    pname = "Spiffy";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Spiffy-0.46.tar.gz";
      sha256 = "18qxshrjh0ibpzjm2314157mxlibh3smyg64nr4mq990hh564n4g";
    };
  };

  SpreadsheetCSV = buildPerlPackage {
    pname = "Spreadsheet-CSV";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/Spreadsheet-CSV-0.20.tar.gz";
      sha256 = "070bb252a8fe8b938a1ce4fc90525f833d4e619b6d4673b0ae0a23408d514ab6";
    };
    nativeBuildInputs = [ CGI ];
    propagatedBuildInputs = [ ArchiveZip SpreadsheetParseExcel TextCSV_XS XMLParser ];
    meta = {
      description = "Drop-in replacement for Text::CSV_XS with spreadsheet support";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetParseExcel = buildPerlPackage {
    pname = "Spreadsheet-ParseExcel";
    version = "0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOUGW/Spreadsheet-ParseExcel-0.65.tar.gz";
      sha256 = "6ec4cb429bd58d81640fe12116f435c46f51ff1040c68f09cc8b7681c1675bec";
    };
    propagatedBuildInputs = [ CryptRC4 DigestPerlMD5 IOStringy OLEStorage_Lite ];
    meta = {
      description = "Read information from an Excel file";
      homepage = "http://github.com/runrig/spreadsheet-parseexcel";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetWriteExcel = buildPerlPackage {
    pname = "Spreadsheet-WriteExcel";
    version = "2.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/Spreadsheet-WriteExcel-2.40.tar.gz";
      sha256 = "e356aad6866cf135731268ee0e979a197443c15a04878e9cf3e80d022ad6c07e";
    };
    propagatedBuildInputs = [ OLEStorage_Lite ParseRecDescent ];
    meta = {
      description = "Write to a cross platform Excel binary file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "chartex";
    };
  };

  SQLAbstract = buildPerlPackage {
    pname = "SQL-Abstract";
    version = "2.000001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/SQL-Abstract-2.000001.tar.gz";
      sha256 = "sha256-NaZCZiw0lCDUS+bg732HZep0PrEq0UOZqjojK7lObpo=";
    };
    buildInputs = [ DataDumperConcise TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ HashMerge MROCompat Moo ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstractClassic = buildPerlPackage {
    pname = "SQL-Abstract-Classic";
    version = "1.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/SQL-Abstract-Classic-1.91.tar.gz";
      sha256 = "0a7g13hs3kdxrjn43sfli09mgsi9d6w0dfw6hlk268av17yisgaf";
    };
    buildInputs = [ TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ SQLAbstract ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstractLimit = buildPerlPackage {
    pname = "SQL-Abstract-Limit";
    version = "0.143";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASB/SQL-Abstract-Limit-0.143.tar.gz";
      sha256 = "sha256-0Yr9eIk72DC6JGXArmozQlRgFZADhk3tO1rc9RGJyuk=";
    };
    propagatedBuildInputs = [ DBI SQLAbstract ];
    buildInputs = [ TestDeep TestException ];
  };

  SQLAbstractPg = buildPerlPackage {
    pname = "SQL-Abstract-Pg";
    version = "1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/SQL-Abstract-Pg-1.0.tar.gz";
      sha256 = "sha256-Pic2DfN7jYjzxS2smwNJP5vT7v9sjYj5sIbScRVT9Uc=";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ SQLAbstract ];
    meta = {
      description = "PostgreSQL features for SQL::Abstract";
      homepage = "https://mojolicious.org";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  SQLSplitStatement = buildPerlPackage {
    pname = "SQL-SplitStatement";
    version = "1.00020";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EM/EMAZEP/SQL-SplitStatement-1.00020.tar.gz";
      sha256 = "0bqg45k4c9qkb2ypynlwhpvzsl4ssfagmsalys18s5c79ps30z7p";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassAccessor ListMoreUtils RegexpCommon SQLTokenizer ];
    meta = {
      description = "Split any SQL code into atomic statements";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "sql-split";
    };
  };

  SQLStatement = buildPerlPackage {
    pname = "SQL-Statement";
    version = "1.414";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/SQL-Statement-1.414.tar.gz";
      sha256 = "0j8sg36wc3nwfb2gj3fv75f0iv7s7q7vl6b5l3fywdm1lv7vvs6x";
    };
    buildInputs = [ MathBaseConvert TestDeep TextSoundex ];
    propagatedBuildInputs = [ Clone ModuleRuntime ParamsUtil ];
  };

  SQLTokenizer = buildPerlPackage {
    pname = "SQL-Tokenizer";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IZ/IZUT/SQL-Tokenizer-0.24.tar.gz";
      sha256 = "1qa2dfbzdlr5qqdam9yn78z5w3al5r8577x06qan8wv58ay6ka7s";
    };
  };

  SQLTranslator = buildPerlPackage {
    pname = "SQL-Translator";
    version = "1.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/SQL-Translator-1.62.tar.gz";
      sha256 = "096fq62iphmxgcfcayg4i0wf09y1rl1ar6hrcxfqsbrsmkwlzk8a";
    };
    buildInputs = [ FileShareDirInstall JSONMaybeXS TestDifferences TestException XMLWriter YAML ];
    propagatedBuildInputs = [ CarpClan DBI FileShareDir Moo PackageVariant ParseRecDescent TryTiny GraphViz GD ];

    postPatch = ''
      patchShebangs script
    '';

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      for file in $out/bin/*; do
        shortenPerlShebang $file
      done
    '';

    meta = {
      description = "SQL DDL transformations and more";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "sqlt";
    };
  };

  PackageVariant = buildPerlPackage {
    pname = "Package-Variant";
    version = "1.003002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/Package-Variant-1.003002.tar.gz";
      sha256 = "b2ed849d2f4cdd66467512daa3f143266d6df810c5fae9175b252c57bc1536dc";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ImportInto strictures ];
    meta = {
      description = "Parameterizable packages";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortNaturally = buildPerlPackage {
    pname = "Sort-Naturally";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz";
      sha256 = "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746";
    };
  };

  Starlet = buildPerlPackage {
    pname = "Starlet";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Starlet-0.31.tar.gz";
      sha256 = "b9603b8e62880cb4582f6a7939eafec65e6efd3d900f2c7dd342e5f4c68d62d8";
    };
    buildInputs = [ LWP TestSharedFork TestTCP ];
    propagatedBuildInputs = [ ParallelPrefork Plack ServerStarter ];
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "A simple, high-performance PSGI/Plack HTTP server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Starman = buildPerlModule {
    pname = "Starman";
    version = "0.4015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Starman-0.4015.tar.gz";
      sha256 = "1y1kn4929k299fbf6sw9lxcsdlq9fvq777p6yrzk591rr9xhkx8h";
    };
    buildInputs = [ LWP ModuleBuildTiny TestRequires TestTCP ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [ DataDump HTTPParserXS NetServer Plack NetServerSSPrefork ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/starman
    '';

    doCheck = false; # binds to various TCP ports
    meta = {
      description = "High-performance preforking PSGI/Plack web server";
      homepage = "https://github.com/miyagawa/Starman";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "starman";
    };
  };

  StatisticsBasic = buildPerlPackage {
    pname = "Statistics-Basic";
    version = "1.6611";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JETTERO/Statistics-Basic-1.6611.tar.gz";
      sha256 = "1ywl398z42hz9w1k0waf1caa6agz8jzsjlf4rzs1lgpx2mbcwmb8";
    };
    propagatedBuildInputs = [ NumberFormat ];
    meta = {
      license = with lib.licenses; [ free ];
    };
  };

  StatisticsCaseResampling = buildPerlPackage {
    pname = "Statistics-CaseResampling";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Statistics-CaseResampling-0.15.tar.gz";
      sha256 = "11whlh2dl7l6wrrnfmpbsg7ldcn316iccl1aaa4j5lqhdyyl6745";
    };
    meta = {
      description = "Efficient resampling and calculation of medians with confidence intervals";
      license = with lib.licenses; [ unfree ];
    };
  };

  StatisticsChiSquare = buildPerlPackage rec {
    pname = "Statistics-ChiSquare";
    version = "1.0000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Statistics-ChiSquare-1.0000.tar.gz";
      sha256 = "255a5a38336d048ddb9077222691e000984e907aae09a4ea695a9cfd49a1ddd0";
    };
    meta = {
      description = "Implements the Chi Squared test, using pre-computed tables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsDescriptive = buildPerlModule {
    pname = "Statistics-Descriptive";
    version = "3.0800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Statistics-Descriptive-3.0800.tar.gz";
      sha256 = "0fgrjr79ai5dn92kypslsi97y7r8iiwmd682lrd47vdz4vmdwkmh";
    };
    propagatedBuildInputs = [ ListMoreUtils ];
    meta = {
      description = "Module of basic descriptive statistical functions";
      homepage = "http://metacpan.org/release/Statistics-Descriptive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsDistributions = buildPerlPackage {
    pname = "Statistics-Distributions";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEK/Statistics-Distributions-1.02.tar.gz";
      sha256 = "1j1kswl98f4i9dn176f9aa3y9bissx2sscga5jm3gjl4pxm3k7zr";
    };
  };

  StatisticsTTest = buildPerlPackage {
    pname = "Statistics-TTest";
    version = "1.1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YU/YUNFANG/Statistics-TTest-1.1.0.tar.gz";
      sha256 = "0rkifgzm4rappiy669dyi6lyxn2sdqaf0bl6gndlfa67b395kndj";
    };
    propagatedBuildInputs = [ StatisticsDescriptive StatisticsDistributions ];
  };

  StreamBuffered = buildPerlPackage {
    pname = "Stream-Buffered";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.03.tar.gz";
      sha256 = "0fs2n9zw6isfkha2kbqrvl9mwg572x1x0jlfaps0qsyynn846bcv";
    };
    meta = {
      description = "Temporary buffer to save bytes";
      homepage = "https://github.com/plack/Stream-Buffered";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  strictures = buildPerlPackage {
    pname = "strictures";
    version = "2.000006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/strictures-2.000006.tar.gz";
      sha256 = "0mwd9xqz4n8qfpi5h5581lbm33qhf7agww18h063icnilrs7km89";
    };
    meta = {
      description = "Turn on strict and make most warnings fatal";
      homepage = "http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/strictures.git";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringApprox = buildPerlPackage {
    pname = "String-Approx";
    version = "3.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/String-Approx-3.28.tar.gz";
      sha256 = "43201e762d8699cb0ac2c0764a5454bdc2306c0771014d6c8fba821480631342";
    };
  };

  StringCamelCase = buildPerlPackage {
    pname = "String-CamelCase";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIO/String-CamelCase-0.04.tar.gz";
      sha256 = "1a8i4yzv586svd0pbxls7642vvmyiwzh4x2xyij8gbnfxsydxhw9";
    };
  };

  StringCompareConstantTime = buildPerlPackage {
    pname = "String-Compare-ConstantTime";
    version = "0.321";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FRACTAL/String-Compare-ConstantTime-0.321.tar.gz";
      sha256 = "0b26ba2b121d8004425d4485d1d46f59001c83763aa26624dff6220d7735d7f7";
    };
    meta = {
      description = "Timing side-channel protected string compare";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringCRC32 = buildPerlPackage {
    pname = "String-CRC32";
    version = "2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/String-CRC32-2.tar.gz";
      sha256 = "0bfrpnkgfakd4apv366p63z4vzypzvhj3yyqaw9dg7zca2pgxdzd";
    };
  };

  StringDiff = buildPerlModule {
    pname = "String-Diff";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YAPPO/String-Diff-0.07.tar.gz";
      sha256 = "7215b67cbc3226e2d0e18b38ec58c93be0bf6090278698bef955348826cd0af3";
    };
    patches = [
      (fetchpatch {
        url = "https://salsa.debian.org/perl-team/modules/packages/libstring-diff-perl/-/raw/d8120a93f73f4d4aa40d10819b2f0a312608ca9b/debian/patches/0001-Fix-the-test-suite-for-YAML-1.21-compatibility.patch";
        sha256 = "0rggwcp7rfnp3zhnxpn5pb878v2dhpk3x6682w9dnsym92gjrij5";
      })
    ];
    buildInputs = [ TestBase ModuleBuildTiny ModuleInstallGithubMeta ModuleInstallRepository ModuleInstallReadmeFromPod ModuleInstallReadmeMarkdownFromPod YAML ];
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Simple diff to String";
      homepage = "https://github.com/yappo/p5-String-Diff";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  StringErrf = buildPerlPackage {
    pname = "String-Errf";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Errf-0.008.tar.gz";
      sha256 = "1nyn9s52jgbffrsv0m7rhcx1awjj43n68bfjlap8frdc7mw6y4xf";
    };
    buildInputs = [ JSONMaybeXS TimeDate ];
    propagatedBuildInputs = [ StringFormatter ];
    meta = {
      description = "A simple sprintf-like dialect";
      homepage = "https://github.com/rjbs/String-Errf";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringEscape = buildPerlPackage {
    pname = "String-Escape";
    version = "2010.002";
    src = fetchurl {
        url = "mirror://cpan/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz";
        sha256 = "12ls7f7847i4qcikkp3skwraqvjphjiv2zxfhl5d49326f5myr7x";
    };
  };

  StringFlogger = buildPerlPackage {
    pname = "String-Flogger";
    version = "1.101245";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Flogger-1.101245.tar.gz";
      sha256 = "aa03c08e01f802a358c175c6093c02adf9688659a087a8ddefdc3e9cef72640b";
    };
    propagatedBuildInputs = [ JSONMaybeXS SubExporter ];
    meta = {
      description = "String munging for loggers";
      homepage = "https://github.com/rjbs/String-Flogger";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringFormat = buildPerlPackage {
    pname = "String-Format";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/String-Format-1.18.tar.gz";
      sha256 = "0y77frxzjifd4sw0j19cc346ysas1mya84rdxaz279lyin7plhcy";
    };
  };

  StringFormatter = buildPerlPackage {
    pname = "String-Formatter";
    version = "0.102084";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Formatter-0.102084.tar.gz";
      sha256 = "0mlwm0rirv46gj4h072q8gdync5zxxsxy8p028gdyrhczl942dc3";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = with lib; {
      description = "Build sprintf-like functions of your own";
      license = licenses.gpl2;
    };
  };

  StringInterpolate = buildPerlPackage {
    pname = "String-Interpolate";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/String-Interpolate-0.32.tar.gz";
      sha256 = "15fwbpz3jdpdgmz794iw9hz2caxrnrw9pdwprxxkanpm92cdhaf7";
    };
    meta = with lib; {
      # https://metacpan.org/pod/String::Interpolate
      description = "String::Interpolate - Wrapper for builtin the Perl interpolation engine.";
      license = licenses.gpl1Plus;
    };
    propagatedBuildInputs = [ PadWalker SafeHole ];
  };

  StringInterpolateNamed = buildPerlPackage {
    pname = "String-Interpolate-Named";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/String-Interpolate-Named-1.00.tar.gz";
      sha256 = "727299fa69258b604770e059ec4da906bfde71861fdd1e3e89e30677371c5a80";
    };
    meta = {
      description = "Interpolated named arguments in string";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringMkPasswd = buildPerlPackage {
    pname = "String-MkPasswd";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.05.tar.gz";
      sha256 = "15lvcc8c9hp6mg3jx02wd3b85aphn8yl5db62q3pam04c0sgh42k";
    };
    meta = {
      description = "Random password generator";
      homepage = "https://github.com/sirhc/string-mkpasswd";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mkpasswd.pl";
    };
  };

  StringRandom = buildPerlModule {
    pname = "String-Random";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/String-Random-0.31.tar.gz";
      sha256 = "0p4pmf3k6c01j8clfx54167rva9mf82bkh9aj5qdrix2cgpd2jjb";
    };
  };

  StringRewritePrefix = buildPerlPackage {
    pname = "String-RewritePrefix";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.008.tar.gz";
      sha256 = "1sq8way03gxb990n232y201grnh0jj0xhj7g4b3mz3sfj7b32np4";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      description = "Rewrite strings based on a set of known prefixes";
      homepage = "https://github.com/rjbs/String-RewritePrefix";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringShellQuote = buildPerlPackage {
    pname = "String-ShellQuote";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz";
      sha256 = "0dfxhr6hxc2majkkrm0qbx3qcbykzpphbj2ms93dc86f7183c1p6";
    };
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Quote strings for passing through the shell";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "shell-quote";
    };
  };

  StringSimilarity = buildPerlPackage {
    pname = "String-Similarity";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/String-Similarity-1.04.tar.gz";
      sha256 = "0i9j3hljxw7j6yiii9nsscfj009vw6zv1q8cxwd75jxvj0idm3hz";
    };
    doCheck = true;
    meta = {
      description = "Calculate the similarity of two strings";
      license = with lib.licenses; [ gpl2 ];
    };
  };

  ShellCommand = buildPerlPackage {
    pname = "Shell-Command";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Shell-Command-0.06.tar.gz";
      sha256 = "1lgc2rb3b5a4lxvbq0cbg08qk0n2i88srxbsz93bwi3razpxxr7k";
    };
  };

  ShellConfigGenerate = buildPerlPackage {
    pname = "Shell-Config-Generate";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Shell-Config-Generate-0.34.tar.gz";
      sha256 = "84f451f22215dd68e9c18aa3f7ddb03a82007d166cfada003d0f166f571e0562";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ ShellGuess ];
    meta = {
      description = "Portably generate config for any shell";
      homepage = "https://metacpan.org/pod/Shell::Config::Generate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ShellGuess = buildPerlPackage {
    pname = "Shell-Guess";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Shell-Guess-0.09.tar.gz";
      sha256 = "4069fa2637e443118ed956d710231d166823d23b2a64eb87b8a46872e865a12b";
    };
    meta = {
      description = "Make an educated guess about the shell in use";
      homepage = "https://metacpan.org/pod/Shell::Guess";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringToIdentifierEN = buildPerlPackage {
    pname = "String-ToIdentifier-EN";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/String-ToIdentifier-EN-0.12.tar.gz";
      sha256 = "12nw7h2yiybhdw0vnnpc7bif8ylhsn6kqf6s39dsrf9h54iq9yrs";
    };
    propagatedBuildInputs = [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
  };

  StringTruncate = buildPerlPackage {
    pname = "String-Truncate";
    version = "1.100602";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100602.tar.gz";
      sha256 = "0vjz4fd4cvcy12gk5bdha7z73ifmfpmk748khha94dhiq3pd98xa";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      description = "A module for when strings are too long to be displayed in...";
      homepage = "https://github.com/rjbs/String-Truncate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringTT = buildPerlPackage {
    pname = "String-TT";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/String-TT-0.03.tar.gz";
      sha256 = "1asjr79wqcl9wk96afxrm1yhpj8lk9bk8kyz78yi5ypr0h55yq7p";
    };
    buildInputs = [ TestException TestSimple13 TestTableDriven ];
    propagatedBuildInputs = [ PadWalker SubExporter TemplateToolkit ];
    meta = {
      description = "Use TT to interpolate lexical variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringUtil = buildPerlModule {
    pname = "String-Util";
    version = "1.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BAKERSCOT/String-Util-1.31.tar.gz";
      sha256 = "0vfjvy04y71f8jsjg0yll28wqlpgn7gbkcrb0i72k0qcliz9mg7v";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "String processing utility functions";
      homepage = "https://github.com/scottchiefbaker/String-Util";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  strip-nondeterminism = callPackage ../development/perl-modules/strip-nondeterminism { };

  StructDumb = buildPerlModule {
    pname = "Struct-Dumb";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Struct-Dumb-0.12.tar.gz";
      sha256 = "0wvzcpil9xc2wkibq3sj8i5bgq4iadx2k7hfqb8jm5p66g271kjj";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Make simple lightweight record-like structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporter = buildPerlPackage {
    pname = "Sub-Exporter";
    version = "0.987";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.987.tar.gz";
      sha256 = "1ml3n1ck4ln9qjm2mcgkczj1jb5n1fkscz9c4x23v4db0glb4g2l";
    };
    propagatedBuildInputs = [ DataOptList ];
    meta = {
      description = "A sophisticated exporter for custom-built routines";
      homepage = "https://github.com/rjbs/Sub-Exporter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterForMethods = buildPerlPackage {
    pname = "Sub-Exporter-ForMethods";
    version = "0.100052";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-ForMethods-0.100052.tar.gz";
      sha256 = "421fbba4f6ffcf13c4335f2c20630d709e6fa659c07545d094dbc5a558ad3006";
    };
    buildInputs = [ namespaceautoclean ];
    propagatedBuildInputs = [ SubExporter SubName ];
    meta = {
      description = "Helper routines for using Sub::Exporter to build methods";
      homepage = "https://github.com/rjbs/Sub-Exporter-ForMethods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterGlobExporter = buildPerlPackage {
    pname = "Sub-Exporter-GlobExporter";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-GlobExporter-0.005.tar.gz";
      sha256 = "0qvsvfvfyk69v2ygjnyd5sh3bgbzd6f7k7mgv0zws1yywvpmxi1g";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      description = "Export shared globs with Sub::Exporter collectors";
      homepage = "https://github.com/rjbs/Sub-Exporter-GlobExporter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterProgressive = buildPerlPackage {
    pname = "Sub-Exporter-Progressive";
    version = "0.001013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz";
      sha256 = "0mn0x8mkh36rrsr58s1pk4srwxh2hbwss7sv630imnk49navfdfm";
    };
    meta = {
      description = "Only use Sub::Exporter if you need it";
      homepage = "https://github.com/frioux/Sub-Exporter-Progressive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubHandlesVia = buildPerlPackage {
    pname = "Sub-HandlesVia";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Sub-HandlesVia-0.016.tar.gz";
      sha256 = "1mgr5igbr0zj8kzlfq7ayh5912i6mz47cx3605s04927wm5d9pk9";
    };
    propagatedBuildInputs = [ ClassMethodModifiers ClassTiny RoleTiny ScalarListUtils TypeTiny ];
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      description = "Alternative handles_via implementation";
      homepage = "https://metacpan.org/release/Sub-HandlesVia";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubIdentify = buildPerlPackage {
    pname = "Sub-Identify";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz";
      sha256 = "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f";
    };
    meta = {
      description = "Retrieve names of code references";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubInfo = buildPerlPackage {
    pname = "Sub-Info";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Sub-Info-0.002.tar.gz";
      sha256 = "ea3056d696bdeff21a99d340d5570887d39a8cc47bff23adfc82df6758cdd0ea";
    };
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Tool for inspecting subroutines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubInstall = buildPerlPackage {
    pname = "Sub-Install";
    version = "0.928";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Install-0.928.tar.gz";
      sha256 = "03zgk1yh128gciyx3q77zxzxg9kf8yy2gm46gdxqi24mcykngrb1";
    };
    meta = {
      description = "Install subroutines into packages easily";
      homepage = "https://github.com/rjbs/Sub-Install";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubName = buildPerlPackage {
    pname = "Sub-Name";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Sub-Name-0.26.tar.gz";
      sha256 = "2d2f2d697d516c89547e7c4307f1e79441641cae2c7395e7319b306d390df105";
    };
    buildInputs = [ BC DevelCheckBin ];
    meta = {
      description = "(Re)name a sub";
      homepage = "https://github.com/p5sagit/Sub-Name";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubOverride = buildPerlPackage {
    pname = "Sub-Override";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Sub-Override-0.09.tar.gz";
      sha256 = "1d955qn44brkcfif3gi0q2vvvqahny6rax0vr068x5i9yz0ng6lk";
    };
    buildInputs = [ TestFatal ];
  };

  SubQuote = buildPerlPackage {
    pname = "Sub-Quote";
    version = "2.006006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz";
      sha256 = "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Efficient generation of subroutines via string eval";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubStrictDecl = buildPerlModule {
    pname = "Sub-StrictDecl";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Sub-StrictDecl-0.005.tar.gz";
      sha256 = "sha256-oSfa52RcGpVwzZopcMbcST1SL/BzGKNKOeQJCY9pESU=";
    };
    propagatedBuildInputs = [ LexicalSealRequireHints ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Detect undeclared subroutines in compilation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubUplevel = buildPerlPackage {
    pname = "Sub-Uplevel";
    version = "0.2800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2800.tar.gz";
      sha256 = "14z2xjiw931wizcx3mblmby753jspvfm321d6chs907nh0xzdwxl";
    };
    meta = {
      description = "Apparently run a function in a higher stack frame";
      homepage = "https://github.com/Perl-Toolchain-Gang/Sub-Uplevel";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SVNSimple = buildPerlPackage {
    pname = "SVN-Simple";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/SVN-Simple-0.28.tar.gz";
      sha256 = "1ysgi38zx236cxz539k6d6rw5z0vc70rrglsaf5fk6rnwilw2g6n";
    };
    propagatedBuildInputs = [ (pkgs.subversionClient.override { inherit perl; }) ];
  };

  SafeHole = buildPerlModule {
    pname = "Safe-Hole";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Safe-Hole-0.14.tar.gz";
      sha256 = "01gc2lfli282dj6a2pkpxb0vmpyavs323cbdw15gxi06pn5nxxgl";
    };
    meta = {
      description = "Lib/Safe/Hole.pm";
      homepage = "http://github.com/toddr/Safe-Hole";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin;
    };
  };

  Swim = buildPerlPackage {
    pname = "Swim";
    version = "0.1.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Swim-0.1.48.tar.gz";
      sha256 = "a5f72fd2f22917fa2b4acbb2ee2c3d32903d97ee5b0e449b0f387018c77f4f0c";
    };
    propagatedBuildInputs = [ HTMLEscape HashMerge IPCRun Pegex TextAutoformat YAMLLibYAML ];
    meta = {
      description = "See What I Mean?!";
      homepage = "https://github.com/ingydotnet/swim-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "swin";
    };
  };

  Switch = buildPerlPackage {
    pname = "Switch";
    version = "2.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz";
      sha256 = "0xbdjdgzfj9zwa4j3ipr8bfk7bcici4hk89hq5d27rhg2isljd9i";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
  };

  SymbolGet = buildPerlPackage {
    pname = "Symbol-Get";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Symbol-Get-0.10.tar.gz";
      sha256 = "0ee5568c5ae3573ca874e09e4d0524466cfc1ad9a2c24d0bc91d4c7b06f21d9c";
    };
    buildInputs = [ TestDeep TestException ];
    propagatedBuildInputs = [ CallContext ];
    meta = {
      description = "Read Perl's symbol table programmatically";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  SymbolGlobalName = buildPerlPackage {
    pname = "Symbol-Global-Name";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Symbol-Global-Name-0.05.tar.gz";
      sha256 = "0f7623e9d724760aa64040222da1d82f1188586791329261cc60dad1d60d6a92";
    };
    meta = {
      description = "Finds name and type of a global variable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SymbolUtil = buildPerlModule {
    pname = "Symbol-Util";
    version = "0.0203";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Symbol-Util-0.0203.tar.gz";
      sha256 = "0cnwwrd5d6i80f33s7n2ak90rh4s53ss7q57wndrpkpr4bfn3djm";
    };
  };

  syntax = buildPerlPackage {
    pname = "syntax";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHAYLON/syntax-0.004.tar.gz";
      sha256 = "fe19b6da8a8f43a5aa2ee571441bc0e339fb156d0081c157a1a24e9812c7d365";
    };
    propagatedBuildInputs = [ DataOptList namespaceclean ];
    meta = {
      description = "Activate syntax extensions";
      homepage = "https://github.com/phaylon/syntax/wiki";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SyntaxKeywordJunction = buildPerlPackage {
    pname = "Syntax-Keyword-Junction";
    version = "0.003008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/Syntax-Keyword-Junction-0.003008.tar.gz";
      sha256 = "8b4975f21b1992a7e6c2df5dcc92b254c61925595eddcdfaf0b1498717aa95ef";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ syntax ];
    meta = {
      description = "Perl6 style Junction operators in Perl5";
      homepage = "https://github.com/frioux/Syntax-Keyword-Junction";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SyntaxKeywordTry = buildPerlModule {
    pname = "Syntax-Keyword-Try";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Syntax-Keyword-Try-0.27.tar.gz";
      sha256 = "sha256-JG4bAz4/8i/VQgVQ1Lbg1WtDjNy7nTXL6LG1uhV03iM=";
    };
    propagatedBuildInputs = [ XSParseKeyword ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "A try/catch/finally syntax for perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  SysMmap = buildPerlPackage {
    pname = "Sys-Mmap";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Sys-Mmap-0.20.tar.gz";
      sha256 = "1kz22l7sh2mibliixyshc9958bqlkzsb13agcibp7azii4ncw80q";
    };
    meta = with lib; {
      description = "Use mmap to map in a file as a Perl variable";
      maintainers = with maintainers; [ peterhoeg ];
      license = with licenses; [ gpl2Plus ];
    };
  };

  SysMemInfo = buildPerlPackage {
    pname = "Sys-MemInfo";
    version = "0.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCRESTO/Sys-MemInfo-0.99.tar.gz";
      sha256 = "0786319d3a3a8bae5d727939244bf17e140b714f52734d5e9f627203e4cf3e3b";
    };
    meta = {
      description = "Memory information";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = [ maintainers.pSub ];
    };
  };

  SysHostnameLong = buildPerlPackage {
    pname = "Sys-Hostname-Long";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/Sys-Hostname-Long-1.5.tar.gz";
      sha256 = "1jv5n8jv48c1p8svjsigyxndv1ygsq8wgwj9c7ypx1vaf3rns679";
    };
    doCheck = false; # no `hostname' in stdenv
  };

  SysSigAction = buildPerlPackage {
    pname = "Sys-SigAction";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.23.tar.gz";
      sha256 = "c4ef6c9345534031fcbbe2adc347fc7194d47afc945e7a44fac7e9563095d353";
    };
    doCheck = !stdenv.isAarch64; # it hangs on Aarch64
    meta = {
      description = "Perl extension for Consistent Signal Handling";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysSyslog = buildPerlPackage {
    pname = "Sys-Syslog";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAPER/Sys-Syslog-0.36.tar.gz";
      sha256 = "ed42a9e5ba04ad4856cc0cb5d38d289c3c5d3764543ec04efafc4af7e3378df8";
    };
    meta = {
      description = "Perl interface to the UNIX syslog(3) calls";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SystemCommand = buildPerlPackage {
    pname = "System-Command";
    version = "1.121";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/System-Command-1.121.tar.gz";
      sha256 = "43de5ecd20c1da46e8a6f4fceab29e04697a2890a99bf6a91b3ca004a468a241";
    };
    propagatedBuildInputs = [ IPCRun ];
    buildInputs = [ PodCoverageTrustPod TestCPANMeta TestPod TestPodCoverage ];
    meta = {
      description = "Object for running system commands";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysVirt = buildPerlModule rec {
    pname = "Sys-Virt";
    version = "8.4.0";
    src = fetchFromGitLab {
      owner = "libvirt";
      repo = "libvirt-perl";
      rev = "v${version}";
      sha256 = "sha256-nw9KG3dO0Oxre2NVp+4Z+kgIluU5j1xOu8grZJRXhik=";
    };
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.libvirt CPANChanges TestPod TestPodCoverage XMLXPath ];
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Libvirt Perl API";
      homepage = "http://libvirt.org";
      license = with lib.licenses; [ gpl1 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.SysVirt.x86_64-darwin
    };
  };

  TAPParserSourceHandlerpgTAP = buildPerlModule {
    pname = "TAP-Parser-SourceHandler-pgTAP";
    version = "3.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.35.tar.gz";
      sha256 = "1655337l1cyd7q62007wrk87q2gbbwfq9xjy1wgx3hyflxpkkvl4";
    };
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Stream TAP from pgTAP test scripts";
      homepage = "https://search.cpan.org/dist/Tap-Parser-Sourcehandler-pgTAP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TaskCatalystTutorial = buildPerlPackage {
    pname = "Task-Catalyst-Tutorial";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/Task-Catalyst-Tutorial-0.06.tar.gz";
      sha256 = "75b1b2d96155647842587146cefd0de30943b85195e8e3eca51e0f0b8642d61e";
    };
    propagatedBuildInputs = [ CatalystAuthenticationStoreDBIxClass CatalystControllerHTMLFormFu CatalystDevel CatalystManual CatalystPluginAuthorizationACL CatalystPluginAuthorizationRoles CatalystPluginSessionStateCookie CatalystPluginSessionStoreFastMmap CatalystPluginStackTrace CatalystViewTT ];
    doCheck = false; /* fails with 'open3: exec of .. perl .. failed: Argument list too long at .../TAP/Parser/Iterator/Process.pm line 165.' */
    meta = {
      description = "Everything you need to follow the Catalyst Tutorial";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TaskFreecellSolverTesting = buildPerlModule {
    pname = "Task-FreecellSolver-Testing";
    version = "0.0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Task-FreecellSolver-Testing-0.0.12.tar.gz";
      sha256 = "19wkz5ii8h90i9gmh692kvw9rz7k9bmpi53pw331fm0jmsvi069x";
    };
    buildInputs = [ CodeTidyAll TestDataSplit TestDifferences TestPerlTidy TestRunPluginTrimDisplayedFilenames TestRunValgrind TestTrailingSpace TestTrap ];
    propagatedBuildInputs = [ EnvPath FileWhich GamesSolitaireVerify InlineC ListMoreUtils MooX StringShellQuote TaskTestRunAllPlugins TemplateToolkit YAMLLibYAML ];
    meta = {
      description = "Install the CPAN dependencies of the Freecell Solver test suite";
      homepage = "http://metacpan.org/release/Task-FreecellSolver-Testing";
      license = with lib.licenses; [ mit ];
    };
  };

  TaskPlack = buildPerlModule {
    pname = "Task-Plack";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Task-Plack-0.28.tar.gz";
      sha256 = "0ajwkyr9nwn11afi6fz6kx4bi7a3p8awjsldmsakz3sl0s42pmbr";
    };
    propagatedBuildInputs = [ CGICompile CGIEmulatePSGI CGIPSGI Corona FCGI FCGIClient FCGIProcManager HTTPServerSimplePSGI IOHandleUtil NetFastCGI PSGI PlackAppProxy PlackMiddlewareAuthDigest PlackMiddlewareConsoleLogger PlackMiddlewareDebug PlackMiddlewareDeflater PlackMiddlewareHeader PlackMiddlewareReverseProxy PlackMiddlewareSession Starlet Starman Twiggy ];
    buildInputs = [ ModuleBuildTiny TestSharedFork ];
  };

  TaskTestRunAllPlugins = buildPerlModule {
    pname = "Task-Test-Run-AllPlugins";
    version = "0.0106";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Task-Test-Run-AllPlugins-0.0106.tar.gz";
      sha256 = "0y6fgldb59mc96lkghmd8n0gdbqaal6hz0cqqadna1jqi3q0p38v";
    };
    buildInputs = [ TestRun TestRunCmdLine TestRunPluginAlternateInterpreters TestRunPluginBreakOnFailure TestRunPluginColorFileVerdicts TestRunPluginColorSummary TestRunPluginTrimDisplayedFilenames ];
    meta = {
      description = "Specifications for installing all the Test::Run";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TaskWeaken = buildPerlPackage {
    pname = "Task-Weaken";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Task-Weaken-1.06.tar.gz";
      sha256 = "1gk6rmnp4x50lzr0vfng41khf0f8yzxlm0pad1j69vxskpdzx0r3";
    };
    meta = {
      description = "Ensure that a platform has weaken support";
      homepage = "https://github.com/karenetheridge/Task-Weaken";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Tcl = buildPerlPackage {
    pname = "Tcl";
    version = "1.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VK/VKON/Tcl-1.27.tar.gz";
      sha256 = "sha256-+DhYd6Sp7Z89OQPS0PfNcPrDzmgyxg9gCmghzuP7WHI=";
    };
    propagatedBuildInputs = [
      pkgs.bwidget
      pkgs.tcl
      pkgs.tix
      pkgs.tk
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices ];
    makeMakerFlags = lib.optionalString stdenv.isLinux
      "--tclsh=${pkgs.tcl}/bin/tclsh --nousestubs";
    meta = {
      description = "Tcl extension module for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TclpTk = buildPerlPackage {
    pname = "Tcl-pTk";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAC/Tcl-pTk-1.09.tar.gz";
      sha256 = "sha256-LR+YBlKS9+W7mBBy9/EkAOjxGVVe4MC5zToPr/pXl24=";
    };
    propagatedBuildInputs = [
      ClassISA
      SubName
      Tcl
      TestDeep
    ];
    buildPhase = ''
      perl Makefile.PL --tclsh "${pkgs.tk.tcl}/bin/tclsh" INSTALL_BASE=$out --no-test-for-tk
    '';
    postInstall = ''
      mkdir -p $out/lib/perl5/site_perl
      mv $out/lib/perl5/Tcl $out/lib/perl5/site_perl/
      mv $out/lib/perl5/auto $out/lib/perl5/site_perl/
    '' + lib.optionalString stdenv.isDarwin ''
      mv $out/lib/perl5/darwin-thread-multi-2level $out/lib/perl5/site_perl/
    '';
    meta = {
      description = "Interface to Tcl/Tk with Perl/Tk compatible syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginAutoformat = buildPerlPackage {
    pname = "Template-Plugin-Autoformat";
    version = "2.77";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KARMAN/Template-Plugin-Autoformat-2.77.tar.gz";
      sha256 = "bddfb4919f0abb2a2be7a9665333e0d4e098032f0e383dbaf04c4d896c7486ed";
    };
    propagatedBuildInputs = [ TemplateToolkit TextAutoformat ];
    meta = {
      description = "TT plugin for Text::Autoformat";
      homepage = "https://github.com/karpet/template-plugin-autoformat";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginClass = buildPerlPackage {
    pname = "Template-Plugin-Class";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Template-Plugin-Class-0.14.tar.gz";
      sha256 = "1hq7jy6zg1iaslsyi05afz0i944y9jnv3nb4krkxjfmzwy5gw106";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
  };

  TemplatePluginIOAll = buildPerlPackage {
    pname = "Template-Plugin-IO-All";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XE/XERN/Template-Plugin-IO-All-0.01.tar.gz";
      sha256 = "1f7445422a21932e09bbef935766e0af6b7cceb088e9d8e030cd7a84bcdc5ee4";
    };
    propagatedBuildInputs = [ IOAll TemplateToolkit ];
    meta = {
      description = "Perl Template Toolkit Plugin for IO::All";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ eelco ];
    };
  };

  TemplatePluginJavaScript = buildPerlPackage {
    pname = "Template-Plugin-JavaScript";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Template-Plugin-JavaScript-0.02.tar.gz";
      sha256 = "1mqqqs0dhfr6bp1305j9ns05q4pq1n3f561l6p8848k5ml3dh87a";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
  };

  TemplatePluginJSONEscape = buildPerlPackage {
    pname = "Template-Plugin-JSON-Escape";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NANTO/Template-Plugin-JSON-Escape-0.02.tar.gz";
      sha256 = "051a8b1d3bc601d58fc51e246067d36450cfe970278a0456e8ab61940f13cd86";
    };
    propagatedBuildInputs = [ JSON TemplateToolkit ];
  };

  TemplateTimer = buildPerlPackage {
    pname = "Template-Timer";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-1.00.tar.gz";
      sha256 = "1d3pbcx1kz73ncg8s8lx3ifwphz838qy0m40gdar7790cnrlqcdp";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Rudimentary profiling for Template Toolkit";
      license = with lib.licenses; [ artistic2 gpl3 ];
    };
  };

  TemplateTiny = buildPerlPackage {
    pname = "Template-Tiny";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Template-Tiny-1.12.tar.gz";
      sha256 = "073e062c630b51dfb725cd6485a329155cb72d5c596e8cb698eb67c4566f0a4a";
    };
    meta = {
      description = "Template Toolkit reimplemented in as little code as possible";
      homepage = "https://github.com/karenetheridge/Template-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplateToolkit = buildPerlPackage {
    pname = "Template-Toolkit";
    version = "3.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/Template-Toolkit-3.009.tar.gz";
      sha256 = "1dpmy62x1yshf7kwslj85sc8bcgw1m30dh0szmfrp99pysxj7bfn";
    };
    doCheck = !stdenv.isDarwin;
    propagatedBuildInputs = [ AppConfig ];
    buildInputs = [ CGI TestLeakTrace ];
    meta = {
      description = "Comprehensive template processing system";
      homepage = "http://www.template-toolkit.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplateGD = buildPerlPackage {
    pname = "Template-GD";
    version = "2.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/Template-GD-2.66.tar.gz";
      sha256 = "98523c8192f2e8184042e5a2e172bd767ac289dd2e480f35f680dce32160905b";
    };
    propagatedBuildInputs = [ GD TemplateToolkit ];
    meta = {
      description = "GD plugin(s) for the Template Toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermEncoding = buildPerlPackage {
    pname = "Term-Encoding";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Term-Encoding-0.03.tar.gz";
      sha256 = "95ba9687d735d25a3cbe64508d7894f009c7fa2a1726c3e786e9e21da2251d0b";
    };
    meta = {
      description = "Detect encoding of the current terminal";
      homepage = "https://github.com/miyagawa/Term-Encoding";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBar = buildPerlPackage {
    pname = "Term-ProgressBar";
    version = "2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/Term-ProgressBar-2.22.tar.gz";
      sha256 = "2642ecca5b0b038c14812bcad3a9611ff7911dc59c9104d220797f837a880c49";
    };
    buildInputs = [ CaptureTiny TestException TestWarnings ];
    propagatedBuildInputs = [ ClassMethodMaker TermReadKey ];
    meta = {
      description = "Provide a progress meter on a standard terminal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarQuiet = buildPerlPackage {
    pname = "Term-ProgressBar-Quiet";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/Term-ProgressBar-Quiet-0.31.tar.gz";
      sha256 = "25675292f588bc29d32e710cf3667da9a2a1751e139801770a9fdb18cd2184a6";
    };
    propagatedBuildInputs = [ IOInteractive TermProgressBar ];
    buildInputs = [ TestMockObject ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarSimple = buildPerlPackage {
    pname = "Term-ProgressBar-Simple";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVDB/Term-ProgressBar-Simple-0.03.tar.gz";
      sha256 = "a20db3c67d5bdfd0c1fab392c6d1c26880a7ee843af602af4f9b53a7043579a6";
    };
    propagatedBuildInputs = [ TermProgressBarQuiet ];
    buildInputs = [ TestMockObject ];
  };

  TermReadKey = let
    cross = stdenv.hostPlatform != stdenv.buildPlatform;
  in buildPerlPackage {
    pname = "TermReadKey";
    version = "2.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz";
      sha256 = "143jlibah1g14bym7sj3gphvqkpj1w4vn7sqc4vc62jpviw5hr2s";
    };

    # use native libraries from the host when running build commands
    postConfigure = lib.optionalString cross (let
      host_perl = buildPerl;
      host_self = buildPerl.pkgs.TermReadKey;
      perl_lib = "${host_perl}/lib/perl5/${host_perl.version}";
      self_lib = "${host_self}/lib/perl5/site_perl/${host_perl.version}";
    in ''
      sed -ie 's|"-I$(INST_ARCHLIB)"|"-I${perl_lib}" "-I${self_lib}"|g' Makefile
    '');

    # TermReadKey uses itself in the build process
    nativeBuildInputs = lib.optionals cross [
      buildPerl.pkgs.TermReadKey
    ];
  };

  TermReadLineGnu = buildPerlPackage {
    pname = "Term-ReadLine-Gnu";
    version = "1.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.36.tar.gz";
      sha256 = "9a08f7a4013c9b865541c10dbba1210779eb9128b961250b746d26702bab6925";
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
      description = "Perl extension for the GNU Readline/History Library";
      homepage = "https://github.com/hirooih/perl-trg";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "perlsh";
    };
  };

  TermReadLineTTYtter = buildPerlPackage {
    pname = "Term-ReadLine-TTYtter";
    version = "1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz";
      sha256 = "14xcqhg1vrwgv65nd2z8xzn0wgb18i17pzkkh8m15cp1rqrk2dxc";
    };

    outputs = [ "out" ];

    meta = {
      description = "A Term::ReadLine driver based on Term::ReadLine::Perl, with special features for microblogging and the TTYtter client (q.v)";
      homepage = "http://www.floodgap.com/software/ttytter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermReadPassword = buildPerlPackage rec {
    pname = "Term-ReadPassword";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHOENIX/${pname}-${version}.tar.gz";
      sha256 = "08s3zdqbr01qf4h8ryc900qq1cjcdlyy2dq0gppzzy9mbcs6da71";
    };

    outputs = [ "out" ];

    meta = {
      description = "This module lets you ask the user for a password in the traditional way, from the keyboard, without echoing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermShell = buildPerlModule {
    pname = "Term-Shell";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Term-Shell-0.12.tar.gz";
      sha256 = "1mrx7g74qvkdis7x7zq1zs0b7q2fsz59g4hxvg140r8bq1wzav3x";
    };
    propagatedBuildInputs = [ TermReadKey TextAutoformat ];
    meta = with lib; {
      homepage = "https://metacpan.org/release/Term-Shell";
      description = "A simple command-line shell framework";
      license = with licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermShellUI = buildPerlPackage {
    pname = "Term-ShellUI";
    version = "0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRONSON/Term-ShellUI-0.92.tar.gz";
      sha256 = "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb";
    };
  };

  TermSizeAny = buildPerlPackage {
    pname = "Term-Size-Any";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz";
      sha256 = "64fa5fdb1ae3a823134aaa95aec75354bc17bdd9ca12ba0a7ae34a7e51b3ded2";
    };
    propagatedBuildInputs = [ DevelHide TermSizePerl ];
    meta = {
      description = "Retrieve terminal size";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermSizePerl = buildPerlPackage {
    pname = "Term-Size-Perl";
    version = "0.031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Perl-0.031.tar.gz";
      sha256 = "ae9a6746cb1b305ddc8f8d8ca46878552b9c1123628971e13a275183822f209e";
    };
    meta = {
      description = "Perl extension for retrieving terminal size (Perl version)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermTable = buildPerlPackage {
    pname = "Term-Table";
    version = "0.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Term-Table-0.015.tar.gz";
      sha256 = "d8a18b2801f91f0e5d747147ce786964a76f91d18568652908a3dc06a9b948d5";
    };
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Format a header and rows into a table";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermSk = buildPerlPackage {
    pname = "Term-Sk";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KEICHNER/Term-Sk-0.18.tar.gz";
      sha256 = "f2e491796061205b08688802b287792d7d803b08972339fb1070ba05612af885";
    };
    meta = {
      description = "Perl extension for displaying a progress indicator on a terminal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermUI = buildPerlPackage {
    pname = "Term-UI";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Term-UI-0.46.tar.gz";
      sha256 = "19p92za5cx1v7g57pg993amprcvm1az3pp7y9g5b1aplsy06r54i";
    };
    propagatedBuildInputs = [ LogMessageSimple ];
    meta = {
      description = "User interfaces via Term::ReadLine made easy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermVT102 = buildPerlPackage {
    pname = "Term-VT102";
    version = "0.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AJ/AJWOOD/Term-VT102-0.91.tar.gz";
      sha256 = "f954e0310941d45c0fc3eb4a40f5d3a00d68119e277d303a1e6af11ded6fbd94";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  TermVT102Boundless = buildPerlPackage {
    pname = "Term-VT102-Boundless";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FB/FBARRIOS/Term-VT102-Boundless-0.05.tar.gz";
      sha256 = "e1ded85ae3d76b59c03b8697f4a6cb01ae31bd62a9354f5bb7d18f9e927b485f";
    };
    propagatedBuildInputs = [ TermVT102 ];
  };

  TermAnimation = buildPerlPackage {
    pname = "Term-Animation";
    version = "2.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz";
      sha256 = "7d5c3c2d4f9b657a8b1dce7f5e2cbbe02ada2e97c72f3a0304bf3c99d084b045";
    };
    propagatedBuildInputs = [ Curses ];
    meta = {
      description = "ASCII sprite animation framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test2Harness = buildPerlPackage {
    pname = "Test2-Harness";
    version = "1.000042";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Harness-1.000042.tar.gz";
      sha256 = "aaf231a68af1a6ffd6a11188875fcf572e373e43c8285945227b9d687b43db2d";
    };

    checkPhase = ''
      patchShebangs ./t ./scripts/yath
      ./scripts/yath test -j $NIX_BUILD_CORES
    '';

    propagatedBuildInputs = [ DataUUID Importer LongJump ScopeGuard TermTable Test2PluginMemUsage Test2PluginUUID Test2Suite gotofile ];
    meta = {
      description = "A new and improved test harness with better Test2 integration";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "yath";
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Test2Harness.x86_64-darwin
    };
  };

  Test2PluginMemUsage = buildPerlPackage {
    pname = "Test2-Plugin-MemUsage";
    version = "0.002003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Plugin-MemUsage-0.002003.tar.gz";
      sha256 = "5e0662d5a823ae081641f5ce82843111eec1831cd31f883a6c6de54afdf87c25";
    };
    buildInputs = [ Test2Suite ];
    meta = {
      description = "Collect and display memory usage information";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test2PluginUUID = buildPerlPackage {
    pname = "Test2-Plugin-UUID";
    version = "0.002001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Plugin-UUID-0.002001.tar.gz";
      sha256 = "4c6c8d484d7153d8779dc155a992b203095b5c5aa1cfb1ee8bcedcd0601878c9";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ DataUUID ];
    meta = {
      description = "Use REAL UUIDs in Test2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test2PluginNoWarnings = buildPerlPackage {
    pname = "Test2-Plugin-NoWarnings";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Test2-Plugin-NoWarnings-0.09.tar.gz";
      sha256 = "0x7vy9r5gyxqg3qy966frj8ywkckkv7mc83xy4mkdvrf0h0dhgdy";
    };
    buildInputs = [ IPCRun3 Test2Suite ];
    propagatedBuildInputs = [ TestSimple13 ];
    meta = {
      description = "Fail if tests warn";
      homepage = "https://metacpan.org/release/Test2-Plugin-NoWarnings";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  Test2Suite = buildPerlPackage {
    pname = "Test2-Suite";
    version = "0.000138";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Suite-0.000138.tar.gz";
      sha256 = "0x887d8y657k7072k5f5ly36f067ldafm27xbd9lh5nirvr2vxqc";
    };
    propagatedBuildInputs = [ ModulePluggable ScopeGuard SubInfo TermTable TestSimple13 ];
    meta = {
      description = "Distribution with a rich set of tools built upon the Test2 framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestAbortable = buildPerlPackage {
    pname = "Test-Abortable";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Abortable-0.002.tar.gz";
      sha256 = "0v97y31j56f4mxw0vxyjbdprq4951h4wcdh4acnfm63np7wvg44p";
    };
    propagatedBuildInputs = [ SubExporter ];
    buildInputs = [ TestNeeds ];
    meta = {
      description = "Subtests that you can die your way out of ... but survive";
      homepage = "https://github.com/rjbs/Test-Abortable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestAssert = buildPerlModule {
    pname = "Test-Assert";
    version = "0.0504";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Test-Assert-0.0504.tar.gz";
      sha256 = "194bzflmzc0cw5727kznbj1zwzj7gnj7nx1643zk2hshdjlnv8yg";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
  };

  TestAssertions = buildPerlPackage {
    pname = "Test-Assertions";
    version = "1.054";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBC/Test-Assertions-1.054.tar.gz";
      sha256 = "10026w4r3yv6k3vc6cby7d61mxddlqh0ls6z39c82f17awfy9p7w";
    };
    propagatedBuildInputs = [ LogTrace ];
  };

  TestAggregate = buildPerlModule {
    pname = "Test-Aggregate";
    version = "0.375";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/Test-Aggregate-0.375.tar.gz";
      sha256 = "c6cc0abfd0d4fce85371acca93ec245381841d32b4caa2d6475e4bc8130427d1";
    };
    buildInputs = [ TestMost TestNoWarnings TestTrap ];
    meta = {
      description = "Aggregate *.t tests to make them run faster";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = true; # This module only works with Test::More version < 1.3, but you have 1.302133
    };
  };


  TestBase = buildPerlPackage {
    pname = "Test-Base";
    version = "0.89";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Test-Base-0.89.tar.gz";
      sha256 = "056hibgg3i2b89mwr76vyxi6ayb3hqjqcwicvn3s5lximsma3517";
    };
    propagatedBuildInputs = [ Spiffy ];
    buildInputs = [ AlgorithmDiff TextDiff ];
  };

  TestBits = buildPerlPackage {
    pname = "Test-Bits";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Test-Bits-0.02.tar.gz";
      sha256 = "1hqbvqlkj3k9ys4zq3f1fl1y6crni8r0ynan673f49rs91b6z0m9";
    };
    propagatedBuildInputs = [ ListAllUtils ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Provides a bits_is() subroutine for testing binary data";
      homepage = "http://metacpan.org/release/Test-Bits";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestCheckDeps = buildPerlPackage {
    pname = "Test-CheckDeps";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Test-CheckDeps-0.010.tar.gz";
      sha256 = "1vjinlixxdx6gfcw8y1dw2rla8bfhi8nmgcqr3nffc7kqskcrz36";
    };
    propagatedBuildInputs = [ CPANMetaCheck ];
    meta = {
      description = "Check for presence of dependencies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestClass = buildPerlPackage {
    pname = "Test-Class";
    version = "0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Class-0.50.tar.gz";
      sha256 = "099154ed8caf3ff97c71237fab952264ac1c03d9270737a56071cabe65991350";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ MROCompat ModuleRuntime TryTiny ];
    meta = {
      description = "Easily create test classes in an xUnit/JUnit style";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestClassMost = buildPerlModule {
    pname = "Test-Class-Most";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Test-Class-Most-0.08.tar.gz";
      sha256 = "1zvx9hil0mg0pnb8xfa4m0xgjpvh8s5gnbyprq3xwpdsdgcdwk33";
    };
    buildInputs = [ TestClass TestDeep TestDifferences TestException TestMost TestWarn ];
    meta = {
      description = "Test Classes the easy way";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCleanNamespaces = buildPerlPackage {
    pname = "Test-CleanNamespaces";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-CleanNamespaces-0.24.tar.gz";
      sha256 = "338d5569e8e89a654935f843ec0bc84aaa486fe8dd1898fb9cab3eccecd5327a";
    };
    buildInputs = [ Filepushd Moo Mouse RoleTiny SubExporter TestDeep TestNeeds TestWarnings namespaceclean ];
    propagatedBuildInputs = [ PackageStash SubIdentify ];
    meta = {
      description = "Check for uncleaned imports";
      homepage = "https://github.com/karenetheridge/Test-CleanNamespaces";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCmd = buildPerlPackage {
    pname = "Test-Cmd";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Test-Cmd-1.09.tar.gz";
      sha256 = "114nfafwfxxn7kig265b7lg0znb5ybvc282sjjwf14g7vpn20cyg";
    };
      doCheck = false; /* test fails */
    meta = {
      description = "Perl module for portable testing of commands and scripts";
      homepage = "https://github.com/neilb/Test-Cmd";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCommand = buildPerlModule {
    pname = "Test-Command";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBOO/Test-Command-0.11.tar.gz";
      sha256 = "0cwm3c4d49mdrbm6vgh78b3x8mk730l0zg8i7xb9z8bkx9pzr8r8";
    };
    meta = {
      description = "Test routines for external commands";
      homepage = "https://metacpan.org/release/Test-Command";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCompile = buildPerlModule {
    pname = "Test-Compile";
    version = "2.4.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EG/EGILES/Test-Compile-v2.4.1.tar.gz";
      sha256 = "56a7a3459db5de0f92419029cf1b4d51c44dd02d4690cff3c4eedf666f6d8d46";
    };
    propagatedBuildInputs = [ UNIVERSALrequire ];
    meta = {
      description = "Assert that your Perl files compile OK";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCPANMeta = buildPerlPackage {
    pname = "Test-CPAN-Meta";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-0.25.tar.gz";
      sha256 = "f55b4f9cf6bc396d0fe8027267685cb2ac4affce897d0967a317fac6db5a8db5";
    };
    meta = {
      description = "Validate your CPAN META.json files";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestCPANMetaJSON = buildPerlPackage {
    pname = "Test-CPAN-Meta-JSON";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-JSON-0.16.tar.gz";
      sha256 = "1jg9ka50ixwq083wd4k12rhdjq87w0ihb34gd8jjn7gvvyd51b37";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Validate your CPAN META.json files";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestDataSplit = buildPerlModule {
    pname = "Test-Data-Split";
    version = "0.2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Data-Split-0.2.2.tar.gz";
      sha256 = "08l0h9xkikj6ggm24dark2hp9wffypanjdbha3gdfc5dmn83h275";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ IOAll ListMoreUtils MooX MooXlate ];
    meta = {
      description = "Split data-driven tests into several test scripts";
      homepage = "http://metacpan.org/release/Test-Data-Split";
      license = with lib.licenses; [ mit ];
    };
  };

  TestDeep = buildPerlPackage {
    pname = "Test-Deep";
    version = "1.130";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-1.130.tar.gz";
      sha256 = "0mkw18q5agr30djxr1y68rcfw8aq20ws872hmv88f9gnynag8r20";
    };
    meta = {
      homepage = "http://github.com/rjbs/Test-Deep";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDeepJSON = buildPerlModule {
    pname = "Test-Deep-JSON";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MOTEMEN/Test-Deep-JSON-0.05.tar.gz";
      sha256 = "aec8571b9e31b7301e26132c132c6800952dc089c645d76954a3ad1a6b350858";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ ExporterLite JSONMaybeXS TestDeep ];
    meta = {
      description = "Compare JSON with Test::Deep";
      homepage = "https://github.com/motemen/perl5-Test-Deep-JSON";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDeepType = buildPerlPackage {
    pname = "Test-Deep-Type";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Deep-Type-0.008.tar.gz";
      sha256 = "6e7bea1a2f1e75319a22d1c51996ebac50ca5e3663d1bc223130887e62e959f1";
    };
    buildInputs = [ TestFatal TestNeeds ];
    propagatedBuildInputs = [ TestDeep TryTiny ];
    meta = {
      description = "A Test::Deep plugin for validating type constraints";
      homepage = "https://github.com/karenetheridge/Test-Deep-Type";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDir = buildPerlPackage {
    pname = "Test-Dir";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MT/MTHURN/Test-Dir-1.16.tar.gz";
      sha256 = "7332b323913eb6a2684d094755196304b2f8606f70eaab913654ca91f273eac2";
    };
    meta = {
      description = "Test directory attributes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDifferences = buildPerlPackage {
    pname = "Test-Differences";
    version = "0.67";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Test-Differences-0.67.tar.gz";
      sha256 = "c88dbbb48b934b069284874f33abbaaa438aa31204aa3fa73bfc2f4aeac878da";
    };
    propagatedBuildInputs = [ CaptureTiny TextDiff ];
    meta = {
      description = "Test strings and data structures and show differences if not ok";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDistManifest = buildPerlModule {
    pname = "Test-DistManifest";
    version = "1.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-DistManifest-1.014.tar.gz";
      sha256 = "3d26c20df42628981cbfcfa5b1ca028c6ceadb344c1dcf97a25ad6a88b73d7c5";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ ModuleManifest ];
    meta = {
      description = "Author test that validates a package MANIFEST";
      homepage = "https://github.com/jawnsy/Test-DistManifest";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestEOL = buildPerlPackage {
    pname = "Test-EOL";
    version = "2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-EOL-2.02.tar.gz";
      sha256 = "1i5g40bx72fh0nszxh75v042bp66f4jv3xva4bi7z017zgbrjc98";
    };
    meta = {
      description = "Check the correct line endings in your project";
      homepage = "https://github.com/karenetheridge/Test-EOL";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestException = buildPerlPackage {
    pname = "Test-Exception";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-Exception-0.43.tar.gz";
      sha256 = "0cxm7s4bg0xpxa6l6996a6iq3brr4j7p4hssnkc6dxv4fzq16sqm";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestExpect = buildPerlPackage {
    pname = "Test-Expect";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Test-Expect-0.34.tar.gz";
      sha256 = "2628fcecdda5f649bd25323f646b96a1a07e4557cadcb327c9bad4dc41bbb999";
    };
    propagatedBuildInputs = [ ClassAccessorChained ExpectSimple ];
    meta = {
      description = "Automated driving and testing of terminal-based programs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFailWarnings = buildPerlPackage {
    pname = "Test-FailWarnings";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-FailWarnings-0.008.tar.gz";
      sha256 = "0vx9chcp5x8m0chq574p9fnfckh5gl94j7904rh9v17n568fyd6s";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      description = "Add test failures if warnings are caught";
      homepage = "https://github.com/dagolden/Test-FailWarnings";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TestFakeHTTPD = buildPerlModule {
    pname = "Test-Fake-HTTPD";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MASAKI/Test-Fake-HTTPD-0.09.tar.gz";
      sha256 = "07iddzxkgxk0ym2gz3scmrw9gmnk755qwksmpvlj42d9cyq9rxql";
    };
    propagatedBuildInputs = [ HTTPDaemon Plack ];
    buildInputs = [ LWP ModuleBuildTiny TestException TestSharedFork TestTCP TestUseAllModules ];
    meta = {
      description = "A fake HTTP server";
      homepage = "https://github.com/masaki/Test-Fake-HTTPD";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFatal = buildPerlPackage {
    pname = "Test-Fatal";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Fatal-0.016.tar.gz";
      sha256 = "7283d430f2ba2030b8cd979ae3039d3f1b2ec3dde1a11ca6ae09f992a66f788f";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      description = "Incredibly simple helpers for testing code with exceptions";
      homepage = "https://github.com/rjbs/Test-Fatal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFile = buildPerlPackage {
    pname = "Test-File";
    version = "1.443";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-File-1.443.tar.gz";
      sha256 = "61b4a6ab8f617c8c7b5975164cf619468dc304b6baaaea3527829286fa58bcd5";
    };
    buildInputs = [ Testutf8 ];
    meta = {
      description = "Test file attributes";
      homepage = "https://github.com/briandfoy/test-file";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestFileContents = buildPerlModule {
    pname = "Test-File-Contents";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/Test-File-Contents-0.23.tar.gz";
      sha256 = "cd6fadfb910b34b4b53991ff231dad99929ca8850abec3ad0e2810c4bd7b1f3d";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      description = "Test routines for examining the contents of files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFileShareDir = buildPerlPackage {
    pname = "Test-File-ShareDir";
    version = "1.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KENTNL/Test-File-ShareDir-1.001002.tar.gz";
      sha256 = "b33647cbb4b2f2fcfbde4f8bb4383d0ac95c2f89c4c5770eb691f1643a337aad";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassTiny FileCopyRecursive FileShareDir PathTiny ScopeGuard ];
    meta = {
      description = "Create a Fake ShareDir for your modules for testing";
      homepage = "https://github.com/kentnl/Test-File-ShareDir";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFilename = buildPerlPackage {
    pname = "Test-Filename";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Filename-0.03.tar.gz";
      sha256 = "1gpw4mjw68gnby8s4cifvbz6g2923xsc189jkw9d27i8qv20qiba";
    };
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Portable filename comparison";
      homepage = "https://metacpan.org/release/Test-Filename";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TestFork = buildPerlModule {
    pname = "Test-Fork";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Fork-0.02.tar.gz";
      sha256 = "0gnh8m81fdrwmzy1fix12grfq7sf7nn0gbf24zlap1gq4kxzpzpw";
    };
    meta = {
      description = "Test code which forks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarnessStraps = buildPerlModule {
    pname = "Test-Harness-Straps";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Harness-Straps-0.30.tar.gz";
      sha256 = "8b00efaa35723c1a35c8c8f5fa46a99e4bc528dfa520352b54ac418ef6d1cfa8";
    };
    meta = {
      description = "Detailed analysis of test results";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHexDifferences = buildPerlPackage {
    pname = "Test-HexDifferences";
    version = "1.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Test-HexDifferences-1.001.tar.gz";
      sha256 = "18lh6shpfx567gjikrid4hixydgv1hi3mycl20qzq2j2vpn4afd6";
    };
    propagatedBuildInputs = [ SubExporter TextDiff ];
    buildInputs = [ TestDifferences TestNoWarnings ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  TestHexString = buildPerlModule {
    pname = "Test-HexString";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-HexString-0.03.tar.gz";
      sha256 = "0h1zl2l1ljlcxsn0xvin9dwiymnhyhnfnxgzg3f9899g37f4qk3x";
    };
    meta = {
      description = "Test binary strings with hex dump diagnostics";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestIdentity = buildPerlModule {
    pname = "Test-Identity";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Identity-0.01.tar.gz";
      sha256 = "08szivpqfwxnf6cfh0f0rfs4f7xbaxis3bra31l2c5gdk800a0ig";
    };
    meta = {
      description = "Assert the referential identity of a reference";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHTTPServerSimple = buildPerlPackage {
    pname = "Test-HTTP-Server-Simple";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Test-HTTP-Server-Simple-0.11.tar.gz";
      sha256 = "85c97ebd4deb805291b17277032da48807228f24f89b1ce2fb3c09f7a896bb78";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Test::More functions for HTTP::Server::Simple";
      license = with lib.licenses; [ unfree ];
    };
  };

  TestJSON = buildPerlModule {
    pname = "Test-JSON";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Test-JSON-0.11.tar.gz";
      sha256 = "1cyp46w3q7dg89qkw31ik2h2a6mdx6pzdz2lmp8m0a61zjr8mh07";
    };
    propagatedBuildInputs = [ JSONAny ];
    buildInputs = [ TestDifferences ];
  };

  TestKwalitee = buildPerlPackage {
    pname = "Test-Kwalitee";
    version = "1.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Kwalitee-1.28.tar.gz";
      sha256 = "18s3c8qfr3kmmyxmsn5la2zgbdsgpnkmscnl68i7fnavfpfnqlxl";
    };
    propagatedBuildInputs = [ ModuleCPANTSAnalyse ];
    buildInputs = [ CPANMetaCheck TestDeep TestWarnings ];
    meta = {
      description = "Test the Kwalitee of a distribution before you release it";
      homepage = "https://github.com/karenetheridge/Test-Kwalitee";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "kwalitee-metrics";
    };
  };

  TestLWPUserAgent = buildPerlPackage {
    pname = "Test-LWP-UserAgent";
    version = "0.036";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-LWP-UserAgent-0.036.tar.gz";
      sha256 = "sha256-BTJ1MNNGuAphpulD+9dJmGvcqJIRpOswHAjC0XkxThE=";
    };
    propagatedBuildInputs = [ LWP SafeIsa namespaceclean ];
    buildInputs = [ PathTiny Plack TestDeep TestFatal TestNeeds TestRequiresInternet TestWarnings ];
    meta = {
      description = "A LWP::UserAgent suitable for simulating and testing network calls";
      homepage = "https://github.com/karenetheridge/Test-LWP-UserAgent";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLeakTrace = buildPerlPackage {
    pname = "Test-LeakTrace";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/Test-LeakTrace-0.16.tar.gz";
      sha256 = "00z4hcjra5nk700f3fgpy8fs036d7ry7glpn8g3wh7jzj7nrw22z";
    };
    meta = {
      description = "Traces memory leaks";
      homepage = "https://metacpan.org/release/Test-LeakTrace";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLectroTest = buildPerlPackage {
    pname = "Test-LectroTest";
    version = "0.5001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMOERTEL/Test-LectroTest-0.5001.tar.gz";
      sha256 = "0dfpkvn06499gczch4gfmdb05fdj82vlqy7cl6hz36l9jl6lyaxc";
    };
    meta = {
      description = "Easy, automatic, specification-based tests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLoadAllModules = buildPerlPackage {
    pname = "Test-LoadAllModules";
    version = "0.022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KI/KITANO/Test-LoadAllModules-0.022.tar.gz";
      sha256 = "1zjwbqk1ns9m8srrhyj3i5zih976i4d2ibflh5s8lr10a1aiz1hv";
    };
    propagatedBuildInputs = [ ListMoreUtils ModulePluggable ];
    meta = {
      description = "Do use_ok for modules in search path";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLongString = buildPerlPackage {
    pname = "Test-LongString";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/Test-LongString-0.17.tar.gz";
      sha256 = "0kwp7rfr1i2amz4ckigkv13ah7jr30q6l5k4wk0vxl84myg39i5b";
    };
  };

  TestMemoryCycle = buildPerlPackage {
    pname = "Test-Memory-Cycle";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-Memory-Cycle-1.06.tar.gz";
      sha256 = "9d53ddfdc964cd8454cb0da4c695b6a3ae47b45839291c34cb9d8d1cfaab3202";
    };
    propagatedBuildInputs = [ DevelCycle PadWalker ];
    meta = {
      description = "Verifies code hasn't left circular references";
      license = with lib.licenses; [ unfree ];
    };
  };

  TestMemoryGrowth = buildPerlModule {
    pname = "Test-MemoryGrowth";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-MemoryGrowth-0.04.tar.gz";
      sha256 = "1l1f7mwjyfgfbhad13p4wgavnb3mdjs6v3xr2m0rxm5ba8kqard0";
    };
    meta = {
      description = "Assert that code does not cause growth in memory usage";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.TestMemoryGrowth.x86_64-darwin
    };
  };

  TestMetricsAny = buildPerlModule {
    pname = "Test-Metrics-Any";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Metrics-Any-0.01.tar.gz";
      sha256 = "0s744lv997g1wr4i4vg1d7zpzjfw334hdy45215jf6xj9s6wh1i5";
    };
    propagatedBuildInputs = [ MetricsAny ];
    meta = {
      description = "Assert that code produces metrics via Metrics::Any";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockClass = buildPerlModule {
    pname = "Test-Mock-Class";
    version = "0.0303";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Test-Mock-Class-0.0303.tar.gz";
      sha256 = "00pkfqcz7b34q1mvx15k46sbxs22zcrvrbv15rnbn2na57z54bnd";
    };
    buildInputs = [ ClassInspector TestAssert TestUnitLite ];
    propagatedBuildInputs = [ FatalException Moose namespaceclean ];
    meta = with lib; {
      description = "Simulating other classes";
      license = licenses.lgpl2Plus;
    };
  };

  TestMockGuard = buildPerlModule {
    pname = "Test-Mock-Guard";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/Test-Mock-Guard-0.10.tar.gz";
      sha256 = "7f228a63f8d6ceb92aa784080a13e85073121b2835eca06d794f9709950dbd3d";
    };
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      description = "Simple mock test library using RAII";
      homepage = "https://github.com/zigorou/p5-test-mock-guard";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockHTTPTiny = buildPerlPackage {
    pname = "Test-Mock-HTTP-Tiny";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OD/ODYNIEC/Test-Mock-HTTP-Tiny-0.002.tar.gz";
      sha256 = "sha256-+c+tfYUEZQvtNJO8bSyoLXuRvDcTyGxDXnXriKxb5eY=";
    };
    propagatedBuildInputs = [ TestDeep URI ];
    meta = {
      description = "Record and replay HTTP requests/responses with HTTP::Tiny";
      homepage = "https://github.com/odyniec/p5-Test-Mock-HTTP-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockModule = buildPerlModule {
    pname = "Test-MockModule";
    version = "0.175.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFRANKS/Test-MockModule-v0.175.0.tar.gz";
      sha256 = "1zpf8p04and7jj33pc919g2pfg0scaqwqq1cnk8wx0nx2gbq9ch7";
    };
    propagatedBuildInputs = [ SUPER ];
    buildInputs = [ TestWarnings ];
  };

  SUPER = buildPerlModule {
    pname = "SUPER";
    version = "1.20190531";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/SUPER-1.20190531.tar.gz";
      sha256 = "685d1ee76e7f0e9006942923bf7df8b11c107132992917593dcf7397d417d39a";
    };
    propagatedBuildInputs = [ SubIdentify ];
    meta = {
      description = "Control superclass method dispatch";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  TestMockObject = buildPerlPackage {
    pname = "Test-MockObject";
    version = "1.20200122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20200122.tar.gz";
      sha256 = "2b7f80da87f5a6fe0360d9ee521051053017442c3a26e85db68dfac9f8307623";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ UNIVERSALcan UNIVERSALisa ];
    meta = {
      description = "Perl extension for emulating troublesome interfaces";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockTime = buildPerlPackage {
    pname = "Test-MockTime";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/Test-MockTime-0.17.tar.gz";
      sha256 = "1y820qsq7yf7r6smy5c6f0mpf2cis2q24vwmpim1svv0n8cf2qrk";
    };
  };

  TestMockTimeHiRes = buildPerlModule {
    pname = "Test-MockTime-HiRes";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TA/TARAO/Test-MockTime-HiRes-0.08.tar.gz";
      sha256 = "1hfykcjrls6ywgbd49w29c7apj3nq4wlyx7jzpd2glwmz2pgfjaz";
    };
    buildInputs = [ AnyEvent ModuleBuildTiny TestClass TestMockTime TestRequires ];
    meta = {
      description = "Replaces actual time with simulated high resolution time";
      homepage = "https://github.com/tarao/perl5-Test-MockTime-HiRes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMojibake = buildPerlPackage {
    pname = "Test-Mojibake";
    version = "1.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYP/Test-Mojibake-1.3.tar.gz";
      sha256 = "0cqvbwddgh0pfzmh989gkysi9apqj7dp7jkxfa428db9kgzpbzlg";
    };
    meta = {
      description = "Check your source for encoding misbehavior";
      homepage = "https://github.com/creaktive/Test-Mojibake";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "scan_mojibake";
    };
  };

  TestMoreUTF8 = buildPerlPackage {
    pname = "Test-More-UTF8";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MONS/Test-More-UTF8-0.05.tar.gz";
      sha256 = "016fs77lmw8xxrcnapvp6wq4hjwgsdfi3l9ylpxgxkcpdarw9wdr";
    };
    meta = {
      description = "Enhancing Test::More for UTF8-based projects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMost = buildPerlPackage {
    pname = "Test-Most";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Test-Most-0.37.tar.gz";
      sha256 = "1isg8z6by113zn08l044w6k04y5m5bnns3rqmks8rwdr3qa70csk";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    buildInputs = [ TestDeep TestDifferences TestException TestWarn ];
    meta = {
      description = "Most commonly needed test functions and features";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Testmysqld = buildPerlModule {
    pname = "Test-mysqld";
    version = "1.0013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SO/SONGMU/Test-mysqld-1.0013.tar.gz";
      sha256 = "1vrybrh3is3xfwqdhxr1mvmmdyjhz9p0f6n8hasn7japj2h43bap";
    };
    buildInputs = [ pkgs.which ModuleBuildTiny TestSharedFork ];
    propagatedBuildInputs = [ ClassAccessorLite DBDmysql FileCopyRecursive ];
    meta = {
      description = "Mysqld runner for tests";
      homepage = "https://github.com/kazuho/p5-test-mysqld";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  TestNeeds = buildPerlPackage {
    pname = "Test-Needs";
    version = "0.002006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Test-Needs-0.002006.tar.gz";
      sha256 = "77f9fff0c96c5e09f34d0416b3533c3319f7cd0bb1f7fe8f8072ad59f433f0e5";
    };
    meta = {
      description = "Skip tests when modules not available";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNoTabs = buildPerlPackage {
    pname = "Test-NoTabs";
    version = "2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-NoTabs-2.02.tar.gz";
      sha256 = "0c306p9qdpa2ycii3c50hml23mwy6bjxpry126g1dw11hyiwcxgv";
    };
    meta = {
      description = "Check the presence of tabs in your project";
      homepage = "https://github.com/karenetheridge/Test-NoTabs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNoWarnings = buildPerlPackage {
    pname = "Test-NoWarnings";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Test-NoWarnings-1.04.tar.gz";
      sha256 = "0v385ch0hzz9naqwdw2az3zdqi15gka76pmiwlgsy6diiijmg2k3";
    };
    meta = {
      description = "Make sure you didn't emit any warnings while testing";
      license = with lib.licenses; [ lgpl21 ];
    };
  };

  TestObject = buildPerlPackage {
    pname = "Test-Object";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Object-0.08.tar.gz";
      sha256 = "65278964147837313f4108e55b59676e8a364d6edf01b3dc198aee894ab1d0bb";
    };
  };

  TestOutput = buildPerlPackage {
    pname = "Test-Output";
    version = "1.031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-Output-1.031.tar.gz";
      sha256 = "193y1xjvgc1p9pdgdwps2127knvpz9wc1xh6gmr74y3ihmqz7f7q";
    };
    propagatedBuildInputs = [ CaptureTiny ];
  };

  TestPAUSEPermissions = buildPerlPackage {
    pname = "Test-PAUSE-Permissions";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Test-PAUSE-Permissions-0.07.tar.gz";
      sha256 = "0gh7f67g1y30yggmwj1pq6xgrx3cfjibj2378nl3gilvyaxw2w2m";
    };
    propagatedBuildInputs = [ ConfigIdentity PAUSEPermissions ParseLocalDistribution ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestUseAllModules ];
    meta = {
      description = "Tests module permissions in your distribution";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPerlCritic = buildPerlModule {
    pname = "Test-Perl-Critic";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-Perl-Critic-1.04.tar.gz";
      sha256 = "28f806b5412c7908b56cf1673084b8b44ce1cb54c9417d784d91428e1a04096e";
    };
    propagatedBuildInputs = [ MCE PerlCritic ];
  };

  TestPerlTidy = buildPerlModule rec {
    pname = "Test-PerlTidy";
    version = "20200930";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-PerlTidy-${version}.tar.gz";
      sha256 = "1djpfi57s1j6mqb0ii2ca1sj3ym7jjab018inp6vdmsyfjcnhvwz";
    };
    propagatedBuildInputs = [ PathTiny PerlTidy TextDiff ];
    buildInputs = [ TestPerlCritic ];
    meta = {
      description = "Check that all your files are tidy";
      homepage = "http://metacpan.org/release/Test-PerlTidy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPod = buildPerlPackage {
    pname = "Test-Pod";
    version = "1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Pod-1.52.tar.gz";
      sha256 = "1z75x1pxwp8ajwq9iazlg2c3wd7rdlim08yclpdg32qnc36dpa30";
    };
    meta = {
      description = "Check for POD errors in files";
      homepage = "http://search.cpan.org/dist/Test-Pod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodCoverage = buildPerlPackage {
    pname = "Test-Pod-Coverage";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Test-Pod-Coverage-1.10.tar.gz";
      sha256 = "1m203mhgfilz7iqc8mxaw4lw02fz391mni3n25sfx7nryylwrja8";
    };
    propagatedBuildInputs = [ PodCoverage ];
  };

  TestPodLinkCheck = buildPerlModule {
    pname = "Test-Pod-LinkCheck";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-LinkCheck-0.008.tar.gz";
      sha256 = "2bfe771173c38b69eeb089504e3f76511b8e45e6a9e6dac3e616e400ea67bcf0";
    };
    buildInputs = [ ModuleBuildTiny TestPod ];
    propagatedBuildInputs = [ CaptureTiny Moose podlinkcheck ];
    meta = {
      description = "Tests POD for invalid links";
      homepage = "http://search.cpan.org/dist/Test-Pod-LinkCheck";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodNo404s = buildPerlModule {
    pname = "Test-Pod-No404s";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-No404s-0.02.tar.gz";
      sha256 = "0ycfghsyl9f31kxdppjwx2g5iajrqh3fyywz0x7d8ayndw2hdihi";
    };
    propagatedBuildInputs = [ LWP URIFind ];
    buildInputs = [ ModuleBuildTiny TestPod ];
    meta = {
      description = "Using this test module will check your POD for any http 404 links";
      homepage = "http://search.cpan.org/dist/Test-Pod-No404s";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPortabilityFiles = buildPerlPackage {
    pname = "Test-Portability-Files";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.10.tar.gz";
      sha256 = "08e4b432492dc1b44b55d5db57952eb76379c7f434ee8f16aca64d491f401a16";
    };
    meta = {
      description = "Check file names portability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRefcount = buildPerlModule {
    pname = "Test-Refcount";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Refcount-0.10.tar.gz";
      sha256 = "1chf6zizi7x128l3qm1bdqzwjjqm2j4gzajgghaksisn945c4mq4";
    };
    meta = {
      description = "Assert reference counts on objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequires = buildPerlPackage {
    pname = "Test-Requires";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Test-Requires-0.11.tar.gz";
      sha256 = "03q49vi09b4n31kpnmq4v2dga5ja438a8f1wgkgwvvlpjmadx22b";
    };
    meta = {
      description = "Checks to see if the module can be loaded";
      homepage = "https://github.com/tokuhirom/Test-Requires";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequiresGit = buildPerlPackage {
    pname = "Test-Requires-Git";
    version = "1.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/Test-Requires-Git-1.008.tar.gz";
      sha256 = "70916210970d84d7491451159ab8b67e15251c8c0dae7c3df6c8d88542ea42a6";
    };
    propagatedBuildInputs = [ GitVersionCompare ];
    meta = {
      description = "Check your test requirements against the available version of Git";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequiresInternet = buildPerlPackage {
    pname = "Test-RequiresInternet";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MALLEN/Test-RequiresInternet-0.05.tar.gz";
      sha256 = "0gl33vpj9bb78pzyijp884b66sbw6jkh1ci0xki8rmf03hmb79xv";
    };
    meta = {
      description = "Easily test network connectivity";
      homepage = "https://metacpan.org/dist/Test-RequiresInternet";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRoo = buildPerlPackage {
    pname = "Test-Roo";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Roo-1.004.tar.gz";
      sha256 = "1mnym49j1lj7gzylma5b6nr4vp75rmgz2v71904v01xmxhy9l4i1";
    };

    propagatedBuildInputs = [ Moo MooXTypesMooseLike SubInstall strictures ];
    buildInputs = [ CaptureTiny ];
  };

  TestRoutine = buildPerlPackage {
    pname = "Test-Routine";
    version = "0.027";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Routine-0.027.tar.gz";
      sha256 = "0n6k310v2py787lkvhzrn8vndws9icdf8mighgl472k0x890xm5s";
    };
    buildInputs = [ TestAbortable TestFatal ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Composable units of assertion";
      homepage = "https://github.com/rjbs/Test-Routine";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRun = buildPerlModule {
    pname = "Test-Run";
    version = "0.0305";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-0.0305.tar.gz";
      sha256 = "0j62hzh7k4lvk390pm8581nhjnayxp4pf0g6x1vagqpqc3fp36pq";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ IPCSystemSimple ListMoreUtils MooseXStrictConstructor TextSprintfNamed UNIVERSALrequire ];
    meta = {
      description = "Base class to run standard TAP scripts";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunCmdLine = buildPerlModule {
    pname = "Test-Run-CmdLine";
    version = "0.0132";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-CmdLine-0.0132.tar.gz";
      sha256 = "01x7rzscj3f06kpv0bd9dwx4wg9bmn7b5gyqfvy7wmv3ak6r3hxj";
    };
    buildInputs = [ TestRun TestTrap ];
    propagatedBuildInputs = [ MooseXGetopt UNIVERSALrequire YAMLLibYAML ];
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Analyze tests from the command line using Test::Run";
      homepage = "http://web-cpan.berlios.de/modules/Test-Run";
      license = with lib.licenses; [ mit ];
      mainProgram = "runprove";
    };
  };

  TestRunPluginAlternateInterpreters = buildPerlModule {
    pname = "Test-Run-Plugin-AlternateInterpreters";
    version = "0.0125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-AlternateInterpreters-0.0125.tar.gz";
      sha256 = "1fwr687h05fg6xn6vsfx9ll2ha8c7brmqbiz18biz0jx2jdnihsj";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Define different interpreters for different test scripts with Test::Run";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginBreakOnFailure = buildPerlModule {
    pname = "Test-Run-Plugin-BreakOnFailure";
    version = "0.0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-BreakOnFailure-v0.0.6.tar.gz";
      sha256 = "1a8k9p89s31wrax0yk8p0zsvj40mjgi0bnjmj0949hghwbihw650";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Stop processing the entire test suite";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginColorFileVerdicts = buildPerlModule {
    pname = "Test-Run-Plugin-ColorFileVerdicts";
    version = "0.0125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-ColorFileVerdicts-0.0125.tar.gz";
      sha256 = "0ihy5rzhc7472kh8931i7fbqf36nixl6yjrf8x5ndzd62hn1l90w";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    propagatedBuildInputs = [ Moose ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      description = "Make the file verdict ('ok', 'NOT OK')";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginColorSummary = buildPerlModule {
    pname = "Test-Run-Plugin-ColorSummary";
    version = "0.0203";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-ColorSummary-0.0203.tar.gz";
      sha256 = "1zca7w360m0vf3srf8af1s2k9k8hi85w1cavql7m2sr9kcvpknbv";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      description = "A Test::Run plugin that";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginTrimDisplayedFilenames = buildPerlModule {
    pname = "Test-Run-Plugin-TrimDisplayedFilenames";
    version = "0.0126";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-TrimDisplayedFilenames-0.0126.tar.gz";
      sha256 = "0a4hxbsbhsnkx99h3d01fchv7ip0c1np2jmf6xvqm657qv1lk1la";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Trim the first components";
      homepage = "http://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunValgrind = buildPerlModule {
    pname = "Test-RunValgrind";
    version = "0.2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-RunValgrind-0.2.2.tar.gz";
      sha256 = "1vm5iw5sy0mhjjypaaviil9qgqixmkaghdbjbcyb4lf2mm6d24v9";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Tests that an external program is valgrind-clean";
      homepage = "http://metacpan.org/release/Test-RunValgrind";
      license = with lib.licenses; [ mit ];
    };
  };

  TestScript = buildPerlPackage {
    pname = "Test-Script";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Test-Script-1.26.tar.gz";
      sha256 = "1dvkb8dvidnycd6ws2h2iy262h37fjakflv6z90xrw72xix26hkd";
    };

    buildInputs = [ Test2Suite ];

    propagatedBuildInputs = [ CaptureTiny ProbePerl ];
  };

  TestScriptRun = buildPerlPackage {
    pname = "Test-Script-Run";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SUNNAVY/Test-Script-Run-0.08.tar.gz";
      sha256 = "1fef216e70bc425ace3e2c4370dfcdddb5e798b099efba2679244a4d5bc1ab0a";
    };
    propagatedBuildInputs = [ IPCRun3 TestException ];
    meta = {
      description = "Test scripts with run";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSharedFork = buildPerlPackage {
    pname = "Test-SharedFork";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-SharedFork-0.35.tar.gz";
      sha256 = "17y52j20k1bs9dgf4n6rhh9dn4cfxxbnfn2cfs7pb00fc5jyhci9";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Fork test";
      homepage = "https://github.com/tokuhirom/Test-SharedFork";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSimple13 = buildPerlPackage {
    pname = "Test-Simple";
    version = "1.302183";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-Simple-1.302183.tar.gz";
      sha256 = "1zq6841yrwxmrmhgzmzx0njlymsv9mzl6l5njabfl2j2xjjvs0ws";
    };
    meta = {
      description = "Basic utilities for writing tests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSnapshot = buildPerlPackage {
    pname = "Test-Snapshot";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/Test-Snapshot-0.06.tar.gz";
      sha256 = "f4dd7a9a55baa2247540ae34210cd05a04f9d1061befec97a1c90eda95bfae45";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      description = "Test against data stored in automatically-named file";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestSpec = buildPerlPackage {
    pname = "Test-Spec";
    version = "0.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AK/AKZHAN/Test-Spec-0.54.tar.gz";
      sha256 = "1lk5l69bm6yl1zxzz5v6mizzqfinpdhasmi4qjxr1vnwcl9cyc8a";
    };
    propagatedBuildInputs = [ DevelGlobalPhase PackageStash TieIxHash ];
    buildInputs = [ TestDeep TestTrap ];
    meta = {
      description = "Write tests in a declarative specification style";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSubCalls = buildPerlPackage {
    pname = "Test-SubCalls";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-SubCalls-1.10.tar.gz";
      sha256 = "cbc1e9b35a05e71febc13e5ef547a31c8249899bb6011dbdc9d9ff366ddab6c2";
    };
    propagatedBuildInputs = [ HookLexWrap ];
  };

  TestSynopsis = buildPerlPackage {
    pname = "Test-Synopsis";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZO/ZOFFIX/Test-Synopsis-0.16.tar.gz";
      sha256 = "09891vnkw9i8v074rswaxbrp6x2d8j8r90gqc306497ppiryq4qv";
    };
    meta = {
      description = "Test your SYNOPSIS code";
      homepage = "http://metacpan.org/release/Test-Synopsis";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTableDriven = buildPerlPackage {
    pname = "Test-TableDriven";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/Test-TableDriven-0.02.tar.gz";
      sha256 = "16l5n6sx3yqdir1rqq21d41znpwzbs8v34gqr93y051arypphn22";
    };
    meta = {
      description = "Write tests, not scripts that run them";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTempDirTiny = buildPerlPackage {
    pname = "Test-TempDir-Tiny";
    version = "0.018";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-TempDir-Tiny-0.018.tar.gz";
      sha256 = "10ay3zbihyxn4nbb1f0fmr4szag8iy8pd27v8j6idq6cgzys3dyp";
    };
    meta = {
      description = "Temporary directories that stick around when tests fail";
      homepage = "https://github.com/dagolden/Test-TempDir-Tiny";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TestTCP = buildPerlPackage {
    pname = "Test-TCP";
    version = "2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Test-TCP-2.22.tar.gz";
      sha256 = "0mvv9rqwrwlcfh8qrs0s47p85rhlnw15d4gbpyi802bddp0c6lry";
    };
    buildInputs = [ TestSharedFork ];
    meta = {
      description = "Testing TCP program";
      homepage = "https://github.com/tokuhirom/Test-TCP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestUNIXSock = buildPerlModule rec {
    pname = "Test-UNIXSock";
    version = "0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FU/FUJIWARA/${pname}-${version}.tar.gz";
      sha256 = "0gwgd2w16dsppmf1r6yc17ipvs8b62ybsiz2dyzwy4il236b8c1p";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ TestSharedFork TestTCP ];
    meta = {
      description = "Testing UNIX domain socket program";
      homepage = "https://github.com/fujiwara/Test-UNIXSock";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTime = buildPerlPackage {
    pname = "Test-Time";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SATOH/Test-Time-0.08.tar.gz";
      sha256 = "b8bc3b074bb2247e8588399c1e55d071f049cf6ce1c8b4192c38cf3c24559548";
    };
    meta = {
      description = "Overrides the time() and sleep() core functions for testing";
      homepage = "https://github.com/cho45/Test-Time";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestToolbox = buildPerlModule {
    pname = "Test-Toolbox";
    version = "0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKO/Test-Toolbox-0.4.tar.gz";
      sha256 = "1hxx9rhvncvn7wvzhzx4sk00w0xq2scgspfhhyqwjnm1yg3va820";
    };
    meta = {
      description = "Test::Toolbox - tools for testing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTrailingSpace = buildPerlModule {
    pname = "Test-TrailingSpace";
    version = "0.0600";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-TrailingSpace-0.0600.tar.gz";
      sha256 = "f09d263adec06700a43a24e29f5484cf6d2939914c607dec51590f4bb8fa5a11";
    };
    propagatedBuildInputs = [ FileFindObjectRule ];
    meta = {
      description = "Test for trailing space in source files";
      homepage = "http://metacpan.org/release/Test-TrailingSpace";
      license = with lib.licenses; [ mit ];
    };
  };

  TestUnitLite = buildPerlModule {
    pname = "Test-Unit-Lite";
    version = "0.1202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz";
      sha256 = "1a5jym9hjcpdf0rwyn7gwrzsx4xqzwgzx59rgspqlqiif7p2a79m";
    };
    meta = {
      description = "Unit testing without external dependencies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWarn = buildPerlPackage {
    pname = "Test-Warn";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGJ/Test-Warn-0.36.tar.gz";
      sha256 = "1nkc7jzxff0w4x9axbpsgxrksqdjnf70rb74q39zikkrsd3a7g7c";
    };
    propagatedBuildInputs = [ SubUplevel ];
    meta = {
      description = "Perl extension to test methods for warnings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWarnings = buildPerlPackage {
    pname = "Test-Warnings";
    version = "0.030";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Warnings-0.030.tar.gz";
      sha256 = "89a4947ddf1564ae01122275584433d7f6c4370370bcf3768922d796956ae24f";
    };
    buildInputs = [ CPANMetaCheck PadWalker ];
    meta = {
      description = "Test for warnings and the lack of them";
      homepage = "https://github.com/karenetheridge/Test-Warnings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWeaken = buildPerlPackage {
    pname = "Test-Weaken";
    version = "3.022000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/Test-Weaken-3.022000.tar.gz";
      sha256 = "2631a87121310262e0e96107a6fa0ed69487b7701520773bee5fa9accc295f5b";
    };
    propagatedBuildInputs = [ ScalarListUtils ];
    meta = {
      description = "Test that freed memory objects were, indeed, freed";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWithoutModule = buildPerlPackage {
    pname = "Test-Without-Module";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/Test-Without-Module-0.20.tar.gz";
      sha256 = "8e9aeb7c32a6c6d0b8a93114db2a8c072721273a9d9a2dd4f9ca86cfd28aa524";
    };
    meta = {
      description = "Test fallback behaviour in absence of modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanize = buildPerlPackage {
    pname = "Test-WWW-Mechanize";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.54.tar.gz";
      sha256 = "1z4s8fijwx8p74fw29435d2c2l6c1sgzz0n7lrdby5212xdqpa6w";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ CarpAssertMore HTTPServerSimple WWWMechanize ];
    meta = {
      description = "Testing-specific WWW::Mechanize subclass";
      homepage = "https://github.com/libwww-perl/WWW-Mechanize";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestWWWMechanizeCatalyst = buildPerlPackage {
    pname = "Test-WWW-Mechanize-Catalyst";
    version = "0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/Test-WWW-Mechanize-Catalyst-0.62.tar.gz";
      sha256 = "1cdc2q16vs6fb335pzaislz2rx1ph9acaxyp7v5hv9xbwwddwfqq";
    };
    doCheck = false; # listens on an external port
    propagatedBuildInputs = [ CatalystRuntime WWWMechanize ];
    buildInputs = [ CatalystPluginSession CatalystPluginSessionStateCookie TestException TestWWWMechanize Testutf8 ];
    meta = {
      description = "Test::WWW::Mechanize for Catalyst";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanizeCGI = buildPerlPackage {
    pname = "Test-WWW-Mechanize-CGI";
    version = "0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/Test-WWW-Mechanize-CGI-0.1.tar.gz";
      sha256 = "0bwwdk0iai5dlvvfpja971qpgvmf6yq67iag4z4szl9v5sra0xm5";
    };
    propagatedBuildInputs = [ WWWMechanizeCGI ];
    buildInputs = [ TestLongString TestWWWMechanize ];
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    pname = "Test-WWW-Mechanize-PSGI";
    version = "0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/Test-WWW-Mechanize-PSGI-0.39.tar.gz";
      sha256 = "0n4rhyyags3cwqb0gb1pr6gccd2x3l190j8gd96lwlvxnjrklss7";
    };
    buildInputs = [ CGI TestLongString TestWWWMechanize ];
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Test PSGI programs using WWW::Mechanize";
      homepage = "https://github.com/acme/test-www-mechanize-psgi";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestXPath = buildPerlModule {
    pname = "Test-XPath";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/Test-XPath-0.19.tar.gz";
      sha256 = "1wy0488yg15kahfafnlmlhppxik7d0z00wxwj9fszrsq2h6crz6y";
    };
    propagatedBuildInputs = [ XMLLibXML ];
  };

  TestYAML = buildPerlPackage {
    pname = "Test-YAML";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/Test-YAML-1.07.tar.gz";
      sha256 = "0pwrrnwi1qaiy3c5522vy0kzncxc9g02r4b056wqqaa69w1hsc0z";
    };
    buildInputs = [ TestBase ];
    meta = {
      description = "Testing Module for YAML Implementations";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "test-yaml";
    };
  };

  TextAligner = buildPerlModule {
    pname = "Text-Aligner";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Aligner-0.16.tar.gz";
      sha256 = "09ap457vrlqvw2544j907fbb5crs08hd7sy4syipzxc6wny7v1aw";
    };
    meta = {
      description = "Module to align text";
      homepage = "http://metacpan.org/release/Text-Aligner";
      license = with lib.licenses; [ free ];
    };
  };

  TextAspell = buildPerlPackage {
    pname = "Text-Aspell";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANK/Text-Aspell-0.09.tar.gz";
      sha256 = "0r9g31rd55934mp6n45b96g934ck4qns8x9i7qckn9wfy44k5sib";
    };
    propagatedBuildInputs = [ pkgs.aspell ];
    ASPELL_CONF = "dict-dir ${pkgs.aspellDicts.en}/lib/aspell";
    NIX_CFLAGS_COMPILE = "-I${pkgs.aspell}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.aspell}/lib -laspell";
  };

  TextAutoformat = buildPerlPackage {
    pname = "Text-Autoformat";
    version = "1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.75.tar.gz";
      sha256 = "9dd4f4ce3daec4b4dbf5b59dac4568a8946aed12c28b4e5988c8e8c602c6b771";
    };
    propagatedBuildInputs = [ TextReform ];
    meta = {
      description = "Automatic text wrapping and reformatting";
      homepage = "https://github.com/neilb/Text-Autoformat";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBalanced = buildPerlPackage {
    pname = "Text-Balanced";
    version = "2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/Text-Balanced-2.04.tar.gz";
      sha256 = "1qp7whrampvdzb4nbdvbzp02vlmyk5ssha2lg1iaf2y8hn5l177l";
    };
    meta = {
      description = "Extract delimited text sequences from strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBibTeX = buildPerlModule {
    pname = "Text-BibTeX";
    version = "0.88";
    buildInputs = [ CaptureTiny ConfigAutoConf ExtUtilsLibBuilder ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/Text-BibTeX-0.88.tar.gz";
      sha256 = "0b7lmjvfmypps1nw6nsdikgaakm0n0g4186glaqazg5xd1p5h55h";
    };
    # libbtparse.so: cannot open shared object file (aarch64 only)
    patches = [ ../development/perl-modules/TextBibTeX-use-lib-on-aarch64.patch ];
    perlPreHook = "export LD=$CC";
    perlPostHook = lib.optionalString stdenv.isDarwin ''
      oldPath="$(pwd)/btparse/src/libbtparse.dylib"
      newPath="$out/lib/libbtparse.dylib"

      install_name_tool -id "$newPath" "$newPath"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/biblex"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/bibparse"
      install_name_tool -change "$oldPath" "$newPath" "$out/bin/dumpnames"
      install_name_tool -change "$oldPath" "$newPath" "$out/${perl.libPrefix}/${perl.version}/darwin"*"-2level/auto/Text/BibTeX/BibTeX.bundle"
    '';
    meta = {
      description = "Interface to read and parse BibTeX files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextBrew = buildPerlPackage {
    pname = "Text-Brew";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCIVEY/Text-Brew-0.02.tar.gz";
      sha256 = "0k7nxglbx5pxl693zrj1fsi094sf1a3vqsrn73inzz7r3j28a6xa";
    };
  };

  TextCharWidth = buildPerlPackage {
    pname = "Text-CharWidth";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KUBOTA/Text-CharWidth-0.04.tar.gz";
      sha256 = "abded5f4fdd9338e89fd2f1d8271c44989dae5bf50aece41b6179d8e230704f8";
    };
  };

  TextCSV = buildPerlPackage {
    pname = "Text-CSV";
    version = "2.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Text-CSV-2.00.tar.gz";
      sha256 = "8ccbd9195805222d995844114d0e595bb24ce188f85284dbf256080311cbb2c2";
    };
    meta = {
      description = "Comma-separated values manipulator (using XS or PurePerl)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextCSVEncoded = buildPerlPackage {
    pname = "Text-CSV-Encoded";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZA/ZARQUON/Text-CSV-Encoded-0.25.tar.gz";
      sha256 = "1l5rwlmnpnhjszb200a94lwvkwslsvyxm24ycf37gm8dla1mk2i4";
    };
    propagatedBuildInputs = [ TextCSV ];
    meta = {
      description = "Encoding aware Text::CSV";
      homepage = "https://github.com/singingfish/Text-CSV-Encoded";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextCSV_XS = buildPerlPackage {
    pname = "Text-CSV_XS";
    version = "1.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.44.tgz";
      sha256 = "c4812ddca8e2654736c44bc2ce60b27a428a1bc4d5364b0ed1fad3609c8f9bc4";
    };
    meta = {
      description = "Comma-Separated Values manipulation routines";
      homepage = "https://metacpan.org/pod/Text::CSV_XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextDiff = buildPerlPackage {
    pname = "Text-Diff";
    version = "1.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Text-Diff-1.45.tar.gz";
      sha256 = "013g13prdghxvrp5754gyc7rmv1syyxrhs33yc5f0lrz3dxs1fp8";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perform diffs on files and record sets";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextFormat = buildPerlModule {
    pname = "Text-Format";
    version = "0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Format-0.62.tar.gz";
      sha256 = "0104z7jjv46kqh77rnx8kvmsbr5dy0s56xm01dckq4ly65br0hkx";
    };
    meta = {
      description = "Various subroutines to format text";
      homepage = "http://www.shlomifish.org/open-source/projects/Text-Format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ bcdarwin ];
    };
  };

  TextDiffFormattedHTML = buildPerlPackage {
    pname = "Text-Diff-FormattedHTML";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/Text-Diff-FormattedHTML-0.08.tar.gz";
      sha256 = "39ab775a5c056745f2abd8cc7c1cbc5496dfef7e52a9f4bd8ada6aa6c9c7b70d";
    };
    propagatedBuildInputs = [ FileSlurp StringDiff ];
    meta = {
      description = "Generate a colorful HTML diff of strings/files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  TextFuzzy = buildPerlPackage {
    pname = "Text-Fuzzy";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/Text-Fuzzy-0.29.tar.gz";
      sha256 = "3df5cfd2ca1a4c5ca7ff7bab3cc8d53ad2064e134cbf11004f3cf8c4b9055bff";
    };
    meta = {
      description = "Partial string matching using edit distances";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextGerman = buildPerlPackage {
    pname = "Text-German";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UL/ULPFR/Text-German-0.06.tar.gz";
      sha256 = "1p87pgap99lw0nv62i3ghvsi7yg90lhn8vsa3yqp75rd04clybcj";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  TextGlob = buildPerlPackage {
    pname = "Text-Glob";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz";
      sha256 = "11sj62fynfgwrlgkv5a051cq6yn0pagxqjsz27dxx8phsd4wv706";
    };
  };

  TextHogan = buildPerlPackage {
    pname = "Text-Hogan";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAORU/Text-Hogan-2.03.tar.gz";
      sha256 = "0yk1qn457jqknds4g2khlhi5vk2li1njbfwvxy44i665wknj7naq";
    };
    propagatedBuildInputs = [ Clone RefUtil TextTrim ];
    buildInputs = [ DataVisitor PathTiny TryTiny YAML ];
    meta = {
      description = "Text::Hogan - A mustache templating engine statement-for-statement cloned from hogan.js";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextIconv = buildPerlPackage {
    pname = "Text-Iconv";
    version = "1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz";
      sha256 = "5b80b7d5e709d34393bcba88971864a17b44a5bf0f9e4bcee383d029e7d2d5c3";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.TextIconv.x86_64-darwin
    };
  };

  TestInDistDir = buildPerlPackage {
    pname = "Test-InDistDir";
    version = "1.112071";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHALDU/Test-InDistDir-1.112071.tar.gz";
      sha256 = "922c5c63314f406f4cbb35ec423ac2154d2c2b71a65addb7732c9d240a83fefb";
    };
    meta = {
      description = "Test environment setup for development with IDE";
      homepage = "https://github.com/wchristian/Test-InDistDir";
      license = with lib.licenses; [ wtfpl ];
      maintainers = [ maintainers.sgo ];
    };
  };

  TestInter = buildPerlPackage {
    pname = "Test-Inter";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/Test-Inter-1.09.tar.gz";
      sha256 = "1e9f129cc1a001fb95449d385253b38afabf5b466e3b3bd33e4e430f216e177a";
    };
    buildInputs = [ FileFindRule TestPod TestPodCoverage ];
    meta = {
      description = "Framework for more readable interactive test scripts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextLayout = buildPerlPackage {
    pname = "Text-Layout";
    version = "0.019";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/Text-Layout-0.019.tar.gz";
      sha256 = "a043f2a89e113b29c523a9efa71fa8398ed75edd482193901b38d08dd4a4108e";
    };
    buildInputs = [ PDFAPI2 ];
    meta = {
      description = "Pango style markup formatting";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextLevenshteinXS = buildPerlPackage {
    pname = "Text-LevenshteinXS";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JG/JGOLDBERG/Text-LevenshteinXS-0.03.tar.gz";
      sha256 = "sha256-43T/eyN5Gc5eqSRfNW0ctSzIf9JrOlo4s/Pl/4KgFJE=";
    };
    meta = {
      description = "Levenshtein edit distance in a XS way";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextLorem = buildPerlModule {
    pname = "Text-Lorem";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADEOLA/Text-Lorem-0.3.tar.gz";
      sha256 = "64bb636fb21213101a646b414ecbdc1b55edf905cbcdc7f5d24774ec5061fe2d";
    };
    meta = {
      description = "Generate random Latin looking text";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
      mainProgram = "lorem";
    };
  };

  TestManifest = buildPerlPackage {
    pname = "Test-Manifest";
    version = "2.021";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-Manifest-2.021.tar.gz";
      sha256 = "a47aaad71c580e16e6e63d8c037cdddcd919876754beb2c95d9a88682dd332d9";
    };
    meta = {
      description = "Interact with a t/test_manifest file";
      homepage = "https://github.com/briandfoy/test-manifest";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TextMarkdown = buildPerlPackage {
    pname = "Text-Markdown";
    version = "1.000031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Text-Markdown-1.000031.tar.gz";
      sha256 = "06y79lla8adkqhrs41xdddqjs81dcrh266b50mfbg37bxkawd4f1";
    };
    nativeBuildInputs = [ shortenPerlShebang ];
    checkInputs = [ ListMoreUtils TestDifferences TestException ];
    postInstall = ''
      shortenPerlShebang $out/bin/Markdown.pl
    '';
    meta = {
      description = "Convert Markdown syntax to (X)HTML";
      license = with lib.licenses; [ bsd ];
      mainProgram = "Markdown.pl";
    };
  };

  TextMarkdownHoedown = buildPerlModule {
    pname = "Text-Markdown-Hoedown";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Text-Markdown-Hoedown-1.03.tar.gz";
      sha256 = "sha256-U6cw/29IgrmavYVW8mqRH1gvZ1tZ8OFnJe0ey8CE7lA=";
    };
    buildInputs = [ Filepushd ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Hoedown for Perl5";
      homepage = "https://github.com/tokuhirom/Text-Markdown-Hoedown";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMinimumVersion = buildPerlPackage {
    pname = "Test-MinimumVersion";
    version = "0.101082";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-MinimumVersion-0.101082.tar.gz";
      sha256 = "3fba4e8fcf74806259aa639be7d90e70346ad0e0e4b8b619593490e378241970";
    };
    propagatedBuildInputs = [ PerlMinimumVersion ];
    meta = {
      description = "Does your code require newer perl than you think?";
      homepage = "https://github.com/rjbs/Test-MinimumVersion";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMicroTemplate = buildPerlPackage {
    pname = "Text-MicroTemplate";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Text-MicroTemplate-0.24.tar.gz";
      sha256 = "1j5ljx7hs4k29732nr5f2m4kssz4rqjw3kknsnhams2yydqix01j";
    };
    meta = {
      description = "Micro template engine with Perl5 language";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMultiMarkdown = buildPerlPackage {
    pname = "Text-MultiMarkdown";
    version = "1.000035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Text-MultiMarkdown-1.000035.tar.gz";
      sha256 = "2467dd13751dc2979d7c880b24e762952130fdf42a1ed3ee04fdf72d4b52646a";
    };
    buildInputs = [ ListMoreUtils TestException ];
    propagatedBuildInputs = [ HTMLParser TextMarkdown ];
    meta = {
      description = "Convert MultiMarkdown syntax to (X)HTML";
      license = with lib.licenses; [ bsd3 ];
      mainProgram = "MultiMarkdown.pl";
    };
  };

  TestNumberDelta = buildPerlPackage {
    pname = "Test-Number-Delta";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz";
      sha256 = "535430919e6fdf6ce55ff76e9892afccba3b7d4160db45f3ac43b0f92ffcd049";
    };
    meta = {
      description = "Compare the difference between numbers against a given tolerance";
      homepage = "https://github.com/dagolden/Test-Number-Delta";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TextParsewords = buildPerlPackage {
    pname = "Text-ParseWords";
    version = "3.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Text-ParseWords-3.30.tar.gz";
      hash = "sha256-heAjgXndQ5l+WMZr1RYRGCvH1TNQUCmi2w0yMu2v9eg=";
    };
    meta = {
      description = "Parse text into an array of tokens or array of arrays";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextPasswordPronounceable = buildPerlPackage {
    pname = "Text-Password-Pronounceable";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSIBLEY/Text-Password-Pronounceable-0.30.tar.gz";
      sha256 = "c186a50256e0bedfafb17e7ce157e7c52f19503bb79e18ebf06255911f6ead1a";
    };
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextPatch = buildPerlPackage {
    pname = "Text-Patch";
    version = "1.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CADE/Text-Patch-1.8.tar.gz";
      sha256 = "eaf18e61ba6a3e143846a7cc66f08ce58a0c4fbda92acb31aede25cb3b5c3dcc";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      description = "Patches text with given patch";
      license = with lib.licenses; [ gpl2 ];
    };
  };

  TextPDF = buildPerlPackage {
    pname = "Text-PDF";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/Text-PDF-0.31.tar.gz";
      sha256 = "0s5cimfr4wwzgv15k30x83ncg1257jwsvmbmb86lp02rw5g537yz";
    };
  };

  TextQuoted = buildPerlPackage {
    pname = "Text-Quoted";
    version = "2.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Text-Quoted-2.10.tar.gz";
      sha256 = "081bf95ec9220af26cec89161e61bf73f9fbcbfeee1d9af15139e5d7b708f445";
    };
    propagatedBuildInputs = [ TextAutoformat ];
    meta = {
      description = "Extract the structure of a quoted mail message";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRecordParser = buildPerlPackage {
    pname = "Text-RecordParser";
    version = "1.6.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCLARK/Text-RecordParser-1.6.5.tar.gz";
      sha256 = "0nn33c058bl957v38xhqig4ld34lifl4arqiilhxky339i0q2fys";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ ClassAccessor IOStringy ListMoreUtils Readonly TextAutoformat ];
    buildInputs = [ TestException ];
  };

  TextReflow = buildPerlPackage {
    pname = "Text-Reflow";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MW/MWARD/Text-Reflow-1.17.tar.gz";
      sha256 = "4bf2139ff617d6e59cc0e59cdecd7cb723ecfd28d5ac387afb553ffdc071b860";
    };
    meta = {
      description = "Reflow text files using Knuth's paragraphing algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextReform = buildPerlModule {
    pname = "Text-Reform";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Text-Reform-1.20.tar.gz";
      sha256 = "a8792dd8c1aac97001032337b36a356be96e2d74c4f039ef9a363b641db4ae61";
    };
    meta = {
      description = "Manual text wrapping and reformatting";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextRoman = buildPerlPackage {
    pname = "Text-Roman";
    version = "3.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYP/Text-Roman-3.5.tar.gz";
      sha256 = "0sh47svzz0wm993ywfgpn0fvhajl2sj5hcnf5zxjz02in6ihhjnb";
    };
    meta = {
      description = "Allows conversion between Roman and Arabic algarisms";
      homepage = "https://github.com/creaktive/Text-Roman";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextSimpleTable = buildPerlPackage {
    pname = "Text-SimpleTable";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/Text-SimpleTable-2.07.tar.gz";
      sha256 = "1v8r8qpzg283p2pqqr8dqrak2bxray1b2jmib0qk75jffqw3yv95";
    };
    propagatedBuildInputs = [ UnicodeLineBreak ];
    meta = {
      description = "Simple eyecandy ASCII tables";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TextSoundex = buildPerlPackage {
    pname = "Text-Soundex";
    version = "3.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Text-Soundex-3.05.tar.gz";
      sha256 = "f6dd55b4280b25dea978221839864382560074e1d6933395faee2510c2db60ed";
    };
  };

  TextSprintfNamed = buildPerlModule {
    pname = "Text-Sprintf-Named";
    version = "0.0405";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Sprintf-Named-0.0405.tar.gz";
      sha256 = "1z0glxrmbc6pgjs5bkmp1wiifd4xdcrin8wqz6rhmi6gzxw0siwv";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Sprintf-like function with named conversions";
      homepage = "http://metacpan.org/release/Text-Sprintf-Named";
      license = with lib.licenses; [ mit ];
    };
  };

  TextTable = buildPerlModule {
    pname = "Text-Table";
    version = "1.134";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Table-1.134.tar.gz";
      sha256 = "02yigisvgshpgfyqwj0xad4jg473cd80a6c210nb5h5p32dl5kxs";
    };
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      description = "Organize Data in Tables";
      homepage = "http://metacpan.org/release/Text-Table";
      license = with lib.licenses; [ isc ];
    };
  };

  TextTabularDisplay = buildPerlPackage {
    pname = "Text-TabularDisplay";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/Text-TabularDisplay-1.38.tar.gz";
      sha256 = "1s46s4pg5mpfllx3icf4vnqz9iadbbdbsr5p7pr6gdjnzbx902gb";
    };
  };

  TextTemplate = buildPerlPackage {
    pname = "Text-Template";
    version = "1.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Text-Template-1.59.tar.gz";
      sha256 = "1dd2c788c05303ed9a970e1881109642151fa93e02c7a80d4c70608276bab1ee";
    };
    buildInputs = [ TestMoreUTF8 TestWarnings ];
  };

  TestTrap = buildPerlModule {
    pname = "Test-Trap";
    version = "0.3.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.3.4.tar.gz";
      sha256 = "1qjs2080kcc66s4d7499br5lw2qmhr9gxky4xsl6vjdn6dpna10b";
    };
    propagatedBuildInputs = [ DataDump ];
    meta = {
      description = "Trap exit codes, exceptions, output, etc";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVars = buildPerlModule {
    pname = "Test-Vars";
    version = "0.014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Test-Vars-0.014.tar.gz";
      sha256 = "0qr8q0ksr925ycwbsyxjwgz4p9r7a8vkxpn33vy23zbijwpa3xx7";
    };

    buildInputs = [ ModuleBuildTiny ];

    meta = {
      description = "Detects unused variables in perl modules";
      homepage = "https://github.com/houseabsolute/p5-Test-Vars";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVersion = buildPerlPackage {
    pname = "Test-Version";
    version = "2.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Test-Version-2.09.tar.gz";
      sha256 = "9ce1dd2897a5f30e1b7f8966ec66f57d8d8f280f605f28c7ca221fa79aca38e0";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ FileFindRulePerl ];
    meta = {
      description = "Check to see that version's in modules are sane";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TextTrim = buildPerlPackage {
    pname = "Text-Trim";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJT/Text-Trim-1.03.tar.gz";
      sha256 = "0ks9afvx9c1b6px98wwzhbyhd2y6hdg7884814fc9pnx8qfzrz50";
    };
    meta = {
      description = "Remove leading and/or trailing whitespace from strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextUnaccent = buildPerlPackage {
    pname = "Text-Unaccent";
    version = "1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDACHARY/Text-Unaccent-1.08.tar.gz";
      sha256 = "0avk50kia78kxryh2whmaj5l18q2wvmkdyqyjsf6kwr4kgy6x3i7";
    };
    # https://rt.cpan.org/Public/Bug/Display.html?id=124815
    NIX_CFLAGS_COMPILE = "-DHAS_VPRINTF";
    meta = {
      license = with lib.licenses; [ unfree ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.TextUnaccent.x86_64-darwin
    };
  };

  TextUnidecode = buildPerlPackage {
    pname = "Text-Unidecode";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz";
      sha256 = "1imii0p6wvhrxsr5z2zhazpx5vl4l4ybf1y2c5hy480xvi6z293c";
    };
  };

  Testutf8 = buildPerlPackage {
    pname = "Test-utf8";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.02.tar.gz";
      sha256 = "df82f09c5940830b25a49f1c8162fa24d371e602880edef8d9a4d4bfd66b8bd7";
    };
    meta = {
      description = "Handy utf8 tests";
      homepage = "https://github.com/2shortplanks/Test-utf8/tree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextNSP = buildPerlPackage {
    pname = "Text-NSP";
    version = "1.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TP/TPEDERSE/Text-NSP-1.31.tar.gz";
      sha256 = "a01201beb29636b3e41ecda2a6cf6522fd265416bd6d994fad02f59fb49cf595";
    };
    meta = {
      description = "Extract collocations and Ngrams from text";
      license = with lib.licenses; [ free ];
      maintainers = [ maintainers.bzizou ];
    };
  };

  TextvFileasData = buildPerlPackage {
    pname = "Text-vFile-asData";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Text-vFile-asData-0.08.tar.gz";
      sha256 = "b291ab5e0f987c5172560a692234711a75e4596d83475f72d01278369532f82a";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    meta = {
      description = "Parse vFile formatted files into data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWikiFormat = buildPerlModule {
    pname = "Text-WikiFormat";
    version = "0.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CY/CYCLES/Text-WikiFormat-0.81.tar.gz";
      sha256 = "0cxbgx879bsskmnhjzamgsa5862ddixyx4yr77lafmwimnaxjg74";
    };
    propagatedBuildInputs = [ URI ];
  };

  TextWordDiff = buildPerlPackage {
    pname = "Text-WordDiff";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMK/Text-WordDiff-0.09.tar.gz";
      sha256 = "fee699ca763adca2f4e18f4a8a836fd2102bc2820af708f8eb43356d5ae0d50e";
    };
    propagatedBuildInputs = [ AlgorithmDiff HTMLParser ];
    meta = {
      description = "Track changes between documents";
      homepage = "https://metacpan.org/release/Text-WordDiff";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWrapI18N = buildPerlPackage {
    pname = "Text-WrapI18N";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz";
      sha256 = "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488";
    };
    buildInputs = [ pkgs.glibcLocales ];
    propagatedBuildInputs = [ TextCharWidth ];
    preConfigure = ''
      substituteInPlace WrapI18N.pm --replace '/usr/bin/locale' '${pkgs.glibc.bin}/bin/locale'
    '';
    meta = {
      description = "Line wrapping module with support for multibyte, fullwidth, and combining characters and languages without whitespaces between words";
      license = with lib.licenses; [ artistic1 gpl2 ];
    };
  };

  TextWrapper = buildPerlPackage {
    pname = "Text-Wrapper";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJM/Text-Wrapper-1.05.tar.gz";
      sha256 = "64268e15983a9df47e1d9199a491f394e89f542e54afb33f4b78f3f318e09ab9";
    };
    buildInputs = [ TestDifferences ];
    meta = {
      description = "Word wrap text by breaking long lines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Throwable = buildPerlPackage {
    pname = "Throwable";
    version = "0.200013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Throwable-0.200013.tar.gz";
      sha256 = "184gdcwxqwnkrx5md968v1ny70pq6blzpkihccm3bpdxnpgd11wr";
    };
    propagatedBuildInputs = [ DevelStackTrace Moo ];
    meta = {
      description = "A role for classes that can be thrown";
      homepage = "https://github.com/rjbs/Throwable";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieCacheLRU = buildPerlPackage {
    pname = "Tie-Cache-LRU";
    version = "20150301";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Tie-Cache-LRU-20150301.tar.gz";
      sha256 = "1bf740450d3a6d7c12b48c25f7da5964e44e7cc38b28572cfb76ff22464f4469";
    };
    propagatedBuildInputs = [ ClassVirtual enum ];
    meta = {
      description = "A Least-Recently Used cache";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieCacheLRUExpires = buildPerlPackage {
    pname = "Tie-Cache-LRU-Expires";
    version = "0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/Tie-Cache-LRU-Expires-0.55.tar.gz";
      sha256 = "b316d849acd25f24346d55a9950d281fee0746398767c601234122159573eb9a";
    };
    propagatedBuildInputs = [ TieCacheLRU ];
    meta = {
      license = with lib.licenses; [ artistic1 ];
    };
  };

  TieCycle = buildPerlPackage {
    pname = "Tie-Cycle";
    version = "1.225";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Tie-Cycle-1.225.tar.gz";
      sha256 = "0i9xq2qm50p2ih24265jndp2x8hfq7ap0d88nrlv5yaad4hxhc7k";
    };
    meta = {
      description = "Cycle through a list of values via a scalar";
      homepage = "https://github.com/briandfoy/tie-cycle";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TieEncryptedHash = buildPerlPackage {
    pname = "Tie-EncryptedHash";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Tie-EncryptedHash-1.24.tar.gz";
      sha256 = "aa9a083a231e4046170a5894644e3c59679c7dbd0aa2d1217dc85150df2c1e21";
    };
    propagatedBuildInputs = [ CryptBlowfish CryptCBC CryptDES ];
    meta = {
      description = "Hashes (and objects based on hashes) with encrypting fields";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  TieFile = buildPerlPackage {
    pname = "Tie-File";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Tie-File-1.05.tar.gz";
      sha256 = "8a980b577ff4b10fe11062ed8c774857fa8c9833c5305f2e8bfb3347af63f139";
    };
    meta = {
      description = "Access the lines of a disk file via a Perl array";
      license = with lib.licenses; [ unfree ];
    };
  };

  TieIxHash = buildPerlModule {
    pname = "Tie-IxHash";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz";
      sha256 = "0mmg9iyh42syal3z1p2pn9airq65yrkfs66cnqs9nz76jy60pfzs";
    };
    meta = {
      description = "Ordered associative arrays for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieHandleOffset = buildPerlPackage {
    pname = "Tie-Handle-Offset";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Tie-Handle-Offset-0.004.tar.gz";
      sha256 = "ee9f39055dc695aa244a252f56ffd37f8be07209b337ad387824721206d2a89e";
    };
    meta = {
      description = "Tied handle that hides the beginning of a file";
      homepage = "https://github.com/dagolden/tie-handle-offset";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TieHashIndexed = buildPerlPackage {
    pname = "Tie-Hash-Indexed";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHX/Tie-Hash-Indexed-0.08.tar.gz";
      sha256 = "043v98xaid6sjch2x9c39s475wm9i13vzf8jg73qm12sby0n5g1p";
    };
    doCheck = false; /* test fails on some machines */
    meta = {
      description = "Ordered hashes for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieHashMethod = buildPerlPackage {
    pname = "Tie-Hash-Method";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YV/YVES/Tie-Hash-Method-0.02.tar.gz";
      sha256 = "d513fbb51413f7ca1e64a1bdce6194df7ec6076dea55066d67b950191eec32a9";
    };
    meta = {
      description = "Tied hash with specific methods overriden by callbacks";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  TieRefHash = buildPerlPackage {
    pname = "Tie-RefHash";
    version = "1.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Tie-RefHash-1.40.tar.gz";
      sha256 = "1mvyjab8pv1yfimvlh4gxxpm3xzny4pinymdr8hgdd9gim8izkss";
    };
  };

  TieRegexpHash = buildPerlPackage {
    pname = "Tie-RegexpHash";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALTREUS/Tie-RegexpHash-0.17.tar.gz";
      sha256 = "0c207850e77efb16618e0aa015507926a3425b34aad5aa6e3e40d83989a085a3";
    };
    meta = {
      license = with lib.licenses; [ artistic1 ];
    };
  };

  TieSimple = buildPerlPackage {
    pname = "Tie-Simple";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANENKAMP/Tie-Simple-1.04.tar.gz";
      sha256 = "29e9e2133951046c78f205f1b3e8df62c90e114f0e08fa06b817766a0f808b12";
    };
    meta = {
      description = "Variable ties made much easier: much, much, much easier..";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieSub = buildPerlPackage {
    pname = "Tie-Sub";
    version = "1.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Tie-Sub-1.001.tar.gz";
      sha256 = "1cgiyj85hhw2m4x2iv4zgaj3hzf3fghircpcfqmjndni4r4a0wgg";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    buildInputs = [ ModuleBuild TestDifferences TestException TestNoWarnings ];
    meta = {
      description = "Tie::Sub - Tying a subroutine, function or method to a hash";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieToObject = buildPerlPackage {
    pname = "Tie-ToObject";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz";
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
  };

  TimeDate = buildPerlPackage {
    pname = "TimeDate";
    version = "2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz";
      sha256 = "1cjyc0yi873597r7xcp9yz0l1c46ik2kxwfrn00zbrlx0d5rrdn0";
    };
  };

  TimeDuration = buildPerlPackage {
    pname = "Time-Duration";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Time-Duration-1.21.tar.gz";
      sha256 = "1f59z2svfydxgd1gzrb5k3hl6d432kzmskk7jhv2dyb5hyx0wd7y";
    };
    meta = {
      description = "Rounded or exact English expression of durations";
      homepage = "https://github.com/neilbowers/Time-Duration";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDurationParse = buildPerlPackage {
    pname = "Time-Duration-Parse";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Time-Duration-Parse-0.15.tar.gz";
      sha256 = "10g39bbrxkabbsfq4rv7f5b5x7h3jba08j4pg8gwr0b9iqx19n31";
    };
    buildInputs = [ TimeDuration ];
    propagatedBuildInputs = [ ExporterLite ];
    meta = {
      description = "Parse string that represents time duration";
      homepage = "https://github.com/neilb/Time-Duration-Parse";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeLocal = buildPerlPackage {
    pname = "Time-Local";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Time-Local-1.30.tar.gz";
      sha256 = "c7744f6b2986b946d3e2cf034df371bee16cdbafe53e945abb1a542c4f8920cb";
    };
    meta = {
      description = "Efficiently compute time from local and GMT time";
      homepage = "http://metacpan.org/release/Time-Local";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeMoment = buildPerlPackage {
    pname = "Time-Moment";
    version = "0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Time-Moment-0.44.tar.gz";
      sha256 = "64acfa042f634fcef8dadf55e7f42ba4eaab8aaeb7d5212eb89815a31f78f6fd";
    };
    buildInputs = [ TestFatal TestNumberDelta TestRequires ];
    meta = {
      description = "Represents a date and time of day with an offset from UTC";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeOut = buildPerlPackage {
    pname = "Time-Out";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PATL/Time-Out-0.11.tar.gz";
      sha256 = "1lhmx1x8j6z1k9vn32bcsw7g44cg22icshnnc37djlnlixlxm5lk";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  TimeParseDate = buildPerlPackage {
    pname = "Time-ParseDate";
    version = "2015.103";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MU/MUIR/modules/Time-ParseDate-2015.103.tar.gz";
      sha256 = "2c1a06235bf811813caac9eaa9daa71af758667cdf7b082cb59863220fcaeed1";
    };
    doCheck = false;
    meta = {
      description = "Parse and format time values";
      license = with lib.licenses; [ unfree ];
    };
  };

  TimePeriod = buildPerlPackage {
    pname = "Time-Period";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PB/PBOYD/Time-Period-1.25.tar.gz";
      sha256 = "d07fa580529beac6a9c8274c6bf220b4c3aade685df65c1669d53339bf6ef1e8";
    };
    meta = {
      description = "A Perl module to deal with time periods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.winpat ];
    };
  };

  TimePiece = buildPerlPackage {
    pname = "Time-Piece";
    version = "1.3401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ES/ESAYM/Time-Piece-1.3401.tar.gz";
      sha256 = "4b55b7bb0eab45cf239a54dfead277dfa06121a43e63b3fce0853aecfdb04c27";
    };
    meta = {
      description = "Object Oriented time objects";
      homepage = "https://metacpan.org/release/Time-Piece";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  Tirex = buildPerlPackage rec {
    pname = "Tirex";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner  = "openstreetmap";
      repo   = "tirex";
      rev    = "v${version}";
      sha256 = "0dskf50qm6yh3rx6j2nqydr1if71x6ik85hxsa2r9qgldcby2rgh";
    };

    buildInputs = [
      GD
      IPCShareLite
      JSON
      LWP
      HTTPDaemon
      pkgs.cairo
      pkgs.mapnik
      pkgs.zlib
    ];

    installPhase = ''
      make install DESTDIR=$out INSTALLOPTS=""
      mv $out/$out/lib $out/$out/share $out
      rmdir $out/$out $out/nix/store $out/nix
    '';

    meta = {
      description = "Tools for running a map tile server";
      homepage = "https://wiki.openstreetmap.org/wiki/Tirex";
      maintainers = with maintainers; [ jglukasik ];
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  Tk = buildPerlPackage {
    pname = "Tk";
    version = "804.035";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/Tk-804.035.tar.gz";
      sha256 = "4d2b80291ba6de34d8ec886a085a6dbd2b790b926035a087e99025614c5ffdd4";
    };
    makeMakerFlags = "X11INC=${pkgs.xorg.libX11.dev}/include X11LIB=${pkgs.xorg.libX11.out}/lib";
    buildInputs = [ pkgs.xorg.libX11 pkgs.libpng ];
    doCheck = false;            # Expects working X11.
    meta = {
      description = "Tk - a Graphical User Interface Toolkit";
      license = with lib.licenses; [ tcltk ];
    };
  };

  TkToolBar = buildPerlPackage {
    pname = "Tk-ToolBar";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASB/Tk-ToolBar-0.12.tar.gz";
      sha256 = "sha256-Rj4oTsRxN+fEJclpGwKo3sXOJytY6h9jWa6AQaI53Q8=";
    };
    makeMakerFlags = "X11INC=${pkgs.xorg.libX11.dev}/include X11LIB=${pkgs.xorg.libX11.out}/lib";
    buildInputs = [ Tk ];
    doCheck = false;            # Expects working X11.
    meta = {
      description = "A toolbar widget for Perl/Tk";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeDAGNode = buildPerlPackage {
    pname = "Tree-DAG_Node";
    version = "1.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-DAG_Node-1.31.tgz";
      sha256 = "016kr76azxzfcpxjkhqp2piyyl6529shjis20mc3g2snfabsd2qw";
    };
    propagatedBuildInputs = [ FileSlurpTiny ];
    meta = {
      description = "An N-ary tree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimple = buildPerlPackage {
    pname = "Tree-Simple";
    version = "1.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-1.33.tgz";
      sha256 = "1alnwb6c7n4al91m9cyknvcyvdz521lh22dz1hyk4v7c50adffnv";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "A simple tree object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimpleVisitorFactory = buildPerlPackage {
    pname = "Tree-Simple-VisitorFactory";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-VisitorFactory-0.15.tgz";
      sha256 = "06y2vazkl307k59hnkp9h5bp3p7711kgmp1qdhb2lgnfwzn84zin";
    };
    propagatedBuildInputs = [ TreeSimple ];
    buildInputs = [ TestException ];
  };

  TryTiny = buildPerlPackage {
    pname = "Try-Tiny";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz";
      sha256 = "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b";
    };
    buildInputs = [ CPANMetaCheck CaptureTiny ];
    meta = {
      description = "Minimal try/catch with proper preservation of $@";
      homepage = "https://github.com/p5sagit/Try-Tiny";
      license = with lib.licenses; [ mit ];
    };
  };

  TryTinyByClass = buildPerlPackage {
    pname = "Try-Tiny-ByClass";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Try-Tiny-ByClass-0.01.tar.gz";
      sha256 = "0ipif12ix6vnmlyar4gh89libfadbsd9kvqg52f2cpr957slx3h3";
    };
    propagatedBuildInputs = [ DispatchClass TryTiny ];
    meta = {
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Twiggy = buildPerlPackage {
    pname = "Twiggy";
    version = "0.1025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Twiggy-0.1025.tar.gz";
      sha256 = "1a57knbwync7rlzhsz1kdc0sd380xnaccwgiy1qwj5d87abdynnp";
    };
    propagatedBuildInputs = [ AnyEvent Plack ];
    buildInputs = [ TestRequires TestSharedFork TestTCP ];
    meta = {
      description = "AnyEvent HTTP server for PSGI";
      homepage = "https://github.com/miyagawa/Twiggy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "twiggy";
    };
  };

  TypeTiny = buildPerlPackage {
    pname = "Type-Tiny";
    version = "1.012000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-1.012000.tar.gz";
      sha256 = "147axzi07g5akpzbzd2npvdyh9pmzv22a8la1dmylahw2qh15nyk";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    buildInputs = [ TestMemoryCycle ];
    meta = {
      description = "Tiny, yet Moo(se)-compatible type constraint";
      homepage = "https://typetiny.toby.ink";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TypeTinyXS = buildPerlPackage {
    pname = "Type-Tiny-XS";
    version = "0.022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-XS-0.022.tar.gz";
      sha256 = "bcc34a31f7dc1d30cc803889b5c8f90e4773b73b5becbdb3860f5abe7e22ff00";
    };
    meta = {
      description = "Provides an XS boost for some of Type::Tiny's built-in type constraints";
      homepage = "https://metacpan.org/release/Type-Tiny-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TypesSerialiser = buildPerlPackage {
    pname = "Types-Serialiser";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.01.tar.gz";
      sha256 = "104a7292pwwg57rswpkiaq1cgj7hcsrpf818azcy7l0l14xigizq";
    };
    propagatedBuildInputs = [ commonsense ];
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  UNIVERSALcan = buildPerlPackage {
    pname = "UNIVERSAL-can";
    version = "1.20140328";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz";
      sha256 = "522da9f274786fe2cba99bc77cc1c81d2161947903d7fad10bd62dfb7f11990f";
    };
    meta = {
      description = "Work around buggy code calling UNIVERSAL::can() as a function";
      homepage = "https://github.com/chromatic/UNIVERSAL-can";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALisa = buildPerlPackage {
    pname = "UNIVERSAL-isa";
    version = "1.20171012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/UNIVERSAL-isa-1.20171012.tar.gz";
      sha256 = "0avzv9j32aab6l0rd63n92v0pgliz1p4yabxxjfq275hdh1mcsfi";
    };
    meta = {
      description = "Attempt to recover from people calling UNIVERSAL::isa as a function";
      homepage = "https://github.com/karenetheridge/UNIVERSAL-isa";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALrequire = buildPerlPackage {
    pname = "UNIVERSAL-require";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/UNIVERSAL-require-0.18.tar.gz";
      sha256 = "b2a736a87967a143dab58c8a110501d5235bcdd2c8b2a3bfffcd3c0bd06b38ed";
    };
    meta = {
      description = "Require() modules from a variable [deprecated]";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCaseFold = buildPerlModule {
    pname = "Unicode-CaseFold";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AR/ARODLAND/Unicode-CaseFold-1.01.tar.gz";
      sha256 = "418a212808f9d0b8bb330ac905096d2dd364976753d4c71534dab9836a63194d";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Unicode case-folding for case-insensitive lookups";
      homepage = "http://metacpan.org/release/Unicode-CaseFold";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCheckUTF8 = buildPerlPackage {
    pname = "Unicode-CheckUTF8";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRADFITZ/Unicode-CheckUTF8-1.03.tar.gz";
      sha256 = "97f84daf033eb9b49cd8fe31db221fef035a5c2ee1d757f3122c88cf9762414c";
    };
  };

  UnicodeLineBreak = buildPerlPackage {
    pname = "Unicode-LineBreak";
    version = "2019.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz";
      sha256 = "12iinva5gqc9g7qzxrvmh45n714z0ad9g7wq2dxwgp6drbj64rs8";
    };
    propagatedBuildInputs = [ MIMECharset ];
    meta = {
      description = "UAX #14 Unicode Line Breaking Algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeString = buildPerlPackage {
    pname = "Unicode-String";
    version = "2.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz";
      sha256 = "0s4vp8k7ag7z9lsnnkpa9mnch83kxhp9gh7yiapld5a7rq712jl9";
    };
  };

  UnicodeStringprep = buildPerlModule {
    pname = "Unicode-Stringprep";
    version = "1.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/Unicode-Stringprep-1.105.tar.gz";
      sha256 = "e6bebbc58408231fd1317db9102449b3e7da4fa437e79f637382d36313efd011";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Preparation of Internationalized Strings (RFC 3454)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  UnicodeUTF8 = buildPerlPackage {
    pname = "Unicode-UTF8";
    version = "0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Unicode-UTF8-0.62.tar.gz";
      sha256 = "fa8722d0b74696e332fddd442994436ea93d3bfc7982d4babdcedfddd657d0f6";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Encoding and decoding of UTF-8 encoding form";
      homepage = "https://github.com/chansen/p5-unicode-utf8";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  UnixGetrusage = buildPerlPackage {
    pname = "Unix-Getrusage";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TA/TAFFY/Unix-Getrusage-0.03.tar.gz";
      sha256 = "76cde1cee2453260b85abbddc27cdc9875f01d2457e176e03dcabf05fb444d12";
    };
  };

  URI = buildPerlPackage {
    pname = "URI";
    version = "5.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/URI-5.05.tar.gz";
      sha256 = "1v3r3ck67w272kzfgm1nd3wb41av1hlnza56vkxxj1i7s3917hd5";
    };
    buildInputs = [ TestNeeds ];
    meta = {
      description = "Uniform Resource Identifiers (absolute and relative)";
      homepage = "https://github.com/libwww-perl/URI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIdb = buildPerlModule {
    pname = "URI-db";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/URI-db-0.19.tar.gz";
      sha256 = "c4999deaf451652216032c8e327ff6e6d655539eac379095bb69b0c369efa658";
    };
    propagatedBuildInputs = [ URINested ];
    meta = {
      description = "Database URIs";
      homepage = "https://search.cpan.org/dist/URI-db";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFind = buildPerlModule {
    pname = "URI-Find";
    version = "20160806";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/URI-Find-20160806.tar.gz";
      sha256 = "1mk3jv8x0mcq3ajrn9garnxd0jc7sw4pkwqi88r5apqvlljs84z2";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Find URIs in arbitrary text";
      homepage = "http://metacpan.org/release/URI-Find";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "urifind";
    };
  };

  URIFromHash = buildPerlPackage {
    pname = "URI-FromHash";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.05.tar.gz";
      sha256 = "1l3g5ygv83vn9y1zpwjdqq5cs4ip2q058q0gmpcf5wp9rsycbjm7";
    };
    propagatedBuildInputs = [ ParamsValidate URI ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Build a URI from a set of named parameters";
      homepage = "http://metacpan.org/release/URI-FromHash";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  UriGoogleChart = buildPerlPackage {
    pname = "URI-GoogleChart";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/URI-GoogleChart-1.02.tar.gz";
      sha256 = "00hq5cpsk7sa04n0wg52qhpqf9i2849yyvw2zk83ayh1qqpc50js";
    };
    propagatedBuildInputs = [ URI ];
  };

  UserIdentity = buildPerlPackage {
    pname = "User-Identity";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/User-Identity-1.00.tar.gz";
      sha256 = "0jlzishg33848qvl5x7nsrnlpnx7lfg5hr4m1qrjddzy3hkv86cj";
    };
    meta = {
      description = "Collect information about a user";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIIMAP = buildPerlPackage {
    pname = "URI-imap";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CW/CWEST/URI-imap-1.01.tar.gz";
      sha256 = "0bdv6mrdijcq46r3lmz801rscs63f8p9qqliy2safd6fds4rj55v";
    };
    propagatedBuildInputs = [ URI ];
  };

  URINested = buildPerlModule {
    pname = "URI-Nested";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/URI-Nested-0.10.tar.gz";
      sha256 = "e1971339a65fbac63ab87142d4b59d3d259d51417753c77cb58ea31a8233efaf";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Nested URIs";
      homepage = "https://metacpan.org/release/URI-Nested";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URISmartURI = buildPerlPackage {
    pname = "URI-SmartURI";
    version = "0.032";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/URI-SmartURI-0.032.tar.gz";
      sha256 = "0b2grkmkbnp37q85wj7jpj5zr93vdbisgxlls2vl5q928rwln5zb";
    };
    propagatedBuildInputs = [ ClassC3Componentised FileFindRule ListMoreUtils Moose URI namespaceclean ];
    buildInputs = [ TestFatal TestNoWarnings ];
    meta = {
      description = "Subclassable and hostless URIs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URITemplate = buildPerlPackage {
    pname = "URI-Template";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICAS/URI-Template-0.24.tar.gz";
      sha256 = "1phibcmam2hklrddzj79l43va1gcqpyszbw21ynxq53ynmhjvbk8";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Object for handling URI templates (RFC 6570)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIcpan = buildPerlPackage {
    pname = "URI-cpan";
    version = "1.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/URI-cpan-1.007.tar.gz";
      sha256 = "1lsjw7m9c3vyq1h9pqzngww18yq23mn4jxv9d7i4a2ifcsa16nhj";
    };
    propagatedBuildInputs = [ CPANDistnameInfo URI ];
    meta = {
      description = "URLs that refer to things on the CPAN";
      homepage = "https://github.com/rjbs/URI-cpan";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIws = buildPerlPackage {
    pname = "URI-ws";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/URI-ws-0.03.tar.gz";
      sha256 = "6e6b0e4172acb6a53c222639c000608c2dd61d50848647482ac8600d50e541ef";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "WebSocket support for URI package";
      homepage = "http://perl.wdlabs.com/URI-ws";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UUID4Tiny = buildPerlPackage {
    pname = "UUID4-Tiny";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CV/CVLIBRARY/UUID4-Tiny-0.002.tar.gz";
      sha256 = "e7535b31e386d432dec7adde214348389e1d5cf753e7ed07f1ae04c4360840cf";
    };
    postPatch = lib.optionalString (stdenv.isAarch64) ''
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/unistd.h
      # printf SYS_getrandom | gcc -include sys/syscall.h -E -
      substituteInPlace lib/UUID4/Tiny.pm \
        --replace "syscall( 318" "syscall( 278"
    '';
    meta = {
      description = "Cryptographically secure v4 UUIDs for Linux x64";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.linux; # configure phase fails with "OS unsupported"
    };
  };

  UUIDTiny = buildPerlPackage {
    pname = "UUID-Tiny";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAUGUSTIN/UUID-Tiny-1.04.tar.gz";
      sha256 = "6dcd92604d64e96cc6c188194ae16a9d3a46556224f77b6f3d1d1312b68f9a3d";
    };
    meta = {
      description = "Pure Perl UUID Support With Functional Interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UUIDURandom = buildPerlPackage {
    pname = "UUID-URandom";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/UUID-URandom-0.001.tar.gz";
      sha256 = "3f13631b13b9604fb489e2989490c99f103743a837239bdafae9d6baf55f8f46";
    };
    propagatedBuildInputs = [ CryptURandom ];
    meta = {
      description = "UUIDs based on /dev/urandom or the Windows Crypto API";
      homepage = "https://github.com/dagolden/UUID-URandom";
      license = with lib.licenses; [ asl20 ];
    };
  };

  VariableMagic = buildPerlPackage {
    pname = "Variable-Magic";
    version = "0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/Variable-Magic-0.62.tar.gz";
      sha256 = "3f9a18517e33f006a9c2fc4f43f01b54abfe6ff2eae7322424f31069296b615c";
    };
    meta = {
      description = "Associate user-defined magic to variables from Perl";
      homepage = "http://search.cpan.org/dist/Variable-Magic";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Version = buildPerlPackage {
    pname = "version";
    version = "0.9928";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/version-0.9928.tar.gz";
      sha256 = "13mabl07rhwwlshj72hvp1j43q3ygxf7wp7qxx3nbqbnrf6i83i4";
    };
    meta = {
      description = "Structured version objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  vidir = buildPerlPackage {
    pname = "App-vidir";
    version = "0.050";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WOLDRICH/App-vidir-0.050.tar.gz";
      sha256 = "1xa3vabbkxaqa8pnyl0dblr1m4g2229m1fzl8c9q74f06i00hikh";
    };
    outputs = [ "out" ];
    meta = {
      description = "File manager USING vim itself";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.chreekat ];
      mainProgram = "vidir";
    };
  };

  VMEC2 = buildPerlModule {
    pname = "VM-EC2";
    version = "1.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/VM-EC2-1.28.tar.gz";
      sha256 = "b2b6b31745c57431fca0efb9b9d0b8f168d6081755e048fd9d6c4469bd108acd";
    };
    propagatedBuildInputs = [ AnyEventCacheDNS AnyEventHTTP JSON StringApprox XMLSimple ];
    meta = {
      description = "Perl interface to Amazon EC2, Virtual Private Cloud, Elastic Load Balancing, Autoscaling, and Relational Database services";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  VMEC2SecurityCredentialCache = buildPerlPackage {
    pname = "VM-EC2-Security-CredentialCache";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCONOVER/VM-EC2-Security-CredentialCache-0.25.tar.gz";
      sha256 = "fc7e9c152ff2b721ccb221ac40089934775cf58366aedb5cc1693609f840937b";
    };
    propagatedBuildInputs = [ DateTimeFormatISO8601 VMEC2 ];
    meta = {
      description = "Cache credentials respecting expiration time for IAM roles";
      homepage = "http://search.cpan.org/dist/VM-EC2-Security-CredentialCache";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  W3CLinkChecker = buildPerlPackage {
    pname = "W3C-LinkChecker";
    version = "4.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/W3C-LinkChecker-4.81.tar.gz";
      sha256 = "6239f61b20d91dce7b21e4d4f626ab93a8f1e2f207da5015590d508cf6c66a65";
    };
    outputs = [ "out" ];
    propagatedBuildInputs = [ CGI CSSDOM ConfigGeneral LWP LocaleCodes NetIP TermReadKey ];
    meta = {
      description = "W3C Link Checker";
      homepage = "https://validator.w3.org/checklink";
      license = with lib.licenses; [ w3c ];
      mainProgram = "checklink";
    };
  };

  WWWCurl = buildPerlPackage {
    pname = "WWW-Curl";
    version = "4.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZBALINT/WWW-Curl-4.17.tar.gz";
      sha256 = "1fmp9aib1kaps9vhs4dwxn7b15kgnlz9f714bxvqsd1j1q8spzsj";
    };
    patches = [
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/curl-7.71.0.patch?h=perl-www-curl&id=261d84887d736cc097abef61164339216fb79180";
        sha256 = "1hiw5lkflfa93z5d6k8fnnml0r08c653bbvvb8zx6gcrlbrdalfs";
        name = "WWWCurl-curl-7.71.0.patch";
      })
    ];
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-return-type";
    buildInputs = [ pkgs.curl ];
    doCheck = false; # performs network access
  };

  WWWFormUrlEncoded = buildPerlModule {
    pname = "WWW-Form-UrlEncoded";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/WWW-Form-UrlEncoded-0.26.tar.gz";
      sha256 = "1x4h5m5fkwaa0gbn6zp9mjrhr3r989w8wyrjxiii3dqm3xghnj60";
    };
    meta = {
      description = "Parser and builder for application/x-www-form-urlencoded";
      homepage = "https://github.com/kazeburo/WWW-Form-UrlEncoded";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWMechanize = buildPerlPackage {
    pname = "WWW-Mechanize";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/WWW-Mechanize-2.03.tar.gz";
      sha256 = "0pl4jc6hmkhzkswka62dij7l0378qvn9dwbh08n54q8xyr6xf79z";
    };
    propagatedBuildInputs = [ HTMLForm HTMLTree LWP ];
    doCheck = false;
    buildInputs = [ CGI HTTPServerSimple PathTiny TestDeep TestFatal TestOutput TestWarnings ];
    meta = {
      description = "Handy web browsing in a Perl object";
      homepage = "https://github.com/libwww-perl/WWW-Mechanize";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "mech-dump";
    };
  };

  WWWMechanizeCGI = buildPerlPackage {
    pname = "WWW-Mechanize-CGI";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/WWW-Mechanize-CGI-0.3.tar.gz";
      sha256 = "046jm18liq7rwkdawdh9520cnalkfrk26yqryp7xgw71y65lvq61";
    };
    propagatedBuildInputs = [ HTTPRequestAsCGI WWWMechanize ];
    preConfigure = ''
      substituteInPlace t/cgi-bin/script.cgi \
        --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    '';
    meta = {
      license = with lib.licenses; [ unfree ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.WWWMechanizeCGI.x86_64-darwin
    };
  };

  WWWRobotRules = buildPerlPackage {
    pname = "WWW-RobotRules";
    version = "6.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz";
      sha256 = "07m50dp5n5jxv3m93i55qvnd67a6g7cvbvlik115kmc8lbkh5da6";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Database of robots.txt-derived permissions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWTwilioAPI = buildPerlPackage {
    pname = "WWW-Twilio-API";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTTW/WWW-Twilio-API-0.21.tar.gz";
      sha256 = "582db53a091f8da3670c037733314f2510af5e8ee0ba42a0e391e2f2e3ca7734";
    };
    prePatch = "rm examples.pl";
    propagatedBuildInputs = [ LWPProtocolHttps ];
    meta = {
      description = "Accessing Twilio's REST API with Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWYoutubeViewer = callPackage ../development/perl-modules/WWW-YoutubeViewer { };

  Want = buildPerlPackage {
    pname = "Want";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/Want-0.29.tar.gz";
      sha256 = "1xsjylbxxcbkjazqms49ipi94j1hd2ykdikk29cq7dscil5p9r5l";
    };
  };

  Win32ShellQuote = buildPerlPackage {
    pname = "Win32-ShellQuote";
    version = "0.003001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Win32-ShellQuote-0.003001.tar.gz";
      sha256 = "aa74b0e3dc2d41cd63f62f853e521ffd76b8d823479a2619e22edb4049b4c0dc";
    };
    meta = {
      description = "Quote argument lists for Win32";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Workflow = buildPerlModule {
    pname = "Workflow";
    version = "1.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JONASBN/Workflow-1.48.tar.gz";
      sha256 = "0bz6gil9mygh5ikh8mf86ids9xb1dbgx9hqc1g68qn9ffsyb012f";
    };
    buildInputs = [ DBDMock ListMoreUtils PodCoverageTrustPod TestException TestKwalitee TestPod TestPodCoverage ];
    propagatedBuildInputs = [ ClassAccessor ClassFactory ClassObservable DBI DataUUID DateTimeFormatStrptime FileSlurp LogDispatch LogLog4perl XMLSimple ];
    meta = {
      description = "Simple, flexible system to implement workflows";
      homepage = "https://github.com/jonasbn/perl-workflow";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Wx = buildPerlPackage {
    pname = "Wx";
    version = "0.9932";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/Wx-0.9932.tar.gz";
      sha256 = "0w0vcpk8bmklh16c0z1vxgipnmvdw7cckcmay7k7cihgb99vdz8w";
    };
    propagatedBuildInputs = [ AlienWxWidgets ];
    # Testing requires an X server:
    #   Error: Unable to initialize GTK, is DISPLAY set properly?"
    doCheck = false;
    buildInputs = [ ExtUtilsXSpp ];
  };

  WxGLCanvas = buildPerlPackage {
    pname = "Wx-GLCanvas";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/Wx-GLCanvas-0.09.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ pkgs.libGLU Wx ];
    doCheck = false;
  };

  X11IdleTime = buildPerlPackage {
    pname = "X11-IdleTime";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWENDT/X11-IdleTime-0.09.tar.gz";
      sha256 = "0j27cb9yy9ymni8cbiyxplbg086b8lv6b330nwqyx0briq3xrzfq";
    };
    buildInputs = [ pkgs.xorg.libXext pkgs.xorg.libXScrnSaver pkgs.xorg.libX11 ];
    propagatedBuildInputs = [ InlineC ];
    patchPhase = "sed -ie 's,-L/usr/X11R6/lib/,-L${pkgs.xorg.libX11.out}/lib/ -L${pkgs.xorg.libXext.out}/lib/ -L${pkgs.xorg.libXScrnSaver}/lib/,' IdleTime.pm";
    meta = {
      description = "Get the idle time of X11";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  X11Protocol = buildPerlPackage {
    pname = "X11-Protocol";
    version = "0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMCCAM/X11-Protocol-0.56.tar.gz";
      sha256 = "1dq89bh6fqv7l5mbffqcismcljpq5f869bx7g8lg698zgindv5ny";
    };
    buildInputs = [ pkgs.xlibsWrapper ];
    NIX_CFLAGS_LINK = "-lX11";
    doCheck = false; # requires an X server
  };

  X11ProtocolOther = buildPerlPackage {
    pname = "X11-Protocol-Other";
    version = "31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/X11-Protocol-Other-31.tar.gz";
      sha256 = "1x3kvic52jgp2mvd5wzrqrprqi82cdk8l4075v8b33ksvj9mjqiw";
    };
    propagatedBuildInputs = [ X11Protocol ];
    buildInputs = [ EncodeHanExtra ModuleUtil ];
    meta = {
      description = "Miscellaneous helpers for X11::Protocol connections";
      homepage = "http://user42.tuxfamily.org/x11-protocol-other/index.html";
      license = with lib.licenses; [ gpl1Plus gpl3Plus ];
    };
  };

  X11GUITest = buildPerlPackage {
    pname = "X11-GUITest";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/X11-GUITest-0.28.tar.gz";
      sha256 = "0jznws68skdzkhgkgcgjlj40qdyh9i75r7fw8bqzy406f19xxvnw";
    };
    buildInputs = [ pkgs.xlibsWrapper pkgs.xorg.libXtst pkgs.xorg.libXi ];
    NIX_CFLAGS_LINK = "-lX11 -lXext -lXtst";
    doCheck = false; # requires an X server
  };

  X11XCB = buildPerlPackage {
    pname = "X11-XCB";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/X11-XCB-0.18.tar.gz";
      sha256 = "1cjpghw7cnackw20lbd7yzm222kz5bnrwz52f8ay24d1f4pwrnxf";
    };
    patches = [
      # Pull upstream fix for parallel build failure
      (fetchpatch {
        url = "https://github.com/stapelberg/X11-XCB/commit/813608dacdae1ae35c9eb0f171a958617e014520.patch";
        sha256 = "017f5r4fyryhzgp99lw3csrl21r27hmqv483vp9fdz9xkvrmh743";
      })
    ];
    AUTOMATED_TESTING = false;
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.xorg.libxcb pkgs.xorg.xcbproto pkgs.xorg.xcbutil pkgs.xorg.xcbutilwm ExtUtilsDepends ExtUtilsPkgConfig TestDeep TestException XSObjectMagic ];
    propagatedBuildInputs = [ DataDump MouseXNativeTraits XMLDescent XMLSimple ];
    NIX_CFLAGS_LINK = "-lxcb -lxcb-util -lxcb-xinerama -lxcb-icccm";
    doCheck = false; # requires an X server
    meta = {
      description = "Perl bindings for libxcb";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLCanonicalizeXML = buildPerlPackage {
    pname = "XML-CanonicalizeXML";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SJ/SJZASADA/XML-CanonicalizeXML-0.10.tar.gz";
      sha256 = "1vl6wbqmq91mc0hkgfwlndbxcv2jm01hj7kpzprw3d6bh144ca77";
    };
    buildInputs = [ pkgs.libxml2 ];
    meta = {
      description = "Perl extension for inclusive (1.0 and 1.1) and exclusive canonicalization of XML using libxml2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  XMLDescent = buildPerlModule {
    pname = "XML-Descent";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/XML-Descent-1.04.tar.gz";
      sha256 = "0l5xmw2hd95ypppz3lyvp4sn02ccsikzjwacli3ydxfdz1bbh4d7";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ XMLTokeParser ];
    meta = {
      description = "Recursive descent XML parsing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLEncoding = buildPerlPackage {
    pname = "XML-Encoding";
    version = "2.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/XML-Encoding-2.11.tar.gz";
      sha256 = "a50e41af0a79b882d48816b95681f38a55af1e6a88828dcd96374a8bde2305a1";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "A perl module for parsing XML encoding maps";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDOM = buildPerlPackage {
    pname = "XML-DOM";
    version = "1.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.46.tar.gz";
      sha256 = "0phpkc4li43m2g44hdcvyxzy9pymqwlqhh5hwp2xc0cv8l5lp8lb";
    };
    propagatedBuildInputs = [ XMLRegExp libxml_perl ];
  };

  XMLFeedPP = buildPerlPackage {
    pname = "XML-FeedPP";
    version = "0.95";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/XML-FeedPP-0.95.tar.gz";
      sha256 = "1x5806xwmbqxr1dkdhalb6d7n31s3ya776klkai7c2x6y6drbhwh";
    };
    propagatedBuildInputs = [ XMLTreePP ];
    meta = {
      description = "Parse/write/merge/edit RSS/RDF/Atom syndication feeds";
      homepage = "http://perl.overmeer.net/CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLFilterBufferText = buildPerlPackage {
    pname = "XML-Filter-BufferText";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz";
      sha256 = "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c";
    };
    doCheck = false;
  };

  XMLFilterXInclude = buildPerlPackage {
    pname = "XML-Filter-XInclude";
    version = "1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Filter-XInclude-1.0.tar.gz";
      sha256 = "98746f3c1f6f049491fec203d455bb8f8c9c6e250f041904dda5d78e21187f93";
    };
    doCheck = false;
  };

  XMLFilterSort = buildPerlPackage {
    pname = "XML-Filter-Sort";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Filter-Sort-1.01.tar.gz";
      sha256 = "sha256-UQWF85pJFszV+o1UXpYXnJHq9vx8l6QBp1aOhBFi+l8=";
    };
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [
      XMLSAX
      XMLSAXWriter
    ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/xmlsort
    '';
    meta = {
      description = "SAX filter for sorting elements in XML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "xmlsort";
    };
  };

  XMLGrove = buildPerlPackage {
    pname = "XML-Grove";
    version = "0.46alpha";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/XML-Grove-0.46alpha.tar.gz";
      sha256 = "05yis1ms7cgwjh57k57whrmalb3ha0bjr9hyvh7cnadcyiynvdpw";
    };
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ libxml_perl ];

    #patch from https://bugzilla.redhat.com/show_bug.cgi?id=226285
    patches = [ ../development/perl-modules/xml-grove-utf8.patch ];
    meta = {
      description = "Perl-style XML objects";
      license = with lib.licenses; [ unfree ];
    };
  };

  XMLHandlerYAWriter = buildPerlPackage {
    pname = "XML-Handler-YAWriter";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRAEHE/XML-Handler-YAWriter-0.23.tar.gz";
      sha256 = "11d45a1sz862va9rry3p2m77pwvq3kpsvgwhc5ramh9mbszbnk77";
    };
    propagatedBuildInputs = [ libxml_perl ];
    meta = {
      description = "Yet another Perl SAX XML Writer";
      license = with lib.licenses; [ unfree ];
      mainProgram = "xmlpretty";
    };
  };

  XMLLibXML = buildPerlPackage {
    pname = "XML-LibXML";
    version = "2.0207";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0207.tar.gz";
      sha256 = "sha256-kDQ2yYWYdb71WTJDquhc7TKa0PtLV7v0WXXjJUfFDBU=";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ AlienBuild AlienLibxml2 ]
      ++ lib.optionals stdenv.isDarwin (with pkgs; [ libiconv zlib ]);
    propagatedBuildInputs = [ XMLSAX ];
  };

  XMLLibXMLSimple = buildPerlPackage {
    pname = "XML-LibXML-Simple";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz";
      sha256 = "cd98c8104b70d7672bfa26b4513b78adf2b4b9220e586aa8beb1a508500365a6";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      description = "An API for simple XML files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLLibXSLT = buildPerlPackage {
    pname = "XML-LibXSLT";
    version = "1.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.99.tar.gz";
      sha256 = "1w7pn0wb88nma6biy4h05ak3j4ykma6vz1wbkrxy8qgvfyl1fzhj";
    };
    buildInputs = [ pkgs.pkg-config pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
  };

  XMLMini = buildPerlPackage {
    pname = "XML-Mini";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PD/PDEEGAN/XML-Mini-1.38.tar.gz";
      sha256 = "af803d38036a3184e124a682e5466f1bc107f48a89ef35b0c7647e11a073fe2d";
    };
    meta = {
      license = with lib.licenses; [ unfree ];
    };
  };

  XMLNamespaceSupport = buildPerlPackage {
    pname = "XML-NamespaceSupport";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz";
      sha256 = "1vz5pbi4lm5fhq2slrs2hlp6bnk29863abgjlcx43l4dky2rbsa7";
    };
  };

  XMLParser = buildPerlPackage {
    pname = "XML-Parser";
    version = "2.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz";
      sha256 = "0pai3ik47q7rgnix9644c673fwydz52gqkxr9kxwq765j4j36cfk";
    };
    patches = [ ../development/perl-modules/xml-parser-0001-HACK-Assumes-Expat-paths-are-good.patch ];
    postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Expat/Makefile.PL --replace 'use English;' '#'
    '' + lib.optionalString stdenv.isCygwin ''
      sed -i"" -e "s@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. \$Config{_exe};@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. (\$^O eq 'cygwin' ? \"\" : \$Config{_exe});@" inc/Devel/CheckLib.pm
    '';
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat.out}/lib EXPATINCPATH=${pkgs.expat.dev}/include";
    propagatedBuildInputs = [ LWP ];
  };

  XMLParserLite = buildPerlPackage {
    pname = "XML-Parser-Lite";
    version = "0.722";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/XML-Parser-Lite-0.722.tar.gz";
      sha256 = "1vk3jwh1kfcsmc5kvxzqdnb1cllvf0yf27fg0ra0w6jkw4ks143g";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Lightweight pure-perl XML Parser (based on regexps)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLXPath = buildPerlPackage {
    pname = "XML-XPath";
    version = "1.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/XML-XPath-1.44.tar.gz";
      sha256 = "1cc9110705165dc09dd09974dd7c0b6709c9351d6b6b1cef5a711055f891dd0f";
    };
    buildInputs = [ PathTiny ];
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Parse and evaluate XPath statements";
      license = with lib.licenses; [ artistic2 ];
      mainProgram = "xpath";
    };
  };

  XMLXPathEngine = buildPerlPackage {
    pname = "XML-XPathEngine";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIROD/XML-XPathEngine-0.14.tar.gz";
      sha256 = "0r72na14bmsxfd16s9nlza155amqww0k8wsa9x2a3sqbpp5ppznj";
    };
    meta = {
      description = "A re-usable XPath engine for DOM-like trees";
      license = with lib.licenses; [ unfree ];
    };
  };

  XMLRegExp = buildPerlPackage {
    pname = "XML-RegExp";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz";
      sha256 = "0m7wj00a2kik7wj0azhs1zagwazqh3hlz4255n75q21nc04r06fz";
    };
  };

  XMLRPCLite = buildPerlPackage {
    pname = "XMLRPC-Lite";
    version = "0.717";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/XMLRPC-Lite-0.717.tar.gz";
      sha256 = "0925md6jhzgpsibwgny4my461b2wngm8dhxlcry8pbqzrgrab7rs";
    };
    propagatedBuildInputs = [ SOAPLite ];
    # disable tests that require network
    preCheck = "rm t/{26-xmlrpc.t,37-mod_xmlrpc.t}";
    meta = {
      description = "Client and server implementation of XML-RPC protocol";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLRSS = buildPerlModule {
    pname = "XML-RSS";
    version = "1.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-RSS-1.62.tar.gz";
      sha256 = "0klb8ghd405pdkmn25lp3i4j2lfydz8w581sk51p3zy788s0c9yk";
    };
    propagatedBuildInputs = [ DateTimeFormatMail DateTimeFormatW3CDTF XMLParser ];
    meta = {
      description = "Creates and updates RSS files";
      homepage = "http://metacpan.org/release/XML-RSS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLRules = buildPerlModule {
    pname = "XML-Rules";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JENDA/XML-Rules-1.16.tar.gz";
      sha256 = "3788255c07afe4195a0de72ce050652320d817528ff2d10c611f6e392043868b";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Parse XML and specify what and how to keep/process for individual tags";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAX = buildPerlPackage {
    pname = "XML-SAX";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz";
      sha256 = "0am13vnv8qsjafr5ljakwnkhlwpk15sga02z8mxsg9is0j3w61j5";
    };
    propagatedBuildInputs = [ XMLNamespaceSupport XMLSAXBase ];
    postInstall = ''
      perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
      '';
  };

  XMLSAXBase = buildPerlPackage {
    pname = "XML-SAX-Base";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz";
      sha256 = "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0";
    };
    meta = {
      description = "Base class for SAX Drivers and Filters";
      homepage = "https://github.com/grantm/XML-SAX-Base";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAXExpat = buildPerlPackage {
    pname = "XML-SAX-Expat";
    version = "0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJOERN/XML-SAX-Expat-0.51.tar.gz";
      sha256 = "0gy8h2bvvvlxychwsb99ikdh5cqpk6sqc073jk2b4zffs09n40ac";
    };
    propagatedBuildInputs = [ XMLParser XMLSAX ];
    # Avoid creating perllocal.pod, which contains a timestamp
    installTargets = [ "pure_install" ];
    meta = {
      description = "SAX Driver for Expat";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAXWriter = buildPerlPackage {
    pname = "XML-SAX-Writer";
    version = "0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.57.tar.gz";
      sha256 = "3d61d07ef43b0126f5b4de4f415a256fa859fa88dc4fdabaad70b7be7c682cf0";
    };
    propagatedBuildInputs = [ XMLFilterBufferText XMLNamespaceSupport XMLSAXBase ];
    meta = {
      description = "SAX2 XML Writer";
      homepage = "https://github.com/perigrin/xml-sax-writer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSemanticDiff = buildPerlModule {
    pname = "XML-SemanticDiff";
    version = "1.0007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SemanticDiff-1.0007.tar.gz";
      sha256 = "1xd00821y795fy2rag8aizb5wsbbzfxgmdf9qwpvdxn3pgpyzz85";
    };
    propagatedBuildInputs = [ XMLParser ];
  };

  XMLSimple = buildPerlPackage {
    pname = "XML-Simple";
    version = "2.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz";
      sha256 = "1y6vh328zrh085d40852v4ij2l4g0amxykswxd1nfhd2pspds7sk";
    };
    propagatedBuildInputs = [ XMLSAXExpat ];
  };

  XMLTokeParser = buildPerlPackage {
    pname = "XML-TokeParser";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/XML-TokeParser-0.05.tar.gz";
      sha256 = "1hnpwb3lh6cbgwvjjgqzcp6jm4mp612qn6ili38adc9nhkwv8fc5";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Simplified interface to XML::Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTreePP = buildPerlPackage {
    pname = "XML-TreePP";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAWASAKI/XML-TreePP-0.43.tar.gz";
      sha256 = "7fbe2d6430860059894aeeebf75d4cacf1bf8d7b75294eb87d8e1502f81bd760";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Pure Perl implementation for parsing/writing XML documents";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTwig = buildPerlPackage {
    pname = "XML-Twig";
    version = "3.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.52.tar.gz";
      sha256 = "1bc0hrz4jp6199hi29sdxmb9gyy45whla9hd19yqfasgq8k5ixzy";
    };
    postInstall = ''
      mkdir -p $out/bin
      cp tools/xml_grep/xml_grep $out/bin
    '';
    propagatedBuildInputs = [ XMLParser ];
    doCheck = false;  # requires lots of extra packages
    meta = {
      description = "A Perl module for processing huge XML documents in tree mode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "xml_grep";
    };
  };

  XMLValidatorSchema = buildPerlPackage {
    pname = "XML-Validator-Schema";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/XML-Validator-Schema-1.10.tar.gz";
      sha256 = "6142679580150a891f7d32232b5e31e2b4e5e53e8a6fa9cbeecb5c23814f1422";
    };
    propagatedBuildInputs = [ TreeDAGNode XMLFilterBufferText XMLSAX ];
    meta = {
      description = "Validate XML against a subset of W3C XML Schema";
      license = with lib.licenses; [ unfree ];
    };
  };

  XMLWriter = buildPerlPackage {
    pname = "XML-Writer";
    version = "0.900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz";
      sha256 = "07qd806kcs7si7qakx3x5p68xq2jdmkxdrns987kaayg7syzbj3k";
    };
  };

  XSObjectMagic = buildPerlPackage {
    pname = "XS-Object-Magic";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/XS-Object-Magic-0.05.tar.gz";
      sha256 = "0njyy4y0zax4zz55y82dlm9cly1pld1lcxb281s12bp9rrhf9j9x";
    };
    buildInputs = [ ExtUtilsDepends TestFatal TestSimple13 ];
    meta = {
      description = "Opaque, extensible XS pointer backed objects using sv_magic";
      homepage = "https://github.com/karenetheridge/XS-Object-Magic";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XSParseKeyword = buildPerlModule {
    pname = "XS-Parse-Keyword";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/XS-Parse-Keyword-0.25.tar.gz";
      sha256 = "sha256-9e2zDPfH8iDQxsMdwetVQDKECpnHwpgxT1zD/vZscsc=";
    };
    buildInputs = [ ExtUtilsCChecker ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "XS functions to assist in parsing keyword syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  XSParseSublike = buildPerlModule {
    pname = "XS-Parse-Sublike";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/XS-Parse-Sublike-0.16.tar.gz";
      sha256 = "sha256-IV5AmzmFgdJfDv8DeFBjvCUTu4YbrL6Z/m1VNTRvZt8=";
    };
    buildInputs = [ TestFatal ];
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "XS functions to assist in parsing sub-like syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.zakame ];
    };
  };

  XXX = buildPerlPackage {
    pname = "XXX";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/XXX-0.35.tar.gz";
      sha256 = "1azk2h3d2vxc84zpa34gr0dvhvf5qkwbaidy3ks0gkkx9463crm6";
    };
    propagatedBuildInputs = [ YAMLPP ];
    meta = {
      description = "See Your Data in the Nude";
      homepage = "https://github.com/ingydotnet/xxx-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAML = buildPerlPackage {
    pname = "YAML";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-1.30.tar.gz";
      sha256 = "1kbrfksjg4k4vmx1i337m5n69m00m0m5bgsh61c15bzzrgbacc2h";
    };

    buildInputs = [ TestBase TestDeep TestYAML ];

    meta = {
      description = "YAML Ain't Markup Language (tm)";
      homepage = "https://github.com/ingydotnet/yaml-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLOld = buildPerlPackage {
    pname = "YAML-Old";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/YAML-Old-1.23.tar.gz";
      sha256 = "fa546fcd9acc5a39bc8871902f7fc1eba50e7dc781c5cd5c0abf1aece6d17ecd";
    };
    buildInputs = [ TestYAML TestBase ];
    meta = {
      description = "Old YAML.pm Legacy Code";
      homepage = "https://github.com/ingydotnet/yaml-old-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLSyck = buildPerlPackage {
    pname = "YAML-Syck";
    version = "1.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/YAML-Syck-1.34.tar.gz";
      sha256 = "0na1wg3d7ykzy5i44w6i1s37ymq6x0cvcc9gzvmri9xxmv65d4fc";
    };
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Fast, lightweight YAML loader and dumper";
      homepage = "http://github.com/toddr/YAML-Syck";
      license = with lib.licenses; [ mit ];
    };
  };

  YAMLTiny = buildPerlPackage {
    pname = "YAML-Tiny";
    version = "1.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz";
      sha256 = "0i3p4nz8ysrsrs6vlzc6gkjcfpcaf05xjc7lwbjkw7lg5shmycdw";
    };
  };

  YAMLLibYAML = buildPerlPackage {
    pname = "YAML-LibYAML";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-LibYAML-0.83.tar.gz";
      sha256 = "sha256-tHF1tP85etdaT3eB09g8CGN9pv8LrjJq87OJ2FS+xJA=";
    };
  };

  YAMLPP = buildPerlPackage {
    pname = "YAML-PP";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-PP-0.026.tar.gz";
      sha256 = "1ss5b8ny00pvg6bfx562hy7z5hj02w1yh224qpn6dsgk3ikqx1ab";
    };
    buildInputs = [ TestDeep TestWarn ];
    meta = {
      description = "YAML 1.2 Processor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WebMachine = buildPerlPackage {
    pname = "Web-Machine";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Web-Machine-0.17.tar.gz";
      sha256 = "f139d2b3114c549e91847daaab8b75cb699e57daf5bbf0dbd13293f33fe5e22a";
    };
    buildInputs = [ NetHTTP TestFailWarnings TestFatal ];
    propagatedBuildInputs = [ HTTPHeadersActionPack HTTPMessage HashMultiValue IOHandleUtil ModuleRuntime Plack SubExporter TryTiny ];
    meta = {
      description = "A Perl port of Webmachine";
      homepage = "http://metacpan.org/release/Web-Machine";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WebServiceLinode = buildPerlModule {
    pname = "WebService-Linode";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEGRB/WebService-Linode-0.29.tar.gz";
      sha256 = "103aab245304f08e9e87ac7bc884ddb44a630de6bac077dc921f716d71154922";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ JSON LWPProtocolHttps ];
    meta = {
      description = "Perl Interface to the Linode.com API";
      homepage = "https://github.com/mikegrb/WebService-Linode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WebServiceValidatorHTMLW3C = buildPerlModule {
    pname = "WebService-Validator-HTML-W3C";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STRUAN/WebService-Validator-HTML-W3C-0.28.tar.gz";
      sha256 = "sha256-zLB60zegOuyBob6gqJzSlUaR/1uzZ9+aMrnZEw8XURA=";
    };
    buildInputs = [ ClassAccessor LWP ];
    meta = {
      description = "Access the W3Cs online HTML validator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ZonemasterCLI = buildPerlPackage {
    pname = "Zonemaster-CLI";
    version = "4.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-CLI-v4.0.1.tar.gz";
      sha256 = "edd34f7b8137e492e6ce8474c45a550572dca5056abdefc45c076df9d6965ca0";
    };
    propagatedBuildInputs = [
      JSONXS
      MooseXGetopt
      TextReflow
      ZonemasterEngine
      ZonemasterLDNS
      libintl-perl
    ];

    preConfigure = ''
      patchShebangs script/
    '';

    meta = {
      description = "Run Zonemaster tests from the command line";
      license = with lib.licenses; [ bsd3 ];
      maintainers = with lib.maintainers; [ qbit ];
    };
  };

  ZonemasterEngine = buildPerlPackage {
    pname = "Zonemaster-Engine";
    version = "4.5.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-Engine-v4.5.1.tar.gz";
      sha256 = "45d204c6dad7cd90176084bf2427baa8ce503684a5699ebeb236e4d33bc0ba86";
    };
    buildInputs = [ PodCoverage TestDifferences TestException TestFatal TestNoWarnings TestPod ];
    propagatedBuildInputs = [ ClassAccessor Clone EmailValid FileShareDir FileSlurp IOSocketInet6 ListMoreUtils ModuleFind Moose MooseXSingleton NetIP Readonly TextCSV ZonemasterLDNS libintl-perl ];

    preCheck = ''
      # disable dnssec test as it fails
      rm -f t/Test-dnssec.t t/manifest.t
    '';

    meta = {
      description = "A tool to check the quality of a DNS zone";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  ZonemasterLDNS = buildPerlPackage {
    pname = "Zonemaster-LDNS";
    version = "2.2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-LDNS-2.2.2.tar.gz";
      sha256 = "e0a71c3e35aa761909be323d4101823d7fc1f2f4541b0f75794520c611e4efcf";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include -I${pkgs.libidn2}.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.libidn2}/lib -lcrypto -lidn2";

    makeMakerFlags = "--prefix-openssl=${pkgs.openssl.dev}";

    buildInputs = [ DevelChecklib ModuleInstall ModuleInstallXSUtil TestFatal pkgs.ldns pkgs.libidn2 pkgs.openssl pkgs.pkg-config ];
    meta = {
      description = "Perl wrapper for the ldns DNS library";
      license = lib.licenses.bsd3;
    };
  };

} // lib.optionalAttrs config.allowAliases {
  autodie = null; # part of Perl
  AutoLoader = null; # part of Perl 5.22
  constant = null; # part of Perl 5.22
  DevelSelfStubber = null; # part of Perl 5.22
  Digest = null; # part of Perl 5.22
  Exporter = null; # part of Perl 5.22
  I18NCollate = null; # part of Perl 5.22
  lib_ = null; # part of Perl 5.22
  LocaleMaketextSimple = null; # part of Perl 5.22
  MathComplex = null; # part of Perl 5.22
  MIMEBase64 = null; # part of Perl 5.22
  PerlIOviaQuotedPrint = null; # part of Perl 5.22
  PodEscapes = null; # part of Perl 5.22
  Safe = null; # part of Perl 5.22
  SearchDict = null; # part of Perl 5.22
  Test = null; # part of Perl 5.22
  TextAbbrev = null; # part of Perl 5.22
  TextTabsWrap = null; # part of Perl 5.22
  DigestSHA = null;
  "if" = null;
  TestSimple = null;
  AttributeHandlers = null; # part of Perl 5.26
  base = null; # part of Perl 5.26
  CPANMeta = null; # part of Perl 5.26
  CPANMetaRequirements = null; # part of Perl 5.26
  CPANMetaYAML = null; # part of Perl 5.26
  DigestMD5 = null; # part of Perl 5.26
  LocaleMaketext = null; # part of Perl 5.26
  ModuleLoadConditional = null; # part of Perl 5.26
  ModuleMetadata = null; # part of Perl 5.26
  PerlOSType = null; # part of Perl 5.26
  PodUsage = null; # part of Perl 5.26
  TermANSIColor = null; # part of Perl 5.26
  TermCap = null; # part of Perl 5.26
  ThreadSemaphore = null; # part of Perl 5.26
  UnicodeNormalize = null; # part of Perl 5.26
  XSLoader = null; # part of Perl 5.26

  Carp = null; # part of Perl 5.28
  ExtUtilsCBuilder = null; # part of Perl 5.28
  ExtUtilsParseXS = null; # part of Perl 5.28
  FilterSimple = null; # part of Perl 5.28
  IOSocketIP = null; # part of Perl 5.28
  SelfLoader = null; # part of Perl 5.28
  Socket = null; # part of Perl 5.28
  TestHarness = null; # part of Perl 5.28
  threads = null; # part of Perl 5.28
  TimeHiRes = null; # part of Perl 5.28
  UnicodeCollate = null; # part of Perl 5.28
  ModuleCoreList = null; # part of Perl 5.28.2

  bignum = null; # part of Perl 5.30.3
  DataDumper = null; # part of Perl 5.30.3
  ExtUtilsManifest = null; # part of Perl 5.30.3
  FileTemp = null; # part of Perl 5.30.3
  MathBigRat = null; # part of Perl 5.30.3
  Storable = null; # part of Perl 5.30.3
  threadsshared = null; # part of Perl 5.30.3
  ThreadQueue = null; # part of Perl 5.30.3

  ArchiveZip_1_53 = self.ArchiveZip;
  Autobox = self.autobox;
  CommonSense = self.commonsense; # For backwards compatibility.
  if_ = self."if"; # For backwards compatibility.
  Log4Perl = self.LogLog4perl; # For backwards compatibility.
  MouseXGetOpt = self.MouseXGetopt;
  NamespaceAutoclean = self.namespaceautoclean; # Deprecated.
  NamespaceClean = self.namespaceclean; # Deprecated.
  CatalystPluginUnicodeEncoding = self.CatalystRuntime;
  ClassAccessorFast = self.ClassAccessor;
  ClassMOP = self.Moose;
  CompressZlib = self.IOCompress;
  constantdefer = self.constant-defer;
  DigestHMAC_SHA1 = self.DigestHMAC;
  DistZillaPluginNoTabsTests = self.DistZillaPluginTestNoTabs;
  EmailMIMEModifier = self.EmailMIME;
  ExtUtilsCommand = self.ExtUtilsMakeMaker;
  IOstringy = self.IOStringy;
  libintl_perl = self.libintl-perl;
  libintlperl = self.libintl-perl;
  LWPProtocolconnect = self.LWPProtocolConnect;
  LWPProtocolhttps = self.LWPProtocolHttps;
  LWPUserAgent = self.LWP;
  MIMEtools = self.MIMETools;
  NetLDAP = self.perlldap;
  NetSMTP = self.libnet;
  OLEStorageLight = self.OLEStorage_Lite; # For backwards compatibility. Please use OLEStorage_Lite instead.
  ParseCPANMeta = self.CPANMeta;
  TestMoose = self.Moose;
  TestMore = self.TestSimple;
  TestTester = self.TestSimple;
  Testuseok = self.TestSimple;
  SubExporterUtil = self.SubExporter;
  version = self.Version;

  Gtk2GladeXML = throw "Gtk2GladeXML has been removed"; # 2022-01-15
}; in self
