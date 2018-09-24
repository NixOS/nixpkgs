/* The top-level package collection of nixpkgs.
 * It is sorted by categories corresponding to the folder names
 * in the /pkgs folder. Inside the categories packages are roughly
 * sorted by alphabet, but strict sorting has been long lost due
 * to merges. Please use the full-text search of your editor. ;)
 * Hint: ### starts category names.
 */
{ lib, noSysDirs, config}:
self: pkgs:

with pkgs;

{

  # Allow callPackage to fill in the pkgs argument
  inherit pkgs;

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (if stdenv.hostPlatform.is32bit then stdenv else multiStdenv);

  stdenvNoCC = stdenv.override { cc = null; };

  stdenvNoLibs = let
    bintools = stdenv.cc.bintools.override {
      libc = null;
      noLibc = true;
    };
  in stdenv.override {
    cc = stdenv.cc.override {
      libc = null;
      noLibc = true;
      extraPackages = [];
      inherit bintools;
    };
    allowedRequisites =
      lib.mapNullable (rs: rs ++ [ bintools ]) (stdenv.allowedRequisites or null);
  };

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Helper functions.
  inherit lib config;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  stringsWithDeps = lib.stringsWithDeps;

  ### Evaluating the entire Nixpkgs naively will fail, make failure fast
  AAAAAASomeThingsFailToEvaluate = throw ''
    Please be informed that this pseudo-package is not the only part of
    Nixpkgs that fails to evaluate. You should not evaluate entire Nixpkgs
    without some special measures to handle failing packages, like those taken
    by Hydra.
  '';

  tests = recurseIntoAttrs (callPackages ../test {});

  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };

  common-updater-scripts = callPackage ../common-updater/scripts.nix { };

  ### BUILD SUPPORT

  autoreconfHook = makeSetupHook
    { deps = [ autoconf automake gettext libtool ]; }
    ../build-support/setup-hooks/autoreconf.sh;

  autoreconfHook264 = makeSetupHook
    { deps = [ autoconf264 automake111x gettext libtool ]; }
    ../build-support/setup-hooks/autoreconf.sh;

  autoPatchelfHook = makeSetupHook
    { name = "auto-patchelf-hook"; deps = [ file ]; }
    ../build-support/setup-hooks/auto-patchelf.sh;

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        '${findutils}/bin/find' "$sourceRoot" \
          '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  # Zip file format only allows times after year 1980, which makes e.g. Python wheel building fail with:
  # ValueError: ZIP does not support timestamps before 1980
  ensureNewerSourcesForZipFilesHook = ensureNewerSourcesHook { year = "1980"; };

  updateAutotoolsGnuConfigScriptsHook = makeSetupHook
    { substitutions = { gnu_config = gnu-config;}; }
    ../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh;

  gogUnpackHook = makeSetupHook {
    name = "gog-unpack-hook";
    deps = [ innoextract file-rename ]; }
    ../build-support/setup-hooks/gog-unpack.sh;

  buildEnv = callPackage ../build-support/buildenv { }; # not actually a package

  buildFHSUserEnv = callPackage ../build-support/build-fhs-userenv { };

  buildMaven = callPackage ../build-support/build-maven.nix {};

  castxml = callPackage ../development/tools/castxml { };

  cmark = callPackage ../development/libraries/cmark { };

  corgi = callPackage ../development/tools/corgi { };

  dhallToNix = callPackage ../build-support/dhall-to-nix.nix {
    inherit dhall-nix;
  };

  diffPlugins = (callPackage ../build-support/plugins.nix {}).diffPlugins;

  dieHook = makeSetupHook {} ../build-support/setup-hooks/die.sh;

  digitalbitbox = libsForQt5.callPackage ../applications/misc/digitalbitbox { };

  dockerTools = callPackage ../build-support/docker { };

  docker_compose = pythonPackages.docker_compose;

  docker-ls = callPackage ../tools/misc/docker-ls { };

  dotfiles = callPackage ../applications/misc/dotfiles { };

  dotnetenv = callPackage ../build-support/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  dotnetbuildhelpers = callPackage ../build-support/dotnetbuildhelpers { };

  dotnet-sdk = callPackage ../development/compilers/dotnet/sdk { };

  dispad = callPackage ../tools/X11/dispad { };

  dump1090 = callPackage ../applications/misc/dump1090 { };

  ebook2cw = callPackage ../applications/misc/ebook2cw { };

  etBook = callPackage ../data/fonts/et-book { };

  fetchbower = callPackage ../build-support/fetchbower {
    inherit (nodePackages) bower2nix;
  };

  fetchbzr = callPackage ../build-support/fetchbzr { };

  fetchcvs = callPackage ../build-support/fetchcvs { };

  fetchdarcs = callPackage ../build-support/fetchdarcs { };

  fetchdocker = callPackage ../build-support/fetchdocker { };

  fetchDockerConfig = callPackage ../build-support/fetchdocker/fetchDockerConfig.nix { };

  fetchDockerLayer = callPackage ../build-support/fetchdocker/fetchDockerLayer.nix { };

  fetchfossil = callPackage ../build-support/fetchfossil { };

  fetchgit = callPackage ../build-support/fetchgit {
    git = gitMinimal;
  };

  fetchgitPrivate = callPackage ../build-support/fetchgit/private.nix { };

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  fetchMavenArtifact = callPackage ../build-support/fetchmavenartifact { };

  global-platform-pro = callPackage ../development/tools/global-platform-pro/default.nix { };

  graph-easy = callPackage ../tools/graphics/graph-easy { };

  packer = callPackage ../development/tools/packer { };

  pet = callPackage ../development/tools/pet { };

  mht2htm = callPackage ../tools/misc/mht2htm { };

  fetchpatch = callPackage ../build-support/fetchpatch { };

  fetchs3 = callPackage ../build-support/fetchs3 { };

  fetchsvn = callPackage ../build-support/fetchsvn {
    sshSupport = true;
  };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchsvnssh = callPackage ../build-support/fetchsvnssh {
    sshSupport = true;
  };

  fetchhg = callPackage ../build-support/fetchhg { };

  # `fetchurl' downloads a file from the network.
  fetchurl = import ../build-support/fetchurl {
    inherit lib stdenvNoCC;
    # On darwin, libkrb5 needs bootstrap_cmds which would require
    # converting many packages to fetchurl_boot to avoid evaluation cycles.
    curl = buildPackages.curl.override (lib.optionalAttrs stdenv.isDarwin { gssSupport = false; });
  };

  fetchRepoProject = callPackage ../build-support/fetchrepoproject { };

  fetchipfs = import ../build-support/fetchipfs {
    inherit curl stdenv;
  };

  # fetchurlBoot is used for curl and its dependencies in order to
  # prevent a cyclic dependency (curl depends on curl.tar.bz2,
  # curl.tar.bz2 depends on fetchurl, fetchurl depends on curl).  It
  # uses the curl from the previous bootstrap phase (e.g. a statically
  # linked curl in the case of stdenv-linux).
  fetchurlBoot = stdenv.fetchurlBoot;

  fetchzip = callPackage ../build-support/fetchzip { };

  fetchCrate = callPackage ../build-support/rust/fetchcrate.nix { };

  fetchFromGitHub = {
    owner, repo, rev, name ? "source",
    fetchSubmodules ? false, private ? false,
    githubBase ? "github.com", varPrefix ? null,
    ... # For hash agility
  }@args: assert private -> !fetchSubmodules;
  let
    baseUrl = "https://${githubBase}/${owner}/${repo}";
    passthruAttrs = removeAttrs args [ "owner" "repo" "rev" "fetchSubmodules" "private" "githubBase" "varPrefix" ];
    varBase = "NIX${if varPrefix == null then "" else "_${varPrefix}"}_GITHUB_PRIVATE_";
    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetcher = if fetchSubmodules then fetchgit else fetchzip;
    privateAttrs = lib.optionalAttrs private {
      netrcPhase = ''
        if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
          echo "Error: Private fetchFromGitHub requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
          exit 1
        fi
        cat > netrc <<EOF
        machine ${githubBase}
                login ''$${varBase}USERNAME
                password ''$${varBase}PASSWORD
        EOF
      '';
      netrcImpureEnvVars = [ "${varBase}USERNAME" "${varBase}PASSWORD" ];
    };
    fetcherArgs = (if fetchSubmodules
        then { inherit rev fetchSubmodules; url = "${baseUrl}.git"; }
        else ({ url = "${baseUrl}/archive/${rev}.tar.gz"; } // privateAttrs)
      ) // passthruAttrs // { inherit name; };
  in fetcher fetcherArgs // { meta.homepage = baseUrl; inherit rev; };

  fetchFromBitbucket = {
    owner, repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
    meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
    extraPostFetch = ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
  } // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; };

  # cgit example, snapshot support is optional in cgit
  fetchFromSavannah = {
    repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
    meta.homepage = "http://git.savannah.gnu.org/cgit/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  # gitlab example
  fetchFromGitLab = {
    owner, repo, rev, domain ? "gitlab.com", name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://${domain}/api/v4/projects/${owner}%2F${repo}/repository/archive.tar.gz?sha=${rev}";
    meta.homepage = "https://${domain}/${owner}/${repo}/";
  } // removeAttrs args [ "domain" "owner" "repo" "rev" ]) // { inherit rev; };

  # gitweb example, snapshot support is optional in gitweb
  fetchFromRepoOrCz = {
    repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
    meta.homepage = "http://repo.or.cz/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  fetchNuGet = callPackage ../build-support/fetchnuget { };
  buildDotnetPackage = callPackage ../build-support/build-dotnet-package { };

  fetchgx = callPackage ../build-support/fetchgx { };

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  ld-is-cc-hook = makeSetupHook { name = "ld-is-cc-hook"; }
    ../build-support/setup-hooks/ld-is-cc-hook.sh;

  libredirect = callPackage ../build-support/libredirect { };

  madonctl = callPackage ../applications/misc/madonctl { };

  makeDesktopItem = callPackage ../build-support/make-desktopitem { };

  makeAutostartItem = callPackage ../build-support/make-startupitem { };

  makeInitrd = { contents, compressor ? "gzip -9n", prepend ? [ ] }:
    callPackage ../build-support/kernel/make-initrd.nix {
      inherit contents compressor prepend;
    };

  makeWrapper = makeSetupHook { deps = [ dieHook ]; }
                              ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, firmware, rootModules, allowMissing ? false }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit kernel firmware rootModules allowMissing;
    };

  mkShell = callPackage ../build-support/mkshell { };

  nixBufferBuilders = import ../build-support/emacs/buffer.nix { inherit (pkgs) lib writeText; inherit (emacsPackagesNg) inherit-local; };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  pruneLibtoolFiles = makeSetupHook { name = "prune-libtool-files"; }
    ../build-support/setup-hooks/prune-libtool-files.sh;

  closureInfo = callPackage ../build-support/closure-info.nix { };

  setupSystemdUnits = callPackage ../build-support/setup-systemd-units.nix { };

  singularity-tools = callPackage ../build-support/singularity-tools { };

  srcOnly = args: callPackage ../build-support/src-only args;

  substituteAll = callPackage ../build-support/substitute/substitute-all.nix { };

  substituteAllFiles = callPackage ../build-support/substitute-files/substitute-all-files.nix { };

  replaceDependency = callPackage ../build-support/replace-dependency.nix { };

  nukeReferences = callPackage ../build-support/nuke-references { };

  removeReferencesTo = callPackage ../build-support/remove-references-to { };

  vmTools = callPackage ../build-support/vm { };

  releaseTools = callPackage ../build-support/release { };

  composableDerivation = callPackage ../../lib/composable-derivation.nix { };

  inherit (lib.systems) platforms;

  setJavaClassPath = makeSetupHook { } ../build-support/setup-hooks/set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook { } ../build-support/setup-hooks/fix-darwin-dylib-names.sh;

  keepBuildTree = makeSetupHook { } ../build-support/setup-hooks/keep-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook { } ../build-support/setup-hooks/enable-coverage-instrumentation.sh;

  makeGCOVReport = makeSetupHook
    { deps = [ pkgs.lcov pkgs.enableGCOVInstrumentation ]; }
    ../build-support/setup-hooks/make-coverage-analysis-report.sh;

  # intended to be used like nix-build -E 'with import <nixpkgs> {}; enableDebugging fooPackage'
  enableDebugging = pkg: pkg.override { stdenv = stdenvAdapters.keepDebugInfo pkg.stdenv; };

  findXMLCatalogs = makeSetupHook { } ../build-support/setup-hooks/find-xml-catalogs.sh;

  wrapGAppsHook = makeSetupHook {
    deps = [ gnome3.dconf.lib gnome3.gtk librsvg makeWrapper ];
  } ../build-support/setup-hooks/wrap-gapps-hook.sh;

  separateDebugInfo = makeSetupHook { } ../build-support/setup-hooks/separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook { } ../build-support/setup-hooks/setup-debug-info-dirs.sh;

  useOldCXXAbi = makeSetupHook { } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  ical2org = callPackage ../tools/misc/ical2org {};

  iconConvTools = callPackage ../build-support/icon-conv-tools {};


  ### TOOLS

  _1password = callPackage ../applications/misc/1password { };

  _9pfs = callPackage ../tools/filesystems/9pfs { };

  a2ps = callPackage ../tools/text/a2ps { };

  abcm2ps = callPackage ../tools/audio/abcm2ps { };

  abcmidi = callPackage ../tools/audio/abcmidi { };

  abduco = callPackage ../tools/misc/abduco { };

  acbuild = callPackage ../applications/misc/acbuild { };

  acct = callPackage ../tools/system/acct { };

  accuraterip-checksum = callPackage ../tools/audio/accuraterip-checksum { };

  acme-sh = callPackage ../tools/admin/acme.sh { };

  acoustidFingerprinter = callPackage ../tools/audio/acoustid-fingerprinter {
    ffmpeg = ffmpeg_1;
  };

  acpica-tools = callPackage ../tools/system/acpica-tools { };

  actdiag = with python3.pkgs; toPythonApplication actdiag;

  actkbd = callPackage ../tools/system/actkbd { };

  advancecomp = callPackage ../tools/compression/advancecomp {};

  aefs = callPackage ../tools/filesystems/aefs { };

  aegisub = callPackage ../applications/video/aegisub {
    wxGTK = wxGTK30;
    spellcheckSupport = config.aegisub.spellcheckSupport or true;
    automationSupport = config.aegisub.automationSupport or true;
    openalSupport     = config.aegisub.openalSupport or false;
    alsaSupport       = config.aegisub.alsaSupport or true;
    pulseaudioSupport = config.aegisub.pulseaudioSupport or true;
    portaudioSupport  = config.aegisub.portaudioSupport or false;
  };

  aerospike = callPackage ../servers/nosql/aerospike { };

  aespipe = callPackage ../tools/security/aespipe { };

  aescrypt = callPackage ../tools/misc/aescrypt { };

  acme-client = callPackage ../tools/networking/acme-client { inherit (darwin) apple_sdk; };

  afew = callPackage ../applications/networking/mailreaders/afew { pythonPackages = python3Packages; };

  afio = callPackage ../tools/archivers/afio { };

  afl = callPackage ../tools/security/afl {
    stdenv = clangStdenv;
  };

  afpfs-ng = callPackage ../tools/filesystems/afpfs-ng { };

  agrep = callPackage ../tools/text/agrep { };

  aha = callPackage ../tools/text/aha { };

  ahcpd = callPackage ../tools/networking/ahcpd { };

  aide = callPackage ../tools/security/aide { };

  aircrack-ng = callPackage ../tools/networking/aircrack-ng { };

  airfield = callPackage ../tools/networking/airfield { };

  airsonic = callPackage ../servers/misc/airsonic { };

  airspy = callPackage ../applications/misc/airspy { };

  airtame = callPackage ../applications/misc/airtame { };

  aj-snapshot  = callPackage ../applications/audio/aj-snapshot { };

  albert = libsForQt5.callPackage ../applications/misc/albert {};

  alacritty = callPackage ../applications/misc/alacritty {
    inherit (xorg) libXcursor libXxf86vm libXi;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  amazon-glacier-cmd-interface = callPackage ../tools/backup/amazon-glacier-cmd-interface { };

  ammonite = callPackage ../development/tools/ammonite {};

  amtterm = callPackage ../tools/system/amtterm {};

  analog = callPackage ../tools/admin/analog {};

  ansifilter = callPackage ../tools/text/ansifilter {};

  apktool = callPackage ../development/tools/apktool {
    buildTools = androidenv.buildTools;
  };

  appimage-run = callPackage ../tools/package-management/appimage-run {};

  appimagekit = callPackage ../tools/package-management/appimagekit {};

  apt-cacher-ng = callPackage ../servers/http/apt-cacher-ng { };

  apt-offline = callPackage ../tools/misc/apt-offline { };

  aptly = callPackage ../tools/misc/aptly { };

  archivemount = callPackage ../tools/filesystems/archivemount { };

  arandr = callPackage ../tools/X11/arandr { };

  arangodb = callPackage ../servers/nosql/arangodb { };

  arcanist = callPackage ../development/tools/misc/arcanist {};

  arduino = arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/arduino/arduino-core {
    jdk = jdk;
    withGui = false;
  };

  apitrace = libsForQt5.callPackage ../applications/graphics/apitrace {};

  arguments = callPackage ../development/libraries/arguments { };

  argus = callPackage ../tools/networking/argus {};

  argus-clients = callPackage ../tools/networking/argus-clients {};

  argtable = callPackage ../tools/misc/argtable {};

  argyllcms = callPackage ../tools/graphics/argyllcms {};

  arp-scan = callPackage ../tools/misc/arp-scan { };

  inherit (callPackages ../data/fonts/arphic {})
    arphic-ukai arphic-uming;

  artyFX = callPackage ../applications/audio/artyFX {};

  as31 = callPackage ../development/compilers/as31 {};

  owl-lisp = callPackage ../development/compilers/owl-lisp {};

  ascii = callPackage ../tools/text/ascii { };

  asciinema = callPackage ../tools/misc/asciinema {};

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super; };
    gsl = gsl_1;
  };

  atomicparsley = callPackage ../tools/video/atomicparsley { };

  autoflake = callPackage ../development/tools/analysis/autoflake { };

  avfs = callPackage ../tools/filesystems/avfs { };

  aws-iam-authenticator = callPackage ../tools/security/aws-iam-authenticator {};

  awscli = callPackage ../tools/admin/awscli { };

  awsebcli = callPackage ../tools/virtualization/awsebcli {};

  awslogs = callPackage ../tools/admin/awslogs { };

  aws-okta = callPackage ../tools/security/aws-okta { };

  aws-rotate-key = callPackage ../tools/admin/aws-rotate-key { };

  aws_shell = pythonPackages.callPackage ../tools/admin/aws_shell { };

  aws-sam-cli = callPackage ../development/tools/aws-sam-cli { };

  aws-vault = callPackage ../tools/admin/aws-vault { };

  iamy = callPackage ../tools/admin/iamy { };

  azure-cli = nodePackages.azure-cli;

  azure-vhd-utils  = callPackage ../tools/misc/azure-vhd-utils { };

  awless = callPackage ../tools/virtualization/awless { };

  brakeman = callPackage ../development/tools/analysis/brakeman { };

  ec2_api_tools = callPackage ../tools/virtualization/ec2-api-tools { };

  ec2_ami_tools = callPackage ../tools/virtualization/ec2-ami-tools { };

  altermime = callPackage ../tools/networking/altermime {};

  amule = callPackage ../tools/networking/p2p/amule { };

  amuleDaemon = appendToName "daemon" (amule.override {
    monolithic = false;
    daemon = true;
  });

  amuleGui = appendToName "gui" (amule.override {
    monolithic = false;
    client = true;
  });

  apg = callPackage ../tools/security/apg { };

  apt = callPackage ../tools/package-management/apt {
    inherit (perlPackages) Po4a;
    # include/c++/6.4.0/cstdlib:75:25: fatal error: stdlib.h: No such file or directory
    stdenv = overrideCC stdenv gcc5;
  };

  autorevision = callPackage ../tools/misc/autorevision { };

  bcachefs-tools = callPackage ../tools/filesystems/bcachefs-tools { };

  bmap-tools = callPackage ../tools/misc/bmap-tools { };

  bonnie = callPackage ../tools/filesystems/bonnie { };

  bonfire = callPackage ../tools/misc/bonfire { };

  bunny = callPackage ../tools/package-management/bunny { };

  cloud-sql-proxy = callPackage ../tools/misc/cloud-sql-proxy { };

  container-linux-config-transpiler = callPackage ../development/tools/container-linux-config-transpiler { };

  cconv = callPackage ../tools/text/cconv { };

  chkcrontab = callPackage ../tools/admin/chkcrontab { };

  djmount = callPackage ../tools/filesystems/djmount { };

  dgsh = callPackage ../shells/dgsh { };

  dkimpy = with pythonPackages; toPythonApplication dkimpy;

  ecdsautils = callPackage ../tools/security/ecdsautils { };

  sedutil = callPackage ../tools/security/sedutil { };

  elvish = callPackage ../shells/elvish { };

  encryptr = callPackage ../tools/security/encryptr {
    gconf = gnome2.GConf;
  };

  enchive = callPackage ../tools/security/enchive { };

  enpass = callPackage ../tools/security/enpass { };

  esh = callPackage ../tools/text/esh { };

  ezstream = callPackage ../tools/audio/ezstream { };

  genymotion = callPackage ../development/mobile/genymotion { };

  gams = callPackage ../tools/misc/gams {
    licenseFile = config.gams.licenseFile or null;
    optgamsFile = config.gams.optgamsFile or null;
  };

  git-fire = callPackage ../tools/misc/git-fire { };

  gitless = callPackage ../applications/version-management/gitless { };

  gitter = callPackage  ../applications/networking/instant-messengers/gitter { };

  grc = callPackage ../tools/misc/grc { };

  green-pdfviewer = callPackage ../applications/misc/green-pdfviewer {
   SDL = SDL_sixel;
  };

  gcsfuse = callPackage ../tools/filesystems/gcsfuse { };

  glyr = callPackage ../tools/audio/glyr { };

  httperf = callPackage ../tools/networking/httperf { };

  imgpatchtools = callPackage ../development/mobile/imgpatchtools { };

  ipgrep = callPackage ../tools/networking/ipgrep { };

  lastpass-cli = callPackage ../tools/security/lastpass-cli { };

  pacparser = callPackage ../tools/networking/pacparser { };

  pass = callPackage ../tools/security/pass { };

  passExtensions = recurseIntoAttrs pass.extensions;

  asc-key-to-qr-code-gif = callPackage ../tools/security/asc-key-to-qr-code-gif { };

  gopass = callPackage ../tools/security/gopass {
    buildGoPackage = buildGo110Package;
  };

  browserpass = callPackage ../tools/security/browserpass { };

  passff-host = callPackage ../tools/security/passff-host { };

  oracle-instantclient = callPackage ../development/libraries/oracle-instantclient { };

  kwakd = callPackage ../servers/kwakd { };

  kwm = callPackage ../os-specific/darwin/kwm { };

  khd = callPackage ../os-specific/darwin/khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  m-cli = callPackage ../os-specific/darwin/m-cli { };

  reattach-to-user-namespace = callPackage ../os-specific/darwin/reattach-to-user-namespace {};

  skhd = callPackage ../os-specific/darwin/skhd {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  qes = callPackage ../os-specific/darwin/qes {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  titaniumenv = callPackage ../development/mobile/titaniumenv { };

  abootimg = callPackage ../development/mobile/abootimg {};

  adbfs-rootless = callPackage ../development/mobile/adbfs-rootless {
    adb = androidenv.platformTools;
  };

  adb-sync = callPackage ../development/mobile/adb-sync { };

  androidenv = callPackage ../development/mobile/androidenv {
    pkgs_i686 = pkgsi686Linux;
  };

  inherit (androidenv) androidndk;

  androidsdk = androidenv.androidsdk_8_0;

  androidsdk_extras = self.androidenv.androidsdk_8_0_extras;

  webos = recurseIntoAttrs {
    cmake-modules = callPackage ../development/mobile/webos/cmake-modules.nix { };

    novacom = callPackage ../development/mobile/webos/novacom.nix { };
    novacomd = callPackage ../development/mobile/webos/novacomd.nix { };
  };

  arc-theme = callPackage ../misc/themes/arc { };

  arc-kde-theme = callPackage ../misc/themes/arc-kde { };

  adapta-gtk-theme = callPackage ../misc/themes/adapta { };

  adapta-kde-theme = callPackage ../misc/themes/adapta-kde { };

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  aria = aria2;

  aspcud = callPackage ../tools/misc/aspcud { };

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp { };

  autogen = callPackage ../development/tools/misc/autogen {
    guile = guile_2_0;
  };

  autojump = callPackage ../tools/misc/autojump { };

  autorandr = callPackage ../tools/misc/autorandr {};

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  avro-c = callPackage ../development/libraries/avro-c { };

  avro-cpp = callPackage ../development/libraries/avro-c++ { boost = boost160; };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  awstats = callPackage ../tools/system/awstats { };

  axel = callPackage ../tools/networking/axel {
    libssl = openssl;
  };

  axoloti = callPackage ../applications/audio/axoloti { };
  dfu-util-axoloti = callPackage ../applications/audio/axoloti/dfu-util.nix { };
  libusb1-axoloti = callPackage ../applications/audio/axoloti/libusb1.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  backblaze-b2 = python.pkgs.callPackage ../development/tools/backblaze-b2 { };

  bar = callPackage ../tools/system/bar {};

  base16-builder = callPackage ../misc/base16-builder { };

  basex = callPackage ../tools/text/xml/basex { };

  bashplotlib = callPackage ../tools/misc/bashplotlib { };

  babeld = callPackage ../tools/networking/babeld { };

  badvpn = callPackage ../tools/networking/badvpn {};

  barcode = callPackage ../tools/graphics/barcode {};

  bashburn = callPackage ../tools/cd-dvd/bashburn { };

  bashmount = callPackage ../tools/filesystems/bashmount {};

  bat = callPackage ../tools/misc/bat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bc = callPackage ../tools/misc/bc { };

  bdf2psf = callPackage ../tools/misc/bdf2psf { };

  bcat = callPackage ../tools/text/bcat {};

  bcache-tools = callPackage ../tools/filesystems/bcache-tools { };

  bchunk = callPackage ../tools/cd-dvd/bchunk { };

  inherit (callPackages ../misc/logging/beats/6.x.nix { })
    filebeat6
    heartbeat6
    metricbeat6
    packetbeat6;

  filebeat = filebeat6;
  heartbeat = heartbeat6;
  metricbeat = metricbeat6;
  packetbeat = packetbeat6;

  inherit (callPackages ../misc/logging/beats/5.x.nix { })
    filebeat5
    heartbeat5
    metricbeat5
    packetbeat5;

  bfr = callPackage ../tools/misc/bfr { };

  bibtool = callPackage ../tools/misc/bibtool { };

  bibutils = callPackage ../tools/misc/bibutils { };

  bibtex2html = callPackage ../tools/misc/bibtex2html { };

  bindfs = callPackage ../tools/filesystems/bindfs { };

  bins = callPackage ../tools/graphics/bins { };

  bitbucket-cli = python2Packages.bitbucket-cli;

  bittornado = callPackage ../tools/networking/p2p/bittornado { };

  blink = callPackage ../applications/networking/instant-messengers/blink { };

  blockhash = callPackage ../tools/graphics/blockhash { };

  bluemix-cli = callPackage ../tools/admin/bluemix-cli { };

  charles = callPackage ../applications/networking/charles { };

  libqmatrixclient = libsForQt5.callPackage ../development/libraries/libqmatrixclient { };

  quaternion = libsForQt5.callPackage ../applications/networking/instant-messengers/quaternion { };

  tensor = libsForQt5.callPackage ../applications/networking/instant-messengers/tensor { };

  libtensorflow = callPackage ../development/libraries/libtensorflow {
    cudaSupport = config.cudaSupport or false;
    inherit (linuxPackages) nvidia_x11;
    cudatoolkit = cudatoolkit_9_0;
    cudnn = cudnn_cudatoolkit_9_0;
  };

  blink1-tool = callPackage ../tools/misc/blink1-tool { };

  bliss = callPackage ../applications/science/math/bliss { };

  blitz = callPackage ../development/libraries/blitz {
    boost = boost160;
  };

  blobfuse = callPackage ../tools/filesystems/blobfuse { };

  blockdiag = with python3Packages; toPythonApplication blockdiag;

  blsd = callPackage ../tools/misc/blsd {
    libgit2 = libgit2_0_27;
  };

  bluez-tools = callPackage ../tools/bluetooth/bluez-tools { };

  bmon = callPackage ../tools/misc/bmon { };

  bochs = callPackage ../applications/virtualization/bochs { };

  bubblewrap = callPackage ../tools/admin/bubblewrap { };

  borgbackup = callPackage ../tools/backup/borg { };

  boomerang = libsForQt5.callPackage ../development/tools/boomerang { };

  boost-build = callPackage ../development/tools/boost-build { };

  boot = callPackage ../development/tools/build-managers/boot { };

  bootchart = callPackage ../tools/system/bootchart { };

  bowtie2 = callPackage ../applications/science/biology/bowtie2 { };

  boxfs = callPackage ../tools/filesystems/boxfs { };

  brasero-original = lowPrio (callPackage ../tools/cd-dvd/brasero { });

  brasero = callPackage ../tools/cd-dvd/brasero/wrapper.nix { };

  brltty = callPackage ../tools/misc/brltty {
    alsaSupport = (!stdenv.isDarwin);
    systemdSupport = stdenv.isLinux;
  };
  bro = callPackage ../applications/networking/ids/bro { };

  bruteforce-luks = callPackage ../tools/security/bruteforce-luks { };

  bsod = callPackage ../misc/emulators/bsod { };

  btrfs-progs = callPackage ../tools/filesystems/btrfs-progs { };

  btrfs-dedupe = callPackage ../tools/filesystems/btrfs-dedupe {};

  btrbk = callPackage ../tools/backup/btrbk {
    asciidoc = asciidoc-full;
  };

  buildtorrent = callPackage ../tools/misc/buildtorrent { };

  bustle = haskellPackages.bustle;

  buttersink = callPackage ../tools/filesystems/buttersink { };

  bwm_ng = callPackage ../tools/networking/bwm-ng { };

  byobu = callPackage ../tools/misc/byobu {
    # Choices: [ tmux screen ];
    textual-window-manager = tmux;
  };

  bsh = fetchurl {
    url = http://www.beanshell.org/bsh-2.0b5.jar;
    sha256 = "0p2sxrpzd0vsk11zf3kb5h12yl1nq4yypb5mpjrm8ww0cfaijck2";
  };

  btfs = callPackage ../os-specific/linux/btfs { };

  buildah = callPackage ../development/tools/buildah { };

  bukubrow = callPackage ../tools/networking/bukubrow { };

  burpsuite = callPackage ../tools/networking/burpsuite {};

  c3d = callPackage ../applications/graphics/c3d {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  cue2pops = callPackage ../tools/cd-dvd/cue2pops { };

  cabal2nix = haskell.lib.overrideCabal haskellPackages.cabal2nix (drv: {
    isLibrary = false;
    enableSharedExecutables = false;
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      exe=$out/libexec/${drv.pname}-${drv.version}/${drv.pname}
      install -D $out/bin/${drv.pname} $exe
      rm -rf $out/{bin,lib,share}
      makeWrapper $exe $out/bin/${drv.pname} \
        --prefix PATH ":" "${nix}/bin" \
        --prefix PATH ":" "${nix-prefetch-scripts}/bin"
      mkdir -p $out/share/{bash-completion/completions,zsh/vendor-completions,fish/completions}
      $exe --bash-completion-script $exe >$out/share/bash-completion/completions/${drv.pname}
      $exe --zsh-completion-script $exe >$out/share/zsh/vendor-completions/_${drv.pname}
      $exe --fish-completion-script $exe >$out/share/fish/completions/${drv.pname}.fish
    '';
  });

  stack2nix = with haskell.lib; overrideCabal (justStaticExecutables haskellPackages.stack2nix) (drv: {
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/stack2nix \
        --prefix PATH ":" "${git}/bin:${cabal-install}/bin"
    '';
  });

  caddy = callPackage ../servers/caddy { };
  traefik = callPackage ../servers/traefik { };

  calamares = libsForQt5.callPackage ../tools/misc/calamares {
    python = python3;
    boost = pkgs.boost.override { python = python3; };
  };

  capstone = callPackage ../development/libraries/capstone { };
  unicorn-emu = callPackage ../development/libraries/unicorn-emu { };

  casync = callPackage ../applications/networking/sync/casync {
    sphinx = python3Packages.sphinx;
  };

  cataract          = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  catch = callPackage ../development/libraries/catch { };

  catdoc = callPackage ../tools/text/catdoc { };

  catdocx = callPackage ../tools/text/catdocx { };

  catclock = callPackage ../applications/misc/catclock { };

  cde = callPackage ../tools/package-management/cde { };

  cdemu-daemon = callPackage ../misc/emulators/cdemu/daemon.nix { };

  cdemu-client = callPackage ../misc/emulators/cdemu/client.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    google-gflags = null; # only required for examples/tests
  };

  gcdemu = callPackage ../misc/emulators/cdemu/gui.nix { };

  image-analyzer = callPackage ../misc/emulators/cdemu/analyzer.nix { };

  cbor-diag = callPackage ../development/tools/cbor-diag { };

  ccnet = callPackage ../tools/networking/ccnet { };

  cddl = callPackage ../development/tools/cddl { };

  cfdyndns = callPackage ../applications/networking/dyndns/cfdyndns { };

  ckbcomp = callPackage ../tools/X11/ckbcomp { };

  clac = callPackage ../tools/misc/clac {};

  clasp = callPackage ../tools/misc/clasp { };

  cli53 = callPackage ../tools/admin/cli53 { };

  cli-visualizer = callPackage ../applications/misc/cli-visualizer { };

  clog-cli = callPackage ../development/tools/clog-cli { };

  cloud-init = callPackage ../tools/virtualization/cloud-init { };

  cloudmonkey = callPackage ../tools/virtualization/cloudmonkey { };

  clib = callPackage ../tools/package-management/clib { };

  clingo = callPackage ../applications/science/logic/potassco/clingo.nix { };

  colord-kde = libsForQt5.callPackage ../tools/misc/colord-kde {};

  colpack = callPackage ../applications/science/math/colpack { };

  compactor = callPackage ../applications/networking/compactor { };

  consul = callPackage ../servers/consul { };

  consul-ui = callPackage ../servers/consul/ui.nix { };

  consul-alerts = callPackage ../servers/monitoring/consul-alerts { };

  consul-template = callPackage ../tools/system/consul-template { };

  copyright-update = callPackage ../tools/text/copyright-update { };

  corebird = callPackage ../applications/networking/corebird { };

  corosync = callPackage ../servers/corosync { };

  cowsay = callPackage ../tools/misc/cowsay { };

  cherrytree = callPackage ../applications/misc/cherrytree { };

  chntpw = callPackage ../tools/security/chntpw { };

  clipster = callPackage ../tools/misc/clipster { };

  coprthr = callPackage ../development/libraries/coprthr {
    flex = flex_2_5_35;
  };

  cplex = callPackage ../applications/science/math/cplex { releasePath = config.cplex.releasePath or null; };

  cpulimit = callPackage ../tools/misc/cpulimit { };

  codesearch = callPackage ../tools/text/codesearch { };

  codec2 = callPackage ../development/libraries/codec2 { };

  contacts = callPackage ../tools/misc/contacts {
    inherit (darwin.apple_sdk.frameworks) Foundation AddressBook;
  };

  compsize = callPackage ../os-specific/linux/compsize { };

  coturn = callPackage ../servers/coturn { };

  coursier = callPackage ../development/tools/coursier {};

  cri-tools = callPackage ../tools/virtualization/cri-tools {};

  crip = callPackage ../applications/audio/crip { };

  crunch = callPackage ../tools/security/crunch { };

  crudini = callPackage ../tools/misc/crudini { };

  cucumber = callPackage ../development/tools/cucumber {};

  daemontools = callPackage ../tools/admin/daemontools { };

  dale = callPackage ../development/compilers/dale { };

  dante = callPackage ../servers/dante { };

  datamash = callPackage ../tools/misc/datamash { };

  datefudge = callPackage ../tools/system/datefudge { };

  dateutils = callPackage ../tools/misc/dateutils { };

  ddar = callPackage ../tools/backup/ddar { };

  ddate = callPackage ../tools/misc/ddate { };

  dehydrated = callPackage ../tools/admin/dehydrated { };

  deis = callPackage ../development/tools/deis {};

  deisctl = callPackage ../development/tools/deisctl {};

  deja-dup = callPackage ../applications/backup/deja-dup { };

  desync = callPackage ../applications/networking/sync/desync { };

  devmem2 = callPackage ../os-specific/linux/devmem2 { };

  dbus-broker = callPackage ../os-specific/linux/dbus-broker { };

  ioport = callPackage ../os-specific/linux/ioport {};

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialog = callPackage ../development/tools/misc/dialog { };

  dibbler = callPackage ../tools/networking/dibbler { };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  dirb = callPackage ../tools/networking/dirb { };

  direnv = callPackage ../tools/misc/direnv { };

  discount = callPackage ../tools/text/discount { };

  diskscan = callPackage ../tools/misc/diskscan { };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dislocker = callPackage ../tools/filesystems/dislocker { };

  distrobuilder = callPackage ../tools/virtualization/distrobuilder { };

  ditaa = callPackage ../tools/graphics/ditaa { };

  dino = callPackage ../applications/networking/instant-messengers/dino { };

  dlx = callPackage ../misc/emulators/dlx { };

  doitlive = callPackage ../tools/misc/doitlive { };

  dosage = callPackage ../applications/graphics/dosage {
    pythonPackages = python3Packages;
  };

  dozenal = callPackage ../applications/misc/dozenal { };

  dpic = callPackage ../tools/graphics/dpic { };

  dragon-drop = callPackage ../tools/X11/dragon-drop {
    gtk = gtk3;
  };

  dtools = callPackage ../development/tools/dtools { };

  dtrx = callPackage ../tools/compression/dtrx { };

  dune = callPackage ../development/tools/ocaml/dune { };

  duperemove = callPackage ../tools/filesystems/duperemove { };

  dylibbundler = callPackage ../tools/misc/dylibbundler { };

  dynamic-colors = callPackage ../tools/misc/dynamic-colors { };

  dyncall = callPackage ../development/libraries/dyncall { };

  earlyoom = callPackage ../os-specific/linux/earlyoom { };

  EBTKS = callPackage ../development/libraries/science/biology/EBTKS { };

  ecasound = callPackage ../applications/audio/ecasound { };

  edac-utils = callPackage ../os-specific/linux/edac-utils { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  elementary-icon-theme = callPackage ../data/icons/elementary-icon-theme { };

  elementary-xfce-icon-theme = callPackage ../data/icons/elementary-xfce-icon-theme { };

  elm-github-install = callPackage ../tools/package-management/elm-github-install { };

  emby = callPackage ../servers/emby { };

  enca = callPackage ../tools/text/enca { };

  ent = callPackage ../tools/misc/ent { };

  envconsul = callPackage ../tools/system/envconsul { };

  eschalot = callPackage ../tools/security/eschalot { };

  esptool = callPackage ../tools/misc/esptool { };

  esptool-ck = callPackage ../tools/misc/esptool-ck { };

  ephemeralpg = callPackage ../applications/misc/ephemeralpg {};

  et = callPackage ../applications/misc/et {};

  eternal-terminal = callPackage ../tools/networking/eternal-terminal {};

  f3 = callPackage ../tools/filesystems/f3 { };

  fac = callPackage ../development/tools/fac { };

  facedetect = callPackage ../tools/graphics/facedetect { };

  facter = callPackage ../tools/system/facter { };

  fasd = callPackage ../tools/misc/fasd { };

  fastJson = callPackage ../development/libraries/fastjson { };

  fast-cli = nodePackages.fast-cli;

  fd = callPackage ../tools/misc/fd { };

  filebench = callPackage ../tools/misc/filebench { };

  fileshelter = callPackage ../servers/web-apps/fileshelter { };

  fsmon = callPackage ../tools/misc/fsmon { };

  fsql = callPackage ../tools/misc/fsql { };

  fop = callPackage ../tools/typesetting/fop { };

  fondu = callPackage ../tools/misc/fondu { };

  fpp = callPackage ../tools/misc/fpp { };

  fsmark = callPackage ../tools/misc/fsmark { };

  fwup = callPackage ../tools/misc/fwup { };

  fzf = callPackage ../tools/misc/fzf { };

  fzy = callPackage ../tools/misc/fzy { };

  gbsplay = callPackage ../applications/audio/gbsplay { };

  gdrivefs = python27Packages.gdrivefs;

  gdrive = callPackage ../applications/networking/gdrive { };

  go-dependency-manager = callPackage ../development/tools/gdm { };

  geckodriver = callPackage ../development/tools/geckodriver { };

  geekbench = callPackage ../tools/misc/geekbench { };

  gencfsm = callPackage ../tools/security/gencfsm { };

  genromfs = callPackage ../tools/filesystems/genromfs { };

  gh-ost = callPackage ../tools/misc/gh-ost { };

  gist = callPackage ../tools/text/gist { };

  gixy = callPackage ../tools/admin/gixy { };

  gllvm = callPackage ../development/tools/gllvm { };

  glide = callPackage ../development/tools/glide { };

  globalarrays = callPackage ../development/libraries/globalarrays { };

  glock = callPackage ../development/tools/glock { };

  glslviewer = callPackage ../development/tools/glslviewer {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  gmic = callPackage ../tools/graphics/gmic { };

  goa = callPackage ../development/tools/goa {
    buildGoPackage = buildGo110Package;
  };

  gohai = callPackage ../tools/system/gohai { };

  gorilla-bin = callPackage ../tools/security/gorilla-bin { };

  gosu = callPackage ../tools/misc/gosu { };

  greg = callPackage ../applications/audio/greg {
    pythonPackages = python3Packages;
  };

  gringo = callPackage ../tools/misc/gringo { scons = scons_2_5_1; };

  grobi = callPackage ../tools/X11/grobi { };

  gti = callPackage ../tools/misc/gti { };

  hdate = callPackage ../applications/misc/hdate { };

  heatseeker = callPackage ../tools/misc/heatseeker { };

  hebcal = callPackage ../tools/misc/hebcal {};

  hexio = callPackage ../development/tools/hexio { };

  hid-listen = callPackage ../tools/misc/hid-listen { };

  home-manager = callPackage ../tools/package-management/home-manager {};

  hostsblock = callPackage ../tools/misc/hostsblock { };

  hr = callPackage ../applications/misc/hr { };

  hyx = callPackage ../tools/text/hyx { };

  icdiff = callPackage ../tools/text/icdiff {};

  interlock = callPackage ../servers/interlock {};

  kapacitor = callPackage ../servers/monitoring/kapacitor { };

  kisslicer = callPackage ../tools/misc/kisslicer { };

  klaus = with pythonPackages; toPythonApplication klaus;

  lcdproc = callPackage ../servers/monitoring/lcdproc { };

  languagetool = callPackage ../tools/text/languagetool {  };

  lief = callPackage ../development/libraries/lief {};

  libndtypes = callPackage ../development/libraries/libndtypes { };

  libxnd = callPackage ../development/libraries/libxnd { };

  loadwatch = callPackage ../tools/system/loadwatch { };

  loccount = callPackage ../development/tools/misc/loccount { };

  long-shebang = callPackage ../misc/long-shebang {};

  iio-sensor-proxy = callPackage ../os-specific/linux/iio-sensor-proxy { };

  ipvsadm = callPackage ../os-specific/linux/ipvsadm { };

  lynis = callPackage ../tools/security/lynis { };

  mathics = pythonPackages.mathics;

  masscan = callPackage ../tools/security/masscan {
    stdenv = gccStdenv;
  };

  massren = callPackage ../tools/misc/massren { };

  meritous = callPackage ../games/meritous { };

  opendune = callPackage ../games/opendune { };

  meson = callPackage ../development/tools/build-managers/meson { };

  metabase = callPackage ../servers/metabase { };

  monetdb = callPackage ../servers/sql/monetdb { };

  mp3blaster = callPackage ../applications/audio/mp3blaster { };

  mp3fs = callPackage ../tools/filesystems/mp3fs { };

  mpdas = callPackage ../tools/audio/mpdas { };

  mpdcron = callPackage ../tools/audio/mpdcron { };

  mpdris2 = callPackage ../tools/audio/mpdris2 { };

  mq-cli = callPackage ../tools/system/mq-cli { };

  nfdump = callPackage ../tools/networking/nfdump { };

  noteshrink = callPackage ../tools/misc/noteshrink { };

  noti = callPackage ../tools/misc/noti {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  nrsc5 = callPackage ../applications/misc/nrsc5 { };

  nwipe = callPackage ../tools/security/nwipe { };

  nyx = callPackage ../tools/networking/nyx { };

  onboard = callPackage ../applications/misc/onboard { };

  xkbd = callPackage ../applications/misc/xkbd { };

  optar = callPackage ../tools/graphics/optar {};

  patdiff = callPackage ../tools/misc/patdiff { };

  pbzx = callPackage ../tools/compression/pbzx { };

  pev = callPackage ../development/tools/analysis/pev { };

  photon = callPackage ../tools/networking/photon { };

  playerctl = callPackage ../tools/audio/playerctl { };

  ps_mem = callPackage ../tools/system/ps_mem { };

  psstop = callPackage ../tools/system/psstop { };

  parallel-rust = callPackage ../tools/misc/parallel-rust { };

  scour = callPackage ../tools/graphics/scour { };

  s2png = callPackage ../tools/graphics/s2png { };

  simg2img = callPackage ../tools/filesystems/simg2img { };

  socklog = callPackage ../tools/system/socklog { };

  staccato = callPackage ../tools/text/staccato { };

  stagit = callPackage ../development/tools/stagit { };

  bash-supergenpass = callPackage ../tools/security/bash-supergenpass { };

  sweep-visualizer = callPackage ../tools/misc/sweep-visualizer { };

  syscall_limiter = callPackage ../os-specific/linux/syscall_limiter {};

  syslogng = callPackage ../tools/system/syslog-ng { };

  syslogng_incubator = callPackage ../tools/system/syslog-ng-incubator { };

  inherit (callPackages ../servers/rainloop { })
    rainloop-community
    rainloop-standard;

  ring-daemon = callPackage ../applications/networking/instant-messengers/ring-daemon { };

  riot-web = callPackage ../applications/networking/instant-messengers/riot/riot-web.nix {
    conf = config.riot-web.conf or null;
  };

  rsbep = callPackage ../tools/backup/rsbep { };

  rsyslog = callPackage ../tools/system/rsyslog {
    hadoop = null; # Currently Broken
    czmq = czmq3;
  };

  rsyslog-light = rsyslog.override {
    libkrb5 = null;
    systemd = null;
    jemalloc = null;
    mysql = null;
    postgresql = null;
    libdbi = null;
    net_snmp = null;
    libuuid = null;
    gnutls = null;
    libgcrypt = null;
    liblognorm = null;
    openssl = null;
    librelp = null;
    libgt = null;
    libksi = null;
    liblogging = null;
    libnet = null;
    hadoop = null;
    rdkafka = null;
    libmongo-client = null;
    czmq = null;
    rabbitmq-c = null;
    hiredis = null;
  };

  mar1d = callPackage ../games/mar1d { } ;

  mcrypt = callPackage ../tools/misc/mcrypt { };

  mongodb-compass = callPackage ../tools/misc/mongodb-compass { };

  mongodb-tools = callPackage ../tools/misc/mongodb-tools { };

  mozlz4a = callPackage ../tools/compression/mozlz4a {
    pylz4 = python3Packages.lz4;
  };

  msr-tools = callPackage ../os-specific/linux/msr-tools { };

  mstflint = callPackage ../tools/misc/mstflint { };

  mcelog = callPackage ../os-specific/linux/mcelog {
    utillinux = utillinuxMinimal;
  };

  sqlint = callPackage ../development/tools/sqlint { };

  antibody = callPackage ../shells/zsh/antibody { };

  antigen = callPackage ../shells/zsh/antigen { };

  apparix = callPackage ../tools/misc/apparix { };

  appleseed = callPackage ../tools/graphics/appleseed { };

  arping = callPackage ../tools/networking/arping { };

  arpoison = callPackage ../tools/networking/arpoison { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (python2Packages) matplotlib numpy aafigure recursivePthLoader;
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = appendToName "full" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
  });

  asciidoc-full-with-plugins = appendToName "full-with-plugins" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  });

  asciidoctor = callPackage ../tools/typesetting/asciidoctor { };

  asunder = callPackage ../applications/audio/asunder { };

  autossh = callPackage ../tools/networking/autossh { };

  assh = callPackage ../tools/networking/assh { };

  asynk = callPackage ../tools/networking/asynk { };

  b2sum = callPackage ../tools/security/b2sum {
    inherit (llvmPackages) openmp;
  };

  bacula = callPackage ../tools/backup/bacula { };

  bareos = callPackage ../tools/backup/bareos { };

  bats = callPackage ../development/interpreters/bats { };

  bdsync = callPackage ../tools/backup/bdsync { };

  beanstalkd = callPackage ../servers/beanstalkd { };

  beegfs = callPackage ../os-specific/linux/beegfs { };

  beets = callPackage ../tools/audio/beets {
    pythonPackages = python3Packages;
  };

  bepasty = callPackage ../tools/misc/bepasty { };

  bettercap = callPackage ../tools/security/bettercap { };

  bfg-repo-cleaner = gitAndTools.bfg-repo-cleaner;

  bfs = callPackage ../tools/system/bfs { };

  bgs = callPackage ../tools/X11/bgs { };

  biber = callPackage ../tools/typesetting/biber { };

  blueman = callPackage ../tools/bluetooth/blueman {
    withPulseAudio = config.pulseaudio or true;
  };

  bmrsa = callPackage ../tools/security/bmrsa/11.nix { };

  bogofilter = callPackage ../tools/misc/bogofilter { };

  bsdbuild = callPackage ../development/tools/misc/bsdbuild { };

  bsdiff = callPackage ../tools/compression/bsdiff { };

  btar = callPackage ../tools/backup/btar {
    librsync = librsync_0_9;
  };

  bud = callPackage ../tools/networking/bud {
    inherit (pythonPackages) gyp;
  };

  bup = callPackage ../tools/backup/bup { };

  burp = callPackage ../tools/backup/burp { };

  buku = callPackage ../applications/misc/buku { };

  byzanz = callPackage ../applications/video/byzanz {};

  ori = callPackage ../tools/backup/ori { };

  anydesk = callPackage ../applications/networking/remote/anydesk { };

  atool = callPackage ../tools/archivers/atool { };

  bsc = callPackage ../tools/compression/bsc {
    inherit (llvmPackages) openmp;
  };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cabextract = callPackage ../tools/archivers/cabextract { };

  cadaver = callPackage ../tools/networking/cadaver { };

  davix = callPackage ../tools/networking/davix { };

  cantata = libsForQt5.callPackage ../applications/audio/cantata {
    inherit vlc;
    ffmpeg = ffmpeg_2;
  };

  can-utils = callPackage ../os-specific/linux/can-utils { };

  caudec = callPackage ../applications/audio/caudec { };

  ccd2iso = callPackage ../tools/cd-dvd/ccd2iso { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  ccze = callPackage ../tools/misc/ccze { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdi2iso = callPackage ../tools/cd-dvd/cdi2iso { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  mdf2iso = callPackage ../tools/cd-dvd/mdf2iso { };

  nrg2iso = callPackage ../tools/cd-dvd/nrg2iso { };

  libceph = ceph.lib;
  ceph = callPackage ../tools/filesystems/ceph {
    boost = boost166.override { enablePython = true; };
  };
  ceph-dev = ceph;

  certmgr = callPackage ../tools/security/certmgr { };

  cfdg = callPackage ../tools/graphics/cfdg {
    ffmpeg = ffmpeg_2;
  };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  chrony = callPackage ../tools/networking/chrony { };

  chunkfs = callPackage ../tools/filesystems/chunkfs { };

  chunksync = callPackage ../tools/backup/chunksync { };

  cipherscan = callPackage ../tools/security/cipherscan {
    openssl = if stdenv.hostPlatform.system == "x86_64-linux"
      then openssl-chacha
      else openssl;
  };

  cjdns = callPackage ../tools/networking/cjdns { };

  cksfv = callPackage ../tools/networking/cksfv { };

  clementine = callPackage ../applications/audio/clementine {
    gst_plugins =
      with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav ];
  };

  clementineUnfree = clementine.unfree;

  ciopfs = callPackage ../tools/filesystems/ciopfs { };

  circleci-cli = callPackage ../development/tools/misc/circleci-cli { };

  citrix_receiver_unwrapped = callPackage ../applications/networking/remote/citrix-receiver { };
  citrix_receiver_unwrapped_13_10_0 = citrix_receiver_unwrapped.override { version = "13.10.0"; };
  citrix_receiver_unwrapped_13_9_1  = citrix_receiver_unwrapped.override { version = "13.9.1";  };
  citrix_receiver_unwrapped_13_9_0  = citrix_receiver_unwrapped.override { version = "13.9.0";  };
  citrix_receiver_unwrapped_13_8_0  = citrix_receiver_unwrapped.override { version = "13.8.0";  };

  citrix_receiver = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped;
  };
  citrix_receiver_13_10_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_10_0;
  };
  citrix_receiver_13_9_1 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_9_1;
  };
  citrix_receiver_13_9_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_9_0;
  };
  citrix_receiver_13_8_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_8_0;
  };

  citra = libsForQt5.callPackage ../misc/emulators/citra { };

  cmst = libsForQt5.callPackage ../tools/networking/cmst { };

  codimd = callPackage ../servers/web-apps/codimd { };

  colord = callPackage ../tools/misc/colord { };

  colord-gtk = callPackage ../tools/misc/colord-gtk { };

  colordiff = callPackage ../tools/text/colordiff { };

  concurrencykit = callPackage ../development/libraries/concurrencykit { };

  connect = callPackage ../tools/networking/connect { };

  conspy = callPackage ../os-specific/linux/conspy {};

  connman = callPackage ../tools/networking/connman { };

  connman-gtk = callPackage ../tools/networking/connman/connman-gtk { };

  connman-ncurses = callPackage ../tools/networking/connman/connman-ncurses { };

  connman-notify = callPackage ../tools/networking/connman/connman-notify { };

  connmanui = callPackage ../tools/networking/connman/connmanui { };

  connman_dmenu = callPackage ../tools/networking/connman/connman_dmenu  { };

  convertlit = callPackage ../tools/text/convertlit { };

  collectd = callPackage ../tools/system/collectd {
    libsigrok = libsigrok-0-3-0; # not compatible with >= 0.4.0 yet
  };

  collectd-data = callPackage ../tools/system/collectd/data.nix { };

  colormake = callPackage ../development/tools/build-managers/colormake { };

  cpuminer = callPackage ../tools/misc/cpuminer { };

  cpuminer-multi = callPackage ../tools/misc/cpuminer-multi { };

  cuetools = callPackage ../tools/cd-dvd/cuetools { };

  u3-tool = callPackage ../tools/filesystems/u3-tool { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  unionfs-fuse = callPackage ../tools/filesystems/unionfs-fuse { };

  usb-modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };
  usb-modeswitch-data = callPackage ../development/tools/misc/usb-modeswitch/data.nix { };

  anthy = callPackage ../tools/inputmethods/anthy { };

  libpinyin = callPackage ../development/libraries/libpinyin { };

  libskk = callPackage ../development/libraries/libskk {
    inherit (gnome3) gnome-common libgee;
  };

  m17n_db = callPackage ../tools/inputmethods/m17n-db { };

  m17n_lib = callPackage ../tools/inputmethods/m17n-lib { };

  libotf = callPackage ../tools/inputmethods/m17n-lib/otf.nix {
    inherit (xorg) libXaw;
  };

  skktools = callPackage ../tools/inputmethods/skk/skktools { };
  skk-dicts = callPackage ../tools/inputmethods/skk/skk-dicts { };

  libkkc-data = callPackage ../data/misc/libkkc-data {
    inherit (pythonPackages) marisa;
  };

  libkkc = callPackage ../tools/inputmethods/libkkc {
    inherit (gnome3) libgee;
  };

  ibus = callPackage ../tools/inputmethods/ibus {
    gconf = gnome2.GConf;
    inherit (gnome3) dconf glib;
  };

  ibus-qt = callPackage ../tools/inputmethods/ibus/ibus-qt.nix { };

  ibus-engines = recurseIntoAttrs {
    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy { };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul { };

    kkc = callPackage ../tools/inputmethods/ibus-engines/ibus-kkc { };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin { };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n { };

    mozc = callPackage ../tools/inputmethods/ibus-engines/ibus-mozc rec {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

    table = callPackage ../tools/inputmethods/ibus-engines/ibus-table {
      inherit (gnome3) dconf;
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

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix {
    inherit (gnome3) dconf;
    plugins = [ ];
  };

  interception-tools = callPackage ../tools/inputmethods/interception-tools { };
  interception-tools-plugins = {
    caps2esc = callPackage ../tools/inputmethods/interception-tools/caps2esc.nix { };
  };

  brotli = callPackage ../tools/compression/brotli { };

  biosdevname = callPackage ../tools/networking/biosdevname { };

  c14 = callPackage ../applications/networking/c14 { };

  certstrap = callPackage ../tools/security/certstrap { };

  cfssl = callPackage ../tools/security/cfssl { };

  checkbashisms = callPackage ../development/tools/misc/checkbashisms { };

  ckb = libsForQt5.callPackage ../tools/misc/ckb { };

  clamav = callPackage ../tools/security/clamav { };

  clex = callPackage ../tools/misc/clex { };

  client-ip-echo = callPackage ../servers/misc/client-ip-echo { };

  cloc = callPackage ../tools/misc/cloc {
    inherit (perlPackages) perl AlgorithmDiff ParallelForkManager RegexpCommon;
  };

  cloog = callPackage ../development/libraries/cloog {
    isl = isl_0_14;
  };

  cloog_0_18_0 = callPackage ../development/libraries/cloog/0.18.0.nix {
    isl = isl_0_11;
  };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  cloud-utils = callPackage ../tools/misc/cloud-utils { };

  cocoapods = callPackage ../development/mobile/cocoapods { };

  compass = callPackage ../development/tools/compass { };

  conda = callPackage ../tools/package-management/conda { };

  convmv = callPackage ../tools/misc/convmv { };

  convoy = callPackage ../tools/filesystems/convoy { };

  cool-retro-term = libsForQt5.callPackage ../applications/misc/cool-retro-term { };

  coreutils = callPackage ../tools/misc/coreutils { };
  coreutils-full = coreutils.override { minimal = false; };
  coreutils-prefixed = coreutils.override { withPrefix = true; singleBinary = false; };

  corkscrew = callPackage ../tools/networking/corkscrew { };

  cowpatty = callPackage ../tools/security/cowpatty { };

  cpio = callPackage ../tools/archivers/cpio { };

  crackxls = callPackage ../tools/security/crackxls { };

  create-cycle-app = nodePackages_8_x.create-cycle-app;

  createrepo_c = callPackage ../tools/package-management/createrepo_c { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron { };

  inherit (callPackages ../development/compilers/cudatoolkit { })
    cudatoolkit_6
    cudatoolkit_6_5
    cudatoolkit_7
    cudatoolkit_7_5
    cudatoolkit_8
    cudatoolkit_9_0
    cudatoolkit_9;

  cudatoolkit = cudatoolkit_9;

  inherit (callPackages ../development/libraries/science/math/cudnn { })
    cudnn_cudatoolkit_7
    cudnn_cudatoolkit_7_5
    cudnn6_cudatoolkit_8
    cudnn_cudatoolkit_8
    cudnn_cudatoolkit_9
    cudnn_cudatoolkit_9_0;

  cudnn = cudnn_cudatoolkit_9;

  curlFull = curl.override {
    idnSupport = true;
    ldapSupport = true;
    gssSupport = true;
    brotliSupport = true;
  };

  curl_7_59 = callPackage ../tools/networking/curl/7_59.nix rec {
    fetchurl = fetchurlBoot;
    http2Support = true;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
    gssSupport = true;
  };

  curl = callPackage ../tools/networking/curl rec {
    fetchurl = fetchurlBoot;
    http2Support = true;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
    gssSupport = true;
  };

  curl_unix_socket = callPackage ../tools/networking/curl-unix-socket rec { };

  cunit = callPackage ../tools/misc/cunit { };
  bcunit = callPackage ../tools/misc/bcunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  cutter = callPackage ../tools/networking/cutter { };

  cwebbin = callPackage ../development/tools/misc/cwebbin { };

  cvs_fast_export = callPackage ../applications/version-management/cvs-fast-export { };

  dadadodo = callPackage ../tools/text/dadadodo { };

  daemonize = callPackage ../tools/system/daemonize { };

  daq = callPackage ../applications/networking/ids/daq { };

  dar = callPackage ../tools/backup/dar { };

  darkhttpd = callPackage ../servers/http/darkhttpd { };

  darkstat = callPackage ../tools/networking/darkstat { };

  davfs2 = callPackage ../tools/filesystems/davfs2 { };

  dbeaver = callPackage ../applications/misc/dbeaver { };

  dbench = callPackage ../development/tools/misc/dbench { };

  dclxvi = callPackage ../development/libraries/dclxvi { };

  dcraw = callPackage ../tools/graphics/dcraw { };

  dcfldd = callPackage ../tools/system/dcfldd { };

  debianutils = callPackage ../tools/misc/debianutils { };

  debian-devscripts = callPackage ../tools/misc/debian-devscripts {
    inherit (perlPackages) CryptSSLeay LWP TimeDate DBFile FileDesktopEntry;
  };

  debootstrap = callPackage ../tools/misc/debootstrap { };

  deer = callPackage ../shells/zsh/zsh-deer { };

  detox = callPackage ../tools/misc/detox { };

  devilspie2 = callPackage ../applications/misc/devilspie2 {
    gtk = gtk3;
  };

  dex = callPackage ../tools/X11/dex { };

  ddccontrol = callPackage ../tools/misc/ddccontrol { };

  ddccontrol-db = callPackage ../data/misc/ddccontrol-db { };

  ddcutil = callPackage ../tools/misc/ddcutil { };

  ddclient = callPackage ../tools/networking/ddclient { };

  dd_rescue = callPackage ../tools/system/dd_rescue { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  ddrescueview = callPackage ../tools/system/ddrescueview { };

  ddrutility = callPackage ../tools/system/ddrutility { };

  deluge = callPackage ../applications/networking/p2p/deluge {
    pythonPackages = python2Packages;
  };

  desktop-file-utils = callPackage ../tools/misc/desktop-file-utils { };

  dfc  = callPackage ../tools/system/dfc { };

  dev86 = callPackage ../development/compilers/dev86 { };

  diskrsync = callPackage ../tools/backup/diskrsync {
    buildGoPackage = buildGo110Package;
  };

  djbdns = callPackage ../tools/networking/djbdns { };

  dnscrypt-proxy = callPackage ../tools/networking/dnscrypt-proxy/1.x { };

  dnscrypt-proxy2 = callPackage ../tools/networking/dnscrypt-proxy/2.x {
    buildGoPackage = buildGo110Package;
  };

  dnscrypt-wrapper = callPackage ../tools/networking/dnscrypt-wrapper { };

  dnsmasq = callPackage ../tools/networking/dnsmasq { };

  dnsperf = callPackage ../tools/networking/dnsperf { };

  dnstop = callPackage ../tools/networking/dnstop { };

  dhcp = callPackage ../tools/networking/dhcp { };

  dhcpdump = callPackage ../tools/networking/dhcpdump { };

  dhcpcd = callPackage ../tools/networking/dhcpcd { };

  dhcping = callPackage ../tools/networking/dhcping { };

  di = callPackage ../tools/system/di { };

  diction = callPackage ../tools/text/diction { };

  diffoscope = callPackage ../tools/misc/diffoscope {
    jdk = jdk8;
  };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (pythonPackages) mutagen python wrapPython;
  };

  wgetpaste = callPackage ../tools/text/wgetpaste { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  disper = callPackage ../tools/misc/disper { };

  dleyna-connector-dbus = callPackage ../development/libraries/dleyna-connector-dbus { };

  dleyna-core = callPackage ../development/libraries/dleyna-core { };

  dleyna-renderer = callPackage ../development/libraries/dleyna-renderer { };

  dleyna-server = callPackage ../development/libraries/dleyna-server { };

  dmd = callPackage ../development/compilers/dmd { };

  dmg2img = callPackage ../tools/misc/dmg2img { };

  docbook2odf = callPackage ../tools/typesetting/docbook2odf {
    inherit (perlPackages) PerlMagick;
  };

  doas = callPackage ../tools/security/doas { };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLSAXBase XMLParser XMLNamespaceSupport;
  };

  docbook2mdoc = callPackage ../tools/misc/docbook2mdoc { };

  dockbarx = callPackage ../applications/misc/dockbarx { };

  dog = callPackage ../tools/system/dog { };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dolphinEmu = callPackage ../misc/emulators/dolphin-emu { };
  dolphinEmuMaster = callPackage ../misc/emulators/dolphin-emu/master.nix {
    inherit (darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL;
    inherit (darwin) cf-private;
  };

  doomseeker = qt5.callPackage ../applications/misc/doomseeker { };

  doom-bcc = callPackage ../games/zdoom/bcc-git.nix { };

  slade = callPackage ../applications/misc/slade {
    wxGTK = wxGTK30;
  };

  sladeUnstable = callPackage ../applications/misc/slade/git.nix {
    wxGTK = wxGTK30;
  };

  drive = callPackage ../applications/networking/drive { };

  driftnet = callPackage ../tools/networking/driftnet {};

  drone = callPackage ../development/tools/continuous-integration/drone { };

  drone-cli = callPackage ../development/tools/continuous-integration/drone-cli { };

  dropbear = callPackage ../tools/networking/dropbear { };

  dtach = callPackage ../tools/misc/dtach { };

  dtc = callPackage ../development/compilers/dtc { };

  dub = callPackage ../development/tools/build-managers/dub { };

  duc = callPackage ../tools/misc/duc { };

  duff = callPackage ../tools/filesystems/duff { };

  dumptorrent = callPackage ../tools/misc/dumptorrent { };

  duo-unix = callPackage ../tools/security/duo-unix { };

  duplicati = callPackage ../tools/backup/duplicati { };

  duplicity = callPackage ../tools/backup/duplicity {
    gnupg = gnupg1;
  };

  duply = callPackage ../tools/backup/duply { };

  dvdisaster = callPackage ../tools/cd-dvd/dvdisaster { };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  ecmtools = callPackage ../tools/cd-dvd/ecm-tools { };

  e2tools = callPackage ../tools/filesystems/e2tools { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  easyrsa2 = callPackage ../tools/networking/easyrsa/2.x.nix { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  ecryptfs-helper = callPackage ../tools/security/ecryptfs/helper.nix { };

  edid-decode = callPackage ../tools/misc/edid-decode { };

  editres = callPackage ../tools/graphics/editres { };

  edit = callPackage ../applications/editors/edit { };

  edk2 = callPackage ../development/compilers/edk2 { };

  eff = callPackage ../development/interpreters/eff { };

  eflite = callPackage ../applications/audio/eflite {};

  eid-mw = callPackage ../tools/security/eid-mw { };

  mcrcon = callPackage ../tools/networking/mcrcon {};

  s-tar = callPackage ../tools/archivers/s-tar {};

  tealdeer = callPackage ../tools/misc/tealdeer { };

  uudeview = callPackage ../tools/misc/uudeview { };

  uutils-coreutils = callPackage ../tools/misc/uutils-coreutils {
    inherit (pythonPackages) sphinx;
  };

  zabbix-cli = callPackage ../tools/misc/zabbix-cli { };

  ### DEVELOPMENT / EMSCRIPTEN

  buildEmscriptenPackage = callPackage ../development/em-modules/generic { };

  emscriptenVersion = "1.37.36";

  emscripten = callPackage ../development/compilers/emscripten { };

  emscriptenfastcompPackages = callPackage ../development/compilers/emscripten/fastcomp { };

  emscriptenfastcomp = emscriptenfastcompPackages.emscriptenfastcomp;

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // { mkDerivation = buildEmscriptenPackage; };

  efibootmgr = callPackage ../tools/system/efibootmgr { };

  efivar = callPackage ../tools/system/efivar { };

  evemu = callPackage ../tools/system/evemu { };

  # The latest version used by elasticsearch, logstash, kibana and the the beats from elastic.
  elk5Version = "5.6.9";
  elk6Version = "6.3.2";

  elasticsearch5 = callPackage ../servers/search/elasticsearch/5.x.nix { };
  elasticsearch6 = callPackage ../servers/search/elasticsearch { };
  elasticsearch6-oss = callPackage ../servers/search/elasticsearch {
    enableUnfree = false;
  };
  elasticsearch = elasticsearch6;
  elasticsearch-oss = elasticsearch6-oss;

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ../servers/search/elasticsearch/plugins.nix { }
  );

  embree2 = callPackage ../development/libraries/embree/2.x.nix { };

  emem = callPackage ../applications/misc/emem { };

  emv = callPackage ../tools/misc/emv { };

  enblend-enfuse = callPackage ../tools/graphics/enblend-enfuse { };

  cryfs = callPackage ../tools/filesystems/cryfs {
    spdlog = spdlog_0;
  };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  enscript = callPackage ../tools/text/enscript { };

  entr = callPackage ../tools/misc/entr { };

  envoy = callPackage ../tools/networking/envoy {
    bazel = bazel_0_4;
  };

  eot_utilities = callPackage ../tools/misc/eot-utilities { };

  eplot = callPackage ../tools/graphics/eplot { };

  epstool = callPackage ../tools/graphics/epstool { };

  epsxe = callPackage ../misc/emulators/epsxe { };

  escrotum = callPackage ../tools/graphics/escrotum {
    inherit (pythonPackages) buildPythonApplication pygtk numpy;
  };

  ethtool = callPackage ../tools/misc/ethtool { };

  ettercap = callPackage ../applications/networking/sniffers/ettercap { };

  euca2ools = callPackage ../tools/virtualization/euca2ools { };

  eventstat = callPackage ../os-specific/linux/eventstat { };

  evtest = callPackage ../applications/misc/evtest { };

  exa = callPackage ../tools/misc/exa { };

  exempi = callPackage ../development/libraries/exempi {
    stdenv = if stdenv.isi686 then overrideCC stdenv gcc6 else stdenv;
  };

  execline = skawarePackages.execline;

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  exiftool = perlPackages.ImageExifTool;

  ext4magic = callPackage ../tools/filesystems/ext4magic { };

  extract_url = callPackage ../applications/misc/extract_url {
    inherit (perlPackages) MIMEtools HTMLParser CursesUI URIFind;
  };

  extundelete = callPackage ../tools/filesystems/extundelete { };

  expect = callPackage ../tools/misc/expect { };

  f2fs-tools = callPackage ../tools/filesystems/f2fs-tools { };

  Fabric = python2Packages.Fabric;

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fakeroute = callPackage ../tools/networking/fakeroute { };

  fakechroot = callPackage ../tools/system/fakechroot { };

  fast-neural-doodle = callPackage ../tools/graphics/fast-neural-doodle {
    inherit (python27Packages) numpy scipy h5py scikitlearn python
      pillow;
  };

  fastpbkdf2 = callPackage ../development/libraries/fastpbkdf2 { };

  fanficfare = callPackage ../tools/text/fanficfare { };

  fastd = callPackage ../tools/networking/fastd { };

  fatsort = callPackage ../tools/filesystems/fatsort { };

  fcitx = callPackage ../tools/inputmethods/fcitx {
    plugins = [];
  };

  fcitx-engines = recurseIntoAttrs {

    anthy = callPackage ../tools/inputmethods/fcitx-engines/fcitx-anthy { };

    chewing = callPackage ../tools/inputmethods/fcitx-engines/fcitx-chewing { };

    hangul = callPackage ../tools/inputmethods/fcitx-engines/fcitx-hangul { };

    unikey = callPackage ../tools/inputmethods/fcitx-engines/fcitx-unikey { };

    rime = callPackage ../tools/inputmethods/fcitx-engines/fcitx-rime { };

    m17n = callPackage ../tools/inputmethods/fcitx-engines/fcitx-m17n { };

    mozc = callPackage ../tools/inputmethods/fcitx-engines/fcitx-mozc rec {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

    table-extra = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-extra { };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

    cloudpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-cloudpinyin { };

    libpinyin = libsForQt5.callPackage ../tools/inputmethods/fcitx-engines/fcitx-libpinyin { };

    skk = callPackage ../tools/inputmethods/fcitx-engines/fcitx-skk { };
  };

  fcitx-configtool = callPackage ../tools/inputmethods/fcitx/fcitx-configtool.nix { };

  fcppt = callPackage ../development/libraries/fcppt { };

  fcrackzip = callPackage ../tools/security/fcrackzip { };

  fcron = callPackage ../tools/system/fcron { };

  fdm = callPackage ../tools/networking/fdm {};

  feedreader = callPackage ../applications/networking/feedreaders/feedreader {};

  ferm = callPackage ../tools/networking/ferm { };

  fgallery = callPackage ../tools/graphics/fgallery {
    inherit (perlPackages) ImageExifTool CpanelJSONXS;
  };

  flannel = callPackage ../tools/networking/flannel { };

  flashbench = callPackage ../os-specific/linux/flashbench { };

  flatpak = callPackage ../development/libraries/flatpak { };

  flatpak-builder = callPackage ../development/tools/flatpak-builder { };

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file {
    inherit (windows) libgnurx;
  };

  filegive = callPackage ../tools/networking/filegive { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  iprange = callPackage ../applications/networking/firehol/iprange.nix {};

  firehol = callPackage ../applications/networking/firehol {};

  fio = callPackage ../tools/system/fio { };

  firebird-emu = libsForQt5.callPackage ../misc/emulators/firebird-emu { };

  flamerobin = callPackage ../applications/misc/flamerobin { };

  flashtool = pkgsi686Linux.callPackage ../development/mobile/flashtool {
    platformTools = androidenv.platformTools;
  };

  flashrom = callPackage ../tools/misc/flashrom { };

  flent = python3Packages.callPackage ../applications/networking/flent { };

  flpsed = callPackage ../applications/editors/flpsed { };

  fluentd = callPackage ../tools/misc/fluentd { };

  flvstreamer = callPackage ../tools/networking/flvstreamer { };

  hmetis = pkgsi686Linux.callPackage ../applications/science/math/hmetis { };

  libbsd = callPackage ../development/libraries/libbsd { };

  libbladeRF = callPackage ../development/libraries/libbladeRF { };

  lp_solve = callPackage ../applications/science/math/lp_solve { };

  lprof = callPackage ../tools/graphics/lprof { };

  fastlane = callPackage ../tools/admin/fastlane { };

  fatresize = callPackage ../tools/filesystems/fatresize {};

  fdk_aac = callPackage ../development/libraries/fdk-aac { };

  feedgnuplot = callPackage ../tools/graphics/feedgnuplot { };

  fim = callPackage ../tools/graphics/fim { };

  flac123 = callPackage ../applications/audio/flac123 { };

  flamegraph = callPackage ../development/tools/flamegraph { };

  flvtool2 = callPackage ../tools/video/flvtool2 { };

  fmbt = callPackage ../development/tools/fmbt {
    python = python2;
  };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  });
  fontforge-gtk = fontforge.override {
    withSpiro = true;
    withGTK = true;
    gtk2 = gtk2-x11;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  fontforge-fonttools = callPackage ../tools/misc/fontforge/fontforge-fonttools.nix {};

  fontmatrix = callPackage ../applications/graphics/fontmatrix {};

  foremost = callPackage ../tools/system/foremost { };

  forktty = callPackage ../os-specific/linux/forktty {};

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox {
    libpng = libpng12;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fpart = callPackage ../tools/misc/fpart { };

  fping = callPackage ../tools/networking/fping {};

  fpm = callPackage ../tools/package-management/fpm { };

  fprot = callPackage ../tools/security/fprot { };

  fprintd = callPackage ../tools/security/fprintd { };

  fprint_demo = callPackage ../tools/security/fprint_demo { };

  franz = callPackage ../applications/networking/instant-messengers/franz { };

  freedroidrpg = callPackage ../games/freedroidrpg { };

  freeipmi = callPackage ../tools/system/freeipmi {};

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk {
    guile = guile_2_0;
  };

  freetds = callPackage ../development/libraries/freetds { };

  frescobaldi = callPackage ../misc/frescobaldi {};

  frostwire = callPackage ../applications/networking/p2p/frostwire { };
  frostwire-bin = callPackage ../applications/networking/p2p/frostwire/frostwire-bin.nix { };

  ftgl = callPackage ../development/libraries/ftgl { };

  ftop = callPackage ../os-specific/linux/ftop { };

  fsfs = callPackage ../tools/filesystems/fsfs { };

  fstl = qt5.callPackage ../applications/graphics/fstl { };

  fswebcam = callPackage ../os-specific/linux/fswebcam { };

  fuseiso = callPackage ../tools/filesystems/fuseiso { };

  fdbPackages = callPackage ../servers/foundationdb {
    stdenv49 = overrideCC stdenv gcc49;
  };

  inherit (fdbPackages)
    foundationdb51
    foundationdb52
    foundationdb60;

  foundationdb = foundationdb52;

  fuse-7z-ng = callPackage ../tools/filesystems/fuse-7z-ng { };

  fwknop = callPackage ../tools/security/fwknop { };

  exfat = callPackage ../tools/filesystems/exfat { };

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  galen = callPackage ../development/tools/galen {};

  gandi-cli = callPackage ../tools/networking/gandi-cli { };

  garmin-plugin = callPackage ../applications/misc/garmin-plugin {};

  garmintools = callPackage ../development/libraries/garmintools {};

  gauge = callPackage ../development/tools/gauge { };

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawkInteractive = appendToName "interactive"
    (gawk.override { interactive = true; });

  gawp = callPackage ../tools/misc/gawp { };

  gazeboSimulator = recurseIntoAttrs rec {
    sdformat = gazeboSimulator.sdformat4;

    sdformat3 = callPackage ../development/libraries/sdformat/3.nix { };

    sdformat4 = callPackage ../development/libraries/sdformat { };

    gazebo6 = callPackage ../applications/science/robotics/gazebo/6.nix { boost = boost160; };

    gazebo6-headless = gazebo6.override { withHeadless = true;  };

    gazebo7 = callPackage ../applications/science/robotics/gazebo { };

    gazebo7-headless = gazebo7.override { withHeadless = true; };

  };

  # at present, Gazebo 7.0.0 does not match Gazebo 6.5.1 for compatibility
  gazebo = gazeboSimulator.gazebo6;

  gazebo-headless = gazeboSimulator.gazebo6-headless;

  gbdfed = callPackage ../tools/misc/gbdfed {
    gtk = gtk2-x11;
  };

  gdmap = callPackage ../tools/system/gdmap { };

  gen-oath-safe = callPackage ../tools/security/gen-oath-safe { };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  genimage = callPackage ../tools/filesystems/genimage { };

  gerrit = callPackage ../applications/version-management/gerrit { };

  geteltorito = callPackage ../tools/misc/geteltorito { };

  getmail = callPackage ../tools/networking/getmail { };

  getopt = callPackage ../tools/misc/getopt { };

  gftp = callPackage ../tools/networking/gftp { };

  ggobi = callPackage ../tools/graphics/ggobi { };

  gibo = callPackage ../tools/misc/gibo { };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  git-big-picture = callPackage ../applications/version-management/git-and-tools/git-big-picture { };

  git-crecord = callPackage ../applications/version-management/git-crecord { };

  git-lfs = lowPrio (callPackage ../applications/version-management/git-lfs { });

  git-lfs1 = callPackage ../applications/version-management/git-lfs/1.nix { };

  git-ftp = callPackage ../development/tools/git-ftp { };

  git-series = callPackage ../development/tools/git-series { };

  git-sizer = callPackage ../applications/version-management/git-sizer { };

  git-up = callPackage ../applications/version-management/git-up { };

  gitfs = callPackage ../tools/filesystems/gitfs { };

  gitinspector = callPackage ../applications/version-management/gitinspector { };

  gitkraken = callPackage ../applications/version-management/gitkraken { };

  gitlab = callPackage ../applications/version-management/gitlab { };

  gitlab-runner = callPackage ../development/tools/continuous-integration/gitlab-runner { };
  gitlab-runner_1_11 = callPackage ../development/tools/continuous-integration/gitlab-runner/v1.nix { };

  gitlab-shell = callPackage ../applications/version-management/gitlab-shell { };

  gitlab-workhorse = callPackage ../applications/version-management/gitlab-workhorse { };

  gitaly = callPackage ../applications/version-management/gitaly { };

  gitstats = callPackage ../applications/version-management/gitstats { };

  gogs = callPackage ../applications/version-management/gogs { };

  git-latexdiff = callPackage ../tools/typesetting/git-latexdiff { };

  gitea = callPackage ../applications/version-management/gitea { };

  glusterfs = callPackage ../tools/filesystems/glusterfs { };

  glmark2 = callPackage ../tools/graphics/glmark2 { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmrender-resurrect = callPackage ../tools/networking/gmrender-resurrect {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav;
  };

  gmvault = callPackage ../tools/networking/gmvault { };

  gnash = callPackage ../misc/gnash { };

  gnaural = callPackage ../applications/audio/gnaural {
    stdenv = overrideCC stdenv gcc49;
  };

  gnirehtet = callPackage ../tools/networking/gnirehtet { };

  gnome15 = callPackage ../applications/misc/gnome15 {
    inherit (gnome2) gnome_python gnome_python_desktop;
  };

  gnome-builder = callPackage ../applications/editors/gnome-builder { };

  gnokii = callPackage ../tools/misc/gnokii { };

  gnuapl = callPackage ../development/interpreters/gnu-apl { };

  gnu-cobol = callPackage ../development/compilers/gnu-cobol { };

  gnuclad = callPackage ../applications/graphics/gnuclad { };

  gnufdisk = callPackage ../tools/system/fdisk {
    guile = guile_1_8;
  };

  gnugrep = callPackage ../tools/text/gnugrep { };

  gnulib = callPackage ../development/tools/gnulib { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg/1.nix { };
  gnupg1compat = callPackage ../tools/security/gnupg/1compat.nix { };
  gnupg1 = gnupg1compat;    # use config.packageOverrides if you prefer original gnupg1
  gnupg20 = callPackage ../tools/security/gnupg/20.nix {
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg22 = callPackage ../tools/security/gnupg/22.nix {
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg = gnupg22;

  gnuplot = libsForQt5.callPackage ../tools/graphics/gnuplot { };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  gnu-pw-mgr = callPackage ../tools/security/gnu-pw-mgr { };

  gnused = callPackage ../tools/text/gnused { };
  # This is an easy work-around for [:space:] problems.
  gnused_422 = callPackage ../tools/text/gnused/422.nix { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  goaccess = callPackage ../tools/misc/goaccess { };

  gocryptfs = callPackage ../tools/filesystems/gocryptfs { };

  godot = callPackage ../development/tools/godot {};

  goklp = callPackage ../tools/networking/goklp {};

  go-mtpfs = callPackage ../tools/filesystems/go-mtpfs { };

  go-sct = callPackage ../tools/X11/go-sct { };

  # rename to upower-notify?
  go-upower-notify = callPackage ../tools/misc/upower-notify { };

  google-app-engine-go-sdk = callPackage ../development/tools/google-app-engine-go-sdk { };

  google-authenticator = callPackage ../os-specific/linux/google-authenticator { };

  google-cloud-sdk = python2.pkgs.google-cloud-sdk;
  google-cloud-sdk-gce = python2.pkgs.google-cloud-sdk-gce;

  google-fonts = callPackage ../data/fonts/google-fonts { };

  google-compute-engine = python2.pkgs.google-compute-engine;

  gource = callPackage ../applications/version-management/gource { };

  govc = callPackage ../tools/virtualization/govc { };

  gpart = callPackage ../tools/filesystems/gpart { };

  gparted = callPackage ../tools/misc/gparted { };

  ldmtool = callPackage ../tools/misc/ldmtool { };

  gpodder = callPackage ../applications/audio/gpodder { };

  gpp = callPackage ../development/tools/gpp { };

  gpredict = callPackage ../applications/science/astronomy/gpredict { };

  gptfdisk = callPackage ../tools/system/gptfdisk { };

  grafx2 = callPackage ../applications/graphics/grafx2 {};

  grails = callPackage ../development/web/grails { jdk = null; };

  graylog = callPackage ../tools/misc/graylog { };
  graylogPlugins = recurseIntoAttrs (
    callPackage ../tools/misc/graylog/plugins.nix { }
  );

  gprof2dot = callPackage ../development/tools/profiling/gprof2dot { };

  graphviz = callPackage ../tools/graphics/graphviz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  graphviz-nox = graphviz.override {
    xorg = null;
    libdevil = libdevil-nox;
  };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.32 but not 2.0 or 2.36. Please give a day's notice for
   * objections before removal. The feature is libgraph.
   */
  graphviz_2_32 = lib.overrideDerivation (callPackage ../tools/graphics/graphviz/2.32.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  }) (x: { configureFlags = x.configureFlags ++ ["--with-cgraph=no"];});

  grin = callPackage ../tools/text/grin { };

  ripgrep = callPackage ../tools/text/ripgrep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  grive2 = callPackage ../tools/filesystems/grive2 { };

  groff = callPackage ../tools/text/groff {
    ghostscript = null;
    psutils = null;
    netpbm = null;
  };

  gromit-mpx = callPackage ../tools/graphics/gromit-mpx {
    gtk = gtk3;
    libappindicator = libappindicator-gtk3;
    inherit (xorg) libXdmcp;
  };

  gron = callPackage ../development/tools/gron { };

  groonga = callPackage ../servers/search/groonga { };

  grub = pkgsi686Linux.callPackage ../tools/misc/grub {
    buggyBiosCDSupport = config.grub.buggyBiosCDSupport or true;
    stdenv = overrideCC stdenv pkgsi686Linux.gcc6;
  };

  trustedGrub = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { };

  trustedGrub-for-HP = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { for_HP_laptop = true; };

  grub2 = grub2_full;

  grub2_full = callPackage ../tools/misc/grub/2.0x.nix { };

  grub2_efi = grub2.override {
    efiSupport = true;
  };

  grub2_light = grub2.override {
    zfsSupport = false;
  };

  grub2_xen = grub2_full.override {
    xenSupport = true;
  };

  grub2_pvgrub_image = callPackage ../tools/misc/grub/pvgrub_image { };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  gx = callPackage ../tools/package-management/gx {
    buildGoPackage = buildGo110Package;
  };
  gx-go = callPackage ../tools/package-management/gx/go {
    buildGoPackage = buildGo110Package;
  };

  sbsigntool = callPackage ../tools/security/sbsigntool { };

  gsmartcontrol = callPackage ../tools/misc/gsmartcontrol { };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome2) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtest = callPackage ../development/libraries/gtest {};
  gmock = gtest; # TODO: move to aliases.nix

  gbenchmark = callPackage ../development/libraries/gbenchmark {};

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtklick = callPackage ../applications/audio/gtklick {};

  gtdialog = callPackage ../development/libraries/gtdialog {};

  gtkd = callPackage ../development/libraries/gtkd { };

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkperf = callPackage ../development/tools/misc/gtkperf { };

  gtk-vnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess { };

  gup = callPackage ../development/tools/build-managers/gup {};

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome2) libsoup;
  };

  gupnp-av = callPackage ../development/libraries/gupnp-av {};

  gupnp-dlna = callPackage ../development/libraries/gupnp-dlna {};

  gupnp-igd = callPackage ../development/libraries/gupnp-igd {};

  gupnp-tools = callPackage ../tools/networking/gupnp-tools {};

  gvpe = callPackage ../tools/networking/gvpe { };

  gvolicon = callPackage ../tools/audio/gvolicon {};

  gzip = callPackage ../tools/compression/gzip { };

  gzrt = callPackage ../tools/compression/gzrt { };

  httplab = callPackage ../tools/networking/httplab { };

  partclone = callPackage ../tools/backup/partclone { };

  partimage = callPackage ../tools/backup/partimage { };

  pgf_graphics = callPackage ../tools/graphics/pgf { };

  pgjwt = callPackage ../servers/sql/postgresql/pgjwt {};

  cstore_fdw = callPackage ../servers/sql/postgresql/cstore_fdw {};

  pg_hll = callPackage ../servers/sql/postgresql/pg_hll {};

  pg_cron = callPackage ../servers/sql/postgresql/pg_cron {};

  pgtap = callPackage ../servers/sql/postgresql/pgtap {};

  pg_topn = callPackage ../servers/sql/postgresql/topn {};

  pigz = callPackage ../tools/compression/pigz { };

  pixz = callPackage ../tools/compression/pixz { };

  pxattr = callPackage ../tools/archivers/pxattr { };

  pxz = callPackage ../tools/compression/pxz { };

  hans = callPackage ../tools/networking/hans { };

  h2 = callPackage ../servers/h2 { };

  h5utils = callPackage ../tools/misc/h5utils {
    libmatheval = null;
    hdf4 = null;
  };

  haproxy = callPackage ../tools/networking/haproxy { };

  haveged = callPackage ../tools/security/haveged { };

  habitat = callPackage ../applications/networking/cluster/habitat { };

  hardlink = callPackage ../tools/system/hardlink { };

  hashcat = callPackage ../tools/security/hashcat { };

  hash_extender = callPackage ../tools/security/hash_extender { };

  hash-slinger = callPackage ../tools/security/hash-slinger { };

  hal-flash = callPackage ../os-specific/linux/hal-flash { };

  half = callPackage ../development/libraries/half { };

  halibut = callPackage ../tools/typesetting/halibut { };

  halide = callPackage ../development/compilers/halide {};

  hardinfo = callPackage ../tools/system/hardinfo { };

  hdapsd = callPackage ../os-specific/linux/hdapsd { };

  hdaps-gl = callPackage ../tools/misc/hdaps-gl { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

  hdf4 = callPackage ../tools/misc/hdf4 {
    szip = null;
  };

  hdf5 = callPackage ../tools/misc/hdf5 {
    gfortran = null;
    szip = null;
    mpi = null;
  };

  hdf5_1_8 = callPackage ../tools/misc/hdf5/1_8.nix {
    gfortran = null;
    szip = null;
    mpi = null;
  };

  hdf5-mpi = appendToName "mpi" (hdf5.override {
    szip = null;
    mpi = pkgs.openmpi;
  });

  hdf5-cpp = appendToName "cpp" (hdf5.override {
    cpp = true;
  });

  hdf5-fortran = appendToName "fortran" (hdf5.override {
    inherit gfortran;
  });

  hdf5-threadsafe = appendToName "threadsafe" (hdf5.overrideAttrs (oldAttrs: {
      # Threadsafe hdf5
      # However, hdf5 hl (High Level) library is not considered stable
      # with thread safety and should be disabled.
      configureFlags = oldAttrs.configureFlags ++ ["--enable-threadsafe" "--disable-hl" ];
  }));

  hdfview = callPackage ../tools/misc/hdfview {
    javac = jdk;
  };

  hdf_java = callPackage ../tools/misc/hdfjava {
    javac = jdk;
  };

  hecate = callPackage ../applications/editors/hecate { };

  heaptrack = libsForQt5.callPackage ../development/tools/profiling/heaptrack {};

  heimdall = libsForQt5.callPackage ../tools/misc/heimdall { };

  heimdall-gui = heimdall.override { enableGUI = true; };

  hevea = callPackage ../tools/typesetting/hevea { };

  hexd = callPackage ../tools/misc/hexd { };
  pixd = callPackage ../tools/misc/pixd { };

  hhpc = callPackage ../tools/misc/hhpc { };

  hiera-eyaml = callPackage ../tools/system/hiera-eyaml { };

  hfsprogs = callPackage ../tools/filesystems/hfsprogs { };

  highlight = callPackage ../tools/text/highlight ({
    lua = lua5;
  } // lib.optionalAttrs stdenv.isDarwin {
    # doesn't build with clang_37
    inherit (llvmPackages_38) stdenv;
  });

  holochain-go = callPackage ../servers/holochain-go { };

  homesick = callPackage ../tools/misc/homesick { };

  honcho = callPackage ../tools/system/honcho { };

  horst = callPackage ../tools/networking/horst { };

  host = bind.host;

  hotpatch = callPackage ../development/libraries/hotpatch { };

  hotspot = libsForQt5.callPackage ../development/tools/analysis/hotspot { };

  hping = callPackage ../tools/networking/hping { };

  html-proofer = callPackage ../tools/misc/html-proofer { };

  htpdate = callPackage ../tools/networking/htpdate { };

  http-prompt = callPackage ../tools/networking/http-prompt { };

  http-getter = callPackage ../applications/networking/flent/http-getter.nix { };

  httpie = callPackage ../tools/networking/httpie { };

  httping = callPackage ../tools/networking/httping {};

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  httpstat = callPackage ../tools/networking/httpstat { };

  httptunnel = callPackage ../tools/networking/httptunnel { };

  hubicfuse = callPackage ../tools/filesystems/hubicfuse { };

  hwinfo = callPackage ../tools/system/hwinfo { };

  hylafaxplus = callPackage ../servers/hylafaxplus { };

  i2c-tools = callPackage ../os-specific/linux/i2c-tools { };

  i2p = callPackage ../tools/networking/i2p {};

  i2pd = callPackage ../tools/networking/i2pd {
    boost = boost165;
  };

  i-score = libsForQt5.callPackage ../applications/audio/i-score { };

  iasl = callPackage ../development/compilers/iasl { };

  iannix = libsForQt5.callPackage ../applications/audio/iannix { };

  ibniz = callPackage ../tools/graphics/ibniz { };

  icecast = callPackage ../servers/icecast { };

  darkice = callPackage ../tools/audio/darkice { };

  deco = callPackage ../applications/misc/deco { };

  icoutils = callPackage ../tools/graphics/icoutils { };

  idutils = callPackage ../tools/misc/idutils { };

  idle3tools = callPackage ../tools/system/idle3tools { };

  iftop = callPackage ../tools/networking/iftop { };

  ifuse = callPackage ../tools/filesystems/ifuse { };

  inherit (callPackages ../tools/filesystems/irods rec {
            stdenv = llvmPackages_38.libcxxStdenv;
            libcxx = llvmPackages_38.libcxx;
            boost = boost160.override { inherit stdenv; };
            avro-cpp_llvm = avro-cpp.override { inherit stdenv boost; };
          })
      irods
      irods-icommands;

  ignition = recurseIntoAttrs {

    math = callPackage ../development/libraries/ignition-math { };

    math2 = ignition.math;

    transport0 = callPackage ../development/libraries/ignition-transport/0.9.0.nix { };

    transport1 = callPackage ../development/libraries/ignition-transport/1.0.1.nix { };

    transport = ignition.transport0;
  };


  ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;

    jupyter = python3.withPackages (ps: [ ps.jupyter ps.notebook ]);

    packages = config.ihaskell.packages or (self: []);
  };

  imapproxy = callPackage ../tools/networking/imapproxy { };

  imapsync = callPackage ../tools/networking/imapsync { };

  imgur-screenshot = callPackage ../tools/graphics/imgur-screenshot { };

  imgurbash2 = callPackage ../tools/graphics/imgurbash2 { };

  inadyn = callPackage ../tools/networking/inadyn { };

  inboxer = callPackage ../applications/networking/mailreaders/inboxer { };

  incron = callPackage ../tools/system/incron { };

  inetutils = callPackage ../tools/networking/inetutils { };

  infiniband-diags = callPackage ../tools/networking/infiniband-diags { };

  inform7 = callPackage ../development/compilers/inform7 { };

  infamousPlugins = callPackage ../applications/audio/infamousPlugins { };

  innoextract = callPackage ../tools/archivers/innoextract { };

  input-utils = callPackage ../os-specific/linux/input-utils { };

  intecture-agent = callPackage ../tools/admin/intecture/agent.nix { };

  intecture-auth = callPackage ../tools/admin/intecture/auth.nix { };

  intecture-cli = callPackage ../tools/admin/intecture/cli.nix { };

  invoice2data  = callPackage ../tools/text/invoice2data  { };

  iodine = callPackage ../tools/networking/iodine { };

  ioping = callPackage ../tools/system/ioping { };

  iops = callPackage ../tools/system/iops { };

  ior = callPackage ../tools/system/ior { };

  iouyap = callPackage ../tools/networking/iouyap { };

  ip2location = callPackage ../tools/networking/ip2location { };

  ipad_charge = callPackage ../tools/misc/ipad_charge { };

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = iperf3;

  ipfs = callPackage ../applications/networking/ipfs { };
  ipfs-migrator = callPackage ../applications/networking/ipfs-migrator { };
  ipfs-cluster = callPackage ../applications/networking/ipfs-cluster { };

  ipget = callPackage ../applications/networking/ipget {
    buildGoPackage = buildGo110Package;
  };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  ipmiutil = callPackage ../tools/system/ipmiutil {};

  ipmicfg = callPackage ../applications/misc/ipmicfg {};

  ipmiview = callPackage ../applications/misc/ipmiview {};

  ipcalc = callPackage ../tools/networking/ipcalc {};

  netmask = callPackage ../tools/networking/netmask {};

  ipv6calc = callPackage ../tools/networking/ipv6calc {};

  ipxe = callPackage ../tools/misc/ipxe { };

  irker = callPackage ../servers/irker { };

  ised = callPackage ../tools/misc/ised {};

  isl = isl_0_17;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_12 = callPackage ../development/libraries/isl/0.12.2.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_15 = callPackage ../development/libraries/isl/0.15.0.nix { };
  isl_0_17 = callPackage ../development/libraries/isl/0.17.1.nix { };

  ispike = callPackage ../development/libraries/science/robotics/ispike { };

  isync = callPackage ../tools/networking/isync { };
  isyncUnstable = callPackage ../tools/networking/isync/unstable.nix { };

  ivan = callPackage ../games/ivan { };

  jaaa = callPackage ../applications/audio/jaaa { };

  jackett = callPackage ../servers/jackett {
    mono = mono5;
  };

  jade = callPackage ../tools/text/sgml/jade { };

  jazzy = callPackage ../development/tools/jazzy { };

  jd = callPackage ../development/tools/jd { };

  jd-gui = callPackage ../tools/security/jd-gui { };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jekyll = callPackage ../applications/misc/jekyll { };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jing = self.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang { };

  jira-cli = callPackage ../development/tools/jira_cli { };

  jl = haskellPackages.callPackage ../development/tools/jl { };

  jmespath = callPackage ../development/tools/jmespath { };

  jmtpfs = callPackage ../tools/filesystems/jmtpfs { };

  jnettop = callPackage ../tools/networking/jnettop { };

  go-jira = callPackage ../applications/misc/go-jira { };

  john = callPackage ../tools/security/john { };

  journalbeat = callPackage ../tools/system/journalbeat { };

  journaldriver = callPackage ../tools/misc/journaldriver { };

  jp = callPackage ../development/tools/jp { };

  jp2a = callPackage ../applications/misc/jp2a { };

  jpegoptim = callPackage ../applications/graphics/jpegoptim { };

  jpegrescan = callPackage ../applications/graphics/jpegrescan { };

  jq = callPackage ../development/tools/jq { };

  jo = callPackage ../development/tools/jo { };

  jrnl = callPackage ../applications/misc/jrnl { };

  jsawk = callPackage ../tools/text/jsawk { };

  jscoverage = callPackage ../development/tools/misc/jscoverage { };

  jsduck = callPackage ../development/tools/jsduck { };

  jucipp = callPackage ../applications/editors/jucipp { };

  jupp = callPackage ../applications/editors/jupp { };

  jupyter = callPackage ../applications/editors/jupyter { };

  jupyter-kernel = callPackage ../applications/editors/jupyter/kernel.nix { };

  jwhois = callPackage ../tools/networking/jwhois { };

  k2pdfopt = callPackage ../applications/misc/k2pdfopt { };

  kargo = callPackage ../tools/misc/kargo { };

  kazam = callPackage ../applications/video/kazam { };

  kalibrate-rtl = callPackage ../tools/misc/kalibrate-rtl { };

  kalibrate-hackrf = callPackage ../tools/misc/kalibrate-hackrf { };

  kakoune = callPackage ../applications/editors/kakoune { };

  kbdd = callPackage ../applications/window-managers/kbdd { };

  kdbplus = pkgsi686Linux.callPackage ../applications/misc/kdbplus { };

  kde2-decoration = libsForQt5.callPackage ../misc/themes/kde2 { };

  keepalived = callPackage ../tools/networking/keepalived { };

  kexectools = callPackage ../os-specific/linux/kexectools { };

  keybase = callPackage ../tools/security/keybase {
    # Reasoning for the inherited apple_sdk.frameworks:
    # 1. specific compiler errors about: AVFoundation, AudioToolbox, MediaToolbox
    # 2. the rest are added from here: https://github.com/keybase/client/blob/68bb8c893c5214040d86ea36f2f86fbb7fac8d39/go/chat/attachments/preview_darwin.go#L7
    #      #cgo LDFLAGS: -framework AVFoundation -framework CoreFoundation -framework ImageIO -framework CoreMedia  -framework Foundation -framework CoreGraphics -lobjc
    #    with the exception of CoreFoundation, due to the warning in https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix#L25
    inherit (darwin.apple_sdk.frameworks) AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox;
  };

  kbfs = callPackage ../tools/security/kbfs { };

  keybase-gui = callPackage ../tools/security/keybase/gui.nix { };

  keychain = callPackage ../tools/misc/keychain { };

  keyfuzz = callPackage ../tools/inputmethods/keyfuzz { };

  kibana5 = callPackage ../development/tools/misc/kibana/5.x.nix { };
  kibana6 = callPackage ../development/tools/misc/kibana/default.nix { };
  kibana6-oss = callPackage ../development/tools/misc/kibana/default.nix {
    enableUnfree = false;
  };
  kibana = kibana6;
  kibana-oss = kibana6-oss;

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  klick = callPackage ../applications/audio/klick { };

  knockknock = callPackage ../tools/security/knockknock { };

  kore = callPackage ../development/web/kore { };

  krakenx = callPackage ../tools/system/krakenx { };

  partition-manager = libsForQt5.callPackage ../tools/misc/partition-manager { };

  kpcli = callPackage ../tools/security/kpcli { };

  krename = libsForQt5.callPackage ../applications/misc/krename { };

  krunner-pass = libsForQt5.callPackage ../tools/security/krunner-pass { };

  kronometer = libsForQt5.callPackage ../tools/misc/kronometer { };

  krop = callPackage ../applications/graphics/krop { };

  elisa = libsForQt5.callPackage ../applications/audio/elisa { };

  kdiff3 = libsForQt5.callPackage ../tools/text/kdiff3 { };

  kwalletcli = libsForQt5.callPackage ../tools/security/kwalletcli { };

  peruse = libsForQt5.callPackage ../tools/misc/peruse { };

  kst = libsForQt5.callPackage ../tools/graphics/kst { gsl = gsl_1; };

  kytea = callPackage ../tools/text/kytea { };

  ldc = callPackage ../development/compilers/ldc { };

  lbreakout2 = callPackage ../games/lbreakout2 { };

  lego = callPackage ../tools/admin/lego { };

  leocad = callPackage ../applications/graphics/leocad { };

  less = callPackage ../tools/misc/less { };

  lf = callPackage ../tools/misc/lf {};

  lhasa = callPackage ../tools/compression/lhasa {};

  libcpuid = callPackage ../tools/misc/libcpuid { };

  libscrypt = callPackage ../development/libraries/libscrypt { };

  libcloudproviders = callPackage ../development/libraries/libcloudproviders { };

  libsmi = callPackage ../development/libraries/libsmi { };

  lesspipe = callPackage ../tools/misc/lesspipe { };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg_2;
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  lksctp-tools = callPackage ../os-specific/linux/lksctp-tools { };

  lldpd = callPackage ../tools/networking/lldpd { };

  lnav = callPackage ../tools/misc/lnav { };

  loadlibrary = callPackage ../tools/misc/loadlibrary { };

  loc = callPackage ../development/misc/loc { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash5 = callPackage ../tools/misc/logstash/5.x.nix { };
  logstash6 = callPackage ../tools/misc/logstash { };
  logstash6-oss = callPackage ../tools/misc/logstash {
    enableUnfree = false;
  };
  logstash = logstash6;

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  logstash-forwarder = callPackage ../tools/misc/logstash-forwarder { };

  lolcat = callPackage ../tools/misc/lolcat { };

  lsdvd = callPackage ../tools/cd-dvd/lsdvd {};

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

  ltwheelconf = callPackage ../applications/misc/ltwheelconf { };

  lvmsync = callPackage ../tools/backup/lvmsync { };

  kippo = callPackage ../servers/kippo { };

  kzipmix = pkgsi686Linux.callPackage ../tools/compression/kzipmix { };

  mailcatcher = callPackage ../development/web/mailcatcher { };

  makebootfat = callPackage ../tools/misc/makebootfat { };

  matrix-synapse = callPackage ../servers/matrix-synapse { };

  mdbook = callPackage ../tools/text/mdbook {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  medfile = callPackage ../development/libraries/medfile {
    hdf5 = hdf5_1_8;
  };

  memtester = callPackage ../tools/system/memtester { };

  minergate = callPackage ../applications/misc/minergate { };

  minergate-cli = callPackage ../applications/misc/minergate-cli { };

  minidlna = callPackage ../tools/networking/minidlna { };

  minisign = callPackage ../tools/security/minisign { };

  ministat = callPackage ../tools/misc/ministat { };

  mmv = callPackage ../tools/misc/mmv { };

  most = callPackage ../tools/misc/most { };

  motion = callPackage ../applications/video/motion { };

  mtail = callPackage ../servers/monitoring/mtail { };

  multitail = callPackage ../tools/misc/multitail { };

  mxt-app = callPackage ../misc/mxt-app { };

  nagstamon = callPackage ../tools/misc/nagstamon {
    pythonPackages = python3Packages;
  };

  netdata = callPackage ../tools/system/netdata { };

  netsurf = recurseIntoAttrs (let callPackage = newScope pkgs.netsurf; in rec {
    # ui could be gtk, sixel or framebuffer. Note that console display (sixel)
    # requires a terminal that supports `sixel` capabilities such as mlterm
    # or xterm -ti 340
    ui = "sixel";

    uilib = if ui == "gtk" then "gtk" else "framebuffer";

    SDL = if ui == "gtk" then null else if ui == "sixel" then SDL_sixel else SDL;

    buildsystem = callPackage ../applications/misc/netsurf/buildsystem { };

    libwapcaplet = callPackage ../applications/misc/netsurf/libwapcaplet { };

    nsgenbind = callPackage ../applications/misc/netsurf/nsgenbind { };

    libparserutils = callPackage ../applications/misc/netsurf/libparserutils { };

    libcss = callPackage ../applications/misc/netsurf/libcss { };

    libhubbub = callPackage ../applications/misc/netsurf/libhubbub { };

    libdom = callPackage ../applications/misc/netsurf/libdom { };

    libnsbmp = callPackage ../applications/misc/netsurf/libnsbmp { };

    libnsgif = callPackage ../applications/misc/netsurf/libnsgif { };

    libnsfb = callPackage ../applications/misc/netsurf/libnsfb { };

    libnsutils = callPackage ../applications/misc/netsurf/libnsutils { };

    libutf8proc = callPackage ../applications/misc/netsurf/libutf8proc { };

    browser = callPackage ../applications/misc/netsurf/browser { };

  });

  netperf = callPackage ../applications/networking/netperf { };

  netsniff-ng = callPackage ../tools/networking/netsniff-ng { };

  nginx-config-formatter = callPackage ../tools/misc/nginx-config-formatter { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nixnote2 = libsForQt5.callPackage ../applications/misc/nixnote2 { };

  nodejs = hiPrio nodejs-8_x;

  nodejs-slim = nodejs-slim-6_x;

  nodejs-6_x = callPackage ../development/web/nodejs/v6.nix {};
  nodejs-slim-6_x = callPackage ../development/web/nodejs/v6.nix { enableNpm = false; };

  nodejs-8_x = callPackage ../development/web/nodejs/v8.nix {};
  nodejs-slim-8_x = callPackage ../development/web/nodejs/v8.nix { enableNpm = false; };

  nodejs-10_x = callPackage ../development/web/nodejs/v10.nix {
    openssl = openssl_1_1;
  };
  nodejs-slim-10_x = callPackage ../development/web/nodejs/v10.nix {
    enableNpm = false;
    openssl = openssl_1_1;
  };

  nodePackages_10_x = callPackage ../development/node-packages/default-v10.nix {
    nodejs = pkgs.nodejs-10_x;
  };

  nodePackages_8_x = callPackage ../development/node-packages/default-v8.nix {
    nodejs = pkgs.nodejs-8_x;
  };

  nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
    nodejs = pkgs.nodejs-6_x;
  };

  nodePackages = nodePackages_8_x;

  npm2nix = nodePackages.npm2nix;

  file-rename = callPackage ../tools/filesystems/file-rename { };

  kea = callPackage ../tools/networking/kea {
    boost = boost165;
  };

  ispell = callPackage ../tools/text/ispell {};

  jumanpp = callPackage ../tools/text/jumanpp {};

  kindlegen = callPackage ../tools/typesetting/kindlegen { };

  latex2html = callPackage ../tools/misc/latex2html { };

  ldapvi = callPackage ../tools/misc/ldapvi { };

  ldns = callPackage ../development/libraries/ldns {
    openssl = openssl_1_1;
  };

  leafpad = callPackage ../applications/editors/leafpad { };

  leatherman = callPackage ../development/libraries/leatherman { };

  leela = callPackage ../tools/graphics/leela { };

  lftp = callPackage ../tools/networking/lftp { };

  libconfig = callPackage ../development/libraries/libconfig { };

  libcmis = callPackage ../development/libraries/libcmis { };

  libee = callPackage ../development/libraries/libee { };

  libestr = callPackage ../development/libraries/libestr { };

  libevdev = callPackage ../development/libraries/libevdev { };

  libfann = callPackage ../development/libraries/libfann { };

  libipfix = callPackage ../development/libraries/libipfix { };

  libircclient = callPackage ../development/libraries/libircclient { };

  libite = callPackage ../development/libraries/libite { };

  liblangtag = callPackage ../development/libraries/liblangtag {
    inherit (gnome2) gtkdoc;
    inherit (gnome3) gnome-common;
  };

  liblouis = callPackage ../development/libraries/liblouis { };

  liboauth = callPackage ../development/libraries/liboauth { };

  libsidplayfp = callPackage ../development/libraries/libsidplayfp { };

  libsrs2 = callPackage ../development/libraries/libsrs2 { };

  libtermkey = callPackage ../development/libraries/libtermkey { };

  libtelnet = callPackage ../development/libraries/libtelnet { };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libtins = callPackage ../development/libraries/libtins { };

  libshout = callPackage ../development/libraries/libshout { };

  libqb = callPackage ../development/libraries/libqb { };

  libqmi = callPackage ../development/libraries/libqmi { };

  libqrencode = callPackage ../development/libraries/libqrencode { };

  libmbim = callPackage ../development/libraries/libmbim { };

  libmongo-client = callPackage ../development/libraries/libmongo-client { };

  libmesode = callPackage ../development/libraries/libmesode { };

  libnabo = callPackage ../development/libraries/libnabo { };

  libngspice = callPackage ../development/libraries/libngspice { };

  libpointmatcher = callPackage ../development/libraries/libpointmatcher { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  libmpack = callPackage ../development/libraries/libmpack { };

  libiberty = callPackage ../development/libraries/libiberty { };

  libiberty_static = libiberty.override { staticBuild = true; };

  libibverbs = callPackage ../development/libraries/libibverbs { };

  libxc = callPackage ../development/libraries/libxc { };

  libxcomp = callPackage ../development/libraries/libxcomp { };

  libxl = callPackage ../development/libraries/libxl {};

  libx86emu = callPackage ../development/libraries/libx86emu { };

  libzmf = callPackage ../development/libraries/libzmf {};

  librdmacm = callPackage ../development/libraries/librdmacm { };

  libreswan = callPackage ../tools/networking/libreswan { };

  libwebsockets = callPackage ../development/libraries/libwebsockets { };

  limesuite = callPackage ../applications/misc/limesuite { };

  limesurvey = callPackage ../servers/limesurvey { };

  linuxquota = callPackage ../tools/misc/linuxquota { };

  localtime = callPackage ../tools/system/localtime { };

  logcheck = callPackage ../tools/system/logcheck {
    inherit (perlPackages) mimeConstruct;
  };

  logmein-hamachi = callPackage ../tools/networking/logmein-hamachi { };

  logkeys = callPackage ../tools/security/logkeys { };

  logrotate = callPackage ../tools/system/logrotate { };

  logstalgia = callPackage ../tools/graphics/logstalgia {};

  loki = callPackage ../development/libraries/loki { };

  longview = callPackage ../servers/monitoring/longview { };

  lout = callPackage ../tools/typesetting/lout { };

  lr = callPackage ../tools/system/lr { };

  lrzip = callPackage ../tools/compression/lrzip { };

  lsb-release = callPackage ../os-specific/linux/lsb-release { };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lshw = callPackage ../tools/system/lshw { };

  ltris = callPackage ../games/ltris { };

  lxc = callPackage ../os-specific/linux/lxc { };
  lxcfs = callPackage ../os-specific/linux/lxcfs {
    enableDebugBuild = config.lxcfs.enableDebugBuild or false;
  };
  lxd = callPackage ../tools/admin/lxd { };

  lzfse = callPackage ../tools/compression/lzfse { };

  lzham = callPackage ../tools/compression/lzham { };

  lzip = callPackage ../tools/compression/lzip { };

  luxcorerender = callPackage ../tools/graphics/luxcorerender { };

  xz = callPackage ../tools/compression/xz { };
  lzma = xz; # TODO: move to aliases.nix

  lz4 = callPackage ../tools/compression/lz4 { };

  lzbench = callPackage ../tools/compression/lzbench { };

  lzop = callPackage ../tools/compression/lzop { };

  macchanger = callPackage ../os-specific/linux/macchanger { };

  madlang = haskell.lib.justStaticExecutables haskellPackages.madlang;

  mailcheck = callPackage ../applications/networking/mailreaders/mailcheck { };

  maildrop = callPackage ../tools/networking/maildrop { };

  mailhog = callPackage ../servers/mail/mailhog {};

  mailnag = callPackage ../applications/networking/mailreaders/mailnag {
    pythonPackages = python2Packages;
  };

  mailsend = callPackage ../tools/networking/mailsend { };

  mailpile = callPackage ../applications/networking/mailreaders/mailpile { };

  mailutils = callPackage ../tools/networking/mailutils {
    guile = guile_2_0;  # compilation fails with guile 2.2
    sasl = gsasl;
  };

  email = callPackage ../tools/networking/email { };

  maim = callPackage ../tools/graphics/maim {};

  mairix = callPackage ../tools/text/mairix { };

  makemkv = callPackage ../applications/video/makemkv { };

  makerpm = callPackage ../development/tools/makerpm { };

  makefile2graph = callPackage ../development/tools/analysis/makefile2graph { };

  # See https://github.com/NixOS/nixpkgs/issues/15849. I'm switching on isLinux because
  # it looks like gnulib is broken on non-linux, so it seems likely that this would cause
  # trouble on bsd and/or cygwin as well.
  man = if stdenv.isLinux then man-db else man-old;

  man-old = callPackage ../tools/misc/man { };

  man-db = callPackage ../tools/misc/man-db { };

  mandoc = callPackage ../tools/misc/mandoc { };

  mawk = callPackage ../tools/text/mawk { };

  mb2md = callPackage ../tools/text/mb2md { };

  mbox = callPackage ../tools/security/mbox { };

  mbuffer = callPackage ../tools/misc/mbuffer { };

  mecab =
    let
      mecab-nodic = callPackage ../tools/text/mecab/nodic.nix { };
    in
    callPackage ../tools/text/mecab {
      mecab-ipadic = callPackage ../tools/text/mecab/ipadic.nix {
        inherit mecab-nodic;
      };
    };

  memtier-benchmark = callPackage ../tools/networking/memtier-benchmark { };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  memtest86plus = callPackage ../tools/misc/memtest86+ { };

  meo = callPackage ../tools/security/meo {
    boost = boost155;
  };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdbtools_git = callPackage ../tools/misc/mdbtools/git.nix {
    inherit (gnome2) scrollkeeper;
  };

  mdk = callPackage ../development/tools/mdk { };

  mdp = callPackage ../applications/misc/mdp { };

  mednafen = callPackage ../misc/emulators/mednafen { };

  mednafen-server = callPackage ../misc/emulators/mednafen/server.nix { };

  mednaffe = callPackage ../misc/emulators/mednaffe {
    gtk2 = null;
  };

  megacli = callPackage ../tools/misc/megacli { };

  megatools = callPackage ../tools/networking/megatools { };

  memo = callPackage ../applications/misc/memo { };

  mencal = callPackage ../applications/misc/mencal { } ;

  metamorphose2 = callPackage ../applications/misc/metamorphose2 { };

  metar = callPackage ../applications/misc/metar { };

  mfcuk = callPackage ../tools/security/mfcuk { };

  mfoc = callPackage ../tools/security/mfoc { };

  mgba = libsForQt5.callPackage ../misc/emulators/mgba { };

  mikutter = callPackage ../applications/networking/instant-messengers/mikutter { };

  mimeo = callPackage ../tools/misc/mimeo { };

  mimetic = callPackage ../development/libraries/mimetic { };

  minio-client = callPackage ../tools/networking/minio-client {
    buildGoPackage = buildGo110Package;
  };

  minissdpd = callPackage ../tools/networking/minissdpd { };

  inherit (callPackage ../tools/networking/miniupnpc
            { inherit (darwin) cctools; })
    miniupnpc_1 miniupnpc_2;
  miniupnpc = miniupnpc_1;

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  miniball = callPackage ../development/libraries/miniball { };

  minijail = callPackage ../tools/system/minijail { };

  minixml = callPackage ../development/libraries/minixml { };

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  miredo = callPackage ../tools/networking/miredo { };

  mirrorbits = callPackage ../servers/mirrorbits { };

  mitmproxy = callPackage ../tools/networking/mitmproxy { };

  mjpegtools = callPackage ../tools/video/mjpegtools {
    withMinimal = true;
  };

  mjpegtoolsFull = mjpegtools.override {
    withMinimal = false;
  };

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  mkrand = callPackage ../tools/security/mkrand { };

  mktemp = callPackage ../tools/security/mktemp { };

  mktorrent = callPackage ../tools/misc/mktorrent { };

  mmake = callPackage ../tools/misc/mmake { };

  modemmanager = callPackage ../tools/networking/modem-manager {};

  modsecurity_standalone = callPackage ../tools/security/modsecurity { };

  molly-guard = callPackage ../os-specific/linux/molly-guard { };

  moneyplex = callPackage ../applications/office/moneyplex { };

  monit = callPackage ../tools/system/monit { };

  moreutils = callPackage ../tools/misc/moreutils {
    inherit (perlPackages) IPCRun TimeDate TimeDuration;
    docbook-xsl = docbook_xsl;
  };

  mosh = callPackage ../tools/networking/mosh {
    inherit (perlPackages) IOTty;
  };

  motuclient = callPackage ../applications/science/misc/motu-client { };

  mpage = callPackage ../tools/text/mpage { };

  mprime = callPackage ../tools/misc/mprime { };

  mpw = callPackage ../tools/security/mpw { };

  mr = callPackage ../applications/version-management/mr { };

  mrtg = callPackage ../tools/misc/mrtg { };

  mscgen = callPackage ../tools/graphics/mscgen { };

  metasploit = callPackage ../tools/security/metasploit { };

  ms-sys = callPackage ../tools/misc/ms-sys { };

  mtdutils = callPackage ../tools/filesystems/mtdutils { };

  mtools = callPackage ../tools/filesystems/mtools { };

  mtr = callPackage ../tools/networking/mtr {};

  mtx = callPackage ../tools/backup/mtx {};

  mt-st = callPackage ../tools/backup/mt-st {};

  multitran = recurseIntoAttrs (let callPackage = newScope pkgs.multitran; in rec {
    multitrandata = callPackage ../tools/text/multitran/data { };

    libbtree = callPackage ../tools/text/multitran/libbtree { };

    libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

    libfacet = callPackage ../tools/text/multitran/libfacet { };

    libmtquery = callPackage ../tools/text/multitran/libmtquery { };

    mtutils = callPackage ../tools/text/multitran/mtutils { };
  });

  munge = callPackage ../tools/security/munge { };

  mycli = callPackage ../tools/admin/mycli { };

  mydumper = callPackage ../tools/backup/mydumper { };

  mysql2pgsql = callPackage ../tools/misc/mysql2pgsql { };

  mysqltuner = callPackage ../tools/misc/mysqltuner { };

  mytetra = libsForQt5.callPackage ../applications/office/mytetra { };

  nabi = callPackage ../tools/inputmethods/nabi { };

  namazu = callPackage ../tools/text/namazu { };

  nano-wallet = libsForQt5.callPackage ../applications/altcoins/nano-wallet { };

  nasty = callPackage ../tools/security/nasty { };

  nat-traverse = callPackage ../tools/networking/nat-traverse { };

  nawk = callPackage ../tools/text/nawk { };

  nbd = callPackage ../tools/networking/nbd { };
  xnbd = callPackage ../tools/networking/xnbd { };

  inherit (callPackages ../development/libraries/science/math/nccl { })
    nccl_cudatoolkit_8
    nccl_cudatoolkit_9;

  nccl = nccl_cudatoolkit_9;

  ndjbdns = callPackage ../tools/networking/ndjbdns { };

  ndppd = callPackage ../applications/networking/ndppd { };

  neofetch = callPackage ../tools/misc/neofetch { };

  nerdfonts = callPackage ../data/fonts/nerdfonts { };

  nestopia = callPackage ../misc/emulators/nestopia { };

  netatalk = callPackage ../tools/filesystems/netatalk { };

  netcdf = callPackage ../development/libraries/netcdf { };

  netcdf-mpi = appendToName "mpi" (netcdf.override {
    hdf5 = hdf5-mpi;
  });

  netcdfcxx4 = callPackage ../development/libraries/netcdf-cxx4 { };

  netcdffortran = callPackage ../development/libraries/netcdf-fortran { };

  neural-style = callPackage ../tools/graphics/neural-style {};

  nco = callPackage ../development/libraries/nco { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  neopg = callPackage ../tools/security/neopg { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = libressl.nc;

  netcat-gnu = callPackage ../tools/networking/netcat { };

  nethogs = callPackage ../tools/networking/nethogs { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  # stripped down, needed by steam
  networkmanager098 = callPackage ../tools/networking/network-manager/0.9.8 { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager-iodine = callPackage ../tools/networking/network-manager/iodine { };

  networkmanager-openvpn = callPackage ../tools/networking/network-manager/openvpn { };

  networkmanager-l2tp = callPackage ../tools/networking/network-manager/l2tp { };

  networkmanager-vpnc = callPackage ../tools/networking/network-manager/vpnc { };

  networkmanager-openconnect = callPackage ../tools/networking/network-manager/openconnect { };

  networkmanager-fortisslvpn = callPackage ../tools/networking/network-manager/fortisslvpn { };

  networkmanager_strongswan = callPackage ../tools/networking/network-manager/strongswan.nix { };

  networkmanagerapplet = callPackage ../tools/networking/network-manager/applet.nix { };

  networkmanager_dmenu = callPackage ../tools/networking/network-manager/dmenu.nix  { };

  newsboat = callPackage ../applications/networking/feedreaders/newsboat { };

  nextcloud = callPackage ../servers/nextcloud { };

  nextcloud-client = libsForQt5.callPackage ../applications/networking/nextcloud-client { };

  nextcloud-news-updater = callPackage ../servers/nextcloud/news-updater.nix { };

  ngrep = callPackage ../tools/networking/ngrep { };

  ngrok = ngrok-2;

  ngrok-2 = callPackage ../tools/networking/ngrok-2 { };

  ngrok-1 = callPackage ../tools/networking/ngrok-1 { };

  noice = callPackage ../applications/misc/noice { };

  noip = callPackage ../tools/networking/noip { };

  nomad = callPackage ../applications/networking/cluster/nomad {
    buildGoPackage = buildGo110Package;
  };

  miller = callPackage ../tools/text/miller { };

  milu = callPackage ../applications/misc/milu { };

  mpack = callPackage ../tools/networking/mpack { };

  pa_applet = callPackage ../tools/audio/pa-applet { };

  pasystray = callPackage ../tools/audio/pasystray { };

  phash = callPackage ../development/libraries/phash { };

  pnmixer = callPackage ../tools/audio/pnmixer { };

  pulsemixer = callPackage ../tools/audio/pulsemixer { };

  pwsafe = callPackage ../applications/misc/pwsafe {
    wxGTK = wxGTK30;
  };

  niff = callPackage ../tools/package-management/niff { };

  nifskope = libsForQt59.callPackage ../tools/graphics/nifskope { };

  nilfs-utils = callPackage ../tools/filesystems/nilfs-utils {};

  nitrogen = callPackage ../tools/X11/nitrogen {};

  nms = callPackage ../tools/misc/nms { };

  notify-desktop = callPackage ../tools/misc/notify-desktop {};

  nkf = callPackage ../tools/text/nkf {};

  nlopt = callPackage ../development/libraries/nlopt { octave = null; };

  npapi_sdk = callPackage ../development/libraries/npapi-sdk {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap { };

  nmap-graphical = nmap.override {
    graphicalSupport = true;
  };

  nmapsi4 = libsForQt5.callPackage ../tools/security/nmap/qt.nix { };

  nnn = callPackage ../applications/misc/nnn { };

  notary = callPackage ../tools/security/notary {
    buildGoPackage = buildGo110Package;
  };

  notify-osd = callPackage ../applications/misc/notify-osd { };

  notify-osd-customizable = callPackage ../applications/misc/notify-osd-customizable { };

  nox = callPackage ../tools/package-management/nox { };

  nq = callPackage ../tools/system/nq { };

  nsjail = callPackage ../tools/security/nsjail {};

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy = pythonPackages.ntfy;

  ntopng = callPackage ../tools/networking/ntopng { };

  ntp = callPackage ../tools/networking/ntp {
    libcap = if stdenv.isLinux then libcap else null;
  };

  numdiff = callPackage ../tools/text/numdiff { };

  numlockx = callPackage ../tools/X11/numlockx { };

  nuttcp = callPackage ../tools/networking/nuttcp { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = with python3Packages; toPythonApplication nwdiag;

  nylon = callPackage ../tools/networking/nylon { };

  nxproxy = callPackage ../tools/admin/nxproxy { };

  nzbget = callPackage ../tools/networking/nzbget { };

  oathToolkit = callPackage ../tools/security/oath-toolkit { inherit (gnome2) gtkdoc;  };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  ocproxy = callPackage ../tools/networking/ocproxy { };

  ocserv = callPackage ../tools/networking/ocserv { };

  openfortivpn = callPackage ../tools/networking/openfortivpn { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  objconv = callPackage ../development/tools/misc/objconv {};

  odpdown = callPackage ../tools/typesetting/odpdown { };

  odpic = callPackage ../development/libraries/odpic { };

  odt2txt = callPackage ../tools/text/odt2txt { };

  offlineimap = callPackage ../tools/networking/offlineimap { };

  oh-my-zsh = callPackage ../shells/zsh/oh-my-zsh { };

  ola = callPackage ../applications/misc/ola { };

  onioncircuits = callPackage ../tools/security/onioncircuits {
    inherit (gnome3) defaultIconTheme;
  };

  opencc = callPackage ../tools/text/opencc { };

  opencl-info = callPackage ../tools/system/opencl-info { };

  opencryptoki = callPackage ../tools/security/opencryptoki { };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendht = callPackage ../development/libraries/opendht {};

  opendkim = callPackage ../development/libraries/opendkim { };

  opendylan = callPackage ../development/compilers/opendylan {
    opendylan-bootstrap = opendylan_bin;
  };

  opendylan_bin = callPackage ../development/compilers/opendylan/bin.nix { };

  open-ecard = callPackage ../tools/security/open-ecard { };

  openjade = callPackage ../tools/text/sgml/openjade { };

  openmvg = callPackage ../applications/science/misc/openmvg { };

  openmvs = callPackage ../applications/science/misc/openmvs { };

  openntpd = callPackage ../tools/networking/openntpd { };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  openopc = callPackage ../tools/misc/openopc { };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc = callPackage ../tools/security/opensc {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  opensm = callPackage ../tools/networking/opensm { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      etcDir = "/etc/ssh";
      pam = if stdenv.isLinux then pam else null;
    };

  openssh_hpn = pkgs.appendToName "with-hpn" (openssh.override { hpnSupport = true; });

  opensp = callPackage ../tools/text/sgml/opensp { };

  opentracker = callPackage ../applications/networking/p2p/opentracker { };

  opentsdb = callPackage ../tools/misc/opentsdb {};

  openvpn = callPackage ../tools/networking/openvpn { };

  openvpn_learnaddress = callPackage ../tools/networking/openvpn/openvpn_learnaddress.nix { };

  openvpn-auth-ldap = callPackage ../tools/networking/openvpn/openvpn-auth-ldap.nix {
    stdenv = clangStdenv;
  };

  update-resolv-conf = callPackage ../tools/networking/openvpn/update-resolv-conf.nix { };

  opae = callPackage ../development/libraries/opae { };

  openvswitch = callPackage ../os-specific/linux/openvswitch { };

  optipng = callPackage ../tools/graphics/optipng {
    libpng = libpng12;
  };

  olsrd = callPackage ../tools/networking/olsrd { };

  os-prober = callPackage ../tools/misc/os-prober {};

  osl = callPackage ../development/compilers/osl { };

  ossec = callPackage ../tools/security/ossec {};

  ostree = callPackage ../tools/misc/ostree { };

  otfcc = callPackage ../tools/misc/otfcc { };

  otpw = callPackage ../os-specific/linux/otpw { };

  overmind = callPackage ../applications/misc/overmind { };

  owncloud = owncloud70;

  inherit (callPackages ../servers/owncloud { })
    owncloud70
    owncloud80
    owncloud81
    owncloud82
    owncloud90
    owncloud91;

  owncloud-client = libsForQt5.callPackage ../applications/networking/owncloud-client { };

  oxidized = callPackage ../tools/admin/oxidized { };

  oxipng = callPackage ../tools/graphics/oxipng { };

  p2pvc = callPackage ../applications/video/p2pvc {};

  p7zip = callPackage ../tools/archivers/p7zip { };

  packagekit = callPackage ../tools/package-management/packagekit { };

  packagekit-qt = libsForQt5.callPackage ../tools/package-management/packagekit/qt.nix { };

  packetdrill = callPackage ../tools/networking/packetdrill { };

  pacman = callPackage ../tools/package-management/pacman { };

  padthv1 = callPackage ../applications/audio/padthv1 { };

  pagmo2 = callPackage ../development/libraries/pagmo2 { };

  pakcs = callPackage ../development/compilers/pakcs {};

  pal = callPackage ../tools/misc/pal { };

  pandoc = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.pandoc) (drv: {
    configureFlags = drv.configureFlags or [] ++ ["-fembed_data_files"];
    buildDepends = drv.buildDepends or [] ++ [haskellPackages.file-embed];
  });

  pamtester = callPackage ../tools/security/pamtester { };

  paper-gtk-theme = callPackage ../misc/themes/paper { };

  paperwork = callPackage ../applications/office/paperwork { };

  papertrail = callPackage ../tools/text/papertrail { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  parcellite = callPackage ../tools/misc/parcellite { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { };

  pell = callPackage ../applications/misc/pell { };

  pepper = callPackage ../tools/admin/salt/pepper { };

  percona-xtrabackup = callPackage ../tools/backup/percona-xtrabackup {
    boost = boost159;
  };

  pick = callPackage ../tools/misc/pick { };

  pitivi = callPackage ../applications/video/pitivi {
    gst = gst_all_1 //
      { gst-plugins-bad = gst_all_1.gst-plugins-bad.overrideDerivation
          (attrs: { nativeBuildInputs = attrs.nativeBuildInputs ++ [ gtk3 ];
                    # Fix this build error in ./tests/examples/waylandsink:
                    #   main.c:28:2: error: #error "Wayland is not supported in GTK+"
                    configureFlags = attrs.configureFlags or [] ++ [ "--enable-wayland=no" ];
                  });
      };
  };

  p0f = callPackage ../tools/security/p0f { };

  pngout = callPackage ../tools/graphics/pngout { };

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools { flex = flex_2_5_35; };

  patch = gnupatch;

  patchage = callPackage ../applications/audio/patchage { };

  patchwork-classic = callPackage ../applications/networking/ssb/patchwork-classic { };

  pcapfix = callPackage ../tools/networking/pcapfix { };

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcsctools = callPackage ../tools/security/pcsctools {
    inherit (perlPackages) pcscperl Glib Gtk2 Pango Cairo;
  };

  pcsc-cyberjack = callPackage ../tools/security/pcsc-cyberjack { };

  pcsc-scm-scl011 = callPackage ../tools/security/pcsc-scm-scl011 { };

  pdd = python3Packages.callPackage ../tools/misc/pdd { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdf2htmlEX = callPackage ../tools/typesetting/pdf2htmlEX { };

  pdf2odt = callPackage ../tools/typesetting/pdf2odt { };

  pdf-redact-tools = callPackage ../tools/graphics/pdfredacttools { };

  pdfcrack = callPackage ../tools/security/pdfcrack { };

  pdftag = callPackage ../tools/graphics/pdftag { };

  pdf2svg = callPackage ../tools/graphics/pdf2svg { };

  fmodex = callPackage ../games/zandronum/fmod.nix { };

  pdfmod = callPackage ../applications/misc/pdfmod { mono = mono4; };

  pdf-quench = callPackage ../applications/misc/pdf-quench { };

  jbig2enc = callPackage ../tools/graphics/jbig2enc { };

  pdfread = callPackage ../tools/graphics/pdfread {
    inherit (pythonPackages) pillow;
  };

  pdfshuffler = callPackage ../applications/misc/pdfshuffler { };

  briss = callPackage ../tools/graphics/briss { };

  brickd = callPackage ../servers/brickd {
    libusb = libusb1;
  };

  bully = callPackage ../tools/networking/bully { };

  pcapc = callPackage ../tools/networking/pcapc { };

  pdnsd = callPackage ../tools/networking/pdnsd { };

  peco = callPackage ../tools/text/peco { };

  pg_top = callPackage ../tools/misc/pg_top { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = callPackage ../tools/graphics/pfstools { };

  philter = callPackage ../tools/networking/philter { };

  phodav = callPackage ../tools/networking/phodav { };

  pinentry = callPackage ../tools/security/pinentry {
    libcap = if stdenv.isDarwin then null else libcap;
  };

  pinentry_ncurses = self.pinentry.override {
    gtk2 = null;
  };

  pinentry_emacs = self.pinentry.override {
    enableEmacs = true;
  };

  pinentry_gnome = self.pinentry.override {
    gcr = gnome3.gcr;
  };

  pinentry_qt4 = self.pinentry.override {
    qt = qt4;
  };

  pinentry_qt5 = self.pinentry.override {
    qt = qt5.qtbase;
  };

  pinentry_mac = callPackage ../tools/security/pinentry/mac.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  pingtcp = callPackage ../tools/networking/pingtcp { };

  pirate-get = callPackage ../tools/networking/pirate-get { };

  pius = callPackage ../tools/security/pius { };

  pixiewps = callPackage ../tools/networking/pixiewps {};

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plantuml = callPackage ../tools/misc/plantuml { };

  plan9port = callPackage ../tools/system/plan9port { };

  platformioPackages = callPackage ../development/arduino/platformio { };
  platformio = platformioPackages.platformio-chrootenv;

  platinum-searcher = callPackage ../tools/text/platinum-searcher { };

  playbar2 = libsForQt5.callPackage ../applications/audio/playbar2 { };

  plex = callPackage ../servers/plex { enablePlexPass = config.plex.enablePlexPass or false; };

  plexpy = callPackage ../servers/plexpy { python = python2; };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  plotinus = callPackage ../tools/misc/plotinus { };

  plotutils = callPackage ../tools/graphics/plotutils { };

  plowshare = callPackage ../tools/misc/plowshare { };

  pngcheck = callPackage ../tools/graphics/pngcheck {
    zlib = zlibStatic;
  };

  pngcrush = callPackage ../tools/graphics/pngcrush { };

  pngnq = callPackage ../tools/graphics/pngnq { };

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngpp = callPackage ../development/libraries/png++ { };

  pngquant = callPackage ../tools/graphics/pngquant { };

  podiff = callPackage ../tools/text/podiff { };

  pod2mdoc = callPackage ../tools/misc/pod2mdoc { };

  poedit = callPackage ../tools/text/poedit { };

  polipo = callPackage ../servers/polipo { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  polysh = callPackage ../tools/networking/polysh { };

  ponysay = callPackage ../tools/misc/ponysay { };

  popfile = callPackage ../tools/text/popfile { };

  poretools = callPackage ../applications/science/biology/poretools { };

  postscript-lexmark = callPackage ../misc/drivers/postscript-lexmark { };

  povray = callPackage ../tools/graphics/povray { };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  pptpd = callPackage ../tools/networking/pptpd {};

  prettyping = callPackage ../tools/networking/prettyping { };

  prey-bash-client = callPackage ../tools/security/prey { };

  profile-cleaner = callPackage ../tools/misc/profile-cleaner { };

  profile-sync-daemon = callPackage ../tools/misc/profile-sync-daemon { };

  projectlibre = callPackage ../applications/misc/projectlibre { };

  projectm = callPackage ../applications/audio/projectm { };

  proot = callPackage ../tools/system/proot { };

  prototypejs = callPackage ../development/libraries/prototypejs { };

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  pws = callPackage ../tools/misc/pws { };

  cntlm = callPackage ../tools/networking/cntlm { };

  pastebinit = callPackage ../tools/misc/pastebinit { };

  polygraph = callPackage ../tools/networking/polygraph { };

  progress = callPackage ../tools/misc/progress { };

  ps3netsrv = callPackage ../servers/ps3netsrv { };

  pscircle = callPackage ../os-specific/linux/pscircle { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pssh = callPackage ../tools/networking/pssh { };

  pspg = callPackage ../tools/misc/pspg { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  psutils = callPackage ../tools/typesetting/psutils { };

  psensor = callPackage ../tools/system/psensor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  pubs = callPackage ../tools/misc/pubs {};

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pwnat = callPackage ../tools/networking/pwnat { };

  pwndbg = callPackage ../development/tools/misc/pwndbg { };

  pycangjie = pythonPackages.pycangjie;

  pydb = callPackage ../development/tools/pydb { };

  pygmentex = callPackage ../tools/typesetting/pygmentex { };

  pythonIRClib = pythonPackages.pythonIRClib;

  pythonSexy = pythonPackages.libsexy;

  pytrainer = callPackage ../applications/misc/pytrainer { };

  pywal = callPackage ../tools/graphics/pywal {};

  remarshal = callPackage ../development/tools/remarshal { };

  rocket = libsForQt5.callPackage ../tools/graphics/rocket { };

  rtaudio = callPackage ../development/libraries/audio/rtaudio { };

  rtmidi = callPackage ../development/libraries/audio/rtmidi { };

  openmpi = callPackage ../development/libraries/openmpi { };

  openmodelica = callPackage ../applications/science/misc/openmodelica { };

  qarte = callPackage ../applications/video/qarte { };

  qlcplus = libsForQt5.callPackage ../applications/misc/qlcplus { };

  qnial = callPackage ../development/interpreters/qnial { };

  ocz-ssd-guru = callPackage ../tools/misc/ocz-ssd-guru { };

  qalculate-gtk = callPackage ../applications/science/math/qalculate-gtk { };

  qastools = libsForQt5.callPackage ../tools/audio/qastools { };

  qesteidutil = libsForQt5.callPackage ../tools/security/qesteidutil { } ;
  qdigidoc = libsForQt5.callPackage ../tools/security/qdigidoc { } ;
  esteidfirefoxplugin = callPackage ../applications/networking/browsers/mozilla-plugins/esteidfirefoxplugin { };


  qgifer = callPackage ../applications/video/qgifer {
    giflib = giflib_4_1;
  };

  qhull = callPackage ../development/libraries/qhull { };

  qjoypad = callPackage ../tools/misc/qjoypad { };

  qpdf = callPackage ../development/libraries/qpdf { };

  qprint = callPackage ../tools/text/qprint { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qshowdiff = callPackage ../tools/text/qshowdiff { };

  qtikz = libsForQt5.callPackage ../applications/graphics/ktikz { };

  quicktun = callPackage ../tools/networking/quicktun { };

  quilt = callPackage ../development/tools/quilt { };

  quota = if stdenv.isLinux then linuxquota else unixtools.quota;

  wiggle = callPackage ../development/tools/wiggle { };

  radamsa = callPackage ../tools/security/radamsa { };

  radarr = callPackage ../servers/radarr { };

  radeon-profile = libsForQt5.callPackage ../tools/misc/radeon-profile { };

  radsecproxy = callPackage ../tools/networking/radsecproxy { };

  radvd = callPackage ../tools/networking/radvd { };

  rainbowstream = pythonPackages.rainbowstream;

  rambox = callPackage ../applications/networking/instant-messengers/rambox { };

  ranger = callPackage ../applications/misc/ranger { };

  rarcrack = callPackage ../tools/security/rarcrack { };

  rarian = callPackage ../development/libraries/rarian { };

  ratools = callPackage ../tools/networking/ratools { };

  rawdog = callPackage ../applications/networking/feedreaders/rawdog { };

  rc = callPackage ../shells/rc { };

  rdma-core = callPackage ../os-specific/linux/rdma-core { };

  react-native-debugger = callPackage ../development/tools/react-native-debugger { };

  read-edid = callPackage ../os-specific/linux/read-edid { };

  redir = callPackage ../tools/networking/redir { };

  redmine = callPackage ../applications/version-management/redmine { };

  redsocks = callPackage ../tools/networking/redsocks { };

  richgo = callPackage ../development/tools/richgo {  };

  rst2html5 = callPackage ../tools/text/rst2html5 { };

  rt = callPackage ../servers/rt { };

  rtmpdump = callPackage ../tools/video/rtmpdump { };
  rtmpdump_gnutls = rtmpdump.override { gnutlsSupport = true; opensslSupport = false; };

  reaverwps = callPackage ../tools/networking/reaver-wps {};

  reaverwps-t6x = callPackage ../tools/networking/reaver-wps-t6x {};

  recordmydesktop = callPackage ../applications/video/recordmydesktop { };

  gtk-recordmydesktop = callPackage ../applications/video/recordmydesktop/gtk.nix {
    jack2 = jack2Full;
  };

  qt-recordmydesktop = callPackage ../applications/video/recordmydesktop/qt.nix {
    jack2 = jack2Full;
  };

  recutils = callPackage ../tools/misc/recutils { };

  recoll = callPackage ../applications/search/recoll { };

  reflex = callPackage ../development/tools/reflex { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome2) gnome_vfs GConf;
  };

  remarkjs = callPackage ../development/web/remarkjs { };

  alarm-clock-applet = callPackage ../tools/misc/alarm-clock-applet { };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina {
    adwaita-icon-theme = gnome3.adwaita-icon-theme;
    gsettings-desktop-schemas = gnome3.gsettings-desktop-schemas;
  };

  rename = callPackage ../tools/misc/rename {
    inherit (perlPackages) buildPerlPackage;
  };

  renameutils = callPackage ../tools/misc/renameutils { };

  renderdoc = libsForQt5.callPackage ../applications/graphics/renderdoc { };

  replace = callPackage ../tools/text/replace { };

  reckon = callPackage ../tools/text/reckon { };

  recoverjpeg = callPackage ../tools/misc/recoverjpeg { };

  reposurgeon = callPackage ../applications/version-management/reposurgeon { };

  reptyr = callPackage ../os-specific/linux/reptyr {};

  rescuetime = callPackage ../applications/misc/rescuetime { };

  rewritefs = callPackage ../os-specific/linux/rewritefs { };

  rdiff-backup = callPackage ../tools/backup/rdiff-backup { };

  rdfind = callPackage ../tools/filesystems/rdfind { };

  rhash = callPackage ../tools/security/rhash { };

  riemann_c_client = callPackage ../tools/misc/riemann-c-client { };
  riemann-tools = callPackage ../tools/misc/riemann-tools { };

  ripmime = callPackage ../tools/networking/ripmime {};

  rkflashtool = callPackage ../tools/misc/rkflashtool { };

  rkrlv2 = callPackage ../applications/audio/rkrlv2 {};

  rmlint = callPackage ../tools/misc/rmlint {
    inherit (pythonPackages) sphinx;
  };

  rng_tools = callPackage ../tools/security/rng-tools { };

  rnv = callPackage ../tools/text/xml/rnv { };

  rounded-mgenplus = callPackage ../data/fonts/rounded-mgenplus { };

  roundup = callPackage ../tools/misc/roundup { };

  routino = callPackage ../tools/misc/routino { };

  rq = callPackage ../development/tools/rq {
    v8 = v8_static;
  };

  rsnapshot = callPackage ../tools/backup/rsnapshot { };

  rlwrap = callPackage ../tools/misc/rlwrap { };

  rockbox_utility = libsForQt5.callPackage ../tools/misc/rockbox-utility { };

  rosegarden = libsForQt5.callPackage ../applications/audio/rosegarden { };

  rowhammer-test = callPackage ../tools/system/rowhammer-test { };

  rpPPPoE = callPackage ../tools/networking/rp-pppoe { };

  rpiboot-unstable = callPackage ../development/misc/rpiboot/unstable.nix { };

  rpm = callPackage ../tools/package-management/rpm { };

  rpm-ostree = callPackage ../tools/misc/rpm-ostree {
    gperf = gperf_3_0;
  };

  rpmextract = callPackage ../tools/archivers/rpmextract { };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rsibreak = libsForQt5.callPackage ../applications/misc/rsibreak { };

  rss2email = callPackage ../applications/networking/feedreaders/rss2email {
    pythonPackages = python3Packages;
  };

  rsstail = callPackage ../applications/networking/feedreaders/rsstail { };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  rubocop = callPackage ../development/tools/rubocop { };

  runelite = callPackage ../games/runelite { };

  runningx = callPackage ../tools/X11/runningx { };

  runzip = callPackage ../tools/archivers/runzip { };

  rw = callPackage ../tools/misc/rw { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s-tui = callPackage ../tools/system/s-tui { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3fs = callPackage ../tools/filesystems/s3fs { };

  s3cmd = callPackage ../tools/networking/s3cmd { };

  s4cmd = callPackage ../tools/networking/s4cmd { };

  s3gof3r = callPackage ../tools/networking/s3gof3r { };

  s6-dns = skawarePackages.s6-dns;

  s6-linux-utils = skawarePackages.s6-linux-utils;

  s6-networking = skawarePackages.s6-networking;

  s6-portable-utils = skawarePackages.s6-portable-utils;

  sablotron = callPackage ../tools/text/xml/sablotron { };

  safecopy = callPackage ../tools/system/safecopy { };

  safe-rm = callPackage ../tools/system/safe-rm { };

  safeeyes = callPackage ../applications/misc/safeeyes { };

  salt = callPackage ../tools/admin/salt {};

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  saml2aws = callPackage ../tools/security/saml2aws {};

  samplicator = callPackage ../tools/networking/samplicator { };

  sasview = callPackage ../applications/science/misc/sasview {};

  scallion = callPackage ../tools/security/scallion { };

  scanbd = callPackage ../tools/graphics/scanbd { };

  scdoc = callPackage ../tools/typesetting/scdoc { };

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  scrcpy = callPackage ../misc/scrcpy {
    inherit (androidenv) platformTools;
  };

  screen-message = callPackage ../tools/X11/screen-message { };

  screencloud = callPackage ../applications/graphics/screencloud {
    quazip = quazip_qt4;
  };

  screenkey = python2Packages.callPackage ../applications/video/screenkey {
    inherit (gnome3) defaultIconTheme;
  };

  quazip_qt4 = libsForQt5.quazip.override {
    qtbase = qt4; qmake = qmake4Hook;
  };

  scfbuild = python2.pkgs.callPackage ../tools/misc/scfbuild { };

  scriptaculous = callPackage ../development/libraries/scriptaculous { };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sdcv = callPackage ../applications/misc/sdcv { };

  sdl-jstest = callPackage ../tools/misc/sdl-jstest { };

  skim = callPackage ../tools/misc/skim { };

  sec = callPackage ../tools/admin/sec { };

  seccure = callPackage ../tools/security/seccure { };

  secp256k1 = callPackage ../tools/security/secp256k1 { };

  securefs = callPackage ../tools/filesystems/securefs { };

  seexpr = callPackage ../development/compilers/seexpr { };

  setroot = callPackage  ../tools/X11/setroot { };

  setserial = callPackage ../tools/system/setserial { };

  seqdiag = with python3Packages; toPythonApplication seqdiag;

  screenfetch = callPackage ../tools/misc/screenfetch { };

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  sha1collisiondetection = callPackage ../tools/security/sha1collisiondetection { };

  shadowsocks-libev = callPackage ../tools/networking/shadowsocks-libev { };

  sharutils = callPackage ../tools/archivers/sharutils { };

  schema2ldif = callPackage ../tools/text/schema2ldif { };

  shocco = callPackage ../tools/text/shocco { };

  shotwell = callPackage ../applications/graphics/shotwell { };

  shout = nodePackages.shout;

  shellinabox = callPackage ../servers/shellinabox { };

  shrikhand = callPackage ../data/fonts/shrikhand { };

  sic = callPackage ../applications/networking/irc/sic { };

  siege = callPackage ../tools/networking/siege {};

  sieve-connect = callPackage ../applications/networking/sieve-connect {};

  sigal = callPackage ../applications/misc/sigal {
    inherit (pythonPackages) buildPythonApplication fetchPypi;
  };

  sigil = libsForQt5.callPackage ../applications/editors/sigil { };

  signal-desktop = callPackage ../applications/networking/instant-messengers/signal-desktop { };

  # aka., pgp-tools
  signing-party = callPackage ../tools/security/signing-party { };

  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

  sile = callPackage ../tools/typesetting/sile {
  inherit (lua52Packages) lua luaexpat luazlib luafilesystem lpeg;
  };

  silver-searcher = callPackage ../tools/text/silver-searcher { };

  simpleproxy = callPackage ../tools/networking/simpleproxy { };

  simplescreenrecorder = libsForQt5.callPackage ../applications/video/simplescreenrecorder { };

  sipsak = callPackage ../tools/networking/sipsak { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  sit = callPackage ../applications/version-management/sit {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  sixpair = callPackage ../tools/misc/sixpair {};

  skippy-xd = callPackage ../tools/X11/skippy-xd {};

  sks = callPackage ../servers/sks { inherit (ocaml-ng.ocamlPackages_4_02) ocaml camlp4; };

  skydns = callPackage ../servers/skydns { };

  sipcalc = callPackage ../tools/networking/sipcalc { };

  skribilo = callPackage ../tools/typesetting/skribilo {
    tex = texlive.combined.scheme-small;
  };

  sleuthkit = callPackage ../tools/system/sleuthkit {};

  sleepyhead = callPackage ../applications/misc/sleepyhead {};

  slimrat = callPackage ../tools/networking/slimrat {
    inherit (perlPackages) WWWMechanize LWP;
  };

  slsnif = callPackage ../tools/misc/slsnif { };

  slstatus = callPackage ../applications/misc/slstatus {
    conf = config.slstatus.conf or null;
  };

  smartmontools = callPackage ../tools/system/smartmontools {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  smarty3 = callPackage ../development/libraries/smarty3 { };
  smarty3-i18n = callPackage ../development/libraries/smarty3-i18n { };

  smbldaptools = callPackage ../tools/networking/smbldaptools {
    inherit (perlPackages) perlldap CryptSmbHash DigestSHA1;
  };

  smbnetfs = callPackage ../tools/filesystems/smbnetfs {};

  smenu = callPackage ../tools/misc/smenu { };

  smugline = python3Packages.smugline;

  snabb = callPackage ../tools/networking/snabb { } ;

  snapcast = callPackage ../applications/audio/snapcast { };

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  snort = callPackage ../applications/networking/ids/snort { };

  soapui = callPackage ../applications/networking/soapui { };

  sshguard = callPackage ../tools/security/sshguard {};

  softhsm = callPackage ../tools/security/softhsm {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  solr = callPackage ../servers/search/solr { };

  solvespace = callPackage ../applications/graphics/solvespace { };

  sonarr = callPackage ../servers/sonarr { };

  sonata = callPackage ../applications/audio/sonata { };

  souper = callPackage ../development/compilers/souper { };

  sparsehash = callPackage ../development/libraries/sparsehash { };

  spectre-meltdown-checker = callPackage ../tools/security/spectre-meltdown-checker { };

  spiped = callPackage ../tools/networking/spiped { };

  sqliteman = callPackage ../applications/misc/sqliteman { };

  stdman = callPackage ../data/documentation/stdman { };

  storebrowse = callPackage ../tools/system/storebrowse { };

  stubby = callPackage ../tools/networking/stubby { };

  syntex = callPackage ../tools/graphics/syntex {};

  fusesmb = callPackage ../tools/filesystems/fusesmb { samba = samba3; };

  sl = callPackage ../tools/misc/sl { };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  solaar = callPackage ../applications/misc/solaar {};

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  spaceFM = callPackage ../applications/misc/spacefm { };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  squashfuse = callPackage ../tools/filesystems/squashfuse { };

  srcml = callPackage ../applications/version-management/srcml { };

  sshfs-fuse = callPackage ../tools/filesystems/sshfs-fuse { };
  sshfs = sshfs-fuse; # added 2017-08-14

  sshlatex = callPackage ../tools/typesetting/sshlatex { };

  sshuttle = callPackage ../tools/security/sshuttle { };

  ssldump = callPackage ../tools/networking/ssldump { };

  sstp = callPackage ../tools/networking/sstp {};

  structure-synth = callPackage ../tools/graphics/structure-synth { };

  su-exec = callPackage ../tools/security/su-exec {};

  subberthehut = callPackage ../tools/misc/subberthehut { };

  subsurface = libsForQt5.callPackage ../applications/misc/subsurface { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = callPackage ../tools/system/suid-chroot { };

  sundtek = callPackage ../misc/drivers/sundtek { };

  sunxi-tools = callPackage ../development/tools/sunxi-tools { };

  super = callPackage ../tools/security/super { };

  supertux-editor = callPackage ../applications/editors/supertux-editor { };

  super-user-spark = haskellPackages.callPackage ../applications/misc/super_user_spark { };

  svgcleaner = callPackage ../tools/graphics/svgcleaner { };

  ssdeep = callPackage ../tools/security/ssdeep { };

  ssh-ident = callPackage ../tools/networking/ssh-ident { };

  sshpass = callPackage ../tools/networking/sshpass { };

  sslscan = callPackage ../tools/security/sslscan {
    openssl = openssl_1_0_2.override { enableSSL2 = true; };
  };

  sslmate = callPackage ../development/tools/sslmate { };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  ssss = callPackage ../tools/security/ssss { };

  stabber = callPackage ../misc/stabber { };

  stress = callPackage ../tools/system/stress { };

  stress-ng = callPackage ../tools/system/stress-ng { };

  stoken = callPackage ../tools/security/stoken {
    withGTK3 = config.stoken.withGTK3 or true;
  };

  storeBackup = callPackage ../tools/backup/store-backup { };

  stow = callPackage ../tools/misc/stow { };

  stun = callPackage ../tools/networking/stun { };

  stunnel = callPackage ../tools/networking/stunnel { };

  stutter = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.stutter) (drv: {
    preCheck = "export PATH=dist/build/stutter:$PATH";
  });

  strongswan    = callPackage ../tools/networking/strongswan { };
  strongswanTNC = strongswan.override { enableTNC = true; };
  strongswanNM  = strongswan.override { enableNetworkManager = true; };

  su = shadow.su;

  subsonic = callPackage ../servers/misc/subsonic { };

  subfinder = callPackage ../tools/networking/subfinder { };

  surfraw = callPackage ../tools/networking/surfraw { };

  swagger-codegen = callPackage ../tools/networking/swagger-codegen { };

  swec = callPackage ../tools/networking/swec {
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  swfdec = callPackage ../tools/graphics/swfdec {};

  svnfs = callPackage ../tools/filesystems/svnfs { };

  svtplay-dl = callPackage ../tools/misc/svtplay-dl { };

  sysbench = callPackage ../development/tools/misc/sysbench {};

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
    pythonPackages = python3Packages;
   };

  stricat = callPackage ../tools/security/stricat { };

  staruml = callPackage ../tools/misc/staruml { inherit (gnome2) GConf; libgcrypt = libgcrypt_1_5; };

  otter-browser = qt5.callPackage ../applications/networking/browsers/otter {};

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  netalyzr = callPackage ../tools/networking/netalyzr { };

  swaks = callPackage ../tools/networking/swaks { };

  swiften = callPackage ../development/libraries/swiften { };

  t = callPackage ../tools/misc/t { };

  t1utils = callPackage ../tools/misc/t1utils { };

  talkfilters = callPackage ../misc/talkfilters {};

  znapzend = callPackage ../tools/backup/znapzend { };

  tarsnap = callPackage ../tools/backup/tarsnap { };

  tarsnapper = callPackage ../tools/backup/tarsnapper { };

  tcpcrypt = callPackage ../tools/security/tcpcrypt { };

  tcptraceroute = callPackage ../tools/networking/tcptraceroute { };

  tboot = callPackage ../tools/security/tboot { };

  tcpdump = callPackage ../tools/networking/tcpdump { };

  tcpflow = callPackage ../tools/networking/tcpflow { };

  tcpkali = callPackage ../applications/networking/tcpkali { };

  tcpreplay = callPackage ../tools/networking/tcpreplay { };

  ted = callPackage ../tools/typesetting/ted { };

  teamviewer = libsForQt5.callPackage ../applications/networking/remote/teamviewer { };

  telegraf = callPackage ../servers/monitoring/telegraf { };

  teleport = callPackage ../servers/teleport {};

  telepresence = callPackage ../tools/networking/telepresence { };

  termplay = callPackage ../tools/misc/termplay { };

  testdisk-photorec = callPackage ../tools/system/testdisk-photorec { };

  tewisay = callPackage ../tools/misc/tewisay { };

  texmacs = if stdenv.isDarwin
    then callPackage ../applications/editors/texmacs/darwin.nix {
      inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    } else callPackage ../applications/editors/texmacs {
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    };

  texmaker = libsForQt5.callPackage ../applications/editors/texmaker { };

  texstudio = libsForQt5.callPackage ../applications/editors/texstudio { };

  textadept = callPackage ../applications/editors/textadept { };

  texworks = callPackage ../applications/editors/texworks { };

  thc-hydra = callPackage ../tools/security/thc-hydra { };

  theharvester = callPackage ../tools/security/theharvester { };

  thefuck = python3Packages.callPackage ../tools/misc/thefuck { };

  thin-provisioning-tools = callPackage ../tools/misc/thin-provisioning-tools {  };

  tiled = libsForQt5.callPackage ../applications/editors/tiled { };

  timemachine = callPackage ../applications/audio/timemachine { };

  timelapse-deflicker = callPackage ../applications/graphics/timelapse-deflicker { };

  timetrap = callPackage ../applications/office/timetrap { };

  tzupdate = callPackage ../applications/misc/tzupdate { };

  tinc = callPackage ../tools/networking/tinc { };

  tie = callPackage ../development/tools/misc/tie { };

  tilix = callPackage ../applications/misc/tilix { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix { };

  tiny8086 = callPackage ../applications/virtualization/8086tiny { };

  tinyproxy = callPackage ../tools/networking/tinyproxy {};

  tio = callPackage ../tools/misc/tio { };

  tldr = callPackage ../tools/misc/tldr { };

  tldr-hs = haskellPackages.tldr;

  tlspool = callPackage ../tools/networking/tlspool { };

  tmate = callPackage ../tools/misc/tmate { };

  tmpwatch = callPackage ../tools/misc/tmpwatch  { };

  tmux = callPackage ../tools/misc/tmux { };

  tmux-cssh = callPackage ../tools/misc/tmux-cssh { };

  tmuxp = callPackage ../tools/misc/tmuxp { };

  tmuxinator = callPackage ../tools/misc/tmuxinator { };

  tmuxPlugins = recurseIntoAttrs (callPackage ../misc/tmux-plugins { });

  tmsu = callPackage ../tools/filesystems/tmsu {
    go = go_1_10;
  };

  toilet = callPackage ../tools/misc/toilet { };

  tokei = callPackage ../development/tools/misc/tokei { };

  tor = callPackage ../tools/security/tor {
    openssl = openssl_1_1;
    # remove this, when libevent's openssl is upgraded to 1_1_0 or newer.
    libevent = libevent.override {
      sslSupport = false;
    };
  };

  tor-arm = callPackage ../tools/security/tor/tor-arm.nix { };

  tor-browser-bundle-bin = callPackage ../applications/networking/browsers/tor-browser-bundle-bin {
    inherit (gnome3) defaultIconTheme;
  };

  tor-browser-bundle = callPackage ../applications/networking/browsers/tor-browser-bundle {
    stdenv = stdenvNoCC;
    tor-browser-unwrapped = firefoxPackages.tor-browser;
    inherit (python27Packages) obfsproxy;
  };

  touchegg = callPackage ../tools/inputmethods/touchegg { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  toxvpn = callPackage ../tools/networking/toxvpn { };

  tpmmanager = callPackage ../applications/misc/tpmmanager { };

  tpm-quote-tools = callPackage ../tools/security/tpm-quote-tools { };

  tpm-tools = callPackage ../tools/security/tpm-tools { };

  tpm-luks = callPackage ../tools/security/tpm-luks { };

  trezord = callPackage ../servers/trezord { };

  tthsum = callPackage ../applications/misc/tthsum { };

  chaps = callPackage ../tools/security/chaps { };

  trace-cmd = callPackage ../os-specific/linux/trace-cmd { };

  traceroute = callPackage ../tools/networking/traceroute { };

  tracebox = callPackage ../tools/networking/tracebox { };

  tracefilegen = callPackage ../development/tools/analysis/garcosim/tracefilegen { };

  tracefilesim = callPackage ../development/tools/analysis/garcosim/tracefilesim { };

  translate-shell = callPackage ../applications/misc/translate-shell { };

  transporter = callPackage ../applications/networking/transporter { };

  trash-cli = callPackage ../tools/misc/trash-cli { };

  trickle = callPackage ../tools/networking/trickle {};

  inherit (nodePackages) triton;

  triggerhappy = callPackage ../tools/inputmethods/triggerhappy {};

  trousers = callPackage ../tools/security/trousers { };

  tryton = callPackage ../applications/office/tryton { };

  trytond = callPackage ../applications/office/trytond { };

  omapd = callPackage ../tools/security/omapd { };

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ttfautohint = libsForQt5.callPackage ../tools/misc/ttfautohint { };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };

  tty-clock = callPackage ../tools/misc/tty-clock { };

  ttyrec = callPackage ../tools/misc/ttyrec { };

  ttylog = callPackage ../tools/misc/ttylog { };

  turses = callPackage ../applications/networking/instant-messengers/turses { };

  oysttyer = callPackage ../applications/networking/instant-messengers/oysttyer { };

  twilight = callPackage ../tools/graphics/twilight {
    libX11 = xorg.libX11;
  };

  twitterBootstrap3 = callPackage ../development/web/twitter-bootstrap {};
  twitterBootstrap = twitterBootstrap3;

  txt2man = callPackage ../tools/misc/txt2man { };

  txt2tags = callPackage ../tools/text/txt2tags { };

  txtw = callPackage ../tools/misc/txtw { };

  u9fs = callPackage ../servers/u9fs { };

  ua = callPackage ../tools/networking/ua { };

  ucl = callPackage ../development/libraries/ucl { };

  ucspi-tcp = callPackage ../tools/networking/ucspi-tcp { };

  udftools = callPackage ../tools/filesystems/udftools {};

  udpt = callPackage ../servers/udpt { };

  udptunnel = callPackage ../tools/networking/udptunnel { };

  ufraw = callPackage ../applications/graphics/ufraw {
    stdenv = overrideCC stdenv gcc6; # doesn't build with gcc7
  };

  uget = callPackage ../tools/networking/uget { };

  uget-integrator = callPackage ../tools/networking/uget-integrator { };

  uif2iso = callPackage ../tools/cd-dvd/uif2iso { };

  umlet = callPackage ../tools/misc/umlet { };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  unfs3 = callPackage ../servers/unfs3 { };

  unoconv = callPackage ../tools/text/unoconv { };

  unrtf = callPackage ../tools/text/unrtf { };

  untex = callPackage ../tools/text/untex { };

  untrunc = callPackage ../tools/video/untrunc { };

  upx = callPackage ../tools/compression/upx { };

  uqmi = callPackage ../tools/networking/uqmi { };

  uriparser = callPackage ../development/libraries/uriparser {};

  urlscan = callPackage ../applications/misc/urlscan { };

  urlview = callPackage ../applications/misc/urlview {};

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  usync = callPackage ../applications/misc/usync { };

  uwsgi = callPackage ../servers/uwsgi {
    plugins = [];
    withPAM = stdenv.isLinux;
    withSystemd = stdenv.isLinux;
  };

  vacuum = callPackage ../applications/networking/instant-messengers/vacuum {};

  vampire = callPackage ../applications/science/logic/vampire {};

  volatility = callPackage ../tools/security/volatility { };

  vbetool = callPackage ../tools/system/vbetool { };

  vde2 = callPackage ../tools/networking/vde2 { };

  vboot_reference = callPackage ../tools/system/vboot_reference { };

  vcftools = callPackage ../applications/science/biology/vcftools { };

  vcsh = callPackage ../applications/version-management/vcsh {
    inherit (perlPackages) ShellCommand TestMost TestDifferences TestDeep
      TestException TestWarn;
  };

  vcstool = callPackage ../development/tools/vcstool { };

  verilator = callPackage ../applications/science/electronics/verilator {};

  verilog = callPackage ../applications/science/electronics/verilog {};

  vfdecrypt = callPackage ../tools/misc/vfdecrypt { };

  vifm = callPackage ../applications/misc/vifm { };

  viking = callPackage ../applications/misc/viking {
    inherit (gnome2) scrollkeeper;
    inherit (gnome3) gexiv2;
  };

  vim-vint = callPackage ../development/tools/vim-vint { };

  vimer = callPackage ../tools/misc/vimer { };

  vit = callPackage ../applications/misc/vit { };

  vnc2flv = callPackage ../tools/video/vnc2flv {};

  vncrec = callPackage ../tools/video/vncrec { };

  vo-amrwbenc = callPackage ../development/libraries/vo-amrwbenc { };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vobsub2srt = callPackage ../tools/cd-dvd/vobsub2srt { };

  volume_key = callPackage ../development/libraries/volume-key { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

  vpnc = callPackage ../tools/networking/vpnc { };

  vp = callPackage ../applications/misc/vp {
    # Enable next line for console graphics. Note that
    # it requires `sixel` enabled terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
  };

  openconnect = openconnect_gnutls;

  openconnect_openssl = callPackage ../tools/networking/openconnect {
    gnutls = null;
  };

  openconnect_gnutls = callPackage ../tools/networking/openconnect {
    openssl = null;
  };

  ding-libs = callPackage ../tools/misc/ding-libs { };

  sssd = callPackage ../os-specific/linux/sssd {
    inherit (perlPackages) Po4a;
    inherit (python27Packages) ldap;
  };

  vtun = callPackage ../tools/networking/vtun { };

  wakatime = pythonPackages.callPackage ../tools/misc/wakatime { };

  weather = callPackage ../applications/misc/weather { };

  wego = callPackage ../applications/misc/wego { };

  wal_e = callPackage ../tools/backup/wal-e { };

  watchexec = callPackage ../tools/misc/watchexec { };

  watchman = callPackage ../development/tools/watchman {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    CoreFoundation = darwin.cf-private;
  };

  wavefunctioncollapse = callPackage ../tools/graphics/wavefunctioncollapse {};

  wbox = callPackage ../tools/networking/wbox {};

  welkin = callPackage ../tools/graphics/welkin {};

  whipper = callPackage ../applications/audio/whipper { };

  whois = callPackage ../tools/networking/whois { };

  wireguard-tools = callPackage ../tools/networking/wireguard-tools { };

  woff2 = callPackage ../development/web/woff2 { };

  woof = callPackage ../tools/misc/woof { };

  wsmancli = callPackage ../tools/system/wsmancli {};

  wolfebin = callPackage ../tools/networking/wolfebin {
    python = python2;
  };

  xautoclick = callPackage ../applications/misc/xautoclick {};

  xl2tpd = callPackage ../tools/networking/xl2tpd { };

  xe = callPackage ../tools/system/xe { };

  testdisk = callPackage ../tools/misc/testdisk { };

  textql = callPackage ../development/tools/textql { };

  html2text = callPackage ../tools/text/html2text { };

  html-tidy = callPackage ../tools/text/html-tidy { };

  html-xml-utils = callPackage ../tools/text/xml/html-xml-utils { };

  htmldoc = callPackage ../tools/typesetting/htmldoc {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration Foundation;
  };

  rcm = callPackage ../tools/misc/rcm {};

  tftp-hpa = callPackage ../tools/networking/tftp-hpa {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc xorg.fontbhlucidatypewriter75dpi ];
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tweet-hs = haskell.lib.justStaticExecutables haskellPackages.tweet-hs;

  qfsm = callPackage ../applications/science/electronics/qfsm { };

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix { };

  tm = callPackage ../tools/system/tm { };

  tradcpp = callPackage ../development/tools/tradcpp { };

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig {
    libpng = libpng12;
  };

  truecrypt = callPackage ../applications/misc/truecrypt {
    stdenv = overrideInStdenv stdenv [ useOldCXXAbi ];
    wxGUI = config.truecrypt.wxGUI or true;
  };

  ttmkfdir = callPackage ../tools/misc/ttmkfdir { };

  ttwatch = callPackage ../tools/misc/ttwatch { };

  udunits = callPackage ../development/libraries/udunits { };

  uemacs = callPackage ../applications/editors/uemacs { };

  uftp = callPackage ../servers/uftp { };

  uhttpmock = callPackage ../development/libraries/uhttpmock { };

  uim = callPackage ../tools/inputmethods/uim { };

  uhub = callPackage ../servers/uhub { };

  unclutter = callPackage ../tools/misc/unclutter { };

  unclutter-xfixes = callPackage ../tools/misc/unclutter-xfixes { };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units { };

  unittest-cpp = callPackage ../development/libraries/unittest-cpp { };

  unrar = callPackage ../tools/archivers/unrar { };

  xar = callPackage ../tools/compression/xar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  xarchiver = callPackage ../tools/archivers/xarchiver { };

  xbanish = callPackage ../tools/X11/xbanish { };

  xbrightness = callPackage ../tools/X11/xbrightness { };

  xkbvalidate = callPackage ../tools/X11/xkbvalidate { };

  xfstests = callPackage ../tools/misc/xfstests { };

  xprintidle-ng = callPackage ../tools/X11/xprintidle-ng {};

  xscast = callPackage ../applications/video/xscast { };

  xsettingsd = callPackage ../tools/X11/xsettingsd { };

  xsensors = callPackage ../os-specific/linux/xsensors { };

  xcruiser = callPackage ../applications/misc/xcruiser { };

  xxkb = callPackage ../applications/misc/xxkb { };

  ugarit = callPackage ../tools/backup/ugarit { };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker { };

  unar = callPackage ../tools/archivers/unar { stdenv = clangStdenv; };

  unarj = callPackage ../tools/archivers/unarj { };

  unp = callPackage ../tools/archivers/unp { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  undmg = callPackage ../tools/archivers/undmg { };

  uptimed = callPackage ../tools/system/uptimed { };

  urjtag = callPackage ../tools/misc/urjtag {
    svfSupport = true;
    bsdlSupport = true;
    staplSupport = true;
    jedecSupport = true;
  };

  urlwatch = callPackage ../tools/networking/urlwatch { };

  valum = callPackage ../development/web/valum {
    inherit (gnome3) libgee;
  };

  inherit (callPackages ../servers/varnish { })
    varnish4 varnish5 varnish6;
  inherit (callPackages ../servers/varnish/packages.nix { })
    varnish4Packages
    varnish5Packages
    varnish6Packages;

  varnishPackages = varnish5Packages;
  varnish = varnishPackages.varnish;

  hitch = callPackage ../servers/hitch { };

  venus = callPackage ../tools/misc/venus {
    python = python27;
  };

  veracrypt = callPackage ../applications/misc/veracrypt {
    wxGUI = true;
  };

  vlan = callPackage ../tools/networking/vlan { };

  vmtouch = callPackage ../tools/misc/vmtouch { };

  vncdo = callPackage ../tools/admin/vncdo { };

  volumeicon = callPackage ../tools/audio/volumeicon { };

  waf = callPackage ../development/tools/build-managers/waf { python = python3; };

  wakelan = callPackage ../tools/networking/wakelan { };

  wavemon = callPackage ../tools/networking/wavemon { };

  wdfs = callPackage ../tools/filesystems/wdfs { };

  wdiff = callPackage ../tools/text/wdiff { };

  webalizer = callPackage ../tools/networking/webalizer { };

  weighttp = callPackage ../tools/networking/weighttp { };

  wget = callPackage ../tools/networking/wget {
    inherit (perlPackages) IOSocketSSL LWP;
    libpsl = null;
  };

  which = callPackage ../tools/system/which { };

  woeusb = callPackage ../tools/misc/woeusb { };

  chase = callPackage ../tools/system/chase { };

  wicd = callPackage ../tools/networking/wicd { };

  wimlib = callPackage ../tools/archivers/wimlib { };

  wipe = callPackage ../tools/security/wipe { };

  wireguard-go = callPackage ../tools/networking/wireguard-go { };

  wkhtmltopdf = callPackage ../tools/graphics/wkhtmltopdf { };

  wml = callPackage ../development/web/wml { };

  wol = callPackage ../tools/networking/wol { };

  wring = nodePackages.wring;

  wrk = callPackage ../tools/networking/wrk { };

  wrk2 = callPackage ../tools/networking/wrk2 { };

  wuzz = callPackage ../tools/networking/wuzz { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  wyrd = callPackage ../tools/misc/wyrd {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  x86info = callPackage ../os-specific/linux/x86info { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross = pkgsCross.ben-nanonote.buildPackages.gccCrossStageStatic;
  };

  clipnotify = callPackage ../tools/misc/clipnotify { };

  xclip = callPackage ../tools/misc/xclip { };

  xcwd = callPackage ../tools/X11/xcwd { };

  xtitle = callPackage ../tools/misc/xtitle { };

  xdelta = callPackage ../tools/compression/xdelta { };
  xdeltaUnstable = callPackage ../tools/compression/xdelta/unstable.nix { };

  xdummy = callPackage ../tools/misc/xdummy { };

  xdxf2slob = callPackage ../tools/misc/xdxf2slob { };

  xe-guest-utilities = callPackage ../tools/virtualization/xe-guest-utilities { };

  xflux = callPackage ../tools/misc/xflux { };
  xflux-gui = callPackage ../tools/misc/xflux/gui.nix {
    gnome_python = gnome2.gnome_python;
  };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { utillinux = utillinuxMinimal; };
  libxfs = xfsprogs.dev;

  xml2 = callPackage ../tools/text/xml/xml2 { };

  xmlformat = callPackage ../tools/text/xml/xmlformat { };

  xmlroff = callPackage ../tools/typesetting/xmlroff { };

  xmloscopy = callPackage ../tools/text/xml/xmloscopy { };

  xmlstarlet = callPackage ../tools/text/xml/xmlstarlet { };

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xmpppy = pythonPackages.xmpppy;

  xiccd = callPackage ../tools/misc/xiccd { };

  xidlehook = callPackage ../tools/X11/xidlehook {};

  xorriso = callPackage ../tools/cd-dvd/xorriso { };

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsecurelock = callPackage ../tools/X11/xsecurelock { };

  xsel = callPackage ../tools/misc/xsel { };

  xsv = callPackage ../tools/text/xsv { };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {
    boost = boost165;
  };

  xurls = callPackage ../tools/text/xurls {};

  xvfb_run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  xvkbd = callPackage ../tools/X11/xvkbd {};

  xwinmosaic = callPackage ../tools/X11/xwinmosaic {};

  xwinwrap = callPackage ../tools/X11/xwinwrap {};

  yafaray-core = callPackage ../tools/graphics/yafaray-core { };

  yaft = callPackage ../applications/misc/yaft { };

  yarn = callPackage ../development/tools/yarn  { };

  yarn2nix = callPackage ../development/tools/yarn2nix { };
  inherit (yarn2nix) mkYarnPackage;

  yasr = callPackage ../applications/audio/yasr { };

  yank = callPackage ../tools/misc/yank { };

  yaml-merge = callPackage ../tools/text/yaml-merge { };

  yeshup = callPackage ../tools/system/yeshup { };

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  yle-dl = callPackage ../tools/misc/yle-dl {};

  you-get = python3Packages.callPackage ../tools/misc/you-get { };

  zbackup = callPackage ../tools/backup/zbackup {};

  zbar = callPackage ../tools/graphics/zbar { };

  zdelta = callPackage ../tools/compression/zdelta { };

  zerotierone = callPackage ../tools/networking/zerotierone { };

  zerofree = callPackage ../tools/filesystems/zerofree { };

  zfstools = callPackage ../tools/filesystems/zfstools { };

  zile = callPackage ../applications/editors/zile { };

  zinnia = callPackage ../tools/inputmethods/zinnia { };
  tegaki-zinnia-japanese = callPackage ../tools/inputmethods/tegaki-zinnia-japanese { };

  zimreader = callPackage ../tools/text/zimreader { };

  zimwriterfs = callPackage ../tools/text/zimwriterfs { };

  par = callPackage ../tools/text/par { };

  zip = callPackage ../tools/archivers/zip { };

  zkfuse = callPackage ../tools/filesystems/zkfuse { };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  zsh-autoenv = callPackage ../tools/misc/zsh-autoenv { };

  zsh-git-prompt = callPackage ../shells/zsh/zsh-git-prompt { };

  zsh-history-substring-search = callPackage ../shells/zsh/zsh-history-substring-search { };

  zsh-navigation-tools = callPackage ../tools/misc/zsh-navigation-tools { };

  zsh-syntax-highlighting = callPackage ../shells/zsh/zsh-syntax-highlighting { };

  zsh-autosuggestions = callPackage ../shells/zsh/zsh-autosuggestions { };

  zsh-powerlevel9k = callPackage ../shells/zsh/zsh-powerlevel9k { };

  zsh-command-time = callPackage ../shells/zsh/zsh-command-time { };

  zssh = callPackage ../tools/networking/zssh { };

  zstd = callPackage ../tools/compression/zstd { };

  zsync = callPackage ../tools/compression/zsync { };

  zxing = callPackage ../tools/graphics/zxing {};


  ### SHELLS

  runtimeShell = "${runtimeShellPackage}${runtimeShellPackage.shellPath}";
  runtimeShellPackage = bash;

  bash = lowPrio (callPackage ../shells/bash/4.4.nix { });

  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = callPackage ../shells/bash/4.4.nix {
    interactive = true;
    withDocs = true;
  };

  bash-completion = callPackage ../shells/bash/bash-completion { };

  gradle-completion = callPackage ../shells/zsh/gradle-completion { };

  nix-bash-completions = callPackage ../shells/bash/nix-bash-completions { };

  dash = callPackage ../shells/dash { };

  dashing = callPackage ../tools/misc/dashing { };

  es = callPackage ../shells/es { };

  fish = callPackage ../shells/fish { };

  fish-foreign-env = callPackage ../shells/fish/fish-foreign-env { };

  ion = callPackage ../shells/ion { };

  mksh = callPackage ../shells/mksh { };

  oh = callPackage ../shells/oh { };

  oil = callPackage ../shells/oil { };

  pash = callPackage ../shells/pash { };

  tcsh = callPackage ../shells/tcsh { };

  rssh = callPackage ../shells/rssh { };

  rush = callPackage ../shells/rush { };

  xonsh = callPackage ../shells/xonsh { };

  zsh = callPackage ../shells/zsh { };

  nix-zsh-completions = callPackage ../shells/zsh/nix-zsh-completions { };

  zsh-completions = callPackage ../shells/zsh/zsh-completions { };

  zsh-prezto = callPackage ../shells/zsh/zsh-prezto { };

  grml-zsh-config = callPackage ../shells/zsh/grml-zsh-config { };


  ### DEVELOPMENT / COMPILERS

  abcl = callPackage ../development/compilers/abcl {};

  aldor = callPackage ../development/compilers/aldor { };

  aliceml = callPackage ../development/compilers/aliceml { };

  arachne-pnr = callPackage ../development/compilers/arachne-pnr { };

  asn1c = callPackage ../development/compilers/asn1c { };

  aspectj = callPackage ../development/compilers/aspectj { };

  ats = callPackage ../development/compilers/ats { };
  ats2 = callPackage ../development/compilers/ats2 { };

  avra = callPackage ../development/compilers/avra { };

  avian = callPackage ../development/compilers/avian {
    inherit (darwin.apple_sdk.frameworks) CoreServices Foundation;
    stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
  };

  bigloo = callPackage ../development/compilers/bigloo { };

  binaryen = callPackage ../development/compilers/binaryen { };

  colm = callPackage ../development/compilers/colm { };

  fetchegg = callPackage ../build-support/fetchegg { };

  eggDerivation = callPackage ../development/compilers/chicken/eggDerivation.nix { };

  chicken = callPackage ../development/compilers/chicken {
    bootstrap-chicken = chicken.override { bootstrap-chicken = null; };
  };

  egg2nix = callPackage ../development/tools/egg2nix {
    chickenEggs = callPackage ../development/tools/egg2nix/chicken-eggs.nix { };
  };

  ccl = callPackage ../development/compilers/ccl {
    inherit (darwin) bootstrap_cmds;
  };

  chez = callPackage ../development/compilers/chez {
    inherit (darwin) cctools;
  };

  clang = llvmPackages.clang;
  clang-manpages = llvmPackages.clang-manpages;

  clang-sierraHack = clang.override {
    name = "clang-wrapper-with-reexport-hack";
    bintools = darwin.binutils.override {
      useMacosReexportHack = true;
      bintools = darwin.binutils.bintools.override {
        cctools = darwin.cctools.override {
          enableDumpNormalizedLibArgs = true;
        };
      };
    };
  };

  clang_7  = llvmPackages_7.clang;
  clang_6  = llvmPackages_6.clang;
  clang_5  = llvmPackages_5.clang;
  clang_4  = llvmPackages_4.clang;
  clang_39 = llvmPackages_39.clang;
  clang_38 = llvmPackages_38.clang;
  clang_37 = llvmPackages_37.clang;
  clang_35 = wrapCC llvmPackages_35.clang;

  clang-tools = callPackage ../development/tools/clang-tools { };

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer { };

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.cc.isClang then stdenv else lowPrio llvmPackages.stdenv;
  clang-sierraHack-stdenv = overrideCC stdenv clang-sierraHack;
  libcxxStdenv = if stdenv.isDarwin then stdenv else lowPrio llvmPackages.libcxxStdenv;

  clasp-common-lisp = callPackage ../development/compilers/clasp {};

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmdstan = callPackage ../development/compilers/cmdstan { };

  cmucl_binary = pkgsi686Linux.callPackage ../development/compilers/cmucl/binary.nix { };

  compcert = callPackage ../development/compilers/compcert { };

  cpp-gsl = callPackage ../development/libraries/cpp-gsl { };

  # Users installing via `nix-env` will likely be using the REPL,
  # which has a hard dependency on Z3, so make sure it is available.
  cryptol = haskellPackages.cryptol.overrideDerivation (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []) ++ [ makeWrapper ];
    installPhase = (oldAttrs.installPhase or "") + ''
      wrapProgram $out/bin/cryptol \
        --prefix 'PATH' ':' "${lib.getBin z3}/bin"
    '';
  });

  crystal = callPackage ../development/compilers/crystal { };

  devpi-client = callPackage ../development/tools/devpi-client {};

  devpi-server = callPackage ../development/tools/devpi-server {};

  dotty = callPackage ../development/compilers/scala/dotty.nix { jre = jre8;};

  drumstick = callPackage ../development/libraries/drumstick { };

  ecl = callPackage ../development/compilers/ecl { };
  ecl_16_1_2 = callPackage ../development/compilers/ecl/16.1.2.nix { };

  eli = callPackage ../development/compilers/eli { };

  eql = callPackage ../development/compilers/eql {};

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  apache-flex-sdk = callPackage ../development/compilers/apache-flex-sdk { };

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { stdenv = gccStdenv; };
  gambit-unstable = callPackage ../development/compilers/gambit/unstable.nix { stdenv = gccStdenv; };
  gerbil = callPackage ../development/compilers/gerbil { stdenv = gccStdenv; };
  gerbil-unstable = callPackage ../development/compilers/gerbil/unstable.nix { stdenv = gccStdenv; };

  gccFun = callPackage ../development/compilers/gcc/7;
  gcc = gcc7;
  gcc-unwrapped = gcc.cc;

  gccStdenv = if stdenv.cc.isGNU then stdenv else stdenv.override {
    allowedRequisites = null;
    cc = gcc;
    # Remove libcxx/libcxxabi, and add clang for AS if on darwin (it uses
    # clang's internal assembler).
    extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin clang.cc;
  };

  gcc7Stdenv = overrideCC gccStdenv gcc7;
  gcc8Stdenv = overrideCC gccStdenv gcc8;

  wrapCCMulti = cc:
    if stdenv.targetPlatform.system == "x86_64-linux" then let
      # Binutils with glibc multi
      bintools = cc.bintools.override {
        libc = glibc_multi;
      };
    in lowPrio (wrapCCWith {
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
  }) else throw "Multilib ${cc.name} not supported for ‘${stdenv.targetPlatform.system}’";

  wrapClangMulti = clang:
    if stdenv.targetPlatform.system == "x86_64-linux" then
      callPackage ../development/compilers/llvm/multi.nix {
        inherit clang;
        gcc32 = pkgsi686Linux.gcc;
        gcc64 = pkgs.gcc;
      }
    else throw "Multilib ${clang.cc.name} not supported for '${stdenv.targetPlatform.system}'";

  gcc_multi = wrapCCMulti gcc;
  clang_multi = wrapClangMulti clang;

  gccMultiStdenv = overrideCC stdenv gcc_multi;
  clangMultiStdenv = overrideCC stdenv clang_multi;
  multiStdenv = if stdenv.cc.isClang then clangMultiStdenv else gccMultiStdenv;

  gcc_debug = lowPrio (wrapCC (gcc.cc.override {
    stripped = false;
  }));

  libstdcxxHook = makeSetupHook
    { substitutions = { gcc = gcc-unwrapped; }; }
    ../development/compilers/gcc/libstdc++-hook.sh;

  crossLibcStdenv = overrideCC stdenv buildPackages.gccCrossStageStatic;

  # The GCC used to build libc for the target platform. Normal gccs will be
  # built with, and use, that cross-compiled libc.
  gccCrossStageStatic = assert stdenv.targetPlatform != stdenv.hostPlatform; let
    libcCross1 =
      if stdenv.targetPlatform.libc == "msvcrt" then targetPackages.windows.mingw_w64_headers
      else if stdenv.targetPlatform.libc == "libSystem" then darwin.xcode
      else null;
    binutils1 = wrapBintoolsWith {
      bintools = binutils-unwrapped;
      libc = libcCross1;
    };
    in wrapCCWith {
      cc = gccFun {
        # copy-pasted
        inherit noSysDirs;
        # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
        profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));
        isl = if !stdenv.isDarwin then isl_0_17 else null;

        # just for stage static
        crossStageStatic = true;
        langCC = false;
        libcCross = libcCross1;
        targetPackages.stdenv.cc.bintools = binutils1;
        enableShared = false;
      };
      bintools = binutils1;
      libc = libcCross1;
  };

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isSunOS && !isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
    cloog = if !stdenv.isDarwin then cloog else null;
    texinfo = texinfo5; # doesn't validate since 6.1 -> 6.3 bump
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_11 else null;

    cloog = if !stdenv.isDarwin then cloog_0_18_0 else null;
  }));

  gcc5 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/5 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc6 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/6 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc7 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/7 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc8 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc-snapshot = lowPrio (wrapCC (callPackage ../development/compilers/gcc/snapshot {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = isl_0_17;
  }));

  gfortran = gfortran7;

  gfortran48 = wrapCC (gcc48.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran49 = wrapCC (gcc49.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran5 = wrapCC (gcc5.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran6 = wrapCC (gcc6.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran7 = wrapCC (gcc7.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gcj = gcj6;
  gcj6 = wrapCC (gcc6.cc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit (gnome2) libart_lgpl;
  });

  gnu-smalltalk = callPackage ../development/compilers/gnu-smalltalk {
    emacsSupport = config.emacsSupport or false;
  };

  gccgo = gccgo6;
  gccgo6 = wrapCC (gcc6.cc.override {
    name = "gccgo6";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
    profiledCompiler = false;
  });

  gcl = callPackage ../development/compilers/gcl {
    gmp = gmp4;
  };

  gcl_2_6_13_pre = callPackage ../development/compilers/gcl/2.6.13-pre.nix { };

  gcc-arm-embedded-4_7 = pkgsi686Linux.callPackage ../development/compilers/gcc-arm-embedded {
    version = "4.7-2013q3-20130916";
    releaseType = "update";
    sha256 = "1bd9bi9q80xn2rpy0rn1vvj70rh15kb7dmah0qs4q2rv78fqj40d";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-4_8 = pkgsi686Linux.callPackage ../development/compilers/gcc-arm-embedded {
    version = "4.8-2014q1-20140314";
    releaseType = "update";
    sha256 = "ce92859550819d4a3d1a6e2672ea64882b30afa2c08cf67fa8e1d93788c2c577";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-4_9 = pkgsi686Linux.callPackage ../development/compilers/gcc-arm-embedded {
    version = "4.9-2015q1-20150306";
    releaseType = "update";
    sha256 = "c5e0025b065750bbd76b5357b4fc8606d88afbac9ff55b8a82927b4b96178154";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-5 = pkgs.pkgsi686Linux.callPackage ../development/compilers/gcc-arm-embedded {
    dirName = "5.0";
    subdirName = "5-2016-q2-update";
    version = "5.4-2016q2-20160622";
    releaseType = "update";
    sha256 = "1r0rqbnw7rf94f5bsa3gi8bick4xb7qnp1dkvdjfbvqjvysvc44r";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-6 = callPackage ../development/compilers/gcc-arm-embedded/6 {};
  gcc-arm-embedded = gcc-arm-embedded-6;

  gforth = callPackage ../development/compilers/gforth {};

  gtk-server = callPackage ../development/interpreters/gtk-server {};

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  haskellPackages = haskell.packages.ghc843.override {
    overrides = config.haskellPackageOverrides or haskell.packageOverrides;
  };

  inherit (haskellPackages) ghc;

  cabal-install = haskell.lib.justStaticExecutables haskellPackages.cabal-install;

  stack = haskell.lib.justStaticExecutables haskellPackages.stack;
  hlint = haskell.lib.justStaticExecutables haskellPackages.hlint;

  all-cabal-hashes = callPackage ../data/misc/hackage { };

  purescript = haskell.lib.justStaticExecutables haskellPackages.purescript;
  psc-package = haskell.lib.justStaticExecutables
    (haskellPackages.callPackage ../development/compilers/purescript/psc-package { });

  tamarin-prover =
    (haskellPackages.callPackage ../applications/science/logic/tamarin-prover {
      # NOTE: do not use the haskell packages 'graphviz' and 'maude'
      inherit maude which sapic;
      graphviz = graphviz-nox;
    });

  inherit (ocaml-ng.ocamlPackages_4_05.haxe) haxe_3_2 haxe_3_4;
  haxe = haxe_3_4;
  haxePackages = recurseIntoAttrs (callPackage ./haxe-packages.nix { });
  inherit (haxePackages) hxcpp;

  hhvm = callPackage ../development/compilers/hhvm { };

  hop = callPackage ../development/compilers/hop { };

  falcon = callPackage ../development/interpreters/falcon { };

  fsharp = callPackage ../development/compilers/fsharp { };

  fsharp41 = callPackage ../development/compilers/fsharp41 {
    mono = mono46;
  };

  fstar = callPackage ../development/compilers/fstar { };

  pyre = callPackage ../development/tools/pyre { };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  glslang = callPackage ../development/compilers/glslang { };

  go_bootstrap = if stdenv.isAarch64 then
    srcOnly {
      name = "go-1.8-linux-arm64-bootstrap";
      src = fetchurl {
        url = "https://cache.xor.us/go-1.8-linux-arm64-bootstrap.tar.xz";
        sha256 = "0sk6g03x9gbxk2k1djnrgy8rzw1zc5f6ssw0hbxk6kjr85lpmld6";
      };
    }
  else
    callPackage ../development/compilers/go/1.4.nix {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

  go_1_9 = callPackage ../development/compilers/go/1.9.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_10 = callPackage ../development/compilers/go/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_11 = callPackage ../development/compilers/go/1.11.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go = go_1_11;

  go-repo-root = callPackage ../development/tools/go-repo-root { };

  gox = callPackage ../development/tools/gox { };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  icedtea8_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk8;
  };

  icedtea_web = icedtea8_web;

  idrisPackages = callPackage ../development/idris-modules {
    idris-no-deps = haskellPackages.idris;
  };

  idris = idrisPackages.with-packages [ idrisPackages.base ] ;

  intercal = callPackage ../development/compilers/intercal { };

  irony-server = callPackage ../development/tools/irony-server {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacsPackagesNg.melpaStablePackages) irony;
  };

  hugs = callPackage ../development/interpreters/hugs { };

  bootjdk = callPackage ../development/compilers/openjdk/bootstrap.nix { version = "10"; };

  openjdk8 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/8.nix { }
    else
      callPackage ../development/compilers/openjdk/8.nix {
        bootjdk = bootjdk.override { version = "8"; };
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk10 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/10.nix { }
    else
      callPackage ../development/compilers/openjdk/10.nix {
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk = openjdk8;

  jdk8 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejdk8 else openjdk8 // { outputs = [ "out" ]; };
  jre8 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejre8 else lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}"
    (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
      (openjdk8.jre // { outputs = [ "jre" ]; }));
  jre8_headless =
    if stdenv.isAarch32 || stdenv.isAarch64 then
      oraclejre8
    else if stdenv.isDarwin then
      jre8
    else
      lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}-headless"
        (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
          ((openjdk8.override { minimal = true; }).jre // { outputs = [ "jre" ]; }));

  jdk10 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejdk10 else openjdk10 // { outputs = [ "out" ]; };
  jre10 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejre10 else lib.setName "openjre-${lib.getVersion pkgs.openjdk10.jre}"
    (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
      (openjdk10.jre // { outputs = [ "jre" ]; }));
  jre10_headless =
    if stdenv.isAarch32 || stdenv.isAarch64 then
      oraclejre10
    else if stdenv.isDarwin then
      jre10
    else
      lib.setName "openjre-${lib.getVersion pkgs.openjdk10.jre}-headless"
        (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
          ((openjdk10.override { minimal = true; }).jre // { outputs = [ "jre" ]; }));

  jdk = jdk8;
  jre = jre8;
  jre_headless = jre8_headless;

  inherit (callPackages ../development/compilers/graalvm { }) mx jvmci8 graalvm8;

  openshot-qt = libsForQt5.callPackage ../applications/video/openshot-qt { };

  oraclejdk = pkgs.jdkdistro true false;

  oraclejdk8 = pkgs.oraclejdk8distro true false;

  oraclejdk8psu = pkgs.oraclejdk8psu_distro true false;

  oraclejdk10 = pkgs.oraclejdk10distro "JDK" false;

  oraclejre = lowPrio (pkgs.jdkdistro false false);

  oraclejre8 = lowPrio (pkgs.oraclejdk8distro false false);

  oraclejre8psu = lowPrio (pkgs.oraclejdk8psu_distro false false);

  oraclejre10 = lowPrio (pkgs.oraclejdk10distro "JRE" false);

  oracleserverjre10 = lowPrio (pkgs.oraclejdk10distro "ServerJRE" false);

  jrePlugin = jre8Plugin;

  jre8Plugin = lowPrio (pkgs.oraclejdk8distro false true);

  jdkdistro = oraclejdk8distro;

  oraclejdk8distro = installjdk: pluginSupport:
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8cpu-linux.nix { inherit installjdk pluginSupport; });

  oraclejdk8psu_distro = installjdk: pluginSupport:
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8psu-linux.nix { inherit installjdk pluginSupport; });

  oraclejdk10distro = packageType: _:
      (callPackage ../development/compilers/oraclejdk/jdk10-linux.nix { inherit packageType; });

  javacard-devkit = pkgsi686Linux.callPackage ../development/compilers/javacard-devkit { };

  jikes = callPackage ../development/compilers/jikes { };

  julia_06 = callPackage ../development/compilers/julia {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
    llvm = llvm_39;
  };

  julia_07 = callPackage ../development/compilers/julia/0.7.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia_10 = callPackage ../development/compilers/julia/1.0.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia = julia_06;

  jwasm =  callPackage ../development/compilers/jwasm { };

  kotlin = callPackage ../development/compilers/kotlin { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lessc = nodePackages.less;

  liquibase = callPackage ../development/tools/database/liquibase { };

  lizardfs = callPackage ../tools/filesystems/lizardfs { };

  lld = llvmPackages.lld;
  lld_4 = llvmPackages_4.lld;
  lld_5 = llvmPackages_5.lld;
  lld_6 = llvmPackages_6.lld;
  lld_7 = llvmPackages_7.lld;

  lldb = llvmPackages.lldb;
  lldb_4 = llvmPackages_4.lldb;
  lldb_5 = llvmPackages_5.lldb;
  lldb_6 = llvmPackages_6.lldb;
  lldb_7 = llvmPackages_7.lldb;

  llvm = llvmPackages.llvm;
  llvm-manpages = llvmPackages.llvm-manpages;

  llvm_7  = llvmPackages_7.llvm;
  llvm_6  = llvmPackages_6.llvm;
  llvm_5  = llvmPackages_5.llvm;
  llvm_4  = llvmPackages_4.llvm;
  llvm_39 = llvmPackages_39.llvm;
  llvm_38 = llvmPackages_38.llvm;
  llvm_37 = llvmPackages_37.llvm;
  llvm_35 = llvmPackages_35.llvm;

  llvmPackages = recurseIntoAttrs llvmPackages_5;

  llvmPackages_35 = callPackage ../development/compilers/llvm/3.5 ({
    isl = isl_0_14;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_37 = callPackage ../development/compilers/llvm/3.7 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_37.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_37.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_38 = callPackage ../development/compilers/llvm/3.8 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_38.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_38.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_39 = callPackage ../development/compilers/llvm/3.9 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_39.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_39.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_4 = callPackage ../development/compilers/llvm/4 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_4.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_4.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_5 = callPackage ../development/compilers/llvm/5 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_5.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_5.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_6 = callPackage ../development/compilers/llvm/6 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_6.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_6.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_7 = callPackage ../development/compilers/llvm/7 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_7.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_7.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  manticore = callPackage ../development/compilers/manticore { };

  mentorToolchains = recurseIntoAttrs (
    pkgsi686Linux.callPackage ../development/compilers/mentor {}
  );

  mercury = callPackage ../development/compilers/mercury { };

  microscheme = callPackage ../development/compilers/microscheme { };

  mint = callPackage ../development/compilers/mint { };

  mitscheme = callPackage ../development/compilers/mit-scheme {
   texLive = texlive.combine { inherit (texlive) scheme-small; };
   texinfo = texinfo5;
   xlibsWrapper = null;
  };

  mitschemeX11 = mitscheme.override {
   texLive = texlive.combine { inherit (texlive) scheme-small; };
   texinfo = texinfo5;
   enableX11 = true;
  };

  mkcl = callPackage ../development/compilers/mkcl {};

  mlton = callPackage ../development/compilers/mlton { };

  mono  = mono5;
  mono5 = mono58;
  mono4 = mono48;

  mono40 = lowPrio (callPackage ../development/compilers/mono/4.0.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono44 = lowPrio (callPackage ../development/compilers/mono/4.4.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono46 = lowPrio (callPackage ../development/compilers/mono/4.6.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono48 = lowPrio (callPackage ../development/compilers/mono/4.8.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono50 = lowPrio (callPackage ../development/compilers/mono/5.0.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono54 = lowPrio (callPackage ../development/compilers/mono/5.4.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono58 = callPackage ../development/compilers/mono/5.8.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  mono514 = callPackage ../development/compilers/mono/5.14.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mosml = callPackage ../development/compilers/mosml { };

  mozart-binary = callPackage ../development/compilers/mozart/binary.nix { };
  mozart = mozart-binary;

  nim = callPackage ../development/compilers/nim { };
  nrpl = callPackage ../development/tools/nrpl { };

  neko = callPackage ../development/compilers/neko { };

  nextpnr = libsForQt5.callPackage ../development/compilers/nextpnr { };

  nasm = callPackage ../development/compilers/nasm { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  obliv-c = callPackage ../development/compilers/obliv-c {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  ocaml-ng = callPackage ./ocaml-packages.nix { };
  ocaml = ocamlPackages.ocaml;

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml = callPackage ../development/compilers/ocaml/ber-metaocaml-104.nix { };

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  ocaml-top = callPackage ../development/tools/ocaml/ocaml-top { };

  ocsigen-i18n = callPackage ../development/tools/ocaml/ocsigen-i18n { };

  opa = callPackage ../development/compilers/opa {
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  opaline = callPackage ../development/tools/ocaml/opaline { };

  opam = callPackage ../development/tools/ocaml/opam { };
  opam_1_2 = callPackage ../development/tools/ocaml/opam/1.2.2.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  picat = callPackage ../development/compilers/picat {
    stdenv = overrideCC stdenv gcc49;
  };

  ponyc = callPackage ../development/compilers/ponyc {
    llvm = llvm_39;
  };

  pony-stable = callPackage ../development/compilers/ponyc/pony-stable.nix { };

  rgbds = callPackage ../development/compilers/rgbds { };

  rtags = callPackage ../development/tools/rtags {
    inherit (darwin) apple_sdk;
  };

  # For beta and nightly releases use the nixpkgs-mozilla overlay
  rust = callPackage ../development/compilers/rust
    (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    });
  inherit (rust) cargo rustc;

  buildRustCrate = callPackage ../build-support/rust/build-rust-crate { };
  buildRustCrateTests = recurseIntoAttrs (callPackage ../build-support/rust/build-rust-crate/test { }).tests;

  cargo-vendor = callPackage ../build-support/rust/cargo-vendor { };

  cargo-web = callPackage ../development/tools/cargo-web {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  carnix = (callPackage ../build-support/rust/carnix.nix { }).carnix { };

  defaultCrateOverrides = callPackage ../build-support/rust/default-crate-overrides.nix { };

  rustPlatform = recurseIntoAttrs (makeRustPlatform rust);

  makeRustPlatform = rust: lib.fix (self:
    let
      callPackage = newScope self;
    in {
      inherit rust;

      buildRustPackage = callPackage ../build-support/rust {
        inherit rust;
      };

      rustcSrc = callPackage ../development/compilers/rust/rust-src.nix {
        inherit (rust) rustc;
      };
    });

  cargo-download = callPackage ../tools/package-management/cargo-download { };
  cargo-edit = callPackage ../tools/package-management/cargo-edit { };
  cargo-release = callPackage ../tools/package-management/cargo-release { };
  cargo-tree = callPackage ../tools/package-management/cargo-tree { };
  cargo-update = callPackage ../tools/package-management/cargo-update { };

  cargo-asm = callPackage ../development/tools/rust/cargo-asm { };
  cargo-fuzz = callPackage ../development/tools/rust/cargo-fuzz { };

  rainicorn = callPackage ../development/tools/rust/rainicorn { };
  rustfmt = callPackage ../development/tools/rust/rustfmt { };
  rustracer = callPackage ../development/tools/rust/racer { };
  rustracerd = callPackage ../development/tools/rust/racerd { };
  rust-bindgen = callPackage ../development/tools/rust/bindgen { };
  rust-cbindgen = callPackage ../development/tools/rust/cbindgen { };
  rustup = callPackage ../development/tools/rust/rustup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sbclBootstrap = callPackage ../development/compilers/sbcl/bootstrap.nix {};
  sbcl = callPackage ../development/compilers/sbcl {};

  scala_2_10 = callPackage ../development/compilers/scala/2.10.nix { };
  scala_2_11 = callPackage ../development/compilers/scala/2.11.nix { };
  scala_2_12 = callPackage ../development/compilers/scala { jre = jre8; };
  scala = scala_2_12;

  scalafmt = callPackage ../development/tools/scalafmt { };

  sdcc = callPackage ../development/compilers/sdcc {
    gputils = null;
  };

  serpent = callPackage ../development/compilers/serpent { };

  shmig = callPackage ../development/tools/database/shmig { };

  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = if stdenv.isDarwin
            then callPackage ../development/compilers/smlnj { }
            else pkgsi686Linux.callPackage ../development/compilers/smlnj { };

  solc = callPackage ../development/compilers/solc { };

  souffle = callPackage ../development/compilers/souffle { };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper { };

  # sqldeveloper_18 needs JavaFX, which currently only is available inside the
  # (non-free and net yet packaged for Darwin) OracleJDK
  # we might be able to get rid of it, as soon as we have an OpenJDK with OpenJFX included
  sqldeveloper_18 = callPackage ../development/tools/database/sqldeveloper/18.2.nix {
    jdk = oraclejdk;
  };

  squeak = callPackage ../development/compilers/squeak { };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [ mysql_jdbc postgresql_jdbc ];
  };

  stalin = callPackage ../development/compilers/stalin { };

  metaBuildEnv = callPackage ../development/compilers/meta-environment/meta-build-env { };

  swift = callPackage ../development/compilers/swift { };

  swiProlog = callPackage ../development/compilers/swi-prolog { };

  tbb = callPackage ../development/libraries/tbb { };

  terra = callPackage ../development/compilers/terra {
    llvmPackages = llvmPackages_38 // {
      llvm = llvmPackages_38.llvm.override { enableSharedLibraries = false; };
    };
    lua = lua5_1;
  };

  teyjus = callPackage ../development/compilers/teyjus {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
    omake = omake_rc1;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = pkgs.gnome2.GConf;
  };

  tinycc = callPackage ../development/compilers/tinycc { };

  inherit (ocaml-ng.ocamlPackages_4_02) trv;

  bupc = callPackage ../development/compilers/bupc { };

  urn = callPackage ../development/compilers/urn { };

  urweb = callPackage ../development/compilers/urweb { };

  inherit (callPackage ../development/compilers/vala { })
    vala_0_34
    vala_0_36
    vala_0_38
    vala_0_40
    vala;

  valadoc = callPackage ../development/tools/valadoc { };

  wcc = callPackage ../development/compilers/wcc { };

  wla-dx = callPackage ../development/compilers/wla-dx { };

  wrapCCWith =
    { cc
    , # This should be the only bintools runtime dep with this sort of logic. The
      # Others should instead delegate to the next stage's choice with
      # `targetPackages.stdenv.cc.bintools`. This one is different just to
      # provide the default choice, avoiding infinite recursion.
      bintools ? if stdenv.targetPlatform.isDarwin then darwin.binutils else binutils
    , libc ? bintools.libc
    , ...
    } @ extraArgs:
      callPackage ../build-support/cc-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    noLibc = !self.nativeLibc && (self.libc == null);

    isGNU = cc.isGNU or false;
    isClang = cc.isClang or false;

    inherit cc bintools libc;
  } // extraArgs; in self);

  wrapCC = cc: wrapCCWith {
    inherit cc;
  };

  wrapBintoolsWith =
    { bintools
    , libc ? if stdenv.targetPlatform != stdenv.hostPlatform then libcCross else stdenv.cc.libc
    , ...
    } @ extraArgs:
      callPackage ../build-support/bintools-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";

    noLibc = (self.libc == null);

    inherit bintools libc;
  } // extraArgs; in self);

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yasm = callPackage ../development/compilers/yasm { };

  yosys = callPackage ../development/compilers/yosys { };

  z88dk = callPackage ../development/compilers/z88dk { };

  zulu8 = callPackage ../development/compilers/zulu/8.nix { };
  zulu = callPackage ../development/compilers/zulu { };

  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 { };

  angelscript = callPackage ../development/interpreters/angelscript {};

  angelscript_2_22 = callPackage ../development/interpreters/angelscript/2.22.nix {};

  chibi = callPackage ../development/interpreters/chibi { };

  ceptre = callPackage ../development/interpreters/ceptre { };

  clips = callPackage ../development/interpreters/clips { };

  clisp = callPackage ../development/interpreters/clisp { };
  clisp-tip = callPackage ../development/interpreters/clisp/hg.nix { };

  clojure = callPackage ../development/interpreters/clojure { };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  dhall = callPackage ../development/interpreters/dhall { };

  dhall-nix = haskell.lib.justStaticExecutables haskellPackages.dhall-nix;

  dhall-bash = haskell.lib.justStaticExecutables haskellPackages.dhall-bash;

  dhall-json = haskell.lib.justStaticExecutables haskellPackages.dhall-json;

  dhall-text = haskell.lib.justStaticExecutables haskellPackages.dhall-text;

  duktape = callPackage ../development/interpreters/duktape { };

  beam = callPackage ./beam-packages.nix { };

  inherit (beam.interpreters)
    erlang erlangR18 erlangR19 erlangR20 erlangR21
    erlang_odbc erlang_javac erlang_odbc_javac erlang_nox erlang_basho_R16B02
    elixir elixir_1_7 elixir_1_6 elixir_1_5 elixir_1_4 elixir_1_3
    lfe lfe_1_2;

  inherit (beam.packages.erlang)
    rebar rebar3-open rebar3
    hexRegistrySnapshot fetchHex beamPackages
    hex2nix;

  inherit (beam.packages.erlangR18) relxExe;
  inherit (beam.packages.erlangR19) cuter;

  groovy = callPackage ../development/interpreters/groovy { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  # Needed for autogen
  guile_2_0 = callPackage ../development/interpreters/guile/2.0.nix { };

  guile_2_2 = callPackage ../development/interpreters/guile { };

  guile = guile_2_2;

  inherit (callPackages ../applications/networking/cluster/hadoop { })
    hadoop_2_7
    hadoop_2_8
    hadoop_2_9
    hadoop_3_0
    hadoop_3_1;
  hadoop = hadoop_2_7;

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  jimtcl = callPackage ../development/interpreters/jimtcl {};

  jmeter = callPackage ../applications/networking/jmeter {};

  joker = callPackage ../development/interpreters/joker {};

  davmail = callPackage ../applications/networking/davmail {};

  kanif = callPackage ../applications/networking/cluster/kanif { };

  lxappearance = callPackage ../desktops/lxde/core/lxappearance {
    gtk2 = gtk2-x11;
  };

  lxappearance-gtk3 = lxappearance.override {
    withGtk3 = true;
  };

  lxmenu-data = callPackage ../desktops/lxde/core/lxmenu-data.nix { };

  lxpanel = callPackage ../desktops/lxde/core/lxpanel {
    gtk2 = gtk2-x11;
  };

  lxtask = callPackage ../desktops/lxde/core/lxtask { };

  kona = callPackage ../development/interpreters/kona {};

  lolcode = callPackage ../development/interpreters/lolcode { };

  love_0_7 = callPackage ../development/interpreters/love/0.7.nix { lua=lua5_1; };
  love_0_8 = callPackage ../development/interpreters/love/0.8.nix { lua=lua5_1; };
  love_0_9 = callPackage ../development/interpreters/love/0.9.nix { };
  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love_11 = callPackage ../development/interpreters/love/11.1.nix { };
  love = love_0_10;

  wabt = callPackage ../development/tools/wabt { };

  ### LUA MODULES

  lua5_1 = callPackage ../development/interpreters/lua-5/5.1.nix { };
  lua5_2 = callPackage ../development/interpreters/lua-5/5.2.nix { };
  lua5_2_compat = callPackage ../development/interpreters/lua-5/5.2.nix {
    compat = true;
  };
  lua5_3 = callPackage ../development/interpreters/lua-5/5.3.nix { };
  lua5_3_compat = callPackage ../development/interpreters/lua-5/5.3.nix {
    compat = true;
  };
  lua5 = lua5_2_compat;
  lua = lua5;

  lua51Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_1; });
  lua52Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_2; });
  lua53Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_3; });
  luajitPackages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = luajit; });

  luaPackages = lua52Packages;

  inherit (callPackages ../development/interpreters/luajit {})
    luajit luajit_2_0 luajit_2_1;

  luarocks = luaPackages.luarocks;

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  lush2 = callPackage ../development/interpreters/lush {};

  maude = callPackage ../development/interpreters/maude {
    bison = bison2;
    flex = flex_2_5_35;
  };

  mesos = callPackage ../applications/networking/cluster/mesos {
    sasl = cyrus_sasl;
    inherit (pythonPackages) python boto setuptools wrapPython;
    pythonProtobuf = pythonPackages.protobuf;
    perf = linuxPackages.perf;
  };

  mesos-dns = callPackage ../servers/mesos-dns { };

  mujs = callPackage ../development/interpreters/mujs { };

  nix-exec = callPackage ../development/interpreters/nix-exec {
    git = gitMinimal;
  };

  inherit (
    let
      defaultOctaveOptions = {
        qt = null;
        ghostscript = null;
        graphicsmagick = null;
        llvm = null;
        hdf5 = null;
        glpk = null;
        suitesparse = null;
        jdk = null;
        openblas = if stdenv.isDarwin then openblasCompat else openblas;
      };

      hgOctaveOptions =
        (removeAttrs defaultOctaveOptions ["ghostscript"]) // {
          overridePlatforms = stdenv.lib.platforms.none;
        };
    in {
      octave = callPackage ../development/interpreters/octave defaultOctaveOptions;
      octaveHg = lowPrio (callPackage ../development/interpreters/octave/hg.nix hgOctaveOptions);
  }) octave octaveHg;

  octaveFull = (lowPrio (octave.override {
    qt = qt4;
    overridePlatforms = ["x86_64-linux" "x86_64-darwin"];
    openblas = if stdenv.isDarwin then openblasCompat else openblas;
  }));

  ocropus = callPackage ../applications/misc/ocropus { };

  inherit (callPackages ../development/interpreters/perl {}) perl522 perl524 perl526 perl528;

  pachyderm = callPackage ../applications/networking/cluster/pachyderm { };

  php = php72;
  phpPackages = php72Packages;

  php71Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php71;
  });

  php72Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php72;
  });


  inherit (callPackages ../development/interpreters/php { })
    php71
    php72;

  php-embed = php72-embed;

  php71-embed = php71.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  php72-embed = php72.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  picoc = callPackage ../development/interpreters/picoc {};

  picolisp = callPackage ../development/interpreters/picolisp {};

  polyml = callPackage ../development/compilers/polyml { };
  polyml56 = callPackage ../development/compilers/polyml/5.6.nix { };

  pure = callPackage ../development/interpreters/pure {
    llvm = llvm_35;
  };
  purePackages = recurseIntoAttrs (callPackage ./pure-packages.nix {});

  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  # When switching these sets, please update docs at ../../doc/languages-frameworks/python.md
  python = python2;
  python2 = python27;
  python3 = python36;
  pypy = pypy27;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  pythonFull = python.override{x11Support=true;};
  python2Full = python2.override{x11Support=true;};
  python27Full = python27.override{x11Support=true;};
  python3Full = python3.override{x11Support=true;};
  python34Full = python34.override{x11Support=true;};
  python35Full = python35.override{x11Support=true;};
  python36Full = python36.override{x11Support=true;};
  python37Full = python37.override{x11Support=true;};

  # pythonPackages further below, but assigned here because they need to be in sync
  pythonPackages = python.pkgs;
  python2Packages = python2.pkgs;
  python3Packages = python3.pkgs;

  python27 = callPackage ../development/interpreters/python/cpython/2.7 {
    self = python27;
    inherit (darwin) CF configd;
  };
  python34 = callPackage ../development/interpreters/python/cpython/3.4 {
    inherit (darwin) CF configd;
    self = python34;
  };
  python35 = callPackage ../development/interpreters/python/cpython/3.5 {
    inherit (darwin) CF configd;
    self = python35;
  };
  python36 = callPackage ../development/interpreters/python/cpython/3.6 {
    inherit (darwin) CF configd;
    self = python36;
  };
  python37 = callPackage ../development/interpreters/python/cpython/3.7 {
    inherit (darwin) CF configd;
    self = python37;
  };

  pypy27 = callPackage ../development/interpreters/python/pypy/2.7 {
    self = pypy27;
    python = python27.override{x11Support=true;};
    db = db.override { dbmSupport = true; };
  };

  # Python package sets.
  python27Packages = lib.hiPrioSet (recurseIntoAttrs python27.pkgs);
  python34Packages = python34.pkgs;
  python35Packages = python35.pkgs;
  python36Packages = recurseIntoAttrs python36.pkgs;
  python37Packages = python37.pkgs;
  pypyPackages = pypy.pkgs;

  # Should eventually be moved inside Python interpreters.
  python-setup-hook = callPackage ../development/interpreters/python/setup-hook.nix { };

  python2nix = callPackage ../tools/package-management/python2nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs {});

  pypi2nix = callPackage ../development/tools/pypi2nix {
    pythonPackages = python3Packages;
  };

  setupcfg2nix = python3Packages.callPackage ../development/tools/setupcfg2nix {};

  # These pyside tools do not provide any Python modules and are meant to be here.
  # See ../development/python-modules/pyside/default.nix for details.
  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };
  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  svg2tikz = python27Packages.svg2tikz;

  pew = callPackage ../development/tools/pew {};
  pipenv = callPackage ../development/tools/pipenv {};

  pipewire = callPackage ../development/libraries/pipewire {};

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  racket = callPackage ../development/interpreters/racket {
    # racket 6.11 doesn't build with gcc6 + recent glibc:
    # https://github.com/racket/racket/pull/1886
    # https://github.com/NixOS/nixpkgs/pull/31017#issuecomment-343574769
    stdenv = if stdenv.isDarwin then stdenv else gcc7Stdenv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };
  racket-minimal = callPackage ../development/interpreters/racket/minimal.nix { };

  rakudo = callPackage ../development/interpreters/rakudo {
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  rascal = callPackage ../development/interpreters/rascal { };

  red = callPackage ../development/interpreters/red { };

  regextester = callPackage ../applications/misc/regextester { };

  regina = callPackage ../development/interpreters/regina { };

  inherit (ocamlPackages) reason;

  renpy = callPackage ../development/interpreters/renpy {
    ffmpeg = ffmpeg_2;
  };

  pixie = callPackage ../development/interpreters/pixie { };
  dust = callPackage ../development/interpreters/pixie/dust.nix { };

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config { };
  bundix = callPackage ../development/ruby-modules/bundix { };
  bundler = callPackage ../development/ruby-modules/bundler { };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
  bundlerApp = callPackage ../development/ruby-modules/bundler-app { };

  solargraph = callPackage ../development/ruby-modules/solargraph { };

  inherit (callPackage ../development/interpreters/ruby {
    inherit (darwin) libiconv libobjc libunwind;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  })
    ruby_2_3
    ruby_2_4
    ruby_2_5;

  ruby = ruby_2_5;

  mruby = callPackage ../development/compilers/mruby { };

  scsh = callPackage ../development/interpreters/scsh { };

  scheme48 = callPackage ../development/interpreters/scheme48 { };

  self = pkgsi686Linux.callPackage ../development/interpreters/self { };

  spark = spark_22;
  spark_22 = callPackage ../applications/networking/cluster/spark { version = "2.2.1"; };

  spidermonkey_1_8_5 = callPackage ../development/interpreters/spidermonkey/1.8.5.nix { };
  spidermonkey_17 = callPackage ../development/interpreters/spidermonkey/17.nix {
    inherit (darwin) libobjc;
    stdenv = gccStdenv;
  };
  spidermonkey_31 = callPackage ../development/interpreters/spidermonkey/31.nix { };
  spidermonkey_38 = callPackage ../development/interpreters/spidermonkey/38.nix ({
    inherit (darwin) libobjc;
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  }));
  spidermonkey_52 = callPackage ../development/interpreters/spidermonkey/52.nix { };
  spidermonkey = spidermonkey_31;

  ssm-agent = callPackage ../applications/networking/cluster/ssm-agent { };

  supercollider = libsForQt5.callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  taktuk = callPackage ../applications/networking/cluster/taktuk { };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  wasm = callPackage ../development/interpreters/wasm { };

  wasm-gc = callPackage ../development/interpreters/wasm-gc { };


  ### DEVELOPMENT / MISC

  amdadlsdk = callPackage ../development/misc/amdadl-sdk { };

  amdappsdk26 = amdappsdk.override {
    version = "2.6";
  };

  amdappsdk27 = amdappsdk.override {
    version = "2.7";
  };

  amdappsdk28 = amdappsdk.override {
    version = "2.8";
  };

  amdappsdk = callPackage ../development/misc/amdapp-sdk { };

  amdappsdkFull = amdappsdk.override {
    samples = true;
  };

  amtk = callPackage ../development/libraries/amtk { };

  avrgcclibc = throw "avrgcclibs are now separate packages, install avrbinutils, avrgcc and avrlibc";

  avrbinutils = callPackage ../development/misc/avr/binutils {};

  avrgcc      = callPackage ../development/misc/avr/gcc {};

  avrlibc     = callPackage ../development/misc/avr/libc {};

  avr8burnomat = callPackage ../development/misc/avr8-burn-omat { };

  betaflight = callPackage ../development/misc/stm32/betaflight { };

  sourceFromHead = callPackage ../build-support/source-from-head-fun.nix {};

  jruby = callPackage ../development/interpreters/jruby { };

  jython = callPackage ../development/interpreters/jython {};

  guile-cairo = callPackage ../development/guile-modules/guile-cairo {
    guile = guile_2_0;
  };

  guile-fibers = callPackage ../development/guile-modules/guile-fibers { };

  guile-gnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome2.GConf;
    guile = guile_2_0;
    inherit (gnome2) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile-lib = callPackage ../development/guile-modules/guile-lib {
    guile = guile_2_0;
  };

  guile-ncurses = callPackage ../development/guile-modules/guile-ncurses { };

  guile-opengl = callPackage ../development/guile-modules/guile-opengl { };

  guile-reader = callPackage ../development/guile-modules/guile-reader { };

  guile-sdl = callPackage ../development/guile-modules/guile-sdl { };

  guile-sdl2 = callPackage ../development/guile-modules/guile-sdl2 { };

  guile-xcb = callPackage ../development/guile-modules/guile-xcb {
    guile = guile_2_0;
  };

  inav = callPackage ../development/misc/stm32/inav { };

  pharo-vms = callPackage ../development/pharo/vm { };
  pharo = pharo-vms.multi-vm-wrapper;
  pharo-cog32 = pharo-vms.cog32;
  pharo-spur32 = pharo-vms.spur32;
  pharo-spur64 = assert stdenv.is64bit; pharo-vms.spur64;
  pharo-launcher = callPackage ../development/pharo/launcher { };

  srecord = callPackage ../development/tools/misc/srecord { };

  srelay = callPackage ../tools/networking/srelay { };

  xidel = callPackage ../tools/text/xidel { };


  ### DEVELOPMENT / TOOLS

  activator = throw ''
    Typesafe Activator was removed in 2017-05-08 as the actual package reaches end of life.

    See https://github.com/NixOS/nixpkgs/pull/25616
    and http://www.lightbend.com/community/core-tools/activator-and-sbt
    for more information.
  '';

  alloy = callPackage ../development/tools/alloy { };

  adtool = callPackage ../tools/admin/adtool { };

  augeas = callPackage ../tools/system/augeas { };

  inherit (callPackages ../tools/admin/ansible {})
    ansible_2_4
    ansible_2_5
    ansible_2_6
    ansible2
    ansible;

  ansible-lint = callPackage ../development/tools/ansible-lint {};

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3_4 = callPackage ../development/tools/parsing/antlr/3.4.nix { };
  antlr3_5 = callPackage ../development/tools/parsing/antlr/3.5.nix { };
  antlr3 = antlr3_5;

  antlr4_7 = callPackage ../development/tools/parsing/antlr/4.7.nix { };
  antlr4 = antlr4_7;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };
  apacheAnt_1_9 = callPackage ../development/tools/build-managers/apache-ant/1.9.nix { };
  ant = apacheAnt;

  apacheKafka = apacheKafka_2_0;
  apacheKafka_0_9 = callPackage ../servers/apache-kafka { majorVersion = "0.9"; };
  apacheKafka_0_10 = callPackage ../servers/apache-kafka { majorVersion = "0.10"; };
  apacheKafka_0_11 = callPackage ../servers/apache-kafka { majorVersion = "0.11"; };
  apacheKafka_1_0 = callPackage ../servers/apache-kafka { majorVersion = "1.0"; };
  apacheKafka_1_1 = callPackage ../servers/apache-kafka { majorVersion = "1.1"; };
  apacheKafka_2_0 = callPackage ../servers/apache-kafka { majorVersion = "2.0"; };

  kt = callPackage ../tools/misc/kt {};

  arpa2cm = callPackage ../development/tools/build-managers/arpa2cm { };

  asn2quickder = python2Packages.callPackage ../development/tools/asn2quickder {};

  astyle = callPackage ../development/tools/misc/astyle { };

  awf = callPackage ../development/tools/misc/awf { };

  electron = callPackage ../development/tools/electron { };

  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf-archive = callPackage ../development/tools/misc/autoconf-archive { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };
  autoconf264 = callPackage ../development/tools/misc/autoconf/2.64.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = automake116x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake116x = callPackage ../development/tools/misc/automake/automake-1.16.x.nix { };

  automoc4 = callPackage ../development/tools/misc/automoc4 { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  avarice = callPackage ../development/tools/misc/avarice {
    gcc = gcc49;
  };

  babeltrace = callPackage ../development/tools/misc/babeltrace { };

  bam = callPackage ../development/tools/build-managers/bam {};

  bazel_0_4 = callPackage ../development/tools/build-managers/bazel/0.4.nix { };
  bazel = callPackage ../development/tools/build-managers/bazel {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
  };
  bazel_jdk10 = callPackage ../development/tools/build-managers/bazel {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    runJdk = jdk10;
  };

  bazel-buildtools = callPackage ../development/tools/build-managers/bazel/buildtools { };
  buildifier = bazel-buildtools;
  buildozer = bazel-buildtools;
  unused_deps = bazel-buildtools;

  bazel-deps = callPackage ../development/tools/build-managers/bazel/bazel-deps {
    buildBazelPackage = buildBazelPackage.override { enableNixHacks = false; };
  };

  buildBazelPackage = callPackage ../build-support/build-bazel-package { };

  bear = callPackage ../development/tools/build-managers/bear { };

  bin_replace_string = callPackage ../development/tools/misc/bin_replace_string { };

  binutils-unwrapped = callPackage ../development/tools/misc/binutils {
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };
  binutils = wrapBintoolsWith {
    bintools = binutils-unwrapped;
  };
  binutils_nogold = lowPrio (wrapBintoolsWith {
    bintools = binutils-unwrapped.override {
      gold = false;
    };
  });

  bison2 = callPackage ../development/tools/parsing/bison/2.x.nix { };
  bison3 = callPackage ../development/tools/parsing/bison/3.x.nix { };
  bison = bison3;
  yacc = bison; # TODO: move to aliases.nix

  blackmagic = callPackage ../development/tools/misc/blackmagic {
    stdenv = overrideCC stdenv gcc6;
  };

  bloaty = callPackage ../development/tools/bloaty { };

  bloop = callPackage ../development/tools/build-managers/bloop { };

  bossa = callPackage ../development/tools/misc/bossa {
    wxGTK = wxGTK30;
  };

  buck = callPackage ../development/tools/build-managers/buck { };

  buildbot = callPackage ../development/tools/build-managers/buildbot {
    pythonPackages = python2Packages;
  };
  buildbot-worker = callPackage ../development/tools/build-managers/buildbot/worker.nix {
    pythonPackages = python2Packages;
  };
  buildbot-pkg = callPackage ../development/tools/build-managers/buildbot/pkg.nix {
    inherit (python2Packages) buildPythonPackage fetchPypi setuptools;
  };
  buildbot-plugins = callPackages ../development/tools/build-managers/buildbot/plugins.nix {
    pythonPackages = python2Packages;
  };
  buildbot-ui = buildbot.withPlugins (with self.buildbot-plugins; [ www ]);
  buildbot-full = buildbot.withPlugins (with self.buildbot-plugins; [ www console-view waterfall-view grid-view wsgi-dashboards ]);

  buildkite-agent = buildkite-agent2;
  buildkite-agent2 = callPackage ../development/tools/continuous-integration/buildkite-agent/2.x.nix { };
  buildkite-agent3 = callPackage ../development/tools/continuous-integration/buildkite-agent/3.x.nix { };

  byacc = callPackage ../development/tools/parsing/byacc { };

  casperjs = callPackage ../development/tools/casperjs {
    inherit (texFunctions) fontsConf;
  };

  cbrowser = callPackage ../development/tools/misc/cbrowser { };

  ccache = callPackage ../development/tools/misc/ccache { };

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
  ccacheWrapper = makeOverridable ({ extraConfig ? "" }:
     wrapCC (ccache.links extraConfig)) {};
  ccacheStdenv = lowPrio (overrideCC stdenv ccacheWrapper);

  cccc = callPackage ../development/tools/analysis/cccc { };

  cgdb = callPackage ../development/tools/misc/cgdb { };

  cheat = callPackage ../applications/misc/cheat { };

  chefdk = callPackage ../development/tools/chefdk { };

  matter-compiler = callPackage ../development/compilers/matter-compiler {};

  cfr = callPackage ../development/tools/java/cfr { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome2.GConf; };

  chrpath = callPackage ../development/tools/misc/chrpath { };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cide = callPackage ../development/tools/continuous-integration/cide { };

  cl-launch = callPackage ../development/tools/misc/cl-launch {};

  cloudfoundry-cli = callPackage ../development/tools/cloudfoundry-cli { };

  coan = callPackage ../development/tools/analysis/coan { };

  compile-daemon = callPackage ../development/tools/compile-daemon { };

  complexity = callPackage ../development/tools/misc/complexity { };

  conan = callPackage ../development/tools/build-managers/conan { };

  cookiecutter = pythonPackages.cookiecutter;

  corundum = callPackage ../development/tools/corundum { };

  confluent = callPackage ../servers/confluent {};

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = callPackage ../development/tools/misc/ctags/wrapped.nix {};

  ctodo = callPackage ../applications/misc/ctodo { };

  ctmg = callPackage ../tools/security/ctmg { };

  cmake_2_8 = callPackage ../development/tools/build-managers/cmake/2.8.nix { };

  cmake = libsForQt5.callPackage ../development/tools/build-managers/cmake { };

  cmakeCurses = cmake.override { useNcurses = true; };

  cmakeWithGui = cmakeCurses.override { withQt5 = true; };
  cmakeWithQt4Gui = cmakeCurses.override { useQt4 = true; };

  # Does not actually depend on Qt 5
  inherit (kdeFrameworks) extra-cmake-modules kapidox kdoctools;

  coccinelle = callPackage ../development/tools/misc/coccinelle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cpptest = callPackage ../development/libraries/cpptest { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cov-build = callPackage ../development/tools/analysis/cov-build {};

  cppcheck = callPackage ../development/tools/analysis/cppcheck { };

  cquery = callPackage ../development/tools/misc/cquery {
    llvmPackages = llvmPackages_6;
  };

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (perlPackages) perl
      ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey;
    inherit (llvmPackages_6) llvm clang-unwrapped;
  };

  cscope = callPackage ../development/tools/misc/cscope { };

  csmith = callPackage ../development/tools/misc/csmith {
    inherit (perlPackages) perl SysCPU;
  };

  csslint = callPackage ../development/web/csslint { };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  librarian-puppet-go = callPackage ../development/tools/librarian-puppet-go { };

  libgcc = callPackage ../development/libraries/gcc/libgcc { };

  libstdcxx5 = callPackage ../development/libraries/gcc/libstdc++/5.nix { };

  libsigrok = callPackage ../development/tools/libsigrok { };
  # old version:
  libsigrok-0-3-0 = libsigrok.override {
    version = "0.3.0";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  libsigrokdecode = callPackage ../development/tools/libsigrokdecode { };

  dcadec = callPackage ../development/tools/dcadec { };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

  devtodo = callPackage ../development/tools/devtodo { };

  dfeet = callPackage ../development/tools/misc/d-feet { };

  dfu-programmer = callPackage ../development/tools/misc/dfu-programmer { };

  dfu-util = callPackage ../development/tools/misc/dfu-util { };

  ddd = callPackage ../development/tools/misc/ddd { };

  lattice-diamond = callPackage ../development/tools/lattice-diamond { };

  distcc = callPackage ../development/tools/misc/distcc { };

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
  distccWrapper = makeOverridable ({ extraConfig ? "" }:
     wrapCC (distcc.links extraConfig)) {};
  distccStdenv = lowPrio (overrideCC stdenv distccWrapper);

  distccMasquerade = if stdenv.isDarwin
    then null
    else callPackage ../development/tools/misc/distcc/masq.nix {
      gccRaw = gcc.cc;
      binutils = binutils;
    };

  doclifter = callPackage ../development/tools/misc/doclifter { };

  docutils = pythonPackages.docutils;

  doctl = callPackage ../development/tools/doctl { };

  doit = callPackage ../development/tools/build-managers/doit { };

  dot2tex = pythonPackages.dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt4 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt4; });

  drake = callPackage ../development/tools/build-managers/drake { };

  drip = callPackage ../development/tools/drip { };

  drush = callPackage ../development/tools/misc/drush { };

  editorconfig-core-c = callPackage ../development/tools/misc/editorconfig-core-c { };

  eggdbus = callPackage ../development/tools/misc/eggdbus { };

  egypt = callPackage ../development/tools/analysis/egypt { };

  elfutils = callPackage ../development/tools/misc/elfutils { };

  elfkickers = callPackage ../development/tools/misc/elfkickers { };

  emma = callPackage ../development/tools/analysis/emma { };

  epm = callPackage ../development/tools/misc/epm { };

  eresi = callPackage ../development/tools/analysis/eresi { };

  eweb = callPackage ../development/tools/literate-programming/eweb { };

  eztrace = callPackage ../development/tools/profiling/EZTrace { };

  ezquake = callPackage ../games/ezquake { };

  findbugs = callPackage ../development/tools/analysis/findbugs { };

  flootty = callPackage ../development/tools/flootty { };

  flow = callPackage ../development/tools/analysis/flow {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (darwin) cf-private;
  };

  foreman = callPackage ../tools/system/foreman { };

  framac = callPackage ../development/tools/analysis/frama-c { };

  frame = callPackage ../development/libraries/frame { };

  fsatrace = callPackage ../development/tools/misc/fsatrace { };

  fswatch = callPackage ../development/tools/misc/fswatch { };

  funnelweb = callPackage ../development/tools/literate-programming/funnelweb { };

  gede = libsForQt59.callPackage ../development/tools/misc/gede { };

  gdbgui = callPackage ../development/tools/misc/gdbgui { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex_2_6_1 = callPackage ../development/tools/parsing/flex/2.6.1.nix { };
  flex = callPackage ../development/tools/parsing/flex { };

  flexcpp = callPackage ../development/tools/parsing/flexc++ { };

  geis = callPackage ../development/libraries/geis {
    inherit (xorg) libX11 libXext libXi libXtst;
  };

  github-release = callPackage ../development/tools/github/github-release { };

  global = callPackage ../development/tools/misc/global { };

  gnome-doc-utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnome-desktop-testing = callPackage ../development/tools/gnome-desktop-testing {};

  gnome-usage = callPackage ../applications/misc/gnome-usage {};

  gnome-latex = callPackage ../applications/editors/gnome-latex/default.nix { };

  gnum4 = callPackage ../development/tools/misc/gnum4 { };
  m4 = gnum4;

  gnumake382 = callPackage ../development/tools/build-managers/gnumake/3.82 { };
  gnumake3 = gnumake382;
  gnumake42 = callPackage ../development/tools/build-managers/gnumake/4.2 { };
  gnumake = gnumake42;

  gnustep = recurseIntoAttrs (callPackage ../desktops/gnustep {});

  gob2 = callPackage ../development/tools/misc/gob2 { };

  gocd-agent = callPackage ../development/tools/continuous-integration/gocd-agent { };

  gocd-server = callPackage ../development/tools/continuous-integration/gocd-server { };

  gotty = callPackage ../servers/gotty { };

  gputils = callPackage ../development/tools/misc/gputils { };

  gradleGen = callPackage ../development/tools/build-managers/gradle { };
  gradle = self.gradleGen.gradle_latest;
  gradle_2_14 = self.gradleGen.gradle_2_14;
  gradle_2_5 = self.gradleGen.gradle_2_5;
  gradle_3_5 = self.gradleGen.gradle_3_5;

  gperf = callPackage ../development/tools/misc/gperf { };
  # 3.1 changed some parameters from int to size_t, leading to mismatches.
  gperf_3_0 = callPackage ../development/tools/misc/gperf/3.0.x.nix { };

  grail = callPackage ../development/libraries/grail { };

  gtk-doc = callPackage ../development/tools/documentation/gtk-doc { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog { };

  guile-lint = callPackage ../development/tools/guile/guile-lint {
    guile = guile_1_8;
  };

  gwrap = callPackage ../development/tools/guile/g-wrap {
    guile = guile_2_0;
  };

  hcloud = callPackage ../development/tools/hcloud { };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  heroku = callPackage ../development/tools/heroku {
    nodejs = nodejs-10_x;
  };

  htmlunit-driver = callPackage ../development/tools/selenium/htmlunit-driver { };

  hyenae = callPackage ../tools/networking/hyenae { };

  iaca_2_1 = callPackage ../development/tools/iaca/2.1.nix { };
  iaca_3_0 = callPackage ../development/tools/iaca/3.0.nix { };
  iaca = iaca_3_0;

  icestorm = callPackage ../development/tools/icestorm { };

  icmake = callPackage ../development/tools/build-managers/icmake { };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_4;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  inotify-tools = callPackage ../development/tools/misc/inotify-tools { };

  intel-gpu-tools = callPackage ../development/tools/misc/intel-gpu-tools { };

  insomnia = callPackage ../development/web/insomnia { };

  iozone = callPackage ../development/tools/misc/iozone { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  itstool = callPackage ../development/tools/misc/itstool { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jamomacore = callPackage ../development/libraries/audio/jamomacore { };

  jbake = callPackage ../development/tools/jbake { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  jenkins = callPackage ../development/tools/continuous-integration/jenkins { };

  jenkins-job-builder = pythonPackages.jenkins-job-builder;

  kafkacat = callPackage ../development/tools/kafkacat { };

  kati = callPackage ../development/tools/build-managers/kati { };

  kconfig-frontends = callPackage ../development/tools/misc/kconfig-frontends {
    gperf = gperf_3_0;
  };

  kcgi = callPackage ../development/web/kcgi { };

  kcov = callPackage ../development/tools/analysis/kcov { };

  kube-aws = callPackage ../development/tools/kube-aws { };

  kubectx = callPackage ../development/tools/kubectx { };

  kustomize = callPackage ../development/tools/kustomize { };

  kythe = callPackage ../development/tools/kythe { };

  Literate = callPackage ../development/tools/literate-programming/Literate {};

  lcov = callPackage ../development/tools/analysis/lcov { };

  leiningen = callPackage ../development/tools/build-managers/leiningen { };

  lemon = callPackage ../development/tools/parsing/lemon { };

  lenmus = callPackage ../applications/misc/lenmus { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  linuxkit = callPackage ../development/tools/misc/linuxkit { };

  lit = callPackage ../development/tools/misc/lit { };

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  lttng-tools = callPackage ../development/tools/misc/lttng-tools { };

  lttng-ust = callPackage ../development/tools/misc/lttng-ust { };

  lttv = callPackage ../development/tools/misc/lttv { };

  massif-visualizer = libsForQt5.callPackage ../development/tools/analysis/massif-visualizer { };

  maven = maven3;
  maven3 = callPackage ../development/tools/build-managers/apache-maven { };

  go-md2man = callPackage ../development/tools/misc/md2man {};

  minify = callPackage ../development/web/minify { };

  minizinc = callPackage ../development/tools/minizinc { };

  mk = callPackage ../development/tools/build-managers/mk { };

  mkdocs = callPackage ../development/tools/documentation/mkdocs { };

  moby = callPackage ../development/tools/misc/moby { };

  msgpack-tools = callPackage ../development/tools/msgpack-tools { };

  msgpuck = callPackage ../development/libraries/msgpuck { };

  msitools = callPackage ../development/tools/misc/msitools { };

  multi-ghc-travis = haskell.lib.justStaticExecutables haskellPackages.multi-ghc-travis;

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        dejavu_fonts.minimal
      ];
    };
  };

  nailgun = callPackage ../development/tools/nailgun { };

  ninja = callPackage ../development/tools/build-managers/ninja { };

  gn = callPackage ../development/tools/build-managers/gn { };

  nixbang = callPackage ../development/tools/misc/nixbang {
    pythonPackages = python3Packages;
  };

  nexus = callPackage ../development/tools/repository-managers/nexus { };

  nwjs = callPackage ../development/tools/nwjs {
    gconf = pkgs.gnome2.GConf;
  };

  # only kept for nixui, see https://github.com/matejc/nixui/issues/27
  nwjs_0_12 = callPackage ../development/tools/node-webkit/nw12.nix {
    gconf = pkgs.gnome2.GConf;
  };

  noweb = callPackage ../development/tools/literate-programming/noweb { };
  nuweb = callPackage ../development/tools/literate-programming/nuweb { tex = texlive.combined.scheme-small; };

  obelisk = callPackage ../development/tools/ocaml/obelisk { };

  obuild = callPackage ../development/tools/ocaml/obuild { };

  omake = callPackage ../development/tools/ocaml/omake { };

  inherit (ocamlPackages) omake_rc1;

  omniorb = callPackage ../development/tools/omniorb { };

  opengrok = callPackage ../development/tools/misc/opengrok { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile { };

  pahole = callPackage ../development/tools/misc/pahole {};

  panopticon = callPackage ../development/tools/analysis/panopticon {};

  pants = callPackage ../development/tools/build-managers/pants {};

  parse-cli-bin = callPackage ../development/tools/parse-cli-bin { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  peg = callPackage ../development/tools/parsing/peg { };

  pgcli = callPackage ../development/tools/database/pgcli {};

  phantomjs = callPackage ../development/tools/phantomjs { };

  phantomjs2 = libsForQt5.callPackage ../development/tools/phantomjs2 { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  pkgconfig = callPackage ../development/tools/misc/pkgconfig {
    fetchurl = fetchurlBoot;
  };
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  postiats-utilities = callPackage ../development/tools/postiats-utilities {};

  postman = callPackage ../development/web/postman {};

  pprof = callPackage ../development/tools/profiling/pprof { };

  pyprof2calltree = pythonPackages.callPackage ../development/tools/profiling/pyprof2calltree { };

  prelink = callPackage ../development/tools/misc/prelink { };

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake5 = callPackage ../development/tools/misc/premake/5.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  premake = premake4;

  procodile = callPackage ../tools/system/procodile { };

  pup = callPackage ../development/tools/pup { };

  puppet-lint = callPackage ../development/tools/puppet/puppet-lint { };

  pyrseas = callPackage ../development/tools/database/pyrseas { };

  qtcreator = libsForQt5.callPackage ../development/tools/qtcreator { };

  r10k = callPackage ../tools/system/r10k { };

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };

  inherit (callPackages ../development/tools/analysis/radare2 {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  }) radare2 r2-for-cutter;

  radare2-cutter = libsForQt5.callPackage ../development/tools/analysis/radare2/cutter.nix { };

  ragel = ragelStable;

  randoop = callPackage ../development/tools/analysis/randoop { };

  inherit (callPackages ../development/tools/parsing/ragel {
      tex = texlive.combined.scheme-small;
    }) ragelStable ragelDev;

  hammer = callPackage ../development/tools/parsing/hammer { };

  redis-dump = callPackage ../development/tools/redis-dump { };

  redo = callPackage ../development/tools/build-managers/redo { };

  redo-sh = callPackage ../development/tools/build-managers/redo-sh { };

  reno = callPackage ../development/tools/reno { };

  re2c = callPackage ../development/tools/parsing/re2c { };

  remake = callPackage ../development/tools/build-managers/remake { };

  retdec = callPackage ../development/tools/analysis/retdec { };
  retdec-full = retdec.override {
    withPEPatterns = true;
  };

  rhc = callPackage ../development/tools/rhc { };

  rman = callPackage ../development/tools/misc/rman { };

  rolespec = callPackage ../development/tools/misc/rolespec { };

  rr = callPackage ../development/tools/analysis/rr { };

  saleae-logic = callPackage ../development/tools/misc/saleae-logic { };

  sauce-connect = callPackage ../development/tools/sauce-connect { };

  selenium-server-standalone = callPackage ../development/tools/selenium/server { };

  selendroid = callPackage ../development/tools/selenium/selendroid { };

  sconsPackages = callPackage ../development/tools/build-managers/scons { };
  scons = sconsPackages.scons_3_0_1;
  scons_2_5_1 = sconsPackages.scons_2_5_1;

  sbt = callPackage ../development/tools/build-managers/sbt { };
  sbt-with-scala-native = callPackage ../development/tools/build-managers/sbt/scala-native.nix { };
  simpleBuildTool = sbt;

  sbt-extras = callPackage ../development/tools/build-managers/sbt-extras { };

  shallot = callPackage ../tools/misc/shallot { };

  shards = callPackage ../development/tools/build-managers/shards { };

  shellcheck = haskell.lib.justStaticExecutables haskellPackages.ShellCheck;

  schemaspy = callPackage ../development/tools/database/schemaspy { };

  shncpd = callPackage ../tools/networking/shncpd { };

  sigrok-cli = callPackage ../development/tools/sigrok-cli { };

  simpleTpmPk11 = callPackage ../tools/security/simple-tpm-pk11 { };

  slimerjs = callPackage ../development/tools/slimerjs {};

  sloccount = callPackage ../development/tools/misc/sloccount { };

  sloc = nodePackages.sloc;

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  smc = callPackage ../tools/misc/smc { };

  snakemake = callPackage ../applications/science/misc/snakemake { python = python3Packages; };

  snowman = qt5.callPackage ../development/tools/analysis/snowman { };

  sparse = callPackage ../development/tools/analysis/sparse { };

  speedtest-cli = callPackage ../tools/networking/speedtest-cli { };

  spin = callPackage ../development/tools/analysis/spin { };

  spirv-tools = callPackage ../development/tools/spirv-tools { };

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  spoofer = callPackage ../tools/networking/spoofer { };

  spoofer-gui = callPackage ../tools/networking/spoofer { withGUI = true; };

  sqlitebrowser = libsForQt5.callPackage ../development/tools/database/sqlitebrowser { };

  sselp = callPackage ../tools/X11/sselp{ };

  stm32flash = callPackage ../development/tools/misc/stm32flash { };

  strace = callPackage ../development/tools/misc/strace { };

  swarm = callPackage ../development/tools/analysis/swarm { };

  swig1 = callPackage ../development/tools/misc/swig { };
  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };
  swig3 = callPackage ../development/tools/misc/swig/3.x.nix { };
  swig = swig3;
  swigWithJava = swig;

  swfmill = callPackage ../tools/video/swfmill { };

  swftools = callPackage ../tools/video/swftools {
    stdenv = gccStdenv;
  };

  tcptrack = callPackage ../development/tools/misc/tcptrack { };

  teensyduino = arduino-core.override { withGui = true; withTeensyduino = true; };

  teensy-loader-cli = callPackage ../development/tools/misc/teensy-loader-cli { };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.5.nix { };
  texinfo = texinfo6;
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );

  texi2html = callPackage ../development/tools/misc/texi2html { };

  texi2mdoc = callPackage ../tools/misc/texi2mdoc { };

  todolist = callPackage ../applications/misc/todolist { };

  travis = callPackage ../development/tools/misc/travis { };

  trellis = callPackage ../development/tools/trellis { };

  tweak = callPackage ../applications/editors/tweak { };

  uhd = callPackage ../development/tools/misc/uhd { };

  uisp = callPackage ../development/tools/misc/uisp { };

  uncrustify = callPackage ../development/tools/misc/uncrustify { };

  universal-ctags = callPackage ../development/tools/misc/universal-ctags { };

  vagrant = callPackage ../development/tools/vagrant {};

  bashdb = callPackage ../development/tools/misc/bashdb { };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
  };

  jhiccup = callPackage ../development/tools/java/jhiccup { };

  valgrind = callPackage ../development/tools/analysis/valgrind {
    inherit (darwin) xnu bootstrap_cmds cctools;
    llvm = llvm_39;
  };
  valgrind-light = self.valgrind.override { gdb = null; };

  valkyrie = callPackage ../development/tools/analysis/valkyrie { };

  qcachegrind = libsForQt5.callPackage ../development/tools/analysis/qcachegrind {};

  verasco = ocaml-ng.ocamlPackages_4_02.verasco.override {
    coq = coq_8_4;
  };

  visualvm = callPackage ../development/tools/java/visualvm { };

  vultr = callPackage ../development/tools/vultr { };

  vulnix = callPackage ../tools/security/vulnix {
    pythonPackages = python3Packages;
  };

  watson-ruby = callPackage ../development/tools/misc/watson-ruby {};

  xc3sprog = callPackage ../development/tools/misc/xc3sprog { };

  xcodebuild = callPackage ../development/tools/xcbuild/wrapper.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreGraphics ImageIO;
  };
  xcbuild = xcodebuild;
  xcbuildHook = makeSetupHook {
    deps = [ xcbuild ];
  } ../development/tools/xcbuild/setup-hook.sh  ;

  xmlindent = callPackage ../development/web/xmlindent {};

  xpwn = callPackage ../development/mobile/xpwn {};

  xxdiff = callPackage ../development/tools/misc/xxdiff {
    bison = bison2;
  };
  xxdiff-tip = libsForQt5.callPackage ../development/tools/misc/xxdiff/tip.nix { };

  yaml2json = callPackage ../development/tools/yaml2json { };

  ycmd = callPackage ../development/tools/misc/ycmd {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    python = python2;
  };

  yodl = callPackage ../development/tools/misc/yodl { };

  yq = callPackage ../development/tools/yq {
    inherit (python3Packages) buildPythonApplication fetchPypi pyyaml xmltodict;
  };

  winpdb = callPackage ../development/tools/winpdb { };

  grabserial = callPackage ../development/tools/grabserial { };

  mypy = with python3Packages; toPythonApplication mypy;

  ### DEVELOPMENT / LIBRARIES

  a52dec = callPackage ../development/libraries/a52dec { };

  aacskeys = callPackage ../development/libraries/aacskeys { };

  aalib = callPackage ../development/libraries/aalib { };

  accountsservice = callPackage ../development/libraries/accountsservice { };

  acl = callPackage ../development/libraries/acl { };

  activemq = callPackage ../development/libraries/apache-activemq { };

  adns = callPackage ../development/libraries/adns { };

  afflib = callPackage ../development/libraries/afflib { };

  aften = callPackage ../development/libraries/aften { };

  alure = callPackage ../development/libraries/alure { };

  agg = callPackage ../development/libraries/agg { };

  allegro = allegro4;
  allegro4 = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  anttweakbar = callPackage ../development/libraries/AntTweakBar { };

  appstream = callPackage ../development/libraries/appstream { };

  appstream-glib = callPackage ../development/libraries/appstream-glib { };

  appstream-qt = libsForQt5.callPackage ../development/libraries/appstream/qt.nix { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
    db = if stdenv.isFreeBSD then db4 else db;
    # XXX: only the db_185 interface was available through
    #      apr with db58 on freebsd (nov 2015), for unknown reasons
  };

  arb = callPackage ../development/libraries/arb {};
  arb-git = callPackage ../development/libraries/arb/git.nix {};

  armadillo = callPackage ../development/libraries/armadillo {};

  arrow-cpp = callPackage ../development/libraries/arrow-cpp {};

  assimp = callPackage ../development/libraries/assimp { };

  asio = asio_1_12;
  asio_1_10 = callPackage ../development/libraries/asio/1.10.nix { };
  asio_1_12 = callPackage ../development/libraries/asio/1.12.nix { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix {});

  aspellWithDicts = callPackage ../development/libraries/aspell/aspell-with-dicts.nix {
    aspell = aspell.override { searchNixProfiles = false; };
  };

  attica = callPackage ../development/libraries/attica { };

  attr = callPackage ../development/libraries/attr { };

  at-spi2-core = callPackage ../development/libraries/at-spi2-core { };

  at-spi2-atk = callPackage ../development/libraries/at-spi2-atk { };

  aqbanking = callPackage ../development/libraries/aqbanking { };

  aubio = callPackage ../development/libraries/aubio { };

  audiofile = callPackage ../development/libraries/audiofile {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreServices;
  };

  aws-sdk-cpp = callPackage ../development/libraries/aws-sdk-cpp { };

  babl = callPackage ../development/libraries/babl { };

  backward-cpp = callPackage ../development/libraries/backward-cpp { };

  bamf = callPackage ../development/libraries/bamf { };

  bctoolbox = callPackage ../development/libraries/bctoolbox {
    mbedtls = mbedtls_1_3;
  };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  belcard = callPackage ../development/libraries/belcard { };

  belr = callPackage ../development/libraries/belr { };

  beignet = callPackage ../development/libraries/beignet {
    inherit (llvmPackages_39) llvm clang-unwrapped;
  };

  belle-sip = callPackage ../development/libraries/belle-sip { };

  libbfd = callPackage ../development/libraries/libbfd { };

  libopcodes = callPackage ../development/libraries/libopcodes { };

  bicpl = callPackage ../development/libraries/science/biology/bicpl { };

  bicgl = callPackage ../development/libraries/science/biology/bicgl { };

  # TODO(@Ericson2314): Build bionic libc from source
  bionic = assert stdenv.hostPlatform.useAndroidPrebuilt;
    androidenv."androidndkPkgs_${stdenv.hostPlatform.ndkVer}".libraries;

  bobcat = callPackage ../development/libraries/bobcat { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost159 = callPackage ../development/libraries/boost/1.59.nix { };
  boost15x = boost159;
  boost160 = callPackage ../development/libraries/boost/1.60.nix { };
  boost162 = callPackage ../development/libraries/boost/1.62.nix { };
  boost163 = callPackage ../development/libraries/boost/1.63.nix { };
  boost164 = callPackage ../development/libraries/boost/1.64.nix { };
  boost165 = callPackage ../development/libraries/boost/1.65.nix { };
  boost166 = callPackage ../development/libraries/boost/1.66.nix { };
  boost167 = callPackage ../development/libraries/boost/1.67.nix { };
  boost168 = callPackage ../development/libraries/boost/1.68.nix { };
  boost16x = boost167;
  boost = boost16x;

  boost_process = callPackage ../development/libraries/boost-process { };

  botan = callPackage ../development/libraries/botan { };
  botan2 = callPackage ../development/libraries/botan/2.0.nix { };

  box2d = callPackage ../development/libraries/box2d { };

  buddy = callPackage ../development/libraries/buddy { };

  bulletml = callPackage ../development/libraries/bulletml { };

  bwidget = callPackage ../development/libraries/bwidget { };

  bzrtp = callPackage ../development/libraries/bzrtp { };

  c-ares = callPackage ../development/libraries/c-ares {
    fetchurl = fetchurlBoot;
  };

  c-blosc = callPackage ../development/libraries/c-blosc { };

  cachix = (haskell.lib.justStaticExecutables haskellPackages.cachix).overrideAttrs (drv: {
    meta = drv.meta // {
      hydraPlatforms = stdenv.lib.platforms.unix;
    };
  });

  capnproto = callPackage ../development/libraries/capnproto { };

  ndn-cxx = callPackage ../development/libraries/ndn-cxx { };

  cddlib = callPackage ../development/libraries/cddlib {};

  cdk = callPackage ../development/libraries/cdk {};

  cdo = callPackage ../development/libraries/cdo {
    stdenv = gccStdenv;
  };

  cimg = callPackage  ../development/libraries/cimg { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

  ccrtp_1_8 = callPackage ../development/libraries/ccrtp/1.8.nix { };

  cctz = callPackage ../development/libraries/cctz { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cegui = callPackage ../development/libraries/cegui {};

  certbot = callPackage ../tools/admin/certbot { };

  caf = callPackage ../development/libraries/caf {};

  cgal = callPackage ../development/libraries/CGAL {};

  cgui = callPackage ../development/libraries/cgui {};

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  chipmunk = callPackage ../development/libraries/chipmunk {};

  chmlib = callPackage ../development/libraries/chmlib { };

  chromaprint = callPackage ../development/libraries/chromaprint { };

  cl = callPackage ../development/libraries/cl { };

  classads = callPackage ../development/libraries/classads { };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  clipper = callPackage ../development/libraries/clipper { };

  cln = callPackage ../development/libraries/cln { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core_1 = callPackage ../development/libraries/clucene-core { };

  clucene_core = clucene_core_1;

  clutter = callPackage ../development/libraries/clutter { };

  clutter-gst = callPackage ../development/libraries/clutter-gst {
  };

  clutter-gtk = callPackage ../development/libraries/clutter-gtk { };

  cminpack = callPackage ../development/libraries/cminpack { };

  cmocka = callPackage ../development/libraries/cmocka { };

  cmrt = callPackage ../development/libraries/cmrt { };

  cogl = callPackage ../development/libraries/cogl { };

  coin3d = callPackage ../development/libraries/coin3d { };

  soxt = callPackage ../development/libraries/soxt { };

  CoinMP = callPackage ../development/libraries/CoinMP { };

  cointop = callPackage ../applications/misc/cointop { };

  commoncpp2 = callPackage ../development/libraries/commoncpp2 { };

  confuse = callPackage ../development/libraries/confuse { };

  coredumper = callPackage ../development/libraries/coredumper { };

  ctl = callPackage ../development/libraries/ctl { };

  ctpp2 = callPackage ../development/libraries/ctpp2 { };

  ctpl = callPackage ../development/libraries/ctpl { };

  cppdb = callPackage ../development/libraries/cppdb { };

  cpp-hocon = callPackage ../development/libraries/cpp-hocon { };

  cpp-ipfs-api = callPackage ../development/libraries/cpp-ipfs-api { };

  cpp-netlib = callPackage ../development/libraries/cpp-netlib { };
  uri = callPackage ../development/libraries/uri { };

  cppcms = callPackage ../development/libraries/cppcms { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cpputest = callPackage ../development/libraries/cpputest { };

  cracklib = callPackage ../development/libraries/cracklib { };

  cre2 = callPackage ../development/libraries/cre2 { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cryptominisat = callPackage ../applications/science/logic/cryptominisat { };

  curlcpp = callPackage ../development/libraries/curlcpp { };

  cutee = callPackage ../development/libraries/cutee { };

  cutelyst = libsForQt5.callPackage ../development/libraries/cutelyst { };

  cxxtools = callPackage ../development/libraries/cxxtools { };

  cwiid = callPackage ../development/libraries/cwiid { };

  cxx-prettyprint = callPackage ../development/libraries/cxx-prettyprint { };

  cxxtest = callPackage ../development/libraries/cxxtest { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl {
    kerberos = if stdenv.isFreeBSD then libheimdal else kerberos;
  };

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

  dbxml = callPackage ../development/libraries/dbxml { };

  dbus = callPackage ../development/libraries/dbus { };
  dbus_cplusplus  = callPackage ../development/libraries/dbus-cplusplus { };
  dbus-glib       = callPackage ../development/libraries/dbus-glib { };
  dbus_java       = callPackage ../development/libraries/java/dbus-java { };

  dbus-sharp-1_0 = callPackage ../development/libraries/dbus-sharp/dbus-sharp-1.0.nix { };
  dbus-sharp-2_0 = callPackage ../development/libraries/dbus-sharp { };

  dbus-sharp-glib-1_0 = callPackage ../development/libraries/dbus-sharp-glib/dbus-sharp-glib-1.0.nix { };
  dbus-sharp-glib-2_0 = callPackage ../development/libraries/dbus-sharp-glib { };

  makeDBusConf = { suidHelper, serviceDirectories }:
    callPackage ../development/libraries/dbus/make-dbus-conf.nix {
      inherit suidHelper serviceDirectories;
    };

  dee = callPackage ../development/libraries/dee { };

  dhex = callPackage ../applications/editors/dhex { };

  double-conversion = callPackage ../development/libraries/double-conversion { };

  dclib = callPackage ../development/libraries/dclib { };

  dillo = callPackage ../applications/networking/browsers/dillo {
    fltk = fltk13;
  };

  dirac = callPackage ../development/libraries/dirac { };

  directfb = callPackage ../development/libraries/directfb { };

  dlib = callPackage ../development/libraries/dlib { };

  docopt_cpp = callPackage ../development/libraries/docopt_cpp { };

  dotconf = callPackage ../development/libraries/dotconf { };

  # Multi-arch "drivers" which we want to build for i686.
  driversi686Linux = recurseIntoAttrs {
    inherit (pkgsi686Linux)
      mesa_drivers
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      beignet
      glxinfo
      vdpauinfo;
  };

  dssi = callPackage ../development/libraries/dssi {};

  dxflib = callPackage ../development/libraries/dxflib {};

  easyloggingpp = callPackage ../development/libraries/easyloggingpp {};

  eccodes = callPackage ../development/libraries/eccodes { };

  eclib = callPackage ../development/libraries/eclib {};

  editline = callPackage ../development/libraries/editline { };

  eigen = callPackage ../development/libraries/eigen {};
  eigen3_3 = callPackage ../development/libraries/eigen/3.3.nix {};

  eigen2 = callPackage ../development/libraries/eigen/2.0.nix {};

  vmmlib = callPackage ../development/libraries/vmmlib {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  elastix = callPackage ../development/libraries/science/biology/elastix { };

  enchant = callPackage ../development/libraries/enchant { };

  enchant2 = callPackage ../development/libraries/enchant/2.x.nix { };

  enet = callPackage ../development/libraries/enet { };

  epoxy = callPackage ../development/libraries/epoxy {};

  esdl = callPackage ../development/libraries/esdl { };

  libesmtp = callPackage ../development/libraries/libesmtp { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  eventlog = callPackage ../development/libraries/eventlog { };

  faac = callPackage ../development/libraries/faac { };

  faad2 = callPackage ../development/libraries/faad2 { };

  factor-lang = callPackage ../development/compilers/factor-lang {
    inherit (pkgs.gnome2) gtkglext;
  };

  far2l = callPackage ../applications/misc/far2l {
    stdenv = if stdenv.cc.isClang then llvmPackages_4.stdenv else stdenv;
  };

  farbfeld = callPackage ../development/libraries/farbfeld { };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
    inherit (pythonPackages) gst-python;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffcast = callPackage ../tools/X11/ffcast { };

  fflas-ffpack = callPackage ../development/libraries/fflas-ffpack {
    # We need to use blas instead of openblas on darwin,
    # see https://github.com/NixOS/nixpkgs/pull/45013.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  fflas-ffpack_1 = callPackage ../development/libraries/fflas-ffpack/1.nix {};
  linbox = callPackage ../development/libraries/linbox {
    # We need to use blas instead of openblas on darwin, see
    # https://github.com/NixOS/nixpkgs/pull/45013 and
    # https://github.com/NixOS/nixpkgs/pull/45015.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  ffmpeg_0_10 = callPackage ../development/libraries/ffmpeg/0.10.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_1_2 = callPackage ../development/libraries/ffmpeg/1.2.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_2_8 = callPackage ../development/libraries/ffmpeg/2.8.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_3_4 = callPackage ../development/libraries/ffmpeg/3.4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };
  ffmpeg_4 = callPackage ../development/libraries/ffmpeg/4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };

  # Aliases
  ffmpeg_0 = ffmpeg_0_10;
  ffmpeg_1 = ffmpeg_1_2;
  ffmpeg_2 = ffmpeg_2_8;
  ffmpeg_3 = ffmpeg_3_4;
  ffmpeg = ffmpeg_3;

  ffmpeg-full = callPackage ../development/libraries/ffmpeg-full {
    # The following need to be fixed on Darwin
    frei0r = if stdenv.isDarwin then null else frei0r;
    game-music-emu = if stdenv.isDarwin then null else game-music-emu;
    libjack2 = if stdenv.isDarwin then null else libjack2;
    libmodplug = if stdenv.isDarwin then null else libmodplug;
    openal = if stdenv.isDarwin then null else openal;
    libpulseaudio = if stdenv.isDarwin then null else libpulseaudio;
    samba = if stdenv.isDarwin then null else samba;
    vid-stab = if stdenv.isDarwin then null else vid-stab;
    x265 = if stdenv.isDarwin then null else x265;
    xavs = if stdenv.isDarwin then null else xavs;
    inherit (darwin) CF;
    inherit (darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration;
  };

  ffmpegthumbnailer = callPackage ../development/libraries/ffmpegthumbnailer {
    ffmpeg = ffmpeg_2;
  };

  ffmpeg-sixel = callPackage ../development/libraries/ffmpeg-sixel { };

  ffms = callPackage ../development/libraries/ffms {
    ffmpeg = ffmpeg_2;
  };

  fftw = callPackage ../development/libraries/fftw { };
  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };

  filter-audio = callPackage ../development/libraries/filter-audio {};

  flann = callPackage ../development/libraries/flann { };

  flint = callPackage ../development/libraries/flint { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk { };
  fltk = self.fltk13;

  flyway = callPackage ../development/tools/flyway { };

  fplll = callPackage ../development/libraries/fplll {};
  fplll_20160331 = callPackage ../development/libraries/fplll/20160331.nix {};

  freeimage = callPackage ../development/libraries/freeimage { };

  freetts = callPackage ../development/libraries/freetts { };

  frog = self.languageMachines.frog;

  fstrm = callPackage ../development/libraries/fstrm { };

  cfitsio = callPackage ../development/libraries/cfitsio { };

  fontconfig_210 = callPackage ../development/libraries/fontconfig/2.10.nix { };

  fontconfig = callPackage ../development/libraries/fontconfig { };

  fontconfig-penultimate = callPackage ../data/fonts/fontconfig-penultimate {};

  fontconfig-ultimate = callPackage ../development/libraries/fontconfig-ultimate {};

  folly = callPackage ../development/libraries/folly { };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit fontconfig fontDirectories;
    };

  makeFontsCache = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-cache.nix {
      inherit fontconfig fontDirectories;
    };

  freealut = callPackage ../development/libraries/freealut { };

  freeglut = callPackage ../development/libraries/freeglut { };

  freenect = callPackage ../development/libraries/freenect {
    inherit (darwin.apple_sdk.frameworks) Cocoa GLUT;
  };

  freetype = callPackage ../development/libraries/freetype { };

  frei0r = callPackage ../development/libraries/frei0r { };

  fribidi = callPackage ../development/libraries/fribidi { };

  funambol = callPackage ../development/libraries/funambol { };

  gamin = callPackage ../development/libraries/gamin { };
  fam = gamin; # added 2018-04-25

  ganv = callPackage ../development/libraries/ganv { };

  gcab = callPackage ../development/libraries/gcab { };

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome2) gtkdoc;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_4 = callPackage ../development/libraries/gecode { };
  gecode = gecode_4;

  gephi = callPackage ../applications/science/misc/gephi { };

  gegl = callPackage ../development/libraries/gegl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  gegl_0_3 = callPackage ../development/libraries/gegl/3.0.nix {
    gtk = self.gtk2;
  };

  gegl_0_4 = callPackage ../development/libraries/gegl/4.0.nix {
    gtk = self.gtk2;
  };

  geoclue2 = callPackage ../development/libraries/geoclue {};

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  getdata = callPackage ../development/libraries/getdata { };

  getdns = callPackage ../development/libraries/getdns { };

  gettext = callPackage ../development/libraries/gettext { };

  gf2x = callPackage ../development/libraries/gf2x {};

  gd = callPackage ../development/libraries/gd {
    libtiff = null;
    libXpm = null;
  };

  gdal = callPackage ../development/libraries/gdal { };

  gdal_1_11 = callPackage ../development/libraries/gdal/gdal-1_11.nix { };

  gdcm = callPackage ../development/libraries/gdcm { };

  ggz_base_libs = callPackage ../development/libraries/ggz_base_libs {};

  giblib = callPackage ../development/libraries/giblib { };

  gio-sharp = callPackage ../development/libraries/gio-sharp { };

  givaro = callPackage ../development/libraries/givaro {};
  givaro_3 = callPackage ../development/libraries/givaro/3.nix {};
  givaro_3_7 = callPackage ../development/libraries/givaro/3.7.nix {};

  ghp-import = callPackage ../development/tools/ghp-import { };

  icon-lang = callPackage ../development/interpreters/icon-lang { };

  libgit2 = callPackage ../development/libraries/git2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libgit2_0_27 = callPackage ../development/libraries/git2/0.27.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  glbinding = callPackage ../development/libraries/glbinding { };

  gle = callPackage ../development/libraries/gle { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  glfw = glfw3;
  glfw2 = callPackage ../development/libraries/glfw/2.x.nix { };
  glfw3 = callPackage ../development/libraries/glfw/3.x.nix { };

  glibc = callPackage ../development/libraries/glibc {
    installLocales = config.glibc.locales or false;
  };

  # Provided by libc on Operating Systems that use the Extensible Linker Format.
  elf-header =
    if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf"
    then null
    else elf-header-real;

  elf-header-real = callPackage ../development/libraries/elf-header { };

  glibc_memusage = callPackage ../development/libraries/glibc {
    installLocales = false;
    withGd = true;
  };

  # Being redundant to avoid cycles on boot. TODO: find a better way
  glibcCross = callPackage ../development/libraries/glibc {
    installLocales = config.glibc.locales or false;
    stdenv = crossLibcStdenv;
  };

  muslCross = musl.override {
    stdenv = crossLibcStdenv;
  };

  # We can choose:
  libcCrossChooser = name:
    # libc is hackily often used from the previous stage. This `or`
    # hack fixes the hack, *sigh*.
    /**/ if name == "glibc" then targetPackages.glibcCross or glibcCross
    else if name == "bionic" then targetPackages.bionic
    else if name == "uclibc" then targetPackages.uclibcCross
    else if name == "musl" then targetPackages.muslCross or muslCross
    else if name == "msvcrt" then targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if stdenv.targetPlatform.useiOSPrebuilt then targetPackages.darwin.iosSdkPkgs.libraries
    else if name == "libSystem" then targetPackages.darwin.xcode
    else throw "Unknown libc";

  libcCross = assert stdenv.targetPlatform != stdenv.buildPlatform; libcCrossChooser stdenv.targetPlatform.libc;

  # Only supported on Linux, using glibc
  glibcLocales = if stdenv.hostPlatform.libc == "glibc" then callPackage ../development/libraries/glibc/locales.nix { } else null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    glibc32 = pkgsi686Linux.glibc;
  };

  glm = callPackage ../development/libraries/glm { };

  globalplatform = callPackage ../development/libraries/globalplatform { };
  gppcscconnectionplugin =
    callPackage ../development/libraries/globalplatform/gppcscconnectionplugin.nix { };

  glog = callPackage ../development/libraries/glog { };

  gloox = callPackage ../development/libraries/gloox { };

  glpk = callPackage ../development/libraries/glpk { };

  glsurf = callPackage ../applications/science/math/glsurf {
    libpng = libpng12;
    giflib = giflib_4_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_01_0;
  };

  glui = callPackage ../development/libraries/glui {};

  gmime2 = callPackage ../development/libraries/gmime/2.nix { };
  gmime3 = callPackage ../development/libraries/gmime/3.nix { };
  gmime = gmime2;

  gmm = callPackage ../development/libraries/gmm { };

  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { }; # required by older GHC versions
  gmp5 = callPackage ../development/libraries/gmp/5.1.x.nix { };
  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = gmp6;
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr { };

  mpfi = callPackage ../development/libraries/mpfi { };

  mpfshell = callPackage ../development/tools/mpfshell { };

  # A GMP fork
  mpir = callPackage ../development/libraries/mpir {};

  gns3Packages = callPackage ../applications/networking/gns3 { };
  gns3-gui = gns3Packages.guiStable;
  gns3-server = gns3Packages.serverStable;

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
    python = python2;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };
  goocanvas2 = callPackage ../development/libraries/goocanvas/2.x.nix { };

  google-gflags = callPackage ../development/libraries/google-gflags { };
  gflags = google-gflags; # TODO: move to aliases.nix

  gperftools = callPackage ../development/libraries/gperftools { };

  grib-api = callPackage ../development/libraries/grib-api { };

  grpc = callPackage ../development/libraries/grpc { };

  gsettings-qt = libsForQt5.callPackage ../development/libraries/gsettings-qt { };

  gst_all_1 = recurseIntoAttrs(callPackage ../development/libraries/gstreamer {
    callPackage = pkgs.newScope (pkgs // { libav = pkgs.ffmpeg; });
  });

  gstreamer = callPackage ../development/libraries/gstreamer/legacy/gstreamer {
    bison = bison2;
  };

  gst-plugins-base = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-base {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gst-plugins-good = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-good {};

  gst-plugins-bad = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-bad {};

  gst-plugins-ugly = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-ugly {};

  gst-ffmpeg = callPackage ../development/libraries/gstreamer/legacy/gst-ffmpeg {
    ffmpeg = ffmpeg_0;
  };

  gst-python = callPackage ../development/libraries/gstreamer/legacy/gst-python {};

  gstreamermm = callPackage ../development/libraries/gstreamer/legacy/gstreamermm { };

  gnonlin = callPackage ../development/libraries/gstreamer/legacy/gnonlin {};

  gusb = callPackage ../development/libraries/gusb {
    inherit (gnome2) gtkdoc;
  };

  qt-mobility = callPackage ../development/libraries/qt-mobility {};

  qt-gstreamer = callPackage ../development/libraries/gstreamer/legacy/qt-gstreamer {};

  qt-gstreamer1 = callPackage ../development/libraries/gstreamer/qt-gstreamer { boost = boost155; };

  qtstyleplugin-kvantum-qt4 = callPackage ../development/libraries/qtstyleplugin-kvantum-qt4 { };

  gnet = callPackage ../development/libraries/gnet { };

  gnu-config = callPackage ../development/libraries/gnu-config { };

  gnu-efi = if stdenv.hostPlatform.isEfi
              then callPackage ../development/libraries/gnu-efi { }
            else null;

  gnutls = callPackage
    (if stdenv.isDarwin
      # Avoid > 3.5.10 due to frameworks for now; see discussion on:
      # https://github.com/NixOS/nixpkgs/commit/d6454e6a1
      then ../development/libraries/gnutls/3.5.10.nix
      else ../development/libraries/gnutls/3.6.nix)
    {
      guileBindings = config.gnutls.guile or false;
    };

  gnutls-kdh = callPackage ../development/libraries/gnutls-kdh/3.5.nix {
    guileBindings = config.gnutls.guile or false;
    gperf = gperf_3_0;
  };

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme { };

  pgpdump = callPackage ../tools/security/pgpdump { };

  pgpkeyserver-lite = callPackage ../servers/web-apps/pgpkeyserver-lite {};

  gpgstats = callPackage ../tools/security/gpgstats { };

  gpshell = callPackage ../development/tools/misc/gpshell { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsl_1 = callPackage ../development/libraries/gsl/gsl-1_16.nix { };

  gsm = callPackage ../development/libraries/gsm {};

  gsoap = callPackage ../development/libraries/gsoap { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview { };

  gtkmathview = callPackage ../development/libraries/gtkmathview { };

  glib = callPackage ../development/libraries/glib (let
    glib-untested = glib.override { doCheck = false; };
  in {
    # break dependency cycles
    # these things are only used for tests, they don't get into the closure
    shared-mime-info = shared-mime-info.override { glib = glib-untested; };
    desktop-file-utils = desktop-file-utils.override { glib = glib-untested; };
    dbus = dbus.override { systemd = null; };
  });

  glibmm = callPackage ../development/libraries/glibmm { };

  glib-networking = callPackage ../development/libraries/glib-networking {};

  ace = callPackage ../development/libraries/ace { };

  atk = callPackage ../development/libraries/atk { };

  atkmm = callPackage ../development/libraries/atkmm { };

  pixman = callPackage ../development/libraries/pixman { };

  cairo = callPackage ../development/libraries/cairo {
    glSupport = config.cairo.gl or (stdenv.isLinux &&
      !stdenv.isAarch32 && !stdenv.isMips);
  };


  cairomm = callPackage ../development/libraries/cairomm { };

  pango = callPackage ../development/libraries/pango { };

  pangolin = callPackage ../development/libraries/pangolin {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  pangomm = callPackage ../development/libraries/pangomm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pangox_compat = callPackage ../development/libraries/pangox-compat { };

  gdata-sharp = callPackage ../development/libraries/gdata-sharp { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gnome-sharp = callPackage ../development/libraries/gnome-sharp { mono = mono4; };

  granite = callPackage ../development/libraries/granite { };
  elementary-cmake-modules = callPackage ../development/libraries/elementary-cmake-modules { };

  gtk2 = callPackage ../development/libraries/gtk+/2.x.nix {
    cupsSupport = config.gtk2.cups or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gtk2-x11 = gtk2.override {
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk+/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  # On darwin gtk uses cocoa by default instead of x11.
  gtk3-x11 = gtk3.override {
    x11Support = true;
  };

  gtkmm2 = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };

  gtk-sharp-2_0 = callPackage ../development/libraries/gtk-sharp/2.0.nix {
    inherit (gnome2) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtk-sharp-3_0 = callPackage ../development/libraries/gtk-sharp/3.0.nix {
    inherit (gnome2) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtk-sharp-beans = callPackage ../development/libraries/gtk-sharp-beans { };

  gtk-mac-integration = callPackage ../development/libraries/gtk-mac-integration {
    gtk = gtk3;
  };

  gtk-mac-integration-gtk2 = gtk-mac-integration.override {
    gtk = gtk2;
  };

  gtk-mac-integration-gtk3 = gtk-mac-integration;

  gtk-mac-bundler = callPackage ../development/tools/gtk-mac-bundler {};

  gtksourceview = gtksourceview3;

  gtksourceview3 = callPackage ../development/libraries/gtksourceview/3.x.nix { };

  gtksourceview4 = callPackage ../development/libraries/gtksourceview/4.x.nix { };

  gtkspell2 = callPackage ../development/libraries/gtkspell { };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gtkspellmm = callPackage ../development/libraries/gtkspellmm { };

  gts = callPackage ../development/libraries/gts { };

  gumbo = callPackage ../development/libraries/gumbo { };

  gvfs = callPackage ../development/libraries/gvfs {
    gnome = self.gnome3;
  };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  hamlib = callPackage ../development/libraries/hamlib { };

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security SystemConfiguration;
  };
  libheimdal = heimdal;

  harfbuzz = callPackage ../development/libraries/harfbuzz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreText;
  };

  harfbuzzFull = harfbuzz.override {
    withCoreText = stdenv.isDarwin;
    withGraphite2 = true;
    withIcu = true;
  };

  hawknl = callPackage ../development/libraries/hawknl { };

  haxor-news = callPackage ../applications/misc/haxor-news { };

  herqq = libsForQt5.callPackage ../development/libraries/herqq { };

  heyefi = haskellPackages.heyefi;

  hidapi = callPackage ../development/libraries/hidapi {
    libusb = libusb1;
  };

  hiredis = callPackage ../development/libraries/hiredis { };

  hivex = callPackage ../development/libraries/hivex {
    inherit (perlPackages) IOStringy;
  };

  hound = callPackage ../development/tools/misc/hound { };

  hpx = callPackage ../development/libraries/hpx { };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

  hstr = callPackage ../applications/misc/hstr { };

  htmlcxx = callPackage ../development/libraries/htmlcxx { };

  http-parser = callPackage ../development/libraries/http-parser { };

  hunspell = callPackage ../development/libraries/hunspell { };

  hunspellDicts = recurseIntoAttrs (callPackages ../development/libraries/hunspell/dictionaries.nix {});

  hunspellWithDicts = dicts: callPackage ../development/libraries/hunspell/wrapper.nix { inherit dicts; };

  hwloc = callPackage ../development/libraries/hwloc {};

  hwloc-nox = hwloc.override {
    x11Support = false;
  };

  hydra = callPackage ../development/tools/misc/hydra { };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  hyena = callPackage ../development/libraries/hyena { mono = mono4; };

  icu58 = callPackage (import ../development/libraries/icu/58.nix fetchurl) ({
    nativeBuildRoot = buildPackages.icu58.override { buildRootOnly = true; };
  } //
    (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu59 = callPackage ../development/libraries/icu/59.nix ({
    nativeBuildRoot = buildPackages.icu59.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu60 = callPackage ../development/libraries/icu/60.nix ({
    nativeBuildRoot = buildPackages.icu60.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));

  icu = icu59;

  id3lib = callPackage ../development/libraries/id3lib { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilixi = callPackage ../development/libraries/ilixi { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  imv = callPackage ../applications/graphics/imv { };

  iml = callPackage ../development/libraries/iml { };

  imlib2 = callPackage ../development/libraries/imlib2 { };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot { libXinerama = xorg.libXinerama; } ;

  ijs = callPackage ../development/libraries/ijs { };

  incrtcl = callPackage ../development/libraries/incrtcl { };

  indicator-application-gtk2 = callPackage ../development/libraries/indicator-application/gtk2.nix { };
  indicator-application-gtk3 = callPackage ../development/libraries/indicator-application/gtk3.nix { };

  indilib = callPackage ../development/libraries/indilib { };

  iniparser = callPackage ../development/libraries/iniparser { };

  intltool = callPackage ../development/tools/misc/intltool { };

  ios-cross-compile = callPackage ../development/compilers/ios-cross-compile/9.2.nix {};

  ip2location-c = callPackage ../development/libraries/ip2location-c { };

  irrlicht = callPackage ../development/libraries/irrlicht { };

  isocodes = callPackage ../development/libraries/iso-codes { };

  ispc = callPackage ../development/compilers/ispc {
    llvmPackages = llvmPackages_6;
    stdenv = llvmPackages_6.stdenv;
  };

  isso = callPackage ../servers/isso { };

  itk = callPackage ../development/libraries/itk { };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jansson = callPackage ../development/libraries/jansson { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jbigkit = callPackage ../development/libraries/jbigkit { };

  jemalloc = callPackage ../development/libraries/jemalloc { };

  jemalloc450 = callPackage ../development/libraries/jemalloc/jemalloc450.nix { };

  jshon = callPackage ../development/tools/parsing/jshon { };

  json2hcl = callPackage ../development/tools/json2hcl { };

  json-glib = callPackage ../development/libraries/json-glib { };

  json_c = callPackage ../development/libraries/json-c { };

  jsoncpp = callPackage ../development/libraries/jsoncpp { };

  jsonnet = callPackage ../development/compilers/jsonnet {
    emscripten = emscripten.override {python=python2;};
  };

  jsonrpc-glib = callPackage ../development/libraries/jsonrpc-glib { };

  libjson = callPackage ../development/libraries/libjson { };

  libb64 = callPackage ../development/libraries/libb64 { };

  judy = callPackage ../development/libraries/judy { };

  kdeFrameworks =
    let
      mkFrameworks = import ../development/libraries/kde-frameworks;
      attrs = {
        inherit libsForQt5;
        inherit lib fetchurl;
      };
    in
      recurseIntoAttrs (makeOverridable mkFrameworks attrs);

  keybinder = callPackage ../development/libraries/keybinder {
    automake = automake111x;
    lua = lua5_1;
  };

  keybinder3 = callPackage ../development/libraries/keybinder3 {
    automake = automake111x;
  };

  kinetic-cpp-client = callPackage ../development/libraries/kinetic-cpp-client { };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (darwin) bootstrap_cmds;
  };
  krb5Full = krb5;
  libkrb5 = krb5.override {
    fetchurl = fetchurlBoot;
    type = "lib";
  };
  kerberos = libkrb5; # TODO: move to aliases.nix

  languageMachines = recurseIntoAttrs (import ../development/libraries/languagemachines/packages.nix { inherit callPackage; });

  lasso = callPackage ../development/libraries/lasso { };

  LASzip = callPackage ../development/libraries/LASzip { };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  ldb = callPackage ../development/libraries/ldb {
    python = python2;
  };

  lensfun = callPackage ../development/libraries/lensfun {};

  lesstif = callPackage ../development/libraries/lesstif { };

  leveldb = callPackage ../development/libraries/leveldb { };

  lmdb = callPackage ../development/libraries/lmdb { };

  lmdbxx = callPackage ../development/libraries/lmdbxx { };

  levmar = callPackage ../development/libraries/levmar { };

  leptonica = callPackage ../development/libraries/leptonica { };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  libaacs = callPackage ../development/libraries/libaacs { };

  libaal = callPackage ../development/libraries/libaal { };

  libaccounts-glib = callPackage ../development/libraries/libaccounts-glib { };

  libacr38u = callPackage ../tools/security/libacr38u { };

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreServices AudioUnit;
  };

  libabw = callPackage ../development/libraries/libabw { };

  libamqpcpp = callPackage ../development/libraries/libamqpcpp { };

  libantlr3c = callPackage ../development/libraries/libantlr3c {};

  libaom = callPackage ../development/libraries/libaom { };

  libappindicator-gtk2 = libappindicator.override { gtkVersion = "2"; };
  libappindicator-gtk3 = libappindicator.override { gtkVersion = "3"; };
  libappindicator = callPackage ../development/libraries/libappindicator { };

  libarchive = callPackage ../development/libraries/libarchive { };

  libasr = callPackage ../development/libraries/libasr { };

  libass = callPackage ../development/libraries/libass { };

  libast = callPackage ../development/libraries/libast { };

  libassuan = callPackage ../development/libraries/libassuan { };

  libasyncns = callPackage ../development/libraries/libasyncns { };

  libatomic_ops = callPackage ../development/libraries/libatomic_ops {};

  libaudclient = callPackage ../development/libraries/libaudclient { };

  libav = libav_11; # branch 11 is API-compatible with branch 10
  libav_all = callPackage ../development/libraries/libav { };
  inherit (libav_all) libav_0_8 libav_11 libav_12;

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libb2 = callPackage ../development/libraries/libb2 { };

  libbap = callPackage ../development/libraries/libbap {
    inherit (ocaml-ng.ocamlPackages_4_05) bap ocaml findlib ctypes;
  };

  libbass = (callPackage ../development/libraries/audio/libbass { }).bass;
  libbass_fx = (callPackage ../development/libraries/audio/libbass { }).bass_fx;

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbdplus = callPackage ../development/libraries/libbdplus { };

  libblockdev = callPackage ../development/libraries/libblockdev { };

  libblocksruntime = callPackage ../development/libraries/libblocksruntime { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libbs2b = callPackage ../development/libraries/audio/libbs2b { };

  libbson = callPackage ../development/libraries/libbson { };

  libburn = callPackage ../development/libraries/libburn { };

  libbytesize = callPackage ../development/libraries/libbytesize { };

  libcaca = callPackage ../development/libraries/libcaca {
    inherit (xorg) libX11 libXext;
  };

  libcanberra = callPackage ../development/libraries/libcanberra { };
  libcanberra-gtk3 = pkgs.libcanberra.override {
    gtk = gtk3;
  };
  libcanberra-gtk2 = pkgs.libcanberra-gtk3.override {
    gtk = gtk2.override { gdktarget = "x11"; };
  };

  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then pkgs.libcanberra
    else pkgs.libcanberra-gtk2;

  libcec = callPackage ../development/libraries/libcec { };
  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcef = callPackage ../development/libraries/libcef { inherit (gnome2) GConf; };

  libcello = callPackage ../development/libraries/libcello {};

  libcerf = callPackage ../development/libraries/libcerf {};

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  libcdio-paranoia = callPackage ../development/libraries/libcdio-paranoia {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration IOKit;
  };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome2) libsoup;
  };

  libchardet = callPackage ../development/libraries/libchardet { };

  libchewing = callPackage ../development/libraries/libchewing { };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libcrafter = callPackage ../development/libraries/libcrafter { };

  libcrossguid = callPackage ../development/libraries/libcrossguid { };

  libuchardet = callPackage ../development/libraries/libuchardet { };

  libchop = callPackage ../development/libraries/libchop { };

  libclc = callPackage ../development/libraries/libclc { };

  libcli = callPackage ../development/libraries/libcli { };

  libclthreads = callPackage ../development/libraries/libclthreads  { };

  libclxclient = callPackage ../development/libraries/libclxclient  { };

  libconfuse = callPackage ../development/libraries/libconfuse { };

  inherit (gnome3) libcroco;

  libcangjie = callPackage ../development/libraries/libcangjie { };

  libcollectdclient = callPackage ../development/libraries/libcollectdclient { };

  libcredis = callPackage ../development/libraries/libcredis { };

  libctemplate = callPackage ../development/libraries/libctemplate { };

  libcouchbase = callPackage ../development/libraries/libcouchbase { };

  libcue = callPackage ../development/libraries/libcue { };

  libcutl = callPackage ../development/libraries/libcutl { };

  libdaemon = callPackage ../development/libraries/libdaemon { };

  libdap = callPackage ../development/libraries/libdap { };

  libdazzle = callPackage ../development/libraries/libdazzle { };

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = libdbiDrivers.override {
    mysql = null;
    sqlite = null;
  };

  libdbiDrivers = callPackage ../development/libraries/libdbi-drivers { };

  libunity = callPackage ../development/libraries/libunity {
    inherit (gnome3) gnome-common;
  };

  libdbusmenu = callPackage ../development/libraries/libdbusmenu { };
  libdbusmenu-gtk2 = libdbusmenu.override { gtkVersion = "2"; };
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdc1394 = callPackage ../development/libraries/libdc1394 {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  libde265 = callPackage ../development/libraries/libde265 {};

  libdevil = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  libdevil-nox = libdevil.override {
    libX11 = null;
    libGL = null;
  };

  libdigidoc = callPackage ../development/libraries/libdigidoc { };

  libdigidocpp = callPackage ../development/libraries/libdigidocpp { };

  libdiscid = callPackage ../development/libraries/libdiscid { };

  libdivecomputer = callPackage ../development/libraries/libdivecomputer { };

  libdivsufsort = callPackage ../development/libraries/libdivsufsort { };

  libdmtx = callPackage ../development/libraries/libdmtx { };

  libdnet = callPackage ../development/libraries/libdnet { };

  libdrm = callPackage ../development/libraries/libdrm { };

  libdv = callPackage ../development/libraries/libdv { };

  libdvbpsi = callPackage ../development/libraries/libdvbpsi { };

  libdwg = callPackage ../development/libraries/libdwg { };

  libdvdcss = callPackage ../development/libraries/libdvdcss {
    inherit (darwin) IOKit;
  };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };
  libdvdnav_4_2_1 = callPackage ../development/libraries/libdvdnav/4.2.1.nix {
    libdvdread = libdvdread_4_9_9;
  };

  libdvdread = callPackage ../development/libraries/libdvdread { };
  libdvdread_4_9_9 = callPackage ../development/libraries/libdvdread/4.9.9.nix { };

  inherit (callPackage ../development/libraries/libdwarf { })
    libdwarf dwarfdump;

  libeatmydata = callPackage ../development/libraries/libeatmydata { };

  libeb = callPackage ../development/libraries/libeb { };

  libebml = callPackage ../development/libraries/libebml { };

  libebur128 = callPackage ../development/libraries/libebur128 { };

  libedit = callPackage ../development/libraries/libedit { };

  libelf = if stdenv.isFreeBSD
  then callPackage ../development/libraries/libelf-freebsd { }
  else callPackage ../development/libraries/libelf { };

  libetpan = callPackage ../development/libraries/libetpan { };

  libexecinfo = callPackage ../development/libraries/libexecinfo { };

  libfaketime = callPackage ../development/libraries/libfaketime { };

  libfakekey = callPackage ../development/libraries/libfakekey { };

  libfilezilla = callPackage ../development/libraries/libfilezilla { };

  libfm = callPackage ../development/libraries/libfm { };
  libfm-extra = libfm.override {
    extraOnly = true;
  };

  libfprint = callPackage ../development/libraries/libfprint { };

  libfpx = callPackage ../development/libraries/libfpx { };

  libgadu = callPackage ../development/libraries/libgadu { };

  gap-libgap-compatible = let
    version = "4r8p6";
    pkgVer = "2016_11_12-14_25";
  in
    (gap.override { keepAllPackages = false; }).overrideAttrs (oldAttrs: {
      name = "libgap-${oldAttrs.pname}-${version}";
      src = fetchurl {
        url = "https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap${version}_${pkgVer}.tar.bz2";
        sha256 = "19n2p1mdg33s2x9rs51iak7rgndc1cwr56jyqnah0g1ydgg1yh6b";
      };
      patches = (oldAttrs.patches or []) ++ [
        # don't install any packages by default (needed for interop with libgap, probably obsolete  with 4r10
        (fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/nodefaultpackages.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "1xwj766m3axrxbkyx13hy3q8s2wkqxy3m6mgpwq3c3n4vk3v416v";
        })
      ];
  });
  libgap = callPackage ../development/libraries/libgap { };

  libgdata = gnome3.libgdata;

  libgig = callPackage ../development/libraries/libgig { };

  libgnome-keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome-keyring3 = gnome3.libgnome-keyring;

  libglvnd = callPackage ../development/libraries/libglvnd { };

  libgnurl = callPackage ../development/libraries/libgnurl { };

  libgringotts = callPackage ../development/libraries/libgringotts { };

  libgroove = callPackage ../development/libraries/libgroove { };

  libgrss = callPackage ../development/libraries/libgrss { };

  libiio = callPackage ../development/libraries/libiio { };

  libseccomp = callPackage ../development/libraries/libseccomp { };

  libsecret = callPackage ../development/libraries/libsecret { };

  libserialport = callPackage ../development/libraries/libserialport { };

  libsignal-protocol-c = callPackage ../development/libraries/libsignal-protocol-c { };

  libsoundio = callPackage ../development/libraries/libsoundio {
    inherit (darwin.apple_sdk.frameworks) AudioUnit;
  };

  libgtop = callPackage ../development/libraries/libgtop {};

  libLAS = callPackage ../development/libraries/libLAS { };

  liblaxjson = callPackage ../development/libraries/liblaxjson { };

  liblo = callPackage ../development/libraries/liblo { };

  liblscp = callPackage ../development/libraries/liblscp { };

  libe-book = callPackage ../development/libraries/libe-book {};

  libechonest = callPackage ../development/libraries/libechonest { };

  libev = callPackage ../development/libraries/libev {
    fetchurl = fetchurlBoot;
  };

  libevent = callPackage ../development/libraries/libevent { };

  libewf = callPackage ../development/libraries/libewf { };

  libexif = callPackage ../development/libraries/libexif { };

  libexosip = callPackage ../development/libraries/exosip {};

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libexttextcat = callPackage ../development/libraries/libexttextcat {};

  libf2c = callPackage ../development/libraries/libf2c {};

  libfive = callPackage ../development/libraries/libfive {};

  libfixposix = callPackage ../development/libraries/libfixposix {};

  libffcall = callPackage ../development/libraries/libffcall { };

  libffi = callPackage ../development/libraries/libffi { };

  libfreefare = callPackage ../development/libraries/libfreefare {
    inherit (darwin) libobjc;
  };

  libftdi = callPackage ../development/libraries/libftdi { };

  libftdi1 = callPackage ../development/libraries/libftdi/1.x.nix { };

  libgcrypt = callPackage ../development/libraries/libgcrypt { };

  libgcrypt_1_5 = callPackage ../development/libraries/libgcrypt/1.5.nix { };

  libgdiplus = callPackage ../development/libraries/libgdiplus {
      inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  libgksu = callPackage ../development/libraries/libgksu { };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  # https://github.com/gpg/libgpg-error/blob/70058cd9f944d620764e57c838209afae8a58c78/README#L118-L140
  libgpgerror-gen-posix-lock-obj = libgpgerror.override {
    genPosixLockObjOnly = true;
  };

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

  libgpod = callPackage ../development/libraries/libgpod {
    inherit (pkgs.pythonPackages) mutagen;
    monoSupport = false;
  };

  libgssglue = callPackage ../development/libraries/libgssglue { };

  libgudev = callPackage ../development/libraries/libgudev { };

  libguestfs-appliance = callPackage ../development/libraries/libguestfs/appliance.nix {};
  libguestfs = callPackage ../development/libraries/libguestfs {
    inherit (perlPackages) libintl_perl GetoptLong SysVirt;
    appliance = libguestfs-appliance;
  };

  libhangul = callPackage ../development/libraries/libhangul { };

  libharu = callPackage ../development/libraries/libharu { };

  libhdhomerun = callPackage ../development/libraries/libhdhomerun { };

  libheif = callPackage ../development/libraries/libheif {};

  libhttpseverywhere = callPackage ../development/libraries/libhttpseverywhere { };

  libHX = callPackage ../development/libraries/libHX { };

  libibmad = callPackage ../development/libraries/libibmad { };

  libibumad = callPackage ../development/libraries/libibumad { };

  libical = callPackage ../development/libraries/libical { };

  libicns = callPackage ../development/libraries/libicns { };

  libimobiledevice = callPackage ../development/libraries/libimobiledevice { };

  libindicate-gtk2 = libindicate.override { gtkVersion = "2"; };
  libindicate-gtk3 = libindicate.override { gtkVersion = "3"; };
  libindicate = callPackage ../development/libraries/libindicate { };

  libindicator-gtk2 = libindicator.override { gtkVersion = "2"; };
  libindicator-gtk3 = libindicator.override { gtkVersion = "3"; };
  libindicator = callPackage ../development/libraries/libindicator { };

  libinotify-kqueue = callPackage ../development/libraries/libinotify-kqueue { };

  libiodbc = callPackage ../development/libraries/libiodbc {
    useGTK = config.libiodbc.gtk or false;
  };

  libivykis = callPackage ../development/libraries/libivykis { };

  liblastfmSF = callPackage ../development/libraries/liblastfmSF { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  liblcf = callPackage ../development/libraries/liblcf { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 { };

  liblockfile = callPackage ../development/libraries/liblockfile { };

  liblogging = callPackage ../development/libraries/liblogging { };

  liblognorm = callPackage ../development/libraries/liblognorm { };

  libltc = callPackage ../development/libraries/libltc { };

  libmaxminddb = callPackage ../development/libraries/libmaxminddb { };

  libmcrypt = callPackage ../development/libraries/libmcrypt {};

  libmediainfo = callPackage ../development/libraries/libmediainfo { };

  libmhash = callPackage ../development/libraries/libmhash {};

  libmodbus = callPackage ../development/libraries/libmodbus {};

  libmtp = callPackage ../development/libraries/libmtp { };

  libmypaint = callPackage ../development/libraries/libmypaint { };

  libmysofa = callPackage ../development/libraries/audio/libmysofa { };

  libmysqlconnectorcpp = callPackage ../development/libraries/libmysqlconnectorcpp {
    mysql = mysql57;
  };

  libnatpmp = callPackage ../development/libraries/libnatpmp { };

  libnatspec = callPackage ../development/libraries/libnatspec { };

  libndp = callPackage ../development/libraries/libndp { };

  libnfc = callPackage ../development/libraries/libnfc { };

  libnfs = callPackage ../development/libraries/libnfs { };

  libnice = callPackage ../development/libraries/libnice { };

  libnsl = callPackage ../development/libraries/libnsl { };

  liboping = callPackage ../development/libraries/liboping { };

  libplist = callPackage ../development/libraries/libplist { };

  libqglviewer = callPackage ../development/libraries/libqglviewer {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  libre = callPackage ../development/libraries/libre {};
  librem = callPackage ../development/libraries/librem {};

  librelp = callPackage ../development/libraries/librelp { };

  librepo = callPackage ../tools/package-management/librepo { };

  libresample = callPackage ../development/libraries/libresample {};

  librevenge = callPackage ../development/libraries/librevenge {};

  librevisa = callPackage ../development/libraries/librevisa { };

  librime = callPackage ../development/libraries/librime {};

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon CoreServices;
  };

  libsieve = callPackage ../development/libraries/libsieve { };

  libsixel = callPackage ../development/libraries/libsixel { };

  libsolv = callPackage ../development/libraries/libsolv { };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf { };

  # GNU libc provides libiconv so systems with glibc don't need to build
  # libiconv separately. Additionally, Apple forked/repackaged libiconv so we
  # use that instead of the vanilla version on that OS.
  #
  # We also provide `libiconvReal`, which will always be a standalone libiconv,
  # just in case you want it regardless of platform.
  libiconv =
    if (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl")
      then glibcIconv (if stdenv.hostPlatform != stdenv.buildPlatform
                       then libcCross
                       else stdenv.cc.libc)
    else if stdenv.hostPlatform.isDarwin
      then darwin.libiconv
    else libiconvReal;

  glibcIconv = libc: let
    inherit (builtins.parseDrvName libc.name) name version;
    libcDev = lib.getDev libc;
  in runCommand "${name}-iconv-${version}" {} ''
    mkdir -p $out/include
    ln -sv ${libcDev}/include/iconv.h $out/include
  '';

  libiconvReal = callPackage ../development/libraries/libiconv {
    fetchurl = fetchurlBoot;
  };

  # On non-GNU systems we need GNU Gettext for libintl.
  libintl = if stdenv.hostPlatform.libc != "glibc" then gettext else null;

  libid3tag = callPackage ../development/libraries/libid3tag {
    gperf = gperf_3_0;
  };

  libidn = callPackage ../development/libraries/libidn { };

  libidn2 = callPackage ../development/libraries/libidn2 { };

  idnkit = callPackage ../development/libraries/idnkit { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity { };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  libinput-gestures = callPackage ../tools/inputmethods/libinput-gestures {};

  libisofs = callPackage ../development/libraries/libisofs { };

  libisoburn = callPackage ../development/libraries/libisoburn { };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg_drop = callPackage ../development/libraries/libjpeg-drop { };
  libjpeg = libjpeg_turbo;

  libjreen = callPackage ../development/libraries/libjreen { };

  libjson-rpc-cpp = callPackage ../development/libraries/libjson-rpc-cpp { };

  libkate = callPackage ../development/libraries/libkate { };

  libksba = callPackage ../development/libraries/libksba { };

  libksi = callPackage ../development/libraries/libksi { };

  liblinear = callPackage ../development/libraries/liblinear { };

  libmad = callPackage ../development/libraries/libmad { };

  libmanette = callPackage ../development/libraries/libmanette { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatheval = callPackage ../development/libraries/libmatheval {
    guile = guile_2_0;
  };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmd = callPackage ../development/libraries/libmd { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  libmilter = callPackage ../development/libraries/libmilter { };

  libminc = callPackage ../development/libraries/libminc {
    hdf5 = hdf5_1_8;
  };

  libmirage = callPackage ../misc/emulators/cdemu/libmirage.nix { };

  libmkv = callPackage ../development/libraries/libmkv { };

  libmms = callPackage ../development/libraries/libmms { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { };

  libmnl = callPackage ../development/libraries/libmnl { };

  libmodplug = callPackage ../development/libraries/libmodplug {};

  libmpcdec = callPackage ../development/libraries/libmpcdec { };

  libmp3splt = callPackage ../development/libraries/libmp3splt { };

  libmrss = callPackage ../development/libraries/libmrss { };

  libmspack = callPackage ../development/libraries/libmspack { };

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz5 = callPackage ../development/libraries/libmusicbrainz/5.x.nix { };

  libmusicbrainz = libmusicbrainz3;

  libmwaw = callPackage ../development/libraries/libmwaw { };

  libmx = callPackage ../development/libraries/libmx { };

  libndctl = callPackage ../development/libraries/libndctl { };

  libnet = callPackage ../development/libraries/libnet { };

  libnetfilter_conntrack = callPackage ../development/libraries/libnetfilter_conntrack { };

  libnetfilter_cthelper = callPackage ../development/libraries/libnetfilter_cthelper { };

  libnetfilter_cttimeout = callPackage ../development/libraries/libnetfilter_cttimeout { };

  libnetfilter_log = callPackage ../development/libraries/libnetfilter_log { };

  libnetfilter_queue = callPackage ../development/libraries/libnetfilter_queue { };

  libnfnetlink = callPackage ../development/libraries/libnfnetlink { };

  libnftnl = callPackage ../development/libraries/libnftnl { };

  libnih = callPackage ../development/libraries/libnih { };

  libnova = callPackage ../development/libraries/libnova { };

  libnxml = callPackage ../development/libraries/libnxml { };

  libodfgen = callPackage ../development/libraries/libodfgen { };

  libofa = callPackage ../development/libraries/libofa { };

  libofx = callPackage ../development/libraries/libofx { };

  libogg = callPackage ../development/libraries/libogg { };

  liboggz = callPackage ../development/libraries/liboggz { };

  liboil = callPackage ../development/libraries/liboil { };

  libomxil-bellagio = callPackage ../development/libraries/libomxil-bellagio { };

  liboop = callPackage ../development/libraries/liboop { };

  libopus = callPackage ../development/libraries/libopus { };

  libosinfo = callPackage ../development/libraries/libosinfo {
    inherit (gnome3) libsoup;
  };

  libosip = callPackage ../development/libraries/osip {};

  libosip_3 = callPackage ../development/libraries/osip/3.nix {};

  libosmocore = callPackage ../applications/misc/libosmocore { };

  libosmpbf = callPackage ../development/libraries/libosmpbf {};

  libotr = callPackage ../development/libraries/libotr { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpipeline = callPackage ../development/libraries/libpipeline { };

  libpgf = callPackage ../development/libraries/libpgf { };

  libphonenumber = callPackage ../development/libraries/libphonenumber { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libpaper = callPackage ../development/libraries/libpaper { };

  libpfm = callPackage ../development/libraries/libpfm { };

  libpqxx = callPackage ../development/libraries/libpqxx { };

  libproxy = callPackage ../development/libraries/libproxy {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation JavaScriptCore;
  };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libpsl = callPackage ../development/libraries/libpsl { };

  libpst = callPackage ../development/libraries/libpst { };

  libpwquality = callPackage ../development/libraries/libpwquality { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  libroxml = callPackage ../development/libraries/libroxml { };

  librsvg = callPackage ../development/libraries/librsvg { };

  librsync = callPackage ../development/libraries/librsync { };

  librsync_0_9 = callPackage ../development/libraries/librsync/0.9.nix { };

  libs3 = callPackage ../development/libraries/libs3 { };

  libsearpc = callPackage ../development/libraries/libsearpc { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  libsndfile = callPackage ../development/libraries/libsndfile {
    inherit (darwin.apple_sdk.frameworks) Carbon AudioToolbox;
  };

  libsnark = callPackage ../development/libraries/libsnark { };

  libsodium = callPackage ../development/libraries/libsodium { };

  libsoup = callPackage ../development/libraries/libsoup { };

  libspiro = callPackage ../development/libraries/libspiro {};

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libstemmer = callPackage ../development/libraries/libstemmer { };

  libstroke = callPackage ../development/libraries/libstroke { };

  libstrophe = callPackage ../development/libraries/libstrophe { };

  libspatialindex = callPackage ../development/libraries/libspatialindex { };

  libspatialite = callPackage ../development/libraries/libspatialite { };

  libstatgrab = callPackage ../development/libraries/libstatgrab {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libsvm = callPackage ../development/libraries/libsvm { };

  libtar = callPackage ../development/libraries/libtar { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtcod = callPackage ../development/libraries/libtcod { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtiger = callPackage ../development/libraries/libtiger { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libtomcrypt = callPackage ../development/libraries/libtomcrypt { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar { };

  # this is still the new version of the old API
  libtoxcore-new = callPackage ../development/libraries/libtoxcore/new-api.nix { };

  inherit (callPackages ../development/libraries/libtoxcore {})
    libtoxcore_0_1 libtoxcore_0_2;
  libtoxcore = libtoxcore_0_2;

  libtap = callPackage ../development/libraries/libtap { };

  libtsm = callPackage ../development/libraries/libtsm { };

  libtxc_dxtn = callPackage ../development/libraries/libtxc_dxtn { };

  libtxc_dxtn_s2tc = callPackage ../development/libraries/libtxc_dxtn_s2tc { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libu2f-host = callPackage ../development/libraries/libu2f-host { };

  libu2f-server = callPackage ../development/libraries/libu2f-server { };

  libubox = callPackage ../development/libraries/libubox { };

  libuecc = callPackage ../development/libraries/libuecc { };

  libui = callPackage ../development/libraries/libui { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  libwhereami = callPackage ../development/libraries/libwhereami { };

  giflib = giflib_5_1;
  giflib_4_1 = callPackage ../development/libraries/giflib/4.1.nix { };
  giflib_5_1 = callPackage ../development/libraries/giflib/5.1.nix { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunibreak = callPackage ../development/libraries/libunibreak { };

  libunique = callPackage ../development/libraries/libunique { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { inherit (gnome2) gtkdoc; };

  liburcu = callPackage ../development/libraries/liburcu { };

  libusb = callPackage ../development/libraries/libusb {};

  libusb1 = callPackage ../development/libraries/libusb1 {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libusbmuxd = callPackage ../development/libraries/libusbmuxd { };

  libutempter = callPackage ../development/libraries/libutempter { };

  libunwind = if stdenv.isDarwin
    then darwin.libunwind
    else callPackage ../development/libraries/libunwind { };

  libuv = callPackage ../development/libraries/libuv { };

  libv4l = lowPrio (v4l_utils.override {
    withUtils = false;
  });

  libva = callPackage ../development/libraries/libva { };
  libva-minimal = libva.override { minimal = true; };
  libva-utils = callPackage ../development/libraries/libva-utils { };

  libva1 = callPackage ../development/libraries/libva/1.0.0.nix { };
  libva1-minimal = libva1.override { minimal = true; };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libvdpau-va-gl = callPackage ../development/libraries/libvdpau-va-gl { };

  libversion = callPackage ../development/libraries/libversion { };

  libvirt = callPackage ../development/libraries/libvirt { };

  libvirt-glib = callPackage ../development/libraries/libvirt-glib { };

  libvisio = callPackage ../development/libraries/libvisio { };

  libvisual = callPackage ../development/libraries/libvisual { };

  libvncserver = callPackage ../development/libraries/libvncserver {};

  libviper = callPackage ../development/libraries/libviper { };

  libvpx = callPackage ../development/libraries/libvpx { };
  libvpx-git = callPackage ../development/libraries/libvpx/git.nix { };

  libvterm = callPackage ../development/libraries/libvterm { };
  libvterm-neovim = callPackage ../development/libraries/libvterm-neovim { };

  libvorbis = callPackage ../development/libraries/libvorbis { };

  libwebcam = callPackage ../os-specific/linux/libwebcam { };

  libwebp = callPackage ../development/libraries/libwebp { };

  libwmf = callPackage ../development/libraries/libwmf { };

  libwnck = libwnck2;
  libwnck2 = callPackage ../development/libraries/libwnck { };
  libwnck3 = callPackage ../development/libraries/libwnck/3.x.nix { };

  libwpd = callPackage ../development/libraries/libwpd { };

  libwpd_08 = callPackage ../development/libraries/libwpd/0.8.nix { };

  libwps = callPackage ../development/libraries/libwps { };

  libwpg = callPackage ../development/libraries/libwpg { };

  libx86 = callPackage ../development/libraries/libx86 {};

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

  libxkbcommon = callPackage ../development/libraries/libxkbcommon { };

  libxklavier = callPackage ../development/libraries/libxklavier { };

  libxls = callPackage ../development/libraries/libxls { };

  libxmi = callPackage ../development/libraries/libxmi { };

  libxml2 = callPackage ../development/libraries/libxml2 { };

  libxml2Python = pkgs.buildEnv { # slightly hacky
    name = "libxml2+py-${self.libxml2.version}";
    paths = with libxml2; [ dev bin py ];
    inherit (libxml2) passthru;
    # the hook to find catalogs is hidden by buildEnv
    postBuild = ''
      mkdir "$out/nix-support"
      cp '${libxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
    '';
  };

  libxmlxx = callPackage ../development/libraries/libxmlxx { };
  libxmlxx3 = callPackage ../development/libraries/libxmlxx/v3.nix { };

  libxmp = callPackage ../development/libraries/libxmp { };

  libxslt = callPackage ../development/libraries/libxslt { };

  libixp_hg = callPackage ../development/libraries/libixp-hg { };

  libyaml = callPackage ../development/libraries/libyaml { };

  libyamlcpp = callPackage ../development/libraries/libyaml-cpp { };

  libyamlcpp_0_3 = pkgs.libyamlcpp.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchurl {
      url = "https://github.com/jbeder/yaml-cpp/archive/release-0.3.0.tar.gz";
      sha256 = "12aszqw6svwlnb6nzhsbqhz3c7vnd5ahd0k6xlj05w8lm83hx3db";
      };
  });

  libykneomgr = callPackage ../development/libraries/libykneomgr { };

  libytnef = callPackage ../development/libraries/libytnef { };

  libyubikey = callPackage ../development/libraries/libyubikey { };

  libzen = callPackage ../development/libraries/libzen { };

  libzip = callPackage ../development/libraries/libzip { };

  libzdb = callPackage ../development/libraries/libzdb { };

  libwacom = callPackage ../development/libraries/libwacom { };

  lightning = callPackage ../development/libraries/lightning { };

  lightlocker = callPackage ../misc/screensavers/light-locker { };

  lightstep-tracer-cpp = callPackage ../development/libraries/lightstep-tracer-cpp { };

  linenoise = callPackage ../development/libraries/linenoise { };

  linenoise-ng = callPackage ../development/libraries/linenoise-ng { };

  lirc = callPackage ../development/libraries/lirc { };

  liquid-dsp = callPackage ../development/libraries/liquid-dsp { };

  liquidfun = callPackage ../development/libraries/liquidfun { };

  live555 = callPackage ../development/libraries/live555 { };

  loadcaffe = callPackage ../development/libraries/loadcaffe {};

  log4cpp = callPackage ../development/libraries/log4cpp { };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  log4cplus = callPackage ../development/libraries/log4cplus { };

  log4shib = callPackage ../development/libraries/log4shib { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = luabind.override { lua = luajit; };

  luaffi = callPackage ../development/libraries/luaffi { lua = lua5_1; };

  lzo = callPackage ../development/libraries/lzo { };

  mapnik = callPackage ../development/libraries/mapnik { };

  marisa = callPackage ../development/libraries/marisa {};

  matio = callPackage ../development/libraries/matio { };

  mbedtls = callPackage ../development/libraries/mbedtls { };
  mbedtls_1_3 = callPackage ../development/libraries/mbedtls/1.3.nix { };
  polarssl = mbedtls; # TODO: add to aliases.nix

  mdds_0_7_1 = callPackage ../development/libraries/mdds/0.7.1.nix { };
  mdds_0_12_1 = callPackage ../development/libraries/mdds/0.12.1.nix { };
  mdds = callPackage ../development/libraries/mdds { };

  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  menu-cache = callPackage ../development/libraries/menu-cache { };

  mergerfs = callPackage ../tools/filesystems/mergerfs { };

  mergerfs-tools = callPackage ../tools/filesystems/mergerfs/tools.nix { };

  ## libGL/libGLU/Mesa stuff

  # Default libGL implementation, should provide headers and libGL.so/libEGL.so/... to link agains them
  libGL = libGLDarwinOr mesa_noglu.stubs;

  # Default libGLU
  libGLU = libGLDarwinOr mesa_glu;

  # Combined derivation, contains both libGL and libGLU
  # Please, avoid using this attribute.  It was meant as transitional hack
  # for packages that assume that libGLU and libGL live in the same prefix.
  # libGLU_combined propagates both libGL and libGLU
  libGLU_combined = libGLDarwinOr (buildEnv {
    name = "libGLU-combined";
    paths = [ libGL libGLU ];
    extraOutputsToInstall = [ "dev" ];
  });

  # Default derivation with libGL.so.1 to link into /run/opengl-drivers (if need)
  libGL_driver = libGLDarwinOr mesa_drivers;

  libGLSupported = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;

  libGLDarwin = callPackage ../development/libraries/mesa-darwin {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    inherit (darwin.apple_sdk.libs) Xplugin;
    inherit (darwin) apple_sdk;
  };

  libGLDarwinOr = alternative: if stdenv.isDarwin then libGLDarwin else alternative;

  mesa_noglu = callPackage ../development/libraries/mesa {
    llvmPackages = llvmPackages_6;
  };

  mesa_glu =  callPackage ../development/libraries/mesa-glu { };

  # NOTE: 2018-07-12: legacy alias:
  # gcsecurity bussiness is done: https://www.theregister.co.uk/2018/02/08/bruce_perens_grsecurity_anti_slapp/
  # floating point textures patents are expired,
  # so package reduced to alias
  mesa_drivers = mesa_noglu.drivers;

  ## End libGL/libGLU/Mesa stuff

  meterbridge = callPackage ../applications/audio/meterbridge { };

  mhddfs = callPackage ../tools/filesystems/mhddfs { };

  microsoft_gsl = callPackage ../development/libraries/microsoft_gsl { };

  minizip = callPackage ../development/libraries/minizip { };

  miro = callPackage ../applications/video/miro {
    avahi = avahi.override {
      withLibdnssdCompat = true;
    };
    ffmpeg = ffmpeg_2;
  };

  mkvtoolnix = libsForQt5.callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = callPackage ../applications/video/mkvtoolnix {
    withGUI = false;
  };

  mlt = callPackage ../development/libraries/mlt {};

  mono-addins = callPackage ../development/libraries/mono-addins { };

  mono-zeroconf = callPackage ../development/libraries/mono-zeroconf { };

  movit = callPackage ../development/libraries/movit { };

  mosquitto = callPackage ../servers/mqtt/mosquitto { };

  mps = callPackage ../development/libraries/mps { };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  mqtt-bench = callPackage ../applications/misc/mqtt-bench {};

  msgpack = callPackage ../development/libraries/msgpack { };

  msilbc = callPackage ../development/libraries/msilbc { };

  mp4v2 = callPackage ../development/libraries/mp4v2 { };

  libmpc = callPackage ../development/libraries/libmpc { };

  mpich = callPackage ../development/libraries/mpich { };

  mstpd = callPackage ../os-specific/linux/mstpd { };

  mtdev = callPackage ../development/libraries/mtdev { };

  mtpfs = callPackage ../tools/filesystems/mtpfs { };

  mtxclient = callPackage ../development/libraries/mtxclient { };

  mu = callPackage ../tools/networking/mu {
    texinfo = texinfo4;
  };

  mueval = callPackage ../development/tools/haskell/mueval { };

  muparser = callPackage ../development/libraries/muparser { };

  mygpoclient = pythonPackages.mygpoclient;

  mygui = callPackage ../development/libraries/mygui {
    ogre = ogre1_9;
  };

  mysocketw = callPackage ../development/libraries/mysocketw { };

  mythes = callPackage ../development/libraries/mythes { };

  nanoflann = callPackage ../development/libraries/nanoflann { };

  nanomsg = callPackage ../development/libraries/nanomsg { };

  ndpi = callPackage ../development/libraries/ndpi { };

  nifticlib = callPackage ../development/libraries/science/biology/nifticlib { };

  notify-sharp = callPackage ../development/libraries/notify-sharp { };

  ncurses5 = ncurses.override {
    abiVersion = "5";
  };
  ncurses6 = ncurses.override {
    abiVersion = "6";
  };
  ncurses =
    if stdenv.hostPlatform.useiOSPrebuilt
    then null
    else callPackage ../development/libraries/ncurses { };

  neardal = callPackage ../development/libraries/neardal { };

  neon = callPackage ../development/libraries/neon { };

  neon_0_29 = callPackage ../development/libraries/neon/0.29.nix { };

  nettle = callPackage ../development/libraries/nettle { };

  newt = callPackage ../development/libraries/newt { };

  nghttp2 = callPackage ../development/libraries/nghttp2 {
    fetchurl = fetchurlBoot;
  };
  libnghttp2 = nghttp2.lib;

  nix-plugins = callPackage ../development/libraries/nix-plugins {};

  nlohmann_json = callPackage ../development/libraries/nlohmann_json { };

  nntp-proxy = callPackage ../applications/networking/nntp-proxy { };

  non = callPackage ../applications/audio/non { };

  ntl = callPackage ../development/libraries/ntl { };

  nspr = callPackage ../development/libraries/nspr {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  nss = lowPrio (callPackage ../development/libraries/nss { });
  nssTools = nss.tools;

  nss_wrapper = callPackage ../development/libraries/nss_wrapper { };

  nsss = skawarePackages.nsss;

  ntbtls = callPackage ../development/libraries/ntbtls { };

  ntk = callPackage ../development/libraries/audio/ntk { };

  ntrack = callPackage ../development/libraries/ntrack { };

  nvidia-texture-tools = callPackage ../development/libraries/nvidia-texture-tools { };

  nvidia-video-sdk = callPackage ../development/libraries/nvidia-video-sdk { };

  nvtop = callPackage ../tools/system/nvtop {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  ocl-icd-oclhGen = oclh: callPackage ../development/libraries/ocl-icd { opencl-headers = oclh; };
  ocl-icd-oclh_1_2 = ocl-icd-oclhGen opencl-headers_1_2;
  ocl-icd-oclh_2_2 = ocl-icd-oclhGen opencl-headers_2_2;
  ocl-icd = ocl-icd-oclh_2_2;

  ode = callPackage ../development/libraries/ode { };

  ogre = callPackage ../development/libraries/ogre {};
  ogre1_9 = callPackage ../development/libraries/ogre/1.9.x.nix {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  olm = callPackage ../development/libraries/olm { };

  oneko = callPackage ../applications/misc/oneko { };

  oniguruma = callPackage ../development/libraries/oniguruma { };

  oobicpl = callPackage ../development/libraries/science/biology/oobicpl { };

  openalSoft = callPackage ../development/libraries/openal-soft {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };
  openal = openalSoft;

  openbabel = callPackage ../development/libraries/openbabel { };

  opencascade = callPackage ../development/libraries/opencascade { };

  opencl-headersGen = v: callPackage ../development/libraries/opencl-headers { version = v; };
  opencl-headers_1_2 = opencl-headersGen "12";
  opencl-headers_2_2 = opencl-headersGen "22";
  opencl-headers = opencl-headers_2_2;

  opencl-clhpp = callPackage ../development/libraries/opencl-clhpp { };

  opencollada = callPackage ../development/libraries/opencollada { };

  opencore-amr = callPackage ../development/libraries/opencore-amr { };

  opencsg = callPackage ../development/libraries/opencsg { };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv {
    ffmpeg = ffmpeg_2;
  };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix {
    enableCuda = config.cudaSupport or false;
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa QTKit VideoDecodeAcceleration;
  };

  opencv3WithoutCuda = opencv3.override {
    enableCuda = false;
  };

  openexr = callPackage ../development/libraries/openexr { };

  openexrid-unstable = callPackage ../development/libraries/openexrid-unstable { };

  openldap = callPackage ../development/libraries/openldap { };

  opencolorio = callPackage ../development/libraries/opencolorio { };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {
    ffmpeg = ffmpeg_2;
    stdenv = overrideCC stdenv gcc6;
  };

  openh264 = callPackage ../development/libraries/openh264 { };

  openjpeg_1 = callPackage ../development/libraries/openjpeg/1.x.nix { };
  openjpeg_2_1 = callPackage ../development/libraries/openjpeg/2.1.nix { };
  openjpeg = openjpeg_2_1;

  openpa = callPackage ../development/libraries/openpa { };

  opensaml-cpp = callPackage ../development/libraries/opensaml-cpp { };

  openscenegraph = callPackage ../development/libraries/openscenegraph { };

  openslp = callPackage ../development/libraries/openslp {};

  openvdb = callPackage ../development/libraries/openvdb {};

  inherit (callPackages ../development/libraries/libressl { })
    libressl_2_6
    libressl_2_7
    libressl_2_8;

  libressl = libressl_2_7;

  boringssl = callPackage ../development/libraries/boringssl { };

  wolfssl = callPackage ../development/libraries/wolfssl { };

  openssl = openssl_1_0_2;

  inherit (callPackages ../development/libraries/openssl {
      fetchurl = fetchurlBoot;
      cryptodevHeaders = linuxPackages.cryptodev.override {
        fetchurl = fetchurlBoot;
        onlyHeaders = true;
      };
    })
    openssl_1_0_2
    openssl_1_1;

  openssl-chacha = callPackage ../development/libraries/openssl/chacha.nix {
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  opensubdiv = callPackage ../development/libraries/opensubdiv {
    cudaSupport = config.cudaSupport or false;
    cmake = cmake_2_8;
  };

  open-wbo = callPackage ../applications/science/logic/open-wbo {};

  openwsman = callPackage ../development/libraries/openwsman {};

  ortp = callPackage ../development/libraries/ortp { };

  openrct2 = callPackage ../games/openrct2 { };

  osm-gps-map = callPackage ../development/libraries/osm-gps-map { };

  osinfo-db = callPackage ../data/misc/osinfo-db { };
  osinfo-db-tools = callPackage ../tools/misc/osinfo-db-tools { };

  p11-kit = callPackage ../development/libraries/p11-kit { };

  paperkey = callPackage ../tools/security/paperkey { };

  parquet-cpp = callPackage ../development/libraries/parquet-cpp {};

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcaudiolib = callPackage ../development/libraries/pcaudiolib {
    pulseaudioSupport = config.pulseaudio or true;
  };

  pcg_c = callPackage ../development/libraries/pcg-c { };

  pcl = libsForQt5.callPackage ../development/libraries/pcl {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL OpenGL;
  };

  pcre = callPackage ../development/libraries/pcre { };
  pcre16 = self.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = self.pcre.override { variant = "cpp"; };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  pg_repack = callPackage ../servers/sql/postgresql/pg_repack {};

  pg_similarity = callPackage ../servers/sql/postgresql/pg_similarity {};

  pg_tmp = callPackage ../development/tools/database/pg_tmp { };

  pgroonga = callPackage ../servers/sql/postgresql/pgroonga {};

  plv8 = callPackage ../servers/sql/postgresql/plv8 {
    v8 = v8_6_x;
  };

  phonon = callPackage ../development/libraries/phonon {};

  phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix {};

  # TODO(@Ma27) get rid of that as soon as QT4 can be dropped
  phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix {
    withQt4 = true;
  };

  inherit (callPackage ../development/libraries/physfs { })
    physfs_2
    physfs;

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wine-staging = pkgsi686Linux.wine-staging;
  };

  pkcs11helper = callPackage ../development/libraries/pkcs11helper { };

  plib = callPackage ../development/libraries/plib { };

  pocketsphinx = callPackage ../development/libraries/pocketsphinx { };

  poco = callPackage ../development/libraries/poco { };

  podofo = callPackage ../development/libraries/podofo { lua5 = lua5_1; };

  poker-eval = callPackage ../development/libraries/poker-eval { };

  polkit = callPackage ../development/libraries/polkit { };

  polkit_qt4 = callPackage ../development/libraries/polkit-qt-1/qt-4.nix { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };
  poppler_0_61 = callPackage ../development/libraries/poppler/0.61.nix { lcms = lcms2; };

  poppler_gi = lowPrio (poppler.override {
    introspectionSupport = true;
  });

  poppler_min = poppler.override { # TODO: maybe reduce even more
    # this is currently only used by texlive.bin.
    minimal = true;
    suffix = "min";
  };

  poppler_utils = poppler.override { suffix = "utils"; utils = true; };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreAudio CoreServices Carbon;
  };

  portaudio2014 = portaudio.overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz;
      sha256 = "0mwddk4qzybaf85wqfhxqlf0c5im9il8z03rd4n127k8y2jj9q4g";
    };
  });

  portmidi = callPackage ../development/libraries/portmidi {};

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  proselint = callPackage ../tools/text/proselint {
    inherit (python3Packages)
    buildPythonApplication click future six;
  };

  postgis = callPackage ../development/libraries/postgis { };

  protobuf = protobuf3_4;

  protobuf3_5 = callPackage ../development/libraries/protobuf/3.5.nix { };
  protobuf3_4 = callPackage ../development/libraries/protobuf/3.4.nix { };
  protobuf3_1 = callPackage ../development/libraries/protobuf/3.1.nix { };
  protobuf2_5 = callPackage ../development/libraries/protobuf/2.5.nix { };

  protobufc = callPackage ../development/libraries/protobufc/1.3.nix { };

  flatbuffers = callPackage ../development/libraries/flatbuffers { };

  gnupth = callPackage ../development/libraries/pth { };
  pth = if stdenv.hostPlatform.isMusl then npth else gnupth;

  ptlib = callPackage ../development/libraries/ptlib {};

  pugixml = callPackage ../development/libraries/pugixml { };

  pybind11 = callPackage ../development/libraries/pybind11 { };

  re2 = callPackage ../development/libraries/re2 { };

  qbs = callPackage ../development/tools/build-managers/qbs { };

  qca2 = callPackage ../development/libraries/qca2 { qt = qt4; };
  qca2-qt5 = qca2.override { qt = qt5.qtbase; };

  qimageblitz = callPackage ../development/libraries/qimageblitz {};

  qjson = callPackage ../development/libraries/qjson { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = libGLSupported;
    libpng = libpng12;
  };

  qt4 = qt48;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (pkgs.gnome2) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # XXX: mariadb doesn't built on fbsd as of nov 2015
    mysql = if (!stdenv.isFreeBSD) then mysql else null;

    inherit (pkgs.darwin) cf-private libobjc;
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices OpenGL Cocoa AGL;
  };

  qmake48Hook = makeSetupHook
    { substitutions = { qt4 = qt48; }; }
    ../development/libraries/qt-4.x/4.8/qmake-hook.sh;

  qmake4Hook = qmake48Hook;

  qt48Full = appendToName "full" (qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  });

  qt56 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.6) {
      inherit newScope;
      inherit stdenv fetchurl makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (gst_all_1) gstreamer gst-plugins-base;
    });

  libsForQt56 = lib.makeScope qt56.newScope mkLibsForQt5;

  qt59 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.9) {
      inherit newScope;
      inherit stdenv fetchurl makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit (gnome3) gtk3 dconf;
    });

  libsForQt59 = lib.makeScope qt59.newScope mkLibsForQt5;

  qt511 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.11) {
      inherit newScope;
      inherit stdenv fetchurl fetchFromGitHub makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit (gnome3) gtk3 dconf;
    });

  libsForQt511 = recurseIntoAttrs (lib.makeScope qt511.newScope mkLibsForQt5);

  qt5 = qt511;
  libsForQt5 = libsForQt511;

  qt5ct = libsForQt5.callPackage ../tools/misc/qt5ct { };

  mkLibsForQt5 = self: with self; {

    ### KDE FRAMEWORKS

    inherit (kdeFrameworks.override { libsForQt5 = self; })
      attica baloo bluez-qt kactivities kactivities-stats
      karchive kauth kbookmarks kcmutils kcodecs kcompletion kconfig
      kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kdelibs4support
      kdesignerplugin kdnssd kemoticons kfilemetadata kglobalaccel kguiaddons
      khtml ki18n kiconthemes kidletime kimageformats kio kitemmodels kitemviews
      kjobwidgets kjs kjsembed kmediaplayer knewstuff knotifications
      knotifyconfig kpackage kparts kpeople kplotting kpty kross krunner
      kservice ktexteditor ktextwidgets kunitconversion kwallet kwayland
      kwidgetsaddons kwindowsystem kxmlgui kxmlrpcclient modemmanager-qt
      networkmanager-qt plasma-framework prison solid sonnet syntax-highlighting
      syndication threadweaver kirigami2 kholidays kpurpose;

    ### KDE PLASMA 5

    inherit (plasma5.override { libsForQt5 = self; })
      kdecoration khotkeys libkscreen libksysguard;

    ### KDE APPLICATIONS

    inherit (kdeApplications.override { libsForQt5 = self; })
      libkdcraw libkexiv2 libkipi libkomparediff2 libksane;

    ### LIBRARIES

    accounts-qt = callPackage ../development/libraries/accounts-qt { };

    alkimia = callPackage ../development/libraries/alkimia { };

    fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

    qgpgme = callPackage ../development/libraries/gpgme { };

    grantlee = callPackage ../development/libraries/grantlee/5 { };

    kdb = callPackage ../development/libraries/kdb { };

    kdiagram = callPackage ../development/libraries/kdiagram { };

    kproperty = callPackage ../development/libraries/kproperty { };

    kreport = callPackage ../development/libraries/kreport { };

    libcommuni = callPackage ../development/libraries/libcommuni { };

    libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

    libkeyfinder = callPackage ../development/libraries/libkeyfinder { };

    libktorrent = callPackage ../development/libraries/libktorrent { };

    libopenshot = callPackage ../applications/video/openshot-qt/libopenshot.nix { };

    libopenshot-audio = callPackage ../applications/video/openshot-qt/libopenshot-audio.nix { };

    libqtav = callPackage ../development/libraries/libqtav { };

    kpmcore = callPackage ../development/libraries/kpmcore { };

    mlt = callPackage ../development/libraries/mlt/qt-5.nix {
      ffmpeg = ffmpeg_2;
    };

    openbr = callPackage ../development/libraries/openbr { };

    phonon = callPackage ../development/libraries/phonon {
      withQt5 = true;
    };

    phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix {
      withQt5 = true;
    };

    phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix { };

    polkit-qt = callPackage ../development/libraries/polkit-qt-1/qt-5.nix { };

    poppler = callPackage ../development/libraries/poppler {
      lcms = lcms2;
      qt5Support = true;
      suffix = "qt5";
    };

    qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

    qmltermwidget = callPackage ../development/libraries/qmltermwidget { };
    qmlbox2d = libsForQt59.callPackage ../development/libraries/qmlbox2d { };

    qscintilla = callPackage ../development/libraries/qscintilla {
      withQt5 = true;
    };

    qtinstaller = callPackage ../development/libraries/qtinstaller { };

    qtkeychain = callPackage ../development/libraries/qtkeychain {
      withQt5 = true;
    };

    qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

    qtstyleplugin-kvantum = libsForQt5.callPackage ../development/libraries/qtstyleplugin-kvantum { };

    quazip = callPackage ../development/libraries/quazip { };

    qwt = callPackage ../development/libraries/qwt/6.nix { };

    telepathy = callPackage ../development/libraries/telepathy/qt { };

    vlc = callPackage ../applications/video/vlc {};

    qtwebkit-plugins = callPackage ../development/libraries/qtwebkit-plugins { };

  };

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qtkeychain = callPackage ../development/libraries/qtkeychain { };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  quickder = callPackage ../development/libraries/quickder {};

  quicksynergy = callPackage ../applications/misc/quicksynergy { };

  qwt = callPackage ../development/libraries/qwt {};

  qwt6_qt4 = callPackage ../development/libraries/qwt/6_qt4.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  qxt = callPackage ../development/libraries/qxt {};

  rabbitmq-c = callPackage ../development/libraries/rabbitmq-c {};

  range-v3 = callPackage ../development/libraries/range-v3 {};

  rabbitmq-java-client = callPackage ../development/libraries/rabbitmq-java-client {};

  rapidjson = callPackage ../development/libraries/rapidjson {};

  raul = callPackage ../development/libraries/audio/raul { };

  readline = readline6;
  readline6 = readline63;

  readline5 = callPackage ../development/libraries/readline/5.x.nix { };

  readline62 = callPackage ../development/libraries/readline/6.2.nix { };

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  readosm = callPackage ../development/libraries/readosm { };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskellLib = haskell.lib;
  };

  lambda-mod-zsh-theme = callPackage ../shells/zsh/lambda-mod-zsh-theme { };

  leksah = callPackage ../development/tools/haskell/leksah {
    inherit (haskellPackages) ghcWithPackages;
  };

  libgme = callPackage ../development/libraries/audio/libgme { };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };
  redland = librdf_redland; # added 2018-04-25

  librdf = callPackage ../development/libraries/librdf { };
  liblrdf = librdf; # added 2018-04-25

  libsmf = callPackage ../development/libraries/audio/libsmf { };

  lilv = callPackage ../development/libraries/audio/lilv { };

  lv2 = callPackage ../development/libraries/audio/lv2 { };
  lv2Unstable = callPackage ../development/libraries/audio/lv2/unstable.nix { };

  lvtk = callPackage ../development/libraries/audio/lvtk { };

  qradiolink = callPackage ../applications/misc/qradiolink { };

  qrupdate = callPackage ../development/libraries/qrupdate { };

  resolv_wrapper = callPackage ../development/libraries/resolv_wrapper { };

  rhino = callPackage ../development/libraries/java/rhino {
    javac = jdk;
    jvm = jre;
  };

  rlog = callPackage ../development/libraries/rlog { };

  rocksdb = callPackage ../development/libraries/rocksdb { jemalloc = jemalloc450; };

  rocksdb_lite = rocksdb.override { enableLite = true; };

  rote = callPackage ../development/libraries/rote { };

  ronn = callPackage ../development/tools/ronn { };

  rshell = python3.pkgs.callPackage ../development/tools/rshell { };

  rubberband = callPackage ../development/libraries/rubberband {
    inherit (vamp) vampSDK;
  };

  sad = callPackage ../applications/science/logic/sad { };

  safefile = callPackage ../development/libraries/safefile {};

  sbc = callPackage ../development/libraries/sbc { };

  schroedinger = callPackage ../development/libraries/schroedinger { };

  SDL = callPackage ../development/libraries/SDL {
    openglSupport = libGLSupported;
    alsaSupport = stdenv.isLinux;
    x11Support = !stdenv.isCygwin;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa;
  };

  SDL_sixel = callPackage ../development/libraries/SDL_sixel { };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_image = callPackage ../development/libraries/SDL_image { };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_stretch= callPackage ../development/libraries/SDL_stretch { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  SDL2 = callPackage ../development/libraries/SDL2 {
    openglSupport = libGLSupported;
    alsaSupport = stdenv.isLinux;
    x11Support = !stdenv.isCygwin;
    waylandSupport = stdenv.isLinux;
    udevSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };

  SDL2_net = callPackage ../development/libraries/SDL2_net { };

  SDL2_gfx = callPackage ../development/libraries/SDL2_gfx { };

  SDL2_ttf = callPackage ../development/libraries/SDL2_ttf { };

  sblim-sfcc = callPackage ../development/libraries/sblim-sfcc {};

  selinux-sandbox = callPackage ../os-specific/linux/selinux-sandbox { };

  serd = callPackage ../development/libraries/serd {};

  serf = callPackage ../development/libraries/serf {};

  sfsexp = callPackage ../development/libraries/sfsexp {};

  shhmsg = callPackage ../development/libraries/shhmsg { };

  shhopt = callPackage ../development/libraries/shhopt { };

  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix {};

  simavr = callPackage ../development/tools/simavr { };

  simgear = callPackage ../development/libraries/simgear { };

  simp_le = callPackage ../tools/admin/simp_le { };

  simpleitk = callPackage ../development/libraries/simpleitk { lua = lua51Packages.lua; };

  sfml = callPackage ../development/libraries/sfml {
    inherit (darwin.apple_sdk.frameworks) IOKit Foundation AppKit OpenAL;
  };
  csfml = callPackage ../development/libraries/csfml { };

  shapelib = callPackage ../development/libraries/shapelib { };

  shibboleth-sp = callPackage ../development/libraries/shibboleth-sp { };

  skalibs = skawarePackages.skalibs;

  skawarePackages = recurseIntoAttrs {
    buildPackage = callPackage ../build-support/skaware/build-skaware-package.nix { };

    skalibs = callPackage ../development/libraries/skalibs { };
    execline = callPackage ../tools/misc/execline { };

    s6 = callPackage ../tools/system/s6 { };
    s6-dns = callPackage ../tools/networking/s6-dns { };
    s6-linux-utils = callPackage ../os-specific/linux/s6-linux-utils { };
    s6-networking = callPackage ../tools/networking/s6-networking { };
    s6-portable-utils = callPackage ../tools/misc/s6-portable-utils { };
    s6-rc = callPackage ../tools/system/s6-rc { };

    nsss = callPackage ../development/libraries/nsss { };
    utmps = callPackage ../development/libraries/utmps { };

  };

  skydive = callPackage ../tools/networking/skydive { };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
    texinfo = texinfo4; # otherwise erros: must be after `@defun' to use `@defunx'
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  smpeg2 = callPackage ../development/libraries/smpeg2 { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  snappy = callPackage ../development/libraries/snappy { };

  soapyairspy = callPackage ../applications/misc/soapyairspy { };

  soapybladerf = callPackage ../applications/misc/soapybladerf { };

  soapyhackrf = callPackage ../applications/misc/soapyhackrf { };

  soapysdr = callPackage ../applications/misc/soapysdr { inherit (python3Packages) python numpy; };

  soapyremote = callPackage ../applications/misc/soapyremote { };

  soapysdr-with-plugins = callPackage ../applications/misc/soapysdr {
    inherit (python3Packages) python numpy;
    extraPackages = [
      limesuite
      soapyairspy
      soapybladerf
      soapyhackrf
      soapyremote
      soapyuhd
    ];
  };

  soapyuhd = callPackage ../applications/misc/soapyuhd { };

  socket_wrapper = callPackage ../development/libraries/socket_wrapper { };

  sofia_sip = callPackage ../development/libraries/sofia-sip { };

  soil = callPackage ../development/libraries/soil { };

  sonic = callPackage ../development/libraries/sonic { };

  soprano = callPackage ../development/libraries/soprano { };

  soqt = callPackage ../development/libraries/soqt { };

  sord = callPackage ../development/libraries/sord {};

  soundtouch = callPackage ../development/libraries/soundtouch {};

  spandsp = callPackage ../development/libraries/spandsp {};

  spatialite_tools = callPackage ../development/libraries/spatialite-tools { };

  spdk = callPackage ../development/libraries/spdk { };

  speechd = callPackage ../development/libraries/speechd { };

  speech-tools = callPackage ../development/libraries/speech-tools {};

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  sphinxbase = callPackage ../development/libraries/sphinxbase { };

  sphinxsearch = callPackage ../servers/search/sphinxsearch { };

  spice = callPackage ../development/libraries/spice {
    celt = celt_0_5_1;
    inherit (pythonPackages) pyparsing;
  };

  spice-gtk = callPackage ../development/libraries/spice-gtk { };

  spice-protocol = callPackage ../development/libraries/spice-protocol { };

  spice-up = callPackage ../applications/office/spice-up { };

  sratom = callPackage ../development/libraries/audio/sratom { };

  srm = callPackage ../tools/security/srm { };

  srtp = callPackage ../development/libraries/srtp {
    libpcap = if stdenv.isLinux then libpcap else null;
  };

  stb = callPackage ../development/libraries/stb { };

  stxxl = callPackage ../development/libraries/stxxl { parallel = true; };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  sqlite-analyzer = lowPrio (callPackage ../development/libraries/sqlite/analyzer.nix { });

  sqlar = callPackage ../development/libraries/sqlite/sqlar.nix { };

  sqlite-interactive = appendToName "interactive" (sqlite.override { interactive = true; }).bin;

  sqlite-jdbc = callPackage ../servers/sql/sqlite/jdbc { };

  sqlcipher = lowPrio (callPackage ../development/libraries/sqlcipher {
    readline = null;
    ncurses = null;
  });

  stfl = callPackage ../development/libraries/stfl { };

  stlink = callPackage ../development/tools/misc/stlink { };

  steghide = callPackage ../tools/security/steghide {};

  stlport = callPackage ../development/libraries/stlport { };

  streamlink = callPackage ../applications/video/streamlink { pythonPackages = python3Packages; };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  subdl = callPackage ../applications/video/subdl { };

  subtitleeditor = callPackage ../applications/video/subtitleeditor { };

  suil = callPackage ../development/libraries/audio/suil { };

  suil-qt5 = suil.override {
    withQt4 = false;
    withQt5 = true;
  };
  suil-qt4 = suil.override {
    withQt4 = true;
    withQt5 = false;
  };

  sundials = callPackage ../development/libraries/sundials { };

  sutils = callPackage ../tools/misc/sutils { };

  svrcore = callPackage ../development/libraries/svrcore { };

  sword = callPackage ../development/libraries/sword { };

  biblesync = callPackage ../development/libraries/biblesync { };

  szip = callPackage ../development/libraries/szip { };

  t1lib = callPackage ../development/libraries/t1lib { };

  tachyon = callPackage ../development/libraries/tachyon {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  taglib = callPackage ../development/libraries/taglib { };
  taglib_1_9 = callPackage ../development/libraries/taglib/1.9.nix { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  taglib-sharp = callPackage ../development/libraries/taglib-sharp { };

  talloc = callPackage ../development/libraries/talloc {
    python = python2;
  };

  tclap = callPackage ../development/libraries/tclap {};

  tcllib = callPackage ../development/libraries/tcllib { };

  tcltls = callPackage ../development/libraries/tcltls { };

  tclx = callPackage ../development/libraries/tclx { };

  ntdb = callPackage ../development/libraries/ntdb {
    python = python2;
  };

  tdb = callPackage ../development/libraries/tdb {
    python = python2;
  };

  tecla = callPackage ../development/libraries/tecla { };

  tectonic = callPackage ../tools/typesetting/tectonic {
    harfbuzz = harfbuzzFull;
  };

  tepl = callPackage ../development/libraries/tepl { };

  telepathy-glib = callPackage ../development/libraries/telepathy/glib { };

  telepathy-farstream = callPackage ../development/libraries/telepathy/farstream {};

  telepathy-qt = callPackage ../development/libraries/telepathy/qt { qtbase = qt4; };

  tevent = callPackage ../development/libraries/tevent {
    python = python2;
  };

  tet = callPackage ../development/tools/misc/tet { };

  theft = callPackage ../development/libraries/theft { };

  thrift = callPackage ../development/libraries/thrift {
    inherit (pythonPackages) twisted;
  };

  tidyp = callPackage ../development/libraries/tidyp { };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tinyxml-2 = callPackage ../development/libraries/tinyxml-2 { };

  tiscamera = callPackage ../os-specific/linux/tiscamera { };

  tivodecode = callPackage ../applications/video/tivodecode { };

  tix = callPackage ../development/libraries/tix { };

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tnt = callPackage ../development/libraries/tnt { };

  tntnet = callPackage ../development/libraries/tntnet { };

  tntdb = callPackage ../development/libraries/tntdb { };

  kyotocabinet = callPackage ../development/libraries/kyotocabinet { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };

  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  torch = callPackage ../development/libraries/torch {
    openblas = openblasCompat;
  };

  torch-hdf5 = callPackage ../development/libraries/torch-hdf5 {};

  tremor = callPackage ../development/libraries/tremor { };

  twolame = callPackage ../development/libraries/twolame { };

  udns = callPackage ../development/libraries/udns { };

  uid_wrapper = callPackage ../development/libraries/uid_wrapper { };

  umockdev = callPackage ../development/libraries/umockdev {
    vala = vala_0_40;
  };

  unibilium = callPackage ../development/libraries/unibilium { };

  unicap = callPackage ../development/libraries/unicap {};

  unicon-lang = callPackage ../development/interpreters/unicon-lang {};

  tsocks = callPackage ../development/libraries/tsocks { };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers {});

  ustr = callPackage ../development/libraries/ustr { };

  usbredir = callPackage ../development/libraries/usbredir {
    libusb = libusb1;
  };

  uthash = callPackage ../development/libraries/uthash { };

  utmps = skawarePackages.utmps;

  ucommon = ucommon_openssl;

  ucommon_openssl = callPackage ../development/libraries/ucommon {
    gnutls = null;
  };

  ucommon_gnutls = lowPrio (ucommon.override {
    openssl = null;
    zlib = null;
    gnutls = gnutls;
  });

  # 3.14 is needed for R V8 module in ../development/r-modules/default.nix
  v8_3_14 = callPackage ../development/libraries/v8/3.14.nix {
    inherit (python2Packages) python gyp;
    cctools = darwin.cctools;
    stdenv = overrideCC stdenv gcc5;
  };

  v8_3_16_14 = callPackage ../development/libraries/v8/3.16.14.nix {
    inherit (python2Packages) python gyp;
    cctools = darwin.cctools;
    stdenv = if stdenv.isDarwin then stdenv else overrideCC stdenv gcc5;
  };

  v8_6_x = callPackage ../development/libraries/v8/6_x.nix {
    inherit (python2Packages) python;
  };

  v8 = callPackage ../development/libraries/v8 ({
    inherit (python2Packages) python gyp;
    icu = icu58; # v8-5.4.232 fails against icu4c-59.1
  } // lib.optionalAttrs stdenv.isLinux {
    # doesn't build with gcc7
    stdenv = overrideCC stdenv gcc6;
  });

  v8_static = lowPrio (self.v8.override { static = true; });

  vaapiIntel = callPackage ../development/libraries/vaapi-intel { };

  vaapi-intel-hybrid = callPackage ../development/libraries/vaapi-intel-hybrid { };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau { };

  vale = callPackage ../tools/text/vale { };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

  vcg = callPackage ../development/libraries/vcg { };

  vid-stab = callPackage ../development/libraries/vid-stab { };

  vigra = callPackage ../development/libraries/vigra { };

  vlock = callPackage ../misc/screensavers/vlock { };

  vmime = callPackage ../development/libraries/vmime { };

  vrb = callPackage ../development/libraries/vrb { };

  vrpn = callPackage ../development/libraries/vrpn { };

  vsqlite = callPackage ../development/libraries/vsqlite { };

  vtk = callPackage ../development/libraries/vtk {
    inherit (darwin) cf-private libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vulkan-headers = callPackage ../development/libraries/vulkan-headers { };
  vulkan-loader = callPackage ../development/libraries/vulkan-loader { };
  vulkan-tools = callPackage ../tools/graphics/vulkan-tools { };
  vulkan-validation-layers = callPackage ../development/tools/vulkan-validation-layers { };

  vtkWithQt4 = vtk.override { qtLib = qt4; };

  vxl = callPackage ../development/libraries/vxl {
    libpng = libpng12;
    stdenv = overrideCC stdenv gcc6; # upstream code incompatible with gcc7
  };

  wavpack = callPackage ../development/libraries/wavpack { };

  wayland = callPackage ../development/libraries/wayland { };

  wayland_1_9 = callPackage ../development/libraries/wayland/1.9.nix { };

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  webkit = webkitgtk;

  wcslib = callPackage ../development/libraries/wcslib { };

  webkitgtk = webkitgtk220x;

  webkitgtk24x-gtk3 = callPackage ../development/libraries/webkitgtk/2.4.nix {
    harfbuzz = harfbuzzFull.override {
      icu = icu58;
    };
    gst-plugins-base = gst_all_1.gst-plugins-base;
    inherit (darwin) libobjc;
  };

  webkitgtk220x = callPackage ../development/libraries/webkitgtk/2.20.nix {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = overrideCC stdenv gcc6;
  };

  webkitgtk24x-gtk2 = webkitgtk24x-gtk3.override {
    withGtk2 = true;
    enableIntrospection = false;
  };

  websocketpp = callPackage ../development/libraries/websocket++ { };

  webrtc-audio-processing = callPackage ../development/libraries/webrtc-audio-processing { };

  wildmidi = callPackage ../development/libraries/wildmidi { };

  wiredtiger = callPackage ../development/libraries/wiredtiger { };

  wt = wt4;
  inherit (callPackages ../development/libraries/wt {})
    wt3
    wt4;

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxwidgets/2.8 {
    inherit (gnome2) GConf;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxwidgets/2.9 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QuickTime;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK30 = callPackage ../development/libraries/wxwidgets/3.0 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK31 = callPackage ../development/libraries/wxwidgets/3.1 {};

  wxmac = callPackage ../development/libraries/wxwidgets/3.0/mac.nix {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel;
    inherit (darwin.stubs) setfile rez derez;
  };

  wxSVG = callPackage ../development/libraries/wxSVG {
    wxGTK = wxGTK30;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  x265 = callPackage ../development/libraries/x265 { };

  inherit (callPackages ../development/libraries/xapian { })
    xapian_1_2_22 xapian_1_4;
  xapian = xapian_1_4;

  xapian-omega = callPackage ../development/libraries/xapian/tools/omega {
    libmagic = file;
  };

  xavs = callPackage ../development/libraries/xavs { };

  Xaw3d = callPackage ../development/libraries/Xaw3d { };

  xbase = callPackage ../development/libraries/xbase { };

  xcb-util-cursor = xorg.xcbutilcursor;
  xcb-util-cursor-HEAD = callPackage ../development/libraries/xcb-util-cursor/HEAD.nix { };

  xcbutilxrm = callPackage ../servers/x11/xorg/xcb-util-xrm.nix { };

  xdo = callPackage ../tools/misc/xdo { };

  xineLib = callPackage ../development/libraries/xine-lib {
    ffmpeg = ffmpeg_2;
  };

  xautolock = callPackage ../misc/screensavers/xautolock { };

  xercesc = callPackage ../development/libraries/xercesc {};

  xalanc = callPackage ../development/libraries/xalanc {};

  xgboost = callPackage ../development/libraries/xgboost {
    cudaSupport = config.cudaSupport or false;
  };

  xgeometry-select = callPackage ../tools/X11/xgeometry-select { };

  # Avoid using this. It isn't really a wrapper anymore, but we keep the name.
  xlibsWrapper = callPackage ../development/libraries/xlibs-wrapper {
    packages = [
      freetype fontconfig xorg.xproto xorg.libX11 xorg.libXt
      xorg.libXft xorg.libXext xorg.libSM xorg.libICE
      xorg.xextproto
    ];
  };

  xmlrpc_c = callPackage ../development/libraries/xmlrpc-c { };

  xmlsec = callPackage ../development/libraries/xmlsec { };

  xml-security-c = callPackage ../development/libraries/xml-security-c { };

  xml-tooling-c = callPackage ../development/libraries/xml-tooling-c { };

  xlslib = callPackage ../development/libraries/xlslib { };

  xvidcore = callPackage ../development/libraries/xvidcore { };

  xxHash = callPackage ../development/libraries/xxHash {};

  xylib = callPackage ../development/libraries/xylib { };

  yajl = callPackage ../development/libraries/yajl { };

  yubioath-desktop = callPackage ../applications/misc/yubioath-desktop { };

  yubico-piv-tool = callPackage ../tools/misc/yubico-piv-tool { };

  yubikey-manager = callPackage ../tools/misc/yubikey-manager { };

  yubikey-neo-manager = callPackage ../tools/misc/yubikey-neo-manager { };

  yubikey-personalization = callPackage ../tools/misc/yubikey-personalization {
    libusb = libusb1;
  };

  yubikey-personalization-gui = libsForQt5.callPackage ../tools/misc/yubikey-personalization-gui { };

  zeitgeist = callPackage ../development/libraries/zeitgeist { };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  libdynd = callPackage ../development/libraries/libdynd { };

  zlog = callPackage ../development/libraries/zlog { };

  zlibStatic = lowPrio (appendToName "static" (zlib.override {
    static = true;
  }));

  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};
  zeromq4 = callPackage ../development/libraries/zeromq/4.x.nix {};
  zeromq = zeromq4;

  cppzmq = callPackage ../development/libraries/cppzmq {};

  czmq3 = callPackage ../development/libraries/czmq/3.x.nix {};
  czmq4 = callPackage ../development/libraries/czmq/4.x.nix {};
  czmq = czmq4;

  czmqpp = callPackage ../development/libraries/czmqpp {
    czmq = czmq3;
  };

  zmqpp = callPackage ../development/libraries/zmqpp { };

  zig = callPackage ../development/compilers/zig {
    llvmPackages = llvmPackages_6;
  };

  zimlib = callPackage ../development/libraries/zimlib { };

  zita-convolver = callPackage ../development/libraries/audio/zita-convolver { };

  zita-alsa-pcmi = callPackage ../development/libraries/audio/zita-alsa-pcmi { };

  zita-resampler = callPackage ../development/libraries/audio/zita-resampler { };

  zziplib = callPackage ../development/libraries/zziplib { };

  ### DEVELOPMENT / LIBRARIES / AGDA

  agda = callPackage ../build-support/agda {
    glibcLocales = if pkgs.stdenv.isLinux then pkgs.glibcLocales else null;
    extension = self : super : { };
    inherit (haskellPackages) Agda;
  };

  agdaBase = callPackage ../development/libraries/agda/agda-base { };

  agdaIowaStdlib = callPackage ../development/libraries/agda/agda-iowa-stdlib { };

  agdaPrelude = callPackage ../development/libraries/agda/agda-prelude { };

  AgdaStdlib = callPackage ../development/libraries/agda/agda-stdlib {
    inherit (haskellPackages) ghcWithPackages;
  };

  AgdaSheaves = callPackage ../development/libraries/agda/Agda-Sheaves { };

  bitvector = callPackage ../development/libraries/agda/bitvector { };

  categories = callPackage ../development/libraries/agda/categories { };

  pretty = callPackage ../development/libraries/agda/pretty { };

  TotalParserCombinators = callPackage ../development/libraries/agda/TotalParserCombinators { };

  ### DEVELOPMENT / LIBRARIES / JAVA

  commonsBcel = callPackage ../development/libraries/java/commons/bcel { };

  commonsBsf = callPackage ../development/libraries/java/commons/bsf { };

  commonsCompress = callPackage ../development/libraries/java/commons/compress { };

  commonsFileUpload = callPackage ../development/libraries/java/commons/fileupload { };

  commonsLang = callPackage ../development/libraries/java/commons/lang { };

  commonsLogging = callPackage ../development/libraries/java/commons/logging { };

  commonsIo = callPackage ../development/libraries/java/commons/io { };

  commonsMath = callPackage ../development/libraries/java/commons/math { };

  fastjar = callPackage ../development/tools/java/fastjar { };

  httpunit = callPackage ../development/libraries/java/httpunit { };

  gwtdragdrop = callPackage ../development/libraries/java/gwt-dragdrop { };

  gwtwidgets = callPackage ../development/libraries/java/gwt-widgets { };

  javaCup = callPackage ../development/libraries/java/cup { };

  jdom = callPackage ../development/libraries/java/jdom { };

  jflex = callPackage ../development/libraries/java/jflex { };

  junit = callPackage ../development/libraries/java/junit { antBuild = releaseTools.antBuild; };

  junixsocket = callPackage ../development/libraries/java/junixsocket { };

  jzmq = callPackage ../development/libraries/java/jzmq { };

  lombok = callPackage ../development/libraries/java/lombok { };

  lucene = callPackage ../development/libraries/java/lucene { };

  lucenepp = callPackage ../development/libraries/lucene++ {
    boost = boost155;
  };

  mockobjects = callPackage ../development/libraries/java/mockobjects { };

  saxonb = saxonb_8_8;

  inherit (callPackages ../development/libraries/java/saxon { })
    saxon
    saxonb_8_8
    saxonb_9_1
    saxon-he;

  smack = callPackage ../development/libraries/java/smack { };

  swt = callPackage ../development/libraries/java/swt {
    inherit (gnome2) libsoup;
  };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  yuicompressor = callPackage ../development/tools/yuicompressor { };

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO MODULES

  buildGo19Package = callPackage ../development/go-modules/generic {
    go = go_1_9;
  };
  buildGo110Package = callPackage ../development/go-modules/generic {
    go = go_1_10;
  };
  buildGo111Package = callPackage ../development/go-modules/generic {
    go = go_1_11;
  };

  buildGoPackage = buildGo111Package;

  go2nix = callPackage ../development/tools/go2nix { };

  leaps = callPackage ../development/tools/leaps { };

  ws = callPackage ../development/tools/ws { };

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

  clwrapperFunction = callPackage ../development/lisp-modules/clwrapper;

  wrapLisp = lisp: clwrapperFunction { inherit lisp; };

  lispPackagesFor = clwrapper: callPackage ../development/lisp-modules/lisp-packages.nix {
    inherit clwrapper;
  };

  lispPackages = recurseIntoAttrs (quicklispPackages_asdf_3_1 //
    lispPackagesFor ((wrapLisp sbcl).override { asdf = asdf_3_1; }));

  quicklispPackagesFor = clwrapper: callPackage ../development/lisp-modules/quicklisp-to-nix.nix {
    inherit clwrapper;
  };
  quicklispPackagesClisp = quicklispPackagesFor (wrapLisp clisp);
  quicklispPackagesSBCL = quicklispPackagesFor (wrapLisp sbcl);
  quicklispPackages = quicklispPackagesSBCL;
  quicklispPackages_asdf_3_1 = quicklispPackagesFor
    ((wrapLisp sbcl).override { asdf = asdf_3_1; });

  ### DEVELOPMENT / PERL MODULES

  perl522Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl522;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });
  perl524Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl524;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });
  perl526Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl526;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });
  perl528Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl528;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });

  perlPackages = perl528Packages;
  inherit (perlPackages) perl buildPerlPackage;

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlArchiveCpio = perlPackages.ArchiveCpio;

  perlcritic = perlPackages.PerlCritic;

  sqitchPg = callPackage ../development/tools/misc/sqitch {
    name = "sqitch-pg";
    databaseModule = perlPackages.DBDPg;
    sqitchModule = perlPackages.AppSqitch;
  };

  ### DEVELOPMENT / R MODULES

  R = callPackage ../applications/science/math/R {
    # TODO: split docs into a separate output
    texLive = texlive.combine {
      inherit (texlive) scheme-small inconsolata helvetic texinfo fancyvrb cm-super;
    };
    openblas = openblasCompat;
    withRecommendedPackages = false;
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
    inherit (darwin) libobjc;
  };

  rWrapper = callPackage ../development/r-modules/wrapper.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rstudioWrapper = callPackage ../development/r-modules/wrapper-rstudio.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rPackages = callPackage ../development/r-modules {
    overrides = (config.rPackageOverrides or (p: {})) pkgs;
  };

  ### SERVERS

  _389-ds-base = callPackage ../servers/ldap/389 {
    kerberos = libkrb5;
  };

  rdf4store = callPackage ../servers/http/4store { };

  apacheHttpd_2_4 = callPackage ../servers/http/apache-httpd/2.4.nix { };
  apacheHttpd = pkgs.apacheHttpd_2_4;

  apacheHttpdPackagesFor = apacheHttpd: self: let callPackage = newScope self; in {
    inherit apacheHttpd;

    mod_auth_mellon = callPackage ../servers/http/apache-modules/mod_auth_mellon { };

    mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };

    mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

    mod_perl = callPackage ../servers/http/apache-modules/mod_perl { };

    mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

    mod_python = callPackage ../servers/http/apache-modules/mod_python { };

    mod_wsgi = callPackage ../servers/http/apache-modules/mod_wsgi { };

    php = pkgs.php.override { inherit apacheHttpd; };

    subversion = pkgs.subversion.override { httpServer = true; inherit apacheHttpd; };
  };

  apacheHttpdPackages_2_4 = apacheHttpdPackagesFor pkgs.apacheHttpd_2_4 pkgs.apacheHttpdPackages_2_4;
  apacheHttpdPackages = apacheHttpdPackages_2_4;

  appdaemon = callPackage ../servers/home-assistant/appdaemon.nix { };

  archiveopteryx = callPackage ../servers/mail/archiveopteryx { };

  atlassian-confluence = callPackage ../servers/atlassian/confluence.nix { };
  atlassian-crowd = callPackage ../servers/atlassian/crowd.nix { };
  atlassian-jira = callPackage ../servers/atlassian/jira.nix { };

  cadvisor = callPackage ../servers/monitoring/cadvisor { };

  cassandra_2_1 = callPackage ../servers/nosql/cassandra/2.1.nix { };
  cassandra_2_2 = callPackage ../servers/nosql/cassandra/2.2.nix { };
  cassandra_3_0 = callPackage ../servers/nosql/cassandra/3.0.nix { };
  cassandra_3_11 = callPackage ../servers/nosql/cassandra/3.11.nix { };
  cassandra = cassandra_3_11;

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jdk;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jdk;
  };

  apcupsd = callPackage ../servers/apcupsd { };

  asterisk = asterisk-stable;

  inherit (callPackages ../servers/asterisk { })
    asterisk-stable asterisk-lts;

  sabnzbd = callPackage ../servers/sabnzbd { };

  bftpd = callPackage ../servers/ftp/bftpd {};

  bind = callPackage ../servers/dns/bind {
    enablePython = config.bind.enablePython or false;
    python3 = python3.withPackages (ps: with ps; [ ply ]);
  };
  dnsutils = bind.dnsutils;

  inherit (callPackages ../servers/bird { })
    bird bird6 bird2;

  bosun = callPackage ../servers/monitoring/bosun { };

  cayley = callPackage ../servers/cayley { };

  charybdis = callPackage ../servers/irc/charybdis { };

  clamsmtp = callPackage ../servers/mail/clamsmtp { };

  clickhouse = callPackage ../servers/clickhouse {
    inherit (llvmPackages_6) clang-unwrapped lld llvm;
  };

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_1_8_5;
    sphinx = python27Packages.sphinx;
    erlang = erlangR19;
  };

  couchdb2 = callPackage ../servers/http/couchdb/2.0.0.nix {
    spidermonkey = spidermonkey_1_8_5;
  };

  couchpotato = callPackage ../servers/couchpotato {};

  dex-oidc = callPackage ../servers/dex { };

  dgraph = callPackage ../servers/dgraph { };

  dico = callPackage ../servers/dico { };

  dict = callPackage ../servers/dict {
      libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix {};

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dkimproxy = callPackage ../servers/mail/dkimproxy {
    inherit (perlPackages) Error MailDKIM MIMETools NetServer;
  };

  dovecot = callPackage ../servers/mail/dovecot { };
  dovecot_pigeonhole = callPackage ../servers/mail/dovecot/plugins/pigeonhole { };

  dspam = callPackage ../servers/mail/dspam {
    inherit (perlPackages) libnet;
  };

  etcd = callPackage ../servers/etcd { };

  ejabberd = callPackage ../servers/xmpp/ejabberd { };

  exhibitor = callPackage ../servers/exhibitor { };

  hyp = callPackage ../servers/http/hyp { };

  prosody = callPackage ../servers/xmpp/prosody {
    # _compat can probably be removed on next minor version after 0.10.0
    lua5 = lua5_2_compat;
    inherit (lua52Packages) luasocket luasec luaexpat luafilesystem luabitop luaevent luadbi;
  };

  biboumi = callPackage ../servers/xmpp/biboumi { };

  elasticmq = callPackage ../servers/elasticmq { };

  eventstore = callPackage ../servers/nosql/eventstore {
    mono = mono46;
    v8 = v8_6_x;
  };

  exim = callPackage ../servers/mail/exim { };

  facette = callPackage ../servers/monitoring/facette { };

  fcgiwrap = callPackage ../servers/fcgiwrap { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { icu = null; stdenv = overrideCC stdenv gcc5; };
  firebirdSuper = firebird.override { icu = icu58; superServer = true; stdenv = overrideCC stdenv gcc5; };

  foswiki = callPackage ../servers/foswiki { };

  frab = callPackage ../servers/web-apps/frab { };

  freepops = callPackage ../servers/mail/freepops { };

  freeradius = callPackage ../servers/freeradius { };

  freeswitch = callPackage ../servers/sip/freeswitch {
    openssl = openssl_1_0_2;
  };

  fusionInventory = callPackage ../servers/monitoring/fusion-inventory { };

  gatling = callPackage ../servers/http/gatling { };

  glabels = callPackage ../applications/graphics/glabels { };

  gnatsd = callPackage ../servers/gnatsd { };

  gofish = callPackage ../servers/gopher/gofish { };

  grafana = callPackage ../servers/monitoring/grafana { };

  h2o = callPackage ../servers/http/h2o { };

  haka = callPackage ../tools/security/haka { };

  heapster = callPackage ../servers/monitoring/heapster { };

  hbase = callPackage ../servers/hbase {};

  hiawatha = callPackage ../servers/http/hiawatha {};

  home-assistant = callPackage ../servers/home-assistant { };

  hydron = callPackage ../servers/hydron { };

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  knot-dns = callPackage ../servers/dns/knot-dns { };
  knot-resolver = callPackage ../servers/dns/knot-resolver { };

  rdkafka = callPackage ../development/libraries/rdkafka { };

  leafnode = callPackage ../servers/news/leafnode { };

  lighttpd = callPackage ../servers/http/lighttpd { };

  livepeer = callPackage ../servers/livepeer { ffmpeg = ffmpeg_3; };

  lwan = callPackage ../servers/http/lwan { };

  labelImg = callPackage ../applications/science/machine-learning/labelimg { };

  mailman = callPackage ../servers/mail/mailman { };

  mattermost = callPackage ../servers/mattermost { };
  matterircd = callPackage ../servers/mattermost/matterircd.nix { };
  matterbridge = callPackage ../servers/matterbridge { };

  mattermost-desktop = callPackage ../applications/networking/instant-messengers/mattermost-desktop { };

  mediatomb = callPackage ../servers/mediatomb { };

  meguca = callPackage ../servers/meguca {
    buildGoPackage = buildGo110Package;
  };

  memcached = callPackage ../servers/memcached {};

  meteor = callPackage ../servers/meteor { };

  minio = callPackage ../servers/minio {
    buildGoPackage = buildGo110Package;
  };

  # Backwards compatibility.
  mod_dnssd = pkgs.apacheHttpdPackages.mod_dnssd;
  mod_fastcgi = pkgs.apacheHttpdPackages.mod_fastcgi;
  mod_python = pkgs.apacheHttpdPackages.mod_python;
  mod_wsgi = pkgs.apacheHttpdPackages.mod_wsgi;

  mpd = callPackage ../servers/mpd {
    aacSupport    = config.mpd.aacSupport or true;
    clientSupport = config.mpd.clientSupport or true;
    ffmpegSupport = config.mpd.ffmpegSupport or true;
    opusSupport   = config.mpd.opusSupport or true;

  };

  mpd_clientlib = callPackage ../servers/mpd/clientlib.nix { };

  mpdscribble = callPackage ../tools/misc/mpdscribble { };

  micro-httpd = callPackage ../servers/http/micro-httpd { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  mlmmj = callPackage ../servers/mail/mlmmj { };

  morty = callPackage ../servers/web-apps/morty { };

  myserver = callPackage ../servers/http/myserver { };

  nas = callPackage ../servers/nas { };

  nats-streaming-server = callPackage ../servers/nats-streaming-server { };

  neard = callPackage ../servers/neard { };

  nginx = nginxStable;

  nginxStable = callPackage ../servers/http/nginx/stable.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.dav nginxModules.moreheaders ];
  };

  nginxModules = callPackage ../servers/http/nginx/modules.nix { };

  # We should move to dynmaic modules and create a nginxFull package with all modules
  nginxShibboleth = nginxStable.override {
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders nginxModules.shibboleth ];
  };

  libmodsecurity = callPackage ../tools/security/libmodsecurity { };

  ngircd = callPackage ../servers/irc/ngircd { };

  nix-binary-cache = callPackage ../servers/http/nix-binary-cache {};

  nix-tour = callPackage ../applications/misc/nix-tour {};

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  nsq = callPackage ../servers/nsq { };

  oauth2_proxy = callPackage ../servers/oauth2_proxy { };

  openafs = callPackage ../servers/openafs/1.6 { tsmbac = null; ncurses = null; };
  openafs_1_8 = callPackage ../servers/openafs/1.8 { tsmbac = null; ncurses = null; };

  openresty = callPackage ../servers/http/openresty { };

  opensmtpd = callPackage ../servers/mail/opensmtpd { };
  opensmtpd-extras = callPackage ../servers/mail/opensmtpd/extras.nix { };

  openxpki = callPackage ../servers/openxpki { };

  osrm-backend = callPackage ../servers/osrm-backend { };

  p910nd = callPackage ../servers/p910nd { };

  petidomo = callPackage ../servers/mail/petidomo { };

  popa3d = callPackage ../servers/mail/popa3d { };

  postfix = callPackage ../servers/mail/postfix { };

  postsrsd = callPackage ../servers/mail/postsrsd { };

  rmilter = callPackage ../servers/mail/rmilter { };

  rspamd = callPackage ../servers/mail/rspamd { };

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix {
    gperf = gperf_3_0;
  };
  pflogsumm = callPackage ../servers/mail/postfix/pflogsumm.nix { };

  postgrey = callPackage ../servers/mail/postgrey { };

  pshs = callPackage ../servers/http/pshs { };

  # PulseAudio daemons

  pulseaudio = callPackage ../servers/pulseaudio {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  pulseaudioFull = pulseaudio.override {
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  # libpulse implementations
  libpulseaudio-vanilla = pulseaudio.override {
    libOnly = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  apulse = callPackage ../misc/apulse { };

  libpressureaudio = callPackage ../misc/apulse/pressureaudio.nix {
    libpulseaudio = libpulseaudio-vanilla; # headers only
  };

  libcardiacarrest = callPackage ../misc/libcardiacarrest {
    libpulseaudio = libpulseaudio-vanilla; # meta only
  };

  libpulseaudio = libpulseaudio-vanilla;

  pulseeffects = callPackage ../applications/audio/pulseeffects { };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  pies = callPackage ../servers/pies { };

  rpcbind = callPackage ../servers/rpcbind { };

  mariadb = callPackage ../servers/sql/mariadb {
    asio = asio_1_10;
    inherit (darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };
  mysql = mariadb; # TODO: move to aliases.nix

  mongodb = callPackage ../servers/nosql/mongodb {
    sasl = cyrus_sasl;
    boost = boost160;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  percona-server56 = callPackage ../servers/sql/percona/5.6.x.nix { };
  percona-server = percona-server56;

  riak = callPackage ../servers/nosql/riak/2.2.0.nix {
    erlang = erlang_basho_R16B02;
  };

  riak-cs = callPackage ../servers/nosql/riak-cs/2.1.1.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  stanchion = callPackage ../servers/nosql/riak-cs/stanchion.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  influxdb = callPackage ../servers/nosql/influxdb { };

  mysql55 = callPackage ../servers/sql/mysql/5.5.x.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mysql57 = callPackage ../servers/sql/mysql/5.7.x.nix {
    inherit (darwin) cctools developer_cmds;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost159;
  };

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios { };

  munin = callPackage ../servers/monitoring/munin { };

  monitoring-plugins = callPackage ../servers/monitoring/plugins { };

  inherit (callPackage ../servers/monitoring/plugins/labs_consol_de.nix { inherit (perlPackages) DBDsybase NetSNMP; })
    check-mssql-health
    check-nwc-health
    check-ups-health;

  checkSSLCert = callPackage ../servers/monitoring/nagios/plugins/check_ssl_cert.nix { };

  neo4j = callPackage ../servers/nosql/neo4j { };

  check-esxi-hardware = callPackage ../servers/monitoring/plugins/esxi.nix {};

  net_snmp = callPackage ../servers/monitoring/net-snmp {
    # https://sourceforge.net/p/net-snmp/bugs/2712/
    # remove after net-snmp > 5.7.3
    perl = perl522;
  };

  newrelic-sysmond = callPackage ../servers/monitoring/newrelic-sysmond { };

  nullidentdmod = callPackage ../servers/identd/nullidentdmod {};

  riemann = callPackage ../servers/monitoring/riemann { };
  riemann-dash = callPackage ../servers/monitoring/riemann-dash { };

  oidentd = callPackage ../servers/identd/oidentd { };

  openfire = callPackage ../servers/xmpp/openfire { };

  oracleXE = callPackage ../servers/sql/oracle-xe { };

  softether_4_18 = callPackage ../servers/softether/4.18.nix { };
  softether_4_20 = callPackage ../servers/softether/4.20.nix { };
  softether_4_25 = callPackage ../servers/softether/4.25.nix { };
  softether = softether_4_25;

  qboot = callPackage ../applications/virtualization/qboot { stdenv = stdenv_32bit; };

  OVMF = callPackage ../applications/virtualization/OVMF { seabios = null; openssl = null; };
  OVMF-CSM = OVMF.override { openssl = null; };
  #WIP: OVMF-secureBoot = OVMF.override { seabios = null; secureBoot = true; };

  seabios = callPackage ../applications/virtualization/seabios { };

  cbfstool = callPackage ../applications/virtualization/cbfstool { };

  nvramtool = callPackage ../tools/misc/nvramtool { };

  vmfs-tools = callPackage ../tools/filesystems/vmfs-tools { };

  pgbouncer = callPackage ../servers/sql/pgbouncer { };

  pgpool93 = pgpool.override { postgresql = postgresql93; };
  pgpool94 = pgpool.override { postgresql = postgresql94; };

  pgpool = callPackage ../servers/sql/pgpool {
    pam = if stdenv.isLinux then pam else null;
    libmemcached = null; # Detection is broken upstream
  };

  postgresql = postgresql96;

  inherit (callPackages ../servers/sql/postgresql { })
    postgresql93
    postgresql94
    postgresql95
    postgresql96
    postgresql100;

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  inherit (callPackage ../servers/monitoring/prometheus {
    buildGoPackage = buildGo110Package;
  })
      prometheus_1
      prometheus_2
      ;

  prom2json = callPackage ../servers/monitoring/prometheus/prom2json.nix { };
  prometheus = prometheus_1;
  prometheus-alertmanager = callPackage ../servers/monitoring/prometheus/alertmanager.nix { };
  prometheus-bind-exporter = callPackage ../servers/monitoring/prometheus/bind-exporter.nix { };
  prometheus-blackbox-exporter = callPackage ../servers/monitoring/prometheus/blackbox-exporter.nix { };
  prometheus-collectd-exporter = callPackage ../servers/monitoring/prometheus/collectd-exporter.nix { };
  prometheus-consul-exporter = callPackage ../servers/monitoring/prometheus/consul-exporter.nix { };
  prometheus-dnsmasq-exporter = callPackage ../servers/monitoring/prometheus/dnsmasq-exporter.nix { };
  prometheus-dovecot-exporter = callPackage ../servers/monitoring/prometheus/dovecot-exporter.nix { };
  prometheus-fritzbox-exporter = callPackage ../servers/monitoring/prometheus/fritzbox-exporter.nix { };
  prometheus-haproxy-exporter = callPackage ../servers/monitoring/prometheus/haproxy-exporter.nix { };
  prometheus-json-exporter = callPackage ../servers/monitoring/prometheus/json-exporter.nix { };
  prometheus-mesos-exporter = callPackage ../servers/monitoring/prometheus/mesos-exporter.nix { };
  prometheus-minio-exporter = callPackage ../servers/monitoring/prometheus/minio-exporter { };
  prometheus-mysqld-exporter = callPackage ../servers/monitoring/prometheus/mysqld-exporter.nix { };
  prometheus-nginx-exporter = callPackage ../servers/monitoring/prometheus/nginx-exporter.nix { };
  prometheus-node-exporter = callPackage ../servers/monitoring/prometheus/node-exporter.nix { };
  prometheus-openvpn-exporter = callPackage ../servers/monitoring/prometheus/openvpn-exporter.nix { };
  prometheus-postfix-exporter = callPackage ../servers/monitoring/prometheus/postfix-exporter.nix { };
  prometheus-pushgateway = callPackage ../servers/monitoring/prometheus/pushgateway.nix { };
  prometheus-rabbitmq-exporter = callPackage ../servers/monitoring/prometheus/rabbitmq-exporter.nix { };
  prometheus-snmp-exporter = callPackage ../servers/monitoring/prometheus/snmp-exporter.nix {
    buildGoPackage = buildGo110Package;
  };
  prometheus-statsd-exporter = callPackage ../servers/monitoring/prometheus/statsd-bridge.nix { };
  prometheus-surfboard-exporter = callPackage ../servers/monitoring/prometheus/surfboard-exporter.nix { };
  prometheus-unifi-exporter = callPackage ../servers/monitoring/prometheus/unifi-exporter { };
  prometheus-varnish-exporter = callPackage ../servers/monitoring/prometheus/varnish-exporter.nix { };
  prometheus-jmx-httpserver = callPackage ../servers/monitoring/prometheus/jmx-httpserver.nix {  };

  psqlodbc = callPackage ../servers/sql/postgresql/psqlodbc { };

  pure-ftpd = callPackage ../servers/ftp/pure-ftpd { };

  pyIRCt = callPackage ../servers/xmpp/pyIRCt {};

  pyMAILt = callPackage ../servers/xmpp/pyMAILt {};

  pypolicyd-spf = python3.pkgs.callPackage ../servers/mail/pypolicyd-spf { };

  qpid-cpp = callPackage ../servers/amqp/qpid-cpp {
    boost = boost155;
    inherit (pythonPackages) buildPythonPackage qpid-python;
  };

  quagga = callPackage ../servers/quagga { };

  rabbitmq-server = callPackage ../servers/amqp/rabbitmq-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa;
    elixir = elixir_1_6;
    erlang = erlang_nox;
  };

  radicale1 = callPackage ../servers/radicale/1.x.nix { };
  radicale2 = callPackage ../servers/radicale { };

  radicale = radicale2;

  rake = callPackage ../development/tools/build-managers/rake { };

  redis = callPackage ../servers/nosql/redis { };

  redstore = callPackage ../servers/http/redstore { };

  restic = callPackage ../tools/backup/restic { };

  restic-rest-server = callPackage ../tools/backup/restic/rest-server.nix { };

  restya-board = callPackage ../servers/web-apps/restya-board { };

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    libtool = darwin.cctools;
  };

  rippled = callPackage ../servers/rippled {
    boost = boost159;
  };

  s6 = skawarePackages.s6;

  s6-rc = skawarePackages.s6-rc;

  supervise = callPackage ../tools/system/supervise { };

  spamassassin = callPackage ../servers/mail/spamassassin {
    inherit (perlPackages) HTMLParser NetDNS NetAddrIP DBFile
      HTTPDate MailDKIM LWP IOSocketSSL;
  };

  deadpixi-sam-unstable = callPackage ../applications/editors/deadpixi-sam { };
  deadpixi-sam = deadpixi-sam-unstable;

  samba3 = callPackage ../servers/samba/3.x.nix { };

  samba4 = callPackage ../servers/samba/4.x.nix {
    python = python2;
  };

  sambaMaster = callPackage ../servers/samba/master.nix { };

  samba = samba4;

  # A lightweight Samba 3, useful for non-Linux-based OSes.
  samba3_light = lowPrio (samba3.override {
    pam = null;
    fam = null;
    cups = null;
    acl = null;
    openldap = null;
    # libunwind 1.0.1 is not ported to GNU/Hurd.
    libunwind = null;
  });

  samba4Full = lowPrio (samba4.override {
    enableInfiniband = true;
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = true;
    enableGlusterFS = true;
  });

  sambaFull = samba4Full;

  shairplay = callPackage ../servers/shairplay { };

  shairport-sync = callPackage ../servers/shairport-sync { };

  serfdom = callPackage ../servers/serf { };

  seyren = callPackage ../servers/monitoring/seyren { };

  ruby-zoom = callPackage ../tools/text/ruby-zoom { };

  sensu = callPackage ../servers/monitoring/sensu { };

  uchiwa = callPackage ../servers/monitoring/uchiwa { };

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  sipcmd = callPackage ../applications/networking/sipcmd { };

  sipwitch = callPackage ../servers/sip/sipwitch { };

  slimserver = callPackage ../servers/slimserver { };

  smcroute = callPackage ../servers/smcroute { };

  spawn_fcgi = callPackage ../servers/http/spawn-fcgi { };

  squid = callPackage ../servers/squid { };
  squid4 = callPackage ../servers/squid/4.nix { };

  sslh = callPackage ../servers/sslh { };

  thttpd = callPackage ../servers/http/thttpd { };

  storm = callPackage ../servers/computing/storm { };

  slurm = callPackage ../servers/computing/slurm { gtk2 = null; };

  slurm-spank-x11 = callPackage ../servers/computing/slurm-spank-x11 { };

  systemd-journal2gelf = callPackage ../tools/system/systemd-journal2gelf { };

  inherit (callPackages ../servers/http/tomcat { })
    tomcat7
    tomcat8
    tomcat85
    tomcat9;

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  torque = callPackage ../servers/computing/torque { };

  tt-rss = callPackage ../servers/tt-rss { };
  tt-rss-plugin-tumblr-gdpr = callPackage ../servers/tt-rss/plugin-tumblr-gdpr { };
  tt-rss-theme-feedly = callPackage ../servers/tt-rss/theme-feedly { };

  searx = callPackage ../servers/web-apps/searx { };

  selfoss = callPackage ../servers/web-apps/selfoss { };

  shaarli = callPackage ../servers/web-apps/shaarli { };

  shaarli-material = callPackage ../servers/web-apps/shaarli/material-theme.nix { };

  matomo = callPackage ../servers/web-apps/matomo { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  inherit (callPackages ../servers/unifi { })
    unifiLTS
    unifiStable
    unifiTesting;
  unifi = unifiStable;

  virtlyst = libsForQt5.callPackage ../servers/web-apps/virtlyst { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix { };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix { };

  virtuoso = virtuoso6;

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  wallabag = callPackage ../servers/web-apps/wallabag { };

  webmetro = callPackage ../servers/webmetro { };

  winstone = callPackage ../servers/http/winstone { };

  xinetd = callPackage ../servers/xinetd { };

  zookeeper = callPackage ../servers/zookeeper { };

  zookeeper_mt = callPackage ../development/libraries/zookeeper_mt { };

  xqilla = callPackage ../development/tools/xqilla { };

  xquartz = callPackage ../servers/x11/xquartz { };
  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
    inherit (darwin.apple_sdk.frameworks) AppKit;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  xorg = recurseIntoAttrs (lib.callPackagesWith pkgs ../servers/x11/xorg {
    inherit clangStdenv fetchurl fetchgit fetchpatch stdenv intltool freetype fontconfig
      libxslt expat libpng zlib perl mesa_drivers spice-protocol libunwind
      dbus libuuid openssl gperf m4 libevdev tradcpp libinput mcpp makeWrapper autoreconfHook
      autoconf automake libtool mtdev pixman libGL libGLU
      cairo epoxy;
    inherit (buildPackages) pkgconfig xmlto asciidoc flex bison;
    inherit (darwin) apple_sdk cf-private libobjc;
    bootstrap_cmds = if stdenv.isDarwin then darwin.bootstrap_cmds else null;
    python = python2; # Incompatible with Python 3x
    udev = if stdenv.isLinux then udev else null;
    libdrm = if stdenv.isLinux then libdrm else null;
    abiCompat = config.xorg.abiCompat # `config` because we have no `xorg.override`
      or (if stdenv.isDarwin then "1.18" else null); # 1.19 needs fixing on Darwin
  } // { inherit xlibsWrapper; } );

  xwayland = callPackage ../servers/x11/xorg/xwayland.nix { };

  yaws = callPackage ../servers/http/yaws {
    erlang = erlangR18;
  };

  youtrack = callPackage ../servers/jetbrains/youtrack.nix { };

  zabbix = recurseIntoAttrs (callPackages ../servers/monitoring/zabbix {});

  zabbix20 = callPackage ../servers/monitoring/zabbix/2.0.nix { };
  zabbix22 = callPackage ../servers/monitoring/zabbix/2.2.nix { };
  zabbix34 = callPackage ../servers/monitoring/zabbix/3.4.nix { };

  zipkin = callPackage ../servers/monitoring/zipkin { };

  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  autofs5 = callPackage ../os-specific/linux/autofs { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfs-utils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  acpid = callPackage ../os-specific/linux/acpid { };

  acpitool = callPackage ../os-specific/linux/acpitool { };

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alienfx = callPackage ../os-specific/linux/alienfx { };

  alsa-firmware = callPackage ../os-specific/linux/alsa-firmware { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins { };

  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };
  alsaOss = callPackage ../os-specific/linux/alsa-oss { };
  alsaTools = callPackage ../os-specific/linux/alsa-tools { };

  inherit (callPackage ../misc/arm-trusted-firmware {})
    buildArmTrustedFirmware
    armTrustedFirmwareAllwinner
    armTrustedFirmwareQemu
    armTrustedFirmwareRK3328
    ;

  microcodeAmd = callPackage ../os-specific/linux/microcode/amd.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  iucode-tool = callPackage ../os-specific/linux/microcode/iucode-tool.nix { };

  inherit (callPackages ../os-specific/linux/apparmor { python = python3; })
    libapparmor apparmor-utils apparmor-bin-utils apparmor-parser apparmor-pam
    apparmor-profiles apparmor-kernel-patches;

  atop = callPackage ../os-specific/linux/atop { };

  audit = callPackage ../os-specific/linux/audit { };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 = callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  bt-fw-converter = callPackage ../os-specific/linux/firmware/bt-fw-converter { };

  broadcom-bt-firmware = callPackage ../os-specific/linux/firmware/broadcom-bt-firmware { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  blktrace = callPackage ../os-specific/linux/blktrace { };

  bluez5 = callPackage ../os-specific/linux/bluez { };

  pulseaudio-modules-bt = callPackage ../applications/audio/pulseaudio-modules-bt { };

  bluez = bluez5;

  inherit (python3Packages) bedup;

  bridge-utils = callPackage ../os-specific/linux/bridge-utils { };

  busybox = callPackage ../os-specific/linux/busybox { };
  busybox-sandbox-shell = callPackage ../os-specific/linux/busybox/sandbox-shell.nix { };

  cachefilesd = callPackage ../os-specific/linux/cachefilesd { };

  cgmanager = callPackage ../os-specific/linux/cgmanager { };

  checkpolicy = callPackage ../os-specific/linux/checkpolicy { };

  checksec = callPackage ../os-specific/linux/checksec { };

  cifs-utils = callPackage ../os-specific/linux/cifs-utils { };

  cockroachdb = callPackage ../servers/sql/cockroachdb { };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_1; # conky can use 5.2, but toluapp can not
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
    pulseSupport = config.pulseaudio or false;
  } // config.conky or {});

  conntrack-tools = callPackage ../os-specific/linux/conntrack-tools { };

  coredns = callPackage ../servers/dns/coredns { };

  cpufrequtils = callPackage ../os-specific/linux/cpufrequtils { };

  criu = callPackage ../os-specific/linux/criu { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  crda = callPackage ../os-specific/linux/crda { };

  # Darwin package set
  #
  # Even though this is a set of packages not single package, use `callPackage`
  # not `callPackages` so the per-package callPackages don't have their
  # `.override` clobbered. C.F. `llvmPackages` which does the same.
  darwin = callPackage ./darwin-packages.nix { };

  disk_indicator = callPackage ../os-specific/linux/disk-indicator { };

  displaylink = callPackage ../os-specific/linux/displaylink {
    inherit (linuxPackages) evdi;
  };

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  directvnc = callPackage ../os-specific/linux/directvnc { };

  dmraid = callPackage ../os-specific/linux/dmraid {
    lvm2 = lvm2.override {enable_dmeventd = true;};
  };

  drbd = callPackage ../os-specific/linux/drbd { };

  dstat = callPackage ../os-specific/linux/dstat { };

  # unstable until the first 1.x release
  fscrypt-experimental = callPackage ../os-specific/linux/fscrypt {
    buildGoPackage = buildGo110Package;
  };
  fscryptctl-experimental = callPackage ../os-specific/linux/fscryptctl { };

  fwupd = callPackage ../os-specific/linux/firmware/fwupd { };

  fwupdate = callPackage ../os-specific/linux/firmware/fwupdate { };

  fwts = callPackage ../os-specific/linux/fwts { };

  libossp_uuid = callPackage ../development/libraries/libossp-uuid { };

  libuuid = if stdenv.isLinux
    then utillinuxMinimal
    else null;

  light = callPackage ../os-specific/linux/light { };

  lightum = callPackage ../os-specific/linux/lightum { };

  ebtables = callPackage ../os-specific/linux/ebtables { };

  facetimehd-firmware = callPackage ../os-specific/linux/firmware/facetimehd-firmware { };

  fatrace = callPackage ../os-specific/linux/fatrace { };

  ffado = callPackage ../os-specific/linux/ffado {
    inherit (python2Packages) python pyqt4 dbus-python;
  };
  libffado = ffado.override { prefix = "lib"; };

  fbterm = callPackage ../os-specific/linux/fbterm { };

  firejail = callPackage ../os-specific/linux/firejail {};

  fnotifystat = callPackage ../os-specific/linux/fnotifystat { };

  forkstat = callPackage ../os-specific/linux/forkstat { };

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fusePackages = callPackage ../os-specific/linux/fuse {
    utillinux = utillinuxMinimal;
  };
  fuse = lowPrio fusePackages.fuse_2;
  fuse3 = fusePackages.fuse_3;
  fuse-common = hiPrio fusePackages.fuse_3.common;

  fusionio-util = callPackage ../os-specific/linux/fusionio/util.nix { };

  fxload = callPackage ../os-specific/linux/fxload { };

  gfxtablet = callPackage ../os-specific/linux/gfxtablet {};

  gmailieer = callPackage ../applications/networking/gmailieer {};

  gpm = callPackage ../servers/gpm {
    ncurses = null;  # Keep curses disabled for lack of value
  };

  gpm-ncurses = gpm.override { inherit ncurses; };

  gpu-switch = callPackage ../os-specific/linux/gpu-switch { };

  gradm = callPackage ../os-specific/linux/gradm {
    flex = flex_2_5_35;
  };

  hd-idle = callPackage ../os-specific/linux/hd-idle { };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  hostapd = callPackage ../os-specific/linux/hostapd { };

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  nmon = callPackage ../os-specific/linux/nmon { };

  hwdata = callPackage ../os-specific/linux/hwdata { };

  i7z = qt5.callPackage ../os-specific/linux/i7z { };

  pcm = callPackage ../os-specific/linux/pcm { };

  ima-evm-utils = callPackage ../os-specific/linux/ima-evm-utils { };

  intel2200BGFirmware = callPackage ../os-specific/linux/firmware/intel2200BGFirmware { };

  intel-ocl = callPackage ../os-specific/linux/intel-ocl { };

  iomelt = callPackage ../os-specific/linux/iomelt { };

  iotop = callPackage ../os-specific/linux/iotop { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iputils = callPackage ../os-specific/linux/iputils { };

  iptables = callPackage ../os-specific/linux/iptables { };

  iptstate = callPackage ../os-specific/linux/iptstate { } ;

  ipset = callPackage ../os-specific/linux/ipset { };

  irqbalance = callPackage ../os-specific/linux/irqbalance { };

  iw = callPackage ../os-specific/linux/iw { };

  iwd = callPackage ../os-specific/linux/iwd { };

  jfbview = callPackage ../os-specific/linux/jfbview { };
  jfbpdf = jfbview.override {
    imageSupport = false;
  };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  jujuutils = callPackage ../os-specific/linux/jujuutils { };

  kbd = callPackage ../os-specific/linux/kbd { };

  kbdKeymaps = callPackage ../os-specific/linux/kbd/keymaps.nix { };

  kbdlight = callPackage ../os-specific/linux/kbdlight { };

  kmscon = callPackage ../os-specific/linux/kmscon { };

  kmscube = callPackage ../os-specific/linux/kmscube { };

  kmsxx = callPackage ../development/libraries/kmsxx {
    stdenv = overrideCC stdenv gcc6;
  };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  ldm = callPackage ../os-specific/linux/ldm { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libargon2 = callPackage ../development/libraries/libargon2 { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  openelec-dvb-firmware = callPackage ../os-specific/linux/firmware/openelec-dvb-firmware { };

  openiscsi = callPackage ../os-specific/linux/open-iscsi { };

  openisns = callPackage ../os-specific/linux/open-isns { };

  powerstat = callPackage ../os-specific/linux/powerstat { };

  smemstat = callPackage ../os-specific/linux/smemstat { };

  tgt = callPackage ../tools/networking/tgt { };

  # -- Linux kernel expressions ------------------------------------------------

  lkl = callPackage ../applications/virtualization/lkl { };

  inherit (callPackages ../os-specific/linux/kernel-headers { })
    linuxHeaders;

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  klibc = callPackage ../os-specific/linux/klibc { };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linux_beagleboard = callPackage ../os-specific/linux/kernel/linux-beagleboard.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  # linux mptcp is based on the 4.4 kernel
  linux_mptcp = callPackage ../os-specific/linux/kernel/linux-mptcp.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ lib.optionals ((stdenv.hostPlatform.platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_mptcp_93 = callPackage ../os-specific/linux/kernel/linux-mptcp-93.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.p9_fixes
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_rpi = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
    ];
  };

  linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.4"
        kernelPatches.modinst_arg_list_too_long
        # https://github.com/NixOS/nixpkgs/issues/42755
        # Remove these xen-netfront patches once they're included in
        # upstream! Fixes https://github.com/NixOS/nixpkgs/issues/42755
        kernelPatches.xen-netfront_fix_mismatched_rtnl_unlock
        kernelPatches.xen-netfront_update_features_after_registering_netdev
      ];
  };

  linux_4_9 = callPackage ../os-specific/linux/kernel/linux-4.9.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
        # https://github.com/NixOS/nixpkgs/issues/42755
        # Remove these xen-netfront patches once they're included in
        # upstream! Fixes https://github.com/NixOS/nixpkgs/issues/42755
        kernelPatches.xen-netfront_fix_mismatched_rtnl_unlock
        kernelPatches.xen-netfront_update_features_after_registering_netdev
      ];
  };

  linux_4_14 = callPackage ../os-specific/linux/kernel/linux-4.14.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
        # https://github.com/NixOS/nixpkgs/issues/42755
        # Remove these xen-netfront patches once they're included in
        # upstream! Fixes https://github.com/NixOS/nixpkgs/issues/42755
        kernelPatches.xen-netfront_fix_mismatched_rtnl_unlock
        kernelPatches.xen-netfront_update_features_after_registering_netdev
      ];
  };

  linux_4_18 = callPackage ../os-specific/linux/kernel/linux-4.18.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ];
  };

  linux_testing_bcachefs = callPackage ../os-specific/linux/kernel/linux-testing-bcachefs.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_riscv = callPackage ../os-specific/linux/kernel/linux-riscv.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ];
  };

  linux_samus_4_12 = callPackage ../os-specific/linux/kernel/linux-samus-4.12.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.p9_fixes
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_hardkernel_4_14 = callPackage ../os-specific/linux/kernel/linux-hardkernel-4.14.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ];
  };

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit kernel;
    inherit (kernel) stdenv; # in particular, use the same compiler by default

    # Obsolete aliases (these packages do not depend on the kernel).
    inherit (pkgs) odp-dpdk pktgen; # added 2018-05

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    amdgpu-pro = callPackage ../os-specific/linux/amdgpu-pro { };

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bcc = callPackage ../os-specific/linux/bcc {
      python = python3;
    };

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    beegfs-module = callPackage ../os-specific/linux/beegfs/kernel-module.nix { };

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    dpdk = callPackage ../os-specific/linux/dpdk { };

    exfat-nofuse = callPackage ../os-specific/linux/exfat { };

    evdi = callPackage ../os-specific/linux/evdi { };

    hyperv-daemons = callPackage ../os-specific/linux/hyperv-daemons { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    ena = callPackage ../os-specific/linux/ena {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    fusionio-vsl = callPackage ../os-specific/linux/fusionio/vsl.nix { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta { };

    tbs = callPackage ../os-specific/linux/tbs { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy304 = nvidiaPackages.legacy_304;
    nvidia_x11_legacy340 = nvidiaPackages.legacy_340;
    nvidia_x11_beta      = nvidiaPackages.beta;
    nvidia_x11           = nvidiaPackages.stable;

    ply = callPackage ../os-specific/linux/ply { };

    rtl8192eu = callPackage ../os-specific/linux/rtl8192eu { };

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtl8814au = callPackage ../os-specific/linux/rtl8814au { };

    rtlwifi_new = callPackage ../os-specific/linux/rtlwifi_new { };

    openafs = callPackage ../servers/openafs/1.6/module.nix { };
    openafs_1_8 = callPackage ../servers/openafs/1.8/module.nix { };

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

    jool = callPackage ../os-specific/linux/jool { };

    mba6x_bl = callPackage ../os-specific/linux/mba6x_bl { };

    mwprocapture = callPackage ../os-specific/linux/mwprocapture { };

    mxu11x0 = callPackage ../os-specific/linux/mxu11x0 { };

    /* compiles but has to be integrated into the kernel somehow
       Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    netatop = callPackage ../os-specific/linux/netatop { };

    perf = callPackage ../os-specific/linux/kernel/perf.nix { };

    phc-intel = callPackage ../os-specific/linux/phc-intel { };

    prl-tools = callPackage ../os-specific/linux/prl-tools { };

    sch_cake = callPackage ../os-specific/linux/sch_cake { };

    spl = callPackage ../os-specific/linux/spl { };

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    tmon = callPackage ../os-specific/linux/tmon { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    usbip = callPackage ../os-specific/linux/usbip { };

    v86d = callPackage ../os-specific/linux/v86d { };

    vhba = callPackage ../misc/emulators/cdemu/vhba.nix { };

    virtualbox = callPackage ../os-specific/linux/virtualbox {
      virtualbox = pkgs.virtualboxHardened;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions {
      virtualbox = pkgs.virtualboxHardened;
    };

    wireguard = callPackage ../os-specific/linux/wireguard { };

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    inherit (callPackage ../os-specific/linux/zfs {
      configFile = "kernel";
      inherit kernel spl;
     }) zfsStable zfsUnstable;

     zfs = zfsStable;
  });

  # The current default kernel / kernel modules.
  linuxPackages = linuxPackages_4_14;
  linux = linuxPackages.kernel;

  # Update this when adding the newest kernel major version!
  linuxPackages_latest = linuxPackages_4_18;
  linux_latest = linuxPackages_latest.kernel;

  # Build the kernel modules for the some of the kernels.
  linuxPackages_beagleboard = linuxPackagesFor pkgs.linux_beagleboard;
  linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_rpi = linuxPackagesFor pkgs.linux_rpi;
  linuxPackages_4_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_4);
  linuxPackages_4_9 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_9);
  linuxPackages_4_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_14);
  linuxPackages_4_18 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_18);
  # Don't forget to update linuxPackages_latest!

  # Intentionally lacks recurseIntoAttrs, as -rc kernels will quite likely break out-of-tree modules and cause failed Hydra builds.
  linuxPackages_testing = linuxPackagesFor pkgs.linux_testing;

  linuxPackages_custom = { version, src, configfile, allowImportFromDerivation ? true }:
    recurseIntoAttrs (linuxPackagesFor (pkgs.linuxManualConfig {
      inherit version src configfile stdenv allowImportFromDerivation;
    }));

  # This serves as a test for linuxPackages_custom
  linuxPackages_custom_tinyconfig_kernel = let
    base = pkgs.linuxPackages.kernel;
    tinyLinuxPackages = pkgs.linuxPackages_custom {
      inherit (base) version src;
      allowImportFromDerivation = false;
      configfile = pkgs.linuxConfig {
        makeTarget = "tinyconfig";
        src = base.src;
      };
    };
    in tinyLinuxPackages.kernel;

  # Build a kernel with bcachefs module
  linuxPackages_testing_bcachefs = recurseIntoAttrs (linuxPackagesFor pkgs.linux_testing_bcachefs);

  # Build a kernel for Xen dom0
  linuxPackages_xen_dom0 = recurseIntoAttrs (linuxPackagesFor (pkgs.linux.override { features.xen_dom0=true; }));

  linuxPackages_latest_xen_dom0 = recurseIntoAttrs (linuxPackagesFor (pkgs.linux_latest.override { features.xen_dom0=true; }));

  # Hardened linux
  hardenedLinuxPackagesFor = kernel: linuxPackagesFor (kernel.override {
    extraConfig = import ../os-specific/linux/kernel/hardened-config.nix {
      inherit stdenv;
      inherit (kernel) version;
    };
  });

  linuxPackages_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor pkgs.linux);
  linux_hardened = linuxPackages_hardened.kernel;

  linuxPackages_latest_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor pkgs.linux_latest);
  linux_latest_hardened = linuxPackages_latest_hardened.kernel;

  linuxPackages_xen_dom0_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor (pkgs.linux.override { features.xen_dom0=true; }));

  linuxPackages_latest_xen_dom0_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor (pkgs.linux_latest.override { features.xen_dom0=true; }));

  # Samus kernels
  linuxPackages_samus_4_12 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_samus_4_12);
  linuxPackages_samus_latest = linuxPackages_samus_4_12;
  linux_samus_latest = linuxPackages_samus_latest.kernel;

  # Hardkernel (Odroid) kernels.
  linuxPackages_hardkernel_4_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_hardkernel_4_14);
  linuxPackages_hardkernel_latest = linuxPackages_hardkernel_4_14;
  linux_hardkernel_latest = linuxPackages_hardkernel_latest.kernel;

  # GNU Linux-libre kernels
  linuxPackages-libre = recurseIntoAttrs (linuxPackagesFor linux-libre);
  linux-libre = callPackage ../os-specific/linux/kernel/linux-libre.nix {};
  linuxPackages_latest-libre = recurseIntoAttrs (linuxPackagesFor linux_latest-libre);
  linux_latest-libre = linux-libre.override { linux = linux_latest; };

  # A function to build a manually-configured kernel
  linuxManualConfig = makeOverridable (callPackage ../os-specific/linux/kernel/manual-config.nix {});

  # Derive one of the default .config files
  linuxConfig = { src, makeTarget ? "defconfig", name ? "kernel.config" }:
    stdenv.mkDerivation {
      inherit name src;
      buildPhase = ''
        set -x
        make ${makeTarget}
      '';
      installPhase = ''
        cp .config $out
      '';
    };

  buildLinux = attrs: callPackage ../os-specific/linux/kernel/generic.nix attrs;

  dpdk = callPackage ../os-specific/linux/dpdk {
    kernel = null; # dpdk modules are in linuxPackages.dpdk.kmod
  };

  # Using fetchurlBoot because this is used by kerberos (on Linux), which curl depends on
  keyutils = callPackage ../os-specific/linux/keyutils { fetchurl = fetchurlBoot; };

  libselinux = callPackage ../os-specific/linux/libselinux { };

  libsemanage = callPackage ../os-specific/linux/libsemanage { };

  libraw = callPackage ../development/libraries/libraw { };

  libraw1394 = callPackage ../development/libraries/libraw1394 { };

  librealsense = callPackage ../development/libraries/librealsense { };

  libsass = callPackage ../development/libraries/libsass { };

  libsexy = callPackage ../development/libraries/libsexy { };

  libsepol = callPackage ../os-specific/linux/libsepol { };

  libsmbios = callPackage ../os-specific/linux/libsmbios { };

  lm_sensors = callPackage ../os-specific/linux/lm-sensors { };

  lockdep = callPackage ../os-specific/linux/lockdep { };

  lsiutil = callPackage ../os-specific/linux/lsiutil { };

  kmod = callPackage ../os-specific/linux/kmod { };

  kmod-blacklist-ubuntu = callPackage ../os-specific/linux/kmod-blacklist-ubuntu { };

  kmod-debian-aliases = callPackage ../os-specific/linux/kmod-debian-aliases { };

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_ng = callPackage ../os-specific/linux/libcap-ng {
    swig = null; # Currently not using the python2/3 bindings
    python2 = null; # Currently not using the python2 bindings
    python3 = null; # Currently not using the python3 bindings
  };

  libnotify = callPackage ../development/libraries/libnotify { };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lsscsi = callPackage ../os-specific/linux/lsscsi { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mbpfan = callPackage ../os-specific/linux/mbpfan { };

  mdadm = mdadm4;
  mdadm4 = callPackage ../os-specific/linux/mdadm { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  miraclecast = callPackage ../os-specific/linux/miraclecast { };

  mkinitcpio-nfs-utils = callPackage ../os-specific/linux/mkinitcpio-nfs-utils { };

  mmc-utils = callPackage ../os-specific/linux/mmc-utils { };

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit modules;
    };

  multipath-tools = callPackage ../os-specific/linux/multipath-tools { };

  musl = callPackage ../os-specific/linux/musl { };

  nettools = if stdenv.isLinux then callPackage ../os-specific/linux/net-tools { }
             else unixtools.nettools;

  nftables = callPackage ../os-specific/linux/nftables { };

  numactl = callPackage ../os-specific/linux/numactl { };

  numad = callPackage ../os-specific/linux/numad { };

  nvme-cli = callPackage ../os-specific/linux/nvme-cli { };

  open-vm-tools = callPackage ../applications/virtualization/open-vm-tools {
    inherit (gnome3) gtk gtkmm;
  };
  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  delve = callPackage ../development/tools/delve { };

  dep = callPackage ../development/tools/dep { };

  dep2nix = callPackage ../development/tools/dep2nix { };

  easyjson = callPackage ../development/tools/easyjson { };

  go-bindata = callPackage ../development/tools/go-bindata { };

  go-bindata-assetfs = callPackage ../development/tools/go-bindata-assetfs { };

  go-protobuf = callPackage ../development/tools/go-protobuf { };


  go-symbols = callPackage ../development/tools/go-symbols { };

  go-outline = callPackage ../development/tools/go-outline { };

  gocode = callPackage ../development/tools/gocode { };

  goconvey = callPackage ../development/tools/goconvey { };

  gotags = callPackage ../development/tools/gotags { };

  golint = callPackage ../development/tools/golint { };

  golangci-lint = callPackage ../development/tools/golangci-lint { };

  godef = callPackage ../development/tools/godef { };

  gopkgs = callPackage ../development/tools/gopkgs { };

  govers = callPackage ../development/tools/govers { };

  govendor = callPackage ../development/tools/govendor { };

  gotools = callPackage ../development/tools/gotools { };

  gotop = callPackage ../tools/system/gotop { };

  gomodifytags = callPackage ../development/tools/gomodifytags { };

  go-langserver = callPackage ../development/tools/go-langserver {
    buildGoPackage = buildGo110Package;
  };

  gotests = callPackage ../development/tools/gotests { };

  quicktemplate = callPackage ../development/tools/quicktemplate { };

  gogoclient = callPackage ../os-specific/linux/gogoclient { };

  linux-pam = callPackage ../os-specific/linux/pam { };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  odp-dpdk = callPackage ../os-specific/linux/odp-dpdk { };

  odroid-xu3-bootloader = callPackage ../tools/misc/odroid-xu3-bootloader { };

  ofp = callPackage ../os-specific/linux/ofp { };

  openpam = callPackage ../development/libraries/openpam { };

  openbsm = callPackage ../development/libraries/openbsm { };

  pagemon = callPackage ../os-specific/linux/pagemon { };

  pam = if stdenv.isLinux then linux-pam else openpam;

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ccreds = callPackage ../os-specific/linux/pam_ccreds { };

  pam_krb5 = callPackage ../os-specific/linux/pam_krb5 { };

  pam_ldap = callPackage ../os-specific/linux/pam_ldap { };

  pam_mount = callPackage ../os-specific/linux/pam_mount { };

  pam_pgsql = callPackage ../os-specific/linux/pam_pgsql { };

  pam_ssh_agent_auth = callPackage ../os-specific/linux/pam_ssh_agent_auth { };

  pam_u2f = callPackage ../os-specific/linux/pam_u2f { };

  pam_usb = callPackage ../os-specific/linux/pam_usb { };

  paxctl = callPackage ../os-specific/linux/paxctl { };

  paxtest = callPackage ../os-specific/linux/paxtest { };

  pax-utils = callPackage ../os-specific/linux/pax-utils { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = config.pcmciaUtils.firmware or [];
    config = config.pcmciaUtils.config or null;
  };

  pcstat = callPackage ../tools/system/pcstat { };

  perf-tools = callPackage ../os-specific/linux/perf-tools { };

  pipes = callPackage ../misc/screensavers/pipes { };

  pipework = callPackage ../os-specific/linux/pipework { };

  pktgen = callPackage ../os-specific/linux/pktgen { };

  plymouth = callPackage ../os-specific/linux/plymouth { };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  pmtools = callPackage ../os-specific/linux/pmtools { };

  policycoreutils = callPackage ../os-specific/linux/policycoreutils { };

  semodule-utils = callPackage ../os-specific/linux/semodule-utils { };

  powerdns = callPackage ../servers/dns/powerdns { };

  dnsdist = callPackage ../servers/dns/dnsdist { };

  pdns-recursor = callPackage ../servers/dns/pdns-recursor { };

  powertop = callPackage ../os-specific/linux/powertop { };

  pps-tools = callPackage ../os-specific/linux/pps-tools { };

  prayer = callPackage ../servers/prayer { };

  procps = if stdenv.isLinux then callPackage ../os-specific/linux/procps-ng { }
           else unixtools.procps;

  qemu_kvm = lowPrio (qemu.override { hostCpuOnly = true; });

  # See `xenPackages` source for explanations.
  # Building with `xen` instead of `xen-slim` is possible, but makes no sense.
  qemu_xen = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-slim; });
  qemu_xen-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-light; });
  qemu_xen_4_8 = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_8-slim; });
  qemu_xen_4_8-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_8-light; });
  qemu_xen_4_10 = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-slim; });
  qemu_xen_4_10-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-light; });

  qemu_test = lowPrio (qemu.override { hostCpuOnly = true; nixosTestRunner = true; });

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  radeontop = callPackage ../os-specific/linux/radeontop { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};
  raspberrypiWirelessFirmware = callPackage ../os-specific/linux/firmware/raspberrypi-wireless { };

  raspberrypi-tools = callPackage ../os-specific/linux/firmware/raspberrypi/tools.nix {};

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  riscv-pk = callPackage ../misc/riscv-pk { };

  riscv-pk-with-kernel = riscv-pk.override {
    payload = "${linux_riscv}/vmlinux";
  };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  rt5677-firmware = callPackage ../os-specific/linux/firmware/rt5677 { };

  rtl8192su-firmware = callPackage ../os-specific/linux/firmware/rtl8192su-firmware { };

  rtl8723bs-firmware = callPackage ../os-specific/linux/firmware/rtl8723bs-firmware { };

  rtlwifi_new-firmware = callPackage ../os-specific/linux/firmware/rtlwifi_new-firmware { };

  s3ql = callPackage ../tools/backup/s3ql { };

  sass = callPackage ../development/tools/sass { };

  sassc = callPackage ../development/tools/sassc { };

  scanmem = callPackage ../tools/misc/scanmem { };

  schedtool = callPackage ../os-specific/linux/schedtool { };

  sdparm = callPackage ../os-specific/linux/sdparm { };

  sepolgen = callPackage ../os-specific/linux/sepolgen { };

  setools = callPackage ../os-specific/linux/setools { };

  seturgent = callPackage ../os-specific/linux/seturgent { };

  shadow = callPackage ../os-specific/linux/shadow { };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  skopeo = callPackage ../development/tools/skopeo { };

  smem = callPackage ../os-specific/linux/smem { };

  statifier = callPackage ../os-specific/linux/statifier { };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # pkgs.sysdig is a client, for a driver look at linuxPackagesFor

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  sysprof = callPackage ../development/tools/profiling/sysprof { };

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

  systemd = callPackage ../os-specific/linux/systemd {
    utillinux = utillinuxMinimal; # break the cyclic dependency
  };
  udev = systemd; # TODO: move to aliases.nix

  # standalone cryptsetup generator for systemd
  systemd-cryptsetup-generator = callPackage ../os-specific/linux/systemd/cryptsetup-generator.nix { };

  # In nixos, you can set systemd.package = pkgs.systemd_with_lvm2 to get
  # LVM2 working in systemd.
  systemd_with_lvm2 = pkgs.appendToName "with-lvm2" (pkgs.lib.overrideDerivation pkgs.systemd (p: {
      postInstall = p.postInstall + ''
        cp "${pkgs.lvm2}/lib/systemd/system-generators/"* $out/lib/systemd/system-generators
      '';
  }));

  sysvinit = callPackage ../os-specific/linux/sysvinit { };

  sysvtools = sysvinit.override {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcp_wrappers = callPackage ../os-specific/linux/tcp-wrappers { };

  tiptop = callPackage ../os-specific/linux/tiptop { };

  tpacpi-bat = callPackage ../os-specific/linux/tpacpi-bat { };

  trinity = callPackage ../os-specific/linux/trinity { };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootA20OlinuxinoLime
    ubootBananaPi
    ubootBeagleboneBlack
    ubootClearfog
    ubootGuruplug
    ubootJetsonTK1
    ubootNovena
    ubootOdroidXU3
    ubootOrangePiPc
    ubootPcduino3Nano
    ubootPine64
    ubootQemuAarch64
    ubootQemuArm
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootRaspberryPiZero
    ubootSheevaplug
    ubootSopine
    ubootUtilite
    ubootWandboard
    ;

  # Non-upstream U-Boots:
  ubootNanonote = callPackage ../misc/uboot/nanonote.nix { };

  ubootRock64 = callPackage ../misc/uboot/rock64.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = callPackage ../os-specific/linux/uclibc {
    stdenv = crossLibcStdenv;
  };

  eudev = callPackage ../os-specific/linux/eudev {};

  libudev0-shim = callPackage ../os-specific/linux/libudev0-shim { };

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks2;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower { };

  usbguard = libsForQt5.callPackage ../os-specific/linux/usbguard {
    libgcrypt = null;
  };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  usermount = callPackage ../os-specific/linux/usermount { };

  utillinux = if stdenv.isLinux then callPackage ../os-specific/linux/util-linux { }
              else unixtools.utillinux;

  utillinuxCurses = utillinux;

  utillinuxMinimal = if stdenv.isLinux then appendToName "minimal" (utillinux.override {
    minimal = true;
    ncurses = null;
    perl = null;
    systemd = null;
  }) else utillinux;

  v4l_utils = qt5.callPackage ../os-specific/linux/v4l-utils { };

  vndr = callPackage ../development/tools/vndr { };

  windows = callPackages ../os-specific/windows {};

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = libsForQt5.callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  xf86_input_mtrack = callPackage ../os-specific/linux/xf86-input-mtrack { };

  xf86_input_multitouch = callPackage ../os-specific/linux/xf86-input-multitouch { };

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xf86_video_nested = callPackage ../os-specific/linux/xf86-video-nested { };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };

  inherit (callPackage ../os-specific/linux/zfs {
    configFile = "user";
  }) zfsStable zfsUnstable;

  zfs = zfsStable;

  ### DATA

  adapta-backgrounds = callPackage ../data/misc/adapta-backgrounds { };

  aileron = callPackage ../data/fonts/aileron { };

  andagii = callPackage ../data/fonts/andagii { };

  android-udev-rules = callPackage ../os-specific/linux/android-udev-rules { };

  anonymousPro = callPackage ../data/fonts/anonymous-pro { };

  arc-icon-theme = callPackage ../data/icons/arc-icon-theme { };

  arkpandora_ttf = callPackage ../data/fonts/arkpandora { };

  aurulent-sans = callPackage ../data/fonts/aurulent-sans { };

  babelstone-han = callPackage ../data/fonts/babelstone-han { };

  baekmuk-ttf = callPackage ../data/fonts/baekmuk-ttf { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  bgnet = callPackage ../data/documentation/bgnet { };

  brise = callPackage ../data/misc/brise { };

  inherit (kdeFrameworks) breeze-icons;

  cacert = callPackage ../data/misc/cacert { };

  caladea = callPackage ../data/fonts/caladea {};

  cantarell-fonts = callPackage ../data/fonts/cantarell-fonts { };

  capitaine-cursors = callPackage ../data/icons/capitaine-cursors { };

  carlito = callPackage ../data/fonts/carlito {};

  comfortaa = callPackage ../data/fonts/comfortaa {};

  comic-neue = callPackage ../data/fonts/comic-neue { };

  comic-relief = callPackage ../data/fonts/comic-relief {};

  coreclr = callPackage ../development/compilers/coreclr {
    debug = config.coreclr.debug or false;
  };

  corefonts = callPackage ../data/fonts/corefonts { };

  culmus = callPackage ../data/fonts/culmus { };

  clearlyU = callPackage ../data/fonts/clearlyU { };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  crimson = callPackage ../data/fonts/crimson {};

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts {});

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = "${dejavu_fonts.name}";
    paths = [ dejavu_fonts.out ];
  };

  dina-font = callPackage ../data/fonts/dina { };

  dina-font-pcf = callPackage ../data/fonts/dina-pcf { };

  dns-root-data = callPackage ../data/misc/dns-root-data { };

  docbook5 = callPackage ../data/sgml+xml/schemas/docbook-5.0 { };

  docbook_sgml_dtd_31 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/3.1.nix { };

  docbook_sgml_dtd_41 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/4.1.nix { };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_44 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.4.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  docbook_xml_ebnf_dtd = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf { };

  inherit (callPackages ../data/sgml+xml/stylesheets/xslt/docbook-xsl { })
    docbook_xsl
    docbook_xsl_ns;

  documentation-highlighter = callPackage ../misc/documentation-highlighter { };

  cabin = callPackage ../data/fonts/cabin { };

  camingo-code = callPackage ../data/fonts/camingo-code { };

  combinatorial_designs = callPackage ../data/misc/combinatorial_designs { };

  conway_polynomials = callPackage ../data/misc/conway_polynomials { };

  dosis = callPackage ../data/fonts/dosis { };

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  eb-garamond = callPackage ../data/fonts/eb-garamond { };

  elliptic_curves = callPackage ../data/misc/elliptic_curves { };

  eunomia = callPackage ../data/fonts/eunomia { };

  f5_6 = callPackage ../data/fonts/f5_6 { };

  faba-icon-theme = callPackage ../data/icons/faba-icon-theme { };

  faba-mono-icons = callPackage ../data/icons/faba-mono-icons { };

  ferrum = callPackage ../data/fonts/ferrum { };

  fixedsys-excelsior = callPackage ../data/fonts/fixedsys-excelsior { };

  graphs = callPackage ../data/misc/graphs { };

  emacs-all-the-icons-fonts = callPackage ../data/fonts/emacs-all-the-icons-fonts { };

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
  };

  encode-sans = callPackage ../data/fonts/encode-sans { };

  envypn-font = callPackage ../data/fonts/envypn-font { };

  fantasque-sans-mono = callPackage ../data/fonts/fantasque-sans-mono {};

  fira = callPackage ../data/fonts/fira { };

  fira-code = callPackage ../data/fonts/fira-code { };
  fira-code-symbols = callPackage ../data/fonts/fira-code/symbols.nix { };

  fira-mono = callPackage ../data/fonts/fira-mono { };

  font-awesome_4 = callPackage ../data/fonts/font-awesome-4 { };
  font-awesome_5 = callPackage ../data/fonts/font-awesome-5 { };

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  font-droid = callPackage ../data/fonts/droid { };

  freepats = callPackage ../data/misc/freepats { };

  gentium = callPackage ../data/fonts/gentium {};

  gentium-book-basic = callPackage ../data/fonts/gentium-book-basic {};

  geolite-legacy = callPackage ../data/misc/geolite-legacy { };

  gohufont = callPackage ../data/fonts/gohufont { };

  gnome_user_docs = callPackage ../data/documentation/gnome-user-docs { };

  inherit (gnome3) gsettings-desktop-schemas;

  go-font = callPackage ../data/fonts/go-font { };

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  helvetica-neue-lt-std = callPackage ../data/fonts/helvetica-neue-lt-std { };

  hetzner-kube = callPackage ../applications/networking/cluster/hetzner-kube { };

  hicolor-icon-theme = callPackage ../data/icons/hicolor-icon-theme { };

  hanazono = callPackage ../data/fonts/hanazono { };

  ia-writer-duospace = callPackage ../data/fonts/ia-writer-duospace { };

  ibm-plex = callPackage ../data/fonts/ibm-plex { };

  iconpack-obsidian = callPackage ../data/icons/iconpack-obsidian { };

  inconsolata = callPackage ../data/fonts/inconsolata {};
  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  input-fonts = callPackage ../data/fonts/input-fonts { };

  inriafonts = callPackage ../data/fonts/inriafonts { };


  iosevka = callPackage ../data/fonts/iosevka {
    nodejs = nodejs-8_x;
  };
  iosevka-bin = callPackage ../data/fonts/iosevka/bin.nix {};

  ipafont = callPackage ../data/fonts/ipafont {};
  ipaexfont = callPackage ../data/fonts/ipaexfont {};

  iwona = callPackage ../data/fonts/iwona { };

  junicode = callPackage ../data/fonts/junicode { };

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  kochi-substitute-naga10 = callPackage ../data/fonts/kochi-substitute-naga10 {};

  latinmodern-math = callPackage ../data/fonts/lm-math {};

  lato = callPackage ../data/fonts/lato {};

  league-of-moveable-type = callPackage ../data/fonts/league-of-moveable-type {};

  inherit (callPackages ../data/fonts/redhat-liberation-fonts { })
    liberation_ttf_v1_from_source
    liberation_ttf_v1_binary
    liberation_ttf_v2_from_source
    liberation_ttf_v2_binary;
  liberation_ttf = liberation_ttf_v2_binary;

  liberationsansnarrow = callPackage ../data/fonts/liberationsansnarrow { };
  liberationsansnarrow_binary = callPackage ../data/fonts/liberationsansnarrow/binary.nix { };

  liberastika = callPackage ../data/fonts/liberastika { };

  libertine = callPackage ../data/fonts/libertine { };

  libertinus = callPackage ../data/fonts/libertinus { };

  libratbag = callPackage ../os-specific/linux/libratbag { };

  libre-baskerville = callPackage ../data/fonts/libre-baskerville { };

  libre-bodoni = callPackage ../data/fonts/libre-bodoni { };

  libre-caslon = callPackage ../data/fonts/libre-caslon { };

  libre-franklin = callPackage ../data/fonts/libre-franklin { };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  lobster-two = callPackage ../data/fonts/lobster-two {};

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  maia-icon-theme = callPackage ../data/icons/maia-icon-theme { };

  marathi-cursive = callPackage ../data/fonts/marathi-cursive { };

  man-pages = callPackage ../data/documentation/man-pages { };

  material-icons = callPackage ../data/fonts/material-icons { };

  meslo-lg = callPackage ../data/fonts/meslo-lg {};

  migmix = callPackage ../data/fonts/migmix {};

  migu = callPackage ../data/fonts/migu {};

  miscfiles = callPackage ../data/misc/miscfiles { };

  media-player-info = callPackage ../data/misc/media-player-info {};

  medio = callPackage ../data/fonts/medio { };

  mobile-broadband-provider-info = callPackage ../data/misc/mobile-broadband-provider-info { };

  monoid = callPackage ../data/fonts/monoid { };

  mononoki = callPackage ../data/fonts/mononoki { };

  moka-icon-theme = callPackage ../data/icons/moka-icon-theme { };

  montserrat = callPackage ../data/fonts/montserrat { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  mplus-outline-fonts = callPackage ../data/fonts/mplus-outline-fonts { };

  mro-unicode = callPackage ../data/fonts/mro-unicode { };

  mustache-spec = callPackage ../data/documentation/mustache-spec { };

  mustache-go = callPackage ../development/tools/mustache-go { };

  myrica = callPackage ../data/fonts/myrica { };

  nafees = callPackage ../data/fonts/nafees { };

  inherit (callPackages ../data/fonts/noto-fonts {})
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra;

  nullmailer = callPackage ../servers/mail/nullmailer {
    stdenv = gccStdenv;
  };

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme { };

  numix-icon-theme-circle = callPackage ../data/icons/numix-icon-theme-circle { };

  numix-icon-theme-square = callPackage ../data/icons/numix-icon-theme-square { };

  numix-cursor-theme = callPackage ../data/icons/numix-cursor-theme { };

  oldstandard = callPackage ../data/fonts/oldstandard { };

  oldsindhi = callPackage ../data/fonts/oldsindhi { };

  open-dyslexic = callPackage ../data/fonts/open-dyslexic { };

  opensans-ttf = callPackage ../data/fonts/opensans-ttf { };

  orbitron = callPackage ../data/fonts/orbitron { };

  overpass = callPackage ../data/fonts/overpass { };

  oxygenfonts = callPackage ../data/fonts/oxygenfonts { };

  inherit (kdeFrameworks) oxygen-icons5;

  paper-icon-theme = callPackage ../data/icons/paper-icon-theme { };

  papirus-icon-theme = callPackage ../data/icons/papirus-icon-theme { };

  papis = python3Packages.callPackage ../tools/misc/papis { };

  pecita = callPackage ../data/fonts/pecita {};

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  pari-galdata = callPackage ../data/misc/pari-galdata {};

  pari-seadata-small = callPackage ../data/misc/pari-seadata-small {};

  penna = callPackage ../data/fonts/penna { };

  poly = callPackage ../data/fonts/poly { };

  polytopes_db = callPackage ../data/misc/polytopes_db { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  powerline-fonts = callPackage ../data/fonts/powerline-fonts { };

  powerline-go = callPackage ../tools/misc/powerline-go { };

  powerline-rs = callPackage ../tools/misc/powerline-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  profont = callPackage ../data/fonts/profont { };

  proggyfonts = callPackage ../data/fonts/proggyfonts { };

  route159 = callPackage ../data/fonts/route159 { };

  sampradaya = callPackage ../data/fonts/sampradaya { };

  sarasa-gothic = callPackage ../data/fonts/sarasa-gothic { };

  scowl = callPackage ../data/misc/scowl { };

  seshat = callPackage ../data/fonts/seshat { };

  shaderc = callPackage ../development/compilers/shaderc { };

  mime-types = callPackage ../data/misc/mime-types { };

  shared-mime-info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  scheherazade = callPackage ../data/fonts/scheherazade { };

  signwriting = callPackage ../data/fonts/signwriting { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  stix-otf = callPackage ../data/fonts/stix-otf { };

  stix-two = callPackage ../data/fonts/stix-two { };

  inherit (callPackages ../data/fonts/gdouros { })
    symbola aegyptus akkadian anatolian maya unidings musica analecta textfonts aegan abydos;

  iana-etc = callPackage ../data/misc/iana-etc { };

  poppler_data = callPackage ../data/misc/poppler-data { };

  qgo = libsForQt5.callPackage ../games/qgo { };

  qmc2 = libsForQt5.callPackage ../misc/emulators/qmc2 { };

  quattrocento = callPackage ../data/fonts/quattrocento {};

  quattrocento-sans = callPackage ../data/fonts/quattrocento-sans {};

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  raleway = callPackage ../data/fonts/raleway { };

  rictydiminished-with-firacode = callPackage ../data/fonts/rictydiminished-with-firacode { };

  roboto = callPackage ../data/fonts/roboto { };

  roboto-mono = callPackage ../data/fonts/roboto-mono { };

  roboto-slab = callPackage ../data/fonts/roboto-slab { };

  hasklig = callPackage ../data/fonts/hasklig {};

  inter-ui = callPackage ../data/fonts/inter-ui { };

  siji = callPackage ../data/fonts/siji { };

  sound-theme-freedesktop = callPackage ../data/misc/sound-theme-freedesktop { };

  source-code-pro = callPackage ../data/fonts/source-code-pro {};

  source-sans-pro = callPackage ../data/fonts/source-sans-pro { };

  source-serif-pro = callPackage ../data/fonts/source-serif-pro { };

  source-han-code-jp = callPackage ../data/fonts/source-han-code-jp { };

  sourceHanSansPackages = callPackage ../data/fonts/source-han-sans { };
  source-han-sans-japanese = sourceHanSansPackages.japanese;
  source-han-sans-korean = sourceHanSansPackages.korean;
  source-han-sans-simplified-chinese = sourceHanSansPackages.simplified-chinese;
  source-han-sans-traditional-chinese = sourceHanSansPackages.traditional-chinese;
  sourceHanSerifPackages = callPackage ../data/fonts/source-han-serif { };
  source-han-serif-japanese = sourceHanSerifPackages.japanese;
  source-han-serif-korean = sourceHanSerifPackages.korean;
  source-han-serif-simplified-chinese = sourceHanSerifPackages.simplified-chinese;
  source-han-serif-traditional-chinese = sourceHanSerifPackages.traditional-chinese;

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = self.gtk2;
  };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  theano = callPackage ../data/fonts/theano { };

  template-glib = callPackage ../development/libraries/template-glib { };

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  tenderness = callPackage ../data/fonts/tenderness { };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  terminus_font_ttf = callPackage ../data/fonts/terminus-font-ttf { };

  termtekst = callPackage ../misc/emulators/termtekst { };

  tex-gyre = callPackages ../data/fonts/tex-gyre { };

  tex-gyre-math = callPackages ../data/fonts/tex-gyre-math { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  ttf-envy-code-r = callPackage ../data/fonts/ttf-envy-code-r {};

  twemoji-color-font = callPackage ../data/fonts/twemoji-color-font {
    inherit (nodePackages) svgo;
  };

  tzdata = callPackage ../data/misc/tzdata { };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  ucs-fonts = callPackage ../data/fonts/ucs-fonts { };

  ultimate-oldschool-pc-font-pack = callPackage ../data/fonts/ultimate-oldschool-pc-font-pack { };

  uni-vga = callPackage ../data/fonts/uni-vga { };

  unifont = callPackage ../data/fonts/unifont { };

  unifont_upper = callPackage ../data/fonts/unifont_upper { };

  unscii = callPackage ../data/fonts/unscii { };

  vanilla-dmz = callPackage ../data/icons/vanilla-dmz { };

  vdrsymbols = callPackage ../data/fonts/vdrsymbols { };

  vegur = callPackage ../data/fonts/vegur { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  vistafonts-chs = callPackage ../data/fonts/vista-fonts-chs { };

  wireless-regdb = callPackage ../data/misc/wireless-regdb { };

  wqy_microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

  xits-math = callPackage ../data/fonts/xits-math { };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = pythonPackages.xlsx2csv;

  xorg-rgb = callPackage ../data/misc/xorg-rgb {};

  zeal = libsForQt5.callPackage ../data/documentation/zeal { };

  zilla-slab = callPackage ../data/fonts/zilla-slab { };


  ### APPLICATIONS

  _2bwm = callPackage ../applications/window-managers/2bwm {
    patches = config."2bwm".patches or [];
  };

  a2jmidid = callPackage ../applications/audio/a2jmidid { };

  aacgain = callPackage ../applications/audio/aacgain { };

  abcde = callPackage ../applications/audio/abcde {
    inherit (perlPackages) MusicBrainz MusicBrainzDiscID;
    inherit (pythonPackages) eyeD3;
  };

  abiword = callPackage ../applications/office/abiword {
    iconTheme = gnome3.defaultIconTheme;
  };

  abook = callPackage ../applications/misc/abook { };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python3Packages)
      buildPythonApplication appdirs colorama dateutil
      requests requests_toolbelt sqlalchemy fusepy;
  };

  adobe-reader = pkgsi686Linux.callPackage ../applications/misc/adobe-reader { };

  masterpdfeditor = libsForQt5.callPackage ../applications/misc/masterpdfeditor { };

  aeolus = callPackage ../applications/audio/aeolus { };

  aewan = callPackage ../applications/editors/aewan { };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
    stdenv = overrideCC stdenv gcc49;
  };

  agedu = callPackage ../tools/misc/agedu { };

  ahoviewer = callPackage ../applications/graphics/ahoviewer {
    useUnrar = config.ahoviewer.useUnrar or false;
  };

  airwave = callPackage ../applications/audio/airwave { };

  alembic = callPackage ../development/libraries/alembic {};

  alchemy = callPackage ../applications/graphics/alchemy { };

  alock = callPackage ../misc/screensavers/alock { };

  inherit (python2Packages) alot;

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };

  msgviewer = callPackage ../applications/networking/mailreaders/msgviewer { };

  amarok = libsForQt5.callPackage ../applications/audio/amarok { };
  amarok-kf5 = amarok; # for compatibility

  AMB-plugins = callPackage ../applications/audio/AMB-plugins { };

  ams-lv2 = callPackage ../applications/audio/ams-lv2 { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  androidStudioPackages = recurseIntoAttrs
    (callPackage ../applications/editors/android-studio { });
  android-studio = androidStudioPackages.stable;
  android-studio-preview = androidStudioPackages.beta;

  animbar = callPackage ../applications/graphics/animbar { };

  antfs-cli = callPackage ../applications/misc/antfs-cli {};

  antimony = libsForQt5.callPackage ../applications/graphics/antimony {};

  antiword = callPackage ../applications/office/antiword {};

  ao = callPackage ../applications/graphics/ao {};

  apache-directory-studio = callPackage ../applications/networking/apache-directory-studio {};

  aqemu = libsForQt5.callPackage ../applications/virtualization/aqemu { };

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome2) libgnomecanvas libgnomecanvasmm;
    inherit (vamp) vampSDK;
  };

  inherit (python3Packages) arelle;

  ario = callPackage ../applications/audio/ario { };

  arora = callPackage ../applications/networking/browsers/arora { };

  artha = callPackage ../applications/misc/artha { };

  atlassian-cli = callPackage ../applications/office/atlassian-cli { };

  atomEnv = callPackage ../applications/editors/atom/env.nix {
    gconf = gnome2.GConf;
  };

  atomPackages = callPackage ../applications/editors/atom { };

  inherit (atomPackages) atom atom-beta;

  aseprite = callPackage ../applications/editors/aseprite { };
  aseprite-unfree = aseprite.override { unfree = true; };

  astah-community = callPackage ../applications/graphics/astah-community { };

  astroid = callPackage ../applications/networking/mailreaders/astroid { };

  audacious = callPackage ../applications/audio/audacious { };
  audaciousQt5 = libsForQt5.callPackage ../applications/audio/audacious/qt-5.nix { };

  audacity = callPackage ../applications/audio/audacity { };

  audio-recorder = callPackage ../applications/audio/audio-recorder { };

  autokey = callPackage ../applications/office/autokey { };

  autotrace = callPackage ../applications/graphics/autotrace {};

  avocode = callPackage ../applications/graphics/avocode {};

  cadence =  libsForQt5.callPackage ../applications/audio/cadence { };

  milkytracker = callPackage ../applications/audio/milkytracker { };

  schismtracker = callPackage ../applications/audio/schismtracker { };

  altcoins = recurseIntoAttrs ( callPackage ../applications/altcoins { } );

  bitcoin = altcoins.bitcoin;
  clightning = altcoins.clightning;

  bitcoin-xt = altcoins.bitcoin-xt;
  cryptop = altcoins.cryptop;

  libbitcoin = callPackage ../tools/misc/libbitcoin/libbitcoin.nix {
    secp256k1 = secp256k1.override { enableECDH = true; };
  };

  libbitcoin-protocol = callPackage ../tools/misc/libbitcoin/libbitcoin-protocol.nix { };
  libbitcoin-client   = callPackage ../tools/misc/libbitcoin/libbitcoin-client.nix { };
  libbitcoin-network  = callPackage ../tools/misc/libbitcoin/libbitcoin-network.nix { };
  libbitcoin-explorer = callPackage ../tools/misc/libbitcoin/libbitcoin-explorer.nix { };


  go-ethereum = self.altcoins.go-ethereum;
  ethsign = self.altcoins.ethsign;
  ethabi = self.altcoins.ethabi;
  ethrun = self.altcoins.ethrun;
  seth = self.altcoins.seth;
  dapp = self.altcoins.dapp;
  hevm = self.altcoins.hevm;

  parity = self.altcoins.parity;
  parity-beta = self.altcoins.parity-beta;
  parity-ui = self.altcoins.parity-ui;

  stellar-core = self.altcoins.stellar-core;

  particl-core = self.altcoins.particl-core;

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  aesop = callPackage ../applications/office/aesop { };

  avidemux = libsForQt5.callPackage ../applications/video/avidemux { };

  avrdudess = callPackage ../applications/misc/avrdudess { };

  avxsynth = callPackage ../applications/video/avxsynth {
    libjpeg = libjpeg_original; # error: 'JCOPYRIGHT_SHORT' was not declared in this scope
    ffmpeg = ffmpeg_2;
  };

  awesome-4-0 = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    luaPackages = luaPackages.override { inherit lua; };
  };
  awesome = awesome-4-0;

  awesomebump = libsForQt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome3) baobab;

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt4 = callPackage ../applications/networking/sync/backintime/qt4.nix { };

  backintime = backintime-qt4;

  balsa = callPackage ../applications/networking/mailreaders/balsa { };

  bandwidth = callPackage ../tools/misc/bandwidth { };

  baresip = callPackage ../applications/networking/instant-messengers/baresip {
    ffmpeg = ffmpeg_1;
  };

  barrier = callPackage ../applications/misc/barrier {};

  bashSnippets = callPackage ../applications/misc/bashSnippets { };

  batik = callPackage ../applications/graphics/batik { };

  batti = callPackage ../applications/misc/batti { };

  baudline = callPackage ../applications/audio/baudline { };


  bazaar = callPackage ../applications/version-management/bazaar { };

  bazaarTools = callPackage ../applications/version-management/bazaar/tools.nix { };

  bb =  callPackage ../applications/misc/bb { };

  beast = callPackage ../applications/audio/beast {
    inherit (gnome2) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bevelbar = callPackage ../applications/window-managers/bevelbar { };

  bibletime = callPackage ../applications/misc/bibletime { };

  bitcoinarmory = callPackage ../applications/misc/bitcoinarmory { pythonPackages = python2Packages; };

  bitkeeper = callPackage ../applications/version-management/bitkeeper {
    gperf = gperf_3_0;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitlbee-discord = callPackage ../applications/networking/instant-messengers/bitlbee-discord { };

  bitlbee-facebook = callPackage ../applications/networking/instant-messengers/bitlbee-facebook { };

  bitlbee-steam = callPackage ../applications/networking/instant-messengers/bitlbee-steam { };

  bitmeter = callPackage ../applications/audio/bitmeter { };

  bitscope = recurseIntoAttrs
    (callPackage ../applications/science/electronics/bitscope/packages.nix { });

  bitwig-studio1 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio1.nix {
    inherit (gnome3) zenity;
  };
  bitwig-studio2 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio2.nix {
    inherit (gnome3) zenity;
    inherit (self) bitwig-studio1;
  };
  bitwig-studio = bitwig-studio2;

  bgpdump = callPackage ../tools/networking/bgpdump { };

  blackbox = callPackage ../applications/version-management/blackbox { };

  bleachbit = callPackage ../applications/misc/bleachbit { };

  blender = callPackage  ../applications/misc/blender {
    cudaSupport = config.cudaSupport or false;
    pythonPackages = python35Packages;
    stdenv = overrideCC stdenv gcc6;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluejeans = callPackage ../applications/networking/browsers/mozilla-plugins/bluejeans { };

  bombono = callPackage ../applications/video/bombono {};

  bomi = libsForQt5.callPackage ../applications/video/bomi {
    pulseSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  bonzomatic = callPackage ../applications/editors/bonzomatic { };

  brackets = callPackage ../applications/editors/brackets { gconf = gnome2.GConf; };

  notmuch-bower = callPackage ../applications/networking/mailreaders/notmuch-bower { };

  bristol = callPackage ../applications/audio/bristol { };

  bs1770gain = callPackage ../applications/audio/bs1770gain {
    ffmpeg = ffmpeg_2;
  };

  bspwm = callPackage ../applications/window-managers/bspwm { };

  bspwm-unstable = callPackage ../applications/window-managers/bspwm/unstable.nix { };

  btops = callPackage ../applications/window-managers/btops { };

  bvi = callPackage ../applications/editors/bvi { };

  bviplus = callPackage ../applications/editors/bviplus { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome2) libglade;
      stdenv = overrideCC stdenv gcc5;
  };

  calcurse = callPackage ../applications/misc/calcurse { };

  calibre = libsForQt5.callPackage ../applications/misc/calibre { };

  calligra = libsForQt5.callPackage ../applications/office/calligra {
    inherit (kdeApplications) akonadi-calendar akonadi-contacts;
    openjpeg = openjpeg_1;
  };

  perkeep = callPackage ../applications/misc/perkeep { };

  canto-curses = callPackage ../applications/networking/feedreaders/canto-curses { };

  canto-daemon = callPackage ../applications/networking/feedreaders/canto-daemon { };

  carddav-util = callPackage ../tools/networking/carddav-util { };

  catfish = callPackage ../applications/search/catfish { };

  cava = callPackage ../applications/audio/cava { };

  cb2bib = libsForQt5.callPackage ../applications/office/cb2bib { };

  cbatticon = callPackage ../applications/misc/cbatticon { };

  cbc = callPackage ../applications/science/math/cbc { };

  cddiscid = callPackage ../applications/audio/cd-discid {
    inherit (darwin) IOKit;
  };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia {
    inherit (darwin) IOKit;
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  cdrtools = callPackage ../applications/misc/cdrtools { };

  centerim = callPackage ../applications/networking/instant-messengers/centerim { };

  cgit = callPackage ../applications/version-management/git-and-tools/cgit {
    inherit (python3Packages) python wrapPython pygments markdown;
  };

  cgminer = callPackage ../applications/misc/cgminer {
    amdappsdk = amdappsdk28;
  };

  chatzilla = callPackage ../applications/networking/irc/chatzilla { };

  chirp = callPackage ../applications/misc/chirp {
    inherit (pythonPackages) pyserial pygtk;
  };

  browsh = callPackage ../applications/networking/browsers/browsh { };

  bookworm = callPackage ../applications/office/bookworm { };

  chromium = callPackage ../applications/networking/browsers/chromium {
    channel = "stable";
    pulseSupport = config.pulseaudio or true;
    enablePepperFlash = config.chromium.enablePepperFlash or false;
    enableWideVine = config.chromium.enableWideVine or false;
    gnome = gnome2;
  };

  chronos = callPackage ../applications/networking/cluster/chronos { };

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel;
  };

  cinelerra = callPackage ../applications/video/cinelerra { };

  claws-mail = callPackage ../applications/networking/mailreaders/claws-mail {
    inherit (gnome3) gsettings-desktop-schemas;
    inherit (xorg) libSM;
    enableNetworkManager = config.networking.networkmanager.enable or false;
  };

  clfswm = callPackage ../applications/window-managers/clfswm { };

  cligh = python3Packages.callPackage ../development/tools/github/cligh {};

  clipgrab = callPackage ../applications/video/clipgrab { };

  clipmenu = callPackage ../applications/misc/clipmenu { };

  clipit = callPackage ../applications/misc/clipit { };

  cloud-print-connector = callPackage ../servers/cloud-print-connector { };

  clp = callPackage ../applications/science/math/clp { };

  cmatrix = callPackage ../applications/misc/cmatrix { };

  cmus = callPackage ../applications/audio/cmus {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    libjack = libjack2;
    ffmpeg = ffmpeg_2;

    pulseaudioSupport = config.pulseaudio or false;
  };

  cni = callPackage ../applications/networking/cluster/cni {};
  cni-plugins = callPackage ../applications/networking/cluster/cni/plugins.nix {};

  communi = libsForQt5.callPackage ../applications/networking/irc/communi { };

  confclerk = callPackage ../applications/misc/confclerk { };

  copyq = libsForQt5.callPackage ../applications/misc/copyq { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome2) libgnomeui GConf;
  };

  csound = callPackage ../applications/audio/csound { };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    fltk = fltk13;
    libpng = libpng12;
    cmake = cmake_2_8;
  };

  codeblocks = callPackage ../applications/editors/codeblocks { };
  codeblocksFull = codeblocks.override { contribPlugins = true; };

  comical = callPackage ../applications/graphics/comical { };

  conkeror-unwrapped = callPackage ../applications/networking/browsers/conkeror { };
  conkeror = wrapFirefox conkeror-unwrapped { };

  containerd = callPackage ../applications/virtualization/containerd { };

  convchain = callPackage ../tools/graphics/convchain {};

  coursera-dl = callPackage ../applications/misc/coursera-dl {};

  coyim = callPackage ../applications/networking/instant-messengers/coyim {};

  cpp_ethereum = callPackage ../applications/misc/cpp-ethereum { };

  csdp = callPackage ../applications/science/math/csdp {
    liblapack = liblapackWithoutAtlas;
  };

  ctop = callPackage ../tools/system/ctop { };

  cuneiform = callPackage ../tools/graphics/cuneiform {};

  cutecom = libsForQt5.callPackage ../tools/misc/cutecom { };

  cutegram =
    let callpkg = libsForQt56.callPackage;
    in callpkg ../applications/networking/instant-messengers/telegram/cutegram rec {
      libqtelegram-aseman-edition = callpkg ../applications/networking/instant-messengers/telegram/libqtelegram-aseman-edition { };
      telegram-qml = callpkg ../applications/networking/instant-messengers/telegram/telegram-qml {
        inherit libqtelegram-aseman-edition;
      };
    };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  cwm = callPackage ../applications/window-managers/cwm { };

  cyclone = callPackage ../applications/audio/pd-plugins/cyclone  { };

  darcs = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.darcs) (drv: {
    configureFlags = (stdenv.lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
  });

  darktable = callPackage ../applications/graphics/darktable {
    lua = lua5_3;
    pugixml = pugixml.override { shared = true; };
  };

  das_watchdog = callPackage ../tools/system/das_watchdog { };

  dbvisualizer = callPackage ../applications/misc/dbvisualizer {};

  dd-agent = callPackage ../tools/networking/dd-agent/5.nix { };
  datadog-agent = callPackage ../tools/networking/dd-agent/6.nix {
    pythonPackages = datadog-integrations-core {};
  };
  datadog-process-agent = callPackage ../tools/networking/dd-agent/datadog-process-agent.nix { };
  datadog-integrations-core = extras: callPackage ../tools/networking/dd-agent/integrations-core.nix {
    python = python27;
    extraIntegrations = extras;
  };

  ddgr = callPackage ../applications/misc/ddgr { };

  deadbeef = callPackage ../applications/audio/deadbeef {
    pulseSupport = config.pulseaudio or true;
  };

  deadbeefPlugins = {
    headerbar-gtk3 = callPackage ../applications/audio/deadbeef/plugins/headerbar-gtk3.nix { };
    infobar = callPackage ../applications/audio/deadbeef/plugins/infobar.nix { };
    mpris2 = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };
    opus = callPackage ../applications/audio/deadbeef/plugins/opus.nix { };
  };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [];
  };

  dfasma = libsForQt5.callPackage ../applications/audio/dfasma { };

  dfilemanager = libsForQt5.callPackage ../applications/misc/dfilemanager { };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome2) libart_lgpl libgnomeui;
  };

  diffuse = callPackage ../applications/version-management/diffuse { };

  direwolf = callPackage ../applications/misc/direwolf { };

  dirt = callPackage ../applications/audio/dirt {};

  distrho = callPackage ../applications/audio/distrho {};

  dit = callPackage ../applications/editors/dit { };

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djvu2pdf = callPackage ../tools/typesetting/djvu2pdf { };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = pkgs.djview;

  dmenu = callPackage ../applications/misc/dmenu { };

  dmenu2 = callPackage ../applications/misc/dmenu2 { };

  dmensamenu = callPackage ../applications/misc/dmensamenu {
    inherit (python3Packages) buildPythonApplication requests;
  };

  dmtx-utils = callPackage (callPackage ../tools/graphics/dmtx-utils) {
  };

  inherit (callPackage ../applications/virtualization/docker {})
    docker_18_06;

  docker = docker_18_06;
  docker-edge = docker_18_06;

  docker-proxy = callPackage ../applications/virtualization/docker/proxy.nix { };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };

  docker-machine = callPackage ../applications/networking/cluster/docker-machine { };
  docker-machine-kvm = callPackage ../applications/networking/cluster/docker-machine/kvm.nix { };
  docker-machine-kvm2 = callPackage ../applications/networking/cluster/docker-machine/kvm2.nix { };
  docker-machine-xhyve = callPackage ../applications/networking/cluster/docker-machine/xhyve.nix {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
  };

  docker-distribution = callPackage ../applications/virtualization/docker/distribution.nix { };

  amazon-ecr-credential-helper = callPackage ../tools/admin/amazon-ecr-credential-helper { };

  docker-credential-gcr = callPackage ../tools/admin/docker-credential-gcr { };

  doodle = callPackage ../applications/search/doodle { };

  dr14_tmeter = callPackage ../applications/audio/dr14_tmeter { };

  draftsight = callPackage ../applications/graphics/draftsight { };

  dragonfly-reverb = callPackage ../applications/audio/dragonfly-reverb { };

  drawpile = libsForQt5.callPackage ../applications/graphics/drawpile { };

  droopy = callPackage ../applications/networking/droopy {
    inherit (python3Packages) wrapPython;
  };

  drumgizmo = callPackage ../applications/audio/drumgizmo { };

  dunst = callPackage ../applications/misc/dunst { };

  du-dust = callPackage ../tools/misc/dust { };

  devede = callPackage ../applications/video/devede { };

  denemo = callPackage ../applications/audio/denemo {
    inherit (gnome3) gtksourceview;
  };

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dvdbackup = callPackage ../applications/video/dvdbackup { };

  dvd-slideshow = callPackage ../applications/video/dvd-slideshow { };

  dvdstyler = callPackage ../applications/video/dvdstyler {
    inherit (gnome2) libgnomeui;
  };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = config.dwm.patches or [];
  };

  dwm-git = callPackage ../applications/window-managers/dwm/git.nix {
    patches = config.dwm.patches or [];
    conf = config.dwm.conf or null;
  };

  dwm-status = callPackage ../applications/window-managers/dwm/dwm-status.nix { };

  dynamips = callPackage ../applications/virtualization/dynamips { };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [];
  };

  dzen2 = callPackage ../applications/window-managers/dzen2 { };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse {
    jdk = jdk10;
  });

  ecs-agent = callPackage ../applications/virtualization/ecs-agent { };

  ed = callPackage ../applications/editors/ed { };

  edbrowse = callPackage ../applications/editors/edbrowse { };

  ekho = callPackage ../applications/audio/ekho { };

  electron-cash = libsForQt5.callPackage ../applications/misc/electron-cash { };

  electrum = callPackage ../applications/misc/electrum { };

  electrum-dash = callPackage ../applications/misc/electrum/dash.nix { };

  electrum-ltc = callPackage ../applications/misc/electrum/ltc.nix { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs26;
  emacsPackages = emacs26Packages;
  emacsPackagesNg = emacs26PackagesNg;

  emacs26 = callPackage ../applications/editors/emacs {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs26-nox = lowPrio (appendToName "nox" (emacs26.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacs25 = callPackage ../applications/editors/emacs/25.nix {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs25-nox = lowPrio (appendToName "nox" (emacs25.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacsMacport = emacs25Macport;
  emacs25Macport = callPackage ../applications/editors/emacs/macport.nix {
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
  };

  emacsPackagesFor = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

    bbdb3 = callPackage ../applications/editors/emacs-modes/bbdb/3.nix {};

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    calfw = callPackage ../applications/editors/emacs-modes/calfw { };

    coffee = callPackage ../applications/editors/emacs-modes/coffee { };

    colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };

    colorThemeSolarized = callPackage ../applications/editors/emacs-modes/color-theme-solarized { };

    cryptol = callPackage ../applications/editors/emacs-modes/cryptol { };

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    d = callPackage ../applications/editors/emacs-modes/d { };

    darcsum = callPackage ../applications/editors/emacs-modes/darcsum { };

    # ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

    emms = callPackage ../applications/editors/emacs-modes/emms { };

    ensime = callPackage ../applications/editors/emacs-modes/ensime { };

    erlangMode = callPackage ../applications/editors/emacs-modes/erlang { };

    ess = callPackage ../applications/editors/emacs-modes/ess { };

    flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };

    gh = callPackage ../applications/editors/emacs-modes/gh { };

    graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };

    gist = callPackage ../applications/editors/emacs-modes/gist { };

    haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };

    hsc3Mode = callPackage ../applications/editors/emacs-modes/hsc3 { };

    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };

    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };

    ido-ubiquitous = callPackage ../applications/editors/emacs-modes/ido-ubiquitous { };

    icicles = callPackage ../applications/editors/emacs-modes/icicles { };

    idris = callPackage ../applications/editors/emacs-modes/idris { };

    jabber = callPackage ../applications/editors/emacs-modes/jabber { };

    jade = callPackage ../applications/editors/emacs-modes/jade { };

    jdee = callPackage ../applications/editors/emacs-modes/jdee { };

    js2 = callPackage ../applications/editors/emacs-modes/js2 { };

    let-alist = callPackage ../applications/editors/emacs-modes/let-alist { };

    logito = callPackage ../applications/editors/emacs-modes/logito { };

    loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };

    markdownMode = callPackage ../applications/editors/emacs-modes/markdown-mode { };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    metaweblog = callPackage ../applications/editors/emacs-modes/metaweblog { };

    monky = callPackage ../applications/editors/emacs-modes/monky { };

    notmuch = lowPrio (pkgs.notmuch.override { inherit emacs; });

    ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };

    offlineimap = callPackage ../applications/editors/emacs-modes/offlineimap {};

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });

    org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };

    pcache = callPackage ../applications/editors/emacs-modes/pcache { };

    phpMode = callPackage ../applications/editors/emacs-modes/php { };

    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };

    proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral/4.4.nix {
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };
    proofgeneral_HEAD = callPackage ../applications/editors/emacs-modes/proofgeneral/HEAD.nix {
      texinfo = texinfo4 ;
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };

    quack = callPackage ../applications/editors/emacs-modes/quack { };

    rainbowDelimiters = callPackage ../applications/editors/emacs-modes/rainbow-delimiters { };

    rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };

    remember = callPackage ../applications/editors/emacs-modes/remember { };

    rudel = callPackage ../applications/editors/emacs-modes/rudel { };

    s = callPackage ../applications/editors/emacs-modes/s { };

    sbtMode = callPackage ../applications/editors/emacs-modes/sbt-mode { };

    scalaMode1 = callPackage ../applications/editors/emacs-modes/scala-mode/v1.nix { };
    scalaMode2 = callPackage ../applications/editors/emacs-modes/scala-mode/v2.nix { };

    structuredHaskellMode = haskellPackages.structured-haskell-mode;

    sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };

    tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };

    writeGood = callPackage ../applications/editors/emacs-modes/writegood { };

    xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };

    cask = callPackage ../applications/editors/emacs-modes/cask { };
  };

  emacs25Packages = emacsPackagesFor emacs25 pkgs.emacs25Packages;
  emacs26Packages = emacsPackagesFor emacs26 pkgs.emacs26Packages;

  emacsPackagesNgFor = emacs: import ./emacs-packages.nix {
    inherit lib newScope stdenv;
    inherit fetchFromGitHub fetchgit fetchhg fetchurl fetchpatch;
    inherit emacs texinfo makeWrapper runCommand writeText;
    inherit (xorg) lndir;

    trivialBuild = callPackage ../build-support/emacs/trivial.nix {
      inherit emacs;
    };

    melpaBuild = callPackage ../build-support/emacs/melpa.nix {
      inherit emacs;
    };

    external = {
      inherit (haskellPackages) ghc-mod structured-haskell-mode Agda hindent;
      inherit (pythonPackages) elpy;
      inherit
        autoconf automake git libffi libpng pkgconfig poppler rtags w3m zlib;
    };
  };

  emacs25PackagesNg = emacsPackagesNgFor emacs25;
  emacs25WithPackages = emacs25PackagesNg.emacsWithPackages;
  emacs26PackagesNg = emacsPackagesNgFor emacs26;
  emacs26WithPackages = emacs26PackagesNg.emacsWithPackages;
  emacsWithPackages = emacsPackagesNg.emacsWithPackages;

  inherit (gnome3) empathy;

  enhanced-ctorrent = callPackage ../applications/networking/enhanced-ctorrent { };

  eolie = callPackage ../applications/networking/browsers/eolie { };

  epdfview = callPackage ../applications/misc/epdfview { };

  epeg = callPackage ../applications/graphics/epeg { };

  inherit (gnome3) epiphany;

  epic5 = callPackage ../applications/networking/irc/epic5 { };

  eq10q = callPackage ../applications/audio/eq10q { };

  errbot = callPackage ../applications/networking/errbot {
    pythonPackages = python3Packages;
  };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak-ng = callPackage ../applications/audio/espeak-ng { };
  espeak = self.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  esniper = callPackage ../applications/networking/esniper { };

  eterm = callPackage ../applications/misc/eterm { };

  etherape = callPackage ../applications/networking/sniffers/etherape { };

  evilvte = callPackage ../applications/misc/evilvte {
    configH = config.evilvte.config or "";
  };

  evopedia = callPackage ../applications/misc/evopedia { };

  exercism = callPackage ../applications/misc/exercism { };

  gpg-mdp = callPackage ../applications/misc/gpg-mdp { };

  icesl = callPackage ../applications/misc/icesl { };

  keepassx = callPackage ../applications/misc/keepassx { };
  keepassx2 = callPackage ../applications/misc/keepassx/2.0.nix { };
  keepassxc = libsForQt5.callPackage ../applications/misc/keepassx/community.nix { };

  inherit (gnome3) evince;
  evolution-data-server = gnome3.evolution-data-server;

  keepass = callPackage ../applications/misc/keepass {
    buildDotnetPackage = buildDotnetPackage.override { mono = mono54; };
  };

  keepass-keeagent = callPackage ../applications/misc/keepass-plugins/keeagent { };

  keepass-keepasshttp = callPackage ../applications/misc/keepass-plugins/keepasshttp { };

  keepass-keepassrpc = callPackage ../applications/misc/keepass-plugins/keepassrpc { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay { };

  exrtools = callPackage ../applications/graphics/exrtools { };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fbreader = callPackage ../applications/misc/fbreader {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  fdr = libsForQt5.callPackage ../applications/science/programming/fdr { };

  fehlstart = callPackage ../applications/misc/fehlstart { };

  fetchmail = callPackage ../applications/misc/fetchmail { };

  fig2dev = callPackage ../applications/graphics/fig2dev { };

  flacon = callPackage ../applications/audio/flacon { };

  flexget = callPackage ../applications/networking/flexget { };

  fldigi = callPackage ../applications/audio/fldigi { };

  flink = callPackage ../applications/networking/cluster/flink { };
  flink_1_5 = flink.override { version = "1.5"; };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
     inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio CoreMIDI CoreServices;
  };

  fmit = libsForQt5.callPackage ../applications/audio/fmit { };

  fmsynth = callPackage ../applications/audio/fmsynth { };

  focuswriter = libsForQt5.callPackage ../applications/editors/focuswriter { };

  font-manager = callPackage ../applications/misc/font-manager { };

  foo-yc20 = callPackage ../applications/audio/foo-yc20 { };

  fossil = callPackage ../applications/version-management/fossil { };

  freebayes = callPackage ../applications/science/biology/freebayes { };

  freewheeling = callPackage ../applications/audio/freewheeling { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid { };

  fritzing = libsForQt5.callPackage ../applications/science/electronics/fritzing { };

  fvwm = callPackage ../applications/window-managers/fvwm { };

  ganttproject-bin = callPackage ../applications/misc/ganttproject-bin { };

  gauche = callPackage ../development/interpreters/gauche { };

  gcal = callPackage ../applications/misc/gcal { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  ghostwriter = libsForQt5.callPackage ../applications/editors/ghostwriter { };

  gitweb = callPackage ../applications/version-management/git-and-tools/gitweb { };

  gksu = callPackage ../applications/misc/gksu { };

  gnss-sdr = callPackage ../applications/misc/gnss-sdr { boost=boost166; };

  gnuradio = callPackage ../applications/misc/gnuradio {
    inherit (python2Packages) cheetah lxml Mako matplotlib numpy python pyopengl pyqt4 scipy wxPython pygtk;
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    fftw = fftwFloat;
    qwt = qwt6_qt4;
  };

  gnuradio-with-packages = callPackage ../applications/misc/gnuradio/wrapper.nix {
    inherit (python2Packages) python;
    extraPackages = [ gnuradio-nacl gnuradio-osmosdr gnuradio-gsm gnuradio-ais gnuradio-rds gnuradio-limesdr ];
  };

  gnuradio-nacl = callPackage ../applications/misc/gnuradio/nacl.nix { };

  gnuradio-gsm = callPackage ../applications/misc/gnuradio/gsm.nix { };

  gnuradio-ais = callPackage ../applications/misc/gnuradio/ais.nix { };

  gnuradio-limesdr = callPackage ../applications/misc/gnuradio/limesdr.nix { };

  gnuradio-rds = callPackage ../applications/misc/gnuradio/rds.nix { };

  gnuradio-osmosdr = callPackage ../applications/misc/gnuradio/osmosdr.nix { };

  goldendict = libsForQt5.callPackage ../applications/misc/goldendict { };

  gomuks = callPackage ../applications/networking/instant-messengers/gomuks { };

  inherit (ocamlPackages) google-drive-ocamlfuse;

  google-musicmanager = callPackage ../applications/audio/google-musicmanager {
    inherit (qt5) qtbase qtwebkit;
    # Downgrade to 1.34 to get libidn.so.11
    libidn = (libidn.overrideAttrs (oldAttrs: {
      src = fetchurl {
        url = "mirror://gnu/libidn/libidn-1.34.tar.gz";
        sha256 = "0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p";
      };
    })).out;
  };

  googler = callPackage ../applications/misc/googler {
    python = python3;
  };

  gopher = callPackage ../applications/networking/gopher/gopher { };

  gopherclient = libsForQt5.callPackage ../applications/networking/gopher/gopherclient { };

  goxel = callPackage ../applications/graphics/goxel { };

  gpa = callPackage ../applications/misc/gpa { };

  gpicview = callPackage ../applications/graphics/gpicview {
    gtk2 = gtk2-x11;
  };

  gpx = callPackage ../applications/misc/gpx { };

  gqrx = qt5.callPackage ../applications/misc/gqrx { };

  gpx-viewer = callPackage ../applications/misc/gpx-viewer { };

  grass = callPackage ../applications/gis/grass { };

  grepcidr = callPackage ../applications/search/grepcidr { };

  grepm = callPackage ../applications/search/grepm { };

  grip = callPackage ../applications/misc/grip {
    inherit (gnome2) libgnome libgnomeui vte;
  };

  gsimplecal = callPackage ../applications/misc/gsimplecal { };

  gthumb = callPackage ../applications/graphics/gthumb { };

  gtimelog = pythonPackages.gtimelog;

  inherit (gnome3) gucharmap;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  gjay = callPackage ../applications/audio/gjay { };

  photivo = callPackage ../applications/graphics/photivo { };

  rhythmbox = callPackage ../applications/audio/rhythmbox { };

  gradio = callPackage ../applications/audio/gradio { };

  puddletag = callPackage ../applications/audio/puddletag { };

  w_scan = callPackage ../applications/video/w_scan { };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wavrsocvt = callPackage ../applications/misc/audio/wavrsocvt { };

  welle-io = libsForQt5.callPackage ../applications/misc/welle-io { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark {
    withQt = true;
    qt5 = qt59;
    withGtk = false;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices SystemConfiguration;
  };
  wireshark-qt = wireshark;

  # The GTK UI is deprecated by upstream. You probably want the QT version.
  wireshark-gtk = wireshark.override { withGtk = true; withQt = false; };
  wireshark-cli = wireshark.override { withGtk = false; withQt = false; };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  firefoxPackages = recurseIntoAttrs (callPackage ../applications/networking/browsers/firefox/packages.nix {
    callPackage = pkgs.newScope {
      inherit (gnome2) libIDL;
      libpng = libpng_apng;
      python = python2;
      gnused = gnused_422;
      icu = icu59;
      inherit (darwin.apple_sdk.frameworks) CoreMedia ExceptionHandling
                                            Kerberos AVFoundation MediaToolbox
                                            CoreLocation Foundation AddressBook;
      inherit (darwin) libobjc;
    };
  });

  firefox-unwrapped = firefoxPackages.firefox;
  firefox-esr-52-unwrapped = firefoxPackages.firefox-esr-52;
  firefox-esr-60-unwrapped = firefoxPackages.firefox-esr-60;
  tor-browser-unwrapped = firefoxPackages.tor-browser;

  firefox = wrapFirefox firefox-unwrapped { };
  firefox-esr-52 = wrapFirefox firefox-esr-52-unwrapped { };
  firefox-esr-60 = wrapFirefox firefox-esr-60-unwrapped { };
  firefox-esr = firefox-esr-60;

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "release";
    generated = import ../applications/networking/browsers/firefox-bin/release_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-bin = wrapFirefox firefox-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-bin-" +
      (builtins.parseDrvName firefox-bin-unwrapped.name).version;
    desktopName = "Firefox";
  };

  firefox-beta-bin-unwrapped = firefox-bin-unwrapped.override {
    channel = "beta";
    generated = import ../applications/networking/browsers/firefox-bin/beta_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-beta-bin = self.wrapFirefox firefox-beta-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-beta-bin-" +
      (builtins.parseDrvName firefox-beta-bin-unwrapped.name).version;
    desktopName = "Firefox Beta";
  };

  firefox-devedition-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "devedition";
    generated = import ../applications/networking/browsers/firefox-bin/devedition_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-devedition-bin = self.wrapFirefox firefox-devedition-bin-unwrapped {
    browserName = "firefox";
    nameSuffix = "-devedition";
    name = "firefox-devedition-bin-" +
      (builtins.parseDrvName firefox-devedition-bin-unwrapped.name).version;
    desktopName = "Firefox DevEdition";
  };

  firestr = libsForQt5.callPackage ../applications/networking/p2p/firestr
    { boost = boost155;
    };

  flac = callPackage ../applications/audio/flac { };

  flameshot = libsForQt5.callPackage ../tools/misc/flameshot { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer {
    debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer/standalone.nix {
    debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone-debugger = flashplayer-standalone.override {
    debug = true;
  };

  fluxbox = callPackage ../applications/window-managers/fluxbox { };

  fme = callPackage ../applications/misc/fme {
    inherit (gnome2) libglademm;
  };

  fomp = callPackage ../applications/audio/fomp { };

  freecad = callPackage ../applications/graphics/freecad { mpi = openmpi; };

  freemind = callPackage ../applications/misc/freemind { };

  freenet = callPackage ../applications/networking/p2p/freenet { };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  inherit (xorg) xlsfonts;

  xrdp = callPackage ../applications/networking/remote/xrdp { };

  freerdp = callPackage ../applications/networking/remote/freerdp {
    inherit libpulseaudio;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  freerdpUnstable = freerdp;

  # This must go when weston v2 is released
  freerdp_legacy = callPackage ../applications/networking/remote/freerdp/legacy.nix {
    cmake = cmake_2_8;
    ffmpeg = ffmpeg_1;
  };

  fte = callPackage ../applications/editors/fte { };

  game-music-emu = callPackage ../applications/audio/game-music-emu { };

  gcalcli = callPackage ../applications/misc/gcalcli { };

  vcal = callPackage ../applications/misc/vcal { };

  gcolor2 = callPackage ../applications/graphics/gcolor2 { };

  gcolor3 = callPackage ../applications/graphics/gcolor3 { };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  getxbook = callPackage ../applications/misc/getxbook {};

  ghq = gitAndTools.ghq;

  gimp = callPackage ../applications/graphics/gimp {
    gegl = gegl_0_4;
    lcms = lcms2;
    inherit (gnome3) gexiv2;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins {});

  girara = callPackage ../applications/misc/girara {
    gtk = gtk3;
  };

  gitAndTools = recurseIntoAttrs (callPackage ../applications/version-management/git-and-tools {});

  inherit (gitAndTools) git gitFull gitSVN git-cola svn2git git-radar git-secret git-secrets transcrypt git-crypt;

  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
    withpcre2 = false;
  };

  gitRepo = callPackage ../applications/version-management/git-repo {
    python = python27;
  };

  git-review = callPackage ../applications/version-management/git-review { };

  gitolite = callPackage ../applications/version-management/gitolite { };

  inherit (gnome3) gitg;

  giv = callPackage ../applications/graphics/giv { };

  gmrun = callPackage ../applications/misc/gmrun {};

  gnucash = callPackage ../applications/office/gnucash {
    inherit (gnome3) dconf;
  };

  gnucash24 = callPackage ../applications/office/gnucash/2.4.nix {
    inherit (gnome2) libgnomeui libgtkhtml gtkhtml libbonoboui libgnomeprint libglade libart_lgpl;
    gconf = gnome2.GConf;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
    goffice = goffice_0_8;
  };

  gnucash26 = lowPrio (callPackage ../applications/office/gnucash/2.6.nix {
    inherit (gnome2) libgnomecanvas;
    inherit (gnome3) dconf;
    gconf = gnome2.GConf;
    goffice = goffice_0_8;
    webkit = webkitgtk24x-gtk2;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
    glib = glib;
  });

  goffice = callPackage ../development/libraries/goffice { };

  goffice_0_8 = callPackage ../development/libraries/goffice/0.8.nix {
    inherit (pkgs.gnome2) libglade libgnomeui;
    gconf = pkgs.gnome2.GConf;
    libart = pkgs.gnome2.libart_lgpl;
  };

  jetbrains = (recurseIntoAttrs (callPackages ../applications/editors/jetbrains {
    jdk = jetbrains.jdk;
  }) // {
    jdk = callPackage ../development/compilers/jetbrains-jdk {  };
  });

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  linssid = libsForQt5.callPackage ../applications/networking/linssid { };

  lollypop = callPackage ../applications/audio/lollypop { };

  m32edit = callPackage ../applications/audio/midas/m32edit.nix {};

  manuskript = callPackage ../applications/editors/manuskript { };

  manul = callPackage ../development/tools/manul { };

  mi2ly = callPackage ../applications/audio/mi2ly {};

  moe =  callPackage ../applications/editors/moe { };

  multibootusb = callPackage ../applications/misc/multibootusb {};

  praat = callPackage ../applications/audio/praat { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua51Packages.luasocket;
    lua5 = lua5_1;
  };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  rhvoice = callPackage ../applications/audio/rhvoice { };

  svox = callPackage ../applications/audio/svox { };

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (darwin) IOKit;
  };

  gmtk = callPackage ../development/libraries/gmtk { };

  gmu = callPackage ../applications/audio/gmu { };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer { };

  gnumeric = callPackage ../applications/office/gnumeric { };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet_git = lowPrio (callPackage ../applications/networking/p2p/gnunet/git.nix { });

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby { };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = callPackage ../applications/misc/gphoto2/gphotofs.nix { };

  gramps = callPackage ../applications/misc/gramps {
        pythonPackages = python3Packages;
  };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };
  graphicsmagick_q16 = graphicsmagick.override { quantumdepth = 16; };

  graphicsmagick-imagemagick-compat = callPackage ../applications/graphics/graphicsmagick/compat.nix { };

  grisbi = callPackage ../applications/office/grisbi { gtk = gtk2; };

  gtkpod = callPackage ../applications/audio/gtkpod { };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrencode = callPackage ../tools/graphics/qrencode { };

  geeqie = callPackage ../applications/graphics/geeqie { };

  gigedit = callPackage ../applications/audio/gigedit { };

  gqview = callPackage ../applications/graphics/gqview { };

  gmpc = callPackage ../applications/audio/gmpc {};

  gmtp = callPackage ../applications/misc/gmtp {};

  gnomecast = callPackage ../applications/video/gnomecast { };

  gnome-mpv = callPackage ../applications/video/gnome-mpv { };

  gollum = callPackage ../applications/misc/gollum { };

  googleearth = callPackage ../applications/misc/googleearth { };

  google-chrome = callPackage ../applications/networking/browsers/google-chrome { gconf = gnome2.GConf; };

  google-chrome-beta = google-chrome.override { chromium = chromiumBeta; channel = "beta"; };

  google-chrome-dev = google-chrome.override { chromium = chromiumDev; channel = "dev"; };

  google-play-music-desktop-player = callPackage ../applications/audio/google-play-music-desktop-player {
    inherit (gnome2) GConf;
  };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gosmore = callPackage ../applications/misc/gosmore { };

  gpsbabel = libsForQt56.callPackage ../applications/misc/gpsbabel {
    inherit (darwin) IOKit;
  };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  gpsprune = callPackage ../applications/misc/gpsprune { };

  gpxsee = libsForQt5.callPackage ../applications/misc/gpxsee { };

  gspell = callPackage ../development/libraries/gspell { };

  gtk2fontsel = callPackage ../applications/misc/gtk2fontsel {
    inherit (gnome2) gtk;
  };

  guake = callPackage ../applications/misc/guake {
    inherit (gnome3) vte;
  };

  guitone = callPackage ../applications/version-management/guitone {
    graphviz = graphviz_2_32;
  };

  gv = callPackage ../applications/misc/gv { };

  gutenberg = callPackage ../applications/misc/gutenberg {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (darwin) cf-private;
  };

  guvcview = callPackage ../os-specific/linux/guvcview {
    pulseaudioSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  gxmessage = callPackage ../applications/misc/gxmessage { };

  hackrf = callPackage ../applications/misc/hackrf { };

  hakuneko = callPackage ../tools/misc/hakuneko { };

  hamster-time-tracker = callPackage ../applications/misc/hamster-time-tracker {
    inherit (gnome2) gnome_python;
  };

  hashit = callPackage ../tools/misc/hashit { };

  hello = callPackage ../applications/misc/hello { };
  hello-unfree = callPackage ../applications/misc/hello-unfree { };

  helmholtz = callPackage ../applications/audio/pd-plugins/helmholtz { };

  heme = callPackage ../applications/editors/heme { };

  herbstluftwm = callPackage ../applications/window-managers/herbstluftwm { };

  hexchat = callPackage ../applications/networking/irc/hexchat { };

  hexcurse = callPackage ../applications/editors/hexcurse { };

  hexedit = callPackage ../applications/editors/hexedit { };

  hipchat = callPackage ../applications/networking/instant-messengers/hipchat { };

  hledger = haskell.lib.justStaticExecutables haskellPackages.hledger;
  hledger-ui = haskell.lib.justStaticExecutables haskellPackages.hledger-ui;
  hledger-web = haskell.lib.justStaticExecutables haskellPackages.hledger-web;

  homebank = callPackage ../applications/office/homebank {
    gtk = gtk3;
  };

  ht = callPackage ../applications/editors/ht { };

  hubstaff = callPackage ../applications/misc/hubstaff { };

  hue-cli = callPackage ../tools/networking/hue-cli { };

  hugin = callPackage ../applications/graphics/hugin {
    wxGTK = wxGTK30;
  };

  hugo = callPackage ../applications/misc/hugo { };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  hyper = callPackage ../applications/misc/hyper { };

  hyper-haskell-server-with-packages = callPackage ../development/tools/haskell/hyper-haskell/server.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: with self; [];
  };

  hyper-haskell = callPackage ../development/tools/haskell/hyper-haskell {
    hyper-haskell-server = hyper-haskell-server-with-packages.override {
      packages = self: with self; [
        hyper-extra diagrams csound-catalog
      ];
    };
    extra-packages = [ csound ];
  };

  jackline = callPackage ../applications/networking/instant-messengers/jackline { };

  slack = callPackage ../applications/networking/instant-messengers/slack { };

  slack-cli = callPackage ../tools/networking/slack-cli { };

  singularity = callPackage ../applications/virtualization/singularity { };

  spectrwm = callPackage ../applications/window-managers/spectrwm { };

  super-productivity = callPackage ../applications/networking/super-productivity { };

  wlc = callPackage ../development/libraries/wlc { };
  wlroots = callPackage ../development/libraries/wlroots { };
  rootston = wlroots.bin;
  orbment = callPackage ../applications/window-managers/orbment { };
  sway = callPackage ../applications/window-managers/sway { };

  velox = callPackage ../applications/window-managers/velox {
    stConf = config.st.conf or null;
    stPatches = config.st.patches or null;
  };

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-gaps = callPackage ../applications/window-managers/i3/gaps.nix { };

  i3-easyfocus = callPackage ../applications/window-managers/i3/easyfocus.nix { };

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3blocks-gaps = callPackage ../applications/window-managers/i3/blocks-gaps.nix { };

  i3cat = callPackage ../tools/misc/i3cat { };

  i3ipc-glib = callPackage ../applications/window-managers/i3/i3ipc-glib.nix { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  i3lock-color = callPackage ../applications/window-managers/i3/lock-color.nix { };

  i3lock-fancy = callPackage ../applications/window-managers/i3/lock-fancy.nix { };

  i3lock-pixeled = callPackage ../misc/screensavers/i3lock-pixeled { };

  i3minator = callPackage ../tools/misc/i3minator { };

  i3pystatus = callPackage ../applications/window-managers/i3/pystatus.nix { };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i3status-rust = callPackage ../applications/window-managers/i3/status-rust.nix { };

  i3-wk-switch = callPackage ../applications/window-managers/i3/wk-switch.nix { };

  i810switch = callPackage ../os-specific/linux/i810switch { };

  icewm = callPackage ../applications/window-managers/icewm {};

  id3v2 = callPackage ../applications/audio/id3v2 { };

  ifenslave = callPackage ../os-specific/linux/ifenslave { };

  ii = callPackage ../applications/networking/irc/ii {
    stdenv = gccStdenv;
  };

  ike = callPackage ../applications/networking/ike { };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit (perlPackages) TextMarkdown URI HTMLParser HTMLScrubber
      HTMLTemplate TimeDate CGISession DBFile CGIFormBuilder LocaleGettext
      RpcXML XMLSimple YAML YAMLLibYAML HTMLTree Filechdir
      AuthenPassphrase NetOpenIDConsumer LWPxParanoidAgent CryptSSLeay;
    inherit (perlPackages.override { pkgs = pkgs // { imagemagick = imagemagickBig;}; }) PerlMagick;
  };

  iksemel = callPackage ../development/libraries/iksemel { };

  imagej = callPackage ../applications/graphics/imagej { };

  imagemagick_light = imagemagick.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
    libheif = null;
    libde265 = null;
  };

  imagemagick = callPackage ../applications/graphics/ImageMagick {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    ghostscript = null;
  };

  imagemagickBig = imagemagick.override { inherit ghostscript; };

  imagemagick7_light = lowPrio (imagemagick7.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
    libheif = null;
  });

  imagemagick7 = lowPrio (imagemagick7Big.override {
    ghostscript = null;
  });

  imagemagick7Big = lowPrio (callPackage ../applications/graphics/ImageMagick/7.0.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  });

  inherit (nodePackages) imapnotify;

  img2pdf = callPackage ../applications/misc/img2pdf { };

  imgcat = callPackage ../applications/graphics/imgcat { };

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive { };

  inferno = pkgsi686Linux.callPackage ../applications/inferno { };

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
    poppler = poppler_0_61;
  };

  inspectrum = libsForQt5.callPackage ../applications/misc/inspectrum { };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = libsForQt5.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    texlive = texlive.combine { inherit (texlive) scheme-small; };
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  iptraf-ng = callPackage ../applications/networking/iptraf-ng { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  irssi_fish = callPackage ../applications/networking/irc/irssi/fish { };

  irssi_otr = callPackage ../applications/networking/irc/irssi/otr { };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  bip = callPackage ../applications/networking/irc/bip { };

  j4-dmenu-desktop = callPackage ../applications/misc/j4-dmenu-desktop { };

  jabref = callPackage ../applications/office/jabref { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jackmix = callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jalv = callPackage ../applications/audio/jalv { };

  jameica = callPackage ../applications/office/jameica {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  jamin = callPackage ../applications/audio/jamin { };

  japa = callPackage ../applications/audio/japa { };

  jdupes = callPackage ../tools/misc/jdupes { };

  jedit = callPackage ../applications/editors/jedit { };

  jgmenu = callPackage ../applications/misc/jgmenu { };

  jigdo = callPackage ../applications/misc/jigdo { };

  jitsi = callPackage ../applications/networking/instant-messengers/jitsi { };

  joe = callPackage ../applications/editors/joe { };

  josm = callPackage ../applications/misc/josm { };

  jbrout = callPackage ../applications/graphics/jbrout { };

  jwm = callPackage ../applications/window-managers/jwm { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome2) gtkglext;
    stdenv = overrideCC stdenv gcc6;
  };

  k9copy = libsForQt5.callPackage ../applications/video/k9copy {};

  kail = callPackage ../tools/networking/kail {  };

  kanboard = callPackage ../applications/misc/kanboard { };

  kdeApplications =
    let
      mkApplications = import ../applications/kde;
      attrs = {
        inherit lib libsForQt5 fetchurl;
        inherit okteta;
      };
    in
      recurseIntoAttrs (makeOverridable mkApplications attrs);

  inherit (kdeApplications)
    akonadi akregator ark dolphin dragon ffmpegthumbs filelight gwenview k3b
    kaddressbook kate kcachegrind kcalc kcolorchooser kcontacts kdenlive kdf kdialog keditbookmarks
    kget kgpg khelpcenter kig kleopatra kmail kmix kolourpaint kompare konsole kpkpass kitinerary
    kontact korganizer krdc krfb ksystemlog kwalletmanager marble minuet okular spectacle;

  okteta = libsForQt5.callPackage ../applications/editors/okteta { };

  kdeconnect = libsForQt5.callPackage ../applications/misc/kdeconnect { };

  kdecoration-viewer = libsForQt5.callPackage ../tools/misc/kdecoration-viewer { };

  inherit (kdeFrameworks) kdesu;

  kdevelop-pg-qt = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop-pg-qt.nix {};

  kdevelop = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop.nix {
    llvmPackages = llvmPackages_38;
  };

  keepnote = callPackage ../applications/office/keepnote { };

  kega-fusion = pkgsi686Linux.callPackage ../misc/emulators/kega-fusion { };

  kermit = callPackage ../tools/misc/kermit { };

  kexi = libsForQt5.callPackage ../applications/office/kexi { };

  keyfinder = libsForQt5.callPackage ../applications/audio/keyfinder { };

  keyfinder-cli = libsForQt5.callPackage ../applications/audio/keyfinder-cli { };

  keymon = callPackage ../applications/video/key-mon { };

  kgraphviewer = libsForQt5.callPackage ../applications/graphics/kgraphviewer { };

  khal = callPackage ../applications/misc/khal { };

  khard = callPackage ../applications/misc/khard { };

  kid3 = libsForQt5.callPackage ../applications/audio/kid3 { };

  kile = libsForQt5.callPackage ../applications/editors/kile { };

  kino = callPackage ../applications/video/kino {
    inherit (gnome2) libglade;
    ffmpeg = ffmpeg_2;
  };

  kipi-plugins = libsForQt5.callPackage ../applications/graphics/kipi-plugins { };

  kitty = callPackage ../applications/misc/kitty { };

  kiwix = callPackage ../applications/misc/kiwix { };

  kmplayer = libsForQt5.callPackage ../applications/video/kmplayer { };

  kmymoney = libsForQt5.callPackage ../applications/office/kmymoney {
    inherit (kdeApplications) kidentitymanagement;
    inherit (kdeFrameworks) kdewebkit;
  };

  kodestudio = callPackage ../applications/editors/kodestudio { };

  konversation = libsForQt5.callPackage ../applications/networking/irc/konversation { };

  krita = libsForQt5.callPackage ../applications/graphics/krita {
    openjpeg = openjpeg_1;
  };

  krusader = libsForQt5.callPackage ../applications/misc/krusader { };

  ksuperkey = callPackage ../tools/X11/ksuperkey { };

  ktorrent = libsForQt5.callPackage ../applications/networking/p2p/ktorrent { };

  ksonnet = callPackage ../applications/networking/cluster/ksonnet { };

  kubecfg = callPackage ../applications/networking/cluster/kubecfg { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes {  };

  kubectl = (kubernetes.override { components = [ "cmd/kubectl" ]; }).overrideAttrs(oldAttrs: {
    name = "kubectl-${oldAttrs.version}";
  });

  kubernetes-helm = callPackage ../applications/networking/cluster/helm { };

  kubetail = callPackage ../applications/networking/cluster/kubetail { } ;

  kupfer = callPackage ../applications/misc/kupfer { };

  lame = callPackage ../development/libraries/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  caps = callPackage ../applications/audio/caps { };

  lastwatch = callPackage ../applications/audio/lastwatch { };

  lastfmsubmitd = callPackage ../applications/audio/lastfmsubmitd { };

  lbdb = callPackage ../tools/misc/lbdb { abook = null; gnupg = null; goobook = null; khard = null; mu = null; };

  lbzip2 = callPackage ../tools/compression/lbzip2 { };

  lci = callPackage ../applications/science/logic/lci {};

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  leo-editor = callPackage ../applications/editors/leo-editor { };

  libowfat = callPackage ../development/libraries/libowfat { };

  librecad = callPackage ../applications/misc/librecad { };

  libreoffice = hiPrio libreoffice-still;

  libreoffice-args = {
    inherit (perlPackages) ArchiveZip IOCompress;
    inherit (gnome2) GConf ORBit2 gnome_vfs;
    inherit (gnome3) defaultIconTheme;
    zip = zip.override { enableNLS = false; };
    fontsConf = makeFontsConf {
      fontDirectories = [
        carlito dejavu_fonts
        freefont_ttf xorg.fontmiscmisc
        liberation_ttf_v1_binary
        liberation_ttf_v2_binary
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  libreoffice-unwrapped = callPackage ../applications/office/libreoffice
  (libreoffice-args // {
  });
  libreoffice-still-unwrapped = callPackage ../applications/office/libreoffice/still.nix
  (libreoffice-args // {
      poppler = poppler_0_61;
  });

  libreoffice-fresh = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = libreoffice-unwrapped;
  });

  libreoffice-still = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = libreoffice-still-unwrapped;
  });

  libvmi = callPackage ../development/libraries/libvmi { };

  liferea = callPackage ../applications/networking/newsreaders/liferea {
    inherit (gnome3) libpeas gsettings-desktop-schemas dconf;
  };

  lightworks = callPackage ../applications/video/lightworks {
    portaudio = portaudio2014;
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome2) libglade;
  };

  linuxband = callPackage ../applications/audio/linuxband { };

  ledger2 = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger {
    boost = boost15x;
  };
  ledger = ledger3;
  ledger-web = callPackage ../applications/office/ledger-web { };

  lighthouse = callPackage ../applications/misc/lighthouse { };

  lighttable = callPackage ../applications/editors/lighttable {};

  libdsk = callPackage ../misc/emulators/libdsk { };

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone rec {
    polarssl = mbedtls_1_3;
  };

  linuxsampler = callPackage ../applications/audio/linuxsampler { };

  llpp = ocaml-ng.ocamlPackages_4_04.callPackage ../applications/misc/llpp { };

  lmms = libsForQt5.callPackage ../applications/audio/lmms {
    lame = null;
    libsoundio = null;
    portaudio = null;
  };

  loxodo = callPackage ../applications/misc/loxodo { };

  lrzsz = callPackage ../tools/misc/lrzsz { };

  luminanceHDR = libsForQt5.callPackage ../applications/graphics/luminance-hdr { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  handbrake = callPackage ../applications/video/handbrake { };

  lilyterm = callPackage ../applications/misc/lilyterm {
    inherit (gnome2) vte;
    gtk = gtk2;
    flavour = "stable";
  };

  lilyterm-git = lilyterm.override {
    flavour = "git";
  };

  luakit = callPackage ../applications/networking/browsers/luakit {
    inherit (lua51Packages) luafilesystem;
    lua5 = lua5_1;
  };

  looking-glass-client = callPackage ../applications/virtualization/looking-glass-client { };

  lumail = callPackage ../applications/networking/mailreaders/lumail {
    lua = lua5_1;
  };

  lv2bm = callPackage ../applications/audio/lv2bm { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = libsForQt5.callPackage ../applications/misc/lyx { };

  mac = callPackage ../development/libraries/mac { };

  magic-wormhole = with python3Packages; toPythonApplication magic-wormhole;

  mail-notification = callPackage ../desktops/gnome-2/desktop/mail-notification {};

  magnetophonDSP = {
    CharacterCompressor = callPackage ../applications/audio/magnetophonDSP/CharacterCompressor { };
    CompBus = callPackage ../applications/audio/magnetophonDSP/CompBus { };
    ConstantDetuneChorus  = callPackage ../applications/audio/magnetophonDSP/ConstantDetuneChorus { };
    faustCompressors =  callPackage ../applications/audio/magnetophonDSP/faustCompressors { };
    LazyLimiter = callPackage ../applications/audio/magnetophonDSP/LazyLimiter { };
    MBdistortion = callPackage ../applications/audio/magnetophonDSP/MBdistortion { };
    pluginUtils = callPackage ../applications/audio/magnetophonDSP/pluginUtils  { };
    RhythmDelay = callPackage ../applications/audio/magnetophonDSP/RhythmDelay { };
    VoiceOfFaust = callPackage ../applications/audio/magnetophonDSP/VoiceOfFaust { };
    shelfMultiBand = callPackage ../applications/audio/magnetophonDSP/shelfMultiBand  { };
  };

  makeself = callPackage ../applications/misc/makeself { };

  mapmap = libsForQt5.callPackage ../applications/video/mapmap { };

  marathon = callPackage ../applications/networking/cluster/marathon { };
  marathonctl = callPackage ../tools/virtualization/marathonctl { } ;

  markdown-pp = callPackage ../tools/text/markdown-pp { };

  marp = callPackage ../applications/office/marp { };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  mblaze = callPackage ../applications/networking/mailreaders/mblaze { };

  mcpp = callPackage ../development/compilers/mcpp { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  mediainfo = callPackage ../applications/misc/mediainfo { };

  mediainfo-gui = callPackage ../applications/misc/mediainfo-gui { };

  mediathekview = callPackage ../applications/video/mediathekview { };

  meteo = callPackage ../applications/networking/weather/meteo { };

  meld = callPackage ../applications/version-management/meld { };

  meme = callPackage ../applications/graphics/meme { };

  mcomix = callPackage ../applications/graphics/mcomix { };

  mendeley = libsForQt5.callPackage ../applications/office/mendeley {
    gconf = pkgs.gnome2.GConf;
  };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    guiSupport = false; # use mercurialFull to get hgk GUI
  };

  mercurialFull = appendToName "full" (pkgs.mercurial.override { guiSupport = true; });

  merkaartor = libsForQt5.callPackage ../applications/misc/merkaartor { };

  meshlab = libsForQt5.callPackage ../applications/graphics/meshlab { };

  metersLv2 = callPackage ../applications/audio/meters_lv2 { };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {};

  mid2key = callPackage ../applications/audio/mid2key { };

  midori-unwrapped = callPackage ../applications/networking/browsers/midori { };
  midori = wrapFirefox midori-unwrapped { };

  mikmod = callPackage ../applications/audio/mikmod { };

  minicom = callPackage ../tools/misc/minicom { };

  minimodem = callPackage ../applications/audio/minimodem { };

  minidjvu = callPackage ../applications/graphics/minidjvu { };

  minikube = callPackage ../applications/networking/cluster/minikube {
    inherit (darwin.apple_sdk.frameworks) vmnet;
  };

  minitube = libsForQt5.callPackage ../applications/video/minitube { };

  mimic = callPackage ../applications/audio/mimic {
    pulseaudioSupport = config.pulseaudio or false;
  };

  mimms = callPackage ../applications/audio/mimms {};

  meh = callPackage ../applications/graphics/meh {};

  mirage = callPackage ../applications/graphics/mirage { };

  mixxx = callPackage ../applications/audio/mixxx {
    inherit (vamp) vampSDK;
  };

  mjpg-streamer = callPackage ../applications/video/mjpg-streamer { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  MMA = callPackage ../applications/audio/MMA { };

  mmex = callPackage ../applications/office/mmex {
    wxGTK30 = wxGTK30.override { withWebKit  = true ; };
  };

  moc = callPackage ../applications/audio/moc {
    ffmpeg = ffmpeg_2;
  };

  mod-distortion = callPackage ../applications/audio/mod-distortion { };

  monero = callPackage ../applications/altcoins/monero {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
    boost = boost15x;
  };

  monero-gui = libsForQt5.callPackage ../applications/altcoins/monero-gui {
    boost = boost15x;
  };

  xmr-stak = callPackage ../applications/misc/xmr-stak {
    stdenvGcc6 = overrideCC stdenv gcc6;
    hwloc = hwloc-nox;
  };

  xmrig = callPackage ../applications/misc/xmrig { };

  xmrig-proxy = callPackage ../applications/misc/xmrig/proxy.nix { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monkeysphere = callPackage ../tools/security/monkeysphere { };

  monodevelop = callPackage ../applications/editors/monodevelop {};

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  inherit (ocaml-ng.ocamlPackages_4_01_0) monotoneViz;

  moonlight-embedded = callPackage ../applications/misc/moonlight-embedded { };

  mop = callPackage ../applications/misc/mop { };

  mopidy = callPackage ../applications/audio/mopidy { };

  mopidy-gmusic = callPackage ../applications/audio/mopidy/gmusic.nix { };

  mopidy-local-images = callPackage ../applications/audio/mopidy/local-images.nix { };

  mopidy-local-sqlite = callPackage ../applications/audio/mopidy/local-sqlite.nix { };

  mopidy-spotify = callPackage ../applications/audio/mopidy/spotify.nix { };

  mopidy-moped = callPackage ../applications/audio/mopidy/moped.nix { };

  mopidy-mopify = callPackage ../applications/audio/mopidy/mopify.nix { };

  mopidy-spotify-tunigo = callPackage ../applications/audio/mopidy/spotify-tunigo.nix { };

  mopidy-youtube = callPackage ../applications/audio/mopidy/youtube.nix { };

  mopidy-soundcloud = callPackage ../applications/audio/mopidy/soundcloud.nix { };

  mopidy-musicbox-webclient = callPackage ../applications/audio/mopidy/musicbox-webclient.nix { };

  mopidy-iris = callPackage ../applications/audio/mopidy/iris.nix { };

  motif = callPackage ../development/libraries/motif { };

  mozplugger = callPackage ../applications/networking/browsers/mozilla-plugins/mozplugger {};

  mozjpeg = callPackage ../applications/graphics/mozjpeg { };

  easytag = callPackage ../applications/audio/easytag { };

  mp3gain = callPackage ../applications/audio/mp3gain { };

  mp3info = callPackage ../applications/audio/mp3info { };

  mp3splt = callPackage ../applications/audio/mp3splt { };

  mp3val = callPackage ../applications/audio/mp3val { };

  mpc123 = callPackage ../applications/audio/mpc123 { };

  mpg123 = callPackage ../applications/audio/mpg123 { };

  mpg321 = callPackage ../applications/audio/mpg321 { };

  mpc_cli = callPackage ../applications/audio/mpc { };

  clerk = callPackage ../applications/audio/clerk { };

  nbstripout = callPackage ../applications/version-management/nbstripout { };

  ncmpc = callPackage ../applications/audio/ncmpc { };

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  ympd = callPackage ../applications/audio/ympd { };

  nload = callPackage ../applications/networking/nload { };

  normalize = callPackage ../applications/audio/normalize { };

  mm = callPackage ../applications/networking/instant-messengers/mm { };

  matrique = libsForQt5.callPackage ../applications/networking/instant-messengers/matrique { };

  mpc-qt = libsForQt5.callPackage ../applications/video/mpc-qt { };

  mplayer = callPackage ../applications/video/mplayer ({
    pulseSupport = config.pulseaudio or false;
    libdvdnav = libdvdnav_4_2_1;
  } // (config.mplayer or {}));

  MPlayerPlugin = browser:
    callPackage ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      # !!! should depend on MPlayer
    };

  mpv = callPackage ../applications/video/mpv rec {
    inherit (luaPackages) luasocket;
    waylandSupport     = stdenv.isLinux;
    alsaSupport        = !stdenv.isDarwin;
    pulseSupport       = !stdenv.isDarwin;
    rubberbandSupport  = !stdenv.isDarwin;
    dvdreadSupport     = !stdenv.isDarwin;
    dvdnavSupport      = !stdenv.isDarwin;
    drmSupport         = !stdenv.isDarwin;
    vaapiSupport       = !stdenv.isDarwin;
    x11Support         = !stdenv.isDarwin;
    xineramaSupport    = !stdenv.isDarwin;
    xvSupport          = !stdenv.isDarwin;
  };

  mpv-with-scripts = callPackage ../applications/video/mpv/wrapper.nix { };

  mpvScripts = {
    convert = callPackage ../applications/video/mpv/scripts/convert.nix {};
    mpris = callPackage ../applications/video/mpv/scripts/mpris.nix {};
  };

  mrpeach = callPackage ../applications/audio/pd-plugins/mrpeach { };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  mtpaint = callPackage ../applications/graphics/mtpaint { };

  mucommander = callPackage ../applications/misc/mucommander { };

  multimarkdown = callPackage ../tools/typesetting/multimarkdown { };

  multimon-ng = callPackage ../applications/misc/multimon-ng { };

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }) mumble mumble_git murmur;

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = false;
    }) murmur_git;

  mumble_overlay = callPackage ../applications/networking/mumble/overlay.nix {
    mumble_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.mumble
      else null;
  };

  # TODO: we should probably merge these 2
  musescore =
    if stdenv.isDarwin then
      callPackage ../applications/audio/musescore/darwin.nix { }
    else
      libsForQt5.callPackage ../applications/audio/musescore { };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };
  mutt-with-sidebar = mutt.override {
    withSidebar = true;
  };

  mwic = callPackage ../applications/misc/mwic {
    pythonPackages = python3Packages;
  };

  neomutt = callPackage ../applications/networking/mailreaders/neomutt { };

  natron = callPackage ../applications/video/natron { };

  notion = callPackage ../applications/window-managers/notion { };

  openshift = callPackage ../applications/networking/cluster/openshift { };

  oroborus = callPackage ../applications/window-managers/oroborus {};

  osm2pgsql = callPackage ../tools/misc/osm2pgsql { };

  ostinato = callPackage ../applications/networking/ostinato { };

  p4v = libsForQt5.callPackage ../applications/version-management/p4v { };

  partio = callPackage ../development/libraries/partio {};

  pcmanfm = callPackage ../applications/misc/pcmanfm { };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pcmanx-gtk2 = callPackage ../applications/misc/pcmanx-gtk2 { };

  pig = callPackage ../applications/networking/cluster/pig { };

  pijul = callPackage ../applications/version-management/pijul {};

  piper = callPackage ../os-specific/linux/piper { };

  plank = callPackage ../applications/misc/plank { };

  planner = callPackage ../applications/office/planner { };

  playonlinux = callPackage ../applications/misc/playonlinux {
     stdenv = stdenv_32bit;
  };

  polybar = callPackage ../applications/misc/polybar { };

  ptex = callPackage ../development/libraries/ptex {};

  rssguard = libsForQt5.callPackage ../applications/networking/feedreaders/rssguard { };

  scudcloud = callPackage ../applications/networking/instant-messengers/scudcloud { };

  shotcut = libsForQt5.callPackage ../applications/video/shotcut {
    libmlt = mlt;
  };

  shogun = callPackage ../applications/science/machine-learning/shogun { };

  smplayer = libsForQt5.callPackage ../applications/video/smplayer { };

  smtube = libsForQt5.callPackage ../applications/video/smtube {};

  stride = callPackage ../applications/networking/instant-messengers/stride { };

  sudolikeaboss = callPackage ../tools/security/sudolikeaboss { };

  speedread = callPackage ../applications/misc/speedread { };

  sup = callPackage ../applications/networking/mailreaders/sup {
    ruby = ruby_2_3.override { cursesSupport = true; };
  };

  synapse = callPackage ../applications/misc/synapse {
    inherit (gnome3) libgee;
  };

  synapse-bt = callPackage ../applications/networking/p2p/synapse-bt {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  synfigstudio = callPackage ../applications/graphics/synfigstudio {
    inherit (gnome3) defaultIconTheme;
    mlt-qt5 = libsForQt5.mlt;
  };

  typora = callPackage ../applications/editors/typora { };

  taxi = callPackage ../applications/networking/ftp/taxi { };

  librep = callPackage ../development/libraries/librep { };

  rep-gtk = callPackage ../development/libraries/rep-gtk { };

  sawfish = callPackage ../applications/window-managers/sawfish { };

  sidplayfp = callPackage ../applications/audio/sidplayfp { };

  sxhkd = callPackage ../applications/window-managers/sxhkd { };

  sxhkd-unstable = callPackage ../applications/window-managers/sxhkd/unstable.nix { };

  mpop = callPackage ../applications/networking/mpop {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  msmtp = callPackage ../applications/networking/msmtp {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
 };

  maxlib = callPackage ../applications/audio/pd-plugins/maxlib { };

  maxscale = callPackage ../tools/networking/maxscale {
    stdenv = overrideCC stdenv gcc6;
  };

  pdfdiff = callPackage ../applications/misc/pdfdiff { };

  mupdf = callPackage ../applications/misc/mupdf { };

  diffpdf = libsForQt5.callPackage ../applications/misc/diffpdf { };

  diff-pdf = callPackage ../applications/misc/diff-pdf { wxGTK = wxGTK31; };

  mlocate = callPackage ../tools/misc/mlocate { };

  mypaint = callPackage ../applications/graphics/mypaint { };

  mypaint-brushes = callPackage ../development/libraries/mypaint-brushes { };

  mythtv = libsForQt5.callPackage ../applications/video/mythtv { };

  micro = callPackage ../applications/editors/micro { };

  nano = callPackage ../applications/editors/nano { };

  nanoblogger = callPackage ../applications/misc/nanoblogger { };

  nanorc = callPackage ../applications/editors/nano/nanorc { };

  navipowm = callPackage ../applications/misc/navipowm { };

  navit = libsForQt5.callPackage ../applications/misc/navit { };

  netbeans = callPackage ../applications/editors/netbeans { };

  ncdu = callPackage ../tools/misc/ncdu { };

  ncdc = callPackage ../applications/networking/p2p/ncdc { };

  ncview = callPackage ../tools/X11/ncview { } ;

  ne = callPackage ../applications/editors/ne { };

  nedit = callPackage ../applications/editors/nedit { };

  nheko = libsForQt5.callPackage ../applications/networking/instant-messengers/nheko { };

  nomacs = libsForQt5.callPackage ../applications/graphics/nomacs { };

  notepadqq = libsForQt5.callPackage ../applications/editors/notepadqq { };

  notbit = callPackage ../applications/networking/mailreaders/notbit { };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    gmime = gmime3;
  };

  notejot = callPackage ../applications/misc/notejot { };

  notmuch-mutt = callPackage ../applications/networking/mailreaders/notmuch/mutt.nix { };

  muchsync = callPackage ../applications/networking/mailreaders/notmuch/muchsync.nix { };

  notmuch-addrlookup = callPackage ../applications/networking/mailreaders/notmuch-addrlookup { };

  nova-filters =  callPackage ../applications/audio/nova-filters { };

  nspluginwrapper = callPackage ../applications/networking/browsers/mozilla-plugins/nspluginwrapper {};

  nvi = callPackage ../applications/editors/nvi { };

  nvpy = callPackage ../applications/editors/nvpy { };

  obconf = callPackage ../tools/X11/obconf {
    inherit (gnome2) libglade;
  };

  oblogout = callPackage ../tools/X11/oblogout { };

  obs-linuxbrowser = callPackage ../applications/video/obs-studio/linuxbrowser.nix { };

  obs-studio = libsForQt5.callPackage ../applications/video/obs-studio {
    alsaSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or true;
  };

  octoprint = callPackage ../applications/misc/octoprint { };

  octoprint-plugins = callPackage ../applications/misc/octoprint/plugins.nix { };

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  omxplayer = callPackage ../applications/video/omxplayer { };

  openbox = callPackage ../applications/window-managers/openbox { };

  openbox-menu = callPackage ../applications/misc/openbox-menu { };

  openbrf = libsForQt5.callPackage ../applications/misc/openbrf { };

  opencpn = callPackage ../applications/misc/opencpn { };

  openfx = callPackage ../development/libraries/openfx {};

  openimageio = callPackage ../applications/graphics/openimageio {
    stdenv = overrideCC stdenv gcc6;
  };

  openjump = callPackage ../applications/misc/openjump { };

  openorienteering-mapper = libsForQt5.callPackage ../applications/gis/openorienteering-mapper { };

  openscad = callPackage ../applications/graphics/openscad {};

  opentimestamps-client = python3Packages.callPackage ../tools/misc/opentimestamps-client {};

  opentx = callPackage ../applications/misc/opentx { };

  opera = callPackage ../applications/networking/browsers/opera {};

  orca = python3Packages.callPackage ../applications/misc/orca {
    inherit (gnome3) yelp-tools;
  };

  osm2xmap = callPackage ../applications/misc/osm2xmap {
    libyamlcpp = libyamlcpp_0_3;
  };

  osmctools = callPackage ../applications/misc/osmctools { };

  owamp = callPackage ../applications/networking/owamp { };

  vivaldi = callPackage ../applications/networking/browsers/vivaldi {};

  vivaldi-ffmpeg-codecs = callPackage ../applications/networking/browsers/vivaldi/ffmpeg-codecs.nix {};

  openmpt123 = callPackage ../applications/audio/openmpt123 {};

  opusfile = callPackage ../applications/audio/opusfile { };

  opusTools = callPackage ../applications/audio/opus-tools { };

  orpie = callPackage ../applications/misc/orpie {
    gsl = gsl_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  osmo = callPackage ../applications/office/osmo { };

  osquery = callPackage ../tools/system/osquery { };

  palemoon = callPackage ../applications/networking/browsers/palemoon {
    # https://forum.palemoon.org/viewtopic.php?f=57&t=15296#p111146
    stdenv = overrideCC stdenv gcc49;
  };

  pamix = callPackage ../applications/audio/pamix { };

  pamixer = callPackage ../applications/audio/pamixer { };

  ncpamixer = callPackage ../applications/audio/ncpamixer { };

  pan = callPackage ../applications/networking/newsreaders/pan { };

  panotools = callPackage ../applications/graphics/panotools { };

  paprefs = callPackage ../applications/audio/paprefs { };

  pavucontrol = callPackage ../applications/audio/pavucontrol { };

  paraview = libsForQt59.callPackage ../applications/graphics/paraview { };

  packet = callPackage ../development/tools/packet { };

  pbrt = callPackage ../applications/graphics/pbrt { };

  pcsxr = callPackage ../misc/emulators/pcsxr {
    ffmpeg = ffmpeg_2;
  };

  pcsx2 = pkgsi686Linux.callPackage ../misc/emulators/pcsx2 { };

  pekwm = callPackage ../applications/window-managers/pekwm { };

  pencil = callPackage ../applications/graphics/pencil {
  };

  perseus = callPackage ../applications/science/math/perseus {};

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdftk = callPackage ../tools/typesetting/pdftk { };
  pdfgrep  = callPackage ../tools/typesetting/pdfgrep { };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gnome3) libgee;
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  peek = callPackage ../applications/video/peek { };

  pflask = callPackage ../os-specific/linux/pflask {};

  photoqt = libsForQt5.callPackage ../applications/graphics/photoqt { };

  photoflow = callPackage ../applications/graphics/photoflow { };

  phototonic = libsForQt5.callPackage ../applications/graphics/phototonic { };

  phrasendrescher = callPackage ../tools/security/phrasendrescher { };

  phraseapp-client = callPackage ../tools/misc/phraseapp-client { };

  phwmon = callPackage ../applications/misc/phwmon { };

  pianobar = callPackage ../applications/audio/pianobar { };

  pianobooster = callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard { };

  picocom = callPackage ../tools/misc/picocom { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if config.pidgin.openssl or true then openssl else null;
    gnutls = if config.pidgin.gnutls or false then gnutls else null;
    libgcrypt = if config.pidgin.gnutls or false then libgcrypt else null;
    startupnotification = libstartup_notification;
    plugins = [];
  };

  pidgin-latex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    texLive = texlive.combined.scheme-basic;
  };

  pidgin-msn-pecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidgin-mra = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-mra { };

  pidgin-skypeweb = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-skypeweb { };

  pidgin-carbons = callPackage ../applications/networking/instant-messengers/pidgin-plugins/carbons { };

  pidgin-xmpp-receipts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-xmpp-receipts { };

  pidgin-otr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidgin-osd = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-osd { };

  pidgin-sipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pidgin-window-merge = callPackage ../applications/networking/instant-messengers/pidgin-plugins/window-merge { };

  purple-discord = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-discord { };

  purple-hangouts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-hangouts { };

  purple-lurch = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-lurch { };

  purple-matrix = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-matrix { };

  purple-plugin-pack = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-plugin-pack { };

  purple-vk-plugin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-vk-plugin { };

  purple-xmpp-http-upload = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-xmpp-http-upload { };

  telegram-purple = callPackage ../applications/networking/instant-messengers/pidgin-plugins/telegram-purple { };

  toxprpl = callPackage ../applications/networking/instant-messengers/pidgin-plugins/tox-prpl {
    libtoxcore = libtoxcore-new;
  };

  pidgin-opensteamworks = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-opensteamworks { };

  purple-facebook = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-facebook { };

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python3Packages;
  };

  pinfo = callPackage ../applications/misc/pinfo { };

  pinpoint = callPackage ../applications/office/pinpoint {
    inherit (gnome3) clutter clutter-gtk;
  };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtk-sharp-2_0;
  };

  plex-media-player = libsForQt59.callPackage ../applications/video/plex-media-player { };

  plover = recurseIntoAttrs (callPackage ../applications/misc/plover { });

  plugin-torture = callPackage ../applications/audio/plugin-torture { };

  pmenu = callPackage ../applications/misc/pmenu { };

  poezio = python3Packages.poezio;

  pommed = callPackage ../os-specific/linux/pommed {};

  pommed_light = callPackage ../os-specific/linux/pommed-light {};

  pond = callPackage ../applications/networking/instant-messengers/pond { };

  ponymix = callPackage ../applications/audio/ponymix { };

  potrace = callPackage ../applications/graphics/potrace {};

  posterazor = callPackage ../applications/misc/posterazor { };

  ppl-address-book = callPackage ../applications/office/ppl-address-book { };

  pqiv = callPackage ../applications/graphics/pqiv { };

  qiv = callPackage ../applications/graphics/qiv { };

  processing = processing3;
  processing3 = callPackage ../applications/graphics/processing3 {
    jdk = oraclejdk8;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  profanity = callPackage ../applications/networking/instant-messengers/profanity {
    notifySupport   = config.profanity.notifySupport   or true;
    traySupport     = config.profanity.traySupport     or true;
    autoAwaySupport = config.profanity.autoAwaySupport or true;
    python = python3;
  };

  protonmail-bridge = libsForQt5.callPackage ../applications/networking/protonmail-bridge { };

  psi = callPackage ../applications/networking/instant-messengers/psi { };

  psi-plus = callPackage ../applications/networking/instant-messengers/psi-plus { };

  psol = callPackage ../development/libraries/psol { };

  pstree = callPackage ../applications/misc/pstree { };

  ptask = callPackage ../applications/misc/ptask { };

  pulseaudio-ctl = callPackage ../applications/audio/pulseaudio-ctl { };

  pulseaudio-dlna = callPackage ../applications/audio/pulseaudio-dlna { };

  pulseview = libsForQt5.callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  puremapping = callPackage ../applications/audio/pd-plugins/puremapping { };

  pybitmessage = callPackage ../applications/networking/instant-messengers/pybitmessage { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = libsForQt5.callPackage ../applications/networking/p2p/qbittorrent { };

  qcomicbook = libsForQt5.callPackage ../applications/graphics/qcomicbook { };

  eiskaltdcpp = callPackage ../applications/networking/p2p/eiskaltdcpp {
    lua5 = lua5_1;
    miniupnpc = miniupnpc_1;
  };

  qdirstat = libsForQt5.callPackage ../applications/misc/qdirstat {};

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa;
    inherit (darwin.stubs) rez setfile;
  };

  qgis = callPackage ../applications/gis/qgis {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  qgroundcontrol = libsForQt5.callPackage ../applications/science/robotics/qgroundcontrol { };

  qjackctl = libsForQt5.callPackage ../applications/audio/qjackctl { };

  qmapshack = libsForQt5.callPackage ../applications/misc/qmapshack { };

  qmediathekview = libsForQt5.callPackage ../applications/video/qmediathekview { };

  qmetro = callPackage ../applications/misc/qmetro { };

  qmidinet = callPackage ../applications/audio/qmidinet { };

  qmidiroute = callPackage ../applications/audio/qmidiroute { };

  qmmp = libsForQt5.callPackage ../applications/audio/qmmp { };

  qnotero = callPackage ../applications/office/qnotero { };

  qrcode = callPackage ../tools/graphics/qrcode {};

  qsampler = libsForQt5.callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot {
    inherit (darwin.apple_sdk.frameworks) Carbon;
    qt = qt4;
  };

  qsstv = qt5.callPackage ../applications/misc/qsstv { };

  qsyncthingtray = libsForQt5.callPackage ../applications/misc/qsyncthingtray { };

  qstopmotion = libsForQt5.callPackage ../applications/video/qstopmotion { };

  qsynth = libsForQt5.callPackage ../applications/audio/qsynth { };

  qtbitcointrader = callPackage ../applications/misc/qtbitcointrader { };

  qtchan = callPackage ../applications/networking/browsers/qtchan {
    qt = qt5;
  };

  qtox = libsForQt5.callPackage ../applications/networking/instant-messengers/qtox { };

  qtpass = libsForQt5.callPackage ../applications/misc/qtpass { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  qtractor = callPackage ../applications/audio/qtractor { };

  qtscrobbler = callPackage ../applications/audio/qtscrobbler { };

  quassel = libsForQt5.callPackage ../applications/networking/irc/quassel {
    monolithic = true;
    daemon = false;
    client = false;
    withKDE = true;
    dconf = gnome3.dconf;
    tag = "-kf5";
  };

  quasselClient = quassel.override {
    monolithic = false;
    client = true;
    tag = "-client-kf5";
  };

  quasselDaemon = quassel.override {
    monolithic = false;
    daemon = true;
    tag = "-daemon-qt5";
    withKDE = false;
  };

  quassel-webserver = nodePackages.quassel-webserver;

  quirc = callPackage ../tools/graphics/quirc {};

  quilter = callPackage ../applications/editors/quilter { };

  quiterss = libsForQt5.callPackage ../applications/networking/newsreaders/quiterss {};

  falkon = libsForQt5.callPackage ../applications/networking/browsers/falkon { };

  quodlibet = callPackage ../applications/audio/quodlibet {
    keybinder3 = null;
    libmodplug = null;
    kakasi = null;
    libappindicator-gtk3 = null;
  };

  quodlibet-without-gst-plugins = quodlibet.override {
    withGstPlugins = false;
    tag = "-without-gst-plugins";
  };

  quodlibet-xine = quodlibet.override { xineBackend = true; tag = "-xine"; };

  quodlibet-full = quodlibet.override {
    inherit (gnome3) gtksourceview webkitgtk;
    withDbusPython = true;
    withPyInotify = true;
    withMusicBrainzNgs = true;
    withPahoMqtt = true;
    keybinder3 = keybinder3;
    libmodplug = libmodplug;
    kakasi = kakasi;
    libappindicator-gtk3 = libappindicator-gtk3;
    tag = "-full";
  };

  quodlibet-xine-full = quodlibet-full.override { xineBackend = true; tag = "-xine-full"; };

  qutebrowser = libsForQt5.callPackage ../applications/networking/browsers/qutebrowser { };

  rabbitvcs = callPackage ../applications/version-management/rabbitvcs {};

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  renoise = callPackage ../applications/audio/renoise {};

  radiotray-ng = callPackage ../applications/audio/radiotray-ng {
    wxGTK = wxGTK30;
  };

  rapcad = libsForQt5.callPackage ../applications/graphics/rapcad { boost = boost159; };

  rapid-photo-downloader = libsForQt5.callPackage ../applications/graphics/rapid-photo-downloader { };

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratmen = callPackage ../tools/X11/ratmen {};

  ratox = callPackage ../applications/networking/instant-messengers/ratox { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rclone = callPackage ../applications/networking/sync/rclone { };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  rdedup = callPackage ../tools/backup/rdedup { };

  rdup = callPackage ../tools/backup/rdup { };

  realpine = callPackage ../applications/networking/mailreaders/realpine {
    tcl = tcl-8_5;
  };

  reaper = callPackage ../applications/audio/reaper { };

  recode = callPackage ../tools/text/recode { };

  rednotebook = python3Packages.callPackage ../applications/editors/rednotebook { };

  remotebox = callPackage ../applications/virtualization/remotebox { };

  retroshare = libsForQt5.callPackage ../applications/networking/p2p/retroshare { };
  retroshare06 = retroshare;

  ricochet = libsForQt5.callPackage ../applications/networking/instant-messengers/ricochet { };

  ries = callPackage ../applications/science/math/ries { };

  ripser = callPackage ../applications/science/math/ripser { };

  rkt = callPackage ../applications/virtualization/rkt { };

  rofi-unwrapped = callPackage ../applications/misc/rofi { };
  rofi = callPackage ../applications/misc/rofi/wrapper.nix { };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };

  rofi-menugen = callPackage ../applications/misc/rofi-menugen { };

  rofi-systemd = callPackage ../tools/system/rofi-systemd { };

  rpcs3 = libsForQt5.callPackage ../misc/emulators/rpcs3 { };

  rstudio = libsForQt5.callPackage ../applications/editors/rstudio {
    boost = boost166;
  };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix {};

  rtl_433 = callPackage ../applications/misc/rtl_433 { };

  rtl-sdr = callPackage ../applications/misc/rtl-sdr { };

  rtv = callPackage ../applications/misc/rtv { };

  rubyripper = callPackage ../applications/audio/rubyripper {};

  runc = callPackage ../applications/virtualization/runc {};

  rxvt = callPackage ../applications/misc/rxvt { };

  # urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = true;
    gdkPixbufSupport = true;
    unicode3Support = true;
  };

  rxvt_unicode-with-plugins = callPackage ../applications/misc/rxvt_unicode/wrapper.nix {
    plugins = [
      urxvt_autocomplete_all_the_things
      urxvt_perl
      urxvt_perls
      urxvt_tabbedex
      urxvt_font_size
      urxvt_theme_switch
      urxvt_vtwheel
    ];
  };

  # urxvt plugins
  urxvt_autocomplete_all_the_things = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-autocomplete-all-the-things { };
  urxvt_perl = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perl { };
  urxvt_perls = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perls { };
  urxvt_tabbedex = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-tabbedex { };
  urxvt_font_size = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-font-size { };
  urxvt_theme_switch = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-theme-switch { };
  urxvt_vtwheel = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-vtwheel.nix { };

  uade123 = callPackage ../applications/audio/uade123 {};

  udevil = callPackage ../applications/misc/udevil {};

  udiskie = python3Packages.callPackage ../applications/misc/udiskie { };

  sakura = callPackage ../applications/misc/sakura {
    vte = gnome3.vte;
  };

  sayonara = callPackage ../applications/audio/sayonara { };

  sbagen = callPackage ../applications/misc/sbagen { };

  scantailor = callPackage ../applications/graphics/scantailor { };

  scantailor-advanced = qt5.callPackage ../applications/graphics/scantailor/advanced.nix { };

  sc-im = callPackage ../applications/misc/sc-im { };

  scite = callPackage ../applications/editors/scite { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome2) libart_lgpl;
  };

  seafile-client = libsForQt5.callPackage ../applications/networking/seafile-client { };

  seeks = callPackage ../tools/networking/p2p/seeks {
    protobuf = protobuf3_1;
  };

  seg3d = callPackage ../applications/graphics/seg3d {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  sent = callPackage ../applications/misc/sent { };

  seq24 = callPackage ../applications/audio/seq24 { };

  setbfree = callPackage ../applications/audio/setbfree { };

  shadowfox = callPackage ../tools/networking/shadowfox { };

  shfmt = callPackage ../tools/text/shfmt { };

  shutter = callPackage ../applications/graphics/shutter { };

  simple-scan = gnome3.simple-scan;

  siproxd = callPackage ../applications/networking/siproxd { };

  skypeforlinux = callPackage ../applications/networking/instant-messengers/skypeforlinux { };

  skype4pidgin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/skype4pidgin { };

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  SkypeExport = callPackage ../applications/networking/instant-messengers/SkypeExport { };

  slmenu = callPackage ../applications/misc/slmenu {};

  slop = callPackage ../tools/misc/slop {};

  slrn = callPackage ../applications/networking/newsreaders/slrn { };

  sniproxy = callPackage ../applications/networking/sniproxy { };

  sooperlooper = callPackage ../applications/audio/sooperlooper { };

  sops = callPackage ../tools/security/sops { };

  sorcer = callPackage ../applications/audio/sorcer { };

  sound-juicer = callPackage ../applications/audio/sound-juicer { };

  spice-vdagent = callPackage ../applications/virtualization/spice-vdagent { };

  spideroak = callPackage ../applications/networking/spideroak { };

  split2flac = callPackage ../applications/audio/split2flac { };

  squishyball = callPackage ../applications/audio/squishyball {
    ncurses = ncurses5;
  };

  ssvnc = callPackage ../applications/networking/remote/ssvnc { };

  stupidterm = callPackage ../applications/misc/stupidterm {
    vte = gnome3.vte;
    gtk = gtk3;
  };

  styx = callPackage ../applications/misc/styx { };

  tecoc = callPackage ../applications/editors/tecoc { };

  viber = callPackage ../applications/networking/instant-messengers/viber { };

  wavebox = callPackage ../applications/networking/instant-messengers/wavebox { };

  sonic-pi = callPackage ../applications/audio/sonic-pi {
    ruby = ruby_2_3;
  };

  st = callPackage ../applications/misc/st {
    conf = config.st.conf or null;
    patches = config.st.patches or [];
    extraLibs = config.st.extraLibs or [];
  };

  xst = callPackage ../applications/misc/st/xst.nix { };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  stella = callPackage ../misc/emulators/stella { };

  statsd = nodePackages.statsd;

  linuxstopmotion = callPackage ../applications/video/linuxstopmotion { };

  sweethome3d = recurseIntoAttrs (  (callPackage ../applications/misc/sweethome3d { })
                                 // (callPackage ../applications/misc/sweethome3d/editors.nix {
                                      sweethome3dApp = sweethome3d.application;
                                    })
                                 );

  swingsane = callPackage ../applications/graphics/swingsane { };

  sxiv = callPackage ../applications/graphics/sxiv { };

  resilio-sync = callPackage ../applications/networking/resilio-sync { };

  bittorrentSync = bittorrentSync14;
  bittorrentSync14 = callPackage ../applications/networking/bittorrentsync/1.4.x.nix { };
  bittorrentSync20 = callPackage ../applications/networking/bittorrentsync/2.0.x.nix { };

  dropbox = callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox/cli.nix { };

  insync = callPackage ../applications/networking/insync { };

  lightdm = libsForQt5.callPackage ../applications/display-managers/lightdm { };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm/gtk-greeter.nix {
    inherit (xfce) exo;
  };

  lightdm-mini-greeter = callPackage ../applications/display-managers/lightdm-mini-greeter { };

  slic3r = callPackage ../applications/misc/slic3r { };

  slic3r-prusa3d = callPackage ../applications/misc/slic3r/prusa3d.nix { };

  curaengine_stable = callPackage ../applications/misc/curaengine/stable.nix { };
  cura_stable = callPackage ../applications/misc/cura/stable.nix {
    curaengine = curaengine_stable;
  };

  curaengine = callPackage ../applications/misc/curaengine {
    inherit (python3.pkgs) libarcus;
  };
  cura = qt5.callPackage ../applications/misc/cura { };

  curaLulzbot = callPackage ../applications/misc/cura/lulzbot.nix { };

  curaByDagoma = callPackage ../applications/misc/curabydagoma { };

  peru = callPackage ../applications/version-management/peru {};

  pmidi = callPackage ../applications/audio/pmidi { };

  printrun = callPackage ../applications/misc/printrun { };

  sddm = libsForQt5.callPackage ../applications/display-managers/sddm { };

  skrooge = libsForQt5.callPackage ../applications/office/skrooge {};

  slim = callPackage ../applications/display-managers/slim {
    libpng = libpng12;
  };

  smartgithg = callPackage ../applications/version-management/smartgithg { };

  slimThemes = recurseIntoAttrs (callPackage ../applications/display-managers/slim/themes.nix {});

  smartdeblur = callPackage ../applications/graphics/smartdeblur { };

  snapper = callPackage ../tools/misc/snapper { };

  snd = callPackage ../applications/audio/snd { };

  shntool = callPackage ../applications/audio/shntool { };

  sipp = callPackage ../development/tools/misc/sipp { };

  skanlite = libsForQt5.callPackage ../applications/office/skanlite { };

  sonic-visualiser = libsForQt5.callPackage ../applications/audio/sonic-visualiser {
    inherit (pkgs.vamp) vampSDK;
  };

  soulseekqt = libsForQt5.callPackage ../applications/networking/p2p/soulseekqt { };

  sox = callPackage ../applications/misc/audio/sox {
    enableLame = config.sox.enableLame or false;
  };

  soxr = callPackage ../applications/misc/audio/soxr { };

  spek = callPackage ../applications/audio/spek {
    ffmpeg = ffmpeg_2;
  };

  spotify = callPackage ../applications/audio/spotify {
    libgcrypt = libgcrypt_1_5;
    libpng = libpng12;
    curl = curl.override {
      sslSupport = false; gnutlsSupport = true;
    };
  };

  libspotify = callPackage ../development/libraries/libspotify {
    apiKey = config.libspotify.apiKey or null;
  };

  squeezelite = callPackage ../applications/audio/squeezelite { };

  ltunify = callPackage ../tools/misc/ltunify { };

  src = callPackage ../applications/version-management/src {
    git = gitMinimal;
  };

  ssr = callPackage ../applications/audio/soundscape-renderer {};

  ssrc = callPackage ../applications/audio/ssrc { };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  inherit (ocamlPackages) stog;

  stp = callPackage ../applications/science/logic/stp {};

  stumpish = callPackage ../applications/window-managers/stumpish {};

  stumpwm = callPackage ../applications/window-managers/stumpwm {
    version = "latest";
  };

  stumpwm-git = stumpwm.override {
    version = "git";
    inherit sbcl lispPackages;
  };

  sublime = callPackage ../applications/editors/sublime/2 { };

  sublime3Packages = recurseIntoAttrs (callPackage ../applications/editors/sublime/3/packages.nix { });

  sublime3 = sublime3Packages.sublime3;

  sublime3-dev = sublime3Packages.sublime3-dev;

  inherit (callPackages ../applications/version-management/subversion {
      bdbSupport = true;
      httpServer = false;
      httpSupport = true;
      pythonBindings = false;
      perlBindings = false;
      javahlBindings = false;
      saslSupport = false;
      sasl = cyrus_sasl;
    })
    subversion18 subversion19 subversion_1_10;

  subversion = subversion_1_10;

  subversionClient = appendToName "client" (pkgs.subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  });

  subunit = callPackage ../development/libraries/subunit { };

  surf = callPackage ../applications/networking/browsers/surf { gtk = gtk2; };

  sunvox = callPackage ../applications/audio/sunvox { };

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

  swift-im = libsForQt5.callPackage ../applications/networking/instant-messengers/swift-im {
    inherit (gnome2) GConf;
  };

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed { };

  symlinks = callPackage ../tools/system/symlinks { };

  syncplay = callPackage ../applications/networking/syncplay { };

  inherit (callPackages ../applications/networking/syncthing { })
    syncthing
    syncthing-cli
    syncthing-discovery
    syncthing-relay;

  syncthing-gtk = python2Packages.callPackage ../applications/networking/syncthing-gtk { };

  syncthing-tray = callPackage ../applications/misc/syncthing-tray { };

  synergy = callPackage ../applications/misc/synergy {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa CoreServices ScreenSaver;
  };

  tabbed = callPackage ../applications/window-managers/tabbed {
    # if you prefer a custom config, write the config.h in tabbed.config.h
    # and enable
    # customConfig = builtins.readFile ./tabbed.config.h;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages;
  };

  tagainijisho = callPackage ../applications/office/tagainijisho {};

  tahoe-lafs = callPackage ../tools/networking/p2p/tahoe-lafs {};

  tailor = callPackage ../applications/version-management/tailor {};

  tangogps = callPackage ../applications/misc/tangogps {
    gconf = gnome2.GConf;
  };

  teamspeak_client = libsForQt5.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  teamspeak_server = callPackage ../applications/networking/instant-messengers/teamspeak/server.nix { };

  taskjuggler = callPackage ../applications/misc/taskjuggler { };

  tasknc = callPackage ../applications/misc/tasknc { };

  taskwarrior = callPackage ../applications/misc/taskwarrior { };

  tasksh = callPackage ../applications/misc/tasksh { };

  taskserver = callPackage ../servers/misc/taskserver { };

  tdesktopPackages = callPackage ../applications/networking/instant-messengers/telegram/tdesktop { };
  tdesktop = tdesktopPackages.stable;

  telegram-cli = callPackage ../applications/networking/instant-messengers/telegram/telegram-cli { };

  telepathy-gabble = callPackage ../applications/networking/instant-messengers/telepathy/gabble { };

  telepathy-haze = callPackage ../applications/networking/instant-messengers/telepathy/haze {};

  telepathy-logger = callPackage ../applications/networking/instant-messengers/telepathy/logger {};

  telepathy-mission-control = callPackage ../applications/networking/instant-messengers/telepathy/mission-control { };

  telepathy-salut = callPackage ../applications/networking/instant-messengers/telepathy/salut {};

  telepathy-idle = callPackage ../applications/networking/instant-messengers/telepathy/idle {};

  termdown = (newScope pythonPackages) ../applications/misc/termdown { };

  terminal-notifier = callPackage ../applications/misc/terminal-notifier {};

  terminator = callPackage ../applications/misc/terminator { };

  terminus = callPackage ../applications/misc/terminus { };

  lxterminal = callPackage ../applications/misc/lxterminal {
    vte = gnome3.vte;
  };

  termite-unwrapped = callPackage ../applications/misc/termite {
    vte = gnome3.vte-ng;
  };

  termite = callPackage ../applications/misc/termite/wrapper.nix { termite = termite-unwrapped; };

  termtosvg = callPackage ../tools/misc/termtosvg { };

  tesseract = callPackage ../applications/graphics/tesseract { };
  tesseract_4 = lowPrio (callPackage ../applications/graphics/tesseract/4.x.nix { });

  tetraproc = callPackage ../applications/audio/tetraproc { };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  nylas-mail-bin = callPackage ../applications/networking/mailreaders/nylas-mail-bin { };

  thonny = callPackage ../applications/editors/thonny { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome2) libIDL;
    libpng = libpng_apng;
    enableGTK3 = true;
  };

  thunderbolt = callPackage ../os-specific/linux/thunderbolt {};

  thunderbird-bin = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  tig = gitAndTools.tig;

  tilda = callPackage ../applications/misc/tilda {
    vte = gnome3.vte;
    gtk = gtk3;
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid {
    fftw = fftwSinglePrec;
  };

  timescaledb = callPackage ../servers/sql/postgresql/timescaledb {};

  timewarrior = callPackage ../applications/misc/timewarrior { };

  timidity = callPackage ../tools/misc/timidity { };

  tint2 = callPackage ../applications/misc/tint2 { };

  tixati = callPackage ../applications/networking/p2p/tixati { };

  tkcvs = callPackage ../applications/version-management/tkcvs { };

  tla = callPackage ../applications/version-management/arch { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  tnef = callPackage ../applications/misc/tnef { };

  todiff = callPackage ../applications/misc/todiff { };

  todo-txt-cli = callPackage ../applications/office/todo.txt-cli { };

  todoman = callPackage ../applications/office/todoman { };

  toggldesktop = libsForQt5.callPackage ../applications/misc/toggldesktop { };

  tomahawk = callPackage ../applications/audio/tomahawk {
    taglib = taglib_1_9;
    enableXMPP      = config.tomahawk.enableXMPP      or true;
    enableKDE       = config.tomahawk.enableKDE       or false;
    enableTelepathy = config.tomahawk.enableTelepathy or false;
    quazip = quazip_qt4;
    boost = boost155;
  };

  topydo = callPackage ../applications/misc/topydo {};

  torchPackages = recurseIntoAttrs ( callPackage ../applications/science/machine-learning/torch {
    lua = luajit ;
  } );

  torch-repl = lib.setName "torch-repl" torchPackages.trepl;

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    inherit (pythonPackages) wrapPython wxPython;
  };

  tortoisehg = callPackage ../applications/version-management/tortoisehg { };

  toot = callPackage ../applications/misc/toot { };

  tootle = callPackage ../applications/misc/tootle { };

  toxic = callPackage ../applications/networking/instant-messengers/toxic { };

  toxiproxy = callPackage ../development/tools/toxiproxy { };

  tqsl = callPackage ../applications/misc/tqsl { };

  transcode = callPackage ../applications/audio/transcode { };

  transcribe = callPackage ../applications/audio/transcribe { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission-gtk = transmission.override { enableGTK3 = true; };

  transmission-remote-cli = callPackage ../applications/networking/p2p/transmission-remote-cli {};
  transmission-remote-gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  transgui = callPackage ../applications/networking/p2p/transgui { };

  trayer = callPackage ../applications/window-managers/trayer { };

  tree = callPackage ../tools/system/tree {};

  treesheets = callPackage ../applications/office/treesheets { wxGTK = wxGTK31; };

  trezor-bridge = callPackage ../applications/networking/browsers/mozilla-plugins/trezor { };

  tribler = callPackage ../applications/networking/p2p/tribler { };

  trojita = libsForQt5.callPackage ../applications/networking/mailreaders/trojita { };

  tsearch_extras = callPackage ../servers/sql/postgresql/tsearch_extras { };

  tudu = callPackage ../applications/office/tudu { };

  tuxguitar = callPackage ../applications/editors/music/tuxguitar { };

  twister = callPackage ../applications/networking/p2p/twister {
    boost = boost160;
  };

  twmn = libsForQt5.callPackage ../applications/misc/twmn { };

  testssl = callPackage ../applications/networking/testssl { };

  umurmur = callPackage ../applications/networking/umurmur { };

  udocker = pythonPackages.callPackage ../tools/virtualization/udocker { };

  unigine-valley = callPackage ../applications/graphics/unigine-valley { };

  inherit (ocaml-ng.ocamlPackages_4_05) unison;

  unpaper = callPackage ../tools/graphics/unpaper { };

  urh = callPackage ../applications/misc/urh { };

  uuagc = haskell.lib.justStaticExecutables haskellPackages.uuagc;

  uucp = callPackage ../tools/misc/uucp { };

  uvccapture = callPackage ../applications/video/uvccapture { };

  uwimap = callPackage ../tools/networking/uwimap { };

  uzbl = callPackage ../applications/networking/browsers/uzbl {
    webkit = webkitgtk24x-gtk2;
  };

  utox = callPackage ../applications/networking/instant-messengers/utox { };

  valentina = libsForQt5.callPackage ../applications/misc/valentina { };

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vcprompt = callPackage ../applications/version-management/vcprompt { };

  vcv-rack = callPackage ../applications/audio/vcv-rack { };

  vdirsyncer = callPackage ../tools/misc/vdirsyncer { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  verbiste = callPackage ../applications/misc/verbiste {
    inherit (gnome2) libgnomeui;
  };

  vim = callPackage ../applications/editors/vim {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  vimiv = callPackage ../applications/graphics/vimiv {
    inherit (gnome3) defaultIconTheme;
  };

  macvim = callPackage ../applications/editors/vim/macvim.nix { stdenv = clangStdenv; };

  vimHugeX = vim_configurable;

  vim_configurable = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/configurable.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;
    gtk2 = if stdenv.isDarwin then gtk2-x11 else gtk2;
    gtk3 = if stdenv.isDarwin then gtk3-x11 else gtk3;
  });

  qpdfview = libsForQt5.callPackage ../applications/misc/qpdfview {};

  qtile = callPackage ../applications/window-managers/qtile {
    inherit (xorg) libxcb;
  };

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  vimpc = callPackage ../applications/audio/vimpc { };

  wrapNeovim = callPackage ../applications/editors/neovim/wrapper.nix { };

  neovim-unwrapped = callPackage ../applications/editors/neovim {
    luaPackages = luajitPackages;
  };

  neovim = wrapNeovim neovim-unwrapped { };

  neovim-qt = libsForQt5.callPackage ../applications/editors/neovim/qt.nix { };

  neovim-pygui = pythonPackages.neovim_gui;

  neovim-remote = callPackage ../applications/editors/neovim/neovim-remote.nix { pythonPackages = python3Packages; };

  vis = callPackage ../applications/editors/vis {
    inherit (lua52Packages) lpeg;
  };

  virt-viewer = callPackage ../applications/virtualization/virt-viewer { };

  virt-top = callPackage ../applications/virtualization/virt-top { };

  virt-what = callPackage ../applications/virtualization/virt-what { };

  virtmanager = callPackage ../applications/virtualization/virt-manager {
    vte = gnome3.vte;
    dconf = gnome3.dconf;
    system-libvirt = libvirt;
  };

  virtmanager-qt = libsForQt5.callPackage ../applications/virtualization/virt-manager/qt.nix {
    qtermwidget = lxqt.qtermwidget;
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

  virtualbox = callPackage ../applications/virtualization/virtualbox {
    stdenv = stdenv_32bit;
    inherit (gnome2) libIDL;
    pulseSupport = config.pulseaudio or true;
  };

  virtualboxHardened = lowPrio (virtualbox.override {
    enableHardening = true;
  });

  virtualboxHeadless = lowPrio (virtualbox.override {
    enableHardening = true;
    headless = true;
  });

  virtualboxExtpack = callPackage ../applications/virtualization/virtualbox/extpack.nix { };

  virtualboxWithExtpack = lowPrio (virtualbox.override {
    extensionPack = virtualboxExtpack;
  });

  virtualglLib = callPackage ../tools/X11/virtualgl/lib.nix {
    fltk = fltk13;
  };

  virtualgl = callPackage ../tools/X11/virtualgl {
    virtualglLib_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.virtualglLib
      else null;
  };

  vpcs = callPackage ../applications/virtualization/vpcs { };

  primusLib = callPackage ../tools/X11/primus/lib.nix {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  primus = callPackage ../tools/X11/primus {
    stdenv_i686 = pkgsi686Linux.stdenv;
    primusLib_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.primusLib
      else null;
  };

  bumblebee = callPackage ../tools/X11/bumblebee {
    nvidia_x11 = linuxPackages.nvidia_x11;
    nvidia_x11_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.linuxPackages.nvidia_x11.override { libsOnly = true; }
      else null;
    libglvnd_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.libglvnd
      else null;
  };

  uvcdynctrl = callPackage ../os-specific/linux/uvcdynctrl { };

  vkeybd = callPackage ../applications/audio/vkeybd {};

  vlc = libsForQt5.vlc;

  vlc_qt5 = vlc;

  vmpk = callPackage ../applications/audio/vmpk { };

  vnstat = callPackage ../applications/networking/vnstat { };

  vocal = callPackage ../applications/audio/vocal { };

  vogl = libsForQt5.callPackage ../development/tools/vogl { };

  volnoti = callPackage ../applications/misc/volnoti { };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools { };

  vscode = callPackage ../applications/editors/vscode { };

  vscode-with-extensions = callPackage ../applications/editors/vscode/with-extensions.nix {};

  vscode-utils = callPackage ../misc/vscode-extensions/vscode-utils.nix {};

  vscode-extensions = recurseIntoAttrs (callPackage ../misc/vscode-extensions {});

  vue = callPackage ../applications/misc/vue { };

  vuze = callPackage ../applications/networking/p2p/vuze { };

  vwm = callPackage ../applications/window-managers/vwm { };

  vym = qt5.callPackage ../applications/misc/vym { };

  w3m = callPackage ../applications/networking/browsers/w3m {
    graphicsSupport = !stdenv.isDarwin;
  };

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

  watson = callPackage ../applications/office/watson {
    pythonPackages = python3Packages;
  };

  way-cooler = callPackage ../applications/window-managers/way-cooler {};

  wayv = callPackage ../tools/X11/wayv {};

  webtorrent_desktop = callPackage ../applications/video/webtorrent_desktop {};

  weechat = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
    inherit (darwin) libresolv;
    guile = guile_2_0;
  };

  weechatScripts = callPackage ../applications/networking/irc/weechat/scripts { };

  westonLite = weston.override {
    pango = null;
    freerdp = null;
    libunwind = null;
    vaapi = null;
    libva = null;
    libwebp = null;
    xwayland = null;
  };

  weston = callPackage ../applications/window-managers/weston {
    freerdp = freerdp_legacy;
  };

  whitebox-tools = callPackage ../applications/gis/whitebox-tools {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  windowlab = callPackage ../applications/window-managers/windowlab { };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  wily = callPackage ../applications/editors/wily { };

  winswitch = callPackage ../tools/X11/winswitch { };

  wings = callPackage ../applications/graphics/wings {
    erlang = erlangR18;
  };

  write_stylus = libsForQt5.callPackage ../applications/graphics/write_stylus { };

  alsamixer.app = callPackage ../applications/window-managers/windowmaker/dockapps/alsamixer.app.nix { };

  wllvm = callPackage  ../development/tools/wllvm { };

  wmcalclock = callPackage ../applications/window-managers/windowmaker/dockapps/wmcalclock.nix { };

  wmsm.app = callPackage ../applications/window-managers/windowmaker/dockapps/wmsm.app.nix { };

  wmsystemtray = callPackage ../applications/window-managers/windowmaker/dockapps/wmsystemtray.nix { };

  wmname = callPackage ../applications/misc/wmname { };

  wmctrl = callPackage ../tools/X11/wmctrl { };

  wmii_hg = callPackage ../applications/window-managers/wmii-hg { };

  wordnet = callPackage ../applications/misc/wordnet { };

  wordgrinder = callPackage ../applications/office/wordgrinder { };

  worker = callPackage ../applications/misc/worker { };

  workrave = callPackage ../applications/misc/workrave {
    inherit (python27Packages) cheetah;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  worldengine-cli = python3Packages.worldengine;

  wpsoffice = callPackage ../applications/office/wpsoffice {};

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

  wp-cli = callPackage ../development/tools/wp-cli { };

  retroArchCores =
    let
      cfg = config.retroarch or {};
      inherit (lib) optional;
    in with libretro;
      ([ ]
      ++ optional (cfg.enable4do or false) _4do
      ++ optional (cfg.enableBeetlePCEFast or false) beetle-pce-fast
      ++ optional (cfg.enableBeetlePSX or false) beetle-psx
      ++ optional (cfg.enableBeetleSaturn or false) beetle-saturn
      ++ optional (cfg.enableBsnesMercury or false) bsnes-mercury
      ++ optional (cfg.enableDesmume or false) desmume
      ++ optional (cfg.enableDolphin or false) dolphin
      ++ optional (cfg.enableFBA or false) fba
      ++ optional (cfg.enableFceumm or false) fceumm
      ++ optional (cfg.enableGambatte or false) gambatte
      ++ optional (cfg.enableGenesisPlusGX or false) genesis-plus-gx
      ++ optional (cfg.enableHiganSFC or false) higan-sfc
      ++ optional (cfg.enableMAME or false) mame
      ++ optional (cfg.enableMGBA or false) mgba
      ++ optional (cfg.enableMupen64Plus or false) mupen64plus
      ++ optional (cfg.enableNestopia or false) nestopia
      ++ optional (cfg.enableParallelN64 or false) parallel-n64
      ++ optional (cfg.enablePicodrive or false) picodrive
      ++ optional (cfg.enablePrboom or false) prboom
      ++ optional (cfg.enablePPSSPP or false) ppsspp
      ++ optional (cfg.enableQuickNES or false) quicknes
      ++ optional (cfg.enableReicast or false) reicast
      ++ optional (cfg.enableScummVM or false) scummvm
      ++ optional (cfg.enableSnes9x or false) snes9x
      ++ optional (cfg.enableSnes9xNext or false) snes9x-next
      ++ optional (cfg.enableStella or false) stella
      ++ optional (cfg.enableVbaNext or false) vba-next
      ++ optional (cfg.enableVbaM or false) vba-m

      # added on 2017-02-25 due #23163
      ++ optional (cfg.enableMednafenPCEFast or false)
          (throw "nix config option enableMednafenPCEFast has been renamed to enableBeetlePCEFast")
      ++ optional (cfg.enableMednafenPSX or false)
          (throw "nix config option enableMednafenPSX has been renamed to enableBeetlePSX")
      ++ optional (cfg.enableMednafenSaturn or false)
          (throw "nix config option enableMednafenSaturn has been renamed to enableBeetleSaturn")
      );

  wrapRetroArch = { retroarch }: callPackage ../misc/emulators/retroarch/wrapper.nix {
    inherit retroarch;
    cores = retroArchCores;
  };

  wrapKodi = { kodi }: callPackage ../applications/video/kodi/wrapper.nix {
    inherit kodi;
    plugins = let inherit (lib) optional optionals; in with kodiPlugins;
      ([]
      ++ optional (config.kodi.enableAdvancedLauncher or false) advanced-launcher
      ++ optional (config.kodi.enableAdvancedEmulatorLauncher or false)
        advanced-emulator-launcher
      ++ optionals (config.kodi.enableControllers or false)
        (with controllers;
          [ default dreamcast gba genesis mouse n64 nes ps snes ])
      ++ optional (config.kodi.enableExodus or false) exodus
      ++ optionals (config.kodi.enableHyperLauncher or false)
           (with hyper-launcher; [ plugin service pdfreader ])
      ++ optional (config.kodi.enableJoystick or false) joystick
      ++ optional (config.kodi.enableOSMCskin or false) osmc-skin
      ++ optional (config.kodi.enableSVTPlay or false) svtplay
      ++ optional (config.kodi.enableSteamController or false) steam-controller
      ++ optional (config.kodi.enableSteamLauncher or false) steam-launcher
      ++ optional (config.kodi.enablePVRHTS or false) pvr-hts
      ++ optional (config.kodi.enablePVRHDHomeRun or false) pvr-hdhomerun
      ++ optional (config.kodi.enablePVRIPTVSimple or false) pvr-iptvsimple
      );
  };

  wsjtx = qt5.callPackage ../applications/misc/wsjtx { };

  wtftw = callPackage ../applications/window-managers/wtftw {};

  wxhexeditor = callPackage ../applications/editors/wxhexeditor {
    wxGTK = wxGTK31;
  };

  wxcam = callPackage ../applications/video/wxcam {
    inherit (gnome2) libglade;
    wxGTK = wxGTK28;
    gtk = gtk2;
  };

  x11vnc = callPackage ../tools/X11/x11vnc { };

  x2goclient = libsForQt5.callPackage ../applications/networking/remote/x2goclient { };

  x2vnc = callPackage ../tools/X11/x2vnc { };

  x32edit = callPackage ../applications/audio/midas/x32edit.nix {};

  x42-plugins = callPackage ../applications/audio/x42-plugins { };

  xannotate = callPackage ../tools/X11/xannotate {};

  xaos = callPackage ../applications/graphics/xaos {
    libpng = libpng12;
  };

  xara = callPackage ../applications/graphics/xara { };

  xastir = callPackage ../applications/misc/xastir {
    rastermagick = imagemagick;
    inherit (xorg) libXt;
  };

  xautomation = callPackage ../tools/X11/xautomation { };

  xawtv = callPackage ../applications/video/xawtv { };

  xbindkeys = callPackage ../tools/X11/xbindkeys { };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config {
    gtk = gtk2;
  };

  kodiPlain = callPackage ../applications/video/kodi { };

  kodiPlugins = recurseIntoAttrs (callPackage ../applications/video/kodi/plugins.nix {});

  kodi = wrapKodi {
    kodi = kodiPlain;
  };

  kodi-retroarch-advanced-launchers =
    callPackage ../misc/emulators/retroarch/kodi-advanced-launchers.nix {
      cores = retroArchCores;
  };
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers;

  xca = libsForQt5.callPackage ../applications/misc/xca { };

  xcalib = callPackage ../tools/X11/xcalib { };

  xcape = callPackage ../tools/X11/xcape { };

  xchainkeys = callPackage ../tools/X11/xchainkeys { };

  xchm = callPackage ../applications/misc/xchm { };

  inherit (xorg) xcompmgr;

  inherit (callPackage ../applications/window-managers/compton {}) compton compton-git;

  xdaliclock = callPackage ../tools/misc/xdaliclock {};

  xdg-dbus-proxy = callPackage ../development/libraries/xdg-dbus-proxy { };

  xdg-desktop-portal = callPackage ../development/libraries/xdg-desktop-portal { };

  xdg-desktop-portal-gtk = callPackage ../development/libraries/xdg-desktop-portal-gtk { };

  xdg-user-dirs = callPackage ../tools/X11/xdg-user-dirs { };

  xdg_utils = callPackage ../tools/X11/xdg-utils {
    w3m = w3m-batch;
  };

  xdgmenumaker = callPackage ../applications/misc/xdgmenumaker { };

  xdotool = callPackage ../tools/X11/xdotool { };

  xenPackages = recurseIntoAttrs (callPackage ../applications/virtualization/xen/packages.nix {});

  xen = xenPackages.xen-vanilla;
  xen-slim = xenPackages.xen-slim;
  xen-light = xenPackages.xen-light;

  xen_4_8 = xenPackages.xen_4_8-vanilla;
  xen_4_8-slim = xenPackages.xen_4_8-slim;
  xen_4_8-light = xenPackages.xen_4_8-light;
  xen_4_10 = xenPackages.xen_4_10-vanilla;
  xen_4_10-slim = xenPackages.xen_4_10-slim;
  xen_4_10-light = xenPackages.xen_4_10-light;

  xkbset = callPackage ../tools/X11/xkbset { };

  xkbmon = callPackage ../applications/misc/xkbmon { };

  win-spice = callPackage ../applications/virtualization/driver/win-spice { };
  win-virtio = callPackage ../applications/virtualization/driver/win-virtio { };
  win-qemu = callPackage ../applications/virtualization/driver/win-qemu { };
  win-pvdrivers = callPackage ../applications/virtualization/driver/win-pvdrivers { };
  win-signed-gplpv-drivers = callPackage ../applications/virtualization/driver/win-signed-gplpv-drivers { };

  xfe = callPackage ../applications/misc/xfe {
    fox = fox_1_6;
  };

  xfig = callPackage ../applications/graphics/xfig { };

  xfractint = callPackage ../applications/graphics/xfractint {};

  xineUI = callPackage ../applications/video/xine-ui { };

  xmind = callPackage ../applications/misc/xmind { };

  xneur = callPackage ../applications/misc/xneur { };

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome2) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gconf = gnome2.GConf;
    inherit (gnome2) libglade scrollkeeper;
    gtkhtml = gnome2.gtkhtml4;
    python = python27;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome2) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  apvlv = callPackage ../applications/misc/apvlv { };

  xpdf = libsForQt5.callPackage ../applications/misc/xpdf { };

  xpointerbarrier = callPackage ../tools/X11/xpointerbarrier {};

  xkb_switch = callPackage ../tools/X11/xkb-switch { };

  xkblayout-state = callPackage ../applications/misc/xkblayout-state { };

  xmonad-log = callPackage ../tools/misc/xmonad-log { };

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: [];
  };

  xmonad_log_applet = callPackage ../applications/window-managers/xmonad/log-applet {
    desktopSupport = "gnomeflashback";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_mate = xmonad_log_applet.override {
    desktopSupport = "mate";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_xfce = xmonad_log_applet.override {
    desktopSupport = "xfce4";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmpp-client = callPackage ../applications/networking/instant-messengers/xmpp-client { };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { };
  libfakeXinerama = callPackage ../tools/X11/xpra/libfakeXinerama.nix { };
  #TODO: 'pil' is not available for python3, yet
  xpraGtk3 = callPackage ../tools/X11/xpra/gtk3.nix { inherit (texFunctions) fontsConf; inherit (python3Packages) buildPythonApplication python cython pygobject3 pycairo; };

  xrectsel = callPackage ../tools/X11/xrectsel { };

  xrestop = callPackage ../tools/X11/xrestop { };

  xsd = callPackage ../development/libraries/xsd { };

  xscope = callPackage ../applications/misc/xscope { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome2) libglade;
  };

  xss-lock = callPackage ../misc/screensavers/xss-lock { };

  xloadimage = callPackage ../tools/X11/xloadimage { };

  xssproxy = callPackage ../misc/screensavers/xssproxy { };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  mlterm = callPackage ../applications/misc/mlterm {
    vte = gnome3.vte;
    libssh2 = null;
    openssl = null;
  };

  roxterm = callPackage ../applications/misc/roxterm {
    inherit (gnome3) gsettings-desktop-schemas vte;
  };

  xtrace = callPackage ../tools/X11/xtrace { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmove = callPackage ../applications/misc/xmove { };

  xmp = callPackage ../applications/audio/xmp { };

  xnee = callPackage ../tools/X11/xnee { };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome2) scrollkeeper libglade;
  };

  xzgv = callPackage ../applications/graphics/xzgv { };

  yabar = callPackage ../applications/window-managers/yabar { };

  yabar-unstable = callPackage ../applications/window-managers/yabar/unstable.nix { };

  yakuake = libsForQt5.callPackage ../applications/misc/yakuake {
    inherit (kdeApplications) konsole;
  };

  yarp = callPackage ../applications/science/robotics/yarp {};

  yarssr = callPackage ../applications/misc/yarssr { };

  yate = callPackage ../applications/misc/yate { };

  ydiff = callPackage ../development/tools/ydiff { };

  yed = callPackage ../applications/graphics/yed {};

  inherit (gnome3) yelp;

  yokadi = python3Packages.callPackage ../applications/misc/yokadi {};

  yoshimi = callPackage ../applications/audio/yoshimi { };

  youtube-dl = with python3Packages; toPythonApplication youtube-dl;

  youtube-dl-light = with python3Packages; toPythonApplication youtube-dl-light;

  youtube-viewer = perlPackages.WWWYoutubeViewer;

  zam-plugins = callPackage ../applications/audio/zam-plugins { };

  zanshin = libsForQt5.callPackage ../applications/office/zanshin {
    inherit (kdeApplications) akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap;
    inherit (kdeFrameworks) krunner kwallet;
    boost = boost160;
  };

  zathura = callPackage ../applications/misc/zathura {
    useMupdf = config.zathura.useMupdf or true;
  };

  zeroc_ice = callPackage ../development/libraries/zeroc-ice {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zeronet = callPackage ../applications/networking/p2p/zeronet { };

  zexy = callPackage ../applications/audio/pd-plugins/zexy  { };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zgv = callPackage ../applications/graphics/zgv {
   # Enable the below line for terminal display. Note
   # that it requires sixel graphics compatible terminals like mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  zim = callPackage ../applications/office/zim { };

  zoom-us = libsForQt59.callPackage ../applications/networking/instant-messengers/zoom-us { };

  zotero = callPackage ../applications/office/zotero { };

  zscroll = callPackage ../applications/misc/zscroll {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };

  ### GAMES

  _2048-in-terminal = callPackage ../games/2048-in-terminal { };

  _20kly = callPackage ../games/20kly { };

  _90secondportraits = callPackage ../games/90secondportraits { love = love_0_10; };

  adom = callPackage ../games/adom { };

  airstrike = callPackage ../games/airstrike { };

  alienarena = callPackage ../games/alienarena { };

  amoeba = callPackage ../games/amoeba { };
  amoeba-data = callPackage ../games/amoeba/data.nix { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

  angband = callPackage ../games/angband { };

  anki = python2Packages.callPackage ../games/anki { };

  armagetronad = callPackage ../games/armagetronad { };

  arena = callPackage ../games/arena {};

  arx-libertatis = callPackage ../games/arx-libertatis {
    stdenv = overrideCC stdenv gcc6;
  };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    libsigcxx = libsigcxx12;
    physfs = physfs_2;
  };

  assaultcube = callPackage ../games/assaultcube { };

  astromenace = callPackage ../games/astromenace { };

  atanks = callPackage ../games/atanks {};

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  banner = callPackage ../games/banner {};

  bastet = callPackage ../games/bastet {};

  beancount = with python3.pkgs; toPythonApplication beancount;

  bean-add = callPackage ../applications/office/beancount/bean-add.nix { };

  bench = haskell.lib.justStaticExecutables haskellPackages.bench;

  beret = callPackage ../games/beret { };

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  blackshadeselite = callPackage ../games/blackshadeselite { };

  blobby = callPackage ../games/blobby { };

  braincurses = callPackage ../games/braincurses { };

  brogue = callPackage ../games/brogue { };

  bsdgames = callPackage ../games/bsdgames { };

  btanks = callPackage ../games/btanks { };

  bzflag = callPackage ../games/bzflag { };

  cataclysm-dda = callPackage ../games/cataclysm-dda {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    ncurses = ncurses5;
  };

  cataclysm-dda-git = callPackage ../games/cataclysm-dda/git.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
  };

  chessdb = callPackage ../games/chessdb { };

  chessx = libsForQt59.callPackage ../games/chessx { };

  chocolateDoom = callPackage ../games/chocolate-doom { };

  crispyDoom = callPackage ../games/crispy-doom { };

  ckan = callPackage ../games/ckan { };

  cockatrice = libsForQt5.callPackage ../games/cockatrice {  };

  commandergenius = callPackage ../games/commandergenius { };

  confd = callPackage ../tools/system/confd { };

  construoBase = lowPrio (callPackage ../games/construo {
    libGL = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit  freeglut;
    libGL = libGLU_combined;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crafty = callPackage ../games/crafty { };

  crawlTiles = callPackage ../games/crawl {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  crrcsim = callPackage ../games/crrcsim {};

  cutemaze = libsForQt5.callPackage ../games/cutemaze {};

  cuyo = callPackage ../games/cuyo { };

  dhewm3 = callPackage ../games/dhewm3 {};

  digikam = libsForQt5.callPackage ../applications/graphics/digikam {
    inherit (plasma5) oxygen;
    inherit (kdeApplications) kcalcore;
    opencv3 = opencv3WithoutCuda;
  };

  displaycal = (newScope pythonPackages) ../applications/graphics/displaycal {};

  drumkv1 = callPackage ../applications/audio/drumkv1 { };

  duckmarines = callPackage ../games/duckmarines { love = love_0_9; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });

  dwarf-fortress = dwarf-fortress-packages.dwarf-fortress;

  dwarf-therapist = dwarf-fortress-packages.dwarf-therapist;

  dxx-rebirth = callPackage ../games/dxx-rebirth {
    physfs = physfs_2;
  };

  inherit (callPackages ../games/dxx-rebirth/assets.nix { })
    descent1-assets
    descent2-assets;

  inherit (callPackages ../games/dxx-rebirth/full.nix { })
    d1x-rebirth-full
    d2x-rebirth-full;

  easyrpg-player = callPackage ../games/easyrpg-player { };

  eboard = callPackage ../games/eboard { };

  eduke32 = callPackage ../games/eduke32 { };

  egoboo = callPackage ../games/egoboo { };

  EmptyEpsilon = callPackage ../games/empty-epsilon { };

  endgame-singularity = callPackage ../games/endgame-singularity { };

  endless-sky = callPackage ../games/endless-sky { };

  enyo-doom = libsForQt5.callPackage ../games/enyo-doom { };

  eternity = callPackage ../games/eternity-engine { };

  eureka-editor = callPackage ../applications/misc/eureka-editor { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  exult = callPackage ../games/exult { };

  factorio = callPackage ../games/factorio { releaseType = "alpha"; };

  factorio-experimental = factorio.override { releaseType = "alpha"; experimental = true; };

  factorio-headless = factorio.override { releaseType = "headless"; };

  factorio-headless-experimental = factorio.override { releaseType = "headless"; experimental = true; };

  factorio-demo = factorio.override { releaseType = "demo"; };

  factorio-mods = callPackage ../games/factorio/mods.nix { };

  factorio-utils = callPackage ../games/factorio/utils.nix { };

  fairymax = callPackage ../games/fairymax {};

  fava = callPackage ../applications/office/fava {};

  fish-fillets-ng = callPackage ../games/fish-fillets-ng {};

  flightgear = libsForQt5.callPackage ../games/flightgear { };

  flock = callPackage ../development/tools/flock { };

  freecell-solver = callPackage ../games/freecell-solver { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = freeciv.override {
    gtkClient = true;
    sdlClient = false;
  };

  freedink = callPackage ../games/freedink { };

  freeorion = callPackage ../games/freeorion { };

  freesweep = callPackage ../games/freesweep { };

  frotz = callPackage ../games/frotz { };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  galaxis = callPackage ../games/galaxis { };

  gambatte = callPackage ../games/gambatte { };

  garden-of-coloured-lights = callPackage ../games/garden-of-coloured-lights { allegro = allegro4; };

  gargoyle = callPackage ../games/gargoyle {
    libtool = darwin.cctools;
  };

  gav = callPackage ../games/gav { };

  gcs = callPackage ../games/gcs { };

  gcompris = libsForQt59.callPackage ../games/gcompris { };

  gemrb = callPackage ../games/gemrb { };

  gl117 = callPackage ../games/gl-117 {};

  globulation2 = callPackage ../games/globulation {
    boost = boost155;
  };

  gltron = callPackage ../games/gltron { };

  gmad = callPackage ../games/gmad { };

  gnubg = callPackage ../games/gnubg { };

  gnuchess = callPackage ../games/gnuchess { };

  gnugo = callPackage ../games/gnugo { };

  gnujump = callPackage ../games/gnujump { };

  gnushogi = callPackage ../games/gnushogi { };

  gogui = callPackage ../games/gogui {};

  gshogi = python3Packages.callPackage ../games/gshogi {};

  gtetrinet = callPackage ../games/gtetrinet {
    inherit (gnome2) GConf libgnome libgnomeui;
  };

  gtypist = callPackage ../games/gtypist { };

  gzdoom = callPackage ../games/gzdoom { };

  hawkthorne = callPackage ../games/hawkthorne { love = love_0_9; };

  hedgewars = callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
    ffmpeg = ffmpeg_2;
  };

  hexen = callPackage ../games/hexen { };

  holdingnuts = callPackage ../games/holdingnuts { };

  hyperrogue = callPackage ../games/hyperrogue { };

  icbm3d = callPackage ../games/icbm3d { };

  ingen = callPackage ../applications/audio/ingen {
    inherit (pythonPackages) rdflib;
  };

  instead = callPackage ../games/instead {
    lua = lua5;
  };

  instead-launcher = callPackage ../games/instead-launcher { };

  ja2-stracciatella = callPackage ../games/ja2-stracciatella { };

  klavaro = callPackage ../games/klavaro {};

  kobodeluxe = callPackage ../games/kobodeluxe { };

  lgogdownloader = callPackage ../games/lgogdownloader { };

  liberal-crime-squad = callPackage ../games/liberal-crime-squad { };

  lincity = callPackage ../games/lincity {};

  lincity_ng = callPackage ../games/lincity/ng.nix {
    # https://github.com/lincity-ng/lincity-ng/issues/25
    physfs = physfs_2;
  };

  liquidwar = callPackage ../games/liquidwar {
    guile = guile_2_0;
  };

  liquidwar5 = callPackage ../games/liquidwar/5.nix {
  };

  macopix = callPackage ../games/macopix {
    gtk = gtk2;
  };

  mars = callPackage ../games/mars { };

  megaglest = callPackage ../games/megaglest {};

  minecraft = callPackage ../games/minecraft { };

  minecraft-server = callPackage ../games/minecraft-server { };

  moon-buggy = callPackage ../games/moon-buggy {};

  multimc = libsForQt5.callPackage ../games/multimc { };

  minetest = callPackage ../games/minetest {
    libpng = libpng12;
  };

  mnemosyne = callPackage ../games/mnemosyne {
    python = python3;
  };

  mrrescue = callPackage ../games/mrrescue { };

  mudlet = libsForQt5.callPackage ../games/mudlet {
    inherit (lua51Packages) luafilesystem lrexlib luazip luasqlite3;
  };

  n2048 = callPackage ../games/n2048 {};

  naev = callPackage ../games/naev { };

  nethack = callPackage ../games/nethack { };

  nethack-qt = callPackage ../games/nethack { qtMode = true; };

  nethack-x11 = callPackage ../games/nethack { x11Mode = true; };

  neverball = callPackage ../games/neverball { };

  nexuiz = callPackage ../games/nexuiz { };

  njam = callPackage ../games/njam { };

  newtonwars = callPackage ../games/newtonwars { };

  odamex = callPackage ../games/odamex { };

  oilrush = callPackage ../games/oilrush { };

  onscripter-en = callPackage ../games/onscripter-en { };

  openarena = callPackage ../games/openarena { };

  opendungeons = callPackage ../games/opendungeons {
    ogre = ogre1_9;
  };

  openlierox = callPackage ../games/openlierox { };

  openclonk = callPackage ../games/openclonk { };

  openjk = callPackage ../games/openjk { };

  openmw = callPackage ../games/openmw { };

  openmw-tes3mp = libsForQt5.callPackage ../games/openmw/tes3mp.nix { };

  openra = callPackage ../games/openra { lua = lua5_1; };

  openrw = callPackage ../games/openrw { };

  openspades = callPackage ../games/openspades { };

  openttd = callPackage ../games/openttd {
    zlib = zlibStatic;
  };

  opentyrian = callPackage ../games/opentyrian { };

  openxcom = callPackage ../games/openxcom { };

  orthorobot = callPackage ../games/orthorobot { };

  pacvim = callPackage ../games/pacvim { };

  performous = callPackage ../games/performous { };

  pingus = callPackage ../games/pingus {};

  pioneer = callPackage ../games/pioneer { };

  pioneers = callPackage ../games/pioneers { };

  planetary_annihilation = callPackage ../games/planetaryannihilation { };

  pong3d = callPackage ../games/pong3d { };

  pokerth = callPackage ../games/pokerth { };

  pokerth-server = pokerth.server;

  prboom = callPackage ../games/prboom { };

  privateer = callPackage ../games/privateer { };

  pysolfc = callPackage ../games/pysolfc { };

  qweechat = callPackage ../applications/networking/irc/qweechat { };

  qqwing = callPackage ../games/qqwing { };

  quake3wrapper = callPackage ../games/quake3/wrapper { };

  quake3demo = quake3wrapper {
    name = "quake3-demo-${lib.getVersion quake3demodata}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    paks = [ quake3pointrelease quake3demodata ];
  };

  quake3demodata = callPackage ../games/quake3/content/demo.nix { };

  quake3pointrelease = callPackage ../games/quake3/content/pointrelease.nix { };

  quakespasm = callPackage ../games/quakespasm { };
  vkquake = callPackage ../games/quakespasm/vulkan.nix { };

  ioquake3 = callPackage ../games/quake3/ioquake { };

  quantumminigolf = callPackage ../games/quantumminigolf {};

  racer = callPackage ../games/racer { };

  residualvm = callPackage ../games/residualvm {
    openglSupport = libGLSupported;
  };

  rftg = callPackage ../games/rftg { };

  rigsofrods = callPackage ../games/rigsofrods {
    angelscript = angelscript_2_22;
    ogre = ogre1_9;
    ogrepaged = ogrepaged.override {
      ogre = ogre1_9;
    };
    mygui = mygui.override {
      withOgre = true;
    };
  };

  rili = callPackage ../games/rili { };

  rimshot = callPackage ../games/rimshot { love = love_0_7; };

  rogue = callPackage ../games/rogue {
    ncurses = ncurses5;
  };

  robotfindskitten = callPackage ../games/robotfindskitten { };

  rocksndiamonds = callPackage ../games/rocksndiamonds { };

  rrootage = callPackage ../games/rrootage { };

  saga = callPackage ../applications/gis/saga { };

  samplv1 = callPackage ../applications/audio/samplv1 { };

  sauerbraten = callPackage ../games/sauerbraten {};

  scaleway-cli = callPackage ../tools/admin/scaleway-cli { };

  scid = callPackage ../games/scid {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  scid-vs-pc = callPackage ../games/scid-vs-pc {
    tcl = tcl-8_6;
    tk = tk-8_6;
  };

  scummvm = callPackage ../games/scummvm { };

  scorched3d = callPackage ../games/scorched3d { };

  scrolls = callPackage ../games/scrolls { };

  sdlmame = callPackage ../games/sdlmame { };

  service-wrapper = callPackage ../os-specific/linux/service-wrapper { };

  sgtpuzzles = callPackage (callPackage ../games/sgt-puzzles) { };

  sienna = callPackage ../games/sienna { love = love_0_10; };

  sil = callPackage ../games/sil { };

  simutrans = callPackage ../games/simutrans { };
  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  snake4 = callPackage ../games/snake4 { };

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  solarus = libsForQt5.callPackage ../games/solarus { };

  solarus-quest-editor = libsForQt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.
  space-orbit = callPackage ../games/space-orbit { };

  spring = callPackage ../games/spring {
    boost = boost155;
    cmake = cmake_2_8;
  };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  ssl-cert-check = callPackage ../tools/admin/ssl-cert-check { };

  stardust = callPackage ../games/stardust {};

  stockfish = callPackage ../games/stockfish { };

  steamPackages = callPackage ../games/steam { };

  steam = steamPackages.steam-chrootenv.override {
    # DEPRECATED
    withJava = config.steam.java or false;
    withPrimus = config.steam.primus or false;
  };

  steam-run = steam.run;
  steam-run-native = (steam.override {
    nativeOnly = true;
  }).run;

  steamcmd = steamPackages.steamcmd;

  linux-steam-integration = callPackage ../games/linux-steam-integration {
    gtk = pkgs.gtk3;
  };

  stepmania = callPackage ../games/stepmania {
    ffmpeg = ffmpeg_2;
  };

  stuntrally = callPackage ../games/stuntrally {
    ogre = ogre1_9;
    mygui = mygui.override {
      withOgre = true;
    };
  };

  superTux = callPackage ../games/supertux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  synthv1 = callPackage ../applications/audio/synthv1 { };

  tcl2048 = callPackage ../games/tcl2048 { };

  the-powder-toy = callPackage ../games/the-powder-toy {
    lua = lua5_1;
  };

  tbe = callPackage ../games/the-butterfly-effect { };

  teetertorture = callPackage ../games/teetertorture { };

  teeworlds = callPackage ../games/teeworlds { };

  tengine = callPackage ../servers/http/tengine {
    modules = with nginxModules; [ rtmp dav moreheaders modsecurity-nginx ];
  };

  tennix = callPackage ../games/tennix { };

  terraria-server = callPackage ../games/terraria-server { };

  tibia = pkgsi686Linux.callPackage ../games/tibia { };

  tintin = callPackage ../games/tintin { };

  tinyfugue = callPackage ../games/tinyfugue { };

  tome4 = callPackage ../games/tome4 { };

  trackballs = callPackage ../games/trackballs { };

  tremulous = callPackage ../games/tremulous { };

  tuxpaint = callPackage ../games/tuxpaint { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    libpng = libpng12;
  };

  torcs = callPackage ../games/torcs { };

  trigger = callPackage ../games/trigger { };

  typespeed = callPackage ../games/typespeed { };

  ufoai = callPackage ../games/ufoai { };

  ultimatestunts = callPackage ../games/ultimatestunts { };

  ultrastar-creator = libsForQt5.callPackage ../tools/misc/ultrastar-creator { };

  ultrastar-manager = libsForQt5.callPackage ../tools/misc/ultrastar-manager { };

  ultrastardx = callPackage ../games/ultrastardx {
    ffmpeg = ffmpeg_2;
  };

  unnethack = callPackage ../games/unnethack { };

  uqm = callPackage ../games/uqm { };

  urbanterror = callPackage ../games/urbanterror { };

  ue4 = callPackage ../games/ue4 { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  ut2004Packages = callPackage ../games/ut2004 { };

  ut2004demo = self.ut2004Packages.ut2004 [ self.ut2004Packages.ut2004-demo ];

  vapor = callPackage ../games/vapor { love = love_0_8; };

  vapoursynth = callPackage ../development/libraries/vapoursynth {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  vapoursynth-mvtools = callPackage ../development/libraries/vapoursynth-mvtools { };

  vassal = callPackage ../games/vassal { };

  vdrift = callPackage ../games/vdrift { };

  # To ensure vdrift's code is built on hydra
  vdrift-bin = vdrift.bin;

  vectoroids = callPackage ../games/vectoroids { };

  vessel = pkgsi686Linux.callPackage ../games/vessel { };

  vitetris = callPackage ../games/vitetris { };

  vms-empire = callPackage ../games/vms-empire { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  warmux = callPackage ../games/warmux { };

  warsow-engine = callPackage ../games/warsow/engine.nix { };

  warsow = callPackage ../games/warsow { };

  warzone2100 = libsForQt5.callPackage ../games/warzone2100 { };

  wesnoth = callPackage ../games/wesnoth {
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
  };

  wesnoth-dev = wesnoth;

  widelands = callPackage ../games/widelands {
    lua = lua5_2;
  };

  worldofgoo_demo = worldofgoo.override {
    demo = true;
  };

  worldofgoo = callPackage ../games/worldofgoo { };

  xboard =  callPackage ../games/xboard { };

  xbomb = callPackage ../games/xbomb { };

  xconq = callPackage ../games/xconq {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  xjump = callPackage ../games/xjump { };
  # TODO: the corresponding nix file is missing
  # xracer = callPackage ../games/xracer { };

  xmoto = callPackage ../games/xmoto { };

  xonotic = callPackage ../games/xonotic { };

  xpilot-ng = callPackage ../games/xpilot { };
  bloodspilot-server = callPackage ../games/xpilot/bloodspilot-server.nix {};
  bloodspilot-client = callPackage ../games/xpilot/bloodspilot-client.nix {};

  xskat = callPackage ../games/xskat { };

  xsnow = callPackage ../games/xsnow { };

  xsok = callPackage ../games/xsok { };

  xsokoban = callPackage ../games/xsokoban { };

  inherit (callPackage ../games/quake2/yquake2 { })
    yquake2
    yquake2-ctf
    yquake2-ground-zero
    yquake2-the-reckoning
    yquake2-all-games;

  zandronum = callPackage ../games/zandronum { };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zangband = callPackage ../games/zangband { };

  zdbsp = callPackage ../games/zdoom/zdbsp.nix { };

  zdoom = callPackage ../games/zdoom { };

  zod = callPackage ../games/zod { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };

  zeroadPackages = callPackage ../games/0ad {
    wxGTK = wxGTK30;
  };

  zeroad = zeroadPackages.zeroad;

  ### DESKTOP ENVIRONMENTS

  clearlooks-phenix = callPackage ../misc/themes/clearlooks-phenix { };

  deepin = recurseIntoAttrs (import ../desktops/deepin {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment {
    callPackage = newScope pkgs.enlightenment;
  });

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  } // {
    inherit (pkgs)
      # GTK Libs
      glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtkmm2 libcanberra-gtk2

      # Included for backwards compatibility
      libsoup libwnck gtk-doc gnome-doc-utils;

    gtk = self.gtk2;
    gtkmm = self.gtkmm2;
  });

  gnome3 = recurseIntoAttrs (callPackage ../desktops/gnome-3 { });

  gnomeExtensions = recurseIntoAttrs {
    appindicator = callPackage ../desktops/gnome-3/extensions/appindicator { };
    battery-status = callPackage ../desktops/gnome-3/extensions/battery-status { };
    caffeine = callPackage ../desktops/gnome-3/extensions/caffeine { };
    clipboard-indicator = callPackage ../desktops/gnome-3/extensions/clipboard-indicator { };
    dash-to-dock = callPackage ../desktops/gnome-3/extensions/dash-to-dock { };
    dash-to-panel = callPackage ../desktops/gnome-3/extensions/dash-to-panel { };
    icon-hider = callPackage ../desktops/gnome-3/extensions/icon-hider { };
    impatience = callPackage ../desktops/gnome-3/extensions/impatience.nix { };
    mediaplayer = callPackage ../desktops/gnome-3/extensions/mediaplayer { };
    nohotcorner = callPackage ../desktops/gnome-3/extensions/nohotcorner { };
    no-title-bar = callPackage ../desktops/gnome-3/extensions/no-title-bar { };
    remove-dropdown-arrows = callPackage ../desktops/gnome-3/extensions/remove-dropdown-arrows { };
    system-monitor = callPackage ../desktops/gnome-3/extensions/system-monitor { };
    taskwhisperer = callPackage ../desktops/gnome-3/extensions/taskwhisperer { };
    timepp = callPackage ../desktops/gnome-3/extensions/timepp { };
    topicons-plus = callPackage ../desktops/gnome-3/extensions/topicons-plus { };
  };

  hsetroot = callPackage ../tools/X11/hsetroot { };

  kakasi = callPackage ../tools/text/kakasi { };

  lumina = libsForQt5.callPackage ../desktops/lumina { };

  lxqt = recurseIntoAttrs (import ../desktops/lxqt {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  mate = recurseIntoAttrs (callPackage ../desktops/mate { });

  maxx = callPackage ../desktops/maxx { };

  pantheon = recurseIntoAttrs rec {
    callPackage = newScope pkgs.pantheon;
    pantheon-terminal = callPackage ../desktops/pantheon/apps/pantheon-terminal { };
  };

  redshift = callPackage ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg wrapPython;
    inherit (darwin.apple_sdk.frameworks) CoreLocation ApplicationServices Foundation Cocoa;
    geoclue = geoclue2;
  };

  redshift-plasma-applet = libsForQt5.callPackage ../applications/misc/redshift-plasma-applet { };

  latte-dock = libsForQt5.callPackage ../applications/misc/latte-dock { };

  orion = callPackage ../misc/themes/orion {};

  elementary-gtk-theme = callPackage ../misc/themes/elementary { };

  albatross = callPackage ../misc/themes/albatross { };

  gtk_engines = callPackage ../misc/themes/gtk2/gtk-engines { };

  gtk-engine-bluecurve = callPackage ../misc/themes/gtk2/gtk-engine-bluecurve { };

  gtk-engine-murrine = callPackage ../misc/themes/gtk2/gtk-engine-murrine { };

  gnome-themes-extra = gnome3.gnome-themes-extra;

  numix-gtk-theme = callPackage ../misc/themes/numix { };

  numix-solarized-gtk-theme = callPackage ../misc/themes/numix-solarized { };

  numix-sx-gtk-theme = callPackage ../misc/themes/numix-sx { };

  onestepback = callPackage ../misc/themes/onestepback { };

  theme-jade1 = callPackage ../misc/themes/jade1 { };

  theme-obsidian2 = callPackage ../misc/themes/obsidian2 { };

  theme-vertex = callPackage ../misc/themes/vertex { };

  rox-filer = callPackage ../desktops/rox/rox-filer {
    gtk = gtk2;
  };

  xfce = xfce4-12;
  xfceUnstable = xfce4-13;

  xfce4-12 = recurseIntoAttrs (callPackage ../desktops/xfce { });
  xfce4-13 = recurseIntoAttrs (callPackage ../desktops/xfce4-13 { });

  xrandr-invert-colors = callPackage ../applications/misc/xrandr-invert-colors { };

  ### DESKTOP ENVIRONMENTS / PLASMA 5

  plasma5 =
    let
      mkPlasma5 = import ../desktops/plasma-5;
      attrs = {
        inherit libsForQt5 lib fetchurl;
        inherit (gnome3) gsettings-desktop-schemas;
        gconf = gnome2.GConf;
      };
    in
      recurseIntoAttrs (makeOverridable mkPlasma5 attrs);

  inherit (kdeFrameworks) kded kinit frameworkintegration;

  inherit (plasma5)
    bluedevil breeze-gtk breeze-qt5 breeze-grub breeze-plymouth
    kactivitymanagerd kde-cli-tools kde-gtk-config kdeplasma-addons kgamma5
    kinfocenter kmenuedit kscreen kscreenlocker ksshaskpass ksysguard
    kwallet-pam kwayland-integration kwin kwrited milou oxygen plasma-browser-integration
    plasma-desktop plasma-integration plasma-nm plasma-pa plasma-vault plasma-workspace
    plasma-workspace-wallpapers polkit-kde-agent powerdevil sddm-kcm
    systemsettings user-manager xdg-desktop-portal-kde;

  ### SCIENCE

  ### SCIENCE/CHEMISTY

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  gwyddion = callPackage ../applications/science/chemistry/gwyddion {};

  jmol = callPackage ../applications/science/chemistry/jmol { };

  molden = callPackage ../applications/science/chemistry/molden { };

  octopus = callPackage ../applications/science/chemistry/octopus { openblas=openblasCompat; };

  openmolcas = callPackage ../applications/science/chemistry/openmolcas { };

  pymol = callPackage ../applications/science/chemistry/pymol { };

  quantum-espresso = callPackage ../applications/science/chemistry/quantum-espresso { };

  quantum-espresso-mpi = callPackage ../applications/science/chemistry/quantum-espresso {
     mpi = openmpi;
  };

  siesta = callPackage ../applications/science/chemistry/siesta { };

  siesta-mpi = callPackage ../applications/science/chemistry/siesta {
     mpi = openmpi;
  };

  ### SCIENCE/GEOMETRY

  drgeo = callPackage ../applications/science/geometry/drgeo {
    inherit (gnome2) libglade;
    guile = guile_1_8;
  };

  tetgen = callPackage ../applications/science/geometry/tetgen { }; # AGPL3+
  tetgen_1_4 = callPackage ../applications/science/geometry/tetgen/1.4.nix { }; # MIT

  ### SCIENCE/BENCHMARK

  papi = callPackage ../development/libraries/science/benchmark/papi { };

  ### SCIENCE/BIOLOGY

  alliance = callPackage ../applications/science/electronics/alliance { };

  ants = callPackage ../applications/science/biology/ants { };

  archimedes = callPackage ../applications/science/electronics/archimedes {
    stdenv = overrideCC stdenv gcc49;
  };

  bedtools = callPackage ../applications/science/biology/bedtools { };

  bcftools = callPackage ../applications/science/biology/bcftools { };

  conglomerate = callPackage ../applications/science/biology/conglomerate {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  dcm2niix = callPackage ../applications/science/biology/dcm2niix { };

  diamond = callPackage ../applications/science/biology/diamond { };

  ecopcr = callPackage ../applications/science/biology/ecopcr { };

  emboss = callPackage ../applications/science/biology/emboss { };

  ezminc = callPackage ../applications/science/biology/EZminc { };

  hisat2 = callPackage ../applications/science/biology/hisat2 { };

  htslib = callPackage ../development/libraries/science/biology/htslib { };

  igv = callPackage ../applications/science/biology/igv { };

  inormalize = callPackage ../applications/science/biology/inormalize {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  iv = callPackage ../applications/science/biology/iv {
    neuron-version = neuron.version;
  };

  kallisto = callPackage ../applications/science/biology/kallisto { };

  mirtk = callPackage ../development/libraries/science/biology/mirtk { };

  muscle = callPackage ../applications/science/biology/muscle { };

  n3 = callPackage ../applications/science/biology/N3 {
    inherit (perlPackages) perl GetoptTabular MNI-Perllib;
  };

  neuron = callPackage ../applications/science/biology/neuron {
    python = null;
  };

  neuron-mpi = appendToName "mpi" (neuron.override {
    mpi = pkgs.openmpi;
  });

  neuron-full = neuron-mpi.override { inherit python; };

  mrbayes = callPackage ../applications/science/biology/mrbayes { };

  minc_tools = callPackage ../applications/science/biology/minc-tools {
    inherit (perlPackages) TextFormat;
  };

  minc_widgets = callPackage ../applications/science/biology/minc-widgets {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  mni_autoreg = callPackage ../applications/science/biology/mni_autoreg {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  minimap2 = callPackage ../applications/science/biology/minimap2 { };

  mosdepth = callPackage ../applications/science/biology/mosdepth { };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  paml = callPackage ../applications/science/biology/paml { };

  picard-tools = callPackage ../applications/science/biology/picard-tools { };

  platypus = callPackage ../applications/science/biology/platypus { };

  plink = callPackage ../applications/science/biology/plink { };

  plink-ng = callPackage ../applications/science/biology/plink-ng { };

  raxml = callPackage ../applications/science/biology/raxml { };

  raxml-mpi = appendToName "mpi" (raxml.override {
    mpi = true;
  });

  samtools = callPackage ../applications/science/biology/samtools { };
  samtools_0_1_19 = callPackage ../applications/science/biology/samtools/samtools_0_1_19.nix {
    stdenv = gccStdenv;
  };

  snpeff = callPackage ../applications/science/biology/snpeff { };

  somatic-sniper = callPackage ../applications/science/biology/somatic-sniper { };

  star = callPackage ../applications/science/biology/star { };

  strelka = callPackage ../applications/science/biology/strelka { };

  seaview = callPackage ../applications/science/biology/seaview { };

  varscan = callPackage ../applications/science/biology/varscan { };

  hmmer = callPackage ../applications/science/biology/hmmer { };

  bwa = callPackage ../applications/science/biology/bwa { };

  ### SCIENCE/MACHINE LEARNING

  sc2-headless = callPackage ../applications/science/machine-learning/sc2-headless {
    licenseAccepted = (config.sc2-headless.accept_license or false);
  };

  ### SCIENCE/MATH

  almonds = callPackage ../applications/science/math/almonds { };

  arpack = callPackage ../development/libraries/science/math/arpack { };

  atlas = callPackage ../development/libraries/science/math/atlas {
    # The build process measures CPU capabilities and optimizes the
    # library to perform best on that particular machine. That is a
    # great feature, but it's of limited use with pre-built binaries
    # coming from a central build farm.
    tolerateCpuTimingInaccuracy = true;
    liblapack = liblapackWithoutAtlas;
    withLapack = false;
  };

  blas = callPackage ../development/libraries/science/math/blas { };

  brial = callPackage ../development/libraries/science/math/brial { };

  clblas = callPackage ../development/libraries/science/math/clblas {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo OpenCL;
  };

  cliquer = callPackage ../development/libraries/science/math/cliquer { };

  ecos = callPackage ../development/libraries/science/math/ecos { };

  flintqs = callPackage ../development/libraries/science/math/flintqs { };

  gurobi = callPackage ../applications/science/math/gurobi { };

  jags = callPackage ../applications/science/math/jags { };

  libbraiding = callPackage ../development/libraries/science/math/libbraiding { };

  libhomfly = callPackage ../development/libraries/science/math/libhomfly { };

  # We have essentially 4 permutations of liblapack: version 3.4.1 or 3.5.0,
  # and with or without atlas as a dependency. The default `liblapack` is 3.4.1
  # with atlas. Atlas, when built with liblapack as a dependency, uses 3.5.0
  # without atlas. Etc.
  liblapack = callPackage ../development/libraries/science/math/liblapack {};
  liblapackWithoutAtlas = liblapackWithAtlas.override { atlas = null; };
  liblapackWithAtlas = liblapack;

  liblbfgs = callPackage ../development/libraries/science/math/liblbfgs { };

  m4ri = callPackage ../development/libraries/science/math/m4ri { };

  m4rie = callPackage ../development/libraries/science/math/m4rie { };

  nasc = callPackage ../applications/science/math/nasc { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  openlibm = callPackage ../development/libraries/science/math/openlibm {};

  openspecfun = callPackage ../development/libraries/science/math/openspecfun {};

  planarity = callPackage ../development/libraries/science/math/planarity { };

  scalapack = callPackage ../development/libraries/science/math/scalapack {
    mpi = openmpi;
  };

  rankwidth = callPackage ../development/libraries/science/math/rankwidth { };

  fenics = callPackage ../development/libraries/science/math/fenics {
    inherit (python3Packages) numpy ply pytest python six sympy;
    pythonPackages = python3Packages;
    pythonBindings = true;
    docs = true;
  };

  lcalc = callPackage ../development/libraries/science/math/lcalc { };

  lrcalc = callPackage ../applications/science/math/lrcalc { };

  lie = callPackage ../applications/science/math/LiE { };

  magma = callPackage ../development/libraries/science/math/magma { };

  mathematica = callPackage ../applications/science/math/mathematica { };
  mathematica9 = callPackage ../applications/science/math/mathematica/9.nix { };
  mathematica10 = callPackage ../applications/science/math/mathematica/10.nix { };

  metis = callPackage ../development/libraries/science/math/metis {};

  nauty = callPackage ../applications/science/math/nauty {};

  rubiks = callPackage ../development/libraries/science/math/rubiks { };

  petsc = callPackage ../development/libraries/science/math/petsc { };

  parmetis = callPackage ../development/libraries/science/math/parmetis {
    mpi = openmpi;
  };

  scs = callPackage ../development/libraries/science/math/scs {
    liblapack = liblapackWithoutAtlas;
  };

  sage = callPackage ../applications/science/math/sage {
    nixpkgs = pkgs;
  };
  sageWithDoc = sage.override { withDoc = true; };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse {};
  suitesparse = suitesparse_4_4;

  superlu = callPackage ../development/libraries/science/math/superlu {};

  symmetrica = callPackage ../applications/science/math/symmetrica {};

  sympow = callPackage ../development/libraries/science/math/sympow { };

  ipopt = callPackage ../development/libraries/science/math/ipopt { openblas = openblasCompat; };

  gmsh = callPackage ../applications/science/math/gmsh { };

  zn_poly = callPackage ../development/libraries/science/math/zn_poly { };

  ### SCIENCE/MOLECULAR-DYNAMICS

  lammps = callPackage ../applications/science/molecular-dynamics/lammps {
    fftw = fftw;
  };

  lammps-mpi = appendToName "mpi" (lammps.override {
    mpiSupport = true;
    mpi = openmpi;
  });

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    mpiEnabled = false;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  };

  gromacsMpi = lowPrio (gromacs.override {
    singlePrec = true;
    mpiEnabled = true;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  });

  gromacsDouble = lowPrio (gromacs.override {
    singlePrec = false;
    mpiEnabled = false;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  gromacsDoubleMpi = lowPrio (gromacs.override {
    singlePrec = false;
    mpiEnabled = true;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  ### SCIENCE/MEDICINE

  aliza = callPackage ../applications/science/medicine/aliza { };

  ### PHYSICS

  sacrifice = callPackage ../applications/science/physics/sacrifice {};

  sherpa = callPackage ../applications/science/physics/sherpa {};

  ### SCIENCE/PROGRAMMING

  dafny = dotnetPackages.Dafny;

  plm = callPackage ../applications/science/programming/plm { };

  scyther = callPackage ../applications/science/programming/scyther { };

  ### SCIENCE/LOGIC

  abc-verifier = callPackage ../applications/science/logic/abc {};

  abella = callPackage ../applications/science/logic/abella {};

  acgtk = callPackage ../applications/science/logic/acgtk {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  alt-ergo = callPackage ../applications/science/logic/alt-ergo {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  aspino = callPackage ../applications/science/logic/aspino {};

  beluga = callPackage ../applications/science/logic/beluga { };

  boogie = dotnetPackages.Boogie;

  inherit (callPackage ./coq-packages.nix {
    inherit (ocaml-ng) ocamlPackages_3_12_1
                       ocamlPackages_4_02
                       ocamlPackages_4_05
    ;
  }) mkCoqPackages
    coq_8_3 coq_8_4 coq_8_5 coq_8_6 coq_8_7 coq_8_8
    coqPackages_8_5 coqPackages_8_6 coqPackages_8_7 coqPackages_8_8
    coqPackages coq
  ;

  coq2html = callPackage ../applications/science/logic/coq2html {
    make = pkgs.gnumake3;
  };

  cryptoverif = callPackage ../applications/science/logic/cryptoverif { };

  caprice32 = callPackage ../misc/emulators/caprice32 { };

  cubicle = callPackage ../applications/science/logic/cubicle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (a: { dontDisableStatic = true; });
  };
  cvc4 = callPackage ../applications/science/logic/cvc4 {};

  drat-trim = callPackage ../applications/science/logic/drat-trim {};

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
  };

  eprover = callPackage ../applications/science/logic/eprover { };

  gappa = callPackage ../applications/science/logic/gappa { };

  gfan = callPackage ../applications/science/math/gfan {};

  giac = callPackage ../applications/science/math/giac { };
  giac-with-xcas = giac.override { enableGUI = true; };

  ginac = callPackage ../applications/science/math/ginac { };

  glucose = callPackage ../applications/science/logic/glucose { };
  glucose-syrup = callPackage ../applications/science/logic/glucose/syrup.nix { };

  hol = callPackage ../applications/science/logic/hol { };

  inherit (ocamlPackages) hol_light;

  hologram = callPackage ../tools/security/hologram { };

  tini = callPackage ../applications/virtualization/tini {};

  ifstat-legacy = callPackage ../tools/networking/ifstat-legacy { };

  isabelle = callPackage ../applications/science/logic/isabelle {
    polyml = polyml56;
    java = if stdenv.isLinux then jre else jdk;
  };

  iprover = callPackage ../applications/science/logic/iprover {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
  };

  jonprl = callPackage ../applications/science/logic/jonprl {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  lean = callPackage ../applications/science/logic/lean {};
  lean2 = callPackage ../applications/science/logic/lean2 {};
  lean3 = lean;
  elan = callPackage ../applications/science/logic/elan {};

  leo2 = callPackage ../applications/science/logic/leo2 {
     ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;};

  logisim = callPackage ../applications/science/logic/logisim {};

  ltl2ba = callPackage ../applications/science/logic/ltl2ba {};

  inherit (ocaml-ng.ocamlPackages_3_11_2) matita;

  matita_130312 = lowPrio ocamlPackages.matita_130312;

  metis-prover = callPackage ../applications/science/logic/metis-prover { };

  mcrl2 = callPackage ../applications/science/logic/mcrl2 { };

  minisat = callPackage ../applications/science/logic/minisat {};
  minisatUnstable = callPackage ../applications/science/logic/minisat/unstable.nix {};

  monosat = callPackage ../applications/science/logic/monosat {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  ott = callPackage ../applications/science/logic/ott { };

  otter = callPackage ../applications/science/logic/otter {};

  picosat = callPackage ../applications/science/logic/picosat {};

  libpoly = callPackage ../applications/science/logic/poly {};

  prooftree = (with ocaml-ng.ocamlPackages_4_01_0;
    callPackage  ../applications/science/logic/prooftree {
      camlp5 = camlp5_transitional;
    });

  prover9 = callPackage ../applications/science/logic/prover9 { };

  proverif = callPackage ../applications/science/logic/proverif { };

  sapic = callPackage ../applications/science/logic/sapic {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  satallax = callPackage ../applications/science/logic/satallax {
    ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;
  };

  saw-tools = callPackage ../applications/science/logic/saw-tools {};

  spass = callPackage ../applications/science/logic/spass {
    stdenv = gccStdenv;
  };

  statverif = callPackage ../applications/science/logic/statverif {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  tptp = callPackage ../applications/science/logic/tptp {};

  celf = callPackage ../applications/science/logic/celf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  twelf = callPackage ../applications/science/logic/twelf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  verifast = callPackage ../applications/science/logic/verifast {};

  veriT = callPackage ../applications/science/logic/verit {};

  why3 = callPackage ../applications/science/logic/why3 {};

  workcraft = callPackage ../applications/science/logic/workcraft {};

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };

  z3 = callPackage ../applications/science/logic/z3 { python = python2; };

  tlaplus = callPackage ../applications/science/logic/tlaplus {};
  tlaps = callPackage ../applications/science/logic/tlaplus/tlaps.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };
  tlaplusToolbox = callPackage ../applications/science/logic/tlaplus/toolbox.nix {gtk = gtk2;};

  aiger = callPackage ../applications/science/logic/aiger {};

  avy = callPackage ../applications/science/logic/avy {};

  btor2tools = callPackage ../applications/science/logic/btor2tools {};

  boolector = callPackage ../applications/science/logic/boolector {};

  symbiyosys = callPackage ../applications/science/logic/symbiyosys {};

  lingeling = callPackage ../applications/science/logic/lingeling {};

  ### SCIENCE / ELECTRONICS

  adms = callPackage ../applications/science/electronics/adms { };

  # Since version 8 Eagle requires an Autodesk account and a subscription
  # in contrast to single payment for the charged editions.
  # This is the last version with the old model.
  eagle7 = callPackage ../applications/science/electronics/eagle/eagle7.nix { };

  eagle = libsForQt5.callPackage ../applications/science/electronics/eagle/eagle.nix { };

  caneda = libsForQt5.callPackage ../applications/science/electronics/caneda { };

  geda = callPackage ../applications/science/electronics/geda {
    guile = guile_2_0;
  };

  gerbv = callPackage ../applications/science/electronics/gerbv { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave { };

  kicad = callPackage ../applications/science/electronics/kicad {
    wxGTK = wxGTK30;
    boost = boost160;
  };

  kicad-unstable = python.pkgs.callPackage ../applications/science/electronics/kicad/unstable.nix {
    wxGTK = wxGTK30;
    boost = boost160;
  };

  librepcb = libsForQt5.callPackage ../applications/science/electronics/librepcb { };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  pcb = callPackage ../applications/science/electronics/pcb { };

  qucs = callPackage ../applications/science/electronics/qucs { };

  xcircuit = callPackage ../applications/science/electronics/xcircuit { };

  xoscope = callPackage ../applications/science/electronics/xoscope { };


  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe rec {
    cudaSupport = config.caffe.cudaSupport or config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  caffe2 = callPackage ../development/libraries/science/math/caffe2 {
    eigen3 = eigen3_3;
    inherit (python3Packages) python future six numpy pydot;
    protobuf = protobuf3_1;
    python-protobuf = python3Packages.protobuf3_1;
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
  };

  cntk = callPackage ../applications/science/math/cntk rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (linuxPackages) nvidia_x11;
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
  };

  ecm = callPackage ../applications/science/math/ecm { };

  eukleides = callPackage ../applications/science/math/eukleides {
    texLive = texlive.combine { inherit (texlive) scheme-small; };
    texinfo = texinfo4;
  };

  form = callPackage ../applications/science/math/form { };

  fricas = callPackage ../applications/science/math/fricas { };

  gap = callPackage ../applications/science/math/gap { };

  gap-minimal = lowPrio (gap.override { keepAllPackages = false; });

  geogebra = callPackage ../applications/science/math/geogebra { };

  maxima = callPackage ../applications/science/math/maxima {
    ecl = null;
  };
  maxima-ecl = maxima.override {
    ecl = ecl_16_1_2;
    ecl-fasl = true;
    sbcl = null;
  };

  mxnet = callPackage ../applications/science/math/mxnet rec {
    cudaSupport = config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (linuxPackages) nvidia_x11;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { wxGTK = wxGTK30; };

  pari = callPackage ../applications/science/math/pari { tex = texlive.combined.scheme-basic; };
  gp2c = callPackage ../applications/science/math/pari/gp2c.nix { };

  palp = callPackage ../applications/science/math/palp { };

  ratpoints = callPackage ../applications/science/math/ratpoints {};

  calc = callPackage ../applications/science/math/calc { };

  pcalc = callPackage ../applications/science/math/pcalc { };

  bcal = callPackage ../applications/science/math/bcal { };

  pspp = callPackage ../applications/science/math/pspp {
    inherit (gnome3) gtksourceview;
  };

  pynac = callPackage ../applications/science/math/pynac { };

  singular = callPackage ../applications/science/math/singular { };

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  scilab-bin = callPackage ../applications/science/math/scilab-bin {};

  scotch = callPackage ../applications/science/math/scotch {
    flex = flex_2_5_35;
  };

  msieve = callPackage ../applications/science/math/msieve { };

  weka = callPackage ../applications/science/math/weka { };

  yad = callPackage ../tools/misc/yad { };

  yacas = callPackage ../applications/science/math/yacas { };

  speedcrunch = libsForQt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (pkgs.gnome2) gtkglext;
  };

  cytoscape = callPackage ../applications/science/misc/cytoscape { };

  fityk = callPackage ../applications/science/misc/fityk { };

  gildas = callPackage ../applications/science/astronomy/gildas { };

  gplates = callPackage ../applications/science/misc/gplates {
    boost = boost160;
    cgal = cgal.override { boost = boost160; };
  };

  gravit = callPackage ../applications/science/astronomy/gravit { };

  golly = callPackage ../applications/science/misc/golly { wxGTK = wxGTK30; };
  golly-beta = callPackage ../applications/science/misc/golly/beta.nix { wxGTK = wxGTK30; };

  megam = callPackage ../applications/science/misc/megam { };

  ns-3 = callPackage ../development/libraries/science/networking/ns3 { };

  root = callPackage ../applications/science/misc/root {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  simgrid = callPackage ../applications/science/misc/simgrid { };

  spyder = callPackage ../applications/science/spyder { };

  openspace = callPackage ../applications/science/astronomy/openspace { };

  stellarium = libsForQt5.callPackage ../applications/science/astronomy/stellarium { };

  astrolabe-generator = callPackage ../applications/science/astronomy/astrolabe-generator { };

  tulip = callPackage ../applications/science/misc/tulip {
    cmake = cmake_2_8;
  };

  vite = callPackage ../applications/science/misc/vite { };

  xearth = callPackage ../applications/science/astronomy/xearth { };
  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  ### SCIENCE / PHYSICS

  fastjet = callPackage ../development/libraries/physics/fastjet { };

  fastnlo = callPackage ../development/libraries/physics/fastnlo { };

  geant4 = libsForQt5.callPackage ../development/libraries/physics/geant4 { };

  cernlib = callPackage ../development/libraries/physics/cernlib { };

  g4py = callPackage ../development/libraries/physics/geant4/g4py { };

  hepmc = callPackage ../development/libraries/physics/hepmc { };

  herwig = callPackage ../development/libraries/physics/herwig { };

  lhapdf = callPackage ../development/libraries/physics/lhapdf { };

  mcgrid = callPackage ../development/libraries/physics/mcgrid { };

  nlojet = callPackage ../development/libraries/physics/nlojet { };

  pythia = callPackage ../development/libraries/physics/pythia { };

  rivet = callPackage ../development/libraries/physics/rivet {
    imagemagick = graphicsmagick-imagemagick-compat;
  };

  thepeg = callPackage ../development/libraries/physics/thepeg { };

  yoda = callPackage ../development/libraries/physics/yoda { };
  yoda-with-root = lowPrio (yoda.override {
    withRootSupport = true;
  });

  ### SCIENCE/ROBOTICS

  apmplanner2 = libsForQt5.callPackage ../applications/science/robotics/apmplanner2 { };

  ### MISC

  android-file-transfer = libsForQt5.callPackage ../tools/filesystems/android-file-transfer { };

  antimicro = libsForQt5.callPackage ../tools/misc/antimicro { };

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  auctex = callPackage ../tools/typesetting/tex/auctex { };

  areca = callPackage ../applications/backup/areca { };

  attract-mode = callPackage ../misc/emulators/attract-mode { };

  beep = callPackage ../misc/beep { };

  blackbird = callPackage ../misc/themes/blackbird { };

  bootil = callPackage ../development/libraries/bootil { };

  brgenml1lpr = pkgsi686Linux.callPackage ../misc/cups/drivers/brgenml1lpr {};

  brgenml1cupswrapper = callPackage ../misc/cups/drivers/brgenml1cupswrapper {};

  brightnessctl = callPackage ../misc/brightnessctl { };

  calaos_installer = libsForQt5.callPackage ../misc/calaos/installer {};

  ccemux = callPackage ../misc/emulators/ccemux { };

  click = callPackage ../applications/networking/cluster/click { };

  cups = callPackage ../misc/cups {
    libusb = libusb1;
  };

  cups-filters = callPackage ../misc/cups/filters.nix { };

  cups-pk-helper = callPackage ../misc/cups/cups-pk-helper.nix { };

  cups-kyocera = callPackage ../misc/cups/drivers/kyocera {};

  cups-kyodialog3 = callPackage ../misc/cups/drivers/kyodialog3 {};

  cups-dymo = callPackage ../misc/cups/drivers/dymo {};

  cups-toshiba-estudio = callPackage ../misc/cups/drivers/estudio {};

  cups-zj-58 =  callPackage ../misc/cups/drivers/zj-58 { };

  crashplan = callPackage ../applications/backup/crashplan { };
  crashplansb = callPackage ../applications/backup/crashplan/crashplan-small-business.nix { gconf = gnome2.GConf; };

  colort = callPackage ../applications/misc/colort { };

  terminal-parrot = callPackage ../applications/misc/terminal-parrot { };

  e17gtk = callPackage ../misc/themes/e17gtk { };

  epson-alc1100 = callPackage ../misc/drivers/epson-alc1100 { };

  epson-escpr = callPackage ../misc/drivers/epson-escpr { };

  epson_201207w = callPackage ../misc/drivers/epson_201207w { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cups-bjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  cups-brother-hl1110 = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1110 { };

  # this driver ships with pre-compiled 32-bit binary libraries
  cnijfilter_2_80 = pkgsi686Linux.callPackage ../misc/cups/drivers/cnijfilter_2_80 { };

  cnijfilter_4_00 = callPackage ../misc/cups/drivers/cnijfilter_4_00 {
    libusb = libusb1;
  };

  cnijfilter2 = callPackage ../misc/cups/drivers/cnijfilter2 {
    libusb = libusb1;
  };

  darcnes = callPackage ../misc/emulators/darcnes { };

  darling-dmg = callPackage ../tools/filesystems/darling-dmg { };

  desmume = callPackage ../misc/emulators/desmume { inherit (pkgs.gnome2) gtkglext libglade; };

  dbacl = callPackage ../tools/misc/dbacl { };

  dblatex = callPackage ../tools/typesetting/tex/dblatex {
    enableAllFeatures = false;
  };

  dblatexFull = appendToName "full" (dblatex.override {
    enableAllFeatures = true;
  });

  dbus-map = callPackage ../tools/misc/dbus-map { };

  dell-530cdn = callPackage ../misc/drivers/dell-530cdn {};

  dosbox = callPackage ../misc/emulators/dosbox { };
  dosbox-unstable = callPackage ../misc/emulators/dosbox/unstable.nix { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  ekiga = newScope pkgs.gnome2 ../applications/networking/instant-messengers/ekiga { };

  emulationstation = callPackage ../misc/emulators/emulationstation {
    stdenv = overrideCC stdenv gcc5;
  };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  flam3 = callPackage ../tools/graphics/flam3 { };

  glee = callPackage ../tools/graphics/glee { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  faust = self.faust2;

  faust1 = callPackage ../applications/audio/faust/faust1.nix { };

  faust2 = callPackage ../applications/audio/faust/faust2.nix {
    llvm = llvm_5;
  };

  faust2alqt = callPackage ../applications/audio/faust/faust2alqt.nix { };

  faust2alsa = callPackage ../applications/audio/faust/faust2alsa.nix { };

  faust2csound = callPackage ../applications/audio/faust/faust2csound.nix { };

  faust2firefox = callPackage ../applications/audio/faust/faust2firefox.nix { };

  faust2jack = callPackage ../applications/audio/faust/faust2jack.nix { };

  faust2jaqt = callPackage ../applications/audio/faust/faust2jaqt.nix { };

  faust2ladspa = callPackage ../applications/audio/faust/faust2ladspa.nix { };

  faust2lv2 = callPackage ../applications/audio/faust/faust2lv2.nix { };

  faustlive = callPackage ../applications/audio/faust/faustlive.nix { };

  fceux = callPackage ../misc/emulators/fceux { };

  flockit = callPackage ../tools/backup/flockit { };

  foldingathome = callPackage ../misc/foldingathome { };

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic-filters = callPackage ../misc/drivers/foomatic-filters {};

  gajim = python3.pkgs.callPackage ../applications/networking/instant-messengers/gajim {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-libav gst-plugins-ugly;
    inherit (gnome3) gspell;
  };

  gammu = callPackage ../applications/misc/gammu { };

  gensgs = pkgsi686Linux.callPackage ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript rec {
    cupsSupport = config.ghostscript.cups or (!stdenv.isDarwin);
    x11Support = cupsSupport; # with CUPS, X11 only adds very little
  };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  });

  glava = callPackage ../applications/misc/glava {};

  gnome-breeze = callPackage ../misc/themes/gnome-breeze { };

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  };
  gnuk-unstable = lowPrio (callPackage ../misc/gnuk/unstable.nix {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  });
  gnuk-git = lowPrio (callPackage ../misc/gnuk/git.nix {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  });

  greybird = callPackage ../misc/themes/greybird { };

  guetzli = callPackage ../applications/graphics/guetzli { };

  gummi = callPackage ../applications/misc/gummi { };

  gxemul = callPackage ../misc/emulators/gxemul { };

  hatari = callPackage ../misc/emulators/hatari { };

  helm = callPackage ../applications/audio/helm { };

  helmfile = callPackage ../applications/networking/cluster/helmfile { };

  heptio-ark = callPackage ../applications/networking/cluster/heptio-ark { };

  hplip = callPackage ../misc/drivers/hplip { };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hplip_3_16_11 = callPackage ../misc/drivers/hplip/3.16.11.nix { };

  hplipWithPlugin_3_16_11 = hplip_3_16_11.override { withPlugin = true; };

  hyperfine = callPackage ../tools/misc/hyperfine { };

  epkowa = callPackage ../misc/drivers/epkowa { };

  idsk = callPackage ../tools/filesystems/idsk { };

  igraph = callPackage ../development/libraries/igraph { };

  illum = callPackage ../tools/system/illum { };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2 = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
    inherit (darwin.apple_sdk.frameworks) AudioToolbox CoreAudio CoreFoundation;
  };
  libjack2 = jack2.override { prefix = "lib"; };
  jack2Full = jack2; # TODO: move to aliases.nix

  keynav = callPackage ../tools/X11/keynav { };

  kompose = callPackage ../applications/networking/cluster/kompose { };

  kontemplate = callPackage ../applications/networking/cluster/kontemplate { };

  kops = callPackage ../applications/networking/cluster/kops { };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };
  lilypond-unstable = callPackage ../misc/lilypond/unstable.nix { };
  lilypond-with-fonts = callPackage ../misc/lilypond/with-fonts.nix {
    lilypond = lilypond-unstable;
  };

  lollypop-portal = callPackage ../misc/lollypop-portal { };

  openlilylib-fonts = callPackage ../misc/lilypond/fonts.nix { };

  mailcore2 = callPackage ../development/libraries/mailcore2 {
    icu = icu58;
  };

  martyr = callPackage ../development/libraries/martyr { };

  matcha = callPackage ../misc/themes/matcha { };

  # previously known as flat-plat
  materia-theme = callPackage ../misc/themes/materia-theme { };

  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome2) GConf;
  };

  moltengamepad = callPackage ../misc/drivers/moltengamepad { };

  openzwave = callPackage ../development/libraries/openzwave { };

  mongoc = callPackage ../development/libraries/mongoc { };

  mupen64plus = callPackage ../misc/emulators/mupen64plus { };

  muse = callPackage ../applications/audio/muse { };

  mynewt-newt = callPackage ../tools/package-management/mynewt-newt { };

  inherit (callPackages ../tools/package-management/nix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
      curl = curl_7_59;
      boehmgc = boehmgc.override { enableLargeConfig = true; };
      })
    nix
    nix1
    nixStable
    nixUnstable;

  nixops = callPackage ../tools/package-management/nixops { };

  nixopsUnstable = lowPrio (callPackage ../tools/package-management/nixops/unstable.nix { });

  nixops-dns = callPackage ../tools/package-management/nixops/nixops-dns.nix { };

  /*
   * Evaluate a NixOS configuration using this evaluation of Nixpkgs.
   *
   * With this function you can write, for example, a package that
   * depends on a custom virtual machine image.
   *
   * Parameter: A module, path or list of those that represent the
   *            configuration of the NixOS system to be constructed.
   *
   * Result:    An attribute set containing packages produced by this
   *            evaluation of NixOS, such as toplevel, kernel and
   *            initialRamdisk.
   *            The result can be extended in the modules by defining
   *            extra options in system.build.
   *
   * Unlike in plain NixOS, the nixpkgs.config, nixpkgs.overlays and
   * nixpkgs.system options will be ignored by default. Instead,
   * nixpkgs.pkgs will have the default value of pkgs as it was
   * constructed right after invoking the nixpkgs function (e.g. the
   * value of import <nixpkgs> { overlays = [./my-overlay.nix]; }
   * but not the value of (import <nixpkgs> {} // { extra = ...; }).
   *
   * If you do want to use the config.nixpkgs options, you are
   * probably better off by calling nixos/lib/eval-config.nix
   * directly, even though it is possible to set config.nixpkgs.pkgs.
   *
   * For more information about writing NixOS modules, see
   * https://nixos.org/nixos/manual/index.html#sec-writing-modules
   *
   * Note that you will need to have called Nixpkgs with the system
   * parameter set to the right value for your deployment target.
   */
  nixos = configuration:
    (import (self.path + "/nixos/lib/eval-config.nix") {
      inherit (pkgs.stdenv.hostPlatform) system;
      modules = [(
                  { lib, ... }: {
                    config.nixpkgs.pkgs = lib.mkDefault pkgs;
                  }
                )] ++ (
                  if builtins.isList configuration
                  then configuration
                  else [configuration]
                );
    }).config.system.build;

  nixui = callPackage ../tools/package-management/nixui { node_webkit = nwjs_0_12; };

  nix-bundle = callPackage ../tools/package-management/nix-bundle { };

  nix-delegate = haskell.lib.justStaticExecutables haskellPackages.nix-delegate;
  nix-deploy = haskell.lib.justStaticExecutables haskellPackages.nix-deploy;
  nix-diff = haskell.lib.justStaticExecutables haskellPackages.nix-diff;

  nix-du = callPackage ../tools/package-management/nix-du { };

  nix-info = callPackage ../tools/nix/info { };
  nix-info-tested = nix-info.override { doCheck = true; };

  nix-index = callPackage ../tools/package-management/nix-index { };

  nix-pin = callPackage ../tools/package-management/nix-pin { };

  nix-prefetch-github = callPackage ../build-support/nix-prefetch-github {};

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts;

  nix-update-source = callPackage ../tools/package-management/nix-update-source {};

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (pythonPackages) python toposort; };

  nix-top = callPackage ../tools/package-management/nix-top { };

  nix-repl = throw (
    "nix-repl has been removed because it's not maintained anymore, " +
    (lib.optionalString (! lib.versionAtLeast "2" (lib.versions.major builtins.nixVersion))
      "ugrade your Nix installation to a newer version and ") +
    "use `nix repl` instead. " +
    "Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );

  nix-review = callPackage ../tools/package-management/nix-review { };

  nix-serve = callPackage ../tools/package-management/nix-serve { };

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };
  nixos-icons = callPackage ../data/misc/nixos-artwork/icons.nix { };
  nixos-grub2-theme = callPackage ../data/misc/nixos-artwork/grub2-theme.nix { };

  nixos-container = callPackage ../tools/virtualization/nixos-container { };

  norwester-font = callPackage ../data/fonts/norwester  {};

  nut = callPackage ../applications/misc/nut { };

  solfege = callPackage ../misc/solfege { };

  disnix = callPackage ../tools/package-management/disnix { };

  dysnomia = callPackage ../tools/package-management/disnix/dysnomia {
    enableApacheWebApplication = config.disnix.enableApacheWebApplication or false;
    enableAxis2WebService = config.disnix.enableAxis2WebService or false;
    enableEjabberdDump = config.disnix.enableEjabberdDump or false;
    enableMySQLDatabase = config.disnix.enableMySQLDatabase or false;
    enablePostgreSQLDatabase = config.disnix.enablePostgreSQLDatabase or false;
    enableSubversionRepository = config.disnix.enableSubversionRepository or false;
    enableTomcatWebApplication = config.disnix.enableTomcatWebApplication or false;
  };

  disnixos = callPackage ../tools/package-management/disnix/disnixos { };

  DisnixWebService = callPackage ../tools/package-management/disnix/DisnixWebService { };

  lkproof = callPackage ../tools/typesetting/tex/lkproof { };

  lice = callPackage ../tools/misc/lice {};

  m33-linux = callPackage ../misc/drivers/m33-linux { };

  mnemonicode = callPackage ../misc/mnemonicode { };

  mysql-workbench = callPackage ../applications/misc/mysql-workbench (let mysql = mysql57; in {
    gdal = gdal.override {mysql = mysql // {lib = {dev = mysql;};};};
    mysql = mysql;
    pcre = pcre-cpp;
  });

  redis-desktop-manager = libsForQt5.callPackage ../applications/misc/redis-desktop-manager { };

  robo3t = callPackage ../applications/misc/robo3t { };

  rucksack = callPackage ../development/tools/rucksack { };

  sam-ba = callPackage ../tools/misc/sam-ba { };

  opkg = callPackage ../tools/package-management/opkg { };

  opkg-utils = callPackage ../tools/package-management/opkg-utils { };

  pgmanage = callPackage ../applications/misc/pgmanage { };

  pgadmin = callPackage ../applications/misc/pgadmin { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../tools/typesetting/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../tools/typesetting/tex/pgf/2.x.nix { };

  pgf3 = callPackage ../tools/typesetting/tex/pgf/3.x.nix { };

  pgfplots = callPackage ../tools/typesetting/tex/pgfplots { };

  phabricator = callPackage ../misc/phabricator { };

  physlock = callPackage ../misc/screensavers/physlock { };

  pjsip = callPackage ../applications/networking/pjsip { };

  plano-theme = callPackage ../misc/themes/plano { };

  ppsspp = libsForQt5.callPackage ../misc/emulators/ppsspp { };

  pt = callPackage ../applications/misc/pt { };

  protocol = python3Packages.callPackage ../applications/networking/protocol { };

  pykms = callPackage ../tools/networking/pykms { };

  pyload = callPackage ../applications/networking/pyload {};

  uae = callPackage ../misc/emulators/uae { };

  fsuae = callPackage ../misc/emulators/fs-uae { };

  putty = callPackage ../applications/networking/remote/putty { };

  redprl = callPackage ../applications/science/logic/redprl { };

  retroarchBare = callPackage ../misc/emulators/retroarch {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
  };

  retroarch = wrapRetroArch { retroarch = retroarchBare; };

  libretro = recurseIntoAttrs (callPackage ../misc/emulators/retroarch/cores.nix {
    retroarch = retroarchBare;
  });

  retrofe = callPackage ../misc/emulators/retrofe { };

  rpl = callPackage ../tools/text/rpl {
    pythonPackages = python3Packages;
  };

  ricty = callPackage ../data/fonts/ricty { };

  rss-glx = callPackage ../misc/screensavers/rss-glx { };

  run-scaled = callPackage ../tools/X11/run-scaled { };

  runit = callPackage ../tools/system/runit { };

  refind = callPackage ../tools/bootloaders/refind { };

  spectrojack = callPackage ../applications/audio/spectrojack { };

  sift = callPackage ../tools/text/sift { };

  xlockmore = callPackage ../misc/screensavers/xlockmore { };

  xtrlock-pam = callPackage ../misc/screensavers/xtrlock-pam { };

  sailsd = callPackage ../misc/sailsd { };

  shc = callPackage ../tools/security/shc { };

  canon-cups-ufr2 = callPackage ../misc/cups/drivers/canon { };

  hll2390dw-cups = callPackage ../misc/cups/drivers/hll2390dw-cups { };

  mfcj470dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj470dwcupswrapper { };
  mfcj470dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj6510dwcupswrapper { };
  mfcj6510dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj6510dwlpr { };

  mfcl2700dncupswrapper = callPackage ../misc/cups/drivers/mfcl2700dncupswrapper { };
  mfcl2700dnlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcl2700dnlpr { };

  mfcl2720dwcupswrapper = callPackage ../misc/cups/drivers/mfcl2720dwcupswrapper { };
  mfcl2720dwlpr = callPackage ../misc/cups/drivers/mfcl2720dwlpr { };

  mfcl2740dwcupswrapper = callPackage ../misc/cups/drivers/mfcl2740dwcupswrapper { };
  mfcl2740dwlpr = callPackage ../misc/cups/drivers/mfcl2740dwlpr { };

  mfcl8690cdwcupswrapper = callPackage ../misc/cups/drivers/mfcl8690cdwcupswrapper { };
  mfcl8690cdwlpr = callPackage ../misc/cups/drivers/mfcl8690cdwlpr { };

  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung { };
  samsung-unified-linux-driver_4_01_17 = callPackage ../misc/cups/drivers/samsung/4.01.17.nix { };
  samsung-unified-linux-driver = callPackage ../misc/cups/drivers/samsung/4.00.39 { };

  sane-backends = callPackage ../applications/graphics/sane/backends {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  sane-backends-git = callPackage ../applications/graphics/sane/backends/git.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  brlaser = callPackage ../misc/cups/drivers/brlaser { };

  brscan4 = callPackage ../applications/graphics/sane/backends/brscan4 { };

  mkSaneConfig = callPackage ../applications/graphics/sane/config.nix { };

  sane-frontends = callPackage ../applications/graphics/sane/frontends.nix { };

  satysfi = callPackage ../tools/typesetting/satysfi { };

  sc-controller = pythonPackages.callPackage ../misc/drivers/sc-controller {
    inherit libusb1; # Shadow python.pkgs.libusb1.
  };

  sct = callPackage ../tools/X11/sct {};

  seafile-shared = callPackage ../misc/seafile-shared { };

  serviio = callPackage ../servers/serviio {};
  selinux-python = callPackage ../os-specific/linux/selinux-python {
    # needs python3 bindings
    libselinux = libselinux.override { python = python3; };
    libsemanage = libsemanage.override { python = python3; };
  };

  sierra-gtk-theme = callPackage ../misc/themes/sierra { };

  slock = callPackage ../misc/screensavers/slock {
    conf = config.slock.conf or null;
  };

  smokeping = callPackage ../tools/networking/smokeping {
    inherit fping rrdtool;
    inherit (perlPackages)
      FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty perl NetDNS perlldap;
  };

  snapraid = callPackage ../tools/filesystems/snapraid { };

  soundOfSorting = callPackage ../misc/sound-of-sorting { };

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  steamcontroller = callPackage ../misc/drivers/steamcontroller { };

  streamripper = callPackage ../applications/audio/streamripper { };

  sqsh = callPackage ../development/tools/sqsh { };

  inherit (callPackage ../applications/networking/cluster/terraform {})
    terraform_0_8_5
    terraform_0_8
    terraform_0_9
    terraform_0_10
    terraform_0_10-full
    terraform_0_11
    terraform_0_11-full
    ;

  terraform = terraform_0_11;
  terraform-full = terraform_0_11-full;

  terraform-provider-ibm = callPackage ../applications/networking/cluster/terraform-provider-ibm {};

  terraform-inventory = callPackage ../applications/networking/cluster/terraform-inventory {};

  terraform-provider-nixos = callPackage ../applications/networking/cluster/terraform-provider-nixos {};

  terraform-landscape = callPackage ../applications/networking/cluster/terraform-landscape {};

  terraform-provider-libvirt = callPackage ../applications/networking/cluster/terraform-provider-libvirt {};

  terragrunt = callPackage ../applications/networking/cluster/terragrunt {};

  terragrunt_0_11_1 = callPackage ../applications/networking/cluster/terragrunt/0.11.1.nix {
    terraform = terraform_0_8;
  };

  terragrunt_0_9_8 = callPackage ../applications/networking/cluster/terragrunt/0.9.8.nix {
    terraform = terraform_0_8_5;
  };

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tewi-font = callPackage ../data/fonts/tewi  {};

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see http://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = recurseIntoAttrs
    (callPackage ../tools/typesetting/tex/texlive { });

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  thermald = callPackage ../tools/system/thermald { };

  thinkfan = callPackage ../tools/system/thinkfan { };

  tup = callPackage ../development/tools/build-managers/tup { };

  trufflehog = callPackage ../tools/security/trufflehog { };

  tvbrowser-bin = callPackage ../applications/misc/tvbrowser/bin.nix { };

  tvheadend = callPackage ../servers/tvheadend { };

  ums = callPackage ../servers/ums { };

  unity3d = callPackage ../development/tools/unity3d {
    stdenv = stdenv_32bit;
    gcc_32bit = pkgsi686Linux.gcc;
    inherit (gnome2) GConf libgnomeui gnome_vfs;
  };

  urbit = callPackage ../misc/urbit { };

  utf8proc = callPackage ../development/libraries/utf8proc { };

  unicode-paracode = callPackage ../tools/misc/unicode { };

  unixcw = callPackage ../applications/misc/unixcw { };

  valauncher = callPackage ../applications/misc/valauncher { };

  vault = callPackage ../tools/security/vault { };

  vaultenv = haskellPackages.vaultenv;

  vbam = callPackage ../misc/emulators/vbam {
    ffmpeg = ffmpeg_2;
  };

  vice = callPackage ../misc/emulators/vice {
    giflib = giflib_4_1;
  };

  viewnior = callPackage ../applications/graphics/viewnior { };

  vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../misc/vim-plugins {
    llvmPackages = llvmPackages_39;
  });

  vimprobable2-unwrapped = callPackage ../applications/networking/browsers/vimprobable2 {
    webkit = webkitgtk24x-gtk2;
  };
  vimprobable2 = wrapFirefox vimprobable2-unwrapped { };

  vimb-unwrapped = callPackage ../applications/networking/browsers/vimb { };
  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };
  nip2 = callPackage ../tools/graphics/nip2 { };

  virglrenderer = callPackage ../development/libraries/virglrenderer { };

  vokoscreen = libsForQt5.callPackage ../applications/video/vokoscreen { };

  wavegain = callPackage ../applications/audio/wavegain { };

  wcalc = callPackage ../applications/misc/wcalc { };

  webfs = callPackage ../servers/http/webfs { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  winePackagesFor = wineBuild: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit wineBuild;

    inherit (callPackage ./wine-packages.nix {})
      minimal base full stable unstable staging;
  });

  winePackages = recurseIntoAttrs (winePackagesFor (config.wine.build or "wine32"));
  wineWowPackages = recurseIntoAttrs (winePackagesFor "wineWow");

  wine = winePackages.full;

  wine-staging = lowPrio (winePackages.full.override {
    wineRelease = "staging";
  });

  winetricks = callPackage ../misc/emulators/wine/winetricks.nix {
    inherit (gnome3) zenity;
  };

  with-shell = callPackage ../applications/misc/with-shell { };

  wmutils-core = callPackage ../tools/X11/wmutils-core { };

  wmutils-opt = callPackage ../tools/X11/wmutils-opt { };

  wordpress = callPackage ../servers/web-apps/wordpress { };

  wraith = callPackage ../applications/networking/irc/wraith { };

  wxmupen64plus = callPackage ../misc/emulators/wxmupen64plus { };

  wxsqlite3 = callPackage ../development/libraries/wxsqlite3 {
    wxGTK = wxGTK30;
  };

  wxsqliteplus = callPackage ../development/libraries/wxsqliteplus {
    wxGTK = wxGTK30;
  };

  x11idle = callPackage ../tools/misc/x11idle {};

  x2x = callPackage ../tools/X11/x2x { };

  xboxdrv = callPackage ../misc/drivers/xboxdrv { };

  xbps = callPackage ../tools/package-management/xbps { };

  xcftools = callPackage ../tools/graphics/xcftools { };

  xhyve = callPackage ../applications/virtualization/xhyve {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin) libobjc;
  };

  xinput_calibrator = callPackage ../tools/X11/xinput_calibrator { };

  xlog = callPackage ../applications/misc/xlog { };

  xmagnify = callPackage ../tools/X11/xmagnify { };

  xosd = callPackage ../misc/xosd { };

  xosview2 = callPackage ../tools/X11/xosview2 { };

  xpad = callPackage ../applications/misc/xpad {
    inherit (gnome3) gtksourceview;
  };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
    sane-backends = sane-backends.override { libpng = libpng12; };
  };

  xsw = callPackage ../applications/misc/xsw {
   # Enable the next line to use this in terminal.
   # Note that it requires sixel capable terminals such as mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  xwiimote = callPackage ../misc/drivers/xwiimote {
    bluez = pkgs.bluez5.override {
      enableWiimote = true;
    };
  };

  xzoom = callPackage ../tools/X11/xzoom {};

  yabause = libsForQt5.callPackage ../misc/emulators/yabause {
    freeglut = null;
    openal = null;
  };

  yadm = callPackage ../applications/version-management/yadm { };

  yamdi = callPackage ../tools/video/yamdi { };

  yandex-disk = callPackage ../tools/filesystems/yandex-disk { };

  yara = callPackage ../tools/security/yara { };

  yaxg = callPackage ../tools/graphics/yaxg {};

  zap = callPackage ../tools/networking/zap { };

  zdfmediathk = callPackage ../applications/video/zdfmediathk { };

  zopfli = callPackage ../tools/compression/zopfli { };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zsnes = pkgsi686Linux.callPackage ../misc/emulators/zsnes { };

  xcpc = callPackage ../misc/emulators/xcpc { };

  zxcvbn-c = callPackage ../development/libraries/zxcvbn-c { };

  snes9x-gtk = callPackage ../misc/emulators/snes9x-gtk { };

  openmsx = callPackage ../misc/emulators/openmsx {
    python = python27;
  };

  higan = callPackage ../misc/emulators/higan {
    inherit (gnome2) gtksourceview;
  };

  bullet = callPackage ../development/libraries/bullet {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  inherit (callPackages ../development/libraries/spdlog { })
    spdlog_0 spdlog_1;

  spdlog = spdlog_1;

  dart = callPackage ../development/interpreters/dart { };
  dart_stable = dart.override { version = "1.24.3"; };
  dart_old = dart.override { version = "1.16.1"; };
  dart_dev = dart.override { version = "2.0.0-dev.26.0"; };

  httrack = callPackage ../tools/backup/httrack { };

  httraqt = libsForQt5.callPackage ../tools/backup/httrack/qt.nix { };

  mg = callPackage ../applications/editors/mg { };

  mpvc = callPackage ../applications/misc/mpvc { };

  aucdtect = callPackage ../tools/audio/aucdtect { };

  togglesg-download = callPackage ../tools/misc/togglesg-download { };

  discord = callPackage ../applications/networking/instant-messengers/discord { };

  golden-cheetah = libsForQt56.callPackage ../applications/misc/golden-cheetah {};

  linkchecker = callPackage ../tools/networking/linkchecker { };

  tomb = callPackage ../os-specific/linux/tomb {};

  tomboy = callPackage ../applications/misc/tomboy {
    mono = mono46;
  };

  imatix_gsl = callPackage ../development/tools/imatix_gsl {};

  iterm2 = callPackage ../applications/misc/iterm2 {};

  sequeler = callPackage ../applications/misc/sequeler {
    inherit (gnome3) gtksourceview libgda libgee;
  };

  sequelpro = callPackage ../applications/misc/sequelpro {};

  maphosts = callPackage ../tools/networking/maphosts {};

  zimg = callPackage ../development/libraries/zimg { };

  zk-shell = callPackage ../applications/misc/zk-shell { };

  zuki-themes = callPackage ../misc/themes/zuki { };

  tora = libsForQt5.callPackage ../development/tools/tora {};

  xulrunner = firefox-unwrapped;

  xrq = callPackage ../applications/misc/xrq { };

  nitrokey-app = libsForQt5.callPackage ../tools/security/nitrokey-app { };
  nitrokey-udev-rules = callPackage ../tools/security/nitrokey-app/udev-rules.nix { };

  fpm2 = callPackage ../tools/security/fpm2 { };

  tw-rs = callPackage ../misc/tw-rs { };

  simplenote = callPackage ../applications/misc/simplenote { };

  hy = callPackage ../development/interpreters/hy {};

  check-uptime = callPackage ../servers/monitoring/plugins/uptime.nix { };

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { inherit (darwin) cctools; };

  chrome-gnome-shell = callPackage  ../desktops/gnome-3/extensions/chrome-gnome-shell {};

  NSPlist = callPackage ../development/libraries/NSPlist {};

  PlistCpp = callPackage ../development/libraries/PlistCpp {};

  xib2nib = callPackage ../development/tools/xib2nib {};

  linode-cli = callPackage ../tools/virtualization/linode-cli { };

  hss = callPackage ../tools/networking/hss {};

  undaemonize = callPackage ../tools/system/undaemonize {};

  houdini = callPackage ../applications/misc/houdini {};

  xtermcontrol = callPackage ../applications/misc/xtermcontrol {};

  openfst = callPackage ../development/libraries/openfst {};

  duti = callPackage ../os-specific/darwin/duti {};

  dnstracer = callPackage ../tools/networking/dnstracer {
    inherit (darwin) libresolv;
  };

  wal-g = callPackage ../tools/backup/wal-g {};

  tlwg = callPackage ../data/fonts/tlwg { };

  simplehttp2server = callPackage ../servers/simplehttp2server { };

  diceware = callPackage ../tools/security/diceware { };

  xml2rfc = callPackage ../tools/typesetting/xml2rfc { };

  mmark = callPackage ../tools/typesetting/mmark { };

  wire-desktop = callPackage ../applications/networking/instant-messengers/wire-desktop { };

  teseq = callPackage ../applications/misc/teseq {  };

  ape = callPackage ../applications/misc/ape { };
  attemptoClex = callPackage ../applications/misc/ape/clex.nix { };
  apeClex = callPackage ../applications/misc/ape/apeclex.nix { };

  # Unix tools
  unixtools = recurseIntoAttrs (callPackages ./unix-tools.nix { });
  inherit (unixtools) hexdump ps logger eject umount
                      mount wall hostname more sysctl getconf
                      getent locale killall xxd watch;

  fts = if stdenv.hostPlatform.isMusl then netbsd.fts else null;

  inherit (recurseIntoAttrs (callPackages ../os-specific/bsd { }))
          netbsd;

  yrd = callPackage ../tools/networking/yrd { };

  powershell = callPackage ../shells/powershell { };

  doing = callPackage ../applications/misc/doing  { };

  undervolt = callPackage ../os-specific/linux/undervolt { };

  alibuild = callPackage ../development/tools/build-managers/alibuild {
    python = python27;
  };
}
