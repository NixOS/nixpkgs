/*
  The top-level package collection of nixpkgs.
  It is sorted by categories corresponding to the folder names in the /pkgs
  folder. Inside the categories packages are roughly sorted by alphabet, but
  strict sorting has been long lost due to merges. Please use the full-text
  search of your editor. ;)
  Hint: ### starts category names.
*/
{
  lib,
  noSysDirs,
  config,
  overlays,
}:
res: pkgs: super:

with pkgs;

{
  # A module system style type tag
  #
  # Allows the nixpkgs fixpoint, usually known as `pkgs` to be distinguished
  # nominally.
  #
  #     pkgs._type == "pkgs"
  #     pkgs.pkgsStatic._type == "pkgs"
  #
  # Design note:
  # While earlier stages of nixpkgs fixpoint construction are supertypes of this
  # stage, they're generally not usable in places where a `pkgs` is expected.
  # (earlier stages being the various `super` variables that precede
  # all-packages.nix)
  _type = "pkgs";

  # A stdenv capable of building 32-bit binaries.
  # On x86_64-linux, it uses GCC compiled with multilib support; on i686-linux,
  # it's just the plain stdenv.
  stdenv_32bit = lowPrio (if stdenv.hostPlatform.is32bit then stdenv else multiStdenv);

  mkStdenvNoLibs =
    stdenv:
    let
      bintools = stdenv.cc.bintools.override {
        libc = null;
        noLibc = true;
      };
    in
    stdenv.override {
      cc = stdenv.cc.override {
        libc = null;
        noLibc = true;
        extraPackages = [ ];
        inherit bintools;
      };
      allowedRequisites = lib.mapNullable (rs: rs ++ [ bintools ]) (stdenv.allowedRequisites or null);
    };

  stdenvNoLibs =
    if stdenvNoCC.hostPlatform != stdenvNoCC.buildPlatform then
      # We cannot touch binutils or cc themselves, because that will cause
      # infinite recursion. So instead, we just choose a libc based on the
      # current platform. That means we won't respect whatever compiler was
      # passed in with the stdenv stage argument.
      #
      # TODO It would be much better to pass the `stdenvNoCC` and *unwrapped*
      # cc, bintools, compiler-rt equivalent, etc. and create all final stdenvs
      # as part of the stage. Then we would never be tempted to override a later
      # thing to to create an earlier thing (leading to infinite recursion) and
      # we also would still respect the stage arguments choices for these
      # things.
      (
        if stdenvNoCC.hostPlatform.isDarwin || stdenvNoCC.hostPlatform.useLLVM or false then
          overrideCC stdenvNoCC buildPackages.llvmPackages.clangNoCompilerRt
        else
          gccCrossLibcStdenv
      )
    else
      mkStdenvNoLibs stdenv;

  stdenvNoLibc =
    if stdenvNoCC.hostPlatform != stdenvNoCC.buildPlatform then
      (
        if stdenvNoCC.hostPlatform.isDarwin || stdenvNoCC.hostPlatform.useLLVM or false then
          overrideCC stdenvNoCC buildPackages.llvmPackages.clangNoLibc
        else
          gccCrossLibcStdenv
      )
    else
      mkStdenvNoLibs stdenv;

  gccStdenvNoLibs = mkStdenvNoLibs gccStdenv;
  clangStdenvNoLibs = mkStdenvNoLibs clangStdenv;

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;

  ### Helper functions.
  inherit lib config overlays;

  # do not import 'appendToName' to get consistent package-names with the same
  # set of package-parameters: https://github.com/NixOS/nixpkgs/issues/68519
  inherit (lib) lowPrio hiPrio makeOverridable;

  inherit (lib) recurseIntoAttrs;

  # This is intended to be the reverse of recurseIntoAttrs, as it is
  # defined now it exists mainly for documentation purposes, but you
  # can also override this with recurseIntoAttrs to recurseInto all
  # the Attrs which is useful for testing massive changes. Ideally,
  # every package subset not marked with recurseIntoAttrs should be
  # marked with this.
  inherit (lib) dontRecurseIntoAttrs;

  stringsWithDeps = lib.stringsWithDeps;

  ### Evaluating the entire Nixpkgs naively will likely fail, make failure fast
  AAAAAASomeThingsFailToEvaluate = throw ''
    This pseudo-package is likely not the only part of Nixpkgs that fails to evaluate.
    You should not evaluate entire Nixpkgs without measures to handle failing packages.
  '';

  tests = lib.recurseIntoAttrs (callPackages ../test { });

  defaultPkgConfigPackages =
    # We don't want nix-env -q to enter this, because all of these are aliases.
    dontRecurseIntoAttrs (import ./pkg-config/defaultPkgConfigPackages.nix pkgs);

  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };

  common-updater-scripts = callPackage ../common-updater/scripts.nix { };

  vimPluginsUpdater = callPackage ../applications/editors/vim/plugins/utils/updater.nix {
    inherit (python3Packages) buildPythonApplication;
  };

  genericUpdater = callPackage ../common-updater/generic-updater.nix { };

  _experimental-update-script-combinators = callPackage ../common-updater/combinators.nix { };

  directoryListingUpdater = callPackage ../common-updater/directory-listing-updater.nix { };

  gitUpdater = callPackage ../common-updater/git-updater.nix { };

  httpTwoLevelsUpdater = callPackage ../common-updater/http-two-levels-updater.nix { };

  unstableGitUpdater = callPackage ../common-updater/unstable-updater.nix { };

  inherit (nix-update) nix-update-script;

  ### Push NixOS tests inside the fixed point

  # See also allTestsForSystem in nixos/release.nix
  nixosTests =
    import ../../nixos/tests/all-tests.nix {
      inherit pkgs;
      system = stdenv.hostPlatform.system;
      callTest = config: config.test;
    }
    // {
      # for typechecking of the scripts and evaluation of
      # the nodes, without running VMs.
      allDrivers = import ../../nixos/tests/all-tests.nix {
        inherit pkgs;
        system = stdenv.hostPlatform.system;
        callTest = config: config.test.driver;
      };
    };

  ### BUILD SUPPORT

  __flattenIncludeHackHook = callPackage ../build-support/setup-hooks/flatten-include-hack { };

  arrayUtilities =
    let
      arrayUtilitiesPackages = makeScopeWithSplicing' {
        otherSplices = generateSplicesForMkScope "arrayUtilities";
        f =
          finalArrayUtilities:
          {
            callPackages = lib.callPackagesWith (pkgs // finalArrayUtilities);
          }
          // lib.packagesFromDirectoryRecursive {
            inherit (finalArrayUtilities) callPackage;
            directory = ../build-support/setup-hooks/arrayUtilities;
          };
      };
    in
    recurseIntoAttrs arrayUtilitiesPackages;

  addBinToPathHook = callPackage (
    { makeSetupHook }:
    makeSetupHook {
      name = "add-bin-to-path-hook";
    } ../build-support/setup-hooks/add-bin-to-path.sh
  ) { };

  aider-chat = with python312Packages; toPythonApplication aider-chat;

  aider-chat-with-playwright =
    with python312Packages;
    toPythonApplication (aider-chat.withOptional { withPlaywright = true; });

  aider-chat-with-browser =
    with python312Packages;
    toPythonApplication (aider-chat.withOptional { withBrowser = true; });

  aider-chat-with-help =
    with python312Packages;
    toPythonApplication (aider-chat.withOptional { withHelp = true; });

  aider-chat-with-bedrock =
    with python312Packages;
    toPythonApplication (aider-chat.withOptional { withBedrock = true; });

  aider-chat-full =
    with python312Packages;
    toPythonApplication (aider-chat.withOptional { withAll = true; });

  autoreconfHook = callPackage (
    {
      makeSetupHook,
      autoconf,
      automake,
      gettext,
      libtool,
    }:
    makeSetupHook {
      name = "autoreconf-hook";
      propagatedBuildInputs = [
        autoconf
        automake
        gettext
        libtool
      ];
    } ../build-support/setup-hooks/autoreconf.sh
  ) { };

  autoreconfHook264 = autoreconfHook.override {
    autoconf = autoconf264;
    automake = automake111x;
  };

  autoreconfHook269 = autoreconfHook.override {
    autoconf = autoconf269;
  };
  autoreconfHook271 = autoreconfHook.override {
    autoconf = autoconf271;
  };

  autoPatchelfHook = makeSetupHook {
    name = "auto-patchelf-hook";
    propagatedBuildInputs = [
      auto-patchelf
      bintools
    ];
  } ../build-support/setup-hooks/auto-patchelf.sh;

  appimageTools = callPackage ../build-support/appimage { };

  appimageupdate-qt = appimageupdate.override { withQtUI = true; };

  stripJavaArchivesHook = makeSetupHook {
    name = "strip-java-archives-hook";
    propagatedBuildInputs = [ strip-nondeterminism ];
  } ../build-support/setup-hooks/strip-java-archives.sh;

  ensureNewerSourcesHook =
    { year }:
    makeSetupHook
      {
        name = "ensure-newer-sources-hook";
      }
      (
        writeScript "ensure-newer-sources-hook.sh" ''
          postUnpackHooks+=(_ensureNewerSources)
          _ensureNewerSources() {
            local r=$sourceRoot
            # Avoid passing option-looking directory to find. The example is diffoscope-269:
            #   https://salsa.debian.org/reproducible-builds/diffoscope/-/issues/378
            [[ $r == -* ]] && r="./$r"
            '${findutils}/bin/find' "$r" \
              '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
          }
        ''
      );

  # addDriverRunpath is the preferred package name, as this enables
  # many more scenarios than just opengl now.
  aocd = with python3Packages; toPythonApplication aocd;

  archipelago-minecraft = callPackage ../by-name/ar/archipelago/package.nix {
    extraPackages = [ jdk17 ];
  };

  cve = with python3Packages; toPythonApplication cvelib;

  apko = callPackage ../development/tools/apko {
    buildGoModule = buildGo123Module;
  };

  basalt-monado = callPackage ../by-name/ba/basalt-monado/package.nix {
    tbb = tbb_2021_11;
    cereal = cereal_1_3_2;
    opencv = opencv.override { enableGtk3 = true; };
  };

  beebeep = libsForQt5.callPackage ../applications/office/beebeep { };

  bloodhound-py = with python3Packages; toPythonApplication bloodhound-py;

  # Zip file format only allows times after year 1980, which makes e.g. Python
  # wheel building fail with:
  # ValueError: ZIP does not support timestamps before 1980
  ensureNewerSourcesForZipFilesHook = ensureNewerSourcesHook { year = "1980"; };

  updateAutotoolsGnuConfigScriptsHook = makeSetupHook {
    name = "update-autotools-gnu-config-scripts-hook";
    substitutions = {
      gnu_config = gnu-config;
    };
  } ../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh;

  gogUnpackHook = makeSetupHook {
    name = "gog-unpack-hook";
    propagatedBuildInputs = [
      innoextract
      file-rename
    ];
  } ../build-support/setup-hooks/gog-unpack.sh;

  buf = callPackage ../by-name/bu/buf/package.nix {
    buildGoModule = buildGo123Module;
  };

  buildEnv = callPackage ../build-support/buildenv { }; # not actually a package

  buildFHSEnv = buildFHSEnvBubblewrap;
  buildFHSEnvChroot = callPackage ../build-support/build-fhsenv-chroot { }; # Deprecated; use buildFHSEnv/buildFHSEnvBubblewrap
  buildFHSEnvBubblewrap = callPackage ../build-support/build-fhsenv-bubblewrap { };

  cameractrls-gtk4 = cameractrls.override { withGtk = 4; };

  cameractrls-gtk3 = cameractrls.override { withGtk = 3; };

  checkpointBuildTools = callPackage ../build-support/checkpoint-build.nix { };

  celeste-classic-pm = pkgs.celeste-classic.override {
    practiceMod = true;
  };

  cereal = cereal_1_3_0;

  chef-cli = callPackage ../tools/misc/chef-cli { };

  clang-uml = callPackage ../by-name/cl/clang-uml/package.nix {
    stdenv = clangStdenv;
  };

  cope = callPackage ../by-name/co/cope/package.nix {
    perl = perl538;
    perlPackages = perl538Packages;
  };

  coolercontrol = recurseIntoAttrs (callPackage ../applications/system/coolercontrol { });

  copilot-language-server-fhs = copilot-language-server.fhs;

  deck = callPackage ../by-name/de/deck/package.nix {
    buildGoModule = buildGo123Module;
  };

  dhallDirectoryToNix = callPackage ../build-support/dhall/directory-to-nix.nix { };

  dhallPackageToNix = callPackage ../build-support/dhall/package-to-nix.nix { };

  dhallToNix = callPackage ../build-support/dhall/to-nix.nix { };

  dinghy = with python3Packages; toPythonApplication dinghy;

  djgpp = djgpp_i586;
  djgpp_i586 = callPackage ../development/compilers/djgpp {
    targetArchitecture = "i586";
    stdenv = gccStdenv;
  };
  djgpp_i686 = lowPrio (
    callPackage ../development/compilers/djgpp {
      targetArchitecture = "i686";
      stdenv = gccStdenv;
    }
  );

  djhtml = python3Packages.callPackage ../development/tools/djhtml { };

  dnf-plugins-core = with python3Packages; toPythonApplication dnf-plugins-core;

  dnf4 = python3Packages.callPackage ../development/python-modules/dnf4/wrapper.nix { };

  ebpf-verifier = callPackage ../tools/networking/ebpf-verifier {
    catch2 = catch2_3;
  };

  eff = callPackage ../by-name/ef/eff/package.nix { ocamlPackages = ocaml-ng.ocamlPackages_5_2; };

  enochecker-test = with python3Packages; callPackage ../development/tools/enochecker-test { };

  inherit (gridlock) nyarr;

  inspec = callPackage ../tools/misc/inspec { };

  lshw-gui = lshw.override { withGUI = true; };

  kdePackages = callPackage ../kde { };

  buildcatrust = with python3.pkgs; toPythonApplication buildcatrust;

  mumps-mpi = callPackage ../by-name/mu/mumps/package.nix { mpiSupport = true; };

  protoc-gen-grpc-web = callPackage ../development/tools/protoc-gen-grpc-web {
    protobuf = protobuf_21;
  };

  vcpkg-tool = callPackage ../by-name/vc/vcpkg-tool/package.nix {
    fmt = fmt_11;
  };

  r3ctl = qt5.callPackage ../tools/misc/r3ctl { };

  deviceTree = callPackage ../os-specific/linux/device-tree { };

  octodns-providers = octodns.providers;

  oletools = with python3.pkgs; toPythonApplication oletools;

  ollama-rocm = callPackage ../by-name/ol/ollama/package.nix { acceleration = "rocm"; };
  ollama-cuda = callPackage ../by-name/ol/ollama/package.nix { acceleration = "cuda"; };

  device-tree_rpi = callPackage ../os-specific/linux/device-tree/raspberrypi.nix { };

  diffPlugins = (callPackage ../build-support/plugins.nix { }).diffPlugins;

  dieHook = makeSetupHook {
    name = "die-hook";
  } ../build-support/setup-hooks/die.sh;

  digitalbitbox = libsForQt5.callPackage ../applications/misc/digitalbitbox {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  devShellTools = callPackage ../build-support/dev-shell-tools { };

  dockerTools = callPackage ../build-support/docker {
    writePython3 = buildPackages.writers.writePython3;
  };

  tarsum = callPackage ../build-support/docker/tarsum.nix { };

  nix-prefetch-docker = callPackage ../build-support/docker/nix-prefetch-docker.nix { };

  docker-sync = callPackage ../tools/misc/docker-sync { };

  # Dotnet

  dotnetCorePackages = recurseIntoAttrs (callPackage ../development/compilers/dotnet { });

  dotnet-sdk_6 = dotnetCorePackages.sdk_6_0-bin;
  dotnet-sdk_7 = dotnetCorePackages.sdk_7_0-bin;
  dotnet-sdk_8 = dotnetCorePackages.sdk_8_0;
  dotnet-sdk_9 = dotnetCorePackages.sdk_9_0;
  dotnet-sdk_10 = dotnetCorePackages.sdk_10_0;

  dotnet-runtime_6 = dotnetCorePackages.runtime_6_0-bin;
  dotnet-runtime_7 = dotnetCorePackages.runtime_7_0-bin;
  dotnet-runtime_8 = dotnetCorePackages.runtime_8_0;
  dotnet-runtime_9 = dotnetCorePackages.runtime_9_0;
  dotnet-runtime_10 = dotnetCorePackages.runtime_10_0;

  dotnet-aspnetcore_6 = dotnetCorePackages.aspnetcore_6_0-bin;
  dotnet-aspnetcore_7 = dotnetCorePackages.aspnetcore_7_0-bin;
  dotnet-aspnetcore_8 = dotnetCorePackages.aspnetcore_8_0;
  dotnet-aspnetcore_9 = dotnetCorePackages.aspnetcore_9_0;
  dotnet-aspnetcore_10 = dotnetCorePackages.aspnetcore_10_0;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnet-aspnetcore = dotnetCorePackages.aspnetcore_8_0;

  inherit (dotnetCorePackages)
    buildDotnetModule
    buildDotnetGlobalTool
    mkNugetSource
    mkNugetDeps
    autoPatchcilHook
    ;

  dotnetenv = callPackage ../build-support/dotnet/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  buildDotnetPackage = callPackage ../build-support/dotnet/build-dotnet-package { };
  fetchNuGet = callPackage ../build-support/dotnet/fetchnuget { };
  dupeguru = callPackage ../applications/misc/dupeguru {
    python3Packages = python311Packages;
  };

  qdmr = libsForQt5.callPackage ../applications/radio/qdmr { };

  fetchbower = callPackage ../build-support/fetchbower { };

  fetchbzr = callPackage ../build-support/fetchbzr { };

  fetchcvs =
    if
      stdenv.buildPlatform != stdenv.hostPlatform
    # hack around splicing being crummy with things that (correctly) don't eval.
    then
      buildPackages.fetchcvs
    else
      callPackage ../build-support/fetchcvs { };

  fetchdarcs = callPackage ../build-support/fetchdarcs { };

  fetchdocker = callPackage ../build-support/fetchdocker { };

  fetchDockerConfig = callPackage ../build-support/fetchdocker/fetchDockerConfig.nix { };

  fetchDockerLayer = callPackage ../build-support/fetchdocker/fetchDockerLayer.nix { };

  fetchfossil = callPackage ../build-support/fetchfossil { };

  fetchgit =
    (callPackage ../build-support/fetchgit {
      git = buildPackages.gitMinimal;
      cacert = buildPackages.cacert;
      git-lfs = buildPackages.git-lfs;
    })
    // {
      # fetchgit is a function, so we use // instead of passthru.
      tests = pkgs.tests.fetchgit;
    };

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or { });

  fetchMavenArtifact = callPackage ../build-support/fetchmavenartifact { };

  fetchpijul = callPackage ../build-support/fetchpijul { };

  inherit (callPackages ../build-support/node/fetch-yarn-deps { })
    fixup-yarn-lock
    prefetch-yarn-deps
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    fetchYarnDeps
    ;

  prefer-remote-fetch = import ../build-support/prefer-remote-fetch;

  opendrop = python3Packages.callPackage ../tools/networking/opendrop { };

  pe-bear = libsForQt5.callPackage ../applications/misc/pe-bear { };

  magika = with python3Packages; toPythonApplication magika;

  mysql-shell = mysql-shell_8;

  inherit
    ({
      mysql-shell_8 = callPackage ../development/tools/mysql-shell/8.nix {
        antlr = antlr4_10;
        icu = icu73;
        protobuf = protobuf_24;
        stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_18.stdenv else stdenv;
      };
    })
    mysql-shell_8
    ;

  mysql-shell-innovation = callPackage ../development/tools/mysql-shell/innovation.nix {
    antlr = antlr4_10;
    icu = icu73;
    protobuf = protobuf_24;
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_18.stdenv else stdenv;
  };

  fetchpatch =
    callPackage ../build-support/fetchpatch {
      # 0.3.4 would change hashes: https://github.com/NixOS/nixpkgs/issues/25154
      patchutils = __splicedPackages.patchutils_0_3_3;
    }
    // {
      tests = pkgs.tests.fetchpatch;
      version = 1;
    };

  fetchpatch2 =
    callPackage ../build-support/fetchpatch {
      patchutils = __splicedPackages.patchutils_0_4_2;
    }
    // {
      tests = pkgs.tests.fetchpatch2;
      version = 2;
    };

  fetchs3 = callPackage ../build-support/fetchs3 { };

  fetchtorrent = callPackage ../build-support/fetchtorrent { };

  fetchsvn =
    if
      stdenv.buildPlatform != stdenv.hostPlatform
    # hack around splicing being crummy with things that (correctly) don't eval.
    then
      buildPackages.fetchsvn
    else
      callPackage ../build-support/fetchsvn { };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchsvnssh = callPackage ../build-support/fetchsvnssh { };

  fetchhg = callPackage ../build-support/fetchhg { };

  fetchFirefoxAddon = callPackage ../build-support/fetchfirefoxaddon { } // {
    tests = pkgs.tests.fetchFirefoxAddon;
  };

  fetchNextcloudApp = callPackage ../build-support/fetchnextcloudapp { };

  # `fetchurl' downloads a file from the network.
  fetchurl =
    if stdenv.buildPlatform != stdenv.hostPlatform then
      buildPackages.fetchurl # No need to do special overrides twice,
    else
      makeOverridable (import ../build-support/fetchurl) {
        inherit lib stdenvNoCC buildPackages;
        inherit cacert;
        curl = buildPackages.curlMinimal.override (old: rec {
          # break dependency cycles
          fetchurl = stdenv.fetchurlBoot;
          zlib = buildPackages.zlib.override { fetchurl = stdenv.fetchurlBoot; };
          pkg-config = buildPackages.pkg-config.override (old: {
            pkg-config = old.pkg-config.override {
              fetchurl = stdenv.fetchurlBoot;
            };
          });
          perl = buildPackages.perl.override {
            inherit zlib;
            fetchurl = stdenv.fetchurlBoot;
          };
          openssl = buildPackages.openssl.override {
            fetchurl = stdenv.fetchurlBoot;
            buildPackages = {
              coreutils = buildPackages.coreutils.override {
                fetchurl = stdenv.fetchurlBoot;
                inherit perl;
                xz = buildPackages.xz.override { fetchurl = stdenv.fetchurlBoot; };
                gmpSupport = false;
                aclSupport = false;
                attrSupport = false;
              };
              inherit perl;
            };
            inherit perl;
          };
          libssh2 = buildPackages.libssh2.override {
            fetchurl = stdenv.fetchurlBoot;
            inherit zlib openssl;
          };
          # On darwin, libkrb5 needs bootstrap_cmds which would require
          # converting many packages to fetchurl_boot to avoid evaluation cycles.
          # So turn gssSupport off there, and on Windows.
          # On other platforms, keep the previous value.
          gssSupport =
            if stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isWindows then
              false
            else
              old.gssSupport or true; # `? true` is the default
          libkrb5 = buildPackages.krb5.override {
            fetchurl = stdenv.fetchurlBoot;
            inherit pkg-config perl openssl;
            withLibedit = false;
            byacc = buildPackages.byacc.override { fetchurl = stdenv.fetchurlBoot; };
            keyutils = buildPackages.keyutils.override { fetchurl = stdenv.fetchurlBoot; };
          };
          nghttp2 = buildPackages.nghttp2.override {
            fetchurl = stdenv.fetchurlBoot;
            inherit pkg-config;
            enableApp = false; # curl just needs libnghttp2
            enableTests = false; # avoids bringing `cunit` and `tzdata` into scope
          };
        });
      };

  fetchRepoProject = callPackage ../build-support/fetchrepoproject { };

  fetchipfs = callPackage ../build-support/fetchipfs { };

  fetchzip = callPackage ../build-support/fetchzip { } // {
    tests = pkgs.tests.fetchzip;
  };

  fetchDebianPatch = callPackage ../build-support/fetchdebianpatch { } // {
    tests = pkgs.tests.fetchDebianPatch;
  };

  fetchCrate = callPackage ../build-support/rust/fetchcrate.nix { };

  fetchFromGitea = callPackage ../build-support/fetchgitea { };

  fetchFromGitHub = callPackage ../build-support/fetchgithub { };

  fetchFromBitbucket = callPackage ../build-support/fetchbitbucket { };

  fetchFromSavannah = callPackage ../build-support/fetchsavannah { };

  fetchFromSourcehut = callPackage ../build-support/fetchsourcehut { };

  fetchFromGitLab = callPackage ../build-support/fetchgitlab { };

  fetchFromGitiles = callPackage ../build-support/fetchgitiles { };

  fetchFrom9Front = callPackage ../build-support/fetch9front { };

  fetchFromRepoOrCz = callPackage ../build-support/fetchrepoorcz { };

  fetchFromRadicle = callPackage ../build-support/fetchradicle { };
  fetchRadiclePatch = callPackage ../build-support/fetchradiclepatch { };

  fetchgx = callPackage ../build-support/fetchgx { };

  fetchPypi = callPackage ../build-support/fetchpypi { };

  fetchPypiLegacy = callPackage ../build-support/fetchpypilegacy { };

  resolveMirrorURLs =
    { url }:
    fetchurl {
      showURLs = true;
      inherit url;
    };

  ld-is-cc-hook = makeSetupHook {
    name = "ld-is-cc-hook";
  } ../build-support/setup-hooks/ld-is-cc-hook.sh;

  copyDesktopItems = makeSetupHook {
    name = "copy-desktop-items-hook";
  } ../build-support/setup-hooks/copy-desktop-items.sh;

  makeDesktopItem = callPackage ../build-support/make-desktopitem { };

  copyPkgconfigItems = makeSetupHook {
    name = "copy-pkg-config-items-hook";
  } ../build-support/setup-hooks/copy-pkgconfig-items.sh;

  makePkgconfigItem = callPackage ../build-support/make-pkgconfigitem { };

  makeDarwinBundle = callPackage ../build-support/make-darwin-bundle { };

  makeAutostartItem = callPackage ../build-support/make-startupitem { };

  makeImpureTest = callPackage ../build-support/make-impure-test.nix;

  makeInitrd = callPackage ../build-support/kernel/make-initrd.nix; # Args intentionally left out

  makeInitrdNG = callPackage ../build-support/kernel/make-initrd-ng.nix;
  makeInitrdNGTool = callPackage ../build-support/kernel/make-initrd-ng-tool.nix { };

  makeWrapper = makeShellWrapper;

  makeShellWrapper = makeSetupHook {
    name = "make-shell-wrapper-hook";
    propagatedBuildInputs = [ dieHook ];
    substitutions = {
      # targetPackages.runtimeShell only exists when pkgs == targetPackages (when targetPackages is not  __raw)
      shell =
        if targetPackages ? runtimeShell then
          targetPackages.runtimeShell
        else
          throw "makeWrapper/makeShellWrapper must be in nativeBuildInputs";
    };
    passthru = {
      tests = tests.makeWrapper;
    };
  } ../build-support/setup-hooks/make-wrapper.sh;

  compressFirmwareXz = callPackage ../build-support/kernel/compress-firmware.nix { type = "xz"; };

  compressFirmwareZstd = callPackage ../build-support/kernel/compress-firmware.nix { type = "zstd"; };

  makeModulesClosure =
    {
      kernel,
      firmware,
      rootModules,
      allowMissing ? false,
      extraFirmwarePaths ? [ ],
    }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit
        kernel
        firmware
        rootModules
        allowMissing
        extraFirmwarePaths
        ;
    };

  mkBinaryCache = callPackage ../build-support/binary-cache { };

  mkShell = callPackage ../build-support/mkshell { };
  mkShellNoCC = mkShell.override { stdenv = stdenvNoCC; };

  mpsolve = libsForQt5.callPackage ../applications/science/math/mpsolve { };

  nixBufferBuilders = import ../applications/editors/emacs/build-support/buffer.nix {
    inherit lib writeText;
    inherit (emacs.pkgs) inherit-local;
  };

  nix-gitignore = callPackage ../build-support/nix-gitignore { };

  ociTools = callPackage ../build-support/oci-tools { };

  inherit (callPackages ../build-support/setup-hooks/patch-rc-path-hooks { })
    patchRcPathBash
    patchRcPathCsh
    patchRcPathFish
    patchRcPathPosix
    ;

  pruneLibtoolFiles = makeSetupHook {
    name = "prune-libtool-files";
  } ../build-support/setup-hooks/prune-libtool-files.sh;

  closureInfo = callPackage ../build-support/closure-info.nix { };

  serverspec = callPackage ../tools/misc/serverspec { };

  setupSystemdUnits = callPackage ../build-support/setup-systemd-units.nix { };

  shortenPerlShebang = makeSetupHook {
    name = "shorten-perl-shebang-hook";
    propagatedBuildInputs = [ dieHook ];
  } ../build-support/setup-hooks/shorten-perl-shebang.sh;

  sile = callPackage ../by-name/si/sile/package.nix {
    lua = luajit;
  };

  singularity-tools = callPackage ../build-support/singularity-tools { };

  srcOnly = callPackage ../build-support/src-only { };

  substitute = callPackage ../build-support/substitute/substitute.nix { };

  substituteAll = callPackage ../build-support/substitute/substitute-all.nix { };

  substituteAllFiles = callPackage ../build-support/substitute-files/substitute-all-files.nix { };

  replaceDependencies = callPackage ../build-support/replace-dependencies.nix { };

  replaceDependency =
    {
      drv,
      oldDependency,
      newDependency,
      verbose ? true,
    }:
    replaceDependencies {
      inherit drv verbose;
      replacements = [
        {
          inherit oldDependency newDependency;
        }
      ];
      # When newDependency depends on drv, instead of causing infinite recursion, keep it as is.
      cutoffPackages = [ newDependency ];
    };

  replaceVarsWith = callPackage ../build-support/replace-vars/replace-vars-with.nix { };

  replaceVars = callPackage ../build-support/replace-vars/replace-vars.nix { };

  replaceDirectDependencies = callPackage ../build-support/replace-direct-dependencies.nix { };

  nukeReferences = callPackage ../build-support/nuke-references {
    inherit (darwin) signingUtils;
  };

  referencesByPopularity = callPackage ../build-support/references-by-popularity { };

  dockerMakeLayers = callPackage ../build-support/docker/make-layers.nix { };

  removeReferencesTo = callPackage ../build-support/remove-references-to {
    inherit (darwin) signingUtils;
  };

  # No callPackage.  In particular, we don't want `img` *package* in parameters.
  vmTools = makeOverridable (import ../build-support/vm) { inherit pkgs lib; };

  releaseTools = callPackage ../build-support/release { };

  inherit (lib.systems) platforms;

  setJavaClassPath = makeSetupHook {
    name = "set-java-classpath-hook";
  } ../build-support/setup-hooks/set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook {
    name = "fix-darwin-dylib-names-hook";
    substitutions = { inherit (darwin.binutils) targetPrefix; };
    meta.platforms = lib.platforms.darwin;
  } ../build-support/setup-hooks/fix-darwin-dylib-names.sh;

  writeDarwinBundle = callPackage ../build-support/make-darwin-bundle/write-darwin-bundle.nix { };

  desktopToDarwinBundle = makeSetupHook {
    name = "desktop-to-darwin-bundle-hook";
    propagatedBuildInputs = [
      writeDarwinBundle
      librsvg
      imagemagick
      (onlyBin python3Packages.icnsutil)
    ];
  } ../build-support/setup-hooks/desktop-to-darwin-bundle.sh;

  keepBuildTree = makeSetupHook {
    name = "keep-build-tree-hook";
  } ../build-support/setup-hooks/keep-build-tree.sh;

  moveBuildTree = makeSetupHook {
    name = "move-build-tree-hook";
  } ../build-support/setup-hooks/move-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook {
    name = "enable-gcov-instrumentation-hook";
  } ../build-support/setup-hooks/enable-coverage-instrumentation.sh;

  makeGCOVReport = makeSetupHook {
    name = "make-gcov-report-hook";
    propagatedBuildInputs = [
      lcov
      enableGCOVInstrumentation
    ];
  } ../build-support/setup-hooks/make-coverage-analysis-report.sh;

  makeHardcodeGsettingsPatch = callPackage ../build-support/make-hardcode-gsettings-patch { };

  # intended to be used like nix-build -E 'with import <nixpkgs> { }; enableDebugging fooPackage'
  enableDebugging = pkg: pkg.override { stdenv = stdenvAdapters.keepDebugInfo pkg.stdenv; };

  findXMLCatalogs = makeSetupHook {
    name = "find-xml-catalogs-hook";
  } ../build-support/setup-hooks/find-xml-catalogs.sh;

  wrapGAppsHook3 = wrapGAppsNoGuiHook.override {
    isGraphical = true;
  };

  wrapGAppsHook4 = wrapGAppsNoGuiHook.override {
    isGraphical = true;
    gtk3 = __splicedPackages.gtk4;
  };

  wrapGAppsNoGuiHook = callPackage ../build-support/setup-hooks/wrap-gapps-hook {
    makeWrapper = makeBinaryWrapper;
  };

  separateDebugInfo = makeSetupHook {
    name = "separate-debug-info-hook";
  } ../build-support/setup-hooks/separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook {
    name = "setup-debug-info-dirs-hook";
  } ../build-support/setup-hooks/setup-debug-info-dirs.sh;

  writableTmpDirAsHomeHook = callPackage (
    { makeSetupHook }:
    makeSetupHook {
      name = "writable-tmpdir-as-home-hook";
    } ../build-support/setup-hooks/writable-tmpdir-as-home.sh
  ) { };

  useOldCXXAbi = makeSetupHook {
    name = "use-old-cxx-abi-hook";
  } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  validatePkgConfig = makeSetupHook {
    name = "validate-pkg-config";
    propagatedBuildInputs = [
      findutils
      pkg-config
    ];
  } ../build-support/setup-hooks/validate-pkg-config.sh;

  #package writers
  writers = callPackage ../build-support/writers { };

  # lib functions depending on pkgs
  inherit
    (import ../pkgs-lib {
      # The `lib` variable in this scope doesn't include any applied lib overlays,
      # `pkgs.lib` does.
      inherit (pkgs) lib;
      inherit pkgs;
    })
    formats
    ;

  testers = callPackage ../build-support/testers { };

  ### TOOLS

  _3llo = callPackage ../tools/misc/3llo { };

  _7zz-rar = _7zz.override { enableUnfree = true; };

  acquire = with python3Packages; toPythonApplication acquire;

  actdiag = with python3.pkgs; toPythonApplication actdiag;

  opnplug = adlplug.override { type = "OPN"; };

  akkoma = callPackage ../by-name/ak/akkoma/package.nix {
    beamPackages = beam_minimal.packages.erlang_26.extend (
      self: super: {
        elixir = self.elixir_1_16;
        rebar3 = self.rebar3WithPlugins {
          plugins = with self; [ pc ];
        };
      }
    );
  };

  akkoma-admin-fe = callPackage ../by-name/ak/akkoma-admin-fe/package.nix {
    python3 = python311;
  };

  aegisub = callPackage ../by-name/ae/aegisub/package.nix (
    {
      luajit = luajit.override { enable52Compat = true; };
    }
    // (config.aegisub or { })
  );

  acme-client = callPackage ../tools/networking/acme-client {
    stdenv = gccStdenv;
  };

  aflplusplus = callPackage ../tools/security/aflplusplus { wine = null; };

  libdislocator = callPackage ../tools/security/aflplusplus/libdislocator.nix { };

  aioblescan = with python3Packages; toPythonApplication aioblescan;

  inherit (recurseIntoAttrs (callPackage ../tools/package-management/akku { }))
    akku
    akkuPackages
    ;

  alice-tools = callPackage ../tools/games/alice-tools {
    withGUI = false;
  };

  alice-tools-qt5 = libsForQt5.callPackage ../tools/games/alice-tools { };

  alice-tools-qt6 = qt6Packages.callPackage ../tools/games/alice-tools { };

  auditwheel = with python3Packages; toPythonApplication auditwheel;

  davinci-resolve-studio = callPackage ../by-name/da/davinci-resolve/package.nix {
    studioVariant = true;
  };

  dehinter = with python3Packages; toPythonApplication dehinter;

  gamemode = callPackage ../tools/games/gamemode {
    libgamemode32 = pkgsi686Linux.gamemode.lib;
  };

  gamescope = callPackage ../by-name/ga/gamescope/package.nix {
    enableExecutable = true;
    enableWsi = false;

    wlroots = wlroots_0_17;
  };

  gamescope-wsi = callPackage ../by-name/ga/gamescope/package.nix {
    enableExecutable = false;
    enableWsi = true;

    wlroots = wlroots_0_17;
  };

  font-v = with python3Packages; toPythonApplication font-v;

  fontbakery = with python3Packages; toPythonApplication fontbakery;

  genealogos-api = genealogos-cli.override {
    crate = "api";
  };

  # This is to workaround gfal2-python broken against Python 3.12 or later.
  # TODO: Remove these lines after solving the breakage.
  gfal2-util = callPackage ../by-name/gf/gfal2-util/package.nix (
    lib.optionalAttrs python3Packages.gfal2-python.meta.broken {
      python3Packages = python311Packages;
    }
  );

  gp-saml-gui = python3Packages.callPackage ../tools/networking/gp-saml-gui { };

  fwbuilder = libsForQt5.callPackage ../tools/security/fwbuilder { };

  inherit (callPackages ../tools/networking/ivpn/default.nix { })
    ivpn
    ivpn-service
    ;

  kanata-with-cmd = kanata.override { withCmd = true; };

  ksnip = libsForQt5.callPackage ../tools/misc/ksnip { };

  linux-router-without-wifi = linux-router.override { useWifiDependencies = false; };

  makehuman = libsForQt5.callPackage ../applications/misc/makehuman { };

  mcaselector = callPackage ../tools/games/minecraft/mcaselector {
    jre = jre.override {
      enableJavaFX = true;
    };
  };

  mkosi = python3Packages.callPackage ../tools/virtualization/mkosi { inherit systemd; };

  mkosi-full = mkosi.override { withQemu = true; };

  mpremote = python3Packages.callPackage ../tools/misc/mpremote { };

  mpy-utils = python3Packages.callPackage ../tools/misc/mpy-utils { };

  networkd-notify = python3Packages.callPackage ../tools/networking/networkd-notify {
    systemd = pkgs.systemd;
  };

  ocs-url = libsForQt5.callPackage ../tools/misc/ocs-url { };

  openbugs = pkgsi686Linux.callPackage ../applications/science/machine-learning/openbugs { };

  openusd = python3Packages.openusd.override {
    withTools = true;
    withUsdView = true;
  };

  pricehist = python3Packages.callPackage ../tools/misc/pricehist { };

  py7zr = with python3Packages; toPythonApplication py7zr;

  q = callPackage ../tools/networking/q { };

  qFlipper = libsForQt5.callPackage ../tools/misc/qflipper { };

  ronin = callPackage ../tools/security/ronin { };

  inherit (callPackage ../development/libraries/sdbus-cpp { }) sdbus-cpp sdbus-cpp_2;

  sdkmanager = with python3Packages; toPythonApplication sdkmanager;

  shaperglot = with python3Packages; toPythonApplication shaperglot;

  slipstream = callPackage ../tools/games/slipstream {
    jdk = jdk8;
  };

  supermin = callPackage ../tools/virtualization/supermin {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  ufolint = with python3Packages; toPythonApplication ufolint;

  valeronoi = qt6Packages.callPackage ../tools/misc/valeronoi { };

  veikk-linux-driver-gui = libsForQt5.callPackage ../tools/misc/veikk-linux-driver-gui { };

  ventoy-full = ventoy.override {
    withCryptsetup = true;
    withXfs = true;
    withExt4 = true;
    withNtfs = true;
  };

  ventoy-full-gtk = ventoy-full.override {
    defaultGuiType = "gtk3";
  };

  ventoy-full-qt = ventoy-full.override {
    defaultGuiType = "qt5";
  };

  vprof = with python3Packages; toPythonApplication vprof;

  winbox = winbox3;
  winbox3 = callPackage ../tools/admin/winbox {
    wine = wineWowPackages.stable;
  };

  x2t = callPackage ../by-name/x2/x2t/package.nix {
    openssl = openssl.override {
      enableMD2 = true;
      static = true;
    };
  };

  yabridge = callPackage ../tools/audio/yabridge {
    wine = wineWowPackages.yabridge;
  };

  yabridgectl = callPackage ../tools/audio/yabridgectl {
    wine = wineWowPackages.yabridge;
  };

  yafetch = callPackage ../tools/misc/yafetch {
    stdenv = clangStdenv;
  };

  ### APPLICATIONS/VERSION-MANAGEMENT

  git = callPackage ../applications/version-management/git {
    perlLibs = [
      perlPackages.LWP
      perlPackages.URI
      perlPackages.TermReadKey
    ];
    smtpPerlLibs = [
      perlPackages.libnet
      perlPackages.NetSMTPSSL
      perlPackages.IOSocketSSL
      perlPackages.NetSSLeay
      perlPackages.AuthenSASL
      perlPackages.DigestHMAC
    ];
  };

  # The full-featured Git.
  gitFull = git.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = true;
    withSsh = true;
    withLibsecret = !stdenv.hostPlatform.isDarwin;
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (git.override { svnSupport = true; });

  git-doc = lib.addMetaAttrs {
    description = "Additional documentation for Git";
    longDescription = ''
      This package contains additional documentation (HTML and text files) that
      is referenced in the man pages of Git.
    '';
  } gitFull.doc;

  gitMinimal = git.override {
    withManual = false;
    osxkeychainSupport = false;
    pythonSupport = false;
    perlSupport = false;
    withpcre2 = false;
  };

  bitbucket-server-cli = callPackage ../applications/version-management/bitbucket-server-cli { };

  bump2version = with python3Packages; toPythonApplication bump2version;

  cgit = callPackage ../applications/version-management/cgit { };

  cgit-pink = callPackage ../applications/version-management/cgit/pink.nix { };

  commitlint = nodePackages."@commitlint/cli";

  datalad = with python3Packages; toPythonApplication datalad;

  datalad-gooey = with python3Packages; toPythonApplication datalad-gooey;

  forgejo-lts = callPackage ../by-name/fo/forgejo/lts.nix { };

  gita = python3Packages.callPackage ../applications/version-management/gita { };

  github-cli = gh;

  git-annex-metadata-gui =
    libsForQt5.callPackage ../applications/version-management/git-annex-metadata-gui
      {
        inherit (python3Packages) buildPythonApplication pyqt5 git-annex-adapter;
      };

  git-annex-remote-dbx = callPackage ../applications/version-management/git-annex-remote-dbx {
    inherit (python3Packages)
      buildPythonApplication
      dropbox
      annexremote
      humanfriendly
      ;
  };

  git-annex-remote-googledrive =
    python3Packages.callPackage ../applications/version-management/git-annex-remote-googledrive
      { };

  git-archive-all = python3.pkgs.callPackage ../applications/version-management/git-archive-all { };

  git-credential-manager = callPackage ../applications/version-management/git-credential-manager { };

  git-imerge = python3Packages.callPackage ../applications/version-management/git-imerge { };

  git-machete = python3Packages.callPackage ../applications/version-management/git-machete { };

  git-publish = python3Packages.callPackage ../applications/version-management/git-publish { };

  git-recent = callPackage ../applications/version-management/git-recent {
    util-linux = if stdenv.hostPlatform.isLinux then util-linuxMinimal else util-linux;
  };

  gitRepo = git-repo;
  git-repo-updater =
    python3Packages.callPackage ../applications/version-management/git-repo-updater
      { };

  git-review = python3Packages.callPackage ../applications/version-management/git-review { };

  gittyup = libsForQt5.callPackage ../applications/version-management/gittyup { };

  merge-fmt = callPackage ../applications/version-management/merge-fmt {
    inherit (ocamlPackages)
      buildDunePackage
      cmdliner
      base
      stdio
      ;
  };

  pass-git-helper =
    python3Packages.callPackage ../applications/version-management/pass-git-helper
      { };

  qgit = qt5.callPackage ../applications/version-management/qgit { };

  silver-platter = python3Packages.callPackage ../applications/version-management/silver-platter { };

  svn-all-fast-export =
    libsForQt5.callPackage ../applications/version-management/svn-all-fast-export
      { };

  svn2git = callPackage ../applications/version-management/svn2git {
    git = gitSVN;
  };

  inherit (haskellPackages) git-annex;

  inherit (haskellPackages) git-brunch;

  git-autofixup = perlPackages.GitAutofixup;

  ghrepo-stats = with python3Packages; toPythonApplication ghrepo-stats;

  git-filter-repo = with python3Packages; toPythonApplication git-filter-repo;

  git-revise = with python3Packages; toPythonApplication git-revise;

  ### APPLICATIONS/EMULATORS

  _86Box-with-roms = _86Box.override {
    unfreeEnableRoms = true;
    unfreeEnableDiscord = true;
  };

  box64 = callPackage ../applications/emulators/box64 {
    hello-x86_64 = if stdenv.hostPlatform.isx86_64 then hello else pkgsCross.gnu64.hello;
  };

  box86 =
    let
      args = {
        hello-x86_32 = if stdenv.hostPlatform.isx86_32 then hello else pkgsCross.gnu32.hello;
      };
    in
    if stdenv.hostPlatform.is32bit then
      callPackage ../applications/emulators/box86 args
    else if stdenv.hostPlatform.isx86_64 then
      pkgsCross.gnu32.callPackage ../applications/emulators/box86 args
    else if stdenv.hostPlatform.isAarch64 then
      pkgsCross.armv7l-hf-multiplatform.callPackage ../applications/emulators/box86 args
    else
      throw "Don't know 32-bit platform for cross from: ${stdenv.hostPlatform.stdenv}";

  cdemu-client = callPackage ../applications/emulators/cdemu/client.nix { };

  cdemu-daemon = callPackage ../applications/emulators/cdemu/daemon.nix { };

  dosbox = callPackage ../applications/emulators/dosbox {
    SDL = if stdenv.hostPlatform.isDarwin then SDL else SDL_compat;
  };

  fceux-qt5 = fceux.override { ___qtVersion = "5"; };
  fceux-qt6 = fceux.override { ___qtVersion = "6"; };

  firebird-emu = libsForQt5.callPackage ../applications/emulators/firebird-emu { };

  fusesoc = python3Packages.callPackage ../tools/package-management/fusesoc { };

  gcdemu = callPackage ../applications/emulators/cdemu/gui.nix { };

  gensgs = pkgsi686Linux.callPackage ../applications/emulators/gens-gs { };

  goldberg-emu = callPackage ../applications/emulators/goldberg-emu {
    protobuf = protobuf_21;
  };

  image-analyzer = callPackage ../applications/emulators/cdemu/analyzer.nix { };

  kega-fusion = pkgsi686Linux.callPackage ../applications/emulators/kega-fusion { };

  libmirage = callPackage ../applications/emulators/cdemu/libmirage.nix { };

  mame = libsForQt5.callPackage ../applications/emulators/mame { };

  mame-tools = lib.addMetaAttrs {
    description = mame.meta.description + " (tools only)";
  } (lib.getOutput "tools" mame);

  ppsspp-sdl =
    let
      argset = {
        enableQt = false;
        enableVulkan = true;
        forceWayland = false;
      };
    in
    ppsspp.override argset;

  ppsspp-sdl-wayland =
    let
      argset = {
        enableQt = false;
        enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/13845
        forceWayland = true;
      };
    in
    ppsspp.override argset;

  ppsspp-qt =
    let
      argset = {
        enableQt = true;
        enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/11628
        forceWayland = false;
      };
    in
    ppsspp.override argset;

  punes = libsForQt5.callPackage ../applications/emulators/punes { };

  punes-qt6 = qt6Packages.callPackage ../applications/emulators/punes { };

  py65 = with python3.pkgs; toPythonApplication py65;

  rmg-wayland = callPackage ../by-name/rm/rmg/package.nix {
    withWayland = true;
  };

  shadps4 = callPackage ../by-name/sh/shadps4/package.nix {
    # relies on std::sinf & co, which was broken in GCC until GCC 14: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79700
    stdenv = gcc14Stdenv;
  };

  snes9x-gtk = snes9x.override {
    withGtk = true;
  };

  winetricks = callPackage ../applications/emulators/wine/winetricks.nix { };

  zsnes = pkgsi686Linux.callPackage ../applications/emulators/zsnes { };
  zsnes2 = pkgsi686Linux.callPackage ../applications/emulators/zsnes/2.x.nix { };

  ### APPLICATIONS/EMULATORS/RETROARCH

  libretro = recurseIntoAttrs (callPackage ../applications/emulators/libretro { });

  retroarch = wrapRetroArch { };

  # includes only cores for platform with free licenses
  retroarch-free = retroarch.withCores (
    cores:
    lib.filter (
      c: (c ? libretroCore) && (lib.meta.availableOn stdenv.hostPlatform c) && (!c.meta.unfree)
    ) (lib.attrValues cores)
  );

  # includes all cores for platform (including ones with non-free licenses)
  retroarch-full = retroarch.withCores (
    cores:
    lib.filter (c: (c ? libretroCore) && (lib.meta.availableOn stdenv.hostPlatform c)) (
      lib.attrValues cores
    )
  );

  wrapRetroArch = retroarch-bare.wrapper;

  # Aliases kept here because they are easier to use
  x16-emulator = x16.emulator;
  x16-rom = x16.rom;
  x16-run = x16.run;

  yabause = libsForQt5.callPackage ../applications/emulators/yabause {
    libglut = null;
    openal = null;
  };

  ### APPLICATIONS/FILE-MANAGERS

  doublecmd = callPackage ../by-name/do/doublecmd/package.nix {
    inherit (libsForQt5) libqtpas wrapQtAppsHook;
  };

  vifm-full = vifm.override {
    mediaSupport = true;
    inherit lib udisks2 python3;
  };

  xfe = callPackage ../by-name/xf/xfe/package.nix {
    fox = fox_1_6;
  };

  johnny-reborn-engine = callPackage ../applications/misc/johnny-reborn { };

  johnny-reborn = callPackage ../applications/misc/johnny-reborn/with-data.nix { };

  ### APPLICATIONS/TERMINAL-EMULATORS

  contour = callPackage ../by-name/co/contour/package.nix {
    inherit (darwin) libutil sigtool;
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_17.stdenv else stdenv;
  };

  cool-retro-term = libsForQt5.callPackage ../applications/terminal-emulators/cool-retro-term { };

  kitty = callPackage ../by-name/ki/kitty/package.nix {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.hostPlatform.isDarwin; };
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  mlterm-wayland = mlterm.override {
    enableX11 = false;
  };

  rxvt-unicode = callPackage ../applications/terminal-emulators/rxvt-unicode/wrapper.nix { };

  rxvt-unicode-emoji = rxvt-unicode.override {
    rxvt-unicode-unwrapped = rxvt-unicode-unwrapped-emoji;
  };

  rxvt-unicode-plugins = import ../applications/terminal-emulators/rxvt-unicode-plugins {
    inherit callPackage;
  };

  rxvt-unicode-unwrapped = callPackage ../applications/terminal-emulators/rxvt-unicode { };

  rxvt-unicode-unwrapped-emoji = rxvt-unicode-unwrapped.override {
    emojiSupport = true;
  };

  st = callPackage ../applications/terminal-emulators/st {
    conf = config.st.conf or null;
    patches = config.st.patches or [ ];
    extraLibs = config.st.extraLibs or [ ];
  };
  xst = callPackage ../applications/terminal-emulators/st/xst.nix { };
  mcaimi-st = callPackage ../applications/terminal-emulators/st/mcaimi-st.nix { };

  termite = callPackage ../applications/terminal-emulators/termite/wrapper.nix {
    termite = termite-unwrapped;
  };
  termite-unwrapped = callPackage ../applications/terminal-emulators/termite { };

  twine = with python3Packages; toPythonApplication twine;

  inherit (callPackages ../development/tools/ammonite { })
    ammonite_2_12
    ammonite_2_13
    ammonite_3_3
    ;
  ammonite = ammonite_3_3;

  android-tools = lowPrio (callPackage ../tools/misc/android-tools { });

  angie = callPackage ../servers/http/angie {
    zlib-ng = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [
      nginxModules.rtmp
      nginxModules.dav
      nginxModules.moreheaders
    ];
  };

  angieQuic = callPackage ../servers/http/angie {
    zlib-ng = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    withQuic = true;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [
      nginxModules.rtmp
      nginxModules.dav
      nginxModules.moreheaders
    ];
    # Use latest quictls to allow http3 support
    openssl = quictls;
  };

  angie-console-light = callPackage ../servers/http/angie/console-light.nix { };

  apk-tools = callPackage ../tools/package-management/apk-tools {
    lua = lua5_3;
  };

  appimage-run = callPackage ../tools/package-management/appimage-run { };
  appimage-run-tests = callPackage ../tools/package-management/appimage-run/test.nix {
    appimage-run = appimage-run.override {
      appimage-run-tests = null; # break boostrap cycle for passthru.tests
    };
  };

  ArchiSteamFarm = callPackage ../applications/misc/ArchiSteamFarm { };

  arduino = arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/embedded/arduino/arduino-core/chrootenv.nix { };
  arduino-core-unwrapped = callPackage ../development/embedded/arduino/arduino-core { };

  apio = python3Packages.callPackage ../development/embedded/fpga/apio { };

  apitrace = libsForQt5.callPackage ../applications/graphics/apitrace { };

  arpack-mpi = arpack.override { useMpi = true; };

  asymptote = libsForQt5.callPackage ../tools/graphics/asymptote { };

  authelia = callPackage ../servers/authelia {
    buildGoModule = buildGo124Module;
    pnpm = pnpm_10;
  };

  authentik-outposts = recurseIntoAttrs (callPackages ../by-name/au/authentik/outposts.nix { });

  autoflake = with python3.pkgs; toPythonApplication autoflake;

  awsume = python3Packages.callPackage ../tools/admin/awsume { };

  aws-mfa = python3Packages.callPackage ../tools/admin/aws-mfa { };

  azure-cli-extensions = recurseIntoAttrs azure-cli.extensions;

  brakeman = callPackage ../development/tools/analysis/brakeman { };

  # Derivation's result is not used by nixpkgs. Useful for validation for
  # regressions of bootstrapTools on hydra and on ofborg. Example:
  #     pkgsCross.aarch64-multiplatform.freshBootstrapTools.build
  freshBootstrapTools =
    if stdenv.hostPlatform.isDarwin then
      callPackage ../stdenv/darwin/make-bootstrap-tools.nix {
        localSystem = stdenv.buildPlatform;
        crossSystem = if stdenv.buildPlatform == stdenv.hostPlatform then null else stdenv.hostPlatform;
      }
    else if stdenv.hostPlatform.isLinux then
      callPackage ../stdenv/linux/make-bootstrap-tools.nix { }
    else if stdenv.hostPlatform.isFreeBSD then
      callPackage ../stdenv/freebsd/make-bootstrap-tools.nix { }
    else
      throw "freshBootstrapTools: unknown hostPlatform ${stdenv.hostPlatform.config}";

  crystfel = callPackage ../applications/science/physics/crystfel { };

  crystfel-headless = callPackage ../applications/science/physics/crystfel { withGui = false; };

  amule-daemon = amule.override {
    monolithic = false;
    enableDaemon = true;
  };

  amule-gui = amule.override {
    monolithic = false;
    client = true;
  };

  amule-web = amule.override {
    monolithic = false;
    httpServer = true;
  };

  bashate = python3Packages.callPackage ../development/tools/bashate {
    python3Packages = python311Packages;
  };

  inherit (callPackages ../tools/security/bitwarden-directory-connector { })
    bitwarden-directory-connector-cli
    bitwarden-directory-connector
    ;

  bitwarden-menu = python3Packages.callPackage ../applications/misc/bitwarden-menu { };

  blocksat-cli = with python3Packages; toPythonApplication blocksat-cli;

  bucklespring = bucklespring-x11;
  bucklespring-libinput = callPackage ../applications/audio/bucklespring { };
  bucklespring-x11 = callPackage ../applications/audio/bucklespring { legacy = true; };

  buildbotPackages = recurseIntoAttrs (
    callPackage ../development/tools/continuous-integration/buildbot { }
  );
  inherit (buildbotPackages)
    buildbot
    buildbot-ui
    buildbot-full
    buildbot-plugins
    buildbot-worker
    ;

  certipy = with python3Packages; toPythonApplication certipy-ad;

  chipsec = callPackage ../tools/security/chipsec {
    kernel = null;
    withDriver = false;
  };

  fedora-backgrounds = callPackage ../data/misc/fedora-backgrounds { };

  coconut = with python3Packages; toPythonApplication coconut;

  coolreader = libsForQt5.callPackage ../applications/misc/coolreader { };

  corsair = with python3Packages; toPythonApplication corsair-scan;

  inherit (cue) writeCueValidator;

  cyclonedx-gomod = callPackage ../tools/security/cyclonedx-gomod {
    buildGoModule = buildGo123Module;
  };

  dazel = python3Packages.callPackage ../development/tools/dazel { };

  detect-secrets = with python3Packages; toPythonApplication detect-secrets;

  deterministic-host-uname = deterministic-uname.override {
    forPlatform = stdenv.targetPlatform; # offset by 1 so it works in nativeBuildInputs
  };

  dkimpy = with python3Packages; toPythonApplication dkimpy;

  esbuild = callPackage ../development/tools/esbuild { };

  esbuild_netlify = callPackage ../development/tools/esbuild/netlify.nix { };

  libfx2 = with python3Packages; toPythonApplication fx2;

  flirc = libsForQt5.callPackage ../applications/video/flirc {
    readline = readline70;
  };

  foxdot = with python3Packages; toPythonApplication foxdot;

  fluffychat-web = fluffychat.override { targetFlutterPlatform = "web"; };

  gammaray = qt6Packages.callPackage ../development/tools/gammaray { };

  gams = callPackage ../tools/misc/gams (config.gams or { });

  gancioPlugins = recurseIntoAttrs (
    callPackage ../by-name/ga/gancio/plugins.nix { inherit (gancio) nodejs; }
  );

  github-changelog-generator = callPackage ../development/tools/github-changelog-generator { };

  github-to-sqlite = with python3Packages; toPythonApplication github-to-sqlite;

  gistyc = with python3Packages; toPythonApplication gistyc;

  glances = python3Packages.callPackage ../applications/system/glances { };

  glaxnimate = libsForQt5.callPackage ../applications/video/glaxnimate { };

  go2tv-lite = go2tv.override { withGui = false; };

  guglielmo = libsForQt5.callPackage ../applications/radio/guglielmo { };

  grc = python3Packages.callPackage ../tools/misc/grc { };

  gremlin-console = callPackage ../applications/misc/gremlin-console {
    openjdk = openjdk11;
  };

  gremlin-server = callPackage ../applications/misc/gremlin-server {
    openjdk = openjdk11;
  };

  hinit = haskell.lib.compose.justStaticExecutables haskellPackages.hinit;

  hwi = with python3Packages; toPythonApplication hwi;

  kavita = callPackage ../servers/web-apps/kavita { };

  livebook = callPackage ../by-name/li/livebook/package.nix {
    elixir = elixir_1_17;
    beamPackages = beamPackages.extend (self: super: { elixir = elixir_1_17; });
  };

  pass = callPackage ../tools/security/pass { };

  pass-nodmenu = callPackage ../tools/security/pass {
    dmenuSupport = false;
    pass = pass-nodmenu;
  };

  pass-wayland = callPackage ../tools/security/pass {
    waylandSupport = true;
    pass = pass-wayland;
  };

  passExtensions = recurseIntoAttrs pass.extensions;

  gopass = callPackage ../tools/security/gopass { };

  gopass-hibp = callPackage ../tools/security/gopass/hibp.nix { };

  git-credential-gopass = callPackage ../tools/security/gopass/git-credential.nix { };

  gopass-summon-provider = callPackage ../tools/security/gopass/summon.nix { };

  kerf = kerf_1; # kerf2 is WIP
  kerf_1 = callPackage ../development/interpreters/kerf {
    stdenv = clangStdenv;
  };

  kjv = callPackage ../applications/misc/kjv { };

  lukesmithxyz-bible-kjv = callPackage ../applications/misc/kjv/lukesmithxyz-kjv.nix { };

  plausible = callPackage ../servers/web-apps/plausible {
    elixir = elixir_1_17;
    beamPackages = beamPackages.extend (self: super: { elixir = elixir_1_17; });
  };

  reattach-to-user-namespace = callPackage ../os-specific/darwin/reattach-to-user-namespace { };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  gomobile = callPackage ../development/mobile/gomobile { };

  adb-sync = callPackage ../development/mobile/adb-sync {
    inherit (androidenv.androidPkgs) platform-tools;
  };

  androidenv = callPackage ../development/mobile/androidenv { };

  androidndkPkgs = androidndkPkgs_26;
  androidndkPkgs_21 = (callPackage ../development/androidndk-pkgs { })."21";
  androidndkPkgs_23 = (callPackage ../development/androidndk-pkgs { })."23";
  androidndkPkgs_24 = (callPackage ../development/androidndk-pkgs { })."24";
  androidndkPkgs_25 = (callPackage ../development/androidndk-pkgs { })."25";
  androidndkPkgs_26 = (callPackage ../development/androidndk-pkgs { })."26";

  androidsdk = androidenv.androidPkgs.androidsdk;

  webos = recurseIntoAttrs {
    cmake-modules = callPackage ../development/mobile/webos/cmake-modules.nix { };

    novacom = callPackage ../development/mobile/webos/novacom.nix { };
    novacomd = callPackage ../development/mobile/webos/novacomd.nix { };
  };

  apprise = with python3Packages; toPythonApplication apprise;

  asmrepl = callPackage ../development/interpreters/asmrepl { };

  avahi = callPackage ../development/libraries/avahi { };

  avahi-compat = callPackage ../development/libraries/avahi {
    withLibdnssdCompat = true;
  };

  axel = callPackage ../tools/networking/axel {
    libssl = openssl;
  };

  base16-builder = callPackage ../misc/base16-builder { };

  babelfish = callPackage ../shells/fish/babelfish.nix { };

  bat-extras = recurseIntoAttrs (lib.makeScope newScope (callPackage ../tools/misc/bat-extras { }));

  beauty-line-icon-theme = callPackage ../data/icons/beauty-line-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  beautysh = with python3.pkgs; toPythonApplication beautysh;

  inherit (callPackages ../misc/logging/beats/7.x.nix { })
    auditbeat7
    filebeat7
    heartbeat7
    metricbeat7
    packetbeat7
    ;

  auditbeat = auditbeat7;
  filebeat = filebeat7;
  heartbeat = heartbeat7;
  metricbeat = metricbeat7;
  packetbeat = packetbeat7;

  biliass = with python3.pkgs; toPythonApplication biliass;

  birdtray = libsForQt5.callPackage ../applications/misc/birdtray { };

  charles = charles5;
  inherit (callPackages ../applications/networking/charles { })
    charles3
    charles4
    charles5
    ;

  quaternion-qt6 =
    qt6Packages.callPackage ../applications/networking/instant-messengers/quaternion
      { };
  quaternion = quaternion-qt6;

  tensor = libsForQt5.callPackage ../applications/networking/instant-messengers/tensor { };

  libtensorflow = python3.pkgs.tensorflow-build.libtensorflow;

  libtorch-bin = callPackage ../development/libraries/science/math/libtorch/bin.nix { };

  behave = with python3Packages; toPythonApplication behave;

  blockdiag = with python3Packages; toPythonApplication blockdiag;

  bookstack = callPackage ../servers/web-apps/bookstack { };

  boomerang = libsForQt5.callPackage ../development/tools/boomerang { };

  bozohttpd-minimal = bozohttpd.override { minimal = true; };

  brasero-unwrapped = callPackage ../tools/cd-dvd/brasero { };

  brasero = callPackage ../tools/cd-dvd/brasero/wrapper.nix { };

  btlejack = python3Packages.callPackage ../applications/radio/btlejack { };

  bsh = fetchurl {
    url = "http://www.beanshell.org/bsh-2.0b5.jar";
    hash = "sha256-YjIZlWOAc1SzvLWs6z3BNlAvAixrDvdDmHqD9m/uWlw=";
  };

  buildah = callPackage ../development/tools/buildah/wrapper.nix { };
  buildah-unwrapped = callPackage ../development/tools/buildah { };

  cabal2nix-unwrapped = haskell.lib.compose.justStaticExecutables (
    haskellPackages.generateOptparseApplicativeCompletions [ "cabal2nix" ] haskellPackages.cabal2nix
  );

  cabal2nix = symlinkJoin {
    inherit (cabal2nix-unwrapped) name meta;
    nativeBuildInputs = [ buildPackages.makeWrapper ];
    paths = [ cabal2nix-unwrapped ];
    postBuild = ''
      wrapProgram $out/bin/cabal2nix \
        --prefix PATH ":" "${
          lib.makeBinPath [
            nix
            nix-prefetch-scripts
          ]
        }"
    '';
  };

  stack2nix =
    with haskell.lib;
    overrideCabal (justStaticExecutables haskellPackages.stack2nix) (_: {
      executableToolDepends = [ makeWrapper ];
      postInstall = ''
        wrapProgram $out/bin/stack2nix \
          --prefix PATH ":" "${git}/bin:${cabal-install}/bin"
      '';
    });

  calamares = libsForQt5.callPackage ../tools/misc/calamares {
    boost = boost.override {
      enablePython = true;
      python = python3;
    };
  };
  calamares-nixos = lowPrio (calamares.override { nixos-extensions = true; });
  candle = libsForQt5.callPackage ../applications/misc/candle { };

  capstone = callPackage ../development/libraries/capstone { };
  capstone_4 = callPackage ../development/libraries/capstone/4.nix { };

  cataract = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  catch2 = callPackage ../development/libraries/catch2 { };

  catch2_3 = callPackage ../development/libraries/catch2/3.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    gflags = null; # only required for examples/tests
  };

  cedille = callPackage ../applications/science/logic/cedille {
    inherit (haskellPackages)
      alex
      happy
      Agda
      ghcWithPackages
      ;
  };

  clevercsv = with python3Packages; toPythonApplication clevercsv;

  cleanit = with python3Packages; toPythonApplication cleanit;

  clickgen = with python3Packages; toPythonApplication clickgen;

  cloud-init = callPackage ../tools/virtualization/cloud-init { inherit systemd; };

  clingo = callPackage ../applications/science/logic/potassco/clingo.nix { };

  clingcon = callPackage ../applications/science/logic/potassco/clingcon.nix { };

  coloredlogs = with python3Packages; toPythonApplication coloredlogs;

  czkawka-full = czkawka.wrapper.override {
    extraPackages = [ ffmpeg ];
  };

  commitizen = with python3Packages; toPythonApplication commitizen;

  compactor = callPackage ../applications/networking/compactor {
    protobuf = protobuf_21;
  };

  inherit (callPackages ../tools/misc/coreboot-utils { })
    msrtool
    cbmem
    ifdtool
    intelmetool
    cbfstool
    nvramtool
    superiotool
    ectool
    inteltool
    amdfwtool
    acpidump-all
    coreboot-utils
    ;

  coreboot-configurator = libsForQt5.callPackage ../tools/misc/coreboot-configurator { };

  sway-unwrapped = callPackage ../by-name/sw/sway-unwrapped/package.nix {
    wlroots = wlroots_0_18;
  };

  cambrinary = python3Packages.callPackage ../applications/misc/cambrinary { };

  cplex = callPackage ../applications/science/math/cplex (config.cplex or { });

  cot = with python3Packages; toPythonApplication cot;

  crossplane = with python3Packages; toPythonApplication crossplane;

  csv2md = with python3Packages; toPythonApplication csv2md;

  csvtool = callPackage ../development/ocaml-modules/csv/csvtool.nix { };

  dataclass-wizard = with python3Packages; toPythonApplication dataclass-wizard;

  datasette = with python3Packages; toPythonApplication datasette;

  datovka = libsForQt5.callPackage ../applications/networking/datovka { };

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialogbox = libsForQt5.callPackage ../tools/misc/dialogbox { };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  h = callPackage ../tools/misc/h { };

  discourse = callPackage ../servers/web-apps/discourse { };

  discourseAllPlugins = discourse.override {
    plugins = lib.filter (p: p ? pluginName) (builtins.attrValues discourse.plugins);
  };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dino = callPackage ../applications/networking/instant-messengers/dino {
    inherit (gst_all_1)
      gstreamer
      gst-plugins-base
      gst-plugins-bad
      gst-vaapi
      ;
    gst-plugins-good = gst_all_1.gst-plugins-good.override { gtkSupport = true; };
  };

  dnschef = python3Packages.callPackage ../tools/networking/dnschef { };

  inherit (ocamlPackages) dot-merlin-reader;

  inherit (ocaml-ng.ocamlPackages_4_10) dune_1;
  inherit (ocamlPackages) dune_2 dune_3 dune-release;

  dvc = with python3.pkgs; toPythonApplication dvc;

  dvc-with-remotes = dvc.override {
    enableGoogle = true;
    enableAWS = true;
    enableAzure = true;
    enableSSH = true;
  };

  easyaudiosync = qt6Packages.callPackage ../applications/audio/easyaudiosync { };

  easycrypt = callPackage ../applications/science/logic/easycrypt {
    why3 = pkgs.why3.override {
      ideSupport = false;
      coqPackages = {
        coq = null;
        flocq = null;
      };
    };
  };

  easycrypt-runtest = callPackage ../applications/science/logic/easycrypt/runtest.nix { };

  easyocr = with python3.pkgs; toPythonApplication easyocr;

  eddy = callPackage ../applications/graphics/eddy { };

  element-web = callPackage ../by-name/el/element-web/package.nix {
    conf = config.element-web.conf or { };
  };

  elm-github-install = callPackage ../tools/package-management/elm-github-install { };

  espanso-wayland = espanso.override {
    x11Support = false;
    waylandSupport = !stdenv.hostPlatform.isDarwin;
  };

  fastly = callPackage ../misc/fastly {
    # If buildGoModule is overridden, provide a matching version of the go attribute
  };

  f3d_egl = f3d.override { vtk_9 = vtk_9_egl; };

  fast-cli = nodePackages.fast-cli;

  fdroidcl = pkgs.callPackage ../development/mobile/fdroidcl { };

  ### TOOLS/TYPESETTING/TEX

  advi = callPackage ../tools/typesetting/tex/advi {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  dblatexFull = dblatex.override { enableAllFeatures = true; };

  latex2mathml = with python3Packages; toPythonApplication latex2mathml;

  pgf = pgf2;

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see https://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = callPackage ../tools/typesetting/tex/texlive { };
  inherit (texlive.schemes)
    texliveBasic
    texliveBookPub
    texliveConTeXt
    texliveFull
    texliveGUST
    texliveInfraOnly
    texliveMedium
    texliveMinimal
    texliveSmall
    texliveTeTeX
    ;
  texlivePackages = recurseIntoAttrs (lib.mapAttrs (_: v: v.build) texlive.pkgs);

  futhark = haskell.lib.compose.justStaticExecutables haskellPackages.futhark;

  qt-video-wlr = libsForQt5.callPackage ../applications/misc/qt-video-wlr { };

  g2o = libsForQt5.callPackage ../development/libraries/g2o { };

  inherit (go-containerregistry) crane gcrane;

  geekbench_4 = callPackage ../tools/misc/geekbench/4.nix { };
  geekbench_5 = callPackage ../tools/misc/geekbench/5.nix { };
  geekbench_6 = callPackage ../tools/misc/geekbench/6.nix { };
  geekbench = geekbench_6;

  ghidra = callPackage ../tools/security/ghidra/build.nix {
    protobuf = protobuf_21;
  };

  ghidra-extensions = recurseIntoAttrs (callPackage ../tools/security/ghidra/extensions.nix { });

  ghidra-bin = callPackage ../tools/security/ghidra { };

  gpg-tui = callPackage ../tools/security/gpg-tui {
    inherit (darwin) libresolv;
  };

  greg = callPackage ../applications/audio/greg {
    pythonPackages = python3Packages;
  };

  hocr-tools = with python3Packages; toPythonApplication hocr-tools;

  hopper = qt5.callPackage ../development/tools/analysis/hopper { };

  hypr = callPackage ../applications/window-managers/hyprwm/hypr {
    cairo = cairo.override { xcbSupport = true; };
  };

  hyprland = callPackage ../by-name/hy/hyprland/package.nix {
    stdenv = gcc14Stdenv;
  };

  hyprpolkitagent = callPackage ../by-name/hy/hyprpolkitagent/package.nix {
    stdenv = gcc14Stdenv;
  };

  hyprshade = python311Packages.callPackage ../applications/window-managers/hyprwm/hyprshade { };

  hyprlandPlugins = recurseIntoAttrs (
    callPackage ../applications/window-managers/hyprwm/hyprland-plugins { }
  );

  intensity-normalization = with python3Packages; toPythonApplication intensity-normalization;

  jellyfin-media-player = libsForQt5.callPackage ../applications/video/jellyfin-media-player { };

  jellyfin-mpv-shim = python3Packages.callPackage ../applications/video/jellyfin-mpv-shim { };

  klaus = with python3Packages; toPythonApplication klaus;

  klipper = callPackage ../servers/klipper { };

  klipper-firmware = callPackage ../servers/klipper/klipper-firmware.nix { };

  klipper-flash = callPackage ../servers/klipper/klipper-flash.nix { };

  klipper-genconf = callPackage ../servers/klipper/klipper-genconf.nix { };

  klog = qt5.callPackage ../applications/radio/klog { };

  lexicon = with python3Packages; toPythonApplication dns-lexicon;

  lief = callPackage ../development/libraries/lief { };

  # Less secure variant of lowdown for use inside Nix builds.
  lowdown-unsandboxed = lowdown.override {
    enableDarwinSandbox = false;
  };

  kaggle = with python3Packages; toPythonApplication kaggle;

  maliit-framework = libsForQt5.callPackage ../applications/misc/maliit-framework { };

  maliit-keyboard = libsForQt5.callPackage ../applications/misc/maliit-keyboard { };

  mat2 = with python3.pkgs; toPythonApplication mat2;

  materialx = with python3Packages; toPythonApplication materialx;

  # while building documentation meson may want to run binaries for host
  # which needs an emulator
  # example of an error which this fixes
  # [Errno 8] Exec format error: './gdk3-scan'
  mesonEmulatorHook =
    makeSetupHook
      {
        name = "mesonEmulatorHook";
        substitutions = {
          crossFile = writeText "cross-file.conf" ''
            [binaries]
            exe_wrapper = '${lib.escape [ "'" "\\" ] (stdenv.targetPlatform.emulator pkgs)}'
          '';
        };
      }
      # The throw is moved into the `makeSetupHook` derivation, so that its
      # outer level, but not its outPath can still be evaluated if the condition
      # doesn't hold. This ensures that splicing still can work correctly.
      (
        if (!stdenv.hostPlatform.canExecute stdenv.targetPlatform) then
          ../by-name/me/meson/emulator-hook.sh
        else
          throw "mesonEmulatorHook may only be added to nativeBuildInputs when the target binaries can't be executed; however you are attempting to use it in a situation where ${stdenv.hostPlatform.config} can execute ${stdenv.targetPlatform.config}. Consider only adding mesonEmulatorHook according to a conditional based canExecute in your package expression."
      );

  mkspiffs = callPackage ../tools/filesystems/mkspiffs { };

  mkspiffs-presets = recurseIntoAttrs (callPackages ../tools/filesystems/mkspiffs/presets.nix { });

  mobilizon = callPackage ../servers/mobilizon {
    elixir = beam.packages.erlang_26.elixir_1_15;
    beamPackages = beam.packages.erlang_26.extend (self: super: { elixir = self.elixir_1_15; });
    mobilizon-frontend = callPackage ../servers/mobilizon/frontend.nix { };
  };

  monado = callPackage ../by-name/mo/monado/package.nix {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  mpd-sima = python3Packages.callPackage ../tools/audio/mpd-sima { };

  nltk-data = callPackage ../tools/text/nltk-data { };

  seabios-coreboot = seabios.override { ___build-type = "coreboot"; };
  seabios-csm = seabios.override { ___build-type = "csm"; };
  seabios-qemu = seabios.override { ___build-type = "qemu"; };

  seaborn-data = callPackage ../tools/misc/seaborn-data { };

  nodepy-runtime = with python3.pkgs; toPythonApplication nodepy-runtime;

  nixpkgs-pytools = with python3.pkgs; toPythonApplication nixpkgs-pytools;

  nsz = with python3.pkgs; toPythonApplication nsz;

  ocrmypdf = with python3.pkgs; toPythonApplication ocrmypdf;

  online-judge-template-generator =
    python3Packages.callPackage ../tools/misc/online-judge-template-generator
      { };

  online-judge-tools = with python3.pkgs; toPythonApplication online-judge-tools;

  inherit (ocamlPackages) patdiff;

  patool = with python3Packages; toPythonApplication patool;

  pixcat = with python3Packages; toPythonApplication pixcat;

  pyznap = python3Packages.callPackage ../tools/backup/pyznap { };

  psrecord = python3Packages.callPackage ../tools/misc/psrecord { };

  rare = python3Packages.callPackage ../games/rare { };

  rmview = libsForQt5.callPackage ../applications/misc/remarkable/rmview { };

  remarkable-mouse = python3Packages.callPackage ../applications/misc/remarkable/remarkable-mouse { };

  ropgadget = with python3Packages; toPythonApplication ropgadget;

  scour = with python3Packages; toPythonApplication scour;

  steampipePackages = recurseIntoAttrs (callPackage ../tools/misc/steampipe-packages { });

  inherit (callPackages ../servers/rainloop { })
    rainloop-community
    rainloop-standard
    ;

  razergenie = libsForQt5.callPackage ../applications/misc/razergenie { };

  roundcube = callPackage ../servers/roundcube { };

  roundcubePlugins = recurseIntoAttrs (callPackage ../servers/roundcube/plugins { });

  rsyslog = callPackage ../tools/system/rsyslog {
    withHadoop = false; # Currently Broken
    withKsi = false; # Currently Broken
  };

  rsyslog-light = rsyslog.override {
    withKrb5 = false;
    withSystemd = false;
    withJemalloc = false;
    withMysql = false;
    withPostgres = false;
    withDbi = false;
    withNetSnmp = false;
    withUuid = false;
    withCurl = false;
    withGnutls = false;
    withGcrypt = false;
    withLognorm = false;
    withMaxminddb = false;
    withOpenssl = false;
    withRelp = false;
    withKsi = false;
    withLogging = false;
    withNet = false;
    withHadoop = false;
    withRdkafka = false;
    withMongo = false;
    withCzmq = false;
    withRabbitmq = false;
    withHiredis = false;
  };

  xmlsort = perlPackages.XMLFilterSort;

  mcelog = callPackage ../os-specific/linux/mcelog {
    util-linux = util-linuxMinimal;
  };

  sqlint = callPackage ../development/tools/sqlint { };

  apc-temp-fetch = with python3.pkgs; callPackage ../tools/networking/apc-temp-fetch { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (python3.pkgs)
      pygments
      matplotlib
      numpy
      aafigure
      recursive-pth-loader
      ;
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = asciidoc.override {
    enableStandardFeatures = true;
  };

  asciidoc-full-with-plugins = asciidoc.override {
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  };

  asciidoctor = callPackage ../tools/typesetting/asciidoctor { };

  asciidoctor-with-extensions = callPackage ../tools/typesetting/asciidoctor-with-extensions { };

  b2sum = callPackage ../tools/security/b2sum {
    inherit (llvmPackages) openmp;
  };

  beamerpresenter = beamerpresenter-mupdf;

  beamerpresenter-mupdf = qt6Packages.callPackage ../applications/office/beamerpresenter {
    useMupdf = true;
    usePoppler = false;
  };

  beamerpresenter-poppler = qt6Packages.callPackage ../applications/office/beamerpresenter {
    useMupdf = false;
    usePoppler = true;
  };

  beetsPackages = lib.recurseIntoAttrs (callPackage ../tools/audio/beets { });
  inherit (beetsPackages) beets beets-unstable;

  binlore = callPackage ../development/tools/analysis/binlore { };

  birdfont = callPackage ../tools/misc/birdfont { };
  xmlbird = callPackage ../tools/misc/birdfont/xmlbird.nix { stdenv = gccStdenv; };

  bmrsa = callPackage ../tools/security/bmrsa/11.nix { };

  anystyle-cli = callPackage ../tools/misc/anystyle-cli { };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  bzip2_1_1 = callPackage ../tools/compression/bzip2/1_1.nix { };

  bzip3 = callPackage ../tools/compression/bzip3 {
    stdenv = clangStdenv;
  };

  davix-copy = davix.override { enableThirdPartyCopy = true; };

  cdist = python3Packages.callPackage ../tools/admin/cdist { };

  cdrtools = callPackage ../tools/cd-dvd/cdrtools {
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_14.stdenv else stdenv;
  };

  cemu-ti = qt5.callPackage ../applications/science/math/cemu-ti { };

  libceph = ceph.lib;
  inherit
    (callPackages ../tools/filesystems/ceph {
      lua = lua5_4; # Ceph currently requires >= 5.3

      # To see which `fmt` version Ceph upstream recommends, check its `src/fmt` submodule.
      #
      # Ceph does not currently build with `fmt_10`; see https://github.com/NixOS/nixpkgs/issues/281027#issuecomment-1899128557
      # If we want to switch for that before upstream fixes it, use this patch:
      # https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899648638
      fmt = fmt_9;

      # Remove once Ceph supports arrow-cpp >= 20, see:
      # * https://tracker.ceph.com/issues/71269
      # * https://github.com/NixOS/nixpkgs/issues/406306
      arrow-cpp = callPackage ../tools/filesystems/ceph/arrow-cpp-19.nix { };
    })
    ceph
    ceph-client
    ;
  ceph-dev = ceph;

  clementine = libsForQt5.callPackage ../applications/audio/clementine {
    gst_plugins = with gst_all_1; [
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-libav
    ];
    protobuf = protobuf_21;
  };

  mellowplayer = libsForQt5.callPackage ../applications/audio/mellowplayer { };

  circus = with python310Packages; toPythonApplication circus;

  inherit (callPackage ../applications/networking/remote/citrix-workspace { })
    citrix_workspace_23_09_0
    citrix_workspace_23_11_0
    citrix_workspace_24_02_0
    citrix_workspace_24_05_0
    citrix_workspace_24_08_0
    citrix_workspace_24_11_0
    ;
  citrix_workspace = citrix_workspace_24_11_0;

  cmst = libsForQt5.callPackage ../tools/networking/cmst { };

  colord-gtk4 = colord-gtk.override { withGtk4 = true; };

  connmanFull = connman.override {
    # TODO: Why is this in `connmanFull` and not the default build? See TODO in
    # nixos/modules/services/networking/connman.nix (near the assertions)
    enableNetworkManagerCompatibility = true;
    enableHh2serialGps = true;
    enableL2tp = true;
    enableIospm = true;
    enableTist = true;
  };

  connmanMinimal = connman.override {
    # enableDatafiles = false; # If disabled, configuration and data files are not installed
    # enableEthernet = false; # If disabled no ethernet connection can be performed
    # enableWifi = false; # If disabled no WiFi connection can be performed
    enableBluetooth = false;
    enableClient = false;
    enableDundee = false;
    enableGadget = false;
    enableLoopback = false;
    enableNeard = false;
    enableOfono = false;
    enableOpenconnect = false;
    enableOpenvpn = false;
    enablePacrunner = false;
    enablePolkit = false;
    enablePptp = false;
    enableStats = false;
    enableTools = false;
    enableVpnc = false;
    enableWireguard = false;
    enableWispr = false;
  };

  collectd = callPackage ../tools/system/collectd { };

  collectd-data = callPackage ../tools/system/collectd/data.nix { };

  unify = with python3Packages; toPythonApplication unify;

  inherit (nodePackages) uppy-companion;

  usb-modeswitch-data = callPackage ../by-name/us/usb-modeswitch/data.nix { };

  persistent-evdev = python3Packages.callPackage ../servers/persistent-evdev { };

  inherit (import ../development/libraries/libsbsms pkgs)
    libsbsms
    libsbsms_2_0_2
    libsbsms_2_3_0
    ;

  m17n_lib = callPackage ../tools/inputmethods/m17n-lib { };

  libotf = callPackage ../tools/inputmethods/m17n-lib/otf.nix { };

  skkDictionaries = callPackages ../tools/inputmethods/skk/skk-dicts { };

  ibus = callPackage ../tools/inputmethods/ibus { };

  ibus-engines = recurseIntoAttrs {
    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy { };

    bamboo = callPackage ../tools/inputmethods/ibus-engines/ibus-bamboo { };

    cangjie = callPackage ../tools/inputmethods/ibus-engines/ibus-cangjie { };

    chewing = callPackage ../tools/inputmethods/ibus-engines/ibus-chewing { };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul { };

    kkc = callPackage ../tools/inputmethods/ibus-engines/ibus-kkc { };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin { };

    libthai = callPackage ../tools/inputmethods/ibus-engines/ibus-libthai { };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n { };

    inherit mozc mozc-ut;

    openbangla-keyboard = libsForQt5.callPackage ../applications/misc/openbangla-keyboard {
      withIbusSupport = true;
    };

    pinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-pinyin { };

    rime = callPackage ../tools/inputmethods/ibus-engines/ibus-rime { };

    table = callPackage ../tools/inputmethods/ibus-engines/ibus-table { };

    table-chinese = callPackage ../tools/inputmethods/ibus-engines/ibus-table-chinese {
      ibus-table = ibus-engines.table;
    };

    table-others = callPackage ../tools/inputmethods/ibus-engines/ibus-table-others {
      ibus-table = ibus-engines.table;
    };

    uniemoji = callPackage ../tools/inputmethods/ibus-engines/ibus-uniemoji { };

    typing-booster-unwrapped = callPackage ../tools/inputmethods/ibus-engines/ibus-typing-booster { };

    typing-booster = callPackage ../tools/inputmethods/ibus-engines/ibus-typing-booster/wrapper.nix {
      typing-booster = ibus-engines.typing-booster-unwrapped;
    };
  };

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix { };

  interception-tools = callPackage ../tools/inputmethods/interception-tools { };
  interception-tools-plugins = recurseIntoAttrs {
    caps2esc = callPackage ../tools/inputmethods/interception-tools/caps2esc.nix { };
    dual-function-keys =
      callPackage ../tools/inputmethods/interception-tools/dual-function-keys.nix
        { };
  };

  blacken-docs = with python3Packages; toPythonApplication blacken-docs;

  bluetooth_battery = python3Packages.callPackage ../applications/misc/bluetooth_battery { };

  calyx-vpn = qt6Packages.callPackage ../tools/networking/bitmask-vpn {
    provider = "calyx";
  };

  cask-server = libsForQt5.callPackage ../applications/misc/cask-server { };

  code-browser-qt = libsForQt5.callPackage ../applications/editors/code-browser { withQt = true; };
  code-browser-gtk2 = callPackage ../applications/editors/code-browser { withGtk2 = true; };
  code-browser-gtk = callPackage ../applications/editors/code-browser { withGtk3 = true; };

  cffconvert = python3Packages.toPythonApplication python3Packages.cffconvert;

  ckb-next = libsForQt5.callPackage ../tools/misc/ckb-next { };

  cmdpack = callPackages ../tools/misc/cmdpack { };

  cocoapods = callPackage ../development/tools/cocoapods { };

  cocoapods-beta = lowPrio (callPackage ../development/tools/cocoapods { beta = true; });

  compass = callPackage ../development/tools/compass { };

  cone = callPackage ../development/compilers/cone {
    llvmPackages = llvmPackages_13;
  };

  coreutils = callPackage ../tools/misc/coreutils { };

  # The coreutils above are built with dependencies from
  # bootstrapping. We cannot override it here, because that pulls in
  # openssl from the previous stage as well.
  coreutils-full = callPackage ../tools/misc/coreutils { minimal = false; };
  coreutils-prefixed = coreutils.override {
    withPrefix = true;
    singleBinary = false;
  };

  create-cycle-app = nodePackages.create-cycle-app;

  cron = isc-cron;

  # Top-level fix-point used in `cudaPackages`' internals
  _cuda = import ../development/cuda-modules/_cuda;

  cudaPackages_11_0 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.0"; };
  cudaPackages_11_1 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.1"; };
  cudaPackages_11_2 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.2"; };
  cudaPackages_11_3 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.3"; };
  cudaPackages_11_4 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.4"; };
  cudaPackages_11_5 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.5"; };
  cudaPackages_11_6 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.6"; };
  cudaPackages_11_7 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.7"; };
  cudaPackages_11_8 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "11.8"; };
  cudaPackages_11 = recurseIntoAttrs cudaPackages_11_8;

  cudaPackages_12_0 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.0"; };
  cudaPackages_12_1 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.1"; };
  cudaPackages_12_2 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.2"; };
  cudaPackages_12_3 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.3"; };
  cudaPackages_12_4 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.4"; };
  cudaPackages_12_5 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.5"; };
  cudaPackages_12_6 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.6"; };
  cudaPackages_12_8 = callPackage ./cuda-packages.nix { cudaMajorMinorVersion = "12.8"; };
  cudaPackages_12 = cudaPackages_12_8; # Latest supported by cudnn

  cudaPackages = recurseIntoAttrs cudaPackages_12;

  # TODO: move to alias
  cudatoolkit = cudaPackages.cudatoolkit;
  cudatoolkit_11 = cudaPackages_11.cudatoolkit;

  curlFull = curl.override {
    ldapSupport = true;
    gsaslSupport = true;
    rtmpSupport = true;
    pslSupport = true;
    websocketSupport = true;
  };

  curlHTTP3 = curl.override {
    http3Support = true;
  };

  curl = curlMinimal.override (
    {
      idnSupport = true;
      pslSupport = true;
      zstdSupport = true;
    }
    // lib.optionalAttrs (!stdenv.hostPlatform.isStatic) {
      brotliSupport = true;
    }
  );

  curlWithGnuTls = curl.override {
    gnutlsSupport = true;
    opensslSupport = false;
  };

  curl-impersonate-ff = curl-impersonate.curl-impersonate-ff;
  curl-impersonate-chrome = curl-impersonate.curl-impersonate-chrome;

  cve-bin-tool = python3Packages.callPackage ../tools/security/cve-bin-tool { };

  danger-gitlab = callPackage ../applications/version-management/danger-gitlab { };

  dconf2nix = callPackage ../development/tools/haskell/dconf2nix { };

  ddcui = libsForQt5.callPackage ../applications/misc/ddcui { };

  inherit (callPackages ../applications/networking/p2p/deluge { })
    deluge-gtk
    deluged
    deluge
    ;

  deluge-2_x = deluge;

  diffoscopeMinimal = diffoscope.override {
    enableBloat = false;
  };

  diffutils = callPackage ../tools/text/diffutils { };

  dmd = callPackage ../by-name/dm/dmd/package.nix (
    {
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      # https://github.com/NixOS/nixpkgs/pull/206907#issuecomment-1527034123
      stdenv = gcc11Stdenv;
    }
  );

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  sl1-to-photon = python3Packages.callPackage ../applications/misc/sl1-to-photon { };

  drone = callPackage ../development/tools/continuous-integration/drone { };
  drone-oss = callPackage ../development/tools/continuous-integration/drone {
    enableUnfree = false;
  };

  dsview = libsForQt5.callPackage ../applications/science/electronics/dsview { };

  inherit (import ../build-support/dlang/dub-support.nix { inherit callPackage; })
    buildDubPackage
    dub-to-nix
    ;

  duff = callPackage ../tools/filesystems/duff {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  dvtm-unstable = callPackage ../tools/misc/dvtm/unstable.nix { };

  eid-mw = callPackage ../tools/security/eid-mw {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  engauge-digitizer = libsForQt5.callPackage ../applications/science/math/engauge-digitizer { };

  kramdown-asciidoc = callPackage ../tools/typesetting/kramdown-asciidoc { };

  rocmPackages = rocmPackages_6;
  rocmPackages_6 = recurseIntoAttrs (callPackage ../development/rocm-modules/6 { });

  sonobuoy = callPackage ../applications/networking/cluster/sonobuoy { };

  strawberry-qt6 = qt6Packages.callPackage ../applications/audio/strawberry { };

  strawberry = strawberry-qt6;

  schleuder = callPackage ../tools/security/schleuder { };

  schleuder-cli = callPackage ../tools/security/schleuder/cli { };

  teamocil = callPackage ../tools/misc/teamocil { };

  tsm-client-withGui = callPackage ../by-name/ts/tsm-client/package.nix { enableGui = true; };

  tracy = callPackage ../by-name/tr/tracy/package.nix { withWayland = stdenv.hostPlatform.isLinux; };
  tracy-glfw = callPackage ../by-name/tr/tracy/package.nix { withWayland = false; };
  tracy-wayland = callPackage ../by-name/tr/tracy/package.nix { withWayland = true; };

  uusi = haskell.lib.compose.justStaticExecutables haskellPackages.uusi;

  uutils-coreutils-noprefix = uutils-coreutils.override { prefix = null; };

  vorta = qt6Packages.callPackage ../applications/backup/vorta { };

  xkcdpass = with python3Packages; toPythonApplication xkcdpass;

  zonemaster-cli = perlPackages.ZonemasterCLI;

  ### DEVELOPMENT / EMSCRIPTEN

  buildEmscriptenPackage = callPackage ../development/em-modules/generic { };

  emscripten = callPackage ../development/compilers/emscripten {
    llvmPackages = llvmPackages_20;
  };

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // {
    mkDerivation = buildEmscriptenPackage;
  };

  # The latest version used by elasticsearch, logstash, kibana and the the beats from elastic.
  # When updating make sure to update all plugins or they will break!
  elk7Version = "7.17.27";

  elasticsearch7 = callPackage ../servers/search/elasticsearch/7.x.nix {
    util-linux = util-linuxMinimal;
    jre_headless = jdk11_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  elasticsearch = elasticsearch7;

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ../servers/search/elasticsearch/plugins.nix { }
  );

  embree = callPackage ../development/libraries/embree { };
  embree2 = callPackage ../development/libraries/embree/2.x.nix { };

  emborg = python3Packages.callPackage ../development/python-modules/emborg { };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  ethercalc = callPackage ../servers/web-apps/ethercalc { };

  evtest-qt = libsForQt5.callPackage ../applications/misc/evtest-qt { };

  executor = with python3Packages; toPythonApplication executor;

  exiftool = perlPackages.ImageExifTool;

  expect = tclPackages.expect;

  Fabric = with python3Packages; toPythonApplication fabric;

  chewing-editor = libsForQt5.callPackage ../applications/misc/chewing-editor { };

  fcitx5 = callPackage ../tools/inputmethods/fcitx5 { };

  fcitx5-bamboo = callPackage ../tools/inputmethods/fcitx5/fcitx5-bamboo.nix { };

  fcitx5-skk = qt6Packages.callPackage ../tools/inputmethods/fcitx5/fcitx5-skk.nix { };

  fcitx5-anthy = callPackage ../tools/inputmethods/fcitx5/fcitx5-anthy.nix { };

  fcitx5-chewing = callPackage ../tools/inputmethods/fcitx5/fcitx5-chewing.nix { };

  fcitx5-lua = callPackage ../tools/inputmethods/fcitx5/fcitx5-lua.nix { lua = lua5_3; };

  fcitx5-m17n = callPackage ../tools/inputmethods/fcitx5/fcitx5-m17n.nix { };

  fcitx5-openbangla-keyboard = libsForQt5.callPackage ../applications/misc/openbangla-keyboard {
    withFcitx5Support = true;
  };

  fcitx5-gtk = callPackage ../tools/inputmethods/fcitx5/fcitx5-gtk.nix { };

  fcitx5-hangul = callPackage ../tools/inputmethods/fcitx5/fcitx5-hangul.nix { };

  fcitx5-rime = callPackage ../tools/inputmethods/fcitx5/fcitx5-rime.nix { };

  fcitx5-table-extra = callPackage ../tools/inputmethods/fcitx5/fcitx5-table-extra.nix { };

  fcitx5-table-other = callPackage ../tools/inputmethods/fcitx5/fcitx5-table-other.nix { };

  flannel = callPackage ../tools/networking/flannel { };
  cni-plugin-flannel = callPackage ../tools/networking/flannel/plugin.nix { };

  flatpak-builder = callPackage ../development/tools/flatpak-builder {
    binutils = binutils-unwrapped;
  };

  fltrdr = callPackage ../tools/misc/fltrdr {
    icu = icu63;
  };

  file = callPackage ../tools/misc/file {
    inherit (windows) libgnurx;
  };

  findutils = callPackage ../tools/misc/findutils { };

  bsd-fingerd = bsd-finger.override {
    buildProduct = "daemon";
  };

  iprange = callPackage ../applications/networking/firehol/iprange.nix { };

  firehol = callPackage ../applications/networking/firehol { };

  fluentd = callPackage ../tools/misc/fluentd { };

  gemstash = callPackage ../development/tools/gemstash { };

  lpd8editor = libsForQt5.callPackage ../applications/audio/lpd8editor { };

  lp_solve = callPackage ../applications/science/math/lp_solve {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  fontmatrix = callPackage ../applications/graphics/fontmatrix { };

  fox = callPackage ../development/libraries/fox { };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix { };

  fpm = callPackage ../tools/package-management/fpm { };

  ferdium = callPackage ../applications/networking/instant-messengers/ferdium {
    mkFranzDerivation = callPackage ../applications/networking/instant-messengers/franz/generic.nix { };
  };

  franz = callPackage ../applications/networking/instant-messengers/franz {
    mkFranzDerivation = callPackage ../applications/networking/instant-messengers/franz/generic.nix { };
  };

  freqtweak = callPackage ../applications/audio/freqtweak {
    wxGTK = wxGTK32;
  };

  frostwire-bin = callPackage ../applications/networking/p2p/frostwire/frostwire-bin.nix { };

  fstl = callPackage ../applications/graphics/fstl { };

  fwknop = callPackage ../tools/security/fwknop {
    texinfo = texinfo6_7; # Uses @setcontentsaftertitlepage, removed in 6.8.
  };

  uniscribe = callPackage ../tools/text/uniscribe { };

  gandi-cli = python3Packages.callPackage ../tools/networking/gandi-cli { };

  inherit (callPackages ../tools/filesystems/garage { })
    garage
    garage_0_8
    garage_0_9
    garage_0_8_7
    garage_0_9_4
    garage_1_3_0
    garage_1_x
    garage_1

    garage_2_1_0
    garage_2
    ;

  gauge-unwrapped = callPackage ../development/tools/gauge { };
  gauge = callPackage ../development/tools/gauge/wrapper.nix { };
  gaugePlugins = recurseIntoAttrs (callPackage ../development/tools/gauge/plugins { });

  gawd = python3Packages.toPythonApplication python3Packages.gawd;

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawk-with-extensions = callPackage ../tools/text/gawk/gawk-with-extensions.nix {
    extensions = gawkextlib.full;
  };
  gawkextlib = callPackage ../tools/text/gawk/gawkextlib.nix { };

  gawkInteractive = gawk.override { interactive = true; };

  ggshield = callPackage ../tools/security/ggshield {
    python3 = python311;
  };

  gibberish-detector = with python3Packages; toPythonApplication gibberish-detector;

  gitlab-ee = callPackage ../by-name/gi/gitlab/package.nix {
    gitlabEnterprise = true;
  };

  gitlab-triage = callPackage ../applications/version-management/gitlab-triage { };

  gitlab-workhorse = callPackage ../by-name/gi/gitlab/gitlab-workhorse { };

  gitqlient = libsForQt5.callPackage ../applications/version-management/gitqlient { };

  glogg = libsForQt5.callPackage ../tools/text/glogg { };

  gmrender-resurrect = callPackage ../tools/networking/gmrender-resurrect {
    inherit (gst_all_1)
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
      ;
  };

  gnome-panel-with-modules = callPackage ../by-name/gn/gnome-panel/wrapper.nix { };

  dapl = callPackage ../development/interpreters/dzaima-apl {
    buildNativeImage = false;
    stdenv = stdenvNoCC;
    jdk = jre;
  };
  dapl-native = callPackage ../development/interpreters/dzaima-apl {
    buildNativeImage = true;
    jdk = graalvmPackages.graalvm-ce;
  };

  gnucap-full = gnucap.withPlugins (p: [ p.verilog ]);

  gnugrep = callPackage ../tools/text/gnugrep { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1compat = callPackage ../tools/security/gnupg/1compat.nix { };
  gnupg1 = gnupg1compat; # use config.packageOverrides if you prefer original gnupg1

  gnupg24 = callPackage ../tools/security/gnupg/24.nix {
    pinentry = if stdenv.hostPlatform.isDarwin then pinentry_mac else pinentry-gtk2;
  };
  gnupg = gnupg24;

  gnuplot = libsForQt5.callPackage ../tools/graphics/gnuplot { };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  gnused = callPackage ../tools/text/gnused { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  inherit (callPackage ../development/tools/godot { })
    godot3
    godot3-export-templates
    godot3-headless
    godot3-debug-server
    godot3-server
    godot3-mono
    godot3-mono-export-templates
    godot3-mono-headless
    godot3-mono-debug-server
    godot3-mono-server
    godotPackages_4_3
    godotPackages_4_4
    godotPackages_4_5
    godotPackages_4
    godotPackages
    godot_4_3
    godot_4_3-mono
    godot_4_3-export-templates-bin
    godot_4_4
    godot_4_4-mono
    godot_4_4-export-templates-bin
    godot_4_5
    godot_4_5-mono
    godot_4_5-export-templates-bin
    godot_4
    godot_4-mono
    godot_4-export-templates-bin
    godot
    godot-mono
    godot-export-templates-bin
    ;

  goattracker = callPackage ../applications/audio/goattracker { };

  goattracker-stereo = callPackage ../applications/audio/goattracker {
    isStereo = true;
  };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };
  google-cloud-sdk-gce = google-cloud-sdk.override {
    with-gce = true;
  };

  google-compute-engine = with python3.pkgs; toPythonApplication google-compute-engine;

  gdown = with python3Packages; toPythonApplication gdown;

  gpt4all-cuda = gpt4all.override {
    cudaSupport = true;
  };

  gprof2dot = with python3Packages; toPythonApplication gprof2dot;

  grails = callPackage ../development/web/grails { jdk = null; };

  graylog-6_0 = callPackage ../tools/misc/graylog/6.0.nix { };

  inherit
    ({
      graylog-6_1 = callPackage ../tools/misc/graylog/6.1.nix { };
    })
    graylog-6_1
    ;

  graylogPlugins = recurseIntoAttrs (
    callPackage ../tools/misc/graylog/plugins.nix { graylogPackage = graylog-6_0; }
  );

  graphviz = callPackage ../tools/graphics/graphviz { };

  graphviz-nox = callPackage ../tools/graphics/graphviz {
    withXorg = false;
  };

  grub2 = callPackage ../tools/misc/grub/default.nix { };

  grub2_efi = grub2.override {
    efiSupport = true;
  };

  grub2_light = grub2.override {
    zfsSupport = false;
  };

  grub2_xen = grub2.override {
    xenSupport = true;
  };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  gruut = with python3.pkgs; toPythonApplication gruut;

  gruut-ipa = with python3.pkgs; toPythonApplication gruut-ipa;

  gsmlib = callPackage ../development/libraries/gsmlib {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  gssdp = callPackage ../development/libraries/gssdp { };

  gssdp_1_6 = callPackage ../development/libraries/gssdp/1.6.nix { };

  gssdp-tools = callPackage ../development/libraries/gssdp/tools.nix { };

  gtkd = callPackage ../development/libraries/gtkd { dcompiler = ldc; };

  gup = callPackage ../development/tools/build-managers/gup { };

  gupnp = callPackage ../development/libraries/gupnp { };

  gupnp_1_6 = callPackage ../development/libraries/gupnp/1.6.nix { };

  gvm-tools = with python3.pkgs; toPythonApplication gvm-tools;

  gzip = callPackage ../tools/compression/gzip { };

  haskell-language-server =
    callPackage ../development/tools/haskell/haskell-language-server/withWrapper.nix
      { };

  hassil = with python3Packages; toPythonApplication hassil;

  haste-client = callPackage ../tools/misc/haste-client { };

  hal-hardware-analyzer =
    libsForQt5.callPackage ../applications/science/electronics/hal-hardware-analyzer
      { };

  halide = callPackage ../development/compilers/halide {
    llvmPackages = llvmPackages_19;
  };

  hareThirdParty = recurseIntoAttrs (callPackage ./hare-third-party.nix { });

  hdf5 = callPackage ../tools/misc/hdf5 {
    fortranSupport = false;
    fortran = gfortran;
  };

  hdf5_1_10 = callPackage ../tools/misc/hdf5/1.10.nix { };

  hdf5-mpi = hdf5.override {
    mpiSupport = true;
    cppSupport = false;
  };

  hdf5-cpp = hdf5.override { cppSupport = true; };

  hdf5-fortran = hdf5.override { fortranSupport = true; };

  hdf5-fortran-mpi = hdf5.override {
    fortranSupport = true;
    mpiSupport = true;
    cppSupport = false;
  };

  hdf5-threadsafe = hdf5.override { threadsafe = true; };

  heaptrack = libsForQt5.callPackage ../development/tools/profiling/heaptrack { };

  heimdall = libsForQt5.callPackage ../tools/misc/heimdall { };

  heimdall-gui = heimdall.override { enableGUI = true; };

  headscale = callPackage ../servers/headscale {
    buildGoModule = buildGo123Module;
  };

  highlight = callPackage ../tools/text/highlight {
    lua = lua5;
  };

  hockeypuck = callPackage ../servers/hockeypuck/server.nix { };

  hockeypuck-web = callPackage ../servers/hockeypuck/web.nix { };

  homesick = callPackage ../tools/misc/homesick { };

  host = bind.host;

  hotdoc = python3Packages.callPackage ../development/tools/hotdoc { };

  hotspot = libsForQt5.callPackage ../development/tools/analysis/hotspot { };

  hpccm = with python3Packages; toPythonApplication hpccm;

  hqplayer-desktop = qt6Packages.callPackage ../applications/audio/hqplayer-desktop { };

  html-proofer = callPackage ../tools/misc/html-proofer { };

  httpie = with python3Packages; toPythonApplication httpie;

  hue-plus = libsForQt5.callPackage ../applications/misc/hue-plus { };

  humanfriendly = with python3Packages; toPythonApplication humanfriendly;

  hw-probe = perlPackages.callPackage ../tools/system/hw-probe { };

  hyphen = callPackage ../development/libraries/hyphen { };

  hyphenDicts = recurseIntoAttrs (callPackages ../development/libraries/hyphen/dictionaries.nix { });

  iannix = libsForQt5.callPackage ../applications/audio/iannix { };

  iaito = libsForQt5.callPackage ../tools/security/iaito { };

  icemon = libsForQt5.callPackage ../applications/networking/icemon { };

  icepeak = haskell.lib.compose.justStaticExecutables haskellPackages.icepeak;

  inherit
    (callPackages ../tools/filesystems/irods rec {
      stdenv = llvmPackages_13.libcxxStdenv;
      libcxx = llvmPackages_13.libcxx;
      boost = boost178.override { inherit stdenv; };
      fmt = fmt_9.override { inherit stdenv; };
      nanodbc_llvm = nanodbc.override { inherit stdenv; };
      avro-cpp_llvm = avro-cpp.override { inherit stdenv boost; };
      spdlog_llvm = spdlog.override { inherit stdenv fmt; };
    })
    irods
    irods-icommands
    ;

  ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;

    jupyter = python3.withPackages (ps: [
      ps.jupyter
      ps.notebook
    ]);

    packages = config.ihaskell.packages or (_: [ ]);
  };

  iruby = callPackage ../applications/editors/jupyter-kernels/iruby { };

  ilspycmd = callPackage ../development/tools/ilspycmd {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  in-formant = qt6Packages.callPackage ../applications/audio/in-formant { };

  incus-lts = callPackage ../by-name/in/incus/lts.nix { };

  indexed-bzip2 = with python3Packages; toPythonApplication indexed-bzip2;

  infisical = callPackage ../development/tools/infisical { };

  input-remapper = python3Packages.callPackage ../tools/inputmethods/input-remapper { };

  internetarchive = with python3Packages; toPythonApplication internetarchive;

  iocextract = with python3Packages; toPythonApplication iocextract;

  iocsearcher = with python3Packages; toPythonApplication iocsearcher;

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = iperf3;

  i-pi = with python3Packages; toPythonApplication i-pi;

  # ipscan is commonly known under the name angryipscanner
  angryipscanner = ipscan;

  isl = isl_0_20;
  isl_0_20 = callPackage ../development/libraries/isl/0.20.0.nix { };
  isl_0_24 = callPackage ../development/libraries/isl/0.24.0.nix { };

  jackett = callPackage ../servers/jackett { };

  jamesdsp = qt6Packages.callPackage ../applications/audio/jamesdsp { };
  jamesdsp-pulse = qt6Packages.callPackage ../applications/audio/jamesdsp {
    usePipewire = false;
    usePulseaudio = true;
  };

  jazzy = callPackage ../development/tools/jazzy { };

  jc = with python3Packages; toPythonApplication jc;

  jello = with python3Packages; toPythonApplication jello;

  jing = res.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang {
    jdk_headless = jdk8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  jl = haskellPackages.jl;

  joplin = nodePackages.joplin;

  jpylyzer = with python3Packages; toPythonApplication jpylyzer;

  jsbeautifier = with python3Packages; toPythonApplication jsbeautifier;

  json-schema-for-humans = with python3Packages; toPythonApplication json-schema-for-humans;

  jupyter = callPackage ../applications/editors/jupyter { };

  jupyter-all = jupyter.override {
    definitions = {
      clojure = clojupyter.definition;
      octave = octave-kernel.definition;
      # wolfram = wolfram-for-jupyter-kernel.definition; # unfree
    };
  };

  jupyter-console = callPackage ../applications/editors/jupyter/console.nix { };

  jupyter-kernel = callPackage ../applications/editors/jupyter/kernel.nix { };

  wrapKakoune =
    kakoune: attrs:
    callPackage ../applications/editors/kakoune/wrapper.nix (attrs // { inherit kakoune; });
  kakounePlugins = recurseIntoAttrs (callPackage ../applications/editors/kakoune/plugins { });

  kakoune-unwrapped = callPackage ../applications/editors/kakoune { };
  kakoune = wrapKakoune kakoune-unwrapped {
    plugins = [ ]; # override with the list of desired plugins
  };
  kakouneUtils = callPackage ../applications/editors/kakoune/plugins/kakoune-utils.nix { };

  kaffeine = libsForQt5.callPackage ../applications/video/kaffeine { };

  kdiskmark = libsForQt5.callPackage ../tools/filesystems/kdiskmark { };

  keepkey-agent = with python3Packages; toPythonApplication keepkey-agent;

  keybase = callPackage ../tools/security/keybase { };

  kbfs = callPackage ../tools/security/keybase/kbfs.nix { };

  keybase-gui = callPackage ../tools/security/keybase/gui.nix { };

  keystore-explorer = callPackage ../applications/misc/keystore-explorer {
    jdk = jdk11;
  };

  kio-fuse = libsForQt5.callPackage ../tools/filesystems/kio-fuse { };

  krename = libsForQt5.callPackage ../applications/misc/krename { };

  krunner-pass = libsForQt5.callPackage ../tools/security/krunner-pass { };

  krunner-translator = libsForQt5.callPackage ../tools/misc/krunner-translator { };

  krunvm = callPackage ../applications/virtualization/krunvm {
    inherit (darwin) sigtool;
  };

  kronometer = libsForQt5.callPackage ../tools/misc/kronometer { };

  kwalletcli = libsForQt5.callPackage ../tools/security/kwalletcli { };

  peruse = libsForQt5.callPackage ../tools/misc/peruse { };

  ksmoothdock = libsForQt5.callPackage ../applications/misc/ksmoothdock { };

  ligo =
    let
      ocaml_p = ocaml-ng.ocamlPackages_4_14.overrideScope (
        self: super: {
          zarith = super.zarith.override { version = "1.13"; };
        }
      );
    in
    callPackage ../development/compilers/ligo {
      coq = coq_8_13.override {
        customOCamlPackages = ocaml_p;
      };
      ocamlPackages = ocaml_p;
    };

  leocad = callPackage ../applications/graphics/leocad { };

  libcoap = callPackage ../applications/networking/libcoap {
    autoconf = buildPackages.autoconf269;
  };

  libcryptui = callPackage ../development/libraries/libcryptui {
    autoreconfHook = buildPackages.autoreconfHook269;
    gtk3 = if stdenv.hostPlatform.isDarwin then gtk3-x11 else gtk3;
  };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg_6-full;
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  llm = with python3Packages; toPythonApplication llm;

  loganalyzer = libsForQt5.callPackage ../development/tools/loganalyzer { };

  logstash7 = callPackage ../tools/misc/logstash/7.x.nix {
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash7-oss = callPackage ../tools/misc/logstash/7.x.nix {
    enableUnfree = false;
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash = logstash7;

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  lolcat = callPackage ../tools/misc/lolcat { };

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

  kdbg = libsForQt5.callPackage ../development/tools/misc/kdbg { };

  kristall = libsForQt5.callPackage ../applications/networking/browsers/kristall { };

  lagrange-tui = lagrange.override { enableTUI = true; };

  kzipmix = pkgsi686Linux.callPackage ../tools/compression/kzipmix { };

  mailcatcher = callPackage ../development/web/mailcatcher { };

  maskromtool = qt6Packages.callPackage ../tools/graphics/maskromtool { };

  matrix-synapse-plugins = recurseIntoAttrs matrix-synapse-unwrapped.plugins;

  maubot = with python3Packages; toPythonApplication maubot;

  mautrix-telegram = recurseIntoAttrs (callPackage ../servers/mautrix-telegram { });

  m2r = with python3Packages; toPythonApplication m2r;

  md2gemini = with python3.pkgs; toPythonApplication md2gemini;

  md2pdf = with python3Packages; toPythonApplication md2pdf;

  mdcat = callPackage ../tools/text/mdcat {
    inherit (python3Packages) ansi2html;
  };

  medfile = callPackage ../development/libraries/medfile {
    hdf5 = hdf5.override { usev110Api = true; };
  };

  mhonarc = perlPackages.MHonArc;

  mx-puppet-discord = callPackage ../servers/mx-puppet-discord { };

  nanoemoji = with python3Packages; toPythonApplication nanoemoji;

  netdata = callPackage ../tools/system/netdata {
    protobuf = protobuf_21;
  };
  netdataCloud = netdata.override {
    withCloudUi = true;
  };

  netsurf = recurseIntoAttrs (callPackage ../applications/networking/browsers/netsurf { });
  netsurf-browser = netsurf.browser;

  nyxt = callPackage ../applications/networking/browsers/nyxt {
    sbcl = sbcl_2_4_6;
    inherit (gst_all_1)
      gstreamer
      gst-libav
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      ;
  };

  nixnote2 = libsForQt5.callPackage ../applications/misc/nixnote2 { };

  nodejs = hiPrio nodejs_22;
  nodejs-slim = nodejs-slim_22;
  corepack = hiPrio corepack_22;

  nodejs_20 = callPackage ../development/web/nodejs/v20.nix { };
  nodejs-slim_20 = callPackage ../development/web/nodejs/v20.nix { enableNpm = false; };
  corepack_20 = hiPrio (callPackage ../development/web/nodejs/corepack.nix { nodejs = nodejs_20; });

  nodejs_22 = callPackage ../development/web/nodejs/v22.nix { };
  nodejs-slim_22 = callPackage ../development/web/nodejs/v22.nix { enableNpm = false; };
  corepack_22 = hiPrio (callPackage ../development/web/nodejs/corepack.nix { nodejs = nodejs_22; });

  nodejs_24 = callPackage ../development/web/nodejs/v24.nix { };
  nodejs-slim_24 = callPackage ../development/web/nodejs/v24.nix { enableNpm = false; };
  corepack_24 = hiPrio (callPackage ../development/web/nodejs/corepack.nix { nodejs = nodejs_24; });

  # Update this when adding the newest nodejs major version!
  nodejs_latest = nodejs_24;
  nodejs-slim_latest = nodejs-slim_24;
  corepack_latest = hiPrio corepack_24;

  buildNpmPackage = callPackage ../build-support/node/build-npm-package { };

  npmHooks = callPackage ../build-support/node/build-npm-package/hooks { };

  inherit (callPackages ../build-support/node/fetch-npm-deps { })
    fetchNpmDeps
    prefetch-npm-deps
    ;

  importNpmLock = callPackages ../build-support/node/import-npm-lock { };

  nodePackages_latest = recurseIntoAttrs nodejs_latest.pkgs;

  nodePackages = recurseIntoAttrs nodejs.pkgs;

  node2nix = nodePackages.node2nix;

  kcollectd = kdePackages.callPackage ../tools/misc/kcollectd { };

  ktailctl = kdePackages.callPackage ../applications/networking/ktailctl { };

  ldapdomaindump = with python3Packages; toPythonApplication ldapdomaindump;

  leanblueprint = with python3Packages; toPythonApplication leanblueprint;

  inherit (callPackage ../development/tools/lerna { })
    lerna_6
    lerna_8
    ;
  lerna = lerna_8;

  libhandy = callPackage ../development/libraries/libhandy { };

  # Needed for apps that still depend on the unstable verison of the library (not libhandy-1)
  libhandy_0 = callPackage ../development/libraries/libhandy/0.x.nix { };

  libint = callPackage ../development/libraries/libint { };
  libintPsi4 = callPackage ../development/libraries/libint {
    enableFortran = false;
    enableSSE = false;
    maxAm = 6;
    eriDeriv = 2;
    eri3Deriv = 2;
    eri2Deriv = 2;
    eriAm = [
      6
      5
      4
    ];
    eri3Am = [
      6
      5
      4
    ];
    eri2Am = [
      6
      5
      4
    ];
    eriOptAm = [
      3
      2
      2
    ];
    eri3OptAm = [
      3
      2
      2
    ];
    eri2OptAm = [
      3
      2
      2
    ];
    enableOneBody = true;
    oneBodyDerivOrd = 2;
    enableGeneric = false;
    enableContracted = false;
    cartGaussOrd = "standard";
    shGaussOrd = "gaussian";
    eri2PureSh = false;
    eri3PureSh = false;
  };

  libirc = libsForQt5.callPackage ../development/libraries/libirc { };

  libportal-gtk3 = libportal.override { variant = "gtk3"; };
  libportal-gtk4 = libportal.override { variant = "gtk4"; };
  libportal-qt5 = libportal.override { variant = "qt5"; };
  libportal-qt6 = libportal.override { variant = "qt6"; };

  jesec-rtorrent = callPackage ../applications/networking/p2p/jesec-rtorrent {
    libtorrent = callPackage ../applications/networking/p2p/jesec-rtorrent/libtorrent.nix { };
  };

  librest = callPackage ../development/libraries/librest { };

  librest_1_0 = callPackage ../development/libraries/librest/1.0.nix { };

  licensee = callPackage ../tools/package-management/licensee { };

  lidarr = callPackage ../servers/lidarr { };

  inherit
    ({
      limesuite = callPackage ../applications/radio/limesuite {
      };
      limesuiteWithGui = limesuite.override {
        withGui = true;
      };
    })
    limesuite
    limesuiteWithGui
    ;

  linux-gpib = callPackage ../applications/science/electronics/linux-gpib/user.nix { };

  liquidctl = with python3Packages; toPythonApplication liquidctl;

  xz = callPackage ../tools/compression/xz { };

  madlang = haskell.lib.compose.justStaticExecutables haskellPackages.madlang;

  mailnag = callPackage ../applications/networking/mailreaders/mailnag {
    availablePlugins = {
      # More are listed here: https://github.com/pulb/mailnag/#desktop-integration
      # Use the attributes here as arguments to `plugins` list
      goa = callPackage ../applications/networking/mailreaders/mailnag/goa-plugin.nix { };
    };
  };
  mailnagWithPlugins = mailnag.withPlugins (builtins.attrValues mailnag.availablePlugins);
  mailpit = callPackage ../servers/mail/mailpit {
    libtool = if stdenv.hostPlatform.isDarwin then cctools else libtool;
  };

  mailutils = callPackage ../tools/networking/mailutils {
    sasl = gsasl;
  };

  man = man-db;

  mangohud = callPackage ../tools/graphics/mangohud {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
    mangohud32 = pkgsi686Linux.mangohud;
  };

  marimo = with python3Packages; toPythonApplication marimo;

  mecab =
    let
      mecab-nodic = callPackage ../tools/text/mecab/nodic.nix { };
    in
    callPackage ../tools/text/mecab {
      mecab-ipadic = callPackage ../tools/text/mecab/ipadic.nix {
        inherit mecab-nodic;
      };
    };

  mbutil = python310Packages.callPackage ../applications/misc/mbutil { };

  mcstatus = with python3Packages; toPythonApplication mcstatus;

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  miniupnpd-nftables = callPackage ../tools/networking/miniupnpd { firewall = "nftables"; };

  minijail = callPackage ../tools/system/minijail { };

  minijail-tools = python3.pkgs.callPackage ../tools/system/minijail/tools.nix { };

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  mitmproxy = with python3Packages; toPythonApplication mitmproxy;

  mjpegtoolsFull = mjpegtools.override {
    withMinimal = false;
  };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  molecule = with python3Packages; toPythonApplication molecule;

  moreutils = callPackage ../tools/misc/moreutils {
    docbook-xsl = docbook_xsl;
  };

  metasploit = callPackage ../tools/security/metasploit { };

  mtr = callPackage ../tools/networking/mtr { };

  mtr-gui = callPackage ../tools/networking/mtr { withGtk = true; };

  multitran = recurseIntoAttrs (
    let
      callPackage = newScope pkgs.multitran;
    in
    {
      multitrandata = callPackage ../tools/text/multitran/data { };

      libbtree = callPackage ../tools/text/multitran/libbtree { };

      libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

      libfacet = callPackage ../tools/text/multitran/libfacet { };

      libmtquery = callPackage ../tools/text/multitran/libmtquery { };

      mtutils = callPackage ../tools/text/multitran/mtutils { };
    }
  );

  mytetra = libsForQt5.callPackage ../applications/office/mytetra { };

  nerd-fonts = recurseIntoAttrs (callPackage ../data/fonts/nerd-fonts { });

  maple-mono = recurseIntoAttrs (callPackage ../data/fonts/maple-font { });

  netcdf-mpi = netcdf.override {
    hdf5 = hdf5-mpi.override { usev110Api = true; };
  };

  # Not in aliases because it wouldn't get picked up by callPackage
  netbox = netbox_4_2;

  netcat = libressl.nc.overrideAttrs (old: {
    meta = old.meta // {
      description = "Utility which reads and writes data across network connections — LibreSSL implementation";
      mainProgram = "nc";
    };
  });

  netlify-cli = callPackage ../by-name/ne/netlify-cli/package.nix {
    nodejs = nodejs_20;
  };

  networkmanager = callPackage ../tools/networking/networkmanager { };

  libnma-gtk4 = libnma.override { withGtk4 = true; };

  nm-tray = libsForQt5.callPackage ../tools/networking/networkmanager/tray.nix { };

  inherit (callPackages ../servers/nextcloud { })
    nextcloud30
    nextcloud31
    ;

  nextcloud30Packages = callPackage ../servers/nextcloud/packages { ncVersion = "30"; };
  nextcloud31Packages = callPackage ../servers/nextcloud/packages { ncVersion = "31"; };

  nextcloud-notify_push = callPackage ../servers/nextcloud/notify_push.nix { };

  inherit (callPackages ../applications/networking/cluster/nomad { })
    nomad
    nomad_1_9
    ;

  nomacs-qt6 = nomacs.override { qtVersion = 6; };

  nth = with python3Packages; toPythonApplication name-that-hash;

  nvchecker =
    with python3Packages;
    toPythonApplication (
      nvchecker.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs =
          oldAttrs.dependencies ++ lib.flatten (builtins.attrValues oldAttrs.optional-dependencies);
      })
    );

  nvfetcher = haskell.lib.compose.justStaticExecutables haskellPackages.nvfetcher;

  mkgmap = callPackage ../applications/misc/mkgmap { };

  mkgmap-splitter = callPackage ../applications/misc/mkgmap/splitter { };

  op-geth = callPackage ../applications/blockchains/optimism/geth.nix { };

  optimism = callPackage ../applications/blockchains/optimism { };

  pandoc-acro = python3Packages.callPackage ../tools/misc/pandoc-acro { };

  pandoc-imagine = python3Packages.callPackage ../tools/misc/pandoc-imagine { };

  pandoc-include = python3Packages.callPackage ../tools/misc/pandoc-include { };

  pandoc-drawio-filter = python3Packages.callPackage ../tools/misc/pandoc-drawio-filter { };

  pandoc-plantuml-filter = python3Packages.callPackage ../tools/misc/pandoc-plantuml-filter { };

  # pandoc-*nos is a filter suite, where pandoc-xnos has all functionality and the others are used for only specific functionality
  pandoc-eqnos = python3Packages.callPackage ../tools/misc/pandoc-eqnos { };
  pandoc-fignos = python3Packages.callPackage ../tools/misc/pandoc-fignos { };
  pandoc-secnos = python3Packages.callPackage ../tools/misc/pandoc-secnos { };
  pandoc-tablenos = python3Packages.callPackage ../tools/misc/pandoc-tablenos { };

  pegasus-frontend = libsForQt5.callPackage ../games/pegasus-frontend { };

  pgbadger = perlPackages.callPackage ../tools/misc/pgbadger { };

  nifskope = libsForQt5.callPackage ../tools/graphics/nifskope { };

  notation = callPackage ../by-name/no/notation/package.nix {
    buildGoModule = buildGo123Module;
  };

  nsjail = callPackage ../tools/security/nsjail {
    protobuf = protobuf_21;
  };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy-sh = callPackage ../tools/misc/ntfy-sh { };

  nvfancontrol = callPackage ../tools/misc/nvfancontrol {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  nwdiag = with python3Packages; toPythonApplication nwdiag;

  nxdomain = python3.pkgs.callPackage ../tools/networking/nxdomain { };

  ofono-phonesim = libsForQt5.callPackage ../development/tools/ofono-phonesim { };

  ola = callPackage ../applications/misc/ola {
    protobuf = protobuf_21;
  };

  olive-editor = qt6Packages.callPackage ../applications/video/olive-editor { };

  ome_zarr = with python3Packages; toPythonApplication ome-zarr;

  onlykey = callPackage ../tools/security/onlykey { node_webkit = nwjs; };

  openapi-generator-cli = callPackage ../tools/networking/openapi-generator-cli {
    jre = pkgs.jre_headless;
  };

  openboard = callPackage ../applications/graphics/openboard { };

  ophcrack-cli = ophcrack.override { enableGui = false; };

  open-interpreter = with python3Packages; toPythonApplication open-interpreter;

  openhantek6022 = libsForQt5.callPackage ../applications/science/electronics/openhantek6022 { };

  openmvg = callPackage ../applications/science/misc/openmvg {
    inherit (llvmPackages) openmp;
  };

  openmvs = callPackage ../applications/science/misc/openmvs {
    inherit (llvmPackages) openmp;
  };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  openrefine = callPackage ../applications/science/misc/openrefine { jdk = jdk17; };

  openrgb-with-all-plugins = openrgb.withPlugins [
    openrgb-plugin-effects
    openrgb-plugin-hardwaresync
  ];

  opensshPackages = dontRecurseIntoAttrs (callPackage ../tools/networking/openssh { });

  openssh = opensshPackages.openssh.override {
    etcDir = "/etc/ssh";
  };

  opensshTest = openssh.tests.openssh;

  opensshWithKerberos = openssh.override {
    withKerberos = true;
  };

  openssh_hpn = opensshPackages.openssh_hpn.override {
    etcDir = "/etc/ssh";
  };

  openssh_hpnWithKerberos = openssh_hpn.override {
    withKerberos = true;
  };

  openssh_gssapi = opensshPackages.openssh_gssapi.override {
    etcDir = "/etc/ssh";
    withKerberos = true;
  };

  ssh-copy-id = callPackage ../tools/networking/openssh/copyid.nix { };

  sshd-openpgp-auth = callPackage ../by-name/ss/ssh-openpgp-auth/daemon.nix { };

  opentrack = libsForQt5.callPackage ../applications/misc/opentrack { };

  openvpn = callPackage ../tools/networking/openvpn { };

  openvpn_learnaddress = callPackage ../tools/networking/openvpn/openvpn_learnaddress.nix { };

  openvpn-auth-ldap = callPackage ../tools/networking/openvpn/openvpn-auth-ldap.nix {
    inherit (llvmPackages) stdenv;
  };

  namespaced-openvpn = python3Packages.callPackage ../tools/networking/namespaced-openvpn { };

  update-dotdee = with python3Packages; toPythonApplication update-dotdee;

  update-nix-fetchgit = haskell.lib.compose.justStaticExecutables haskellPackages.update-nix-fetchgit;

  update-resolv-conf = callPackage ../tools/networking/openvpn/update-resolv-conf.nix { };

  update-systemd-resolved = callPackage ../tools/networking/openvpn/update-systemd-resolved.nix { };

  opentelemetry-collector = opentelemetry-collector-releases.otelcol;
  opentelemetry-collector-builder = callPackage ../tools/misc/opentelemetry-collector/builder.nix { };
  opentelemetry-collector-contrib = opentelemetry-collector-releases.otelcol-contrib;
  opentelemetry-collector-releases =
    callPackage ../tools/misc/opentelemetry-collector/releases.nix
      { };

  openvswitch-dpdk = callPackage ../by-name/op/openvswitch/package.nix { withDPDK = true; };

  optifinePackages = callPackage ../tools/games/minecraft/optifine { };

  optifine = optifinePackages.optifine-latest;

  opl3bankeditor = libsForQt5.callPackage ../tools/audio/opl3bankeditor { };
  opn2bankeditor = libsForQt5.callPackage ../tools/audio/opl3bankeditor/opn2bankeditor.nix { };

  orangefs = callPackage ../tools/filesystems/orangefs {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  osl = libsForQt5.callPackage ../development/compilers/osl {
    libclang = llvmPackages_15.libclang;
    clang = clang_15;
    llvm = llvm_15;
  };

  ossec-agent = callPackage ../tools/security/ossec/agent.nix { };

  ossec-server = callPackage ../tools/security/ossec/server.nix { };

  ovito = callPackage ../applications/graphics/ovito { };

  p4c = callPackage ../development/compilers/p4c {
    protobuf = protobuf_21;
  };

  p7zip = callPackage ../tools/archivers/p7zip { };
  p7zip-rar = p7zip.override { enableUnfree = true; };

  packagekit = callPackage ../tools/package-management/packagekit { };

  padthv1 = libsForQt5.callPackage ../applications/audio/padthv1 { };

  pageedit = libsForQt5.callPackage ../applications/office/PageEdit { };

  pagefind = libsForQt5.callPackage ../applications/misc/pagefind { };

  pakcs = callPackage ../development/compilers/pakcs { };

  paperwork = callPackage ../applications/office/paperwork/paperwork-gtk.nix { };

  parallel = callPackage ../tools/misc/parallel { };

  parallel-full = callPackage ../tools/misc/parallel/wrapper.nix { };

  parcellite = callPackage ../tools/misc/parcellite {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  patchutils = callPackage ../tools/text/patchutils { };

  patchutils_0_3_3 = callPackage ../tools/text/patchutils/0.3.3.nix { };

  patchutils_0_4_2 = callPackage ../tools/text/patchutils/0.4.2.nix { };

  inherit (import ../servers/sql/percona-server pkgs)
    percona-server_8_0
    percona-server_8_4
    percona-server
    ;
  inherit (import ../tools/backup/percona-xtrabackup pkgs)
    percona-xtrabackup_8_0
    percona-xtrabackup_8_4
    percona-xtrabackup
    ;

  pipecontrol = libsForQt5.callPackage ../applications/audio/pipecontrol { };

  pulumiPackages = recurseIntoAttrs pulumi.pkgs;

  pulumi-bin = callPackage ../tools/admin/pulumi-bin { };

  patch = gnupatch;

  patchance = python3Packages.callPackage ../applications/audio/patchance { };

  pcscliteWithPolkit = pcsclite.override {
    pname = "pcsclite-with-polkit";
    polkitSupport = true;
  };

  pdd = python3Packages.callPackage ../tools/misc/pdd { };

  pdfminer = with python3Packages; toPythonApplication pdfminer-six;

  pgsync = callPackage ../development/tools/database/pgsync { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true; # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = libsForQt5.callPackage ../tools/graphics/pfstools { };

  piper-train = callPackage ../tools/audio/piper/train.nix { };
  piper-tts = callPackage ../tools/audio/piper { };

  phosh = callPackage ../applications/window-managers/phosh { };

  phosh-mobile-settings =
    callPackage ../applications/window-managers/phosh/phosh-mobile-settings.nix
      { };

  inherit (callPackages ../tools/security/pinentry { })
    pinentry-curses
    pinentry-emacs
    pinentry-gtk2
    pinentry-gnome3
    pinentry-qt
    pinentry-tty
    pinentry-all
    ;

  pinentry_mac = callPackage ../tools/security/pinentry/mac.nix { };

  pinnwand = callPackage ../servers/pinnwand { };

  plan9port = callPackage ../tools/system/plan9port {
    inherit (darwin) DarwinTools;
  };

  platformio = if stdenv.hostPlatform.isLinux then platformio-chrootenv else platformio-core;

  playbar2 = libsForQt5.callPackage ../applications/audio/playbar2 { };

  playwright = playwright-driver;
  playwright-driver = (callPackage ../development/web/playwright/driver.nix { }).playwright-core;
  playwright-test = (callPackage ../development/web/playwright/driver.nix { }).playwright-test;

  inherit (callPackage ../servers/plik { })
    plik
    plikd
    ;

  plex = callPackage ../servers/plex { };

  plexRaw = callPackage ../servers/plex/raw.nix { };

  tabview = with python3Packages; toPythonApplication tabview;

  tautulli = python3Packages.callPackage ../servers/tautulli { };

  pleroma = callPackage ../servers/pleroma {
    elixir = elixir_1_17;
    beamPackages = beam.packages.erlang_26.extend (self: super: { elixir = elixir_1_17; });
  };

  plfit = callPackage ../by-name/pl/plfit/package.nix {
    python = null;
  };

  inherit (callPackage ../development/tools/pnpm { })
    pnpm_8
    pnpm_9
    pnpm_10
    ;
  pnpm = pnpm_10;

  po4a = perlPackages.Po4a;

  podman-compose = python3Packages.callPackage ../applications/virtualization/podman-compose { };

  polaris = callPackage ../servers/polaris { };

  polaris-web = callPackage ../servers/polaris/web.nix { };

  projectlibre = callPackage ../applications/misc/projectlibre {
    jre = jre8;
    jdk = jdk8;
  };

  projectm_3 = libsForQt5.callPackage ../applications/audio/projectm_3 { };

  proxmark3 = libsForQt5.callPackage ../tools/security/proxmark3/default.nix { };

  pws = callPackage ../tools/misc/pws { };

  pycflow2dot = with python3.pkgs; toPythonApplication pycflow2dot;

  pyinfra = with python3Packages; toPythonApplication pyinfra;

  pylint = with python3Packages; toPythonApplication pylint;

  pyocd = with python3Packages; toPythonApplication pyocd;

  pypass = with python3Packages; toPythonApplication pypass;

  pydeps = with python3Packages; toPythonApplication pydeps;

  pywal = with python3Packages; toPythonApplication pywal;

  raysession = python3Packages.callPackage ../applications/audio/raysession { };

  remarshal = with python3Packages; toPythonApplication remarshal;

  riseup-vpn = qt6Packages.callPackage ../tools/networking/bitmask-vpn {
    provider = "riseup";
  };

  rocket = libsForQt5.callPackage ../tools/graphics/rocket { };

  rtabmap = callPackage ../by-name/rt/rtabmap/package.nix {
    pcl = pcl.override { vtk = vtkWithQt5; };
  };

  rtaudio = callPackage ../development/libraries/audio/rtaudio {
    jack = libjack2;
  };

  rtmidi = callPackage ../development/libraries/audio/rtmidi {
    jack = libjack2;
  };

  mpi = openmpi; # this attribute should used to build MPI applications
  openmodelica = recurseIntoAttrs (callPackage ../applications/science/misc/openmodelica { });

  qarte = libsForQt5.callPackage ../applications/video/qarte { };

  qlcplus = libsForQt5.callPackage ../applications/misc/qlcplus { };

  qdigidoc = callPackage ../tools/security/qdigidoc { };

  qjournalctl = libsForQt5.callPackage ../applications/system/qjournalctl { };

  qjoypad = libsForQt5.callPackage ../tools/misc/qjoypad { };

  qmarkdowntextedit = libsForQt5.callPackage ../development/libraries/qmarkdowntextedit { };

  qosmic = callPackage ../applications/graphics/qosmic { };

  qtikz = callPackage ../applications/graphics/ktikz { };

  qtspim = libsForQt5.callPackage ../development/tools/misc/qtspim { };

  quictls = callPackage ../development/libraries/quictls { };

  quota = if stdenv.hostPlatform.isLinux then linuxquota else unixtools.quota;

  qvge = callPackage ../applications/graphics/qvge { };

  qview = callPackage ../applications/graphics/qview { };

  wayback_machine_downloader = callPackage ../applications/networking/wayback_machine_downloader { };

  radarr = callPackage ../servers/radarr { };

  radeon-profile = libsForQt5.callPackage ../tools/misc/radeon-profile { };

  rainbowstream = with python3.pkgs; toPythonApplication rainbowstream;

  rapidgzip = with python3Packages; toPythonApplication rapidgzip;

  rar = callPackage ../tools/archivers/rar { };

  ratarmount = with python3Packages; toPythonApplication ratarmount;

  retext = qt6Packages.callPackage ../applications/editors/retext { };

  inherit (callPackage ../tools/security/rekor { })
    rekor-cli
    rekor-server
    ;

  rst2pdf = with python3Packages; toPythonApplication rst2pdf;

  rstcheck = with python3Packages; toPythonApplication rstcheck;

  rstcheckWithSphinx = rstcheck.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.sphinx;
  });

  rtmpdump_gnutls = rtmpdump.override {
    gnutlsSupport = true;
    opensslSupport = false;
  };

  qt-box-editor = libsForQt5.callPackage ../applications/misc/qt-box-editor { };

  recoll = libsForQt5.callPackage ../applications/search/recoll { };

  recoll-nox = recoll.override { withGui = false; };

  reckon = callPackage ../tools/text/reckon { };

  remote-exec = python3Packages.callPackage ../tools/misc/remote-exec { };

  reptor = with python3.pkgs; toPythonApplication reptor;

  rescuetime = libsForQt5.callPackage ../applications/misc/rescuetime { };

  inherit (callPackage ../development/misc/resholve { })
    resholve
    ;

  reuse = with python3.pkgs; toPythonApplication reuse;

  riemann-tools = callPackage ../tools/misc/riemann-tools { };

  rmlint = callPackage ../tools/misc/rmlint {
    inherit (python3Packages) sphinx;
  };

  rosenpass = callPackage ../tools/networking/rosenpass { };

  rosenpass-tools = callPackage ../tools/networking/rosenpass/tools.nix { };

  rpm = callPackage ../tools/package-management/rpm {
    lua = lua5_4;
  };

  rsibreak = libsForQt5.callPackage ../applications/misc/rsibreak { };

  rss2email = callPackage ../applications/networking/feedreaders/rss2email {
    pythonPackages = python3Packages;
  };

  rucio = callPackage ../by-name/ru/rucio/package.nix {
    # Pinned to python 3.12 while python313Packages.future does not evaluate and
    # until https://github.com/CZ-NIC/pyoidc/issues/649 is resolved
    python3Packages = python312Packages;
  };

  rubocop = rubyPackages.rubocop;

  ruby-lsp = rubyPackages.ruby-lsp;

  s3cmd = python3Packages.callPackage ../tools/networking/s3cmd { };

  s3-credentials = with python3Packages; toPythonApplication s3-credentials;

  safety-cli = with python3.pkgs; toPythonApplication safety;

  sasview = libsForQt5.callPackage ../applications/science/misc/sasview { };

  scfbuild = python3.pkgs.callPackage ../tools/misc/scfbuild { };

  segger-jlink-headless = callPackage ../by-name/se/segger-jlink/package.nix { headless = true; };

  selectdefaultapplication = libsForQt5.callPackage ../applications/misc/selectdefaultapplication { };

  semgrep = python3.pkgs.toPythonApplication python3.pkgs.semgrep;
  inherit (semgrep.passthru) semgrep-core;

  seqdiag = with python3Packages; toPythonApplication seqdiag;

  shellify = haskellPackages.shellify.bin;

  shiv = with python3Packages; toPythonApplication shiv;

  slither-analyzer = with python3Packages; toPythonApplication slither-analyzer;

  # aka., pgp-tools
  simplescreenrecorder = libsForQt5.callPackage ../applications/video/simplescreenrecorder { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  sks = callPackage ../servers/sks {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  slstatus = callPackage ../applications/misc/slstatus {
    conf = config.slstatus.conf or null;
  };

  smpq = callPackage ../by-name/sm/smpq/package.nix {
    stormlib = stormlib.overrideAttrs (old: {
      version = "9.22";
      src = fetchFromGitHub {
        owner = "ladislav-zezula";
        repo = "StormLib";
        rev = "v9.22";
        hash = "sha256-jFUfxLzuRHAvFE+q19i6HfGcL6GX4vKL1g7l7LOhjeU=";
      };
    });
  };

  snapcast = callPackage ../applications/audio/snapcast {
    pulseaudioSupport = config.pulseaudio or stdenv.hostPlatform.isLinux;
  };

  soapui = callPackage ../applications/networking/soapui {
    jdk = jdk11;
  };

  specup = haskellPackages.specup.bin;

  spglib = callPackage ../development/libraries/spglib {
    inherit (llvmPackages) openmp;
  };

  # to match naming of other package repositories
  spire-agent = spire.agent;
  spire-server = spire.server;

  spoof-mac = python3Packages.callPackage ../tools/networking/spoof-mac { };

  soundkonverter = libsForQt5.soundkonverter;

  sparrow-unwrapped = callPackage ../applications/blockchains/sparrow {
    openimajgrabber = callPackage ../applications/blockchains/sparrow/openimajgrabber.nix { };
    openjdk = jdk23.override { enableJavaFX = true; };
  };

  sparrow = callPackage ../applications/blockchains/sparrow/fhsenv.nix { };

  steck = callPackage ../servers/pinnwand/steck.nix { };

  stm32loader = with python3Packages; toPythonApplication stm32loader;

  solanum = callPackage ../servers/irc/solanum {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  solc-select = with python3Packages; toPythonApplication solc-select;

  splot = haskell.lib.compose.justStaticExecutables haskellPackages.splot;

  sourcehut = callPackage ../applications/version-management/sourcehut { };

  sshfs = sshfs-fuse; # added 2017-08-14

  inherit (callPackages ../tools/misc/sshx { })
    sshx
    sshx-server
    ;

  strip-nondeterminism = perlPackages.strip-nondeterminism;

  subsurface = libsForQt5.callPackage ../applications/misc/subsurface { };

  sumorobot-manager =
    python3Packages.callPackage ../applications/science/robotics/sumorobot-manager
      { };

  sslscan = callPackage ../tools/security/sslscan {
    openssl = openssl.override { withZlib = true; };
  };

  stacer = libsForQt5.callPackage ../tools/system/stacer { };

  staticjinja = with python3.pkgs; toPythonApplication staticjinja;

  stoken = callPackage ../tools/security/stoken (config.stoken or { });

  stutter = haskell.lib.compose.justStaticExecutables haskellPackages.stutter;

  strongswanTNC = strongswan.override { enableTNC = true; };
  strongswanTPM = strongswan.override { enableTPM2 = true; };
  strongswanNM = strongswan.override { enableNetworkManager = true; };

  stylish-haskell = haskell.lib.compose.justStaticExecutables haskellPackages.stylish-haskell;

  su = shadow.su;

  subzerod = with python3Packages; toPythonApplication subzerod;

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    autoreconfHook = buildPackages.autoreconfHook269;
    libxml2 = libxml2Python;
  };

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  systemdgenie = libsForQt5.callPackage ../applications/system/systemdgenie { };

  t = callPackage ../tools/misc/t { };

  tartube = callPackage ../applications/video/tartube { };

  tartube-yt-dlp = callPackage ../applications/video/tartube {
    youtube-dl = yt-dlp;
  };

  teamviewer = libsForQt5.callPackage ../applications/networking/remote/teamviewer { };

  buildTeleport = callPackage ../build-support/teleport { };

  telepresence = callPackage ../tools/networking/telepresence {
    pythonPackages = python3Packages;
  };

  texmacs = libsForQt5.callPackage ../applications/editors/texmacs {
    extraFonts = true;
  };

  texmaker = qt6Packages.callPackage ../applications/editors/texmaker { };

  texworks = qt6Packages.callPackage ../applications/editors/texworks { };

  theLoungePlugins =
    let
      pkgs = lib.filterAttrs (name: _: lib.hasPrefix "thelounge-" name) nodePackages;
      getPackagesWithPrefix =
        prefix:
        lib.mapAttrs' (
          name: pkg: lib.nameValuePair (lib.removePrefix ("thelounge-" + prefix + "-") name) pkg
        ) (lib.filterAttrs (name: _: lib.hasPrefix ("thelounge-" + prefix + "-") name) pkgs);
    in
    lib.recurseIntoAttrs {
      plugins = lib.recurseIntoAttrs (getPackagesWithPrefix "plugin");
      themes = lib.recurseIntoAttrs (getPackagesWithPrefix "theme");
    };

  thinkpad-scripts = python3.pkgs.callPackage ../tools/misc/thinkpad-scripts { };

  tiled = libsForQt5.callPackage ../applications/editors/tiled { };

  timetrap = callPackage ../applications/office/timetrap { };

  tinc = callPackage ../tools/networking/tinc { };

  tikzit = libsForQt5.callPackage ../tools/typesetting/tikzit { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix { };

  tldr-hs = haskellPackages.tldr;

  tmuxPlugins = recurseIntoAttrs (
    callPackage ../misc/tmux-plugins {
      pkgs = pkgs.__splicedPackages;
    }
  );

  tor = callPackage ../tools/security/tor { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  trackma-curses = trackma.override { withCurses = true; };

  trackma-gtk = trackma.override { withGTK = true; };

  trackma-qt = trackma.override { withQT = true; };

  tpmmanager = libsForQt5.callPackage ../applications/misc/tpmmanager { };

  trezorctl = with python3Packages; toPythonApplication trezor;

  trezor-agent = with python3Packages; toPythonApplication trezor-agent;

  ttp = with python3.pkgs; toPythonApplication ttp;

  trace-cmd = callPackage ../os-specific/linux/trace-cmd { };

  kernelshark = qt6Packages.callPackage ../os-specific/linux/trace-cmd/kernelshark.nix { };

  tracee = callPackage ../tools/security/tracee {
    clang = clang_14;
  };

  translatelocally-models = recurseIntoAttrs (callPackages ../misc/translatelocally-models { });

  translatepy = with python3.pkgs; toPythonApplication translatepy;

  trytond = with python3Packages; toPythonApplication trytond;

  ttfautohint = libsForQt5.callPackage ../tools/misc/ttfautohint {
    autoreconfHook = buildPackages.autoreconfHook269;
  };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };

  twilight = callPackage ../tools/graphics/twilight {
    libX11 = xorg.libX11;
  };

  twitch-chat-downloader =
    python3Packages.callPackage ../applications/misc/twitch-chat-downloader
      { };

  twurl = callPackage ../tools/misc/twurl { };

  ubpm = libsForQt5.callPackage ../applications/misc/ubpm { };

  uftraceFull = uftrace.override {
    withLuaJIT = true;
    withPython = true;
  };

  unetbootin = libsForQt5.callPackage ../tools/cd-dvd/unetbootin { };

  unrpa = with python3Packages; toPythonApplication unrpa;

  usort = with python3Packages; toPythonApplication usort;

  vacuum = libsForQt5.callPackage ../applications/networking/instant-messengers/vacuum { };

  vampire = callPackage ../applications/science/logic/vampire { };

  vcmi = libsForQt5.callPackage ../games/vcmi { };

  video2midi = callPackage ../tools/audio/video2midi {
    pythonPackages = python3Packages;
  };

  vikunja = callPackage ../by-name/vi/vikunja/package.nix { pnpm = pnpm_9; };

  vimpager = callPackage ../tools/misc/vimpager { };
  vimpager-latest = callPackage ../tools/misc/vimpager/latest.nix { };

  vimwiki-markdown = python3Packages.callPackage ../tools/misc/vimwiki-markdown { };

  visidata = python3Packages.callPackage ../applications/misc/visidata { };

  vkbasalt = callPackage ../tools/graphics/vkbasalt {
    vkbasalt32 = pkgsi686Linux.vkbasalt;
  };

  vpn-slice = python3Packages.callPackage ../tools/networking/vpn-slice { };

  vpWithSixel = vp.override {
    # Enable next line for console graphics. Note that it requires `sixel`
    # enabled terminals such as mlterm or xterm -ti 340
    SDL = SDL_sixel;
    SDL_image = SDL_image.override { SDL = SDL_sixel; };
  };

  openconnectPackages = callPackage ../tools/networking/openconnect { };

  inherit (openconnectPackages) openconnect openconnect_openssl;

  globalprotect-openconnect =
    libsForQt5.callPackage ../tools/networking/globalprotect-openconnect
      { };

  sssd = callPackage ../os-specific/linux/sssd {
    # NOTE: freeipa and sssd need to be built with the same version of python
    inherit (perlPackages) Po4a;
  };

  webassemblyjs-cli = nodePackages."@webassemblyjs/cli-1.11.1";
  webassemblyjs-repl = nodePackages."@webassemblyjs/repl-1.11.1";

  buildWasmBindgenCli = callPackage ../build-support/wasm-bindgen-cli { };

  wasm-strip = nodePackages."@webassemblyjs/wasm-strip";
  wasm-text-gen = nodePackages."@webassemblyjs/wasm-text-gen-1.11.1";
  wast-refmt = nodePackages."@webassemblyjs/wast-refmt-1.11.1";

  wasmedge = callPackage ../development/tools/wasmedge {
    stdenv = clangStdenv;
  };

  whatweb = callPackage ../tools/security/whatweb { };

  woodpecker-agent = callPackage ../development/tools/continuous-integration/woodpecker/agent.nix { };

  woodpecker-cli = callPackage ../development/tools/continuous-integration/woodpecker/cli.nix { };

  woodpecker-server =
    callPackage ../development/tools/continuous-integration/woodpecker/server.nix
      { };

  wpscan = callPackage ../tools/security/wpscan { };

  testdisk = libsForQt5.callPackage ../tools/system/testdisk { };

  testdisk-qt = testdisk.override { enableQt = true; };

  td = callPackage ../tools/misc/td { };

  tweet-hs = haskell.lib.compose.justStaticExecutables haskellPackages.tweet-hs;

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix { };

  tremor-rs = callPackage ../tools/misc/tremor-rs { };

  tremor-language-server = callPackage ../tools/misc/tremor-rs/ls.nix { };

  truecrack-cuda = truecrack.override { cudaSupport = true; };

  turbovnc = callPackage ../tools/admin/turbovnc {
    # fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc xorg.fontbhlucidatypewriter75dpi ];
    libjpeg_turbo = libjpeg_turbo.override { enableJava = true; };
  };

  ufmt = with python3Packages; toPythonApplication ufmt;

  uim = callPackage ../tools/inputmethods/uim {
    autoconf = buildPackages.autoconf269;
  };

  unbound-with-systemd = unbound.override {
    withSystemd = true;
  };

  unbound-full = unbound.override {
    python = python3;
    withSystemd = true;
    withDynlibModule = true;
    withPythonModule = true;
    withDoH = true;
    withECS = true;
    withDNSCrypt = true;
    withDNSTAP = true;
    withTFO = true;
    withRedis = true;
  };

  unrar-wrapper = python3Packages.callPackage ../tools/archivers/unrar-wrapper { };

  ugarit = callPackage ../tools/backup/ugarit {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  unar = callPackage ../tools/archivers/unar {
    stdenv = clangStdenv;
  };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  inherit (callPackages ../servers/varnish { })
    varnish60
    varnish77
    ;
  inherit (callPackages ../servers/varnish/packages.nix { })
    varnish60Packages
    varnish77Packages
    ;
  varnishPackages = varnish77Packages;
  varnish = varnishPackages.varnish;

  vncdo = with python3Packages; toPythonApplication vncdo;

  # An alias to work around the splicing incidents
  # Related:
  # https://github.com/NixOS/nixpkgs/issues/204303
  # https://github.com/NixOS/nixpkgs/issues/211340
  # https://github.com/NixOS/nixpkgs/issues/227327
  wafHook = waf.hook;

  web-eid-app = libsForQt5.callPackage ../tools/security/web-eid-app { };

  wio = callPackage ../by-name/wi/wio/package.nix {
    wlroots = wlroots_0_17;
  };

  wring = nodePackages.wring;

  wyrd = callPackage ../tools/misc/wyrd {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  clipbuzz = callPackage ../tools/misc/clipbuzz {
    zig = buildPackages.zig_0_12;
  };

  # A minimal xar is needed to break an infinite recursion between macfuse-stubs and xar.
  # It is also needed to reduce the amount of unnecessary stuff in the Darwin bootstrap.
  xarMinimal = callPackage ../by-name/xa/xar/package.nix { e2fsprogs = null; };

  xdelta = callPackage ../tools/compression/xdelta { };
  xdeltaUnstable = callPackage ../tools/compression/xdelta/unstable.nix { };

  xdot = with python3Packages; toPythonApplication xdot;

  xflux = callPackage ../tools/misc/xflux { };
  xflux-gui = python3Packages.callPackage ../tools/misc/xflux/gui.nix { };

  libxfs = xfsprogs.dev;

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xorriso = libisoburn;

  xvfb-run = callPackage ../tools/misc/xvfb-run {
    inherit (texFunctions) fontsConf;
  };

  yapf = with python3Packages; toPythonApplication yapf;

  yarn-berry_4 = yarn-berry.override { berryVersion = 4; };
  yarn-berry_3 = yarn-berry.override { berryVersion = 3; };

  yarn2nix-moretea = callPackage ../development/tools/yarn2nix-moretea {
    pkgs = pkgs.__splicedPackages;
  };

  inherit (yarn2nix-moretea)
    yarn2nix
    mkYarnPackage
    mkYarnModules
    fixup_yarn_lock
    ;

  yamlfix = with python3Packages; toPythonApplication yamlfix;

  yamllint = with python3Packages; toPythonApplication yamllint;

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  zbackup = callPackage ../tools/backup/zbackup {
    protobuf = protobuf_21;
  };

  zbar = libsForQt5.callPackage ../tools/graphics/zbar { };

  # Nvidia support does not require any propietary libraries, so CI can build it.
  # Note that when enabling this unconditionally, non-nvidia users will always have an empty "GPU" section.
  zenith-nvidia = zenith.override {
    nvidiaSupport = true;
  };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  zstd = callPackage ../tools/compression/zstd {
    cmake = buildPackages.cmakeMinimal;
  };

  ### SHELLS

  runtimeShell = "${runtimeShellPackage}${runtimeShellPackage.shellPath}";
  runtimeShellPackage = bashNonInteractive;

  bash = callPackage ../shells/bash/5.nix { };
  bashNonInteractive = lowPrio (
    callPackage ../shells/bash/5.nix {
      interactive = false;
    }
  );
  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = bash;
  bashFHS = callPackage ../shells/bash/5.nix {
    forFHSEnv = true;
  };
  bashInteractiveFHS = bashFHS;

  carapace = callPackage ../shells/carapace {
    buildGoModule = buildGo123Module;
  };

  wrapFish = callPackage ../shells/fish/wrapper.nix { };

  fishPlugins = recurseIntoAttrs (callPackage ../shells/fish/plugins { });

  powerline = with python3Packages; toPythonApplication powerline;

  ### DEVELOPMENT / COMPILERS

  temurin-bin-24 = javaPackages.compiler.temurin-bin.jdk-24;
  temurin-jre-bin-24 = javaPackages.compiler.temurin-bin.jre-24;

  temurin-bin-23 = javaPackages.compiler.temurin-bin.jdk-23;
  temurin-jre-bin-23 = javaPackages.compiler.temurin-bin.jre-23;

  temurin-bin-21 = javaPackages.compiler.temurin-bin.jdk-21;
  temurin-jre-bin-21 = javaPackages.compiler.temurin-bin.jre-21;

  temurin-bin-17 = javaPackages.compiler.temurin-bin.jdk-17;
  temurin-jre-bin-17 = javaPackages.compiler.temurin-bin.jre-17;

  temurin-bin-11 = javaPackages.compiler.temurin-bin.jdk-11;
  temurin-jre-bin-11 = javaPackages.compiler.temurin-bin.jre-11;

  temurin-bin-8 = javaPackages.compiler.temurin-bin.jdk-8;
  temurin-jre-bin-8 = javaPackages.compiler.temurin-bin.jre-8;

  temurin-bin = temurin-bin-21;
  temurin-jre-bin = temurin-jre-bin-21;

  semeru-bin-21 = javaPackages.compiler.semeru-bin.jdk-21;
  semeru-jre-bin-21 = javaPackages.compiler.semeru-bin.jre-21;
  semeru-bin-17 = javaPackages.compiler.semeru-bin.jdk-17;
  semeru-jre-bin-17 = javaPackages.compiler.semeru-bin.jre-17;
  semeru-bin-11 = javaPackages.compiler.semeru-bin.jdk-11;
  semeru-jre-bin-11 = javaPackages.compiler.semeru-bin.jre-11;
  semeru-bin-8 = javaPackages.compiler.semeru-bin.jdk-8;
  semeru-jre-bin-8 = javaPackages.compiler.semeru-bin.jre-8;

  semeru-bin = semeru-bin-21;
  semeru-jre-bin = semeru-jre-bin-21;

  adaptivecppWithCuda = adaptivecpp.override { cudaSupport = true; };
  adaptivecppWithRocm = adaptivecpp.override { rocmSupport = true; };

  adoptopenjdk-icedtea-web = callPackage ../development/compilers/adoptopenjdk-icedtea-web {
    jdk = jdk8;
  };

  armips = callPackage ../development/compilers/armips {
    stdenv = gcc10Stdenv;
  };

  ballerina = callPackage ../development/compilers/ballerina {
    openjdk = openjdk17_headless;
  };

  binaryen = callPackage ../development/compilers/binaryen {
    nodejs = nodejs-slim;
    inherit (python3Packages) filecheck;
  };

  bluespec = callPackage ../by-name/bl/bluespec/package.nix {
    gmp-static = gmp.override { withStatic = true; };
  };

  codon = callPackage ../development/compilers/codon {
    inherit (llvmPackages) lld stdenv;
  };

  colmap = libsForQt5.callPackage ../applications/science/misc/colmap {
    inherit (config) cudaSupport;
  };
  colmapWithCuda = colmap.override { cudaSupport = true; };

  opensplatWithCuda = opensplat.override { cudaSupport = true; };

  chickenPackages_4 = recurseIntoAttrs (callPackage ../development/compilers/chicken/4 { });
  chickenPackages_5 = recurseIntoAttrs (callPackage ../development/compilers/chicken/5 { });
  chickenPackages = dontRecurseIntoAttrs chickenPackages_5;

  inherit (chickenPackages_5)
    fetchegg
    eggDerivation
    chicken
    egg2nix
    ;

  cdb = callPackage ../development/tools/database/cdb {
    stdenv = gccStdenv;
  };

  libclang = llvmPackages.libclang;
  clang-manpages = llvmPackages.clang-manpages;

  clang = llvmPackages.clang;
  clang_12 = llvmPackages_12.clang;
  clang_13 = llvmPackages_13.clang;
  clang_14 = llvmPackages_14.clang;
  clang_15 = llvmPackages_15.clang;
  clang_16 = llvmPackages_16.clang;
  clang_17 = llvmPackages_17.clang;

  clang-tools = llvmPackages.clang-tools;

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer {
    llvmPackages = llvmPackages;
    inherit (llvmPackages) clang;
  };

  clazy = callPackage ../development/tools/analysis/clazy {
    stdenv = llvmPackages.stdenv;
  };

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.cc.isClang then stdenv else lowPrio llvmPackages.stdenv;
  libcxxStdenv = if stdenv.hostPlatform.isDarwin then stdenv else lowPrio llvmPackages.libcxxStdenv;

  comby = callPackage ../development/tools/comby {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  inherit (coqPackages_8_20) compcert;

  computecpp = wrapCCWith rec {
    cc = computecpp-unwrapped;
    extraPackages = [
      llvmPackages.compiler-rt
    ];
    extraBuildCommands = ''
      wrap compute $wrapper $ccPath/compute
      wrap compute++ $wrapper $ccPath/compute++
      export named_cc=compute
      export named_cxx=compute++

      rsrc="$out/resource-root"
      mkdir -p "$rsrc/lib"
      ln -s "${cc}/lib" "$rsrc/include"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
  };

  corretto11 = javaPackages.compiler.corretto11;
  corretto17 = javaPackages.compiler.corretto17;
  corretto21 = javaPackages.compiler.corretto21;

  inherit (callPackage ../development/compilers/crystal { })
    crystal_1_11
    crystal_1_14
    crystal_1_15
    crystal
    ;

  crystalline = callPackage ../development/tools/language-servers/crystalline {
    llvmPackages = crystal.llvmPackages;
  };

  devpi-server = python3Packages.callPackage ../development/tools/devpi-server { };

  dprint-plugins = recurseIntoAttrs (callPackage ../by-name/dp/dprint/plugins { });

  elm2nix = haskell.lib.compose.justStaticExecutables haskellPackages.elm2nix;

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  fasm = pkgsi686Linux.callPackage ../development/compilers/fasm {
    inherit (stdenv.hostPlatform) isx86_64;
  };
  fasm-bin = callPackage ../development/compilers/fasm/bin.nix { };

  fbc =
    if stdenv.hostPlatform.isDarwin then
      callPackage ../development/compilers/fbc/mac-bin.nix { }
    else
      callPackage ../development/compilers/fbc { };

  filecheck = with python3Packages; toPythonApplication filecheck;

  flutterPackages-bin = recurseIntoAttrs (callPackage ../development/compilers/flutter { });
  flutterPackages-source = recurseIntoAttrs (
    callPackage ../development/compilers/flutter { useNixpkgsEngine = true; }
  );
  flutterPackages = flutterPackages-bin;
  flutter = flutterPackages.stable;
  flutter332 = flutterPackages.v3_32;
  flutter329 = flutterPackages.v3_29;
  flutter327 = flutterPackages.v3_27;
  flutter326 = flutterPackages.v3_26;
  flutter324 = flutterPackages.v3_24;

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { };
  gambit-unstable = callPackage ../development/compilers/gambit/unstable.nix { };
  gambit-support = callPackage ../development/compilers/gambit/gambit-support.nix { };
  gerbil = callPackage ../development/compilers/gerbil { };
  gerbil-unstable = callPackage ../development/compilers/gerbil/unstable.nix { };
  gerbil-support = callPackage ../development/compilers/gerbil/gerbil-support.nix { };
  gerbilPackages-unstable = pkgs.gerbil-support.gerbilPackages-unstable; # NB: don't recurseIntoAttrs for (unstable!) libraries
  glow-lang = pkgs.gerbilPackages-unstable.glow-lang;

  default-gcc-version = 14;
  gcc = pkgs.${"gcc${toString default-gcc-version}"};
  gccFun = callPackage ../development/compilers/gcc;
  gcc-unwrapped = gcc.cc;

  wrapNonDeterministicGcc =
    stdenv: ccWrapper:
    if ccWrapper.isGNU then
      ccWrapper.overrideAttrs (old: {
        env = old.env // {
          cc = old.env.cc.override {
            reproducibleBuild = false;
            profiledCompiler = with stdenv; (!isDarwin && hostPlatform.isx86);
          };
        };
      })
    else
      ccWrapper;

  gnuStdenv =
    if stdenv.cc.isGNU then
      stdenv
    else
      gccStdenv.override {
        cc = gccStdenv.cc.override {
          bintools = buildPackages.binutils;
        };
      };

  gccStdenv =
    if stdenv.cc.isGNU then
      stdenv
    else
      stdenv.override {
        cc = buildPackages.gcc;
        allowedRequisites = null;
        # Remove libcxx/libcxxabi, and add clang for AS if on darwin (it uses
        # clang's internal assembler).
        extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin clang.cc;
      };

  gcc9Stdenv = overrideCC gccStdenv buildPackages.gcc9;
  gcc10Stdenv = overrideCC gccStdenv buildPackages.gcc10;
  gcc11Stdenv = overrideCC gccStdenv buildPackages.gcc11;
  gcc12Stdenv = overrideCC gccStdenv buildPackages.gcc12;
  gcc13Stdenv = overrideCC gccStdenv buildPackages.gcc13;
  gcc14Stdenv = overrideCC gccStdenv buildPackages.gcc14;
  gcc15Stdenv = overrideCC gccStdenv buildPackages.gcc15;

  # This is not intended for use in nixpkgs but for providing a faster-running
  # compiler to nixpkgs users by building gcc with reproducibility-breaking
  # profile-guided optimizations
  fastStdenv = overrideCC gccStdenv (wrapNonDeterministicGcc gccStdenv buildPackages.gcc_latest);

  wrapCCMulti =
    cc:
    let
      # Binutils with glibc multi
      bintools = cc.bintools.override {
        libc = glibc_multi;
      };
    in
    lowPrio (wrapCCWith {
      cc = cc.cc.override {
        stdenv = overrideCC stdenv (wrapCCWith {
          cc = cc.cc;
          inherit bintools;
          libc = glibc_multi;
        });
        profiledCompiler = false;
        enableMultilib = true;
      };
      libc = glibc_multi;
      inherit bintools;
      extraBuildCommands = ''
        echo "dontMoveLib64=1" >> $out/nix-support/setup-hook
      '';
    });

  wrapClangMulti =
    clang:
    callPackage ../development/compilers/llvm/multi.nix {
      inherit clang;
      gcc32 = pkgsi686Linux.gcc;
      gcc64 = pkgs.gcc;
    };

  gcc_multi = wrapCCMulti gcc;
  clang_multi = wrapClangMulti clang;

  gccMultiStdenv = overrideCC stdenv buildPackages.gcc_multi;
  clangMultiStdenv = overrideCC stdenv buildPackages.clang_multi;
  multiStdenv = if stdenv.cc.isClang then clangMultiStdenv else gccMultiStdenv;

  gcc_debug = lowPrio (
    wrapCC (
      gcc.cc.overrideAttrs {
        dontStrip = true;
      }
    )
  );

  gccCrossLibcStdenv = overrideCC stdenvNoCC buildPackages.gccWithoutTargetLibc;

  # The GCC used to build libc for the target platform. Normal gccs will be
  # built with, and use, that cross-compiled libc.
  gccWithoutTargetLibc =
    let
      libcCross1 = binutilsNoLibc.libc;
    in
    (wrapCCWith {
      cc = gccFun {
        # copy-pasted
        inherit noSysDirs;
        majorMinorVersion = toString default-gcc-version;

        reproducibleBuild = true;
        profiledCompiler = false;

        isl = if !stdenv.hostPlatform.isDarwin then isl_0_20 else null;

        withoutTargetLibc = true;
        langCC = false;
        libcCross = libcCross1;
        targetPackages.stdenv.cc.bintools = binutilsNoLibc;
        enableShared =
          stdenv.targetPlatform.hasSharedLibraries

          # temporarily disabled due to breakage;
          # see https://github.com/NixOS/nixpkgs/pull/243249
          && !stdenv.targetPlatform.isWindows
          && !(stdenv.targetPlatform.useLLVM or false);
      };
      bintools = binutilsNoLibc;
      libc = libcCross1;
      extraPackages = [ ];
    }).overrideAttrs
      (prevAttrs: {
        meta = prevAttrs.meta // {
          badPlatforms =
            (prevAttrs.meta.badPlatforms or [ ])
            ++ lib.optionals (stdenv.targetPlatform == stdenv.hostPlatform) [ stdenv.hostPlatform.system ];
        };
      });

  inherit (callPackage ../development/compilers/gcc/all.nix { inherit noSysDirs; })
    gcc9
    gcc10
    gcc11
    gcc12
    gcc13
    gcc14
    gcc15
    ;

  gcc_latest = gcc15;

  libgccjit = gcc.cc.override {
    name = "libgccjit";
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    langJit = true;
    enableLTO = false;
  };

  gnat = gnat13; # When changing this, update also gnatPackages

  gnat11 = wrapCC (
    gcc11.cc.override {
      name = "gnat";
      langC = true;
      langCC = false;
      langAda = true;
      profiledCompiler = false;
      # As per upstream instructions building a cross compiler
      # should be done with a (native) compiler of the same version.
      # If we are cross-compiling GNAT, we may as well do the same.
      gnat-bootstrap =
        if stdenv.hostPlatform == stdenv.targetPlatform && stdenv.buildPlatform == stdenv.hostPlatform then
          buildPackages.gnat-bootstrap11
        else
          buildPackages.gnat11;
      stdenv =
        if
          stdenv.hostPlatform == stdenv.targetPlatform
          && stdenv.buildPlatform == stdenv.hostPlatform
          && stdenv.buildPlatform.isDarwin
          && stdenv.buildPlatform.isx86_64
        then
          overrideCC stdenv gnat-bootstrap11
        else
          stdenv;
    }
  );

  gnat12 = wrapCC (
    gcc12.cc.override {
      name = "gnat";
      langC = true;
      langCC = false;
      langAda = true;
      profiledCompiler = false;
      # As per upstream instructions building a cross compiler
      # should be done with a (native) compiler of the same version.
      # If we are cross-compiling GNAT, we may as well do the same.
      gnat-bootstrap =
        if stdenv.hostPlatform == stdenv.targetPlatform && stdenv.buildPlatform == stdenv.hostPlatform then
          buildPackages.gnat-bootstrap12
        else
          buildPackages.gnat12;
      stdenv =
        if
          stdenv.hostPlatform == stdenv.targetPlatform
          && stdenv.buildPlatform == stdenv.hostPlatform
          && stdenv.buildPlatform.isDarwin
          && stdenv.buildPlatform.isx86_64
        then
          overrideCC stdenv gnat-bootstrap12
        else
          stdenv;
    }
  );

  gnat13 = wrapCC (
    gcc13.cc.override {
      name = "gnat";
      langC = true;
      langCC = false;
      langAda = true;
      profiledCompiler = false;
      # As per upstream instructions building a cross compiler
      # should be done with a (native) compiler of the same version.
      # If we are cross-compiling GNAT, we may as well do the same.
      gnat-bootstrap =
        if stdenv.hostPlatform == stdenv.targetPlatform && stdenv.buildPlatform == stdenv.hostPlatform then
          buildPackages.gnat-bootstrap13
        else
          buildPackages.gnat13;
      stdenv =
        if
          stdenv.hostPlatform == stdenv.targetPlatform
          && stdenv.buildPlatform == stdenv.hostPlatform
          && stdenv.buildPlatform.isDarwin
          && stdenv.buildPlatform.isx86_64
        then
          overrideCC stdenv gnat-bootstrap13
        else
          stdenv;
    }
  );

  gnat14 = wrapCC (
    gcc14.cc.override {
      name = "gnat";
      langC = true;
      langCC = false;
      langAda = true;
      profiledCompiler = false;
      # As per upstream instructions building a cross compiler
      # should be done with a (native) compiler of the same version.
      # If we are cross-compiling GNAT, we may as well do the same.
      gnat-bootstrap =
        if stdenv.hostPlatform == stdenv.targetPlatform && stdenv.buildPlatform == stdenv.hostPlatform then
          buildPackages.gnat-bootstrap14
        else
          buildPackages.gnat14;
      stdenv =
        if
          stdenv.hostPlatform == stdenv.targetPlatform
          && stdenv.buildPlatform == stdenv.hostPlatform
          && stdenv.buildPlatform.isDarwin
          && stdenv.buildPlatform.isx86_64
        then
          overrideCC stdenv gnat-bootstrap14
        else
          stdenv;
    }
  );

  gnat15 = wrapCC (
    gcc15.cc.override {
      name = "gnat";
      langC = true;
      langCC = false;
      langAda = true;
      profiledCompiler = false;
      # As per upstream instructions building a cross compiler
      # should be done with a (native) compiler of the same version.
      # If we are cross-compiling GNAT, we may as well do the same.
      gnat-bootstrap =
        if stdenv.hostPlatform == stdenv.targetPlatform && stdenv.buildPlatform == stdenv.hostPlatform then
          buildPackages.gnat-bootstrap14
        else
          buildPackages.gnat15;
      stdenv =
        if
          stdenv.hostPlatform == stdenv.targetPlatform
          && stdenv.buildPlatform == stdenv.hostPlatform
          && stdenv.buildPlatform.isDarwin
          && stdenv.buildPlatform.isx86_64
        then
          overrideCC stdenv gnat-bootstrap14
        else
          stdenv;
    }
  );

  gnat-bootstrap = gnat-bootstrap12;
  gnat-bootstrap11 = wrapCC (
    callPackage ../development/compilers/gnat-bootstrap { majorVersion = "11"; }
  );
  gnat-bootstrap12 = wrapCCWith (
    {
      cc = callPackage ../development/compilers/gnat-bootstrap { majorVersion = "12"; };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
      bintools = bintoolsDualAs;
    }
  );
  gnat-bootstrap13 = wrapCCWith (
    {
      cc = callPackage ../development/compilers/gnat-bootstrap { majorVersion = "13"; };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
      bintools = bintoolsDualAs;
    }
  );
  gnat-bootstrap14 = wrapCCWith (
    {
      cc = callPackage ../development/compilers/gnat-bootstrap { majorVersion = "14"; };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
      bintools = bintoolsDualAs;
    }
  );

  gnat12Packages = recurseIntoAttrs (callPackage ./ada-packages.nix { gnat = buildPackages.gnat12; });
  gnat13Packages = recurseIntoAttrs (callPackage ./ada-packages.nix { gnat = buildPackages.gnat13; });
  gnat14Packages = recurseIntoAttrs (callPackage ./ada-packages.nix { gnat = buildPackages.gnat14; });
  gnat15Packages = recurseIntoAttrs (callPackage ./ada-packages.nix { gnat = buildPackages.gnat15; });
  gnatPackages = gnat13Packages;

  inherit (gnatPackages)
    gprbuild
    gnatprove
    ;

  gccgo = wrapCC (
    gcc.cc.override {
      name = "gccgo";
      langCC = true; # required for go.
      langC = true;
      langGo = true;
      langJit = true;
      profiledCompiler = false;
    }
    // {
      # not supported on darwin: https://github.com/golang/go/issues/463
      meta.broken = stdenv.hostPlatform.isDarwin;
    }
  );

  gccgo12 = wrapCC (
    gcc12.cc.override {
      name = "gccgo";
      langCC = true; # required for go.
      langC = true;
      langGo = true;
      langJit = true;
      profiledCompiler = false;
    }
    // {
      # not supported on darwin: https://github.com/golang/go/issues/463
      meta.broken = stdenv.hostPlatform.isDarwin;
    }
  );

  gccgo13 = wrapCC (
    gcc13.cc.override {
      name = "gccgo";
      langCC = true; # required for go.
      langC = true;
      langGo = true;
      langJit = true;
      profiledCompiler = false;
    }
    // {
      # not supported on darwin: https://github.com/golang/go/issues/463
      meta.broken = stdenv.hostPlatform.isDarwin;
    }
  );

  gccgo14 = wrapCC (
    gcc14.cc.override {
      name = "gccgo";
      langCC = true; # required for go.
      langC = true;
      langGo = true;
      langJit = true;
      profiledCompiler = false;
    }
    // {
      # not supported on darwin: https://github.com/golang/go/issues/463
      meta.broken = stdenv.hostPlatform.isDarwin;
    }
  );

  gccgo15 = wrapCC (
    gcc15.cc.override {
      name = "gccgo";
      langCC = true; # required for go.
      langC = true;
      langGo = true;
      langJit = true;
      profiledCompiler = false;
    }
    // {
      # not supported on darwin: https://github.com/golang/go/issues/463
      meta.broken = stdenv.hostPlatform.isDarwin;
    }
  );

  ghdl-mcode = callPackage ../by-name/gh/ghdl/package.nix { backend = "mcode"; };

  ghdl-gcc = callPackage ../by-name/gh/ghdl/package.nix { backend = "gcc"; };

  ghdl-llvm = callPackage ../by-name/gh/ghdl/package.nix {
    backend = "llvm";
    inherit (llvmPackages_15) llvm;
  };

  gcc-arm-embedded = gcc-arm-embedded-14;

  # It would be better to match the default gcc so that there are no linking errors
  # when using C/C++ libraries in D packages, but right now versions >= 12 are broken.
  gdc = gdc11;
  gdc11 = wrapCC (
    gcc11.cc.override {
      name = "gdc";
      langCC = false;
      langC = false;
      langD = true;
      profiledCompiler = false;
    }
  );

  # Haskell and GHC

  haskell = recurseIntoAttrs (callPackage ./haskell-packages.nix { });

  haskellPackages =
    recurseIntoAttrs
      # Prefer native-bignum to avoid linking issues with gmp
      # GHC 9.6 rts can't be built statically with hadrian, so we need to use 9.4
      # until 9.8 is ready
      (
        if stdenv.hostPlatform.isStatic then
          haskell.packages.native-bignum.ghc94
        # JS backend can't use gmp
        else if stdenv.hostPlatform.isGhcjs then
          haskell.packages.native-bignum.ghc98
        # ICEs horribly on i686, see https://gitlab.haskell.org/ghc/ghc/-/issues/25904
        # FIXME: remove when fixed
        else if stdenv.hostPlatform.isi686 then
          haskell.packages.ghc96
        else
          haskell.packages.ghc98
      );

  # haskellPackages.ghc is build->host (it exposes the compiler used to build the
  # set, similarly to stdenv.cc), but pkgs.ghc should be host->target to be more
  # consistent with the gcc, gnat, clang etc. derivations
  #
  # We use targetPackages.haskellPackages.ghc if available since this also has
  # the withPackages wrapper available. In the final cross-compiled package set
  # however, targetPackages won't be populated, so we need to fall back to the
  # plain, cross-compiled compiler (which is only theoretical at the moment).
  ghc =
    targetPackages.haskellPackages.ghc or
    # Prefer native-bignum to avoid linking issues with gmp
    # Use 9.4 for static over broken 9.6
    (
      if stdenv.targetPlatform.isStatic then
        haskell.compiler.native-bignum.ghc94
      # JS backend can't use GMP
      else if stdenv.targetPlatform.isGhcjs then
        haskell.compiler.native-bignum.ghc98
      # ICEs horribly on i686, see https://gitlab.haskell.org/ghc/ghc/-/issues/25904
      # FIXME: remove when fixed
      else if stdenv.hostPlatform.isi686 then
        haskell.compiler.ghc96
      else
        haskell.compiler.ghc98
    );

  alex = haskell.lib.compose.justStaticExecutables haskellPackages.alex;

  happy = haskell.lib.compose.justStaticExecutables haskellPackages.happy;

  hscolour = haskell.lib.compose.justStaticExecutables haskellPackages.hscolour;

  cabal-install = haskell.lib.compose.justStaticExecutables haskellPackages.cabal-install;

  stack =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.stack;

  hlint = haskell.lib.compose.justStaticExecutables haskellPackages.hlint;

  krank = haskell.lib.compose.justStaticExecutables haskellPackages.krank;

  stylish-cabal = haskell.lib.compose.justStaticExecutables haskellPackages.stylish-cabal;

  lhs2tex = haskellPackages.lhs2tex;

  all-cabal-hashes = callPackage ../data/misc/hackage { };

  purescript = callPackage ../development/compilers/purescript/purescript { };

  purescript-psa = nodePackages.purescript-psa;

  purenix = haskell.lib.compose.justStaticExecutables haskellPackages.purenix;

  spago = callPackage ../development/tools/purescript/spago { };

  pulp = nodePackages.pulp;

  pscid = nodePackages.pscid;

  coreboot-toolchain = recurseIntoAttrs (
    callPackage ../development/tools/misc/coreboot-toolchain { }
  );

  spicedb = callPackage ../servers/spicedb { };
  spicedb-zed = callPackage ../servers/spicedb/zed.nix { };

  tamarin-prover = (
    callPackage ../applications/science/logic/tamarin-prover {
      # 2025-03-07: dependency fclabels doesn't compile with GHC >= 9.8
      # https://github.com/sebastiaanvisser/fclabels/issues/46
      haskellPackages = haskell.packages.ghc96;
      graphviz = graphviz-nox;
    }
  );

  inherit
    (callPackage ../development/compilers/haxe {
    })
    haxe_4_3
    haxe_4_1
    haxe_4_0
    ;

  haxe = haxe_4_3;
  haxePackages = recurseIntoAttrs (callPackage ./haxe-packages.nix { });
  inherit (haxePackages) hxcpp;

  falcon = callPackage ../development/interpreters/falcon {
    stdenv = gcc10Stdenv;
  };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix { });

  gopro-tool = callPackage ../by-name/go/gopro-tool/package.nix {
    vlc = vlc.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ x264 ];
    });
  };

  gwe = callPackage ../tools/misc/gwe {
    nvidia_x11 = linuxPackages.nvidia_x11;
  };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  idrisPackages = recurseIntoAttrs (
    callPackage ../development/idris-modules {
      idris-no-deps = haskellPackages.idris;
      pkgs = pkgs.__splicedPackages;
    }
  );

  idris = idrisPackages.with-packages [ idrisPackages.base ];

  idris2Packages = recurseIntoAttrs (callPackage ../development/compilers/idris2 { });

  inherit (idris2Packages) idris2;

  inherit (callPackage ../development/tools/database/indradb { })
    indradb-server
    indradb-client
    ;

  instawow = callPackage ../games/instawow/default.nix { };

  irony-server = callPackage ../development/tools/irony-server {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacs.pkgs.melpaStablePackages) irony;
  };

  openjfx17 = openjfx;
  openjfx21 = callPackage ../by-name/op/openjfx/package.nix { featureVersion = "21"; };
  openjfx23 = callPackage ../by-name/op/openjfx/package.nix { featureVersion = "23"; };
  openjfx24 = callPackage ../by-name/op/openjfx/package.nix { featureVersion = "24"; };

  openjdk8-bootstrap = javaPackages.compiler.openjdk8-bootstrap;
  openjdk8 = javaPackages.compiler.openjdk8;
  openjdk8_headless = javaPackages.compiler.openjdk8.headless;
  jdk8 = openjdk8;
  jdk8_headless = openjdk8_headless;
  jre8 = openjdk8.jre;
  jre8_headless = openjdk8_headless.jre;

  openjdk11-bootstrap = javaPackages.compiler.openjdk11-bootstrap;
  openjdk11 = javaPackages.compiler.openjdk11;
  openjdk11_headless = javaPackages.compiler.openjdk11.headless;
  jdk11 = openjdk11;
  jdk11_headless = openjdk11_headless;

  openjdk17-bootstrap = javaPackages.compiler.openjdk17-bootstrap;
  openjdk17 = javaPackages.compiler.openjdk17;
  openjdk17_headless = javaPackages.compiler.openjdk17.headless;
  jdk17 = openjdk17;
  jdk17_headless = openjdk17_headless;

  openjdk21 = javaPackages.compiler.openjdk21;
  openjdk21_headless = javaPackages.compiler.openjdk21.headless;
  jdk21 = openjdk21;
  jdk21_headless = openjdk21_headless;

  openjdk23 = javaPackages.compiler.openjdk23;
  openjdk23_headless = javaPackages.compiler.openjdk23.headless;
  jdk23 = openjdk23;
  jdk23_headless = openjdk23_headless;

  openjdk24 = javaPackages.compiler.openjdk24;
  openjdk24_headless = javaPackages.compiler.openjdk24.headless;
  jdk24 = openjdk24;
  jdk24_headless = openjdk24_headless;

  # default JDK
  jdk = jdk21;
  jdk_headless = jdk21_headless;

  # Since the introduction of the Java Platform Module System in Java 9, Java
  # no longer ships a separate JRE package.
  #
  # If you are building a 'minimal' system/image, you are encouraged to use
  # 'jre_minimal' to build a bespoke JRE containing only the modules you need.
  #
  # For a general-purpose system, 'jre' defaults to the full JDK:
  jre = jdk;
  jre_headless = jdk_headless;

  jre11_minimal = callPackage ../development/compilers/openjdk/jre.nix {
    jdk = jdk11;
    jdkOnBuild = buildPackages.jdk11;
  };
  jre17_minimal = callPackage ../development/compilers/openjdk/jre.nix {
    jdk = jdk17;
    jdkOnBuild = buildPackages.jdk17;
  };
  jre21_minimal = callPackage ../development/compilers/openjdk/jre.nix {
    jdk = jdk21;
    jdkOnBuild = buildPackages.jdk21;
  };
  jre_minimal = callPackage ../development/compilers/openjdk/jre.nix {
    jdkOnBuild = buildPackages.jdk;
  };

  openjdk = jdk;
  openjdk_headless = jdk_headless;

  graalvmPackages = recurseIntoAttrs (callPackage ../development/compilers/graalvm { });
  buildGraalvmNativeImage =
    (callPackage ../build-support/build-graalvm-native-image {
      graalvmDrv = graalvmPackages.graalvm-ce;
    }).override;

  openshot-qt = libsForQt5.callPackage ../applications/video/openshot-qt { };

  inherit (callPackage ../development/compilers/julia { })
    julia_19-bin
    julia_110-bin
    julia_111-bin
    julia_19
    julia_110
    julia_111
    ;

  julia-lts = julia_110-bin;
  julia-stable = julia_111;
  julia = julia-stable;

  julia-lts-bin = julia_110-bin;
  julia-stable-bin = julia_111-bin;
  julia-bin = julia-stable-bin;

  koka = haskell.lib.compose.justStaticExecutables (
    haskellPackages.callPackage ../development/compilers/koka { }
  );

  kotlin = callPackage ../development/compilers/kotlin { };
  kotlin-native = callPackage ../development/compilers/kotlin/native.nix { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lazarus-qt5 = libsForQt5.callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
    withQt = true;
  };

  lazarus-qt6 = qt6Packages.callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
    withQt = true;
  };

  lld = llvmPackages.lld;
  lld_12 = llvmPackages_12.lld;
  lld_13 = llvmPackages_13.lld;
  lld_14 = llvmPackages_14.lld;
  lld_15 = llvmPackages_15.lld;
  lld_16 = llvmPackages_16.lld;
  lld_17 = llvmPackages_17.lld;

  lldb = llvmPackages.lldb;
  lldb_12 = llvmPackages_12.lldb;
  lldb_13 = llvmPackages_13.lldb;
  lldb_14 = llvmPackages_14.lldb;
  lldb_15 = llvmPackages_15.lldb;
  lldb_16 = llvmPackages_16.lldb;
  lldb_17 = llvmPackages_17.lldb;

  llvm = llvmPackages.llvm;
  llvm_12 = llvmPackages_12.llvm;
  llvm_13 = llvmPackages_13.llvm;
  llvm_14 = llvmPackages_14.llvm;
  llvm_15 = llvmPackages_15.llvm;
  llvm_16 = llvmPackages_16.llvm;
  llvm_17 = llvmPackages_17.llvm;

  mlir_16 = llvmPackages_16.mlir;
  mlir_17 = llvmPackages_17.mlir;

  libclc = llvmPackages.libclc;
  libllvm = llvmPackages.libllvm;
  llvm-manpages = llvmPackages.llvm-manpages;

  llvmPackages = llvmPackages_19;

  inherit
    (rec {
      llvmPackagesSet = recurseIntoAttrs (callPackages ../development/compilers/llvm { });

      llvmPackages_12 = llvmPackagesSet."12";
      llvmPackages_13 = llvmPackagesSet."13";
      llvmPackages_14 = llvmPackagesSet."14";
      llvmPackages_15 = llvmPackagesSet."15";
      llvmPackages_16 = llvmPackagesSet."16";
      llvmPackages_17 = llvmPackagesSet."17";

      llvmPackages_18 = llvmPackagesSet."18";
      clang_18 = llvmPackages_18.clang;
      lld_18 = llvmPackages_18.lld;
      lldb_18 = llvmPackages_18.lldb;
      llvm_18 = llvmPackages_18.llvm;

      llvmPackages_19 = llvmPackagesSet."19";
      clang_19 = llvmPackages_19.clang;
      lld_19 = llvmPackages_19.lld;
      lldb_19 = llvmPackages_19.lldb;
      llvm_19 = llvmPackages_19.llvm;
      bolt_19 = llvmPackages_19.bolt;

      llvmPackages_20 = llvmPackagesSet."20";
      clang_20 = llvmPackages_20.clang;
      lld_20 = llvmPackages_20.lld;
      lldb_20 = llvmPackages_20.lldb;
      llvm_20 = llvmPackages_20.llvm;
      bolt_20 = llvmPackages_20.bolt;

      llvmPackages_21 = llvmPackagesSet."21";
      clang_21 = llvmPackages_21.clang;
      lld_21 = llvmPackages_21.lld;
      lldb_21 = llvmPackages_21.lldb;
      llvm_21 = llvmPackages_21.llvm;
      bolt_21 = llvmPackages_21.bolt;

      mkLLVMPackages = llvmPackagesSet.mkPackage;
    })
    llvmPackages_12
    llvmPackages_13
    llvmPackages_14
    llvmPackages_15
    llvmPackages_16
    llvmPackages_17
    llvmPackages_18
    clang_18
    lld_18
    lldb_18
    llvm_18
    llvmPackages_19
    clang_19
    lld_19
    lldb_19
    llvm_19
    bolt_19
    llvmPackages_20
    clang_20
    lld_20
    lldb_20
    llvm_20
    bolt_20
    llvmPackages_21
    clang_21
    lld_21
    lldb_21
    llvm_21
    bolt_21
    mkLLVMPackages
    ;

  mercury = callPackage ../development/compilers/mercury {
    jdk_headless = openjdk8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  mitscheme = callPackage ../development/compilers/mit-scheme {
    texinfo = texinfo6;
  };

  mitschemeX11 = mitscheme.override {
    enableX11 = true;
  };

  inherit (callPackage ../development/compilers/mlton { })
    mlton20130715
    mlton20180207Binary
    mlton20180207
    mlton20210117
    mltonHEAD
    ;

  mlton = mlton20210117;

  mono = mono6;

  mono4 = lowPrio (callPackage ../development/compilers/mono/4.nix { });

  mono5 = callPackage ../development/compilers/mono/5.nix { };

  mono6 = callPackage ../development/compilers/mono/6.nix { };

  mozart2 = callPackage ../development/compilers/mozart {
    emacs = emacs-nox;
    jre_headless = jre8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  mozart2-binary = callPackage ../development/compilers/mozart/binary.nix { };

  nim = nim2;
  nim1 = nim-1_0;
  nim2 = nim-2_2;
  nim-unwrapped = nim-unwrapped-2_2;
  nim-unwrapped-1 = nim-unwrapped-1_0;
  nim-unwrapped-2 = nim-unwrapped-2_2;

  buildNimPackage = callPackage ../build-support/build-nim-package.nix { };
  buildNimSbom = callPackage ../build-support/build-nim-sbom.nix { };
  nimOverrides = callPackage ./nim-overrides.nix { };

  nextpnrWithGui = libsForQt5.callPackage ../by-name/ne/nextpnr/package.nix {
    enableGui = true;
  };

  obliv-c = callPackage ../development/compilers/obliv-c {
    stdenv = gcc10Stdenv;
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  ocaml-ng = callPackage ./ocaml-packages.nix { };
  ocaml = ocamlPackages.ocaml;

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  ocaml-crunch = ocamlPackages.crunch.bin;

  inherit (ocaml-ng.ocamlPackages_4_14)
    ocamlformat_0_19_0
    ocamlformat_0_20_0
    ocamlformat_0_20_1
    ocamlformat_0_21_0
    ocamlformat_0_22_4
    ocamlformat_0_23_0
    ocamlformat_0_24_1
    ocamlformat_0_25_1
    ocamlformat_0_26_0
    ocamlformat_0_26_1
    ;

  inherit (ocaml-ng.ocamlPackages_5_2)
    ocamlformat_0_26_2
    ;

  inherit (ocamlPackages)
    ocamlformat # latest version
    ocamlformat_0_27_0
    ;

  inherit (ocamlPackages) odig;

  ber_metaocaml = callPackage ../development/compilers/ocaml/ber-metaocaml.nix { };

  opam = callPackage ../development/tools/ocaml/opam { };

  opam-installer = callPackage ../development/tools/ocaml/opam/installer.nix { };

  wrapWatcom = callPackage ../development/compilers/open-watcom/wrapper.nix { };
  open-watcom-v2-unwrapped = callPackage ../development/compilers/open-watcom/v2.nix { };
  open-watcom-v2 = wrapWatcom open-watcom-v2-unwrapped { };
  open-watcom-bin-unwrapped = callPackage ../development/compilers/open-watcom/bin.nix { };
  open-watcom-bin = wrapWatcom open-watcom-bin-unwrapped { };

  rml = callPackage ../development/compilers/rml {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  wrapRustcWith = { rustc-unwrapped, ... }@args: callPackage ../build-support/rust/rustc-wrapper args;
  wrapRustc = rustc-unwrapped: wrapRustcWith { inherit rustc-unwrapped; };

  rust_1_86 = callPackage ../development/compilers/rust/1_86.nix {
    llvm_19 = llvmPackages_19.libllvm;
  };
  rust_1_88 = callPackage ../development/compilers/rust/1_88.nix {
    llvm_20 = llvmPackages_20.libllvm;
  };
  rust = rust_1_86;

  mrustc = callPackage ../development/compilers/mrustc { };
  mrustc-minicargo = callPackage ../development/compilers/mrustc/minicargo.nix { };
  mrustc-bootstrap = callPackage ../development/compilers/mrustc/bootstrap.nix {
    openssl = openssl_1_1;
  };

  rustPackages_1_86 = rust_1_86.packages.stable;
  rustPackages_1_88 = rust_1_88.packages.stable;
  rustPackages = rustPackages_1_86;

  inherit (rustPackages)
    cargo
    cargo-auditable
    cargo-auditable-cargo-wrapper
    clippy
    rustc
    rustPlatform
    ;

  makeRustPlatform = callPackage ../development/compilers/rust/make-rust-platform.nix { };

  buildRustCrate =
    let
      # Returns a true if the builder's rustc was built with support for the target.
      targetAlreadyIncluded = lib.elem stdenv.hostPlatform.rust.rustcTarget (
        lib.splitString "," (
          lib.removePrefix "--target=" (
            lib.elemAt (lib.filter (
              f: lib.hasPrefix "--target=" f
            ) pkgsBuildBuild.rustc.unwrapped.configureFlags) 0
          )
        )
      );
    in
    callPackage ../build-support/rust/build-rust-crate (
      { }
      // lib.optionalAttrs (stdenv.hostPlatform.libc == null) {
        stdenv = stdenvNoCC; # Some build targets without libc will fail to evaluate with a normal stdenv.
      }
      // lib.optionalAttrs targetAlreadyIncluded { inherit (pkgsBuildBuild) rustc cargo; } # Optimization.
    );
  buildRustCrateHelpers = callPackage ../build-support/rust/build-rust-crate/helpers.nix { };

  cargo-flamegraph = callPackage ../by-name/ca/cargo-flamegraph/package.nix {
    inherit (linuxPackages) perf;
  };

  defaultCrateOverrides = callPackage ../build-support/rust/default-crate-overrides.nix { };

  inherit (callPackages ../development/tools/rust/cargo-pgrx { })
    cargo-pgrx_0_12_0_alpha_1
    cargo-pgrx_0_12_5
    cargo-pgrx_0_12_6
    cargo-pgrx_0_14_1
    ;
  cargo-pgrx = cargo-pgrx_0_12_6;

  buildPgrxExtension = callPackage ../development/tools/rust/cargo-pgrx/buildPgrxExtension.nix { };
  opensmalltalk-vm = callPackage ../development/compilers/opensmalltalk-vm { };

  rustfmt = rustPackages.rustfmt;
  rust-bindgen-unwrapped = callPackage ../development/tools/rust/bindgen/unwrapped.nix { };
  rust-bindgen = callPackage ../development/tools/rust/bindgen { };
  rustup = callPackage ../development/tools/rust/rustup { };
  rustup-toolchain-install-master =
    callPackage ../development/tools/rust/rustup-toolchain-install-master
      {
      };
  scala_2_12 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.12"; };
  scala_2_13 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.13"; };
  scala_3 = callPackage ../development/compilers/scala { };

  scala = scala_3;
  scala-runners = callPackage ../development/compilers/scala-runners {
    coursier = coursier.override { jre = jdk8; };
  };

  scalafix = callPackage ../development/tools/scalafix {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  # smlnjBootstrap should be redundant, now that smlnj works on Darwin natively
  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = callPackage ../development/compilers/smlnj { };

  squeak = callPackage ../development/compilers/squeak {
    stdenv = clangStdenv;
  };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [
      jtds_jdbc
      mssql_jdbc
      mysql_jdbc
      postgresql_jdbc
    ];
  };

  swiftPackages = recurseIntoAttrs (callPackage ../development/compilers/swift { });
  inherit (swiftPackages)
    swift
    swiftpm
    sourcekit-lsp
    swift-format
    swiftpm2nix
    ;

  swi-prolog-gui = swi-prolog.override { withGui = true; };

  tbb_2020_3 = callPackage ../development/libraries/tbb/2020_3.nix { };
  tbb_2021_11 = callPackage ../development/libraries/tbb { };
  tbb_2022_0 = callPackage ../development/libraries/tbb/2022_0.nix { };
  # many packages still fail with latest version
  tbb = tbb_2020_3;

  teyjus = callPackage ../development/compilers/teyjus {
    inherit (ocaml-ng.ocamlPackages_4_14) buildDunePackage;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = gnome2.GConf;
  };

  urweb = callPackage ../development/compilers/urweb {
    icu = icu67;
  };

  vcard = python3Packages.toPythonApplication python3Packages.vcard;

  inherit (callPackage ../development/compilers/vala { })
    vala_0_56
    vala
    ;

  vyper = with python3Packages; toPythonApplication vyper;

  wrapCCWith =
    {
      cc,
      # This should be the only bintools runtime dep with this sort of logic. The
      # Others should instead delegate to the next stage's choice with
      # `targetPackages.stdenv.cc.bintools`. This one is different just to
      # provide the default choice, avoiding infinite recursion.
      # See the bintools attribute for the logic and reasoning. We need to provide
      # a default here, since eval will hit this function when bootstrapping
      # stdenv where the bintools attribute doesn't exist, but will never actually
      # be evaluated -- callPackage ends up being too eager.
      bintools ? pkgs.bintools,
      libc ? bintools.libc,
      # libc++ from the default LLVM version is bound at the top level, but we
      # want the C++ library to be explicitly chosen by the caller, and null by
      # default.
      libcxx ? null,
      extraPackages ? lib.optional (
        cc.isGNU or false && stdenv.targetPlatform.isMinGW
      ) threadsCross.package,
      nixSupport ? { },
      ...
    }@extraArgs:
    callPackage ../build-support/cc-wrapper (
      let
        self = {
          nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
          nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
          nativePrefix = stdenv.cc.nativePrefix or "";
          noLibc = !self.nativeLibc && (self.libc == null);

          isGNU = cc.isGNU or false;
          isClang = cc.isClang or false;
          isArocc = cc.isArocc or false;
          isZig = cc.isZig or false;

          inherit
            cc
            bintools
            libc
            libcxx
            extraPackages
            nixSupport
            zlib
            ;
        }
        // extraArgs;
      in
      self
    );

  wrapCC =
    cc:
    wrapCCWith {
      inherit cc;
    };

  wrapBintoolsWith =
    {
      bintools,
      libc ? if stdenv.targetPlatform != stdenv.hostPlatform then libcCross else stdenv.cc.libc,
      ...
    }@extraArgs:
    callPackage ../build-support/bintools-wrapper (
      let
        self = {
          nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
          nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
          nativePrefix = stdenv.cc.nativePrefix or "";

          noLibc = (self.libc == null);

          inherit bintools libc;
        }
        // extraArgs;
      in
      self
    );

  # prolog
  yosys = callPackage ../development/compilers/yosys { };
  yosys-bluespec = callPackage ../development/compilers/yosys/plugins/bluespec.nix { };
  yosys-ghdl = callPackage ../development/compilers/yosys/plugins/ghdl.nix { };
  yosys-synlig = callPackage ../development/compilers/yosys/plugins/synlig.nix { };
  yosys-symbiflow = callPackage ../development/compilers/yosys/plugins/symbiflow.nix { };

  zulu8 = callPackage ../development/compilers/zulu/8.nix { };
  zulu11 = callPackage ../development/compilers/zulu/11.nix { };
  zulu17 = callPackage ../development/compilers/zulu/17.nix { };
  zulu21 = callPackage ../development/compilers/zulu/21.nix { };
  zulu23 = callPackage ../development/compilers/zulu/23.nix { };
  zulu24 = callPackage ../development/compilers/zulu/24.nix { };
  zulu = zulu21;

  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 { };
  acl2-minimal = callPackage ../development/interpreters/acl2 { certifyBooks = false; };

  babashka-unwrapped = callPackage ../development/interpreters/babashka { };
  babashka = callPackage ../development/interpreters/babashka/wrapped.nix { };

  uiua-unstable = callPackage ../by-name/ui/uiua/package.nix { uiua_versionType = "unstable"; };

  # BQN interpreters and compilers

  mbqn = bqn;

  cbqn = cbqn-bootstrap.phase2;
  cbqn-replxx = cbqn-bootstrap.phase2-replxx;
  cbqn-standalone = cbqn-bootstrap.phase0;
  cbqn-standalone-replxx = cbqn-bootstrap.phase0-replxx;

  # Below, the classic self-bootstrapping process
  cbqn-bootstrap = lib.dontRecurseIntoAttrs {
    # Use clang to compile CBQN if we aren't already.
    # CBQN's upstream primarily targets and tests clang which means using gcc
    # will result in slower binaries and on some platforms failing/broken builds.
    # See https://github.com/dzaima/CBQN/issues/12.
    #
    # Known issues:
    #
    # * CBQN using gcc is broken at runtime on i686 due to
    #   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58416,
    # * CBQN uses some CPP macros gcc doesn't like for aarch64.
    stdenv = if !stdenv.cc.isClang then clangStdenv else stdenv;

    mbqn-source = buildPackages.mbqn.src;

    phase0 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      generateBytecode = false;
      # Not really used, but since null can be dangerous...
      bqn-interpreter = "${lib.getExe' buildPackages.mbqn "bqn"}";
    };

    phase0-replxx = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      enableReplxx = true;
      generateBytecode = false;
      # Not really used, but since null can be dangerous...
      bqn-interpreter = "${lib.getExe' buildPackages.mbqn "bqn"}";
    };

    phase1 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      generateBytecode = true;
      bqn-interpreter = "${lib.getExe' buildPackages.cbqn-bootstrap.phase0 "cbqn"}";
    };

    phase2 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      generateBytecode = true;
      bqn-interpreter = "${lib.getExe' buildPackages.cbqn-bootstrap.phase0 "cbqn"}";
    };

    phase2-replxx = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      generateBytecode = true;
      enableReplxx = true;
      bqn-interpreter = "${lib.getExe' buildPackages.cbqn-bootstrap.phase0 "cbqn"}";
    };
  };

  dbqn = callPackage ../by-name/db/dbqn/package.nix {
    buildNativeImage = false;
    jdk = jre;
    stdenv = stdenvNoCC;
  };

  dbqn-native = dbqn.override {
    buildNativeImage = true;
    jdk = graalvmPackages.graalvm-ce;
  };

  clojupyter = callPackage ../applications/editors/jupyter-kernels/clojupyter {
    jre = jre8;
  };

  inherit (callPackage ../applications/editors/jupyter-kernels/xeus-cling { })
    cpp11-kernel
    cpp14-kernel
    cpp17-kernel
    cpp2a-kernel
    xeus-cling
    ;

  clojure = callPackage ../development/interpreters/clojure {
    # set this to an LTS version of java
    jdk = jdk21;
  };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  dhall = haskell.lib.compose.justStaticExecutables haskellPackages.dhall;

  dhall-bash = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-bash;

  dhall-docs = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-docs;

  dhall-lsp-server = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-lsp-server;

  dhall-json = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-json;

  dhall-nix = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-nix;

  dhall-nixpkgs = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-nixpkgs;

  dhall-yaml = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-yaml;

  dhallPackages = recurseIntoAttrs (callPackage ./dhall-packages.nix { });

  beam = callPackage ./beam-packages.nix { };
  beam_minimal = callPackage ./beam-packages.nix {
    beam = beam_minimal;
    systemdSupport = false;
    wxSupport = false;
  };

  inherit (beam.interpreters)
    erlang
    erlang_28
    erlang_27
    erlang_26
    elixir
    elixir_1_18
    elixir_1_17
    elixir-ls
    ;

  inherit (beam.packages.erlang_26.beamPackages)
    elixir_1_16
    elixir_1_15
    elixir_1_14
    ;

  inherit (beam.packages.erlang)
    erlang-ls
    ex_doc
    erlfmt
    elvis-erlang
    rebar
    rebar3
    rebar3WithPlugins
    fetchHex
    lfe
    lfe_2_1
    ;

  beamPackages = dontRecurseIntoAttrs beam27Packages;
  beamMinimalPackages = dontRecurseIntoAttrs beamMinimal27Packages;

  beam26Packages = recurseIntoAttrs beam.packages.erlang_26.beamPackages;
  beam27Packages = recurseIntoAttrs beam.packages.erlang_27.beamPackages;
  # 28 is pre-release
  beam28Packages = dontRecurseIntoAttrs beam.packages.erlang_28.beamPackages;

  beamMinimal26Packages = recurseIntoAttrs beam_minimal.packages.erlang_26.beamPackages;
  beamMinimal27Packages = recurseIntoAttrs beam_minimal.packages.erlang_27.beamPackages;
  # 28 is pre-release
  beamMinimal28Packages = dontRecurseIntoAttrs beam_minimal.packages.erlang_28.beamPackages;

  gnudatalanguage = callPackage ../development/interpreters/gnudatalanguage {
    inherit (llvmPackages) openmp;
    # MPICH currently build on Darwin
    mpi = mpich;
  };

  inherit (callPackages ../applications/networking/cluster/hadoop { })
    hadoop_3_4
    hadoop_3_3
    hadoop2
    ;
  hadoop3 = hadoop_3_4;
  hadoop = hadoop3;

  jacinda = haskell.lib.compose.justStaticExecutables haskellPackages.jacinda;

  janet = callPackage ../development/interpreters/janet { };

  jpm = callPackage ../development/interpreters/janet/jpm.nix { };

  davmail = callPackage ../applications/networking/davmail {
    zulu = zulu11;
  };

  lambda-lisp-blc = lambda-lisp;

  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love_11 = callPackage ../development/interpreters/love/11.nix { };
  love = love_11;

  ### LUA interpreters
  emiluaPlugins = recurseIntoAttrs (
    callPackage ./emilua-plugins.nix { } (callPackage ../development/interpreters/emilua { })
  );

  inherit (emiluaPlugins) emilua;

  luaInterpreters = callPackage ./../development/interpreters/lua-5 { };
  inherit (luaInterpreters)
    lua5_1
    lua5_2
    lua5_2_compat
    lua5_3
    lua5_3_compat
    lua5_4
    lua5_4_compat
    luajit_2_1
    luajit_2_0
    luajit_openresty
    ;

  lua5 = lua5_2_compat;
  lua = lua5;

  lua51Packages = recurseIntoAttrs lua5_1.pkgs;
  lua52Packages = recurseIntoAttrs lua5_2.pkgs;
  lua53Packages = recurseIntoAttrs lua5_3.pkgs;
  lua54Packages = recurseIntoAttrs lua5_4.pkgs;
  luajitPackages = recurseIntoAttrs luajit.pkgs;

  luaPackages = lua52Packages;

  luajit = luajit_2_1;

  luarocks = luaPackages.luarocks;
  luarocks-nix = luaPackages.luarocks-nix;

  luarocks-packages-updater = callPackage ../by-name/lu/luarocks-packages-updater/package.nix {
    pluginupdate = ../../maintainers/scripts/pluginupdate-py;
  };

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  ### CuboCore
  CuboCore = recurseIntoAttrs (
    import ./cubocore-packages.nix {
      inherit
        newScope
        lxqt
        lib
        ;
    }
  );

  ### End of CuboCore

  obb = callPackage ../development/interpreters/clojure/obb.nix { };

  octave = callPackage ../development/interpreters/octave { };

  octaveFull = octave.override {
    enableQt = true;
  };

  octave-kernel = callPackage ../applications/editors/jupyter-kernels/octave { };

  octavePackages = recurseIntoAttrs octave.pkgs;

  # PHP interpreters, packages and extensions.
  #
  # Set default PHP interpreter, extensions and packages
  php = php84;
  phpExtensions = php.extensions;
  phpPackages = php.packages;

  # Import PHP84 interpreter, extensions and packages
  php84 = callPackage ../development/interpreters/php/8.4.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php84Extensions = recurseIntoAttrs php84.extensions;
  php84Packages = recurseIntoAttrs php84.packages;

  # Import PHP83 interpreter, extensions and packages
  php83 = callPackage ../development/interpreters/php/8.3.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php83Extensions = recurseIntoAttrs php83.extensions;
  php83Packages = recurseIntoAttrs php83.packages;

  # Import PHP82 interpreter, extensions and packages
  php82 = callPackage ../development/interpreters/php/8.2.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php82Extensions = recurseIntoAttrs php82.extensions;
  php82Packages = recurseIntoAttrs php82.packages;

  # Import PHP81 interpreter, extensions and packages
  php81 = callPackage ../development/interpreters/php/8.1.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php81Extensions = recurseIntoAttrs php81.extensions;
  php81Packages = recurseIntoAttrs php81.packages;

  polyml = callPackage ../development/compilers/polyml { };
  polyml56 = callPackage ../development/compilers/polyml/5.6.nix { };
  polyml57 = callPackage ../development/compilers/polyml/5.7.nix { };

  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  # When switching these sets, please update docs at ../../doc/languages-frameworks/python.md
  python2 = python27;
  python3 = python312;

  # pythonPackages further below, but assigned here because they need to be in sync
  python2Packages = dontRecurseIntoAttrs python27Packages;
  python3Packages = dontRecurseIntoAttrs python312Packages;

  pypy = pypy2;
  pypy2 = pypy27;
  pypy3 = pypy311;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  python2Full = python2.override {
    self = python2Full;
    pythonAttr = "python2Full";
    x11Support = true;
  };
  python27Full = python27.override {
    self = python27Full;
    pythonAttr = "python27Full";
    x11Support = true;
  };
  python3Full = python3.override {
    self = python3Full;
    pythonAttr = "python3Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };
  python310Full = python310.override {
    self = python310Full;
    pythonAttr = "python310Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };
  python311Full = python311.override {
    self = python311Full;
    pythonAttr = "python311Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };
  python312Full = python312.override {
    self = python312Full;
    pythonAttr = "python312Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };
  python313Full = python313.override {
    self = python313Full;
    pythonAttr = "python313Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };
  python314Full = python314.override {
    self = python314Full;
    pythonAttr = "python314Full";
    bluezSupport = lib.meta.availableOn stdenv.hostPlatform bluez;
    x11Support = true;
  };

  # https://py-free-threading.github.io
  python313FreeThreading = python313.override {
    self = python313FreeThreading;
    pythonAttr = "python313FreeThreading";
    enableGIL = false;
  };
  python314FreeThreading = python314.override {
    self = python314FreeThreading;
    pythonAttr = "python313FreeThreading";
    enableGIL = false;
  };

  pythonInterpreters = callPackage ./../development/interpreters/python { };
  inherit (pythonInterpreters)
    python27
    python310
    python311
    python312
    python313
    python314
    python3Minimal
    pypy27
    pypy310
    pypy311
    ;

  # List of extensions with overrides to apply to all Python package sets.
  pythonPackagesExtensions = [ ];

  # Python package sets.
  python27Packages = python27.pkgs;
  python310Packages = python310.pkgs;
  python311Packages = python311.pkgs;
  python312Packages = recurseIntoAttrs python312.pkgs;
  python313Packages = recurseIntoAttrs python313.pkgs;
  python314Packages = python314.pkgs;
  pypyPackages = pypy.pkgs;
  pypy2Packages = pypy2.pkgs;
  pypy27Packages = pypy27.pkgs;
  pypy3Packages = pypy3.pkgs;
  pypy310Packages = pypy310.pkgs;
  pypy311Packages = pypy311.pkgs;

  pythonManylinuxPackages = callPackage ./../development/interpreters/python/manylinux { };

  pythonCondaPackages = callPackage ./../development/interpreters/python/conda { };

  # Should eventually be moved inside Python interpreters.
  python-setup-hook = buildPackages.callPackage ../development/interpreters/python/setup-hook.nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs { });

  svg2tikz = with python3.pkgs; toPythonApplication svg2tikz;

  poetryPlugins = recurseIntoAttrs poetry.plugins;

  pipx = with python3.pkgs; toPythonApplication pipx;

  pipewire = callPackage ../development/libraries/pipewire {
    # ffmpeg depends on SDL2 which depends on pipewire by default.
    # Break the cycle by depending on ffmpeg-headless.
    # Pipewire only uses libavcodec (via an SPA plugin), which isn't
    # affected by the *-headless changes.
    ffmpeg = ffmpeg-headless;
  };

  wireplumber = callPackage ../development/libraries/pipewire/wireplumber.nix { };

  racket = callPackage ../development/interpreters/racket { };
  racket-minimal = callPackage ../development/interpreters/racket/minimal.nix {
    stdenv = stdenvAdapters.makeStaticLibraries stdenv;
  };

  rakudo = callPackage ../development/interpreters/rakudo { };
  moarvm = callPackage ../development/interpreters/rakudo/moarvm.nix { };
  nqp = callPackage ../development/interpreters/rakudo/nqp.nix { };
  zef = callPackage ../development/interpreters/rakudo/zef.nix { };

  inherit (ocamlPackages) reason rtop;

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config {
    inherit (darwin) DarwinTools autoSignDarwinBinariesHook;
  };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
  bundlerApp = callPackage ../development/ruby-modules/bundler-app { };
  bundlerUpdateScript = callPackage ../development/ruby-modules/bundler-update-script { };

  bundler-audit = callPackage ../tools/security/bundler-audit { };

  solargraph = rubyPackages.solargraph;

  inherit
    (callPackage ../development/interpreters/ruby {
      inherit (darwin) libunwind;
    })
    mkRubyVersion
    mkRuby
    ruby_3_1
    ruby_3_2
    ruby_3_3
    ruby_3_4
    ;

  ruby = ruby_3_3;
  rubyPackages = rubyPackages_3_3;

  rubyPackages_3_1 = recurseIntoAttrs ruby_3_1.gems;
  rubyPackages_3_2 = recurseIntoAttrs ruby_3_2.gems;
  rubyPackages_3_3 = recurseIntoAttrs ruby_3_3.gems;
  rubyPackages_3_4 = recurseIntoAttrs ruby_3_4.gems;

  samplebrain = libsForQt5.callPackage ../applications/audio/samplebrain { };

  inherit (callPackages ../applications/networking/cluster/spark { })
    spark_3_5
    spark_3_4
    ;
  spark3 = spark_3_5;
  spark = spark3;

  inherit
    ({
      spidermonkey_91 = callPackage ../development/interpreters/spidermonkey/91.nix { };
      spidermonkey_115 = callPackage ../development/interpreters/spidermonkey/115.nix { };
      spidermonkey_128 = callPackage ../development/interpreters/spidermonkey/128.nix { };
    })
    spidermonkey_91
    spidermonkey_115
    spidermonkey_128
    ;

  supercollider = libsForQt5.callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  supercolliderPlugins = recurseIntoAttrs {
    sc3-plugins = callPackage ../development/interpreters/supercollider/plugins/sc3-plugins.nix {
      fftw = fftwSinglePrec;
    };
  };

  supercollider-with-plugins = callPackage ../development/interpreters/supercollider/wrapper.nix {
    plugins = [ ];
  };

  supercollider-with-sc3-plugins = supercollider-with-plugins.override {
    plugins = with supercolliderPlugins; [ sc3-plugins ];
  };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };
  tcl-9_0 = callPackage ../development/interpreters/tcl/9.0.nix { };

  # We don't need versioned package sets thanks to the tcl stubs mechanism
  tclPackages = recurseIntoAttrs (callPackage ./tcl-packages.nix { });

  tclreadline = tclPackages.tclreadline;

  wasm = ocamlPackages.wasm;

  ### DEVELOPMENT / MISC

  inherit (callPackages ../development/misc/h3 { }) h3_3 h3_4;

  h3 = h3_3;

  avrlibc = callPackage ../development/misc/avr/libc {
    stdenv = stdenvNoLibc;
  };

  sourceFromHead = callPackage ../build-support/source-from-head-fun.nix { };

  jruby = callPackage ../development/interpreters/jruby { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  # Needed for autogen
  guile_2_0 = callPackage ../development/interpreters/guile/2.0.nix { };

  guile_2_2 = callPackage ../development/interpreters/guile/2.2.nix { };

  guile_3_0 = callPackage ../development/interpreters/guile/3.0.nix { };

  guile = guile_3_0;

  guile-sdl = callPackage ../by-name/gu/guile-sdl/package.nix {
    guile = guile_2_2;
  };

  guile-xcb = callPackage ../by-name/gu/guile-xcb/package.nix {
    guile = guile_2_2;
  };

  msp430GccSupport = callPackage ../development/misc/msp430/gcc-support.nix { };

  msp430Newlib = callPackage ../development/misc/msp430/newlib.nix { };

  mspds = callPackage ../development/misc/msp430/mspds { };
  mspds-bin = callPackage ../development/misc/msp430/mspds/binary.nix { };

  mspdebug = callPackage ../development/misc/msp430/mspdebug.nix { };

  vc4-newlib = callPackage ../development/misc/vc4/newlib.nix { };

  or1k-newlib = callPackage ../development/misc/or1k/newlib.nix { };

  ### DEVELOPMENT / TOOLS

  actiona = libsForQt5.callPackage ../applications/misc/actiona { };

  inherit (callPackage ../development/tools/alloy { })
    alloy5
    alloy6
    alloy
    ;

  anybadge = with python3Packages; toPythonApplication anybadge;

  ansible = ansible_2_18;
  ansible_2_18 = python3Packages.toPythonApplication python3Packages.ansible-core;
  ansible_2_17 = python3Packages.toPythonApplication (
    python3Packages.ansible-core.overridePythonAttrs (oldAttrs: rec {
      version = "2.17.8";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-Ob6KeYaix9NgabDZciC8L2eDxl/qfG1+Di0A0ayK+Hc=";
      };
    })
  );
  ansible_2_16 = python3Packages.toPythonApplication (
    python3Packages.ansible-core.overridePythonAttrs (oldAttrs: rec {
      version = "2.16.14";
      src = oldAttrs.src.override {
        inherit version;
        hash = "sha256-gCef/9mGhrrfqjLh7HhdmKbfGy/B5Al97AWXZA10ZBU=";
      };
    })
  );

  ansible-builder = with python3Packages; toPythonApplication ansible-builder;

  yakut = python3Packages.callPackage ../development/tools/misc/yakut { };

  ### DEVELOPMENT / TOOLS / LANGUAGE-SERVERS

  fortls = python3.pkgs.callPackage ../development/tools/language-servers/fortls { };

  fortran-language-server =
    python3.pkgs.callPackage ../development/tools/language-servers/fortran-language-server
      { };

  inherit (callPackages ../development/tools/language-servers/nixd { }) nixf nixt nixd;

  antlr2 = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };
  antlr3_4 = callPackage ../development/tools/parsing/antlr/3.4.nix { };
  antlr3_5 = callPackage ../development/tools/parsing/antlr/3.5.nix { };
  antlr3 = antlr3_5;

  inherit (callPackages ../development/tools/parsing/antlr/4.nix { })
    antlr4_8
    antlr4_9
    antlr4_10
    antlr4_11
    antlr4_12
    antlr4_13
    ;

  antlr4 = antlr4_13;

  antlr = antlr4;

  inherit (callPackages ../servers/apache-kafka { })
    apacheKafka_3_7
    apacheKafka_3_8
    apacheKafka_3_9
    apacheKafka_4_0
    ;

  apacheKafka = apacheKafka_4_0;

  asn2quickder = python3Packages.callPackage ../development/tools/asn2quickder { };

  libastyle = astyle.override { asLibrary = true; };

  aws-adfs = with python3Packages; toPythonApplication aws-adfs;

  electron-source = callPackage ../development/tools/electron { };

  inherit (callPackages ../development/tools/electron/binary { })
    electron_33-bin
    electron_34-bin
    electron_35-bin
    electron_36-bin
    electron_37-bin
    electron_38-bin
    ;

  inherit (callPackages ../development/tools/electron/chromedriver { })
    electron-chromedriver_33
    electron-chromedriver_34
    electron-chromedriver_35
    electron-chromedriver_36
    electron-chromedriver_37
    electron-chromedriver_38
    ;

  electron_33 = electron_33-bin;
  electron_34 = electron_34-bin;
  electron_35 = electron_35-bin;
  electron_36 =
    if lib.meta.availableOn stdenv.hostPlatform electron-source.electron_36 then
      electron-source.electron_36
    else
      electron_36-bin;
  electron_37 =
    if lib.meta.availableOn stdenv.hostPlatform electron-source.electron_37 then
      electron-source.electron_37
    else
      electron_37-bin;
  electron_38 =
    if lib.meta.availableOn stdenv.hostPlatform electron-source.electron_38 then
      electron-source.electron_38
    else
      electron_38-bin;
  electron = electron_37;
  electron-bin = electron_37-bin;
  electron-chromedriver = electron-chromedriver_37;

  autoconf = callPackage ../development/tools/misc/autoconf { };
  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };
  autoconf264 = callPackage ../development/tools/misc/autoconf/2.64.nix { };
  autoconf269 = callPackage ../development/tools/misc/autoconf/2.69.nix { };
  autoconf271 = callPackage ../development/tools/misc/autoconf/2.71.nix { };

  automake = automake116x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake115x = callPackage ../development/tools/misc/automake/automake-1.15.x.nix { };

  automake116x = callPackage ../development/tools/misc/automake/automake-1.16.x.nix { };

  automake117x = callPackage ../development/tools/misc/automake/automake-1.17.x.nix { };

  bandit = with python3Packages; toPythonApplication bandit;

  bazel = bazel_6;

  bazel_5 = callPackage ../development/tools/build-managers/bazel/bazel_5 {
    inherit (darwin) sigtool;
    buildJdk = jdk11_headless;
    runJdk = jdk11_headless;
    stdenv =
      if stdenv.cc.isClang then
        llvmPackages_17.stdenv
      else if stdenv.cc.isGNU then
        gcc12Stdenv
      else
        stdenv;
    bazel_self = bazel_5;
  };

  bazel_6 = callPackage ../development/tools/build-managers/bazel/bazel_6 {
    inherit (darwin) sigtool;
    buildJdk = jdk11_headless;
    runJdk = jdk11_headless;
    stdenv =
      if stdenv.cc.isClang then
        llvmPackages_17.stdenv
      else if stdenv.cc.isGNU then
        gcc12Stdenv
      else
        stdenv;
    bazel_self = bazel_6;
  };

  bazel_7 = callPackage ../development/tools/build-managers/bazel/bazel_7 {
    inherit (darwin) sigtool;
    buildJdk = jdk21_headless;
    runJdk = jdk21_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_17.stdenv else stdenv;
    bazel_self = bazel_7;
  };

  buildifier = bazel-buildtools;
  buildozer = bazel-buildtools;
  unused_deps = bazel-buildtools;

  buildBazelPackage = callPackage ../build-support/build-bazel-package { };

  binutils-unwrapped = callPackage ../development/tools/misc/binutils {
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };
  binutils-unwrapped-all-targets = callPackage ../development/tools/misc/binutils {
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
    withAllTargets = true;
  };
  binutils = wrapBintoolsWith {
    bintools = binutils-unwrapped;
  };
  binutils_nogold = lowPrio (wrapBintoolsWith {
    bintools = binutils-unwrapped.override {
      enableGold = false;
    };
  });
  binutilsNoLibc = wrapBintoolsWith {
    bintools = binutils-unwrapped;
    libc = preLibcCrossHeaders;
  };

  libbfd = callPackage ../development/tools/misc/binutils/libbfd.nix { };

  libopcodes = callPackage ../development/tools/misc/binutils/libopcodes.nix { };

  # Held back 2.38 release. Remove once all dependencies are ported to 2.39.
  binutils-unwrapped_2_38 = callPackage ../development/tools/misc/binutils/2.38 {
    autoreconfHook = autoreconfHook269;
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };

  libbfd_2_38 = callPackage ../development/tools/misc/binutils/2.38/libbfd.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libopcodes_2_38 = callPackage ../development/tools/misc/binutils/2.38/libopcodes.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  # Here we select the default bintools implementations to be used.  Note when
  # cross compiling these are used not for this stage but the *next* stage.
  # That is why we choose using this stage's target platform / next stage's
  # host platform.
  #
  # Because this is the *next* stages choice, it's a bit non-modular to put
  # here. In theory, bootstraping is supposed to not be a chain but at tree,
  # where each stage supports many "successor" stages, like multiple possible
  # futures. We don't have a better alternative, but with this downside in
  # mind, please be judicious when using this attribute. E.g. for building
  # things in *this* stage you should use probably `stdenv.cc.bintools` (from a
  # default or alternate `stdenv`), at build time, and try not to "force" a
  # specific bintools at runtime at all.
  #
  # In other words, try to only use this in wrappers, and only use those
  # wrappers from the next stage.
  bintools-unwrapped =
    let
      inherit (stdenv.targetPlatform) linker;
    in
    if linker == "lld" then
      llvmPackages.bintools-unwrapped
    else if linker == "cctools" then
      darwin.binutils-unwrapped
    else if linker == "bfd" then
      binutils-unwrapped
    else if linker == "gold" then
      binutils-unwrapped.override { enableGoldDefault = true; }
    else
      null;
  bintoolsNoLibc = wrapBintoolsWith {
    bintools = bintools-unwrapped;
    libc = preLibcCrossHeaders;
  };
  bintools = wrapBintoolsWith {
    bintools = bintools-unwrapped;
  };

  bintoolsDualAs = wrapBintoolsWith {
    bintools = darwin.binutilsDualAs-unwrapped;
    wrapGas = true;
  };

  black = with python3Packages; toPythonApplication black;

  black-macchiato = with python3Packages; toPythonApplication black-macchiato;

  buck = callPackage ../development/tools/build-managers/buck {
    python3 = python311;
  };

  build2 = callPackage ../development/tools/build-managers/build2 {
    # Break cycle by using self-contained toolchain for bootstrapping
    build2 = buildPackages.callPackage ../development/tools/build-managers/build2/bootstrap.nix { };
  };

  # Dependency of build2, must also break cycle for this
  libbutl = callPackage ../development/libraries/libbutl {
    build2 = build2.bootstrap;
    inherit (darwin) DarwinTools;
  };

  bdep = callPackage ../development/tools/build-managers/build2/bdep.nix { };

  bore-cli = callPackage ../tools/networking/bore-cli/default.nix { };

  bpkg = callPackage ../development/tools/build-managers/build2/bpkg.nix { };

  buildkite-test-collector-rust =
    callPackage ../development/tools/continuous-integration/buildkite-test-collector-rust
      {
      };

  libbpf = callPackage ../os-specific/linux/libbpf { };
  libbpf_0 = callPackage ../os-specific/linux/libbpf/0.x.nix { };

  bundlewrap = with python3.pkgs; toPythonApplication bundlewrap;

  # Wrapper that works as gcc or g++
  # It can be used by setting in nixpkgs config like this, for example:
  #    replaceStdenv = { pkgs }: pkgs.ccacheStdenv;
  # But if you build in chroot, you should have that path in chroot
  # If instantiated directly, it will use $HOME/.ccache as the cache directory,
  # i.e. /homeless-shelter/.ccache using the Nix daemon.
  # You should specify a different directory using an override in
  # packageOverrides to set extraConfig.
  #
  # Example using Nix daemon (i.e. multiuser Nix install or on NixOS):
  #    packageOverrides = pkgs: {
  #     ccacheWrapper = pkgs.ccacheWrapper.override {
  #       extraConfig = ''
  #         export CCACHE_COMPRESS=1
  #         export CCACHE_DIR=/var/cache/ccache
  #         export CCACHE_UMASK=007
  #       '';
  #     };
  # You can use a different directory, but whichever directory you choose
  # should be owned by user root, group nixbld with permissions 0770.
  ccacheWrapper =
    makeOverridable
      (
        { extraConfig, cc }:
        cc.override {
          cc = ccache.links {
            inherit extraConfig;
            unwrappedCC = cc.cc;
          };
        }
      )
      {
        extraConfig = "";
        inherit (stdenv) cc;
      };

  ccacheStdenv = lowPrio (
    makeOverridable
      (
        { stdenv, ... }@extraArgs:
        overrideCC stdenv (
          buildPackages.ccacheWrapper.override (
            {
              inherit (stdenv) cc;
            }
            // lib.optionalAttrs (builtins.hasAttr "extraConfig" extraArgs) {
              extraConfig = extraArgs.extraConfig;
            }
          )
        )
      )
      {
        inherit stdenv;
      }
  );

  matter-compiler = callPackage ../development/compilers/matter-compiler { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cloudcompare = callPackage ../applications/graphics/cloudcompare { };

  cookiecutter = with python3Packages; toPythonApplication cookiecutter;

  corundum = callPackage ../development/tools/corundum { };

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = callPackage ../development/tools/misc/ctags/wrapped.nix { };

  cubiomes-viewer = libsForQt5.callPackage ../applications/misc/cubiomes-viewer { };

  # can't use override - it triggers infinite recursion
  cmakeMinimal = callPackage ../by-name/cm/cmake/package.nix {
    isMinimalBuild = true;
  };

  cmakeCurses = cmake.override {
    uiToolkits = [ "ncurses" ];
  };

  cmakeWithGui = cmake.override {
    uiToolkits = [
      "ncurses"
      "qt5"
    ];
  };

  cmake-format = python3Packages.callPackage ../development/tools/cmake-format { };

  cmake-language-server =
    python3Packages.callPackage ../development/tools/misc/cmake-language-server
      {
        inherit cmake cmake-format;
      };

  # Does not actually depend on Qt 5
  inherit (plasma5Packages) extra-cmake-modules;

  coccinelle = callPackage ../development/tools/misc/coccinelle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  credstash = with python3Packages; toPythonApplication credstash;

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (llvmPackages_16) llvm libclang;
  };

  inherit (nodePackages) csslint;

  css-html-js-minify = with python3Packages; toPythonApplication css-html-js-minify;

  cvise = python3Packages.callPackage ../development/tools/misc/cvise {
    # cvise keeps up with fresh llvm releases and supports wide version range
    inherit (llvmPackages) llvm libclang;
  };

  daggerfall-unity-unfree = daggerfall-unity.override {
    pname = "daggerfall-unity-unfree";
    includeUnfree = true;
  };

  dbt = with python3Packages; toPythonApplication dbt-core;

  devbox = callPackage ../development/tools/devbox { buildGoModule = buildGo124Module; };

  libcxx = llvmPackages.libcxx;

  libgcc = stdenv.cc.cc.libgcc or null;

  # This is for e.g. LLVM libraries on linux.
  gccForLibs =
    if
      stdenv.targetPlatform == stdenv.hostPlatform && targetPackages.stdenv.cc.isGNU
    # Can only do this is in the native case, otherwise we might get infinite
    # recursion if `targetPackages.stdenv.cc.cc` itself uses `gccForLibs`.
    then
      targetPackages.stdenv.cc.cc
    else
      gcc.cc;

  libsigrok = callPackage ../development/tools/libsigrok { };

  distcc = callPackage ../development/tools/misc/distcc {
    libiberty_static = libiberty.override { staticBuild = true; };
  };

  # distccWrapper: wrapper that works as gcc or g++
  # It can be used by setting in nixpkgs config like this, for example:
  #    replaceStdenv = { pkgs }: pkgs.distccStdenv;
  # But if you build in chroot, a default 'nix' will create
  # a new net namespace, and won't have network access.
  # You can use an override in packageOverrides to set extraConfig:
  #    packageOverrides = pkgs: {
  #     distccWrapper = pkgs.distccWrapper.override {
  #       extraConfig = ''
  #         DISTCC_HOSTS="myhost1 myhost2"
  #       '';
  #     };
  #
  distccWrapper = makeOverridable (
    {
      extraConfig ? "",
    }:
    wrapCC (distcc.links extraConfig)
  ) { };
  distccStdenv = lowPrio (overrideCC stdenv buildPackages.distccWrapper);

  distccMasquerade =
    if stdenv.hostPlatform.isDarwin then
      null
    else
      callPackage ../development/tools/misc/distcc/masq.nix {
        gccRaw = gcc.cc;
        binutils = binutils;
      };

  docutils = with python3Packages; toPythonApplication docutils;

  doit = with python3Packages; toPythonApplication doit;

  dot2tex = with python3.pkgs; toPythonApplication dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt5 = null;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt5; });

  drake = callPackage ../development/tools/build-managers/drake { };

  edb = libsForQt5.callPackage ../development/tools/misc/edb { };

  license_finder = callPackage ../development/tools/license_finder { };

  # NOTE: Override and set useIcon = false to use Awk instead of Icon.
  fffuu = haskell.lib.compose.justStaticExecutables (
    haskellPackages.callPackage ../tools/misc/fffuu { }
  );

  flow = callPackage ../development/tools/analysis/flow {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  framac = callPackage ../by-name/fr/framac/package.nix {
    ocamlPackages = ocaml-ng.ocamlPackages_5_2;
    why3 = why3.override {
      version = "1.7.2";
      coqPackages = coqPackages_8_18;
      ocamlPackages = ocaml-ng.ocamlPackages_5_2;
    };
  };

  fswatch = callPackage ../development/tools/misc/fswatch {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  gede = libsForQt5.callPackage ../development/tools/misc/gede { };

  gdbgui = python3Packages.callPackage ../development/tools/misc/gdbgui { };

  pmd = callPackage ../development/tools/analysis/pmd {
    openjdk = openjdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  jdepend = callPackage ../development/tools/analysis/jdepend {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex = callPackage ../development/tools/parsing/flex { };

  m4 = gnum4;

  gn_2233 = callPackage ../by-name/gn/gn/2233.nix { };

  gnumake = callPackage ../development/tools/build-managers/gnumake { };
  gradle-packages = import ../development/tools/build-managers/gradle {
    inherit
      jdk17
      jdk21
      jdk23
      ;
  };
  gradleGen = gradle-packages.gen;
  wrapGradle = callPackage gradle-packages.wrapGradle { };

  gradle_7-unwrapped = callPackage gradle-packages.gradle_7 { };
  gradle_8-unwrapped = callPackage gradle-packages.gradle_8 { };
  gradle-unwrapped = gradle_8-unwrapped;

  gradle_7 = wrapGradle gradle_7-unwrapped null;
  gradle_8 = wrapGradle gradle_8-unwrapped null;
  gradle = wrapGradle gradle-unwrapped "gradle-unwrapped";

  gperf = callPackage ../development/tools/misc/gperf { };
  # 3.1 changed some parameters from int to size_t, leading to mismatches.
  gperf_3_0 = callPackage ../development/tools/misc/gperf/3.0.x.nix { };

  griffe = with python3Packages; toPythonApplication griffe;

  gwrap = g-wrap;
  g-wrap = callPackage ../by-name/g-/g-wrap/package.nix {
    guile = guile_2_2;
  };

  hadolint =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.hadolint;

  iaca_2_1 = callPackage ../development/tools/iaca/2.1.nix { };
  iaca_3_0 = callPackage ../development/tools/iaca/3.0.nix { };
  iaca = iaca_3_0;

  ikos = callPackage ../development/tools/analysis/ikos {
    inherit (llvmPackages_14) stdenv clang llvm;
    tbb = tbb_2021_11;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_20;
  };

  inherit (callPackage ../applications/misc/inochi2d { })
    inochi-creator
    inochi-session
    ;

  javacc = callPackage ../development/tools/parsing/javacc {
    # Upstream doesn't support anything newer than Java 8.
    # https://github.com/javacc/javacc/blob/c708628423b71ce8bc3b70143fa5b6a2b7362b3a/README.md#building-javacc-from-source
    jdk = jdk8;
    jre = jre8;
  };

  jenkins-job-builder = with python3Packages; toPythonApplication jenkins-job-builder;

  kcc = callPackage ../applications/graphics/kcc { };

  kustomize = callPackage ../development/tools/kustomize { };

  kustomize_3 = callPackage ../development/tools/kustomize/3.nix { };

  kustomize_4 = callPackage ../development/tools/kustomize/4.nix { };

  kustomize-sops = callPackage ../development/tools/kustomize/kustomize-sops.nix { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  linuxkit = callPackage ../development/tools/misc/linuxkit {
    inherit (darwin) sigtool;
  };

  lit = with python3Packages; toPythonApplication lit;

  massif-visualizer = libsForQt5.callPackage ../development/tools/analysis/massif-visualizer { };

  maven3 = maven;
  inherit (maven) buildMaven;

  mavproxy = python3Packages.callPackage ../applications/science/robotics/mavproxy { };

  mdl = callPackage ../development/tools/misc/mdl { };

  meraki-cli = python3Packages.callPackage ../tools/admin/meraki-cli { };

  python-matter-server =
    with python3Packages;
    toPythonApplication (
      python-matter-server.overridePythonAttrs (oldAttrs: {
        dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.server;
      })
    );

  minizinc = callPackage ../development/tools/minizinc { };
  minizincide = qt6Packages.callPackage ../development/tools/minizinc/ide.nix { };

  mkdocs = with python3Packages; toPythonApplication mkdocs;

  mold-wrapped = wrapBintoolsWith {
    bintools = mold;
    extraBuildCommands = ''
      wrap ${targetPackages.stdenv.cc.bintools.targetPrefix}ld.mold ${../build-support/bintools-wrapper/ld-wrapper.sh} ${mold}/bin/ld.mold
      wrap ${targetPackages.stdenv.cc.bintools.targetPrefix}mold ${../build-support/bintools-wrapper/ld-wrapper.sh} ${mold}/bin/mold
    '';
  };

  mopsa = ocamlPackages.mopsa.bin;

  haskell-ci =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.haskell-ci;

  nixbang = callPackage ../development/tools/misc/nixbang {
    pythonPackages = python3Packages;
  };

  nexusmods-app-unfree = nexusmods-app.override {
    pname = "nexusmods-app-unfree";
    _7zz = _7zz-rar;
  };

  nwjs = callPackage ../development/tools/nwjs { };

  nwjs-sdk = callPackage ../development/tools/nwjs {
    sdk = true;
  };

  obelisk = callPackage ../development/tools/ocaml/obelisk { menhir = ocamlPackages.menhir; };

  openai = with python3Packages; toPythonApplication openai;

  openai-whisper = with python3.pkgs; toPythonApplication openai-whisper;

  openocd-rp2040 = openocd.overrideAttrs (old: {
    pname = "openocd-rp2040";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "openocd";
      rev = "4d87f6dcae77d3cbcd8ac3f7dc887adf46ffa504";
      hash = "sha256-bBqVoHsnNoaC2t8hqcduI8GGlO0VDMUovCB0HC+rxvc=";
      # openocd disables the vendored libraries that use submodules and replaces them with nix versions.
      # this works out as one of the submodule sources seems to be flakey.
      fetchSubmodules = false;
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      autoreconfHook
    ];
  });

  oprofile = callPackage ../development/tools/profiling/oprofile {
    libiberty_static = libiberty.override { staticBuild = true; };
  };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  pgcli = with pkgs.python3Packages; toPythonApplication pgcli;

  pkgconf-unwrapped = libpkgconf;

  pkgconf = callPackage ../build-support/pkg-config-wrapper {
    pkg-config = pkgconf-unwrapped;
    baseBinName = "pkgconf";
  };

  pkg-config = callPackage ../build-support/pkg-config-wrapper {
    pkg-config = pkg-config-unwrapped;
  };

  pkg-configUpstream = lowPrio (
    pkg-config.override (old: {
      pkg-config = old.pkg-config.override {
        vanilla = true;
      };
    })
  );

  portableService = callPackage ../build-support/portable-service { };

  polar = callPackage ../tools/misc/polar { };

  pyprof2calltree = with python3Packages; toPythonApplication pyprof2calltree;

  premake4 = callPackage ../development/tools/misc/premake { };

  premake5 = callPackage ../development/tools/misc/premake/5.nix { };

  premake = premake4;

  pry = callPackage ../development/tools/pry { };

  pycritty = with python3Packages; toPythonApplication pycritty;

  qtcreator = qt6Packages.callPackage ../development/tools/qtcreator {
    inherit (linuxPackages) perf;
    llvmPackages = llvmPackages_18;
    stdenv = llvmPackages_18.stdenv;
  };

  qxmledit = libsForQt5.callPackage ../applications/editors/qxmledit { };

  radare2 = callPackage ../development/tools/analysis/radare2 (
    {
      lua = lua5;
    }
    // (config.radare or { })
  );

  rizin = pkgs.callPackage ../development/tools/analysis/rizin { };

  rizinPlugins = recurseIntoAttrs rizin.plugins;

  cutter = qt6.callPackage ../development/tools/analysis/rizin/cutter.nix { };

  cutterPlugins = recurseIntoAttrs cutter.plugins;

  ragel = ragelStable;

  inherit (callPackages ../development/tools/parsing/ragel { }) ragelStable ragelDev;

  redis-dump = callPackage ../development/tools/redis-dump { };

  inherit (regclient) regbot regctl regsync;

  reno = with python312Packages; toPythonApplication reno;

  replace-secret = callPackage ../build-support/replace-secret/replace-secret.nix { };

  inherit (callPackage ../development/tools/replay-io { })
    replay-io
    replay-node-cli
    ;

  rescript-language-server = callPackage ../by-name/re/rescript-language-server/package.nix {
    rescript-editor-analysis = vscode-extensions.chenglou92.rescript-vscode.rescript-editor-analysis;
  };

  rnginline = with python3Packages; toPythonApplication rnginline;

  rr = callPackage ../development/tools/analysis/rr { };

  muonStandalone = muon.override {
    embedSamurai = true;
    buildDocs = false;
  };

  seer = libsForQt5.callPackage ../development/tools/misc/seer { };

  semantik = libsForQt5.callPackage ../applications/office/semantik { };

  sbt = callPackage ../development/tools/build-managers/sbt { };
  sbt-with-scala-native = callPackage ../development/tools/build-managers/sbt/scala-native.nix { };
  simpleBuildTool = sbt;

  scss-lint = callPackage ../development/tools/scss-lint { };

  shake =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.shake;

  shellcheck = callPackage ../development/tools/shellcheck {
    inherit (__splicedPackages.haskellPackages) ShellCheck;
  };

  # Minimal shellcheck executable for package checks.
  # Use shellcheck which does not include docs, as
  # pandoc takes long to build and documentation isn't needed for just running the cli
  shellcheck-minimal = haskell.lib.compose.justStaticExecutables shellcheck.unwrapped;

  sloc = nodePackages.sloc;

  slurm = callPackage ../by-name/sl/slurm/package.nix {
    nvml = cudaPackages.cuda_nvml_dev;
  };

  snowman = qt5.callPackage ../development/tools/analysis/snowman { };

  sparse = callPackage ../development/tools/analysis/sparse {
    llvm = llvm_14;
  };

  speedtest-cli = with python3Packages; toPythonApplication speedtest-cli;

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  spoofer = callPackage ../tools/networking/spoofer {
    protobuf = protobuf_21;
  };

  spoofer-gui = callPackage ../tools/networking/spoofer {
    withGUI = true;
    protobuf = protobuf_21;
  };

  sqlitebrowser = libsForQt5.callPackage ../development/tools/database/sqlitebrowser { };

  sqlite-utils = with python3Packages; toPythonApplication sqlite-utils;

  sqlmap = with python3Packages; toPythonApplication sqlmap;

  c0 = callPackage ../development/compilers/c0 {
    stdenv = if stdenv.hostPlatform.isDarwin then gccStdenv else stdenv;
  };

  swftools = callPackage ../tools/video/swftools {
    stdenv = gccStdenv;
  };

  teensyduino = arduino-core.override {
    withGui = true;
    withTeensyduino = true;
  };

  tytools = libsForQt5.callPackage ../development/embedded/tytools { };

  texinfoPackages = callPackages ../development/tools/misc/texinfo/packages.nix { };
  inherit (texinfoPackages)
    texinfo413
    texinfo6_5 # needed for allegro
    texinfo6_7 # needed for gpm, iksemel and fwknop
    texinfo6
    texinfo7
    ;
  texinfo4 = texinfo413; # needed for eukleides and singular
  texinfo = texinfo7;
  texinfoInteractive = texinfo.override { interactive = true; };

  tflint-plugins = recurseIntoAttrs (callPackage ../development/tools/analysis/tflint-plugins { });

  travis = callPackage ../development/tools/misc/travis { };

  tree-sitter = makeOverridable (callPackage ../development/tools/parsing/tree-sitter) { };

  tree-sitter-grammars = recurseIntoAttrs tree-sitter.builtGrammars;

  uhdMinimal = uhd.override {
    enableUtils = false;
    enablePythonApi = false;
  };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
  };

  gdbHostCpuOnly = gdb.override { hostCpuOnly = true; };

  jprofiler = callPackage ../development/tools/java/jprofiler {
    jdk = jdk11;
  };

  valgrind-light = (valgrind.override { gdb = null; }).overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      description = "${oldAttrs.meta.description} (without GDB)";
    };
  });

  qcachegrind = libsForQt5.callPackage ../development/tools/analysis/qcachegrind { };

  vcpkg-tool-unwrapped = vcpkg-tool.override { doWrap = false; };

  wails = callPackage ../development/tools/wails {
    stdenv = gccStdenv;
  };

  whatstyle = callPackage ../development/tools/misc/whatstyle {
    inherit (llvmPackages) clang-unwrapped;
  };

  whisper-cpp-vulkan = whisper-cpp.override {
    vulkanSupport = true;
  };

  watson-ruby = callPackage ../development/tools/misc/watson-ruby { };

  xcbuild = callPackage ../by-name/xc/xcbuild/package.nix {
    stdenv =
      # xcbuild is included in the SDK. Avoid an infinite recursion by using a bootstrap stdenv.
      if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
  };

  xcbuildHook = makeSetupHook {
    name = "xcbuild-hook";
    propagatedBuildInputs = [ xcbuild ];
  } ../by-name/xc/xcbuild/setup-hook.sh;

  xcodebuild = xcbuild;

  xxdiff = libsForQt5.callPackage ../development/tools/misc/xxdiff { };

  xxdiff-tip = xxdiff;

  yourkit-java = callPackage ../by-name/yo/yourkit-java/package.nix {
    jre = jdk21;
  };

  yq = python3.pkgs.toPythonApplication python3.pkgs.yq;

  mypy = with python3Packages; toPythonApplication mypy;

  mypy-protobuf = with python3Packages; toPythonApplication mypy-protobuf;

  basedmypy = with python3Packages; toPythonApplication basedmypy;

  ### DEVELOPMENT / LIBRARIES

  abseil-cpp_202103 = callPackage ../development/libraries/abseil-cpp/202103.nix { };
  abseil-cpp_202301 = callPackage ../development/libraries/abseil-cpp/202301.nix { };
  abseil-cpp_202401 = callPackage ../development/libraries/abseil-cpp/202401.nix { };
  abseil-cpp_202407 = callPackage ../development/libraries/abseil-cpp/202407.nix { };
  abseil-cpp = abseil-cpp_202501;

  acl = callPackage ../development/libraries/acl { };

  agg = callPackage ../development/libraries/agg {
    stdenv = gccStdenv;
  };

  allegro = allegro4;
  allegro4 = callPackage ../development/libraries/allegro { };
  allegro5 = callPackage ../development/libraries/allegro/5.nix { };

  ansi2html = with python3.pkgs; toPythonApplication ansi2html;

  appstream = callPackage ../development/libraries/appstream { };

  apr = callPackage ../development/libraries/apr {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  argparse-manpage = with python3Packages; toPythonApplication argparse-manpage;

  asio_1_10 = callPackage ../development/libraries/asio/1.10.nix { };
  asio = callPackage ../development/libraries/asio { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix { });

  aspellWithDicts = callPackage ../development/libraries/aspell/aspell-with-dicts.nix {
    aspell = aspell.override { searchNixProfiles = false; };
  };

  astal = recurseIntoAttrs (lib.makeScope newScope (callPackage ../development/libraries/astal { }));

  attr = callPackage ../development/libraries/attr { };

  # Not moved to aliases while we decide if we should split the package again.
  at-spi2-atk = at-spi2-core;

  aqbanking = callPackage ../development/libraries/aqbanking { };

  aws-spend-summary = haskellPackages.aws-spend-summary.bin;

  inherit (callPackages ../development/libraries/bashup-events { }) bashup-events32 bashup-events44;

  bc-soci = callPackage ../development/libraries/soci/bc-soci.nix { };

  # TODO(@Ericson2314): Build bionic libc from source
  bionic =
    if stdenv.hostPlatform.useAndroidPrebuilt then
      pkgs."androidndkPkgs_${stdenv.hostPlatform.androidNdkVersion}".libraries
    else
      callPackage ../os-specific/linux/bionic-prebuilt { };

  inherit (callPackage ../development/libraries/boost { inherit (buildPackages) boost-build; })
    boost177
    boost178
    boost179
    boost180
    boost181
    boost182
    boost183
    boost186
    boost187
    boost188
    ;

  boost = boost187;

  inherit (callPackages ../development/libraries/botan { })
    botan2
    botan3
    ;

  c-ares = callPackage ../development/libraries/c-ares { };

  c-aresMinimal = callPackage ../development/libraries/c-ares {
    withCMake = false;
  };

  inherit (callPackages ../development/libraries/c-blosc { })
    c-blosc
    c-blosc2
    ;

  cachix = (lib.getBin haskellPackages.cachix).overrideAttrs (old: {
    meta = (old.meta or { }) // {
      mainProgram = old.meta.mainProgram or "cachix";
    };
  });

  hercules-ci-agent = callPackage ../development/tools/continuous-integration/hercules-ci-agent { };

  hci = callPackage ../development/tools/continuous-integration/hci { };

  niv = lib.getBin (haskell.lib.compose.justStaticExecutables haskellPackages.niv);

  ormolu = lib.getBin (haskell.lib.compose.justStaticExecutables haskellPackages.ormolu);

  catboost = callPackage ../by-name/ca/catboost/package.nix {
    # https://github.com/catboost/catboost/issues/2540
    cudaPackages = cudaPackages_11;
    llvmPackagesCuda = llvmPackages_14;
  };

  cctag = callPackage ../development/libraries/cctag {
    stdenv = clangStdenv;
    tbb = tbb_2021_11;
  };

  ceedling = callPackage ../development/tools/ceedling { };

  celt = callPackage ../development/libraries/celt { };
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix { };
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix { };

  certbot-full = certbot.withPlugins (
    cp: with cp; [
      # FIXME unbreak certbot-dns-cloudflare
      certbot-dns-google
      certbot-dns-inwx
      certbot-dns-ovh
      certbot-dns-rfc2136
      certbot-dns-route53
    ]
  );

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core = clucene_core_2;

  codecserver = callPackage ../applications/audio/codecserver {
    protobuf = protobuf_21;
  };

  inherit (cosmopolitan) cosmocc;

  ctranslate2 = callPackage ../development/libraries/ctranslate2 rec {
    stdenv = if withCUDA then gcc11Stdenv else pkgs.stdenv;
    withCUDA = pkgs.config.cudaSupport;
    withCuDNN = withCUDA && (cudaPackages ? cudnn);
    cudaPackages = pkgs.cudaPackages;
  };

  ustream-ssl = callPackage ../development/libraries/ustream-ssl { ssl_implementation = openssl; };

  ustream-ssl-wolfssl = callPackage ../development/libraries/ustream-ssl {
    ssl_implementation = wolfssl;
    additional_buildInputs = [ openssl ];
  };

  ustream-ssl-mbedtls = callPackage ../development/libraries/ustream-ssl {
    ssl_implementation = mbedtls_2;
  };

  cxxtest = python3Packages.callPackage ../development/libraries/cxxtest { };

  # Make bdb5 the default as it is the last release under the custom
  # bsd-like license
  db = db5;
  db4 = db48;
  db48 = callPackage ../development/libraries/db/db-4.8.nix { };
  db5 = db53;
  db53 = callPackage ../development/libraries/db/db-5.3.nix { };
  db6 = db60;
  db60 = callPackage ../development/libraries/db/db-6.0.nix { };
  db62 = callPackage ../development/libraries/db/db-6.2.nix { };

  dbus = callPackage ../development/libraries/dbus { };
  dbus-sharp-1_0 = callPackage ../development/libraries/dbus-sharp/dbus-sharp-1.0.nix { };
  dbus-sharp-2_0 = callPackage ../development/libraries/dbus-sharp { };

  dbus-sharp-glib-1_0 =
    callPackage ../development/libraries/dbus-sharp-glib/dbus-sharp-glib-1.0.nix
      { };
  dbus-sharp-glib-2_0 = callPackage ../development/libraries/dbus-sharp-glib { };

  makeDBusConf = callPackage ../development/libraries/dbus/make-dbus-conf.nix { };

  dee = callPackage ../development/libraries/dee {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  draco = callPackage ../development/libraries/draco {
    tinygltf = callPackage ../development/libraries/draco/tinygltf.nix { };
  };

  # Multi-arch "drivers" which we want to build for i686.
  driversi686Linux = recurseIntoAttrs {
    inherit (pkgsi686Linux)
      amdvlk
      intel-media-driver
      intel-vaapi-driver
      mesa
      mesa-demos
      libva-vdpau-driver
      libvdpau-va-gl
      vdpauinfo
      ;
  };

  eccodes = callPackage ../development/libraries/eccodes {
    pythonPackages = python3Packages;
    stdenv = if stdenv.hostPlatform.isDarwin then gccStdenv else stdenv;
  };

  vapoursynth-editor = libsForQt5.callPackage ../by-name/va/vapoursynth/editor.nix { };

  # TODO: Fix references and add justStaticExecutables https://github.com/NixOS/nixpkgs/issues/318013
  emanote = haskellPackages.emanote;

  enchant2 = callPackage ../development/libraries/enchant/2.x.nix { };
  enchant = enchant2;

  factorPackages-0_99 = callPackage ./factor-packages.nix {
    factor-unwrapped = callPackage ../development/compilers/factor-lang/0.99.nix { };
  };
  factorPackages-0_100 = callPackage ./factor-packages.nix {
    factor-unwrapped = callPackage ../development/compilers/factor-lang/0.100.nix { };
  };
  factorPackages = factorPackages-0_100;

  factor-lang-0_99 = factorPackages-0_99.factor-lang;
  factor-lang-0_100 = factorPackages-0_100.factor-lang;
  factor-lang = factor-lang-0_100;

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-libav
      ;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  inherit (callPackage ../development/libraries/ffmpeg { })
    ffmpeg_4
    ffmpeg_4-headless
    ffmpeg_4-full
    ffmpeg_6
    ffmpeg_6-headless
    ffmpeg_6-full
    ffmpeg_7
    ffmpeg_7-headless
    ffmpeg_7-full
    ffmpeg
    ffmpeg-headless
    ffmpeg-full
    ;

  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };
  # Need gcc >= 4.6.0 to build with FFTW with quad precision, but Darwin defaults to Clang
  fftwQuad = fftw.override {
    precision = "quad-precision";
    stdenv = gccStdenv;
  };
  fftwMpi = fftw.override { enableMpi = true; };

  flint = flint3;

  flint3 = callPackage ../development/libraries/flint/3.nix { };

  fltk13 = callPackage ../development/libraries/fltk { };
  fltk14 = callPackage ../development/libraries/fltk/1.4.nix { };
  fltk13-minimal = fltk13.override {
    withGL = false;
    withCairo = false;
    withPango = false;
    withExamples = false;
    withDocs = false;
  };
  fltk14-minimal = fltk14.override {
    withGL = false;
    withCairo = false;
    withPango = false;
    withExamples = false;
    withDocs = false;
  };
  fltk = fltk13;
  fltk-minimal = fltk13-minimal;

  inherit (callPackages ../development/libraries/fmt { }) fmt_9 fmt_10 fmt_11;

  fmt = fmt_10;

  fplll = callPackage ../development/libraries/fplll { };
  fplll_20160331 = callPackage ../development/libraries/fplll/20160331.nix { };

  freeimage = callPackage ../by-name/fr/freeimage/package.nix {
    openexr = openexr_2;
  };

  freeipa = callPackage ../os-specific/linux/freeipa {
    # NOTE: freeipa and sssd need to be built with the same version of python
    kerberos = krb5.override {
      withVerto = true;
    };
    sasl = cyrus_sasl;
    samba = samba4.override {
      enableLDAP = true;
    };
  };

  frog = res.languageMachines.frog;

  fontconfig = callPackage ../development/libraries/fontconfig { };

  makeFontsConf = callPackage ../development/libraries/fontconfig/make-fonts-conf.nix { };

  makeFontsCache = callPackage ../development/libraries/fontconfig/make-fonts-cache.nix { };

  gamenetworkingsockets = callPackage ../development/libraries/gamenetworkingsockets {
    protobuf = protobuf_21;
  };

  gamt = callPackage ../by-name/am/amtterm/package.nix { withGamt = true; };

  gcr = callPackage ../development/libraries/gcr { };

  gcr_4 = callPackage ../development/libraries/gcr/4.nix { };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_6 = qt5.callPackage ../development/libraries/gecode { };
  gecode = gecode_6;

  gegl = callPackage ../development/libraries/gegl {
    openexr = openexr_2;
  };

  geoclue2-with-demo-agent = geoclue2.override { withDemoAgent = true; };

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  geos = callPackage ../development/libraries/geos { };

  geos_3_9 = callPackage ../development/libraries/geos/3.9.nix { };

  gettext = callPackage ../development/libraries/gettext { };

  gdalMinimal = gdal.override {
    useMinimalFeatures = true;
  };

  gdcm = callPackage ../development/libraries/gdcm {
    inherit (darwin) DarwinTools;
  };

  givaro = callPackage ../development/libraries/givaro { };

  ghp-import = with python3Packages; toPythonApplication ghp-import;

  ghcid = haskellPackages.ghcid.bin;

  graphia = qt6Packages.callPackage ../applications/science/misc/graphia { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix { };
  glfw = glfw3;
  glfw2 = callPackage ../development/libraries/glfw/2.x.nix { };

  glfw3-minecraft = callPackage ../by-name/gl/glfw3/package.nix {
    withMinecraftPatch = true;
  };

  glibc = callPackage ../development/libraries/glibc {
    stdenv = gccStdenv; # doesn't compile without gcc
  };

  mtrace = callPackage ../development/libraries/glibc/mtrace.nix { };

  # Provided by libc on Operating Systems that use the Extensible Linker Format.
  elf-header = if stdenv.hostPlatform.isElf then null else elf-header-real;

  glibc_memusage = callPackage ../development/libraries/glibc {
    withGd = true;
  };

  # Being redundant to avoid cycles on boot. TODO: find a better way
  glibcCross = callPackage ../development/libraries/glibc {
    stdenv = gccCrossLibcStdenv; # doesn't compile without gcc
    libgcc = callPackage ../development/libraries/gcc/libgcc {
      gcc = gccCrossLibcStdenv.cc;
      glibc = glibcCross.override { libgcc = null; };
      stdenvNoLibs = gccCrossLibcStdenv;
    };
  };

  muslCross = musl.override {
    stdenv = stdenvNoLibc;
  };

  # These are used when buiding compiler-rt / libgcc, prior to building libc.
  preLibcCrossHeaders =
    let
      inherit (stdenv.targetPlatform) libc;
    in
    if stdenv.targetPlatform.isMinGW then
      targetPackages.windows.mingw_w64_headers or windows.mingw_w64_headers
    else if libc == "nblibc" then
      targetPackages.netbsd.headers or netbsd.headers
    else
      null;

  # We can choose:
  libcCrossChooser =
    name:
    # libc is hackily often used from the previous stage. This `or`
    # hack fixes the hack, *sigh*.
    if name == null then
      null
    else if name == "glibc" then
      targetPackages.glibcCross or glibcCross
    else if name == "bionic" then
      targetPackages.bionic or bionic
    else if name == "uclibc" then
      targetPackages.uclibc or uclibc
    else if name == "avrlibc" then
      targetPackages.avrlibc or avrlibc
    else if name == "newlib" && stdenv.targetPlatform.isMsp430 then
      targetPackages.msp430Newlib or msp430Newlib
    else if name == "newlib" && stdenv.targetPlatform.isVc4 then
      targetPackages.vc4-newlib or vc4-newlib
    else if name == "newlib" && stdenv.targetPlatform.isOr1k then
      targetPackages.or1k-newlib or or1k-newlib
    else if name == "newlib" then
      targetPackages.newlib or newlib
    else if name == "newlib-nano" then
      targetPackages.newlib-nano or newlib-nano
    else if name == "musl" then
      targetPackages.muslCross or muslCross
    else if name == "msvcrt" then
      targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if name == "ucrt" then
      targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if name == "libSystem" then
      if stdenv.targetPlatform.useiOSPrebuilt then
        targetPackages.darwin.iosSdkPkgs.libraries or darwin.iosSdkPkgs.libraries
      else
        targetPackages.darwin.libSystem or darwin.libSystem
    else if name == "fblibc" then
      targetPackages.freebsd.libc or freebsd.libc
    else if name == "oblibc" then
      targetPackages.openbsd.libc or openbsd.libc
    else if name == "nblibc" then
      targetPackages.netbsd.libc or netbsd.libc
    else if name == "wasilibc" then
      targetPackages.wasilibc or wasilibc
    else if name == "relibc" then
      targetPackages.relibc or relibc
    else if name == "llvm" then
      targetPackages.llvmPackages_20.libc or llvmPackages_20.libc
    else
      throw "Unknown libc ${name}";

  libcCross =
    if stdenv.targetPlatform == stdenv.buildPlatform then
      null
    else
      libcCrossChooser stdenv.targetPlatform.libc;

  threadsCross =
    lib.optionalAttrs (stdenv.targetPlatform.isMinGW && !(stdenv.targetPlatform.useLLVM or false))
      {
        # other possible values: win32 or posix
        model = "mcf";
        # For win32 or posix set this to null
        package = targetPackages.windows.mcfgthreads or windows.mcfgthreads;
      };

  wasilibc = callPackage ../development/libraries/wasilibc {
    stdenv = stdenvNoLibc;
  };

  # Only supported on Linux and only on glibc
  glibcLocales =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu then
      callPackage ../development/libraries/glibc/locales.nix {
        stdenv = if (!stdenv.cc.isGNU) then gccStdenv else stdenv;
        withLinuxHeaders = !stdenv.cc.isGNU;
      }
    else
      null;
  glibcLocalesUtf8 =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu then
      callPackage ../development/libraries/glibc/locales.nix {
        stdenv = if (!stdenv.cc.isGNU) then gccStdenv else stdenv;
        withLinuxHeaders = !stdenv.cc.isGNU;
        allLocales = false;
      }
    else
      null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    # The buildPackages is required for cross-compilation. The pkgsi686Linux set
    # has target and host always set to the same value based on target platform
    # of the current set. We need host to be same as build to correctly get i686
    # variant of glibc.
    glibc32 = pkgsi686Linux.buildPackages.glibc;
  };

  glsurf = callPackage ../applications/science/math/glsurf {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14_unsafe_string;
  };

  gmime2 = callPackage ../development/libraries/gmime/2.nix { };
  gmime3 = callPackage ../development/libraries/gmime/3.nix { };
  gmime = gmime2;

  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = gmp6;
  gmpxx = gmp.override { cxx = true; };

  #GMP ex-satellite, so better keep it near gmp
  # A GMP fork
  gns3Packages = recurseIntoAttrs (callPackage ../applications/networking/gns3 { });
  gns3-gui = gns3Packages.guiStable;
  gns3-server = gns3Packages.serverStable;

  gobject-introspection = callPackage ../development/libraries/gobject-introspection/wrapper.nix { };

  gobject-introspection-unwrapped = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };
  goocanvas2 = callPackage ../development/libraries/goocanvas/2.x.nix { };
  goocanvas3 = callPackage ../development/libraries/goocanvas/3.x.nix { };

  gsettings-qt = libsForQt5.callPackage ../development/libraries/gsettings-qt { };

  gst_all_1 = recurseIntoAttrs (
    callPackage ../development/libraries/gstreamer {
      callPackage = newScope gst_all_1;
    }
  );

  qxmpp = qt6Packages.callPackage ../development/libraries/qxmpp { };

  gnutls = callPackage ../development/libraries/gnutls {
    util-linux = util-linuxMinimal; # break the cyclic dependency
    autoconf = buildPackages.autoconf269;
  };

  gpgme = callPackage ../development/libraries/gpgme { };

  grantlee = libsForQt5.callPackage ../development/libraries/grantlee { };

  glib = callPackage ../by-name/gl/glib/package.nix (
    let
      glib-untested = glib.overrideAttrs { doCheck = false; };
    in
    {
      # break dependency cycles
      # these things are only used for tests, they don't get into the closure
      shared-mime-info = shared-mime-info.override { glib = glib-untested; };
      desktop-file-utils = desktop-file-utils.override { glib = glib-untested; };
      dbus = dbus.override { enableSystemd = false; };
    }
  );

  glibmm = callPackage ../development/libraries/glibmm { };

  glibmm_2_68 = callPackage ../development/libraries/glibmm/2.68.nix { };

  glirc = haskell.lib.compose.justStaticExecutables haskellPackages.glirc;

  # Not moved to aliases while we decide if we should split the package again.
  atk = at-spi2-core;

  atkmm = callPackage ../development/libraries/atkmm { };

  atkmm_2_36 = callPackage ../development/libraries/atkmm/2.36.nix { };

  cairomm = callPackage ../development/libraries/cairomm { };

  cairomm_1_16 = callPackage ../development/libraries/cairomm/1.16.nix { };

  pango = callPackage ../development/libraries/pango {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.hostPlatform.isDarwin; };
  };

  pangomm = callPackage ../development/libraries/pangomm { };

  pangomm_2_48 = callPackage ../development/libraries/pangomm/2.48.nix { };

  pangomm_2_42 = callPackage ../development/libraries/pangomm/2.42.nix { };

  gdk-pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gdk-pixbuf-xlib = callPackage ../development/libraries/gdk-pixbuf/xlib.nix { };

  gtk2 = callPackage ../development/libraries/gtk/2.x.nix { };

  gtk2-x11 = gtk2.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override {
      cairo = cairo.override { x11Support = true; };
      x11Support = true;
    };
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk/3.x.nix { };

  gtk4 = callPackage ../development/libraries/gtk/4.x.nix { };

  # On darwin gtk uses cocoa by default instead of x11.
  gtk3-x11 = gtk3.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override {
      cairo = cairo.override { x11Support = true; };
      x11Support = true;
    };
    x11Support = true;
  };

  gtkmm2 = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };
  gtkmm4 = callPackage ../development/libraries/gtkmm/4.x.nix { };

  gtk-sharp-2_0 = callPackage ../development/libraries/gtk-sharp/2.0.nix { };

  gtk-sharp-3_0 = callPackage ../development/libraries/gtk-sharp/3.0.nix { };

  gtk-mac-integration-gtk2 = gtk-mac-integration.override {
    gtk = gtk2;
  };

  gtk-mac-integration-gtk3 = gtk-mac-integration;

  gtksourceview = gtksourceview3;

  gtksourceview3 = callPackage ../development/libraries/gtksourceview/3.x.nix { };

  gtksourceview4 = callPackage ../development/libraries/gtksourceview/4.x.nix { };

  gtksourceview5 = callPackage ../development/libraries/gtksourceview/5.x.nix { };

  gtksourceviewmm = callPackage ../development/libraries/gtksourceviewmm { };

  gtksourceviewmm4 = callPackage ../development/libraries/gtksourceviewmm/4.x.nix { };

  gtkspell2 = callPackage ../development/libraries/gtkspell { };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  hamlib = hamlib_3;
  hamlib_3 = callPackage ../development/libraries/hamlib { };
  hamlib_4 = callPackage ../development/libraries/hamlib/4.nix { };

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  harfbuzzFull = harfbuzz.override {
    withCoreText = stdenv.hostPlatform.isDarwin;
    withGraphite2 = true;
    withIcu = true;
  };

  herqq = libsForQt5.callPackage ../development/libraries/herqq { };

  highfive-mpi = highfive.override { hdf5 = hdf5-mpi; };

  hivex = callPackage ../development/libraries/hivex {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hunspellDicts = recurseIntoAttrs (
    callPackages ../development/libraries/hunspell/dictionaries.nix { }
  );

  hunspellDictsChromium = recurseIntoAttrs (
    callPackages ../development/libraries/hunspell/dictionaries-chromium.nix { }
  );

  hunspellWithDicts = dicts: callPackage ../by-name/hu/hunspell/wrapper.nix { inherit dicts; };

  hydra = callPackage ../by-name/hy/hydra/package.nix { nix = nixVersions.nix_2_29; };

  icu-versions = callPackages ../development/libraries/icu { };
  inherit (icu-versions)
    icu60
    icu63
    icu64
    icu66
    icu67
    icu69
    icu70
    icu71
    icu72
    icu73
    icu74
    icu75
    icu76
    icu77
    ;

  icu = icu76;

  idasen = with python3Packages; toPythonApplication idasen;

  imlib2Full = imlib2.override {
    # Compilation error on Darwin with librsvg. For more information see:
    # https://github.com/NixOS/nixpkgs/pull/166452#issuecomment-1090725613
    svgSupport = !stdenv.hostPlatform.isDarwin;
    heifSupport = !stdenv.hostPlatform.isDarwin;
    webpSupport = true;
    jxlSupport = true;
    psSupport = true;
  };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot {
    libXinerama = xorg.libXinerama;
  };

  indicator-application-gtk2 =
    callPackage ../development/libraries/indicator-application/gtk2.nix
      { };
  indicator-application-gtk3 =
    callPackage ../development/libraries/indicator-application/gtk3.nix
      { };

  indilib = callPackage ../development/libraries/science/astronomy/indilib { };
  indi-3rdparty = recurseIntoAttrs (
    callPackages ../development/libraries/science/astronomy/indilib/indi-3rdparty.nix { }
  );

  ios-cross-compile = callPackage ../development/compilers/ios-cross-compile/9.2.nix { };

  irrlicht =
    if !stdenv.hostPlatform.isDarwin then
      callPackage ../development/libraries/irrlicht { }
    else
      callPackage ../development/libraries/irrlicht/mac.nix {
      };

  iso-flags-png-320x240 = iso-flags.overrideAttrs (oldAttrs: {
    buildFlags = [ "png-country-320x240-fancy" ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share && mv build/png-country-4x2-fancy/res-320x240 $out/share/iso-flags-png
      runHook postInstall
    '';
  });

  isoimagewriter = libsForQt5.callPackage ../tools/misc/isoimagewriter { };

  isort = with python3Packages; toPythonApplication isort;

  isso = callPackage ../servers/isso {
    nodejs = nodejs_20;
  };

  itk_5_2 = callPackage ../development/libraries/itk/5.2.x.nix {
    enableRtk = false;
  };

  itk_5 = callPackage ../development/libraries/itk/5.x.nix { };

  itk = itk_5;

  jemalloc = callPackage ../development/libraries/jemalloc { };

  rust-jemalloc-sys = callPackage ../development/libraries/jemalloc/rust.nix { };
  rust-jemalloc-sys-unprefixed = rust-jemalloc-sys.override { unprefixed = true; };

  json2yaml = haskell.lib.compose.justStaticExecutables haskellPackages.json2yaml;

  kddockwidgets = libsForQt5.callPackage ../development/libraries/kddockwidgets { };

  keybinder = callPackage ../development/libraries/keybinder {
    automake = automake111x;
    lua = lua5_1;
  };

  keybinder3 = callPackage ../development/libraries/keybinder3 {
    gtk3 = if stdenv.hostPlatform.isDarwin then gtk3-x11 else gtk3;
    automake = automake111x;
  };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (buildPackages.darwin) bootstrap_cmds;
  };
  libkrb5 = krb5; # TODO(de11n) Try to make krb5 reuse libkrb5 as a dependency

  ktextaddons = libsForQt5.callPackage ../development/libraries/ktextaddons { };

  l-smash = callPackage ../development/libraries/l-smash {
    stdenv = gccStdenv;
  };

  languageMachines = recurseIntoAttrs (
    import ../development/libraries/languagemachines/packages.nix {
      inherit pkgs;
    }
  );

  laurel = callPackage ../servers/monitoring/laurel/default.nix { };

  lcms = lcms2;

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or (lib.meta.availableOn stdenv.hostPlatform libpulseaudio);
  };

  libappindicator-gtk2 = libappindicator.override { gtkVersion = "2"; };
  libappindicator-gtk3 = libappindicator.override { gtkVersion = "3"; };
  libasn1c = callPackage ../servers/osmocom/libasn1c/default.nix { };

  libbap = callPackage ../development/libraries/libbap {
    inherit (ocaml-ng.ocamlPackages_4_14)
      bap
      ocaml
      findlib
      ctypes
      ctypes-foreign
      ;
  };

  libbass = (callPackage ../development/libraries/audio/libbass { }).bass;
  libbass_fx = (callPackage ../development/libraries/audio/libbass { }).bass_fx;
  libbassmidi = (callPackage ../development/libraries/audio/libbass { }).bassmidi;
  libbassmix = (callPackage ../development/libraries/audio/libbass { }).bassmix;

  libcamera-qcam = callPackage ../by-name/li/libcamera/package.nix { withQcam = true; };

  libcanberra-gtk2 = pkgs.libcanberra.override {
    gtkSupport = "gtk2";
  };
  libcanberra-gtk3 = pkgs.libcanberra.override {
    gtkSupport = "gtk3";
  };

  libcanberra_kde =
    if (config.kde_runtime.libcanberraWithoutGTK or true) then
      pkgs.libcanberra
    else
      pkgs.libcanberra-gtk2;

  libcec = callPackage ../development/libraries/libcec { };

  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcef = callPackage ../development/libraries/libcef { };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain_libsoup3 = libchamplain.override { withLibsoup3 = true; };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libcomps = callPackage ../tools/package-management/libcomps { };

  libcxxrt = callPackage ../development/libraries/libcxxrt {
    stdenv =
      if stdenv.hostPlatform.useLLVM or false then
        overrideCC stdenv buildPackages.llvmPackages.tools.clangNoLibcxx
      else
        stdenv;
  };

  libdbiDriversBase = libdbiDrivers.override {
    libmysqlclient = null;
    sqlite = null;
  };

  libdbusmenu-gtk2 = libdbusmenu.override { gtkVersion = "2"; };
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };

  libdevil = callPackage ../development/libraries/libdevil { };

  libdevil-nox = callPackage ../development/libraries/libdevil {
    withXorg = false;
  };

  libdnf = callPackage ../tools/package-management/libdnf { };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };
  libdvdnav_4_2_1 = callPackage ../development/libraries/libdvdnav/4.2.1.nix {
    libdvdread = libdvdread_4_9_9;
  };

  libdvdread = callPackage ../development/libraries/libdvdread { };
  libdvdread_4_9_9 = callPackage ../development/libraries/libdvdread/4.9.9.nix { };

  dwarfdump = libdwarf.bin;

  libfm-extra = libfm.override {
    extraOnly = true;
  };

  libgda5 = callPackage ../development/libraries/libgda/5.x.nix { };

  libgda6 = callPackage ../development/libraries/libgda/6.x.nix { };

  libgnome-games-support = callPackage ../development/libraries/libgnome-games-support { };
  libgnome-games-support_2_0 =
    callPackage ../development/libraries/libgnome-games-support/2.0.nix
      { };

  libiio = callPackage ../development/libraries/libiio { };

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libfive = libsForQt5.callPackage ../development/libraries/libfive { };

  # Use Apple’s fork of libffi by default, which provides APIs and trampoline functionality that is not yet
  # merged upstream. This is needed by some packages (such as cffi).
  #
  # `libffiReal` is provided in case the upstream libffi package is needed on Darwin instead of the fork.
  libffiReal = callPackage ../development/libraries/libffi { };
  libffi = if stdenv.hostPlatform.isDarwin then darwin.libffi else libffiReal;
  libffi_3_3 = callPackage ../development/libraries/libffi/3.3.nix { };
  libffiBoot = libffi.override {
    doCheck = false;
  };

  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgpg-error.git;a=blob;f=README;h=fd6e1a83f55696c1f7a08f6dfca08b2d6b7617ec;hb=70058cd9f944d620764e57c838209afae8a58c78#l118
  libgpg-error-gen-posix-lock-obj = libgpg-error.override {
    genPosixLockObjOnly = true;
  };

  libgpod = callPackage ../development/libraries/libgpod {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libindicator-gtk2 = libindicator.override { gtkVersion = "2"; };
  libindicator-gtk3 = libindicator.override { gtkVersion = "3"; };
  inherit (callPackage ../development/libraries/libliftoff { }) libliftoff_0_4 libliftoff_0_5;
  libliftoff = libliftoff_0_5;

  libqtdbusmock = libsForQt5.callPackage ../development/libraries/libqtdbusmock {
    inherit (lomiri) cmake-extras;
  };

  libqtdbustest = libsForQt5.callPackage ../development/libraries/libqtdbustest {
    inherit (lomiri) cmake-extras;
  };

  libremines = qt6.callPackage ../games/libremines { };

  librepo = callPackage ../tools/package-management/librepo { };

  libretranslate = with python3.pkgs; toPythonApplication libretranslate;

  librsb = callPackage ../development/libraries/librsb {
    # Taken from https://build.opensuse.org/package/view_file/science/librsb/librsb.spec
    memHierarchy = "L3:16/64/8192K,L2:16/64/2048K,L1:8/64/16K";
  };

  # GNU libc provides libiconv so systems with glibc don't need to
  # build libiconv separately. Additionally, Apple forked/repackaged
  # libiconv, so build and use the upstream one with a compatible ABI,
  # and BSDs include libiconv in libc.
  #
  # We also provide `libiconvReal`, which will always be a standalone libiconv,
  # just in case you want it regardless of platform.
  libiconv =
    if
      lib.elem stdenv.hostPlatform.libc [
        "glibc"
        "musl"
        "nblibc"
        "wasilibc"
        "fblibc"
      ]
    then
      libcIconv (if stdenv.hostPlatform != stdenv.buildPlatform then libcCross else stdenv.cc.libc)
    else if stdenv.hostPlatform.isDarwin then
      darwin.libiconv
    else
      libiconvReal;

  libcIconv =
    libc:
    let
      inherit (libc) pname version;
      libcDev = lib.getDev libc;
    in
    runCommand "${pname}-iconv-${version}" { strictDeps = true; } ''
      mkdir -p $out/include
      ln -sv ${libcDev}/include/iconv.h $out/include
    '';

  libiconvReal = callPackage ../development/libraries/libiconv { };

  iconv =
    if
      lib.elem stdenv.hostPlatform.libc [
        "glibc"
        "musl"
      ]
    then
      lib.getBin stdenv.cc.libc
    else if stdenv.hostPlatform.isDarwin then
      lib.getBin libiconv
    else if stdenv.hostPlatform.isFreeBSD then
      lib.getBin freebsd.iconv
    else
      lib.getBin libiconvReal;

  # On non-GNU systems we need GNU Gettext for libintl.
  libintl = if stdenv.hostPlatform.libc != "glibc" then gettext else null;

  libidn2 = callPackage ../development/libraries/libidn2 { };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  # also known as libturbojpeg
  libjpeg = libjpeg_turbo;
  libjpeg8 = libjpeg_turbo.override { enableJpeg8 = true; };

  malcontent = callPackage ../development/libraries/malcontent { };

  malcontent-ui = callPackage ../development/libraries/malcontent/ui.nix { };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  inherit
    ({
      libmicrohttpd_0_9_77 = callPackage ../development/libraries/libmicrohttpd/0.9.77.nix { };
      libmicrohttpd_1_0 = callPackage ../development/libraries/libmicrohttpd/1.0.nix { };
    })
    libmicrohttpd_0_9_77
    libmicrohttpd_1_0
    ;

  libmicrohttpd = libmicrohttpd_1_0;

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz5 = callPackage ../development/libraries/libmusicbrainz/5.x.nix { };

  libmusicbrainz = libmusicbrainz3;

  libosmscout = libsForQt5.callPackage ../development/libraries/libosmscout { };

  libpeas = callPackage ../development/libraries/libpeas { };
  libpeas2 = callPackage ../development/libraries/libpeas/2.x.nix { };

  libpng = callPackage ../development/libraries/libpng {
    stdenv =
      # libpng is a dependency of xcbuild. Avoid an infinite recursion by using a bootstrap stdenv
      # that does not propagate xcrun.
      if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
  };

  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  inherit
    (callPackages ../development/libraries/prometheus-client-c {
      stdenv = gccStdenv; # Required for darwin
    })
    libprom
    ;

  libpulsar = callPackage ../development/libraries/libpulsar {
    protobuf = protobuf_21;
  };

  libpwquality = callPackage ../development/libraries/libpwquality { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx30 = callPackage ../development/libraries/libsigcxx/3.0.nix { };

  libsoup_2_4 = callPackage ../development/libraries/libsoup { };

  libsoup_3 = callPackage ../development/libraries/libsoup/3.x.nix { };

  libtorrent-rasterbar = libtorrent-rasterbar-2_0_x;

  libubox-nossl = callPackage ../development/libraries/libubox { };

  libubox = callPackage ../development/libraries/libubox { with_ustream_ssl = true; };

  libubox-wolfssl = callPackage ../development/libraries/libubox {
    with_ustream_ssl = true;
    ustream-ssl = ustream-ssl-wolfssl;
  };

  libubox-mbedtls = callPackage ../development/libraries/libubox {
    with_ustream_ssl = true;
    ustream-ssl = ustream-ssl-mbedtls;
  };

  libunistring = callPackage ../development/libraries/libunistring { };

  libunique = callPackage ../development/libraries/libunique { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { };

  libusb-compat-0_1 = callPackage ../development/libraries/libusb-compat/0.1.nix { };

  libunicode = callPackage ../by-name/li/libunicode/package.nix {
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_17.stdenv else stdenv;
  };

  libunwind =
    # Use the system unwinder in the SDK but provide a compatibility package to:
    # 1. avoid evaluation errors with setting `unwind` to `null`; and
    # 2. provide a `.pc` for compatibility with packages that expect to find libunwind that way.
    if stdenv.hostPlatform.isDarwin then
      darwin.libunwind
    else if stdenv.hostPlatform.system == "riscv32-linux" then
      llvmPackages.libunwind
    else
      callPackage ../development/libraries/libunwind { };

  libv4l = lowPrio (
    v4l-utils.override {
      withUtils = false;
    }
  );

  libva-minimal = callPackage ../development/libraries/libva { minimal = true; };
  libva = libva-minimal.override { minimal = false; };
  libva-utils = callPackage ../development/libraries/libva/utils.nix { };

  libva1 = callPackage ../development/libraries/libva/1.nix { };
  libva1-minimal = libva1.override { minimal = true; };

  libwnck = callPackage ../development/libraries/libwnck { };
  libwnck2 = callPackage ../development/libraries/libwnck/2.nix { };

  libwpd = callPackage ../development/libraries/libwpd { };

  libwpd_08 = callPackage ../development/libraries/libwpd/0.8.nix { };

  libxcrypt = callPackage ../development/libraries/libxcrypt {
    fetchurl = stdenv.fetchurlBoot;
    perl = buildPackages.perl.override {
      enableCrypt = false;
      fetchurl = stdenv.fetchurlBoot;
    };
  };
  libxcrypt-legacy = libxcrypt.override { enableHashes = "all"; };

  libxkbcommon = libxkbcommon_8;
  libxml2 = callPackage ../development/libraries/libxml2 {
    python = python3;
    stdenv =
      # libxml2 is a dependency of xcbuild. Avoid an infinite recursion by using a bootstrap stdenv
      # that does not propagate xcrun.
      if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
  };

  libxml2Python =
    let
      inherit (python3.pkgs) libxml2;
    in
    pkgs.buildEnv {
      # slightly hacky
      name = "libxml2+py-${res.libxml2.version}";
      paths = with libxml2; [
        dev
        bin
        py
      ];
      # Avoid update.nix/tests conflicts with libxml2.
      passthru = builtins.removeAttrs libxml2.passthru [
        "updateScript"
        "tests"
      ];
      # the hook to find catalogs is hidden by buildEnv
      postBuild = ''
        mkdir "$out/nix-support"
        cp '${libxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
      '';
    };

  libxmlxx = callPackage ../development/libraries/libxmlxx { };
  libxmlxx3 = callPackage ../development/libraries/libxmlxx/v3.nix { };

  libxslt = callPackage ../development/libraries/libxslt { };

  libwpe = callPackage ../development/libraries/libwpe { };

  libwpe-fdo = callPackage ../development/libraries/libwpe/fdo.nix { };

  yaml-cpp = callPackage ../development/libraries/yaml-cpp { };

  yaml-cpp_0_3 = callPackage ../development/libraries/yaml-cpp/0.3.0.nix { };

  liquid-dsp = callPackage ../development/libraries/liquid-dsp {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = luabind.override { lua = luajit; };

  luksmeta = callPackage ../development/libraries/luksmeta {
    asciidoc = asciidoc-full;
  };

  mapnik = callPackage ../development/libraries/mapnik {
    harfbuzz = harfbuzz.override {
      withIcu = true;
    };
  };

  matterhorn =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.matterhorn;

  mbedtls_2 = callPackage ../development/libraries/mbedtls/2.nix { };
  mbedtls = callPackage ../development/libraries/mbedtls/3.nix { };

  mediastreamer = libsForQt5.callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  mergerfs = callPackage ../tools/filesystems/mergerfs { };

  mergerfs-tools = callPackage ../tools/filesystems/mergerfs/tools.nix { };

  simple-dftd3 = callPackage ../development/libraries/science/chemistry/simple-dftd3 { };

  tblite = callPackage ../development/libraries/science/chemistry/tblite { };

  ## libGL/libGLU/Mesa stuff

  # Default libGL implementation.
  #
  # Android NDK provides an OpenGL implementation, we can just use that.
  #
  # On macOS, the SDK provides the OpenGL framework in `stdenv`.
  # Packages that still need GLX specifically can pull in `libGLX`
  # instead. If you have a package that should work without X11 but it
  # can’t find the library, it may help to add the path to
  # `$NIX_CFLAGS_COMPILE`:
  #
  #    preConfigure = ''
  #      export NIX_CFLAGS_COMPILE+=" -L$SDKROOT/System/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries"
  #    '';
  #
  # If you still can’t get it working, please don’t hesitate to ping
  # @NixOS/darwin-maintainers to ask an expert to take a look.
  libGL =
    if stdenv.hostPlatform.useAndroidPrebuilt then
      stdenv
    else if stdenv.hostPlatform.isDarwin then
      null
    else
      libglvnd;

  # On macOS, the SDK provides the OpenGL framework in `stdenv`.
  # Packages that use `libGLX` on macOS may need to depend on
  # `mesa_glu` directly if this doesn’t work.
  libGLU = if stdenv.hostPlatform.isDarwin then null else mesa_glu;

  # `libglvnd` does not work (yet?) on macOS.
  libGLX = if stdenv.hostPlatform.isDarwin then mesa else libglvnd;

  # On macOS, the SDK provides the GLUT framework in `stdenv`. Packages
  # that use `libGLX` on macOS may need to depend on `freeglut`
  # directly if this doesn’t work.
  libglut = if stdenv.hostPlatform.isDarwin then null else freeglut;

  mesa =
    if stdenv.hostPlatform.isDarwin then
      callPackage ../development/libraries/mesa/darwin.nix { }
    else
      callPackage ../development/libraries/mesa { };

  mesa_i686 = pkgsi686Linux.mesa; # make it build on Hydra

  libgbm = callPackage ../development/libraries/mesa/gbm.nix { };
  mesa-gl-headers = callPackage ../development/libraries/mesa/headers.nix { };

  ## End libGL/libGLU/Mesa stuff

  mkvtoolnix-cli = mkvtoolnix.override {
    withGUI = false;
  };

  mpeg2dec = libmpeg2;

  msoffcrypto-tool = with python3.pkgs; toPythonApplication msoffcrypto-tool;

  mpich = callPackage ../development/libraries/mpich {
    ch4backend = libfabric;
  };

  mpich-pmix = mpich.override {
    pmixSupport = true;
    withPm = [ ];
  };

  mygpoclient = with python3.pkgs; toPythonApplication mygpoclient;

  nanovna-saver = libsForQt5.callPackage ../applications/science/electronics/nanovna-saver { };

  nemo-qml-plugin-dbus = libsForQt5.callPackage ../development/libraries/nemo-qml-plugin-dbus { };

  ncurses5 = ncurses.override {
    abiVersion = "5";
  };
  ncurses6 = ncurses.override {
    abiVersion = "6";
  };
  ncurses =
    if stdenv.hostPlatform.useiOSPrebuilt then
      null
    else
      callPackage ../development/libraries/ncurses {
        # ncurses is included in the SDK. Avoid an infinite recursion by using a bootstrap stdenv.
        stdenv = if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
      };

  nettle = import ../development/libraries/nettle { inherit callPackage fetchurl; };

  libnghttp2 = nghttp2.lib;

  ngtcp2 = callPackage ../development/libraries/ngtcp2 { };
  ngtcp2-gnutls = callPackage ../development/libraries/ngtcp2/gnutls.nix { };

  non = callPackage ../applications/audio/non {
    wafHook = (waf.override { extraTools = [ "gccdeps" ]; }).hook;
  };

  nss_latest = callPackage ../development/libraries/nss/latest.nix { };
  nss_3_115 = callPackage ../development/libraries/nss/3_115.nix { };
  nss_3_114 = callPackage ../development/libraries/nss/3_114.nix { };
  nss_esr = callPackage ../development/libraries/nss/esr.nix { };
  nss = nss_esr;
  nssTools = nss.tools;

  nuspell = callPackage ../development/libraries/nuspell { };
  nuspellWithDicts =
    dicts: callPackage ../development/libraries/nuspell/wrapper.nix { inherit dicts; };

  nv-codec-headers-9 = nv-codec-headers.override { majorVersion = "9"; };
  nv-codec-headers-10 = nv-codec-headers.override { majorVersion = "10"; };
  nv-codec-headers-11 = nv-codec-headers.override { majorVersion = "11"; };
  nv-codec-headers-12 = nv-codec-headers.override { majorVersion = "12"; };

  nvidiaCtkPackages = callPackage ../by-name/nv/nvidia-container-toolkit/packages.nix { };
  inherit (nvidiaCtkPackages)
    nvidia-docker
    ;

  nvidia-vaapi-driver = lib.hiPrio (callPackage ../development/libraries/nvidia-vaapi-driver { });

  nvidia-system-monitor-qt = libsForQt5.callPackage ../tools/system/nvidia-system-monitor-qt { };

  nvtopPackages = recurseIntoAttrs (import ../tools/system/nvtop { inherit callPackage stdenv; });

  inherit (callPackages ../development/libraries/ogre { })
    ogre_13
    ogre_14
    ;

  ogre = ogre_14;

  openal = openalSoft;

  openbabel = openbabel3;

  openbabel2 = callPackage ../development/libraries/openbabel/2.nix { };

  openbabel3 = callPackage ../development/libraries/openbabel { };

  opencascade-occt_7_6 = opencascade-occt.overrideAttrs rec {
    pname = "opencascade-occt";
    version = "7.6.2";
    commit = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";
    src = fetchurl {
      name = "occt-${commit}.tar.gz";
      url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
      hash = "sha256-n3KFrN/mN1SVXfuhEUAQ1fJzrCvhiclxfEIouyj9Z18=";
    };
    patches = [
      # Backport GCC 14 build fix
      (fetchpatch {
        url = "https://github.com/Open-Cascade-SAS/OCCT/commit/7236e83dcc1e7284e66dc61e612154617ef715d6.patch";
        hash = "sha256-NoC2mE3DG78Y0c9UWonx1vmXoU4g5XxFUT3eVXqLU60=";
      })
    ];
  };

  opencascade-occt_7_6_1 = opencascade-occt.overrideAttrs {
    pname = "opencascade-occt";
    version = "7.6.1";
    src = fetchFromGitHub {
      owner = "Open-Cascade-SAS";
      repo = "OCCT";
      rev = "V7_6_1";
      sha256 = "sha256-C02P3D363UwF0NM6R4D4c6yE5ZZxCcu5CpUaoTOxh7E=";
    };
  };

  opencsg = callPackage ../development/libraries/opencsg {
    inherit (qt5) qmake;
  };

  opencv4 = callPackage ../development/libraries/opencv/4.x.nix {
    pythonPackages = python3Packages;
    # TODO: LTO does not work.
    # https://github.com/NixOS/nixpkgs/issues/343123
    enableLto = false;
  };

  opencv4WithoutCuda = opencv4.override {
    enableCuda = false;
  };

  opencv = opencv4;

  openexr = callPackage ../development/libraries/openexr/3.nix { };
  openexr_2 = callPackage ../development/libraries/openexr/2.nix { };

  opencolorio = callPackage ../development/libraries/opencolorio { };
  opencolorio_1 = callPackage ../development/libraries/opencolorio/1.x.nix { };

  openstackclient = with python312Packages; toPythonApplication python-openstackclient;
  openstackclient-full = openstackclient.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.cli-plugins;
  });
  barbicanclient = with python312Packages; toPythonApplication python-barbicanclient;
  glanceclient = with python312Packages; toPythonApplication python-glanceclient;
  heatclient = with python312Packages; toPythonApplication python-heatclient;
  ironicclient = with python312Packages; toPythonApplication python-ironicclient;
  magnumclient = with python312Packages; toPythonApplication python-magnumclient;
  manilaclient = with python312Packages; toPythonApplication python-manilaclient;
  mistralclient = with python312Packages; toPythonApplication python-mistralclient;
  swiftclient = with python312Packages; toPythonApplication python-swiftclient;
  troveclient = with python312Packages; toPythonApplication python-troveclient;
  watcherclient = with python312Packages; toPythonApplication python-watcherclient;
  zunclient = with python312Packages; toPythonApplication python-zunclient;

  openvdb = callPackage ../development/libraries/openvdb { };

  inherit (callPackages ../development/libraries/libressl { })
    libressl_4_0
    libressl_4_1
    ;

  libressl = libressl_4_1;

  openssl = openssl_3_4;

  openssl_legacy = openssl.override {
    conf = ../development/libraries/openssl/3.0/legacy.cnf;
  };

  inherit (callPackages ../development/libraries/openssl { })
    openssl_1_1
    openssl_3
    openssl_3_4
    ;

  openwebrx = callPackage ../applications/radio/openwebrx {
    inherit (python3Packages)
      buildPythonPackage
      buildPythonApplication
      setuptools
      pycsdr
      pydigiham
      ;
  };

  pcre = callPackage ../development/libraries/pcre { };
  pcre16 = res.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = res.pcre.override { variant = "cpp"; };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdfhummus = libsForQt5.callPackage ../development/libraries/pdfhummus { };

  inherit
    (callPackage ../development/libraries/physfs {
    })
    physfs_2
    physfs
    ;

  pingvin-share = callPackage ../servers/pingvin-share { };

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wine-staging = pkgsi686Linux.wine-staging;
  };

  place-cursor-at = haskell.lib.compose.justStaticExecutables haskellPackages.place-cursor-at;

  podofo = callPackage ../development/libraries/podofo { };

  podofo010 = callPackage ../development/libraries/podofo/0.10.x.nix { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };

  poppler_gi = lowPrio (
    poppler.override {
      introspectionSupport = true;
    }
  );

  poppler_min = poppler.override {
    # TODO: maybe reduce even more
    minimal = true;
    suffix = "min";
  };

  poppler-utils = poppler.override {
    suffix = "utils";
    utils = true;
  };

  proj = callPackage ../development/libraries/proj { };

  proj_7 = callPackage ../development/libraries/proj/7.nix { };

  prospector = callPackage ../development/tools/prospector { };

  protobuf = protobuf_30;

  inherit
    ({
      protobuf_30 = callPackage ../development/libraries/protobuf/30.nix { };
      protobuf_29 = callPackage ../development/libraries/protobuf/29.nix { };
      protobuf_28 = callPackage ../development/libraries/protobuf/28.nix { };
      protobuf_27 = callPackage ../development/libraries/protobuf/27.nix { };
      protobuf_26 = callPackage ../development/libraries/protobuf/26.nix { };
      protobuf_25 = callPackage ../development/libraries/protobuf/25.nix { };
      protobuf_24 = callPackage ../development/libraries/protobuf/24.nix { };
      protobuf_21 = callPackage ../development/libraries/protobuf/21.nix {
        abseil-cpp = abseil-cpp_202103;
      };
    })
    protobuf_30
    protobuf_29
    protobuf_28
    protobuf_27
    protobuf_26
    protobuf_25
    protobuf_24
    protobuf_21
    ;

  flatbuffers = callPackage ../development/libraries/flatbuffers { };
  flatbuffers_23 = callPackage ../development/libraries/flatbuffers/23.nix { };

  nanopbMalloc = callPackage ../by-name/na/nanopb/package.nix { enableMalloc = true; };

  pth = if stdenv.hostPlatform.isMusl then npth else gnupth;

  python-qt = libsForQt5.callPackage ../development/libraries/python-qt { };

  pyotherside = libsForQt5.callPackage ../development/libraries/pyotherside { };

  qbs = libsForQt5.callPackage ../development/tools/build-managers/qbs { };

  qdjango = libsForQt5.callPackage ../development/libraries/qdjango { };

  qmenumodel = libsForQt5.callPackage ../development/libraries/qmenumodel {
    inherit (lomiri) cmake-extras;
  };

  quarto = callPackage ../development/libraries/quarto { };

  quartoMinimal = callPackage ../development/libraries/quarto {
    rWrapper = null;
    python3 = null;
  };

  qt5 = recurseIntoAttrs (
    makeOverridable (import ../development/libraries/qt-5/5.15) {
      inherit (__splicedPackages)
        makeScopeWithSplicing'
        generateSplicesForMkScope
        lib
        stdenv
        fetchurl
        fetchpatch
        fetchgit
        fetchFromGitHub
        makeSetupHook
        makeWrapper
        bison
        cups
        dconf
        harfbuzz
        libGL
        perl
        gtk3
        python3
        llvmPackages_15
        overrideLibcxx
        darwin
        ;
      inherit (__splicedPackages.gst_all_1) gstreamer gst-plugins-base;
      inherit config;
    }
  );

  libsForQt5 = recurseIntoAttrs (
    import ./qt5-packages.nix {
      inherit
        lib
        config
        __splicedPackages
        makeScopeWithSplicing'
        generateSplicesForMkScope
        pkgsHostTarget
        ;
    }
  );

  # plasma5Packages maps to the Qt5 packages set that is used to build the plasma5 desktop
  plasma5Packages = libsForQt5;

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qt6 = recurseIntoAttrs (callPackage ../development/libraries/qt-6 { });

  qt6Packages = recurseIntoAttrs (
    import ./qt6-packages.nix {
      inherit
        lib
        config
        __splicedPackages
        makeScopeWithSplicing'
        generateSplicesForMkScope
        pkgsHostTarget
        kdePackages
        ;
      inherit stdenv;
    }
  );

  qv2ray = libsForQt5.callPackage ../applications/networking/qv2ray { };

  readline = readline82;

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  readline82 = callPackage ../development/libraries/readline/8.2.nix { };

  readmdict = with python3Packages; toPythonApplication readmdict;

  kissfftFloat = kissfft.override {
    datatype = "float";
  };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskellLib = haskell.lib.compose;
  };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };
  redland = librdf_redland; # added 2018-04-25

  renovate = callPackage ../by-name/re/renovate/package.nix {
    nodejs = nodejs_20;
  };

  qradiolink = callPackage ../applications/radio/qradiolink {
    protobuf = protobuf_21;
  };

  qadwaitadecorations-qt6 = callPackage ../by-name/qa/qadwaitadecorations/package.nix {
    useQt6 = true;
  };

  qgnomeplatform = libsForQt5.callPackage ../development/libraries/qgnomeplatform { };

  qgnomeplatform-qt6 = qt6Packages.callPackage ../development/libraries/qgnomeplatform {
    useQt6 = true;
  };

  reposilitePlugins = recurseIntoAttrs (callPackage ../by-name/re/reposilite/plugins.nix { });

  rhino = callPackage ../development/libraries/java/rhino {
    javac = jdk8;
    jvm = jre8;
  };

  rocksdb_9_10 = rocksdb.overrideAttrs rec {
    pname = "rocksdb";
    version = "9.10.0";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-G+DlQwEUyd7JOCjS1Hg1cKWmA/qAiK8UpUIKcP+riGQ=";
    };
  };

  rocksdb_8_11 = rocksdb.overrideAttrs rec {
    pname = "rocksdb";
    version = "8.11.4";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-ZrU7G3xeimF3H2LRGBDHOq936u5pH/3nGecM4XEoWc8=";
    };
  };

  rocksdb_8_3 = rocksdb.overrideAttrs rec {
    pname = "rocksdb";
    version = "8.3.2";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-mfIRQ8nkUbZ3Bugy3NAvOhcfzFY84J2kBUIUBcQ2/Qg=";
    };
  };

  rocksdb_7_10 = rocksdb.overrideAttrs rec {
    pname = "rocksdb";
    version = "7.10.2";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-U2ReSrJwjAXUdRmwixC0DQXht/h/6rV8SOf5e2NozIs=";
    };
  };

  rocksdb_6_23 = rocksdb.overrideAttrs rec {
    pname = "rocksdb";
    version = "6.23.3";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-SsDqhjdCdtIGNlsMj5kfiuS3zSGwcxi4KV71d95h7yk=";
    };
  };

  rover = callPackage ../development/tools/rover { };

  rshell = python3.pkgs.callPackage ../development/embedded/rshell { };

  schroedinger = callPackage ../development/libraries/schroedinger {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  SDL = SDL_compat;
  SDL2 = sdl2-compat;

  sdr-j-fm = libsForQt5.callPackage ../applications/radio/sdr-j-fm { };

  sigdigger = libsForQt5.callPackage ../applications/radio/sigdigger { };

  sev-snp-measure = with python3Packages; toPythonApplication sev-snp-measure;

  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix { };

  simavr = callPackage ../development/tools/simavr {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrlibc = pkgsCross.avr.libcCross;
  };

  simpleitk = callPackage ../development/libraries/simpleitk { lua = lua5_4; };

  skawarePackages = recurseIntoAttrs (callPackage ../development/skaware-packages { });

  inherit (skawarePackages)
    execline
    execline-man-pages
    mdevd
    nsss
    s6
    s6-dns
    s6-linux-init
    s6-linux-utils
    s6-man-pages
    s6-networking
    s6-networking-man-pages
    s6-portable-utils
    s6-portable-utils-man-pages
    s6-rc
    s6-rc-man-pages
    sdnotify-wrapper
    skalibs
    skalibs_2_10
    tipidee
    utmps
    ;

  kgt = callPackage ../development/tools/kgt {
    inherit (skawarePackages) cleanPackaging;
  };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile;
  };

  soapysdr = callPackage ../applications/radio/soapysdr { };

  soapysdr-with-plugins = callPackage ../applications/radio/soapysdr {
    extraPackages = [
      limesuite
      soapyairspy
      soapyaudio
      soapybladerf
      soapyhackrf
      soapyplutosdr
      soapyremote
      soapyrtlsdr
      soapyuhd
    ];
  };

  spandsp = callPackage ../development/libraries/spandsp { };
  spandsp3 = callPackage ../development/libraries/spandsp/3.nix { };

  speechd-minimal = speechd.override {
    withLibao = false;
    withPulse = false;
    withAlsa = false;
    withOss = false;
    withFlite = false;
    withEspeak = false;
    withPico = false;
    libsOnly = true;
  };

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  sphinx = with python3Packages; toPythonApplication sphinx;

  sphinx-autobuild = with python3Packages; toPythonApplication sphinx-autobuild;

  sphinx-serve = with python3Packages; toPythonApplication sphinx-serve;

  inherit (python3Packages) sphinxHook;

  suwidgets = libsForQt5.callPackage ../applications/radio/suwidgets { };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  unqlite = lowPrio (callPackage ../development/libraries/unqlite { });

  inherit
    (callPackage ../development/libraries/sqlite/tools.nix {
    })
    sqlite-analyzer
    sqldiff
    sqlite-rsync
    ;

  sqlar = callPackage ../development/libraries/sqlite/sqlar.nix { };

  sqlite-interactive = (sqlite.override { interactive = true; }).bin;

  stlink-gui = callPackage ../by-name/st/stlink/package.nix { withGUI = true; };

  streamlink-twitch-gui-bin = callPackage ../applications/video/streamlink-twitch-gui/bin.nix { };

  structuresynth = libsForQt5.callPackage ../development/libraries/structuresynth { };

  sundials = callPackage ../development/libraries/sundials { };

  svxlink = libsForQt5.callPackage ../applications/radio/svxlink { };

  tclap = tclap_1_2;

  tclap_1_2 = callPackage ../development/libraries/tclap/1.2.nix { };

  tclap_1_4 = callPackage ../development/libraries/tclap/1.4.nix { };

  termbench-pro = callPackage ../by-name/te/termbench-pro/package.nix {
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_17.stdenv else stdenv;
    fmt = fmt_11;
  };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tk = tk-8_6;

  tk-9_0 = callPackage ../development/libraries/tk/9.0.nix { tcl = tcl-9_0; };
  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tpm2-tss = callPackage ../development/libraries/tpm2-tss {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers { });

  valeStyles = recurseIntoAttrs (callPackages ../by-name/va/vale/styles.nix { });

  valhalla = callPackage ../development/libraries/valhalla {
    boost = boost.override {
      enablePython = true;
      python = python3;
    };
    protobuf = protobuf_21.override {
      abseil-cpp = abseil-cpp_202103.override {
        cxxStandard = "17";
      };
    };
  };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vencord-web-extension = callPackage ../by-name/ve/vencord/package.nix { buildWebExtension = true; };

  vid-stab = callPackage ../development/libraries/vid-stab {
    inherit (llvmPackages) openmp;
  };

  vigra = callPackage ../development/libraries/vigra {
    hdf5 = hdf5.override { usev110Api = true; };
  };

  vllm = with python3Packages; toPythonApplication vllm;

  vte-gtk4 = vte.override {
    gtkVersion = "4";
  };

  vtfedit = callPackage ../by-name/vt/vtfedit/package.nix {
    wine = wineWowPackages.staging;
  };

  vtk_9 = libsForQt5.callPackage ../development/libraries/vtk/9.x.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages_17.stdenv else stdenv;
  };

  vtk_9_withQt5 = vtk_9.override { enableQt = true; };

  vtk = vtk_9;

  vtk_9_egl = vtk_9.override { enableEgl = true; };

  vtkWithQt5 = vtk_9_withQt5;

  vulkan-caps-viewer = libsForQt5.callPackage ../tools/graphics/vulkan-caps-viewer { };

  wayland = callPackage ../development/libraries/wayland { };
  wayland-scanner = callPackage ../development/libraries/wayland/scanner.nix { };

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  waylandpp = callPackage ../development/libraries/waylandpp {
    graphviz = graphviz-nox;
  };

  webkitgtk_4_0 = callPackage ../development/libraries/webkitgtk {
    harfbuzz = harfbuzzFull;
    libsoup = libsoup_2_4;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
  };

  webkitgtk_4_1 = webkitgtk_4_0.override {
    libsoup = libsoup_3;
  };

  webkitgtk_6_0 = webkitgtk_4_0.override {
    libsoup = libsoup_3;
    gtk3 = gtk4;
  };

  webrtc-audio-processing_1 = callPackage ../development/libraries/webrtc-audio-processing { };
  webrtc-audio-processing_0_3 =
    callPackage ../development/libraries/webrtc-audio-processing/0.3.nix
      { };
  # bump when majoring of packages have updated
  webrtc-audio-processing = webrtc-audio-processing_0_3;

  wlr-protocols = callPackage ../development/libraries/wlroots/protocols.nix { };

  wt = wt4;
  inherit (libsForQt5.callPackage ../development/libraries/wt { })
    wt4
    ;

  inherit (callPackages ../development/libraries/xapian { })
    xapian_1_4
    ;
  xapian = xapian_1_4;

  xapian-omega = callPackage ../development/libraries/xapian/tools/omega {
    libmagic = file;
  };

  xcb-util-cursor = xorg.xcbutilcursor;
  xcb-util-cursor-HEAD = callPackage ../development/libraries/xcb-util-cursor/HEAD.nix { };

  xcbutilxrm = callPackage ../servers/x11/xorg/xcb-util-xrm.nix { };

  xgboostWithCuda = xgboost.override { cudaSupport = true; };

  yubikey-manager-qt = libsForQt5.callPackage ../tools/misc/yubikey-manager-qt { };

  yubikey-personalization-gui = libsForQt5.callPackage ../tools/misc/yubikey-personalization-gui { };

  zlib = callPackage ../development/libraries/zlib {
    stdenv =
      # zlib is a dependency of xcbuild. Avoid an infinite recursion by using a bootstrap stdenv
      # that does not propagate xcrun.
      if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
  };

  inherit
    (rec {
      zigPackages = recurseIntoAttrs (callPackage ../development/compilers/zig { });

      zig_0_12 = zigPackages."0.12";
      zig_0_13 = zigPackages."0.13";
      zig_0_14 = zigPackages."0.14";
    })
    zigPackages
    zig_0_12
    zig_0_13
    zig_0_14
    ;

  zig = zig_0_14;

  zigStdenv = if stdenv.cc.isZig then stdenv else lowPrio zig.passthru.stdenv;

  aroccPackages = recurseIntoAttrs (callPackage ../development/compilers/arocc { });
  arocc = aroccPackages.latest;

  aroccStdenv = if stdenv.cc.isArocc then stdenv else lowPrio arocc.cc.passthru.stdenv;

  ### DEVELOPMENT / LIBRARIES / DARWIN SDKS

  apple-sdk_11 = callPackage ../by-name/ap/apple-sdk/package.nix { darwinSdkMajorVersion = "11"; };
  apple-sdk_12 = callPackage ../by-name/ap/apple-sdk/package.nix { darwinSdkMajorVersion = "12"; };
  apple-sdk_13 = callPackage ../by-name/ap/apple-sdk/package.nix { darwinSdkMajorVersion = "13"; };
  apple-sdk_14 = callPackage ../by-name/ap/apple-sdk/package.nix { darwinSdkMajorVersion = "14"; };
  apple-sdk_15 = callPackage ../by-name/ap/apple-sdk/package.nix { darwinSdkMajorVersion = "15"; };

  darwinMinVersionHook =
    deploymentTarget:
    makeSetupHook {
      name = "darwin-deployment-target-hook-${deploymentTarget}";
      substitutions = {
        darwinMinVersionVariable = lib.escapeShellArg stdenv.hostPlatform.darwinMinVersionVariable;
        deploymentTarget = lib.escapeShellArg deploymentTarget;
      };
    } ../os-specific/darwin/darwin-min-version-hook/setup-hook.sh;

  ### DEVELOPMENT / TESTING TOOLS

  atf = callPackage ../by-name/at/atf/package.nix {
    stdenv =
      # atf is a dependency of libiconv. Avoid an infinite recursion with `pkgsStatic` by using a bootstrap stdenv.
      if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
  };

  ### DEVELOPMENT / LIBRARIES / AGDA

  agdaPackages = recurseIntoAttrs (
    callPackage ./agda-packages.nix {
      inherit (haskellPackages) Agda;
    }
  );
  agda = agdaPackages.agda;

  ### DEVELOPMENT / LIBRARIES / BASH

  ### DEVELOPMENT / LIBRARIES / JAVA

  javaCup = callPackage ../development/libraries/java/cup {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  saxonb = saxonb_8_8;
  saxon-he = saxon_12-he;

  inherit
    (callPackages ../development/libraries/java/saxon {
      jre = jre_headless;
      jre8 = jre8_headless;
    })
    saxon
    saxonb_8_8
    saxonb_9_1
    saxon_9-he
    saxon_11-he
    saxon_12-he
    ;

  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO

  # the unversioned attributes should always point to the same go version
  go = go_1_24;
  buildGoModule = buildGo124Module;

  go_latest = go_1_24;
  buildGoLatestModule = buildGo124Module;

  go_1_23 = callPackage ../development/compilers/go/1.23.nix { };
  buildGo123Module = callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_23;
  };

  go_1_24 = callPackage ../development/compilers/go/1.24.nix { };
  buildGo124Module = callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_24;
  };

  go_1_25 = callPackage ../development/compilers/go/1.25.nix { };
  buildGo125Module = callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_25;
  };

  ### DEVELOPMENT / HARE

  hareHook = callPackage ../by-name/ha/hare/hook.nix { };

  ### DEVELOPMENT / JAVA MODULES

  javaPackages = recurseIntoAttrs (callPackage ./java-packages.nix { });

  ### DEVELOPMENT / LISP MODULES

  asdf = callPackage ../development/lisp-modules/asdf {
    texLive = null;
  };

  # QuickLisp minimal version
  asdf_2_26 = callPackage ../development/lisp-modules/asdf/2.26.nix {
    texLive = null;
  };
  # Currently most popular
  asdf_3_1 = callPackage ../development/lisp-modules/asdf/3.1.nix {
    texLive = null;
  };
  # Latest
  asdf_3_3 = callPackage ../development/lisp-modules/asdf/3.3.nix {
    texLive = null;
  };

  wrapLisp = callPackage ../development/lisp-modules/nix-cl.nix { };

  # Armed Bear Common Lisp
  abcl = wrapLisp {
    pkg = callPackage ../development/compilers/abcl {
      # https://armedbear.common-lisp.dev/ lists OpenJDK 17 as the highest
      # supported JDK.
      jdk = openjdk17;
    };
    faslExt = "abcl";
  };

  # Clozure Common Lisp
  ccl = wrapLisp {
    pkg = callPackage ../development/compilers/ccl {
      inherit (buildPackages.darwin) bootstrap_cmds;
    };
    faslExt = "lx64fsl";
  };

  # Clasp Common Lisp
  clasp-common-lisp = wrapLisp {
    pkg = callPackage ../development/compilers/clasp { };
    faslExt = "fasl";
  };

  # CLISP
  clisp = wrapLisp {
    pkg = callPackage ../development/interpreters/clisp { };
    faslExt = "fas";
    flags = [
      "-E"
      "UTF-8"
    ];
  };

  wrapLispi686Linux = pkgsi686Linux.callPackage ../development/lisp-modules/nix-cl.nix { };

  # CMU Common Lisp
  cmucl_binary = wrapLispi686Linux {
    pkg = pkgsi686Linux.callPackage ../development/compilers/cmucl/binary.nix { };
    faslExt = "sse2f";
    program = "lisp";
  };

  # Embeddable Common Lisp
  ecl = wrapLisp {
    pkg = callPackage ../development/compilers/ecl { };
    faslExt = "fas";
  };
  ecl_16_1_2 = wrapLisp {
    pkg = callPackage ../development/compilers/ecl/16.1.2.nix { };
    faslExt = "fas";
  };

  # GNU Common Lisp
  gcl = wrapLisp {
    pkg = callPackage ../development/compilers/gcl { };
    faslExt = "o";
  };

  # ManKai Common Lisp
  mkcl = wrapLisp {
    pkg = callPackage ../development/compilers/mkcl { };
    faslExt = "fas";
  };

  # Steel Bank Common Lisp
  sbcl_2_4_6 = wrapLisp {
    pkg = callPackage ../development/compilers/sbcl { version = "2.4.6"; };
    faslExt = "fasl";
    flags = [
      "--dynamic-space-size"
      "3000"
    ];
  };
  sbcl_2_4_10 = wrapLisp {
    pkg = callPackage ../development/compilers/sbcl { version = "2.4.10"; };
    faslExt = "fasl";
    flags = [
      "--dynamic-space-size"
      "3000"
    ];
  };
  sbcl_2_5_2 = wrapLisp {
    pkg = callPackage ../development/compilers/sbcl { version = "2.5.2"; };
    faslExt = "fasl";
    flags = [
      "--dynamic-space-size"
      "3000"
    ];
  };
  sbcl_2_5_4 = wrapLisp {
    pkg = callPackage ../development/compilers/sbcl { version = "2.5.4"; };
    faslExt = "fasl";
    flags = [
      "--dynamic-space-size"
      "3000"
    ];
  };
  sbcl = sbcl_2_5_4;

  sbclPackages = recurseIntoAttrs sbcl.pkgs;

  ### DEVELOPMENT / PERL MODULES

  perlInterpreters = import ../development/interpreters/perl { inherit callPackage; };
  inherit (perlInterpreters) perl538 perl540;

  perl538Packages = recurseIntoAttrs perl538.pkgs;
  perl540Packages = recurseIntoAttrs perl540.pkgs;

  perl = perl540;
  perlPackages = perl540Packages;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;

  sqitchMysql =
    (callPackage ../development/tools/misc/sqitch {
      mysqlSupport = true;
    }).overrideAttrs
      { pname = "sqitch-mysql"; };

  sqitchPg =
    (callPackage ../development/tools/misc/sqitch {
      postgresqlSupport = true;
    }).overrideAttrs
      { pname = "sqitch-pg"; };

  sqitchSqlite =
    (callPackage ../development/tools/misc/sqitch {
      sqliteSupport = true;
    }).overrideAttrs
      { pname = "sqitch-sqlite"; };

  ### DEVELOPMENT / R MODULES

  R = callPackage ../applications/science/math/R {
    # TODO: split docs into a separate output
    withRecommendedPackages = false;
  };

  rWrapper = callPackage ../development/r-modules/wrapper.nix {
    recommendedPackages = with rPackages; [
      boot
      class
      cluster
      codetools
      foreign
      KernSmooth
      lattice
      MASS
      Matrix
      mgcv
      nlme
      nnet
      rpart
      spatial
      survival
    ];
    # Override this attribute to register additional libraries.
    packages = [ ];
  };

  radianWrapper = callPackage ../development/r-modules/wrapper-radian.nix {
    recommendedPackages = with rPackages; [
      boot
      class
      cluster
      codetools
      foreign
      KernSmooth
      lattice
      MASS
      Matrix
      mgcv
      nlme
      nnet
      rpart
      spatial
      survival
    ];
    radian = python3Packages.radian;
    # Override this attribute to register additional libraries.
    packages = [ ];
    # Override this attribute if you want to expose R with the same set of
    # packages as specified in radian
    wrapR = false;
  };

  rstudioWrapper = callPackage ../development/r-modules/wrapper-rstudio.nix {
    recommendedPackages = with rPackages; [
      boot
      class
      cluster
      codetools
      foreign
      KernSmooth
      lattice
      MASS
      Matrix
      mgcv
      nlme
      nnet
      rpart
      spatial
      survival
    ];
    # Override this attribute to register additional libraries.
    packages = [ ];
  };

  rstudioServerWrapper = rstudioWrapper.override { rstudio = rstudio-server; };

  rPackages = dontRecurseIntoAttrs (
    callPackage ../development/r-modules {
      overrides = (config.rPackageOverrides or (_: { })) pkgs;
    }
  );

  ### SERVERS

  adguardhome = callPackage ../servers/adguardhome { };

  alerta = callPackage ../servers/monitoring/alerta/client.nix { };

  alerta-server = callPackage ../servers/monitoring/alerta { };

  apacheHttpd_2_4 = callPackage ../servers/http/apache-httpd/2.4.nix { };
  apacheHttpd = apacheHttpd_2_4;

  apacheHttpdPackagesFor =
    apacheHttpd: self:
    let
      callPackage = newScope self;
    in
    {
      inherit apacheHttpd;
      mod_auth_mellon = callPackage ../servers/http/apache-modules/mod_auth_mellon { };
      mod_ca = callPackage ../servers/http/apache-modules/mod_ca { };
      mod_crl = callPackage ../servers/http/apache-modules/mod_crl { };
      mod_cspnonce = callPackage ../servers/http/apache-modules/mod_cspnonce { };
      mod_csr = callPackage ../servers/http/apache-modules/mod_csr { };
      mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };
      mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };
      mod_itk = callPackage ../servers/http/apache-modules/mod_itk { };
      mod_jk = callPackage ../servers/http/apache-modules/mod_jk { };
      mod_mbtiles = callPackage ../servers/http/apache-modules/mod_mbtiles { };
      mod_ocsp = callPackage ../servers/http/apache-modules/mod_ocsp { };
      mod_perl = callPackage ../servers/http/apache-modules/mod_perl { };
      mod_pkcs12 = callPackage ../servers/http/apache-modules/mod_pkcs12 { };
      mod_python = callPackage ../servers/http/apache-modules/mod_python { };
      mod_scep = callPackage ../servers/http/apache-modules/mod_scep { };
      mod_spkac = callPackage ../servers/http/apache-modules/mod_spkac { };
      mod_tile = callPackage ../servers/http/apache-modules/mod_tile { };
      mod_timestamp = callPackage ../servers/http/apache-modules/mod_timestamp { };
      mod_wsgi3 = callPackage ../servers/http/apache-modules/mod_wsgi { };
      php = pkgs.php.override { inherit apacheHttpd; };
      subversion = pkgs.subversion.override {
        httpServer = true;
        inherit apacheHttpd;
      };
    }
    // lib.optionalAttrs config.allowAliases {
      mod_evasive = throw "mod_evasive is not supported on Apache httpd 2.4";
      mod_wsgi = self.mod_wsgi2;
      mod_wsgi2 = throw "mod_wsgi2 has been removed since Python 2 is EOL. Use mod_wsgi3 instead";
    };

  apacheHttpdPackages_2_4 = recurseIntoAttrs (
    apacheHttpdPackagesFor apacheHttpd_2_4 apacheHttpdPackages_2_4
  );
  apacheHttpdPackages = apacheHttpdPackages_2_4;

  appdaemon = callPackage ../servers/home-assistant/appdaemon.nix { };

  cassandra_4 = callPackage ../servers/nosql/cassandra/4.nix {
    # Effective Cassandra 4.0.2 there is full Java 11 support
    #  -- https://cassandra.apache.org/doc/latest/cassandra/new/java11.html
    jre = pkgs.jdk11_headless;
    python = python3;
  };
  cassandra = cassandra_4;

  cassandra-cpp-driver = callPackage ../development/libraries/cassandra-cpp-driver/default.nix { };

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jre;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jre;
  };

  inherit (callPackages ../servers/asterisk { })
    asterisk
    asterisk-stable
    asterisk-lts
    asterisk_18
    asterisk_20
    asterisk_22
    ;

  asterisk-ldap = lowPrio (asterisk.override { ldapSupport = true; });

  dnsutils = bind.dnsutils;
  dig = lib.addMetaAttrs { mainProgram = "dig"; } bind.dnsutils;

  charybdis = callPackage ../servers/irc/charybdis {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  clickhouse = callPackage ../servers/clickhouse {
    llvmPackages = llvmPackages_16;
  };

  clickhouse-cli = with python3Packages; toPythonApplication clickhouse-cli;

  couchdb3 = callPackage ../servers/http/couchdb/3.nix {
    erlang = beamMinimalPackages.erlang;
  };

  dcnnt = python3Packages.callPackage ../servers/dcnnt { };

  deconz = qt5.callPackage ../servers/deconz { };

  dict = callPackage ../servers/dict {
    flex = flex_2_5_35;
    libmaa = callPackage ../servers/dict/libmaa.nix { };
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix { });

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix { };

  diod = callPackage ../servers/diod { lua = lua5_1; };

  directx-shader-compiler = callPackage ../tools/graphics/directx-shader-compiler {
    # https://github.com/NixOS/nixpkgs/issues/216294
    stdenv = if stdenv.cc.isGNU && stdenv.hostPlatform.isi686 then gcc11Stdenv else stdenv;
  };

  dodgy = with python3Packages; toPythonApplication dodgy;

  envoy = callPackage ../by-name/en/envoy/package.nix {
    jdk = openjdk11_headless;
  };

  etcd = etcd_3_5;
  etcd_3_4 = callPackage ../servers/etcd/3.4.nix { };
  etcd_3_5 = callPackage ../servers/etcd/3.5 { };

  prosody = callPackage ../servers/xmpp/prosody {
    withExtraLibs = [ ];
    withExtraLuaPackages = _: [ ];
  };

  elasticmq-server-bin = callPackage ../servers/elasticmq-server-bin {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  eventstore = callPackage ../servers/nosql/eventstore { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  inherit (callPackages ../servers/firebird { })
    firebird_4
    firebird_3
    firebird
    ;

  freshrss = callPackage ../servers/web-apps/freshrss { };
  freshrss-extensions = recurseIntoAttrs (callPackage ../servers/web-apps/freshrss/extensions { });

  glabels-qt = callPackage ../applications/graphics/glabels-qt { };

  grafana = callPackage ../servers/monitoring/grafana { };
  grafanaPlugins = callPackages ../servers/monitoring/grafana/plugins { };

  hasura-cli = callPackage ../servers/hasura/cli.nix { };

  inherit (callPackage ../servers/hbase { })
    hbase_2_4
    hbase_2_5
    hbase_2_6
    hbase_3_0
    ;
  hbase2 = hbase_2_6;
  hbase3 = hbase_3_0;
  hbase = hbase2; # when updating, point to the latest stable release

  home-assistant = callPackage ../servers/home-assistant { };

  buildHomeAssistantComponent = callPackage ../servers/home-assistant/build-custom-component { };
  home-assistant-custom-components = lib.recurseIntoAttrs (
    lib.packagesFromDirectoryRecursive {
      inherit (home-assistant.python.pkgs) callPackage;
      directory = ../servers/home-assistant/custom-components;
    }
  );
  home-assistant-custom-lovelace-modules = lib.recurseIntoAttrs (
    lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ../servers/home-assistant/custom-lovelace-modules;
    }
  );

  home-assistant-cli = callPackage ../servers/home-assistant/cli.nix { };

  home-assistant-component-tests = recurseIntoAttrs home-assistant.tests.components;

  icingaweb2-ipl = callPackage ../servers/icingaweb2/ipl.nix { };
  icingaweb2-thirdparty = callPackage ../servers/icingaweb2/thirdparty.nix { };
  icingaweb2 = callPackage ../servers/icingaweb2 { };
  icingaweb2Modules = {
    theme-april = callPackage ../servers/icingaweb2/theme-april { };
    theme-lsd = callPackage ../servers/icingaweb2/theme-lsd { };
    theme-particles = callPackage ../servers/icingaweb2/theme-particles { };
    theme-snow = callPackage ../servers/icingaweb2/theme-snow { };
    theme-spring = callPackage ../servers/icingaweb2/theme-spring { };
  };

  inspircdMinimal = inspircd.override { extraModules = [ ]; };

  inherit (callPackages ../servers/http/jetty { })
    jetty_11
    jetty_12
    ;

  jetty = jetty_12;

  kanidm_1_5 = callPackage ../by-name/ka/kanidm/1_5.nix { kanidm = kanidm_1_5; };
  kanidm_1_6 = callPackage ../by-name/ka/kanidm/1_6.nix { kanidm = kanidm_1_6; };
  kanidm_1_7 = callPackage ../by-name/ka/kanidm/1_7.nix {
    kanidm = kanidm_1_7;
    rustPlatform = rustPackages_1_88.rustPlatform;
  };

  kanidmWithSecretProvisioning = kanidmWithSecretProvisioning_1_6;

  kanidmWithSecretProvisioning_1_5 = callPackage ../by-name/ka/kanidm/1_5.nix {
    enableSecretProvisioning = true;
  };

  kanidmWithSecretProvisioning_1_6 = callPackage ../by-name/ka/kanidm/1_6.nix {
    enableSecretProvisioning = true;
  };

  kanidmWithSecretProvisioning_1_7 = callPackage ../by-name/ka/kanidm/1_7.nix {
    enableSecretProvisioning = true;
    rustPlatform = rustPackages_1_88.rustPlatform;
  };

  knot-resolver = callPackage ../servers/dns/knot-resolver {
    systemd = systemdMinimal; # in closure already anyway
  };

  leafnode = callPackage ../servers/news/leafnode { };

  leafnode1 = callPackage ../servers/news/leafnode/1.nix { };

  lemmy-server = callPackage ../servers/web-apps/lemmy/server.nix { };

  lemmy-ui = callPackage ../servers/web-apps/lemmy/ui.nix {
    nodejs = nodejs_20;
  };

  mailmanPackages = callPackage ../servers/mail/mailman { };
  inherit (mailmanPackages) mailman mailman-hyperkitty;
  mailman-web = mailmanPackages.web;

  mastodon = callPackage ../servers/mastodon {
    nodejs-slim = nodejs-slim_22;
    python3 = python311;
    ruby = ruby_3_3;
    yarn-berry = yarn-berry_4.override { nodejs = nodejs-slim_22; };
  };

  micro-full = micro.wrapper.override {
    extraPackages = [
      wl-clipboard
      xclip
    ];
  };

  micro-with-wl-clipboard = micro.wrapper.override {
    extraPackages = [
      wl-clipboard
    ];
  };

  micro-with-xclip = micro.wrapper.override {
    extraPackages = [
      xclip
    ];
  };

  minio = callPackage ../servers/minio { };
  # Keep around to allow people to migrate their data from the old legacy fs format
  # https://github.com/minio/minio/releases/tag/RELEASE.2022-10-29T06-21-33Z
  minio_legacy_fs = callPackage ../servers/minio/legacy_fs.nix { };

  mkchromecast = libsForQt5.callPackage ../applications/networking/mkchromecast { };

  inherit
    (callPackages ../servers/mpd {
    })
    mpd
    mpd-small
    mpdWithFeatures
    ;

  mtprotoproxy = python3.pkgs.callPackage ../servers/mtprotoproxy { };

  moodle = callPackage ../servers/web-apps/moodle { };

  moodle-utils = callPackage ../servers/web-apps/moodle/moodle-utils.nix { };

  inherit (callPackage ../applications/networking/mullvad { })
    mullvad
    ;

  mullvad-closest = with python3Packages; toPythonApplication mullvad-closest;

  napalm =
    with python3Packages;
    toPythonApplication (
      napalm.overridePythonAttrs (attrs: {
        # add community frontends that depend on the napalm python package
        propagatedBuildInputs = attrs.propagatedBuildInputs ++ [
          napalm-hp-procurve
        ];
      })
    );

  nginx = nginxStable;

  nginxQuic = callPackage ../servers/http/nginx/quic.nix {
    zlib-ng = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [
      nginxModules.rtmp
      nginxModules.dav
      nginxModules.moreheaders
    ];
    # Use latest boringssl to allow http3 support
    openssl = quictls;
  };

  nginxStable = callPackage ../servers/http/nginx/stable.nix {
    zlib-ng = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [
      nginxModules.rtmp
      nginxModules.dav
      nginxModules.moreheaders
    ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    zlib-ng = zlib-ng.override { withZlibCompat = true; };
    withKTLS = true;
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [
      nginxModules.dav
      nginxModules.moreheaders
    ];
  };

  nginxModules = recurseIntoAttrs (callPackage ../servers/http/nginx/modules.nix { });

  # We should move to dynmaic modules and create a nginxFull package with all modules
  nginxShibboleth = nginxStable.override {
    modules = [
      nginxModules.rtmp
      nginxModules.dav
      nginxModules.moreheaders
      nginxModules.shibboleth
    ];
  };

  libmodsecurity = callPackage ../tools/security/libmodsecurity {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  nsd = callPackage ../servers/dns/nsd (config.nsd or { });

  outline = callPackage ../servers/web-apps/outline (
    lib.fix (super: {
      yarn = yarn.override { inherit (super) nodejs; };
      nodejs = nodejs_22;
    })
  );

  openafs = callPackage ../servers/openafs/1.8 { };

  openresty = callPackage ../servers/http/openresty {
    zlib-ng = zlib;
    withPerl = false;
    modules = [ ];
  };

  system-sendmail = lowPrio (callPackage ../servers/mail/system-sendmail { });

  # PulseAudio daemons

  hsphfpd = callPackage ../servers/pulseaudio/hsphfpd.nix { };

  pulseaudio = callPackage ../servers/pulseaudio { };

  qpaeq = libsForQt5.callPackage ../servers/pulseaudio/qpaeq.nix { };

  pulseaudioFull = pulseaudio.override {
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    advancedBluetoothCodecs = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  libpulseaudio = pulseaudio.override {
    libOnly = true;
  };

  apulse = callPackage ../misc/apulse { };

  libpressureaudio = callPackage ../misc/apulse/pressureaudio.nix { };

  tomcat-native = callPackage ../servers/http/tomcat/tomcat-native.nix { };

  libmysqlclient = libmysqlclient_3_3;
  libmysqlclient_3_1 = mariadb-connector-c_3_1;
  libmysqlclient_3_2 = mariadb-connector-c_3_2;
  libmysqlclient_3_3 = mariadb-connector-c_3_3;
  mariadb-connector-c = mariadb-connector-c_3_3;
  mariadb-connector-c_3_1 = callPackage ../servers/sql/mariadb/connector-c/3_1.nix { };
  mariadb-connector-c_3_2 = callPackage ../servers/sql/mariadb/connector-c/3_2.nix { };
  mariadb-connector-c_3_3 = callPackage ../servers/sql/mariadb/connector-c/3_3.nix { };

  inherit (import ../servers/sql/mariadb pkgs)
    mariadb_106
    mariadb_1011
    mariadb_114
    ;
  mariadb = mariadb_1011;
  mariadb-embedded = mariadb.override { withEmbedded = true; };

  mongodb = hiPrio mongodb-7_0;

  mongodb-6_0 = callPackage ../servers/nosql/mongodb/6.0.nix {
    sasl = cyrus_sasl;
    boost = boost178.override { enableShared = false; };
  };

  mongodb-7_0 = callPackage ../servers/nosql/mongodb/7.0.nix {
    sasl = cyrus_sasl;
    boost = boost179.override { enableShared = false; };
  };

  influxdb = callPackage ../servers/nosql/influxdb { };
  influxdb2-server = callPackage ../servers/nosql/influxdb2 { };
  influxdb2-cli = callPackage ../servers/nosql/influxdb2/cli.nix { };
  influxdb2-token-manipulator = callPackage ../servers/nosql/influxdb2/token-manipulator.nix { };
  influxdb2-provision = callPackage ../servers/nosql/influxdb2/provision.nix { };
  # For backwards compatibility with older versions of influxdb2,
  # which bundled the server and CLI into the same derivation. Will be
  # removed in a few releases.
  influxdb2 = callPackage ../servers/nosql/influxdb2/combined.nix { };

  mysql80 = callPackage ../servers/sql/mysql/8.0.x.nix {
    inherit (darwin) developer_cmds DarwinTools;
    boost = boost177; # Configure checks for specific version.
    icu = icu69;
    protobuf = protobuf_21;
  };

  mssql_jdbc = callPackage ../servers/sql/mssql/jdbc { };
  jtds_jdbc = callPackage ../servers/sql/mssql/jdbc/jtds.nix { };

  inherit (callPackage ../servers/mir { })
    mir
    mir_2_15
    ;

  icinga2 = callPackage ../servers/monitoring/icinga2 { };

  icinga2-agent = callPackage ../servers/monitoring/icinga2 {
    nameSuffix = "-agent";
    withMysql = false;
    withNotification = false;
    withIcingadb = false;
    withPerfdata = false;
  };

  nagiosPlugins = recurseIntoAttrs (callPackages ../servers/monitoring/nagios-plugins { });

  riemann-dash = callPackage ../servers/monitoring/riemann-dash { };

  qboot = pkgsi686Linux.callPackage ../applications/virtualization/qboot { };

  rust-hypervisor-firmware = callPackage ../applications/virtualization/rust-hypervisor-firmware { };

  OVMF = callPackage ../applications/virtualization/OVMF {
    inherit (python3Packages) pexpect;
  };
  OVMFFull = callPackage ../applications/virtualization/OVMF {
    inherit (python3Packages) pexpect;
    secureBoot = true;
    httpSupport = true;
    tpmSupport = true;
    tlsSupport = true;
    msVarsTemplate = stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64;
  };

  tang = callPackage ../servers/tang {
    asciidoc = asciidoc-full;
  };

  inherit (import ../servers/sql/postgresql pkgs)
    postgresqlVersions
    postgresqlJitVersions
    libpq
    ;

  inherit (postgresqlVersions)
    postgresql_13
    postgresql_14
    postgresql_15
    postgresql_16
    postgresql_17
    ;

  inherit (postgresqlJitVersions)
    postgresql_13_jit
    postgresql_14_jit
    postgresql_15_jit
    postgresql_16_jit
    postgresql_17_jit
    ;
  postgresql = postgresql_17;
  postgresql_jit = postgresql_17_jit;
  postgresqlPackages = recurseIntoAttrs postgresql.pkgs;
  postgresql13Packages = recurseIntoAttrs postgresql_13.pkgs;
  postgresql14Packages = recurseIntoAttrs postgresql_14.pkgs;
  postgresql15Packages = recurseIntoAttrs postgresql_15.pkgs;
  postgresql16Packages = recurseIntoAttrs postgresql_16.pkgs;
  postgresql17Packages = recurseIntoAttrs postgresql_17.pkgs;

  postgres-websockets = haskellPackages.postgres-websockets.bin;
  postgrest = haskellPackages.postgrest.bin;

  prom2json = callPackage ../servers/monitoring/prometheus/prom2json.nix { };
  prometheus-alertmanager = callPackage ../servers/monitoring/prometheus/alertmanager.nix { };
  prometheus-apcupsd-exporter = callPackage ../servers/monitoring/prometheus/apcupsd-exporter.nix { };
  prometheus-artifactory-exporter =
    callPackage ../servers/monitoring/prometheus/artifactory-exporter.nix
      { };
  prometheus-atlas-exporter = callPackage ../servers/monitoring/prometheus/atlas-exporter.nix { };
  prometheus-aws-s3-exporter = callPackage ../servers/monitoring/prometheus/aws-s3-exporter.nix { };
  prometheus-bind-exporter = callPackage ../servers/monitoring/prometheus/bind-exporter.nix { };
  prometheus-bird-exporter = callPackage ../servers/monitoring/prometheus/bird-exporter.nix { };
  prometheus-bitcoin-exporter = callPackage ../servers/monitoring/prometheus/bitcoin-exporter.nix { };
  prometheus-blackbox-exporter =
    callPackage ../servers/monitoring/prometheus/blackbox-exporter.nix
      { };
  prometheus-cloudflare-exporter =
    callPackage ../servers/monitoring/prometheus/cloudflare-exporter.nix
      { };
  prometheus-collectd-exporter =
    callPackage ../servers/monitoring/prometheus/collectd-exporter.nix
      { };
  prometheus-consul-exporter = callPackage ../servers/monitoring/prometheus/consul-exporter.nix { };
  prometheus-dnsmasq-exporter = callPackage ../servers/monitoring/prometheus/dnsmasq-exporter.nix { };
  prometheus-domain-exporter = callPackage ../servers/monitoring/prometheus/domain-exporter.nix { };
  prometheus-fastly-exporter = callPackage ../servers/monitoring/prometheus/fastly-exporter.nix { };
  prometheus-flow-exporter = callPackage ../servers/monitoring/prometheus/flow-exporter.nix { };
  prometheus-fritzbox-exporter =
    callPackage ../servers/monitoring/prometheus/fritzbox-exporter.nix
      { };
  prometheus-gitlab-ci-pipelines-exporter =
    callPackage ../servers/monitoring/prometheus/gitlab-ci-pipelines-exporter.nix
      { };
  prometheus-graphite-exporter =
    callPackage ../servers/monitoring/prometheus/graphite-exporter.nix
      { };
  prometheus-haproxy-exporter = callPackage ../servers/monitoring/prometheus/haproxy-exporter.nix { };
  prometheus-idrac-exporter = callPackage ../servers/monitoring/prometheus/idrac-exporter.nix { };
  prometheus-imap-mailstat-exporter =
    callPackage ../servers/monitoring/prometheus/imap-mailstat-exporter.nix
      { };
  prometheus-influxdb-exporter =
    callPackage ../servers/monitoring/prometheus/influxdb-exporter.nix
      { };
  prometheus-ipmi-exporter = callPackage ../servers/monitoring/prometheus/ipmi-exporter.nix { };
  prometheus-jitsi-exporter = callPackage ../servers/monitoring/prometheus/jitsi-exporter.nix { };
  prometheus-jmx-httpserver = callPackage ../servers/monitoring/prometheus/jmx-httpserver.nix { };
  prometheus-json-exporter = callPackage ../servers/monitoring/prometheus/json-exporter.nix { };
  prometheus-junos-czerwonk-exporter =
    callPackage ../servers/monitoring/prometheus/junos-czerwonk-exporter.nix
      { };
  prometheus-kea-exporter = callPackage ../servers/monitoring/prometheus/kea-exporter.nix { };
  prometheus-keylight-exporter =
    callPackage ../servers/monitoring/prometheus/keylight-exporter.nix
      { };
  prometheus-knot-exporter = callPackage ../servers/monitoring/prometheus/knot-exporter.nix { };
  prometheus-lnd-exporter = callPackage ../servers/monitoring/prometheus/lnd-exporter.nix { };
  prometheus-mail-exporter = callPackage ../servers/monitoring/prometheus/mail-exporter.nix { };
  prometheus-mikrotik-exporter =
    callPackage ../servers/monitoring/prometheus/mikrotik-exporter.nix
      { };
  prometheus-modemmanager-exporter =
    callPackage ../servers/monitoring/prometheus/modemmanager-exporter.nix
      { };
  prometheus-mongodb-exporter = callPackage ../servers/monitoring/prometheus/mongodb-exporter.nix { };
  prometheus-mysqld-exporter = callPackage ../servers/monitoring/prometheus/mysqld-exporter.nix { };
  prometheus-nats-exporter = callPackage ../servers/monitoring/prometheus/nats-exporter.nix { };
  prometheus-nextcloud-exporter =
    callPackage ../servers/monitoring/prometheus/nextcloud-exporter.nix
      { };
  prometheus-nginx-exporter = callPackage ../servers/monitoring/prometheus/nginx-exporter.nix { };
  prometheus-nginxlog-exporter =
    callPackage ../servers/monitoring/prometheus/nginxlog-exporter.nix
      { };
  prometheus-nut-exporter = callPackage ../servers/monitoring/prometheus/nut-exporter.nix { };
  prometheus-pgbouncer-exporter =
    callPackage ../servers/monitoring/prometheus/pgbouncer-exporter.nix
      { };
  prometheus-php-fpm-exporter = callPackage ../servers/monitoring/prometheus/php-fpm-exporter.nix { };
  prometheus-pihole-exporter = callPackage ../servers/monitoring/prometheus/pihole-exporter.nix { };
  prometheus-ping-exporter = callPackage ../servers/monitoring/prometheus/ping-exporter.nix { };
  prometheus-postfix-exporter = callPackage ../servers/monitoring/prometheus/postfix-exporter.nix { };
  prometheus-postgres-exporter =
    callPackage ../servers/monitoring/prometheus/postgres-exporter.nix
      { };
  prometheus-process-exporter = callPackage ../servers/monitoring/prometheus/process-exporter.nix { };
  prometheus-pve-exporter = callPackage ../servers/monitoring/prometheus/pve-exporter.nix { };
  prometheus-redis-exporter = callPackage ../servers/monitoring/prometheus/redis-exporter.nix { };
  prometheus-rabbitmq-exporter =
    callPackage ../servers/monitoring/prometheus/rabbitmq-exporter.nix
      { };
  prometheus-rtl_433-exporter = callPackage ../servers/monitoring/prometheus/rtl_433-exporter.nix { };
  prometheus-sabnzbd-exporter = callPackage ../servers/monitoring/prometheus/sabnzbd-exporter.nix { };
  prometheus-sachet = callPackage ../servers/monitoring/prometheus/sachet.nix { };
  prometheus-script-exporter = callPackage ../servers/monitoring/prometheus/script-exporter.nix { };
  prometheus-shelly-exporter = callPackage ../servers/monitoring/prometheus/shelly-exporter.nix { };
  prometheus-smokeping-prober = callPackage ../servers/monitoring/prometheus/smokeping-prober.nix { };
  prometheus-snmp-exporter = callPackage ../servers/monitoring/prometheus/snmp-exporter.nix { };
  prometheus-statsd-exporter = callPackage ../servers/monitoring/prometheus/statsd-exporter.nix { };
  prometheus-sql-exporter = callPackage ../servers/monitoring/prometheus/sql-exporter.nix { };
  prometheus-systemd-exporter = callPackage ../servers/monitoring/prometheus/systemd-exporter.nix { };
  prometheus-unbound-exporter = callPackage ../servers/monitoring/prometheus/unbound-exporter.nix { };
  prometheus-v2ray-exporter = callPackage ../servers/monitoring/prometheus/v2ray-exporter.nix { };
  prometheus-varnish-exporter = callPackage ../servers/monitoring/prometheus/varnish-exporter.nix { };
  prometheus-wireguard-exporter =
    callPackage ../servers/monitoring/prometheus/wireguard-exporter.nix
      {
      };
  prometheus-zfs-exporter = callPackage ../servers/monitoring/prometheus/zfs-exporter.nix { };
  prometheus-xmpp-alerts = callPackage ../servers/monitoring/prometheus/xmpp-alerts.nix { };

  public-inbox = perlPackages.callPackage ../servers/mail/public-inbox { };

  spf-engine = python3.pkgs.callPackage ../servers/mail/spf-engine { };

  pypiserver = with python3Packages; toPythonApplication pypiserver;

  qremotecontrol-server = libsForQt5.callPackage ../servers/misc/qremotecontrol-server { };

  rabbitmq-server = callPackage ../by-name/ra/rabbitmq-server/package.nix rec {
    erlang = erlang_27;
    elixir = elixir_1_17.override { inherit erlang; };
  };

  qcal = callPackage ../tools/networking/qcal/default.nix { };

  rake = callPackage ../development/tools/build-managers/rake { };

  restic = callPackage ../tools/backup/restic { };

  restic-rest-server = callPackage ../tools/backup/restic/rest-server.nix { };

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    stdenv = clangStdenv;
    libtool = cctools;
    protobuf = protobuf_21;
  };

  samba4 = callPackage ../servers/samba/4.x.nix { };

  samba = samba4;

  samba4Full = lowPrio (
    samba4.override {
      enableLDAP = true;
      enablePrinting = true;
      enableMDNS = true;
      enableDomainController = true;
      enableRegedit = true;
      enableCephFS = !stdenv.hostPlatform.isAarch64;
    }
  );

  sambaFull = samba4Full;

  scalene = with python3Packages; toPythonApplication scalene;

  shairplay = callPackage ../servers/shairplay { avahi = avahi-compat; };

  shairport-sync-airplay2 = shairport-sync.override {
    enableAirplay2 = true;
  };

  stalwart-mail-webadmin = stalwart-mail.webadmin;

  stalwart-mail-enterprise = stalwart-mail.override {
    stalwartEnterprise = true;
  };

  ruby-zoom = callPackage ../tools/text/ruby-zoom { };

  inherit (callPackages ../servers/monitoring/sensu-go { })
    sensu-go-agent
    sensu-go-backend
    sensu-go-cli
    ;

  shishi = callPackage ../servers/shishi {
    pam = if stdenv.hostPlatform.isLinux then pam else null;
    # see also openssl, which has/had this same trick
  };

  sickgear = callPackage ../servers/sickbeard/sickgear.nix { };

  spacecookie = haskell.lib.compose.justStaticExecutables haskellPackages.spacecookie;

  inherit (callPackages ../servers/http/tomcat { })
    tomcat9
    tomcat10
    tomcat11
    ;

  tomcat = tomcat11;

  torque = callPackage ../servers/computing/torque {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  virtualenv = with python3Packages; toPythonApplication virtualenv;

  virtualenv-clone = with python3Packages; toPythonApplication virtualenv-clone;

  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
  };

  xorg =
    let
      # Use `lib.callPackageWith __splicedPackages` rather than plain `callPackage`
      # so as not to have the newly bound xorg items already in scope,  which would
      # have created a cycle.
      overrides = lib.callPackageWith __splicedPackages ../servers/x11/xorg/overrides.nix {
        inherit (buildPackages.darwin) bootstrap_cmds;
        udev = if stdenv.hostPlatform.isLinux then udev else null;
        libdrm = if stdenv.hostPlatform.isLinux then libdrm else null;
      };

      generatedPackages = lib.callPackageWith __splicedPackages ../servers/x11/xorg/default.nix { };

      xorgPackages = makeScopeWithSplicing' {
        otherSplices = generateSplicesForMkScope "xorg";
        f = lib.extends overrides generatedPackages;
      };

    in
    recurseIntoAttrs xorgPackages;

  xwayland = callPackage ../servers/x11/xorg/xwayland.nix { };

  zabbixFor = version: rec {
    agent = (callPackages ../servers/monitoring/zabbix/agent.nix { }).${version};
    proxy-mysql =
      (callPackages ../servers/monitoring/zabbix/proxy.nix { mysqlSupport = true; }).${version};
    proxy-pgsql =
      (callPackages ../servers/monitoring/zabbix/proxy.nix { postgresqlSupport = true; }).${version};
    proxy-sqlite =
      (callPackages ../servers/monitoring/zabbix/proxy.nix { sqliteSupport = true; }).${version};
    server-mysql =
      (callPackages ../servers/monitoring/zabbix/server.nix { mysqlSupport = true; }).${version};
    server-pgsql =
      (callPackages ../servers/monitoring/zabbix/server.nix { postgresqlSupport = true; }).${version};
    web = (callPackages ../servers/monitoring/zabbix/web.nix { }).${version};
    agent2 = (callPackages ../servers/monitoring/zabbix/agent2.nix { }).${version};

    # backwards compatibility
    server = server-pgsql;
  };

  zabbix72 = recurseIntoAttrs (zabbixFor "v72");
  zabbix70 = recurseIntoAttrs (zabbixFor "v70");
  zabbix60 = recurseIntoAttrs (zabbixFor "v60");

  zabbix = zabbix60;

  ### SERVERS / GEOSPATIAL

  ### OS-SPECIFIC

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alsa-utils = callPackage ../by-name/al/alsa-utils/package.nix {
    fftw = fftwFloat;
  };

  arm-trusted-firmware = callPackage ../misc/arm-trusted-firmware { };
  inherit (arm-trusted-firmware)
    buildArmTrustedFirmware
    armTrustedFirmwareTools
    armTrustedFirmwareAllwinner
    armTrustedFirmwareAllwinnerH616
    armTrustedFirmwareAllwinnerH6
    armTrustedFirmwareQemu
    armTrustedFirmwareRK3328
    armTrustedFirmwareRK3399
    armTrustedFirmwareRK3568
    armTrustedFirmwareRK3588
    armTrustedFirmwareS905
    ;

  inherit (libapparmor.passthru) apparmorRulesFromClosure;

  ath9k-htc-blobless-firmware = callPackage ../os-specific/linux/firmware/ath9k { };
  ath9k-htc-blobless-firmware-unstable = callPackage ../os-specific/linux/firmware/ath9k {
    enableUnstable = true;
  };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 =
    callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix
      { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  bluez5 = bluez;
  bluez5-experimental = bluez-experimental;

  bluez-experimental = bluez.override {
    enableExperimental = true;
  };

  busybox = callPackage ../os-specific/linux/busybox {
    # Fixes libunwind from being dynamically linked to a static binary.
    stdenv =
      if (stdenv.targetPlatform.useLLVM or false) then
        overrideCC stdenv buildPackages.llvmPackages.clangNoLibcxx
      else
        stdenv;
  };
  busybox-sandbox-shell = callPackage ../os-specific/linux/busybox/sandbox-shell.nix { };

  cm-rgb = python3Packages.callPackage ../tools/system/cm-rgb { };

  conky = callPackage ../os-specific/linux/conky (
    {
      lua = lua5_4;
      inherit (linuxPackages.nvidia_x11.settings) libXNVCtrl;
    }
    // config.conky or { }
  );

  cpupower-gui = python3Packages.callPackage ../os-specific/linux/cpupower-gui {
    inherit (pkgs) meson;
  };

  # Darwin package set
  #
  # Even though this is a set of packages not single package, use `callPackage`
  # not `callPackages` so the per-package callPackages don't have their
  # `.override` clobbered. C.F. `llvmPackages` which does the same.
  darwin = callPackage ./darwin-packages.nix { };

  displaylink = callPackage ../os-specific/linux/displaylink {
    inherit (linuxPackages) evdi;
  };

  dmraid = callPackage ../os-specific/linux/dmraid { lvm2 = lvm2_dmeventd; };

  drbd = callPackage ../os-specific/linux/drbd/utils.nix { };

  # unstable until the first 1.x release
  fwts = callPackage ../os-specific/linux/fwts { };

  libuuid = if stdenv.hostPlatform.isLinux then util-linuxMinimal else null;

  elegant-sddm = libsForQt5.callPackage ../data/themes/elegant-sddm { };

  error-inject = callPackages ../os-specific/linux/error-inject { };

  ffado = callPackage ../os-specific/linux/ffado { };
  ffado-mixer = callPackage ../os-specific/linux/ffado { withMixer = true; };
  libffado = ffado;

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fusePackages = dontRecurseIntoAttrs (
    callPackage ../os-specific/linux/fuse {
      util-linux = util-linuxMinimal;
    }
  );
  fuse = fuse2;
  fuse2 = lowPrio (if stdenv.hostPlatform.isDarwin then macfuse-stubs else fusePackages.fuse_2);
  fuse3 = fusePackages.fuse_3;

  gpm = callPackage ../servers/gpm {
    withNcurses = false; # Keep curses disabled for lack of value

    # latest 6.8 mysteriously fails to parse '@headings single':
    #   https://lists.gnu.org/archive/html/bug-texinfo/2021-09/msg00011.html
    texinfo = buildPackages.texinfo6_7;
  };

  gpm-ncurses = gpm.override { withNcurses = true; };

  btop-cuda = btop.override { cudaSupport = true; };
  btop-rocm = btop.override { rocmSupport = true; };

  i7z = qt5.callPackage ../os-specific/linux/i7z { };

  ipu6-camera-hal = callPackage ../development/libraries/ipu6-camera-hal { };

  ipu6ep-camera-hal = callPackage ../development/libraries/ipu6-camera-hal {
    ipuVersion = "ipu6ep";
  };

  ipu6epmtl-camera-hal = callPackage ../development/libraries/ipu6-camera-hal {
    ipuVersion = "ipu6epmtl";
  };

  iputils = hiPrio (callPackage ../os-specific/linux/iputils { });
  # hiPrio for collisions with inetutils (ping)

  iptables = callPackage ../os-specific/linux/iptables { };
  iptables-legacy = callPackage ../os-specific/linux/iptables { nftablesCompat = false; };
  iptables-nftables-compat = iptables;

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  libkrun-sev = libkrun.override { sevVariant = true; };

  linthesia = callPackage ../games/linthesia/default.nix { };

  projecteur = libsForQt5.callPackage ../os-specific/linux/projecteur { };

  lkl = callPackage ../applications/virtualization/lkl { };
  lklWithFirewall = callPackage ../applications/virtualization/lkl { firewallSupport = true; };

  inherit (callPackages ../os-specific/linux/kernel-headers { inherit (pkgsBuildBuild) elf-header; })
    linuxHeaders
    makeLinuxHeaders
    ;

  klibc = callPackage ../os-specific/linux/klibc { };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linuxKernel = recurseIntoAttrs (callPackage ./linux-kernels.nix { });

  inherit (linuxKernel) buildLinux linuxConfig kernelPatches;

  linuxPackagesFor = linuxKernel.packagesFor;

  hardenedLinuxPackagesFor = linuxKernel.hardenedPackagesFor;

  linuxManualConfig = linuxKernel.manualConfig;

  linuxPackages_custom = linuxKernel.customPackage;

  # This serves as a test for linuxPackages_custom
  linuxPackages_custom_tinyconfig_kernel =
    let
      base = linuxPackages.kernel;
      tinyLinuxPackages = linuxKernel.customPackage {
        inherit (base) version modDirVersion src;
        allowImportFromDerivation = false;
        configfile = linuxConfig {
          makeTarget = "tinyconfig";
          src = base.src;
        };
      };
    in
    tinyLinuxPackages.kernel;

  # The current default kernel / kernel modules.
  linuxPackages = linuxKernel.packageAliases.linux_default;
  linux = linuxPackages.kernel;

  linuxPackages_latest = linuxKernel.packageAliases.linux_latest;
  linux_latest = linuxPackages_latest.kernel;

  # Testing (rc) kernel
  linuxPackages_testing = linuxKernel.packages.linux_testing;
  linux_testing = linuxKernel.kernels.linux_testing;

  # Realtime kernel
  linuxPackages-rt = linuxKernel.packageAliases.linux_rt_default;
  linuxPackages-rt_latest = linuxKernel.packageAliases.linux_rt_latest;
  linux-rt = linuxPackages-rt.kernel;
  linux-rt_latest = linuxPackages-rt_latest.kernel;

  # hardened kernels
  linuxPackages_hardened = linuxKernel.packages.linux_hardened;
  linux_hardened = linuxPackages_hardened.kernel;
  linuxPackages_5_4_hardened = linuxKernel.packages.linux_5_4_hardened;
  linux_5_4_hardened = linuxKernel.kernels.linux_5_4_hardened;
  linuxPackages_5_10_hardened = linuxKernel.packages.linux_5_10_hardened;
  linux_5_10_hardened = linuxKernel.kernels.linux_5_10_hardened;
  linuxPackages_5_15_hardened = linuxKernel.packages.linux_5_15_hardened;
  linux_5_15_hardened = linuxKernel.kernels.linux_5_15_hardened;
  linuxPackages_6_1_hardened = linuxKernel.packages.linux_6_1_hardened;
  linux_6_1_hardened = linuxKernel.kernels.linux_6_1_hardened;
  linuxPackages_6_6_hardened = linuxKernel.packages.linux_6_6_hardened;
  linux_6_6_hardened = linuxKernel.kernels.linux_6_6_hardened;
  linuxPackages_6_12_hardened = linuxKernel.packages.linux_6_12_hardened;
  linux_6_12_hardened = linuxKernel.kernels.linux_6_12_hardened;

  # GNU Linux-libre kernels
  linuxPackages-libre = linuxKernel.packages.linux_libre;
  linux-libre = linuxPackages-libre.kernel;
  linuxPackages_latest-libre = linuxKernel.packages.linux_latest_libre;
  linux_latest-libre = linuxPackages_latest-libre.kernel;

  # zen-kernel
  linuxPackages_zen = linuxKernel.packages.linux_zen;
  linux_zen = linuxPackages_zen.kernel;
  linuxPackages_lqx = linuxKernel.packages.linux_lqx;
  linux_lqx = linuxPackages_lqx.kernel;

  # XanMod kernel
  linuxPackages_xanmod = linuxKernel.packages.linux_xanmod;
  linux_xanmod = linuxKernel.kernels.linux_xanmod;
  linuxPackages_xanmod_stable = linuxKernel.packages.linux_xanmod_stable;
  linux_xanmod_stable = linuxKernel.kernels.linux_xanmod_stable;
  linuxPackages_xanmod_latest = linuxKernel.packages.linux_xanmod_latest;
  linux_xanmod_latest = linuxKernel.kernels.linux_xanmod_latest;

  linux-doc = callPackage ../os-specific/linux/kernel/htmldocs.nix { };

  cryptodev = linuxPackages.cryptodev;

  librealsense = callPackage ../development/libraries/librealsense { };

  librealsenseWithCuda = callPackage ../development/libraries/librealsense {
    cudaSupport = true;
    # librealsenseWithCuda doesn't build on gcc11. CUDA 11.3 is the last version
    # to use pre-gcc11, in particular gcc9.
    stdenv = gcc9Stdenv;
  };

  librealsenseWithoutCuda = callPackage ../development/libraries/librealsense {
    cudaSupport = false;
  };

  librealsense-gui = callPackage ../development/libraries/librealsense {
    enableGUI = true;
  };

  kmod = callPackage ../os-specific/linux/kmod { };

  lvm2 = callPackage ../os-specific/linux/lvm2/2_03.nix {
    # break the cyclic dependency:
    # util-linux (non-minimal) depends (optionally, but on by default) on systemd,
    # systemd (optionally, but on by default) on cryptsetup and cryptsetup depends on lvm2
    util-linux = util-linuxMinimal;
  };

  lvm2_dmeventd = lvm2.override {
    enableDmeventd = true;
    enableCmdlib = true;
  };
  lvm2_vdo = lvm2_dmeventd.override {
    enableVDO = true;
  };

  mdadm = mdadm4;
  minimal-bootstrap = recurseIntoAttrs (
    import ../os-specific/linux/minimal-bootstrap {
      inherit (stdenv) buildPlatform hostPlatform;
      inherit lib config;
      fetchurl = import ../build-support/fetchurl/boot.nix {
        inherit (stdenv.buildPlatform) system;
      };
      checkMeta = callPackage ../stdenv/generic/check-meta.nix { inherit (stdenv) hostPlatform; };
    }
  );
  minimal-bootstrap-sources =
    callPackage ../os-specific/linux/minimal-bootstrap/stage0-posix/bootstrap-sources.nix
      {
        inherit (stdenv) hostPlatform;
      };
  make-minimal-bootstrap-sources =
    callPackage ../os-specific/linux/minimal-bootstrap/stage0-posix/make-bootstrap-sources.nix
      {
        inherit (stdenv) hostPlatform;
      };

  aggregateModules =
    modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit (buildPackages) kmod;
      inherit modules;
    };

  nushell = callPackage ../shells/nushell { };

  nushellPlugins = recurseIntoAttrs (
    callPackage ../shells/nushell/plugins {
    }
  );

  nettools =
    if stdenv.hostPlatform.isLinux then
      callPackage ../os-specific/linux/net-tools { }
    else
      unixtools.nettools;

  nftables = callPackage ../os-specific/linux/nftables { };

  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  odin = callPackage ../by-name/od/odin/package.nix {
    llvmPackages = llvmPackages_18;
  };

  pam =
    if stdenv.hostPlatform.isLinux then
      linux-pam
    else if stdenv.hostPlatform.isFreeBSD then
      freebsd.libpam
    else
      openpam;

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  procps =
    if stdenv.hostPlatform.isLinux then
      callPackage ../os-specific/linux/procps-ng { }
    else
      unixtools.procps;

  qemu_kvm = lowPrio (qemu.override { hostCpuOnly = true; });
  qemu_full = lowPrio (
    qemu.override {
      smbdSupport = lib.meta.availableOn stdenv.hostPlatform samba;
      cephSupport = lib.meta.availableOn stdenv.hostPlatform ceph;
      glusterfsSupport =
        lib.meta.availableOn stdenv.hostPlatform glusterfs
        && lib.meta.availableOn stdenv.hostPlatform libuuid;
    }
  );

  qemu_test = lowPrio (
    qemu.override {
      hostCpuOnly = true;
      nixosTestRunner = true;
    }
  );

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi { };
  raspberrypi-armstubs = callPackage ../os-specific/linux/firmware/raspberrypi/armstubs.nix { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  sass = callPackage ../development/tools/sass { };

  sddm-astronaut = qt6Packages.callPackage ../data/themes/sddm-astronaut { };

  sddm-chili-theme = libsForQt5.callPackage ../data/themes/chili-sddm { };

  sddm-sugar-dark = libsForQt5.callPackage ../data/themes/sddm-sugar-dark { };

  sdrangel = qt6Packages.callPackage ../applications/radio/sdrangel { };

  sgx-sdk = callPackage ../os-specific/linux/sgx/sdk { };

  sgx-psw = callPackage ../os-specific/linux/sgx/psw {
    protobuf = protobuf_21;
  };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # sysdig is a client, for a driver look at linuxPackagesFor

  sysprof = callPackage ../development/tools/profiling/sysprof { };

  libsysprof-capture = callPackage ../development/tools/profiling/sysprof/capture.nix { };

  systemd = callPackage ../os-specific/linux/systemd {
    # break some cyclic dependencies
    util-linux = util-linuxMinimal;
    # provide a super minimal gnupg used for systemd-machined
    gnupg = gnupg.override {
      enableMinimal = true;
      guiSupport = false;
    };
  };
  systemdMinimal = systemd.override {
    pname = "systemd-minimal";
    withAcl = false;
    withAnalyze = false;
    withApparmor = false;
    withAudit = false;
    withCompression = false;
    withCoredump = false;
    withCryptsetup = false;
    withRepart = false;
    withDocumentation = false;
    withEfi = false;
    withFido2 = false;
    withGcrypt = false;
    withHostnamed = false;
    withHomed = false;
    withHwdb = false;
    withImportd = false;
    withIptables = false;
    withLibBPF = false;
    withLibidn2 = false;
    withLocaled = false;
    withLogind = false;
    withMachined = false;
    withNetworkd = false;
    withNss = false;
    withOomd = false;
    withOpenSSL = false;
    withPCRE2 = false;
    withPam = false;
    withPolkit = false;
    withPortabled = false;
    withRemote = false;
    withResolved = false;
    withShellCompletions = false;
    withSysupdate = false;
    withSysusers = false;
    withTimedated = false;
    withTimesyncd = false;
    withTpm2Tss = false;
    withUserDb = false;
    withUkify = false;
    withBootloader = false;
    withPasswordQuality = false;
    withVmspawn = false;
    withQrencode = false;
    withLibarchive = false;
  };
  systemdLibs = systemdMinimal.override {
    pname = "systemd-minimal-libs";
    buildLibsOnly = true;
  };
  # We do not want to include ukify in the normal systemd attribute as it
  # relies on Python at runtime.
  systemdUkify = systemd.override {
    withUkify = true;
  };

  udev = if lib.meta.availableOn stdenv.hostPlatform systemdLibs then systemdLibs else libudev-zero;

  sysvtools = sysvinit.override {
    withoutInitTools = true;
  };

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot { })
    buildUBoot
    ubootTools
    ubootA20OlinuxinoLime
    ubootA20OlinuxinoLime2EMMC
    ubootBananaPi
    ubootBananaPim3
    ubootBananaPim64
    ubootAmx335xEVM
    ubootClearfog
    ubootCM3588NAS
    ubootCubieboard2
    ubootGuruplug
    ubootJetsonTK1
    ubootLibreTechCC
    ubootNanoPCT4
    ubootNanoPCT6
    ubootNovena
    ubootOdroidC2
    ubootOdroidXU3
    ubootOlimexA64Olinuxino
    ubootOlimexA64Teres1
    ubootOrangePi3
    ubootOrangePi3B
    ubootOrangePi5
    ubootOrangePi5Plus
    ubootOrangePiPc
    ubootOrangePiZeroPlus2H5
    ubootOrangePiZero
    ubootOrangePiZero2
    ubootOrangePiZero3
    ubootPcduino3Nano
    ubootPine64
    ubootPine64LTS
    ubootPinebook
    ubootPinebookPro
    ubootQemuAarch64
    ubootQemuArm
    ubootQemuRiscv64Smode
    ubootQemuX86
    ubootQemuX86_64
    ubootQuartz64B
    ubootRadxaZero3W
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootRaspberryPi4_32bit
    ubootRaspberryPi4_64bit
    ubootRaspberryPiZero
    ubootRock4CPlus
    ubootRock5ModelB
    ubootRock64
    ubootRock64v2
    ubootRockPiE
    ubootRockPi4
    ubootRockPro64
    ubootROCPCRK3399
    ubootSheevaplug
    ubootSopine
    ubootTuringRK1
    ubootUtilite
    ubootVisionFive2
    ubootWandboard
    ;

  eudev = callPackage ../by-name/eu/eudev/package.nix {
    util-linux = util-linuxMinimal;
  };

  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks2;

  usbrelay = callPackage ../os-specific/linux/usbrelay { };
  usbrelayd = callPackage ../os-specific/linux/usbrelay/daemon.nix { };

  util-linuxMinimal = util-linux.override {
    fetchurl = stdenv.fetchurlBoot;
    cryptsetupSupport = false;
    nlsSupport = false;
    ncursesSupport = false;
    pamSupport = false;
    shadowSupport = false;
    systemdSupport = false;
    translateManpages = false;
  };

  v4l-utils = qt5.callPackage ../os-specific/linux/v4l-utils { };

  windows = callPackages ../os-specific/windows { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = libsForQt5.callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  inherit
    ({
      zfs_2_2 = callPackage ../os-specific/linux/zfs/2_2.nix {
        configFile = "user";
      };
      zfs_2_3 = callPackage ../os-specific/linux/zfs/2_3.nix {
        configFile = "user";
      };
      zfs_unstable = callPackage ../os-specific/linux/zfs/unstable.nix {
        configFile = "user";
      };
    })
    zfs_2_2
    zfs_2_3
    zfs_unstable
    ;
  zfs = zfs_2_3;

  ### DATA

  adwaita-qt = libsForQt5.callPackage ../data/themes/adwaita-qt { };

  adwaita-qt6 = qt6Packages.callPackage ../data/themes/adwaita-qt {
    useQt6 = true;
  };

  androguard = with python3.pkgs; toPythonApplication androguard;

  andromeda-gtk-theme = libsForQt5.callPackage ../data/themes/andromeda-gtk-theme { };

  ant-theme = callPackage ../data/themes/ant-theme/ant.nix { };

  ant-bloody-theme = callPackage ../data/themes/ant-theme/ant-bloody.nix { };

  ant-nebula-theme = callPackage ../data/themes/ant-theme/ant-nebula.nix { };

  bibata-cursors-translucent = callPackage ../data/icons/bibata-cursors/translucent.nix { };

  breath-theme = libsForQt5.callPackage ../data/themes/breath-theme { };

  cnspec = callPackage ../tools/security/cnspec {
    buildGoModule = buildGo123Module;
  };

  colloid-kde = libsForQt5.callPackage ../data/themes/colloid-kde { };

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts { });

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = dejavu_fonts.name;
    paths = [ dejavu_fonts.out ];
  };

  docbook_sgml_dtd_31 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/3.1.nix { };

  docbook_sgml_dtd_41 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/4.1.nix { };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_44 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.4.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  inherit (callPackages ../data/sgml+xml/stylesheets/xslt/docbook-xsl { })
    docbook-xsl-nons
    docbook-xsl-ns
    ;

  # TODO: move this to aliases
  docbook_xsl = docbook-xsl-nons;
  docbook_xsl_ns = docbook-xsl-ns;

  documentation-highlighter = callPackage ../misc/documentation-highlighter { };

  epapirus-icon-theme = papirus-icon-theme.override { withElementary = true; };

  moeli = eduli;

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
  };

  flat-remix-icon-theme = callPackage ../data/icons/flat-remix-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };
  font-awesome_4 = (callPackage ../data/fonts/font-awesome { }).v4;
  font-awesome_5 = (callPackage ../data/fonts/font-awesome { }).v5;
  font-awesome_6 = (callPackage ../data/fonts/font-awesome { }).v6;
  font-awesome = font-awesome_6;

  graphite-kde-theme = libsForQt5.callPackage ../data/themes/graphite-kde-theme { };

  palenight-theme = callPackage ../data/themes/gtk-theme-framework { theme = "palenight"; };

  amarena-theme = callPackage ../data/themes/gtk-theme-framework { theme = "amarena"; };

  gruvterial-theme = callPackage ../data/themes/gtk-theme-framework { theme = "gruvterial"; };

  oceanic-theme = callPackage ../data/themes/gtk-theme-framework { theme = "oceanic"; };

  spacx-gtk-theme = callPackage ../data/themes/gtk-theme-framework { theme = "spacx"; };

  inherit
    ({
      gruppled-black-cursors = callPackage ../data/icons/gruppled-cursors { theme = "gruppled_black"; };
      gruppled-black-lite-cursors = callPackage ../data/icons/gruppled-lite-cursors {
        theme = "gruppled_black_lite";
      };
      gruppled-white-cursors = callPackage ../data/icons/gruppled-cursors { theme = "gruppled_white"; };
      gruppled-white-lite-cursors = callPackage ../data/icons/gruppled-lite-cursors {
        theme = "gruppled_white_lite";
      };
    })
    gruppled-black-cursors
    gruppled-black-lite-cursors
    gruppled-white-cursors
    gruppled-white-lite-cursors
    ;

  gruvbox-dark-icons-gtk = callPackage ../data/icons/gruvbox-dark-icons-gtk {
    inherit (plasma5Packages) breeze-icons;
  };

  iosevka-comfy = recurseIntoAttrs (callPackages ../data/fonts/iosevka/comfy.nix { });

  kde-rounded-corners =
    kdePackages.callPackage ../data/themes/kwin-decorations/kde-rounded-corners
      { };

  kora-icon-theme = callPackage ../data/icons/kora-icon-theme {
    inherit (libsForQt5.kdeFrameworks) breeze-icons;
  };

  la-capitaine-icon-theme = callPackage ../data/icons/la-capitaine-icon-theme {
    inherit (plasma5Packages) breeze-icons;
    inherit (pantheon) elementary-icon-theme;
  };

  layan-kde = libsForQt5.callPackage ../data/themes/layan-kde { };

  inherit (callPackages ../data/fonts/liberation-fonts { })
    liberation_ttf_v1
    liberation_ttf_v2
    ;
  liberation_ttf = liberation_ttf_v2;

  lightly-qt = libsForQt5.callPackage ../data/themes/lightly-qt { };

  lightly-boehs = libsForQt5.callPackage ../data/themes/lightly-boehs { };

  # ltunifi and solaar both provide udev rules but solaar's rules are more
  # up-to-date so we simply use that instead of having to maintain our own rules
  logitech-udev-rules = solaar.udev;

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs (callPackages ../data/fonts/lohit-fonts { });

  maia-icon-theme = libsForQt5.callPackage ../data/icons/maia-icon-theme { };

  marwaita-icons = callPackage ../by-name/ma/marwaita-icons/package.nix {
    inherit (kdePackages) breeze-icons;
  };

  material-kwin-decoration = libsForQt5.callPackage ../data/themes/material-kwin-decoration { };

  mplus-outline-fonts = recurseIntoAttrs (callPackage ../data/fonts/mplus-outline-fonts { });

  nordic = libsForQt5.callPackage ../data/themes/nordic { };

  noto-fonts-lgc-plus = callPackage ../by-name/no/noto-fonts/package.nix {
    suffix = "-lgc-plus";
    variants = [
      "Noto Sans"
      "Noto Serif"
      "Noto Sans Mono"
      "Noto Music"
      "Noto Sans Symbols"
      "Noto Sans Symbols 2"
      "Noto Sans Math"
    ];
    longDescription = ''
      This package provides the Noto Fonts, but only for latin, greek
      and cyrillic scripts, as well as some extra fonts.
    '';
  };

  nullmailer = callPackage ../servers/mail/nullmailer {
    stdenv = gccStdenv;
  };

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  openmoji-color = callPackage ../data/fonts/openmoji { fontFormats = [ "glyf_colr_0" ]; };

  openmoji-black = callPackage ../data/fonts/openmoji { fontFormats = [ "glyf" ]; };

  papirus-icon-theme = callPackage ../data/icons/papirus-icon-theme {
    inherit (pantheon) elementary-icon-theme;
    inherit (plasma5Packages) breeze-icons;
  };

  papirus-maia-icon-theme = callPackage ../data/icons/papirus-maia-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  papis = with python3Packages; toPythonApplication papis;

  plata-theme = callPackage ../data/themes/plata {
    inherit (mate) marco;
  };

  polychromatic = qt6Packages.callPackage ../applications/misc/polychromatic { };

  qogir-kde = libsForQt5.callPackage ../data/themes/qogir-kde { };

  ricochet-refresh = callPackage ../by-name/ri/ricochet-refresh/package.nix {
    protobuf = protobuf_21; # https://github.com/blueprint-freespeech/ricochet-refresh/issues/178
  };

  roapi-http = callPackage ../servers/roapi/http.nix { };

  shaderc = callPackage ../development/compilers/shaderc {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  sierra-breeze-enhanced =
    libsForQt5.callPackage ../data/themes/kwin-decorations/sierra-breeze-enhanced
      { useQt5 = true; };

  scheherazade-new = scheherazade.override {
    version = "4.300";
  };

  inherit (callPackages ../data/fonts/gdouros { })
    aegan
    aegyptus
    akkadian
    assyrian
    eemusic
    maya
    symbola
    textfonts
    unidings
    ;

  inherit (callPackages ../data/fonts/pretendard { })
    pretendard
    pretendard-gov
    pretendard-jp
    pretendard-std
    ;

  sourceHanPackages = dontRecurseIntoAttrs (callPackage ../data/fonts/source-han { });
  source-han-sans = sourceHanPackages.sans;
  source-han-serif = sourceHanPackages.serif;
  source-han-mono = sourceHanPackages.mono;
  source-han-sans-vf-otf = sourceHanPackages.sans-vf-otf;
  source-han-sans-vf-ttf = sourceHanPackages.sans-vf-ttf;
  source-han-serif-vf-otf = sourceHanPackages.serif-vf-otf;
  source-han-serif-vf-ttf = sourceHanPackages.serif-vf-ttf;

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = res.gtk2;
  };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) { };

  tela-circle-icon-theme = callPackage ../data/icons/tela-circle-icon-theme {
    inherit (libsForQt5) breeze-icons;
  };

  tex-gyre = callPackages ../data/fonts/tex-gyre { };

  tex-gyre-math = callPackages ../data/fonts/tex-gyre-math { };

  utterly-nord-plasma = kdePackages.callPackage ../data/themes/utterly-nord-plasma {
    # renamed in KF6
    plasma-framework = kdePackages.libplasma;
  };

  whitesur-kde = kdePackages.callPackage ../data/themes/whitesur-kde { };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = with python3Packages; toPythonApplication xlsx2csv;

  zafiro-icons = callPackage ../data/icons/zafiro-icons {
    inherit (plasma5Packages) breeze-icons;
  };

  ### APPLICATIONS / GIS

  qgis-ltr = callPackage ../applications/gis/qgis/ltr.nix { };

  qgis = callPackage ../applications/gis/qgis { };

  qmapshack = libsForQt5.callPackage ../applications/gis/qmapshack { };

  spatialite-gui = callPackage ../by-name/sp/spatialite-gui/package.nix {
    wxGTK = wxGTK32;
  };

  zombietrackergps = libsForQt5.callPackage ../applications/gis/zombietrackergps { };

  ### APPLICATIONS

  _2bwm = callPackage ../applications/window-managers/2bwm {
    patches = config."2bwm".patches or [ ];
  };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python3Packages)
      buildPythonApplication
      appdirs
      colorama
      python-dateutil
      requests
      requests-toolbelt
      setuptools
      sqlalchemy
      fusepy
      ;
  };

  inherit (qt6Packages.callPackage ../applications/office/activitywatch { })
    aw-qt
    aw-notify
    aw-server-rust
    aw-watcher-afk
    aw-watcher-window
    ;

  activitywatch = callPackage ../applications/office/activitywatch/wrapper.nix { };

  adobe-reader = pkgsi686Linux.callPackage ../applications/misc/adobe-reader { };

  anilibria-winmaclinux = libsForQt5.callPackage ../applications/video/anilibria-winmaclinux { };

  masterpdfeditor4 = libsForQt5.callPackage ../applications/misc/masterpdfeditor4 { };

  inherit
    ({
      pdfstudio2021 = callPackage ../applications/misc/pdfstudio { year = "2021"; };
      pdfstudio2022 = callPackage ../applications/misc/pdfstudio { year = "2022"; };
      pdfstudio2023 = callPackage ../applications/misc/pdfstudio { year = "2023"; };
      pdfstudio2024 = callPackage ../applications/misc/pdfstudio { year = "2024"; };
      pdfstudioviewer = callPackage ../applications/misc/pdfstudio { program = "pdfstudioviewer"; };
    })
    pdfstudio2021
    pdfstudio2022
    pdfstudio2023
    pdfstudio2024
    pdfstudioviewer
    ;

  airwave = libsForQt5.callPackage ../applications/audio/airwave { };

  amarok = libsForQt5.callPackage ../applications/audio/amarok { };
  amarok-kf5 = amarok; # for compatibility

  androidStudioPackages = recurseIntoAttrs (callPackage ../applications/editors/android-studio { });
  android-studio = androidStudioPackages.stable;
  android-studio-full = android-studio.full;

  androidStudioForPlatformPackages = recurseIntoAttrs (
    callPackage ../applications/editors/android-studio-for-platform { }
  );
  android-studio-for-platform = androidStudioForPlatformPackages.stable;

  antimony = libsForQt5.callPackage ../applications/graphics/antimony { };

  apngasm = callPackage ../applications/graphics/apngasm { };
  apngasm_2 = callPackage ../applications/graphics/apngasm/2.nix { };

  ardour = callPackage ../applications/audio/ardour { };
  ardour_7 = callPackage ../applications/audio/ardour/7.nix { };

  arelle = with python3Packages; toPythonApplication arelle;

  astroid = callPackage ../applications/networking/mailreaders/astroid {
    vim = vim-full.override { features = "normal"; };
    protobuf = protobuf_21;
  };

  audacious = audacious-bare.override { withPlugins = true; };

  av-98 = callPackage ../applications/networking/browsers/av-98 { };

  bambootracker-qt6 = bambootracker.override { withQt6 = true; };

  ausweisapp = qt6Packages.callPackage ../applications/misc/ausweisapp { };

  awesome = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    inherit (texFunctions) fontsConf;
  };

  awesomebump = libsForQt5.callPackage ../applications/graphics/awesomebump { };

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt = qt6.callPackage ../applications/networking/sync/backintime/qt.nix { };

  backintime = backintime-qt;

  barrier = libsForQt5.callPackage ../applications/misc/barrier { };

  bespokesynth-with-vst2 = bespokesynth.override {
    enableVST2 = true;
  };

  bfcal = libsForQt5.callPackage ../applications/misc/bfcal { };

  bino3d = qt6Packages.callPackage ../applications/video/bino3d { };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitscope = recurseIntoAttrs (
    callPackage ../applications/science/electronics/bitscope/packages.nix { }
  );

  bitwig-studio3 = callPackage ../applications/audio/bitwig-studio/bitwig-studio3.nix { };
  bitwig-studio4 = callPackage ../applications/audio/bitwig-studio/bitwig-studio4.nix {
    libjpeg = libjpeg8;
  };
  bitwig-studio5-unwrapped = callPackage ../applications/audio/bitwig-studio/bitwig-studio5.nix {
    libjpeg = libjpeg8;
  };

  bitwig-studio5 = callPackage ../applications/audio/bitwig-studio/bitwig-wrapper.nix {
    bitwig-studio-unwrapped = bitwig-studio5-unwrapped;
  };

  bitwig-studio = bitwig-studio5;

  blackbox = callPackage ../applications/version-management/blackbox {
    pinentry = pinentry-curses;
  };

  blender = callPackage ../by-name/bl/blender/package.nix {
    python3Packages = python311Packages;
  };

  blender-hip = blender.override { hipSupport = true; };

  blucontrol = callPackage ../applications/misc/blucontrol/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
  };

  breezy = with python3Packages; toPythonApplication breezy;

  calcmysky = qt6Packages.callPackage ../applications/science/astronomy/calcmysky { };

  calibre = callPackage ../by-name/ca/calibre/package.nix {
    podofo = podofo010;
  };

  # calico-felix and calico-node have not been packaged due to libbpf, linking issues
  inherit (callPackage ../applications/networking/cluster/calico { })
    calico-apiserver
    calico-app-policy
    calico-cni-plugin
    calico-kube-controllers
    calico-pod2daemon
    calico-typha
    calicoctl
    confd-calico
    ;

  carla = libsForQt5.callPackage ../applications/audio/carla { };

  cb2bib = libsForQt5.callPackage ../applications/office/cb2bib { };

  cbconvert-gui = cbconvert.gui;

  cdparanoia = cdparanoiaIII;

  brotab = callPackage ../tools/misc/brotab { };

  bumblebee-status = callPackage ../applications/window-managers/i3/bumblebee-status { };

  chromium = callPackage ../applications/networking/browsers/chromium (config.chromium or { });

  chuck = callPackage ../applications/audio/chuck {
    inherit (darwin) DarwinTools;
  };

  clight = callPackage ../applications/misc/clight { };

  clight-gui = libsForQt5.callPackage ../applications/misc/clight/clight-gui.nix { };

  clightd = callPackage ../applications/misc/clight/clightd.nix { };

  clipgrab = libsForQt5.callPackage ../applications/video/clipgrab { };

  cmus = callPackage ../applications/audio/cmus {
    libjack = libjack2;
  };

  cni = callPackage ../applications/networking/cluster/cni { };
  cni-plugins = callPackage ../applications/networking/cluster/cni/plugins.nix { };

  communi = libsForQt5.callPackage ../applications/networking/irc/communi { };

  confclerk = libsForQt5.callPackage ../applications/misc/confclerk { };

  copyq = qt6Packages.callPackage ../applications/misc/copyq { };

  cpeditor = libsForQt5.callPackage ../applications/editors/cpeditor { };

  csound = callPackage ../applications/audio/csound { };

  csound-qt = libsForQt5.callPackage ../applications/audio/csound/csound-qt { };

  codeblocksFull = codeblocks.override { contribPlugins = true; };

  cudatext-qt = callPackage ../applications/editors/cudatext { widgetset = "qt5"; };
  cudatext-gtk = callPackage ../applications/editors/cudatext { widgetset = "gtk2"; };
  cudatext = cudatext-qt;

  cqrlog = callPackage ../applications/radio/cqrlog {
    hamlib = hamlib_4;
  };

  cutecom = libsForQt5.callPackage ../tools/misc/cutecom { };

  darcs = haskell.lib.compose.disableCabalFlag "library" (
    haskell.lib.compose.justStaticExecutables haskellPackages.darcs
  );

  darktable = callPackage ../by-name/da/darktable/package.nix {
    lua = lua5_4;
    pugixml = pugixml.override { shared = true; };
  };

  datadog-agent = callPackage ../tools/networking/dd-agent/datadog-agent.nix {
    pythonPackages = datadog-integrations-core { };
  };
  datadog-process-agent = callPackage ../tools/networking/dd-agent/datadog-process-agent.nix { };
  datadog-integrations-core =
    extras:
    callPackage ../tools/networking/dd-agent/integrations-core.nix {
      extraIntegrations = extras;
    };

  deadbeef = callPackage ../applications/audio/deadbeef { };

  deadbeefPlugins = {
    headerbar-gtk3 = callPackage ../applications/audio/deadbeef/plugins/headerbar-gtk3.nix { };
    lyricbar = callPackage ../applications/audio/deadbeef/plugins/lyricbar.nix { };
    mpris2 = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };
    musical-spectrum = callPackage ../applications/audio/deadbeef/plugins/musical-spectrum.nix { };
    statusnotifier = callPackage ../applications/audio/deadbeef/plugins/statusnotifier.nix { };
    playlist-manager = callPackage ../applications/audio/deadbeef/plugins/playlist-manager.nix { };
  };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [ ];
  };

  inherit (callPackage ../development/tools/devpod { }) devpod devpod-desktop;

  dfasma = libsForQt5.callPackage ../applications/audio/dfasma { };

  direwolf = callPackage ../applications/radio/direwolf {
    hamlib = hamlib_4;
  };

  djv = callPackage ../by-name/dj/djv/package.nix { openexr = openexr_2; };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = djview;

  dmenu = callPackage ../applications/misc/dmenu { };
  dmenu-wayland = callPackage ../applications/misc/dmenu/wayland.nix { };

  dmenu-rs-enable-plugins = dmenu-rs.override { enablePlugins = true; };

  dmensamenu = callPackage ../applications/misc/dmensamenu {
    inherit (python3Packages) buildPythonApplication requests;
  };

  inherit (callPackage ../applications/virtualization/docker { })
    docker_25
    docker_26
    docker_27
    docker_28
    ;

  docker = docker_27;
  docker-client = docker.override { clientOnly = true; };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };
  docker-machine-hyperkit =
    callPackage ../applications/networking/cluster/docker-machine/hyperkit.nix
      { };
  docker-machine-kvm2 = callPackage ../applications/networking/cluster/docker-machine/kvm2.nix { };

  docker-buildx = callPackage ../applications/virtualization/docker/buildx.nix { };
  docker-compose = callPackage ../applications/virtualization/docker/compose.nix { };
  docker-sbom = callPackage ../applications/virtualization/docker/sbom.nix { };

  drawio = callPackage ../applications/graphics/drawio {
    inherit (darwin) autoSignDarwinBinariesHook;
  };
  drawio-headless = callPackage ../applications/graphics/drawio/headless.nix { };

  drawpile = callPackage ../applications/graphics/drawpile { };
  drawpile-server-headless = drawpile.override {
    buildClient = false;
    buildServerGui = false;
  };

  drawterm-wayland = callPackage ../by-name/dr/drawterm/package.nix { withWayland = true; };

  droopy = python3Packages.callPackage ../applications/networking/droopy { };

  dwl = callPackage ../by-name/dw/dwl/package.nix {
    wlroots = wlroots_0_18;
  };

  dwm = callPackage ../applications/window-managers/dwm {
    # dwm is configured entirely through source modification. Allow users to
    # specify patches through nixpkgs.config.dwm.patches
    patches = config.dwm.patches or [ ];
  };

  dwm-status = callPackage ../applications/window-managers/dwm/dwm-status.nix { };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [ ];
  };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  electrum = libsForQt5.callPackage ../applications/misc/electrum { };

  electrum-grs = libsForQt5.callPackage ../applications/misc/electrum/grs.nix { };

  electrum-ltc = libsForQt5.callPackage ../applications/misc/electrum/ltc.nix { };

  elf-dissector = libsForQt5.callPackage ../applications/misc/elf-dissector { };

  elinks = callPackage ../applications/networking/browsers/elinks {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  inherit (recurseIntoAttrs (callPackage ../applications/editors/emacs { }))
    emacs30
    emacs30-gtk3
    emacs30-nox
    emacs30-pgtk

    emacs29-macport
    ;

  emacs-macport = emacs29-macport;
  emacs = emacs30;
  emacs-gtk = emacs30-gtk3;
  emacs-nox = emacs30-nox;
  emacs-pgtk = emacs30-pgtk;

  emacsPackagesFor =
    emacs:
    import ./emacs-packages.nix {
      inherit (lib) makeScope makeOverridable dontRecurseIntoAttrs;
      emacs' = emacs;
      pkgs' = pkgs; # default pkgs used for bootstrapping the emacs package set
    };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak-ng = callPackage ../applications/audio/espeak-ng { };
  espeak = res.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  evilpixie = callPackage ../applications/graphics/evilpixie { };

  greenfoot = callPackage ../applications/editors/greenfoot {
    openjdk = openjdk21.override {
      enableJavaFX = true;
      openjfx_jdk = openjfx21.override { withWebKit = true; };
    };
  };

  haruna = kdePackages.callPackage ../applications/video/haruna { };

  hdrmerge = callPackage ../applications/graphics/hdrmerge { };

  input-leap = qt6Packages.callPackage ../applications/misc/input-leap {
    avahi = avahi.override { withLibdnssdCompat = true; };
  };

  evolution-data-server-gtk4 = evolution-data-server.override {
    withGtk3 = false;
    withGtk4 = true;
  };
  evolution = callPackage ../applications/networking/mailreaders/evolution/evolution { };
  evolutionWithPlugins =
    callPackage ../applications/networking/mailreaders/evolution/evolution/wrapper.nix
      {
        plugins = [
          evolution
          evolution-ews
        ];
      };

  fetchmail = callPackage ../applications/misc/fetchmail { };
  fetchmail_7 = callPackage ../applications/misc/fetchmail/v7.nix { };

  firewalld-gui = firewalld.override { withGui = true; };

  flacon = libsForQt5.callPackage ../applications/audio/flacon { };

  fldigi = callPackage ../applications/radio/fldigi {
    hamlib = hamlib_4;
  };

  fmit = libsForQt5.callPackage ../applications/audio/fmit { };

  focuswriter = qt6Packages.callPackage ../applications/editors/focuswriter { };

  fossil = callPackage ../applications/version-management/fossil {
    sqlite = sqlite.override { enableDeserialize = true; };
  };

  fritzing = qt6Packages.callPackage ../applications/science/electronics/fritzing { };

  fvwm = fvwm2;

  ganttproject-bin = callPackage ../applications/misc/ganttproject-bin {
    jre = openjdk17.override {
      enableJavaFX = true;
    };
  };

  gaucheBootstrap = callPackage ../development/interpreters/gauche/boot.nix { };

  gauche = callPackage ../development/interpreters/gauche { };

  gazelle-origin = python3Packages.callPackage ../tools/misc/gazelle-origin { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  gnuradio = callPackage ../applications/radio/gnuradio/wrapper.nix {
    unwrapped = callPackage ../applications/radio/gnuradio {
      python = python311;
    };
  };
  gnuradioPackages = lib.recurseIntoAttrs gnuradio.pkgs;

  greetd = recurseIntoAttrs (
    {
      greetd = callPackage ../applications/display-managers/greetd { };
      gtkgreet = callPackage ../applications/display-managers/greetd/gtkgreet.nix { };
      qtgreet = callPackage ../applications/display-managers/greetd/qtgreet.nix { };
      regreet = callPackage ../applications/display-managers/greetd/regreet.nix { };
      tuigreet = callPackage ../applications/display-managers/greetd/tuigreet.nix { };
      wlgreet = callPackage ../applications/display-managers/greetd/wlgreet.nix { };
    }
    // lib.optionalAttrs config.allowAliases {
      dlm = throw "greetd.dlm has been removed as it is broken and abandoned upstream"; # Added 2024-07-15
    }
  );

  goldendict = libsForQt5.callPackage ../applications/misc/goldendict { };
  goldendict-ng = qt6Packages.callPackage ../applications/misc/goldendict-ng { };

  inherit (ocamlPackages) google-drive-ocamlfuse;

  gqrx = qt6Packages.callPackage ../applications/radio/gqrx { };
  gqrx-portaudio = qt6Packages.callPackage ../applications/radio/gqrx {
    portaudioSupport = true;
    pulseaudioSupport = false;
  };
  gqrx-gr-audio = qt6Packages.callPackage ../applications/radio/gqrx {
    portaudioSupport = false;
    pulseaudioSupport = false;
  };

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  puddletag = libsForQt5.callPackage ../applications/audio/puddletag { };

  welle-io = qt6Packages.callPackage ../applications/radio/welle-io { };

  wireshark = qt6Packages.callPackage ../applications/networking/sniffers/wireshark {
    libpcap = libpcap.override { withBluez = stdenv.hostPlatform.isLinux; };
  };
  wireshark-qt = wireshark;

  qtwirediff = qt6Packages.callPackage ../applications/networking/sniffers/qtwirediff { };

  tshark = wireshark-cli;
  wireshark-cli = wireshark.override {
    withQt = false;
    libpcap = libpcap.override { withBluez = stdenv.hostPlatform.isLinux; };
  };

  fclones = callPackage ../tools/misc/fclones { };

  fclones-gui = callPackage ../tools/misc/fclones/gui.nix { };

  feh = callPackage ../applications/graphics/feh {
    imlib2 = imlib2Full;
  };

  buildMozillaMach =
    opts: callPackage (import ../build-support/build-mozilla-mach/default.nix opts) { };

  firefox-unwrapped = import ../applications/networking/browsers/firefox/packages/firefox.nix {
    inherit
      stdenv
      lib
      callPackage
      fetchurl
      nixosTests
      buildMozillaMach
      ;
  };
  firefox-beta-unwrapped =
    import ../applications/networking/browsers/firefox/packages/firefox-beta.nix
      {
        inherit
          stdenv
          lib
          callPackage
          fetchurl
          nixosTests
          buildMozillaMach
          ;
      };
  firefox-devedition-unwrapped =
    import ../applications/networking/browsers/firefox/packages/firefox-devedition.nix
      {
        inherit
          stdenv
          lib
          callPackage
          fetchurl
          nixosTests
          buildMozillaMach
          ;
      };
  firefox-esr-140-unwrapped =
    import ../applications/networking/browsers/firefox/packages/firefox-esr-140.nix
      {
        inherit
          stdenv
          lib
          callPackage
          fetchurl
          nixosTests
          buildMozillaMach
          ;
      };
  firefox-esr-unwrapped = firefox-esr-140-unwrapped;

  firefox = wrapFirefox firefox-unwrapped { };
  firefox-beta = wrapFirefox firefox-beta-unwrapped { };
  firefox-devedition = wrapFirefox firefox-devedition-unwrapped { };

  firefox-mobile = callPackage ../applications/networking/browsers/firefox/mobile-config.nix { };

  firefox-esr-140 = wrapFirefox firefox-esr-140-unwrapped {
    nameSuffix = "-esr";
    wmClass = "firefox-esr";
    icon = "firefox-esr";
  };
  firefox-esr = firefox-esr-140;

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    inherit (firefox-unwrapped.passthru) applicationName;
    generated = import ../applications/networking/browsers/firefox-bin/release_sources.nix;
  };

  firefox-bin = wrapFirefox firefox-bin-unwrapped {
    pname = "firefox-bin";
  };

  librewolf-unwrapped = import ../applications/networking/browsers/librewolf {
    inherit
      stdenv
      lib
      callPackage
      buildMozillaMach
      nixosTests
      ;
  };

  librewolf = wrapFirefox librewolf-unwrapped {
    inherit (librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
    libName = "librewolf";
  };

  librewolf-bin = wrapFirefox librewolf-bin-unwrapped {
    pname = "librewolf-bin";
    extraPrefsFiles = [
      "${librewolf-bin-unwrapped}/lib/librewolf-bin-${librewolf-bin-unwrapped.version}/librewolf.cfg"
    ];
    extraPoliciesFiles = [
      "${librewolf-bin-unwrapped}/lib/librewolf-bin-${librewolf-bin-unwrapped.version}/distribution/extra-policies.json"
    ];
  };

  firefox_decrypt = python3Packages.callPackage ../tools/security/firefox_decrypt { };

  floorp-unwrapped = import ../applications/networking/browsers/floorp {
    inherit
      stdenv
      lib
      fetchFromGitHub
      buildMozillaMach
      nixosTests
      ;
  };

  floorp = wrapFirefox floorp-unwrapped { };

  formiko =
    with python3Packages;
    callPackage ../applications/editors/formiko {
      inherit buildPythonApplication;
    };

  freedv = callPackage ../by-name/fr/freedv/package.nix {
    codec2 = codec2.override {
      freedvSupport = true;
    };
  };

  freemind = callPackage ../applications/misc/freemind {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  inherit
    ({
      freeoffice = callPackage ../applications/office/softmaker/freeoffice.nix { };
    })
    freeoffice
    ;

  inherit (xorg) xlsfonts;

  gimp3 = callPackage ../applications/graphics/gimp {
    lcms = lcms2;
  };

  gimp3-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    gimpPlugins = gimp3Plugins;
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimp3Plugins = recurseIntoAttrs (
    callPackage ../applications/graphics/gimp/plugins {
      gimp = gimp3;
    }
  );

  gimp = callPackage ../applications/graphics/gimp/2.0 {
    autoreconfHook = buildPackages.autoreconfHook269;
    lcms = lcms2;
  };

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins { });

  gtk-pipe-viewer = perlPackages.callPackage ../applications/video/pipe-viewer { withGtk3 = true; };

  kemai = qt6Packages.callPackage ../applications/misc/kemai { };

  jetbrains = (
    recurseIntoAttrs (
      callPackages ../applications/editors/jetbrains {
        vmopts = config.jetbrains.vmopts or null;
        jdk = jetbrains.jdk;
      }
    )
    // {
      jdk-no-jcef = callPackage ../development/compilers/jetbrains-jdk {
        jdk = jdk21;
        withJcef = false;
      };
      jdk-no-jcef-17 = callPackage ../development/compilers/jetbrains-jdk/17.nix {
        withJcef = false;
      };
      jdk = callPackage ../development/compilers/jetbrains-jdk {
        jdk = jdk21;
      };
      jcef = callPackage ../development/compilers/jetbrains-jdk/jcef.nix {
        jdk = jdk21;
      };
    }
  );

  librespot = callPackage ../applications/audio/librespot {
    withALSA = stdenv.hostPlatform.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.hostPlatform.isLinux;
    withPortAudio = stdenv.hostPlatform.isDarwin;
  };

  linssid = libsForQt5.callPackage ../applications/networking/linssid { };

  linvstmanager = qt5.callPackage ../applications/audio/linvstmanager { };

  deadd-notification-center = haskell.lib.compose.justStaticExecutables (
    haskellPackages.callPackage ../applications/misc/deadd-notification-center { }
  );

  m32edit = callPackage ../applications/audio/midas/m32edit.nix { };

  manim = python3Packages.toPythonApplication python3Packages.manim;

  manim-slides = python3Packages.toPythonApplication (
    python3Packages.manim-slides.override {
      withGui = true;
    }
  );

  manuskript = libsForQt5.callPackage ../applications/editors/manuskript {
    python3Packages = python311Packages;
  };

  minari = python3Packages.toPythonApplication python3Packages.minari;

  mindforger = libsForQt5.callPackage ../applications/editors/mindforger { };

  molsketch = libsForQt5.callPackage ../applications/editors/molsketch { };

  pattypan = callPackage ../applications/misc/pattypan {
    jdk = jdk.override { enableJavaFX = true; };
  };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet-gtk = callPackage ../applications/networking/p2p/gnunet/gtk.nix { };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = callPackage ../applications/misc/gphoto2/gphotofs.nix { };

  graphicsmagick_q16 = graphicsmagick.override { quantumdepth = 16; };
  graphicsmagick-imagemagick-compat = graphicsmagick.imagemagick-compat;

  q4wine = libsForQt5.callPackage ../applications/misc/q4wine { };

  googleearth-pro = libsForQt5.callPackage ../applications/misc/googleearth-pro { };

  gpsbabel = libsForQt5.callPackage ../applications/misc/gpsbabel { };

  gpsbabel-gui = gpsbabel.override {
    withGUI = true;
    withDoc = true;
  };

  gpu-screen-recorder = callPackage ../applications/video/gpu-screen-recorder { };

  gpu-screen-recorder-gtk =
    callPackage ../applications/video/gpu-screen-recorder/gpu-screen-recorder-gtk.nix
      { };

  gpxsee-qt5 = libsForQt5.callPackage ../applications/misc/gpxsee { };

  gpxsee-qt6 = qt6Packages.callPackage ../applications/misc/gpxsee { };

  gpxsee = gpxsee-qt5;

  guvcview = libsForQt5.callPackage ../os-specific/linux/guvcview { };

  hachoir = with python3Packages; toPythonApplication hachoir;

  heimer = libsForQt5.callPackage ../applications/misc/heimer { };

  hydrogen-web-unwrapped =
    callPackage ../applications/networking/instant-messengers/hydrogen-web/unwrapped.nix
      { };

  hydrogen-web = callPackage ../applications/networking/instant-messengers/hydrogen-web/wrapper.nix {
    conf = config.hydrogen-web.conf or { };
  };

  hledger = haskell.lib.compose.justStaticExecutables haskellPackages.hledger;
  hledger-iadd = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-iadd;
  hledger-interest = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-interest;
  hledger-ui = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-ui;
  hledger-web =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.hledger-web;
  hledger-utils = with python3.pkgs; toPythonApplication hledger-utils;

  hollywood = callPackage ../applications/misc/hollywood {
    inherit (python3Packages) pygments;
  };

  hovercraft = python3Packages.callPackage ../applications/misc/hovercraft { };

  hpack = haskell.lib.compose.justStaticExecutables haskellPackages.hpack;

  hpmyroom = libsForQt5.callPackage ../applications/networking/hpmyroom { };

  hue-cli = callPackage ../tools/networking/hue-cli { };

  hugin = callPackage ../applications/graphics/hugin {
    wxGTK = wxGTK32;
  };

  huggle = libsForQt5.callPackage ../applications/misc/huggle { };

  hushboard = python3.pkgs.callPackage ../applications/audio/hushboard { };

  hydrogen = qt5.callPackage ../applications/audio/hydrogen { };

  hyperion-ng = libsForQt5.callPackage ../applications/video/hyperion-ng { };

  jackline = callPackage ../applications/networking/instant-messengers/jackline {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  meerk40t = callPackage ../applications/misc/meerk40t { };

  meerk40t-camera = callPackage ../applications/misc/meerk40t/camera.nix { };

  libmt32emu = callPackage ../applications/audio/munt/libmt32emu.nix { };

  mt32emu-qt = libsForQt5.callPackage ../applications/audio/munt/mt32emu-qt.nix { };

  mt32emu-smf2wav = callPackage ../applications/audio/munt/mt32emu-smf2wav.nix { };

  noson = libsForQt5.callPackage ../applications/audio/noson { };

  pass2csv = python3Packages.callPackage ../tools/security/pass2csv { };

  pinboard = with python3Packages; toPythonApplication pinboard;

  pinboard-notes-backup = haskell.lib.compose.justStaticExecutables haskellPackages.pinboard-notes-backup;

  pixel2svg = python310Packages.callPackage ../tools/graphics/pixel2svg { };

  pixinsight = callPackage ../applications/graphics/pixinsight { };

  inherit (callPackage ../applications/virtualization/singularity/packages.nix { })
    apptainer
    singularity
    apptainer-overriden-nixos
    singularity-overriden-nixos
    ;

  inherit (callPackages ../development/libraries/wlroots { })
    wlroots_0_17
    wlroots_0_18
    wlroots_0_19
    ;

  sway-contrib = recurseIntoAttrs (callPackages ../applications/misc/sway-contrib { });

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.hostPlatform.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-auto-layout = callPackage ../applications/window-managers/i3/auto-layout.nix { };

  i3-rounded = callPackage ../applications/window-managers/i3/rounded.nix { };

  i3altlayout = callPackage ../applications/window-managers/i3/altlayout.nix { };

  i3-balance-workspace =
    python3Packages.callPackage ../applications/window-managers/i3/balance-workspace.nix
      { };

  i3-cycle-focus = callPackage ../applications/window-managers/i3/cycle-focus.nix { };

  i3-easyfocus = callPackage ../applications/window-managers/i3/easyfocus.nix { };

  i3-layout-manager = callPackage ../applications/window-managers/i3/layout-manager.nix { };

  i3-ratiosplit = callPackage ../applications/window-managers/i3/i3-ratiosplit.nix { };

  i3-resurrect = python3Packages.callPackage ../applications/window-managers/i3/i3-resurrect.nix { };

  i3-swallow = python3Packages.callPackage ../applications/window-managers/i3/swallow.nix { };

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3blocks-gaps = callPackage ../applications/window-managers/i3/blocks-gaps.nix { };

  i3ipc-glib = callPackage ../applications/window-managers/i3/i3ipc-glib.nix { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  i3lock-blur = callPackage ../applications/window-managers/i3/lock-blur.nix { };

  i3lock-color = callPackage ../applications/window-managers/i3/lock-color.nix { };

  i3lock-fancy = callPackage ../applications/window-managers/i3/lock-fancy.nix { };

  i3lock-fancy-rapid = callPackage ../applications/window-managers/i3/lock-fancy-rapid.nix { };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i3status-rust = callPackage ../applications/window-managers/i3/status-rust.nix { };

  i3wsr = callPackage ../applications/window-managers/i3/wsr.nix { };

  i3-wk-switch = callPackage ../applications/window-managers/i3/wk-switch.nix { };

  kitti3 = python3.pkgs.callPackage ../applications/window-managers/i3/kitti3.nix { };

  waybox = callPackage ../by-name/wa/waybox/package.nix {
    wlroots = wlroots_0_17;
  };

  workstyle = callPackage ../applications/window-managers/i3/workstyle.nix { };

  wmfocus = callPackage ../applications/window-managers/i3/wmfocus.nix { };

  ii = callPackage ../applications/networking/irc/ii {
    stdenv = gccStdenv;
  };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit
      (perlPackages.override {
        pkgs = pkgs // {
          imagemagick = imagemagickBig;
        };
      })
      ImageMagick
      ;
  };

  ikiwiki-full = ikiwiki.override {
    bazaarSupport = false; # tests broken
    cvsSupport = true;
    docutilsSupport = true;
    gitSupport = true;
    mercurialSupport = true;
    monotoneSupport = true;
    subversionSupport = true;
  };

  iksemel = callPackage ../development/libraries/iksemel {
    texinfo = buildPackages.texinfo6_7; # Uses @setcontentsaftertitlepage, removed in 6.8.
  };

  avalonia-ilspy = callPackage ../applications/misc/avalonia-ilspy {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  imagemagick6_light = imagemagick6.override {
    bzip2Support = false;
    zlibSupport = false;
    libX11Support = false;
    libXtSupport = false;
    fontconfigSupport = false;
    freetypeSupport = false;
    ghostscriptSupport = false;
    libjpegSupport = false;
    djvulibreSupport = false;
    lcms2Support = false;
    openexrSupport = false;
    libpngSupport = false;
    liblqr1Support = false;
    librsvgSupport = false;
    libtiffSupport = false;
    libxml2Support = false;
    openjpegSupport = false;
    libwebpSupport = false;
    libheifSupport = false;
    libde265Support = false;
  };

  imagemagick6 = callPackage ../applications/graphics/ImageMagick/6.x.nix { };

  imagemagick6Big = imagemagick6.override {
    ghostscriptSupport = true;
  };

  imagemagick_light = lowPrio (
    imagemagick.override {
      bzip2Support = false;
      zlibSupport = false;
      libX11Support = false;
      libXtSupport = false;
      fontconfigSupport = false;
      freetypeSupport = false;
      libraqmSupport = false;
      libjpegSupport = false;
      djvulibreSupport = false;
      lcms2Support = false;
      openexrSupport = false;
      libjxlSupport = false;
      libpngSupport = false;
      liblqr1Support = false;
      librsvgSupport = false;
      libtiffSupport = false;
      libxml2Support = false;
      openjpegSupport = false;
      libwebpSupport = false;
      libheifSupport = false;
    }
  );

  imagemagick = lowPrio (
    callPackage ../applications/graphics/ImageMagick {
    }
  );

  imagemagickBig = lowPrio (
    imagemagick.override {
      ghostscriptSupport = true;
    }
  );

  inherit (nodePackages) imapnotify;

  img2pdf = with python3Packages; toPythonApplication img2pdf;

  imgp = callPackage ../applications/graphics/imgp { };

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
  };

  inkscape-with-extensions = callPackage ../applications/graphics/inkscape/with-extensions.nix { };

  inkscape-extensions = recurseIntoAttrs (
    callPackages ../applications/graphics/inkscape/extensions.nix { }
  );

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = qt6Packages.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    lua5 = lua5_3;
  };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  jabcode = callPackage ../development/libraries/jabcode { };

  jabcode-writer = callPackage ../development/libraries/jabcode {
    subproject = "writer";
  };

  jabcode-reader = callPackage ../development/libraries/jabcode {
    subproject = "reader";
  };

  jabref = callPackage ../applications/office/jabref {
    jdk = jdk21.override {
      enableJavaFX = true;
      openjfx_jdk = openjfx23;
    };
  };

  jackmix = libsForQt5.callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jalv-qt = jalv.override { useQt = true; };

  js8call = qt5.callPackage ../applications/radio/js8call { };

  jwm = callPackage ../applications/window-managers/jwm { };

  jwm-settings-manager = callPackage ../applications/window-managers/jwm/jwm-settings-manager.nix { };

  inherit (callPackage ../applications/networking/cluster/k3s { })
    k3s_1_30
    k3s_1_31
    k3s_1_32
    k3s_1_33
    ;
  k3s = k3s_1_32;

  kapow = libsForQt5.callPackage ../applications/misc/kapow { };

  kchmviewer = libsForQt5.callPackage ../applications/misc/kchmviewer { };

  okteta = libsForQt5.callPackage ../applications/editors/okteta { };

  k4dirstat = libsForQt5.callPackage ../applications/misc/k4dirstat { };

  kbibtex = libsForQt5.callPackage ../applications/office/kbibtex { };

  kaidan = kdePackages.callPackage ../applications/networking/instant-messengers/kaidan { };

  kexi = libsForQt5.callPackage ../applications/office/kexi { };

  kgraphviewer = callPackage ../applications/graphics/kgraphviewer { };

  kid3-cli = kid3.override {
    withCLI = true;
    withKDE = false;
    withQt = false;
  };
  kid3-kde = kid3.override {
    withCLI = true;
    withKDE = true;
    withQt = false;
  };
  kid3-qt = kid3.override {
    withCLI = true;
    withKDE = false;
    withQt = true;
  };

  kiwix = libsForQt5.callPackage ../applications/misc/kiwix { };

  kiwix-tools = callPackage ../applications/misc/kiwix/tools.nix { };

  klayout = libsForQt5.callPackage ../applications/misc/klayout { };

  klee = callPackage ../applications/science/logic/klee {
    llvmPackages = llvmPackages_13;
  };

  kmetronome = qt6Packages.callPackage ../applications/audio/kmetronome { };

  kmplayer = libsForQt5.callPackage ../applications/video/kmplayer { };

  kmymoney = libsForQt5.callPackage ../applications/office/kmymoney { };

  kotatogram-desktop =
    callPackage ../applications/networking/instant-messengers/telegram/kotatogram-desktop
      { };

  krane = callPackage ../applications/networking/cluster/krane { };

  krita = callPackage ../applications/graphics/krita/wrapper.nix { };

  ktimetracker = libsForQt5.callPackage ../applications/office/ktimetracker { };

  kubeval = callPackage ../applications/networking/cluster/kubeval { };

  kubeval-schema = callPackage ../applications/networking/cluster/kubeval/schema.nix { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes { };
  kubectl = callPackage ../applications/networking/cluster/kubernetes/kubectl.nix { };
  kubectl-convert = kubectl.convert;

  kubectl-view-allocations =
    callPackage ../applications/networking/cluster/kubectl-view-allocations
      { };

  kubelogin-oidc = callPackage ../by-name/ku/kubelogin-oidc/package.nix {
    buildGoModule = buildGo124Module;
  };

  kthxbye = callPackage ../servers/monitoring/prometheus/kthxbye.nix { };

  linkerd = callPackage ../applications/networking/cluster/linkerd { };
  linkerd_edge = callPackage ../applications/networking/cluster/linkerd/edge.nix { };
  linkerd_stable = linkerd;

  kuma = callPackage ../applications/networking/cluster/kuma { isFull = true; };
  kuma-experimental = callPackage ../applications/networking/cluster/kuma {
    isFull = true;
    enableGateway = true;
    pname = "kuma-experimental";
  };
  kumactl = callPackage ../applications/networking/cluster/kuma {
    components = [ "kumactl" ];
    pname = "kumactl";
  };
  kuma-cp = callPackage ../applications/networking/cluster/kuma {
    components = [ "kuma-cp" ];
    pname = "kuma-cp";
  };
  kuma-dp = callPackage ../applications/networking/cluster/kuma {
    components = [ "kuma-dp" ];
    pname = "kuma-dp";
  };

  kubernetes-helm = callPackage ../applications/networking/cluster/helm { };

  wrapHelm = callPackage ../applications/networking/cluster/helm/wrapper.nix { };

  kubernetes-helm-wrapped = wrapHelm kubernetes-helm { };

  kubernetes-helmPlugins = recurseIntoAttrs (
    callPackage ../applications/networking/cluster/helm/plugins { }
  );

  kup = libsForQt5.callPackage ../applications/misc/kup { };

  timoni = callPackage ../applications/networking/cluster/timoni { };

  kvirc = libsForQt5.callPackage ../applications/networking/irc/kvirc { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  lenovo-legion = libsForQt5.callPackage ../os-specific/linux/lenovo-legion/app.nix { };

  leo-editor = libsForQt5.callPackage ../applications/editors/leo-editor { };

  libkiwix = callPackage ../applications/misc/kiwix/lib.nix { };

  libreoffice-bin = callPackage ../applications/office/libreoffice/darwin { };

  libreoffice = hiPrio libreoffice-still;
  libreoffice-unwrapped = libreoffice.unwrapped;

  libreoffice-qt = hiPrio libreoffice-qt-still;
  libreoffice-qt-unwrapped = libreoffice-qt.unwrapped;

  libreoffice-qt-fresh = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = libsForQt5.callPackage ../applications/office/libreoffice {
        kdeIntegration = true;
        variant = "fresh";
      };
    }
  );
  libreoffice-qt-fresh-unwrapped = libreoffice-qt-fresh.unwrapped;

  libreoffice-qt-still = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = libsForQt5.callPackage ../applications/office/libreoffice {
        kdeIntegration = true;
        variant = "still";
      };
    }
  );
  libreoffice-qt-still-unwrapped = libreoffice-qt-still.unwrapped;

  libreoffice-qt6 = hiPrio libreoffice-qt6-still;
  libreoffice-qt6-unwrapped = libreoffice-qt6.unwrapped;

  libreoffice-qt6-fresh = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = kdePackages.callPackage ../applications/office/libreoffice {
        kdeIntegration = true;
        variant = "fresh";
      };
    }
  );
  libreoffice-qt6-fresh-unwrapped = libreoffice-qt6-fresh.unwrapped;

  libreoffice-qt6-still = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = kdePackages.callPackage ../applications/office/libreoffice {
        kdeIntegration = true;
        variant = "still";
      };
    }
  );
  libreoffice-qt6-still-unwrapped = libreoffice-qt-still.unwrapped;

  libreoffice-fresh = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = callPackage ../applications/office/libreoffice {
        variant = "fresh";
      };
    }
  );
  libreoffice-fresh-unwrapped = libreoffice-fresh.unwrapped;

  libreoffice-still = lowPrio (
    callPackage ../applications/office/libreoffice/wrapper.nix {
      unwrapped = callPackage ../applications/office/libreoffice {
        variant = "still";
      };
    }
  );
  libreoffice-still-unwrapped = libreoffice-still.unwrapped;

  libreoffice-collabora = callPackage ../applications/office/libreoffice {
    variant = "collabora";
    withFonts = true;
  };

  libutp = callPackage ../applications/networking/p2p/libutp { };
  libutp_3_4 = callPackage ../applications/networking/p2p/libutp/3.4.nix { };

  ledger-web = callPackage ../applications/office/ledger-web { };

  linphone = libsForQt5.callPackage ../applications/networking/instant-messengers/linphone { };

  lmms = libsForQt5.callPackage ../applications/audio/lmms {
    lame = null;
    libsoundio = null;
    portaudio = null;
  };

  luminanceHDR = callPackage ../applications/graphics/luminance-hdr {
    openexr = openexr_2;
  };

  luddite = with python3Packages; toPythonApplication luddite;

  lutris-unwrapped = python3.pkgs.callPackage ../applications/misc/lutris {
    inherit (pkgs) meson;
  };
  lutris = callPackage ../applications/misc/lutris/fhsenv.nix { };
  lutris-free = lutris.override {
    steamSupport = false;
  };

  lv2lint = callPackage ../applications/audio/lv2lint/default.nix { };

  lxi-tools = callPackage ../tools/networking/lxi-tools { };
  lxi-tools-gui = callPackage ../tools/networking/lxi-tools { withGui = true; };

  lyx = libsForQt5.callPackage ../applications/misc/lyx { };

  magic-wormhole = with python3Packages; toPythonApplication magic-wormhole;

  magnetophonDSP = lib.recurseIntoAttrs {
    CharacterCompressor = callPackage ../applications/audio/magnetophonDSP/CharacterCompressor { };
    CompBus = callPackage ../applications/audio/magnetophonDSP/CompBus { };
    ConstantDetuneChorus = callPackage ../applications/audio/magnetophonDSP/ConstantDetuneChorus { };
    faustCompressors = callPackage ../applications/audio/magnetophonDSP/faustCompressors { };
    LazyLimiter = callPackage ../applications/audio/magnetophonDSP/LazyLimiter { };
    MBdistortion = callPackage ../applications/audio/magnetophonDSP/MBdistortion { };
    pluginUtils = callPackage ../applications/audio/magnetophonDSP/pluginUtils { };
    RhythmDelay = callPackage ../applications/audio/magnetophonDSP/RhythmDelay { };
    VoiceOfFaust = callPackage ../applications/audio/magnetophonDSP/VoiceOfFaust { };
    shelfMultiBand = callPackage ../applications/audio/magnetophonDSP/shelfMultiBand { };
  };

  mandelbulber = callPackage ../applications/graphics/mandelbulber { };

  mastodon-bot = nodePackages.mastodon-bot;

  matrix-commander =
    python3Packages.callPackage ../applications/networking/instant-messengers/matrix-commander
      { };

  mbrola = callPackage ../applications/audio/mbrola { };

  mbrola-voices = callPackage ../applications/audio/mbrola/voices.nix { };

  mediaelch = mediaelch-qt5;
  mediaelch-qt5 = libsForQt5.callPackage ../applications/misc/mediaelch { };
  mediaelch-qt6 = qt6Packages.callPackage ../applications/misc/mediaelch { };

  melmatcheq.lv2 = callPackage ../applications/audio/melmatcheq.lv2 { };

  mendeley = libsForQt5.callPackage ../applications/office/mendeley {
    gconf = gnome2.GConf;
  };

  mercurialFull = mercurial.override { fullBuild = true; };

  meshcentral = callPackage ../tools/admin/meshcentral { };

  meshlab = callPackage ../applications/graphics/meshlab { };
  meshlab-unstable = callPackage ../applications/graphics/meshlab-unstable { };

  michabo = libsForQt5.callPackage ../applications/misc/michabo { };

  miniaudicle = qt6Packages.callPackage ../applications/audio/miniaudicle { };

  minitube = libsForQt5.callPackage ../applications/video/minitube { };

  mixxx = qt6Packages.callPackage ../applications/audio/mixxx { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  mmlgui = callPackage ../applications/audio/mmlgui {
    libvgm = libvgm.override {
      withAllEmulators = false;
      emulators = [
        "_PRESET_SMD"
      ];
      enableLibplayer = false;
    };
  };

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  monotoneViz = callPackage ../applications/version-management/monotone-viz {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14_unsafe_string;
  };

  monitor = callPackage ../applications/system/monitor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  moolticute = libsForQt5.callPackage ../applications/misc/moolticute { };

  mopidyPackages =
    (callPackages ../applications/audio/mopidy {
      python = python3;
    })
    // {
      __attrsFailEvaluation = true;
    };

  inherit (mopidyPackages)
    mopidy
    mopidy-bandcamp
    mopidy-iris
    mopidy-jellyfin
    mopidy-local
    mopidy-moped
    mopidy-mopify
    mopidy-mpd
    mopidy-mpris
    mopidy-muse
    mopidy-musicbox-webclient
    mopidy-notify
    mopidy-podcast
    mopidy-scrobbler
    mopidy-somafm
    mopidy-soundcloud
    mopidy-spotify
    mopidy-subidy
    mopidy-tidal
    mopidy-tunein
    mopidy-youtube
    mopidy-ytmusic
    ;

  mpg123 = callPackage ../applications/audio/mpg123 {
    jack = libjack2;
  };

  libmpg123 = mpg123.override {
    libOnly = true;
    withConplay = false;
  };

  pragha = libsForQt5.callPackage ../applications/audio/pragha { };

  rofi-emoji = (callPackage ../applications/misc/rofi-emoji { }).v3;
  rofi-emoji-wayland =
    (callPackage ../applications/misc/rofi-emoji {
      rofi-unwrapped = rofi-wayland-unwrapped;
    }).v4;

  rofi-rbw = python3Packages.callPackage ../applications/misc/rofi-rbw {
    waylandSupport = false;
    x11Support = false;
  };

  rofi-rbw-wayland = python3Packages.callPackage ../applications/misc/rofi-rbw {
    waylandSupport = true;
  };

  rofi-rbw-x11 = python3Packages.callPackage ../applications/misc/rofi-rbw {
    x11Support = true;
  };

  rquickshare-legacy = rquickshare.override { app-type = "legacy"; };

  seamly2d = callPackage ../applications/graphics/seamly2d { };

  # a somewhat more maintained fork of ympd
  memento = qt6Packages.callPackage ../applications/video/memento { };

  mpc-qt = qt6Packages.callPackage ../applications/video/mpc-qt { };

  mplayer = callPackage ../applications/video/mplayer (
    {
      libdvdnav = libdvdnav_4_2_1;
    }
    // (config.mplayer or { })
  );

  mpv-unwrapped = callPackage ../applications/video/mpv {
    stdenv = if stdenv.hostPlatform.isDarwin then swiftPackages.stdenv else stdenv;
  };

  # Wrap avoiding rebuild
  mpv = mpv-unwrapped.wrapper { mpv = mpv-unwrapped; };

  mpvScripts = mpv-unwrapped.scripts;

  mu-repo = python3Packages.callPackage ../applications/misc/mu-repo { };

  murmur =
    (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }).murmur;

  mumble =
    (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
    }).mumble;

  mumble_overlay = (callPackages ../applications/networking/mumble { }).overlay;

  mup = callPackage ../applications/audio/mup {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  musescore = qt6.callPackage ../applications/audio/musescore { };

  mwic = callPackage ../applications/misc/mwic {
    pythonPackages = python3Packages;
  };

  natron = libsForQt5.callPackage ../applications/video/natron { };

  netmaker = callPackage ../applications/networking/netmaker { subPackages = [ "." ]; };
  netmaker-full = callPackage ../applications/networking/netmaker { };

  ninja_1_11 = callPackage ../by-name/ni/ninja/package.nix { ninjaRelease = "1.11"; };

  nootka = qt5.callPackage ../applications/audio/nootka { };

  opcua-client-gui = libsForQt5.callPackage ../misc/opcua-client-gui { };

  ostinato = libsForQt5.callPackage ../applications/networking/ostinato {
    protobuf = protobuf_21;
  };

  p4v = qt6Packages.callPackage ../applications/version-management/p4v { };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pdfmixtool = libsForQt5.callPackage ../applications/office/pdfmixtool { };

  pijuice = with python3Packages; toPythonApplication pijuice;

  pinegrow6 = callPackage ../applications/editors/pinegrow { pinegrowVersion = "6"; };

  pinegrow = callPackage ../applications/editors/pinegrow { };

  pipe-viewer = perlPackages.callPackage ../applications/video/pipe-viewer { };

  playonlinux = callPackage ../applications/misc/playonlinux { stdenv = stdenv_32bit; };

  pleroma-bot = python3Packages.callPackage ../development/python-modules/pleroma-bot { };

  pnglatex = with python3Packages; toPythonApplication pnglatex;

  polybarFull = polybar.override {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport = true;
    iwSupport = false;
    nlSupport = true;
    i3Support = true;
  };

  polyphone = qt6.callPackage ../applications/audio/polyphone { };

  scx = recurseIntoAttrs (callPackage ../os-specific/linux/scx { });

  shogun = callPackage ../applications/science/machine-learning/shogun {
    protobuf = protobuf_21;
  };

  smtube = libsForQt5.callPackage ../applications/video/smtube { };

  inherit
    ({
      softmaker-office = callPackage ../applications/office/softmaker/softmaker-office.nix { };
      softmaker-office-nx = callPackage ../applications/office/softmaker/softmaker-office-nx.nix { };
    })
    softmaker-office
    softmaker-office-nx
    ;

  taxi-cli = with python3Packages; toPythonApplication taxi;

  msmtp = callPackage ../applications/networking/msmtp {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
  };

  pdfsam-basic = callPackage ../applications/misc/pdfsam-basic {
    jdk21 = openjdk21.override { enableJavaFX = true; };
  };

  mupdf-headless = mupdf.override {
    enableX11 = false;
    enableGL = false;
  };

  diffpdf = libsForQt5.callPackage ../applications/misc/diffpdf { };

  diff-pdf = callPackage ../applications/misc/diff-pdf {
    wxGTK = wxGTK32;
  };

  mypaint-brushes1 = callPackage ../development/libraries/mypaint-brushes/1.0.nix { };

  mypaint-brushes = callPackage ../development/libraries/mypaint-brushes { };

  mythtv = libsForQt5.callPackage ../applications/video/mythtv { };

  ncdu_1 = callPackage ../by-name/nc/ncdu/1.nix { };

  notepadqq = libsForQt5.callPackage ../applications/editors/notepadqq { };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    pythonPackages = python3Packages;
  };

  notmuch-mutt = callPackage ../applications/networking/mailreaders/notmuch/mutt.nix { };

  muchsync = callPackage ../applications/networking/mailreaders/notmuch/muchsync.nix { };

  nufraw = callPackage ../applications/graphics/nufraw { };

  nufraw-thumbnailer = callPackage ../applications/graphics/nufraw {
    addThumbnailer = true;
  };

  obs-studio = qt6Packages.callPackage ../applications/video/obs-studio { };

  obs-studio-plugins = recurseIntoAttrs (callPackage ../applications/video/obs-studio/plugins { });
  wrapOBS = callPackage ../applications/video/obs-studio/wrapper.nix { };

  okms-cli = callPackage ../by-name/ok/okms-cli/package.nix {
    buildGoModule = buildGo123Module;
  };

  omegat = callPackage ../applications/misc/omegat.nix { };

  openambit = qt5.callPackage ../applications/misc/openambit { };

  openbox-menu = callPackage ../applications/misc/openbox-menu {
    stdenv = gccStdenv;
  };

  openbrf = libsForQt5.callPackage ../applications/misc/openbrf { };

  opencpn = callPackage ../applications/misc/opencpn {
    inherit (darwin) DarwinTools;
  };

  openimageio_2 = callPackage ../by-name/op/openimageio/2.nix { };

  open-music-kontrollers = lib.recurseIntoAttrs {
    eteroj = callPackage ../applications/audio/open-music-kontrollers/eteroj.nix { };
    jit = callPackage ../applications/audio/open-music-kontrollers/jit.nix { };
    mephisto = callPackage ../applications/audio/open-music-kontrollers/mephisto.nix { };
    midi_matrix = callPackage ../applications/audio/open-music-kontrollers/midi_matrix.nix { };
    moony = callPackage ../applications/audio/open-music-kontrollers/moony.nix { };
    orbit = callPackage ../applications/audio/open-music-kontrollers/orbit.nix { };
    patchmatrix = callPackage ../applications/audio/open-music-kontrollers/patchmatrix.nix { };
    router = callPackage ../applications/audio/open-music-kontrollers/router.nix { };
    sherlock = callPackage ../applications/audio/open-music-kontrollers/sherlock.nix { };
    synthpod = callPackage ../applications/audio/open-music-kontrollers/synthpod.nix { };
    vm = callPackage ../applications/audio/open-music-kontrollers/vm.nix { };
  };

  inherit (callPackages ../data/fonts/open-relay { })
    constructium
    fairfax
    fairfax-hd
    kreative-square
    ;

  openscad = callPackage ../applications/graphics/openscad { };

  opentoonz = callPackage ../applications/graphics/opentoonz { };

  opentx = libsForQt5.callPackage ../applications/misc/opentx { };

  organicmaps = qt6Packages.callPackage ../applications/misc/organicmaps { };

  openrazer-daemon = python3Packages.toPythonApplication python3Packages.openrazer-daemon;

  orpie = callPackage ../applications/misc/orpie {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  osmscout-server = libsForQt5.callPackage ../applications/misc/osmscout-server {
    protobuf = protobuf_21.override {
      abseil-cpp = abseil-cpp_202103.override {
        cxxStandard = "17";
      };
    };
  };

  palemoon-bin = callPackage ../applications/networking/browsers/palemoon/bin.nix { };
  palemoon-gtk2-bin = palemoon-bin.override { withGTK3 = false; };

  pantalaimon = callPackage ../applications/networking/instant-messengers/pantalaimon { };

  pantalaimon-headless = callPackage ../applications/networking/instant-messengers/pantalaimon {
    enableDbusUi = false;
  };

  parsec-bin = callPackage ../applications/misc/parsec/bin.nix { };

  paraview = libsForQt5.callPackage ../applications/graphics/paraview { };

  pekwm = callPackage ../by-name/pe/pekwm/package.nix {
    awk = gawk;
    grep = gnugrep;
    sed = gnused;
  };

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gst_all_1)
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-libav
      ;
  };

  peaclock = callPackage ../applications/misc/peaclock {
    stdenv = gccStdenv;
  };

  photoflare = callPackage ../applications/graphics/photoflare { };

  phototonic = callPackage ../applications/graphics/phototonic { };

  pianobooster = qt5.callPackage ../applications/audio/pianobooster { };

  pianoteq = callPackage ../applications/audio/pianoteq { };

  pidginPackages = recurseIntoAttrs (
    callPackage ../applications/networking/instant-messengers/pidgin/pidgin-plugins { }
  );

  inherit (pidginPackages) pidgin;

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python3Packages;
  };

  pineapple-pictures = qt6Packages.callPackage ../applications/graphics/pineapple-pictures { };

  plater = libsForQt5.callPackage ../applications/misc/plater { };

  plexamp = callPackage ../applications/audio/plexamp { };

  plex-media-player = libsForQt5.callPackage ../applications/video/plex-media-player { };

  plex-mpv-shim = python3Packages.callPackage ../applications/video/plex-mpv-shim { };

  plover = recurseIntoAttrs (libsForQt5.callPackage ../applications/misc/plover { });

  pokefinder = qt6Packages.callPackage ../tools/games/pokefinder { };

  pothos = libsForQt5.callPackage ../applications/radio/pothos { };

  qiv = callPackage ../applications/graphics/qiv {
    imlib2 = imlib2Full;
  };

  processing = callPackage ../applications/graphics/processing {
    jdk = jdk17;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  profanity = callPackage ../applications/networking/instant-messengers/profanity (
    {
    }
    // (config.profanity or { })
  );

  protonvpn-cli = python3Packages.callPackage ../applications/networking/protonvpn-cli { };
  protonvpn-cli_2 = python3Packages.callPackage ../applications/networking/protonvpn-cli/2.nix { };

  protonvpn-gui = python3Packages.callPackage ../applications/networking/protonvpn-gui { };

  psi = libsForQt5.callPackage ../applications/networking/instant-messengers/psi { };

  psi-plus = libsForQt5.callPackage ../applications/networking/instant-messengers/psi-plus { };

  pulseview = libsForQt5.callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins =
    plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  pure-maps = libsForQt5.callPackage ../applications/misc/pure-maps { };

  qbittorrent-nox = qbittorrent.override { guiSupport = false; };

  qbittorrent-enhanced-nox = qbittorrent-enhanced.override { guiSupport = false; };

  qcad = libsForQt5.callPackage ../applications/misc/qcad { };

  qcomicbook = callPackage ../applications/graphics/qcomicbook { };

  qctools = libsForQt5.callPackage ../applications/video/qctools { };

  qelectrotech = libsForQt5.callPackage ../applications/misc/qelectrotech { };

  eiskaltdcpp = libsForQt5.callPackage ../applications/networking/p2p/eiskaltdcpp { };

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin) sigtool;
  };

  qemu-python-utils = python3Packages.toPythonApplication (
    python3Packages.qemu.override {
      fuseSupport = true;
      tuiSupport = true;
    }
  );

  qemu-utils = qemu.override {
    toolsOnly = true;
  };

  # variant of qemu building user space emulator only - intended to be used from pkgsStatic
  qemu-user = qemu.override {
    userOnly = true;
  };

  canokey-qemu = callPackage ../applications/virtualization/qemu/canokey-qemu.nix { };

  wrapQemuBinfmtP = callPackage ../applications/virtualization/qemu/binfmt-p-wrapper.nix { };

  qjackctl = libsForQt5.callPackage ../applications/audio/qjackctl { };

  qimgv = callPackage ../applications/graphics/qimgv { };

  qmediathekview = libsForQt5.callPackage ../applications/video/qmediathekview { };

  qmplay2-qt5 = qmplay2.override { qtVersion = "5"; };
  qmplay2-qt6 = qmplay2.override { qtVersion = "6"; };

  qmidinet = libsForQt5.callPackage ../applications/audio/qmidinet { };

  qnotero = libsForQt5.callPackage ../applications/office/qnotero { };

  qpwgraph = qt6Packages.callPackage ../applications/audio/qpwgraph { };

  qsampler = libsForQt5.callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot { };

  qsstv = qt5.callPackage ../applications/radio/qsstv { };

  qsyncthingtray = libsForQt5.callPackage ../applications/misc/qsyncthingtray { };

  qsudo = libsForQt5.callPackage ../applications/misc/qsudo { };

  qsynth = libsForQt5.callPackage ../applications/audio/qsynth { };

  qtbitcointrader = libsForQt5.callPackage ../applications/misc/qtbitcointrader { };

  qtemu = libsForQt5.callPackage ../applications/virtualization/qtemu { };

  qtpass = libsForQt5.callPackage ../applications/misc/qtpass { };

  quassel = libsForQt5.callPackage ../applications/networking/irc/quassel { };

  quasselClient = quassel.override {
    monolithic = false;
    client = true;
    tag = "-client-kf5";
  };

  quasselDaemon = quassel.override {
    monolithic = false;
    enableDaemon = true;
    withKDE = false;
    tag = "-daemon-qt5";
  };

  quiterss = libsForQt5.callPackage ../applications/networking/newsreaders/quiterss { };

  quodlibet = callPackage ../applications/audio/quodlibet {
    kakasi = null;
    keybinder3 = null;
    libappindicator-gtk3 = null;
    libmodplug = null;
  };

  quodlibet-without-gst-plugins = quodlibet.override {
    tag = "-without-gst-plugins";
    withGstPlugins = false;
  };

  quodlibet-xine = quodlibet.override {
    tag = "-xine";
    withGstreamerBackend = false;
    withXineBackend = true;
  };

  quodlibet-full = quodlibet.override {
    inherit gtksourceview;
    kakasi = kakasi;
    keybinder3 = keybinder3;
    libappindicator-gtk3 = libappindicator-gtk3;
    libmodplug = libmodplug;
    tag = "-full";
    withDbusPython = true;
    withMusicBrainzNgs = true;
    withPahoMqtt = true;
    withPypresence = true;
    withSoco = true;
  };

  quodlibet-xine-full = quodlibet-full.override {
    tag = "-xine-full";
    withGstreamerBackend = false;
    withXineBackend = true;
  };

  qutebrowser-qt5 = qutebrowser.override {
    qt6Packages = libsForQt5;
  };

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  radiotray-ng = callPackage ../applications/audio/radiotray-ng {
    wxGTK = wxGTK32;
  };

  rapid-photo-downloader = callPackage ../applications/graphics/rapid-photo-downloader { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rclone = callPackage ../applications/networking/sync/rclone { };

  rclone-browser = libsForQt5.callPackage ../applications/networking/sync/rclone/browser.nix { };

  reaper = callPackage ../applications/audio/reaper {
    jackLibrary = libjack2; # Another option is "pipewire.jack".
    ffmpeg = ffmpeg_4-headless;
  };

  rednotebook = python3Packages.callPackage ../applications/editors/rednotebook { };

  restique = libsForQt5.callPackage ../applications/backup/restique { };

  retroshare = libsForQt5.callPackage ../applications/networking/p2p/retroshare { };

  rgp = libsForQt5.callPackage ../development/tools/rgp { };

  ripcord =
    if stdenv.hostPlatform.isLinux then
      qt5.callPackage ../applications/networking/instant-messengers/ripcord { }
    else
      callPackage ../applications/networking/instant-messengers/ripcord/darwin.nix { };

  inherit (callPackage ../applications/networking/cluster/rke2 { })
    rke2_1_29
    rke2_1_30
    rke2_1_31
    rke2_1_32
    rke2_stable
    rke2_latest
    ;
  rke2 = rke2_stable;

  rofi-unwrapped = callPackage ../applications/misc/rofi { };
  rofi = callPackage ../applications/misc/rofi/wrapper.nix { };
  rofi-wayland-unwrapped = callPackage ../applications/misc/rofi/wayland.nix { };
  rofi-wayland = callPackage ../applications/misc/rofi/wrapper.nix {
    rofi-unwrapped = rofi-wayland-unwrapped;
  };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };
  rofi-pass-wayland = callPackage ../tools/security/pass/rofi-pass.nix {
    backend = "wayland";
  };

  rstudio-server = rstudio.override { server = true; };

  rsync = callPackage ../applications/networking/sync/rsync (config.rsync or { });
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix { };

  inherit (callPackages ../applications/radio/rtl-sdr { })
    rtl-sdr-librtlsdr
    rtl-sdr-osmocom
    rtl-sdr-blog
    ;

  rtl-sdr = rtl-sdr-blog;

  rusty-psn-gui = rusty-psn.override { withGui = true; };

  sayonara = libsForQt5.callPackage ../applications/audio/sayonara { };

  scantailor-advanced = callPackage ../applications/graphics/scantailor/advanced.nix { };

  scantailor-universal = callPackage ../applications/graphics/scantailor/universal.nix { };

  scribus_1_5 = libsForQt5.callPackage ../applications/office/scribus/default.nix { };
  scribus = scribus_1_5;

  seafile-client = libsForQt5.callPackage ../applications/networking/seafile-client { };

  seq66 = qt5.callPackage ../applications/audio/seq66 { };

  sfxr-qt = libsForQt5.callPackage ../applications/audio/sfxr-qt { };

  sommelier = callPackage ../applications/window-managers/sommelier { };

  spotify-qt = qt6Packages.callPackage ../applications/audio/spotify-qt { };

  squishyball = callPackage ../applications/audio/squishyball {
    ncurses = ncurses5;
  };

  sonic-pi = libsForQt5.callPackage ../applications/audio/sonic-pi { };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  sweethome3d = recurseIntoAttrs (
    (callPackage ../applications/misc/sweethome3d { })
    // (callPackage ../applications/misc/sweethome3d/editors.nix {
      sweethome3dApp = sweethome3d.application;
    })
  );

  sxiv = callPackage ../applications/graphics/sxiv {
    imlib2 = imlib2Full;
  };

  nsxiv = callPackage ../by-name/ns/nsxiv/package.nix {
    imlib2 = imlib2Full;
  };

  dropbox = callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox/cli.nix { };

  maestral = with python3Packages; toPythonApplication maestral;

  maestral-gui = qt6Packages.callPackage ../applications/networking/maestral-qt { };

  myfitnesspal = with python3Packages; toPythonApplication myfitnesspal;

  libstrangle = callPackage ../tools/X11/libstrangle {
    stdenv = stdenv_32bit;
  };

  lightdm = libsForQt5.callPackage ../applications/display-managers/lightdm { };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm-gtk-greeter = callPackage ../applications/display-managers/lightdm/gtk-greeter.nix {
    inherit (xfce) xfce4-dev-tools;
  };

  curaengine_stable = callPackage ../applications/misc/curaengine/stable.nix { };

  curaengine = callPackage ../applications/misc/curaengine {
    inherit (python3.pkgs) libarcus;
    protobuf = protobuf_21;
  };

  cura = libsForQt5.callPackage ../applications/misc/cura { };

  curaPlugins = callPackage ../applications/misc/cura/plugins.nix { };

  prusa-slicer = callPackage ../applications/misc/prusa-slicer {
    # Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
    # on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
    # with --cores 32 on clang).
    stdenv = clangStdenv;
  };

  super-slicer = callPackage ../applications/misc/prusa-slicer/super-slicer.nix { };

  super-slicer-beta = super-slicer.beta;

  super-slicer-latest = super-slicer.latest;

  skrooge = libsForQt5.callPackage ../applications/office/skrooge { };

  smartdeblur = callPackage ../applications/graphics/smartdeblur { };

  soci = callPackage ../development/libraries/soci { };

  socialscan = with python3.pkgs; toPythonApplication socialscan;

  sonic-lineup = libsForQt5.callPackage ../applications/audio/sonic-lineup { };

  sonic-visualiser = libsForQt5.callPackage ../applications/audio/sonic-visualiser { };

  soulseekqt = libsForQt5.callPackage ../applications/networking/p2p/soulseekqt { };

  spek = callPackage ../applications/audio/spek {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  squeezelite-pulse = callPackage ../by-name/sq/squeezelite/package.nix {
    audioBackend = "pulse";
  };

  inherit (ocaml-ng.ocamlPackages) stog;

  # Stumpwm is broken on SBCL 2.4.11, see
  # https://github.com/NixOS/nixpkgs/pull/360320
  stumpwm = callPackage ../applications/window-managers/stumpwm {
    stdenv = stdenvNoCC;
    sbcl = sbcl_2_4_10.withPackages (
      ps: with ps; [
        alexandria
        cl-ppcre
        clx
        fiasco
      ]
    );
  };

  stumpwm-unwrapped = sbcl_2_4_10.pkgs.stumpwm;

  sublime3Packages = recurseIntoAttrs (
    callPackage ../applications/editors/sublime/3/packages.nix { }
  );

  sublime3 = sublime3Packages.sublime3;

  sublime3-dev = sublime3Packages.sublime3-dev;

  inherit (recurseIntoAttrs (callPackage ../applications/editors/sublime/4/packages.nix { }))
    sublime4
    sublime4-dev
    ;

  inherit (callPackage ../applications/version-management/sublime-merge { })
    sublime-merge
    sublime-merge-dev
    ;

  inherit
    (callPackages ../applications/version-management/subversion {
      sasl = cyrus_sasl;
    })
    subversion
    ;

  subversionClient = subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  };

  surge = callPackage ../applications/audio/surge {
    git = gitMinimal;
  };

  supersonic-wayland = supersonic.override {
    waylandSupport = true;
  };

  syncplay = python3.pkgs.callPackage ../applications/networking/syncplay { };

  syncplay-nogui = syncplay.override { enableGUI = false; };

  inherit
    (callPackages ../applications/networking/syncthing {
      inherit (darwin) autoSignDarwinBinariesHook;
    })
    syncthing
    syncthing-discovery
    syncthing-relay
    ;

  syncthingtray = kdePackages.callPackage ../applications/misc/syncthingtray {
    # renamed in KF5 -> KF6
    plasma-framework = kdePackages.libplasma;
  };
  syncthingtray-minimal = syncthingtray.override {
    webviewSupport = false;
    jsSupport = false;
    kioPluginSupport = false;
    plasmoidSupport = false;
    systemdSupport = true;
  };

  synergy = libsForQt5.callPackage ../applications/misc/synergy { };

  synergyWithoutGUI = synergy.override { withGUI = false; };

  tabbed = callPackage ../applications/window-managers/tabbed {
    # if you prefer a custom config, write the config.h in tabbed.config.h
    # and enable
    # customConfig = builtins.readFile ./tabbed.config.h;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages taffybar;
  };

  tagainijisho = libsForQt5.callPackage ../applications/office/tagainijisho { };

  tamgamp.lv2 = callPackage ../applications/audio/tamgamp.lv2 { };

  telegram-desktop =
    kdePackages.callPackage ../applications/networking/instant-messengers/telegram/telegram-desktop
      {
        stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_19.stdenv else stdenv;
      };

  tg = python3Packages.callPackage ../applications/networking/instant-messengers/telegram/tg { };

  termdown = python3Packages.callPackage ../applications/misc/termdown { };

  terminaltexteffects = with python3Packages; toPythonApplication terminaltexteffects;

  inherit
    (callPackage ../applications/graphics/tesseract {
    })
    tesseract3
    tesseract4
    tesseract5
    ;
  tesseract = tesseract5;

  thunderbirdPackages = recurseIntoAttrs (
    callPackage ../applications/networking/mailreaders/thunderbird/packages.nix {
      callPackage = newScope {
        inherit (rustPackages) cargo rustc;
      };
    }
  );

  thunderbird-unwrapped = thunderbirdPackages.thunderbird;
  thunderbird = wrapThunderbird thunderbird-unwrapped { };

  thunderbird-latest-unwrapped = thunderbirdPackages.thunderbird-latest;
  thunderbird-latest = wrapThunderbird thunderbird-latest-unwrapped { };

  thunderbird-esr-unwrapped = thunderbirdPackages.thunderbird-esr;
  thunderbird-esr = wrapThunderbird thunderbird-esr-unwrapped { };

  thunderbird-128-unwrapped = thunderbirdPackages.thunderbird-128;
  thunderbird-128 = wrapThunderbird thunderbirdPackages.thunderbird-128 { };

  thunderbird-140-unwrapped = thunderbirdPackages.thunderbird-140;
  thunderbird-140 = wrapThunderbird thunderbirdPackages.thunderbird-140 { };

  thunderbird-bin = thunderbird-latest-bin;
  thunderbird-latest-bin = wrapThunderbird thunderbird-latest-bin-unwrapped {
    pname = "thunderbird-bin";
  };
  thunderbird-latest-bin-unwrapped =
    callPackage ../applications/networking/mailreaders/thunderbird-bin
      {
        generated = import ../applications/networking/mailreaders/thunderbird-bin/release_sources.nix;
      };
  thunderbird-esr-bin = wrapThunderbird thunderbird-esr-bin-unwrapped {
    pname = "thunderbird-esr-bin";
  };
  thunderbird-esr-bin-unwrapped = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    generated = import ../applications/networking/mailreaders/thunderbird-bin/release_esr_sources.nix;
    versionSuffix = "esr";
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid {
    fftw = fftwSinglePrec;
  };

  inherit
    ({
      timeshift-unwrapped = callPackage ../applications/backup/timeshift/unwrapped.nix { };
      timeshift = callPackage ../applications/backup/timeshift { grubPackage = grub2; };
      timeshift-minimal = callPackage ../applications/backup/timeshift/minimal.nix { };
    })
    timeshift-unwrapped
    timeshift
    timeshift-minimal
    ;

  tipp10 = qt6.callPackage ../applications/misc/tipp10 { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  tony = libsForQt5.callPackage ../applications/audio/tony { };

  trustedqsl = tqsl; # Alias added 2019-02-10

  libtransmission_3 = transmission_3.override {
    installLib = true;
    enableDaemon = false;
    enableCli = false;
  };
  transmission_3-gtk = transmission_3.override { enableGTK3 = true; };
  transmission_3-qt = transmission_3.override { enableQt = true; };
  transmission_3_noSystemd = transmission_3.override { enableSystemd = false; };

  transmission_4 = callPackage ../applications/networking/p2p/transmission/4.nix {
    fmt = fmt_9;
    libutp = libutp_3_4;
  };
  libtransmission_4 = transmission_4.override {
    installLib = true;
    enableDaemon = false;
    enableCli = false;
  };
  transmission_4-gtk = transmission_4.override { enableGTK3 = true; };
  transmission_4-qt5 = transmission_4.override { enableQt5 = true; };
  transmission_4-qt6 = transmission_4.override { enableQt6 = true; };
  transmission_4-qt = transmission_4-qt5;

  traverso = libsForQt5.callPackage ../applications/audio/traverso { };

  tinywl = callPackage ../applications/window-managers/tinywl {
    wlroots = wlroots_0_18;
  };

  trojita = libsForQt5.callPackage ../applications/networking/mailreaders/trojita { };

  tuxclocker = libsForQt5.callPackage ../applications/misc/tuxclocker {
    tuxclocker-plugins = tuxclocker-plugins-with-unfree;
  };

  tuxclocker-without-unfree = libsForQt5.callPackage ../applications/misc/tuxclocker { };

  twmn = libsForQt5.callPackage ../applications/misc/twmn { };

  tests-stdenv-gcc-stageCompare = callPackage ../test/stdenv/gcc-stageCompare.nix { };

  twinkle = qt5.callPackage ../applications/networking/instant-messengers/twinkle { };

  buildTypstPackage = callPackage ../build-support/build-typst-package.nix { };

  typstPackages = typst.packages;

  ueberzug = with python3Packages; toPythonApplication ueberzug;

  uefitoolPackages = recurseIntoAttrs (callPackage ../tools/system/uefitool/variants.nix { });
  uefitool = uefitoolPackages.new-engine;

  ungoogled-chromium = callPackage ../applications/networking/browsers/chromium (
    (config.chromium or { })
    // {
      ungoogled = true;
    }
  );

  unigine-tropics = pkgsi686Linux.callPackage ../applications/graphics/unigine-tropics { };

  unigine-sanctuary = pkgsi686Linux.callPackage ../applications/graphics/unigine-sanctuary { };

  unigine-superposition = libsForQt5.callPackage ../applications/graphics/unigine-superposition { };

  uuagc = haskell.lib.compose.justStaticExecutables haskellPackages.uuagc;

  valentina = libsForQt5.callPackage ../applications/misc/valentina { };

  vdirsyncer = with python3Packages; toPythonApplication vdirsyncer;

  veusz = callPackage ../applications/graphics/veusz { };

  vim = vimUtils.makeCustomizable (
    callPackage ../applications/editors/vim {
    }
  );

  macvim =
    let
      macvimUtils = callPackage ../applications/editors/vim/macvim-configurable.nix { };
    in
    macvimUtils.makeCustomizable (
      callPackage ../applications/editors/vim/macvim.nix {
        stdenv = clangStdenv;
      }
    );

  vim-full = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/full.nix { });

  vim-darwin =
    (vim-full.override {
      config = {
        vim = {
          gui = "none";
          darwin = true;
        };
      };
    }).overrideAttrs
      {
        pname = "vim-darwin";
        meta = {
          platforms = lib.platforms.darwin;
        };
      };

  vimacs = callPackage ../applications/editors/vim/vimacs.nix { };

  qpdfview = libsForQt5.callPackage ../applications/office/qpdfview { };

  vimgolf = callPackage ../games/vimgolf { };

  # this is a lower-level alternative to wrapNeovim conceived to handle
  # more usecases when wrapping neovim. The interface is being actively worked on
  # so expect breakage. use wrapNeovim instead if you want a stable alternative
  wrapNeovimUnstable = callPackage ../applications/editors/neovim/wrapper.nix { };
  wrapNeovim = neovim-unwrapped: lib.makeOverridable (neovimUtils.legacyWrapper neovim-unwrapped);
  neovim-unwrapped = callPackage ../by-name/ne/neovim-unwrapped/package.nix {
    lua = if lib.meta.availableOn stdenv.hostPlatform luajit then luajit else lua5_1;
  };

  neovimUtils = callPackage ../applications/editors/neovim/utils.nix {
    lua = lua5_1;
  };
  neovim = wrapNeovim neovim-unwrapped { };

  gnvim-unwrapped = callPackage ../applications/editors/neovim/gnvim { };

  gnvim = callPackage ../applications/editors/neovim/gnvim/wrapper.nix { };

  virt-top = callPackage ../applications/virtualization/virt-top {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  virt-manager = callPackage ../applications/virtualization/virt-manager { };

  virt-manager-qt = libsForQt5.callPackage ../applications/virtualization/virt-manager/qt.nix {
    qtermwidget = lxqt.qtermwidget_1_4;
  };

  virtualbox = libsForQt5.callPackage ../applications/virtualization/virtualbox {
    stdenv = stdenv_32bit;

    # VirtualBox uses wsimport, which was removed after JDK 8.
    jdk = jdk8;

    # Opt out of building the guest BIOS sources with the problematic Open Watcom
    # toolchain. People who need to build the BIOS from sources (for example to
    # apply patches) can override this.
    open-watcom-bin = null;
  };

  virtualboxKvm = lowPrio (
    virtualbox.override {
      enableKvm = true;
    }
  );

  virtualboxHardened = lowPrio (
    virtualbox.override {
      enableHardening = true;
    }
  );

  virtualboxHeadless = lowPrio (
    virtualbox.override {
      enableHardening = true;
      headless = true;
    }
  );

  virtualboxExtpack = callPackage ../applications/virtualization/virtualbox/extpack.nix { };

  virtualboxWithExtpack = lowPrio (
    virtualbox.override {
      extensionPack = virtualboxExtpack;
    }
  );

  virtualglLib = callPackage ../tools/X11/virtualgl/lib.nix {
    fltk = fltk13;
  };

  virtualgl = callPackage ../tools/X11/virtualgl {
    virtualglLib_i686 =
      if stdenv.hostPlatform.system == "x86_64-linux" then pkgsi686Linux.virtualglLib else null;
  };

  vlc-bin-universal = vlc-bin.override { variant = "universal"; };

  libvlc = vlc.override {
    withQt5 = false;
    onlyLibVLC = true;
  };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  vscode = callPackage ../applications/editors/vscode/vscode.nix { };
  vscode-fhs = vscode.fhs;
  vscode-fhsWithPackages = vscode.fhsWithPackages;

  vscode-with-extensions = callPackage ../applications/editors/vscode/with-extensions.nix { };

  vscode-utils = callPackage ../applications/editors/vscode/extensions/vscode-utils.nix { };

  vscode-extensions = recurseIntoAttrs (callPackage ../applications/editors/vscode/extensions { });

  vscode-extension-update-script =
    callPackage ../by-name/vs/vscode-extension-update/vscode-extension-update-script.nix
      { };

  vscodium = callPackage ../applications/editors/vscode/vscodium.nix { };
  vscodium-fhs = vscodium.fhs;
  vscodium-fhsWithPackages = vscodium.fhsWithPackages;

  code-cursor = callPackage ../by-name/co/code-cursor/package.nix {
    vscode-generic = ../applications/editors/vscode/generic.nix;
  };
  code-cursor-fhs = code-cursor.fhs;
  code-cursor-fhsWithPackages = code-cursor.fhsWithPackages;

  windsurf = callPackage ../by-name/wi/windsurf/package.nix {
    vscode-generic = ../applications/editors/vscode/generic.nix;
  };

  openvscode-server = callPackage ../servers/openvscode-server {
    nodejs = nodejs_20;
  };

  code-server = callPackage ../servers/code-server {
    nodejs = nodejs_20;
  };

  whispers = with python3Packages; toPythonApplication whispers;

  # Should always be the version with the most features
  w3m-full = w3m;

  # Version without X11
  w3m-nox = w3m.override {
    x11Support = false;
    imlib2 = imlib2-nox;
  };

  # Version without X11 or graphics
  w3m-nographics = w3m.override {
    x11Support = false;
    graphicsSupport = false;
  };

  # Version for batch text processing, not a good browser
  w3m-batch = w3m.override {
    graphicsSupport = false;
    mouseSupport = false;
    x11Support = false;
    imlib2 = imlib2-nox;
  };

  wayfire = callPackage ../applications/window-managers/wayfire/default.nix {
    wlroots = wlroots_0_17;
  };
  wf-config = callPackage ../applications/window-managers/wayfire/wf-config.nix { };

  wayfirePlugins = recurseIntoAttrs (
    callPackage ../applications/window-managers/wayfire/plugins.nix { }
  );
  wayfire-with-plugins = callPackage ../applications/window-managers/wayfire/wrapper.nix {
    plugins = with wayfirePlugins; [
      wcm
      wf-shell
    ];
  };

  webcamoid = qt6Packages.callPackage ../applications/video/webcamoid { };

  webcord = callPackage ../by-name/we/webcord/package.nix { electron = electron_36; };

  webcord-vencord = callPackage ../by-name/we/webcord-vencord/package.nix { electron = electron_36; };

  webmacs = libsForQt5.callPackage ../applications/networking/browsers/webmacs {
    stdenv = if stdenv.cc.isClang then gccStdenv else stdenv;
  };

  webssh = with python3Packages; toPythonApplication webssh;

  wrapWeechat = callPackage ../applications/networking/irc/weechat/wrapper.nix { };

  weechat-unwrapped = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libresolv;
    guile = guile_3_0;
  };

  weechat = wrapWeechat weechat-unwrapped { };

  weechatScripts = recurseIntoAttrs (callPackage ../applications/networking/irc/weechat/scripts { });

  westonLite = weston.override {
    demoSupport = false;
    jpegSupport = false;
    lcmsSupport = false;
    pangoSupport = false;
    pipewireSupport = false;
    rdpSupport = false;
    remotingSupport = false;
    vaapiSupport = false;
    vncSupport = false;
    webpSupport = false;
    xwaylandSupport = false;
  };

  wgnord = callPackage ../applications/networking/wgnord/default.nix { };

  whalebird = callPackage ../applications/misc/whalebird {
    electron = electron_36;
  };

  inherit (windowmaker) dockapps;

  wofi-pass = callPackage ../../pkgs/tools/security/pass/wofi-pass.nix { };

  worldengine-cli = python3Packages.worldengine;

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

  wrapThunderbird = callPackage ../applications/networking/mailreaders/thunderbird/wrapper.nix { };

  wsjtx = qt5.callPackage ../applications/radio/wsjtx { };

  x11basic = callPackage ../development/compilers/x11basic {
    autoconf = buildPackages.autoconf269;
  };

  x2goclient = libsForQt5.callPackage ../applications/networking/remote/x2goclient { };

  x32edit = callPackage ../applications/audio/midas/x32edit.nix { };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config {
    gtk = gtk2;
  };

  kodiPackages = recurseIntoAttrs (kodi.packages);

  kodi = callPackage ../applications/video/kodi {
    ffmpeg = ffmpeg_6;
    jre_headless = buildPackages.jdk11_headless;
  };

  kodi-wayland = callPackage ../applications/video/kodi {
    ffmpeg = ffmpeg_6;
    jre_headless = buildPackages.jdk11_headless;
    waylandSupport = true;
  };

  kodi-gbm = callPackage ../applications/video/kodi {
    ffmpeg = ffmpeg_6;
    jre_headless = buildPackages.jdk11_headless;
    gbmSupport = true;
  };

  xca = qt6Packages.callPackage ../applications/misc/xca { };

  inherit (xorg) xcompmgr;

  xdg-desktop-portal = callPackage ../development/libraries/xdg-desktop-portal { };

  xdg-desktop-portal-hyprland =
    callPackage ../applications/window-managers/hyprwm/xdg-desktop-portal-hyprland
      {
        inherit (qt6)
          qtbase
          qttools
          qtwayland
          wrapQtAppsHook
          ;
      };

  buildXenPackage = callPackage ../build-support/xen { };

  gxneur = callPackage ../applications/misc/gxneur {
    inherit (gnome2) libglade GConf;
  };

  xournalpp = callPackage ../applications/graphics/xournalpp {
    lua = lua5_3;
  };

  xpdf = libsForQt5.callPackage ../applications/misc/xpdf { };

  xmobar = haskellPackages.xmobar.bin;

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = _: [ haskellPackages.xmonad-contrib ];
  };

  xmonadctl = callPackage ../applications/window-managers/xmonad/xmonadctl.nix {
    inherit (haskellPackages) ghcWithPackages;
  };

  xmonad_log_applet = callPackage ../applications/window-managers/xmonad/log-applet {
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_mate = xmonad_log_applet.override {
    desktopSupport = "mate";
  };

  xmonad_log_applet_xfce = xmonad_log_applet.override {
    desktopSupport = "xfce4";
  };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xygrib = libsForQt5.callPackage ../applications/misc/xygrib { };

  ydiff = with python3.pkgs; toPythonApplication ydiff;

  yokadi = python3Packages.callPackage ../applications/misc/yokadi { };

  your-editor = callPackage ../applications/editors/your-editor { stdenv = gccStdenv; };

  youtube-dl = with python3Packages; toPythonApplication youtube-dl;

  youtube-dl-light = with python3Packages; toPythonApplication youtube-dl-light;

  youtube-music = callPackage ../applications/audio/youtube-music {
    pnpm = pnpm_10;
  };

  yt-dlp-light = yt-dlp.override {
    atomicparsleySupport = false;
    ffmpegSupport = false;
    rtmpSupport = false;
  };

  youtube-viewer = perlPackages.WWWYoutubeViewer;

  yuview = libsForQt5.yuview;

  zathuraPkgs = callPackage ../applications/misc/zathura { };
  zathura = zathuraPkgs.zathuraWrapper;

  zeroc-ice-cpp11 = zeroc-ice.override { cpp11 = true; };

  zexy = callPackage ../applications/audio/pd-plugins/zexy {
    autoconf = buildPackages.autoconf269;
  };

  zed-editor-fhs = zed-editor.fhs;

  zgv = callPackage ../applications/graphics/zgv {
    # Enable the below line for terminal display. Note
    # that it requires sixel graphics compatible terminals like mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
    SDL_image = SDL_image.override { SDL = SDL_sixel; };
  };

  zotero_7 = pkgs.zotero;

  zsteg = callPackage ../tools/security/zsteg { };

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx {
    guiModule = "zest";
    fftw = fftwSinglePrec;
  };

  zynaddsubfx-fltk = zynaddsubfx.override {
    guiModule = "fltk";
  };

  zynaddsubfx-ntk = zynaddsubfx.override {
    guiModule = "ntk";
  };

  ### BLOCKCHAINS / CRYPTOCURRENCIES / WALLETS

  alfis-nogui = alfis.override {
    withGui = false;
  };

  bitcoin = libsForQt5.callPackage ../applications/blockchains/bitcoin {
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoind = callPackage ../applications/blockchains/bitcoin {
    withGui = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoin-knots = libsForQt5.callPackage ../applications/blockchains/bitcoin-knots {
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoind-knots = callPackage ../applications/blockchains/bitcoin-knots {
    withGui = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoin-abc = libsForQt5.callPackage ../applications/blockchains/bitcoin-abc {
    withGui = true;
    protobuf = protobuf_21;
  };
  bitcoind-abc = callPackage ../applications/blockchains/bitcoin-abc {
    mkDerivation = stdenv.mkDerivation;
    protobuf = protobuf_21;
    withGui = false;
  };

  cryptop = python3.pkgs.callPackage ../applications/blockchains/cryptop { };

  elements = libsForQt5.callPackage ../applications/blockchains/elements {
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };
  elementsd = callPackage ../applications/blockchains/elements {
    withGui = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };
  elementsd-simplicity = elementsd.overrideAttrs {
    version = "unstable-2023-04-18";
    src = fetchFromGitHub {
      owner = "ElementsProject";
      repo = "elements";
      rev = "ea318a45094ab3d31dd017d7781a6f28f1ffaa33"; # simplicity branch latest
      hash = "sha256-ooe+If3HWaJWpr2ux7DpiCTqB9Hv+aXjquEjplDjvhM=";
    };
  };

  fulcrum = libsForQt5.callPackage ../applications/blockchains/fulcrum { };

  gridcoin-research = libsForQt5.callPackage ../applications/blockchains/gridcoin-research {
    boost = boost179;
  };

  groestlcoin = libsForQt5.callPackage ../applications/blockchains/groestlcoin {
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  groestlcoind = callPackage ../applications/blockchains/groestlcoin {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  ledger-agent = with python3Packages; toPythonApplication ledger-agent;

  napari = with python3Packages; toPythonApplication napari;

  nano-wallet = libsForQt5.callPackage ../applications/blockchains/nano-wallet { };

  pycoin = with python3Packages; toPythonApplication pycoin;

  inherit (callPackages ../applications/blockchains/teos { })
    teos
    teos-watchtower-plugin
    ;

  vertcoin = libsForQt5.callPackage ../applications/blockchains/vertcoin {
    withGui = true;
  };
  vertcoind = callPackage ../applications/blockchains/vertcoin {
    withGui = false;
  };

  zcash = callPackage ../applications/blockchains/zcash {
    stdenv = llvmPackages.stdenv;
  };

  samplv1 = qt6.callPackage ../applications/audio/samplv1 { };

  beancount = with python3.pkgs; toPythonApplication beancount;

  beancount_2 = with python3.pkgs; toPythonApplication beancount_2;

  beancount-black = with python3.pkgs; toPythonApplication beancount-black;

  beanhub-cli = with python3.pkgs; toPythonApplication beanhub-cli;

  bean-add = callPackage ../applications/office/beancount/bean-add.nix { };

  beanquery = with python3.pkgs; toPythonApplication beanquery;

  bench =
    # TODO: Erroneous references to GHC on aarch64-darwin: https://github.com/NixOS/nixpkgs/issues/318013
    (
      if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
        lib.id
      else
        haskell.lib.compose.justStaticExecutables
    )
      haskellPackages.bench;

  cri-o = callPackage ../applications/virtualization/cri-o/wrapper.nix { };
  cri-o-unwrapped = callPackage ../applications/virtualization/cri-o { };

  drumkv1 = libsForQt5.callPackage ../applications/audio/drumkv1 { };

  phonemizer = with python3Packages; toPythonApplication phonemizer;

  ### GAMES

  _2048-cli = _2048-cli-terminal;
  _2048-cli-curses = callPackage ../games/2048-cli { ui = "curses"; };
  _2048-cli-terminal = callPackage ../games/2048-cli { ui = "terminal"; };

  _90secondportraits = callPackage ../games/90secondportraits { love = love_0_10; };

  inherit (callPackages ../games/fteqw { })
    fteqw
    fteqw-dedicated
    fteqcc
    ;

  pmars-x11 = pmars.override { enableXwinGraphics = true; };

  vanillatd = callPackage ../by-name/va/vanillatd/package.nix { appName = "vanillatd"; };

  vanillara = callPackage ../by-name/va/vanillatd/package.nix { appName = "vanillara"; };

  ### GAMES/DOOM-PORTS

  doomseeker = qt5.callPackage ../games/doom-ports/doomseeker { };

  enyo-launcher = libsForQt5.callPackage ../games/doom-ports/enyo-launcher { };

  slade = callPackage ../games/doom-ports/slade {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  sladeUnstable = callPackage ../games/doom-ports/slade/git.nix {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  zandronum = callPackage ../games/doom-ports/zandronum { };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zandronum-alpha = callPackage ../games/doom-ports/zandronum/alpha { };

  zandronum-alpha-server = zandronum-alpha.override {
    serverOnly = true;
  };

  fmodex = callPackage ../games/doom-ports/zandronum/fmod.nix { };

  pro-office-calculator = libsForQt5.callPackage ../games/pro-office-calculator { };

  qgo = libsForQt5.callPackage ../games/qgo { };

  amoeba = callPackage ../games/amoeba { };
  amoeba-data = callPackage ../games/amoeba/data.nix { };

  anki = callPackage ../games/anki { };
  anki-bin = callPackage ../games/anki/bin.nix { };
  anki-sync-server = callPackage ../games/anki/sync-server.nix { };

  armagetronad = callPackage ../games/armagetronad { };

  armagetronad-dedicated = callPackage ../games/armagetronad { dedicatedServer = true; };

  art = callPackage ../by-name/ar/art/package.nix {
    fftw = fftwSinglePrec;
  };

  arx-libertatis = libsForQt5.callPackage ../games/arx-libertatis { };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    physfs = physfs_2;
  };

  beancount-ing-diba = callPackage ../applications/office/beancount/beancount-ing-diba.nix {
    inherit (python3Packages) beancount beangulp;
  };

  beancount-share = callPackage ../applications/office/beancount/beancount_share.nix {
    inherit (python3Packages) beancount beancount-plugin-utils;
  };

  cataclysmDDA = callPackage ../games/cataclysm-dda { };

  cataclysm-dda = cataclysmDDA.stable.tiles;

  cataclysm-dda-git = cataclysmDDA.git.tiles;

  chessx = libsForQt5.callPackage ../games/chessx { };

  chiaki = libsForQt5.callPackage ../games/chiaki { };

  chiaki-ng = kdePackages.callPackage ../games/chiaki-ng { };

  cockatrice = libsForQt5.callPackage ../games/cockatrice {
    protobuf = protobuf_21;
  };

  construoBase = lowPrio (
    callPackage ../games/construo {
      libGL = null;
      libGLU = null;
      libglut = null;
    }
  );

  construo = construoBase.override {
    inherit libGL libGLU libglut;
  };

  crawlTiles = callPackage ../games/crawl {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  curseofwar = callPackage ../games/curseofwar { SDL = null; };
  curseofwar-sdl = callPackage ../games/curseofwar { ncurses = null; };

  cutechess = qt5.callPackage ../games/cutechess { };

  cutemaze = qt6Packages.callPackage ../games/cutemaze { };

  ddnet-server = ddnet.override { buildClient = false; };

  duckmarines = callPackage ../games/duckmarines { love = love_0_10; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });

  inherit (dwarf-fortress-packages) dwarf-fortress dwarf-fortress-full dwarf-therapist;

  dfhack = dwarf-fortress-packages.dwarf-fortress-full;

  dxx-rebirth = callPackage ../games/dxx-rebirth { };

  inherit (callPackages ../games/dxx-rebirth/assets.nix { })
    descent1-assets
    descent2-assets
    ;

  inherit (callPackages ../games/dxx-rebirth/full.nix { })
    d1x-rebirth-full
    d2x-rebirth-full
    ;

  fallout-ce = callPackage ../games/fallout-ce/fallout-ce.nix { };
  fallout2-ce = callPackage ../games/fallout-ce/fallout2-ce.nix { };

  fltrator = callPackage ../games/fltrator {
    fltk = fltk-minimal;
  };

  factorio = callPackage ../by-name/fa/factorio/package.nix { releaseType = "alpha"; };

  factorio-experimental = factorio.override {
    releaseType = "alpha";
    experimental = true;
  };

  factorio-headless = factorio.override { releaseType = "headless"; };

  factorio-headless-experimental = factorio.override {
    releaseType = "headless";
    experimental = true;
  };

  factorio-demo = factorio.override { releaseType = "demo"; };

  factorio-demo-experimental = factorio.override {
    releaseType = "demo";
    experimental = true;
  };

  factorio-space-age = factorio.override { releaseType = "expansion"; };

  factorio-space-age-experimental = factorio.override {
    releaseType = "expansion";
    experimental = true;
  };

  factorio-utils = callPackage ../by-name/fa/factorio/utils.nix { };

  flightgear = libsForQt5.callPackage ../games/flightgear { };

  freecad-wayland = freecad.override { withWayland = true; };
  freecad-qt6 = freecad.override {
    withWayland = true;
    qtVersion = 6;
  };

  freeciv = callPackage ../games/freeciv {
    sdl2Client = false;
    gtkClient = true;
    qtClient = false;
  };

  freeciv_sdl2 = freeciv.override {
    sdl2Client = true;
    gtkClient = false;
    qtClient = false;
  };

  freeciv_qt = freeciv.override {
    sdl2Client = false;
    gtkClient = false;
    qtClient = true;
  };

  freeciv_gtk = freeciv;

  garden-of-coloured-lights = callPackage ../games/garden-of-coloured-lights { allegro = allegro4; };

  gcompris = kdePackages.callPackage ../games/gcompris { };

  gl-gsync-demo = callPackage ../games/gl-gsync-demo {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  gscrabble = python3Packages.callPackage ../games/gscrabble { };

  qtads = qt5.callPackage ../games/qtads { };

  ibmcloud-cli = callPackage ../tools/admin/ibmcloud-cli { stdenv = stdenvNoCC; };

  instaloader = python3Packages.callPackage ../tools/misc/instaloader { };

  iortcw = callPackage ../games/iortcw { };
  # used as base package for iortcw forks
  iortcw_sp = callPackage ../games/iortcw/sp.nix { };

  katagoWithCuda = katago.override {
    backend = "cuda";
  };

  katagoCPU = katago.override {
    backend = "eigen";
  };

  katagoTensorRT = katago.override {
    backend = "tensorrt";
  };

  koboredux = callPackage ../games/koboredux { };

  koboredux-free = callPackage ../games/koboredux {
    useProprietaryAssets = false;
  };

  ldmud-full = callPackage ../by-name/ld/ldmud/package.nix {
    ipv6Support = true;
    mccpSupport = true;
    mysqlSupport = true;
    postgresSupport = true;
    sqliteSupport = true;
    tlsSupport = true;
    pythonSupport = true;
  };

  leela-zero = libsForQt5.callPackage ../games/leela-zero { };

  legendary-gl = python3Packages.callPackage ../games/legendary-gl { };

  lincity = callPackage ../games/lincity { };

  lincity_ng = callPackage ../games/lincity/ng.nix {
    # https://github.com/lincity-ng/lincity-ng/issues/25
    physfs = physfs_2;
  };

  liquidwar = callPackage ../games/liquidwar {
    guile = guile_2_0;
  };

  liquidwar5 = callPackage ../games/liquidwar/5.nix { };

  maptool = callPackage ../games/maptool {
    # MapTool is fussy about which JRE it uses; OpenJDK will leave it hanging
    # at launch in a class initialization deadlock. MapTool ships Temurin with
    # their pre-built releases so we might as well use it too.
    jre = temurin-bin-21;
    openjfx = openjfx21;
  };

  mindustry-wayland = callPackage ../by-name/mi/mindustry/package.nix {
    enableWayland = true;
  };

  mindustry-server = callPackage ../by-name/mi/mindustry/package.nix {
    enableClient = false;
    enableServer = true;
  };

  minecraftServers = import ../games/minecraft-servers { inherit callPackage lib javaPackages; };
  minecraft-server = minecraftServers.vanilla; # backwards compatibility

  luanti-client = luanti.override { buildServer = false; };
  luanti-server = luanti.override { buildClient = false; };

  mnemosyne = callPackage ../games/mnemosyne { };

  mrrescue = callPackage ../games/mrrescue { love = love_0_10; };

  mudlet = libsForQt5.callPackage ../games/mudlet {
    lua = lua5_1;
  };

  blightmud = callPackage ../games/blightmud { };

  blightmud-tts = callPackage ../games/blightmud { withTTS = true; };

  nethack = callPackage ../games/nethack { };

  nethack-qt = callPackage ../games/nethack {
    qtMode = true;
    stdenv = gccStdenv;
  };

  nethack-x11 = callPackage ../games/nethack { x11Mode = true; };

  npush = callPackage ../games/npush { };
  run-npush = callPackage ../games/npush/run.nix { };

  oilrush = callPackage ../games/oilrush { };

  openloco = pkgsi686Linux.callPackage ../games/openloco { };

  openmw = libsForQt5.callPackage ../games/openmw { };

  openmw-tes3mp = libsForQt5.callPackage ../games/openmw/tes3mp.nix { };

  openraPackages_2019 = import ../games/openra_2019 {
    inherit lib;
    pkgs = pkgs.__splicedPackages;
  };

  openra_2019 = openraPackages_2019.engines.release;

  openraPackages = recurseIntoAttrs (callPackage ../games/openra { });

  openra = openraPackages.engines.release;

  openttd = callPackage ../games/openttd {
    zlib = zlib.override {
      static = true;
    };
  };
  openttd-jgrpp = callPackage ../games/openttd/jgrpp.nix {
    zlib = zlib.override {
      static = true;
    };
  };
  openttd-grfcodec = callPackage ../games/openttd/grfcodec.nix { };
  openttd-nml = callPackage ../games/openttd/nml.nix { };

  openxcom = callPackage ../games/openxcom { SDL = SDL_compat; };

  openxray = callPackage ../games/openxray {
    # Builds with Clang, but hits an assertion failure unless GCC is used
    # https://github.com/OpenXRay/xray-16/issues/1224
    stdenv = gccStdenv;
  };

  orthorobot = callPackage ../games/orthorobot { love = love_0_10; };

  papermcServers = callPackages ../games/papermc { };

  papermc = papermcServers.papermc;

  path-of-building = qt6Packages.callPackage ../games/path-of-building { };

  pentobi = libsForQt5.callPackage ../games/pentobi { };

  pokerth = libsForQt5.callPackage ../games/pokerth {
    protobuf = protobuf_21;
  };

  pokerth-server = libsForQt5.callPackage ../games/pokerth {
    target = "server";
    protobuf = protobuf_21;
  };

  quake3wrapper = callPackage ../games/quake3/wrapper { };

  quake3demo = quake3wrapper {
    name = "quake3-demo-${lib.getVersion quake3demodata}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    paks = [
      quake3pointrelease
      quake3demodata
    ];
  };

  quake3demodata = callPackage ../games/quake3/content/demo.nix { };

  quake3pointrelease = callPackage ../games/quake3/content/pointrelease.nix { };

  quake3hires = callPackage ../games/quake3/content/hires.nix { };

  quakespasm = callPackage ../games/quakespasm { };
  vkquake = callPackage ../games/quakespasm/vulkan.nix { };

  rogue = callPackage ../games/rogue {
    ncurses = ncurses5;
  };

  rott = callPackage ../games/rott { SDL = SDL_compat; };

  rott-shareware = rott.override {
    buildShareware = true;
  };

  starsector = callPackage ../games/starsector {
    openjdk = openjdk17;
  };

  scummvm = callPackage ../games/scummvm { };

  inherit (callPackage ../games/scummvm/games.nix { })
    beneath-a-steel-sky
    broken-sword-25
    drascula-the-vampire-strikes-back
    dreamweb
    flight-of-the-amazon-queen
    lure-of-the-temptress
    ;

  sgt-puzzles = callPackage ../games/sgt-puzzles { };

  sgt-puzzles-mobile = callPackage ../games/sgt-puzzles {
    isMobile = true;
  };

  shattered-pixel-dungeon = callPackage ../games/shattered-pixel-dungeon { };
  rkpd2 = callPackage ../games/shattered-pixel-dungeon/rkpd2 { };
  rat-king-adventure = callPackage ../games/shattered-pixel-dungeon/rat-king-adventure { };
  experienced-pixel-dungeon =
    callPackage ../games/shattered-pixel-dungeon/experienced-pixel-dungeon
      { };
  summoning-pixel-dungeon = callPackage ../games/shattered-pixel-dungeon/summoning-pixel-dungeon { };
  shorter-pixel-dungeon = callPackage ../games/shattered-pixel-dungeon/shorter-pixel-dungeon { };
  tower-pixel-dungeon = callPackage ../games/shattered-pixel-dungeon/tower-pixel-dungeon { };

  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  # solarus and solarus-quest-editor must use the same version of Qt.
  solarus = libsForQt5.callPackage ../games/solarus { };
  solarus-quest-editor = libsForQt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.
  spring = callPackage ../games/spring { asciidoc = asciidoc-full; };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  steam-run = steam.run;

  # This exists so Hydra tries to build all of Steam's dependencies.
  steam-fhsenv-without-steam = steam.override { steam-unwrapped = null; };

  steam-run-free = steam-fhsenv-without-steam.run;

  steamback = python311.pkgs.callPackage ../tools/games/steamback { };

  protontricks = python3Packages.callPackage ../tools/package-management/protontricks {
    steam-run = steam-run-free;
    inherit winetricks yad;
  };

  protonup-ng = with python3Packages; toPythonApplication protonup-ng;

  stuntrally = callPackage ../games/stuntrally { boost = boost183; };

  synthv1 = libsForQt5.callPackage ../applications/audio/synthv1 { };

  the-powder-toy = callPackage ../by-name/th/the-powder-toy/package.nix {
    lua = lua5_2;
  };

  tbe = libsForQt5.callPackage ../games/the-butterfly-effect { };

  teeworlds-server = teeworlds.override { buildClient = false; };

  tengine = callPackage ../servers/http/tengine {
    modules = with nginxModules; [
      rtmp
      dav
      moreheaders
      modsecurity
    ];
  };

  tibia = pkgsi686Linux.callPackage ../games/tibia { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    libpng = libpng12;
  };

  ultrastar-creator = libsForQt5.callPackage ../tools/misc/ultrastar-creator { };

  ultrastar-manager = libsForQt5.callPackage ../tools/misc/ultrastar-manager { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  # To ensure vdrift's code is built on hydra
  vdrift-bin = vdrift.bin;

  vessel = pkgsi686Linux.callPackage ../games/vessel { };

  warsow-engine = callPackage ../games/warsow/engine.nix { };

  warsow = callPackage ../games/warsow { };

  wesnoth = callPackage ../games/wesnoth {
    boost = boost186;
    # wesnoth requires lua built with c++, see https://github.com/wesnoth/wesnoth/pull/8234
    lua = lua5_4.override {
      postConfigure = ''
        makeFlagsArray+=("CC=$CXX")
      '';
    };
  };

  wesnoth-dev = wesnoth;

  inherit (callPackage ../games/xonotic { })
    xonotic-data
    xonotic
    ;

  xonotic-glx =
    (callPackage ../games/xonotic {
      withSDL = false;
      withGLX = true;
    }).xonotic;

  xonotic-dedicated =
    (callPackage ../games/xonotic {
      withSDL = false;
      withDedicated = true;
    }).xonotic;

  xonotic-sdl = xonotic;
  xonotic-sdl-unwrapped = xonotic-sdl.xonotic-unwrapped;
  xonotic-glx-unwrapped = xonotic-glx.xonotic-unwrapped;
  xonotic-dedicated-unwrapped = xonotic-dedicated.xonotic-unwrapped;

  xpilot-ng = callPackage ../games/xpilot { };
  bloodspilot-server = callPackage ../games/xpilot/bloodspilot-server.nix { };
  bloodspilot-client = callPackage ../games/xpilot/bloodspilot-client.nix { };

  inherit
    (callPackage ../games/quake2/yquake2 {
    })
    yquake2
    yquake2-ctf
    yquake2-ground-zero
    yquake2-the-reckoning
    yquake2-all-games
    ;

  zeroad-unwrapped = callPackage ../by-name/ze/zeroad-unwrapped/package.nix {
    wxGTK = wxGTK32;
    fmt = fmt_9;
  };

  ### DESKTOP ENVIRONMENTS

  arcan-wrapped = arcan.wrapper.override { };
  arcan-all-wrapped = arcan.wrapper.override {
    name = "arcan-all-wrapped";
    appls = [
      cat9
      durden
      pipeworld
    ];

  };
  cat9-wrapped = arcan.wrapper.override {
    name = "cat9-wrapped";
    appls = [ cat9 ];
  };
  durden-wrapped = arcan.wrapper.override {
    name = "durden-wrapped";
    appls = [ durden ];
  };
  pipeworld-wrapped = arcan.wrapper.override {
    name = "pipeworld-wrapped";
    appls = [ pipeworld ];
  };
  prio-wrapped = arcan.wrapper.override {
    name = "prio-wrapped";
    appls = [ prio ];
  };

  deepin = recurseIntoAttrs (callPackage ../desktops/deepin { });

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment { });

  expidus = recurseIntoAttrs (
    callPackages ../desktops/expidus {
      # Use the Nix built Flutter Engine for testing.
      # Also needed when we eventually package Genesis Shell.
      flutterPackages = flutterPackages-source;
    }
  );

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 { });

  gnome = recurseIntoAttrs (callPackage ../desktops/gnome { });

  inherit (callPackage ../desktops/gnome/extensions { })
    gnomeExtensions
    gnome38Extensions
    gnome40Extensions
    gnome41Extensions
    gnome42Extensions
    gnome43Extensions
    gnome44Extensions
    gnome45Extensions
    gnome46Extensions
    gnome47Extensions
    gnome48Extensions
    ;

  gnome-extensions-cli = python3Packages.callPackage ../desktops/gnome/misc/gnome-extensions-cli { };

  gnome-session-ctl = callPackage ../by-name/gn/gnome-session/ctl.nix { };

  lomiri = recurseIntoAttrs (callPackage ../desktops/lomiri { });

  lumina = recurseIntoAttrs (callPackage ../desktops/lumina { });

  ### DESKTOPS/LXDE

  lxde = recurseIntoAttrs (callPackage ../desktops/lxde { });
  # Backwards compatibility aliases
  inherit (lxde)
    lxappearance
    lxappearance-gtk2
    lxmenu-data
    lxpanel
    lxrandr
    lxsession
    lxtask
    ;

  lxqt = recurseIntoAttrs (
    import ../desktops/lxqt {
      inherit pkgs;
      inherit (lib) makeScope;
      inherit kdePackages;
    }
  );

  mate = recurseIntoAttrs (callPackage ../desktops/mate { });

  # Needed for elementary's gala, wingpanel and greeter until support for higher versions is provided
  pantheon = recurseIntoAttrs (callPackage ../desktops/pantheon { });

  xfce = recurseIntoAttrs (callPackage ../desktops/xfce { });

  plasma-applet-volumewin7mixer =
    libsForQt5.callPackage ../applications/misc/plasma-applet-volumewin7mixer
      { };

  plasma-theme-switcher = libsForQt5.callPackage ../applications/misc/plasma-theme-switcher { };

  plasma-pass = libsForQt5.callPackage ../tools/security/plasma-pass { };

  inherit
    (callPackages ../applications/misc/redshift {
      inherit (python3Packages)
        python
        pygobject3
        pyxdg
        wrapPython
        ;
      geoclue = geoclue2;
    })
    redshift
    gammastep
    ;

  redshift-plasma-applet = libsForQt5.callPackage ../applications/misc/redshift-plasma-applet { };

  latte-dock = libsForQt5.callPackage ../applications/misc/latte-dock { };

  ### SCIENCE/CHEMISTY

  avogadrolibs = libsForQt5.callPackage ../development/libraries/science/chemistry/avogadrolibs { };

  molequeue = libsForQt5.callPackage ../development/libraries/science/chemistry/molequeue { };

  avogadro2 = libsForQt5.callPackage ../applications/science/chemistry/avogadro2 { };

  jmol = callPackage ../applications/science/chemistry/jmol {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  marvin = callPackage ../applications/science/chemistry/marvin { };

  molbar = with python3Packages; toPythonApplication molbar;

  nwchem = callPackage ../applications/science/chemistry/nwchem {
    blas = blas-ilp64;
    lapack = lapack-ilp64;
  };

  autodock-vina = callPackage ../applications/science/chemistry/autodock-vina { };

  pdb2pqr = with python3Packages; toPythonApplication pdb2pqr;

  quantum-espresso = callPackage ../applications/science/chemistry/quantum-espresso {
    hdf5 = hdf5-fortran;
  };

  siesta = callPackage ../applications/science/chemistry/siesta { };

  siesta-mpi = callPackage ../applications/science/chemistry/siesta { useMpi = true; };

  ### SCIENCE/GEOMETRY

  tetgen = callPackage ../applications/science/geometry/tetgen { }; # AGPL3+
  tetgen_1_4 = callPackage ../applications/science/geometry/tetgen/1.4.nix { }; # MIT

  ### SCIENCE/BENCHMARK

  ### SCIENCE/BIOLOGY

  blast = callPackage ../applications/science/biology/blast { };

  blast-bin = callPackage ../applications/science/biology/blast/bin.nix { };

  cd-hit = callPackage ../applications/science/biology/cd-hit {
    inherit (llvmPackages) openmp;
  };

  deepdiff = with python3Packages; toPythonApplication deepdiff;

  deepsecrets = callPackage ../tools/security/deepsecrets {
    python3 = python311;
  };

  deep-translator = with python3Packages; toPythonApplication deep-translator;

  hh-suite = callPackage ../applications/science/biology/hh-suite {
    inherit (llvmPackages) openmp;
  };

  kallisto = callPackage ../applications/science/biology/kallisto {
    autoconf = buildPackages.autoconf269;
  };

  mirtk = callPackage ../development/libraries/science/biology/mirtk { itk = itk_5_2; };

  nest = callPackage ../applications/science/biology/nest { };

  nest-mpi = callPackage ../applications/science/biology/nest { withMpi = true; };

  neuron-mpi = neuron.override { useMpi = true; };

  neuron-full = neuron-mpi.override {
    useCore = true;
    useRx3d = true;
  };

  mrtrix = callPackage ../applications/science/biology/mrtrix { };

  minc_tools = callPackage ../applications/science/biology/minc-tools {
    inherit (perlPackages) perl TextFormat;
  };

  obitools3 = callPackage ../applications/science/biology/obitools/obitools3.nix { };

  raxml-mpi = raxml.override { useMpi = true; };

  samtools = callPackage ../applications/science/biology/samtools { };

  trimmomatic = callPackage ../applications/science/biology/trimmomatic {
    jdk = pkgs.jdk21_headless;
    # Reduce closure size
    jre = pkgs.jre_minimal.override {
      modules = [
        "java.base"
        "java.logging"
      ];
      jdk = pkgs.jdk21_headless;
    };
  };

  truvari = callPackage ../applications/science/biology/truvari { };

  ### SCIENCE/MACHINE LEARNING

  sc2-headless = callPackage ../applications/science/machine-learning/sc2-headless { };

  streamlit = with python3Packages; toPythonApplication streamlit;

  ### SCIENCE/MATH

  blas-ilp64 = blas.override { isILP64 = true; };

  cantor = libsForQt5.cantor;

  labplot = libsForQt5.callPackage ../applications/science/math/labplot { };

  lapack-ilp64 = lapack.override { isILP64 = true; };

  liblapack = lapack-reference;

  nota = haskellPackages.callPackage ../applications/science/math/nota { };

  notus-scanner = with python3Packages; toPythonApplication notus-scanner;

  openblas = callPackage ../development/libraries/science/math/openblas {
    inherit (llvmPackages) openmp;
  };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  inherit (callPackage ../development/libraries/science/math/magma { }) magma;

  magma-cuda = magma.override {
    cudaSupport = true;
    rocmSupport = false;
  };

  magma-cuda-static = magma-cuda.override {
    static = true;
  };

  magma-hip = magma.override {
    cudaSupport = false;
    rocmSupport = true;
  };

  mathematica = callPackage ../applications/science/math/mathematica { };

  mathematica-webdoc = callPackage ../applications/science/math/mathematica {
    webdoc = true;
  };

  mathematica-cuda = callPackage ../applications/science/math/mathematica {
    cudaSupport = true;
  };

  mathematica-webdoc-cuda = callPackage ../applications/science/math/mathematica {
    webdoc = true;
    cudaSupport = true;
  };

  math-preview = callPackage ../by-name/ma/math-preview/package.nix {
    nodejs = nodejs_20;
  };

  p4est-sc = callPackage ../development/libraries/science/math/p4est-sc {
    p4est-sc-debugEnable = false;
  };

  p4est-sc-dbg = callPackage ../development/libraries/science/math/p4est-sc { };

  p4est = callPackage ../development/libraries/science/math/p4est { };

  p4est-dbg = callPackage ../development/libraries/science/math/p4est {
    p4est-sc = p4est-sc-dbg;
  };

  sageWithDoc = sage.override { withDoc = true; };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse/4.4.nix { };
  suitesparse_5_3 = callPackage ../development/libraries/science/math/suitesparse {
    inherit (llvmPackages) openmp;
  };
  suitesparse = suitesparse_5_3;

  trilinos = callPackage ../development/libraries/science/math/trilinos { };

  trilinos-mpi = callPackage ../development/libraries/science/math/trilinos { withMPI = true; };

  wolfram-engine = libsForQt5.callPackage ../applications/science/math/wolfram-engine { };

  wolfram-for-jupyter-kernel = callPackage ../applications/editors/jupyter-kernels/wolfram { };

  wolfram-notebook = callPackage ../applications/science/math/wolfram-engine/notebook.nix { };

  ### SCIENCE/MOLECULAR-DYNAMICS

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    fftw = fftwSinglePrec;
  };

  gromacsPlumed = lowPrio (
    gromacs.override {
      singlePrec = true;
      enablePlumed = true;
      fftw = fftwSinglePrec;
    }
  );

  gromacsMpi = lowPrio (
    gromacs.override {
      singlePrec = true;
      enableMpi = true;
      fftw = fftwSinglePrec;
    }
  );

  gromacsDouble = lowPrio (
    gromacs.override {
      singlePrec = false;
      fftw = fftw;
    }
  );

  gromacsDoubleMpi = lowPrio (
    gromacs.override {
      singlePrec = false;
      enableMpi = true;
      fftw = fftw;
    }
  );

  gromacsCudaMpi = lowPrio (
    gromacs.override {
      singlePrec = true;
      enableMpi = true;
      enableCuda = true;
      fftw = fftwSinglePrec;
    }
  );

  ### SCIENCE/MEDICINE

  ### SCIENCE/PHYSICS

  mcfm = callPackage ../applications/science/physics/MCFM {
    stdenv = gccStdenv;
    lhapdf = lhapdf.override {
      stdenv = gccStdenv;
      python3 = null;
    };
  };

  xflr5 = libsForQt5.callPackage ../applications/science/physics/xflr5 { };

  ### SCIENCE/PROGRAMMING

  ### SCIENCE/LOGIC

  abella = callPackage ../applications/science/logic/abella {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  inherit
    (callPackage ./coq-packages.nix {
      inherit (ocaml-ng)
        ocamlPackages_4_05
        ocamlPackages_4_09
        ocamlPackages_4_10
        ocamlPackages_4_12
        ocamlPackages_4_14
        ;
    })
    mkCoqPackages
    coqPackages_8_5
    coq_8_5
    coqPackages_8_6
    coq_8_6
    coqPackages_8_7
    coq_8_7
    coqPackages_8_8
    coq_8_8
    coqPackages_8_9
    coq_8_9
    coqPackages_8_10
    coq_8_10
    coqPackages_8_11
    coq_8_11
    coqPackages_8_12
    coq_8_12
    coqPackages_8_13
    coq_8_13
    coqPackages_8_14
    coq_8_14
    coqPackages_8_15
    coq_8_15
    coqPackages_8_16
    coq_8_16
    coqPackages_8_17
    coq_8_17
    coqPackages_8_18
    coq_8_18
    coqPackages_8_19
    coq_8_19
    coqPackages_8_20
    coq_8_20
    coqPackages_9_0
    coq_9_0
    coqPackages
    coq
    ;

  inherit
    (callPackage ./rocq-packages.nix {
      inherit (ocaml-ng)
        ocamlPackages_4_14
        ;
    })
    mkRocqPackages
    rocqPackages_9_0
    rocq-core_9_0
    rocqPackages
    rocq-core
    ;

  coq-kernel = callPackage ../applications/editors/jupyter-kernels/coq { };

  cubicle = callPackage ../applications/science/logic/cubicle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  };

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (_: {
      dontDisableStatic = true;
    });
    stdenv = gccStdenv;
  };
  cvc5 = callPackage ../applications/science/logic/cvc5 {
    cadical = pkgs.cadical.override { version = "2.0.0"; };
  };

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {
    ocaml = ocaml-ng.ocamlPackages_4_14_unsafe_string.ocaml;
  };

  eprover = callPackage ../applications/science/logic/eprover { };

  eprover-ho = callPackage ../applications/science/logic/eprover { enableHO = true; };

  giac-with-xcas = giac.override { enableGUI = true; };

  glucose = callPackage ../applications/science/logic/glucose { };
  glucose-syrup = callPackage ../applications/science/logic/glucose {
    enableUnfree = true;
  };

  inherit (ocamlPackages) hol_light;

  isabelle = callPackage ../by-name/is/isabelle/package.nix {
    polyml = polyml.overrideAttrs {
      pname = "polyml-for-isabelle";
      version = "2025";
      configureFlags = [
        "--enable-intinf-as-int"
        "--with-gmp"
        "--disable-shared"
      ];
      buildFlags = [ "compiler" ];
    };

    java = openjdk21;
  };
  isabelle-components = recurseIntoAttrs (callPackage ../by-name/is/isabelle/components { });

  lean3 = lean;
  mathlibtools = with python3Packages; toPythonApplication mathlibtools;

  leo2 = callPackage ../applications/science/logic/leo2 {
    inherit (ocaml-ng.ocamlPackages_4_14_unsafe_string) ocaml camlp4;
  };

  leo3-bin = callPackage ../applications/science/logic/leo3/binary.nix { };

  prooftree = callPackage ../applications/science/logic/prooftree {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  satallax = callPackage ../applications/science/logic/satallax {
    inherit (ocaml-ng.ocamlPackages_4_14) ocaml;
  };

  spass = callPackage ../applications/science/logic/spass {
    stdenv = gccStdenv;
  };

  statverif = callPackage ../applications/science/logic/statverif {
    ocaml = ocaml-ng.ocamlPackages_4_14_unsafe_string.ocaml;
  };

  veriT = callPackage ../applications/science/logic/verit {
    stdenv = gccStdenv;
  };

  why3 = callPackage ../applications/science/logic/why3 { coqPackages = coqPackages_8_20; };

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };

  tlaplus = callPackage ../applications/science/logic/tlaplus {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  tlaplus18 = callPackage ../applications/science/logic/tlaplus/tlaplus18.nix { };
  tlaps = callPackage ../applications/science/logic/tlaplus/tlaps.nix {
    inherit (ocaml-ng.ocamlPackages_4_14_unsafe_string) ocaml;
  };
  tlaplusToolbox = callPackage ../applications/science/logic/tlaplus/toolbox.nix { };

  avy = callPackage ../applications/science/logic/avy { };

  ### SCIENCE / ENGINEERING

  ### SCIENCE / ELECTRONICS

  appcsxcad = libsForQt5.callPackage ../applications/science/electronics/appcsxcad { };

  simulide_0_4_15 = callPackage ../by-name/si/simulide/package.nix { versionNum = "0.4.15"; };
  simulide_1_0_0 = callPackage ../by-name/si/simulide/package.nix { versionNum = "1.0.0"; };
  simulide_1_1_0 = callPackage ../by-name/si/simulide/package.nix { versionNum = "1.1.0"; };
  simulide_1_2_0 = callPackage ../by-name/si/simulide/package.nix { versionNum = "1.2.0"; };

  eagle = libsForQt5.callPackage ../applications/science/electronics/eagle/eagle.nix { };

  caneda = libsForQt5.callPackage ../applications/science/electronics/caneda { };

  degate = libsForQt5.callPackage ../applications/science/electronics/degate { };

  geda = callPackage ../applications/science/electronics/geda {
    guile = guile_2_2;
  };

  gerbv = callPackage ../applications/science/electronics/gerbv {
    cairo = cairo.override { x11Support = true; };
  };

  # this is a wrapper for kicad.base and kicad.libraries
  kicad = callPackage ../applications/science/electronics/kicad { };
  # this is the same but without the (sizable) 3D models library
  kicad-small = kicad.override {
    pname = "kicad-small";
    with3d = false;
  };
  # this is the stable branch at whatever point update.sh last updated versions.nix
  kicad-testing = kicad.override {
    pname = "kicad-testing";
    testing = true;
  };
  # and a small version of that
  kicad-testing-small = kicad.override {
    pname = "kicad-testing-small";
    testing = true;
    with3d = false;
  };
  # this is the master branch at whatever point update.sh last updated versions.nix
  kicad-unstable = kicad.override {
    pname = "kicad-unstable";
    stable = false;
  };
  # and a small version of that
  kicad-unstable-small = kicad.override {
    pname = "kicad-unstable-small";
    stable = false;
    with3d = false;
  };

  kicadAddons = recurseIntoAttrs (callPackage ../applications/science/electronics/kicad/addons { });

  librepcb = qt6Packages.callPackage ../applications/science/electronics/librepcb { };

  ngspice = libngspice.override {
    withNgshared = false;
  };

  openems = callPackage ../applications/science/electronics/openems {
    qcsxcad = libsForQt5.qcsxcad;
  };

  qucs-s = qt6Packages.callPackage ../applications/science/electronics/qucs-s { };

  xyce-parallel = callPackage ../by-name/xy/xyce/package.nix {
    withMPI = true;
    trilinos = trilinos-mpi;
  };

  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe (
    {
      opencv4 = opencv4WithoutCuda; # Used only for image loading.
      blas = openblas;
    }
    // (config.caffe or { })
  );

  gap-minimal = lowPrio (gap.override { packageSet = "minimal"; });

  gap-full = lowPrio (gap.override { packageSet = "full"; });

  geogebra = callPackage ../applications/science/math/geogebra { };
  geogebra6 = callPackage ../applications/science/math/geogebra/geogebra6.nix { };

  maxima = callPackage ../applications/science/math/maxima {
    lisp-compiler = sbcl;
  };
  maxima-ecl = maxima.override {
    lisp-compiler = ecl;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  pari = callPackage ../applications/science/math/pari { };
  gp2c = callPackage ../applications/science/math/pari/gp2c.nix { };

  raspa = callPackage ../applications/science/molecular-dynamics/raspa { };

  raspa-data = callPackage ../applications/science/molecular-dynamics/raspa/data.nix { };

  weka = callPackage ../applications/science/math/weka { jre = openjdk11; };

  yacas = libsForQt5.callPackage ../applications/science/math/yacas { };

  yacas-gui = yacas.override {
    enableGui = true;
    enableJupyter = false;
  };

  speedcrunch = libsForQt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  boinc-headless = callPackage ../applications/science/misc/boinc { headless = true; };

  celestia = callPackage ../applications/science/astronomy/celestia {
    autoreconfHook = buildPackages.autoreconfHook269;
    inherit (gnome2) gtkglext;
  };

  convertall = qt5.callPackage ../applications/science/misc/convertall { };

  cytoscape = callPackage ../applications/science/misc/cytoscape {
    jre = openjdk17;
  };

  faissWithCuda = faiss.override {
    cudaSupport = true;
  };

  gplates = libsForQt5.callPackage ../applications/science/misc/gplates { };

  golly = callPackage ../applications/science/misc/golly {
    wxGTK = wxGTK32;
  };

  megam = callPackage ../applications/science/misc/megam {
    inherit (ocaml-ng.ocamlPackages_4_14) ocaml;
  };

  ns-3 = callPackage ../development/libraries/science/networking/ns-3 { };

  spyder = with python3.pkgs; toPythonApplication spyder;

  stellarium = qt6Packages.callPackage ../applications/science/astronomy/stellarium { };

  tulip = libsForQt5.callPackage ../applications/science/misc/tulip { };

  vite = libsForQt5.callPackage ../applications/science/misc/vite { };

  ### SCIENCE / PHYSICS

  hepmc3 = callPackage ../development/libraries/physics/hepmc3 {
    python = null;
  };

  lhapdf = callPackage ../development/libraries/physics/lhapdf { };

  pythia = callPackage ../development/libraries/physics/pythia {
    hepmc = hepmc2;
  };

  yoda-with-root = lowPrio (
    yoda.override {
      withRootSupport = true;
    }
  );

  ### SCIENCE/ROBOTICS

  apmplanner2 = libsForQt5.callPackage ../applications/science/robotics/apmplanner2 { };

  ### MISC

  android-file-transfer = libsForQt5.callPackage ../tools/filesystems/android-file-transfer { };

  antimicrox = libsForQt5.callPackage ../tools/misc/antimicrox { };

  autotiling = python3Packages.callPackage ../misc/autotiling { };

  avell-unofficial-control-center =
    callPackage ../applications/misc/avell-unofficial-control-center
      { };

  brgenml1lpr = pkgsi686Linux.callPackage ../misc/cups/drivers/brgenml1lpr { };

  cups = callPackage ../misc/cups { };

  cups-filters = callPackage ../misc/cups/filters.nix { };

  cups-pk-helper = callPackage ../misc/cups/cups-pk-helper.nix { };

  epsonscan2 = callPackage ../by-name/ep/epsonscan2/package.nix {
    inherit (qt5) wrapQtAppsHook qtbase;
  };

  foomatic-db-ppds-withNonfreeDb = callPackage ../by-name/fo/foomatic-db-ppds/package.nix {
    withNonfreeDb = true;
  };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  dcp375cwlpr = (pkgsi686Linux.callPackage ../misc/cups/drivers/brother/dcp375cw { }).driver;

  dcp375cw-cupswrapper = (callPackage ../misc/cups/drivers/brother/dcp375cw { }).cupswrapper;

  dcp9020cdwlpr = (pkgsi686Linux.callPackage ../misc/cups/drivers/brother/dcp9020cdw { }).driver;

  dcp9020cdw-cupswrapper = (callPackage ../misc/cups/drivers/brother/dcp9020cdw { }).cupswrapper;

  cups-brother-hl1110 = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1110 { };

  cups-brother-hl1210w = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1210w { };

  cups-brother-hl2260d = pkgsi686Linux.callPackage ../misc/cups/drivers/hl2260d { };

  cups-brother-hl3140cw = pkgsi686Linux.callPackage ../misc/cups/drivers/hl3140cw { };

  cups-brother-hll2340dw = pkgsi686Linux.callPackage ../misc/cups/drivers/hll2340dw { };

  cups-brother-hll3230cdw = pkgsi686Linux.callPackage ../misc/cups/drivers/hll3230cdw { };

  # this driver ships with pre-compiled 32-bit binary libraries
  cnijfilter_2_80 = pkgsi686Linux.callPackage ../misc/cups/drivers/cnijfilter_2_80 { };

  faust = faust2;

  flashprint = libsForQt5.callPackage ../applications/misc/flashprint { };

  fahclient = callPackage ../applications/science/misc/foldingathome/client.nix { };

  gajim = callPackage ../applications/networking/instant-messengers/gajim {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-libav;
    gst-plugins-good = gst_all_1.gst-plugins-good.override { gtkSupport = true; };
  };

  ghostscriptX = ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  };

  ghostscript_headless = ghostscript.override {
    cupsSupport = false;
    x11Support = false;
  };

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  gotrue = callPackage ../tools/security/gotrue { };

  gotrue-supabase = callPackage ../tools/security/gotrue/supabase.nix { };

  gowitness = callPackage ../tools/security/gowitness {
    buildGoModule = buildGo123Module;
  };

  helmfile = callPackage ../applications/networking/cluster/helmfile { };

  helmfile-wrapped = callPackage ../applications/networking/cluster/helmfile {
    inherit (kubernetes-helm-wrapped.passthru) pluginsDir;
  };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hjson = with python3Packages; toPythonApplication hjson;

  epkowa = callPackage ../misc/drivers/epkowa { };

  utsushi = callPackage ../misc/drivers/utsushi { };

  utsushi-networkscan = callPackage ../misc/drivers/utsushi/networkscan.nix { };

  lima = callPackage ../applications/virtualization/lima {
    inherit (darwin) sigtool;
  };

  lima-bin = callPackage ../applications/virtualization/lima/bin.nix { };

  image_optim = callPackage ../applications/graphics/image_optim { inherit (nodePackages) svgo; };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2 = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
  };

  libjack2 = jack2.override { prefix = "lib"; };

  jack-example-tools = callPackage ../misc/jackaudio/tools.nix {
    libopus = libopus.override { withCustomModes = true; };
    jack = jack2;
  };

  jack-autoconnect = libsForQt5.callPackage ../applications/audio/jack-autoconnect { };
  jack_autoconnect = jack-autoconnect;

  j2cli = with python311Packages; toPythonApplication j2cli;

  kmonad = haskellPackages.kmonad.bin;

  kompute = callPackage ../development/libraries/kompute {
    fmt = fmt_10;
  };

  # In general we only want keep the last three minor versions around that
  # correspond to the last three supported kubernetes versions:
  # https://kubernetes.io/docs/setup/release/version-skew-policy/#supported-versions
  # Exceptions are versions that we need to keep to allow upgrades from older NixOS releases
  inherit (callPackage ../applications/networking/cluster/kops { })
    mkKops
    kops_1_27
    kops_1_28
    kops_1_29
    kops_1_30
    ;
  kops = kops_1_29;

  lilypond = callPackage ../misc/lilypond { };

  lilypond-unstable = callPackage ../misc/lilypond/unstable.nix { };

  lilypond-unstable-with-fonts = callPackage ../misc/lilypond/with-fonts.nix {
    lilypond = lilypond-unstable;
    openlilylib-fonts = openlilylib-fonts.override {
      lilypond = lilypond-unstable;
    };
  };

  lilypond-with-fonts = callPackage ../misc/lilypond/with-fonts.nix { };

  openlilylib-fonts = callPackage ../misc/lilypond/fonts.nix { };

  meilisearch_1_11 = callPackage ../by-name/me/meilisearch/package.nix { version = "1.11.3"; };

  mongocxx = callPackage ../development/libraries/mongocxx/default.nix { };

  muse = libsForQt5.callPackage ../applications/audio/muse { };

  nixDependencies = recurseIntoAttrs (
    callPackage ../tools/package-management/nix/dependencies-scope.nix { }
  );

  nixVersions = recurseIntoAttrs (
    callPackage ../tools/package-management/nix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
    }
  );

  nix = nixVersions.stable;

  # Overlays for CppNix nightly, Lix, or Tvix want to change the default Nix
  # implementation in Nixpkgs by overriding `pkgs.nix`. However, some packages
  # link against the internal/unstable CppNix APIs directly, and these packages
  # will break if built with different versions or implementations of Nix.
  #
  # If you want to swap out the Nix implementation in your package set, you
  # don't want these packages to break. Therefore, some packages will refer to
  # `nixForLinking` explicitly, at least until these dependencies can be sorted out.
  nixForLinking = nixVersions.stable;

  nixStatic = pkgsStatic.nix;

  lixPackageSets = recurseIntoAttrs (
    callPackage ../tools/package-management/lix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
    }
  );

  lix = lixPackageSets.stable.lix;

  lixStatic = pkgsStatic.lix;

  inherit (callPackages ../applications/networking/cluster/nixops { })
    nixops_unstable_minimal

    # Not recommended; too fragile
    nixops_unstable_full
    ;

  # Useful with ofborg, e.g. commit prefix `nixops_unstablePlugins.nixops-digitalocean: ...` to trigger automatically.
  nixops_unstablePlugins = recurseIntoAttrs nixops_unstable_minimal.availablePlugins;

  /*
    Evaluate a NixOS configuration using this evaluation of Nixpkgs.

    With this function you can write, for example, a package that
    depends on a custom virtual machine image.

    Parameter:  A module, path or list of those that represent the
                configuration of the NixOS system to be constructed.

    Result: An attribute set containing packages produced by this
            evaluation of NixOS, such as toplevel, kernel and
            initialRamdisk.
            The result can be extended in the modules by defining
            extra attributes in system.build.
            Alternatively, you may use the result's config and
            options attributes to query any option.

    Example:

        let
          myOS = pkgs.nixos ({ lib, pkgs, config, ... }: {

            config.services.nginx = {
              enable = true;
              # ...
            };

            # Use config.system.build to exports relevant parts of a
            # configuration. The runner attribute should not be
            # considered a fully general replacement for systemd
            # functionality.
            config.system.build.run-nginx = config.systemd.services.nginx.runner;
          });
        in
          myOS.run-nginx

    Unlike in plain NixOS, the nixpkgs.config and
    nixpkgs.system options will be ignored by default. Instead,
    nixpkgs.pkgs will have the default value of pkgs as it was
    constructed right after invoking the nixpkgs function (e.g. the
    value of import <nixpkgs> { overlays = [./my-overlay.nix]; }
    but not the value of (import <nixpkgs> {} // { extra = ...; }).

    If you do want to use the config.nixpkgs options, you are
    probably better off by calling nixos/lib/eval-config.nix
    directly, even though it is possible to set config.nixpkgs.pkgs.

    For more information about writing NixOS modules, see
    https://nixos.org/nixos/manual/index.html#sec-writing-modules

    Note that you will need to have called Nixpkgs with the system
    parameter set to the right value for your deployment target.
  */
  nixos =
    configuration:
    let
      c = import (path + "/nixos/lib/eval-config.nix") {
        modules = [
          (
            { lib, ... }:
            {
              config.nixpkgs.pkgs = lib.mkDefault pkgs;
              config.nixpkgs.localSystem = lib.mkDefault stdenv.hostPlatform;
            }
          )
        ]
        ++ (if builtins.isList configuration then configuration else [ configuration ]);

        # The system is inherited from the current pkgs above.
        # Set it to null, to remove the "legacy" entrypoint's non-hermetic default.
        system = null;
      };
    in
    c.config.system.build // c;

  # A NixOS/home-manager/arion/... module that sets the `pkgs` module argument.
  pkgsModule =
    { options, ... }:
    {
      config =
        if options ? nixpkgs.pkgs then
          {
            # legacy / nixpkgs.nix style
            nixpkgs.pkgs = pkgs;
          }
        else
          {
            # minimal
            _module.args.pkgs = pkgs;
          };
    };

  nixosOptionsDoc = attrs: (import ../../nixos/lib/make-options-doc) ({ inherit pkgs lib; } // attrs);

  nix-eval-jobs = callPackage ../tools/package-management/nix-eval-jobs {
    nix = nixVersions.nix_2_28;
  };

  nix-delegate = haskell.lib.compose.justStaticExecutables haskellPackages.nix-delegate;
  nix-deploy = haskell.lib.compose.justStaticExecutables haskellPackages.nix-deploy;
  nix-derivation = haskell.lib.compose.justStaticExecutables haskellPackages.nix-derivation;
  nix-diff = haskell.lib.compose.justStaticExecutables haskellPackages.nix-diff;

  nix-info = callPackage ../tools/nix/info { };
  nix-info-tested = nix-info.override { doCheck = true; };

  nix-index-unwrapped = callPackage ../tools/package-management/nix-index { };
  nix-index = callPackage ../tools/package-management/nix-index/wrapper.nix { };

  nix-linter = haskell.lib.compose.justStaticExecutables (haskellPackages.nix-linter);

  nix-pin = callPackage ../tools/package-management/nix-pin { };

  nix-prefetch-github = with python3Packages; toPythonApplication nix-prefetch-github;

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts
    ;

  nix-update-source = callPackage ../tools/package-management/nix-update-source { };

  nix-tree = haskell.lib.compose.justStaticExecutables (haskellPackages.nix-tree);

  nix-serve-ng = haskell.lib.compose.justStaticExecutables haskellPackages.nix-serve-ng;

  nix-visualize = python3.pkgs.callPackage ../tools/package-management/nix-visualize { };

  nixfmt-classic = haskellPackages.nixfmt.bin;

  nixpkgs-manual = callPackage ../../doc/doc-support/package.nix { };

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };
  nixos-icons = callPackage ../data/misc/nixos-artwork/icons.nix { };
  nixos-grub2-theme = callPackage ../data/misc/nixos-artwork/grub2-theme.nix { };

  nixos-rebuild = callPackage ../os-specific/linux/nixos-rebuild { };

  disnix = callPackage ../tools/package-management/disnix { };

  dysnomia = callPackage ../tools/package-management/disnix/dysnomia (
    config.disnix or {
      inherit (python3Packages) supervisor;
    }
  );

  DisnixWebService = callPackage ../tools/package-management/disnix/DisnixWebService {
    jdk = jdk8;
  };

  lice = python3Packages.callPackage ../tools/misc/lice { };

  mysql-workbench = callPackage ../by-name/my/mysql-workbench/package.nix (
    let
      mysql = mysql80;
    in
    {
      gdal = gdal.override {
        libmysqlclient = mysql;
      };
      mysql = mysql;
    }
  );

  resp-app = libsForQt5.callPackage ../applications/misc/resp-app { };

  pgadmin4-desktopmode = pgadmin4.override { server-mode = false; };

  pgmodeler = qt6Packages.callPackage ../applications/misc/pgmodeler { };

  philipstv = with python3Packages; toPythonApplication philipstv;

  pyupgrade = with python3Packages; toPythonApplication pyupgrade;

  pwntools = with python3Packages; toPythonApplication pwntools;

  putty = callPackage ../applications/networking/remote/putty {
    gtk3 = if stdenv.hostPlatform.isDarwin then gtk3-x11 else gtk3;
  };

  qMasterPassword = qt6Packages.callPackage ../applications/misc/qMasterPassword { };

  qMasterPassword-wayland = qt6Packages.callPackage ../applications/misc/qMasterPassword {
    x11Support = false;
    waylandSupport = true;
  };

  qmake2cmake = python3Packages.callPackage ../tools/misc/qmake2cmake { };

  qtrvsim = libsForQt5.callPackage ../applications/science/computer-architecture/qtrvsim { };

  pick-colour-picker = callPackage ../applications/graphics/pick-colour-picker { };

  romdirfs = callPackage ../tools/filesystems/romdirfs {
    stdenv = gccStdenv;
  };

  sail-riscv = callPackage ../applications/virtualization/sail-riscv {
    inherit (ocamlPackages) sail;
  };

  mfcj470dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj6510dwlpr { };

  mfcl2700dnlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcl2700dnlpr { };

  # This driver is only available as a 32 bit proprietary binary driver
  mfcl3770cdwlpr = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw { }).driver;
  mfcl3770cdwcupswrapper = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw { }).cupswrapper;

  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung/1.00.37.nix { };
  samsung-unified-linux-driver_4_01_17 = callPackage ../misc/cups/drivers/samsung/4.01.17.nix { };
  samsung-unified-linux-driver = res.samsung-unified-linux-driver_4_01_17;

  sane-backends = callPackage ../applications/graphics/sane/backends (config.sane or { });

  sane-drivers = callPackage ../applications/graphics/sane/drivers.nix { };

  mkSaneConfig = callPackage ../applications/graphics/sane/config.nix { };

  sane-frontends = callPackage ../applications/graphics/sane/frontends.nix { };

  slock = callPackage ../misc/screensavers/slock {
    conf = config.slock.conf or null;
  };

  snscrape = with python3Packages; toPythonApplication snscrape;

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  tellico = libsForQt5.callPackage ../applications/misc/tellico { };

  termpdfpy = python3Packages.callPackage ../applications/misc/termpdf.py { };

  inherit (callPackage ../applications/networking/cluster/terraform { })
    mkTerraform
    terraform_1
    terraform_plugins_test
    ;

  terraform = terraform_1;

  terraform-providers = recurseIntoAttrs (
    callPackage ../applications/networking/cluster/terraform-providers { }
  );

  terraforming = callPackage ../applications/networking/cluster/terraforming { };

  terraform-landscape = callPackage ../applications/networking/cluster/terraform-landscape { };

  trufflehog = callPackage ../tools/security/trufflehog {
    buildGoModule = buildGo123Module;
  };

  unityhub = callPackage ../development/tools/unityhub { };

  vaultenv = haskell.lib.justStaticExecutables haskellPackages.vaultenv;

  vaultwarden-sqlite = vaultwarden;
  vaultwarden-mysql = vaultwarden.override { dbBackend = "mysql"; };
  vaultwarden-postgresql = vaultwarden.override { dbBackend = "postgresql"; };

  vimUtils = callPackage ../applications/editors/vim/plugins/utils/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../applications/editors/vim/plugins { });

  vimb = wrapFirefox vimb-unwrapped { };

  vivisect = with python3Packages; toPythonApplication (vivisect.override { withGui = true; });

  vokoscreen = libsForQt5.callPackage ../applications/video/vokoscreen {
    ffmpeg = ffmpeg-full;
  };

  wacomtablet = libsForQt5.callPackage ../tools/misc/wacomtablet { };

  wasmer = callPackage ../development/interpreters/wasmer {
    llvmPackages = llvmPackages_18;
  };

  wavm = callPackage ../development/interpreters/wavm {
    llvmPackages = llvmPackages_12;
  };

  webkit2-sharp = callPackage ../development/libraries/webkit2-sharp {
    webkitgtk = webkitgtk_4_0;
  };

  wibo = pkgsi686Linux.callPackage ../applications/emulators/wibo { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  winePackagesFor =
    wineBuild:
    lib.makeExtensible (
      self: with self; {
        callPackage = newScope self;

        inherit wineBuild;

        inherit (callPackage ./wine-packages.nix { })
          minimal
          base
          full
          stable
          stableFull
          unstable
          unstableFull
          staging
          stagingFull
          wayland
          waylandFull
          yabridge
          fonts
          ;
      }
    );

  winePackages = recurseIntoAttrs (winePackagesFor (config.wine.build or "wine32"));
  wine64Packages = recurseIntoAttrs (winePackagesFor "wine64");
  wineWowPackages = recurseIntoAttrs (winePackagesFor "wineWow");
  wineWow64Packages = recurseIntoAttrs (winePackagesFor "wineWow64");

  wine = winePackages.full;
  wine64 = wine64Packages.full;

  wine-staging = lowPrio (
    winePackages.full.override {
      wineRelease = "staging";
    }
  );

  wine-wayland = lowPrio (
    winePackages.full.override {
      x11Support = false;
    }
  );

  inherit (callPackage ../servers/web-apps/wordpress { })
    wordpress
    wordpress_6_7
    wordpress_6_8
    ;

  wordpressPackages = recurseIntoAttrs (
    callPackage ../servers/web-apps/wordpress/packages {
      plugins = lib.importJSON ../servers/web-apps/wordpress/packages/plugins.json;
      themes = lib.importJSON ../servers/web-apps/wordpress/packages/themes.json;
      languages = lib.importJSON ../servers/web-apps/wordpress/packages/languages.json;
    }
  );

  wraith = callPackage ../applications/networking/irc/wraith {
    openssl = openssl_1_1;
  };

  xsane = callPackage ../applications/graphics/sane/xsane.nix { };

  xsw = callPackage ../applications/misc/xsw {
    # Enable the next line to use this in terminal.
    # Note that it requires sixel capable terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
    SDL_gfx = SDL_gfx.override { SDL = SDL_sixel; };
    SDL_image = SDL_image.override { SDL = SDL_sixel; };
    SDL_ttf = SDL_ttf.override { SDL = SDL_sixel; };
  };

  yacreader = callPackage ../applications/graphics/yacreader { };

  yamale = with python3Packages; toPythonApplication yamale;

  zap-chip-gui = zap-chip.override { withGui = true; };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (callPackage ../applications/networking/znc/modules.nix { });

  bullet = callPackage ../development/libraries/bullet { };

  bullet-roboschool = callPackage ../development/libraries/bullet/roboschool-fork.nix { };

  dart = callPackage ../development/compilers/dart { };

  pub2nix = recurseIntoAttrs (callPackage ../build-support/dart/pub2nix { });

  buildDartApplication = callPackage ../build-support/dart/build-dart-application { };

  dartHooks = callPackage ../build-support/dart/build-dart-application/hooks { };

  httrack = callPackage ../tools/backup/httrack { };

  httraqt = libsForQt5.callPackage ../tools/backup/httrack/qt.nix { };

  # Overriding does not work when using callPackage on discord using import instead. (https://github.com/NixOS/nixpkgs/pull/179906)
  discord = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "stable";
  };

  discord-ptb = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "ptb";
  };

  discord-canary = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "canary";
  };

  discord-development = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "development";
  };

  discord-screenaudio =
    qt6Packages.callPackage ../applications/networking/instant-messengers/discord-screenaudio
      { };

  discordo = callPackage ../applications/networking/discordo/default.nix { };

  tomb = callPackage ../by-name/to/tomb/package.nix {
    pinentry = pinentry-curses;
  };

  maphosts = callPackage ../tools/networking/maphosts { };

  tora = libsForQt5.callPackage ../development/tools/tora { };

  nitrokey-app = libsForQt5.callPackage ../tools/security/nitrokey-app { };

  nitrokey-app2 = qt6Packages.callPackage ../tools/security/nitrokey-app2 { };

  hy = with python3Packages; toPythonApplication hy;

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { };

  vdr = callPackage ../applications/video/vdr { };
  vdrPlugins = recurseIntoAttrs (callPackage ../applications/video/vdr/plugins.nix { });
  wrapVdr = callPackage ../applications/video/vdr/wrapper.nix { };

  chrome-token-signing = libsForQt5.callPackage ../tools/security/chrome-token-signing { };

  linode-cli = python3Packages.callPackage ../tools/virtualization/linode-cli { };

  phonetisaurus = callPackage ../development/libraries/phonetisaurus {
    # https://github.com/AdolfVonKleist/Phonetisaurus/issues/70
    openfst = openfst.overrideAttrs rec {
      version = "1.7.9";
      src = fetchurl {
        url = "http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${version}.tar.gz";
        hash = "sha256-kxmusx0eKVCuJUSYhOJVzCvJ36+Yf2AVkHY+YaEPvd4=";
      };
    };
  };

  compressDrv = callPackage ../build-support/compress-drv { };

  compressDrvWeb = callPackage ../build-support/compress-drv/web.nix { };

  dnstracer = callPackage ../tools/networking/dnstracer {
    inherit (darwin) libresolv;
  };

  diceware = with python3Packages; toPythonApplication diceware;

  xml2rfc = with python3Packages; toPythonApplication xml2rfc;

  ape = callPackage ../applications/misc/ape { };
  attemptoClex = callPackage ../applications/misc/ape/clex.nix { };
  apeClex = callPackage ../applications/misc/ape/apeclex.nix { };

  # Unix tools
  unixtools = recurseIntoAttrs (callPackages ./unixtools.nix { });
  inherit (unixtools)
    hexdump
    ps
    logger
    eject
    umount
    mount
    wall
    hostname
    more
    sysctl
    getconf
    getent
    locale
    killall
    xxd
    watch
    ;

  fts = if stdenv.hostPlatform.isMusl then musl-fts else null;

  bsdSetupHook = makeSetupHook {
    name = "bsd-setup-hook";
  } ../os-specific/bsd/setup-hook.sh;

  freebsd = callPackage ../os-specific/bsd/freebsd { };

  netbsd = callPackage ../os-specific/bsd/netbsd { };

  openbsd = callPackage ../os-specific/bsd/openbsd { };

  bcompare = libsForQt5.callPackage ../applications/version-management/bcompare { };

  xp-pen-deco-01-v2-driver = libsForQt5.xp-pen-deco-01-v2-driver;

  xp-pen-g430-driver = libsForQt5.xp-pen-g430-driver;

  newlib = callPackage ../development/misc/newlib {
    stdenv = stdenvNoLibc;
  };

  newlib-nano = callPackage ../development/misc/newlib {
    stdenv = stdenvNoLibc;
    nanoizeNewlib = true;
  };

  wfuzz = with python3Packages; toPythonApplication wfuzz;

  kodelife = callPackage ../applications/graphics/kodelife {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  sieveshell = with python3.pkgs; toPythonApplication managesieve;

  jami = qt6Packages.callPackage ../applications/networking/instant-messengers/jami {
    # TODO: remove once `udev` is `systemdMinimal` everywhere.
    udev = systemdMinimal;
    jack = libjack2;
  };

  gpio-utils = callPackage ../os-specific/linux/kernel/gpio-utils.nix { };

  inherit (callPackage ../applications/misc/zettlr { }) zettlr;

  zrythm = callPackage ../applications/audio/zrythm {
    inherit (plasma5Packages) breeze-icons;
  };

  swift-corelibs-libdispatch = swiftPackages.Dispatch;

  aitrack = libsForQt5.callPackage ../applications/misc/aitrack { };

  tidal-dl = python3Packages.callPackage ../tools/audio/tidal-dl { };

  tubekit = callPackage ../applications/networking/cluster/tubekit/wrapper.nix { };

  tubekit-unwrapped = callPackage ../applications/networking/cluster/tubekit { };

  duden = python3Packages.toPythonApplication python3Packages.duden;

  yaziPlugins = recurseIntoAttrs (callPackage ../by-name/ya/yazi/plugins { });

  dillo = callPackage ../by-name/di/dillo/package.nix {
    fltk = fltk13;
  };

  cantata = callPackage ../by-name/ca/cantata/package.nix {
    ffmpeg = ffmpeg_6;
  };

  libkazv = callPackage ../by-name/li/libkazv/package.nix {
    libcpr = libcpr_1_10_5;
  };

  tree-from-tags = callPackage ../by-name/tr/tree-from-tags/package.nix {
    ruby = ruby_3_1;
  };

  biblioteca = callPackage ../by-name/bi/biblioteca/package.nix {
    webkitgtk = webkitgtk_6_0;
  };

  libpostalWithData = callPackage ../by-name/li/libpostal/package.nix {
    withData = true;
  };

  clash-verge-rev = callPackage ../by-name/cl/clash-verge-rev/package.nix {
    libsoup = libsoup_3;
  };

  rustdesk-flutter = callPackage ../by-name/ru/rustdesk-flutter/package.nix {
    flutter = flutter324;
  };

  vips_8_17 = callPackage ../by-name/vi/vips/8_17.nix { };
}
