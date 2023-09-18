/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as much code as the function itself. */

{ config
, stdenv, lib, buildPackages, pkgs, darwin
, fetchurl, fetchpatch, fetchFromGitHub, fetchFromGitLab
, perl, shortenPerlShebang
, nixosTests
}:

self:

# cpan2nix assumes that perl-packages.nix will be used only with perl 5.30.3 or above
assert lib.versionAtLeast perl.version "5.30.3";
let
  inherit (lib) maintainers teams;

in
with self; {

  inherit perl;
  perlPackages = self;

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

  buildPerlPackage = callPackage ../development/perl-modules/generic { };

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


  ack = buildPerlPackage rec {
    pname = "ack";
    version = "3.7.0";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/ack-v${version}.tar.gz";
      hash = "sha256-6nyqFPdX3ggzEO0suimGYd3Mpd7gbsjxgEPqYlp53yA=";
    };

    outputs = ["out" "man"];

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    propagatedBuildInputs = [ FileNext ];
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/ack
    '';

    # tests fails on nixos and hydra because of different purity issues
    doCheck = false;

    meta = {
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
      hash = "sha256-P49dcm+uU3qzNuAKaBmuSoWW5MXyQ+dypTbvLrbmBrE=";
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
      hash = "sha256-o3WXQsW+8tGXWrc9NUmdgRMySRmySTYTAlXP8H0ClPc=";
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
      hash = "sha256-ybF2RkOTPrGjNWkGzDctSDqZQWIHox3z5Y7piS2ZIvk=";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Represent a series of changes in annotate form";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmBackoff = buildPerlPackage {
    pname = "Algorithm-Backoff";
    version = "0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/Algorithm-Backoff-0.009.tar.gz";
      sha256 = "9f0ffcdf1e65a88022d6412f46ad977ede5a7b64be663009d13948fe8c9d180b";
    };
    buildInputs = [ TestException TestNumberDelta ];
    meta = {
      homepage = "https://metacpan.org/release/Algorithm-Backoff";
      description = "Various backoff strategies for retry";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmC3 = buildPerlPackage {
    pname = "Algorithm-C3";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Algorithm-C3-0.11.tar.gz";
      hash = "sha256-qvSEZ3Zd7qbkgFS8fUPkbk1Ay82hZVLGKdN74Jgokwk=";
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
      hash = "sha256-qVbQUXGA1tkEL0fXOqaicot1/L1UaUDS2+Cn589Cj3M=";
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
      hash = "sha256-MOhKxLMdQLZik/exIhMxxaUFYaOdWA2FAE2cH/+ZF1E=";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      description = "Compute 'intelligent' differences between two files / lists";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmLCSS = buildPerlPackage {
    pname = "Algorithm-LCSS";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JF/JFREEMAN/Algorithm-LCSS-0.01.tar.gz";
      hash = "sha256-cXzvzHhCoXGrVXbyLrcuVm7fBhzq+H3Mvn8ggfVgH3g=";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perl extension for getting the Longest Common Sub-Sequence";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  AlgorithmMerge = buildPerlPackage {
    pname = "Algorithm-Merge";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSMITH/Algorithm-Merge-0.08.tar.gz";
      hash = "sha256-nAaIJYodxLg5iAU7n5qY53KM25tppQCNy9JR0PgIFs8=";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Three-way merge and diff";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienBaseModuleBuild = buildPerlModule {
    pname = "Alien-Base-ModuleBuild";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-Base-ModuleBuild-1.15.tar.gz";
      hash = "sha256-E8lDLPQbNMsU3yRUoD5UDivV3J65yCgktq0PTGd5Ov0=";
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
      hash = "sha256-MAC8vphIJkP3a7z/zkL9SPJMY6ZFf4qiwWlfSBrJ7VE=";
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
      hash = "sha256-CQzUjuU1v2LxeIlWF6hReDrhGqTGAGof1NhKQy8RPaU=";
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
      hash = "sha256-D76RarEfaA5cKM0ayAA3IyPioOBq/8bIs2J5/GTXZRc=";
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
      hash = "sha256-c7RSRPC1w25TMsM1abgqGrLDPiY/HQB4XSADvK7GjbM=";
    };
    strictDeps = true;
    nativeBuildInputs = [ pkgs.pkg-config ];
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
      hash = "sha256-w1BSRQfNgn+rhk5dTCzDULG6uqEvqVrsDKAIQ/zH3us=";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Use shorter versions of class names";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  asa = buildPerlPackage {
    pname = "asa";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/asa-1.04.tar.gz";
      hash = "sha256-5YM7dOczuu4Z0e9eBLEmPBz/nBdGmVrXL8QJGPRAZ14=";
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
      hash = "sha256-yaosncPGPYl3PH1yA/KkbRuSTQxy2fgBrxR6Pci8USo=";
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
      hash = "sha256-uWTL2nH79sDqaaTztBUEwUXygWga/hmewrSUQC6/SmU=";
    };

    buildInputs = [ ArchiveExtract ];
    TIDYP_DIR = pkgs.tidyp;
    propagatedBuildInputs = [ FileShareDir ];
    meta = {
      description = "Building, finding and using tidyp library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlienWxWidgets = buildPerlModule {
    pname = "Alien-wxWidgets";
    version = "0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/Alien-wxWidgets-0.69.tar.gz";
      hash = "sha256-UyJOS7vv/0z3tj7ZpiljiTuf/Ull1w2WcQNI+Gdt4kk=";
    };
    postPatch = ''
      substituteInPlace Build.PL \
        --replace "gtk+-2.0" "gtk+-3.0"
    '';
    propagatedBuildInputs = [ pkgs.pkg-config pkgs.gtk3 pkgs.wxGTK32 ModulePluggable ];
    buildInputs = [ LWPProtocolHttps ];
    meta = {
      description = "Building, finding and using wxWidgets binaries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Alienm4 = buildPerlPackage {
    pname = "Alien-m4";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Alien-m4-0.19.tar.gz";
      hash = "sha256-SdvvZKGoDGtKc3T85ovix+6eZdHA3/Uxw5u1lBRG0PY=";
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
      hash = "sha256-/tZyJbLZamZpL30vQ+DTRykhRSnbHWsTsNykYgquANA=";
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
      hash = "sha256-dvQ0yrNpmc3wmBE0W7Oda3y+1+CFsCM4Mox/RuCLOPM=";
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
      hash = "sha256-UL7qaJwJj+Sq64OAbEC5/n+UbVdprPmfhJ8JkJGkuYU=";
    };
    buildInputs = [ CanaryStability ];
    meta = {
      description = "The DBI of event loop programming";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventAIO = buildPerlPackage {
    pname ="AnyEvent-AIO";
    version = "1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-AIO-1.1.tar.gz";
      hash = "sha256-axBbjGQVYWMfUz7DQj6AZ6PX1YBDv4Xw9eCdcGkFcGs=";
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
      hash = "sha256-k+NgEJQEZGJuXzG5+u3WXhLtjRq/Fs4FL+vyP0la78g=";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ BDB AnyEvent ];
    meta = {
      description = "Truly asynchronous berkeley db access";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventCacheDNS = buildPerlModule {
    pname = "AnyEvent-CacheDNS";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/AnyEvent-CacheDNS-0.08.tar.gz";
      hash = "sha256-QcH68YO2GAa1WInO6hI3dQwfYbnOJzX98z3AVTZxLa4=";
    };
    propagatedBuildInputs = [ AnyEvent ];
    doCheck = false; # does an DNS lookup
    meta = {
      description = "Simple DNS resolver with caching";
      homepage = "https://github.com/potyl/perl-AnyEvent-CacheDNS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventFastPing = buildPerlPackage {
    pname = "AnyEvent-FastPing";
    version = "2.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-FastPing-2.1.tar.gz";
      hash = "sha256-5ZIbj3rTXJg6ACWuAKSPyVyQwX/uw+WFmBhwSwxScCw=";
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
      hash = "sha256-XPpTQWEkF29vTNMrAOqMp5otXfUSWGg5ic0E/obiUBM=";
    };
    propagatedBuildInputs = [ AnyEvent commonsense ];
    meta = {
      description = "Simple but non-blocking HTTP/HTTPS client";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventI3 = buildPerlPackage {
    pname = "AnyEvent-I3";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/AnyEvent-I3-0.17.tar.gz";
      hash = "sha256-U4LJhMnxODlfKfDACvgaoMj0t2VYIFXHPt5LE/BKbWM=";
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
      hash = "sha256-v9fPZFw8jGEUcQVxKGEUR+IPGt8BUWxpYky9i8d/W/A=";
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
      hash = "sha256-mMUqH+cAcQ8+W8VaOLJd5iXpsug0HSeNz54bPz0ZrO4=";
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
      hash = "sha256-qKY+N/qALoJYvpmYORbN5FElgdyAYt5Q5z1mr24thTU=";
    };
    propagatedBuildInputs = [ Moose Mouse ];
    meta = {
      description = "(DEPRECATED) use Moo instead!";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyURIEscape = buildPerlPackage {
    pname = "Any-URI-Escape";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/Any-URI-Escape-0.01.tar.gz";
      hash = "sha256-44E87J8Qj6XAvmbgjBmGv7pNJCFRsPn07F4MXhcQjEw=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Load URI::Escape::XS preferentially over URI::Escape";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIEscapeXS = buildPerlPackage {
    pname = "URI-Escape-XS";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/URI-Escape-XS-0.14.tar.gz";
      hash = "sha256-w5rFDGwrgxrkvwhpLmyl1KP5xX3E1/nEywZj4shsJ1k=";
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
      hash = "sha256-H3G5TT1VqVCksy2uTpD252yBV1CKfiruUGIbF5qtsfs=";
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
      hash = "sha256-ZSf08VmCcL6ge+x4e3G98OwrVyVIvnQ4z3TyuaYAv+0=";
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
      hash = "sha256-lFCVA+506oIBg9BwwRYw7lvA/YwSy3T66VPtYuShrBc=";
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
      hash = "sha256-/mm3aJmv6QuK5bgt4qqnV1rakIk39EhbgKrvMXVj6Z8=";
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
      hash = "sha256-BoHwfX2KlCnQ7fioxa1qZVvn/oGtoUJnCyuOd2s7s+s=";
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
      hash = "sha256-UdP1gzq1GftG5VUrYOVFXk+cHGgn0e7kFT0LQJ8qk0U=";
    };
    propagatedBuildInputs = [ CaptureTiny ClassLoad ];
    buildInputs = [ TestKwalitee TestPod ];
    meta = {
      description = "Dispatcher module for command line interface programs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AppClusterSSH = buildPerlModule {
    pname = "App-ClusterSSH";
    version = "4.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DU/DUNCS/App-ClusterSSH-4.16.tar.gz";
      hash = "sha256-G3y4q2BoViRK34vZrE0nUHwuQWh7OvGiJs4dsvP9VXg=";
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
      homepage = "https://github.com/duncs/clusterssh/wiki";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cssh";
    };
  };

  AppCmd = buildPerlPackage {
    pname = "App-Cmd";
    version = "0.331";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/App-Cmd-0.331.tar.gz";
      hash = "sha256-Sl098ABr0niIDQH0lXqqZSqPkf6PZuk633D7oMPstoA=";
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
      hash = "sha256-EXcCcCXssJ7mTZ+fJVYVwE214U91NsNEr2MgMuuIew8=";
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
      hash = "sha256-Ep2zbchFZhpYIoaBDP4tUhbrLOCCutQK4fzc4PRd7M8=";
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
      hash = "sha256-rE5K3CP+wKtU8IispRH1pX2V5sl6EqHLmO7R/g/g6Zw=";
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
      hash = "sha256-YyECxuZ958nP9R1vqg2dA7/vvtNbXMXZaRn3uSAlAck=";
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
      hash = "sha256-iiSlTkuhclGss88IO2drzqCYsClF9iMsV4nQd3ImxHg=";
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
    version = "6.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/App-Music-ChordPro-6.010.tar.gz";
      hash = "sha256-SqTkbR2bWIMcU5gSRf2WW6s1ckHtJVPkxj/bBO9X4kM=";
    };
    buildInputs = [ PodParser ];
    propagatedBuildInputs = [ AppPackager FileLoadLines FileHomeDir IOString ImageInfo PDFAPI2 StringInterpolateNamed TextLayout ]
      ++ lib.optionals (!stdenv.isDarwin) [ Wx ];
    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;

    # Delete tests that fail when version env var is set, see
    # https://github.com/ChordPro/chordpro/issues/293
    patchPhase = ''
      rm t/320_subst.t t/321_subst.t t/322_subst.t
    '';

    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/chordpro
      rm $out/bin/wxchordpro # Wx not supported on darwin
    '';
    meta = {
      description = "A lyrics and chords formatting program";
      homepage = "https://www.chordpro.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "chordpro";
    };
  };

  AppPackager =  buildPerlPackage {
    pname = "App-Packager";
    version = "1.430.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/App-Packager-1.430.1.tar.gz";
      hash = "sha256-V/TQFEWDh/ni7S39hhXR4lRbimUEsQryJIZXjYvjdKM=";
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
      hash = "sha256-D/pYdfYMe0L3yDK5Qtyaq+L8KHYXEjvd6bj8rW31eQI=";
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
      hash = "sha256-FcGIJTmTpLZuVZnweJsTJvCmbAkr2/rJMTcG1BwoUXA=";
    };
    propagatedBuildInputs = [ ArchiveZip ];
    buildInputs = [ ExtUtilsMakeMakerCPANfile TestUseAllModules ];
    meta = {
      description = "Simple CPAN package extractor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AppSqitch = buildPerlModule {
    version = "1.3.1";
    pname = "App-Sqitch";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/App-Sqitch-v1.3.1.tar.gz";
      hash = "sha256-9edo0pjNQEfuKuQjGXgujCzaMSc3vL2/r1gL1H7+i5Q=";
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
      hash = "sha256-wCoW9n5MNXaQpUODGYQxSf1wDCIxKPn/6+yrKEnFi7g=";
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
      hash = "sha256-WGuTnO/9s3GIt8Rh3RqPnzVpUYTIcDsFw19tUIyAkPU=";
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
      hash = "sha256-ROMQ9pnresGYGNunIh7ohCoecESLdFWMUSaWKy7ZU9w=";
    };

    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ Moo TypeTiny ];
    meta = {
      description = "Perl extension for comparing arrays";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArrayDiff = buildPerlPackage {
    pname = "Array-Diff";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Array-Diff-0.09.tar.gz";
      hash = "sha256-gAY5Lphh50FTfCu8kRbI5CuWLy4H6NZBov9qEcZEUHc=";
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
      hash = "sha256-virrX1qa8alvADNQilacqTrRmtFdx8a5mObXvHQMZvc=";
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
      hash = "sha256-U7iAo67AQ+TjcM4SaCtHVt5F3XQtq1cpT+IaFUU87+M=";
    };
    meta = {
      description = "Set up array elements as aliases";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ArrayUtils = buildPerlPackage {
    pname = "ArrayUtils";
    version = "0.5";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/Z/ZM/ZMIJ/Array/Array-Utils-0.5.tar.gz";
      hash = "sha256-id0bf82bQ3lJKjp3SW45/mzTebdz/QOmsWDdJu3mN3A=";
    };
    meta = {
      description = "Small utils for array manipulation";
      homepage = "https://metacpan.org/pod/Array::Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AsyncPing = buildPerlPackage {
    pname = "AsyncPing";
    version = "2016.1207";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XI/XINFWANG/AsyncPing-2016.1207.tar.gz";
      hash = "sha256-b76a/sF6d3B2+K2JksjSMAr2WpUDRD0dT/nD+NKZyVo=";
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
      hash = "sha256-JG+zFml2TngzayGRE0Ei4HxE8tgtxPN9VSqyj4ZovtM=";
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
      hash = "sha256-ms0JzbjozwttCCEKO4A0IwDImjWYVTGb9rAMFMSqtoc=";
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
      hash = "sha256-xeSPU1FCiBhYMM7ZO/Phb731zdzpfe0dHYqbCiHqKHs=";
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
      hash = "sha256-GfPQ2qi5XP+2jHBDUN0GdKI+HS8U0DKQO36WCe23s3o=";
    };
    propagatedBuildInputs = [ FileWhich IPCRun LogLog4perl ];
    meta = {
      description = "API wrapper around the 'tar' utility";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  ArchiveZip = buildPerlPackage {
    pname = "Archive-Zip";
    version = "1.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz";
      hash = "sha256-mE4YXXhbr2EpxudfjrREEXRawAv2Ei+xyOgio4YexlA=";
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
      hash = "sha256-Uw1Z7wwJNfmGLRhxh6LXWDsSxjm7Z9sU+YMyKxYYktk=";
    };
    meta = {
      description = "Object-oriented interface to FITS HDUs";
      homepage = "https://github.com/timj/perl-Astro-FITS-Header";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  AudioFLACHeader = buildPerlPackage {
    pname = "Audio-FLAC-Header";
    version = "2.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANIEL/Audio-FLAC-Header-2.4.tar.gz";
      hash = "sha256-+6WRHWwi2BUGVlzZoUOOhgVCD/eYbPA9GhLQBqQHBUM=";
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
      hash = "sha256-gxJyAnHHrdxLvuwzEs3divS5kKxjYgSllsB5M61sY0o=";
    };
    buildInputs = [ pkgs.zlib TestWarn ];
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.zlib.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.zlib.out}/lib -lz";
    meta = {
      description = "Fast C metadata and tag reader for all common audio file formats";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  AuthenDecHpwd = buildPerlModule {
    pname = "Authen-DecHpwd";
    version = "2.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Authen-DecHpwd-2.007.tar.gz";
      hash = "sha256-9DqTuwK0H3Mn2S+eljtpUF9nNQpS6PUHlvmK/E+z8Xc=";
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
      hash = "sha256-tfr0fj+UikUoEGzLiMxxBIz+WY5bAmpEQ2i8fjk0gGc=";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
    # Remove test files that fail after DES support was removed from crypt()
    postPatch = ''
      rm t/04core.t t/05edit.t
    '';
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
      hash = "sha256-13sAuxUBpW9xGOkarAx+Qi2888QY+c6YuAF3HDqg900=";
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
      hash = "sha256-XdScrNmD79YajD8aVlcbtzeF6xVZCLXXvsl+7XjfDFQ=";
    };
    propagatedBuildInputs = [ pkgs.krb5.dev AuthenKrb5 ];
    # The following ENV variables are required by Makefile.PL to find
    # programs in krb5.dev. It is not enough to just specify the
    # path to krb5-config as this tool returns the prefix of krb5,
    # which implies a working value for KRB5_LIBDIR, but not the others.
    perlPreHook = ''
      export KRB5_CONFTOOL=${pkgs.krb5.dev}/bin/krb5-config
      export KRB5_BINDIR=${pkgs.krb5.dev}/bin
      export KRB5_INCDIR=${pkgs.krb5.dev}/include
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
      hash = "sha256-eZbhpCxRIWADzPA8S1JQKGtMVWhCV5cYUfXs6RYdx90=";
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
      hash = "sha256-GoE9vcBcP72d0528/YXiz7C6PQ9lLPaybsg6uBRt3Hc=";
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
      hash = "sha256-VdtFIGF9hZ2IwO5Ull2oFbcibXkrjNyN6/kgc1WeBGM=";
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
      hash = "sha256-eyCPmDfIOhhCZyVIklNlh+7Qvd5J577euj1ypmUjF0A=";
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
      hash = "sha256-ZhT6dRjwlPhTdBtjxz82JxaMXTrKibHQKxAW3DKFTgk=";
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
      hash = "sha256-pMzMNLs/U6zwunjJ/GGvjRVtEJ0cEEh7pZiKVQd9H3A=";
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
      hash = "sha256-RRCMI5pzc9AJQdzw0XGs0D58FqY85vfZVo/wUrF89ag=";
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
      hash = "sha256-As3atH+L8aHL1Mm/jSWPbQURFJnDP4MV5yRIEvcmE6o=";
    };
    # Our C crypt() doesn't support this weak "crypt" algorithm anymore.
    postPatch = ''
      patch -p1 <<-EOF
        --- a/t/09password.t
        +++ b/t/09password.t
        @@ -10 +10 @@
        -use Test::More tests => 16;
        +use Test::More tests => 14;
        @@ -14 +13,0 @@
        -    [ 'crypt',     'lk9Mh5KHGjAaM',                          'crypt'        ],
        @@ -18 +16,0 @@
        -    [ 'crypt',     '{CRYPT}lk9Mh5KHGjAaM',                   '{CRYPT}'      ],
      EOF
    '';
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
      hash = "sha256-z1W8NiWe3w/Wr5rSusgbMdxbVqFixmBZDsuWnHwWdLI=";
    };
    # Our C crypt() doesn't support this weak "crypt" algorithm anymore.
    postPatch = ''
      sed -e 's/tests => 8/tests => 7/' -e "/'crypt'/d" -i t/04basic.t
    '';
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
      hash = "sha256-wwO3/M+qH/TUxCmrPxXlyip3VU74yfw7jGK6hZ6HTJg=";
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
      hash = "sha256-rIElyIq+Odn+Aco6zBOgCinzM2pLt+9gRH5ri4Iv9CI=";
    };
    propagatedBuildInputs = [ TemplateToolkit XMLSimple ];
    buildInputs = [ DBI ];

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
      hash = "sha256-ILvBbLNFT+XozzT+YfGpH+JsPxfkSf9mX8u7kqtEPr0=";
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
      hash = "sha256-LZmXVoUkKYDQqZBPY5FEwFnW7OFYme/eSst0LTJT8QU=";
    };
    meta = {
      description = "Lexically disable autovivification";
      homepage = "https://search.cpan.org/dist/autovivification";
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
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  BC = buildPerlPackage {
    pname = "B-C";
    version = "1.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/B-C-1.57.tar.gz";
      hash = "sha256-BFKmEdNDrfnZX86ra6a2YXbjrX/MzlKAkiwOQx9RSf8=";
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
      hash = "sha256-/K+3de2EpFvCwGxf/XE0LLPAb7C9zVwbUbDBL4tYX1E=";
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
      hash = "sha256-wduX0BMVvtEJtMSJWM0yGVz8nvXTt3B+tHhAwdV8ELI=";
    };
    meta = {
      description = "Friendlier flags for B";
      license = with lib.licenses; [ artistic1 gpl1Only ];
    };
  };

  BeanstalkClient = buildPerlPackage {
    pname = "Beanstalk-Client";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/Beanstalk-Client-1.07.tar.gz";
      hash = "sha256-MYirESfyyrqX32XIT2nbDscMZOXXDylvmiZ0+nnBEsw=";
    };
    propagatedBuildInputs = [ ClassAccessor YAMLSyck ];
    meta = {
      description = "Client to communicate with beanstalkd server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BerkeleyDB = buildPerlPackage {
    pname = "BerkeleyDB";
    version = "0.65";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/BerkeleyDB-0.65.tar.gz";
      hash = "sha256-QQqonnIylB1JEGyeBI1jN0dVQ+wdIz6nzbcly1uWNQQ=i";
    };

    preConfigure = ''
      echo "LIB = ${pkgs.db.out}/lib" > config.in
      echo "INCLUDE = ${pkgs.db.dev}/include" >> config.in
    '';
    meta = {
      description = "Perl extension for Berkeley DB version 2, 3, 4, 5 or 6";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BDB = buildPerlPackage rec {
    pname = "BDB";
    version = "1.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${pname}-${version}.tar.gz";
      hash = "sha256-o/LKnSuu/BqqQJCLL5y5KS/aPn15fji7146rudna62s=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.db4.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.db4.out}/lib -ldb";
    buildInputs = [ pkgs.db4 ];
    propagatedBuildInputs = [ commonsense ];
    meta = {
      description = "Asynchronous Berkeley DB access";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksEndOfScope = buildPerlPackage {
    pname = "B-Hooks-EndOfScope";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.24.tar.gz";
      hash = "sha256-A6o9/l0KpkcalvQ/6DGBedGXlNSmQHCPAoj5IW7HrMY=";
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
      hash = "sha256-bib5k2f06pRBac9uBc9NBngyCCQkyo7O/Mt7WmMhexY=";
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
      hash = "sha256-x7XRvvWe+Qh/9n6zFo0mJL6UrlRkRp4lmtEb+4rYzc0=";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Wrap OP check callbacks";
      homepage = "https://github.com/karenetheridge/B-Hooks-OP-Check";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BioExtAlign = callPackage ../development/perl-modules/Bio-Ext-Align { };

  BioDBHTS = buildPerlModule {
    pname = "Bio-DB-HTS";
    version = "3.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVULLO/Bio-DB-HTS-3.01.tar.gz";
      sha256 = "12a6bc1f579513cac8b9167cce4e363655cc8eba26b7d9fe1170dfe95e044f42";
    };

    buildInputs = [ pkgs.htslib pkgs.zlib ];

    propagatedBuildInputs = [ BioPerl ];
    htslibStore = toString pkgs.htslib;

    postPatch = ''
      # -Wl,-rpath not recognized : replaced by -rpath=
      sed -i 's/Wl,-rpath,/rpath=/' Build.PL
    '';

    preBuild = ''
      export HTSLIB_DIR=${pkgs.htslib}
    '';

    meta = {
      description = "Perl interface to HTS library for DNA sequencing";
      license = lib.licenses.asl20;
    };
  };

  BioPerl = buildPerlPackage {
    pname = "BioPerl";
    version = "1.7.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz";
      hash = "sha256-xJCjvncV6m5DBe/ZcQ5e2rgtq8Vf14a2UFtVCjDXFzg=";
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
      hash = "sha256-PG2qZx/s+8Nfkqk4W1Y9ZfUN/Gvci0gF+e9GwNA1qSY=";
    };
    propagatedBuildInputs = [ CarpClan ];
    meta = {
      description = "Efficient bit vector, set of integers and 'big int' math library";
      license = with lib.licenses; [ artistic1 gpl1Plus lgpl2Only ];
    };
  };

  BKeywords = buildPerlPackage rec {
    pname = "B-Keywords";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/B-Keywords-1.26.tar.gz";
      hash = "sha256-LaoVXS8mf7De3Yf4pMT7VmOHn8EGUXse4lg1Pvh67TQ=";
    };
    meta = {
      description = "Lists of reserved barewords and symbol names";
      license = with lib.licenses; [ artistic1 gpl2Only ];
    };
  };

  boolean = buildPerlPackage {
    pname = "boolean";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/boolean-0.46.tar.gz";
      hash = "sha256-lcCICFw+g79oD+bOFtgmTsJjEEkPfRaA5BbqehGPFWo=";
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
      hash = "sha256-AFTdP1c70/b0e3PugdHoRYQvugSq21KICqUnAcaH0co=";
    };
    patches = [
      # Fix out of memory error on Perl 5.19.4 and later.
      ../development/perl-modules/boost-geometry-utils-fix-oom.patch
    ];
    perlPreHook = "export LD=$CC";
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp ];
    meta = {
      description = "Bindings for the Boost Geometry library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BotTraining = buildPerlPackage {
    pname = "Bot-Training";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-0.07.tar.gz";
      hash = "sha256-7ma7+BTw3D0egGgOBQ+tELHgGP7Xkp9lPtQOCIsqopU=";
    };
    buildInputs = [ FileSlurp ];
    propagatedBuildInputs = [ ClassLoad DirSelf FileShareDir ModulePluggable MooseXGetopt namespaceclean  ];
    meta = {
      description = "Plain text training material for bots like Hailo and AI::MegaHAL";
      homepage = "https://metacpan.org/release/Bot-Training";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "bot-training";
    };
  };

  BotTrainingMegaHAL = buildPerlPackage {
    pname = "Bot-Training-MegaHAL";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-MegaHAL-0.03.tar.gz";
      hash = "sha256-lWByr/BPIW5cO4GWlltdgNTUdpXXfsqr1W5Z1l8iv2A=";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ BotTraining ];
    meta = {
      description = "Provide megahal.trn via Bot::Training";
      homepage = "https://metacpan.org/release/Bot-Training-MegaHAL";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BotTrainingStarCraft = buildPerlPackage {
    pname = "Bot-Training-StarCraft";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Bot-Training-StarCraft-0.03.tar.gz";
      hash = "sha256-58640Bxi5zLdib/l9Ng+eBwc2RJULRd8Iudht8hhTV4=";
    };
    buildInputs = [ FileShareDirInstall ];
    propagatedBuildInputs = [ BotTraining ];
    meta = {
      description = "Provide starcraft.trn via Bot::Training";
      homepage = "https://metacpan.org/release/Bot-Training-StarCraft";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BSDResource = buildPerlPackage {
    pname = "BSD-Resource";
    version = "1.2911";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/BSD-Resource-1.2911.tar.gz";
      hash = "sha256-nRz7oGPMGPckJ6IkUfeQiDa3MxrIeF2+B1U8WwQ6DD0=";
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
      hash = "sha256-9GEsDDVDEHQbmattJkUSJoIxUMonEJsbORIy1c/dpts=";
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
      hash = "sha256-KPfTOP14tvnJpggL6d4/XLI9iIuW6/b8v6zp8pZq6/k=";
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
      hash = "sha256-+X9T9qMFAQmqQU/usYTK0QGBLUF2DpUrXYSZP2aF/+o=";
    };
    propagatedBuildInputs = [ TaskWeaken ];
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Helper functions for op tree manipulation";
      homepage = "https://search.cpan.org/dist/B-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessHours = buildPerlPackage {
    pname = "Business-Hours";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Business-Hours-0.13.tar.gz";
      hash = "sha256-qAf+P/u4T/pTlnEazOdXZPOknyQjZGc1DHHIp3pcPsI=";
    };
    propagatedBuildInputs = [ SetIntSpan ];
    meta = {
      description = "Calculate business hours in a time period";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISBN = buildPerlPackage {
    pname = "Business-ISBN";
    version = "3.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-3.005.tar.gz";
      hash = "sha256-ZTD7rkDFY3bbTmaGw0r42j21xLqtDRBAR7HvPiT+Lio=";
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
      hash = "sha256-hExPZPGT04k0C0RlodW8NMYPDI5C5caayK/j07vFyg0=";
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
      hash = "sha256-SjIxoWRWv4y/F/JrZSQ/JHB4tRRdmgOqdYa68JV37LI=";
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
      hash = "sha256-l+yrFdJNEeKFK/Cyj4TIeYvThAKgpp4Xvg5mibJycV4=";
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
      hash = "sha256-U7vTOeahHvygfGGaYVx8GIpouyvoSaHLfvw91Nmuha4=";
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
      hash = "sha256-A9lntfgoRpCRN9WrmYSsVwrBCkQB4MYC89IgjEZayYI=";
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
      hash = "sha256-0sf9Xbpd0BC32JI1FokLtsz2tfGIzLafNcsP1sAx0eg=";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
    doCheck = false; # randomly fails
    meta = {
      description = "The Cache Interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheFastMmap = buildPerlPackage {
    pname = "Cache-FastMmap";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.54.tar.gz";
      hash = "sha256-NULiALmAJ3rkVqvjbgyp+bjyvya7FVivJOFAgUrWeVI=";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Uses an mmap'ed file to act as a shared memory interprocess cache";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheKyotoTycoon = buildPerlModule {
    pname = "Cache-KyotoTycoon";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Cache-KyotoTycoon-0.16.tar.gz";
      hash = "sha256-zLBII1iUxItpegDleMtFC05evBQYpVSnz6hjJwezlHw=";
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
      hash = "sha256-MbPFHsDqrwMALizI49fVy+YZGc/a2mHACOuYU6ysQqk=";
    };
    propagatedBuildInputs = [ StringCRC32 ];
    meta = {
      description = "Client library for memcached (memory cache daemon)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheMemcachedFast = buildPerlPackage {
    pname = "Cache-Memcached-Fast";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RA/RAZ/Cache-Memcached-Fast-0.26.tar.gz";
      hash = "sha256-Xo5G2SLMpuTzhRMsLLLHHu9/S171j702o5n5Fp3qoJo=";
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
      hash = "sha256-4dLYlneYEWarxbtuXsxkcfAB8T61bVvpVE2AR9wIpZI=";
    };
    propagatedBuildInputs = [ DBFile FileNFSLock HeapFibonacci IOString TimeDate ];
    doCheck = false; # can time out
    meta = {
      description = "Memory based implementation of the Cache interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheSimpleTimedExpiry = buildPerlPackage {
    pname = "Cache-Simple-TimedExpiry";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Cache-Simple-TimedExpiry-0.27.tar.gz";
      hash = "sha256-Tni35N0jG1VxpIzQ7htjlT9eNHkMnQIOFZWnx9Crvkk=";
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
      hash = "sha256-YELLfcUWdasjQ3BZxjhHE8X7vOhExMYAF9LgYZSPBdo=";
    };
    buildInputs = [ pkgs.cairo ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
    meta = {
      description = "Perl interface to the cairo 2d vector graphics library";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  CairoGObject = buildPerlPackage {
    pname = "Cairo-GObject";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Cairo-GObject-1.005.tar.gz";
      hash = "sha256-jYlkRNceHQvKPSTjHl2CvQ2VQqrtkdH7fqs2e85nXFA=";
    };
    buildInputs = [ pkgs.cairo ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      description = "Integrate Cairo into the Glib type system";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  CallContext = buildPerlPackage {
    pname = "Call-Context";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Call-Context-0.03.tar.gz";
      hash = "sha256-Dua/RrxydVrbemsI550S4gfeX3gJcHs8NTtYyy8LWiY=";
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
      hash = "sha256-52r8fzimJJJKd8XJiMNsnjiL+ncW51zTl/744bQuu4k=";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
    meta = {
      description = "PDF manipulation library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  capitalization = buildPerlPackage {
    pname = "capitalization";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/capitalization-0.03.tar.gz";
      hash = "sha256-8TUW1XKUH2ihwj8uDkn1vwmyL5B+uSkrcrr/5ie77jw=";
    };
    propagatedBuildInputs = [ DevelSymdump ];
    meta = {
      description = "No capitalization on method names";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CanaryStability = buildPerlPackage {
    pname = "Canary-Stability";
    version = "2013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz";
      hash = "sha256-pckcYs+V/Lho9g6rXIMpCPaQUiEBP+orzj/1cEbXtuo=";
    };
    meta = {
      description = "Canary to check perl compatibility for schmorp's modules";
      license = with lib.licenses; [ gpl1Plus ];
    };
  };

  CaptchaReCAPTCHA = buildPerlPackage {
    pname = "Captcha-reCaptcha";
    version = "0.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SUNNYP/Captcha-reCaptcha-0.99.tar.gz";
      hash = "sha256-uJI1dmARZu3j9/Ly/1X/bjw7znDmnzZaUe076MykQ5I=";
    };
    propagatedBuildInputs = [ HTMLTiny LWP ];
    meta = {
      description = "A Perl implementation of the reCAPTCHA API";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CaptureTiny = buildPerlPackage {
    pname = "Capture-Tiny";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
      hash = "sha256-bCMRPoe605MwjJCiBwE+UF9lknRzZjjYx5usnGfMPhk=";
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
      hash = "sha256-mKoRSSFxwBb7CCdYGrH6XtAbHpnGNXSJ3fOoJzFYZvE=";
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
      hash = "sha256-kk+OK048s9iyYka1+cB82qS4gAzvNF+ggR1ykw1zpU4=";
    };
    meta = {
      description = "Executable comments";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAssertMore = buildPerlPackage {
    pname = "Carp-Assert-More";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-1.24.tar.gz";
      hash = "sha256-ulzBZichfdu/tbGk9rGEv500LvuBSNkdo0SfCwN1sis=";
    };
    propagatedBuildInputs = [ CarpAssert ];
    buildInputs = [ TestException ];
    meta = {
      description = "Convenience assertions for common situations";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  CarpClan = buildPerlPackage {
    pname = "Carp-Clan";
    version = "6.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Carp-Clan-6.08.tar.gz";
      hash = "sha256-x1+S40QizFplqwXRVYQrcBRSQ06a77ZJ1uIonEfvZwg=";
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
      hash = "sha256-d9QrknMrz8GKWdNB5WzkdiBbHE04Dqs6ByJPV0XCPkU=";
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
      hash = "sha256-hWUgOVCgV9Q+zWTpWTcV1WXC+9iwLJH0PFOyERrNOUg=";
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
      hash = "sha256-zPgbulIA06CtaQH5I68XOj1EFmGK6gimk4uq/970yyA=";
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
      hash = "sha256-b6GBbe5kSw216gzBXF5xHcLO0gg2JavOcJZSHx1lpSk=";
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
      hash = "sha256-x/2FYnXo3hjAAWHXNJTsZr0N3QoZ27dMQtVXHJ7ggE8=";
    };
    buildInputs = [ ModuleBuildTiny TestLongString TestSimple13 TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ AuthenHtpasswd CatalystPluginAuthentication ];
    patches = [
      ../development/perl-modules/CatalystAuthenticationStoreHtpasswd-test-replace-DES-hash-with-bcrypt.patch
    ];
    meta = {
      description = "Authen::Htpasswd based user storage/authentication";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    pname = "Catalyst-Authentication-Store-DBIx-Class";
    version = "0.1506";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-DBIx-Class-0.1506.tar.gz";
      hash = "sha256-fFefJZUoXmTD3LVUAzSqmgAkQ+HUyMg6tEk7kMxRskQ=";
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
      hash = "sha256-CFeBKmF83Y1FcdDZonm1hmEy9dhFBv0kK8Bh3HdKozI=";
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
      hash = "sha256-f2P5MOHmE/FZVcnm1zhzZ1xQwKO8KmGgNHMzYe0m0nE=";
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
      hash = "sha256-8T+5s7OwCzXwarwxYURhyNc0b74H+1accejVhuXrXdw=";
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
      hash = "sha256-7ipLs+14uqFGQzVAjyhDRba6DvZXate/vXtlbHiKOfk=";
    };
    buildInputs = [ ModuleInstall TestLongString TestWWWMechanize TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystPluginStaticSimple ClassAccessor FileSlurp JSONXS ListMoreUtils PodPOMViewTOC XMLSimple ];
    meta = {
      description = "Serves PODs right from your Catalyst application";
      homepage = "https://search.cpan.org/dist/Catalyst-Controller-POD";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  CatalystDevel = buildPerlPackage {
    pname = "Catalyst-Devel";
    version = "1.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Devel-1.42.tar.gz";
      hash = "sha256-fsbwtsq1uMCX5Hdp/HOk1MAVpYxB/bQPwk3z7nfEir0=";
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
      hash = "sha256-AC3Pnv7HxYiSoYP5CAFTnQzxPsOvzPjTrRkhfCsNWBo=";
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
      hash = "sha256-s54zllkDwAWD4BgOPdUopUkg9SB83wUmBcoTgoz6wTw=";
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
      hash = "sha256-JqkR7173/8gbbOZcMVb3H7NQg8RWrSfm2C0twCST7uo=";
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
      hash = "sha256-pt87Da9fZsW0NxDDvyLjSL6LBTdf8dloYIfm9pRiYPk=";
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
      hash = "sha256-hz245OcqmU4+F661PSuDfm1SS0uLDzU58mITXIjMISA=";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime ];
    meta = {
      description = "Request logging from within Catalyst";
      homepage = "https://metacpan.org/release/Catalyst-Plugin-AccessLog";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthentication = buildPerlPackage {
    pname = "Catalyst-Plugin-Authentication";
    version = "0.10023";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authentication-0.10023.tar.gz";
      hash = "sha256-NgOaq9rLB+Zoek16i/rHj+nQ+7BM2o1tlm1sHjJZ0Gw=";
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
      hash = "sha256-KjfmU0gu/SyTuGxqg4lB4FbF+U3YbA8LiT1RkzMSg3w=";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassThrowable ];
    buildInputs = [ CatalystPluginAuthentication CatalystPluginAuthorizationRoles CatalystPluginSession CatalystPluginSessionStateCookie TestWWWMechanizeCatalyst ];
    meta = {
      description = "ACL support for Catalyst applications";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthorizationRoles = buildPerlPackage {
    pname = "Catalyst-Plugin-Authorization-Roles";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authorization-Roles-0.09.tar.gz";
      hash = "sha256-7kBE5eKg2UxOxRL61V7gyN4UTh47h4Ugf5YCXPmkA1E=";
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
      hash = "sha256-KV/tRJyTJLBleP1GjjOR4E+/ZK0kN2oARAjRvG9UQ+A=";
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
      hash = "sha256-aq2nDrKfYd90xTj5KaEHD92TIMW278lNJkwzghe8sWw=";
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
      hash = "sha256-Sj1ccgBiTT567ULQWnBnSSdGg+t7rSYN6Sx1W/aQnlI=";
    };
    propagatedBuildInputs = [ CatalystPluginSession GDSecurityImage ];
    meta = {
      description = "Create and validate Captcha for Catalyst";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage {
    pname = "Catalyst-Plugin-ConfigLoader";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-Plugin-ConfigLoader-0.35.tar.gz";
      hash = "sha256-nippim8tBG4NxeV1EpKc1CPIB9Sja6Pynp5a3NcaGXE=";
    };
    propagatedBuildInputs = [ CatalystRuntime ConfigAny DataVisitor ];
    meta = {
      description = "Load config files of various types";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginFormValidator = buildPerlPackage {
    pname = "Catalyst-Plugin-FormValidator";
    version = "0.094";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DH/DHOSS/Catalyst-Plugin-FormValidator-0.094.tar.gz";
      hash = "sha256-WDTxG/XJ9LXTNtZcfOZjm3bOe/56KHXrBI1+ocgs4Fo=";
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
      hash = "sha256-SGxqDo9BD9AXJ59IBKueNbpGMh0zoKlyH+Hgijkd56A=";
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
      hash = "sha256-DbPDpXtO49eJulEpiQ4oWJE/7wDYGFvcnF1/3jHgQ+8=";
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
      hash = "sha256-Kzm5l7q/+rNTquMsol8smbdljlBEew23H7gKFsS2osE=";
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
      hash = "sha256-hWEKF8ofQOuZ3b615TRi8ebVaOiv2Z1Pl1uwf1IKhSg=";
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
      hash = "sha256-dwfFZzTNsVEvcz3EAPrfb0xTyyF7WCB4V4JNrWeAoHk=";
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
      hash = "sha256-6bHHsrlsGU+Hpfd+FElxcHfHD/xnpL/CnwJsnuLge+o=";
    };
    propagatedBuildInputs = [ CatalystPluginSession ];
    meta = {
      description = "Maintain session IDs using cookies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-Store-FastMmap";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Session-Store-FastMmap-0.16.tar.gz";
      hash = "sha256-uut/17+QW+dGMciHYP2KKYDO6pVieZM5lYFkPvY3cnQ=";
    };
    propagatedBuildInputs = [ CacheFastMmap CatalystPluginSession ];
    meta = {
      description = "FastMmap session storage backend";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionStoreFile = buildPerlPackage {
    pname = "Catalyst-Plugin-Session-Store-File";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Catalyst-Plugin-Session-Store-File-0.18.tar.gz";
      hash = "sha256-VHOOPOdvi+i2aUcJLSiXPHPXnR7hm12SsFdVL4/wm08=";
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
      hash = "sha256-y4ghhphUUSA9kj19+QIKoELajcGUltgj4WU1twUfX1c=";
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
      hash = "sha256-Mp2s0LoJ0Qp2CHqxdvldtro9smotD+M+7i9eRs7XU6w=";
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
      hash = "sha256-Nrczj5a+9PJoX3pFVbFRl5Oud4O9PW0iyX87cY8wlFQ=";
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
      hash = "sha256-ZJyJSrFvn0itqPnMWZp+y7iJGrN2H/b9UQUgxt5AfB8=";
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
      hash = "sha256-5BMmtgmYkfJEtDKSHtEAlqxhnzK4xPi0FjMxO9VGYts=";
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
      hash = "sha256-es+PXyRex/bzU/SHKdE3sSrxrPos8fvWXHA5HpM3+OE=";
    };
    buildInputs = [ CatalystRuntime TestLongString TestSimple13 TestWWWMechanize TestWWWMechanizeCatalyst TextCSV XMLSimple ];
    meta = {
      description = "A view module to help in the convenience of downloading data into many supportable formats";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewJSON = buildPerlPackage {
    pname = "Catalyst-View-JSON";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Catalyst-View-JSON-0.37.tar.gz";
      hash = "sha256-xdo/bop3scmYVd431YgCwLGU4pp9hsYO04Mc/dWfnew=";
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
      hash = "sha256-KN8SU3w9Xg5aSJ/GZL2+rgEyfZvegkW/QJjfgt+870s=";
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
      hash = "sha256-CElE6cnQ37ENSrNFPhwSX97jkSm0bRfAI0w8U1FkBEc=";
    };
    propagatedBuildInputs = [ CatalystRuntime MooseXTraitsPluggable ];
    meta = {
      description = "Automatic Trait Loading and Resolution for Catalyst Components";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystXRoleApplicator = buildPerlPackage {
    pname = "CatalystX-RoleApplicator";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/CatalystX-RoleApplicator-0.005.tar.gz";
      hash = "sha256-4o5HZ3aJva31VE4cQaKsV1WZNm+EDXO70LA8ZPtVim8=";
    };
    propagatedBuildInputs = [ CatalystRuntime MooseXRelatedClassRoles ];
    meta = {
      description = "Apply roles to your Catalyst application-related classes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystTraitForRequestProxyBase = buildPerlPackage {
    pname = "Catalyst-TraitFor-Request-ProxyBase";
    version = "0.000005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-TraitFor-Request-ProxyBase-0.000005.tar.gz";
      hash = "sha256-p78Pqn4Syl32Jdn1/HEPEb/Ra6U4WDfkjUKz0obJcQo=";
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
      hash = "sha256-5jpH80y0P3+87GdYyaVCiAGOOIAjZTYYkLKjTfCKWyI=";
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
      hash = "sha256-hWSEnVY5AV3iNiTlc8riU265CUMrZNkAmKHgtFKp60s=";
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
      hash = "sha256-OHIYl8hKwsKNVYHBHTtGevkwwfN34L0uwzCPAiXGBGo=";
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
      hash = "sha256-vcy6H6jkwc8xicXlo1KaZpOmSKpSgrWXU4x6rdzm2ck=";
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
      hash = "sha256-6+ZCnEFcFOc8bK/g1OLc3o4WnYFScfHhUjwmThrsx8k=";
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
      hash = "sha256-C9IV5wEvn1Lmp9P+aV7jDvlZ15bo5TRy+g7YxT+6YAo=";
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
      hash = "sha256-9Et07t+9Hrjw+WiPndrhVCLl+kiueL4hsK/LnjJJDqU=";
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
      hash = "sha256-RpnLSr2XIBSvO+ubCmlbQluH2ibLK0vbJgIHCqrdPcY=";
    };
    meta = {
      description = "HTTP Cookie parser in pure C";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIEmulatePSGI = buildPerlPackage {
    pname = "CGI-Emulate-PSGI";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/CGI-Emulate-PSGI-0.23.tar.gz";
      hash = "sha256-3VtsNT8I+6EA2uCZBChPf3P4Mo0x9qZ7LBNvrXKNFYs=";
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
      hash = "sha256-boLRGOPEwMLa/NpYde3l6N2//+C336pkjkUeA5pFpKk=";
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
      hash = "sha256-5TQt89xZPt+3JMev6FCxoO51P01zP1GT4DewRjPf7s4=";
    };
    propagatedBuildInputs = [ CGI FCGI ];
    doCheck = false;
    meta = {
      description = "CGI Interface for Fast CGI";
      homepage = "https://metacpan.org/module/CGI::Fast";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIFormBuilder = buildPerlPackage {
    pname = "CGI-FormBuilder";
    version = "3.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGPRESH/CGI-FormBuilder-3.10.tar.gz";
      hash = "sha256-rsmb4MDwZ6fnJpxTeOWubI1905s2i08SwNhGOxPucZg=";
    };

    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Easily generate and process stateful forms";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIMinimal = buildPerlModule {
    pname = "CGI-Minimal";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SN/SNOWHARE/CGI-Minimal-1.30.tar.gz";
      hash = "sha256-uU1QghsCYR2m7lQjGTFFB4xNuygvKxYqSw1YCUmXvEc=";
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
      hash = "sha256-xQ3LEL+EhqmEO67QMq2J2Hn/L0HJkzQt6tYvlHpZjZE=";
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
      hash = "sha256-RnVkYcJM52ZrgQjduW26thJpnfMBLIDvEQFmGf4VVPc=";
    };
    propagatedBuildInputs = [ CGI ];
    meta = {
      description = "Persistent session data in CGI applications";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  CGISimple = buildPerlModule {
    pname = "CGI-Simple";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/CGI-Simple-1.25.tar.gz";
      hash = "sha256-5ebPNuoG8OZ7vc3Zz7aY80yZNR6usy3U+mNviZQ+9H4=";
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
      hash = "sha256-0T2Np/3NbZBgVOR2D8KKcYrskb088GeliSf7fLHAnWw=";
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
      hash = "sha256-x/Gis1cKj+3khOkz+Juhcp4KvQWTV5HRRsUi3RIO6FE=";
    };
    preConfigure = ''
      # fix error 'Unescaped left brace in regex is illegal here in regex'
      substituteInPlace lib/CHI/t/Driver/Subcache/l1_cache.pm --replace 'qr/CHI stats: {' 'qr/CHI stats: \{'
    '';
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
      hash = "sha256-hL2ZoaDOckd7FeNYgeYSA5i7P1U67rXo1ysIhSDk9r8=";
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
      hash = "sha256-sDyiY/j0Gm7FRcU5MhOjFG02vUUzWt6Zr1HdQqtu4W0=";
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
      hash = "sha256-xRhWIIFXAbP+whMUzNjFaT5r/VGUMVJ9ozcKgWQiBnE=";
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
      hash = "sha256-vxKj5d5aLG6KRHs2T09aBQv3RiTFbjFQIq55kv8vQRw=";
    };
    meta = {
      description = "Automated accessor generation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorChained = buildPerlModule {
    pname = "Class-Accessor-Chained";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz";
      hash = "sha256-pb9J04BPg60lobFvMn0U1MvuInATIQSyhwUDHbzMNNI=";
    };
    propagatedBuildInputs = [ ClassAccessor ];
    meta = {
      description = "Make chained accessors";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorGrouped = buildPerlPackage {
    pname = "Class-Accessor-Grouped";
    version = "0.10014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Class-Accessor-Grouped-0.10014.tar.gz";
      hash = "sha256-NdWwPvwJ9n86MVXJYkEmw+FiyOPKmP+CbbNYUzpExLs=";
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
      hash = "sha256-dbO47I7+aHZ3tj8KEO75ZuAfYHNcVmVs51y7RMq6M1o=";
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
      hash = "sha256-wFsyNsBXGdgZwg2w/ettCVR0fkPXpzgpTu1/vPNuzxs=";
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
      hash = "sha256-4aW93lJQWAJmSpEIpRXJ6OUCy3IppJ3pT0CBsbKu7YQ=";
    };
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Useful base class for deriving other modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3 = buildPerlPackage {
    pname = "Class-C3";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Class-C3-0.35.tar.gz";
      hash = "sha256-hAU88aaPzIwSBWwvEgrfBPf2jjvjT0QI6V0Cb+5n4z4=";
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
      hash = "sha256-hWdiJarbduhmamq+LgZZ1A60WBrWOFsXDupOHWvzS/c=";
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
      hash = "sha256-MFGxRtwe/q6hqaLp5rF3MICZW4mKtYPxVWWNX8gLlpM=";
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
      hash = "sha256-m2XUG5kVOJkugWsyzE+ptKSguz6cEOfuvv+CZY27yPY=";
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
      hash = "sha256-9dSVsd+4JtXAxF0DtNDmtgR8uwbNv2vhX9TckCrutws=";
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
      hash = "sha256-wSLW4t9hNs6b6h5tK3dsueaeAAhezplTAYFMevOo6BQ=";
    };
    meta = {
      description = "Inheritable, overridable class and instance data accessor creation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassDataInheritable = buildPerlPackage {
    pname = "Class-Data-Inheritable";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz";
      hash = "sha256-mWf+zuoVIn5ELsgYcjFj621zuJR+MfFquAb24jka8Uo=";
    };
    meta = {
      description = "Inheritable, overridable class data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassEHierarchy = buildPerlPackage {
    pname = "Class-EHierarchy";
    version = "2.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORLISS/Class-EHierarchy/Class-EHierarchy-2.01.tar.gz";
      hash = "sha256-Y3q3a+s4MqmwcbmZobFb8F0pffamYsyxqABPKYcwg4I=";
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
      hash = "sha256-w3otJp65NfNqI+ETSArglG+nwSoSeBOWoSJsjkNfMPU=";
    };
    meta = {
      description = "Base class for dynamic factory classes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassFactoryUtil = buildPerlModule {
    pname = "Class-Factory-Util";
    version = "1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Class-Factory-Util-1.7.tar.gz";
      hash = "sha256-bFFrRFtE+HNj+zoUhDHTHp7LXm8h+2SByJskBrZpLiY=";
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
      hash = "sha256-R9s86pzp/6mL+cdFV/0yz3AHkatTcCDJWKwwtKn/IAs=";
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
      hash = "sha256-zCldI6RyaHwkSJ1YIm6tI7n9wliOUi8LXwdHdBcAaU4=";
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
      hash = "sha256-iBbzTpo46EmhDfdWAw3M+f4GGhlsEaw/qv1xE8kpuWQ=";
    };
    meta = {
      description = "Report the search path for a class's ISA tree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassIterator = buildPerlPackage {
    pname = "Class-Iterator";
    version = "0.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEXMEC/Class-Iterator-0.3.tar.gz";
      hash = "sha256-2xuofKkQfxYf6cHp5+JnwAJt78Jv4+c7ytirj/wY750=";
    };
    meta = {
      description = "Iterator class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassLoader = buildPerlPackage rec {
    pname = "Class-Loader";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Class-Loader-2.03.tar.gz";
      hash = "sha256-T+8gdurWBCNFT/H06ChZqam5lCtfuO7gyYucY8nyuOc=";
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
      hash = "sha256-rKx0LnnQ7Ip75Nj7gTqF6kTUfRnAFwzdswZEYCtYLGY=";
    };
    preConfigure = ''
      # fix error 'Unescaped left brace in regex is illegal here in regex'
      substituteInPlace tests/xemulator/class_methodmaker/Test.pm --replace 's/(TEST\s{)/$1/g' 's/(TEST\s\{)/$1/g'
    '';
    meta = {
      description = "Generate common types of methods";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodMaker = buildPerlPackage {
    pname = "Class-MethodMaker";
    version = "2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz";
      hash = "sha256-Xu9YzLJ+vQG83lsUvMVTtTR6Bpnlw+khx3gMNSaJAyg=";
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
      hash = "sha256-q1gH9xAYqELea3pIJtbB8kuNWwn8zlAFozCc9upA/WM=";
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
      hash = "sha256-h0f2Q4k5FPjESXnxcW0MHsikE5R5ZVVEeUToYPH/fAs=";
    };
    propagatedBuildInputs = [ ParamsClassify ];
    meta = {
      description = "Dynamic class mixing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassRefresh = buildPerlPackage {
    pname = "Class-Refresh";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Class-Refresh-0.07.tar.gz";
      hash = "sha256-47ADU1XLs1oq7j8iNojVeJRqenxXCs05iyjN2x/UvrM=";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ClassUnload DevelOverrideGlobalRequire TryTiny ];
    meta = {
      homepage = "http://metacpan.org/release/Class-Refresh";
      description = "Refresh your classes during runtime";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassReturnValue = buildPerlPackage {
    pname = "Class-ReturnValue";
    version = "0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Class-ReturnValue-0.55.tar.gz";
      hash = "sha256-7Tg2iF149zTM16mFUOxCKmFt98MTEMG3sfZFn1+w5L0=";
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
      hash = "sha256-J7oT8NlRKSkWa72MnvldkNYw/IDwyaG3RYiRBV6SgqQ=";
    };
    meta = {
      description = "Implementation of a 'Singleton' class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassThrowable = buildPerlPackage {
    pname = "Class-Throwable";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Class-Throwable-0.13.tar.gz";
      hash = "sha256-3JoR4Nq1bcIg3qjJT+PEfbXn3Xwe0E3IF4qlu3v7vM4=";
    };
    meta = {
      description = "A minimal lightweight exception class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassTiny = buildPerlPackage {
    pname = "Class-Tiny";
    version = "1.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.008.tar.gz";
      hash = "sha256-7gWKY5Evofy5pySY9WykIaIFbcf59LZ4N0RtZCGBVhU=";
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
      hash = "sha256-Kkj6d5tSl+VhVjgOizJjfGxY3stPSn88c1BSPhEnX48=";
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
      hash = "sha256-W8Is9Tbr/SVkxb2vQvDYpM7j0ZMPyLRLfUpCA4YirdE=";
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
      hash = "sha256-PvGHM6DwPBE/O8+KxQR24Jyh/mI09KqsqiTfypUWgJQ=";
    };
    propagatedBuildInputs = [ ClassISA ];
    meta = {
      description = "Allow other classes and objects to respond to events in yours";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassStd = buildPerlModule {
    pname = "Class-Std";
    version = "0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz";
      hash = "sha256-vNbYL2yK8P4Gn87X3RZaR5WwtukjUcfU5aGrmhT8NcY=";
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
      hash = "sha256-G9Q3Y8ajcxgwl6MOeH9dZxOw2ydRHFLVMyZrWdLPp4A=";
    };
    propagatedBuildInputs = [ ClassStd ];
    nativeCheckInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Faster but less secure than Class::Std";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassUnload = buildPerlPackage {
    pname = "Class-Unload";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.11.tar.gz";
      hash = "sha256-UuKXR6fk0uGiicDh3oEHY08QyEJs18nTHsrIOD5KCl8=";
    };
    propagatedBuildInputs = [ ClassInspector ];
    buildInputs = [ TestRequires ];
    meta = {
      description = "Unload a class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassVirtual = buildPerlPackage {
    pname = "Class-Virtual";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/Class-Virtual-0.08.tar.gz";
      hash = "sha256-xkmbQtO05cZIil6C+8KGmObJhgFlBy3d+mdJNVqc+7I=";
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
      hash = "sha256-mcVrOV8SOa8ZkB8v7rEl2ey041Gg2A2qlSkhGkcApvI=";
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
      hash = "sha256-xnFkiOZf53n/eag/DyA2rZRGPv49DzSca5kRKXW9hfw=";
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
      hash = "sha256-In25W2MzgnAkVUzDLvcI0wwaf/uW39RCX4/g46/18cE=";
    };
    buildInputs = [ PodCoverageTrustPod TestPerlCritic ];
    propagatedBuildInputs = [ CaptureTiny RefUtil SubExporter TermReadKey YAML ];
    meta = {
      description = "Subroutines for making simple command line scripts";
      homepage = "https://github.com/reyjrar/CLI-Helpers";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  Clipboard = buildPerlModule {
    pname = "Clipboard";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Clipboard-0.26.tar.gz";
      hash = "sha256-iGrkPchTj5v8Tgf9vPCbf71u5Zwx82RhjIWd4UlTxYo=";
    };
    propagatedBuildInputs = [ CGI ];
    # Disable test on darwin because MacPasteboard fails when not logged in interactively.
    # Mac OS error -4960 (coreFoundationUnknownErr): The unknown error at lib/Clipboard/MacPasteboard.pm line 3.
    # Mac-Pasteboard-0.009.readme: 'NOTE that Mac OS X appears to restrict pasteboard access to processes that are logged in interactively.
    #     Ssh sessions and cron jobs can not create the requisite pasteboard handles, giving coreFoundationUnknownErr (-4960)'
    doCheck = !stdenv.isDarwin;
    meta = {
      description = "Copy and paste with any OS";
      homepage = "https://metacpan.org/release/Clipboard";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  Clone = buildPerlPackage {
    pname = "Clone";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz";
      hash = "sha256-y7buNIr6lUMuSHiJO0Z1JUnnDcaP5tnkMNHS6ZB5qeY=";
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
      hash = "sha256-ViNIH1jO6O25bNICqtDfViLUJ+X3SLJThR39YuUSNjI=";
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
      hash = "sha256-VyAwlKXYV0tqAJUejyOZtmb050+VEdnJ+1tFPV0R9Xg=";
    };
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CodeTidyAll = buildPerlPackage {
    pname = "Code-TidyAll";
    version = "0.78";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Code-TidyAll-0.78.tar.gz";
      hash = "sha256-Ml67QdhZAG7jK2Qmu+hlhnjqywPAESCqYoZZ9uY3ubY=";
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
      hash = "sha256-jR3inlbwczFoXqONGDr87f8hCOccSp2zb0GeUN0sHOU=";
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
      hash = "sha256-WMv34zPTpKQCl6vENBKzIdpEnGgWAg5PpmJasHn8kKU=";
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
      hash = "sha256-WtJtBhEb/s1TyPW7XeqUvyAl9seOlfbYAS5M+oninyY=";
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
      hash = "sha256-qGocTKTzAG10eQZEJaCfpbZonlcmH8uZT+Z9Bhy6Dn4=";
    };
    meta = {
      description = "Implements some sane defaults for Perl programs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompilerLexer = buildPerlModule {
    pname = "Compiler-Lexer";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GO/GOCCY/Compiler-Lexer-0.23.tar.gz";
      hash = "sha256-YDHOSv67+k9JKidJSb57gjIxTpECOCjEOOR5gf8Kmds=";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    buildInputs = [ ModuleBuildXSUtil ];
    meta = {
      homepage = "https://github.com/goccy/p5-Compiler-Lexer";
      description = "Lexical Analyzer for Perl5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressBzip2 = buildPerlPackage {
    pname = "Compress-Bzip2";
    version = "2.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Compress-Bzip2-2.28.tar.gz";
      hash = "sha256-hZ+DXD9cmYgQ2LKm+eKC/5nWy2bM+lXK5+Ztr7A1EW4=";
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
      hash = "sha256-XR9d9IzhO03uHMnyeOzb+Bd4d7C5iBWk6zyRw0ZnFvI=";
    };
    meta = {
      description = "Extremely light-weight Lempel-Ziv-Free compression";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawBzip2 = buildPerlPackage {
    pname = "Compress-Raw-Bzip2";
    version = "2.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.101.tar.gz";
      hash = "sha256-DJsTT9OIKQ4w6Q/J9jkAlmEn+Y52sFTs1IHrO1UAuNg=";
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
      hash = "sha256-uyZ/0xmB7aEfREA4+KD8pLlKUa5hsttxJGq/ak0yKjY=";
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
      hash = "sha256-1p0mIMoCTcG0JPf0Io/hFpsrd0FrswMQ6JDTvn2kff8=";
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
      description = "Low-Level Interface to zlib or zlib-ng compression library";
      homepage = "https://github.com/pmqs/Compress-Raw-Zlib";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressUnLZMA = buildPerlPackage {
    pname = "Compress-unLZMA";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Compress-unLZMA-0.05.tar.gz";
      hash = "sha256-TegBoo2S1ekJR0Zc60jU45/WQJOF6cIw5MBIKdllF7g=";
    };
    meta = {
      description = "Interface to LZMA decompression library";
      license = with lib.licenses; [ artistic1 gpl1Plus lgpl21Plus ];
    };
  };

  ConfigAny = buildPerlPackage {
    pname = "Config-Any";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Config-Any-0.32.tar.gz";
      hash = "sha256-aNoqXPJfrt1NJM89DVcJlcGZ1blQEIot541A3s7TYVA=";
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
      hash = "sha256-ME9mzCZTJkwP4SfSFmnobT0YzXLyV02PUTG+7DGgoz4=";
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
      hash = "sha256-Cpv5d7iqvnY0PogJXSKWyKQiQQ/SoFoZAfKyDi4fb60=";
    };
    meta = {
      description = "Generic Config Module";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ConfigGitLike = buildPerlPackage {
    pname = "Config-GitLike";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Config-GitLike-1.18.tar.gz";
      hash = "sha256-9650QPOtq1uf+apXIW2E/UpoEAm5WE4y2kL4u3HjMsU=";
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
      hash = "sha256-qLOjosnIxDuS3EAb8nCdZRTxW0Z/1PcsSNNWM1dx1uM=";
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
      hash = "sha256-Yov3bVuR+J3eItSBPsAzAm6/cbdyu2HM2pCdoAyGlzI=";
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
      hash = "sha256-KVIL2zdlnmQUkbDGlmFCmhqJtqLkdcL5tOvyfkXoEqg=";
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
      hash = "sha256-PEV7ZdmOX/QL25z4FLDVmD6wxT+4aWvaO6A1rSrNaAI=";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A module for reading .ini-style configuration files";
      homepage = "https://metacpan.org/release/Config-IniFiles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  ConfigMerge = buildPerlPackage {
    pname = "Config-Merge";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/Config-Merge-1.04.tar.gz";
      hash = "sha256-qTJHe0OuX7BKFvBxqJHae9IIbBDGgFkvKIj6nZlyzM8=";
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
      hash = "sha256-Mn/d9o4TiyRp5aK643xzP4fKhMr2Hhz6qUm+PZUNqK8=";
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
      hash = "sha256-I8lWZvxDxK2uvMCTsbVgke/CpqotdTZqIW0Y7alq1xY=";
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
      hash = "sha256-aakWvzcR68nn1MqqcPPGlekYuTpZI5WHczA+DaC21EU=";
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
      hash = "sha256-XQQ5W+fhTpcKA+qVL7dimuME2XwDH5DMHCm9Cmpi/EA=";
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
      hash = "sha256-3ZmVcG8Pk4ShXM/+EWw7biL0K6LljY8k7QPEoOOG7bQ=";
    };
    meta = {
      description = "Simple configuration file class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigStd = buildPerlModule {
    pname = "Config-Std";
    version = "0.903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICKER/Config-Std-0.903.tar.gz";
      hash = "sha256-t3Cf9mO9J50mSrnC9R6elYhHmjNnqMTPwYZZwqEUgP4=";
    };
    propagatedBuildInputs = [ ClassStd ];
    meta = {
      description = "Load and save configuration files in a standard format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigTiny = buildPerlPackage {
    pname = "Config-Tiny";
    version = "2.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Config-Tiny-2.24.tgz";
      hash = "sha256-EGSUjkvFfobjGNvIeRxTyludlblYzEdDZ8MneYETUjI=";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "Read/Write .ini style files with as little code as possible";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigVersioned = buildPerlPackage {
    pname = "Config-Versioned";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Config-Versioned-1.01.tar.gz";
      hash = "sha256-vJpK43OL2J+GoHvKZzYnyjySupaXN81tvHq3rRfNI0g=";
    };
    propagatedBuildInputs = [ ConfigStd GitPurePerl ];
    doCheck = false;
    meta = {
      description = "Simple, versioned access to configuration data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "cfgver";
    };
  };

  Connector = buildPerlModule {
    pname = "Connector";
    version = "1.47";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Connector-1.47.tar.gz";
      hash = "sha256-I2R4pAq53cIVgu4na6krnjgbP8XtljkKLe2o4nSGeoM=";
    };
    buildInputs = [ ModuleBuildTiny ConfigMerge ConfigStd ConfigVersioned DBDSQLite DBI IOSocketSSL JSON LWP LWPProtocolHttps ProcSafeExec TemplateToolkit YAML ];
    propagatedBuildInputs = [ LogLog4perl Moose ];
    prePatch = ''
      # Attempts to use network.
      rm t/01-proxy-http.t
      rm t/01-proxy-proc-safeexec.t

      # crypt() tests that use DES
      rm t/01-builtin-password.t
      rm t/01-builtin-password-scheme.t
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
      hash = "sha256-+AWVOgjFeEahak2F17dmOYr698NsFGX8sd6gnl+jlNs=";
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
      hash = "sha256-l+istusqKpGvfWzw0t/2+kKq+Tn8fW0cYFek8N9SyQQ=";
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
      hash = "sha256-H98ARSDHnjokTPlohhYpNRbBF5PXRsdh82dJbrPQYHY=";
    };
    meta = {
      description = "ASN.1 Encode/Decode library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConvertBase32 = buildPerlPackage {
    pname = "Convert-Base32";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEGAMI/Convert-Base32-0.06.tar.gz";
      hash = "sha256-S6gsFnxB9FWqgoRzhyfkyUouvLHEznl/b9oHJFpkIRU=";
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
      hash = "sha256-Jp89+GVpJZbeIU/kK5Lc+H1qa8It237Sq8f0i4LkXmw=";
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
      hash = "sha256-tBIXxykxA0ukQX16nh4pmfBFgNTmsxxwmT/tzMJEDTg=";
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
      hash = "sha256-kjKc4cMrWVLEjhIj2wGMjFjOr+8Dv6D9SBfNicNVo70=";
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
      hash = "sha256-zSxZ1YBhzhpJdaMTFg33GG9i7qJlW4XVIOXiTp7rD+k=";
    };
    propagatedBuildInputs = [ SymbolUtil ];
    meta = {
      description = "Define TRUE and FALSE constants";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  curry = buildPerlPackage {
    pname = "curry";
    version = "1.001000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/curry-1.001000.tar.gz";
      hash = "sha256-ixhgeSAgZPs9zCXPcpCqP11VHZjRuG1YRHBqdgwfVtQ=";
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
      hash = "sha256-eyEmMZjKImhu//OumHokC+Qj3SFgr96yn+cW0DKYb/o=";
    };
    meta = {
      description = "Constant subs with deferred value calculation";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  ContextPreserve = buildPerlPackage {
    pname = "Context-Preserve";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Context-Preserve-0.03.tar.gz";
      hash = "sha256-CZFKTCx725nKtoDBg8v0kuyY1uI/vMSH/MSuEFZ9/R8=";
    };
    buildInputs = [ TestException TestSimple13 ];
    meta = {
      description = "Run code after a subroutine call, preserving the context the subroutine would have seen if it were the last statement in the caller";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CookieBaker = buildPerlModule {
    pname = "Cookie-Baker";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cookie-Baker-0.11.tar.gz";
      hash = "sha256-WSdfR04HwKo2EePmhLiU59uRMzPYIUQgvmPxLsGM16s=";
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
      hash = "sha256-o7lxB4CiJC5w750G5R+Rt/PqCq5o9Tx25CxYLCzLJpg=";
    };
    propagatedBuildInputs = [ CGICookieXS ];
    meta = {
      description = "HTTP Cookie parser in C (Please use CGI::Cookie::XS instead)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Coro = buildPerlPackage {
    pname = "Coro";
    version = "6.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Coro-6.57.tar.gz";
      hash = "sha256-GSjkgDNUDhHr9VBpht0QGveNJCHSEPllmSI7FdUXFMY=";
    };
    propagatedBuildInputs = [ AnyEvent Guard commonsense ];
    buildInputs = [ CanaryStability ];
    meta = {
      description = "The only real threads in perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CoroEV = buildPerlPackage rec {
    pname = "CoroEV";
    version = "6.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Coro-${version}.tar.gz";
      hash = "sha256-Q9ecAnFw/NpMoO6Sc0YFvJXhImhvUHG5TZB2TIGuijA=";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ AnyEvent Coro EV Guard commonsense ];
    preConfigure = ''
      cd EV
    '';
    meta = {
      description = "Do events the coro-way, with EV";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Corona = buildPerlPackage {
    pname = "Corona";
    version = "0.1004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Corona-0.1004.tar.gz";
      hash = "sha256-//XRnoPeem0mWfNGgpgmsWUrtmZlS4eDsRmlNFS9rzw=";
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
      hash = "sha256-H1VnLv1QWpuqz6GSTRFTYhIKpr+O+rehfHywkLF8zEE=";
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
      hash = "sha256-Wil6/D42etgIEUZNTrfk3Tyv+LpJnN0rVY9ieUQ6dlc=";
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
    version = "4.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Cpanel-JSON-XS-4.36.tar.gz";
      hash = "sha256-7OhHQhfLLt8E5PUaGM7aN4e1sd//7iyJGbLrEJpnJu0=";
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
      hash = "sha256-Z1wVLOaOcz9MQPVuzcGhkVxv/1X2IrBEFCqlrOjFrwk=";
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
      hash = "sha256-Ae7eqQ0HRoy1jkpQv6O7HU7tqQc1lq3REY/DWRU6vo0=";
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
      hash = "sha256-QIBxbF2n4DtQTjzA6h/V757WkV9vtzdWTp4T01Wonjk=";
    };
    propagatedBuildInputs = [ CompressBzip2 DataCompare ModuleSignature ];
    meta = {
      description = "Write a CHECKSUMS file for a directory as on CPAN";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANCommonIndex = buildPerlPackage {
    pname = "CPAN-Common-Index";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Common-Index-0.010.tar.gz";
      hash = "sha256-xD3bsi/UKwYRj+Y1f1NwD7139TG6PEJ/qvvzA8v06vA=";
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
      hash = "sha256-LyT76ffurLwmnTX8YWGDIvwXvkme4M2QGPNwk0qfJDU=";
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
      hash = "sha256-KKBXK/wcBnjZzn2kjPUhCXraIw+W6z0GP8uuHP5qNR8=";
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
      hash = "sha256-c2ByY+fKTXwrKu7EUR06vAtYz5CHFSS373iaUoyoUuM=";
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
      hash = "sha256-WPastH15HtjjCm68wlCJIYusrZbkbajmIakrd4xWndQ=";
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
      hash = "sha256-jgh+/jYl3suBaymR/4195K1xkPmGPQSQlnAU9nGfu8U=";
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
      hash = "sha256-PqHABvEO9m/UF+UCpWnfFcTMHHdrCE41Y5dRxBzmZxo=";
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
      hash = "sha256-RrNDH/tr9bnLNZ95Vl1IQH5lKtKwT99cpipp5xl6Z7E=";
    };
    meta = {
      description = "Perl Blowfish encryption module";
      license = with lib.licenses; [ bsdOriginalShortened ];
    };
  };

  CryptCAST5_PP = buildPerlPackage {
    pname = "Crypt-CAST5_PP";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBMATH/Crypt-CAST5_PP-1.04.tar.gz";
      hash = "sha256-y6mKgEA/uJihTJKPI39EgWtISGQYQM4lFzY8LAcbUyc=";
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
      hash = "sha256-anDeIbbMfysQAGfo4Yjblm6agAG122+pdufLWylK5kU=";
    };
    meta = {
      description = "Encrypt Data with Cipher Block Chaining Mode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptCurve25519 = buildPerlPackage {
    pname = "Crypt-Curve25519";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AJ/AJGB/Crypt-Curve25519-0.06.tar.gz";
      hash = "sha256-n0hwPbTuyiluqCwtZuShOfInC437C+38T/lEVLt7IMc=";
    };
    patches = [
      (fetchpatch {
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-perl/Crypt-Curve25519/files/Crypt-Curve25519-0.60.0-fmul-fixedvar.patch?id=cec727ad614986ca1e6b9468eea7f1a5a9183382";
        hash = "sha256-Dq431QnMuI9V34BKy7SNaQMXD4lykDuo3wab278sAFA=";
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
      hash = "sha256-LbHrtYN7TLIAUcDuW3M7RFPjE33wqSMGA0yGdiHt1+c=";
    };
    meta = {
      description = "Perl DES encryption module";
      license = with lib.licenses; [ bsdOriginalShortened ];
    };
  };

  CryptDES_EDE3 = buildPerlPackage {
    pname = "Crypt-DES_EDE3";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BT/BTROTT/Crypt-DES_EDE3-0.01.tar.gz";
      hash = "sha256-nLLgS2JenMCDPNSZ92/RJVZYPs7KeCqXWKVeP5aXSNY=";
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
      hash = "sha256-yIzzQjsB5nguiYbX/lMEQ2q4SwklxEmMb9+hfvmjf18=";
    };
    propagatedBuildInputs = [ MathBigIntGMP ];
    meta = {
      description = "Diffie-Hellman key exchange system";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptDHGMP = buildPerlPackage {
    pname = "Crypt-DH-GMP";
    version = "0.00012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/Crypt-DH-GMP-0.00012.tar.gz";
      hash = "sha256-UeekeuWUz1X2bAdi9mkhVIbn2LNGC9rf55NQzPJtrzg=";
    };
    buildInputs = [ pkgs.gmp DevelChecklib TestRequires ];
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    meta = {
      description = "Crypt::DH Using GMP Directly";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptDSA = buildPerlPackage {
    pname = "Crypt-DSA";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Crypt-DSA-1.17.tar.gz";
      hash = "sha256-0bhYX2v3RvduXcXaNkHTJe1la8Ll80S1RRS1XDEAmgM=";
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
      hash = "sha256-9a9i6QjNMaNLK4ExNaBxgBb9AD/6ACH/vdhMUBWCZ6o=";
    };
    meta = {
      description = "Use block ciphers using ECB mode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptEksblowfish = buildPerlModule {
    pname = "Crypt-Eksblowfish";
    version = "0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Crypt-Eksblowfish-0.009.tar.gz";
      hash = "sha256-PMcSbVhBEHI3qb4txcf7wWfPPEtM40Z4qESLhQdXAUw=";
    };
    propagatedBuildInputs = [ ClassMix ];
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "The Eksblowfish block cipher";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptFormat = buildPerlPackage {
    pname = "Crypt-Format";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Crypt-Format-0.10.tar.gz";
      hash = "sha256-id3AEKbJHVvnoYdKUo7tbto58sQBwY5j2A3fv3En4t0=";
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
      hash = "sha256-M714wRkkoPwf8+7d6UB4y79rbKnt4EbSsvVh6emnIBk=";
    };
    meta = {
      description = "Perl interface to IDEA block cipher";
      license = with lib.licenses; [ bsdOriginalShortened ];
    };
  };

  CryptJWT = buildPerlPackage {
    pname = "Crypt-JWT";
    version = "0.029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/Crypt-JWT-0.029.tar.gz";
      hash = "sha256-D8z/KQZaAJju8VHe6zPBLA1o4WoctOdGWybrvUwYzS8=";
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
      hash = "sha256-aFqgkPgXmobWiWISzPjM/eennM6FcZm7FOInehDSQK0=";
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
      hash = "sha256-cCkLtb3GfBcBKN8+UWexfQS7eTkzqubAWnWGfao/OTg=";
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
      hash = "sha256-M44nA4RH/eAjznyaC1dPR+4zeQRKDAgxrJRx8UMNxMU=";
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
      hash = "sha256-t31q7qJTAa975nn3RS6JTKiK+XEL/9bgHWZaFBw5GUg=";
    };
    meta = {
      description = "Provide interoperable MD5-based crypt() functions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptPKCS10 = buildPerlModule {
    pname = "Crypt-PKCS10";
    version = "2.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRSCOTTY/Crypt-PKCS10-2.001.tar.gz";
      hash = "sha256-95RbdqLY9Njs9iey646k9B0AHmqRXv6C5x1rl/6j/6k=";
    };
    buildInputs = [ pkgs.unzip ModuleBuildTiny ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "Parse PKCS #10 certificate requests";
      homepage = "https://github.com/openxpki/Crypt-PKCS10";
      license = with lib.licenses; [ gpl1Only ];
    };
  };

  CryptRandomSeed = buildPerlPackage {
    pname = "Crypt-Random-Seed";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Crypt-Random-Seed-0.03.tar.gz";
      hash = "sha256-WT2lS1IsCcwmu8wOTknByOaIpv0zsHJq+AHXIqXI0PE=";
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
      hash = "sha256-qTwG3kCeby6y6YaOptTmU9mfL3kAssGDHh9lrODE74Q=";
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
      hash = "sha256-7E7OJp+a0ZWMbimOzuLlpDReNX86T/ssdIEWr4du7eY=";
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
      hash = "sha256-oJErQsUr4XPaUo1VJ+QNlnMkvASseNn8LdyR/xb+ljM=";
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
      hash = "sha256-XsRCXGvCIgeIljC+c1DZlobmKkTGE2lgEQIDzVlK4Oo=";
    };
    meta = {
      description = "Perl implementation of the RC4 encryption algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRandPasswd = buildPerlPackage {
    pname = "Crypt-RandPasswd";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Crypt-RandPasswd-0.06.tar.gz";
      hash = "sha256-sb2QR42cx19MffpNvub9DApAoaUpKI33JpeHMwgpSDE=";
    };
    meta = {
      description = "Random password generator based on FIPS-181";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRIPEMD160 = buildPerlPackage {
    pname = "Crypt-RIPEMD160";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Crypt-RIPEMD160-0.08.tar.gz";
      hash = "sha256-NNHIdgf2yd76s3QbdtMbzPu21NIBr4Dg9gg8N4EwsjI=";
    };
    meta = {
      description = "Perl extension for the RIPEMD-160 Hash function";
      homepage = "https://wiki.github.com/toddr/Crypt-RIPEMD160";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptMySQL = buildPerlModule {
    pname = "Crypt-MySQL";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEBE/Crypt-MySQL-0.04.tar.gz";
      hash = "sha256-k+vfqu/P6atoPwEhyF8kR12Bl/C87EYBghnkERQ03eM=";
    };
    propagatedBuildInputs = [ DigestSHA1 ];
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "Emulate MySQL PASSWORD() function";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptRijndael = buildPerlPackage {
    pname = "Crypt-Rijndael";
    version = "1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-Rijndael-1.15.tar.gz";
      hash = "sha256-oJibVZkNeQXRtb9STNi0aq3A3neEFNTKjUBqoqpZQWM=";
    };
    meta = {
      description = "Crypt::CBC compliant Rijndael encryption module";
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  CryptUnixCryptXS = buildPerlPackage {
    pname = "Crypt-UnixCrypt_XS";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/Crypt-UnixCrypt_XS-0.11.tar.gz";
      hash = "sha256-Yus0EsLJG9TcK4pNnuJtW94usRkycDtu6sR3Pk0fT6o=";
    };
    meta = {
      description = "Perl xs interface for a portable traditional crypt function";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptURandom = buildPerlPackage {
    pname = "Crypt-URandom";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/Crypt-URandom-0.36.tar.gz";
      hash = "sha256-gf7JkhrcXTyRy+CtjLK7ibBFxPsN6cs8Q/F+WOR3+KE=";
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
      hash = "sha256-fRbulczj61TBdGc6cpn0wIb7o6yF+EfQ4TT+7V93YBc=";
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
      hash = "sha256-aMSsfqv6lX3PiUwsI7zsCW+H6M8G3t/Lv3AuVTHbsTc=";
    };
    meta = {
      description = "Perl-only implementation of lanman and nt md4 hash functions, for use in Samba style smbpasswd entries";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  CryptSodium = buildPerlPackage {
    pname = "Crypt-Sodium";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MG/MGREGORO/Crypt-Sodium-0.11.tar.gz";
      hash = "sha256-kHxzoQVs6gV9qYGa6kipKreG5qqq858c3ZZHsj8RbHg=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.libsodium.dev}/include";
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
      hash = "sha256-WIFVXWGHlyojgqoNTbLXTJcLBndMYhtspSNzkjbS1QE=";
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
      hash = "sha256-6Kf/Kpk7dqaa1t/9vlV1W+Vni4Tm7ElNzZq5Zvdm9Q4=";
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
      hash = "sha256-tm+rUU7fl/wy9Y2iV1gnBKIQwrNeKX1cMbf6L/0I6Qg=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    meta = {
      description = "Perl wrapper around OpenSSL's AES library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLBignum = buildPerlPackage {
    pname = "Crypt-OpenSSL-Bignum";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz";
      hash = "sha256-I05y+4OW1FUn5v1F5DdZxcPzogjPjynmoiFhqZb9Qtw=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    meta = {
      description = "OpenSSL's multiprecision integer arithmetic";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLGuess = buildPerlPackage {
    pname = "Crypt-OpenSSL-Guess";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.15.tar.gz";
      hash = "sha256-HFAzOBgZ/bTJCH3SkbkOxw54ENMdV+remziOzP1wOG0=";
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
      hash = "sha256-8IdvqhujER45uGqnMMYDIR7/KQXkYMcqV7YejPR1zvQ=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    OPENSSL_PREFIX = pkgs.openssl;
    buildInputs = [ CryptOpenSSLGuess ];
    meta = {
      description = "OpenSSL/LibreSSL pseudo-random number generator access";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLRSA = buildPerlPackage {
    pname = "Crypt-OpenSSL-RSA";
    version = "0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Crypt-OpenSSL-RSA-0.33.tar.gz";
      hash = "sha256-vb5jD21vVAMldGrZmXcnKshmT/gb0Z8K2rptb0Xv2GQ=";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    OPENSSL_PREFIX = pkgs.openssl;
    buildInputs = [ CryptOpenSSLGuess ];
    meta = {
      description = "RSA encoding and decoding, using the openSSL libraries";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptOpenSSLX509 = buildPerlPackage rec {
    pname = "Crypt-OpenSSL-X509";
    version = "1.914";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JONASBN/Crypt-OpenSSL-X509-1.914.tar.gz";
      hash = "sha256-ScV1JX5kCK1aiQEeW1gA1Zj5zK/fQucQBO2Byy9E7no=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -lcrypto";
    OPENSSL_PREFIX = pkgs.openssl;
    buildInputs = [ CryptOpenSSLGuess ];
    propagatedBuildInputs = [ ConvertASN1 ];
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
      hash = "sha256-l9+nmjCaCG4YSk5hBH+KEP+z2wUQJefSIqJfGRMLpBc=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DigestHMAC DigestSHA3 Moo TypeTiny namespaceautoclean strictures ];
    meta = {
      description = "The PBKDF2 password hash algorithm";
      homepage = "https://metacpan.org/release/Crypt-PBKDF2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  CryptPerl = buildPerlPackage {
    pname = "Crypt-Perl";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Crypt-Perl-0.34.tar.gz";
      hash = "sha256-DhyyI98AQfbZsBDxHm+XqXq1WhGKJzk460/oXUA/GxE=";
    };
    nativeCheckInputs = [ pkgs.openssl MathBigIntGMP ];
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
      hash = "sha256-WFBKYedGQB6HiEEE/MmNAxM51T9IfElV//tesdAykMs=";
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
      hash = "sha256-+OzKRch+uRMlmSsT8FlPgI5vG8TDuafxQbmoODhNJSw=";
    };

    makeMakerFlags = [ "--libpath=${lib.getLib pkgs.openssl}/lib" "--incpath=${pkgs.openssl.dev}/include" ];
    buildInputs = [ PathClass ];
    propagatedBuildInputs = [ BytesRandomSecure LWPProtocolHttps ];
    meta = {
      description = "OpenSSL support for LWP";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  CSSDOM = buildPerlPackage {
    pname = "CSS-DOM";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPROUT/CSS-DOM-0.17.tar.gz";
      hash = "sha256-Zbl46/PDmF5V7jK7baHp+upJSoXTAFxjuux+lphZ8CY=";
    };
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Document Object Model for Cascading Style Sheets";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CSSMinifier = buildPerlPackage {
    pname = "CSS-Minifier";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMICHAUX/CSS-Minifier-0.01.tar.gz";
      hash = "sha256-0Kk0m46LfoOrcM+IVM+7Qv8pwfbHyCmPIlfdIaoMf+8=";
    };
    meta = {
      description = "Perl extension for minifying CSS";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  CSSMinifierXS = buildPerlModule {
    pname = "CSS-Minifier-XS";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GT/GTERMARS/CSS-Minifier-XS-0.09.tar.gz";
      hash = "sha256-iKaZf6DfazlNHjRr0OV81WWFfiF9gHtlLxdrAGvm2tc=";
    };
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "XS based CSS minifier";
      homepage = "https://metacpan.org/release/CSS-Minifier-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CSSSquish = buildPerlPackage {
    pname = "CSS-Squish";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSIBLEY/CSS-Squish-0.10.tar.gz";
      hash = "sha256-ZfwNaazR+jPZpMOwnM4PvXN9dHsfzE6dh+vZEFDLy04=";
    };
    buildInputs = [ TestLongString ];
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Compact many CSS files into one big file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Curses = buildPerlPackage {
    pname = "Curses";
    version = "1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GI/GIRAFFED/Curses-1.37.tar.gz";
      hash = "sha256-dHB6460Zs1u+/aKx1r0x9XtAzayKuHIXHIcUyIlU2yA=";
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
      hash = "sha256-CrgnpRO24UQDGE+wZajqHS69oSLSF4y/RceB8xEkDq8=";
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
      hash = "sha256-CCDKSp+5SbqPr5evV0AYuu/7aU6YDFCHu2UiqnC52+w=";
    };
    propagatedBuildInputs = [ CursesUI TestPod TestPodCoverage ];
    meta = {
      description = "Create and manipulate data in grid model";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptX = buildPerlPackage {
    pname = "CryptX";
    version = "0.078";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIK/CryptX-0.078.tar.gz";
      hash = "sha256-kxYLEkL31XQ8s8kxuO/HyzmCHQ4y+U+Wkz8eiOYYvL0=";
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
      hash = "sha256-0v9hT5RX3IerJ3uBvO01MsPtMJtzuaYarvvpSIyeZg8=";
    };
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "Parse a X.509 certificate";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CwdGuard = buildPerlModule {
    pname = "Cwd-Guard";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cwd-Guard-0.05.tar.gz";
      hash = "sha256-evx8orlQLkQCQZOK2Xo+fr1VAYDr1hQuHbOUGGsmjnc=";
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
      hash = "sha256-L+XheYgqa5Jt/vChCLSiyHof+waJK88vuI5Mj0uEODw=";
    };
    buildInputs = [ TestRequires ];
    patches = [
      ../development/perl-modules/Data-Clone-fix-apostrophe-package-separator.patch
    ];
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
      hash = "sha256-gYog8fOPdOZSU8+Lz2/tf5SlqN1mL3UzDcr0sRfO6L0=";
    };
    propagatedBuildInputs = [ Clone FileFindRule ];
    meta = {
      description = "Compare perl data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDump = buildPerlPackage {
    pname = "Data-Dump";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.23.tar.gz";
      hash = "sha256-r1OwXvE4e0yrRCfmeJF5KD5PDajPA26NtRbds0RRK2U=";
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
      hash = "sha256-LZoCYq1EPTIdxInvbfp7Pu0RonCKddOX03G7JYXl7KE=";
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
      hash = "sha256-psIvETyvMRN1kN7xtwKKfnGO+s4yKCctBnLCXgNdWFM=";
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
      hash = "sha256-JhHEoaMDhZTXnqTtFNnhWpr493EF9RZneV/k+KU0J+Q=";
    };
    propagatedBuildInputs = [ CryptRijndael DataFloat HTTPLite ParamsClassify ];
    meta = {
      description = "Entropy (randomness) management";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataFloat = buildPerlModule {
    pname = "Data-Float";
    version = "0.013";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Float-0.013.tar.gz";
      hash = "sha256-4rFSPYWJMLi729GW8II19eZ4uEkZuodxLiYxO5wnUYo=";
    };
    meta = {
      description = "Details of the floating point data type";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataFormValidator = buildPerlPackage {
    pname = "Data-FormValidator";
    version = "4.88";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DF/DFARRELL/Data-FormValidator-4.88.tar.gz";
      hash = "sha256-waU5+RySy82KjYNZfsmnZD/NjM9alOFTgsN2UokXAGY=";
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
      hash = "sha256-uK9DfUn9BCWiPr/z5ZidrmTe6vDgRqpfQTZlzTFpp3s=";
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
      hash = "sha256-Gp2EPn9mfBxvd8Z69dd+dGL/I7QZN8sXRU0DU1zZvnA=";
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
      hash = "sha256-+SQ8vor/7VBF/k31BXJqenKJRx4wxRrAZbPtbODRpgQ=";
    };
    meta = {
      description = "Make binary data human-readable";
      license = with lib.licenses; [ artistic1 gpl2Only ];
    };
  };

  DataHierarchy = buildPerlPackage {
    pname = "Data-Hierarchy";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz";
      hash = "sha256-s6jmK1Pin3HdWYmu75n7+vH0tuJyoGgAOBNg1Z6f2e0=";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Handle data in a hierarchical structure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataICal = buildPerlPackage {
    pname = "Data-ICal";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Data-ICal-0.24.tar.gz";
      hash = "sha256-czHHyEiGxTM3wNuCNhXg5xNKjxPv0oTlwgcm1bzVLf8=";
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
      hash = "sha256-xvSrE0ZygjQTtQ8HR5saGwUfTO5C3Tzn6xWD1mkbZx0=";
    };
    buildInputs = [ TestBits ];
    meta = {
      description = "Pack and unpack big-endian IEEE754 floats and doubles";
      homepage = "https://metacpan.org/release/Data-IEEE754";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DataInteger = buildPerlModule {
    pname = "Data-Integer";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Integer-0.006.tar.gz";
      hash = "sha256-Y7d+3jtjnONRUlA0hjYpr5iavL/0qwOxT8Tq1GH/o1Q=";
    };
    meta = {
      description = "Details of the native integer data type";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataMessagePack = buildPerlModule {
    pname = "Data-MessagePack";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Data-MessagePack-1.01.tar.gz";
      hash = "sha256-j6DtAQHQTmYYIae3jo1izj4ZspknW7/tF44rqJEmY+o=";
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
      hash = "sha256-NmEXyylmRz8lWfL0V1/2rmnoTGmg8woHc+G1GkV+9cM=";
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
      hash = "sha256-LvpSFn0ferNZAs8yrgJ3amI3BdeRnUEYmBKHsETOPYs=";
    };
    propagatedBuildInputs = [ ClassAccessorChained ];
    buildInputs = [ TestException ];
    meta = {
      description = "Help when paging through sets of results";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPagePageset = buildPerlModule {
    pname = "Data-Page-Pageset";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHUNZI/Data-Page-Pageset-1.02.tar.gz";
      hash = "sha256-zqwbtVQ+I9qyUZUTxibj/+ZaF3uOHtnlagMNRVHUUZA=";
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
      hash = "sha256-gwzegXQf84Q4VBLhb6ulV0WlSnzAGd0j1+1PBdVRqWE=";
    };
    meta = {
      description = "Perl extension for assessing password quality";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPerl = buildPerlPackage {
    pname = "Data-Perl";
    version = "0.002011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Data-Perl-0.002011.tar.gz";
      hash = "sha256-jTTb4xTPotmb2arlRrvelMOLsFt0sHyJveFnOm9sVfQ=";
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
      hash = "sha256-YGkwEH2CdcyuLyVFQ6N270gWE3rVZimAIcypcj+CUlo=";
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
      hash = "sha256-61kBhKjbKKfknqsJ4l+GUMM/H2aLakcoKd50pTJWv8A=";
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
      hash = "sha256-zZN+W3DjSquIX/QU4qbRnkeDt8KPw82lFFsjBRTrtN4=";
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
      hash = "sha256-CzA1/9uQmqH33ta2CPqdiUQhyCwJfVHnFxFw1nV5qcs=";
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
      hash = "sha256-EhVaUgADPYCl8HVzd19JPxcAcs97KK48otFStZGXHxE=";
    };
    meta = {
      description = "Modules that serialize data structures";
      homepage = "https://metacpan.org/release/Data-Serializer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSExpression = buildPerlPackage {
    pname = "Data-SExpression";
    version = "0.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NELHAGE/Data-SExpression-0.41.tar.gz";
      hash = "sha256-gWJCakKFoJQ4X9+vbQnO0QbVr1dVP5U6yx1Whn3QFJs=";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ];
    meta = {
      description = "Parse Lisp S-Expressions into perl data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSpreadPagination = buildPerlPackage {
    pname = "Data-SpreadPagination";
    version = "0.1.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNEW/Data-SpreadPagination-0.1.2.tar.gz";
      hash = "sha256-dOv9hHEyw4zJ6DXhToLEPxgJqVy8mLuE0ffOLk70h+M=";
    };
    propagatedBuildInputs = [ DataPage MathRound ];
    meta = {
      description = "Page numbering and spread pagination";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStag = buildPerlPackage {
    pname = "Data-Stag";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CM/CMUNGALL/Data-Stag-0.14.tar.gz";
      hash = "sha256-SrEiUI0vuG0XGhX0AG5c+JbV+s+mUhnAskOomQYljlk=";
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
      hash = "sha256-BuCEMqa5dwVgbJJXCbmRKa2SZRbkd9WORGHks9nzCRc=";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose PathClass namespaceclean ];
    meta = {
      description = "N at a time iteration API";
      homepage = "https://metacpan.org/release/Data-Stream-Bulk";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataStructureUtil = buildPerlPackage {
    pname = "Data-Structure-Util";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/Data-Structure-Util-0.16.tar.gz";
      hash = "sha256-nNQqE+ZcsV86diluuaE02iIBaOx0fFaNMxpQrnot28Y=";
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
      hash = "sha256-q8s2EPygbZodmRaraYB0OmHYWvVfn9N2vqZxKommnHg=";
    };
    buildInputs = [ DebugShowStuff ];
    meta = {
      description = "Taint-aware, XML-ish data serialization";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataULID = buildPerlPackage {
    pname = "Data-ULID";
    version = "1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BALDUR/Data-ULID-1.0.0.tar.gz";
      hash = "sha256-TXV0dYk9utUWXwplxEbTi0fzkBnTb3fanSnJjL8nIG8=";
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
      hash = "sha256-tpGbpJuf6Yv98+isyue5t/eNyeceu9C3/vekXZkyTMs=";
    };
    meta = {
      description = "Perl extension for simple genrating of unique id's";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataUtil = buildPerlModule {
    pname = "Data-Util";
    version = "0.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Data-Util-0.66.tar.gz";
      hash = "sha256-w10520UglupaaVtUZo2Z1YuVTHL8nvgi4+CmJ/EVxvQ=";
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
      hash = "sha256-Ucnvv4QjhTYW6qJIQeTRmWstsANpAGF/sdvHbHWh82A=";
    };
    meta = {
      description = "Allow complex data structures to be encoded using flat URIs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataUUID = buildPerlPackage {
    pname = "Data-UUID";
    version = "1.226";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-UUID-1.226.tar.gz";
      hash = "sha256-CT1X/6DUEalLr6+uSVaX2yb1ydAncZj+P3zyviKZZFM=";
    };
    patches = [
      ../development/perl-modules/Data-UUID-CVE-2013-4184.patch
    ];
    meta = {
      description = "Globally/Universally Unique Identifiers (GUIDs/UUIDs)";
      license = with lib.licenses; [ bsd0 ];
    };
  };

  DataUUIDMT = buildPerlPackage {
    pname = "Data-UUID-MT";
    version = "1.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz";
      hash = "sha256-MExLmBKDEfhLf1KccBi6hJx102Q6qA6jgrSwgFfEZy0=";
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
      hash = "sha256-RHDyU7jScgpN0/o65VCZVBfCJp875/8DDgGvoEo6lCE=";
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
      hash = "sha256-4aqSI13LnG/ZtsjNoYTRr3NTfMd/T4Og+IIHqL+/t9Y=";
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
      hash = "sha256-8GQY0qRgORPRts5SsWfdE+eH4TvyvjJaBl331Aj3nGA=";
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
      hash = "sha256-K7FpMou80tzO3Lk4Yn6HIOf0w/jjGCMCD7TCBQXTTG4=";
    };
    buildInputs = [ TestNeeds ];
    propagatedBuildInputs = [ Moose TieToObject namespaceclean ];
    meta = {
      description = "Visitor style traversal of Perl data structures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateCalc = buildPerlPackage {
    pname = "Date-Calc";
    version = "6.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.4.tar.gz";
      hash = "sha256-fOE3sueXt8CQHzrfGgWhk0M1bNHwRnaqHFap9iT4Wa0=";
    };
    propagatedBuildInputs = [ BitVector ];
    doCheck = false; # some of the checks rely on the year being <2015
    meta = {
      description = "Gregorian calendar date calculations";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateExtract = buildPerlPackage {
    pname = "Date-Extract";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Date-Extract-0.06.tar.gz";
      hash = "sha256-vHZY1cUMNSXsDvy1Ujal3i1dT8BvwUf6OSnI8JU82is=";
    };
    buildInputs = [ TestMockTime ];
    propagatedBuildInputs = [ DateTimeFormatNatural ];
    meta = {
      description = "Extract probable dates from strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateManip = buildPerlPackage {
    pname = "Date-Manip";
    version = "6.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-6.83.tar.gz";
      hash = "sha256-9JGy4dh2wiKllWOxu9iTwQNCB+0DNzBL85YxHZ6Rmfo=";
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

  DateRange = buildPerlPackage {
    pname = "Date-Range";
    version = "1.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMTM/Date-Range-1.41.tar.gz";
      hash = "sha256-v5iXSSsQHAUDh50Up+fr6QJUQ4NgGufGmpXedcvZSLk=";
    };
    propagatedBuildInputs = [ DateSimple ];
    meta = {
      description = "work with a range of dates";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  DateSimple = buildPerlPackage {
    pname = "Date-Simple";
    version = "3.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz";
      hash = "sha256-KaGSYxTOFoGjEtYVXClZDHcd2s+Rt0hYc85EnvIJ3QQ=";
    };
    meta = {
      description = "A simple date object";
      license = with lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  DateTime = buildPerlPackage {
    pname = "DateTime";
    version = "1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-1.54.tar.gz";
      hash = "sha256-sS7abZAHE/Inlk3E3A4u+4bSlOi8Lxa+npW2WflTsuc=";
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
      hash = "sha256-RouCo0qopmY/sFWAnu2KcAx6PM8mfgKWl1cboypsJUk=";
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
      hash = "sha256-U9pDhO9c8w7ofcATH0tu7iEhzA66NHFioyi5vPr0deo=";
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
      hash = "sha256-+UCHiaRhEHdmyhojK7PsHnAu7HyoFnQB6m7D9LbQtaU=";
    };
    propagatedBuildInputs = [ DateTimeSet ];
    meta = {
      description = "DateTime::Set extension for create basic recurrence sets";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatBuilder = buildPerlPackage {
    pname = "DateTime-Format-Builder";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz";
      hash = "sha256-Yf+yPYWzyheGstoyiembV+BiX+DknbAqbcDLYsaJ4vI=";
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
      hash = "sha256-9uykyL5mzpmS7hUJMvj88HgJ/T0WZMryALil/Tp+Xrw=";
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
      hash = "sha256-UKe5/rKHuxSycyOlPCMkSGGBo6tss/THZi1CvpAa2O4=";
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
      hash = "sha256-0E52nfRZaN/S0b3GR6Mlxod2FAaXYnhubxN/H17D2EA=";
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
      hash = "sha256-iwn2U59enA3w5hNQMWme1O+e74Fl/ICu/uzIF++ZfDM=";
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
      hash = "sha256-FJdow2i5134fJdM5bH8D4kKRAB/RTCxdq2p2JbKm2qk=";
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
      hash = "sha256-jfjjXER3OI/1x86LPotq5O0wIJx6UFHUFze9FNdV/LA=";
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
      hash = "sha256-c4+w+xTkL/rhQqMi9J9HHIzBImlM++bTNYA2MgP0RVI=";
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
      hash = "sha256-mBjUFi7JzsYTm6l7OeBInSF1gaHUP7txPzvv/oD5jx0=";
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
      hash = "sha256-f4YupeUb1Fvrxsb5cISXuYlkky5aOevK/jQCNRzgUZs=";
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
      hash = "sha256-L6Q8g47PU1byIakaQcgduiLnhgxUdLSmFyMlmJgXPko=";
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
      hash = "sha256-zB9OCuHTmw1MPd3M/XQjx3xnpwlQxLXsq/jKVTqylLQ=";
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
      hash = "sha256-aaArZhu/HaoUpIE8tnhuqmbb3ydD8LP0WOMCNMOiYmg=";
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
      hash = "sha256-bGBNjFycJzm3jgU4pAIoO4Kx30GeYL7yCwSEPkWEut4=";
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
      hash = "sha256-E27hIkwxxuAXaSqfXlb9tPcKlfRq7DrYVdN4PeNaDfc=";
    };
    propagatedBuildInputs = [ DateTime ];
    meta = {
      description = "Parse and format RFC3339 datetime strings";
      homepage = "https://search.cpan.org/dist/DateTime-Format-RFC3339";
      license = with lib.licenses; [ cc0 ];
    };
  };

  DateTimeSet = buildPerlModule {
    pname = "DateTime-Set";
    version = "0.3900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Set-0.3900.tar.gz";
      hash = "sha256-lPQcOSSq/eTvf6a1jgWV1AONisX/1iuhEbE8X028CUY=";
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
      hash = "sha256-Vz3UBZot/Tgz1qfSvwhHeKxllaAJsR3qY2DX0CLORSY=";
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
      hash = "sha256-F+bSAuesYElSMEjpe7jxlePHkghXDaFQT0MTWE5Ienk=";
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
      hash = "sha256-pN1dLNfbjqbkhhsZPgJLQYeisO0rmdWHBi37EaXNLLc=";
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
      hash = "sha256-JxbZsfBWJ9YJQs4GNLnBolEJsWSBgoXUW2Ca6FluKxc=";
    };
    propagatedBuildInputs = [ AnyEvent CompressLZF JSONXS commonsense ];
    meta = {
      description = "Deliantra suppport module to read/write archetypes, maps etc";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCaller = buildPerlPackage {
    pname = "Devel-Caller";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.07.tar.gz";
      hash = "sha256-tnmisYA0sLcg3oLDcIckw2SxCmyhZMvGfNw68oPzUD8=";
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
      hash = "sha256-FX89tZwp7R1JEzpGnO53LIha1O5k6GkqkbPr/b4v4+Q=";
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
      hash = "sha256-dot2l7S41NNyx1B7ZendJqpCI/cQAYO7tNOvRtQ4abU=";
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
      hash = "sha256-8hxeKZrTzg/cDLD0E3jcqFpw6NbJp1mfDlapVyAOwpQ=";
    };
    buildInputs = [ CaptureTiny MockConfig ];
    meta = {
      description = "Check that a library is available";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCheckOS = buildPerlPackage {
    pname = "Devel-CheckOS";
    version = "1.85";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Devel-CheckOS-1.85.tar.gz";
      hash = "sha256-b0Op2h3G+v2qybYbg80C2IO/Yq7xUck5hr75inrmWMo=";
    };
    propagatedBuildInputs = [ FileFindRule ];
    meta = {
      description = "Check what OS we're running on";
      license = with lib.licenses; [ gpl2Only artistic1 ];
    };
  };

  DevelLeak = buildPerlPackage rec {
    pname = "Devel-Leak";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NI-S/Devel-Leak-0.03.tar.gz";
      hash = "sha256-b0LDTxHitOPqLg5rlBaoimha3UR5EMr02R3SwXgXclI=";
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
      hash = "sha256-acbpcBYmD0COnX5Ej5QrNqbUnfWvBzQPHWXX4jAWdBk=";
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
      hash = "sha256-tlTUaWPRqIFCa6FZlPKPUuuDmw0TW/I5tNG/OLHKyko=";
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
      hash = "sha256-8Z0ExG8uWQpBHCMAeew2KEsucaDAv3oExXARMHqtgZs=";
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
      hash = "sha256-9QHK93b/fphvduAlRNbOI0yJdwFzKD8x333MV4AKOGg=";
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
      hash = "sha256-xCGCqahImjFMv+bhyEUvMrO2Jqpsif7h2JJebftk+tU=";
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
      hash = "sha256-SzZ+YbH63ed/tvtynzzVrNHUbnEhjZb0Bry6ONQ7S+8=";
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
      hash = "sha256-WmLB0Jvmu+IDmZTxCNhPQtJKh9KkAcXolNtayiF7MJs=";
    };
    propagatedBuildInputs = [ DBI SQLStatement TextCSV_XS ];
    meta = {
      description = "DBI driver for CSV files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBDMock = buildPerlModule {
    pname = "DBD-Mock";
    version = "1.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JL/JLCOOPER/DBD-Mock-1.58.tar.gz";
      hash = "sha256-ux6/ASQQE5blu4PerQ8U8S3V8XXLE3ilnaUpXGLJxzw=";
    };
    propagatedBuildInputs = [ DBI ];
    buildInputs = [ ModuleBuildTiny TestException ];
    meta = {
      description = "Mock database driver for testing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBDSQLite = buildPerlPackage {
    pname = "DBD-SQLite";
    version = "1.70";

    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.70.tar.gz";
      hash = "sha256-QP2N31OeDnc6ek5tN2eUwzAUWfmrAFCXi9z5cRPa/j4=";
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
        hash = "sha256-nn4JvaIGlr2lUnUC+0ABe9AFrRrC5bfdTQiefo0Pjwo=";
      })
    ];

    makeMakerFlags = [ "SQLITE_INC=${pkgs.sqlite.dev}/include" "SQLITE_LIB=${pkgs.sqlite.out}/lib" ];

    postInstall = ''
      # Get rid of a pointless copy of the SQLite sources.
      rm -rf $out/${perl.libPrefix}/*/*/auto/share
    '';

    preCheck = "rm t/65_db_config.t"; # do not run failing tests

    meta = {
      description = "Self Contained SQLite RDBMS in a DBI Driver";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.unix;
    };
  };

  DBDMariaDB = buildPerlPackage {
    pname = "DBD-MariaDB";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PALI/DBD-MariaDB-1.22.tar.gz";
      hash = "sha256-C2j9VCuWU/FbIFhXgZhjSNcehafjhD8JGZdwR6F5scY=";
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
      hash = "sha256-T0hUH/FaCnQF92rcEPgWJ8M5lvv1bJXCbAlERMCSjXg=";
    };

    buildInputs = [ pkgs.libmysqlclient DevelChecklib TestDeep TestDistManifest TestPod ];
    propagatedBuildInputs = [ DBI ];

    doCheck = false;

  #  makeMakerFlags = "MYSQL_HOME=${mysql}";
    meta = {
      description = "MySQL driver for the Perl5 Database Interface (DBI)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBDOracle = buildPerlPackage {
    pname = "DBD-Oracle";
    version = "1.80";

    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJEVANS/DBD-Oracle-1.80.tar.gz";
      hash = "sha256-8F4lKCNuPRNWXAuRI54HdZTb8GV6xZSY9Uov7psZ6uc=";
    };

    ORACLE_HOME = "${pkgs.oracle-instantclient.lib}/lib";

    buildInputs = [ pkgs.oracle-instantclient TestNoWarnings ];
    propagatedBuildInputs = [ DBI ];

    postBuild = lib.optionalString stdenv.isDarwin ''
      install_name_tool -add_rpath "${pkgs.oracle-instantclient.lib}/lib" blib/arch/auto/DBD/Oracle/Oracle.bundle
    '';
    meta = {
      description = "Oracle database driver for the DBI module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBDPg = buildPerlPackage {
    pname = "DBD-Pg";
    version = "3.14.2";

    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TU/TURNSTEP/DBD-Pg-3.14.2.tar.gz";
      hash = "sha256-yXPphFiWCnjsVAMqcbOEDxeEGN1+adBj5GKg8Q7Gjk0=";
    };

    buildInputs = [ pkgs.postgresql ];
    propagatedBuildInputs = [ DBI ];

    makeMakerFlags = [ "POSTGRES_HOME=${pkgs.postgresql}" ];

    # tests freeze in a sandbox
    doCheck = false;

    meta = {
      description = "DBI PostgreSQL interface";
      homepage = "https://search.cpan.org/dist/DBD-Pg";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.unix;
    };
  };

  DBDsybase = buildPerlPackage {
    pname = "DBD-Sybase";
    version = "1.16";

    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ME/MEWP/DBD-Sybase-1.16.tar.gz";
      hash = "sha256-Z/Qn6Lf/rirMPMiYRGPYeKu7Iom8F9t5opTlbIMR1sw=";
    };

    SYBASE = pkgs.freetds;

    buildInputs = [ pkgs.freetds ];
    propagatedBuildInputs = [ DBI ];

    doCheck = false;

    meta = {
      description = "DBI driver for Sybase datasources";
      license = with lib.licenses; [ artistic1 gpl1Only ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.DBDsybase.x86_64-darwin
    };
  };

  DBFile = buildPerlPackage {
    pname = "DB_File";
    version = "1.855";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/DB_File-1.855.tar.gz";
      hash = "sha256-2f/iolvmzf7no01kI1zciZ6Zuos/uN6Knn9K8g5MqWA=";
    };

    preConfigure = ''
      cat > config.in <<EOF
      PREFIX = size_t
      HASH = u_int32_t
      LIB = ${pkgs.db.out}/lib
      INCLUDE = ${pkgs.db.dev}/include
      EOF
    '';
    meta = {
      description = "Perl5 access to Berkeley DB version 1.x";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBI = buildPerlPackage {
    pname = "DBI";
    version = "1.643";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/DBI-1.643.tar.gz";
      hash = "sha256-iiuZPbVgosNzwXTul2pRAn3XgOx2auF2IMIDk9LoNvo=";
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
      homepage = "https://dbi.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBICxTestDatabase = buildPerlPackage {
    pname = "DBICx-TestDatabase";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/DBICx-TestDatabase-0.05.tar.gz";
      hash = "sha256-jjvCUwsBIWGIw6plrNvS9ZxOYx864IXfxDmr2J+PCs8=";
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
      hash = "sha256-NB4Lbssp2MSRdKbAnXxtvzhym6QBXuf9cDYKT/7h8lE=";
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
      hash = "sha256-uKIpp7FfVZCV1FYc+CIEYBKFQbp/w1Re01hpkj1GVlw=";
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
      hash = "sha256-NwhSMqEjClqodUOZ+1mw+PzV9Zeh4uNIxSJ0YaGSYiU=";
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
      hash = "sha256-Io9RqyJGQlhLTcY9tt4mZ8W/riqJSpN2shChBIBqWvs=";
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
      hash = "sha256-QUJ1YyFu31qTllCQrg4chaldN6gdcg8CwTYM+n208Bc=";
    };
    propagatedBuildInputs = [ DBIxClass HTMLWidget ];
    meta = {
      description = "Like FromForm but with DBIx::Class and HTML::Widget";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassHelpers = buildPerlPackage {
    pname = "DBIx-Class-Helpers";
    version = "2.036000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/DBIx-Class-Helpers-2.036000.tar.gz";
      hash = "sha256-t7i0iRqYPANO8LRfQRJASgpAVQxOIX2ut6IsoWhh79s=";
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
      hash = "sha256-YmK0hx22psRaDL583o8biQsiwpGt1OzEDKruq1o6b1A=";
    };
    buildInputs = [ DBDSQLite TestException ];
    propagatedBuildInputs = [ DBIxClass JSONMaybeXS YAML ];
    meta = {
      description = "Inflators to serialize data structures for DBIx::Class";
      homepage = "https://metacpan.org/release/DBIx-Class-InflateColumn-Serializer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  DBIxClassIntrospectableM2M = buildPerlPackage {
    pname = "DBIx-Class-IntrospectableM2M";
    version = "0.001002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/DBIx-Class-IntrospectableM2M-0.001002.tar.gz";
      hash = "sha256-xrqvtCQWk/2zSynr2QaZOt02S/Mar6RGLz4GIgTMh/A=";
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
      hash = "sha256-6GnN3hN4z+vM8imwzeWNJ0bcYIC3X1bQcqpfH852p2Q=";
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
      hash = "sha256-V8CNLBlRSGy5XPuD9Rj0YqPb8g01Pz7uT0avRPoZw1k=";
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
      hash = "sha256-eiqXj7bZ/qo+SxCcccljsmoAii0TDFh27PJMWnIzih0=";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Database-independent schema objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxSearchBuilder = buildPerlPackage {
    pname = "DBIx-SearchBuilder";
    version = "1.71";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/DBIx-SearchBuilder-1.71.tar.gz";
      hash = "sha256-5C/dpvbmSSe7h3dIPlZtaDA6iwkY0YjKD+VRo6PUQr0=";
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
      hash = "sha256-RtMRqizgiQdAHFYRllhCbbsETFpA3nPZp7eb9QOQyuM=";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Very complete easy-to-use OO interface to DBI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBMDeep = buildPerlPackage {
    pname = "DBM-Deep";
    version = "2.0016";
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/S/SP/SPROUT/DBM-Deep-2.0016.tar.gz";
      hash = "sha256-kCp8eqBIjY0KDops89oOlrQJOuRx5rdy8MbViY5HDk0=";
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
      hash = "sha256-SCGi3hCscQj03LKEpxuHaYGwyx6mxe1q+xd78ufLjXM=";
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
      hash = "sha256-Kz0Jt7zzifwRYgeyg77iUONI1EycY0YL7mfvq03SG7Q=";
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
      hash = "sha256-lqlNLMaQwfqP00ET47CEvypGmjI6l4AoWu+S3cOB5jo=";
    };

    propagatedBuildInputs = [ DBI Moo ];
    buildInputs = [ DBDSQLite TestFatal TestRoo ];
    meta = {
      description = "Detect what database you are connected to";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCamelcadedb = buildPerlPackage {
    pname = "Devel-Camelcadedb";
    version = "2021.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HU/HURRICUP/Devel-Camelcadedb-v2021.2.tar.gz";
      hash = "sha256-iKHZ6V05j/5NQRSGHiHDb3wiMVs9A+f3ZMy84BirPkc=";
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
      hash = "sha256-/TNlxNiYsrK927eKRtUHoYzKhJCikBmVR9q38ec5C8I=";
    };
    meta = {
      description = "Find memory cycles in objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelDeclare = buildPerlPackage {
    pname = "Devel-Declare";
    version = "0.006022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-Declare-0.006022.tar.gz";
      hash = "sha256-cvKco1ZGpZO+mDEf/dtyAzrh6KnYJUxiqiSL1iYOWW4=";
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
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Devel-FindPerl-0.016.tar.gz";
      hash = "sha256-Q6K/L3h6PxuIEXkGMWKyqj58sET25eduxkZq6QqGETg=";
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
      hash = "sha256-NLil8pmRMRRo/mkTytq6df1dKws+47tB/ltT76uRVKs=";
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
      hash = "sha256-jaMCL3ynHf2/SqYGmJRNcgCsMUn0c32KnJG/Q4f/MvU=";
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
      hash = "sha256-b8O7z08CU6blFoKWyQmTjBPIhpI6eZWslp5Hrfzwfss=";
    };
    meta = {
      description = "Forces the unavailability of specified Perl modules (for testing)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelNYTProf = buildPerlPackage {
    pname = "Devel-NYTProf";
    version = "6.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/Devel-NYTProf-6.12.tar.gz";
      hash = "sha256-qDtZheTalr24X1McFqtvPUkHGnM80JSqMPqF+2pLAsQ=";
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
      hash = "sha256-i/3i/6R8mUb4rcjPxEXC+XuNHN1ngRG+6fRE6C96puc=";
    };
    propagatedBuildInputs = [ MROCompat PackageStash SubIdentify ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Introspect overloaded operators";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelOverrideGlobalRequire = buildPerlPackage {
    pname = "Devel-OverrideGlobalRequire";
    version = "0.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Devel-OverrideGlobalRequire-0.001.tar.gz";
      hash = "sha256-B5GJLeOuKSr0qU44LyHbHuiCEIdQMYUebqgsNBB4Xvk=";
    };
    meta = {
      homepage = "https://metacpan.org/release/Devel-OverrideGlobalRequire";
      description = "Override CORE::GLOBAL::require safely";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPartialDump = buildPerlPackage {
    pname = "Devel-PartialDump";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-PartialDump-0.20.tar.gz";
      hash = "sha256-rvD/PqWalpGWfCiFEY/2ZxVghJVwicQ4j0nbZG/T2Qc=";
    };
    propagatedBuildInputs = [ ClassTiny SubExporter namespaceclean ];
    buildInputs = [ TestSimple13 TestWarnings ];
    meta = {
      description = "Partial dumping of data structures, optimized for argument printing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelStackTrace = buildPerlPackage {
    pname = "Devel-StackTrace";
    version = "2.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.04.tar.gz";
      hash = "sha256-zTwD7VR9PULGH6WBTJgpYTk5LnlxwJLgmkMfLJ9daFU=";
    };
    meta = {
      description = "An object representing a stack trace";
      homepage = "https://metacpan.org/release/Devel-StackTrace";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DevelSize = buildPerlPackage {
    pname = "Devel-Size";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWCLARK/Devel-Size-0.83.tar.gz";
      hash = "sha256-dXpn4KpZrhA+pcoJLL7MAlZE69wyZzFoj/q2+II+9LM=";
    };
    meta = {
      description = "Perl extension for finding the memory usage of Perl variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    pname = "Devel-StackTrace-AsHTML";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.15.tar.gz";
      hash = "sha256-YoPb4hl+LyAAnMS0SZl3Qhac3ZUb/ETLxuYsKpYtMUc=";
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
      hash = "sha256-gm+BoQf1WSolFnZu1DvrR+EMyD7cnqSAkLAqNgQHdsA=";
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
      hash = "sha256-EStQ9/vG9rr11FhO6X9ULO1snsA6MUf3kCyEuLJneMs=";
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
      hash = "sha256-O8csbT/xRNc677kOmnjTNhLVjPHNFjHs+4mFupbaSlk=";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      homepage = "https://metacpan.org/release/Digest-HMAC";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestJHash = buildPerlPackage {
    pname = "Digest-JHash";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Digest-JHash-0.10.tar.gz";
      hash = "sha256-x0bPCoYaAECQJjzVTXco0MdZWgz5DLv9hAmzlu47AGM=";
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
      hash = "sha256-0Kq/SDTCCsQRvqQnxKMItZpfyqMnZ571KUwdaKtx7tM=";
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
      hash = "sha256-ZlEQu6MkcPOY8xHNZGL9iXXXyDZ1/2dLwvbHtysMqqY=";
    };
    meta = {
      description = "Perl interface to the MD4 Algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestMD5File = buildPerlPackage {
    pname = "Digest-MD5-File";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/Digest-MD5-File-0.08.tar.gz";
      hash = "sha256-rbQ6VOMmJ7T35XyWQObrBtC7edjqVM0L157TVoj7Ehg=";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Perl extension for getting MD5 sums for files and urls";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestPerlMD5 = buildPerlPackage {
    pname = "Digest-Perl-MD5";
    version = "1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DELTA/Digest-Perl-MD5-1.9.tar.gz";
      hash = "sha256-cQDLoXEPRfsOkH2LGnvYyu81xkrNMdfyJa/1r/7s2bE=";
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
      hash = "sha256-aMHawhh0IfDrer9xRSoG8ZAYG4/Eso7e31uQKW+5Q8w=";
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
      hash = "sha256-Smi2fFA09A+7E0SzBM1myqpeMg61IwBSAcwk921HDBQ=";
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
      hash = "sha256-VITN/m68OYwkZfeBx3w++1OKOULNSyDWiBjG//kHT8c=";
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
      hash = "sha256-hP9yJoc9XoZW7Hc0TAg4wVOp8BW0a2Dh/oeYuykn5QU=";
    };
    propagatedBuildInputs = [ Moo PathTiny ];
    meta = {
      description = "Treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs";
      homepage = "https://metacpan.org/release/Dir-Manifest";
      license = with lib.licenses; [ mit ];
    };
  };

  DirSelf = buildPerlPackage {
    pname = "Dir-Self";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Dir-Self-0.11.tar.gz";
      hash = "sha256-4lGlGrx9m6PnCPc8KqII4J1HoMUo1iVHEPp4zI1ohbU=";
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
      hash = "sha256-1020Oxr56L1G/8Fb/k3x5dgQxCzoWC6TdRDcKiyhZYI=";
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
      hash = "sha256-6oRLlobJTWZtnURDIddkSQss3i+YXEFltMLHdmXK7cQ=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Declare version conflicts for your dist";
      homepage = "https://metacpan.org/release/Dist-CheckConflicts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZilla = buildPerlPackage {
    pname = "Dist-Zilla";
    version = "6.017";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-6.017.tar.gz";
      hash = "sha256-XI0wzjOsi16Tfm+D/Pp3nnIlyhSZUe5cm8LDrzwrb+4=";
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
      homepage = "https://dzil.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "dzil";
    };
  };

  DistZillaPluginBundleTestingMania = buildPerlModule {
    pname = "Dist-Zilla-PluginBundle-TestingMania";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-PluginBundle-TestingMania-0.25.tar.gz";
      hash = "sha256-XguywA8UD9ZNy9EvpdPJ4kS5NWgor0ZRmLYjBGnUWRw=";
    };
    buildInputs = [ MooseAutobox TestCPANMeta TestPerlCritic TestVersion ];
    propagatedBuildInputs = [ DistZillaPluginMojibakeTests DistZillaPluginTestCPANChanges DistZillaPluginTestCPANMetaJSON DistZillaPluginTestCompile DistZillaPluginTestDistManifest DistZillaPluginTestEOL DistZillaPluginTestKwalitee DistZillaPluginTestMinimumVersion DistZillaPluginTestNoTabs DistZillaPluginTestPerlCritic DistZillaPluginTestPodLinkCheck DistZillaPluginTestPortability DistZillaPluginTestSynopsis DistZillaPluginTestUnusedVars DistZillaPluginTestVersion PodCoverageTrustPod ];
    doCheck = false; /* fails with 'open3: exec of .. perl .. failed: Argument list too long at .../TAP/Parser/Iterator/Process.pm line 165.' */
    meta = {
      description = "Test your dist with every testing plugin conceivable";
      homepage = "https://metacpan.org/release/Dist-Zilla-PluginBundle-TestingMania";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginCheckChangeLog = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-CheckChangeLog";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FA/FAYLAND/Dist-Zilla-Plugin-CheckChangeLog-0.05.tar.gz";
      hash = "sha256-sLNNbXC1bxlE0DxfDcO49vJEdMgW0HtlehFsaSwuBSo=";
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
      hash = "sha256-8f/1R+okqPekg0Bqcu1sQFjXRtna6WNyVQLdugJas4A=";
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
      hash = "sha256-H9njgz8qEsTQSQ9FXgb2gZ87+Bt1I46kSOKToo2IwTk=";
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
      hash = "sha256-1E8nmZIveLKnlh7YkSPhG913q/6FuiBA2CuArXLtE7w=";
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
      hash = "sha256-nKrXs2bqWRGa1zzdmdzdU/h3pRW9AWT8KLM5wBc5qAE=";
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
      hash = "sha256-IVs6XDxYyLqw6icTBEG72uxzfuzADwZwk39gi9v2SAY=";
    };
    buildInputs = [ CPANChanges TestDeep ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for your changelog";
      homepage = "https://metacpan.org/release/Dist-Zilla-Plugin-Test-CPAN-Changes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANMetaJSON = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-CPAN-Meta-JSON";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.004.tar.gz";
      hash = "sha256-Clc+HVZAN05u5NVtT7lKPGfU511Ss93q5wz6ZFDhryI=";
    };
    buildInputs = [ MooseAutobox TestCPANMetaJSON TestDeep ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Validate your CPAN META.json files";
      homepage = "https://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Meta::JSON";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  DistZillaPluginTestCompile = buildPerlModule {
    pname = "Dist-Zilla-Plugin-Test-Compile";
    version = "2.058";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Compile-2.058.tar.gz";
      hash = "sha256-0M+T5SXxAuyg9/OWcSTS5Z0KIS9zjOVMHd2R3aJo2Io=";
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
      hash = "sha256-Twrye7OHRdLex9lBvPdJ5tf76vjnvPinmhMQqWObD2U=";
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
      hash = "sha256-orlZx6AszDLt1D7lhgmHVhPv1Ty8u9YDmeF/FUZ6Qzg=";
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
      hash = "sha256-vdvPzHXo6y0tnIYRVS8AzcGwUfDwB5hiO4aS/1Awry8=";
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
      hash = "sha256-uLcfS2S2ifS2R6OofWqqrkWmiJLTXja6qXb2BXNjcPs=";
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
      hash = "sha256-G2EMQpFpKbtwFDw2t55XF1JbDp3njj1GCal4ZCtk0KQ=";
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
      hash = "sha256-klC1nV3Brkxok7p4O9PwUTGxT/npGvtFVTFPVSaKOCU=";
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
      hash = "sha256-Ml0jbaCUA4jSqobsXBMmUWtK1Fre+Oek+Du5HV7hVJA=";
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
      hash = "sha256-4I/1vZ4kz5UDBVMwFIkTgI2Ro9/jIKK9+LD8Y4cZsXk=";
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
      hash = "sha256-59XiUwzYpbtarfPhZpplOqqW4yyte9a5yrprQlzqtWM=";
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
      hash = "sha256-6gGZo6AEMhPdwTJQi57ZsTHvcXc1uPk9eCkRkdBLQ8I=";
    };
    buildInputs = [ TestDeep TestOutput TestVars ];
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Release tests for unused variables";
      homepage = "https://metacpan.org/release/Dist-Zilla-Plugin-Test-UnusedVars";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestVersion = buildPerlPackage {
    pname = "Dist-Zilla-Plugin-Test-Version";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Dist-Zilla-Plugin-Test-Version-1.09.tar.gz";
      hash = "sha256-ckBQhzG8G/bfrXcB7GVFChjvkkWlIasm69ass5qevhc=";
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
      hash = "sha256-/jpEuVhtrxJ3/Lu69yFrAs4j77vWlPDfEbf3U0S+TpY=";
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
      hash = "sha256-BMenzEURYX16cMTKQQ0QcH3EliSM2tICQK4kIiMhJFQ=";
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
      hash = "sha256-0x08p9ZyvZKBg8y/KdMnXqWU99Mkrl9J22GClnxassc=";
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
      hash = "sha256-/HFprLbEPffwBefvatCO6MputnlrXRYEWTyZczfMgkA=";
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
      hash = "sha256-D6N4UpjML2eA5j46X7HKgU3Lw2DOtZ7Y+oTrT/oG+e8=";
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
      hash = "sha256-MFuUx3gBHO5w2fIVFNkumF+p3Mu4TGR5jwwfCyTrhw4=";
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
      hash = "sha256-mV9tBKe0h91eG1XjtSythMh3UJN8lv624k6PHxDNWT4=";
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
      hash = "sha256-V5xhfjA7nYdEEce2G0a1nTb4FXGGJQdK5oMue7nbUQQ=";
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
      hash = "sha256-uk/YCsUBfW0TLgNYx4aw7NHHrcvu5cGfs9opZHkaVvA=";
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
      hash = "sha256-7EJd2/OV4OGsfG+VtJM8VcV6yfHnUUADx8kE7GzTQrg=";
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
      hash = "sha256-Owrfa7QTz+Uddfi6eayoDer8mNwReap7LXp5r/Wmq5w=";
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
      hash = "sha256-3LmLCdw+j3V+w4gqQjRUgQi7LRLjz635WibO84Gp54k=";
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
      hash = "sha256-QtFkrH/03C6oSOcQ/iH6hVCaO8u5HtLTVuSrqVHtiDU=";
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
      hash = "sha256-THEEVQezHshT3WAVK0DjO6N0F3nA9JuxQ7UM+NJDq1w=";
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
      hash = "sha256-S77JM1WNfMm4FSutht0xPeJ3ohqJtOqD2E5hWH6V28Y=";
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
      hash = "sha256-kiIClZ94m6tztu4mQAes+49UORNJb8y2cWGC5Nrlw4A=";
    };
    propagatedBuildInputs = [ EmailMIME EmailSender IOAll IOString OLEStorage_Lite ];
    preCheck = "rm t/internals.t t/plain_jpeg_attached.t"; # these tests expect EmailMIME version 1.946 and fail with 1.949 (the output difference in benign)
    meta = {
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
      hash = "sha256-FEvYbPdo6nkQfKDpkpGoGM4738/qebtfbaE3nMfV2nk=";
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
      hash = "sha256-2F9jzRCI0RMREDZ2qM9Jj/9WSiAbU43lLNdTteXKi9Q=";
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
      hash = "sha256-0ACijvCWNpmx6ytORptYq3w6DPpKdDGeDnRhVuG9igs=";
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
      hash = "sha256-0CEIm2YqYOagyKvbcr2cXkaEjSSNmKmMHqKt3xqsE6I=";
    };
    propagatedBuildInputs = [ IOCaptureOutput MailTools NetDNS NetDomainTLD ];
    doCheck = false;
    meta = {
      description = "Check validity of Internet email addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailValidLoose = buildPerlPackage {
    pname = "Email-Valid-Loose";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Email-Valid-Loose-0.05.tar.gz";
      hash = "sha256-5xjnbt3uJAJRyZnhOcjL5vLMgBktpa+HXL0S+oq5Olk=";
    };
    propagatedBuildInputs = [ EmailValid ];
    meta = {
      description = "Email::Valid which allows dot before at mark";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Encode = buildPerlPackage {
    pname = "Encode";
    version = "3.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-3.19.tar.gz";
      hash = "sha256-kWP4SO72nk1MyIODl/CGH9nqft4AERfb2WlPjZUFLvU=";
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
      hash = "sha256-RUIG+n2C5V4DJ0aYcyNBtgcVDwDo4q7FjzUyagMIMtw=";
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
      hash = "sha256-g02JOqfbbOPxWK+9DkMtbtFaJ24JQNsKdL4T/ZxLu/E=";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    meta = {
      description = "An Encode::Encoding subclass that detects the encoding of data";
      license = with lib.licenses; [ mpl11 gpl2Plus lgpl2Plus ]; # taken from fedora
    };
  };


  EncodeEUCJPASCII = buildPerlPackage {
    pname = "Encode-EUCJPASCII";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz";
      hash = "sha256-+ZjTTVX9nILPkQeGoESNHt+mC/aOLCMGckymfGKd6GE=";
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
      hash = "sha256-H9SwbK2nCFgAOvFT+UyGOzuV8uPQO6GNBFGoHVHbRDo=";
    };
    meta = {
      description = "Extra sets of Chinese encodings";
      license = with lib.licenses; [ mit ];
    };
  };

  EncodeIMAPUTF7 = buildPerlPackage {
    pname = "Encode-IMAPUTF7";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMAKHOLM/Encode-IMAPUTF7-1.05.tar.gz";
      hash = "sha256-RwMF3cN0g8/o08FtE3cKKAEfYAv1V6y4w+B3OZl8N+E=";
    };
    nativeCheckInputs = [ TestNoWarnings ];
    meta = {
      description = "IMAP modified UTF-7 encoding";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeJIS2K = buildPerlPackage {
    pname = "Encode-JIS2K";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz";
      hash = "sha256-HshNcts53rTa1vypWs/MIQM/RaJNNHwg+aGmlolsNcw=";
    };
    outputs = [ "out" ];
    meta = {
      description = "JIS X 0212 (aka JIS 2000) Encodings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeLocale = buildPerlPackage {
    pname = "Encode-Locale";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz";
      hash = "sha256-F2+gJ3H1QqTvsdvCpMko6PQ5G/QHhHO9YEDY8RrbDsE=";
    };
    preCheck = if stdenv.isCygwin then ''
      sed -i"" -e "s@plan tests => 13@plan tests => 10@" t/env.t
      sed -i"" -e "s@ok(env(\"\\\x@#ok(env(\"\\\x@" t/env.t
      sed -i"" -e "s@ok(\$ENV{\"\\\x@#ok(\$ENV{\"\\\x@" t/env.t
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
      hash = "sha256-NLMfysjI/cghubNDSoLXEzIT73TM/yVf4UioavloN74=";
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
      hash = "sha256-yjrO7NuAtdRaoQ4c3o/sTpC0+MkYnHUE3YZY8HH3cZQ=";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ NetIDNEncode ];
    meta = {
      description = "Encode plugin for Punycode (RFC 3492)";
      homepage = "https://search.cpan.org/dist/Encode-Punycode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  enum = buildPerlPackage {
    pname = "enum";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/enum-1.11.tar.gz";
      hash = "sha256-0vNrUBXx419kAVmGe2C/XVzWa1bNXkLTP1Mb5o5e7jU=";
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
      hash = "sha256-2Uo9QS3yRq/cMaIZnL2K6RUWej9GhPe3AUzhIAJR67A=";
    };
    meta = {
      description = "Perl module that imports environment variables as scalars or arrays";
      homepage = "https://search.cpan.org/dist/Env";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EnvPath = buildPerlPackage {
    pname = "Env-Path";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz";
      hash = "sha256-JEvwk3mIMqfYQdnuW0sOa0iZlu72NUHlBQkao0qQFeI=";
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
      hash = "sha256-IOO1ZhwmVHSmnyiZR46ye5RkklWGu2tvtmYSnlgoMl8=";
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
      hash = "sha256-GiP3kTAyrtbUtoMhNzo4mcpmWQ9HJzkaCR7BnJW/etw=";
    };
    meta = {
      description = "Error/exception handling in an OO-ish way";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EV = buildPerlPackage {
    pname = "EV";
    version = "4.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/EV-4.33.tar.gz";
      hash = "sha256-Su6DkbiBE7Qhh/kf1JJF/cjpsZOhWsIC9RnKriqo6jU=";
    };
    buildInputs = [ CanaryStability ];
    propagatedBuildInputs = [ commonsense ];
    meta = {
      description = "Perl interface to libev, a high performance full-featured event loop";
      license = with lib.licenses; [ gpl1Plus ];
    };
  };

  EvalClosure = buildPerlPackage {
    pname = "Eval-Closure";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz";
      hash = "sha256-6glE8vXsmNiVvvbVA+bko3b+pjg6a8ZMdnDUb/IhjK0=";
    };
    buildInputs = [ TestFatal TestRequires ];
    meta = {
      description = "Safely and cleanly create closures via string eval";
      homepage = "https://metacpan.org/release/Eval-Closure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EvalSafe = buildPerlPackage rec {
    pname = "Eval-Safe";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATHIAS/Eval-Safe/Eval-Safe-${version}.tar.gz";
      hash = "sha256-VaUsIz4troYRP58Zs09hftz8hBb5vs5nEme9GBGxIRE=";
    };
    outputs = [ "out" ];
    meta = with lib; {
      description = "Simplified safe evaluation of Perl code";
      homepage = "https://github.com/mkende/perl-eval-safe";
      license = licenses.mit;
      maintainers = with maintainers; [ figsoda ];
    };
  };

  ExcelWriterXLSX = buildPerlPackage {
    pname = "Excel-Writer-XLSX";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/Excel-Writer-XLSX-1.09.tar.gz";
      hash = "sha256-1nnGrBnpPDKrd1lMeT5BuUjHuzhztgDnCtY30JPcoYc=";
    };
    propagatedBuildInputs = [ ArchiveZip ];
    meta = {
      description = "Create a new file in the Excel 2007+ XLSX format";
      homepage = "https://jmcnamara.github.com/excel-writer-xlsx";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "extract_vba";
    };
  };

  ExceptionBase = buildPerlModule {
    pname = "Exception-Base";
    version = "0.2501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Base-0.2501.tar.gz";
      hash = "sha256-VyPdePSsC00mKgXqRq9mPqANgJay6cCkNRXCEHYOHnU=";
    };
    buildInputs = [ TestUnitLite ];
    patches = [
      ../development/perl-modules/Exception-Base-remove-smartmatch-when-5.38.0.patch
    ];
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
      hash = "sha256-M/P7+LE407BOpOwLqD+w32uomIBrz07zk9TK/Boj7g0=";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
    meta = {
      description = "An Exception Object Class";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionDied = buildPerlModule {
    pname = "Exception-Died";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Died-0.06.tar.gz";
      hash = "sha256-NcRAvCr9TVfiQaDbG05o2dUpXfLbjXidObX0UQWXirU=";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
    meta = {
      description = "Convert simple die into real exception object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionWarning = buildPerlModule {
    pname = "Exception-Warning";
    version = "0.0401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Exception-Warning-0.0401.tar.gz";
      hash = "sha256-ezacps61se3ytdX4cOl0x8k+kwNnw5o5AL/2CZce06g=";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ];
    meta = {
      description = "Convert simple warn into real exception object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterDeclare = buildPerlModule {
    pname = "Exporter-Declare";
    version = "0.114";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Exporter-Declare-0.114.tar.gz";
      hash = "sha256-S9cNbKdvb2un5MYY1KyTuFk6WPEjPMvhixD18gTx1OQ=";
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
      hash = "sha256-wFs5Ca9MuG82SV6UpZnSPrq0K+ehjv0NFB/BWGMJ2sI=";
    };
    meta = {
      description = "Lightweight exporting of functions and variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    pname = "Exporter-Tiny";
    version = "1.002002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz";
      hash = "sha256-APC5VxaxgVcTLGwRje2LoxOSVj0Z5JBDPpplOC5wcQE=";
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
      hash = "sha256-CdknYUId7NSVhTEDN5FlqZ779FLHIPMCd2As8jZ5/QY=";
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
      hash = "sha256-r4O5IYXmQmlZE/8Tjv6Bl1LoCFd1mZber8qrJwCtXbU=";
    };
    propagatedBuildInputs = [ Expect ];
    meta = {
      description = "Wrapper around the Expect module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCChecker = buildPerlModule {
    pname = "ExtUtils-CChecker";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/ExtUtils-CChecker-0.11.tar.gz";
      hash = "sha256-EXc2Z343/GEfW3Y3TX+VLhlw64Dh9q1RUNUW565TG/U=";
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
      hash = "sha256-rlEE9jRlDc6KebftE/tZ1no5whOmd2z9qj7nSeYvGow=";
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
      hash = "sha256-aTPQ6WO2IoHvdWEGjmrsrIxKwrR2srugmrC5D7rJ11c=";
    };
    patches = [
      ../development/perl-modules/ExtUtils-Constant-fix-indirect-method-call-in-test.patch
    ];
    meta = {
      description = "Generate XS code to import C header constants";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsCppGuess = buildPerlPackage {
    pname = "ExtUtils-CppGuess";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/ExtUtils-CppGuess-0.21.tar.gz";
      hash = "sha256-/2KReDIaHlkbg/gJcSWT6uRAikE6pEhlS85ZsVbyQVM=";
    };
    doCheck = !stdenv.isDarwin;
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    propagatedBuildInputs = [ CaptureTiny ];
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Guess C++ compiler and flags";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsDepends = buildPerlPackage {
    pname = "ExtUtils-Depends";
    version = "0.8000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.8000.tar.gz";
      hash = "sha256-eA/3ISjATCoi5oARh6qcWMqymEB/bp0GJwavHCULvpg=";
    };
    meta = {
      description = "Easily build XS extensions that depend on XS extensions";
      license = with lib.licenses; [ artistic1 gpl1Plus artistic1 gpl1Plus ];
    };
  };

  ExtUtilsF77 = buildPerlPackage rec {
    pname = "ExtUtils-F77";
    version = "1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KG/KGB/ExtUtils-F77-1.24.tar.gz";
      hash = "sha256-NVh4pKf5AesY0h+eIb6Mi/xqr5Zl00skG8HUPjLFtzA=";
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
      hash = "sha256-3pAbZ5CkVXz07JCBSeA1eDsSW/EV65ZA/rG8HCTDNBY=";
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
      hash = "sha256-5d2He6I7Z7uybHhMR8/aHUEasaiZbu5ehNozPuZ+MMU=";
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
      hash = "sha256-hHNeMDe6sf3/o8JQhWetQSp4XJFZnbPBJZOlCh3UNO0=";
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
      hash = "sha256-xRFx4G3lMDnwvKHZemRx7DeUH/Weij0csXDr3SVztdI=";
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
      hash = "sha256-UCKthX/Xa9P2sWrwmf4jJGOdmTLgjyHokfsxPZyuFwU=";
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
      hash = "sha256-LAd2B9SwoQhWkHTf926BaGWQYq2jpq94swzKDUD44nU=";
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
      hash = "sha256-u+rO2ZXX2NEM/FGjpaZtpBzrK8BP7cq1DhDmMA6AHG4=";
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
      hash = "sha256-sbAVdy27BouToPb/oC9dlIIjZeYBisXtK8U8pmkHH8c=";
    };
    meta = {
      description = "Read/Write/Modify Perl/XS typemap files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsTypemapsDefault = buildPerlModule {
    pname = "ExtUtils-Typemaps-Default";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-Typemaps-Default-1.05.tar.gz";
      hash = "sha256-Pfr1g36/3AB4lb/KhMPC521Ymn0zZADo37MkPYGCFd4=";
    };
    meta = {
      description = "A set of useful typemaps";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsXSBuilder = buildPerlPackage {
    pname = "ExtUtils-XSBuilder";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz";
      hash = "sha256-jM7ThuPVRMXsLes67QVbcuvPwuqabIB9qHxCRScv6Ao=";
    };
    propagatedBuildInputs = [ ParseRecDescent TieIxHash ];
    meta = {
      description = "Automatic Perl XS glue code generation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsXSpp = buildPerlModule {
    pname = "ExtUtils-XSpp";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-XSpp-0.18.tar.gz";
      hash = "sha256-kXatZGcp470nz3q/EUvt00JL/xumEYXPx9VPOpIjqP8=";
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
      hash = "sha256-KAldIT+zKknJwjKmhEg375Rdua1unmHkULTfTQjj7k8=";
    };
    buildInputs = [ ExceptionWarning TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionDied ];
    meta = {
      description = "Thrown when core function has a fatal error";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FCGI = buildPerlPackage {
    pname = "FCGI";
    version = "0.79";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/FCGI-0.79.tar.gz";
      hash = "sha256-jPpOGxT7jVrKoiztZyxq9owKjiXcKpaXoO1/Sk77NOQ=";
    };
    postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      sed -i '/use IO::File/d' Makefile.PL
    '';
    meta = {
      description = "Fast CGI module";
      license = with lib.licenses; [ oml ];
    };
  };

  FCGIClient = buildPerlModule {
    pname = "FCGI-Client";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/FCGI-Client-0.09.tar.gz";
      hash = "sha256-1TfLCc5aqz9Eemu0QV5GzAbv4BYRzVYom1WCvbRiIeg=";
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
      hash = "sha256-4clYwEJCehdeBR4ACPICXo7IBhPTx3UFl7+OUpsEQg4=";
    };
    meta = {
      description = "A perl-based FastCGI process manager";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  FFICheckLib = buildPerlPackage {
    pname = "FFI-CheckLib";
    version = "0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.27.tar.gz";
      hash = "sha256-jUQnR8JPzYVgEH7Z3rmCZYOPF7yFDLcjf4ttSCGZLXQ=";
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
      hash = "sha256-3OKOOTJ2LC/5KqUtkEBcBuiY6By3sWTMrolmrnfx3Ks=";
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
      hash = "sha256-GSvbHOdiZsamlKjpYtA5463uuCm2rB4j9QV/K1Bjkr0=";
    };
    buildInputs = [ Test2Suite TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ ModulePluggable Moo TypeTiny namespaceautoclean ];
    meta = {
      description = "Watch for changes to files, cross-platform style";
      license = with lib.licenses; [artistic2 ];
    };
  };

  Filechdir = buildPerlPackage {
    pname = "File-chdir";
    version = "0.1010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz";
      hash = "sha256-78Eh9AvXoPYvjsm4vHD39UCdgc1wXjcAhZbI78RFKwE=";
    };
    meta = {
      description = "A more sensible way to change directories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileBaseDir = buildPerlModule {
    version = "0.08";
    pname = "File-BaseDir";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KI/KIMRYAN/File-BaseDir-0.08.tar.gz";
      hash = "sha256-wGX80+LyKudpk3vMlxuR+AKU1QCfrBQL+6g799NTBeM=";
    };
    configurePhase = ''
      runHook preConfigure
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    propagatedBuildInputs = [ IPCSystemSimple ];
    buildInputs = [ FileWhich ];
    meta = {
      description = "Use the Freedesktop.org base directory specification";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileBOM = buildPerlModule {
    pname = "File-BOM";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTLAW/File-BOM-0.18.tar.gz";
      hash = "sha256-KO3EP8sRjhG8RYya6InVbTiMHZvCmZewCx3/2Fc4I6M=";
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
      hash = "sha256-ZvtBf4/4peW36iVgYVbnDiBIYcWfqMODGSW03T8VX4o=";
    };
    meta = {
      description = "Run many filetest checks on a tree";
      homepage = "https://search.cpan.org/dist/File-CheckTree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Filechmod = buildPerlPackage {
    pname = "File-chmod";
    version = "0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XE/XENO/File-chmod-0.42.tar.gz";
      hash = "sha256-bK+v/2i8hCFRaLVe3g0ZHctX+aMgG1HWHtsoWKJAd5U=";
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
      hash = "sha256-k0jKXFuI3q3MSDuTme98Lg/CUE+QWNtl88PFPEETmqc=";
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
      hash = "sha256-05cc94qDReOAQrIIu3s5y2lQgDhq9in0oE/9ZUnfEVc=";
    };
    buildInputs = [ PathTiny TestDeep TestFatal TestFile TestWarnings ];
    meta = {
      description = "Perl extension for recursively copying files and directories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileCopyRecursiveReduced = buildPerlPackage {
    pname = "File-Copy-Recursive-Reduced";
    version = "0.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/File-Copy-Recursive-Reduced-0.006.tar.gz";
      hash = "sha256-5hj5k6afQ1UgXFj///aYJgnyi0f2RuxuJE5BtcZwfiw=";
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
      hash = "sha256-z9l8znyWE+TladR4dKK1cE8b6eztLwc5yHByVpQ4KmI=";
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
      hash = "sha256-FpwB49ri9il2e+wanxzb1uxtcT0VAeCyeG5N0SNWNbg=";
    };
    propagatedBuildInputs = [ FileBaseDir URI ];
    meta = {
      description = "Object to handle .desktop files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileDirList = buildPerlPackage {
    version = "0.05";
    pname = "File-DirList";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TP/TPABA/File-DirList/File-DirList-0.05.tar.gz";
      sha256 = "sha256-mTt9dmLlV5hEih7azLmr0oHSvSO+fquZ9Wm44pYtO8M=";
    };
    preCheck = ''
      export HOME="$TMPDIR"
    '';
    meta = {
      description = "Provide a sorted list of directory content";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFindIterator = buildPerlPackage {
    pname = "File-Find-Iterator";
    version = "0.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TE/TEXMEC/File-Find-Iterator-0.4.tar.gz";
      hash = "sha256-orh6uXVqLlu2dK29OZN2Y+0gwoxxa/WhCVo8pE1Uqyw=";
    };
    propagatedBuildInputs = [ ClassIterator ];
    meta = {
      description = "Iterator interface for search files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFindObject = buildPerlModule {
    pname = "File-Find-Object";
    version = "0.3.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-0.3.5.tar.gz";
      hash = "sha256-3EEkq+ZNwSdOjopeW/nheiqSad66zkWBFbV0afHhapE=";
    };
    propagatedBuildInputs = [ ClassXSAccessor ];
    meta = {
      description = "An object oriented File::Find replacement";
      homepage = "https://metacpan.org/release/File-Find-Object";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  FileFindObjectRule = buildPerlModule {
    pname = "File-Find-Object-Rule";
    version = "0.0312";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-Rule-0.0312.tar.gz";
      hash = "sha256-Pgtsja32Ni5l8jEFMLG+Y37WqsETOZ0QxvkSnnNK//k=";
    };
    propagatedBuildInputs = [ FileFindObject NumberCompare TextGlob ];
    # restore t/sample-data which is corrupted by patching shebangs
    preCheck = ''
      tar xf $src */t/sample-data --strip-components=1
    '';
    meta = {
      description = "Alternative interface to File::Find::Object";
      homepage = "https://www.shlomifish.org/open-source/projects/File-Find-Object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "findorule";
    };
  };

  FileFindRule = buildPerlPackage {
    pname = "File-Find-Rule";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz";
      hash = "sha256-fm8WzDPrHyn/Jb7lHVE/S4qElHu/oY7bLTzECi1kyv4=";
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
      hash = "sha256-mkhDP4bgjOGOA1JuKYLeUhYuuQnRlzVGDwfu/K9GPqY=";
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
      hash = "sha256-LsvBmsZ6nmNchyqAeo0+qv9bq8BU8VoZHUfN/F8XanQ=";
    };
    propagatedBuildInputs = [ TextGlob ];
    meta = {
      description = "Nice wrapper for File::Find ala find(1)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileFnMatch = buildPerlPackage {
    pname = "File-FnMatch";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJP/File-FnMatch-0.02.tar.gz";
      hash = "sha256-liRUuOhr6osTK/ivNXV9DGqPXVmQFb1qXWjLeuep6RY=";
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
      hash = "sha256-Ri4VJ062J4UhQH6jAtnupyUs1EyrI4KHH33oM9X4VjI=";
    };
    meta = {
      description = "Find matches to a pattern in a series of files and related functions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  FileHandleUnget = buildPerlPackage {
    pname = "FileHandle-Unget";
    version = "0.1634";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/FileHandle-Unget-0.1634.tar.gz";
      hash = "sha256-OA80rTzl6exmHUxGi7M5IjHBYjF9QXLfN4FGtCqrF4U=";
    };
    buildInputs = [ FileSlurper TestCompile UNIVERSALrequire URI ];
    meta = {
      description = "FileHandle which supports multi-byte unget";
      homepage = "https://github.com/coppit/filehandle-unget";
      license = with lib.licenses; [ gpl2Only ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  FileHomeDir = buildPerlPackage {
    pname = "File-HomeDir";
    version = "1.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/File-HomeDir-1.006.tar.gz";
      hash = "sha256-WTc3xi3w9tq11BIuC0R2QXlFu2Jiwz7twAlmXvFUiFI=";
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
      hash = "sha256-wwxogCelL/T1jNadbY7zVHKnzxBtTOlOtzp5a6fH/6c=";
    };
    propagatedBuildInputs = [ CryptRijndael ];
    meta = {
      description = "Interface to KeePass V1 and V2 database files";
      license = with lib.licenses; [ gpl2Only gpl3Only ];
    };
  };

  Filelchown = buildPerlModule {
    pname = "File-lchown";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/File-lchown-0.02.tar.gz";
      hash = "sha256-oC+/KFQGqKTZOZKE8DLy1VxWl1FUwuFnS9EJg3uAluw=";
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
      hash = "sha256-Uuax3Hyy2HpM30OboUXguejPKMwmpIo8+Zd8g0Y5Z+4=";
    };
    buildInputs = [ pkgs.file ConfigAutoConf TestFatal ];
    makeMakerFlags = [ "--lib=${pkgs.file}/lib" ];
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
      hash = "sha256-FbOkhx4jFko28iY4G3TUUK9B8SzJSYX1kqZp/Kx7SP8=";
    };
    propagatedBuildInputs = [ HTTPDate ];
    meta = {
      description = "Parse directory listing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileLoadLines = buildPerlPackage {
    pname = "File-LoadLines";
    version = "1.021";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/File-LoadLines-1.021.tar.gz";
      hash = "sha256-mOQS98aSYRNPNLh4W926sxVrj0UlU9u1tWytaDuG//A=";
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
      hash = "sha256-4sbkv5C+O4Y7+07628sbSwKfx09OeUvYaWWsp+47qHI=";
    };
    doCheck = false; # Failed test 'desktop file is the right one'
    buildInputs = [ FileBaseDir FileDesktopEntry EncodeLocale ];
    meta = {
      description = "Determine file type from the file name";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileMMagic = buildPerlPackage {
    pname = "File-MMagic";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KN/KNOK/File-MMagic-1.30.tar.gz";
      hash = "sha256-zwwbHrKXBcAtl8KRNkgAnAvkLOk+wks2xpa/LU9evX4=";
    };
    meta = {
      description = "Guess file type from contents";
      license = with lib.licenses; [ asl20 ];
    };
  };

  FileMap = buildPerlModule {
    pname = "File-Map";
    version = "0.67";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/File-Map-0.67.tar.gz";
      hash = "sha256-Enhdvt/CzN+jjbTZenhGSSWRjbNy/Rm67PL6l68i+8I=";
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
      hash = "sha256-a1CxqrbsaZigF/ZAPCc1s7weHPRhh70TTX623z/EUUQ=";
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
      hash = "sha256-+QDLOVBetuFoqcpRoQtz8bveGRS5I6CezXLZwC5uwu8=";
    };
    meta = {
      description = "File-finding iterator";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  FileNFSLock = buildPerlPackage {
    pname = "File-NFSLock";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.29.tar.gz";
      hash = "sha256-YdQVmbSBFk7fm4vsq77y0j9iKpcn9sGDZekrV4LU+jc=";
    };
    meta = {
      description = "Perl module to do NFS (or not) locking";
      license = with lib.licenses; [ artistic1 gpl1Only ];
    };
  };

  FilePath = buildPerlPackage {
    pname = "File-Path";
    version = "2.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/File-Path-2.18.tar.gz";
      hash = "sha256-mA8KF+2zU99G6c17NX+fWSnN4PgMRf16Bs9+DovWrd0=";
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
      hash = "sha256-uv7uj9yW6wYwagxYu9tyCbbeRfhQ51/caxbbV24F5CI=";
    };
    patches = [(fetchpatch {
      name = "missing-pidfile.patch";
      url = "https://sources.debian.org/data/main/libf/libfile-pid-perl/1.01-2/debian/patches/missing-pidfile.patch";
      hash = "sha256-VBsIYyCnjcZLYQ2Uq2MKPK3kF2wiMKvnq0m727DoavM=";
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
      hash = "sha256-1zp/CUQpg7CYJg3z33qDKl9mB3OjE8onP6i1ZmX5fNw=";
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
      hash = "sha256-grJhr4dQfMPn5miZxFcQTryNHAn7hcU/Z8H5D3DxjW4=";
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
      hash = "sha256-6G4qQP/txtVpfQcVA/1roUpfm4IgrzrwIhENjnJPjKY=";
    };
    meta = {
      description = "Remove files and directories";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShare = buildPerlPackage {
    pname = "File-Share";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/File-Share-0.25.tar.gz";
      hash = "sha256-jp0lbgrEOEIoOEtK0qV4GaFj7bOfIJiO1cExjAFAcHA=";
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
      hash = "sha256-O7KiC6Nd+VjcCk8jBvwF2QPYuMTePIvu/OF3OdKByVg=";
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
      hash = "sha256-Rb798Nlcvv58JaHa8pPYX3gNbSV2FGVG5oKKrSblgPk=";
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
      hash = "sha256-/onLtCfg4F8c2Xwt1tOGasayG8eoVzTt4Vm9w1R5VSo=";
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
      hash = "sha256-H9pxLUul4YaBWe019vjvv66dQ11jdvVgbVM7ywgFVaQ=";
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
      hash = "sha256-/T5SxvYkEnGigTSNHUPEQVTC9hoyVD20aqnhVpLRtxM=";
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
      hash = "sha256-TDwhmSqdQr46ed10o8g9J9OAVyadZVCaL1VeoPsrxbA=";
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
      hash = "sha256-TvsupBaxEKG9pvgTNUnMbqNnZALjyvdSn84DEyUKpXg=";
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
      hash = "sha256-RSmVvuq/DpI+Zf3GJ6cl27EsnhDADYAYwW0QumJ1fx4=";
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
      hash = "sha256-JtCfgYNuQ+rkACjVKD/lYg/m/mJ4vz6462AMSOw0r8c=";
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
      hash = "sha256-43ml/4lCDPOZBuXO/zCbjOlY+Z+cPletUrUAKjmC2Tw=";
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
      hash = "sha256-01zZX+9X/U39iDH2LDTilNfEuGH8kJ4Ct2Bxc51S00E=";
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
      hash = "sha256-1EkQIYUNXFy9cCx+R0SFgHmEHS+pPxwtCd3Jp4Y2CN8=";
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
      hash = "sha256-0R3izl5vrT8GFLymR0ykScNa7TUSXVsyJ+ZpvBdv3Bw=";
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
      hash = "sha256-t53CJEstl7bycWf8O3eZ72GheQQPOr12zh4KOwvE4Hg=";
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
      hash = "sha256-HLHt3iCsCU7wA3lLr+8sdiQWnPhALHNn2bdGD2wOZps=";
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
      hash = "sha256-4R7y8u6HJ7f2Zv0kmjIm92jm6t/VHZzbSbPD8aNUZPk=";
    };
    meta = {
      description = "Source Filters";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FinanceQuote = buildPerlPackage rec {
    pname = "Finance-Quote";
    version = "1.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPSCHUCK/Finance-Quote-${version}.tar.gz";
      hash = "sha256-jN3qDTgJo2aVzuaaKGK+qs1hU1f+uv23JkGnerRna4A=";
    };
    buildInputs = [ DateManip DateRange DateSimple DateTime DateTimeFormatISO8601 StringUtil TestKwalitee TestPerlCritic TestPod TestPodCoverage ];
    propagatedBuildInputs = [ DateManip DateTimeFormatStrptime Encode HTMLTableExtract HTMLTokeParserSimple HTMLTree HTMLTreeBuilderXPath HTTPCookies JSON IOCompress IOString LWPProtocolHttps Readonly StringUtil SpreadsheetXLSX TextTemplate TryTiny WebScraper XMLLibXML libwwwperl ];
    meta = {
      homepage = "https://finance-quote.sourceforge.net/";
      changelog = "https://github.com/finance-quote/finance-quote/releases/tag/v${version}";
      description = "Get stock and mutual fund quotes from various exchanges";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = with lib.maintainers; [ nevivurn ];
    };
  };

  FindLib = buildPerlPackage {
    pname = "Find-Lib";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANNK/Find-Lib-1.04.tar.gz";
      hash = "sha256-HXOSHjBh4bBG/kJo4tBf/VpMV2Jmbi5HI/g6rMFG6FE=";
    };
    meta = {
      description = "Helper to smartly find libs to use in the filesystem tree";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FontAFM = buildPerlPackage {
    pname = "Font-AFM";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/Font-AFM-1.20.tar.gz";
      hash = "sha256-MmcRZtoyWWoPa6rNDBIzglpgrK8lgF15yBo/GNYIi8E=";
    };
    meta = {
      description = "Interface to Adobe Font Metrics files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FontTTF = buildPerlPackage {
    pname = "Font-TTF";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/Font-TTF-1.06.tar.gz";
      hash = "sha256-S2l9REJZdZ6gLSxELJv/5f/hTJIUCEoB90NpOpRMwpM=";
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
      hash = "sha256-M9tDV+Es1vQPKlijq5b+tP/9JedC29SL75B9skLQKk4=";
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
      hash = "sha256-/Dpj3FS5YtdFhgcBdq2vW+hp8JtWG7MPX9Mu9TF5JmY=";
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
      hash = "sha256-PF4IMpEG+c7jq0RLgTMcWTX4MIShUdiFBeekZdpUD0E=";
    };
    doCheck = false;
    meta = {
      description = "Converting Perl structures to strings and back";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FunctionParameters = buildPerlPackage {
    pname = "Function-Parameters";
    version = "2.001003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAUKE/Function-Parameters-2.001003.tar.gz";
      hash = "sha256-6qIsa0PAJJnsfbB1jC3SGKOyq0enFLK9+AELXuETwkI=";
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
      hash = "sha256-iHrPu7zcq71HQVD5v+nG5QfTUWdbhivM/XZ/6dMWqvM=";
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
      hash = "sha256-D+ixXBQvKjBKMXGKIKEFA6m0TMASw69eN7i34koHUqM=";
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
      hash = "sha256-OLtJ9jabBUrAUuaNomR/4i0Io605rgNuJ6KRELtOQi4=";
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
      hash = "sha256-dVM2JvgfdoxfIxyXAhBsJbV3KotplcqixYvMSsyRB8k=";
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
      hash = "sha256-5atHXIK6HLCIrSj0I8pRTUaUTWrjw+tV6WNunn8dyJM=";
    };
    buildInputs = [ DirManifest TestDifferences ];
    propagatedBuildInputs = [ ClassXSAccessor ExceptionClass PathTiny ];
    meta = {
      description = "Verify solutions for solitaire games";
      homepage = "https://metacpan.org/release/Games-Solitaire-Verify";
      license = with lib.licenses; [ mit ];
      mainProgram = "verify-solitaire-solution";
    };
  };

  GD = buildPerlPackage {
    pname = "GD";
    version = "2.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/GD-2.73.tar.gz";
      hash = "sha256-SRyecyOFIuKYfmZyWiCTX0Joo4ZCAuy69GWaFpG6Mis=";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype pkgs.libpng pkgs.fontconfig pkgs.xorg.libXpm ExtUtilsPkgConfig TestFork ];

    # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
    hardeningDisable = [ "format" ];

    makeMakerFlags = [ "--lib_png_path=${pkgs.libpng.out}" "--lib_jpeg_path=${pkgs.libjpeg.out}" "--lib_zlib_path=${pkgs.zlib.out}" "--lib_ft_path=${pkgs.freetype.out}" "--lib_fontconfig_path=${pkgs.fontconfig.lib}" "--lib_xpm_path=${pkgs.xorg.libXpm.out}" ];

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
      hash = "sha256-uW9cELZWwX0Wq2Whd3yQgpewKNO2gV9tVLIzfwBr+k8=";
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
      hash = "sha256-Pd4k2ay6lRzd5bVp0eQsrZRs/bUSgORGnzNv1f4MjqY=";
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
      hash = "sha256-iG7L+Fz+lPQTXuVonEhHqa54PsuZ5nWeEsc08t1hFrw=";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Text utilities for use with GD";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GeoIP = buildPerlPackage {
    pname = "Geo-IP";
    version = "1.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/Geo-IP-1.51.tar.gz";
      hash = "sha256-FjAgMV1cVEGDaseeCKd7Qo8nf9CQvqT6gNpwd7JDaro=";
    };
    makeMakerFlags = [ "LIBS=-L${pkgs.geoip}/lib" "INC=-I${pkgs.geoip}/include" ];
    doCheck = false; # seems to access the network
    meta = {
      description = "Look up location and network information by IP Address";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GeoIP2 = buildPerlPackage {
    pname = "GeoIP2";
    version = "2.006002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/GeoIP2-2.006002.tar.gz";
      hash = "sha256-CQVCqO7pvTwS5ZxLZWJMidAf/ZQgTx8Hah20CybAmDQ=";
    };
    propagatedBuildInputs = [ JSONMaybeXS LWPProtocolHttps MaxMindDBReader ParamsValidate Throwable ];
    buildInputs = [ PathClass TestFatal TestNumberDelta ];
    meta = {
      description = "Perl API for MaxMind's GeoIP2 web services and databases";
      homepage = "https://metacpan.org/release/GeoIP2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "web-service-request";
    };
  };

  GetoptArgvFile = buildPerlPackage {
    pname = "Getopt-ArgvFile";
    version = "1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTENZEL/Getopt-ArgvFile-1.11.tar.gz";
      hash = "sha256-NwmqUTzm/XHRpVoC400vCQAX1TUKm9RHAFZTybCDWyI=";
    };
    meta = {
      description = "Interpolates script options from files into @ARGV or another array";
      license = with lib.licenses; [ artistic1 ];
      maintainers = [ maintainers.pSub ];
    };
  };

  GetoptLong = buildPerlPackage {
    pname = "Getopt-Long";
    version = "2.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/Getopt-Long-2.52.tar.gz";
      hash = "sha256-ncenw3M1PVwF765UjnsSOqijHR9Qbrjbvsjw3Kd3Bfo=";
    };
    meta = {
      description = "Extended processing of command line options";
      license = with lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  GetoptLongDescriptive = buildPerlPackage {
    pname = "Getopt-Long-Descriptive";
    version = "0.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.105.tar.gz";
      hash = "sha256-pxzbz0BDWIsmpCoT0VHCQ/bszzjo/AsY/7W1NlGrjBU=";
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
      hash = "sha256-m98GdjO1kTEngg9OgDXtxT0INy+qzla6a/oAyWiiU3c=";
    };
    meta = {
      description = "Table-driven argument parsing for Perl 5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Git = buildPerlPackage {
    pname = "Git";
    version = "0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSOUTH/Git-0.42.tar.gz";
      hash = "sha256-lGmp85jzor8rBQBWbuQdP/b65GBBKhNxhXZ6HMR4Om0=";
    };
    propagatedBuildInputs = [ Error ];
    meta = {
      description = "This is the Git.pm, plus the other files in the perl/Git directory, from github's git/git";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  GitAutofixup = buildPerlPackage rec {
    pname = "App-Git-Autofixup";
    version = "0.003001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TORBIAK/App-Git-Autofixup-0.003001.tar.gz";
      hash = "sha256-F/ayRn/nnFksouFyx3vmICNlxK+hncifKhMNIT+o8eA=";
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
      hash = "sha256-mHx0NmzEw37ghAUPmF+iVDWcicElB/W4v8ZgfeU41ag=";
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
      hash = "sha256-gU360QSpVGNJ+eD9SSyGE33oJ+vChAF6kaUmfBIK1PY=";
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
      hash = "sha256-Y+gmTtNRyyNxtHhSpyNmIUFktfP62dvWgwnH/GPQZJE=";
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
      hash = "sha256-cxagwefMXLPbchEhT0XXvcI1Q2WmgKxL06yL8G0ctQA=";
    };
    buildInputs = [ pkgs.glib ];
    propagatedBuildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig ];
    meta = {
      description = "Perl wrappers for the GLib utility and Object libraries";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  GlibObjectIntrospection = buildPerlPackage {
    pname = "Glib-Object-Introspection";
    version = "0.049";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Glib-Object-Introspection-0.049.tar.gz";
      hash = "sha256-RkYoy53QKLEEOMI4kt5vijAgI1Wk5OsBv9E7jP41r1c=";
    };
    nativeCheckInputs = [ pkgs.cairo CairoGObject ];
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
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  Gnome2 = buildPerlPackage {
    pname = "Gnome2";
    version = "1.047";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gnome2-1.047.tar.gz";
      hash = "sha256-zMhcXcPBT5Fe0aGG0jhoHYP+89F+7RwgABSZ/1a2OQw=";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Glib Gnome2Canvas Gnome2VFS Gtk2 ];
    propagatedBuildInputs = [ pkgs.gnome2.libgnomeui ];
    meta = {
      description = "(DEPRECATED) Perl interface to the 2.x series of the GNOME libraries";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Gnome2Canvas.x86_64-darwin
    };
  };

  Gnome2Canvas = buildPerlPackage {
    pname = "Gnome2-Canvas";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/Gnome2-Canvas-1.004.tar.gz";
      hash = "sha256-ObezmyNdE85IhJ/QKnrNC4dIpLslXVtKLWkUjKtbgjw=";
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
      hash = "sha256-7Kl0Zp305/IbT87blsijKEIjacaLjCzZm5zpzF16eXk=";
    };
    propagatedBuildInputs = [ pkgs.gnome2.gnome_vfs Glib ];
    meta = {
      description = "(DEPRECATED) Perl interface to the 2.x series of the GNOME VFS";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  Gnome2Wnck = buildPerlPackage {
    pname = "Gnome2-Wnck";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TS/TSCH/Gnome2-Wnck-0.16.tar.gz";
      hash = "sha256-YEqOzoisKfEy1ZsMqsJ2V+wxNxwWBqRpiiFg6IrFhuU=";
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
      hash = "sha256-r1Py0/Yyl+BGZ26uFKdilq/dKRDglyO2sRNwhiK3mJs=";
    };
    buildInputs = [ pkgs.gnupg1orig ];
    doCheck = false;
    meta = {
      description = "Perl interface to the GNU Privacy Guard";
      license = with lib.licenses; [ gpl2Plus ];
      mainProgram = "gpgmailtunl";
    };
  };

  GnuPGInterface = buildPerlPackage {
    pname = "GnuPG-Interface";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/GnuPG-Interface-1.02.tar.gz";
      hash = "sha256-wnpIw9SOGpIF42Lu6mbUawMr2EY3mR/fCxOCi8r90+Y=";
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
      hash = "sha256-9z7/4+p6+hkHzol3yHOHq7DUQE+FpySuJjeymnMVSps=";
    };
    propagatedBuildInputs = [ DBI LWP mod_perl2 ];
    doCheck = false; # no make target 'test'
    meta = {
      description = "HTTP transport for DBI stateless proxy driver DBD::Gofer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GooCanvas = buildPerlPackage {
    pname = "Goo-Canvas";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YE/YEWENBIN/Goo-Canvas-0.06.tar.gz";
      hash = "sha256-DFiMUH7tXmLRLtHMHkkcb/Oh9ZxPs9Q14UIUs3qzklE=";
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
      hash = "sha256-4kyHhz4ZBj3U1eLHCcqs+MCuiIEEQ5W7hl3CtP3WO1A=";
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
      hash = "sha256-uoBnNuvMnePYFBp2Omgr3quxy4cCveKZrf1XSs6HUFI=";
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
      hash = "sha256-s4RJxguaJxLd5IFIXMerA7KgrBw/1ICzhT5BEawpTXE=";
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
      hash = "sha256-xs3V7kps3L2/MU2SpPmYXbzfnkJYBIyudhJcBSqjH3c=";
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
      hash = "sha256-wRNjODPzob74+o65ZoC+NtAOQe9AS93X/Au5hwPijU0=";
    };
    propagatedBuildInputs = [ HeapFibonacci SetObject ];
    meta = {
      description = "GRaph data structures and algorithms";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GraphicsColor = buildPerlPackage {
    pname = "Graphics-Color";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GP/GPHAT/Graphics-Color-0.31.tar.gz";
      hash = "sha256-+qj+1bLYDlFgr5duXbIkLAs1VVQs4QQldf9raUWHoz0=";
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
      hash = "sha256-Kv0JTCBGnvp8+cMmDjzuqd4Qw9r+BjOo0eJC405OOdg=";
    };
    buildInputs = [ pkgs.libtiff ExtUtilsDepends ExtUtilsPkgConfig ];
    propagatedBuildInputs = [ Readonly ];
    nativeCheckInputs = [ TestRequires TestDeep pkgs.hexdump ];
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
      hash = "sha256-2V76xM3u2xgoMQDv4+AMWcGt1STZzojByKNYNZEi9a0=";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz TestPod ];
    propagatedBuildInputs = [ FileWhich IPCRun ParseRecDescent XMLTwig XMLXPath ];

    meta = {
      description = "Perl interface to the GraphViz graphing tool";
      license = with lib.licenses; [artistic2 ];
    };
  };

  grepmail = buildPerlPackage {
    pname = "grepmail";
    version = "5.3111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/grepmail-5.3111.tar.gz";
      hash = "sha256-0JhOP3ob4XrgFFdfcMFngVGlvMliIYXcWgUstjJxp2E=";
    };
    buildInputs = [ FileHomeDir FileSlurper TestCompile UNIVERSALrequire URI ];
    propagatedBuildInputs = [ MailMboxMessageParser TimeDate ];
    outputs = [ "out" ];
    meta = {
      description = "Search mailboxes for mail matching a regular expression";
      homepage = "https://github.com/coppit/grepmail";
      license = with lib.licenses; [ gpl2Only ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  GrowlGNTP = buildPerlModule {
    pname = "Growl-GNTP";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/Growl-GNTP-0.21.tar.gz";
      hash = "sha256-KHl/jkJ0BnIFhMr9EOeAp47CtWnFVaGHQ9dFU9X1CD8=";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CryptCBC DataUUID ];
    meta = {
      description = "Perl implementation of GNTP Protocol (Client Part)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GSSAPI = buildPerlPackage {
    pname = "GSSAPI";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGROLMS/GSSAPI-0.28.tar.gz";
      hash = "sha256-fY8se2F2L7TsctLsKBKQ8vh/nH0pgnPaRSVDKmXncNY=";
    };
    propagatedBuildInputs = [ pkgs.krb5.dev ];
    makeMakerFlags = [ "--gssapiimpl" "${pkgs.krb5.dev}" ];
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
      hash = "sha256-ScRDdDsu7+EadoACck9/akxI78lP8806VZ+357aTyWc=";
    };
    buildInputs = [ pkgs.gtk2 ];
    # https://rt.cpan.org/Public/Bug/Display.html?id=130742
    # doCheck = !stdenv.isDarwin;
    doCheck = false;
    propagatedBuildInputs = [ Pango ];
    meta = {
      description = "Perl interface to the 2.x series of the Gimp Toolkit library";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  Gtk2TrayIcon = buildPerlPackage {
    pname = "Gtk2-TrayIcon";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORUP/Gtk2-TrayIcon-0.06.tar.gz";
      hash = "sha256-y7djK3XX9BVU3+jukGPb/R2FIikQd8ZdDYLpzrXpSuI=";
    };
    propagatedBuildInputs = [ pkgs.gtk2 Gtk2 ];
    meta = {
      description = "(DEPRECATED) Perl interface to the EggTrayIcon library";
      license = with lib.licenses; [ gpl2Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.Gtk2TrayIcon.x86_64-darwin
    };
  };

  Gtk2AppIndicator = buildPerlPackage {
    pname = "Gtk2-AppIndicator";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OE/OESTERHOL/Gtk2-AppIndicator-0.15.tar.gz";
      hash = "sha256-olywceIU+4m0RQqkYFAx6uibeWHhSbDW6PSRwZwUqQo=";
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
      hash = "sha256-CHGGw2k6zxlkUc9ZzIt/XPmnsFq+INMty8uggilT+4A=";
    };
    buildInputs = [ pkgs.gtkimageview pkgs.gtk2 ];
    propagatedBuildInputs = [ Gtk2 ];
    # Tests fail due to no display server:
    #   Gtk-WARNING **: cannot open display:  at /nix/store/HASH-perl-Gtk2-1.2498/lib/perl5/site_perl/5.22.2/x86_64-linux-thread-multi/Gtk2.pm line 126.
    #   t/animview.t ...........
    doCheck = false;
    meta = {
      description = "Perl bindings for the GtkImageView widget";
      license = with lib.licenses; [ lgpl3Plus ];
    };
  };

  Gtk2Unique = buildPerlPackage {
    pname = "Gtk2-Unique";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/POTYL/Gtk2-Unique-0.05.tar.gz";
      hash = "sha256-ro37D2hE3aos57W0RVNBlJDI6Dwk/TXEMUBqWPa+D08=";
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
      hash = "sha256-cNxL8qp0mBx54V/SmNmY4FqS66SBHxrVyfH03jdzesw=";
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
      hash = "sha256-vHfnBgaeZPK7hBgZcP1KjepG+IvsDE3XwrH9U4xoN+Y=";
    };
    buildInputs = [ pkgs.gtk3 ];
    propagatedBuildInputs = [ Readonly Gtk3 ];
    nativeCheckInputs = [ TestDifferences TestDeep ImageMagick TryTiny TestMockObject CarpAlways pkgs.librsvg ];
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
      hash = "sha256-HURlEAvzvAR0opRppAb9AzVituNzYYgSEAA3KrKtqIQ=";
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
      hash = "sha256-NMTd+R/JPRCQ2G2hTfcG0XWxYQxnNywB4SzpVV1N0dw=";
    };
    meta = {
      description = "Safe cleanup blocks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HamAPRSFAP = buildPerlPackage {
    pname = "Ham-APRS-FAP";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HE/HESSU/Ham-APRS-FAP-1.21.tar.gz";
      hash = "sha256-4BtFXUb0RxDbzyG2+oQ/CTWM5g7uHEFBvHTgogTToCA=";
    };
    propagatedBuildInputs = [ DateCalc ];
    meta = {
      description = "Finnish APRS Parser (Fabulous APRS Parser)";
      maintainers = with maintainers; [ andrew-d ];
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Hailo = buildPerlPackage {
    pname = "Hailo";
    version = "0.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AV/AVAR/Hailo-0.75.tar.gz";
      hash = "sha256-u6mcsM+j7oYy3YmQbG5voF/muzZ/IoLoiQnO/Y+RdMI=";
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
      homepage = "https://hailo.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "hailo";
    };
  };

  HashDiff = buildPerlPackage {
    pname = "Hash-Diff";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOLAV/Hash-Diff-0.010.tar.gz";
      hash = "sha256-vJpKo47JjwqYKJ41q/mhfC8qMjmiIJoymADglwqi4MU=";
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
      hash = "sha256-cMbEnYtsRgdGQXpQmO3SoP0x/YuGxUv4SS6FPB9OS5g=";
    };
    buildInputs = [ TestAssertions ];
    propagatedBuildInputs = [ LogTrace ];
    meta = {
      description = "Flatten/unflatten complex data hashes";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  HashMerge = buildPerlPackage {
    pname = "Hash-Merge";
    version = "0.302";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HE/HERMES/Hash-Merge-0.302.tar.gz";
      hash = "sha256-rgUi92U5YIth3eFGcOeWd+DzkQNoMvcKIfMa3eJThkQ=";
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
      hash = "sha256-HFYyeHPS8E1XInd/BEhj2WiRBGaZd0DVWnVAccYoe3M=";
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
      hash = "sha256-25qPuGfVB1PDgIiaXlQHVlG14IybO3IctyIMCINUfeg=";
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
      hash = "sha256-Zhgd96po4nhvr2iVyIsYuVyACo5Ob7TAf9F2QQo8c/Q=";
    };
    meta = {
      description = "Store multiple values per key";
      homepage = "https://github.com/miyagawa/Hash-MultiValue";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashSafeKeys = buildPerlPackage {
    pname = "Hash-SafeKeys";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MOB/Hash-SafeKeys-0.04.tar.gz";
      hash = "sha256-pSStO/naZ3wfi+bhWXG3ZXVAj3RJI9onZHro8dPDfMw=";
    };
    meta = {
      description = "Get hash contents without resetting each iterator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashSharedMem = buildPerlModule {
    pname = "Hash-SharedMem";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Hash-SharedMem-0.005.tar.gz";
      hash = "sha256-Mkd2gIYC973EStqpN4lTZUVAKakm+mEfMhyb9rlAu14=";
    };
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isAarch64 "-mno-outline-atomics";
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
      hash = "sha256-ucvE3NgjPo0dfxSB3beaSl+dtxgMs+8CtLy+4F5l6gw=";
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
      hash = "sha256-ZC5Gp1tTe6EUILMPiwNAPJCgahVFjNgAnzOf6eXzdBs=";
    };
    meta = {
      description = "Use Hash::Util::FieldHash or ties, depending on availability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HeapFibonacci = buildPerlPackage {
    pname = "Heap";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz";
      hash = "sha256-zNop88kxdq0P3/9N1vXkrJCzcMuksCg4a3NDv2QTm94=";
    };
    meta = {
      description = "Perl extensions for keeping data partially sorted";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HookLexWrap = buildPerlPackage {
    pname = "Hook-LexWrap";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Hook-LexWrap-0.26.tar.gz";
      hash = "sha256-tgvcX5j5T5KUsGre+CsdmW2hktXxg/n0NLYQ/RE37C0=";
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
      hash = "sha256-pn1KvadR/DxrSjUYU3eoi8pbZRxgszN5gEtOkKF4hwY=";
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
      hash = "sha256-8+8a8Qjyf+8V6+xmR58lHOCKpJvQCwRiycgMhrS2sys=";
    };
    propagatedBuildInputs = [ HTMLTree ];
    meta = {
      description = "Perl extension for HTML::Element(3)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLEscape = buildPerlModule {
    pname = "HTML-Escape";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/HTML-Escape-1.10.tar.gz";
      hash = "sha256-scusQVetje2saRThYohV4FuNyIWkAH0uTfgXfGqbcPs=";
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
      hash = "sha256-IXdjRe1wGywEx7CTgK+UP5mEzH+ZYkCHrqRdtfwJw1k=";
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
      hash = "sha256-faqMfq/0AFUBw0Mci/R41Yu+57g2+GNYGqFK/htLYic=";
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
      hash = "sha256-ywoN2Kpei6nKIUzkUb9N8zqgnBPpB+jTCC3a/rMBUcw=";
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
      hash = "sha256-PFnyM9CxBoaoWu0MmUARzsaGJtoBKN6pC1xP3BdGz8M=";
    };
    propagatedBuildInputs = [ IPCRun URI constant-defer ];
    meta = {
      description = "HTML to text formatting using external programs";
      homepage = "https://user42.tuxfamily.org/html-formatexternal/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  HTMLFormatTextWithLinks = buildPerlModule {
    pname = "HTML-FormatText-WithLinks";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STRUAN/HTML-FormatText-WithLinks-0.15.tar.gz";
      hash = "sha256-f8wat561j7l9Q+W90U4heRolCiBJmJGMYtahcRMYM7E=";
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
      hash = "sha256-gJ7i8RcFcGszxUMStce+5nSDjyvqrtr4y5RecCquObY=";
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
      hash = "sha256-Ty8Bf3qHVPu26RIGyI7RPHVqFOO+oXgYjDuXdGNm6zI=";
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
      hash = "sha256-NvAM12u4luTaCd0rsOXYkGZ/cMePVCUa9NJYyCFJFZ8=";
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
      hash = "sha256-63t43aMSV1LMi8wDltOXf70o2jPS1ExQQq1tNdbN6Cc=";
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
      hash = "sha256-v1C2HCRlbMP8lYYC2AqcfQFyR6842Nv6Dp3sW3VCXV8=";
    };
    propagatedBuildInputs = [ AlienLibGumbo ];
    meta = {
      description = "HTML5 parser based on gumbo C library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMason = buildPerlPackage {
    pname = "HTML-Mason";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.60.tar.gz";
      hash = "sha256-qgu9WmtjxiyJVfjFXsCF43DXktZSZrbDtcXweIu8d+Y=";
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
      hash = "sha256-6v18dlXfqCYd80RrkxooPTAwaHe4OsRnHEnP906n8As=";
    };
    buildInputs = [ Plack ];
    propagatedBuildInputs = [ CGIPSGI HTMLMason ];
    meta = {
      description = "PSGI handler for HTML::Mason";
      homepage = "https://search.cpan.org/dist/HTML-Mason-PSGIHandler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLParser = buildPerlPackage {
    pname = "HTML-Parser";
    version = "3.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/HTML-Parser-3.75.tar.gz";
      hash = "sha256-rGteJajfevVIhSAekcRfuatnRMCM7cGjj8x9ldIRk6k=";
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
      hash = "sha256-SYCZRy3vhmtEi/YvQYLfrfWUcuE/JMuGZKZxynm2cBU=";
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
      hash = "sha256-i0HzE/3BgS8C9vbDfVjyEshP3PeCf3/UsDCQfzncZQw=";
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
      hash = "sha256-GAjsfN9A0nCFdf5hVaiPEDsX/sd5c6WDHC8kwlDnpYw=";
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
      hash = "sha256-Gl1N4UvH+G8OvXZik+Ok4SaYzS3gRnMkP/065xVqauE=";
    };
    buildInputs = [ TestBase ];
    meta = {
      description = "CSS Selector to XPath compiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLScrubber = buildPerlPackage {
    pname = "HTML-Scrubber";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NI/NIGELM/HTML-Scrubber-0.19.tar.gz";
      hash = "sha256-rihVePhWX5FUxj5CNHBLV7aDX3ei+C/+ckiZ1FMmK7E=";
    };
    propagatedBuildInputs = [ HTMLParser ];
    buildInputs = [ TestDifferences TestMemoryCycle ];
    meta = {
      description = "Perl extension for scrubbing/sanitizing HTML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLStripScripts = buildPerlPackage {
    pname = "HTML-StripScripts";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/HTML-StripScripts-1.06.tar.gz";
      hash = "sha256-Iiv7fsH9+kZeMto9xKvtLtxzZLvhno48UTx9WFsBCa0=";
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
      hash = "sha256-R4waTkbrd/p7zpa6KIFo8LmMJ/JQ4A3GMSNlCBrtNAc=";
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
      hash = "sha256-hsWcnVjaPKF02l5i9aD7AvTaArGx4B355dFLtl5MPs8=";
    };
    preCheck = ''
      # https://rt.cpan.org/Public/Bug/Display.html?id=121920
      rm t/30_tree.t
    '';
    propagatedBuildInputs = [ HTMLElementExtended ];
    meta = {
      description = "Perl module for extracting the content contained in tables within an HTML document, either as text or encoded element trees";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTagset = buildPerlPackage {
    pname = "HTML-Tagset";
    version = "3.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz";
      hash = "sha256-rbF9rJ42zQEfUkOIHJc5QX/RAvznYPjeTpvkxxMRCOI=";
    };
    meta = {
      description = "Data tables useful in parsing HTML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTemplate = buildPerlPackage {
    pname = "HTML-Template";
    version = "2.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAMTREGAR/HTML-Template-2.97.tar.gz";
      hash = "sha256-ZUevYfOqhXk/hhYZCTjWd9eZX7O3IMFiWAQLyTXiEp8=";
    };
    propagatedBuildInputs = [ CGI ];
    buildInputs = [ TestPod ];
    meta = {
      description = "Perl module to use HTML-like templating language";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTidy = buildPerlPackage {
    pname = "HTML-Tidy";
    version = "1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tidy-1.60.tar.gz";
      hash = "sha256-vPv2XWh/jmcs9gyYIbzWXV6McqeCcrZ7sKwcaZoT18c=";
    };

    patchPhase = ''
      sed -i "s#/usr/include/tidyp#${pkgs.tidyp}/include/tidyp#" Makefile.PL
      sed -i "s#/usr/lib#${pkgs.tidyp}/lib#" Makefile.PL
    '';
    buildInputs = [ TestException ];
    meta = {
      description = "(X)HTML validation in a Perl object";
      homepage = "https://github.com/petdance/html-tidy";
      license = with lib.licenses; [ artistic2 ];
      mainProgram = "webtidy";
    };
  };

  HTMLTiny = buildPerlPackage {
    pname = "HTML-Tiny";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/HTML-Tiny-1.05.tar.gz";
      hash = "sha256-183J1ZheLkTOuhC3Vqzx4NOhs+47UW5bVK24UP55/aM=";
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
      hash = "sha256-7RETXGg55uDq+WlS5qw1Oi8i67QKchZZZx5dLcwOSp0=";
    };
    propagatedBuildInputs = [ HTMLParser SubOverride ];
    meta = {
      description = "Easy to use HTML::TokeParser interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTree = buildPerlModule {
    pname = "HTML-Tree";
    version = "5.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KE/KENTNL/HTML-Tree-5.07.tar.gz";
      hash = "sha256-8DdNuEcxwgS4bB1bkJdf7w0wqGvZ3vkZND5VTjGp278=";
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
      hash = "sha256-Jeu9skRKClma5eekV9deCe/N8yZqXFcAsUA8y3SIpPM=";
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
      hash = "sha256-vkLfQFWSXOalob818eB60SvEP2VJ91JJAuozMFoOggs=";
    };
    doCheck = false;
    propagatedBuildInputs = [ ClassAccessorChained ClassDataAccessor DateCalc EmailValid HTMLScrubber HTMLTree ModulePluggableFast ];
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "HTML Widget And Validation Framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPAcceptLanguage = buildPerlModule {
    pname = "HTTP-AcceptLanguage";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YAPPO/HTTP-AcceptLanguage-0.02.tar.gz";
      hash = "sha256-LmBfVk7J66tlVI/17sk/nF3qvv7XBzpyneCuKE5OQq8=";
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
      hash = "sha256-/A0sWFs70VMtkmCZZdWJ4Mh804DnzKQvua0KExEicpc=";
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
      hash = "sha256-VuMz6CPF2HKiiSQEgrlM3oQesDe38v/U0bQ6opjG9dA=";
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
      hash = "sha256-kD8Bevqlt4WZzJDvwU7MzIzC6/tjbrjAL48WuoYdH+A=";
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
      hash = "sha256-8HZ+fzy7gLITE8dh8HrY7SU7zp+i0LqAaz+3LTCbLh0=";
    };
    patches = [
      # Patches for CVE-2022-3108, from upstream pre 6.15
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/331d5c1d1f0e48e6b57ef738c2a8509b1eb53376.patch";
        hash = "sha256-vRSyiO38jnsSeKeGbCnKi+VLaTqQSB349eybl1Wa8SQ=";
        name = "HTTP-Daemon-CVE-2022-3108-pre.patch";
      })
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/e84475de51d6fd7b29354a997413472a99db70b2.patch";
        hash = "sha256-z8RXcbVEpjSZcm8dUZcDWYeQHtVZODOGCdcDTfXQpfA=";
        name = "HTTP-Daemon-CVE-2022-3108-1.patch";
      })
      (fetchpatch {
        url = "https://github.com/libwww-perl/HTTP-Daemon/commit/8dc5269d59e2d5d9eb1647d82c449ccd880f7fd0.patch";
        hash = "sha256-e1lxt+AJGfbjNOZoKj696H2Ftkx9wlTF557WkZCLE5Q=";
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
      hash = "sha256-Nl1ilN+9N+vFHe+LZbget5s5NOy8laLsLU2Cfv5qkis=";
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
      hash = "sha256-OozQ2Muj0XzYwE7oLXNB36okfb3ZSknrlLU/aeSD7Do=";
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
      hash = "sha256-MzOd+ewQbeN9hgnP0NPAg8z7sGwWxlG1s4UaVtF6lXw=";
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
      hash = "sha256-x4ERq4V+SMaYJJA9S2zoKT/v/GtdZw21UKdn+FOsx9o=";
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
      hash = "sha256-qeAP/7PYmRoUqq/dxh1tFoxP8U4xSuPbstTaMAjXRu8=";
    };
    meta = {
      description = "An XS extension for processing HTTP headers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken =
        stdenv.isi686 # loadable library and perl binaries are mismatched (got handshake key 0x7d40080, needed 0x7dc0080)
        || stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.HTTPHeaderParserXS.x86_64-darwin
    };
  };

  HTTPHeadersFast = buildPerlModule {
    pname = "HTTP-Headers-Fast";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/HTTP-Headers-Fast-0.22.tar.gz";
      hash = "sha256-zEMdtoSW3YhNtLwMC3ESwfSk8dxoxPWjyqdXoedIG0g=";
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
      hash = "sha256-OOQ9eRHPwU46OPA4K2zHptVZMH0jsQnOc6x9JKmz53w=";
    };
    buildInputs = [ CGI ];
    meta = {
      description = "Lightweight HTTP implementation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPMessage = buildPerlPackage {
    pname = "HTTP-Message";
    version = "6.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Message-6.26.tar.gz";
      hash = "sha256-bObDWd51w7uGaWo5AYm0heyT4//FUya20ET6kA8XJeE=";
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
      hash = "sha256-Xt3aFZ9U0W+GjgMkQKwrAk5VqsSJMYcbYmJ/GhbQCxI=";
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
      hash = "sha256-HHKcHqYxAOh4QFzafWb5rf0+1PHWysrKDukVLfco4BY=";
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
      hash = "sha256-eU5oM+MmsQ0kNp+c2/wWZxBe9lkej0HlYaPUGnAnqAk=";
    };
    meta = {
      description = "A fast, primitive HTTP request parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPProxy = buildPerlPackage {
    pname = "HTTP-Proxy";
    version = "0.304";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOOK/HTTP-Proxy-0.304.tar.gz";
      hash = "sha256-sFKQU07HNiXCGgVl/DUXCJDasWOEPZUzHCksI/UExp0=";
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
      hash = "sha256-lFv7B8bRr1J3P7eEW6YuOnQRGzXL0tXkPvgxnlWsvOo=";
    };
    propagatedBuildInputs = [ ClassAccessor HTTPMessage ];
    meta = {
      description = "Set up a CGI environment from an HTTP::Request";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPResponseEncoding = buildPerlPackage {
    pname = "HTTP-Response-Encoding";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz";
      hash = "sha256-EBZ7jiOKaCAEqw16zL6dduri21evB8WuLfqAgHSkqKo=";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    buildInputs = [ LWP ];
    meta = {
      description = "Adds encoding() to HTTP::Response";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimple = buildPerlPackage {
    pname = "HTTP-Server-Simple";
    version = "0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz";
      hash = "sha256-2JOfpPEr1rjAQ1N/0L+WsFWsNoa5zdn6dz3KauZ5y0w=";
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
      hash = "sha256-Ld3Iq53ImGmAFR5LqDamu/CR9Fzxlb4XaOvbSpk+1Zs=";
    };
    propagatedBuildInputs = [ AuthenSimple HTTPServerSimple ];
    meta = {
      description = "Authentication plugin for HTTP::Server::Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleMason = buildPerlPackage {
    pname = "HTTP-Server-Simple-Mason";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-Mason-0.14.tar.gz";
      hash = "sha256-t6Sdjm5Vv/Cx8CeNlRaFRmsUMkO2+eWeBx9UcsoqAlo=";
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
      hash = "sha256-X3zLhFMEO5cnhJKnVzKBFuEeA1LyhUooqcY05ukTHbo=";
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
      hash = "sha256-c323zxncN4By2Rysdnh/sorNg8DRB85OTrS708kRhiE=";
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
      hash = "sha256-R70RHkdFZtczxBhw4jdMgWidteC1pDrcSK22ZdifsGc=";
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
      hash = "sha256-DXk5pkSo5nAX7HI509lgTzmGu5pP+Avmj+cpnr/SJww=";
    };
    propagatedBuildInputs = [ DateTimeFormatICal FreezeThaw IOString TextvFileasData ];
    meta = {
      description = "Parse iCalendar files into a data structure";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ImagePNGLibpng = buildPerlPackage {
    pname = "Image-PNG-Libpng";
    version = "0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BK/BKB/Image-PNG-Libpng-0.56.tar.gz";
      hash = "sha256-+vu/6/9CP3u4XvJ6MEH7YpG1AzbHpYIiSlysQzHDx9k=";
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
      hash = "sha256-dNRNcBwfFPxLmE+toelVcmtQTC2LBtJl56hh+llDy0g=";
    };
    buildInputs = [ pkgs.freetype pkgs.fontconfig pkgs.libjpeg pkgs.libpng ];
    makeMakerFlags = [ "--incpath ${pkgs.libjpeg.dev}/include" "--libpath ${pkgs.libjpeg.out}/lib" "--incpath" "${pkgs.libpng.dev}/include" "--libpath" "${pkgs.libpng.out}/lib" ];
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
      hash = "sha256-KoSN66Kes5QsRHCaaFPjGKyrDEaMv+27m6rlR2ADJRM=";
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
      hash = "sha256-K8pWDD9xs8HNY6w6l05i87rrmGt/+qAmuSkIG5FKj08=";
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
      hash = "sha256-Ipqg6fBJ76dg88L25h2dU5r0PY92S1Cm4DBktHKaNf8=";
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
      hash = "sha256-8JxfBmO4dzg2WsKBnhhrkJq+ue2F2DvBXudocslHzfg=";
    };
    buildInputs = [ pkgs.libpng pkgs.libjpeg TestNoWarnings ];
    propagatedBuildInputs = [ pkgs.zlib ];
    makeMakerFlags = [ "--with-jpeg-includes=${pkgs.libjpeg.dev}/include" "--with-jpeg-libs=${pkgs.libjpeg.out}/lib" "--with-png-includes=${pkgs.libpng.dev}/include" "--with-png-libs=${pkgs.libpng.out}/lib" ];
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
      hash = "sha256-U8mx+GUxzeBg7mNwnR/ac8q8DPLVgdKbIrAUeBufAms=";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "A library to extract height/width from images";
      homepage = "https://search.cpan.org/dist/Image-Size";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "imgsize";
    };
  };

  ImageOCRTesseract = buildPerlPackage {
    pname = "Image-OCR-Tesseract";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEOCHARRE/Image-OCR-Tesseract-1.26.tar.gz";
      hash = "sha256-mNkEJmpwYvCcm0b3fE6UUp4f6ZM54/g/2h+SAT8AfOo=";
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
      hash = "sha256-inovpVt1qFPEgBQXeDk62sKUts0gfN9UFA9nwS8kypU=";
    };
    doCheck = false; # nondeterministic
    meta = {
      description = "Advanced manipulation of IMAP services w/ referral support";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Importer = buildPerlPackage {
    pname = "Importer";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Importer-0.026.tar.gz";
      hash = "sha256-4I+oThPLmYt6iX/I7Jw0WfzBcWr/Jcw0Pjbvh1iRsO8=";
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
      hash = "sha256-vZ53o/tmK0C0OxjTKAzTUu35+tjZQoPlGBgcwc6fBWc=";
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
      hash = "sha256-7sXMM6bN26i10kJbYHUogq3X5NQbdDGg6k3Nc8wfjMo=";
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
      hash = "sha256-mltHx4Ak+rdmPR5a90ob6rRQ19Y7poV+MbP9gobkrFo=";
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
      hash = "sha256-VOIdJQwCKRJ+MLd6NGHhAHeFTsJE8m+2cPG0Re1MTVs=";
    };
    meta = {
      description = "IO::All of it to Graham and Damian!";
      homepage = "https://github.com/ingydotnet/io-all-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOAsync = buildPerlModule {
    pname = "IO-Async";
    version = "0.802";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/IO-Async-0.802.tar.gz";
      hash = "sha256-5YJzFXd2fEfqxDXvKQRmPUp1Cw5oAqSmGJo38Mswhzg";
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
      hash = "sha256-0vyuFuJ+F6yjkDpK1aK/L7wmjQZRzn8ARabQVG9YTy4=";
    };
    patches = [
      (fetchpatch {
        # Fixes test compatibility with OpenSSL 3
        url = "https://sources.debian.org/data/main/libi/libio-async-ssl-perl/0.23-1/debian/patches/upgrade-error-match.patch";
        hash = "sha256-RK36nVba203I9awZtHiU7jwhCV7U8Gw6wnbs3e9Hbjk=";
        name = "IO-Async-SSL-upgrade-error-match.patch";
      })
    ];
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
      hash = "sha256-wsFaJUynT7jFfSXXtsvK/3ejtPtWlUI/H4C7Qjq//qk=";
    };
    meta = {
      description = "Abstract Base Class to build modules to capture output";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOCaptureOutput = buildPerlPackage {
    pname = "IO-CaptureOutput";
    version = "1.1105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/IO-CaptureOutput-1.1105.tar.gz";
      hash = "sha256-rpkAn8oSc4APFp7LgvTtHMbHZ5XxVr7lwAkwBdVy9Ic=";
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
      hash = "sha256-1vp/mlvu5EZFKg+8Q1iaDHP+fpJcB1uYYosBgEjccqQ=";
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
      hash = "sha256-j/z4Wn9iE+XpQUCtzCsXntAkmOrchDCUV+kE3sk/f5I=";
    };
    propagatedBuildInputs = [ PerlIOviadynamic ];
    meta = {
      description = "Calculate digests while reading or writing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOHTML = buildPerlPackage {
    pname = "IO-HTML";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz";
      hash = "sha256-yHst9ZRju/LDlZZ3PftcA73g9+EFGvM5+WP1jBy9i/U=";
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
      hash = "sha256-jblmqRPaxORkIwcCqiIr84r+ISGT5ja8DzzGUbrezO4=";
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
      hash = "sha256-DtU7iuk66Hfpjg2Jt7Qp4pzNHuTCjpUsTqmqc9Af69w=";
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
      hash = "sha256-RcBpZQXH5DR4RfXNJRK3sbx4+85MvtK1gAgoP8lepfk=";
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
      hash = "sha256-sdt+amvxvh4GFabstc6+eLAOKHsSfVhW0/FrNd1H+LU=";
    };
    meta = {
      description = "Supply object methods for locking files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOMultiplex = buildPerlPackage {
    pname = "IO-Multiplex";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBB/IO-Multiplex-1.16.tar.gz";
      hash = "sha256-dNIsRLWtLnGQ4nhuihfXS79M74m00RV7ozWYtaJyDa0=";
    };
    meta = {
      description = "Supply object methods for locking files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPager = buildPerlPackage {
    version = "2.10";
    pname = "IO-Pager";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-2.10.tgz";
      hash = "sha256-vLTYwtKAyANLglkcwLnrZ6AE+QzpqgWXn8YHEwessZU=";
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
      hash = "sha256-jxoJwHBzitxpXfkD8uf3QwjdjZkbkUwLw5Cg5gISlN0=";
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
      hash = "sha256-8XuzBe5qyLWyA+bYJuuUDE8/bW9L/nGcOzoiX0b1hhU=";
    };
    propagatedBuildInputs = [ TermReadKey Want ];
    doCheck = false; # needs access to /dev/tty
    meta = {
      description = "Interactively prompt for user input";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSessionData = buildPerlPackage {
    pname = "IO-SessionData";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/IO-SessionData-1.03.tar.gz";
      hash = "sha256-ZKRxKj7bs/0QIw2ylsKcjGbwZq37wMPfakglj+85Ld0=";
    };
    outputs = [ "out" "dev" ]; # no "devdoc"
    meta = {
      description = "Supporting module for SOAP::Lite";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketINET6 = buildPerlModule {
    pname = "IO-Socket-INET6";
    version = "2.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.72.tar.gz";
      hash = "sha256-heAg+heShBJfwdCOYKkCKvPsEnEHf+FLEzwXhc2/Hrs=";
    };
    propagatedBuildInputs = [ Socket6 ];
    doCheck = false;
    meta = {
      description = "[DEPRECATED] Object interface for AF_INET/AF_INET6 domain sockets";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketSSL = buildPerlPackage {
    pname = "IO-Socket-SSL";
    version = "2.068";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SULLR/IO-Socket-SSL-2.068.tar.gz";
      hash = "sha256-RCD8AFbxgntN0SRerMoNpW4hgrTvb8B48QfcQ8P7j/k=";
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
      hash = "sha256-7fkV1sxmvuQ1A6ptwrNzNm846v9wFYIYPa0Qy4rfKXI=";
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
      hash = "sha256-Kj9K2EQtkHB4DljvQ3ItGdHuIagDv3yCBod6EEgt5aA=";
    };
    meta = {
      description = "Emulate file interface for in-core strings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOStringy = buildPerlPackage {
    pname = "IO-Stringy";
    version = "2.113";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz";
      hash = "sha256-USIPyvn2amObadJR17B1e/QgL0+d69Rb3TQaaspi/k4=";
    };
    meta = {
      description = "I/O on in-core objects like strings and arrays";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOStty = buildPerlModule {
    pname = "IO-Stty";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Stty-0.04.tar.gz";
      hash = "sha256-XJUJ8ahpPYKH+gE97wv4eqZM2ScThGHvjetVUDxmUcI=";
    };
    buildPhase = "make";
    checkPhase = "make test";
    installPhase = "make install";
    meta = {
      description = "Change and print terminal line settings";
      homepage = "https://wiki.github.com/toddr/IO-Stty";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOTee = buildPerlPackage {
    pname = "IO-Tee";
    version = "0.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/IO-Tee-0.66.tar.gz";
      hash = "sha256-LZznIGUW+cMIY6NnqhwrmzVwLjabCrqhX5n7LMCFUuA=";
    };
    meta = {
      description = "Multiplex output to multiple output handles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOTieCombine = buildPerlPackage {
    pname = "IO-TieCombine";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.005.tar.gz";
      hash = "sha256-QC1NuDALPScWMvSZXgreMp2JKAp+R/K634s4r25Vaa8=";
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
      hash = "sha256-Q/nMD4diC7sVngiQ4ZayOo5kGcvQQiTBDz3O6Uj2tRo=";
    };
    doCheck = !stdenv.isDarwin;  # openpty fails in the sandbox
    meta = {
      description = "Low-level allocate a pseudo-Tty, import constants";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCConcurrencyLimit = buildPerlPackage {
    pname = "IPC-ConcurrencyLimit";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTK/IPC-ConcurrencyLimit-0.17.tar.gz";
      hash = "sha256-Lk11vlLpD8YFg31ajp+yacCofdPTYfMBLA/5Sl+9z+8=";
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
      hash = "sha256-iNuDOlqyLtBstT1vIFcl47U3GyVFlgU3OIhekfoQX3U=";
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
      hash = "sha256-SMQuQOgoG6fJgXQ6hUxI5t7y1R6wkl6myW4lx0SX8g8=";
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
      hash = "sha256-gW6/IX+g35nFg9c8Csxs7XisdzeHxmTHXL8UC7fkyQE=";
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
      hash = "sha256-PYHDzBtc/2nMqTYeLG443wNSJRrntB4v8/68hQ5GNWU=";
    };
    meta = {
      description = "Run a subprocess with input/output redirection";
      license = with lib.licenses; [ artistic1 gpl1Plus bsd3 ];
    };
  };

  IPCShareLite = buildPerlPackage {
    pname = "IPC-ShareLite";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/IPC-ShareLite-0.17.tar.gz";
      hash = "sha256-FNQGuR2pbWUh0NGoLSKjBidHZSJrhrClbn/93Plq578=";
    };
    meta = {
      description = "Lightweight interface to shared memory";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IPCSystemSimple = buildPerlPackage {
    pname = "IPC-System-Simple";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz";
      hash = "sha256-Iub1IitQXuUTBY/co1q3oeq4BTm5jlykqSOnCorpup4=";
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
      hash = "sha256-GJdUHHTVSP0QB+tsB/NBnTx1ddgFamK1ulJwohZtLb0=";
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
      hash = "sha256-x9YxHrbHnpg4M8nmtOjUJtB6mHTSD0vGQbMTuZybyKA=";
    };
    meta = {
      description = "Common utilities for IRC-related tasks";
      homepage = "https://metacpan.org/release/IRC-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ sgo ];
    };
  };

  ImageExifTool = buildPerlPackage rec {
    pname = "Image-ExifTool";
    version = "12.65";

    src = fetchurl {
      url = "https://exiftool.org/Image-ExifTool-${version}.tar.gz";
      hash = "sha256-YWynZES+4/MkYueeN8Y3IC7vKGb0wkANUfIKgScDJDI=";
    };

    nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
    postInstall = lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/exiftool
    '';

    meta = {
      description = "A tool to read, write and edit EXIF meta information";
      longDescription = ''
        ExifTool is a platform-independent Perl library plus a command-line
        application for reading, writing and editing meta information in a wide
        variety of files. ExifTool supports many different metadata formats
        including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop
        IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital
        cameras by Canon, Casio, DJI, FLIR, FujiFilm, GE, GoPro, HP,
        JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Motorola, Nikon,
        Nintendo, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One,
        Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.
      '';
      homepage = "https://exiftool.org/";
      changelog = "https://exiftool.org/history.html";
      license = with lib.licenses; [ gpl1Plus /* or */ artistic2 ];
      maintainers = with maintainers; [ kiloreux anthonyroussel ];
      mainProgram = "exiftool";
    };
  };

  Inline = buildPerlPackage {
    pname = "Inline";
    version = "0.86";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Inline-0.86.tar.gz";
      hash = "sha256-UQp94tARsNuAsIdOjA9zkAEJkQAK4TXP90dN8ebVHjo=";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Write Perl Subroutines in Other Programming Languages";
      longDescription = ''
        The Inline module allows you to put source code from other
        programming languages directly "inline" in a Perl script or
        module. The code is automatically compiled as needed, and then loaded
        for immediate access from Perl.
      '';
      homepage = "https://github.com/ingydotnet/inline-pm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineC = buildPerlPackage {
    pname = "Inline-C";
    version = "0.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/Inline-C-0.81.tar.gz";
      hash = "sha256-8YUljZBQ1/ebTwDxJiXMRpwvcA/2LT6DHLGNgNLIeqw=";
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
      hash = "sha256-x0PgaOb28b2HMGH+R6h05cJIpP2ks8fM6J8P2/oz2Ug=";
    };

    propagatedBuildInputs = [ Inline ];

    # TODO: upgrade https://github.com/NixOS/nixpkgs/pull/89731
    makeMakerFlags = [ "J2SDK=${pkgs.jdk8}" ];

    # FIXME: Apparently tests want to access the network.
    doCheck = false;

    meta = {
      description = "Write Perl classes in Java";
      longDescription = ''
        The Inline::Java module allows you to put Java source code directly
        "inline" in a Perl script or module.  A Java compiler is launched and
        the Java code is compiled.  Then Perl asks the Java classes what
        public methods have been defined.  These classes and methods are
        available to the Perl program as if they had been written in Perl.
      '';
      license = with lib.licenses; [ artistic2 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.InlineJava.x86_64-darwin
    };
  };

  IPCSignal = buildPerlPackage {
    pname = "IPC-Signal";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/IPC-Signal-1.00.tar.gz";
      hash = "sha256-fCH5yMLQwPDw9G533nw9h53VYmaN3wUlh1w4zvIHb9A=";
    };
    meta = {
      description = "Utility functions dealing with signals";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JavaScriptMinifierXS = buildPerlModule {
    pname = "JavaScript-Minifier-XS";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GT/GTERMARS/JavaScript-Minifier-XS-0.11.tar.gz";
      hash = "sha256-FRISykvVCy9eHebQHjywhGBAe9dfJ9/IFi8veSeDnu4=";
    };
    perlPreHook = lib.optionalString (stdenv.isi686 || stdenv.isDarwin) "export LD=$CC";
    meta = {
      description = "XS based JavaScript minifier";
      homepage = "https://metacpan.org/release/JavaScript-Minifier-XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JavaScriptValueEscape = buildPerlModule {
    pname = "JavaScript-Value-Escape";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/JavaScript-Value-Escape-0.07.tar.gz";
      hash = "sha256-msvaNwjt4R9r6uXxEvGIw6kCOk0myOzYmqgru2kxo9w=";
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
      hash = "sha256-REqIdVqJ/6KlQkq07R0R3KYYCOvvV+gSQ0JGGanoYnw=";
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
      hash = "sha256-rkl1XPNxCmoydqN6t9XD5+DArrLas1Ss12gsCad5V8M=";
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
      hash = "sha256-X67+DYM7gTJWiGUwjzI5082qG4oezJtWJNzx774QaD4=";
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
      hash = "sha256-W+47F/+dz/1umauM9/NXR2UL/OHcYi460QuFoZRGL78=";
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
      hash = "sha256-1aK8przPTUT0Ouqs4PRa5lQbt/UNtaSJtdL/X76L8M4=";
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
      hash = "sha256-GXAw31JjX5u+Ja8QdC7qW9dJcUcxGMETEfyry2LjcWo=";
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
      hash = "sha256-zo5V5wvvm8u6LpavYx0QpgWQCWGiLK2XfnGqtWw/KAY=";
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
      hash = "sha256-QPaWjtcfxv1Ij6Q1Ityhk5NDhUCSth/eZgHwcWZHeFg=";
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
      hash = "sha256-d8GCqYUo8XFNgq/FSNWztNyT5nBpEou5uUE/JM8HJIs=";
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
      hash = "sha256-UVU29F8voafojIgkUzdY0BIdJnq5y0U6G1iHyKVrkGg=";
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
      hash = "sha256-5gksTZYfrnd6z3/pn7PNbltxD+yFdlprkEF0gOTJSjQ=";
    };
    propagatedBuildInputs = [ JSONXS ];
    meta = {
      description = "Support versions 1 and 2 of JSON::XS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Later = buildPerlPackage {
    version = "0.21";
    pname = "Object-Realize-Later";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Object-Realize-Later-0.21.tar.gz";
      hash = "sha256-j3uWQMyONOqSvPbAEEmgPBReDrRuViJ14o3d06jW2Nk=";
    };
    meta = {
      description = "Delayed creation of objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LatexIndent = buildPerlPackage rec {
    pname = "latexindent.pl";
    version = "3.21";

    src = fetchFromGitHub {
      owner = "cmhughes";
      repo = pname;
      rev = "V${version}";
      hash = "sha256-STXHOzsshyN7rc2VtJxxt6La4UPGpRYlMO8TX1Jd7pM=";
    };

    outputs = [ "out" ];

    propagatedBuildInputs = [ FileHomeDir YAMLTiny ];

    preBuild = ''
      patchShebangs ./latexindent.pl
    '';

    meta = {
      description = "Perl script to add indentation to LaTeX files";
      homepage = "https://github.com/cmhughes/latexindent.pl";
      license = lib.licenses.gpl3Plus;
    };
  };

  LaTeXML = buildPerlPackage rec {
    pname = "LaTeXML";
    version = "0.8.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRMILLER/${pname}-${version}.tar.gz";
      hash = "sha256-JdqdlEB3newNrdTMLUIn6Oq4dDfAcZh3J03PuQakzHk=";
    };
    outputs = [ "out" "tex" ];
    propagatedBuildInputs = [ ArchiveZip DBFile FileWhich IOString ImageMagick ImageSize JSONXS LWP ParseRecDescent PodParser TextUnidecode XMLLibXSLT ];
    nativeBuildInputs = [ pkgs.makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;
    makeMakerFlags = [ "TEXMF=\${tex}" "NOMKTEXLSR" ];
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
      hash = "sha256-N4NfEe41MmJBtNMDaK4bwZWlBBSzZi2z4TuGW9Uvzek=";
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
      hash = "sha256-wWZao6vUV8yGJLjEGMb4vfWPs6aG+O7VFc9+k1FN8ZI=";
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
      hash = "sha256-npGO0RjvaF1uCdqxzW5m7gox13b+JLumPlJDkG9WATo=";
    };
    meta = {
      description = "Prevent leakage of lexical hints";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libapreq2 = buildPerlPackage rec {
    pname = "libapreq2";
    version = "2.17";
    src = fetchurl {
      url = "mirror://apache/httpd/libapreq/${pname}-${version}.tar.gz";
      hash = "sha256-BGSH8ITBL6HIIq/8X33lbv7ZtIkFpCbmMaa5ScEU2Gw=";
    };
    outputs = [ "out" ];
    buildInputs = [ pkgs.apacheHttpd pkgs.apr pkgs.aprutil ApacheTest ExtUtilsXSBuilder ];
    propagatedBuildInputs = [ (pkgs.apacheHttpdPackages.mod_perl.override { inherit perl; }) ];
    makeMakerFlags = [
      "--with-apache2-src=${pkgs.apacheHttpd.dev}"
      "--with-apache2-apxs=${pkgs.apacheHttpd.dev}/bin/apxs"
      "--with-apache2-httpd=${pkgs.apacheHttpd.out}/bin/httpd"
      "--with-apr-config=${pkgs.apr.dev}/bin/apr-1-config"
      "--with-apu-config=${pkgs.aprutil.dev}/bin/apu-1-config"
    ];
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
      description = "Wrapper for libapreq2's module/handle API";
      license = with lib.licenses; [ asl20 ];
    };
  };

  libintl-perl = buildPerlPackage {
    pname = "libintl-perl";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.32.tar.gz";
      hash = "sha256-gBCCmPJWTsv8cRCjBCAI5mXtAMLhVbNrAYjmwRNc66U=";
    };
    meta = {
      description = "Portable l10n and i10n functions";
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  libnet = buildPerlPackage {
    pname = "libnet";
    version = "3.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/libnet-3.13.tar.gz";
      hash = "sha256-WjX7Hy1KopFoDrGvOImfq0U8IsKOcffHvTdHtaPbNIw=";
    };
    patches = [
      (fetchpatch {
        name = "deterministic-libnet.cfg";
        url = "https://github.com/steve-m-hay/perl-libnet/commit/7d076c4352f67ee4ed64092cfad3963a2321bd53.patch";
        hash = "sha256-GyPx0ZQ/u/+DaFM7eNDvXrMFC0+d3GyLxVZJBKrg6V0=";
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
      hash = "sha256-3+DHAF/Yvd0lp+jCUEsPreFix0ynG096y36OdhBtbNc=";
    };
    meta = {
      description = "Add paths relative to the current file to @INC";
      homepage = "https://github.com/Grinnz/lib-relative";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  libwwwperl = buildPerlPackage {
    pname = "libwww-perl";
    version = "6.70";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMBABQUE/libwww-perl-6.70.tar.gz";
      hash = "sha256-NPANI0R1e5wLVa01gI1T6T19kvekZOyDf+anPFH7WWk=";
    };
    buildInputs = [ HTTPDaemon TestFatal TestNeeds TestRequiresInternet ];
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookieJar HTTPCookies HTTPDate HTTPMessage HTTPNegotiate LWPMediaTypes NetHTTP TryTiny URI WWWRobotRules ];
    meta = {
      homepage = "https://github.com/libwww-perl/libwww-perl";
      description = "The World-Wide Web library for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  libxml_perl = buildPerlPackage {
    pname = "libxml-perl";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/libxml-perl-0.08.tar.gz";
      hash = "sha256-RXEFm3tdSLfOUrATieldeYv1zyAgUjwVP/J7SYFTycs=";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Collection of Perl modules for working with XML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENFindNumber = buildPerlPackage {
    pname = "Lingua-EN-FindNumber";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-FindNumber-1.32.tar.gz";
      hash = "sha256-HRdtHIY/uYRL0Z0sKk5ooO1z2hWPckqJQFuQ236NvQQ=";
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
      hash = "sha256-BcKew0guVyMTpg2iGBsLMMXbfPAfiudhatZ+G2YmMpY=";
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
      hash = "sha256-Zvszg4USdG9cWX6AJk/qZmQ/fyZXDsL5IFthNa1nrL8=";
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
      hash = "sha256-VQWJEamfF1XePrRJqZ/765LYjAH/XcYFEaJGeQUN3qg=";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ LinguaENInflectNumber LinguaENNumberIsOrdinal LinguaENTagger ];
    meta = {
      description = "Inflect short English Phrases";
      homepage = "https://metacpan.org/release/Lingua-EN-Inflect-Phrase";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENNumberIsOrdinal = buildPerlPackage {
    pname = "Lingua-EN-Number-IsOrdinal";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Number-IsOrdinal-0.05.tar.gz";
      hash = "sha256-KNVpVADA9OK9IJeTy3T22iuSVzVqrLKUfGA0JeCWGNY=";
    };
    buildInputs = [ TestFatal TryTiny ];
    propagatedBuildInputs = [ LinguaENFindNumber ];
    meta = {
      description = "Detect if English number is ordinal or cardinal";
      homepage = "https://metacpan.org/release/Lingua-EN-Number-IsOrdinal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaENTagger = buildPerlPackage {
    pname = "Lingua-EN-Tagger";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.31.tar.gz";
      hash = "sha256-lJ6Mh+SAj3uglrl5Ig/wgbvgO21XiQ0u7NS4Ouhy6ZM=";
    };
    propagatedBuildInputs = [ HTMLParser LinguaStem MemoizeExpireLRU ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing";
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  LinguaENWords2Nums = buildPerlPackage {
    pname = "Lingua-EN-Words2Nums";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOEY/Lingua-EN-Words2Nums-0.18.tar.gz";
      hash = "sha256-aGVWeXzSpOqgZvGbvwOrJcBieCksnq0vGH39kDHqHYU=";
    };
    meta = {
      description = "Convert English text to numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaPTStemmer = buildPerlPackage {
    pname = "Lingua-PT-Stemmer";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-PT-Stemmer-0.02.tar.gz";
      hash = "sha256-WW3wH4q3n//9RQ6Ug2pUQ3HYpMk6FffojqLxt5xGhJ0=";
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
      hash = "sha256-qhqZMrZCflmCU+YajM0NBMxVn66dWNh3TCAncItjAmQ=";
    };
    doCheck = false;
    propagatedBuildInputs = [ LinguaPTStemmer LinguaStemFr LinguaStemIt LinguaStemRu LinguaStemSnowballDa SnowballNorwegian SnowballSwedish TextGerman ];
    meta = {
      description = "Stemming of words";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaStemFr = buildPerlPackage {
    pname = "Lingua-Stem-Fr";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SD/SDP/Lingua-Stem-Fr-0.02.tar.gz";
      hash = "sha256-nU9ks6iJihhTQyGFJtWsaKSh+ObEQY1rqV1i9fnV2W8=";
    };
    meta = {
      description = "Perl French Stemming";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaStemIt = buildPerlPackage {
    pname = "Lingua-Stem-It";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AC/ACALPINI/Lingua-Stem-It-0.02.tar.gz";
      hash = "sha256-OOZz+3T+ARWILlrbJnTesIH6tyHXKO4qgRQWPVDIB4g=";
    };
    meta = {
      description = "Porter's stemming algorithm for Italian";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LinguaStemRu = buildPerlPackage {
    pname = "Lingua-Stem-Ru";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Lingua-Stem-Ru-0.04.tar.gz";
      hash = "sha256-EnDOt0dk/blYNwqAiDSvl26H9pqFRw+LxGJYeX6rUig=";
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
      hash = "sha256-Ljm+TuAVx+xHwrBnhYAYp0BuONUSHWVcikaHSt+poFY=";
    };
    meta = {
      description = "Porters stemming algorithm for Denmark";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  LinguaTranslit = buildPerlPackage {
    pname = "Lingua-Translit";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALINKE/Lingua-Translit-0.28.tar.gz";
      hash = "sha256-ET+R2PwsYwQ3FTpJ+3pSsCOvj2J47ZbAcLH2CCS46uE=";
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
      hash = "sha256-sd6LTiXHIplEOeesA0vorjeiCUijG/SF8iu0hvzI3KU=";
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
      hash = "sha256-MSlAwfYPR8T8k/oKnSpiZCX6qDcEDIwvGtWO4J9i83E=";
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
      hash = "sha256-YDd6dPupD6RlIA7hx0MNvd5p1FTYX57hAcA5gDoH5fU=";
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
      hash = "sha256-YD4n2mB7PocqZp16ZtdZgvCWkVPqstSyDDQTR7Tr2l8=";
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
      hash = "sha256-a7V51HZEyw7TVib/d+kJrmkGMHPGrAmqBhT+8A+jc1Y=";
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
      hash = "sha256-3UGiDaVon7IHHuojo4PE4PjYW0YrpluqbE9TolTtNDM=";
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
      hash = "sha256-l8oYajxBa/ae1i2gRvGmDYjYm45u0lAIsvlueH3unWA=";
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
      hash = "sha256-t8S/gAkLKBxKFWDHahqBkJTDoSlDAvd6+4xgykhi7Pk=";
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
      hash = "sha256-yBEwcb1gQANe6KsBzxtyqRBXQZLx0XkQKud1qXPy6Co=";
    };
    meta = {
      description = "Binary Search within a sorted array";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListCompare = buildPerlPackage {
    pname = "List-Compare";
    version = "0.55";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JK/JKEENAN/List-Compare-0.55.tar.gz";
      hash = "sha256-zHGUeYNledUrArwyjtgKmPZ53wQ6mbVxCrLBkWaeuDc=";
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
      hash = "sha256-Y7H3hCzULZtTjR404DMN5f8VWeTCc3NCUGQYJ29kZSc=";
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
      hash = "sha256-6M5G1XwXnuzYdYKT6UAP8wCq8g/v4KnRW5/iMCucskI=";
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
      hash = "sha256-lur7NZM50ivyot5CEpiEejxA9qKLbUQAXQll2oalRp0=";
    };
    buildInputs = [ TestLeakTrace ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      description = "Provide the stuff missing in List::Util";
      homepage = "https://metacpan.org/release/List-SomeUtils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListUtilsBy = buildPerlModule {
    pname = "List-UtilsBy";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.11.tar.gz";
      hash = "sha256-+t30O0vCHbjkwOiaJuXyP+YmzeNJHsZRtqozhif1d1o=";
    };
    meta = {
      description = "Higher-order list utility functions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleCodes = buildPerlPackage {
    pname = "Locale-Codes";
    version = "3.66";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.66.tar.gz";
      hash = "sha256-mfrNbVbijKaPMj0Cy3/GyOuYM7BpalqDPvSsP15cV+c=";
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
      hash = "sha256-kJ1HlUaX58BCGPlykVt4e9EkTXXjvQFiC8Fn1bvEnBU=";
    };
    LANG="C";
    meta = {
      description = "Perl extension for emulating gettext-related API";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleMaketextLexiconGetcontext = buildPerlPackage {
    pname = "Locale-Maketext-Lexicon-Getcontext";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAPER/Locale-Maketext-Lexicon-Getcontext-0.05.tar.gz";
      hash = "sha256-dcsz35RypZYt5UCC9CxqdrJg/EBboQylMkb7H4LAkgg=";
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
      hash = "sha256-lwNtw/Cds3BSrp2aUUSH6IS1bZDHbKEtbKtAXSNWSj8=";
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
      hash = "sha256-N4UXHOt4zHZxMZo6bYztmxkOCX382bKp68gEzRooL5Y=";
    };
    meta = {
      description = "Maketext from already interpolated strings";
      license = with lib.licenses; [ cc0 ];
    };
  };

  LocaleMaketextLexicon = buildPerlPackage {
    pname = "Locale-Maketext-Lexicon";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DRTECH/Locale-Maketext-Lexicon-1.00.tar.gz";
      hash = "sha256-tz9rBKWNPw446/IRWkwVMvGk7vb6xcaipEnk4Uwd3Hw=";
    };
    meta = {
      description = "Use other catalog formats in Maketext";
      homepage = "https://search.cpan.org/dist/Locale-Maketext-Lexicon";
      license = with lib.licenses; [ mit ];
      mainProgram = "xgettext.pl";
    };
  };

  LocaleMsgfmt = buildPerlPackage {
    pname = "Locale-Msgfmt";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AZ/AZAWAWI/Locale-Msgfmt-0.15.tar.gz";
      hash = "sha256-wydoMcvuz1i+AggbzBgL00jao12iGnc3t7A4pZ9kOrQ=";
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
      hash = "sha256-PJlKS2Pm5Og2xveak/UZIcq3fJDJdT/g+LVCkiDVFrk=";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Perl module for manipulating .po entries from GNU gettext";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LocaleTextDomainOO = buildPerlPackage {
    pname = "Locale-TextDomain-OO";
    version = "1.036";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/ST/STEFFENW/Locale-TextDomain-OO-1.036.tar.gz";
      hash = "sha256-tReD4aiWICE+oqg+RbrsOqhunL4en6W590+HSbBUDjg=";
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
      hash = "sha256-PF+gf2Xtd8Ap4g0kahBAQRSPGptH4332PzflHQK9RqA=";
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
      hash = "sha256-LhwAU5ljqeyr0se5te+QpWBna7A0giUXYin8jqS0pMw=";
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
      hash = "sha256-UChgS9jzPY0yymkp+9DagP9L30KN6ARfs/Bbp9FdNOs=";
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
      hash = "sha256-b9eOojm1w1m6lCJ1N2b2OO5PkM0hdRpZs4YVXipFpr0=";
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
    version = "2.000029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/local-lib-2.000029.tar.gz";
      hash = "sha256-jfh6EMFMjpCcW0fFcB5LgYfVGeUlHofIBwmwK7M+/dc=";
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
      hash = "sha256-Rcd4lrKloKRfYgKm+BP0N/+LKD+EocYNDE83MIAq86I=";
    };
    meta = {
      description = "Simple file locking scheme";
      license = with lib.licenses; [ artistic1 gpl2Plus ];
    };
  };

  LogAny = buildPerlPackage {
    pname = "Log-Any";
    version = "1.708";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PR/PREACTION/Log-Any-1.708.tar.gz";
      hash = "sha256-4UB3WdyUYqsJbU3cif6qyKuzQcVCnjjPb3uKmWo17Nk=";
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
      hash = "sha256-EZfT5BIhS+IIgAz3v1BXsf6hVCRTmip5J8/kb3FuwaU=";
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
      hash = "sha256-Ex8GibK0KxsxRJcUxu2o+BHdlqfIZ0jx4DsjnP0BIcA=";
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
      hash = "sha256-uTy8+7h5bVHINuOwAkPNpWMICMFSwU7uXyDKCclFGZM=";
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
      hash = "sha256-o9kcxSRn06PGaDED899EctceQFpF9VMolEhxOsQpPyE=";
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
      hash = "sha256-RyyxCw+sa71nKYvCjxSVhZrYWy356IxKH366c0+IlW4=";
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
      hash = "sha256-wuJBcu2iBD14bm4gUUG72xvei7Lt/CtjAtxPih46oDg=";
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
      hash = "sha256-OlyA5xKEVHcPg6yrjL0+cOXsPVmmHcMnkqF48LMb900=";
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
      hash = "sha256-vWl91iqvJtEY6fCggTQp3rHFRORQFVmHm2H8vf6Z/kY=";
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
      hash = "sha256-qhLRpMCsJguU1Ej6Af66JCqKhctsv9xmQy47W0aK3ZY=";
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
      hash = "sha256-nsuCWO8wwvJN7/SRckDQ/nMkLaWyGSQC95gVsJLtNuM=";
    };
    meta = {
      description = "Provides a unified approach to tracing";
      license = with lib.licenses; [ gpl1Only ];
    };
  };

  MCE = buildPerlPackage {
    pname = "MCE";
    version = "1.874";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARIOROY/MCE-1.874.tar.gz";
      hash = "sha256-2AnjAYR1EVrX7MuL70m9478+dau7zYBWRyi7z6uG09A=";
    };
    meta = {
      description = "Many-Core Engine for Perl providing parallel processing capabilities";
      homepage = "https://github.com/marioroy/mce-perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogLog4perl = buildPerlPackage {
    pname = "Log-Log4perl";
    version = "1.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/Log-Log4perl-1.57.tar.gz";
      hash = "sha256-D4/Ldjio89tMeX35T9vFYBN0kULy+Uy8lbQ8n8oJahM=";
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
      hash = "sha256-DCCTHC978mp2ugE3C5WCIV/lIWsWGCLAw/IEqB+4fzc=";
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
      hash = "sha256-KipBdq2vuFoeucncOJBSkZ6MLJ35mqulOMBrjalkpd8=";
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
      hash = "sha256-VZks+aHh+4M/QoMAUlv6fPftRrg+xBT4KgkXibN9CKM=";
    };
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.systemd ];
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
      hash = "sha256-BQn7i8VDrJZ1pI6xplpjUoYIxsP99ioZ4XBzUA5RGms=";
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
      hash = "sha256-1dZFbYaZK1Wdj2b8kJYPkZKSzTgDwTQD+qxXV2LHevQ=";
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
      hash = "sha256-lu7ECj/QqhvYNBF75eshxDj3MJTYYaGn5XdPCxImtyM=";
    };
    propagatedBuildInputs = [ FileListing HTMLParser HTTPCookies HTTPNegotiate NetHTTP TryTiny WWWRobotRules ];
    # support cross-compilation by avoiding using `has_module` which does not work in miniperl (it requires B native module)
    postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Makefile.PL --replace 'if has_module' 'if 0; #'
    '';
    doCheck = !stdenv.isDarwin;
    nativeCheckInputs = [ HTTPDaemon TestFatal TestNeeds TestRequiresInternet ];
    meta = {
      description = "The World-Wide Web library for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPAuthenOAuth = buildPerlPackage {
    pname = "LWP-Authen-OAuth";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMBRODY/LWP-Authen-OAuth-1.02.tar.gz";
      hash = "sha256-544L196AAs+0dgBzJY1VXvVbLCfAepSz2KIWahf9lrw=";
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
      hash = "sha256-jxvKEtqxahwqfAOknF5YzOQab+yVGfCq37qNrZl5Gdk=";
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
      hash = "sha256-nyUjlHdeI6pCwxdmEeWTBjirUo1RkBELRzGqWwvzWhU=";
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
      hash = "sha256-Fs/hpRFpCwZttWZ8hxSALuK5xdKKMaPnvTb7xwo69ZI=";
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
      hash = "sha256-8/+pEfnVkYHxcXkQ6iZiCQXCmLdNww99TlE57jAguNM=";
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
      hash = "sha256-mWl5RD8Ib/yLNmvbukSGWR2T+SF7wgSz5dZrlHIghx8=";
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
      hash = "sha256-BtjVDozTaSoRy0+0Si+E5UdqmPDi5qSg386fZ+Vd21M=";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A virtual browser that retries errors";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentMockable = buildPerlModule {
    pname = "LWP-UserAgent-Mockable";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJEMMESON/LWP-UserAgent-Mockable-1.18.tar.gz";
      hash = "sha256-JYZPUOOlIZ+J00oYQlmFSUWussXtSBjzbw8wIShUQyQ=";
    };
    propagatedBuildInputs = [ HookLexWrap LWP SafeIsa ];
    # Tests require network connectivity
    # https://rt.cpan.org/Public/Bug/Display.html?id=63966 is the bug upstream,
    # which doesn't look like it will get fixed anytime soon.
    doCheck = false;
    buildInputs = [ ModuleBuildTiny TestRequiresInternet ];
    meta = {
      description = "Permits recording, and later playing back of LWP requests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPxParanoidAgent = buildPerlPackage {
    pname = "LWPx-ParanoidAgent";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/lwp/LWPx-ParanoidAgent-1.12.tar.gz";
      hash = "sha256-zAQa7bdOGDzfkcvryhx71tdk/e5o+9yE8r4IveTg0D0=";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
    meta = {
      description = "Subclass of LWP::UserAgent that protects you from harm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  maatkit = callPackage ../development/perl-modules/maatkit { };

  MacPasteboard = buildPerlPackage {
    pname = "Mac-Pasteboard";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WY/WYANT/Mac-Pasteboard-0.011.tar.gz";
      hash = "sha256-vYxFELHoBcQ+S1UVXAvq8AK2Sf4wtqeEH/Bec5m6Aqk=";
    };
    buildInputs = [ pkgs.darwin.apple_sdk.frameworks.ApplicationServices ];
    meta = {
      description = "Manipulate Mac OS X pasteboards";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      platforms = lib.platforms.darwin;
      mainProgram = "pbtool";
    };
  };

  MailAuthenticationResults = buildPerlPackage {
    pname = "Mail-AuthenticationResults";
    version = "1.20200824.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-AuthenticationResults-1.20200824.1.tar.gz";
      hash = "sha256-M7qo4p+rDobNtHkNAJzFn3IlZyUWaCvHKy1MH4ahHpo=";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Object Oriented Authentication-Results Headers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailDMARC = buildPerlPackage {
    pname = "Mail-DMARC";
    version = "1.20230215";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-DMARC-1.20230215.tar.gz";
      hash = "sha256-V9z1R1nLkkSOVukUE0D2E0QnTFjZ3WWqkKqczw5+uQM=";
    };
    buildInputs = [ ExtUtilsMakeMaker FileShareDirInstall ];
    doCheck = false;  # uses actual DNS at runtime
    checkInputs = [ XMLSAX XMLValidatorSchema TestException TestFileShareDir TestMore TestOutput ];
    propagatedBuildInputs = [
      ConfigTiny DBDSQLite DBIxSimple EmailMIME EmailSender Encode FileShareDir GetoptLong
      IOCompress IO IOSocketSSL NetDNS NetIDNEncode NetIP NetSSLeay RegexpCommon Socket6
      SysSyslog URI XMLLibXML
    ];
    meta = {
      description = "Perl implementation of DMARC";
      homepage = "https://github.com/msimerson/mail-dmarc";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailMaildir = buildPerlPackage {
    version = "1.0.0";
    pname = "Mail-Maildir";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEROALTI/Mail-Maildir-100/Mail-Maildir-1.0.0.tar.bz2";
      hash = "sha256-RF6s2ixmN5ApbXGbypzHKYVUX6GgkBRhdnFgo6/DM88=";
    };
    meta = {
      description = "Handle Maildir folders";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailBox = buildPerlPackage {
    version = "3.009";
    pname = "Mail-Box";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Box-3.009.tar.gz";
      hash = "sha256-kYUhaw4UyRnsI4R2lSVVlJHtfVbSetsbyYWh++t5kWU=";
    };

    doCheck = false;

    propagatedBuildInputs = [ DevelGlobalDestruction FileRemove Later MailTransport ];
    meta = {
      description = "Manage a mailbox, a folder with messages";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailMboxMessageParser = buildPerlPackage {
    pname = "Mail-Mbox-MessageParser";
    version = "1.5111";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCOPPIT/Mail-Mbox-MessageParser-1.5111.tar.gz";
      hash = "sha256-VyPAqpzBC6ue0eO/2dXJX3FZ5xwaR1QU6xrx3uOkYjc=";
    };
    buildInputs = [ FileSlurper TestCompile TestPod TestPodCoverage TextDiff UNIVERSALrequire URI ];
    propagatedBuildInputs = [ FileHandleUnget ];
    meta = {
      description = "A fast and simple mbox folder reader";
      homepage = "https://github.com/coppit/mail-mbox-messageparser";
      license = with lib.licenses; [ gpl2Only ];
      maintainers = with maintainers; [ romildo ];
    };
  };

  MailMessage = buildPerlPackage {
    pname = "Mail-Message";
    version = "3.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Message-3.010.tar.gz";
      hash = "sha256-WEFLGuOCmIFTqRXTFyRdid1FDxhuz204PJZLNnOnixM=";
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
      hash = "sha256-q/8RvQl3ubjDssP8Kg290tONoklWhphxD+wQAtQlG/U=";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA MailAuthenticationResults MailTools NetDNS ];
    doCheck = false; # tries to access the domain name system
    buildInputs = [ NetDNSResolverMock TestRequiresInternet YAMLLibYAML ];
    meta = {
      description = "Signs/verifies Internet mail with DKIM/DomainKey signatures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailIMAPClient = buildPerlPackage {
    pname = "Mail-IMAPClient";
    version = "3.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.42.tar.gz";
      hash = "sha256-HCJk1QxUyDmj44zi+O3aPSTzDMYHlA11dL6rGcsAzn4=";
    };
    propagatedBuildInputs = [ ParseRecDescent ];
    meta = {
      description = "An IMAP Client API";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MailPOP3Client = buildPerlPackage {
    pname = "Mail-POP3Client";
    version = "2.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SD/SDOWD/Mail-POP3Client-2.19.tar.gz";
      hash = "sha256-EULWJHqTy4ayPtiDVVO7LSJ/+CE+4nQ+QVW7k/R6y1k=";
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
      hash = "sha256-NR70EE7LZ17K5pAIJD+ugkPRp+U8aB7rdZ57eBaEyKc=";
    };
    meta = {
      description = "Perl extension for validating email addresses according to RFC822";
      license = with lib.licenses; [ mit ];
    };
  };

  MailSender = buildPerlPackage {
    pname = "Mail-Sender";
    version = "0.903";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/Mail-Sender-0.903.tar.gz";
      hash = "sha256-RBPrSfUgqDGBUYEcywWo1UKXOq2iCqUDrTL5/8mKOb8=";
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
      hash = "sha256-W4qYy1zDnYBEGjiqsBCIXd+A5vzY5uAxQ5LLI+fCaOQ=";
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
      hash = "sha256-YctZFfHHrMepMf/Bv8EpG9+sVV4qRusjkbmV6p7LYWI=";
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
      hash = "sha256-Stm9aCa28DonJzMkZrG30piQyNmaMrSzsKjZJu4aRMs=";
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
      hash = "sha256-0Ny5P3BcEoXYCONN59htvijR7WaqKn3oMPZlH8NRlqM=";
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
      hash = "sha256-nqhYYA+SXh/8fwqGO3g1iS2Ymfz0Sz5QkOyjpGm5iw0=";
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
      hash = "sha256-jAlxNV8kyTt553rVSkVwCQoaWY/Lm4b1wX66QvOLQOA=";
    };
    meta = {
      description = "Very fast base to base conversion";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathLibm = buildPerlPackage {
    pname = "Math-Libm";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSLEWART/Math-Libm-1.00.tar.gz";
      hash = "sha256-v9MJ8oOsjLm/AK+MfDoQvyWr/WQoYcICLvr/CkpSwnY=";
    };
    meta = {
      description = "Perl extension for the C math library, libm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathCalcParser = buildPerlPackage {
    pname = "Math-Calc-Parser";
    version = "1.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Math-Calc-Parser-1.005.tar.gz";
      hash = "sha256-r8PrSWqzo6MBs0N68H4ZfrdDwGCQ8BAdrPggMC8rf3U=";
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
      hash = "sha256-YePP2ye7O+4nvrlxJN2TB2DhA57cHreBbC9WJ3Zfj48=";
    };
    meta = {
      description = "Human-readable unit-aware calculator";
      license = with lib.licenses; [ artistic1 gpl2Only ];
      mainProgram = "ucalc";
    };
  };

  MathBigInt = buildPerlPackage {
    pname = "Math-BigInt";
    version = "1.999818";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-1.999818.tar.gz";
      hash = "sha256-snY0NWzir5t8ASOsg5WomjL7Fa6ugvzTnegVbK0njBU=";
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
      hash = "sha256-XXJebSDMs34HJnNijwsN0Q5d0BFhn3D1CtWK3tRUwB8=";
    };
    buildInputs = [ pkgs.gmp ];
    doCheck = false;
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp.out}/lib -lgmp";
    propagatedBuildInputs = [ MathBigInt ];
    meta = {
      description = "Backend library for Math::BigInt etc. based on GMP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathBigIntLite = buildPerlPackage {
    pname = "Math-BigInt-Lite";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigInt-Lite-0.19.tar.gz";
      hash = "sha256-MPYDS/XSXAKBPISo5aKpivhuLbyoFJwlqSd3GN8mFRo=";
    };
    propagatedBuildInputs = [ MathBigInt ];
    meta = {
      description = "What Math::BigInts are before they become big";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathClipper = buildPerlModule {
    pname = "Math-Clipper";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHELDRAKE/Math-Clipper-1.29.tar.gz";
      hash = "sha256-UyfE8TOGbenXmzGGV/Zp7LSZhgVQs5aGmNRyiHr4dZM=";
    };
    nativeBuildInputs = [ pkgs.ld-is-cc-hook ];
    buildInputs = [ ExtUtilsCppGuess ExtUtilsTypemapsDefault ExtUtilsXSpp ModuleBuildWithXSpp TestDeep ];
    meta = {
      description = "Polygon clipping in 2D";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathConvexHullMonotoneChain = buildPerlPackage {
    pname = "Math-ConvexHull-MonotoneChain";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Math-ConvexHull-MonotoneChain-0.01.tar.gz";
      hash = "sha256-KIvEWQgmMkVUj5FIKrEkiGjdne5Ef5yibK15YT47lPU=";
    };
    meta = {
      description = "Andrew's monotone chain algorithm for finding a convex hull in 2D";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathFibonacci = buildPerlPackage {
    pname = "Math-Fibonacci";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPUL/Math-Fibonacci-1.5.tar.gz";
      hash = "sha256-cKgobpRVjfmdyS9S2D4eIKe494UrzDod59njOCYLmbo=";
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
      hash = "sha256-Ftpfge9SdChiuzyHhASq/bJM2rT4rL/KEoAzJIe8VV8=";
    };
    buildInputs = [ pkgs.gmp AlienGMP ];
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
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
      hash = "sha256-9EWe0y+5u3k+JQT9RCxRX9RopKNNKh+Y5GykHidcc8s=";
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
      hash = "sha256-cgdeTpiDzuUURrqVESZMjDKgFagPSlZIo/azgsU0QCw=";
    };
    propagatedBuildInputs = [ ClassAccessor ParamsValidate ];
    meta = {
      description = "Compute Voronoi diagrams from sets of points";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathInt128 = buildPerlPackage {
    pname = "Math-Int128";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Math-Int128-0.22.tar.gz";
      hash = "sha256-pjDKQBdThmlV8Rc4SKtbSsStXKatkIfxHN+R3ehRGbw=";
    };
    propagatedBuildInputs = [ MathInt64 ];
    meta = {
      description = "Manipulate 128 bits integers in Perl";
      homepage = "https://metacpan.org/release/Math-Int128";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.is32bit; # compiler doesn't support a 128-bit integer type
    };
  };

  MathInt64 = buildPerlPackage {
    pname = "Math-Int64";
    version = "0.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Math-Int64-0.54.tar.gz";
      hash = "sha256-3PxR5phDfqa5zv4CdiFcVs22p/hePiSitrQYnxlg01E=";
    };
    meta = {
      description = "Manipulate 64 bits integers in Perl";
      homepage = "https://metacpan.org/release/Math-Int64";
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
      hash = "sha256-kULyza8wg8iWLxpcK7Dp/okV99lJDAMxKsI2HH6hVfo=";
    };
    # Workaround build failure on -fno-common toolchains:
    #   ld: libPARI/libPARI.a(compat.o):(.bss+0x8): multiple definition of
    #   `overflow'; Pari.o:(.bss+0x80): first defined here
    env.NIX_CFLAGS_COMPILE = "-fcommon";
    preConfigure = "cp ${pari_tgz} pari-${pariversion}.tgz";
    makeMakerFlags = [ "pari_tgz=pari-${pariversion}.tgz" ];
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILYAZ/modules/Math-Pari-2.030518.zip";
      hash = "sha256-3DiVWpaQvmuvqN4lJiEjd8Psn+jaXsAiY6nK+UtYu5E=";
    };
    meta = {
      description = "Perl interface to PARI";
      license = with lib.licenses; [ artistic1 gpl1Plus gpl2Only ];
    };
  };

  MathPlanePath = buildPerlPackage {
    pname = "Math-PlanePath";
    version = "129";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/Math-PlanePath-129.tar.gz";
      hash = "sha256-jaFdDk1Qd7bF0gN2WyiFv3KOUJ4y3pJkYFwIYhN+OX4=";
    };
    propagatedBuildInputs = [ MathLibm constant-defer ];
    buildInputs = [ DataFloat MathBigIntLite NumberFraction ];
    meta = {
      description = "Points on a path through the 2-D plane";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  MathPrimeUtil = buildPerlPackage {
    pname = "Math-Prime-Util";
    version = "0.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANAJ/Math-Prime-Util-0.73.tar.gz";
      hash = "sha256-Svpt2M25dJm9TsppJYYYEsKdn1oPGsJ62dLZybVgKJQ=";
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
      hash = "sha256-JpfH/Vx+Nf3sf1DtVqZ76Aei8iZXWJ5jfa01knRAA74=";
    };
    buildInputs = [ pkgs.gmp ];
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
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
      hash = "sha256-MtzkKGHOBlqHWpHsFMZVfomvB98QzEUNHE3tE9y+PdU=";
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
      hash = "sha256-vgUiMogR2W3lBdnrrD0JY1kCb6jVw497uZmnjsW8JUw=";
    };
    meta = {
      description = "Random Number Generators";
      license = with lib.licenses; [ artistic1 gpl1Plus publicDomain ];
    };
  };

  MathRandomISAAC = buildPerlPackage {
    pname = "Math-Random-ISAAC";
    version = "1.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz";
      hash = "sha256-J3PwL78gfpdF52oDffCL9ajMmH7SPFcEDOf3sVYfK3w=";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      description = "Perl interface to the ISAAC PRNG algorithm";
      homepage = "https://search.cpan.org/dist/Math-Random-ISAAC";
      license = with lib.licenses; [ publicDomain mit artistic2 gpl1Plus ];
    };
  };

  MathRandomMTAuto = buildPerlPackage {
    pname = "Math-Random-MT-Auto";
    version = "6.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.23.tar.gz";
      hash = "sha256-WLy1rTFilk/1oMTS3LqgICwshdnEcElvO3qZh1d3YxM=";
    };
    propagatedBuildInputs = [ ObjectInsideOut ];
    meta = {
      description = "Auto-seeded Mersenne Twister PRNGs";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  MathRandomSecure = buildPerlPackage {
    pname = "Math-Random-Secure";
    version = "0.080001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FREW/Math-Random-Secure-0.080001.tar.gz";
      hash = "sha256-v6Sk6BfspyIGfB/z2hKrWrgNbFfapeXnq5NQyixx6zU=";
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
      hash = "sha256-c6cymoblSlwppEA4LlgDCVtY8zEp5hod8Ak7SCTekyc=";
    };
    meta = {
      description = "Perl extension for rounding numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MathVecStat = buildPerlPackage {
    pname = "Math-VecStat";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASPINELLI/Math-VecStat-0.08.tar.gz";
      hash = "sha256-QJqODksQJcjoD2KPZal3iqd6soUWFAbKSmwJexNlbQ0=";
    };
    meta = {
      description = "Some basic numeric stats on vectors";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MaxMindDBCommon = buildPerlPackage {
    pname = "MaxMind-DB-Common";
    version = "0.040001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Common-0.040001.tar.gz";
      hash = "sha256-a8bfS9NjANB6pKX4GYrmaUyn4xPAOBCciNvDqZeyG9c=";
    };
    propagatedBuildInputs = [ DataDumperConcise DateTime ListAllUtils MooXStrictConstructor ];
    meta = {
      description = "Code shared by the MaxMind DB reader and writer modules";
      homepage = "https://metacpan.org/release/MaxMind-DB-Common";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MaxMindDBReader = buildPerlPackage {
    pname = "MaxMind-DB-Reader";
    version = "1.000014";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Reader-1.000014.tar.gz";
      hash = "sha256-OCAHj5yWf5qIch6kDKBeSZnBxTAb68HRGQYPntXOOak=";
    };
    propagatedBuildInputs = [ DataIEEE754 DataPrinter DataValidateIP MaxMindDBCommon ];
    buildInputs = [ PathClass TestBits TestFatal TestNumberDelta TestRequires ];
    meta = {
      description = "Read MaxMind DB files and look up IP addresses";
      homepage = "https://metacpan.org/release/MaxMind-DB-Reader";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MaxMindDBReaderXS = buildPerlModule {
    pname = "MaxMind-DB-Reader-XS";
    version = "1.000008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Reader-XS-1.000008.tar.gz";
      hash = "sha256-hKr7yC+sjP7q2amOLkhX2+v0Sem4Ff6QiRUNf04Nx4c=";
    };
    propagatedBuildInputs = [ pkgs.libmaxminddb MathInt128 MaxMindDBReader ];
    buildInputs = [ NetWorks PathClass TestFatal TestNumberDelta TestRequires ];
    meta = {
      description = "Fast XS implementation of MaxMind DB reader";
      homepage = "https://metacpan.org/release/MaxMind-DB-Reader-XS";
      license = with lib.licenses; [ artistic2 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.MaxMindDBReaderXS.x86_64-darwin
    };
  };

  MaxMindDBWriter = buildPerlModule {
    pname = "MaxMind-DB-Writer";
    version = "0.300003";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/MaxMind-DB-Writer-0.300003.tar.gz";
      hash = "sha256-ulP1upZfekd/ZxZNl7R1oMESCIcv7fI4mIVQ2SvN6z4=";
    };
    propagatedBuildInputs = [ DigestSHA1 MaxMindDBReader MooseXParamsValidate MooseXStrictConstructor NetWorks SerealDecoder SerealEncoder ];
    buildInputs = [ DevelRefcount JSON TestBits TestDeep TestFatal TestHexDifferences TestRequires TestWarnings ];
    hardeningDisable = [ "format" ];
    meta = {
      description = "Create MaxMind DB database files";
      homepage = "https://metacpan.org/release/MaxMind-DB-Writer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.MaxMindDBWriter.x86_64-darwin
    };
  };

  Memoize = buildPerlPackage {
    pname = "Memoize";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MJ/MJD/Memoize-1.03.tgz";
      hash = "sha256-UjnMX2RKULDen/6qUfqZkesG7LG/RniHPjq4mvnA2vM=";
    };
    meta = {
      description = "Make functions faster by trading space for time";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MemoizeExpireLRU = buildPerlPackage {
    pname = "Memoize-ExpireLRU";
    version = "0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Memoize-ExpireLRU-0.56.tar.gz";
      hash = "sha256-7oNjAcu6uaJLBfxlft+pS3/YV42YNuVmoZHQpbAc1/Y=";
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
      hash = "sha256-O1c/aOezo2qHyGC+JYWZMw+sJItRiFTftWV6xIPcpWU=";
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
      hash = "sha256-pqysP+4xioBLQ53lSsvHwn8LRM/a2FUbvJzUWYarwgE=";
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
      hash = "sha256-rLSZqnIG652yHrhTV6dFIb/jva5KZBbVCnx1uTnPVv4=";
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
      hash = "sha256-xdiDkDs3mlpq2wLgFuxbUiiK8FZS1WTIlTFlk/PH5Xw=";
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
      hash = "sha256-yM19Rxl3zIh2BEGSq9mKga/d/yomu5oQu+NY76Nx2tw=";
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
      hash = "sha256-nFKd+Oiid7sVjWJBxzvRp+oIrq6eHtu1WDoaB0j7mDc=";
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
      hash = "sha256-+L8odObqN4MLDVFV+5ms94gAWHffdXPxJ2NE6Ufag1I=";
    };

    patches = [ ../development/perl-modules/mhonarc.patch ];

    outputs = [ "out" "dev" ]; # no "devdoc"

    installTargets = [ "install" ];

    meta = {
      homepage = "https://www.mhonarc.org/";
      description = "A mail-to-HTML converter";
      mainProgram = "mhonarc";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  MIMECharset = buildPerlPackage {
    pname = "MIME-Charset";
    version = "1.013.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-Charset-1.013.1.tar.gz";
      hash = "sha256-G7em4MDSUfI9bmC/hMmt78W3TuxYR1v+5NORB+YIcPA=";
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
      hash = "sha256-TNe7YbUdQRktFJjBBRqmpMzXWusJtx0uxwanCEpKkwM=";
    };
    outputs = [ "out" ];
    buildInputs = [ ProcWaitStat ];
    meta = {
      description = "Construct and optionally mail MIME messages";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  MIMEEncWords = buildPerlPackage {
    pname = "MIME-EncWords";
    version = "1.014.3";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-EncWords-1.014.3.tar.gz";
      hash = "sha256-6a+1SGEdTn5sULfwa70rG7KAjjeoEN7vtTfGevVIUjg=";
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
      hash = "sha256-8SNYZkgrZ/AIWLPtqk/0z5Ce+QDx0V2ImUi/nAOlkeA=";
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
      hash = "sha256-22A8y/ZlO80oz6gk1y5RHq0Bn8ivufGFTshy2y082No=";
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
      hash = "sha256-ZFefDJI9gdmiGUWG5Hw0dVGeJkbktcECqJIHWfrPaXM=";
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
      hash = "sha256-Mco1pB8q6ZjM19M8GeQgI+5lQP2d7WGbmr1I/waglb4=";
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
      hash = "sha256-C+CoN1N2iJ2gRgRpY4TAz5iyYh0mUNnrAwf25LlAra0=";
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
      hash = "sha256-/uDUEe9WsAkru8BTN5InaH3hQZUoy2t0T3U9vcH7FNk=";
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
      hash = "sha256-cGS+CHHxmbSwTl1yQprfNbLkr2qHGorM0Mm1wqP9E00=";
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
      hash = "sha256-ffIGeEdMCXOTCkcrDFXj+Ohbd5C2irGO9hj5xFPIrvI=";
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
      hash = "sha256-WGiA7QwggBq79nNHR+E+AgPt7+zm68TyDdtQWfAqF6I=";
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
      hash = "sha256-kdJBUjkfjCeX7jUDkTja6m3j7gO98+G4ck+lx1VAzrk=";
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
      hash = "sha256-pbg0V1fKTyuTNfW+FOk+u7UChlIzp1W/U7xxVt7sABs=";
    };
    meta = {
      description = "Temporarily set Config or XSConfig values";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModernPerl = buildPerlPackage {
    pname = "Modern-Perl";
    version = "1.20200211";

    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20200211.tar.gz";
      hash = "sha256-2hyDzuhPq57bnjHX96usQ+Ezey5mAVGR7EttpZKYxIA=";
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
      hash = "sha256-iEk/pG307LIe8RdaNJTyUQsGc+nNtN2AVzzo9nhhvaE=";
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
      hash = "sha256-fg9MaSwXQMGshOoU1+o9i8eYsvsmwJh3Ip4E9DCytxc=";
    };
    postConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      # for unknown reason, the first run of Build fails
      ./Build || true
    '';
    postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      # remove version check since miniperl uses a stub of File::Temp, which do not provide a version:
      # https://github.com/arsv/perl-cross/blob/master/cnf/stub/File/Temp.pm
      sed -i '/File::Temp/d' \
        Build.PL

      # fix discover perl function, it can not handle a wrapped perl
      sed -i "s,\$self->_discover_perl_interpreter,'$(type -p perl)',g" \
        lib/Module/Build/Base.pm
    '';
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
      hash = "sha256-vgiTE/wjjuIYNHOsqMhrVfs89EeXMSy+m4ktY2JiFwM=";
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
      hash = "sha256-5bsqyxF3ksmEYogSrLD+w3bLlwyu6O3ldTXgTXYrDkA=";
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
      hash = "sha256-SuxsuiQMtueAFkBrajqHVjTMKuwI/8XxVy2hzcQOHnw=";
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
      hash = "sha256-RAhLo9iBXzQ705FYWsXYM5pIB85cDdhMmNuPMQtkwOo=";
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
      hash = "sha256-fVgP9qzgy+VVvza4bcjqIyWBUwy+quoJvMtXtVeX8Rw=";
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
      hash = "sha256-U7PIyP29UPw9rT0Z2iDxtkFO9wZluTEXEMgClp50aTQ=";
    };
    propagatedBuildInputs = [ ExtUtilsCppGuess ExtUtilsXSpp ];
    meta = {
      description = "XS++ enhanced flavour of Module::Build";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildXSUtil = buildPerlModule {
    pname = "Module-Build-XSUtil";
    version = "0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/Module-Build-XSUtil-0.19.tar.gz";
      hash = "sha256-kGOzw0bt60IoB//kn/sjA4xPkA1Kd7hFzktT2XvylAA=";
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
      hash = "sha256-gJDPu2ESNDfu/sPjvthgBdH3xaUp+2/aLr68ZWS5qhA=";
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
      hash = "sha256-vZkLpNAFG22yKEyrhAaZ4zr1QtiBgv1FTPpw6tMeyEk=";
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
      hash = "sha256-iO++LppkLc6qGGQw/t/PmZqvDgb2zO0opxS45WtRSSE=";
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
      hash = "sha256-SFJGW0g2GhIM15hyBYF5Lbpa2lJs7vWJHiVNbPl7DAI=";
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
      hash = "sha256-XFSCp/4+nhA1s2qYRHC4hvevCV7u/2P18ZrsjNLYqF4=";
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
      hash = "sha256-wV8aEvDCEwye//PC4a/liHsIzNAzvRMhhtHn1Qh/1m0=";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      description = "Loads one of several alternate underlying implementations for a module";
      homepage = "https://metacpan.org/release/Module-Implementation";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  ModuleInfo = buildPerlPackage {
    pname = "Module-Info";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Module-Info-0.37.tar.gz";
      hash = "sha256-jqgCUpeQsZwfNzoeR9g4FmT5xMH3ao2LvG221zEcJEg=";
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
      hash = "sha256-GlOnjd86uePAP8XjVLQ2MZqUTLpCgbrwuQT6kyoTARs=";
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
      hash = "sha256-zGMhU310XSqDqChvhe8zRnRZOcw7NBAgRb7IVg6PTOw=";
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
      hash = "sha256-QCVyLeY1ft9TwoUBsA59qSzS+fxhG6B1N2Gg4d/zLYg=";
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
      hash = "sha256-Lq1EyXPHSNctnxmeQcRNwYAf6a4GsPrcWUR2k6PJgoE=";
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
      hash = "sha256-efbfVTZhn6/72mlr3SXMrRfEab8y5RzT5hM2bUlAAWk=";
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
      hash = "sha256-MAsuJE+DuaVKlfhATBzTrwY1tPrpdMplOQ7kKOxmhZE=";
    };
    buildInputs = [ URI ];
    propagatedBuildInputs = [ ModuleInstall PodMarkdown ];
    meta = {
      description = "Create README.mkdn from POD";
      homepage = "https://search.cpan.org/dist/Module-Install-ReadmeMarkdownFromPod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.sgo ];
    };
  };

  ModuleInstallRepository = buildPerlPackage {
    pname = "Module-Install-Repository";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Module-Install-Repository-0.06.tar.gz";
      hash = "sha256-AOJZDQkznMzL2qMo0SrY7HfoMaOMmtZjcF5Z7LsYcis=";
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
      hash = "sha256-/nHlMyC+4TGXdJoLF2CaomP3H/RuXiwTDpR0Lqar31Y=";
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
      hash = "sha256-o5X4D/FeoOZv1sRThEtnh+1Kh1o82N+ffikoAlC9U5s=";
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
      hash = "sha256-szF5zk3XPfzefUaAiAS5/7sR2wJF/kVafQAXR1Yv6so=";
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
      hash = "sha256-s/KtReT9ELP7kNkS142LeVqylUgNtW3GToa5+nXFpt8=";
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
      hash = "sha256-CMhXcFjxmTLKG2Zre5EmoYtVajmwi+b7ObBqRTkqB18=";
    };
    propagatedBuildInputs = [ UNIVERSALrequire ];
    meta = {
      description = "Fast plugins with instantiation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRefresh = buildPerlPackage {
    pname = "Module-Refresh";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXMV/Module-Refresh-0.17.tar.gz";
      hash = "sha256-azCmzt3GUSq0SQwWNy7PMJolnyyhR9Yi5HisVOCFEcM=";
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
      hash = "sha256-aDAuxkaDNUfUEL4o4JZ223UAb0qlihHzvbRP/pnw8CQ=";
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
      hash = "sha256-cHzcdQOMcP6Rd5uIisBQ8ShWXTlnupZoDhscfMlzOHU=";
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
      hash = "sha256-7rDOkTU6L2JnpkrxeyDY3o96z/YulbYI3qJIAwC4iE4=";
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
      hash = "sha256-IU6AVcUP7DcalXQ1IP4mlAAE52FpBjsrROyQoNRdaYI=";
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
      hash = "sha256-bPvLakUGREbsiqDuGn3dxCC1RGkwM0QYeu+E0sfz4sY=";
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
      hash = "sha256-DTimWxenrFGI1zh8/+f6oSY4Rw3JNxYevz2kh7fR+Dw=";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      description = "Handle versions of loaded modules with flexible result interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleVersionsReport = buildPerlPackage {
    pname = "Module-Versions-Report";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/Module-Versions-Report-1.06.tar.gz";
      hash = "sha256-oyYdDYSxdnjYxP1V6w+JL1FE2BylPqmjjXXRoArZeWo=";
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
      hash = "sha256-hkxqNXH7SYaprgrw8shArLEC8fc6Gq8Cewa0K40EXvM=";
    };
    meta = {
      description = "Minimalistic HTML/XML DOM parser with CSS selectors";
      homepage = "https://github.com/Grinnz/Mojo-DOM58";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  mod_perl2 = buildPerlPackage {
    pname = "mod_perl";
    version = "2.0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHAY/mod_perl-2.0.12.tar.gz";
      hash = "sha256-9bghtZsP3JZw5G7Q/PMtiRHyUSYYmotowWUvkiHu4mk=";
    };

    makeMakerFlags = [ "MP_AP_DESTDIR=$out" ];
    buildInputs = [ pkgs.apacheHttpd ];
    doCheck = false; # would try to start Apache HTTP server
    passthru.tests = nixosTests.mod_perl;
    meta = {
      description = "Embed a Perl interpreter in the Apache/2.x HTTP server";
      license = with lib.licenses; [ asl20 ];
      mainProgram = "mp2bug";
    };
  };

  Mojolicious = buildPerlPackage {
    pname = "Mojolicious";
    version = "9.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-9.26.tar.gz";
      hash = "sha256-nkKMVRJpjwXhUTONj6Eq7eKHqzpeQp7D04yApKgsjYg=";
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
      hash = "sha256-8j2HYgo92IoFoZ+aKovRn6UboGDdy0vMHZsfBo73pIg=";
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
      hash = "sha256-pJ+XDGxw+ZMLMEp1IWPLlfHZmHEvecsTZAgy5Le2dd0=";
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
      hash = "sha256-VvDTQevDp6zzkZ9a3UPpghbqEoWqDYfn+wDAK7Dv8UY=";
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
      hash = "sha256-xH+I0c434/YT9uizV9grenEEX/wKSXOVUS67zahlYV0=";
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
      hash = "sha256-TCsfr+PhkSYby0TiDo75rz+YjR25akrgsG7tQSArh7Q=";
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
      hash = "sha256-IuxL9TYwDseyAYuoV3C9g2ZFDBAwVDZ9srFp9Mh3QRM=";
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
      hash = "sha256-Oht0BcV4TO5mHP8bARpzlRBN1IS7kbnnWT+ralOb+HQ=";
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
      hash = "sha256-detndnGR/zMzwNAXsK1vZxHHxIW66i5+6XtTtPzJzfA=";
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
      hash = "sha256-oDMZpF0uYTpsfS1ZrAD9SwtHiGVi5ish3pG0r4llgII=";
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
      hash = "sha256-csJMrNtvHXp14uqgBDfHFKv1eafSENSqTT8g8e/0cQ0=";
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
      hash = "sha256-Qf3LUFrH9OzUdWez2utcKHyITJE0DG27a7+pkqH/9yo=";
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
      hash = "sha256-YC14GXw0HdCPLLH1XZg31P3gFHQz1k2+vxloaAtVzMs=";
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
      hash = "sha256-jsvAYUg3IdkgRZQya+zpXM2/vbbRihc8gt1xgXLQqe0=";
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
      hash = "sha256-8dpdh4RxvdhvAcQjhQgAgE9ttCtUU8IW8Jslt5RYS3g=";
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
      hash = "sha256-wE4DmD4MbyvORdCOoucph5yWee+mNLDmjLa4t7SoWIY=";
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
      hash = "sha256-oyLI3wDj5WVf300LernXmSiTIOKfZP6ZrHrxJEhO+dg=";
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
      hash = "sha256-wlmZ2qqCHkZUhLWjINFVqlJZAMh4Ml2aiSAfSnWBxd8=";
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
      hash = "sha256-IBk1+S2slPOcNd5zZh6LJSQ55JbyKGV9uF/5MlfDJo8=";
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
      hash = "sha256-+LprfifSuwpPmjKVWiRC1OQo0cSLgMixIUL/YRvnI28=";
    };
    propagatedBuildInputs = [ ClassAccessor ConfigTiny MathCalcUnits ParamsValidate ];
    meta = {
      description = ''
        A family of perl modules to streamline writing Naemon,
        Nagios, Icinga or Shinken (and compatible) plugins
      '';
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOPipely = buildPerlPackage {
    pname = "IO-Pipely";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCAPUTO/IO-Pipely-0.005.tar.gz";
      hash = "sha256-4zts9csrRu4whRP1HmI5h6UKiZAegb8ZcB3ONRefLnQ=";
    };
    meta = {
      description = "Portably create pipe() or pipe-like handles, one way or another";
      homepage = "https://search.cpan.org/dist/IO-Pipely";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moo = buildPerlPackage {
    pname = "Moo";
    version = "2.004004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Moo-2.004004.tar.gz";
      hash = "sha256-cUt3sRV4hwjG2KtvGO6hc/gQnTl67NNOMsxxoP/PIkY=";
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
      hash = "sha256-33TceAiJIReO33LYJwF9bJJzfJhmWfLa3FM64kZ153w=";
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
      hash = "sha256-cWNT44iU7Lfo5MF7yVSD219ZACsDVBtUpywn8qjzbBI=";
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
      hash = "sha256-egWCflKrWh3eLqXHEpJ7HljI0lFmTZZmJ6353TDsBRI=";
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
      hash = "sha256-W45Sz/3YSpXTaMoQuUNUG5lqk+DQY5b0/hkzVojkFz0=";
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
      hash = "sha256-TfnVdPjybbAivwbBvaRwgolFEJjC4VYzNd840jsHMm0=";
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
      hash = "sha256-99dib//emPhewSwe4msB8Tmk3d0vRT6lbDQd8ZTjIQ4=";
    };
    propagatedBuildInputs = [ RoleTiny ];
    buildInputs = [ Moo ];
    meta = {
      description = "Turn your Moo class into singleton";
      homepage = "https://search.cpan.org/dist/MooX-Singleton";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXStrictConstructor = buildPerlPackage {
    pname = "MooX-StrictConstructor";
    version = "0.011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HARTZELL/MooX-StrictConstructor-0.011.tar.gz";
      hash = "sha256-2jgvgi/8TiKgOqQZpCVydJmdNtiaThI27PT892vGU+I=";
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
      hash = "sha256-HTeAqpvqQwr75lqox25xjxBFzniKrdpBFvWdO3p60rQ=";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    buildInputs = [ Moo TestFatal ];
    meta = {
      description = "Some Moosish types and a type builder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXTypesMooseLikeNumeric = buildPerlPackage {
    pname = "MooX-Types-MooseLike-Numeric";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-Numeric-1.03.tar.gz";
      hash = "sha256-Fq3rYXuWPQEBeZIsLk6HYt93x1Iy4XMgtFmGjElwxEs=";
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
      hash = "sha256-2B4m/2+NsQJh8Ah/ltxUNn3LSanz3o1TI4+DTs4ZYks=";
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
      hash = "sha256-kkAdpM9ITrcYjsGWtoGG76eCoQK0UeoVbNi4dy5ocFU=";
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
      hash = "sha256-Tr7suUbkVSssRyH1u/I+9huTJlELVzlr9ZkLEW8Dfuo=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Abstract base classes for Moose";
      homepage = "https://metacpan.org/release/MooseX-ABC";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXAliases = buildPerlPackage {
    pname = "MooseX-Aliases";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-Aliases-0.11.tar.gz";
      hash = "sha256-xIUPlyQmw0R6ru2Ny0Az6ERgylFwWtPqeLY6+Rn+B0g=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Easy aliasing of methods and attributes in Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXAppCmd = buildPerlModule {
    pname = "MooseX-App-Cmd";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-App-Cmd-0.32.tar.gz";
      hash = "sha256-Lju/coOkvuctkdJusgRDYDCZK75Vy9NewzpUbxb5c/8=";
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
      hash = "sha256-6+BAen6xhwJw4OJXnwl9/X3yrqMwf7cfMk+2niQsxY8=";
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
      hash = "sha256-L/kaZW54quCspCKTgp16flrLm/IrBAFjWyq2yHDeMtU=";
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
      hash = "sha256-AWAxJ4ysYSY9AZUt/lv7XztGtLhCsv/6nyybiKrGOGc=";
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
      hash = "sha256-lD/yjaqAiXMnx8X+xacQDPqsktrw+fl8OOOnfQCucPU=";
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
      hash = "sha256-KuWx49pavA5ABieOy8+o+nwiTqVSmmpoisuyKcCeal8=";
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
      hash = "sha256-JX84QJHTPTQDc6YVOUcDnGmNxEnR75iTNWRPw9LaAGk=";
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
      hash = "sha256-GKz35YnKTMqc3kdgm1NsnYI8hWLRqlIQwWjl6xuOT54=";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork pkgs.postgresql ];
    propagatedBuildInputs = [ DBDPg DBI FileWhich FunctionParameters Moo TieHashMethod TryTiny TypeTiny ];

    makeMakerFlags = [ "POSTGRES_HOME=${pkgs.postgresql}" ];

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
      hash = "sha256-px8v6LlquL/Cdgqh0xNeoEmlsg3LEFRXt2mhGVx6JQk=";
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
      hash = "sha256-GDinoV/ueo8Gnk5rRhxeFpBYthW437Q3hLPV2hpggRs=";
    };
    propagatedBuildInputs = [ EnvSanctify FileHomeDir PerlDestructLevel XMLTwig ];
    meta = {
      description = "Generate suppressions, analyse and test any command with valgrind";
      homepage = "https://search.cpan.org/dist/Test-Valgrind";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXTypesPathClass = buildPerlPackage {
    pname = "MouseX-Types-Path-Class";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MASAKI/MouseX-Types-Path-Class-0.07.tar.gz";
      hash = "sha256-Io1LTz8O2VRyeGkdC3xf5T2Qh0pp33CaSXA8avh8Cd4=";
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
      hash = "sha256-dyiEQf2t0Vvu7JoIE+zorsFULx2M6q7BR1Wz8xb7z4s=";
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
      hash = "sha256-khsxyxP8H5gqYC+OI4Fbet0joiQlfkN5Dih1BM6HlTQ=";
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
      hash = "sha256-3j6o70Ut2VAeqMTtqHRLciRgJgKwRpJgft19YrefA48=";
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
      hash = "sha256-5+OKp8O3i1c06dQ892gy/OAHZ+alPV3Xmhci2GdtXk4=";
    };
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Attribute that returns the instance to allow for chaining";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXAttributeHelpers = buildPerlModule {
    pname = "MooseX-AttributeHelpers";
    version = "0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-AttributeHelpers-0.25.tar.gz";
      hash = "sha256-sMgZ7IOZmyWLJI+CBZ+ll1oM7jZUI6u+4O+spUAcXsY=";
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
      hash = "sha256-y9eCXbnnSwU/UkVEoBTwZv3OKQMW67Vo+HZ5GBs5jac=";
    };
    propagatedBuildInputs = [ DataVisitor HashUtilFieldHashCompat namespaceautoclean ];
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "Fine-grained cloning support for Moose objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXConfigFromFile = buildPerlModule {
    pname = "MooseX-ConfigFromFile";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-ConfigFromFile-0.14.tar.gz";
      hash = "sha256-mtNDzZ+G1xS+m1S5xopEPYrMZQG2rWsV6coBMLLpbwg=";
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
      hash = "sha256-in+5mdypuAKoUTahAUGy0zeKPs3gUnwd9z1V7bKOWbM=";
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
      hash = "sha256-gu637x8NJUGK5AbqJpErJBQo1LKrlRDV6d6z9ywYeZQ=";
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
      hash = "sha256-HeDfO0Mevp81Y730Vp6s1+B+hlqDl/KpkNDLV9TLLCQ=";
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
      hash = "sha256-B8Ic+O1QCycgIP+NoZ8ZRyi7QU4AEqLwzFTvLvYiKmg=";
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
      hash = "sha256-7+7T3bOo6hj0FtSF88KwQnFF0mfmM2jGUdSI6qjCjQk=";
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
      hash = "sha256-72IMHgGdr5zz8jqUPSWpTJHpOrMSvNY74ul0DsC5Qog=";
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
      hash = "sha256-yezBM3bQ/326SBl3M3wz6nTl0makKLavMVUqKRnvfvg=";
    };
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Mark overload code symbols as methods";
      homepage = "https://metacpan.org/release/MooseX-MarkAsMethods";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    pname = "MooseX-MethodAttributes";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.32.tar.gz";
      hash = "sha256-yzOIZXS30t05xCwNzccHrNsK7H273pohwEImYDaMGXs=";
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
      hash = "sha256-y75S7PFgOCMfvX8sxrzhZqNWnIyzlq6A7EUXwuCNqn0=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      homepage = "https://metacpan.org/release/MooseX-NonMoose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXOneArgNew = buildPerlPackage {
    pname = "MooseX-OneArgNew";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-OneArgNew-0.005.tar.gz";
      hash = "sha256-fk/PR06mxCRPCIXxBmcpz9xHL71xkN1BtLVbzWfDED8=";
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
      hash = "sha256-MNt6I33SYCIhb/+5cLmFKFNHEws2kjxxGqCVaty0fp8=";
    };
    propagatedBuildInputs = [ MooseXRoleParameterized ];
    meta = { description = "Apply roles to a class related to yours";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXParamsValidate = buildPerlPackage {
    pname = "MooseX-Params-Validate";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Params-Validate-0.21.tar.gz";
      hash = "sha256-iClURqupmcu4+ZjX+5onAdZhc5SlHW1yTHdObZ/xOdk=";
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
      hash = "sha256-HP52bF1/Dsq1f3M9zKQwoqKs1rmVdXFBuUCt42kr7J4=";
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
      hash = "sha256-krCV1z8SIPnC7S06qlugcutaot4gm3xFXaWocBuYaGU=";
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
      hash = "sha256-QNj9G1UkrpZZZaHxRNegoMhQWUxSRAKyMZsk1cSvEZk=";
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
      hash = "sha256-pbhXdrzd7RaAJ6H/ZktBxfZYhnIc3VQ+OvnVN1misdU=";
    };
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Name your accessors foo() and set_foo()";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MooseXSetOnce = buildPerlPackage {
    pname = "MooseX-SetOnce";
    version = "0.200002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/MooseX-SetOnce-0.200002.tar.gz";
      hash = "sha256-y+0Gt/zTU/DZm/gKh8HAtYEWBpcjGzrZpgjaIxuitlk=";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Write-once, read-many attributes for Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXSingleton = buildPerlModule {
    pname = "MooseX-Singleton";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Singleton-0.30.tar.gz";
      hash = "sha256-ZYSy8xsdPrbdfiMShzjnP2wBWxUhOLCoFX09DVnQZUE=";
    };
    buildInputs = [ ModuleBuildTiny TestFatal TestRequires TestWarnings ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Turn your Moose class into a singleton";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXStorage = buildPerlPackage {
    pname = "MooseX-Storage";
    version = "0.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Storage-0.53.tar.gz";
      hash = "sha256-hwS/5QX2azQPYuhcn/MZwZ6WcLJtSwEskfThA7HarOA=";
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
      hash = "sha256-xypa6Vg3Bszexx1AHcswVAE6dTa3UN8UNmE9hY6ikg0=";
    };
    buildInputs = [ Moo TestFatal TestNeeds ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Make your object constructors blow up on unknown attributes";
      homepage = "https://metacpan.org/release/MooseX-StrictConstructor";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  MooseXTraits = buildPerlModule {
    pname = "MooseX-Traits";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Traits-0.13.tar.gz";
      hash = "sha256-dK/gxPr047l8V/KJQ3yqYL7Mo0zVgh9IndTMnaT74po=";
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
      hash = "sha256-q5a3lQ7L8puDb9/uu+Cqwiylc+cYO+fLfW0S3yKrWMo=";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils Moose namespaceautoclean ];
    meta = {
      description = "Trait loading and resolution for Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypes = buildPerlModule {
    pname = "MooseX-Types";
    version = "0.50";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-0.50.tar.gz";
      hash = "sha256-nNh7NJLL8L6dLfkxeyrfn8MGY3cOaZBmVL6j9BsXywg=";
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
      hash = "sha256-75Nxi20vJA1QtcOssadLTCoZGGllFHAAGoK+HzXQ7w8=";
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
      hash = "sha256-uJ+iZjb2oX6qOGi0UUNARytou9whYaHXmiKhv1sdOcY=";
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
      hash = "sha256-Ibs6WXcZiI7bbOqhMkGNXPkuy5KlDM43uUJZpV4ON5Y=";
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
      hash = "sha256-4DfTd4JT3PkpRkNXFbraDmRJwKKAj6P/MqllBk1aO/Q=";
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
      hash = "sha256-54S6tTaYrpWnCahmMwYUX/7FVmjfbPMWFTM1I/vn734=";
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
      hash = "sha256-Ge7eAt1lTnD3PjTNevAGN2UXO8rv7v8b2+ITGOz9kVg=";
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
      hash = "sha256-8IS+rzwzIJxo0F1NvCTCXWBKZFi5c42W3OsIbI7xMlo=";
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
      hash = "sha256-LuNJ7FxSmm80f0L/ZA5HskVWS5PMowXfY8eCH1tVzxk=";
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
      hash = "sha256-Q822UvljhyPjV3yw+LVGhiAkTJY252WYEeW0qAFgPVc=";
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
      hash = "sha256-0xDSD6Nh/i3/dYI234eUnMe/mOXPOnx5EVNl7M3mzME=";
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
      hash = "sha256-V2I0BzJCHyUCp3DWoSblhPLNljNR0rwle9J4w5vOi+c=";
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
      hash = "sha256-qqxI9GN+3KQI/Xk4G8C/8PmxG9jh6U3gWdrpkzZfVtE=";
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
      hash = "sha256-zo3COUYVOkZ/8JdlFn7iWQ9cUCEg9IotlEFzPzmqMu4=";
    };
    buildInputs = [ ModuleBuildXSUtil TestException TestFatal TestLeakTrace TestOutput TestRequires TryTiny ];
    perlPreHook = "export LD=$CC";
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-fno-stack-protector";
    hardeningDisable = lib.optional stdenv.isi686 "stackprotector";
    meta = {
      description = "Moose minus the antlers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MouseXNativeTraits = buildPerlPackage {
    pname = "MouseX-NativeTraits";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/MouseX-NativeTraits-1.09.tar.gz";
      hash = "sha256-+KW/WihwLfsTyAk75cQcq5xfwcXSR6uR4i591ydky14=";
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
      hash = "sha256-s8oAAjEL8koWwNWSC96pei9G53574+c3foUNAzOHxyY=";
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
      hash = "sha256-iiw7bMwZMo1VedAqfZEoXir9hdgB9J1COo6xbzI9pPg=";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      homepage = "https://metacpan.org/release/MRO-Compat";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MsgPackRaw = buildPerlPackage rec {
    pname = "MsgPack-Raw";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JACQUESG/MsgPack-Raw-${version}.tar.gz";
      hash = "sha256-hVnitkzZjZmrxmbt8qTIckyVNGEmFq8R9OsLvQ1CLaw=";
    };
    checkInputs = [ TestPod TestPodCoverage ];
    meta = with lib; {
      description = "Perl bindings to the msgpack C library";
      homepage = "https://github.com/jacquesg/p5-MsgPack-Raw";
      license = with licenses; [ gpl1Plus /* or */ artistic1 ];
      maintainers = with maintainers; [ figsoda ];
    };
  };

  MusicBrainzDiscID = buildPerlPackage {
    pname = "MusicBrainz-DiscID";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NJ/NJH/MusicBrainz-DiscID-0.06.tar.gz";
      hash = "sha256-ugtu0JiX/1Y7pZhy7pNxW+83FXUVsZt8bW8obmVI7Ks=";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    # Makefile.PL in this package uses which to find pkg-config -- make it use path instead
    patchPhase = ''sed -ie 's/`which pkg-config`/"pkg-config"/' Makefile.PL'';
    doCheck = false; # The main test performs network access
    nativeBuildInputs = [ pkgs.pkg-config ];
    propagatedBuildInputs = [ pkgs.libdiscid ];
    meta = {
      description = "- Perl interface for the MusicBrainz libdiscid library";
      license = with lib.licenses; [ mit ];
    };
  };

  MusicBrainz = buildPerlModule {
    pname = "WebService-MusicBrainz";
    version = "1.0.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BF/BFAIST/WebService-MusicBrainz-1.0.5.tar.gz";
      hash = "sha256-UjuDmWggbFdR6p7mcMeJLIw74PWTqlkaAMAxVGjQkJk=";
    };
    propagatedBuildInputs = [ Mojolicious ];
    doCheck = false; # Test performs network access.
    meta = {
      description = "API to search the musicbrainz.org database";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MustacheSimple = buildPerlPackage {
    pname = "Mustache-Simple";
    version = "1.3.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CM/CMS/Mustache-Simple-v1.3.6.tar.gz";
      hash = "sha256-UdtdUf9LJaZw2L+r45ArbUVDTs94spvB//Ga9uc4MAM=";
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
      hash = "sha256-XXCApL1XFP+e9Taqd0p62zxvDnYCFcpsOdijVFNE+VY=";
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
      hash = "sha256-RevY5kpUqG+I2OAa5VISlnyKqP7VfoFAhd73YIrGWAQ=";
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
      hash = "sha256-ihCoPD4YPcePnnt6pNCbR8EftOfTozuaEpEv0i4xr50=";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      description = "Keep imports and functions out of your namespace";
      homepage = "https://search.cpan.org/dist/namespace-clean";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NeovimExt = buildPerlPackage rec {
    pname = "Neovim-Ext";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JACQUESG/Neovim-Ext-${version}.tar.gz";
      hash = "sha256-bSzrMGLJZzfbpVbLIEYxMPxABocbJbfE9mzTgZ1FBLg=";
    };
    propagatedBuildInputs = [
      ClassAccessor
      EvalSafe
      IOAsync
      MsgPackRaw
    ];
    checkInputs = [
      ArchiveZip
      FileSlurper
      FileWhich
      ProcBackground
      TestPod
      TestPodCoverage
    ];
    # TODO: fix tests
    doCheck = false;
    meta = with lib; {
      description = "Perl bindings for Neovim";
      homepage = "https://github.com/jacquesg/p5-Neovim-Ext";
      license = with licenses; [ gpl1Plus /* or */ artistic1 ];
      maintainers = with maintainers; [ figsoda ];
    };
  };

  NetIdent = buildPerlPackage {
    pname = "Net-Ident";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Net-Ident-1.25.tar.gz";
      hash = "sha256-LlvViwHCpm6ASaL42ck+G19tzlPg7jpIHOam9BHyyPg=";
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
      hash = "sha256-kMNjmPlQFBTMzaiynyOn908vK09VLhLevxYhjHNbuxc=";
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
      hash = "sha256-7FqC37cCi80ouz1Wn5XYfdQWbMGYZ/IYTtOln21soOc=";
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
      hash = "sha256-HQQMazseorVlkFefnBjgUAtsaiF7WdiDHw2WBMqX7T4=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Perl extension to create signatures for AWS requests";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetAmazonEC2 = buildPerlPackage {
    pname = "Net-Amazon-EC2";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MALLEN/Net-Amazon-EC2-0.36.tar.gz";
      hash = "sha256-Tig2kufwZsJBjtrpIz47YkAPk1X01SH5lRXlL3t9cvE=";
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
      hash = "sha256-jQlewUjglLJ/TMzHnhyvnDHzzA5t2CzoqORCyNx7D44=";
    };
    patches =
      [ ../development/perl-modules/net-amazon-mechanicalturk.patch ];
    propagatedBuildInputs = [ DigestHMAC LWPProtocolHttps XMLParser ];
    doCheck = false; /* wants network */
    meta = {
      description = "Amazon Mechanical Turk SDK for Perl";
      license = with lib.licenses; [ asl20 ];
    };
  };

  NetAmazonS3 = buildPerlPackage {
    pname = "Net-Amazon-S3";
    version = "0.97";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BARNEY/Net-Amazon-S3-0.97.tar.gz";
      hash = "sha256-A9hWd9BIPq+tJD2nBWS13xpDCSKZa/22xPGbbCh43jQ=";
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
      hash = "sha256-0rFukwhnSHQ0tHdHhooAP0scyECy15WfiPw2vQ2G2RQ=";
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
      hash = "sha256-nUvW+ZW8rn2LzTorNo7nCO3khABrYij17SXr86gh9z4=";
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

  NetAsyncHTTPServer = buildPerlModule {
    pname = "Net-Async-HTTP-Server";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Net-Async-HTTP-Server-0.13.tar.gz";
      hash = "sha256-yk3kcfIieNI5PIqy7G56xO8hfbRjXS3Mi6KoynIhFO4=";
    };
    buildInputs = [ TestIdentity TestMetricsAny TestRefcount TestSimple13 ];
    propagatedBuildInputs = [ HTTPMessage IOAsync MetricsAny ];
    meta = {
      description = "Serve HTTP with IO::Async";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.anoa ];
    };
  };

  NetAsyncPing = buildPerlPackage {
    pname = "Net-Async-Ping";
    version = "0.004001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABRAXXA/Net-Async-Ping-0.004001.tar.gz";
      hash = "sha256-kFfoUHYMcT2rB6DBycj4isEfbnTop0gcEObyc12K6Vs=";
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
      hash = "sha256-DayDQtPHii/syr1GZxRd1a3U+4zRjRVtKXoead/hFgA=";
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
      hash = "sha256-Cyun3izX3dX+ECouKueuuiHqqxB4vzv9PFpyKTclY4A=";
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
      hash = "sha256-x17caBi7Ng1xwTkWn9ZK1lw1//bSufrHufnmxGfxh7U=";
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
      hash = "sha256-QxfYyzQaYXueCIjaQ8Cc3//8sMnt97jJko10KlY7hRc=";
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
      hash = "sha256-VyXiCCZDVq1rP6++uXVqz8Kny5WDiMpcCHqsJzNF3dE=";
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
      hash = "sha256-56GsnvShI1s/29WIj4bDRxgjBkZ715q8mwdWpktEHLw=";
    };
    nativeBuildInputs = [ buildPackages.pkg-config ];
    buildInputs = [ pkgs.dbus TestPod TestPodCoverage ];
    propagatedBuildInputs = [ XMLTwig ];

    # https://gitlab.com/berrange/perl-net-dbus/-/merge_requests/19
    patches = fetchpatch {
      url = "https://gitlab.com/berrange/perl-net-dbus/-/commit/6bac8f188fb06e5e5edd27aee672d66b7c28caa4.patch";
      hash = "sha256-68kyUxM3E7w99rM2AZWZQMpGcaQxfSWaBs3DnmwnzqY=";
    };

    postPatch = ''
      substituteInPlace Makefile.PL --replace pkg-config $PKG_CONFIG
    '';

    meta = {
      description = "Extension for the DBus bindings";
      homepage = "https://www.freedesktop.org/wiki/Software/dbus";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDNS = buildPerlPackage {
    pname = "Net-DNS";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NL/NLNETLABS/Net-DNS-1.29.tar.gz";
      hash = "sha256-hS1u6H6PDQFCIwJlgcu1aSS6jN3TzrKcYZHbthItQ8U=";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    makeMakerFlags = [ "--noonline-tests" ];
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
      hash = "sha256-vvfxUOUw5VZbi67VmOqvdLb5X60Sit4NH3VQE1ghZ+c=";
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
      hash = "sha256-TDf4ERhNaKxBedSMEOoxki3V/KLBv/zc2VxaKjtAAu4=";
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
      hash = "sha256-EZOQCk/V6eupzNBuE4+RCSG3Ugf/i1JLZDqIyD61WWo=";
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
      hash = "sha256-vLNXootjnwyvfWLTPS5g/wv8z4lNAHzmAfY1UTiD1zk=";
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
      hash = "sha256-ui2FK+jzf1iE4wfagriqPNeU4YoVyAdSGsLKKtE599c=";
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
      hash = "sha256-90PhIjjrFslIBK+0sxCwJUj3C8rxeRZOrlZ/i0mIroU=";
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
      hash = "sha256-UrduwTlZUiyuZNll8V2j2Z3LRF7d2F0s5OT03zhbL8Q=";
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
      hash = "sha256-amnPT6Vfuju70iYu4UKC7YMQc22PWslNGmxZfNEnjE8=";
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
      hash = "sha256-VUU2M+P/JM4yWzS8LIFXuYWZYqMatc8ov3zMHJs6Pqo=";
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
      hash = "sha256-0/amCLheCagICmepkzg3qubyzQ6O453zOAEj3F496RI=";
    };
    propagatedBuildInputs = [ IOSocketSSL ListMoreUtils ];
    meta = {
      description = "Not so simple IMAP client library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIP = buildPerlPackage {
    pname = "Net-IP";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz";
      hash = "sha256-BA8W8wZmR9dhtySjtwdU0oy9Hm/l6gHGPtHNhXEX1jk=";
    };
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIPLite = buildPerlPackage {
    pname = "Net-IP-Lite";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALEXKOM/Net-IP-Lite-0.03.tar.gz";
      hash = "sha256-yZFubPqlO+J1N5zksqVQrhdt36tQ2tQ7Q+1D6CZ4Aqk=";
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
      hash = "sha256-OEXeTzCxfIQrGSys6Iedu2IU3paSz6cPCq8JgUIqY/4=";
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
      hash = "sha256-J+J/A/61X9kVFnOXNbGetUHK+HmVNjKd1+OhKQqkCwE=";
    };
    propagatedBuildInputs = [ MathBase85 NetIPv4Addr ];
    meta = {
      description = "Check and manipulate IPv6 addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIPXS = buildPerlPackage {
    pname = "Net-IP-XS";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOMHRR/Net-IP-XS-0.22.tar.gz";
      hash = "sha256-JZe0aDizgur3S6XJnD9gpqC1poHsNqFBchJL9E9LGSA=";
    };
    propagatedBuildInputs = [ IOCapture TieSimple ];
    meta = {
      homepage = "https://github.com/tomhrr/p5-Net-IP-XS";
      description = "IPv4/IPv6 address library";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  NetLDAPServer = buildPerlPackage {
    pname = "Net-LDAP-Server";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/Net-LDAP-Server-0.43.tar.gz";
      hash = "sha256-3WxMtNMLwyEUsHh/qioeK0/t0bkcLvN5Zey6ETMbsGI=";
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
      hash = "sha256-qMLNQGeQl/w7hCV24bU+w1/UNIGoalA4PutOJOu81tY=";
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
      hash = "sha256-sSBxe18fb2sTsxQ3/dIY7g/GnrASGN4U2SL5Kc+NLY4=";
    };
    propagatedBuildInputs = [ perlldap NetLDAPServer DataDump NetLDAPSID ];
    meta = {
      description = "Test Net::LDAP code";
      homepage = "https://github.com/karpet/net-ldap-server-test";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetLibIDN2 = buildPerlModule {
    pname = "Net-LibIDN2";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THOR/Net-LibIDN2-1.02.tar.gz";
      hash = "sha256-0fMK/GrPplQbAMCafkx059jkuknjJ3wLvEGuNcE5DQc=";
    };
    propagatedBuildInputs = [ pkgs.libidn2 ];
    meta = {
      description = "Perl bindings for GNU Libidn2";
      homepage = "https://github.com/gnuthor/Net--LibIDN2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetNetmask = buildPerlPackage {
    pname = "Net-Netmask";
    version = "2.0001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMASLAK/Net-Netmask-2.0001.tar.gz";
      hash = "sha256-FzVu+GZ/s4xEEKHDzH+kxzVn2/VnS/l/USNtbkiPUXE=";
    };
    buildInputs = [ Test2Suite TestUseAllModules ];
    meta = {
      description = "Understand and manipulate IP netmasks";
      homepage = "https://search.cpan.org/~jmaslak/Net-Netmask";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetMPD = buildPerlModule {
    pname = "Net-MPD";
    version = "0.07";
    buildInputs = [ ModuleBuildTiny ];
    src = fetchurl {
      url = "https://cpan.metacpan.org/authors/id/A/AB/ABERNDT/Net-MPD-0.07.tar.gz";
      hash = "sha256-M4L7nG9cJd4mKPVhRCn6igB5FSFnjELaBoyZ57KU6VM=";
    };
    meta = {
      description = "Communicate with an MPD server";
      homepage = "https://metacpan.org/pod/Net::MPD";
      license = with lib.licenses; [ mit ];
    };
  };

  NetMQTTSimple = buildPerlPackage {
    pname = "Net-MQTT-Simple";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JU/JUERD/Net-MQTT-Simple-1.26.tar.gz";
      hash = "sha256-ERxNNnu1AgXci8AjFfDGuw3mDRwwfQLnUuQuwRtPiLQ=";
    };
    meta = {
      description = "Minimal MQTT version 3 interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetOAuth = buildPerlModule {
    pname = "Net-OAuth";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz";
      hash = "sha256-e/wxnaCsV44Ali81o1DPUREKOjEwFtH9wwciAooikEw=";
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
      hash = "sha256-cINakm4cWo0DJMcv/+6C7rfsbBQd7gT9RGggtk9xxVI=";
    };
    propagatedBuildInputs = [ NetCIDRLite Socket6 ];
    meta = {
      description = "Patricia Trie perl module for fast IP address lookups";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  NetPing = buildPerlPackage {
    pname = "Net-Ping";
    version = "2.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Net-Ping-2.74.tar.gz";
      hash = "sha256-sSqJWbvtXnxVgRF+5eVAAZKy/wo1i/EYX87tDulzfRE=";
    };
    meta = {
      description = "Check a remote host for reachability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetDNSResolverProgrammable = buildPerlPackage {
    pname = "Net-DNS-Resolver-Programmable";
    version = "0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGPRESH/Net-DNS-Resolver-Programmable-0.009.tar.gz";
      hash = "sha256-gICiq3dmKVhZEa8Reb23xNwr6/1LXv13sR0drGJFS/g=";
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
      hash = "sha256-IvgJ4njq1Rk2rVOVgGUbTOXLyRwgnkpXesgjg82fcmo=";
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
      hash = "sha256-iKmy32nnaeWFWkCLGfYZFbguj+Bwq1z01SXdO4u+McE=";
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
      hash = "sha256-gmfGVgNV4uD0g9PMFhlfNC8y/hPK6d3nWgoezl6agT8=";
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
      hash = "sha256-tzlQgTFPJvO5PIV9ZenICgSmNwnfaYWD8io2D/zn4Xg=";
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
      hash = "sha256-HhpwKw3TkMPmKfip6EzKY7eU0eInlX9Cm2dgEHV3+4Y=";
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
      hash = "sha256-pveVyFdEe/TQCEI83RrQTWr7aoYrgOGaNqc1wJeiAnw=";
    };
    nativeCheckInputs = [ HTTPMessage LWP TestSharedFork HTTPServerSimple TestTCP TestUNIXSock ];
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
      hash = "sha256-eynEWt0Z09UIS3Ufe6iajkBHmkRs4hz9nMdB5VgzKgA=";
    };
    propagatedBuildInputs = [ IOSocketSSL ];
    meta = {
      description = "SSL support for Net::SMTP";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSMTPTLS = buildPerlPackage {
    pname = "Net-SMTP-TLS";
    version = "0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWESTHOLM/Net-SMTP-TLS-0.12.tar.gz";
      hash = "sha256-7+dyZnrDdwK5a221KXzIJ0J6Ozo4GbekMVsIudRE5KU=";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
    meta = {
      description = "An SMTP client supporting TLS and AUTH";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSMTPTLSButMaintained = buildPerlPackage {
    pname = "Net-SMTP-TLS-ButMaintained";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FA/FAYLAND/Net-SMTP-TLS-ButMaintained-0.24.tar.gz";
      hash = "sha256-a5XAj3FXnYUcAYP1AqcAyGof7O9XDjzugybF5M5mJW4=";
    };
    propagatedBuildInputs = [ DigestHMAC IOSocketSSL ];
    meta = {
      description = "An SMTP client supporting TLS and AUTH (DEPRECATED, use Net::SMTPS instead)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSNMP = buildPerlModule {
    pname = "Net-SNMP";
    version = "6.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
      hash = "sha256-FMN7wcuz883H1sE+DyeoWfFM3P1epUoEZ6iLwlmwt0E=";
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
      hash = "sha256-BrhR1kWWYl6GY1n7AX3Q0Ilz4OvFDDI/Sh1Q7N2GjnY=";
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
      hash = "sha256-fHHHw8vpUyNN/iW8wa1+2w4fWgV4YB9VI7xgcCYqOBc=";
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
      hash = "sha256-K10bsTWQtYcBFnBOfx3OmpgjxPgP9UYbl7smoxc5MBc=";
    };
    propagatedBuildInputs = [ CryptCurve25519 CryptIDEA CryptX FileHomeDir MathGMP StringCRC32 ];
    preCheck = "export HOME=$TMPDIR";
    meta = {
      description = "Perl client interface to SSH";
      homepage = "https://search.cpan.org/dist/Net-SSH-Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetSSLeay = buildPerlPackage {
    pname = "Net-SSLeay";
    version = "1.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz";
      hash = "sha256-R8LyswDy5xYtcdaZ9jPdajWwYloAy9qMUKwBFEqTlqk=";
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
      hash = "sha256-Y+RTYD2hZbxtHEygtV7aPSIE8EDFkwSkd4LFqniGVlw=";
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
      hash = "sha256-5k1Wek4WKV7LqUk2jnpri1rioWs61oISHZsAfcXSo3o=";
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
      hash = "sha256-suq+Hyo/LGTezWDye8O0buZSVgsCTExWgRVhbI1KRo4=";
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
      hash = "sha256-8JvfoPHSZltTSCa186hmI0mTDu0pmO/k2Nv5iBMUciI=";
    };
    doCheck = false;

    # https://rt.cpan.org/Public/Bug/Display.html?id=99377
    postPatch = ''
      substituteInPlace IP.pm --replace " AutoLoader" ""
    '';
    buildInputs = [ RegexpIPv6 ];
    meta = {
      description = "Perl extension for looking up the whois information for ip addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetWorks = buildPerlPackage {
    pname = "Net-Works";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAXMIND/Net-Works-0.22.tar.gz";
      hash = "sha256-CsmyPfvKGE4ocpskU5S8ZpOq22/EUcqplbS3GewO6f8=";
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
      hash = "sha256-X8ecSbC0DfeAR5xDaWOBND4ratH+UoWfYLxltm6+byw=";
    };
    meta = {
      description = "Convert byte count to human readable format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberCompare = buildPerlPackage {
    pname = "Number-Compare";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Number-Compare-0.03.tar.gz";
      hash = "sha256-gyk3N+gDtDESgwRD+1II7FIIoubqUS7VTvjk3SuICCc=";
    };
    meta = {
      description = "Numeric comparisons";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberFormat = buildPerlPackage {
    pname = "Number-Format";
    version = "1.76";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Number-Format-1.76.tar.gz";
      hash = "sha256-DgBg6zY2NaiFcGxqJvX8qv6udZ97Ksrkndpw4ZXdRNY=";
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
      hash = "sha256-OwCqQz/lFGviH9chZHa6lkG5Y0NlfEzc9A72/KxpEO8=";
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
      hash = "sha256-d7m2jGAKBpzxb02BJuyzIVHmvNNLDtsXt4re5onckdg=";
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
      hash = "sha256-ZY7hyNGXTvSwV+B4L0mTi/PelA6QY/2bYecY6siwO+8=";
    };
    buildInputs = [ DevelHide FileShareDirInstall ParallelForkManager TestDifferences TestPod TestPodCoverage TestWarnings ];
    propagatedBuildInputs = [ DataDumperConcise DBMDeep DevelCheckOS FileFindRule FileShareDir ];
    meta = {
      description = "Large suite of perl modules for parsing and dealing with phone numbers";
      homepage = "https://github.com/DrHyde/perl-modules-Number-Phone";
      license = with lib.licenses; [ artistic1 gpl2Only asl20 ];
    };
  };

  NumberWithError = buildPerlPackage {
    pname = "Number-WithError";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Number-WithError-1.01.tar.gz";
      hash = "sha256-3/agcn54ROpng3vfrdVSuG9rIW0Y7o7kaEKyLM7w9VQ=";
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
      hash = "sha256-yCPjDNp2vBVjblhDAslg4rXu75UXwkSPdFRJiJMVH4U=";
    };
    propagatedBuildInputs = [ DigestHMAC ];
    meta = {
      description = "An NTLM authentication module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.pSub ];
    };
  };

  ObjectAccessor = buildPerlPackage {
    pname = "Object-Accessor";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz";
      hash = "sha256-dsuCSie2tOVgQJ/Pb9Wzv7vTi3Lx89N+0LVL2cC66t4=";
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
      hash = "sha256-q2u4BQj0/dry1RsgyodqqwOFgqhrUijmQ1QRNIr1PII=";
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
      hash = "sha256-nf1sooInJDR+DrZ1nQBwlCWBRwOtXGa9tiFFeYaLysQ=";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Comprehensive inside-out object support module";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ObjectPad = buildPerlModule {
    pname = "Object-Pad";
    version = "0.79";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Object-Pad-0.79.tar.gz";
      hash = "sha256-+wsQ+J5i1UFlvWqyHbVfYLVT+gCPyOddNJhwwafiKtY=";
    };
    buildInputs = [ Test2Suite TestFatal TestRefcount ];
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
      hash = "sha256-hCFTyU2pPiucs7VN7lcrUGS79JmjanPDiiN5mgIDaYo=";
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
      hash = "sha256-Uh04CPQtcSKmsGwzpurm18OZR6q1fEyMyvzE9gP9pT4=";
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
      hash = "sha256-qximFxwOCOqTTuoUoKtPOokJl13anaQhJJIutB6E+Lo=";
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
      hash = "sha256-f3NlRH5NHFuHtDCRRI8EiOZ8nwNrJsAipUCc1z00OJM=";
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
      hash = "sha256-szo5AKzdLO5hAHu5MigNjDzslJkpnUNyud+Yd0vXTAo=";
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
      hash = "sha256-sg4q9EBLSQGrNbumrV46iqYL/3JBPJkojwEBjEz4dOA=";
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
    meta = {
      description = "Perl OpenGL bindings";
      license = with lib.licenses; [ artistic1 gpl1Plus ]; # taken from EPEL
    };
  };

  OpenOfficeOODoc = buildPerlPackage {
    pname = "OpenOffice-OODoc";
    version = "2.125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMGDOC/OpenOffice-OODoc-2.125.tar.gz";
      hash = "sha256-wRRIlwaTxCqLnpPaSMrJE1Fs4zqdRKZGhAD3rYeR2rY=";
    };
    propagatedBuildInputs = [ ArchiveZip XMLTwig ];
    meta = {
      description = "The Perl Open OpenDocument Connector";
      license = with lib.licenses; [ lgpl21Only ];
      maintainers = [ maintainers.wentasah ];
    };
  };

  NetOpenIDCommon = buildPerlPackage {
    pname = "Net-OpenID-Common";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/Net-OpenID-Common-1.20.tar.gz";
      hash = "sha256-q06X10pHcQ4NtKwMgi9/32Iq+GpgpSunIlWoicKdq8k=";
    };
    propagatedBuildInputs = [ CryptDHGMP XMLSimple ];
    meta = {
      description = "Libraries shared between Net::OpenID::Consumer and Net::OpenID::Server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetOpenIDConsumer = buildPerlPackage {
    pname = "Net-OpenID-Consumer";
    version = "1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/Net-OpenID-Consumer-1.18.tar.gz";
      hash = "sha256-Dhw4b+fBhDBx3Zlr3KymEJEGZK5LXRJ8lf6u/Zk2Tzg=";
    };
    propagatedBuildInputs = [ JSON NetOpenIDCommon ];
    buildInputs = [ CGI ];
    meta = {
      description = "Library for consumers of OpenID identities";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetOpenSSH = buildPerlPackage {
    pname = "Net-OpenSSH";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SALVA/Net-OpenSSH-0.80.tar.gz";
      hash = "sha256-/uCTZX3ys2FHKimChZWIpuS8XhrugRjs5e6/6vqNrrM=";
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
      hash = "sha256-NyY97EWtqWFtKJnwX2HDkKcyviKq57yRtWC7lzajiHY=";
    };
    buildInputs = [ pkgs.zookeeper_mt ];
    # fix "error: format not a string literal and no format arguments [-Werror=format-security]"
    hardeningDisable = [ "format" ];
    # Make the async API accessible
    env.NIX_CFLAGS_COMPILE = "-DTHREADED";
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
      description = "Perl extension for Apache ZooKeeper";
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
      hash = "sha256-C1i+eHBszE5L2butQXZ0cEJ/17LPrXSUid4QH4W8XfU=";
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
      hash = "sha256-HXQ62kgrXJhx2JSWbofUwg7clpMbuUn7JjiwAN3WaEs=";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ PackageStash ParamsUtil SubInstall SubName ];
    meta = {
      description = "Manage deprecation warnings for your distribution";
      homepage = "https://metacpan.org/release/Package-DeprecationManager";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  PatchReader = buildPerlPackage {
    pname = "PatchReader";
    version = "0.9.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TM/TMANNERM/PatchReader-0.9.6.tar.gz";
      hash = "sha256-uN43RgNHu1R03AGRbMsx3S/gzZIkLEoy1zDo6wh8Mjw=";
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
      hash = "sha256-kWX1VREuCASTzg6RKd4Ihtowslk/s1Oiq9HHay0mIbU=";
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
      hash = "sha256-02drqUZB4D1qMOlR8JJmxMPKP1tYqnsxSmfyjkGYeKo=";
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
      hash = "sha256-NLCkIt8/7NdZdYcEhVJFfUiudkxDu+/SqdYs62yLrHE=";
    };
    buildInputs = [ pkgs.pango ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      description = "Layout and render international text";
      homepage = "https://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ lgpl21Plus ];
    };
  };

  ParallelForkManager = buildPerlPackage {
    pname = "Parallel-ForkManager";
    version = "2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz";
      hash = "sha256-wbKXCou2ZsPefKrEqPTbzAQ6uBm7wzdpLse/J62uRAQ=";
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
      hash = "sha256-JjZfgQXcYGsUC9HUX41w1cMFQ5D3Xk/bdISj5ZHL+pc=";
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
      hash = "sha256-8cH0jxrhR6WLyI+csvVw1rsV6kwNWJq9TDCE3clhWW4=";
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
      hash = "sha256-OY7BXNiZ/Ni+89ueoXSL9jHxX2wyviA+R1tn31EKWRQ=";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Argument type classification";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsUtil = buildPerlPackage {
    pname = "Params-Util";
    version = "1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/Params-Util-1.102.tar.gz";
      hash = "sha256-SZuxtILbJP2id6UVJVlq0JLCvVHdUI+o/sLp+EkJdAI=";
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
      hash = "sha256-mjo1WD0xJdB+jIAsH5L1vn1SbnbdSW6UTaJwseJz2BI=";
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
      hash = "sha256-3FvuIzg75CdlBz2yhL7Z+9gZ1HBa1knCC2REUgkNFss=";
    };
    propagatedBuildInputs = [ EvalClosure ExceptionClass ];
    buildInputs = [ Specio Test2PluginNoWarnings Test2Suite TestWithoutModule ];
    meta = {
      description = "Build an optimized subroutine parameter validator once, use it forever";
      homepage = "https://metacpan.org/release/Params-ValidationCompiler";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  Paranoid = buildPerlPackage {
    pname = "Paranoid";
    version = "2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORLISS/Paranoid/Paranoid-2.07.tar.gz";
      hash = "sha256-tVz9jG1fGB4hjv0BL3EaUM0U5NvIgEZQuVR3F49Dt/w=";
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
      hash = "sha256-0kIGLfm2ifOQQOTE4JExpsRk0O7629HJrJRxc68z3/g=";
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
      hash = "sha256-ek6SDeODL5CfJV1aMj942M0hXGCMlJbNbJVwEsi0MQg=";
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
    version = "0.241";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/parent-0.241.tar.gz";
      hash = "sha256-sQs5YKs5l9q3Vx/+l1ukYtl50IZFB0Ch4Is5WedRKP4=";
    };
    meta = {
      description = "Establish an ISA relationship with base classes at compile time";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseDebControl = buildPerlPackage {
    pname = "Parse-DebControl";
    version = "2.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYBONCI/Parse-DebControl-2.005.tar.gz";
      hash = "sha256-tkvOH/IS1+PvnUNo57YnSc8ndR+oNgzfU+lpEjNGpyk=";
    };
    propagatedBuildInputs = [ IOStringy LWP ];
    meta = {
      description = "Easy OO parsing of debian control-like files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseIRC = buildPerlPackage {
    pname = "Parse-IRC";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/Parse-IRC-1.22.tar.gz";
      hash = "sha256-RXsJiX8304pwVPlWMkc2VCf+JBAWIu1MfwVHI6RbWNU=";
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
      hash = "sha256-awvDLE6NnoHz8qzB0qdMKi+IepHBUisxzkyNSaQV6Z4=";
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
      hash = "sha256-a3ioVSOYsNLXBjUFyTs8/tBDLFss9uALjlH+v0EcHvo=";
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
      hash = "sha256-vmHoByBHOM8MUu0yFVGZL9x/qPqkPtQ/9InQwmmQBiM=";
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
      hash = "sha256-GUMzaky1TxeIpzPwgnwMVdtDENXq4V5UJjnJ3YVlbjc=";
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
      hash = "sha256-ZZohRUQe822YNd7K+D2jCPzQP0kTjLPZCSjov8nxOdk=";
    };
    meta = {
      description = "Parse Unix syslog files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParserMGC = buildPerlModule {
    pname = "Parser-MGC";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Parser-MGC-0.16.tar.gz";
      hash = "sha256-dERhxfDIOAEvO+jFgEKlVgkhIAzBbbDn0ASn8rgTe5E=";
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
      hash = "sha256-OBDpmDCPui4PTyYEMDUDKwJ85RzlyKUqi440DKZfE+U=";
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
      hash = "sha256-ZUeBlIYCOG8ssuRHOnOfF9xpU9kqq8JJikyiVhvCSM4=";
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
      hash = "sha256-ean2HCdAi0/R7SNNrCRpdN3q+n/mNaGP5B7HeDEwrio=";
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
      hash = "sha256-P3QB2L7UP8kwNAnvbZ80uFogPeaUQFC765WFXTKYsaY=";
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
      hash = "sha256-zQ+I83pY/DZn7AZXZ/4B5z7m76GKESv9NQjPZXnKAOE=";
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
      hash = "sha256-pVhQOqax+McnwAczOQgad4iGBqpwGtoa1i3Z2MP5RaI=";
    };
    meta = {
      description = "Get pathname of current working directory";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PBKDF2Tiny = buildPerlPackage {
    pname = "PBKDF2-Tiny";
    version = "0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/PBKDF2-Tiny-0.005.tar.gz";
      hash = "sha256-tOIdxZswJl6qpBtwUIfsA0R9nGVaFKxA/0bk3inqv44=";
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
      hash = "sha256-JyK35VQ+T687oexrKaff7G2Svh7ewJ0KMZGZLU2Ixp0=";
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
    version = "2.044";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SS/SSIMMS/PDF-API2-2.044.tar.gz";
      hash = "sha256-stFVeeQnI9jX+bct6G0NNc3jTx63cTRWuirTX7PL6n4=";
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
      hash = "sha256-SCskaQxxhfLn+7r5pIKz0SieJduAC/SPKVn1Epl3yjE=";
    };
    nativeCheckInputs = [ TestException TestMemoryCycle ];
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
      hash = "sha256-G1oWfq0ndy2V2tJ/jrfQlRnSkVbu1TxvwUQVGUtaitY=";
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
      homepage = "https://pdl.perl.org";
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
      hash = "sha256-TcjTNd6AslJHzbP5RvDRDZugs8NLDtfQAxb9Bo/QXtw=";
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
      hash = "sha256-JLlpJYQBU8REJBOYs2/Il24IX9sNh5yRc0cJz5F+zqw=";
    };
    meta = {
      description = "Honour PERL5LIB even in taint mode";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Perlosnames = buildPerlPackage {
    pname = "Perl-osnames";
    version = "0.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLANCAR/Perl-osnames-0.122.tar.gz";
      hash = "sha256-cHWTnXR+N1F40ANI0AxS/52yzrsYuudHPcsJ34JRGKA=";
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
      hash = "sha256-v+7wqjbwlBaCpgchJZPbUwssilSZ9tx9QffmGo69/ds=";
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
      hash = "sha256-MRt3XaQZPp3pTPUiXpk8xU3Qlq4efvYHOM2uHZuIVOc=";
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
      hash = "sha256-UuuOIsQmQ/F/4peiFxQBfv254phsJOMzfgMPNlD5IgE=";
    };
    propagatedBuildInputs = [ PerlCritic Readonly namespaceautoclean ];
    meta = {
      description = "Policies for Perl::Critic concerned with using Moose";
      homepage = "https://metacpan.org/release/Perl-Critic-Moose";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  PerlCriticPolicyVariablesProhibitLoopOnHash = buildPerlPackage {
    pname = "Perl-Critic-Policy-Variables-ProhibitLoopOnHash";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XS/XSAWYERX/Perl-Critic-Policy-Variables-ProhibitLoopOnHash-0.008.tar.gz";
      hash = "sha256-EvXwvpbqG9x4KAWFd70cXGPKI8F/rJw3CUUrPf9bhOA=";
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
      hash = "sha256-uP2oQvy+100hAlfAooS23HsdBVSkej3l2X59VC4j5/4=";
    };
    propagatedBuildInputs = [ IOString ListMoreUtils PPI PerlCritic PodMinimumVersion ];
    meta = {
      description = "Some add-on policies for Perl::Critic";
      homepage = "https://user42.tuxfamily.org/perl-critic-pulp/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  PerlDestructLevel = buildPerlPackage {
    pname = "Perl-Destruct-Level";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/Perl-Destruct-Level-0.02.tar.gz";
      hash = "sha256-QLSsCykrYM47h956o5vC+yWhnRDlyfaYZpYchLP20Ts=";
    };
    meta = {
      description = "Allow to change perl's destruction level";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOLayers = buildPerlModule {
    pname = "PerlIO-Layers";
    version = "0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/PerlIO-Layers-0.012.tar.gz";
      hash = "sha256-VC2lQvo2uz/de4d24jDTzMAqpnRM6bd7Tu9MyufASt8=";
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
      hash = "sha256-zszL/kVFsZZdESqGKY3/5Q1oBhgAkMa+x9dXto+4Xrk=";
    };
    meta = {
      description = "PerlIO layer for normalizing line endings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOgzip = buildPerlPackage {
    pname = "PerlIO-gzip";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz";
      hash = "sha256-SEhnmj8gHj87DF9vlSbmAq9Skj/6RxoqNlfbeGvTvcU=";
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
      hash = "sha256-X3mN7VDcx9QhtXhQ+DcxBmbYF/TGfBW6D1odOMdN9Fk=";
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
      hash = "sha256-is169NivIdKLnBWuE3/nbNBk2tfSbrqKMLl+vG4fa0k=";
    };
    meta = {
      description = "Dynamic PerlIO layers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    pname = "PerlIO-via-symlink";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz";
      hash = "sha256-QQfUw0pqNilFNEjCVpXZL4JSKv9k4ptxa1alr1hrLVI=";
    };

    buildInputs = [ ModuleInstall ];

    postPatch = ''
      # remove outdated inc::Module::Install included with module
      # causes build failure for perl5.18+
      rm -r  inc
    '';
    meta = {
      description = "PerlIO layers for create symlinks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlIOviaTimeout = buildPerlModule {
    pname = "PerlIO-via-Timeout";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.32.tar.gz";
      hash = "sha256-knj572aIUNkT2Y+kwNfn1mfP81AzkfSk6uc6JG8ueRY=";
    };
    buildInputs = [ ModuleBuildTiny TestSharedFork TestTCP ];
    meta = {
      description = "A PerlIO layer that adds read & write timeout to a handle";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlLanguageServer = buildPerlPackage {
    pname = "Perl-LanguageServer";
    version = "2.5.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRICHTER/Perl-LanguageServer-2.5.0.tar.gz";
      hash = "sha256-LQYcIkepqAT1JMkSuIN6mxivz6AZkpShcRsVD1oTmQQ=";
    };
    propagatedBuildInputs = [ AnyEvent AnyEventAIO ClassRefresh CompilerLexer Coro DataDump HashSafeKeys IOAIO JSON Moose PadWalker ];
    meta = {
      description = "Language Server and Debug Protocol Adapter for Perl";
      license = lib.licenses.artistic2;
    };
  };

  perlldap = buildPerlPackage {
    pname = "perl-ldap";
    version = "0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARSCHAP/perl-ldap-0.68.tar.gz";
      hash = "sha256-4vOJ/j56nkthSIaSkZrXI7mPO0ebUoj2ENqownmVs1E=";
    };
    # ldapi socket location should match the one compiled into the openldap package
    postPatch = ''
      for f in lib/Net/LDAPI.pm lib/Net/LDAP/Util.pm lib/Net/LDAP.pod lib/Net/LDAP.pm; do
        sed -i 's:/var/run/ldapi:/run/openldap/ldapi:g' "$f"
      done
    '';
    buildInputs = [ TextSoundex ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      description = "LDAP client library";
      homepage = "https://ldap.perl.org";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = teams.deshaw.members;
    };
  };

  PerlMagick = ImageMagick; # added 2021-08-02
  ImageMagick = buildPerlPackage rec {
    pname = "Image-Magick";
    version = "7.1.0-0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JC/JCRISTY/Image-Magick-${version}.tar.gz";
      hash = "sha256-+QyXXL4hRFd3xA0ZwXt/eQI9MGTvj6vPNIz4JlS8Fus=";
    };
    buildInputs = [ pkgs.imagemagick ];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick.dev}/include/ImageMagick";|' Makefile.PL
      '';
    meta = {
      description = "Objected-oriented Perl interface to ImageMagick. Use it to read, manipulate, or write an image or image sequence from within a Perl script";
      license = with lib.licenses; [ imagemagick ];
    };
  };

  PerlTidy = buildPerlPackage rec {
    pname = "Perl-Tidy";
    version = "20211029";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/Perl-Tidy-20211029.tar.gz";
      hash = "sha256-7AOx42pX0JRWmjAIJoj3IiU0AcfMk0rGTS4+tN6IDto=";
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
      hash = "sha256-uRLUJumuulSRpeUC58XAOcXapXVCism9yCr/857G8Ho=";
    };
    meta = {
      description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PkgConfig = buildPerlPackage rec {
    pname = "PkgConfig";
    version = "0.25026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/PkgConfig-0.25026.tar.gz";
      hash = "sha256-Tbpe08LWpoG5XF6/FLammVzmmRrkcZutfxqvOOmHwqA=";
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
      hash = "sha256-MPXyXhm0N4WRVqJSb2HKmrcI1Q1XMMJ5GJQDqr/lQqY=";
    };
    buildInputs = [ AuthenSimplePasswd CGIEmulatePSGI FileShareDirInstall HTTPRequestAsCGI HTTPServerSimplePSGI IOHandleUtil LWP LWPProtocolhttp10 LogDispatchArray MIMETypes TestMockTimeHiRes TestRequires TestSharedFork TestTCP ];
    propagatedBuildInputs = [ ApacheLogFormatCompiler CookieBaker DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HTTPEntityParser HTTPHeadersFast HTTPMessage TryTiny ];
    patches = [
      ../development/perl-modules/Plack-test-replace-DES-hash-with-bcrypt.patch
    ];
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
      hash = "sha256-BKqanbVKmpAn/nBLyjU/jl6fAr5AhytB0jX86c3ypg8=";
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
      hash = "sha256-mr0/kpQ2zV7N+28/DX/foRuUB6OMfWAAYWpQ7eYQFes=";
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
      hash = "sha256-VWc6ylBN4sw0AWpF8yyPft2k7k0oArctZ4TSxBuH+9k=";
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
      hash = "sha256-GS73nlIckMbv9vQUmtLkv8kR0sld94k1hV6Q1lnprJo=";
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
      hash = "sha256-KNqV59pMi1WRrEVFCckhds0IQpYM4HT94w+aEHXcwnU=";
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
      hash = "sha256-bCLQafWlesIG1GWbKLiGm7knBkC7lV793UUdzFjNs5E=";
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
      hash = "sha256-Xra5/3Ly09VpUOI+K8AnFQqcXnVg1zo0GhZeGu3qXV4=";
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
      hash = "sha256-2/taLvtIv+sByzrh4cZ34VXce/4hDH5/IhuuPLaqtfE=";
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
      hash = "sha256-gNRfk9a3KQsL2LPO3YSjf8UBRWzD3sAux6rYHAAYCH4=";
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
      hash = "sha256-h0kx030HZnug0PN5A7lFEQcfQZH+tz+kV2XaK4wVoSg=";
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
      hash = "sha256-T/miydGK2ASbRd/ze5vdQSIeLC8eFrr7gb/tyIxRpO4=";
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
      hash = "sha256-W69cV/4MBkEt7snFq+eVKrigT4xHtLvY6emYImiQPtA=";
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
    version = "0.905";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MREISNER/PLS-0.905.tar.gz";
      hash = "sha256-RVW1J5nBZBXDy/5eMB6gLKDrvDQhTH/lLx19ykUwLik=";
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
      hash = "sha256-C9KBLZqsvZm7cfoQOkuxKelVwTi6dZhzQgfcn7Z7Wm8=";
    };
    propagatedBuildInputs = [ IOString PodParser ];
    meta = {
      description = "Determine minimum Perl version of POD directives";
      homepage = "https://user42.tuxfamily.org/pod-minimumversion/index.html";
      license = with lib.licenses; [ gpl3Plus ];
      mainProgram = "pod-minimumversion";
    };
  };

  POE = buildPerlPackage {
    pname = "POE";
    version = "1.368";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/POE-1.368.tar.gz";
      hash = "sha256-t7Hcdh421Is5BoNJtXba/A7MvDudtRxnfeDhqvrf4SE=";
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
      hash = "sha256-vtDJb+kcmP035utZqASqrJzEqekoRQt21L9VJ6nmpHs=";
    };
    meta = {
      description = "Reusable tests for POE::Loop authors";
      homepage = "https://search.cpan.org/dist/POE-Test-Loops";
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
      hash = "sha256-YippjHgbuF0r33u/4ED+cNM7eXdMmuAfziN13HP69Fc=";
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
      hash = "sha256-jR4zg4J40lKrb1hoQPzucOGbtzUgNbqF/TIkdSYtGBc=";
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
      hash = "sha256-EGB9kyJyjEs3ZMCf4dy0qTmv8Nq+psSMpPhUogd6AUo=";
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
      hash = "sha256-A6SDOG/WosgI8Jd41E2wawLDFA+yS6S/EvhR9G07y5s=";
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
    version = "0.001008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/PPR-0.001008.tar.gz";
      hash = "sha256-EQ5xwF8uLJDrAfCgaU5VqdvpHIV+SBJeF0LRflzbHkk=";
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
      hash = "sha256-kbalrrhBscMTSYx4+tCON9F1lXAtxiBbWtOO9plJt+4=";
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
      hash = "sha256-+MxQVNeMNaDOOft1QwtO9ALiqZAT0uw355l/MWWUYGw=";
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
      hash = "sha256-ZNOQceyU17ZqfKtalQJG8P/wE7WiAKY9EXZDKYfloTU=";
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
      hash = "sha256-G00JCLysVj00p+W+YcXaPu6Y5KbH+mjCZwzFhEtaLXg=";
    };
    meta = {
      description = "Convenient utility for executing external commands in various ways";
      license = with lib.licenses; [ gpl1Only bsd2 ];
    };
  };

  ProcSimple = buildPerlPackage {
    pname = "Proc-Simple";
    version = "1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/Proc-Simple-1.32.tar.gz";
      hash = "sha256-TI8KkksZrXihPac/4PswbTKnudEKMyxSMIf8g6IJqMQ=";
    };
    meta = {
      description = "Launch and control background processes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcWait3 = buildPerlPackage {
    pname = "Proc-Wait3";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTILMES/Proc-Wait3-0.05.tar.gz";
      hash = "sha256-GpB/XbaTPcKTm7/v/hnurn7TnvG5eivJtyPy8l+ByvM=";
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
      hash = "sha256-0HVj9eeHkJ0W5zkCQeh39Jq3ObHenQ4uoaQb0L9EdLw=";
    };
    propagatedBuildInputs = [ IPCSignal ];
    meta = {
      description = "Interpret and act on wait() status values";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PrometheusTiny = buildPerlPackage {
    pname = "Prometheus-Tiny";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBN/Prometheus-Tiny-0.008.tar.gz";
      hash = "sha256-c2pmkTuYAL7skh1QoSsFyzdLXwnVcJ6vQ5hNyJJZp50=";
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
      hash = "sha256-j7xUPgv9XY9zvcEhotrK/UNErupLmbcVxQ3Nqkgmggs=";
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
      hash = "sha256-fOtr2ABnyQRGXU/R8XFXJDiMm9w3xsLAA6IM5Wm39Og=";
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
      hash = "sha256-a5r7PelOwczX20+eai6rolSld5AwHBe8sTuz7f4YULc=";
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
      hash = "sha256-WDfQNxGnoyVPCv7LfkCeiwk3YGDDiluClejumvdXVSI=";
    };
    buildInputs = [ ModuleBuildTiny ];
    meta = {
      description = "WebSocket protocol";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProtocolHTTP2 = buildPerlModule {
    pname = "Protocol-HTTP2";
    version = "1.10";

    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CR/CRUX/Protocol-HTTP2-1.10.tar.gz";
      hash = "sha256-wmoAWPtK+ul+S/DbxkGJ9nEURRXERH89y1l+zQOWpko=";
    };
    buildInputs = [ AnyEvent ModuleBuildTiny NetSSLeay TestLeakTrace TestSharedFork TestTCP ];
    meta = {
      description = "HTTP/2 protocol implementation (RFC 7540)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PSGI = buildPerlPackage {
    pname = "PSGI";
    version = "1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/PSGI-1.102.tar.gz";
      hash = "sha256-pWxEZ0CRfahpJcKfxmM7nfg5shz5j2onCGWY7ZDuH0c=";
    };
    meta = {
      description = "Perl Web Server Gateway Interface Specification";
      license = with lib.licenses; [ cc-by-sa-25 ];
    };
  };

  PadWalker = buildPerlPackage {
    pname = "PadWalker";
    version = "2.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBIN/PadWalker-2.5.tar.gz";
      hash = "sha256-B7Jqu4QRRq8yByqNaMuQF2/7F2/ZJo5vL30Qb4F6DNA=";
    };
    meta = {
      description = "Play with other peoples' lexical variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Perl6Junction = buildPerlPackage {
    pname = "Perl6-Junction";
    version = "1.60000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/Perl6-Junction-1.60000.tar.gz";
      hash = "sha256-0CN16FGX6PkbTLLTM0rpqJ9gAi949c1gdtzU7G+ycWQ=";
    };
    meta = {
      description = "Perl6 style Junction operators in Perl5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlMinimumVersion = buildPerlPackage {
    pname = "Perl-MinimumVersion";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Perl-MinimumVersion-1.38.tar.gz";
      hash = "sha256-R4tYJHkbh/x0yUqJIYBoK9Bq0s3zQDSxpLhZJzkngCo=";
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
      hash = "sha256-KAocRxA5CGX7nzEKhho0cgsotMvlBgnIQa9c8tOivO0=";
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
      hash = "sha256-lw2fxeFJOMDxdA+M/tCU1c+kxL2NR/qAxZqbATnPVI0=";
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
      hash = "sha256-GIdBTRyGidhkyEARQQHgQ+mdfdW5zKaTaaYOgh460Pc=";
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
      hash = "sha256-lW73u4hMVUVuL7bn8in5qH3VCmHXAFAMc4248ronf4c=";
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
      hash = "sha256-LiFirwqIYORXAxiGbsGO++ezf+uNmQs0hIuffFJKpYg=";
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
      hash = "sha256-MLegsMlC9Ep1UsDTTpsfLgugtnlVxh47FYnsNpB0sQc=";
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
      hash = "sha256-bGiDXCTNyvuxVn5oCrErsXYWOCuvi8RM5FfkGh01cyE=";
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
      hash = "sha256-gkM27BgybjuXDngVkis5IbCoIdLuDlCwxbK8Mn+ZYV4=";
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
      hash = "sha256-Cf07XVMRlDegHc7Wa0Lq/c1TiVs8MqKw94Hzb9oPZls=";
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
      hash = "sha256-vp+4kQsQjl0aZvACtlmtIlduiNd5twPf+dFRIsP4CDQ=";
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
      hash = "sha256-2+C1YSmXWy+DoChB6ODtR76A8GBobGbqN+Up2XqnDM0=";
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
      hash = "sha256-G1D7qbvd4+rRkr7roOrd0MYU46+xdD+m//gF9XxW9/Q=";
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
      hash = "sha256-zLQicsdQM3nLETE5RiDuUCdtcoRODoDrSwB6nVj4diM=";
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
      hash = "sha256-ydHXUpLzIYgRhOxWmDwW9Aj9LTEtWnIPj7DSyvpykjg=";
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
      hash = "sha256-FahA6hyKds08hl+78v7DOwNhXA2qUPnIAMVODPBlnUY=";
    };
    propagatedBuildInputs = [ PodParser ];
    meta = {
      description = "Convert Pod data to formatted Latex";
      homepage = "https://github.com/timj/perl-Pod-LaTeX/tree/master";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "pod2latex";
    };
  };

  podlators = buildPerlPackage {
    pname = "podlators";
    version = "4.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RR/RRA/podlators-4.14.tar.gz";
      hash = "sha256-evHEHeNLLk2/9wCinXOHVJwrbPFhQiFEUMkkcH3bD4I=";
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
      hash = "sha256-Tjvr7Bv4Lb+FCpSuJqJTZEz1gG7EGvx05D4XEKNzIds=";
    };
    propagatedBuildInputs = [ FileFindIterator FileHomeDir IPCRun PodParser constant-defer libintl-perl ];
    meta = {
      description = "Check POD L<> link references";
      homepage = "https://user42.tuxfamily.org/podlinkcheck/index.html";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  prefork = buildPerlPackage {
    pname = "prefork";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/prefork-1.05.tar.gz";
      hash = "sha256-bYe836Y7KM78+ocIA6UZtlkOPqGcMA+YzssOGQuxkwU=";
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
      hash = "sha256-zEHmBbjhPECo7mUE/0Y0e1un+9kiA7O7BVQiBRvvxk0=";
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
      hash = "sha256-G7+/fR1IceWoO6shN+ItCJB4IGgVGQ6x1cEmCjSZRW8=";
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
      hash = "sha256-7HnpkIo2BXScT+tQVHY+toEt0ztUzoWlEzmqfPmZG3k=";
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
      hash = "sha256-s34vAJxMzkkk+yPuQxRuUGcilxvqa87S2sFdCAo7xhM=";
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
      hash = "sha256-qfzrLgMY43hlJea/IF4+FD8M82InQIGcq18FjmV+isU=";
    };
    meta = {
      description = "Framework for parsing Pod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodSpell = buildPerlPackage {
    pname = "Pod-Spell";
    version = "1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOLMEN/Pod-Spell-1.20.tar.gz";
      hash = "sha256-Y4P3v+IrwNg5oIBXoM54BpiwRhhK6pNb5IM9lJht0Dw=";
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
      hash = "sha256-2A2s9qeszIfTZoMBZSNNchvS827uGHrvaCtgyQR3Uv8=";
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
      hash = "sha256-iG7hQ+p81Tm0O+16KHmJ0Wc211y/ofheLMzq+eiVnb0=";
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
      hash = "sha256-WvJbKaVXg+SVqd9e9ikyQOLJqwJ2RhPXnx7VCxLexa4=";
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
      hash = "sha256-UMrL4v/7tccNG6XpQn1cit7mGENuxz+W7QU5Iy4si2M=";
    };
    propagatedBuildInputs = [ PodParser ];
    meta = {
      description = "Wrap pod paragraphs, leaving verbatim text and code alone";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "podwrap";
    };
  };

  ProbePerl = buildPerlPackage {
    pname = "Probe-Perl";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Probe-Perl-0.03.tar.gz";
      hash = "sha256-2eTSHi53Y4VZBF+gkEaxtv/2xAO5SZKdshPjCr6KPDE=";
    };
    meta = {
      description = "Information about the currently running perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  POSIXAtFork = buildPerlPackage {
    pname = "POSIX-AtFork";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors//id/N/NI/NIKOLAS/POSIX-AtFork-0.04.tar.gz";
      hash = "sha256-wuIpOobUhxRLyPe6COfEt2sRsOTf3EGAmEXTDvoH5g4=";
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
      hash = "sha256-39PJc5jc/lHII2uF49woA1Znt2Ux96oKZTXzqlQFs1o=";
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
      hash = "sha256-TxOa01+q8t4GI9wLsd2J+lpDHlSL/sh97hlM8OJcyX0=";
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
      hash = "sha256-XgYuAuu2XiS3COfu+lMAxD1vZXvyDQj+xMqKCjuUhF8=";
    };
    propagatedBuildInputs = [ DigestSHA1 URI ];
    meta = {
      description = "Collaborative, content-based spam filtering network agent";
      homepage = "https://razor.sourceforge.net/";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };


  Readonly = buildPerlModule {
    pname = "Readonly";
    version = "2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz";
      hash = "sha256-SyNUJJGvAQ1EpcfIYSRHOKzHSrq65riDjTVN+xlGK14=";
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
      hash = "sha256-gbuX26k6xrXMvOBKQsNZDrBFV9dQGHc+4Y1aMPz0gYg=";
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
      hash = "sha256-iuXE6FKZ5ci93RsZby7qOPAHCeDcDLYEVNyRFK4//w0=";
    };
    propagatedBuildInputs = [ Readonly ];
    meta = {
      description = "Companion module for Readonly.pm, to speed up read-only scalar variables";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Redis = buildPerlModule {
    pname = "Redis";
    version = "1.998";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAMS/Redis-1.998.tar.gz";
      hash = "sha256-WfO7F2w6elTLN3lJe4mnuuH7IXVlxocR1YX8HwnXnIc=";
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
      hash = "sha256-QV+nPbrPRPPV15wUiIzJlFYnIKtGjm9x+RzR92nxBeE=";
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
      hash = "sha256-oGvn+a4bc8m/1bZmKxQcDXBGnpwZu0QTpu5W+Cra5EI=";
    };
    meta = {
      description = "Assemble multiple Regular Expressions into a single RE";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpCommon = buildPerlPackage {
    pname = "Regexp-Common";
    version = "2017060201";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz";
      hash = "sha256-7geFOu4G8xDgQLa/GgGZoY2BiW0yGbmzXJYw0OtpCJs=";
    };
    meta = {
      description = "Provide commonly requested regular expressions";
      license = with lib.licenses; [ mit ];
    };
  };

  RegexpCommonnetCIDR = buildPerlPackage {
    pname = "Regexp-Common-net-CIDR";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Regexp-Common-net-CIDR-0.03.tar.gz";
      hash = "sha256-OWBqV6qyDU9EaDAPLsP6KrVX/MnLeIDsfG4H2AFi2jM=";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      description = "Provide patterns for CIDR blocks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpCommontime = buildPerlPackage {
    pname = "Regexp-Common-time";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MANWAR/Regexp-Common-time-0.16.tar.gz";
      hash = "sha256-HIEHpQq1XHK/ePsRbJGIxM3xYsGGwVhsH5qu5V/xSso=";
    };
    propagatedBuildInputs = [ RegexpCommon ];
    meta = {
      description = "Date and time regexps";
      homepage = "https://github.com/manwar/Regexp-Common-time";
      license = with lib.licenses; [ artistic2 mit bsd3 ];
      maintainers = [ maintainers.artturin ];
    };
  };

  RegexpGrammars = buildPerlModule {
    pname = "Regexp-Grammars";
    version = "1.057";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCONWAY/Regexp-Grammars-1.057.tar.gz";
      hash = "sha256-r1PBmBhGHNcBrrV8Sd/9tGPtxL+PZY2epObVNKwXcEE=";
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
      hash = "sha256-1ULRfXXOk2Md6LohVtoOC1inVcQJzUoNJ6OHOiZxLOI=";
    };
    meta = {
      description = "Regular expression for IPv6 addresses";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpParser = buildPerlPackage {
    pname = "Regexp-Parser";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Regexp-Parser-0.23.tar.gz";
      hash = "sha256-9znauN8rBqrlxI+ZcSUbc3BEZKMtB9jQJfPA+GlUTok=";
    };
    meta = {
      description = "Base class for parsing regexes";
      homepage = "https://wiki.github.com/toddr/Regexp-Parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RegexpTrie = buildPerlPackage {
    pname = "Regexp-Trie";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Regexp-Trie-0.02.tar.gz";
      hash = "sha256-+yv5TtjbwfSpXZ/I9xDLZ7P3lsbvycS7TCz6Prqhxfo=";
    };
    meta = {
      description = "Builds trie-ized regexp";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RESTClient = buildPerlPackage {
    pname = "REST-Client";
    version = "273";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KK/KKANE/REST-Client-273.tar.gz";
      hash = "sha256-qGUqIhQwj6/yxovlzmTJBNzMxehr5/MjdsFZCGnQGEQ=";
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
      hash = "sha256-1OlK3YetMf71h8RxFceIx88+EiyS85YyWuLmEsZwuf0=";
    };
    buildInputs = [ TestLongString TestWWWMechanize TestWWWMechanizeCGI ];
    meta = {
      description = "Utility functions for REST applications";
      homepage = "https://jaldhar.github.com/REST-Utils";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RpcXML = buildPerlPackage {
    pname = "RPC-XML";
    version = "0.80";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.80.tar.gz";
      hash = "sha256-6g18qHqrcMEoF99Yk/a/4Eks5j9uDmPAtFLjdTRMfvc=";
    };
    propagatedBuildInputs = [ XMLParser ];
    doCheck = false;
    meta = {
      description = "Data, client and server classes for XML-RPC";
      homepage = "https://github.com/rjray/rpc-xml";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "make_method";
    };
  };

  ReturnValue = buildPerlPackage {
    pname = "Return-Value";
    version = "1.666005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.666005.tar.gz";
      hash = "sha256-jiJgqWUx6TaGIAuciFDr4AXYjONp/2vHD/GnQFt1UKw=";
    };
    meta = {
      description = "Create context-sensitive return values";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleBasic = buildPerlModule {
    pname = "Role-Basic";
    version = "0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Role-Basic-0.13.tar.gz";
      hash = "sha256-OKCVnvnxk/925ywyWp6SEbxIaGib0OKwBXePU/i282o=";
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
      hash = "sha256-9qbb4Edv+V7h/774JesY2bArBhjeukaG58Y7mdV21NM=";
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
      hash = "sha256-VhNG0aGgekW9hR2FmoJaf2eSWno7pbpY4M2ti7mQc60=";
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
      hash = "sha256-krpXEoUKdBAsk8lC625/Yvek+PSDc07SidCLMkwoFoc=";
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
      hash = "sha256-l19BNDZSWPtH+pIZGQU1E625EB8r1CD87+NF8gkSi+M=";
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
      hash = "sha256-XstCqmkyTm9AiKv64HMTkG5aq/L0bxIE8/HeWRVbtjY=";
    };
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.rpm ];
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
      hash = "sha256-idw0vKixqp/uC8QK7d5eLBYCL8eYssOryH3gczG5lbk=";
    };
    propagatedBuildInputs = [ locallib ];
    doCheck = false; /* creates files in HOME */
    meta = {
      description = "A simple pure perl RSS parser";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RTClientREST = buildPerlModule {
    pname = "RT-Client-REST";
    version = "0.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DJ/DJZORT/RT-Client-REST-0.60.tar.gz";
      hash = "sha256-Dm8to9lpA0kbQ7GcYSIcvuqIQUJk+QcxLyd9qvFEJIs=";
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
      hash = "sha256-h/QUiqD/HV5lJyMyLqt9r6OAHJZ9b5GskUejxGe4pmo=";
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
      hash = "sha256-TSvcHHKnvE1p1qXMhbx1Zkl8Oxg8YXW4MnhDKdWP60s=";
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
      hash = "sha256-9UoXybeHE7AsxDrfrfYLSUZ+djTTExfouenpfCbWi1I=";
    };
    meta = {
      description = "String aspects of scalars";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SCGI = buildPerlModule {
    pname = "SCGI";
    version = "0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VI/VIPERCODE/SCGI-0.6.tar.gz";
      hash = "sha256-WLeMWvTuReQ38Hro87DZRckf0sAlFW7pFtgRWA+R2aQ=";
    };
    preConfigure = "export HOME=$(mktemp -d)";
    meta = {
      description = "This module is for implementing an SCGI interface for an application server";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeGuard = buildPerlPackage {
    pname = "Scope-Guard";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.21.tar.gz";
      hash = "sha256-jJsb6lxWRI4sP63GXQW+nkaQo4I6gPOdLxD92Pd30ng=";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeUpper = buildPerlPackage {
    pname = "Scope-Upper";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.34.tar.gz";
      hash = "sha256-WB2LxRDevQxFal/HlSy3E4rmZ78486d+ltdz3DGWpB4=";
    };
    meta = {
      description = "Act on upper scopes";
      homepage = "https://search.cpan.org/dist/Scope-Upper";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SDL = buildPerlModule {
    pname = "SDL";
    version = "2.548";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FROGGS/SDL-2.548.tar.gz";
      hash = "sha256-JSoZK/qcIHCkiDcH0TnDpF2cRRjM1moeaZtbeVm9T7U=";
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
      hash = "sha256-hxlDGZuA79mOMfS0cRuwcKV2yRvmkhk9ikOv+tZFdN0=";
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
      hash = "sha256-jg47mprxp3i33iFQb6MHl/sbUg3NAC8/KebctSRG3qU=";
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
      hash = "sha256-D9UbpggwJmUNCFJnWCYRc8GKuCNMVSb6x+25GtnGAm4=";
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
      hash = "sha256-C+X+VStQtnhjk+Q+qczldzpItf80o6zyopWqdgmgYrk=";
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
      hash = "sha256-05JWfLObTqYGwOCsr9jtcjIDEbmVM27OX878+bFQ6dc=";
    };
    meta = {
      description = "Linux/POSIX emulation of Win32::SerialPort functions.";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "modemtest";
    };
  };

  ServerStarter = buildPerlModule {
    pname = "Server-Starter";
    version = "0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Server-Starter-0.35.tar.gz";
      hash = "sha256-Z23A1s/0ZIU4Myxjwy+4itCe2GghPqnmLj8Z+tQbnEA=";
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
      hash = "sha256-MsPflu9FXHGHA2Os2VDdxPvISMWU9LxVshtEz5efeaE=";
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
      hash = "sha256-B7yIBzRJLeQLSjqLWjMXYvZOabRikCn9mp01eyW4fh8=";
    };
    meta = {
      description = "Infinite Sets math";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SetIntSpan = buildPerlPackage {
    pname = "Set-IntSpan";
    version = "1.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz";
      hash = "sha256-EbdUmxPsXYfMaV3Ux3fNApg91f6YZgEod/tTD0iz39A=";
    };

    meta = {
      description = "Manages sets of integers, newsrc style";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SetObject = buildPerlPackage {
    pname = "Set-Object";
    version = "1.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/Set-Object-1.40.tar.gz";
      hash = "sha256-HE2EZME+bZSVfPAhzmA8lhsI9S22qer1pbDTeGjNN7c=";
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
      hash = "sha256-o9wVJvPd5y08ZOoAAHuGzmCM3Nk1Z89ubkLcEP3EUR0=";
    };
    meta = {
      description = "Basic set operations";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SmartComments = buildPerlPackage rec {
    pname = "Smart-Comments";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Smart-Comments-1.06.tar.gz";
      hash = "sha256-3PijEhNKfGuCkmoBFdk7aSRypmLSjNw6m98omEranuM=";
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
      hash = "sha256-VQySRSkcjfIkL36I95IaD2NsfuySxkRBjn2Jz+pwsr0=";
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
      hash = "sha256-BD2ZW2sknZ68BMRn2zG7fdwuVfqgjohb2wULHyM2tz8=";
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
      hash = "sha256-Hc+NfyazdSCgENzVGXAU4KWDhe5muDtP3gfqtQrZ5Rg=";
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
      hash = "sha256-76qSNVhZj06IjZelEtYPvMRIHB+cXn3tUnWWKUVg/Ck=";
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
      hash = "sha256-41kQa6saRaFgRKTC+ASfrQNOXe0VF5kLybX42G3d0wE=";
    };
    propagatedBuildInputs = [ ClassInspector IOSessionData LWPProtocolHttps TaskWeaken XMLParser ];
    buildInputs = [ TestWarn XMLParserLite ];
    nativeCheckInputs = [ HTTPDaemon ];
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
      hash = "sha256-RokV+joE3PZXT8lX7/SVkV4kVpQ0lwyR7o5OFFn8kRQ=";
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
      hash = "sha256-60XqYC11AGaDeJ+7pXoBwKH3A3Nx3pXqVLkVd1NdF4k=";
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
      hash = "sha256-WU9carwhbJXNRYd8Qd7FbSvDDh0DFq04VbCiqo5dU7E=";
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
      hash = "sha256-7WpMz6sJTJzRZPVkAk6YvSHZT0MSzKxNYkbSKzQIGs8=";
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
      hash = "sha256-v18zB0BuviWBI38CWYLoyE9vZiXdd05FfAP4mU79Lqo=";
    };
    meta = {
      description = "A perl 5 module for sorting of revision-like numbers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Specio = buildPerlPackage {
    pname = "Specio";
    version = "0.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Specio-0.46.tar.gz";
      hash = "sha256-C/QqoRYHbW78GPcrcsestWOL1BwKoJrswS/Iv5zrlZY=";
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
      hash = "sha256-72gT6or1FyQwREmZjbIeoqk7JYJVSet50/HpFx/qzjM=";
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
      hash = "sha256-j1hiCoQgJVxJtsQ8X/WAK9JeTwkkDFHlvysCKDPUHaM=";
    };
    meta = {
      description = "Spiffy Perl Interface Framework For You";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetCSV = buildPerlPackage {
    pname = "Spreadsheet-CSV";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/Spreadsheet-CSV-0.20.tar.gz";
      hash = "sha256-BwuyUqj+i5OKHOT8kFJfgz1OYZttRnOwrgojQI1RSrY=";
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
      hash = "sha256-bsTLQpvVjYFkD+EhFvQ1xG9R/xBAxo8JzIt2gcFnW+w=";
    };
    propagatedBuildInputs = [ CryptRC4 DigestPerlMD5 IOStringy OLEStorage_Lite ];
    meta = {
      description = "Read information from an Excel file";
      homepage = "https://github.com/runrig/spreadsheet-parseexcel";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SpreadsheetWriteExcel = buildPerlPackage {
    pname = "Spreadsheet-WriteExcel";
    version = "2.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/Spreadsheet-WriteExcel-2.40.tar.gz";
      hash = "sha256-41aq1oZs8TVzEmjuDpeaGXRDwVoEh46c8+gNAirWwH4=";
    };
    propagatedBuildInputs = [ OLEStorage_Lite ParseRecDescent ];
    meta = {
      description = "Write to a cross platform Excel binary file";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "chartex";
    };
  };

  SpreadsheetXLSX = buildPerlPackage {
    pname = "Spreadsheet-XLSX";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AS/ASB/Spreadsheet-XLSX-0.17.tar.gz";
      hash = "sha256-M7d4knz/FjCQZbdOuMRpawNxZg0szf5FvkYFCSrO6XY=";
    };
    buildInputs = [ TestNoWarnings TestWarnings ];
    propagatedBuildInputs = [ ArchiveZip SpreadsheetParseExcel ];
    meta = {
      homepage = "https://github.com/asb-capfan/Spreadsheet-XLSX";
      description = "Perl extension for reading MS Excel 2007 files;";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstract = buildPerlPackage {
    pname = "SQL-Abstract";
    version = "2.000001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/SQL-Abstract-2.000001.tar.gz";
      hash = "sha256-NaZCZiw0lCDUS+bg732HZep0PrEq0UOZqjojK7lObpo=";
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
      hash = "sha256-Tj0d/QlbISMmhYa7BrhpKepXE4jU6UGszL3NoeEI7yg=";
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
      hash = "sha256-0Yr9eIk72DC6JGXArmozQlRgFZADhk3tO1rc9RGJyuk=";
    };
    propagatedBuildInputs = [ DBI SQLAbstract ];
    buildInputs = [ TestDeep TestException ];
    meta = {
      description = "Portable LIMIT emulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstractPg = buildPerlPackage {
    pname = "SQL-Abstract-Pg";
    version = "1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/SQL-Abstract-Pg-1.0.tar.gz";
      hash = "sha256-Pic2DfN7jYjzxS2smwNJP5vT7v9sjYj5sIbScRVT9Uc=";
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
      hash = "sha256-93ww9E2HFY2C9lTp+pTTmlD994WcWn+9WBMnRmYhDy8=";
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
      hash = "sha256-3ei9z6ahNu7doGUZug8++uwIXDnbDfnEctwOxs14Gkk=";
    };
    buildInputs = [ MathBaseConvert TestDeep TextSoundex ];
    propagatedBuildInputs = [ Clone ModuleRuntime ParamsUtil ];
    meta = {
      description = "SQL parsing and processing engine";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLTokenizer = buildPerlPackage {
    pname = "SQL-Tokenizer";
    version = "0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IZ/IZUT/SQL-Tokenizer-0.24.tar.gz";
      hash = "sha256-+qhpvEJlc2QVNqCfU1AuVA1ePjrWp6oaxiXT9pdrQuE=";
    };
    meta = {
      description = "A simple SQL tokenizer";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLTranslator = buildPerlPackage {
    pname = "SQL-Translator";
    version = "1.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/SQL-Translator-1.62.tar.gz";
      hash = "sha256-Cs1P+aw6L41dZxmarALNwSfgOIjkecUce73CG4XBziQ=";
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
      hash = "sha256-su2EnS9M3WZGdRLao/FDJm1t+BDF+ukXWyUsV7wVNtw=";
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
      hash = "sha256-6qscXIdXWngmCJMEqx+P+n8Y5s2LOTdiPpmOhl7B50Y=";
    };
    meta = {
      description = "Sort lexically, but sort numeral parts numerically";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Starlet = buildPerlPackage {
    pname = "Starlet";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Starlet-0.31.tar.gz";
      hash = "sha256-uWA7jmKIDLRYL2p5Oer+xl5u/T2QDyx900Ll9MaNYtg=";
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
      hash = "sha256-EPUJe8o5pDJ/9uaec/B2CdOmWaeJa+OWS0nMJBKxM/g=";
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
      hash = "sha256-aFXOVhX9Phr0z8RRqb9E/ymjFAtOcTADTx8K8lEalPs=";
    };
    propagatedBuildInputs = [ NumberFormat ];
    meta = {
      description = "A collection of very basic statistics modules";
      license = with lib.licenses; [ lgpl2Only ];
    };
  };

  StatisticsCaseResampling = buildPerlPackage {
    pname = "Statistics-CaseResampling";
    version = "0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/Statistics-CaseResampling-0.15.tar.gz";
      hash = "sha256-hRxDvW8Q0yKJUipQxqIJw7JGz9PrVmdz5oYe2gSkkIc=";
    };
    meta = {
      description = "Efficient resampling and calculation of medians with confidence intervals";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsChiSquare = buildPerlPackage rec {
    pname = "Statistics-ChiSquare";
    version = "1.0000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/Statistics-ChiSquare-1.0000.tar.gz";
      hash = "sha256-JVpaODNtBI3bkHciJpHgAJhOkHquCaTqaVqc/Umh3dA=";
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
      hash = "sha256-sE7e6ia/7UNapgKZVnmMKB9/UtRUXz9Fsq1ElU6W+Tk=";
    };
    propagatedBuildInputs = [ ListMoreUtils ];
    meta = {
      description = "Module of basic descriptive statistical functions";
      homepage = "https://metacpan.org/release/Statistics-Descriptive";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsDistributions = buildPerlPackage {
    pname = "Statistics-Distributions";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEK/Statistics-Distributions-1.02.tar.gz";
      hash = "sha256-+Z85ar+EyjeqLOoxrUXXOq7kh1LJmRNsS5E4lCjXM8g=";
    };
    meta = {
      description = "Perl module for calculating critical values and upper probabilities of common statistical distributions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsTTest = buildPerlPackage {
    pname = "Statistics-TTest";
    version = "1.1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YU/YUNFANG/Statistics-TTest-1.1.0.tar.gz";
      hash = "sha256-stlZ0ljHKEebfYYu4BRuWtjuqYm+JWN8vFdlUv9zcWY=";
    };
    propagatedBuildInputs = [ StatisticsDescriptive StatisticsDistributions ];
    meta = {
      description = "Perl module to perform T-test on 2 independent samples Statistics::TTest::Sufficient - Perl module to perfrom T-Test on 2 indepdent samples using sufficient statistics";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StreamBuffered = buildPerlPackage {
    pname = "Stream-Buffered";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.03.tar.gz";
      hash = "sha256-my1DkLXeawz0VY5K0EMXpzxeE90ZrykUnE5Hw3+yQjs=";
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
      hash = "sha256-CdV5dKbRsjgMgChw/tRxEI9RFw2oFFjidRhZ8nFPjVc=";
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
      hash = "sha256-QyAedi2GmcsKwsB2SlRUvcIwbAdxAU1sj7qCFIBjE0I=";
    };
    meta = {
      description = "Perl extension for approximate matching (fuzzy matching)";
      license = with lib.licenses; [ artistic2 gpl2Only ];
    };
  };

  StringCamelCase = buildPerlPackage {
    pname = "String-CamelCase";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIO/String-CamelCase-0.04.tar.gz";
      hash = "sha256-icPevO7Orodk9F10Aj+Pvu4tiDma9nVB29qgsr8nEak=";
    };
    meta = {
      description = "Camelcase, de-camelcase";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringCompareConstantTime = buildPerlPackage {
    pname = "String-Compare-ConstantTime";
    version = "0.321";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FR/FRACTAL/String-Compare-ConstantTime-0.321.tar.gz";
      hash = "sha256-Cya6KxIdgARCXUSF0dRvWQAcg3Y6omYk3/YiDXc11/c=";
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
      hash = "sha256-7bf+rlDsn9cSV9j7IeH+1/9N/jDXmLGvIm0q96a92S0=";
    };
    meta = {
      description = "Perl interface for cyclic redundancy check generation";
      license = with lib.licenses; [ publicDomain ];
    };
  };

  StringDiff = buildPerlModule {
    pname = "String-Diff";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YAPPO/String-Diff-0.07.tar.gz";
      hash = "sha256-chW2fLwyJuLQ4Ys47FjJO+C/YJAnhpi++VU0iCbNCvM=";
    };
    patches = [
      (fetchpatch {
        url = "https://salsa.debian.org/perl-team/modules/packages/libstring-diff-perl/-/raw/d8120a93f73f4d4aa40d10819b2f0a312608ca9b/debian/patches/0001-Fix-the-test-suite-for-YAML-1.21-compatibility.patch";
        hash = "sha256-RcYsn0jVa9sSF8iYPuaFTWx00LrF3m7hH9e6fC7j72U=";
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
      hash = "sha256-rhNveD2sZYeuotItZOwgUnIVOoP5VLB1dm49KYpO1ts=";
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
      hash = "sha256-/WRfizNiJNIKha5/saOEV26sMp963DkjwyQego47moo=";
    };
    meta = {
      description = "Backslash escapes, quoted phrase, word elision, etc";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringFlogger = buildPerlPackage {
    pname = "String-Flogger";
    version = "1.101245";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Flogger-1.101245.tar.gz";
      hash = "sha256-qgPAjgH4AqNYwXXGCTwCrflohlmgh6jd79w+nO9yZAs=";
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
      hash = "sha256-nkF6j42epiO+6i0TpHwNWmlvyGAsBQm4Js1F+Xt253g=";
    };
    meta = {
      description = "sprintf-like string formatting capabilities with arbitrary format definitions";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  StringFormatter = buildPerlPackage {
    pname = "String-Formatter";
    version = "0.102084";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Formatter-0.102084.tar.gz";
      hash = "sha256-gzVBEv0MZt8eEuAi33XvvzDr20NYHACJfIbsHDOonFY=";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      description = "Build sprintf-like functions of your own";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  StringInterpolate = buildPerlPackage {
    pname = "String-Interpolate";
    version = "0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/String-Interpolate-0.32.tar.gz";
      hash = "sha256-xynYmEj1WjV7z5e3m3i2uSsmPkw8knR+fe02Of5d3JU=";
    };
    meta = {
      # https://metacpan.org/pod/String::Interpolate
      description = "String::Interpolate - Wrapper for builtin the Perl interpolation engine.";
      license = with lib.licenses; [ gpl1Plus ];
    };
    propagatedBuildInputs = [ PadWalker SafeHole ];
  };

  StringInterpolateNamed = buildPerlPackage {
    pname = "String-Interpolate-Named";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/String-Interpolate-Named-1.03.tar.gz";
      hash = "sha256-on13VgcnX2jtkqQT85SsAJLn3hzZPWJHnUf7pwF6Jtw=";
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
      hash = "sha256-UxD4NGAEVHUHFma1Qj2y8KqC1mhcgC7Hq+bCxBBjm5Y=";
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
      hash = "sha256-S0rR7mOix9xwkSrBuQRyNamdjwmkdEcZkgEwM4erl1w=";
    };
    meta = {
      description = "Perl module to generate random strings based on a pattern";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringRewritePrefix = buildPerlPackage {
    pname = "String-RewritePrefix";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.008.tar.gz";
      hash = "sha256-5Fox1pFOj1/HIu9I2IGUANr8AhBeDGFBSqu/AbziCOs=";
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
      hash = "sha256-5gY2UDjOINZG0lXIBe/90y+GR18Y1DynVFWwDk2G3TU=";
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
      hash = "sha256-H47aIpC7y3Ia7wzhsL/hOwEgHdPaphijN/LwLikcMkU=";
    };
    doCheck = true;
    meta = {
      description = "Calculate the similarity of two strings";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  ShellCommand = buildPerlPackage {
    pname = "Shell-Command";
    version = "0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/Shell-Command-0.06.tar.gz";
      hash = "sha256-8+Te71d5RL5G+nr1rBGKwoKJEXiLAbx2p0SVNVYW7NE=";
    };
    meta = {
      description = "Cross-platform functions emulating common shell commands";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ShellConfigGenerate = buildPerlPackage {
    pname = "Shell-Config-Generate";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Shell-Config-Generate-0.34.tar.gz";
      hash = "sha256-hPRR8iIV3WjpwYqj992wOoIAfRZs+toAPQ8Wb1ceBWI=";
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
      hash = "sha256-QGn6JjfkQxGO2VbXECMdFmgj0jsqZOuHuKRocuhloSs=";
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
      hash = "sha256-OvuEIykwuaxbGto4PI3VkHrk4jrsWrsBb3D56AU83Io=";
    };
    propagatedBuildInputs = [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
    meta = {
      description = "Convert Strings to English Program Identifiers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringTruncate = buildPerlPackage {
    pname = "String-Truncate";
    version = "1.100602";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100602.tar.gz";
      hash = "sha256-qqPU7sARNpIUhBORM+t11cVx/lGwrTKfCJ5tRpojX24=";
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
      hash = "sha256-92BfCgT5+hI9Ot9PNFeaFMkLfai5O2XS5IkyzNPJUqs=";
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
      hash = "sha256-+7yafqQMgylOBCuzud6x71LMkaDUgye1RC4cT4Df0m0=";
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
      hash = "sha256-Us5wxDPmlirRwg6eKXpTkeC3SkRSD7zi5IL1RONlf3M=";
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
      hash = "sha256-VDyy6AOrkT1EJyx9pqcLtiwZ5GfzsSqqxMlSMlmwg9Y=";
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
      hash = "sha256-Qh+7pPb/zxPEM18sIGMNcJ5vplnAdUXQlNvFpVitMAY=";
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
      hash = "sha256-L8Re7+beB80/2K+eeZxpf701oC7NW/m82MlM77bbemM=";
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
      hash = "sha256-1TW3lU1k2hrBMFsfrfmCAnaeNZk3aFSyztkMOCvqwFY=";
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
      hash = "sha256-ad7USuVHJAJ0AWZ0dsivJoqQCvTqYEf/RPKDvF4s+dU=";
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
      hash = "sha256-Bo0nIIZRTdHoQrakCxvtuv7mOQDlsIiQ72cAA53vrW8=";
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
      hash = "sha256-6jBW1pa97/IamdNA1VcIh9OajMR7/yOt/ILfZ1jN0Oo=";
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
      hash = "sha256-YeVnp2eViIh7e4bUJ7xHbqbXf//n4NF9ZA+JAH2Y7w8=";
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
      hash = "sha256-LS8taX1RbIlUfnxDB/HnlEFkHK4sc5XnMZswbTkN8QU=";
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
      hash = "sha256-k5pnwfcplo4MyBt0lY23UOG9t8AgvuGiYzMvQiwuJbU=";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Perl extension for easily overriding subroutines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubQuote = buildPerlPackage {
    pname = "Sub-Quote";
    version = "2.006006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz";
      hash = "sha256-bk4q9COI+m0mCeDoJBfefMa+RyI/V2WSxlbHPHUk2J0=";
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
      hash = "sha256-oSfa52RcGpVwzZopcMbcST1SL/BzGKNKOeQJCY9pESU=";
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
      hash = "sha256-tPP2O4D2gKQhMy2IUd2+Wo5y/Kp01dHZjzyMxKPs4pM=";
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
      hash = "sha256-1jzBaeQ2m+mKU5q+nMFhG/zCs2lmplF+Z2aI/tGIT/s=";
    };
    propagatedBuildInputs = [ (pkgs.subversionClient.override { inherit perl; }) ];
    meta = {
      description = "A simple interface to subversion's editor interface";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SafeHole = buildPerlModule {
    pname = "Safe-Hole";
    version = "0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/Safe-Hole-0.14.tar.gz";
      hash = "sha256-9PVui70GxP5K4G2xIYbeyt+6wep3XqGMbAKJSB0V7AU=";
    };
    meta = {
      description = "Lib/Safe/Hole.pm";
      homepage = "https://github.com/toddr/Safe-Hole";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin;
    };
  };

  Swim = buildPerlPackage {
    pname = "Swim";
    version = "0.1.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/Swim-0.1.48.tar.gz";
      hash = "sha256-pfcv0vIpF/orSsuy7iw9MpA9l+5bDkSbDzhwGMd/Tww=";
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
      hash = "sha256-MTVJdRQP5iNawTChCUlkka0z3UL5xiGJ4j9J91+TbXU=";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
    meta = {
      description = "A switch statement for Perl, do not use if you can use given/when";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SymbolGet = buildPerlPackage {
    pname = "Symbol-Get";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FELIPE/Symbol-Get-0.10.tar.gz";
      hash = "sha256-DuVWjFrjVzyodOCeTQUkRmz8Gtmiwk0LyR1MewbyHZw=";
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
      hash = "sha256-D3Yj6dckdgqmQEAiLaHYLxGIWGeRMpJhzGDa0dYNapI=";
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
      hash = "sha256-VbZh3SL5zpub5afgo/UomsAM0lTCHj2GAyiaVlrm3DI=";
    };
    meta = {
      description = "Additional utils for Perl symbols manipulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  syntax = buildPerlPackage {
    pname = "syntax";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHAYLON/syntax-0.004.tar.gz";
      hash = "sha256-/hm22oqPQ6WqLuVxRBvA4zn7FW0AgcFXoaJOmBLH02U=";
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
      hash = "sha256-i0l18hsZkqfmwt9dzJKyVMYZJVle3c368LFJhxeqle8=";
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
      hash = "sha256-JG4bAz4/8i/VQgVQ1Lbg1WtDjNy7nTXL6LG1uhV03iM=";
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
      hash = "sha256-GCDOLInxq3NXZE+NsPSfFC9UUmJQ+x4jXbEKqA8V4s8=";
    };
    meta = {
      description = "Use mmap to map in a file as a Perl variable";
      maintainers = with maintainers; [ peterhoeg ];
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  SysMemInfo = buildPerlPackage {
    pname = "Sys-MemInfo";
    version = "0.99";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCRESTO/Sys-MemInfo-0.99.tar.gz";
      hash = "sha256-B4YxnTo6i65dcnk5JEvxfhQLcU9Sc01en2JyA+TPPjs=";
    };
    meta = {
      description = "Memory information";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = [ maintainers.pSub ];
    };
  };

  SysCPU = buildPerlPackage {
    pname = "Sys-CPU";
    version = "0.61";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz";
      hash = "sha256-JQqGt5wjEAHErnHS9mQoCSpPuyBwlxrK/UcapJc5yeQ=";
    };
    patches = [
      # Bug #95400 for Sys-CPU: Tests fail on ARM and AArch64 Linux
      # https://rt.cpan.org/Public/Bug/Display.html?id=95400
      (fetchpatch {
        url = "https://rt.cpan.org/Ticket/Attachment/1359669/721669/0001-Add-support-for-cpu_type-on-ARM-and-AArch64-Linux-pl.patch";
        hash = "sha256-oIJQX+Fz/CPmJNPuJyHVpJxJB2K5IQibnvaT4dv/qmY=";
      })
      (fetchpatch {
        url = "https://rt.cpan.org/Ticket/Attachment/1388036/737125/0002-cpu_clock-can-be-undefined-on-an-ARM.patch";
        hash = "sha256-nCypGyi6bZDEXqdb7wlGGzk9cFzmYkWGP1slBpXDfHw=";
      })
    ];
    buildInputs = lib.optional stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.Carbon;
    doCheck = !stdenv.isAarch64;
    meta = {
      description = "Perl extension for getting CPU information. Currently only number of CPU's supported.";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysHostnameLong = buildPerlPackage {
    pname = "Sys-Hostname-Long";
    version = "1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/Sys-Hostname-Long-1.5.tar.gz";
      hash = "sha256-6Rht83Bqh379YUnyxxHWz4fdbPcvark1uoEhsiWyZcs=";
    };
    doCheck = false; # no `hostname' in stdenv
    meta = {
      description = "Try every conceivable way to get full hostname";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysSigAction = buildPerlPackage {
    pname = "Sys-SigAction";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.23.tar.gz";
      hash = "sha256-xO9sk0VTQDH8u+Ktw0f8cZTUevyUXnpE+sfpVjCV01M=";
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
      hash = "sha256-7UKp5boErUhWzAy1040onDxdN2RUPsBO+vxK9+M3jfg=";
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
      hash = "sha256-Q95ezSDB2kbopvT86rKeBGl6KJCpm/apGzygBKRookE=";
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
    version = "9.7.0";
    src = fetchFromGitLab {
      owner = "libvirt";
      repo = "libvirt-perl";
      rev = "v${version}";
      hash = "sha256-tXXB6Gj27oFZv9WD4dXWdY55jDDLrGYbud4qoyjNe5A=";
    };
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.libvirt CPANChanges TestPod TestPodCoverage XMLXPath ];
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Libvirt Perl API";
      homepage = "https://libvirt.org";
      license = with lib.licenses; [ gpl2Plus artistic1 ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.SysVirt.x86_64-darwin
    };
  };

  TAPParserSourceHandlerpgTAP = buildPerlModule {
    pname = "TAP-Parser-SourceHandler-pgTAP";
    version = "3.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.35.tar.gz";
      hash = "sha256-hO45b6fOw9EfD172hB1f6wl80Mz8ACAMPs2zQM8YpZg=";
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
      hash = "sha256-dbGy2WFVZHhCWHFGzv0N4wlDuFGV6OPspR4PC4ZC1h4=";
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
      hash = "sha256-PRkQt64SVBfG4HeUeOtK8/yc+J4iGVhfiiBBFGP5k6c=";
    };
    buildInputs = [ CodeTidyAll TestDataSplit TestDifferences TestPerlTidy TestRunPluginTrimDisplayedFilenames TestRunValgrind TestTrailingSpace TestTrap ];
    propagatedBuildInputs = [ EnvPath FileWhich GamesSolitaireVerify InlineC ListMoreUtils MooX StringShellQuote TaskTestRunAllPlugins TemplateToolkit YAMLLibYAML ];
    meta = {
      description = "Install the CPAN dependencies of the Freecell Solver test suite";
      homepage = "https://metacpan.org/release/Task-FreecellSolver-Testing";
      license = with lib.licenses; [ mit ];
    };
  };

  TaskPlack = buildPerlModule {
    pname = "Task-Plack";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Task-Plack-0.28.tar.gz";
      hash = "sha256-edUriAZUjz+Vro1qyRW6Q524SJ/mOxOdCsFym7KfXCo=";
    };
    propagatedBuildInputs = [ CGICompile CGIEmulatePSGI CGIPSGI Corona FCGI FCGIClient FCGIProcManager HTTPServerSimplePSGI IOHandleUtil NetFastCGI PSGI PlackAppProxy PlackMiddlewareAuthDigest PlackMiddlewareConsoleLogger PlackMiddlewareDebug PlackMiddlewareDeflater PlackMiddlewareHeader PlackMiddlewareReverseProxy PlackMiddlewareSession Starlet Starman Twiggy ];
    buildInputs = [ ModuleBuildTiny TestSharedFork ];
    meta = {
      description = "Plack bundle";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TaskTestRunAllPlugins = buildPerlModule {
    pname = "Task-Test-Run-AllPlugins";
    version = "0.0106";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Task-Test-Run-AllPlugins-0.0106.tar.gz";
      hash = "sha256-G40L8IhYBmWbwpiBDw1VCq/2gEWtwjepSaymshp9zng=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestRunPluginAlternateInterpreters TestRunPluginBreakOnFailure TestRunPluginColorFileVerdicts TestRunPluginColorSummary TestRunPluginTrimDisplayedFilenames ];
    meta = {
      description = "Specifications for installing all the Test::Run";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TaskWeaken = buildPerlPackage {
    pname = "Task-Weaken";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Task-Weaken-1.06.tar.gz";
      hash = "sha256-I4P+252672RkaOqCSvv3yAEHZyDPug3yp6B0cm3NZr4=";
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
      hash = "sha256-+DhYd6Sp7Z89OQPS0PfNcPrDzmgyxg9gCmghzuP7WHI=";
    };
    propagatedBuildInputs = [
      pkgs.bwidget
      pkgs.tcl
      pkgs.tix
      pkgs.tk
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices ];
    makeMakerFlags = lib.optionals stdenv.isLinux
      [ "--tclsh=${pkgs.tcl}/bin/tclsh" "--nousestubs" ];
    meta = {
      description = "Tcl extension module for Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TclpTk = buildPerlPackage {
    pname = "Tcl-pTk";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAC/Tcl-pTk-1.10.tar.gz";
      hash = "sha256-sMb4KXzTL7KhkF17OSbWMb8p+iM/jYTNHtb+2J85/QQ=";
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
      hash = "sha256-vd+0kZ8Kuyor56lmUzPg1OCYAy8OOD268ExNiWx0hu0=";
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
      hash = "sha256-BgT+iue/OtlnnmTZsa1MnpAUwXeqgOg11SqG942XB8M=";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Allow calling of class methods on arbitrary classes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginIOAll = buildPerlPackage {
    pname = "Template-Plugin-IO-All";
    version = "0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XE/XERN/Template-Plugin-IO-All-0.01.tar.gz";
      hash = "sha256-H3RFQiohky4Ju++TV2bgr2t8zrCI6djgMM16hLzcXuQ=";
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
      hash = "sha256-6iDYBq1lIoLQNTSY4oYN+BJcgLZJFjDCXSY72IDGGNc=";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Encodes text to be safe in JavaScript";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginJSONEscape = buildPerlPackage {
    pname = "Template-Plugin-JSON-Escape";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NA/NANTO/Template-Plugin-JSON-Escape-0.02.tar.gz";
      hash = "sha256-BRqLHTvGAdWPxR4kYGfTZFDP6XAnigRW6KthlA8TzYY=";
    };
    propagatedBuildInputs = [ JSON TemplateToolkit ];
    meta = {
      description = "Adds a .json vmethod and a json filter";
      license = with lib.licenses; [ bsd0 ];
    };
  };

  TemplateTimer = buildPerlPackage {
    pname = "Template-Timer";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-1.00.tar.gz";
      hash = "sha256-tzFMs2UgnZNVe4BU4DEa6MPLXRydIo0es+P8GTpbd7Q=";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Rudimentary profiling for Template Toolkit";
      license = with lib.licenses; [ artistic2 gpl3Only ];
    };
  };

  TemplateTiny = buildPerlPackage {
    pname = "Template-Tiny";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/Template-Tiny-1.12.tar.gz";
      hash = "sha256-Bz4GLGMLUd+3Jc1khaMpFVy3LVxZboy2mOtnxFZvCko=";
    };
    meta = {
      description = "Template Toolkit reimplemented in as little code as possible";
      homepage = "https://github.com/karenetheridge/Template-Tiny";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplateToolkit = buildPerlPackage {
    pname = "Template-Toolkit";
    version = "3.101";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-3.101.tar.gz";
      hash = "sha256-0qMt1sIeSzfGqT34CHyp6IDPrmE6Pl766jB7C9yu21g=";
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
      hash = "sha256-mFI8gZLy6BhAQuWi4XK9dnrCid0uSA819oDc4yFgkFs=";
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
      hash = "sha256-lbqWh9c10lo8vmRQjXiU8AnH+ioXJsPnhuniHaIlHQs=";
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
      hash = "sha256-JkLsylsLA4wUgSvK06lhH/eRHcWckQTSIHl/g3qIDEk=";
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
      hash = "sha256-JWdSkvWIvCnTLnEM82Z9qaKhdR4TmAF3Cp/bGM0hhKY=";
    };
    propagatedBuildInputs = [ IOInteractive TermProgressBar ];
    buildInputs = [ TestMockObject ];
    meta = {
      description = "Provide a progress meter if run interactively";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarSimple = buildPerlPackage {
    pname = "Term-ProgressBar-Simple";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVDB/Term-ProgressBar-Simple-0.03.tar.gz";
      hash = "sha256-og2zxn1b39DB+rOSxtHCaICn7oQ69gKvT5tTpwQ1eaY=";
    };
    propagatedBuildInputs = [ TermProgressBarQuiet ];
    buildInputs = [ TestMockObject ];
    meta = {
      description = "Simpler progress bars";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermReadKey = let
    cross = stdenv.hostPlatform != stdenv.buildPlatform;
  in buildPerlPackage {
    pname = "TermReadKey";
    version = "2.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz";
      hash = "sha256-WmRYeNxXCsM2YVgfuwkP8k684X1D6lP9IuEFqFakcpA=";
    };

    # use native libraries from the host when running build commands
    postConfigure = lib.optionalString cross (let
      host_perl = perl.perlOnBuild;
      host_self = perl.perlOnBuild.pkgs.TermReadKey;
      perl_lib = "${host_perl}/lib/perl5/${host_perl.version}";
      self_lib = "${host_self}/lib/perl5/site_perl/${host_perl.version}";
    in ''
      sed -ie 's|"-I$(INST_ARCHLIB)"|"-I${perl_lib}" "-I${self_lib}"|g' Makefile
    '');

    # TermReadKey uses itself in the build process
    nativeBuildInputs = lib.optionals cross [
      perl.perlOnBuild.pkgs.TermReadKey
    ];
    meta = {
      description = "A perl module for simple terminal control";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermReadLineGnu = buildPerlPackage {
    pname = "Term-ReadLine-Gnu";
    version = "1.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.36.tar.gz";
      hash = "sha256-mgj3pAE8m4ZVQcENu6EhB3nrkSi5YSULdG0mcCuraSU=";
    };
    buildInputs = [ pkgs.readline pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lreadline -lncursesw";

    # For some crazy reason Makefile.PL doesn't generate a Makefile if
    # AUTOMATED_TESTING is set.
    env.AUTOMATED_TESTING = false;

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
      hash = "sha256-rDcxM87hshIqgnP+e0JEYT0O7O/oi2aL2Y/nHR7ErJM=";
    };

    outputs = [ "out" ];

    meta = {
      description = "A Term::ReadLine driver based on Term::ReadLine::Perl, with special features for microblogging and the TTYtter client (q.v)";
      homepage = "https://www.floodgap.com/software/ttytter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermReadPassword = buildPerlPackage rec {
    pname = "Term-ReadPassword";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHOENIX/${pname}-${version}.tar.gz";
      hash = "sha256-4ahmNFs1+f/vfQA34T1tTLKAMQCJ+YwgcTiAvHD7QyM=";
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
      hash = "sha256-fWz1ecALZUDC2x2Sl8rXTuCzgP4B/9OPjm1uTM47Pdc=";
    };
    propagatedBuildInputs = [ TermReadKey TextAutoformat ];
    meta = {
      homepage = "https://metacpan.org/release/Term-Shell";
      description = "A simple command-line shell framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermShellUI = buildPerlPackage {
    pname = "Term-ShellUI";
    version = "0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRONSON/Term-ShellUI-0.92.tar.gz";
      hash = "sha256-MnnAHHYiczXu/wkDKkD0sCsoUVGzV2wEys0VvgWUK9s=";
    };
    meta = {
      description = "A fully-featured shell-like command line environment";
      license = with lib.licenses; [ mit ];
    };
  };

  TermSizeAny = buildPerlPackage {
    pname = "Term-Size-Any";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz";
      hash = "sha256-ZPpf2xrjqCMTSqqVrsdTVLwXvdnKEroKeuNKflGz3tI=";
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
      hash = "sha256-rppnRssbMF3cj42MpGh4VSucESNiiXHhOidRg4IvIJ4=";
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
      hash = "sha256-2KGLKAH5Hw5ddHFHznhpZKdvkdGFaGUpCKPcBqm5SNU=";
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
      hash = "sha256-8uSReWBhIFsIaIgCsod5LX2AOwiXIzn7EHC6BWEq+IU=";
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
      hash = "sha256-kZRsgNf0qrDKS/7cO74KdbN8qxopvXvKOzt0VtQX6aY=";
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
      hash = "sha256-+VTgMQlB1FwPw+tKQPXToA1oEZ4nfTA6HmrxHe1vvZQ=";
    };
    meta = {
      description = "A class to emulate a DEC VT102 terminal";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TermVT102Boundless = buildPerlPackage {
    pname = "Term-VT102-Boundless";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FB/FBARRIOS/Term-VT102-Boundless-0.05.tar.gz";
      hash = "sha256-4d7YWuPXa1nAO4aX9KbLAa4xvWKpNU9bt9GPnpJ7SF8=";
    };
    propagatedBuildInputs = [ TermVT102 ];
    meta = {
      description = "A Term::VT102 that grows automatically to accommodate whatever you print to it";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermAnimation = buildPerlPackage {
    pname = "Term-Animation";
    version = "2.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz";
      hash = "sha256-fVw8LU+bZXqLHc5/Xiy74CraLpfHLzoDBL88mdCEsEU=";
    };
    propagatedBuildInputs = [ Curses ];
    meta = {
      description = "ASCII sprite animation framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test2Harness = buildPerlPackage {
    pname = "Test2-Harness";
    version = "1.000152";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Harness-1.000152.tar.gz";
      hash = "sha256-iIqWAdvTPuuaSTcdZmK7JE8Ad/QJlM4gvJClvlSRqls=";
    };

    checkPhase = ''
      patchShebangs ./t ./scripts/yath
      ./scripts/yath test -j $NIX_BUILD_CORES
    '';

    propagatedBuildInputs = [ DataUUID Importer LongJump ScopeGuard TermTable Test2PluginMemUsage Test2PluginUUID Test2Suite YAMLTiny gotofile ];
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
      hash = "sha256-XgZi1agjrggWQfXOgoQxEe7BgxzTH4g6bG3lSv34fCU=";
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
      hash = "sha256-TGyNSE1xU9h3ncFVqZKyAwlbXFqhz7Hui87c0GAYeMk=";
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
      hash = "sha256-vj3YAAQu7zYr8X0gVs+ek03ukczOmOTxeLj7V3Ly+3Q=";
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
    version = "0.000155";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Suite-0.000155.tar.gz";
      hash = "sha256-x45rxNabwJeDaXaGM4K1K54MMe4YUGbOYMVL10uq1T0=";
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
      hash = "sha256-l5C3+bl2mOosUwQ2xgkMJRGcb1vS9w14r8SZIsPwJ20=";
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
      hash = "sha256-z6NtqWxQQzH/ICZ0e6R9R37+g1z2zyNO4QywX6n7i6Q=";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase constantboolean ];
    meta = {
      description = "Assertion methods for those who like JUnit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestAssertions = buildPerlPackage {
    pname = "Test-Assertions";
    version = "1.054";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BB/BBC/Test-Assertions-1.054.tar.gz";
      hash = "sha256-/NzkHVcnOIFYGt9oCiCmrfUaTDt+McP2mGb7kQk3AoA=";
    };
    propagatedBuildInputs = [ LogTrace ];
    meta = {
      description = "A simple set of building blocks for both unit and runtime testing";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  TestAggregate = buildPerlModule {
    pname = "Test-Aggregate";
    version = "0.375";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/Test-Aggregate-0.375.tar.gz";
      hash = "sha256-xswKv9DU/OhTcazKk+wkU4GEHTK0yqLWR15LyBMEJ9E=";
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
      hash = "sha256-J5Shqq6x06KH3SxyhiWGY3llYvfbnMxrQkvE8d6K0BQ=";
    };
    propagatedBuildInputs = [ Spiffy ];
    buildInputs = [ AlgorithmDiff TextDiff ];
    meta = {
      description = "A Data Driven Testing Framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestBits = buildPerlPackage {
    pname = "Test-Bits";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/Test-Bits-0.02.tar.gz";
      hash = "sha256-qYJvVkg6J+LGMVZZDzKKNjPjA3XBDfyJ9mkOOSneC8M=";
    };
    propagatedBuildInputs = [ ListAllUtils ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Provides a bits_is() subroutine for testing binary data";
      homepage = "https://metacpan.org/release/Test-Bits";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestCheckDeps = buildPerlPackage {
    pname = "Test-CheckDeps";
    version = "0.010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Test-CheckDeps-0.010.tar.gz";
      hash = "sha256-ZvzMpsbzMOfsyJi9alGEbiFFs+AteMSZe6a33iO1Ue4=";
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
      hash = "sha256-CZFU7YyvP/l8cSN/q5UiZKwcA9knBzelYHHKvmWZE1A=";
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
      hash = "sha256-Y0ze2Gu6Xd4Hztcv+4pGcF/5OqhEuY6WveBVQCNMff8=";
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
      hash = "sha256-M41VaejommVJNfhD7AvISqpIb+jdGJj7nKs+zOzVMno=";
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
      hash = "sha256-zzMg7N3nkeC4lFogwfbyZdkPHj2rGPHiPLZ3x51yloQ=";
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
      hash = "sha256-KKP8b+pzoZ9WPxG9DygYZ1bUx0IHvm3qyq0m0ggblTM=";
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
      hash = "sha256-VqejRZ213g+SQZApzxtNUcRN0C1GkM/zxO7fZm9tjUY=";
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
      hash = "sha256-9VtPnPa8OW0P6AJyZ2hcsqxK/86JfQlnoxf6xttajbU=";
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
      hash = "sha256-Z6xQmt/7HSslao+MBSPgB2HZYBZhksYHApj3CIqa6ck=";
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
      hash = "sha256-5Qg4kK2tMNfeUHA1adX1zvF0oZhZNSLqe0bOOHuCgCI=";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ IOAll ListMoreUtils MooX MooXlate ];
    meta = {
      description = "Split data-driven tests into several test scripts";
      homepage = "https://metacpan.org/release/Test-Data-Split";
      license = with lib.licenses; [ mit ];
    };
  };

  TestDeep = buildPerlPackage {
    pname = "Test-Deep";
    version = "1.130";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-1.130.tar.gz";
      hash = "sha256-QGT0lPX2JYfQrlAcpDkQWCHuWEbGh9xlAyM/VTAKfFY=";
    };
    meta = {
      description = "Extremely flexible deep comparison";
      homepage = "https://github.com/rjbs/Test-Deep";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDeepJSON = buildPerlModule {
    pname = "Test-Deep-JSON";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MO/MOTEMEN/Test-Deep-JSON-0.05.tar.gz";
      hash = "sha256-rshXG54xtzAeJhMsEyxoAJUtwInGRddpVKOtGms1CFg=";
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
      hash = "sha256-bnvqGi8edTGaItHFGZbrrFDKXjZj0bwiMTCIfmLpWfE=";
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
      hash = "sha256-czKzI5E+tqJoTQlHVRljBLL4YG9w6quRNlTKkfJz6sI=";
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
      hash = "sha256-yI27tIuTSwaShIdPM6u6qkOKoxIEqj+nO/wvSurIeNo=";
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
      hash = "sha256-PSbCDfQmKJgcv8+lscoCjGzq2zRMHc+XolrWqItz18U=";
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
      hash = "sha256-KDGZ1/sngH/iImr3sSVxxtwlCNjlwP61BdCJ0xcgr8Q=";
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
      hash = "sha256-FWsT8Hdk92bYtFpDco8kOa+Bo1EmJUON6reDt4g+tTM=";
    };
    propagatedBuildInputs = [ SubUplevel ];
    meta = {
      description = "Test exception-based code";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestExpect = buildPerlPackage {
    pname = "Test-Expect";
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Test-Expect-0.34.tar.gz";
      hash = "sha256-Jij87N2l9km9JTI/ZGuWoaB+RVfK3LMnybrU3EG7uZk=";
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
      hash = "sha256-2jTvkCn2hJ1gJiAdSRJ9BU7mrEuXnIIhAxX1chlkqW8=";
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
      hash = "sha256-FPecsGepCSLpvlVPjks509aXeK5Mj/9E9WD2N/tvLR4=";
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
      hash = "sha256-coPUMPK6IDC4zZea4wOdPxsuw93hoRymrgn5kqZveI8=";
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
      hash = "sha256-YbSmq49hfIx7WXUWTPYZRo3DBLa6quo1J4KShvpYvNU=";
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
      hash = "sha256-zW+t+5ELNLS1OZH/Ix2tmZKcqIUKvsOtDigQxL17Hz0=";
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
      hash = "sha256-szZHy7Sy8vz73k+LtDg9CslcL4nExXcOtpHxZDozeq0=";
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
      hash = "sha256-akUMxMYoHtESnzKhwHQfIoln/touMqKRX/Yhw2Ul/L4=";
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
      hash = "sha256-/P77+yT4havoJ8KtB6w9Th/s8hOhRxf8rzw3F1BF0D4=";
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
      hash = "sha256-iwDvqjVyPBo1yMj1+kapnkvFKN+lIDUrVKxBjvbRz6g=";
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
      hash = "sha256-pjlF7N1CCvwxEJT5OiIM+zXfIyQt5hnlO6Z0d6E2kKI=";
    };
    propagatedBuildInputs = [ SubExporter TextDiff ];
    buildInputs = [ TestDifferences TestNoWarnings ];
    meta = {
      description = "Test binary as hexadecimal string";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHexString = buildPerlModule {
    pname = "Test-HexString";
    version = "0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-HexString-0.03.tar.gz";
      hash = "sha256-fUxM3BkvJZTceP916yz00FYfeUs27g6s7oxKGqigP0A=";
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
      hash = "sha256-LwIFAJrtFSZoGCqvoWNXqx9HtMvAAeiYcbZzh++OXyM=";
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
      hash = "sha256-hcl+vU3rgFKRsXJ3Ay2kiAcijyT4mxzi+zwJ96iWu3g=";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Test::More functions for HTTP::Server::Simple";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestJSON = buildPerlModule {
    pname = "Test-JSON";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/Test-JSON-0.11.tar.gz";
      hash = "sha256-B8CKsvzBKFDRrVT89q/prRoloJgxDD5xQq8dPLgh17M=";
    };
    propagatedBuildInputs = [ JSONAny ];
    buildInputs = [ TestDifferences ];
    meta = {
      description = "Test JSON data";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestKwalitee = buildPerlPackage {
    pname = "Test-Kwalitee";
    version = "1.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Kwalitee-1.28.tar.gz";
      hash = "sha256-tFNs3XVbWXciMtQyXae9T7f1vlC0WF27r3WO7DBiQ6M=";
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
      hash = "sha256-BTJ1MNNGuAphpulD+9dJmGvcqJIRpOswHAjC0XkxThE=";
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
      hash = "sha256-Xwie7ZFfHsjHQ/bSd3w+zQygHfL3ueEAONMWlSWD5AM=";
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
      hash = "sha256-rCtPDZWJmvGhoex4TLdAsrkCVqvuEcg+eykRA+ye1zU=";
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
      hash = "sha256-G4YfVVAgZIp0gdStKBqJ5iQYf4lDepizRjVpGyZeXP4=";
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
      hash = "sha256-q8Q0nq8E0b7B5GQWajAYWR6oRtjzxcnIr0rEkF0+l08=";
    };
    meta = {
      description = "Tests strings for equality, with more helpful failures";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMemoryCycle = buildPerlPackage {
    pname = "Test-Memory-Cycle";
    version = "1.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-Memory-Cycle-1.06.tar.gz";
      hash = "sha256-nVPd/clkzYRUyw2kxpW2o65HtFg5KRw0y52NHPqrMgI=";
    };
    propagatedBuildInputs = [ DevelCycle PadWalker ];
    meta = {
      description = "Verifies code hasn't left circular references";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestMemoryGrowth = buildPerlModule {
    pname = "Test-MemoryGrowth";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-MemoryGrowth-0.04.tar.gz";
      hash = "sha256-oGWFJ1Kr1J5BFbmPbbRsdSy71ePkjtAUXO45L3k9LtA=";
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
      hash = "sha256-JQbIjU6yGydLEIX4BskY3Ml//2nhbRJJ5uGdlDYl5Gg=";
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
      hash = "sha256-zS5S/inKCrtsLmGvvDP7Qui+tCGzhL5rwGSs8xl28wI=";
    };
    buildInputs = [ ClassInspector TestAssert TestUnitLite ];
    propagatedBuildInputs = [ FatalException Moose namespaceclean ];
    meta = {
      description = "Simulating other classes";
      license = with lib.licenses; [ lgpl2Plus ];
    };
  };

  TestMockGuard = buildPerlModule {
    pname = "Test-Mock-Guard";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAICRON/Test-Mock-Guard-0.10.tar.gz";
      hash = "sha256-fyKKY/jWzrkqp4QIChPoUHMSGyg17KBteU+XCZUNvT0=";
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
      hash = "sha256-+c+tfYUEZQvtNJO8bSyoLXuRvDcTyGxDXnXriKxb5eY=";
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
      hash = "sha256-B7KE1xPdgs7RtCxgzLFiGjx3xUshsTuGlKdZRcBF7v4=";
    };
    propagatedBuildInputs = [ SUPER ];
    buildInputs = [ TestWarnings ];
    meta = {
      description = "Override subroutines in a module for unit testing";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SUPER = buildPerlModule {
    pname = "SUPER";
    version = "1.20190531";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/SUPER-1.20190531.tar.gz";
      hash = "sha256-aF0e525/DpAGlCkjv334sRwQcTKZKRdZPc9zl9QX05o=";
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
      hash = "sha256-K3+A2of1pv4DYNnuUhBRBTAXRCw6Juhdto36yfgwdiM=";
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
      hash = "sha256-M2PhGLJgbx1qvJVvIrDQkQl3K3CGFV+1ycf5gzUGAvk=";
    };
    meta = {
      description = "Replaces actual time with simulated time";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMockTimeHiRes = buildPerlModule {
    pname = "Test-MockTime-HiRes";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TA/TARAO/Test-MockTime-HiRes-0.08.tar.gz";
      hash = "sha256-X0n3rviV0yfa/fJ0TznBdsirDkuCJ9LW495omiWb3sE=";
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
      hash = "sha256-j/51/5tpNSSIcn3Kc9uR+KoUtZ8voQTrdxfA1xpfGzM=";
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
      hash = "sha256-ufHEs2qXzf76pT7REV3Tj0tIMDd3X2VZ7h3xSs/RzgQ=";
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
      hash = "sha256-UzNwFB658Yz0rDgPbe0qtXgCpuGEAIqA/SMEv8xHT8c=";
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
      hash = "sha256-V61BoJBXyWO1gsgaB276UPpW664hd9gwd33oOGBePu8=";
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
      hash = "sha256-d/n/8MlsXgnzTQQWs1M8Mxn3zQux9/6PgHKtWfQz8OU=";
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
      hash = "sha256-+3XGo4ch8BaeEcHn2+UyntchaIWgsBEj80LdhtM1YDA=";
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
      hash = "sha256-Y4pXZYyxGa8f5bFec9R8JUTc/vhK8Maxsul/CCAraGw=";
    };
    meta = {
      description = "Make sure you didn't emit any warnings while testing";
      license = with lib.licenses; [ lgpl21Only ];
    };
  };

  TestObject = buildPerlPackage {
    pname = "Test-Object";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Object-0.08.tar.gz";
      hash = "sha256-ZSeJZBR4NzE/QQjlW1lnboo2TW7fAbPcGYruiUqx0Ls=";
    };
    meta = {
      description = "Thoroughly testing objects via registered handlers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestOutput = buildPerlPackage {
    pname = "Test-Output";
    version = "1.031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-Output-1.031.tar.gz";
      hash = "sha256-+LjzcYVxeHJyfQb2wHj6d9t5RBD68vbaTTewt2UPfqQ=";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      description = "Utilities to test STDOUT and STDERR messages";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestPAUSEPermissions = buildPerlPackage {
    pname = "Test-PAUSE-Permissions";
    version = "0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SK/SKAJI/Test-PAUSE-Permissions-0.07.tar.gz";
      hash = "sha256-VXDBu/KbxjeoRWcIuaJ0bPT8usE3SF7f82D48I5xBz4=";
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
      hash = "sha256-KPgGtUEseQi1bPFnMIS4tEzhy1TJQX14TZFCjhoECW4=";
    };
    propagatedBuildInputs = [ MCE PerlCritic ];
    meta = {
      description = "Use Perl::Critic in test programs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPerlTidy = buildPerlModule rec {
    pname = "Test-PerlTidy";
    version = "20200930";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-PerlTidy-${version}.tar.gz";
      hash = "sha256-n29omXRe17bNtREFsJSUp/ohdVBMxAgWrkYGfUp0V7Y=";
    };
    propagatedBuildInputs = [ PathTiny PerlTidy TextDiff ];
    buildInputs = [ TestPerlCritic ];
    meta = {
      description = "Check that all your files are tidy";
      homepage = "https://metacpan.org/release/Test-PerlTidy";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPod = buildPerlPackage {
    pname = "Test-Pod";
    version = "1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Pod-1.52.tar.gz";
      hash = "sha256-YKjbzGAWi/HapcwjUCNt+TQ+mHj0q5gwlwpd3m/o5fw=";
    };
    meta = {
      description = "Check for POD errors in files";
      homepage = "https://search.cpan.org/dist/Test-Pod";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodCoverage = buildPerlPackage {
    pname = "Test-Pod-Coverage";
    version = "1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Test-Pod-Coverage-1.10.tar.gz";
      hash = "sha256-SMnMqffZnu50EXZEW0Ma3wnAKeGqV8RwPJ9G92AdQNQ=";
    };
    propagatedBuildInputs = [ PodCoverage ];
    meta = {
      description = "Check for pod coverage in your distribution";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  TestPodLinkCheck = buildPerlModule {
    pname = "Test-Pod-LinkCheck";
    version = "0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-LinkCheck-0.008.tar.gz";
      hash = "sha256-K/53EXPDi2nusIlQTj92URuOReap5trD5hbkAOpnvPA=";
    };
    buildInputs = [ ModuleBuildTiny TestPod ];
    propagatedBuildInputs = [ CaptureTiny Moose podlinkcheck ];
    meta = {
      description = "Tests POD for invalid links";
      homepage = "https://search.cpan.org/dist/Test-Pod-LinkCheck";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodNo404s = buildPerlModule {
    pname = "Test-Pod-No404s";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-No404s-0.02.tar.gz";
      hash = "sha256-EcYGBW/WK9ROB5977wbEWapYnuhc3tv6DMMl6jV8jnk=";
    };
    propagatedBuildInputs = [ LWP URIFind ];
    buildInputs = [ ModuleBuildTiny TestPod ];
    meta = {
      description = "Using this test module will check your POD for any http 404 links";
      homepage = "https://search.cpan.org/dist/Test-Pod-No404s";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPortabilityFiles = buildPerlPackage {
    pname = "Test-Portability-Files";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.10.tar.gz";
      hash = "sha256-COS0MkktwbRLVdXbV5Uut2N5x/Q07o8WrKZNSR9AGhY=";
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
      hash = "sha256-BFfCCklWRz0VfE+q/4gUFUvJP24rVDwoEqGf+OM3DrI=";
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
      hash = "sha256-S4jeVJWX7s3ffDw4pNAgShb1mtgEV3tnGJasBOJOBA8=";
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
      hash = "sha256-cJFiEJcNhNdJFFEVmri2fhUlHIwNrnw99sjYhULqQqY=";
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
      hash = "sha256-u6ezKhzA1Yzi7CCyAKc0fGljFkHoyuj/RWetJO8egz4=";
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
      hash = "sha256-IRKaPOy1B7AJSOFs8V/N5dxNsjWrqEr9f0fSIBOp3tY=";
    };

    propagatedBuildInputs = [ Moo MooXTypesMooseLike SubInstall strictures ];
    buildInputs = [ CaptureTiny ];
    meta = {
      description = "Composable, reusable tests with roles and Moo";
      license = with lib.licenses; [ asl20 ];
    };
  };

  TestRoutine = buildPerlPackage {
    pname = "Test-Routine";
    version = "0.027";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Routine-0.027.tar.gz";
      hash = "sha256-utQOEupgikPogy9W5BqLSfNmN7L5wz3pQcdfsUEY01g=";
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
      hash = "sha256-+Jpx3WD44qd26OYBd8ntXlkJbUAF1QvSmJuSeeCHwkg=";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ IPCSystemSimple ListMoreUtils MooseXStrictConstructor TextSprintfNamed UNIVERSALrequire ];
    meta = {
      description = "Base class to run standard TAP scripts";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunCmdLine = buildPerlModule {
    pname = "Test-Run-CmdLine";
    version = "0.0132";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-CmdLine-0.0132.tar.gz";
      hash = "sha256-ssORzVRjV378dti/so6tKz1OOm+pLbDvNMANyfTPpwc=";
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
      hash = "sha256-UsNomxRdgh8XCj8uXPM6DCkoKE3d6W1sN88VAA8ymbs=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Define different interpreters for different test scripts with Test::Run";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginBreakOnFailure = buildPerlModule {
    pname = "Test-Run-Plugin-BreakOnFailure";
    version = "0.0.6";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-BreakOnFailure-v0.0.6.tar.gz";
      hash = "sha256-oBgO4+LwwUQSkFXaBeKTFRC59QcXTQ+6yjwMndBNE6k=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Stop processing the entire test suite";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginColorFileVerdicts = buildPerlModule {
    pname = "Test-Run-Plugin-ColorFileVerdicts";
    version = "0.0125";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-ColorFileVerdicts-0.0125.tar.gz";
      hash = "sha256-HCQaLBSm/WZLRy5Lb2iP1gyHlzsxjITgFIccBn8uHkY=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    propagatedBuildInputs = [ Moose ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      description = "Make the file verdict ('ok', 'NOT OK')";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginColorSummary = buildPerlModule {
    pname = "Test-Run-Plugin-ColorSummary";
    version = "0.0203";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-ColorSummary-0.0203.tar.gz";
      hash = "sha256-e9l5N5spa1EPxVuxwAuKEM00hQ5OIZf1cBtUYAY/iv0=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap ];
    moreInputs = [ TestTrap ]; # Added because tests were failing without it
    doCheck=true;
    meta = {
      description = "A Test::Run plugin that";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunPluginTrimDisplayedFilenames = buildPerlModule {
    pname = "Test-Run-Plugin-TrimDisplayedFilenames";
    version = "0.0126";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-Run-Plugin-TrimDisplayedFilenames-0.0126.tar.gz";
      hash = "sha256-ioZJw8anmIp3N65KcW1g4MazIXMBtAFT6tNquPTqkCg=";
    };
    buildInputs = [ TestRun TestRunCmdLine TestTrap YAMLLibYAML ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Trim the first components";
      homepage = "https://web-cpan.shlomifish.org/modules/Test-Run";
      license = with lib.licenses; [ mit ];
    };
  };

  TestRunValgrind = buildPerlModule {
    pname = "Test-RunValgrind";
    version = "0.2.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-RunValgrind-0.2.2.tar.gz";
      hash = "sha256-aRPRTK3CUbI8W3I1+NSsPeKHE41xK3W9lLACrwuPpe4=";
    };
    buildInputs = [ TestTrap ];
    propagatedBuildInputs = [ PathTiny ];
    meta = {
      description = "Tests that an external program is valgrind-clean";
      homepage = "https://metacpan.org/release/Test-RunValgrind";
      license = with lib.licenses; [ mit ];
    };
  };

  TestScript = buildPerlPackage {
    pname = "Test-Script";
    version = "1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PL/PLICEASE/Test-Script-1.26.tar.gz";
      hash = "sha256-bUIjeuzi8NxB+mZTN5V0Z0BhhI8CCs1NY962uBtac7c=";
    };

    buildInputs = [ Test2Suite ];

    propagatedBuildInputs = [ CaptureTiny ProbePerl ];
    meta = {
      description = "Basic cross-platform tests for scripts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestScriptRun = buildPerlPackage {
    pname = "Test-Script-Run";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SU/SUNNAVY/Test-Script-Run-0.08.tar.gz";
      hash = "sha256-H+8hbnC8QlrOPixDcN/N3bXnmLCZ77omeSRKTVvBqwo=";
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
      hash = "sha256-KTLoZWEOgHWPdkxYZ1fvjhHbEoTZWOJeS3qFCYQUxZ8=";
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
    version = "1.302195";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-Simple-1.302195.tar.gz";
      hash = "sha256-s5C7I1kuC5Rsla27PDCxG8Y0ooayhHvmEa2SnFfjmmw=";
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
      hash = "sha256-9N16mlW6oiR1QK40IQzQWgT50QYb7+yXockO2pW/rkU=";
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
      hash = "sha256-CjHPEmXc7pC7xCRWrWC7Njr8f6xml//7D9SbupKhZdI=";
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
      hash = "sha256-y8Hps1oF5x/rwT5e9UejHIJJiZu2AR29ydn/Nm3atsI=";
    };
    propagatedBuildInputs = [ HookLexWrap ];
    meta = {
      description = "Track the number of times subs are called";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSynopsis = buildPerlPackage {
    pname = "Test-Synopsis";
    version = "0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZO/ZOFFIX/Test-Synopsis-0.16.tar.gz";
      hash = "sha256-GxPsc7z3JGLAYPiBlJFETXRz8+qK60wO2CgmPu0OCSU=";
    };
    meta = {
      description = "Test your SYNOPSIS code";
      homepage = "https://metacpan.org/release/Test-Synopsis";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTableDriven = buildPerlPackage {
    pname = "Test-TableDriven";
    version = "0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/Test-TableDriven-0.02.tar.gz";
      hash = "sha256-Qlh4r88qFOBHyviRsZFen1/7A2lBYJxDjg370bWxhZo=";
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
      hash = "sha256-17eh/X/M4BaNRPuIdpGP6KmvSa4OuLCWJbZ7GNcfXoE=";
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
      hash = "sha256-PlPDwG1tCYCiv+uRVgK3FOaC7iEa6IwRdIzyzHFOe1c=";
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
      hash = "sha256-NzC0zBA0Es+/b+JHvbwwC+l94wnMmxxcvVc3E7hojz8=";
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
      hash = "sha256-uLw7B0uyJH6FiDmcHlXQcfBJz2zhyLQZLDjPPCRVlUg=";
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
      hash = "sha256-QCC1x/OhWsmxh9Bd/ZgWuAMOwNSkf/g3P3Yzu2FOvcM=";
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
      hash = "sha256-8J0mOt7AZwCkOiTin1SEz20pOZFMYH3sUVkPS7j6WhE=";
    };
    propagatedBuildInputs = [ FileFindObjectRule ];
    meta = {
      description = "Test for trailing space in source files";
      homepage = "https://metacpan.org/release/Test-TrailingSpace";
      license = with lib.licenses; [ mit ];
    };
  };

  TestUnitLite = buildPerlModule {
    pname = "Test-Unit-Lite";
    version = "0.1202";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz";
      hash = "sha256-NR0l7nExYoqvfjmV/h//uJOuf+bvWM8zcO0yCVP1sqg=";
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
      hash = "sha256-7LyjRtN5zvjTwOSsDI6zsmE9c3/6rq5SJxw41788bNo=";
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
      hash = "sha256-iaSUfd8VZK4BEiJ1WEQz1/bENwNwvPN2iSLXlpVq4k8=";
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
      hash = "sha256-JjGocSExAmLg6WEHpvoO1pSHt3AVIHc77l+prMwpX1s=";
    };
    propagatedBuildInputs = [ ScalarListUtils ];
    meta = {
      description = "Test that freed memory objects were, indeed, freed";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWithoutModule = buildPerlPackage {
    pname = "Test-Without-Module";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/Test-Without-Module-0.21.tar.gz";
      hash = "sha256-PN6vraxIU+vq/miTRtVV2l36PPqdTITj5ee/7lC+7EY=";
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
      hash = "sha256-3KiLWxdBFL9apseC/58OzFDBRCuDJMEdORd1LqNDmvw=";
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
      hash = "sha256-GDveGuerpw3LPtd3xVSCN/QsPtVR/VvGWM7obQIWrLE=";
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
      hash = "sha256-pXagsi470a/JJ0/FY7A3ru53cThJyev2pq1EFcFsnC8=";
    };
    propagatedBuildInputs = [ WWWMechanizeCGI ];
    buildInputs = [ TestLongString TestWWWMechanize ];
    meta = {
      description = "Test CGI applications with Test::WWW::Mechanize";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    pname = "Test-WWW-Mechanize-PSGI";
    version = "0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/Test-WWW-Mechanize-PSGI-0.39.tar.gz";
      hash = "sha256-R2s6s7R9U05Nag9JkAIdXTTGnsk3rAcW5mzop7yHmVg=";
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
      hash = "sha256-3vzMDBRY569dkrxzAD5oZ8Z+L6SVWqccVLOE5xEiwPM=";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      description = "Test XML and HTML content and structure with XPath expressions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestYAML = buildPerlPackage {
    pname = "Test-YAML";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/Test-YAML-1.07.tar.gz";
      hash = "sha256-HzANA09GKYy5KWCRLMBLrDP7J/BbiFLY8FHhELnNmV8=";
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
      hash = "sha256-XIV9vOWG9X+j18Tr0yACOrOyljsgSUKK4BvTvE8hVyU=";
    };
    meta = {
      description = "Module to align text";
      homepage = "https://metacpan.org/release/Text-Aligner";
      license = with lib.licenses; [ isc ];
    };
  };

  TextAspell = buildPerlPackage {
    pname = "Text-Aspell";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANK/Text-Aspell-0.09.tar.gz";
      hash = "sha256-K+oyCfGOJzsZPjF1pC0mk5GRnkmrEGtuJSOV0nIYL2U=";
    };
    propagatedBuildInputs = [ pkgs.aspell ];
    ASPELL_CONF = "dict-dir ${pkgs.aspellDicts.en}/lib/aspell";
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.aspell}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.aspell}/lib -laspell";
    meta = {
      description = "Perl interface to the GNU Aspell library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextAutoformat = buildPerlPackage {
    pname = "Text-Autoformat";
    version = "1.75";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.75.tar.gz";
      hash = "sha256-ndT0zj2uxLTb9bWdrEVoqJRq7RLCi05ZiMjoxgLGt3E=";
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
      hash = "sha256-9JxAi4XIC6dieFQoqHWZvtItwP1rt2XJ+m3fqjLk5+I=";
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
      hash = "sha256-sBRYbmi9vK+wos+gQB6woE6l3oxNW8Nt0Pf66ras9Cw=";
    };
    # libbtparse.so: cannot open shared object file
    patches = [ ../development/perl-modules/TextBibTeX-use-lib.patch ];
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
      hash = "sha256-qhuFhBz5/G/jODZrvIcKTpMEonZB5j+Sof2Wvujr9kw=";
    };
    meta = {
      description = "An implementation of the Brew edit distance";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextCharWidth = buildPerlPackage {
    pname = "Text-CharWidth";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KU/KUBOTA/Text-CharWidth-0.04.tar.gz";
      hash = "sha256-q97V9P3ZM46J/S8dgnHESYna5b9Qrs5BthedjiMHBPg=";
    };
    meta = {
      description = "Get number of occupied columns of a string on terminal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextCSV = buildPerlPackage {
    pname = "Text-CSV";
    version = "2.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Text-CSV-2.00.tar.gz";
      hash = "sha256-jMvZGVgFIi2ZWEQRTQ5ZW7JM4Yj4UoTb8lYIAxHLssI=";
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
      hash = "sha256-JIpZg6IN1XeGY56I2v3WVPO5OSVJASDW1xLaayvludA=";
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
      hash = "sha256-xIEt3KjiZUc2xEvCzmCyekKKG8TVNksO0frTYJyPm8Q=";
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
      hash = "sha256-6Lqgexs/U+AK82NomLv3OuyaD/OPlFNu3h2+lu8IbwQ=";
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
      hash = "sha256-fUKQVzGeEjxZC6B2UzTwreSl656o23wOxNOQLeX5BAQ=";
    };
    meta = {
      description = "Various subroutines to format text";
      homepage = "https://github.com/shlomif/perl-Module-Format";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ bcdarwin ];
    };
  };

  TextDiffFormattedHTML = buildPerlPackage {
    pname = "Text-Diff-FormattedHTML";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/Text-Diff-FormattedHTML-0.08.tar.gz";
      hash = "sha256-Oat3WlwFZ0Xyq9jMfBy8VJbf735SqfS9itpqpsnHtw0=";
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
      hash = "sha256-PfXP0soaTFyn/3urPMjVOtIGThNMvxEATzz4xLkFW/8=";
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
      hash = "sha256-ki1PGQEtl3OxH0pvZCEF6fkT9YZvRGG2BZymdNW7B90=";
    };
    meta = {
      description = "German grundform reduction";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextGlob = buildPerlPackage {
    pname = "Text-Glob";
    version = "0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz";
      hash = "sha256-BpzNSdPwot7bEV9L3J+6wHqDWShAlT0fzfw5650wUoc=";
    };
    meta = {
      description = "Match globbing patterns against text";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextHogan = buildPerlPackage {
    pname = "Text-Hogan";
    version = "2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAORU/Text-Hogan-2.03.tar.gz";
      hash = "sha256-WNkj7eTFmEiI75u7JW2IVMxdIqRwikd0sxPLU4jFYXo=";
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
      hash = "sha256-W4C31ecJ00OTvLqIlxhkoXtEpb8PnkvO44PQKefS1cM=";
    };
    meta = {
      description = "Perl interface to iconv() codeset conversion function";
      license = with lib.licenses; [ artistic1 gpl1Plus ]; # taken from el6
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.TextIconv.x86_64-darwin
    };
  };

  TestInDistDir = buildPerlPackage {
    pname = "Test-InDistDir";
    version = "1.112071";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHALDU/Test-InDistDir-1.112071.tar.gz";
      hash = "sha256-kixcYzFPQG9MuzXsQjrCFU0sK3GmWt23cyydJAqD/vs=";
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
      hash = "sha256-Hp8SnMGgAfuVRJ04UlOzivq/W0ZuOzvTPk5DDyFuF3o=";
    };
    buildInputs = [ FileFindRule TestPod TestPodCoverage ];
    meta = {
      description = "Framework for more readable interactive test scripts";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextLayout = buildPerlPackage {
    pname = "Text-Layout";
    version = "0.031";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/Text-Layout-0.031.tar.gz";
      hash = "sha256-EQ4ObbzKIFhKcckNpxBYAdRrXXYd+QmsTfYQbDM3B34=";
    };
    buildInputs = [ IOString PDFAPI2 ];
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
      hash = "sha256-43T/eyN5Gc5eqSRfNW0ctSzIf9JrOlo4s/Pl/4KgFJE=";
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
      hash = "sha256-ZLtjb7ISExAaZGtBTsvcG1Xt+QXLzcf10kd07FBh/i0=";
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
      hash = "sha256-pHqq1xxYDhbm5j2MA3zd3NkZh2dUvrLJXZqIaC3TMtk=";
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
      hash = "sha256-wZHG1ezrjLdcBWUZI2BmLSAtcWutB6IzxLMppChNxxs=";
    };
    nativeBuildInputs = [ shortenPerlShebang ];
    nativeCheckInputs = [ ListMoreUtils TestDifferences TestException ];
    postInstall = ''
      shortenPerlShebang $out/bin/Markdown.pl
    '';
    meta = {
      description = "Convert Markdown syntax to (X)HTML";
      license = with lib.licenses; [ bsd3 ];
      mainProgram = "Markdown.pl";
    };
  };

  TextMarkdownHoedown = buildPerlModule {
    pname = "Text-Markdown-Hoedown";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/Text-Markdown-Hoedown-1.03.tar.gz";
      hash = "sha256-U6cw/29IgrmavYVW8mqRH1gvZ1tZ8OFnJe0ey8CE7lA=";
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
      hash = "sha256-P7pOj890gGJZqmOb59kOcDRq0ODkuLYZWTSQ43gkGXA=";
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
      hash = "sha256-MoAecfNe6Kqg1XbOwSXO5Gs9SRWuZCvGSWISDU+XtMg=";
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
      hash = "sha256-JGfdE3UdwpedfIgLJOdilSEw/fQqHtPuBP33LUtSZGo=";
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
      hash = "sha256-U1QwkZ5v32zlX/dumJKvzLo7fUFg20XzrEOw+S/80Ek=";
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
      hash = "sha256-wYalAlbgvt+vsX584VfnxS8ZUDu3nhjr8GJVkR9urRo=";
    };
    meta = {
      description = "Generate pronounceable passwords";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextPatch = buildPerlPackage {
    pname = "Text-Patch";
    version = "1.8";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CADE/Text-Patch-1.8.tar.gz";
      hash = "sha256-6vGOYbpqPhQ4RqfMZvCM5YoMT72pKssxrt4lyztcPcw=";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      description = "Patches text with given patch";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  TextPDF = buildPerlPackage {
    pname = "Text-PDF";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BH/BHALLISSY/Text-PDF-0.31.tar.gz";
      hash = "sha256-359RXuFZgEsNWnXVrbk8RYTH7EAdjFnCfp9zkl2NrGg=";
    };
    meta = {
      description = "Module for manipulating PDF files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextQuoted = buildPerlPackage {
    pname = "Text-Quoted";
    version = "2.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BP/BPS/Text-Quoted-2.10.tar.gz";
      hash = "sha256-CBv5XskiCvJs7IkWHmG/c/n7y/7uHZrxUTnl17cI9EU=";
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
      hash = "sha256-2juBQUxj+NkhjRFnRaiLlIxGyYsYdjT2KYkuVAAbw1o=";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ ClassAccessor IOStringy ListMoreUtils Readonly TextAutoformat ];
    buildInputs = [ TestException ];
    meta = {
      description = "Read record-oriented files";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  TextReflow = buildPerlPackage {
    pname = "Text-Reflow";
    version = "1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MW/MWARD/Text-Reflow-1.17.tar.gz";
      hash = "sha256-S/ITn/YX1uWcwOWc3s18tyPs/SjVrDh6+1U//cBxuGA=";
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
      hash = "sha256-qHkt2MGqyXABAyM3s2o1a+luLXTE8DnvmjY7ZB20rmE=";
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
      hash = "sha256-y0oIo7FRgC/7L84yWKQWVCq4HbD3Oe5HSpWD/7c+BGo=";
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
      hash = "sha256-JW0/OHZOljMxWLFKsYJXuS8xVcYNZYyvuAOJ9y9GGe0=";
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
      hash = "sha256-9t1VtCgLJd6peCIYOYZDglYAdOHWkzOV+u4lEMLbYO0=";
    };
    meta = {
      description = "Implementation of the soundex algorithm";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextSprintfNamed = buildPerlModule {
    pname = "Text-Sprintf-Named";
    version = "0.0405";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Sprintf-Named-0.0405.tar.gz";
      hash = "sha256-m0cNeP/PxAqz+ZgjGzNrnTQXIw+3zlW0fNewVXOnD/w=";
    };
    buildInputs = [ TestWarn ];
    meta = {
      description = "Sprintf-like function with named conversions";
      homepage = "https://metacpan.org/release/Text-Sprintf-Named";
      license = with lib.licenses; [ mit ];
    };
  };

  TextTable = buildPerlModule {
    pname = "Text-Table";
    version = "1.134";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Table-1.134.tar.gz";
      hash = "sha256-us9Cmxi3wLIsCIIZBVBj45AnSVMdSI69exfqt3V80Qs=";
    };
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      description = "Organize Data in Tables";
      homepage = "https://metacpan.org/release/Text-Table";
      license = with lib.licenses; [ isc ];
    };
  };

  TextTabularDisplay = buildPerlPackage {
    pname = "Text-TabularDisplay";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/Text-TabularDisplay-1.38.tar.gz";
      hash = "sha256-6wmQ+vpWtmfyPbdkvdpaTcX0sd3EsTg6pe7W8i7Rhug=";
    };
    meta = {
      description = "Display text in formatted table output";
      license = with lib.licenses; [ gpl2Plus ];
    };
  };

  TextTemplate = buildPerlPackage {
    pname = "Text-Template";
    version = "1.59";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Text-Template-1.59.tar.gz";
      hash = "sha256-HdLHiMBTA+2alw4YgRCWQhUfqT4Cx6gNTHBggna6se4=";
    };
    buildInputs = [ TestMoreUTF8 TestWarnings ];
    meta = {
      description = "Expand template text with embedded Perl";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTrap = buildPerlModule {
    pname = "Test-Trap";
    version = "0.3.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.3.5.tar.gz";
      hash = "sha256-VPmQFlYrWx1yEQEA8fK+Q3F4zfhDdvSV/9A3bx1+y5o=";
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
      hash = "sha256-p/ehLpdx/SH8HsPePjdSJ6dL/uOye70480WkrCfAKGM=";
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
      hash = "sha256-nOHdKJel8w4bf4lm7Gb1fY2PKA9gXyjHyiIfp5rKOOA=";
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
      hash = "sha256-oPz8HUbd3sQcCYggdF6DxosG/YKfc5T6NSuw1LdTSU8=";
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
      hash = "sha256-J45u/Jsk82mclh77NuvmAqNAi1QVcgF97hMdFScocys=";
    };
    # https://rt.cpan.org/Public/Bug/Display.html?id=124815
    env.NIX_CFLAGS_COMPILE = "-DHAS_VPRINTF";
    meta = {
      description = "Remove accents from a string";
      license = with lib.licenses; [ gpl2Only ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.TextUnaccent.x86_64-darwin
    };
  };

  TextUnidecode = buildPerlPackage {
    pname = "Text-Unidecode";
    version = "1.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz";
      hash = "sha256-bCTxTdwdIOJhYcIHtzyhhO7S71fwi1+y7hlubi6IscY=";
    };
    meta = {
      description = "Plain ASCII transliterations of Unicode tex";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Testutf8 = buildPerlPackage {
    pname = "Test-utf8";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.02.tar.gz";
      hash = "sha256-34LwnFlAgwslpJ8cgWL6JNNx5gKIDt742aTUv9Zri9c=";
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
      hash = "sha256-oBIBvrKWNrPkHs2ips9lIv0mVBa9bZlPrQL1n7Sc9ZU=";
    };
    meta = {
      description = "Extract collocations and Ngrams from text";
      license = with lib.licenses; [ gpl2Plus ];
      maintainers = [ maintainers.bzizou ];
    };
  };

  TextvFileasData = buildPerlPackage {
    pname = "Text-vFile-asData";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/Text-vFile-asData-0.08.tar.gz";
      hash = "sha256-spGrXg+YfFFyVgppIjRxGnXkWW2DR19y0BJ4NpUy+Co=";
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
      hash = "sha256-5DzZla2RV6foOdmT7ntsTRhUlH5VfQltnVqvdFB/qzM=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Module for translating Wiki formatted text into other formats";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWordDiff = buildPerlPackage {
    pname = "Text-WordDiff";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMK/Text-WordDiff-0.09.tar.gz";
      hash = "sha256-/uaZynY63KL04Y9KioNv0hArwoIK9wj460M1bVrg1Q4=";
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
      hash = "sha256-S9KaF/DCx5LRLBAFs8J28qsPrjnACFmuF0HXlBhGpIg=";
    };
    buildInputs = lib.optionals (!stdenv.isDarwin) [ pkgs.glibcLocales ];
    propagatedBuildInputs = [ TextCharWidth ];
    preConfigure = ''
      substituteInPlace WrapI18N.pm --replace '/usr/bin/locale' '${pkgs.unixtools.locale}/bin/locale'
    '';
    meta = {
      description = "Line wrapping module with support for multibyte, fullwidth, and combining characters and languages without whitespaces between words";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextWrapper = buildPerlPackage {
    pname = "Text-Wrapper";
    version = "1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CJ/CJM/Text-Wrapper-1.05.tar.gz";
      hash = "sha256-ZCaOFZg6nfR+HZGZpJHzlOifVC5Ur7M/S3jz8xjgmrk=";
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
      hash = "sha256-mYfQ3rW93TUqYzDO++ky+ILjbdjIpFZLz9Ny3Dlrj6A=";
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
      hash = "sha256-G/dARQ06bXwStIwl99pZZOROfMOLKFcs+3b/IkZPRGk=";
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
      hash = "sha256-sxbYSazSXyQ0bVWplQ0oH+4HRjmHZ8YBI0EiFZVz65o=";
    };
    propagatedBuildInputs = [ TieCacheLRU ];
    meta = {
      description = "Extends Tie::Cache::LRU with expiring";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  TieCycle = buildPerlPackage {
    pname = "Tie-Cycle";
    version = "1.225";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Tie-Cycle-1.225.tar.gz";
      hash = "sha256-8zDYIWlK+bJptgg1cNXBDqIubrOyGEEEjOKCUrHAPUU=";
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
      hash = "sha256-qpoIOiMeQEYXCliUZE48WWecfb0KotEhfchRUN8sHiE=";
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
      hash = "sha256-ipgLV3/0sQ/hEGLtjHdIV/qMmDPFMF8ui/szR69j8Tk=";
    };
    meta = {
      description = "Access the lines of a disk file via a Perl array";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieIxHash = buildPerlModule {
    pname = "Tie-IxHash";
    version = "1.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz";
      hash = "sha256-+rsLjJfmfJs0tswY7Wb2xeAcVbJX3PAHVV4LAn1Mr1Y=";
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
      hash = "sha256-7p85BV3GlaokSiUvVv/Tf4vgcgmzN604eCRyEgbSqJ4=";
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
      hash = "sha256-N7xigV9ahIrHeRK5v0eIqfJyiE6DpS4gk9q0qDpKexA=";
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
      hash = "sha256-1RP7tRQT98oeZKG9zmGU337GB23qVQZtZ7lQGR7sMqk=";
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
      hash = "sha256-Ws8fUY0vtfYgyq16Gy/x9vdRb++PQLprdD7si5aSftc=";
    };
    meta = {
      description = "Use references as hash keys";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieRegexpHash = buildPerlPackage {
    pname = "Tie-RegexpHash";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AL/ALTREUS/Tie-RegexpHash-0.17.tar.gz";
      hash = "sha256-DCB4UOd++xZhjgqgFVB5JqNCWzSq1apuPkDYOYmghaM=";
    };
    meta = {
      description = "Use regular expressions as hash keys";
      license = with lib.licenses; [ artistic1 ];
    };
  };

  TieSimple = buildPerlPackage {
    pname = "Tie-Simple";
    version = "1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HANENKAMP/Tie-Simple-1.04.tar.gz";
      hash = "sha256-KeniEzlRBGx48gXxs+jfYskOEU8OCPoGuBd2ag+AixI=";
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
      hash = "sha256-73GgSCbRNisrduyyHOFzw304pHqf7Cg6qYJDWJD08bE=";
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
      hash = "sha256-oxoNRDD+FPWWIvMdt/JbInXa0uxS8QQL6wMNPoOtOvQ=";
    };
    meta = {
      description = "Tie to an existing object";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDate = buildPerlPackage {
    pname = "TimeDate";
    version = "2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz";
      hash = "sha256-wLacSwOd5vUBsNnxPsWMhrBAwffpsn7ySWUcFD1gXrI=";
    };
    meta = {
      description = "Miscellaneous timezone manipulations routines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDuration = buildPerlPackage {
    pname = "Time-Duration";
    version = "1.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/Time-Duration-1.21.tar.gz";
      hash = "sha256-/jQOuodl+SY2lGdOXf8UgzRD4Zhl5f9Ce715t7X4qbg=";
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
      hash = "sha256-YdgUOo5pgcwfepdIBNSSA55eVnFnZ4KdXkvNntdK44E=";
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
      hash = "sha256-x3RPaymGuUbT4s8DTfNxvuFs26/lPpRauxpULE+JIMs=";
    };
    meta = {
      description = "Efficiently compute time from local and GMT time";
      homepage = "https://metacpan.org/release/Time-Local";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeMoment = buildPerlPackage {
    pname = "Time-Moment";
    version = "0.44";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHANSEN/Time-Moment-0.44.tar.gz";
      hash = "sha256-ZKz6BC9jT8742t9V5/QrpOqriq631SEuuJgVox949v0=";
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
      hash = "sha256-k5baaY/UUtnOYNZCzaIQjxHyDtdsiWF3muEbiXroFdI=";
    };
    meta = {
      description = "Easily timeout long running operations";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeParseDate = buildPerlPackage {
    pname = "Time-ParseDate";
    version = "2015.103";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MU/MUIR/modules/Time-ParseDate-2015.103.tar.gz";
      hash = "sha256-LBoGI1v4EYE8qsnqqdqnGvdYZnzfewgstZhjIg/K7tE=";
    };
    doCheck = false;
    meta = {
      description = "Parse and format time values";
      license = with lib.licenses; [ publicDomain ];
    };
  };

  TimePeriod = buildPerlPackage {
    pname = "Time-Period";
    version = "1.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PB/PBOYD/Time-Period-1.25.tar.gz";
      hash = "sha256-0H+lgFKb6sapyCdMa/IgtMOq3mhd9lwWadUzOb9u8eg=";
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
      hash = "sha256-S1W3uw6rRc8jmlTf6tJ336BhIaQ+Y7P84IU67P2wTCc=";
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
    version = "0.7.0";

    src = fetchFromGitHub {
      owner = "openstreetmap";
      repo = "tirex";
      rev = "v${version}";
      hash = "sha256-0QbPfCPBdNBbUiZ8Ppg2zao98+Ddl3l+yX6y1/J50rg=";
    };

    patches = [
      # https://github.com/openstreetmap/tirex/pull/54
      (fetchpatch {
        url = "https://github.com/openstreetmap/tirex/commit/da0c5db926bc0939c53dd902a969b689ccf9edde.patch";
        hash = "sha256-bnL1ZGy8ZNSZuCRbZn59qRVLg3TL0GjFYnhRKroeVO0=";
      })
    ];

    buildInputs = [
      GD
      IPCShareLite
      JSON
      LWP
      pkgs.mapnik
    ] ++ pkgs.mapnik.buildInputs;

    installPhase = ''
      install -m 755 -d $out/usr/libexec
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
    version = "804.036";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SREZIC/Tk-804.036.tar.gz";
      hash = "sha256-Mqpycaa9/twzMBGbOCXa3dCqS1yTb4StdOq7kyogCl4=";
    };
    patches = [
      # Fix failing configure test due to implicit int return value of main, which results
      # in an error with clang 16.
      ../development/perl-modules/tk-configure-implicit-int-fix.patch
    ];
    makeMakerFlags = [ "X11INC=${pkgs.xorg.libX11.dev}/include" "X11LIB=${pkgs.xorg.libX11.out}/lib" ];
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
      hash = "sha256-Rj4oTsRxN+fEJclpGwKo3sXOJytY6h9jWa6AQaI53Q8=";
    };
    makeMakerFlags = [ "X11INC=${pkgs.xorg.libX11.dev}/include" "X11LIB=${pkgs.xorg.libX11.out}/lib" ];
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
      hash = "sha256-HIuml3JWizdYBUJHCXUSxVDv4xUXwyn7Ze73r8zJ0wQ=";
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
      hash = "sha256-2zrXFCjsbDI9DL8JAWkQ5bft2bbTs1RDoorYw8zilqo=";
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
      hash = "sha256-Nn6C7OfOPioWbDjc+mYI59xxV4HpTgtTmQcMOr/awhs=";
    };
    propagatedBuildInputs = [ TreeSimple ];
    buildInputs = [ TestException ];
    meta = {
      description = "A factory object for dispensing Visitor objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TryTiny = buildPerlPackage {
    pname = "Try-Tiny";
    version = "0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz";
      hash = "sha256-2lvQ1ckDUZu/ELuboMt7ysBWOIK8/kUDruP7FD7d72s=";
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
      hash = "sha256-A45O9SkpXyacKA/vmZpeTbkVaULwkaw8rXabHkVw8UY=";
    };
    propagatedBuildInputs = [ DispatchClass TryTiny ];
    meta = {
      description = "Selectively catch exceptions by class name";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Twiggy = buildPerlPackage {
    pname = "Twiggy";
    version = "0.1025";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Twiggy-0.1025.tar.gz";
      hash = "sha256-11rfljqoFclx8PFxxpTtAI2mAWszfA0/zYdZz5edp6g=";
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
      hash = "sha256-09sSIBYcKuprC4oiJcT+9Sbo275WtL/+naq8A+Lv6pA=";
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
      hash = "sha256-vMNKMffcHTDMgDiJtcj5Dkdztztb7L2zhg9avn4i/wA=";
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
      hash = "sha256-+McXOwkU0OPZVyggd7Nm8MjHAlZxXq7zKY/zK5I4ioA=";
    };
    propagatedBuildInputs = [ commonsense ];
    meta = {
      description = "Simple data types for common serialisation formats";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALcan = buildPerlPackage {
    pname = "UNIVERSAL-can";
    version = "1.20140328";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz";
      hash = "sha256-Ui2p8nR4b+LLqZvHfMHIHSFhlHkD1/rRC9Yt+38RmQ8=";
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
      hash = "sha256-0WlWA2ywHIGd7H0pT274kb4Ltkh2mJYBNUspMWTafys=";
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
      hash = "sha256-sqc2qHlnoUPatYyKEQUB1SNbzdLIsqO//808C9BrOO0=";
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
      hash = "sha256-QYohKAj50Li7MwrJBQltLdNkl2dT1McVNNq5g2pjGU0=";
    };
    perlPreHook = lib.optionalString stdenv.isi686 "export LD=$CC"; # fix undefined reference to `__stack_chk_fail_local'
    meta = {
      description = "Unicode case-folding for case-insensitive lookups";
      homepage = "https://metacpan.org/release/Unicode-CaseFold";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCheckUTF8 = buildPerlPackage {
    pname = "Unicode-CheckUTF8";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRADFITZ/Unicode-CheckUTF8-1.03.tar.gz";
      hash = "sha256-l/hNrwM+ubSc2P4x2yIf7wNaXC7h11fzEiyIz5diQUw=";
    };
    meta = {
      description = "Checks if scalar is valid UTF-8";
      license = with lib.licenses; [ ucd /* and */ artistic1 gpl1Plus ];
    };
  };

  UnicodeLineBreak = buildPerlPackage {
    pname = "Unicode-LineBreak";
    version = "2019.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz";
      hash = "sha256-SGdi5MrN3Md7E5ifl5oCn4RjC4F15/7xeYnhV9S2MYo=";
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
      hash = "sha256-iUoRDs5HlUaviv7Aly7scyDIbE3qTms1Tf88dSa6m2g=";
    };
    meta = {
      description = "String of Unicode characters (UTF-16BE)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeStringprep = buildPerlModule {
    pname = "Unicode-Stringprep";
    version = "1.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFAERBER/Unicode-Stringprep-1.105.tar.gz";
      hash = "sha256-5r67xYQIIx/RMX25ECRJs+faT6Q3559jc4LTYxPv0BE=";
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
      hash = "sha256-+oci0LdGluMy/d1EKZRDbqk9O/x5gtS6vc7f3dZX0PY=";
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
      hash = "sha256-ds3hzuJFMmC4WrvdwnzcmHXwHSRX4XbgPcq/BftETRI=";
    };
    meta = {
      description = "Perl interface to the Unix getrusage system call";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URI = buildPerlPackage {
    pname = "URI";
    version = "5.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OA/OALDERS/URI-5.05.tar.gz";
      hash = "sha256-pcET0tAnBtn73KaobykMWwWy+Gg21Of+FEfwYyYbeew=";
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
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/URI-db-0.20.tar.gz";
      hash = "sha256-FMjaFawgljG445/BJFHJsTEa0LXKX5Aye9+peLfRPxQ=";
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
      hash = "sha256-4hOkJaUbX1UyQhHzeQnXh0nQus3qJZulGphV0NGWY9Y=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Find URIs in arbitrary text";
      homepage = "https://metacpan.org/release/URI-Find";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      mainProgram = "urifind";
    };
  };

  URIFromHash = buildPerlPackage {
    pname = "URI-FromHash";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.05.tar.gz";
      hash = "sha256-p8rFvM7p8uLYrQ9gVAAWNxLNCsZN8vuDT3YPtJ8vb9A=";
    };
    propagatedBuildInputs = [ ParamsValidate URI ];
    buildInputs = [ TestFatal ];
    meta = {
      description = "Build a URI from a set of named parameters";
      homepage = "https://metacpan.org/release/URI-FromHash";
      license = with lib.licenses; [ artistic2 ];
    };
  };

  UriGoogleChart = buildPerlPackage {
    pname = "URI-GoogleChart";
    version = "1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/URI-GoogleChart-1.02.tar.gz";
      hash = "sha256-WoLCLsYBejXQ/IJv7xNBIiaHL8SiPA4sAUqfqS8rGAI=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Generate Google Chart URIs";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UserIdentity = buildPerlPackage {
    pname = "User-Identity";
    version = "1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/User-Identity-1.00.tar.gz";
      hash = "sha256-khm0Jxz+tyYzDpVkWJ6jp9tLbdb29EI3RgSN8aCOn0o=";
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
      hash = "sha256-uxSZiW7ONKe08JFinC5yw2imcwDoVzqyIZjJ2HI1uy0=";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Support IMAP URI";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URINested = buildPerlModule {
    pname = "URI-Nested";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DW/DWHEELER/URI-Nested-0.10.tar.gz";
      hash = "sha256-4ZcTOaZfusY6uHFC1LWdPSWdUUF3U8d8tY6jGoIz768=";
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
      hash = "sha256-6xdLeUYi4UK30JT2p+Nqe6T8i7zySF4QPuPaNevMTyw=";
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
      hash = "sha256-aK4tYbV+FNytD4Kvr/3F7AW1B6HpyN9aphOKqipbEd4=";
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
      hash = "sha256-EloTlGYuCkXiaWl3SWwdAnsUOH/245tgwH4PlurhUtM=";
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
      hash = "sha256-bmsOQXKstqU8IiY5wABgjC3WHVCEhkdIKshgDVDlQe8=";
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
      hash = "sha256-51NbMeOG1DLex63eIUNIOJ4dXPdT5+0H8a4ExDYIQM8=";
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
      hash = "sha256-bc2SYE1k6WzGwYgZSuFqnTpGVWIk93tvPR0TEraPmj0=";
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
      hash = "sha256-PxNjGxO5YE+0ieKYlJDJnxA3Q6g3I5va+unWuvVfj0Y=";
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
    version = "0.63";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/Variable-Magic-0.63.tar.gz";
      hash = "sha256-ukCDssMf8mlPI3EzPVVMgmqvJLTZjQPki1tKQ6Kg5nk=";
    };
    meta = {
      description = "Associate user-defined magic to variables from Perl";
      homepage = "https://search.cpan.org/dist/Variable-Magic";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Version = buildPerlPackage {
    pname = "version";
    version = "0.9928";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/version-0.9928.tar.gz";
      hash = "sha256-JA4Ujct24WVH7/hcflx/fuBBZLgbiiOhppzDfABdqo4=";
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
      hash = "sha256-cEYIQDTAkYMTQ/S7UJMQ4pEaMl0NUG8vUlj1uZbaQ/U=";
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
      hash = "sha256-srazF0XFdDH8oO+5udC48WjWCBdV4Ej9nWxEab0Qis0=";
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
      hash = "sha256-/H6cFS/ytyHMsiGsQAiZNHdc9YNmrttcwWk2CfhAk3s=";
    };
    propagatedBuildInputs = [ DateTimeFormatISO8601 VMEC2 ];
    meta = {
      description = "Cache credentials respecting expiration time for IAM roles";
      homepage = "https://search.cpan.org/dist/VM-EC2-Security-CredentialCache";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  W3CLinkChecker = buildPerlPackage {
    pname = "W3C-LinkChecker";
    version = "4.81";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/W3C-LinkChecker-4.81.tar.gz";
      hash = "sha256-Yjn2GyDZHc57IeTU9iark6jx4vIH2lAVWQ1QjPbGamU=";
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
      hash = "sha256-Uv+rEQ4yNI13XyQclz61b5awju28EQ130lfNsKJKt7o=";
    };
    patches = [
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/curl-7.71.0.patch?h=perl-www-curl&id=261d84887d736cc097abef61164339216fb79180";
        hash = "sha256-2lHV8qKZPdM/WnuvNYphCGRAq7UOTdPKH0k56iYtPMI=";
        name = "WWWCurl-curl-7.71.0.patch";
      })
    ];
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-return-type";
    buildInputs = [ pkgs.curl ];
    doCheck = false; # performs network access
    meta = {
      description = "Perl extension interface for libcurl";
      license = with lib.licenses; [ mit ];
    };
  };

  WWWFormUrlEncoded = buildPerlModule {
    pname = "WWW-Form-UrlEncoded";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/WWW-Form-UrlEncoded-0.26.tar.gz";
      hash = "sha256-wEgLXx8VtxFj7DJ7jnhCKY8Ms6zpfmPXA0rx6UotkPQ=";
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
      hash = "sha256-Px3XTfYdYVIsAnDxluzG6AxAj4xNGDW5nh/OCg2ThF4=";
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
      hash = "sha256-weBNi/Hh8NfP9Rl7I2Z2kyrLgCgJNq7a5PngSFGo0hA=";
    };
    propagatedBuildInputs = [ HTTPRequestAsCGI WWWMechanize ];
    preConfigure = ''
      substituteInPlace t/cgi-bin/script.cgi \
        --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    '';
    meta = {
      description = "Use WWW::Mechanize with CGI applications";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
      broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/perl534Packages.WWWMechanizeCGI.x86_64-darwin
    };
  };

  WWWRobotRules = buildPerlPackage {
    pname = "WWW-RobotRules";
    version = "6.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz";
      hash = "sha256-RrUC56KI1VlCmJHutdl5Rh3T7MalxJHq2F0WW24DpR4=";
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
      hash = "sha256-WC21OgkfjaNnDAN3MzFPJRCvXo7gukKg45Hi8uPKdzQ=";
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
      hash = "sha256-tOR0C41Mt4NZEnPGNr1oMEiS4o2J6Iq/knOx3hf1Uvc=";
    };
    meta = {
      description = "A generalisation of wantarray";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Win32ShellQuote = buildPerlPackage {
    pname = "Win32-ShellQuote";
    version = "0.003001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Win32-ShellQuote-0.003001.tar.gz";
      hash = "sha256-qnSw49wtQc1j9i+FPlIf/Xa42CNHmiYZ4i7bQEm0wNw=";
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
      hash = "sha256-TgSwvHYuWYzMCwzD1N9qYfWkWzTIVQRnLPD5mmh85i8=";
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
      hash = "sha256-HP22U1oPRnbm8aqyydjhbVd74+s7fMBMgHTWheZlG3A=";
    };
    patches = [
      (fetchpatch {
        url = "https://sources.debian.org/data/main/libw/libwx-perl/1%3A0.9932-8/debian/patches/gtk3.patch";
        hash = "sha256-CokmRzDTFmEMN/jTKw9ECCPvi0mHt5+h8Ojg4Jgd7D4=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/libw/libwx-perl/1%3A0.9932-8/debian/patches/wxWidgets_3.2_MakeMaker.patch";
        hash = "sha256-kTJiCGv8yxQbgMych9yT2cOt+2bL1G4oJ0gehNcu0Rc=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/libw/libwx-perl/1%3A0.9932-8/debian/patches/wxWidgets_3.2_port.patch";
        hash = "sha256-y9LMpcbm7p8+LZ2Hw3PA2jc7bHAFEu0QRa170XuseKw=";
      })
    ];
    # DND.c:453:15: error: incompatible integer to pointer conversion assigning to 'NativeFormat' (aka 'const __CFString *') from 'wxDataFormatId'
    postPatch = ''
      substituteInPlace ext/dnd/XS/DataObject.xs \
        --replace "#ifdef __WXGTK20__" "#if wxUSE_GUI"
    '';
    propagatedBuildInputs = [ AlienWxWidgets ];
    # Testing requires an X server:
    #   Error: Unable to initialize GTK, is DISPLAY set properly?"
    doCheck = false;
    buildInputs = [ ExtUtilsXSpp ];
    meta = {
      description = "Interface to the wxWidgets cross-platform GUI toolkit";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WxGLCanvas = buildPerlPackage {
    pname = "Wx-GLCanvas";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/Wx-GLCanvas-0.09.tar.gz";
      hash = "sha256-atLCn/Bv+Apci0udHWvwrtV0iegxvlnJRJT09ojcj+A=";
    };
    propagatedBuildInputs = [ pkgs.libGLU Wx ];
    doCheck = false;
    meta = {
      description = "wxPerl demo helper for Wx::GLCanvas";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  X11IdleTime = buildPerlPackage {
    pname = "X11-IdleTime";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWENDT/X11-IdleTime-0.09.tar.gz";
      hash = "sha256-2P3cB455ge4xt2CMZTZFyyDwFr3dx8VQtNUn79NiR0g=";
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
      hash = "sha256-3pbdbHwfJfMoeqevZJAr+ErKqo4MO7dqoWdjZ+BKCLc=";
    };
    doCheck = false; # requires an X server
    meta = {
      description = "Perl module for the X Window System Protocol, version 11";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  X11ProtocolOther = buildPerlPackage {
    pname = "X11-Protocol-Other";
    version = "31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/X11-Protocol-Other-31.tar.gz";
      hash = "sha256-PGJZk9x6jrHQLgcQimZjAkWcb8b589J2FfdJUVjcc/Q=";
    };
    propagatedBuildInputs = [ X11Protocol ];
    buildInputs = [ EncodeHanExtra ModuleUtil ];
    meta = {
      description = "Miscellaneous helpers for X11::Protocol connections";
      homepage = "https://user42.tuxfamily.org/x11-protocol-other/index.html";
      license = with lib.licenses; [ gpl1Plus gpl3Plus ];
    };
  };

  X11GUITest = buildPerlPackage {
    pname = "X11-GUITest";
    version = "0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/X11-GUITest-0.28.tar.gz";
      hash = "sha256-3O7eU3AGEP/xQtydXE5M0DcMiKTysTcfnL9NjYzm9ks=";
    };
    buildInputs = [ pkgs.xorg.libX11 pkgs.xorg.libXi pkgs.xorg.libXt pkgs.xorg.libXtst ];
    NIX_CFLAGS_LINK = "-lX11";
    doCheck = false; # requires an X server
    meta = {
      description = "Provides GUI testing/interaction routines";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  X11XCB = buildPerlPackage {
    pname = "X11-XCB";
    version = "0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/X11-XCB-0.18.tar.gz";
      hash = "sha256-rtvML3GhEeEVcqJ8nu0qfwoh6venLQoEn0xZdjh8V7I=";
    };
    patches = [
      # Pull upstream fix for parallel build failure
      (fetchpatch {
        url = "https://github.com/stapelberg/X11-XCB/commit/813608dacdae1ae35c9eb0f171a958617e014520.patch";
        hash = "sha256-gxxY8549/ebS3QORjSs8IgdBs2aD05Tu+9Bn70gu7gQ=";
      })
    ];
    env.AUTOMATED_TESTING = false;
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
      hash = "sha256-5yhGSIDLtMHz/XceCQOoUmzWV7OUuzchYDUkXPHihu4=";
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
      hash = "sha256-pxG4VvjN9eZHpExx+WfUjAlgNbnb0/Hvvb6kBgWvvVA=";
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
      hash = "sha256-pQ5Brwp5uILUiBa5VoHzilWvHmqIgo3NljdKi94jBaE=";
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
      hash = "sha256-i6JLC0WbAdbF5bBAiCnH1d/kf/ebNUjIE3WQSAmbF14=";
    };
    propagatedBuildInputs = [ XMLRegExp libxml_perl ];
    meta = {
      description = "Interface to XML::DOM toolset";
      license = with lib.licenses; [ gpl2Only ];
    };
  };

  XMLFeedPP = buildPerlPackage {
    pname = "XML-FeedPP";
    version = "0.95";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/XML-FeedPP-0.95.tar.gz";
      hash = "sha256-kMOVm/GmC3aimnSac5QfOgx7mllUwTZbyB2vyrsBqPQ=";
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
      hash = "sha256-j9ISbTvuxVTfhSkZ9HOeaJICy7pqF1Bum2bqFlhBp1w=";
    };
    doCheck = false;
    meta = {
      description = "Filter to put all characters() in one event";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLFilterXInclude = buildPerlPackage {
    pname = "XML-Filter-XInclude";
    version = "1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Filter-XInclude-1.0.tar.gz";
      hash = "sha256-mHRvPB9vBJSR/sID1FW7j4ycbiUPBBkE3aXXjiEYf5M=";
    };
    doCheck = false;
    meta = {
      description = "XInclude as a SAX Filter";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLFilterSort = buildPerlPackage {
    pname = "XML-Filter-Sort";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Filter-Sort-1.01.tar.gz";
      hash = "sha256-UQWF85pJFszV+o1UXpYXnJHq9vx8l6QBp1aOhBFi+l8=";
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
      hash = "sha256-/LZtffSsKcsO3B6mLBdQcCyqaob8lHkKlPyxo2vQ0Rc=";
    };
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ libxml_perl ];

    #patch from https://bugzilla.redhat.com/show_bug.cgi?id=226285
    patches = [ ../development/perl-modules/xml-grove-utf8.patch ];
    meta = {
      description = "Perl-style XML objects";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLHandlerYAWriter = buildPerlPackage {
    pname = "XML-Handler-YAWriter";
    version = "0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRAEHE/XML-Handler-YAWriter-0.23.tar.gz";
      hash = "sha256-50y7vl41wapyYZC/re8cePN7ThV3+JyT2sKgr4MqpIU=";
    };
    propagatedBuildInputs = [ libxml_perl ];
    meta = {
      description = "Yet another Perl SAX XML Writer";
      license = with lib.licenses; [ gpl1Only ];
      mainProgram = "xmlpretty";
    };
  };

  XMLLibXML = buildPerlPackage {
    pname = "XML-LibXML";
    version = "2.0208";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0208.tar.gz";
      hash = "sha256-DABrA7+NDrUx+1a9o64VdUylbYiN17noBauesZ1f1lM=";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ AlienBuild AlienLibxml2 ]
      ++ lib.optionals stdenv.isDarwin (with pkgs; [ libiconv zlib ]);
    # Remove test that fails after LibXML 2.11 upgrade
    postPatch = ''
      rm t/35huge_mode.t
    '';
    propagatedBuildInputs = [ XMLSAX ];
    meta = {
      description = "Perl Binding for libxml2";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLLibXMLSimple = buildPerlPackage {
    pname = "XML-LibXML-Simple";
    version = "1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz";
      hash = "sha256-zZjIEEtw12cr+ia0UTt4rfK0uSIOWGqovrGlCFADZaY=";
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
      hash = "sha256-En4XqHf7YeR7nouHv42q0xM5pioAEh+XUdUitDiw9/A=";
    };
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      description = "Interface to the GNOME libxslt library";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLMini = buildPerlPackage {
    pname = "XML-Mini";
    version = "1.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PD/PDEEGAN/XML-Mini-1.38.tar.gz";
      hash = "sha256-r4A9OANqMYThJKaC5UZvG8EH9IqJ7zWwx2R+EaBz/i0=";
    };
    meta = {
      description = "Perl implementation of the XML::Mini XML create/parse interface";
      license = with lib.licenses; [ gpl3Plus ];
    };
  };

  XMLNamespaceSupport = buildPerlPackage {
    pname = "XML-NamespaceSupport";
    version = "1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz";
      hash = "sha256-R+mVhZ+N0EE6o/ItNQxKYtplLoVCZ6oFhq5USuK65e8=";
    };
    meta = {
      description = "A simple generic namespace processor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLParser = buildPerlPackage {
    pname = "XML-Parser";
    version = "2.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz";
      hash = "sha256-0zEzJJHFHMz7TLlP/ET5zXM3jmGEmNSjffngQ2YcUV0=";
    };
    patches = [ ../development/perl-modules/xml-parser-0001-HACK-Assumes-Expat-paths-are-good.patch ];
    postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Expat/Makefile.PL --replace 'use English;' '#'
    '' + lib.optionalString stdenv.isCygwin ''
      sed -i"" -e "s@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. \$Config{_exe};@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. (\$^O eq 'cygwin' ? \"\" : \$Config{_exe});@" inc/Devel/CheckLib.pm
    '';
    makeMakerFlags = [ "EXPATLIBPATH=${pkgs.expat.out}/lib" "EXPATINCPATH=${pkgs.expat.dev}/include" ];
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A perl module for parsing XML documents";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLParserLite = buildPerlPackage {
    pname = "XML-Parser-Lite";
    version = "0.722";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/XML-Parser-Lite-0.722.tar.gz";
      hash = "sha256-b5CgJ+FTGg5UBs8d4Txwm1IWlm349z0Lq5q5GSCXY+4=";
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
      hash = "sha256-HMkRBwUWXcCd0Jl03XwLZwnJNR1raxzvWnEQVfiR3Q8=";
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
      hash = "sha256-0v57y70L66FET0pzNAHnuKpSgvrUJm1Cc13XRYKy4mQ=";
    };
    meta = {
      description = "A re-usable XPath engine for DOM-like trees";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLRegExp = buildPerlPackage {
    pname = "XML-RegExp";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz";
      hash = "sha256-3xmQCWA2CFyOLUWQT+GA+Cv+1A8afgUkPzNOoQCQ/FQ=";
    };
    meta = {
      description = "Regular expressions for XML tokens";
      license = with lib.licenses; [ gpl2Plus];
    };
  };

  XMLRPCLite = buildPerlPackage {
    pname = "XMLRPC-Lite";
    version = "0.717";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PH/PHRED/XMLRPC-Lite-0.717.tar.gz";
      hash = "sha256-Op+l8ssfr4t8ZrTDhuqzXKxgiK/E28dX1Pd9KE2rRSQ=";
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
      hash = "sha256-0ycGNELH/3FDmTqgwtFv3lEhSRyXFmHrbLcA0uBDi04=";
    };
    propagatedBuildInputs = [ DateTimeFormatMail DateTimeFormatW3CDTF XMLParser ];
    meta = {
      description = "Creates and updates RSS files";
      homepage = "https://metacpan.org/release/XML-RSS";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLRules = buildPerlModule {
    pname = "XML-Rules";
    version = "1.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JENDA/XML-Rules-1.16.tar.gz";
      hash = "sha256-N4glXAev5BlaDecs4FBlIyDYF1KP8tEMYR9uOSBDhos=";
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
      hash = "sha256-RQbDhwQ6pqd7RV8A9XQJ83IKp+VTSVqyU1JjtO0eoSo=";
    };
    propagatedBuildInputs = [ XMLNamespaceSupport XMLSAXBase ];
    postInstall = ''
      perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
      '';
    meta = {
      description = "Simple API for XML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSAXBase = buildPerlPackage {
    pname = "XML-SAX-Base";
    version = "1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz";
      hash = "sha256-Zss1W6TvR8EMpzi9NZmXI2RDhqyFOrvrUTKEH16KKtA=";
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
      hash = "sha256-TAFiE9DOfbLElOMAhrWZF7MC24wpLc0h853uvZeAyD8=";
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
      hash = "sha256-PWHQfvQ7ASb1tN5PQVolb6hZ+ojcT9q6rXC3vnxoLPA=";
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
      hash = "sha256-Bf3v77vD9rYvx8m1+rr7a2le1o8KPZWFdyUdHwQCoPU=";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Perl extension for comparing XML documents";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLSimple = buildPerlPackage {
    pname = "XML-Simple";
    version = "2.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz";
      hash = "sha256-Ux/drr6iQWdD61xP36sCj1AhI9miIEBaQQDmj8SA2/g=";
    };
    propagatedBuildInputs = [ XMLSAXExpat ];
    meta = {
      description = "An API for simple XML files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTokeParser = buildPerlPackage {
    pname = "XML-TokeParser";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/XML-TokeParser-0.05.tar.gz";
      hash = "sha256-hTm0+YQ2sabQiDQai0Uwt5IqzWUfPyk3f4sZSMfi18I=";
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
      hash = "sha256-f74tZDCGAFmJSu7r911MrPG/jXt1KU64fY4VAvgb12A=";
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
      hash = "sha256-/vdYJsJPK4d9Cg0mRSEvxPuXVu1NJxFhSsFcSX6GgK0=";
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
      hash = "sha256-YUJnlYAVCokffTIjK14x4rTl5T6Kb6nL7stcI4FPFCI=";
    };
    propagatedBuildInputs = [ TreeDAGNode XMLFilterBufferText XMLSAX ];
    meta = {
      description = "Validate XML against a subset of W3C XML Schema";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLWriter = buildPerlPackage {
    pname = "XML-Writer";
    version = "0.900";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz";
      hash = "sha256-c8j1vT7PKzUPStrm1mdtUuCOzC199KnwifpoNg1ADR8=";
    };
    meta = {
      description = "Module for creating a XML document object oriented with on the fly validating towards the given DTD";
      license = with lib.licenses; [ gpl1Only ];
    };
  };

  XSObjectMagic = buildPerlPackage {
    pname = "XS-Object-Magic";
    version = "0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/XS-Object-Magic-0.05.tar.gz";
      hash = "sha256-PcnkYM7pLhF0QGJ1RkOjN3jKUqVNIF/K/6SrDzzxXlo=";
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
    version = "0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/XS-Parse-Keyword-0.34.tar.gz";
      hash = "sha256-EDPdtAmSTZ1Cs4MEodeXRaBDSrxrBJHrErbIu5bx1sE=";
    };
    buildInputs = [ ExtUtilsCChecker Test2Suite ];
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
      hash = "sha256-IV5AmzmFgdJfDv8DeFBjvCUTu4YbrL6Z/m1VNTRvZt8=";
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
      hash = "sha256-pmY2DEl9zgf0HL5FtfjExW24G8iPDHU/Qaxv0QYU86s=";
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
      hash = "sha256-UDCm1sv/rxJYMFC/VSqoANRkbKlnjBh63WSSJ/V0ec0=";
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
      hash = "sha256-+lRvzZrMWjm8iHGQL3/B66UOfceBxc1cCr8a7ObRfs0=";
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
      hash = "sha256-zJFWzK69p5jr/i8xthnoBld/hg7RcEJi8X/608bjQVk=";
    };
    perlPreHook = lib.optionalString stdenv.isDarwin "export LD=$CC";
    meta = {
      description = "Fast, lightweight YAML loader and dumper";
      homepage = "https://github.com/toddr/YAML-Syck";
      license = with lib.licenses; [ mit ];
    };
  };

  YAMLTiny = buildPerlPackage {
    pname = "YAML-Tiny";
    version = "1.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz";
      hash = "sha256-vDFfoS6PHj7l4vQw2Qtwil3H5HyGfbqNzjprj74ld0Q=";
    };
    meta = {
      description = "Read/Write YAML files with as little code as possible";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLLibYAML = buildPerlPackage {
    pname = "YAML-LibYAML";
    version = "0.83";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-LibYAML-0.83.tar.gz";
      hash = "sha256-tHF1tP85etdaT3eB09g8CGN9pv8LrjJq87OJ2FS+xJA=";
    };
    meta = {
      description = "Perl YAML Serialization using XS and libyaml";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLPP = buildPerlPackage {
    pname = "YAML-PP";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-PP-0.026.tar.gz";
      hash = "sha256-S4WOZxzz6WbsxUQI6AMXQMLyj4fClO6WefsC4C1aRes=";
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
      hash = "sha256-8TnSsxFMVJ6RhH2qq4t1y2meV9r1u/Db0TKT8z/l4io=";
    };
    buildInputs = [ NetHTTP TestFailWarnings TestFatal ];
    propagatedBuildInputs = [ HTTPHeadersActionPack HTTPMessage HashMultiValue IOHandleUtil ModuleRuntime Plack SubExporter TryTiny ];
    meta = {
      description = "A Perl port of Webmachine";
      homepage = "https://metacpan.org/release/Web-Machine";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WebScraper = buildPerlModule {
    pname = "Web-Scraper";
    version = "0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Web-Scraper-0.38.tar.gz";
      hash = "sha256-+VtuX41/7r4RbQW/WaK3zxpR7Z0wvKgBI0MOxFZ1Q78=";
    };
    buildInputs = [ ModuleBuildTiny TestBase TestRequires ];
    propagatedBuildInputs = [ HTMLParser HTMLSelectorXPath HTMLTagset HTMLTree HTMLTreeBuilderXPath UNIVERSALrequire URI XMLXPathEngine YAML libwwwperl ];
    meta = {
      homepage = "https://github.com/miyagawa/web-scraper";
      description = "Web Scraping Toolkit using HTML and CSS Selectors or XPath expressions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WebServiceLinode = buildPerlModule {
    pname = "WebService-Linode";
    version = "0.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEGRB/WebService-Linode-0.29.tar.gz";
      hash = "sha256-EDqrJFME8I6eh6x7yITdtEpjDea6wHfckh9xbXEVSSI=";
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
      hash = "sha256-zLB60zegOuyBob6gqJzSlUaR/1uzZ9+aMrnZEw8XURA=";
    };
    buildInputs = [ ClassAccessor LWP ];
    meta = {
      description = "Access the W3Cs online HTML validator";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ZonemasterCLI = buildPerlPackage {
    pname = "Zonemaster-CLI";
    version = "5.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-CLI-v5.0.1.tar.gz";
      hash = "sha256-a/PPgavkaw9gCW44rj7+6AjOOSHKglg4H3kr6jXuRE4=";
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
    version = "4.6.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-Engine-v4.6.1.tar.gz";
      hash = "sha256-4AXo3bZTOLnnPjjX5KNb/2O7MRqcAtlqpz5sPwNN9b0=";
    };
    buildInputs = [ PodCoverage TestDifferences TestException TestFatal TestNoWarnings TestPod ];
    propagatedBuildInputs = [ ClassAccessor Clone EmailValid FileShareDir FileSlurp IOSocketINET6 ListMoreUtils ModuleFind Moose MooseXSingleton NetIP NetIPXS Readonly TextCSV ZonemasterLDNS libintl-perl ];

    meta = {
      description = "A tool to check the quality of a DNS zone";
      license = with lib.licenses; [ bsd3 ];
    };
  };

  ZonemasterLDNS = buildPerlPackage {
    pname = "Zonemaster-LDNS";
    version = "3.1.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZN/ZNMSTR/Zonemaster-LDNS-3.1.0.tar.gz";
      hash = "sha256-Rr4uoQg5g9/ZLVnFQiLAz5MB+Uj39U24YWEa+o2+9HE=";
    };
    env.NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include -I${pkgs.libidn2}.dev}/include";
    NIX_CFLAGS_LINK = "-L${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.libidn2}/lib -lcrypto -lidn2";

    makeMakerFlags = [ "--prefix-openssl=${pkgs.openssl.dev}" ];

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ DevelChecklib ModuleInstall ModuleInstallXSUtil TestFatal pkgs.ldns pkgs.libidn2 pkgs.openssl ];
    meta = {
      description = "Perl wrapper for the ldns DNS library";
      license = with lib.licenses; [ bsd3 ];
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
  IOSocketInet6 = self.IOSocketINET6;
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
}
