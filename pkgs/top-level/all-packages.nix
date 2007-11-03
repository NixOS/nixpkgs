/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */
   

{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? __currentSystem

  # Usually, the system type uniquely determines the stdenv and thus
  # how to build the packages.  But on some platforms we have
  # different stdenvs, leading to different ways to build the
  # packages.  For instance, on Windows we support both Cygwin and
  # Mingw builds.  In both cases, `system' is `i686-cygwin'.  The
  # attribute `stdenvType' is used to select the specific kind of
  # stdenv to use, e.g., `i686-mingw'.
, stdenvType ? system

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

  # More flags for the bootstrapping of stdenv.
, noSysDirs ? true
, gccWithCC ? true
, gccWithProfiling ? true

}:


rec {


  ### Symbolic names.


  x11 = xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X libraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.


  # Override the compiler in stdenv for specific packages.
  overrideGCC = stdenv: gcc: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // { NIX_GCC = gcc; });
    };

  # Add some arbitrary packages to buildInputs for specific packages.
  # Used to override packages in stenv like Make.  Should not be used
  # for other dependencies.
  overrideInStdenv = stdenv: pkgs: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args //
        { buildInputs = (if args ? buildInputs then args.buildInputs else []) ++ pkgs; }
      );
    };

  addAttrsToDerivation = extraAttrs: stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // extraAttrs); };

  # Override the setup script of stdenv.  Useful for testing new
  # versions of the setup script without causing a rebuild of
  # everything.
  #
  # Example:
  #   randomPkg = import ../bla { ...
  #     stdenv = overrideSetup stdenv ../stdenv/generic/setup-latest.sh;
  #   };
  overrideSetup = stdenv: setup: stdenv.regenerate setup;

  # Return a modified stdenv that uses dietlibc to create small
  # statically linked binaries.
  useDietLibC = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        # libcompat.a contains some commonly used functions.
        NIX_LDFLAGS = "-lcompat";
        
        # These are added *after* the command-line flags, so we'll
        # always optimise for size.
        NIX_CFLAGS_COMPILE =
          (if args ? NIX_CFLAGS_COMPILE then args.NIX_CFLAGS_COMPILE else "")
          + " -Os -s -D_BSD_SOURCE=1";
        
        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...

        NIX_GCC = import ../build-support/gcc-wrapper {
          inherit stdenv;
          libc = dietlibc;
          inherit (gcc) gcc binutils name nativeTools nativePrefix;
          nativeLibc = false;
        };
      });
      isDietLibC = true;
    };

  # Return a modified stdenv that tries to build statically linked
  # binaries.
  makeStaticBinaries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...
      });
    };

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // {recurseForDerivations = true;};

  useFromStdenv = hasIt: it: alternative: if hasIt then it else alternative;

  lib = library;

  library = import ../lib;
  lib_unstable = import ../lib/default-unstable.nix;

  # Return an attribute from the Nixpkgs configuration file, or
  # a default value if the attribute doesn't exist.
  getConfig = attrPath: default: library.getAttr attrPath default config;

  # Return user-choosen version of given package. If you define package as
  #
  # pkgname_alts =
  # {
  #   v_0_1 = ();
  #   v_0_2 = ();
  #   default = v_0_1;
  #   recurseForDerivations = true;
  # };
  # pkgname = getVersion "name" pkgname_alts;
  #
  # user will be able to write in his configuration.nix something like
  # environment = { versions = { name = v_0_2; }; }; and pkgname will be equal
  # to pkgname_alts.v_0_2. Using alts.default by default.
  getVersion = name: alts: builtins.getAttr
    (getConfig [ "environment" "versions" name ] "default") alts;

  # Whether user enabled given feature for the given package?
  getFlag = flag: package: default:
  getConfig [ "environment" "flags" package flag ]
  (getConfig [ "environment" "flags" "default" flag ] default);

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  config =
    let {
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      body =
        if configFile != "" && pathExists configFile
        then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2
        then import (toPath configFile2)
        else {};
    };

  # Change the symbolic name of a package for presentation purposes
  # (i.e., so that nix-env users can tell them apart).
  setName = name: drv: drv // {inherit name;};

  updateName = updater: drv: drv // {name = updater (drv.name);};

  # !!! the suffix should really be appended *before* the version, at
  # least most of the time.
  appendToName = suffix: updateName (name: "${name}-${suffix}");

  # Decrease the priority of the package, i.e., other
  # versions/variants will be preferred.
  lowPrio = drv: drv // {
    meta = (if drv ? meta then drv.meta else {}) // {priority = "10";};
  };

  # commented out because it's using the new configuration style proposal which is unstable
  /*  
  mkDerivationByConfiguration = ({ flagConfig ? {}, optionals ? [], defaults ? [],  
        extraAttrs, collectExtraPhaseActions ? []} :
    args: with args.lib_unstable; with args;
    if ( __isAttrs extraAttrs ) then builtins.throw "the argument extraAttrs needs to be a function beeing passed co, but attribute set passed "
    else
    let co = chooseOptionsByFlags { inherit args flagConfig optionals defaults collectExtraPhaseActions; }; in
      args.stdenv.mkDerivation ( 
      {
        inherit (co) configureFlags buildInputs;
      } // extraAttrs co  // co.pass // co.flags_prefixed ));
  */
  

  # Check absence of non-used options
	checker = x: flag: opts: config: 
		(if flag then let result=( 
			(import ../build-support/checker) 
			opts config); in
			(if (result==null) then x else
			abort (toString result))
		else x);

	builderDefs = lib.sumArgs (import ./builder-defs.nix) {
		inherit stringsWithDeps lib stdenv writeScript;
	};

	stringsWithDeps = import ../lib/strings-with-deps.nix {
		inherit stdenv lib;
	};

  ### STANDARD ENVIRONMENT


  defaultStdenv =
    (import ../stdenv {
      inherit system stdenvType;
      allPackages = import ./all-packages.nix;
    }).stdenv;

  stdenv =
    if bootStdenv != null then bootStdenv else
      let changer = getConfig ["replaceStdenv"] null;
      in if changer != null then
        changer {
          stdenv = defaultStdenv;
          overrideSetup = overrideSetup;
        }
      else defaultStdenv;


  ### BUILD SUPPORT


  buildEnv = import ../build-support/buildenv {
    inherit stdenv perl;
  };
  
  fetchcvs = import ../build-support/fetchcvs {
    inherit stdenv cvs nix;
  };

  fetchdarcs = import ../build-support/fetchdarcs {
    inherit stdenv darcs nix;
  };

  fetchsvn = import ../build-support/fetchsvn {
    inherit stdenv subversion nix openssh;
    sshSupport = true;
  };

  # TODO do some testing
  fetchhg = import ../build-support/fetchhg {
    inherit stdenv mercurial nix;
  };

  # Allow the stdenv to determine fetchurl, to cater for strange
  # requirements.
  fetchurl = useFromStdenv (stdenv ? fetchurl) stdenv.fetchurl
    (import ../build-support/fetchurl {
      inherit stdenv curl;
    });

  makeWrapper = ../build-support/make-wrapper/make-wrapper.sh;

  # Run the shell command `buildCommand' to produce a store object
  # named `name'.  The attributes in `env' are added to the
  # environment prior to running the command.
  runCommand = name: env: buildCommand: stdenv.mkDerivation ({
    inherit name buildCommand;
  } // env);

  # Write a plain text file to the Nix store.  (The advantage over
  # plain sources is that `text' can refer to the output paths of
  # derivations, e.g., "... ${somePkg}/bin/foo ...".
  writeText = name: text: runCommand name {inherit text;} "echo -n \"$text\" > $out";

  writeScript = name: text: runCommand name {inherit text;} "echo -n \"$text\" > $out; chmod +x $out";
  
  stdenvNewSetupScript = overrideSetup stdenv ../stdenv/generic/setup-new.sh;

  substituteAll = import ../build-support/substitute/substitute-all.nix {
    stdenv = stdenvNewSetupScript;
  };

  nukeReferences = import ../build-support/nuke-references/default.nix {
    inherit stdenv;
  };

  ### TOOLS


  aefs = import ../tools/security/aefs {
    inherit fetchurl stdenv fuse;
  };

  amule = import ../tools/networking/p2p/amule {
    inherit fetchurl stdenv zlib wxGTK;
  };

  axel = import ../tools/networking/axel {
    inherit fetchurl stdenv;
  };

  azureus = import ../tools/networking/p2p/azureus {
    inherit fetchurl stdenv jdk swt;
  };

  bc = import ../tools/misc/bc {
    inherit fetchurl stdenv flex;
  };

  bibtextools = import ../tools/typesetting/bibtex-tools {
    inherit fetchurl stdenv aterm tetex hevea sdf strategoxt;
  };

  bittorrent = import ../tools/networking/p2p/bittorrent {
    inherit fetchurl stdenv makeWrapper python pycrypto twisted;
    wxPython = wxPython26;
    gui = true;
  };

  bittornado = import ../tools/networking/p2p/bit-tornado {
    inherit fetchurl stdenv python wxPython26;
  };

  bsdiff = import ../tools/compression/bsdiff {
    inherit fetchurl stdenv;
  };

  bzip2 = useFromStdenv (stdenv ? bzip2) stdenv.bzip2
    (import ../tools/compression/bzip2 {
      inherit fetchurl stdenv;
    });

  cabextract = import ../tools/archivers/cabextract {
    inherit fetchurl stdenv;
  };

  cksfv = import ../tools/networking/cksfv {
    inherit fetchurl stdenv;
  };

  coreutils = useFromStdenv (stdenv ? coreutils) stdenv.coreutils
    ((if stdenv ? isDietLibC
      then import ../tools/misc/coreutils-5
      else import ../tools/misc/coreutils)
    {
      inherit fetchurl stdenv;
    });

  cpio = import ../tools/archivers/cpio {
    inherit fetchurl stdenv;
  };

  cron = import ../tools/system/cron {
    inherit fetchurl stdenv;
  };

  curl = if stdenv ? curl then stdenv.curl else (assert false; null);

  curlftpfs = import ../tools/networking/curlftpfs {
    inherit fetchurl stdenv fuse curl pkgconfig zlib;
    inherit (gtkLibs) glib;
  };

  dnsmasq = import ../tools/networking/dnsmasq {
    # TODO i18n can be installed as well, implement it? 
    inherit fetchurl stdenv;
  };

  dhcp = import ../tools/networking/dhcp {
    inherit fetchurl stdenv groff nettools coreutils iputils gnused bash;
  };

  diffutils = useFromStdenv (stdenv ? diffutils) stdenv.diffutils
    (import ../tools/text/diffutils {
      inherit fetchurl stdenv coreutils;
    });

  ed = import ../tools/text/ed {
    inherit fetchurl stdenv;
  };

  enscript = import ../tools/text/enscript {
    inherit fetchurl stdenv;
  };

  eprover = import ../tools/misc/eProver {
    inherit fetchurl stdenv which tetex;
  };

  exif = import ../tools/graphics/exif {
    inherit fetchurl stdenv pkgconfig libexif popt;
  };

  file = import ../tools/misc/file {
    inherit fetchurl stdenv;
  };

  filelight = import ../tools/system/filelight {
    inherit fetchurl stdenv kdelibs x11 zlib 
	perl libpng;
    qt = qt3;
  };

  findutils = useFromStdenv (stdenv ? findutils) stdenv.findutils
    (if system == "i686-darwin" then findutils4227 else
      import ../tools/misc/findutils {
        inherit fetchurl stdenv coreutils;
      }
    );

  findutils4227 = import ../tools/misc/findutils/4.2.27.nix {
    inherit fetchurl stdenv coreutils;
  };

  findutilsWrapper = lowPrio (appendToName "wrapper" (import ../tools/misc/findutils-wrapper {
    inherit stdenv findutils;
  }));

  fontforge = import ../tools/misc/fontforge {
    inherit fetchurl stdenv gettext freetype zlib
      libungif libpng libjpeg libtiff libxml2;
  };

  gawk = useFromStdenv (stdenv ? gawk) stdenv.gawk
    (import ../tools/text/gawk {
      inherit fetchurl stdenv;
    });

  getopt = import ../tools/misc/getopt {
    inherit fetchurl stdenv;
  };

  glxinfo = assert mesaSupported; import ../tools/graphics/glxinfo {
    inherit fetchurl stdenv x11 mesa;
    inherit (xlibs) libXext;
  };

  gnugrep = useFromStdenv (stdenv ? gnugrep) stdenv.gnugrep
    (import ../tools/text/gnugrep {
      inherit fetchurl stdenv pcre;
    });

  gnupatch = useFromStdenv (stdenv ? patch) stdenv.patch (import ../tools/text/gnupatch {
    inherit fetchurl stdenv;
  });

  gnupg = import ../tools/security/gnupg {
    inherit fetchurl stdenv readline;
    ideaSupport = true; # enable for IDEA crypto support
  };

  gnuplot = import ../tools/graphics/gnuplot {
    inherit fetchurl stdenv zlib gd texinfo;
  };

  gnuplotX = import ../tools/graphics/gnuplot {
    inherit fetchurl stdenv zlib gd texinfo;
    inherit (xlibs) libX11 libXt libXaw libXpm;
    x11Support = true;
  };

  gnused = useFromStdenv (stdenv ? gnused) stdenv.gnused
    (import ../tools/text/gnused {
      inherit fetchurl stdenv;
    });

  gnused412 = import ../tools/text/gnused/4.1.2.nix {
    inherit fetchurl stdenv;
  };

  gnutar = useFromStdenv (stdenv ? gnutar) stdenv.gnutar
    (import ../tools/archivers/gnutar {
      inherit fetchurl stdenv;
    });

  gnutar151 = import ../tools/archivers/gnutar/1.15.1.nix {
    inherit fetchurl stdenv;
  };

  graphviz = import ../tools/graphics/graphviz {
    inherit fetchurl stdenv libpng libjpeg expat x11 yacc libtool;
    inherit (xlibs) libXaw;
  };

  groff = import ../tools/text/groff {
    inherit fetchurl stdenv;
  };

  grub =
    if system == "x86_64-linux" then
      (import ./all-packages.nix {system = "i686-linux";}).grub
    else 
      import ../tools/misc/grub {
        inherit fetchurl stdenv;
      };

  gtkgnutella = import ../tools/networking/p2p/gtk-gnutella {
    inherit fetchurl stdenv pkgconfig libxml2;
    inherit (gtkLibs) glib gtk;
  };

  gzip = useFromStdenv (stdenv ? gzip) stdenv.gzip
    (import ../tools/compression/gzip {
      inherit fetchurl stdenv;
    });

  hevea = import ../tools/typesetting/hevea {
    inherit fetchurl stdenv ocaml;
  };

  jdiskreport = import ../tools/misc/jdiskreport {
    inherit fetchurl stdenv unzip jdk;
  };

  jing = import ../tools/text/xml/jing {
    inherit fetchurl stdenv unzip;
  };

  jing_tools = import ../tools/text/xml/jing/jing-script.nix {
    inherit fetchurl stdenv unzip jre;
  };

  jwhois = import ../tools/networking/jwhois {
    inherit fetchurl stdenv;
  };

  ktorrent = import ../tools/networking/p2p/ktorrent {
    inherit fetchurl stdenv pkgconfig kdelibs
      xlibs zlib libpng libjpeg perl gmp;
  };

  less = import ../tools/misc/less {
    inherit fetchurl stdenv ncurses;
  };

  lftp = import ../tools/networking/lftp {
    inherit fetchurl stdenv readline;
  };

  lhs2tex = import ../tools/typesetting/lhs2tex {
    inherit fetchurl stdenv ghc tetex polytable;
  };

  man = import ../tools/misc/man {
     inherit fetchurl stdenv db4 groff;
  };

  mjpegtools = import ../tools/video/mjpegtools {
    inherit fetchurl stdenv libjpeg;
    inherit (xlibs) libX11;
  };

  mktemp = import ../tools/security/mktemp {
    inherit fetchurl stdenv;
  };

  ncat = import ../tools/networking/ncat {
    inherit fetchurl stdenv openssl;
  };

  netcat = import ../tools/networking/netcat {
    inherit fetchurl stdenv;
  };

  netselect = import ../tools/networking/netselect {
    inherit fetchurl stdenv;
  };

  nmap = import ../tools/security/nmap {
    inherit fetchurl stdenv libpcap pkgconfig;
	inherit (xlibs) libX11;
	inherit (gtkLibs) gtk;
  };

  ntp = import ../tools/networking/ntp {
    inherit fetchurl stdenv libcap;
  };

  openssh = import ../tools/networking/openssh {
    inherit fetchurl stdenv zlib openssl pam perl;
    pamSupport = true;
  };

  p7zip = import ../tools/archivers/p7zip {
    inherit fetchurl stdenv;
  };

  par2cmdline = import ../tools/networking/par2cmdline {
    inherit fetchurl;
    stdenv = overrideGCC stdenv gcc34;
  };

  parted = import ../tools/misc/parted {
    inherit fetchurl stdenv e2fsprogs readline;
  };

  patch = gnupatch;

  pciutils = import ../tools/system/pciutils {
    inherit fetchurl stdenv zlib;
  };

  pdfjam = import ../tools/typesetting/pdfjam {
    inherit fetchurl stdenv;
  };

  ploticus = import ../tools/graphics/ploticus {
    inherit fetchurl stdenv zlib libpng;
    inherit (xlibs) libX11;
  };

  pwgen = import ../tools/security/pwgen {
    inherit stdenv fetchurl;
  };

  qtparted = import ../tools/misc/qtparted {
    inherit fetchurl stdenv e2fsprogs ncurses readline parted zlib qt3;
    inherit (xlibs) libX11 libXext;
  };

  realCurl = import ../tools/networking/curl {
    inherit fetchurl stdenv zlib;
    zlibSupport = !stdenv ? isDietLibC;
  };

  replace = import ../tools/text/replace {
    inherit fetchurl stdenv;
  };

  /*
  rdiff_backup = import ../tools/backup/rdiff-backup {
    inherit fetchurl stdenv librsync gnused;
    python=python;
  };
  */

  rpm = import ../tools/package-management/rpm {
    inherit fetchurl stdenv cpio zlib bzip2 file sqlite beecrypt neon elfutils;
  };

  sablotron = import ../tools/text/xml/sablotron {
    inherit fetchurl stdenv expat;
  };

  screen = import ../tools/misc/screen {
    inherit fetchurl stdenv ncurses;
  };

  smartmontools = import ../tools/system/smartmontools {
    inherit fetchurl stdenv;
  };

  sudo = import ../tools/security/sudo {
    inherit fetchurl stdenv coreutils pam;
  };

  superkaramba = import ../desktops/superkaramba {
    inherit stdenv fetchurl kdebase kdelibs zlib libjpeg
      perl qt3 python libpng freetype expat;
    inherit (xlibs) libX11 libXext libXt libXaw libXpm;
  };

  sshfsFuse = import ../tools/networking/sshfs-fuse {
    inherit fetchurl stdenv pkgconfig fuse;
    inherit (gtkLibs) glib;
  };

  ssmtp = import ../tools/networking/ssmtp {
    inherit fetchurl stdenv;
  };

  su = import ../tools/misc/su {
    inherit fetchurl stdenv pam;
  };

  tcpdump = import ../tools/networking/tcpdump {
    inherit fetchurl stdenv libpcap;
  };

  telnet = import ../tools/networking/telnet {
    inherit fetchurl stdenv ncurses;
  };

  testdisk = import ../tools/misc/testdisk {
    inherit fetchurl stdenv ncurses libjpeg e2fsprogs zlib openssl;
  };

  tightvnc = import ../tools/admin/tightvnc {
    inherit fetchurl stdenv x11 zlib libjpeg perl;
    inherit (xlibs) imake gccmakedep libXmu libXaw libXpm libXp;
  };

  time = import ../tools/misc/time {
    inherit fetchurl stdenv;
  };

  trang = import ../tools/text/xml/trang {
    inherit fetchurl stdenv unzip jre;
  };

  transfig = import ../tools/graphics/transfig {
    inherit fetchurl stdenv libpng libjpeg zlib;
    inherit (xlibs) imake;
  };

  units = import ../tools/misc/units {
    inherit fetchurl stdenv;
  };

  unrar = import ../tools/archivers/unrar {
    inherit fetchurl stdenv;
  };

  unshield = import ../tools/archivers/unshield {
    inherit fetchurl stdenv zlib;
  };

  unzip = import ../tools/archivers/unzip {
    inherit fetchurl stdenv;
  };

  wget = import ../tools/networking/wget {
    inherit fetchurl stdenv gettext;
  };

  which = import ../tools/system/which {
    inherit fetchurl stdenv;
  };

  wv = import ../tools/misc/wv {
    inherit fetchurl stdenv libpng zlib imagemagick
	pkgconfig libgsf libxml2;
    inherit (gtkLibs) glib;
  };

  x11_ssh_askpass = import ../tools/networking/x11-ssh-askpass {
    inherit fetchurl stdenv x11;
    inherit (xorg) imake;
  };

  xclip = import ../tools/misc/xclip {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXmu;
  };

  xmlroff = import ../tools/typesetting/xmlroff {
    inherit fetchurl stdenv pkgconfig libxml2 libxslt popt;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
    inherit pangoxsl;
  };

  xmltv = import ../tools/misc/xmltv {
    inherit fetchurl perl perlTermReadKey perlXMLTwig perlXMLWriter
      perlDateManip perlHTMLTree perlHTMLParser perlHTMLTagset
      perlURI perlLWP;
  };

  xpf = import ../tools/text/xml/xpf {
    inherit fetchurl stdenv python;

    libxml2 = import ../development/libraries/libxml2 {
      inherit fetchurl stdenv zlib python;
      pythonSupport = true;
    };
  };

  xsel = import ../tools/misc/xsel {
    inherit fetchurl stdenv x11;
  };

  zdelta = import ../tools/compression/zdelta {
    inherit fetchurl stdenv;
  };

  zip = import ../tools/archivers/zip {
    inherit fetchurl stdenv;
  };


  ### SHELLS


  bash = lowPrio (useFromStdenv (stdenv ? bash) stdenv.bash
    (import ../shells/bash {
      inherit fetchurl stdenv;
      bison = bison23;
    }));

  bashInteractive = appendToName "interactive" (import ../shells/bash {
    inherit fetchurl stdenv ncurses;
    bison = bison23;
    interactive = true;
  });

  tcsh = import ../shells/tcsh {
    inherit fetchurl stdenv ncurses;
  };

  zsh = import ../shells/zsh {
    inherit fetchurl stdenv ncurses coreutils;
  };


  ### DEVELOPMENT / COMPILERS


  abc =
    abcPatchable [];

  abcPatchable = patches : 
    import ../development/compilers/abc/default.nix {
      inherit stdenv fetchurl patches jre apacheAnt;
      javaCup = import ../development/libraries/java/cup {
        inherit stdenv fetchurl jdk;
      };
    };

  aspectj =
    import ../development/compilers/aspectj {
      inherit stdenv fetchurl jre;
    };

  dylan = import ../development/compilers/gwydion-dylan {
    inherit fetchurl stdenv perl boehmgc yacc flex readline;
    dylan =
      import ../development/compilers/gwydion-dylan/binary.nix {
        inherit fetchurl stdenv;
      };
  };

  fpc = import ../development/compilers/fpc {
    inherit fetchurl stdenv gawk;
  };

  g77 = import ../build-support/gcc-wrapper {
    name = "g77";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-3.3 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  g77_40 = import ../build-support/gcc-wrapper {
    name = "g77-4.0";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.0 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
	inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };
 
  g77_41 = import ../build-support/gcc-wrapper {
    name = "g77-4.1";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.1 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
      langC = false;
	inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };
 
  gcc = gcc41;

  gcc295 = wrapGCC (import ../development/compilers/gcc-2.95 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc33 = wrapGCC (import ../development/compilers/gcc-3.3 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc34 = wrapGCC (import ../development/compilers/gcc-3.4 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc40 = wrapGCC (import ../development/compilers/gcc-4.0 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  });

  gcc41 = useFromStdenv (stdenv ? gcc) stdenv.gcc (wrapGCC (import ../development/compilers/gcc-4.1 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = false;
  }));

  gcc41NPTL = wrapGCCWithGlibc gcc41.gcc glibcNPTL;

  gcc42 = lowPrio (wrapGCC (import ../development/compilers/gcc-4.2 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  }));

  gccApple = wrapGCC (import ../development/compilers/gcc-apple {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  });

  # ghc66boot = import ../development/compilers/ghc-6.6-boot {
  #  inherit fetchurl stdenv perl readline;
  #  m4 = gnum4;
  #};

  ghc = ghc661;

  ghc68 = lowPrio (appendToName "snapshot" (import ../development/compilers/ghc-6.8 {
    inherit fetchurl stdenv readline perl gmp ncurses;
    m4 = gnum4;
    ghc = ghcboot;
  }));

  ghc661 = import ../development/compilers/ghc-6.6.1 {
    inherit fetchurl stdenv readline perl gmp ncurses;
    m4 = gnum4;
    ghc = ghcboot;
  };

  ghc66 = import ../development/compilers/ghc-6.6 {
    inherit fetchurl stdenv readline perl gmp ncurses;
    m4 = gnum4;
    ghc = ghcboot;
  };

  ghc64 = import ../development/compilers/ghc {
    inherit fetchurl stdenv perl ncurses readline m4 gmp;
    gcc = stdenv.gcc;
    ghc = ghcboot;
  };

  ghcboot = lowPrio (appendToName "boot" (import ../development/compilers/ghc/boot.nix {
    inherit fetchurl stdenv perl ncurses gmp;
    readline = if stdenv.system == "i686-linux" then readline4 else readline;
  }));

  /*
  ghcWrapper = assert uulib.ghc == ghc;
    import ../development/compilers/ghc-wrapper {
      inherit stdenv ghc;
      libraries = [];
    };
  */

  helium = import ../development/compilers/helium {
    inherit fetchurl stdenv ghc;
  };

  #TODO add packages http://cvs.haskell.org/Hugs/downloads/2006-09/packages/ and test
  # commented out because it's using the new configuration style proposal which is unstable
  #hugs = import ../development/compilers/hugs {
    #inherit lib fetchurl stdenv;
  #};

  j2sdk14x =
    assert system == "i686-linux";
    import ../development/compilers/jdk/default-1.4.nix {
      inherit fetchurl stdenv;
    };

  jdk       = jdkdistro true  false;
  jre       = jdkdistro false false;

  jdkPlugin = jdkdistro true true;
  jrePlugin = jdkdistro false true;

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux" ||
    system == "powerpc-linux";

  jdkdistro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "plugin" else x: x) (import ../development/compilers/jdk {
      inherit fetchurl stdenv unzip installjdk xlibs pluginSupport;
      libstdcpp5 = gcc33.gcc;
    });

  jikes = import ../development/compilers/jikes {
    inherit fetchurl stdenv;
  };

  mono = import ../development/compilers/mono {
    inherit fetchurl stdenv bison pkgconfig;
    inherit (gtkLibs) glib;
  };

  monoDLLFixer = import ../build-support/mono-dll-fixer {
    inherit stdenv perl;
  };

  nasm = import ../development/compilers/nasm {
    inherit fetchurl stdenv;
  };

  ocaml = import ../development/compilers/ocaml {
    inherit fetchurl stdenv x11 ncurses;
  };

  ocaml3080 = import ../development/compilers/ocaml/ocaml-3.08.0.nix {
    inherit fetchurl x11;
    stdenv = overrideGCC stdenv gcc34;
  };

/*
  gcj = import ../build-support/gcc-wrapper/default2.nix {
    name = "gcj";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.0 {
      inherit fetchurl stdenv noSysDirs;
      langJava = true;
      langCC   = false;
      langC    = false;
      langF77  = false;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };
*/

  opencxx = import ../development/compilers/opencxx {
    inherit fetchurl stdenv libtool;
    gcc = gcc33;
  };

  qcmm = import ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = ocaml3080;
    inherit fetchurl stdenv mk noweb groff;
  };

  strategoLibraries = import ../development/compilers/strategoxt/libraries/stratego-libraries-0.17pre.nix {
    inherit stdenv fetchurl pkgconfig aterm;
  };

  strategoxt = import ../development/compilers/strategoxt {
    inherit fetchurl pkgconfig sdf aterm;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoxtUtils = import ../development/compilers/strategoxt/utils {
    inherit fetchurl pkgconfig stdenv aterm sdf strategoxt;
  };

  transformers = import ../development/compilers/transformers {
    inherit fetchurl pkgconfig sdf;
    aterm = aterm23x;

    stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;
    
    strategoxt = import ../development/compilers/strategoxt/strategoxt-0.14.nix {
      inherit fetchurl pkgconfig sdf;
      aterm = aterm23x;
      stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;
    };

    stlport =  import ../development/libraries/stlport {
      inherit fetchurl stdenv;
    };
  };

  visualcpp = import ../development/compilers/visual-c++ {
    inherit fetchurl stdenv cabextract;
  };

  win32hello = import ../development/compilers/visual-c++/test {
    inherit fetchurl stdenv visualcpp windowssdk;
  };

  wrapGCC = baseGCC: wrapGCCWithGlibc baseGCC glibc;

  wrapGCCWithGlibc = baseGCC: glibc: import ../build-support/gcc-wrapper {
    nativeTools = stdenv ? gcc && stdenv.gcc.nativeTools;
    nativeLibc = stdenv ? gcc && stdenv.gcc.nativeLibc;
    gcc = baseGCC;
    libc = glibc;
    inherit stdenv binutils;
  };


  ### DEVELOPMENT / INTERPRETERS


  clisp = import ../development/interpreters/clisp {
    inherit fetchurl stdenv libsigsegv gettext 
	readline ncurses coreutils pcre zlib;
    inherit (xlibs) libX11 libXau libXt;
  };

  guile = import ../development/interpreters/guile {
    inherit fetchurl stdenv ncurses readline libtool gmp;
  };

  kaffe =  import ../development/interpreters/kaffe {
    inherit fetchurl stdenv jikes alsaLib xlibs;
  };

  lua4 = import ../development/interpreters/lua-4 {
    inherit fetchurl stdenv;
  };

  lua5 = import ../development/interpreters/lua-5 {
    inherit fetchurl stdenv ncurses readline;
  };

  octave = import ../development/interpreters/octave {
    inherit stdenv fetchurl readline ncurses perl flex;
	g77 = g77_41;
  };

  perl = if !stdenv.isLinux then sysPerl else realPerl;

  # FIXME: unixODBC needs patching on Darwin (see darwinports)
  php = import ../development/interpreters/php {
    inherit stdenv fetchurl flex bison libxml2 apacheHttpd;
    unixODBC =
      if stdenv.isDarwin then null else unixODBC;
  };

  python = import ../development/interpreters/python {
    inherit fetchurl stdenv zlib bzip2;
  };

  python25 = import ../development/interpreters/python/2.5 {
    inherit fetchurl stdenv zlib bzip2;
  };

  realPerl = import ../development/interpreters/perl {
    inherit fetchurl stdenv;
  };

  ruby = import ../development/interpreters/ruby {
    inherit fetchurl stdenv readline ncurses;
  };

  spidermonkey = import ../development/interpreters/spidermonkey {
    inherit fetchurl;
    # remove when the "internal compiler error" in gcc 4.1.x is fixed
    stdenv = overrideGCC stdenv gcc34;
  };

  sysPerl = import ../development/interpreters/sys-perl {
    inherit stdenv;
  };

  tcl = import ../development/interpreters/tcl {
    inherit fetchurl stdenv;
  };

  xulrunner = import ../development/interpreters/xulrunner {
    inherit fetchurl stdenv pkgconfig perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  xulrunnerWrapper = {application, launcher}:
    import ../development/interpreters/xulrunner/wrapper {
      inherit stdenv xulrunner application launcher;
    };


  ### DEVELOPMENT / MISC


  /*
  toolbus = import ../development/interpreters/toolbus {
    inherit stdenv fetchurl atermjava toolbuslib aterm yacc flex;
  };
  */

  ecj = import ../development/eclipse/ecj {
    inherit fetchurl stdenv unzip jre ant;
  };

  jdtsdk = import ../development/eclipse/jdt-sdk {
    inherit fetchurl stdenv unzip;
  };

  windowssdk = import ../development/misc/windows-sdk {
    inherit fetchurl stdenv cabextract;
  };


  ### DEVELOPMENT / TOOLS


  antlr = import ../development/tools/parsing/antlr/antlr-2.7.6.nix {
    inherit fetchurl stdenv jre;
  };

  antlr3 = import ../development/tools/parsing/antlr {
    inherit fetchurl stdenv jre;
  };

  ant = apacheAnt;
  apacheAnt = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv jdk;
    name = "ant-" + jdk.name;
  };

  apacheAnt14 = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv;
    jdk = j2sdk14x;
    name = "ant-" + j2sdk14x.name;
  };

  autoconf = autoconf261;

  autoconf261 = import ../development/tools/misc/autoconf {
    inherit fetchurl stdenv perl m4;
  };

  automake = automake19x;

  automake17x = import ../development/tools/misc/automake/automake-1.7.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  automake19x = import ../development/tools/misc/automake/automake-1.9.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  # commented out because it's using the new configuration style proposal which is unstable
  #avrdude = import ../development/tools/misc/avrdude {
  #  inherit lib fetchurl stdenv flex yacc;
  #};

  binutils = useFromStdenv (stdenv ? binutils) stdenv.binutils
    (import ../development/tools/misc/binutils {
      inherit fetchurl stdenv noSysDirs;
    });

  bison = bison1875;

  bison1875 = import ../development/tools/parsing/bison/bison-1.875.nix {
    inherit fetchurl stdenv m4;
  };

  bison23 = import ../development/tools/parsing/bison/bison-2.3.nix {
    inherit fetchurl stdenv m4;
  };

  ctags = import ../development/tools/misc/ctags {
    inherit fetchurl stdenv;
  };

  cmake = import ../development/tools/build-managers/cmake {
    inherit fetchurl stdenv replace;
  };

  elfutils = import ../development/tools/misc/elfutils {
    inherit fetchurl stdenv;
  };

  epm = import ../development/tools/misc/epm {
    inherit fetchurl stdenv rpm;
  };

  flex = flex254a;

  flex2533 = import ../development/tools/parsing/flex/flex-2.5.33.nix {
    inherit fetchurl stdenv yacc m4;
  };

  flex254a = import ../development/tools/parsing/flex/flex-2.5.4a.nix {
    inherit fetchurl stdenv yacc;
  };

  frown = import ../development/tools/parsing/frown {
    inherit fetchurl stdenv ghc;
  };

  m4 = gnum4;

  gnum4 = import ../development/tools/misc/gnum4 {
    inherit fetchurl stdenv;
  };

  gnumake = useFromStdenv (stdenv ? gnumake) stdenv.gnumake
    (import ../development/tools/build-managers/gnumake {
      inherit fetchurl stdenv;
    });

  gnumake380 = import ../development/tools/build-managers/gnumake-3.80 {
    inherit fetchurl stdenv;
  };

  gperf = import ../development/tools/misc/gperf {
    inherit fetchurl stdenv;
  };

  happy = import ../development/tools/parsing/happy {
    inherit fetchurl stdenv perl ghc;
  };

  help2man = import ../development/tools/misc/help2man {
    inherit fetchurl stdenv perl gettext perlLocaleGettext;
  };

  iconnamingutils = import ../development/tools/misc/icon-naming-utils {
    inherit fetchurl stdenv perl perlXMLSimple;
  };

  jikespg = import ../development/tools/parsing/jikespg {
    inherit fetchurl stdenv;
  };

  kcachegrind = import ../development/tools/misc/kcachegrind {
    inherit fetchurl stdenv kdelibs zlib perl expat libpng libjpeg;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lcov = import ../development/tools/misc/lcov {
    inherit fetchurl stdenv perl;
  };

  libtool = import ../development/tools/misc/libtool {
    inherit fetchurl stdenv perl m4;
  };

  lsof = import ../development/tools/misc/lsof {
    inherit fetchurl stdenv;
  };

  ltrace = import ../development/tools/misc/ltrace {
  	inherit fetchurl stdenv builderDefs stringsWithDeps lib 
		elfutils;
  };

  mk = import ../development/tools/build-managers/mk {
    inherit fetchurl stdenv;
  };

  noweb = import ../development/tools/literate-programming/noweb {
    inherit fetchurl stdenv;
  };

  patchelf = useFromStdenv (stdenv ? patchelf) stdenv.patchelf
    (import ../development/tools/misc/patchelf {
        inherit fetchurl stdenv;
    });

  /**
   * pkgconfig is optionally taken from the stdenv to allow bootstrapping
   * of glib and pkgconfig itself on MinGW.
   */
  pkgconfig = useFromStdenv (stdenv ? pkgconfig) stdenv.pkgconfig
    (import ../development/tools/misc/pkgconfig {
      inherit fetchurl stdenv;
    });

  scons = import ../development/tools/build-managers/scons {
    inherit fetchurl stdenv python;
  };

  sdf = import ../development/tools/parsing/sdf {
    inherit fetchurl aterm getopt pkgconfig;
    # Note: sdf2-bundle currently requires GNU make 3.80; remove
    # explicit dependency when this is fixed.
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strace = import ../development/tools/misc/strace {
    inherit fetchurl stdenv;
  };

  swig = import ../development/tools/misc/swig {
    inherit fetchurl stdenv perl python;
    perlSupport = true;
    pythonSupport = true;
    javaSupport = false;
  };

  swigWithJava = lowPrio (appendToName "with-java" (import ../development/tools/misc/swig {
    inherit fetchurl stdenv jdk;
    perlSupport = false;
    pythonSupport = false;
    javaSupport = true;
  }));

  texinfo = import ../development/tools/misc/texinfo {
    inherit fetchurl stdenv ncurses;
  };

  uisp = import ../development/tools/misc/uisp {
    inherit fetchurl stdenv;
  };

  uuagc = import ../development/tools/haskell/uuagc {
    inherit fetchurl stdenv;
    ghc = ghc66;
    uulib = uulib66;
  };

  gdb = import ../development/tools/misc/gdb {
    inherit fetchurl stdenv ncurses;
  };

  valgrind = import ../development/tools/misc/valgrind {
    inherit fetchurl stdenv;
  };

  yacc = bison;


  ### DEVELOPMENT / LIBRARIES


  a52dec = import ../development/libraries/a52dec {
    inherit fetchurl stdenv;
  };

  aalib = import ../development/libraries/aalib {
    inherit fetchurl stdenv ncurses;
  };

  /*
  agg = import ../development/libraries/agg {
    inherit fetchurl stdenv autoconf automake libtool pkgconfig;
  };
  */

  apr = import ../development/libraries/apr {
    inherit fetchurl stdenv;
  };

  aprutil = import ../development/libraries/apr-util {
    inherit fetchurl stdenv apr expat db4;
    bdbSupport = true;
  };

  arts = import ../development/libraries/arts {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXext;
    inherit kdelibs zlib libjpeg libpng perl;
    qt = qt3;
    inherit (gnome) glib;
  };

  aterm = lowPrio (import ../development/libraries/aterm {
    inherit fetchurl stdenv;
  });

  aterm242fixes = import ../development/libraries/aterm/2.4.2-fixes.nix {
    inherit fetchurl stdenv;
  };

  aterm23x = import ../development/libraries/aterm/2.3.nix {
    inherit fetchurl stdenv;
  };

  aspell = import ../development/libraries/aspell {
    inherit fetchurl stdenv perl;
  };

  aspellDicts = recurseIntoAttrs (import ../development/libraries/aspell/dictionaries.nix {
    inherit fetchurl stdenv aspell which;
  });

  audiofile = import ../development/libraries/audiofile {
    inherit fetchurl stdenv;
  };

  axis = import ../development/libraries/axis {
    inherit fetchurl stdenv;
  };

  beecrypt = import ../development/libraries/beecrypt {
    inherit fetchurl stdenv m4;
  };

  boehmgc = import ../development/libraries/boehm-gc {
    inherit fetchurl stdenv;
  };

  boost = import ../development/libraries/boost {
    inherit fetchurl stdenv icu zlib bzip2 python;
  };

  cairo = import ../development/libraries/cairo {
    inherit fetchurl stdenv pkgconfig x11 fontconfig freetype zlib libpng;
  };

  chmlib = import ../development/libraries/chmlib {
    inherit fetchurl stdenv;
  };

  cil = import ../development/libraries/cil {
    inherit stdenv fetchurl ocaml perl;
  };

  cilaterm = import ../development/libraries/cil-aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
    inherit fetchurl perl ocaml;
  };

  clanlib = import ../development/libraries/clanlib {
    inherit fetchurl stdenv zlib libpng libjpeg libvorbis libogg mesa;
    inherit (xlibs) libX11 xf86vidmodeproto libXmu libXxf86vm;
  };

  clearsilver = import ../development/libraries/clearsilver {
    inherit fetchurl stdenv python;
  };

  cluceneContrib = (import ../development/libraries/clucene-contrib) {
    inherit fetchurl stdenv cluceneCore;
   };

   cluceneCore = (import ../development/libraries/clucene-core) {
     inherit fetchurl stdenv;
   };

  coredumper = import ../development/libraries/coredumper {
    inherit fetchurl stdenv;
  };

  cppunit = import ../development/libraries/cppunit {
	  inherit fetchurl stdenv;
  };

  cracklib = import ../development/libraries/cracklib {
    inherit fetchurl stdenv;
  };

  cyrus_sasl = import ../development/libraries/cyrus-sasl {
	  inherit fetchurl stdenv openssl db4 gettext;
  };

  db4 = db45;

  db44 = import ../development/libraries/db4/db4-4.4.nix {
    inherit fetchurl stdenv;
  };

  db45 = import ../development/libraries/db4/db4-4.5.nix {
    inherit fetchurl stdenv;
  };

  # I think, this is a bad practice to use getVersion for various build
  # variants, but it's 5 o'clock now...
  dbus = getVersion "dbus" dbus_alts;

  dbus_alts = rec
  {
    noX11 = import ../development/libraries/dbus {
    inherit fetchurl stdenv pkgconfig expat;
    };
    withX11 = import ../development/libraries/dbus_x {
	  inherit fetchurl stdenv pkgconfig expat;
	  inherit (xlibs) libX11 libICE libSM;
    };
	default = noX11;
  };

  dbus_glib = import ../development/libraries/dbus-glib {
    inherit fetchurl stdenv pkgconfig gettext dbus expat;
    inherit (gtkLibs) glib;
  };

  dclib = import ../development/libraries/dclib {
    inherit fetchurl stdenv libxml2 openssl bzip2;
  };

  directfb = import ../development/libraries/directfb {
    inherit fetchurl stdenv perl;
  };

  enchant = import ../development/libraries/enchant {
	  inherit fetchurl stdenv aspell pkgconfig;
	  inherit (gnome) glib;
  };

  exiv2 = import ../development/libraries/exiv2 {
	  inherit fetchurl stdenv zlib;
  };

  expat = import ../development/libraries/expat {
    inherit fetchurl stdenv;
  };

  ffmpeg = import ../development/libraries/ffmpeg {
    inherit fetchurl stdenv;
  };

  ffmpeg_svn = import ../development/libraries/ffmpeg_svn_snapshot {
    inherit fetchurl stdenv;
  };

  fftw = import ../development/libraries/fftw {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
  };


  # commented out because it's using the new configuration style proposal which is unstable
  # needs some testing ..
  #fltk20 = (import ../development/libraries/fltk) {
    #inherit fetchurl stdenv lib mesa mesaHeaders libpng libjpeg zlib ;
    #inherit (xlibs) libX11 libXext;
    #flags = [ "useNixLibs" "threads" "shared" ];
  #};

  fontconfig = import ../development/libraries/fontconfig {
    inherit fetchurl stdenv freetype expat;
  };

  freealut = import ../development/libraries/freealut {
    inherit fetchurl stdenv openal;
  };

  freeglut = assert mesaSupported; import ../development/libraries/freeglut {
    inherit fetchurl stdenv x11 mesa;
  };

  freetype = import ../development/libraries/freetype {
    inherit fetchurl stdenv;
  };

  fribidi = import ../development/libraries/fribidi {
    inherit fetchurl stdenv;
  };

  gettext = getVersion "gettext" gettext_alts;

  gettext_alts = import ../development/libraries/gettext {
    inherit fetchurl stdenv;
  };

  gd = import ../development/libraries/gd {
    inherit fetchurl stdenv zlib libpng freetype libjpeg fontconfig;
  };

  gdal = stdenv.mkDerivation {
    name = "gdal-1.4.2";
    src = fetchurl {
      url = http://download.osgeo.org/gdal/gdal-1.4.2.tar.gz;
      sha256 = "1vl8ym9y7scm0yd4vghjfqims69b9h1gn9l4zvy2jyglh35p8vpf";
    };
  };

  glibc = useFromStdenv (stdenv ? glibc) stdenv.glibc
    (import ../development/libraries/glibc {
      inherit fetchurl stdenv kernelHeaders;
      #installLocales = false;
    });

  glibcNPTL = import ../development/libraries/glibc-nptl {
    inherit fetchurl kernelHeaders perl; 
    stdenv = overrideGCC stdenv gcc34;
  };

  glibmm = import ../development/libraries/gtk-libs-2.6/glibmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) glib;
  };

  gmime = import ../development/libraries/gmime {
    inherit fetchurl stdenv pkgconfig zlib;
    inherit (gtkLibs) glib;
  };

  gmp = import ../development/libraries/gmp {
    inherit fetchurl stdenv m4;
  };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = import ../development/libraries/mpfr {
    inherit fetchurl stdenv gmp;
  };

  gnet = import ../development/libraries/gnet {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib;
  };

  gpgme = import ../development/libraries/gpgme {
    inherit fetchurl stdenv libgpgerror gnupg;
  };

  gtkLibs = recurseIntoAttrs gtkLibs210;

  gtkLibs1x = import ../development/libraries/gtk-libs-1.x {
    inherit fetchurl stdenv x11 libtiff libjpeg libpng;
  };

  gtkLibs210 = import ../development/libraries/gtk-libs-2.10 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo;
    inherit (xlibs) libXinerama libXrandr;
    xineramaSupport = true;
  };

  gtkLibs22 = import ../development/libraries/gtk-libs-2.2 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs24 = import ../development/libraries/gtk-libs-2.4 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs26 = import ../development/libraries/gtk-libs-2.6 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs28 = import ../development/libraries/gtk-libs-2.8 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo;
    inherit (xlibs) libXinerama;
    xineramaSupport = true;
  };

  gtkmm = import ../development/libraries/gtk-libs-2.6/gtkmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) gtk atk;
    inherit glibmm;
  };

  gtkmozembedsharp = import ../development/libraries/gtkmozembed-sharp {
    inherit fetchurl stdenv mono pkgconfig monoDLLFixer;
    inherit (gnome) gtk;
    gtksharp = gtksharp2;
  };

  gtksharp1 = import ../development/libraries/gtk-sharp-1 {
    inherit fetchurl stdenv mono pkgconfig libxml2 monoDLLFixer;
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml 
              libgnomecanvas libgnomeui libgnomeprint 
              libgnomeprintui GConf;
  };

  gtksharp2 = import ../development/libraries/gtk-sharp-2 {
    inherit fetchurl stdenv mono pkgconfig libxml2 monoDLLFixer;
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml 
              libgnomecanvas libgnomeui libgnomeprint 
              libgnomeprintui GConf gnomepanel;
  };

  gtksourceviewsharp = import ../development/libraries/gtksourceview-sharp {
    inherit fetchurl stdenv mono pkgconfig monoDLLFixer;
    inherit (gnome) gtksourceview;
    gtksharp = gtksharp2;
  };

  gtkspell = import ../development/libraries/gtkspell {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit aspell;
  };

  hsqldb = import ../development/libraries/java/hsqldb {
    inherit stdenv fetchurl unzip;
  };

  icu = import ../development/libraries/icu {
    inherit fetchurl stdenv;
  };

  id3lib = import ../development/libraries/id3lib {
    inherit fetchurl stdenv;
  };

  ilmbase = import ../development/libraries/ilmbase {
	  inherit fetchurl stdenv;
  };

  imlib = import ../development/libraries/imlib {
    inherit fetchurl stdenv libjpeg libtiff libungif libpng;
    inherit (xlibs) libX11 libXext xextproto;
  };

  imlib2 = import ../development/libraries/imlib2 {
    inherit fetchurl stdenv x11 libjpeg libtiff libungif libpng;
  };

  lablgtk = import ../development/libraries/lablgtk {
    inherit fetchurl stdenv ocaml pkgconfig;
    inherit (gtkLibs) gtk;
  };

  lcms = import ../development/libraries/lcms {
    inherit fetchurl stdenv;
  };

  lesstif = import ../development/libraries/lesstif {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  libcaca = import ../development/libraries/libcaca {
    inherit fetchurl stdenv ncurses;
  };

  libcdaudio = import ../development/libraries/libcdaudio {
    inherit fetchurl stdenv;
  };

  libcm = assert mesaSupported; import ../development/libraries/libcm {
    inherit fetchurl stdenv pkgconfig xlibs mesa;
    inherit (gtkLibs) glib;
  };

  libdaemon = import ../development/libraries/libdaemon {
    inherit fetchurl stdenv;
  };

  libdrm = import ../development/libraries/libdrm {
    inherit fetchurl stdenv;
  };

  libdvdcss = import ../development/libraries/libdvdcss {
    inherit fetchurl stdenv;
  };

  libdvdnav = import ../development/libraries/libdvdnav {
    inherit fetchurl stdenv;
  };

  libdvdread = import ../development/libraries/libdvdread {
    inherit fetchurl stdenv libdvdcss;
  };

  libevent = import ../development/libraries/libevent {
    inherit fetchurl stdenv;
  };

  libexif = import ../development/libraries/libexif {
    inherit fetchurl stdenv;
  };

  libgcrypt = import ../development/libraries/libgcrypt {
    inherit fetchurl stdenv libgpgerror;
  };

  libgpgerror = import ../development/libraries/libgpg-error {
    inherit fetchurl stdenv;
  };

  libgphoto2 = import ../development/libraries/libgphoto2 {
    inherit fetchurl stdenv pkgconfig libusb;
  };

  # commented out because it's using the new configuration style proposal which is unstable
  #libsamplerate = (import ../development/libraries/libsamplerate) {
  #  inherit fetchurl stdenv mkDerivationByConfigruation pkgconfig lib;
  #};

  libgsf = import ../development/libraries/libgsf {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig libxml2 gettext;
    inherit (gnome) glib;
  };

  libjpeg = import ../development/libraries/libjpeg {
    inherit fetchurl stdenv libtool;
  };

  libjpegStatic = lowPrio (appendToName "static" (import ../development/libraries/libjpeg-static {
    inherit fetchurl stdenv libtool;
    static = true;
  }));

  libmad = import ../development/libraries/libmad {
    inherit fetchurl stdenv;
  };

  libmpcdec = import ../development/libraries/libmpcdec {
    inherit fetchurl stdenv;
  };

  libmspack = import ../development/libraries/libmspack {
    inherit fetchurl stdenv;
  };

  libogg = import ../development/libraries/libogg {
    inherit fetchurl stdenv;
  };

  libotr = import ../development/libraries/libotr {
    inherit fetchurl stdenv libgcrypt;
  };

  libpcap = import ../development/libraries/libpcap {
    inherit fetchurl stdenv flex bison;
  };

  libpng = import ../development/libraries/libpng {
    inherit fetchurl stdenv zlib;
  };

  libsigcxx = import ../development/libraries/libsigcxx {
    inherit fetchurl stdenv pkgconfig;
  };

  libsigsegv = import ../development/libraries/libsigsegv {
    inherit fetchurl stdenv;
  };

  libsndfile = import ../development/libraries/libsndfile {
    inherit fetchurl stdenv;
  };

  libtheora = import ../development/libraries/libtheora {
    inherit fetchurl stdenv libogg libvorbis;
  };

  libtiff = import ../development/libraries/libtiff {
    inherit fetchurl stdenv zlib libjpeg;
  };

  libungif = import ../development/libraries/libungif {
    inherit fetchurl stdenv;
  };

  libusb = import ../development/libraries/libusb {
    inherit fetchurl stdenv;
  };

  libvorbis = import ../development/libraries/libvorbis {
    inherit fetchurl stdenv libogg;
  };

  libwmf = import ../development/libraries/libwmf {
    inherit fetchurl stdenv pkgconfig imagemagick 
	zlib libpng freetype libjpeg libxml2;
    inherit (gtkLibs) glib;
  };

  libwpd = import ../development/libraries/libwpd {
    inherit fetchurl stdenv pkgconfig libgsf libxml2;
    inherit (gnome) glib;
  };

  libxcrypt = import ../development/libraries/libxcrypt {
    inherit fetchurl stdenv;
  };

  libxml2 = import ../development/libraries/libxml2 {
    inherit fetchurl stdenv zlib python;
    pythonSupport = false;
  };

  libxml2Python = lowPrio (appendToName "with-python" (import ../development/libraries/libxml2 {
    inherit fetchurl stdenv zlib python;
    pythonSupport = true;
  }));

  libxslt = import ../development/libraries/libxslt {
    inherit fetchurl stdenv libxml2;
  };

  libixp03 = import ../development/libraries/libixp/libixp-0.3.nix {
    inherit fetchurl stdenv;
  };

  libixp_for_wmii = lowPrio (import ../development/libraries/libixp_for_wmii {
    inherit fetchurl stdenv;
  });

  mesaSupported =
    system == "i686-linux" ||
    system == "x86_64-linux";
  
  mesa = assert mesaSupported; import ../development/libraries/mesa {
    inherit fetchurl stdenv pkgconfig x11 libdrm;
    inherit (xlibs) libXmu libXi makedepend glproto libXxf86vm;
  };

  mesaHeaders = import ../development/libraries/mesa/headers.nix {
    inherit stdenv;
    mesaSrc = mesa.src;
  };

  mpeg2dec = import ../development/libraries/mpeg2dec {
    inherit fetchurl stdenv;
  };

  mysqlConnectorODBC = import ../development/libraries/mysql-connector-odbc {
    inherit fetchurl stdenv mysql libtool zlib unixODBC;
  };

  ncurses = import ../development/libraries/ncurses {
    inherit fetchurl stdenv;
    unicode = (system != "i686-cygwin");
  };

  ncursesDiet = import ../development/libraries/ncurses-diet {
    inherit fetchurl;
    stdenv = useDietLibC stdenv;
  };

  neon = import ../development/libraries/neon {
    inherit fetchurl stdenv libxml2 zlib openssl;
    compressionSupport = true;
    sslSupport = true;
  };

  nss = import ../development/libraries/nss {
    inherit fetchurl stdenv perl zip;
  };

  openal = import ../development/libraries/openal {
    inherit fetchurl stdenv alsaLib autoconf automake libtool;
  };

  openexr = import ../development/libraries/openexr {
	  inherit fetchurl stdenv ilmbase zlib pkgconfig;
  };

  openldap = import ../development/libraries/openldap {
    inherit fetchurl stdenv openssl cyrus_sasl db4;
  };

  openssl = import ../development/libraries/openssl {
    inherit fetchurl stdenv perl;
  };

  pangoxsl = import ../development/libraries/pangoxsl {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib pango;
  };

  pcre = import ../development/libraries/pcre {
    inherit fetchurl stdenv;
    unicodeSupport = getFlag "unicode" "pcre" false;
  };

  popt = import ../development/libraries/popt {
    inherit fetchurl stdenv gettext;
  };

  popt110 = import ../development/libraries/popt/popt-1.10.6.nix {
    inherit fetchurl stdenv gettext libtool autoconf automake;
  };

  qt3 = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor;
    openglSupport = mesaSupported;
    mysqlSupport = false;
  };

  qt4 = getVersion "qt4" qt4_alts;
  # Builds, but not tested yet
  # There are two versions: kde and trolltech
  qt4_alts = import ../development/libraries/qt-4 {
	inherit fetchurl fetchsvn zlib libjpeg libpng which mysql mesa openssl cups dbus
	  fontconfig freetype pkgconfig;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
	  libXmu libXinerama xineramaproto libXcursor libICE libSM libX11 libXext
	  inputproto fixesproto libXfixes;
    inherit (gnome) glib;
    stdenv = overrideSetup stdenv ../stdenv/generic/setup-new-2.sh;
    openglSupport = mesaSupported;
    mysqlSupport = true;
  };

  readline = readline5;

  readline4 = import ../development/libraries/readline/readline4.nix {
    inherit fetchurl stdenv ncurses;
  };

  readline5 = import ../development/libraries/readline/readline5.nix {
    inherit fetchurl stdenv ncurses;
  };

# Also known as librdf, includes raptor and rasqal
  redland = import ../development/libraries/redland {
    inherit fetchurl stdenv openssl libxml2 pkgconfig perl;
	bdb = db4;
  };

  rte = import ../development/libraries/rte {
    inherit fetchurl stdenv;
  };

  SDL = import ../development/libraries/SDL {
    inherit fetchurl stdenv x11 mesa alsaLib;
    inherit (xlibs) libXrandr;
    openglSupport = mesaSupported;
    alsaSupport = true;
  };

  SDL_image = import ../development/libraries/SDL_image {
    inherit fetchurl stdenv SDL libjpeg libungif libtiff libpng;
    inherit (xlibs) libXpm;
  };

  SDL_mixer = import ../development/libraries/SDL_mixer {
    inherit fetchurl stdenv SDL libogg libvorbis;
  };

  SDL_ttf = import ../development/libraries/SDL_ttf {
    inherit fetchurl stdenv SDL freetype;
  };

  slang = import ../development/libraries/slang {
    inherit fetchurl stdenv pcre libpng;
  };

  speex = import ../development/libraries/speex {
    inherit fetchurl stdenv;
  };

  sqlite = import ../development/libraries/sqlite {
    inherit fetchurl stdenv;
  };

  strigi = import ../development/libraries/strigi {
	  inherit stdenv fetchurl zlib cluceneCore cluceneContrib expat bzip2
	  pkgconfig cmake dbus libxml2 perl;
	  qt = qt4;
  };

  t1lib = import ../development/libraries/t1lib {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXaw;
  };

  taglib = import ../development/libraries/taglib {
    inherit fetchurl stdenv zlib;
  };

  tk = import ../development/libraries/tk {
    inherit fetchurl stdenv tcl x11;
  };

  unixODBC = import ../development/libraries/unixODBC {
    inherit fetchurl stdenv;
  };

  wxGTK = wxGTK26;

  wxGTK26 = import ../development/libraries/wxGTK-2.6 {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wxGTK28fun = lib.sumArgs (import ../development/libraries/wxGTK-2.8);

  wxGTK28deps = wxGTK28fun {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wxGTK28 = wxGTK28deps null;

  Xaw3d = import ../development/libraries/Xaw3d {
    inherit fetchurl stdenv x11 bison;
    flex = flex2533;
    inherit (xlibs) imake gccmakedep libXmu libXpm libXp;
  };

  xineLib = import ../development/libraries/xine-lib {
    inherit fetchurl stdenv zlib x11 libdvdcss alsaLib;
    inherit (xlibs) libXv libXinerama;
  };

  xlibsWrapper = import ../development/libraries/xlibs-wrapper {
    inherit stdenv;
    packages = [
      freetype fontconfig xlibs.xproto xlibs.libX11 xlibs.libXt
      xlibs.libXft xlibs.libXext xlibs.libSM xlibs.libICE
      xlibs.xextproto
    ];
  };

  zlib = import ../development/libraries/zlib {
    inherit fetchurl stdenv;
  };

  zlibStatic = lowPrio (appendToName "static" (import ../development/libraries/zlib {
    inherit fetchurl stdenv;
    static = true;
  }));

  zvbi = import ../development/libraries/zvbi {
    inherit fetchurl stdenv libpng x11;
    pngSupport = true;
  };


  ### DEVELOPMENT / LIBRARIES / JAVA


  atermjava = import ../development/libraries/java/aterm {
    inherit fetchurl sharedobjects jjtraveler jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  commonsFileUpload = import ../development/libraries/java/jakarta-commons/file-upload {
    inherit stdenv fetchurl;
  };

  httpunit = import ../development/libraries/java/httpunit {
    inherit stdenv fetchurl unzip;
  };

  jakartabcel = import ../development/libraries/java/jakarta-bcel {
    regexp = jakartaregexp;
    inherit fetchurl stdenv;
  };

  jakartaregexp = import ../development/libraries/java/jakarta-regexp {
    inherit fetchurl stdenv;
  };

  javaCup = import ../development/libraries/java/cup {
    inherit stdenv fetchurl jdk;
  };

  javasvn = import ../development/libraries/java/javasvn {
    inherit stdenv fetchurl unzip;
  };

  jclasslib = import ../development/tools/java/jclasslib {
    inherit fetchurl stdenv xpf jre;
    ant = apacheAnt14;
  };

  jdom = import ../development/libraries/java/jdom {
    inherit stdenv fetchurl;
  };

  jflex = import ../development/libraries/java/jflex {
    inherit stdenv fetchurl;
  };

  jjtraveler = import ../development/libraries/java/jjtraveler {
    inherit fetchurl jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  junit = import ../development/libraries/java/junit {
    inherit stdenv fetchurl unzip;
  };

  lucene = import ../development/libraries/java/lucene {
    inherit stdenv fetchurl;
  };

  mockobjects = import ../development/libraries/java/mockobjects {
    inherit stdenv fetchurl;
  };

  saxon = import ../development/libraries/java/saxon {
    inherit fetchurl stdenv unzip;
  };

  saxonb = import ../development/libraries/java/saxon/default8.nix {
    inherit fetchurl stdenv unzip jre;
  };

  sharedobjects = import ../development/libraries/java/shared-objects {
    inherit fetchurl jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  swt = import ../development/libraries/java/swt {
    inherit stdenv fetchurl unzip jdk pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXtst;
  };

  xalanj = import ../development/libraries/java/xalanj {
    inherit stdenv fetchurl;
  };


  ### DEVELOPMENT / LIBRARIES / HASKELL

  # usage: see ghcPkgUtil.sh - use setup-new2 because of PATH_DELIMITER
  ghcPkgUtil = runCommand "ghcPkgUtil-internal" 
     { ghcPkgUtil = ../development/libraries/haskell/generic/ghcPkgUtil.sh; }
     "mkdir -p $out/nix-support; cp $ghcPkgUtil \$out/nix-support/setup-hook;";


  uulib64 = import ../development/libraries/haskell/uulib { # !!! remove?
    inherit stdenv fetchurl ghc;
  };

  uulib66 = import ../development/libraries/haskell/uulib-ghc-6.6 { # !!! ugh
    inherit stdenv fetchurl autoconf;
    ghc = ghc66;
  };

  wxHaskell = import ../development/libraries/haskell/wxHaskell {
    inherit stdenv fetchurl unzip ghc wxGTK;
  };


  ### DEVELOPMENT / PERL MODULES


  perlArchiveZip = import ../development/perl-modules/Archive-Zip {
    inherit fetchurl perl;
  };

  perlBerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit fetchurl perl db4;
  };

  perlCGISession = import ../development/perl-modules/generic perl {
    name = "CGI-Session-3.95";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/S/SH/SHERZODR/CGI-Session-3.95.tar.gz;
      md5 = "fe9e46496c7c711c54ca13209ded500b";
    };
  };

  perlCompressZlib = import ../development/perl-modules/Compress-Zlib {
    inherit fetchurl perl;
  };

  perlDateManip = import ../development/perl-modules/generic perl {
    name = "DateManip-5.42a";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/DateManip-5.42a.tar.gz;
      md5 = "648386bbf46d021ae283811f75b07bdf";
    };
  };

  perlDigestSHA1 = import ../development/perl-modules/generic perl {
    name = "Digest-SHA1-2.11";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/Digest-SHA1-2.11.tar.gz;
      md5 = "2449bfe21d6589c96eebf94dae24df6b";
    };
  };

  perlEmailAddress = import ../development/perl-modules/generic perl {
    name = "Email-Address-1.888";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Email-Address-1.888.tar.gz;
      sha256 = "0c6b8djnmiy0niskrvywd6867xd1qmn241ffdwj957dkqdakq9yx";
    };
  };

  perlEmailSend = import ../development/perl-modules/generic perl {
    name = "Email-Send-2.185";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Email-Send-2.185.tar.gz;
      sha256 = "0pbgnnbmv6z3zzqaiq1sdcv5d26ijhw4p8k8kp6ac7arvldblamz";
    };
    propagatedBuildInputs = [perlEmailSimple perlEmailAddress perlModulePluggable perlReturnValue];
  };

  perlEmailSimple = import ../development/perl-modules/generic perl {
    name = "Email-Simple-2.003";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Email-Simple-2.003.tar.gz;
      sha256 = "0h8873pidhkqy7415s5sx8z614d0haxiknbjwrn65icrr2m0b8g6";
    };
  };

  perlHTMLParser = import ../development/perl-modules/generic perl {
    name = "HTML-Parser-3.56";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/HTML-Parser-3.56.tar.gz;
      sha256 = "0x1h42r54aq4yqpwi7mla4jzia9c5ysyqh8ir2nav833f9jm6g2h";
    };
    propagatedBuildInputs = [perlHTMLTagset];
  };

  perlHTMLTagset = import ../development/perl-modules/generic perl {
    name = "HTML-Tagset-3.10";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/P/PE/PETDANCE/HTML-Tagset-3.10.tar.gz;
      sha256 = "05k292qy7jzjlmmybis8nncpnwwa4jfkm7q3gq6866ydxrzds9xh";
    };
  };

  perlHTMLTree = import ../development/perl-modules/generic perl {
    name = "HTML-Tree-3.18";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/HTML-Tree-3.18.tar.gz;
      md5 = "6a9e4e565648c9772e7d8ec6d4392497";
    };
  };

  perlLocaleGettext = import ../development/perl-modules/generic perl {
    name = "LocaleGettext-1.04";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gettext-1.04.tar.gz;
      md5 = "578dd0c76f8673943be043435b0fbde4";
    };
  };

  perlLWP = import ../development/perl-modules/generic perl {
    name = "libwww-perl-5.808";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/libwww-perl-5.808.tar.gz;
      sha256 = "1r5rslx68yplyd07bvjahjjrrqb56bhgg6gwdr9c16mv2s57gq12";
    };
    propagatedBuildInputs = [perlURI perlHTMLParser perlHTMLTagset];
  };

  perlModulePluggable = import ../development/perl-modules/generic perl {
    name = "Module-Pluggable-3.5";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/S/SI/SIMONW/Module-Pluggable-3.5.tar.gz;
      sha256 = "08rywi79pqn2c8zr17fmd18lpj5hm8lxd1j4v2k002ni8vhl43nv";
    };
    patches = [
      ../development/perl-modules/module-pluggable.patch
    ];
  };

  perlReturnValue = import ../development/perl-modules/generic perl {
    name = "Return-Value-1.302";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Return-Value-1.302.tar.gz;
      sha256 = "0hf5rmfap49jh8dnggdpvapy5r4awgx5hdc3acc9ff0vfqav8azm";
    };
  };

  perlTermReadKey = import ../development/perl-modules/generic perl {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlURI = import ../development/perl-modules/generic perl {
    name = "URI-1.35";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/URI-1.35.tar.gz;
      md5 = "1a933b1114c41a25587ee59ba8376f7c";
    };
  };

  perlXMLDOM = import ../development/perl-modules/generic perl {
    name = "XML-DOM-1.44";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/T/TJ/TJMATHER/XML-DOM-1.44.tar.gz;
      sha256 = "1r0ampc88ni3sjpzr583k86076qg399arfm9xirv3cw49k3k5bzn";
    };
#    buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLRegExp perlXMLParser perlLWP];
  };

  perlXMLLibXML = import ../development/perl-modules/generic perl {
    name = "XML-LibXML-1.58";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-LibXML-1.58.tar.gz;
      md5 = "4691fc436e5c0f22787f5b4a54fc56b0";
    };
    buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLLibXMLCommon perlXMLSAX];
  };

  perlXMLLibXMLCommon = import ../development/perl-modules/generic perl {
    name = "XML-LibXML-Common-0.13";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-LibXML-Common-0.13.tar.gz;
      md5 = "13b6d93f53375d15fd11922216249659";
    };
    buildInputs = [libxml2];
  };

  perlXMLNamespaceSupport = import ../development/perl-modules/generic perl {
    name = "XML-NamespaceSupport-1.08";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-NamespaceSupport-1.08.tar.gz;
      md5 = "81bd5ae772906d0579c10061ed735dc8";
    };
    buildInputs = [];
  };

  perlXMLParser = import ../development/perl-modules/XML-Parser {
    inherit fetchurl perl expat;
  };

  perlXMLRegExp = import ../development/perl-modules/generic perl {
    name = "XML-RegExp-0.03";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/T/TJ/TJMATHER/XML-RegExp-0.03.tar.gz;
      sha256 = "1gkarylvdk3mddmchcwvzq09gpvx5z26nybp38dg7mjixm5bs226";
    };
  };

  perlXMLSAX = import ../development/perl-modules/generic perl {
    name = "XML-SAX-0.12";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-SAX-0.12.tar.gz;
      md5 = "bff58bd077a9693fc8cf32e2b95f571f";
    };
    propagatedBuildInputs = [perlXMLNamespaceSupport];
  };

  perlXMLSimple = import ../development/perl-modules/generic perl {
    name = "XML-Simple-2.14";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Simple-2.14.tar.gz;
      md5 = "f321058271815de28d214c8efb9091f9";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLTwig = import ../development/perl-modules/generic perl {
    name = "XML-Twig-3.15";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Twig-3.15.tar.gz;
      md5 = "b26886b8bd19761fff37b23e4964b499";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLWriter = import ../development/perl-modules/generic perl {
    name = "XML-Writer-0.602";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/J/JO/JOSEPHW/XML-Writer-0.602.tar.gz;
      sha256 = "0kdi022jcn9mwqsxy2fiwl2cjlid4x13r038jvi426fhjknl11nl";
    };
  };


  ### DEVELOPMENT / PYTHON MODULES


  bsddb3 = import ../development/python-modules/bsddb3 {
    inherit fetchurl stdenv python db4;
  };

  pil = import ../development/python-modules/pil {
    inherit fetchurl stdenv python zlib libtiff libjpeg freetype;
  };

  psyco = import ../development/python-modules/psyco {
    inherit fetchurl stdenv python;
  };

  pycairo = import ../development/python-modules/pycairo {
    inherit fetchurl stdenv python pkgconfig cairo x11;
  };

  pycrypto = import ../development/python-modules/pycrypto {
    inherit fetchurl stdenv python gmp;
  };

  pygame = import ../development/python-modules/pygame {
    inherit fetchurl stdenv python pkgconfig SDL SDL_image 
	SDL_ttf;
  };

  pygobject = import ../development/python-modules/pygobject {
    inherit fetchurl stdenv python pkgconfig;
    inherit (gtkLibs) glib;
  };

  pygtk = import ../development/python-modules/pygtk {
    inherit fetchurl stdenv python pkgconfig pygobject pycairo;
    inherit (gtkLibs) glib gtk;
  };

  wxPython = wxPython26;

  wxPython26 = import ../development/python-modules/wxPython/2.6.nix {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK26;
  };

  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK28;
  };

  twisted = import ../development/python-modules/twisted {
    inherit fetchurl stdenv python ZopeInterface;
  };

  ZopeInterface = import ../development/python-modules/ZopeInterface {
    inherit fetchurl stdenv python;
  };


  ### SERVERS


  apacheHttpd = import ../servers/http/apache-httpd {
    inherit fetchurl stdenv perl openssl db4 expat zlib;
    sslSupport = true;
    db4Support = true;
  };

  dovecot = import ../servers/mail/dovecot {
    inherit fetchurl stdenv ;
  };

  ircdHybrid = import ../servers/irc/ircd-hybrid {
		inherit fetchurl stdenv openssl zlib;
	};

  jetty = import ../servers/http/jetty {
    inherit fetchurl stdenv unzip;
  };

  mod_python = import ../servers/http/apache-modules/mod_python {
    inherit fetchurl stdenv apacheHttpd python;
  };

  mysql = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  mysql5 = import ../servers/sql/mysql5 {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  mysql_jdbc = import ../servers/sql/mysql/jdbc {
    inherit fetchurl stdenv ant;
  };

  nagios = import ../servers/monitoring/nagios {
    inherit fetchurl stdenv perl;
  };

  nagiosPluginsOfficial = import ../servers/monitoring/nagios/plugins/official {
    inherit fetchurl stdenv;
  };

  postgresql = import ../servers/sql/postgresql {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql_jdbc = import ../servers/sql/postgresql/jdbc {
    inherit fetchurl stdenv ant;
  };

  samba = import ../servers/samba {
    inherit stdenv fetchurl readline openldap pam;
  };

  tomcat5 = import ../servers/http/tomcat {
    inherit fetchurl stdenv jdk;
  };

  vsftpd = import ../servers/ftp/vsftpd {
    inherit fetchurl openssl ;
    stdenv = overrideGCC stdenv gcc295 ;
  };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa mesaHeaders
      xkeyboard_config;
  });


  ### OS-SPECIFIC

  # this creates a patch which can be applied to the kernel to integrate this module..
  kernel_module_acerhk = import ../os-specific/linux/kernel/acerhk {
    inherit fetchurl stdenv gnupatch;
    kernel = kernel_2_6_21;
    debug = true;
  };

  _915resolution = import ../os-specific/linux/915resolution {
    inherit fetchurl stdenv;
  };

  #nfsUtils = import ../os-specific/linux/nfs-utils {
  #  inherit fetchurl stdenv;
  #};

  alsaLib = import ../os-specific/linux/alsa/library {
    inherit fetchurl stdenv;
  };

  alsaUtils = import ../os-specific/linux/alsa/utils {
    inherit fetchurl stdenv alsaLib ncurses gettext;
  };

  cramfsswap = import ../os-specific/linux/cramfsswap {
    inherit fetchurl stdenv zlib;
  };

  devicemapper = import ../os-specific/linux/device-mapper {
    inherit fetchurl stdenv;
  };

  devicemapperStatic = lowPrio (appendToName "static" (import ../os-specific/linux/device-mapper {
    inherit fetchurl stdenv;
    static = true;
  }));

  dietlibc = import ../os-specific/linux/dietlibc {
    inherit fetchurl glibc;
    # Dietlibc 0.30 doesn't compile on PPC with GCC 4.1, bus GCC 3.4 works.
   stdenv = if stdenv.system == "powerpc-linux" then overrideGCC stdenv gcc34 else stdenv;
  };

  e2fsprogs = import ../os-specific/linux/e2fsprogs {
    inherit fetchurl stdenv gettext;
  };

  e2fsprogsDiet = lowPrio (appendToName "diet" (import ../os-specific/linux/e2fsprogs {
    inherit fetchurl gettext;
    stdenv = useDietLibC stdenv;
  }));

  e3cfsprogs = import ../os-specific/linux/e3cfsprogs {
    inherit stdenv fetchurl gettext;
  };

  ext3cowtools = import ../os-specific/linux/ext3cow-tools {
    inherit stdenv fetchurl;
    kernel_ext3cowpatched = kernel;
  };

  eject = import ../os-specific/linux/eject {
    inherit fetchurl stdenv gettext;
  };

  fuse = import ../os-specific/linux/fuse {
    inherit fetchurl stdenv;
  };

  genext2fs = import ../os-specific/linux/genext2fs {
    inherit fetchurl stdenv;
  };

  hal = import ../os-specific/linux/hal {
    inherit fetchurl stdenv pkgconfig python pciutils usbutils expat
      libusb dbus dbus_glib libvolume_id perl perlXMLParser
      gettext zlib eject libsmbios udev;
    inherit (gtkLibs) glib;
  };

  hdparm = import ../os-specific/linux/hdparm {
    inherit fetchurl stdenv;
  };
 
  htop = import ../os-specific/linux/htop {
	  inherit fetchurl stdenv ncurses;
  };

  hwdata = import ../os-specific/linux/hwdata {
    inherit fetchurl stdenv;
  };

  ifplugd = import ../os-specific/linux/ifplugd {
    inherit fetchurl stdenv pkgconfig libdaemon;
  };

  initscripts = import ../os-specific/linux/initscripts {
    inherit fetchurl stdenv popt pkgconfig;
    inherit (gtkLibs) glib;
  };

  iproute = import ../os-specific/linux/iproute {
    inherit fetchurl stdenv flex bison db4;
  };

  iputils = import ../os-specific/linux/iputils {
    inherit fetchurl stdenv;
    glibc = stdenv.gcc.libc;
    kernelHeaders = stdenv.gcc.libc.kernelHeaders;
  };

  iptables = import ../os-specific/linux/iptables {
    inherit fetchurl stdenv;
  };

  ipw2200fw = import ../os-specific/linux/firmware/ipw2200 {
    inherit fetchurl stdenv;
  };

  kbd = import ../os-specific/linux/kbd {
    inherit fetchurl stdenv bison flex;
  };

  kernelHeaders = import ../os-specific/linux/kernel-headers {
    inherit fetchurl stdenv;
  };

  kernelHeaders_2_6_21 = import ../os-specific/linux/kernel-headers/2.6.21.3.nix {
    inherit fetchurl stdenv;
  };

  kernelHeaders_2_6_23 = import ../os-specific/linux/kernel-headers/2.6.23.1.nix {
    inherit fetchurl stdenv;
  };

  kernelHeadersArm = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "arm-linux";
  };

  kernelHeadersMips = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "mips-linux";
  };

  kernelHeadersSparc = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "sparc-linux";
  };

  kernelscripts = import ../os-specific/linux/kernelscripts {
    inherit stdenv module_init_tools kernel;
    modules = [];
  };

  kernel = kernel_2_6_21;

  systemKernel = (if (getConfig ["kernel" "version"] "2.6.21") == "2.6.22" then
	kernel_2_6_22 else if (getConfig ["kernel" "version"] "2.6.21") == "2.6.23" then
	kernel_2_6_23 else kernel);

  kernel_2_6_20 = import ../os-specific/linux/kernel/linux-2.6.20.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.20-paravirt-nvidia.patch;
      }
      { name = "skas-2.6.20-v9-pre9";
        patch = fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      { name = "fbsplash-0.9.2-r5-2.6.20-rc6";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/gensplash/archive/fbsplash-0.9.2-r5-2.6.20-rc6.patch;
          sha256 = "11v4f85f4jnh9sbhqcyn47krb7l1czgzjw3w8wgbq14jm0sp9294";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
  };

  kernel_2_6_21 = import ../os-specific/linux/kernel/linux-2.6.21.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "ext3cow";
        patch = ../os-specific/linux/kernel/linux-2.6.21.7-ext3cow_wouter.patch;
        extraConfig =  
	"CONFIG_EXT3COW_FS=m\n" +
	"CONFIG_EXT3COW_FS_XATTR=y\n" +
	"CONFIG_EXT3COW_FS_POSIX_ACL=y\n" +
	"CONFIG_EXT3COW_FS_SECURITY=y\n";
      }
      /* commented out because only acer users have need for it.. 
         It takes quite a while to create the patch when unpacking the kernel sources only for that task
      { name = "acerhk";
        patch = kernel_module_acerhk + "/acerhk-patch.tar.bz2" ;
        extraConfig =  
	"CONFIG_ACERHK=m\n";
      }
      */
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.20-paravirt-nvidia.patch;
      }
      { name = "skas-2.6.20-v9-pre9";
        patch = fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.21/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "00s8074fzsly2zpir885zqkvq267qyzg6vhsn7n1z2v1z78avxd8";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
  };

  kernel_2_6_22 = import ../os-specific/linux/kernel/linux-2.6.22.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      /*{ name = "ext3cow";
        patch = ../os-specific/linux/kernel/linux-2.6.20.3-ext3cow.patch;
        extraConfig =
        "CONFIG_EXT3COW_FS=m\n" +
        "CONFIG_EXT3COW_FS_XATTR=y\n" +
        "CONFIG_EXT3COW_FS_POSIX_ACL=y\n" +
        "CONFIG_EXT3COW_FS_SECURITY=y\n";
      }*/
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.22-paravirt-nvidia.patch;
      }
      /*
      { name = "skas-2.6.20-v9-pre9";
        patch = fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      */
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.22/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "no_hz"] false) "CONFIG_NO_HZ=y" ++
      lib.optional (getConfig ["kernel" "timer_stats"] false) "CONFIG_TIMER_STATS=y" ++
      lib.optional (getConfig ["kernel" "usb_suspend"] false) "CONFIG_USB_SUSPEND=y" ++
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_23 = import ../os-specific/linux/kernel/linux-2.6.23.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.22-paravirt-nvidia.patch;
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.22/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "timer_stats"] false) "CONFIG_TIMER_STATS=y" ++
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };


  libselinux = import ../os-specific/linux/libselinux {
    inherit fetchurl stdenv libsepol;
  };

  librsvg = import ../development/libraries/librsvg {
    inherit fetchurl stdenv;
    inherit libxml2 pkgconfig cairo fontconfig freetype;
    inherit (gtkLibs) glib pango gtk;
    #gtkLibs = gtkLibs210;          #need gtk+
    libart = gnome.libart_lgpl;
  };

  libsepol = import ../os-specific/linux/libsepol {
    inherit fetchurl stdenv;
  };

  libsmbios = import ../os-specific/linux/libsmbios {
    inherit fetchurl stdenv libxml2;
  };

  klibc = import ../os-specific/linux/klibc {
    inherit fetchurl stdenv perl bison mktemp;
	kernel = systemKernel;
  };

  kvm = kvm49;

  kvm12 = import ../os-specific/linux/kvm/12.nix {
    inherit fetchurl zlib e2fsprogs SDL alsaLib;
    stdenv = overrideGCC stdenv gcc34;
    kernelHeaders = stdenv.gcc.libc.kernelHeaders;
  };

  kvm17 = import ../os-specific/linux/kvm/17.nix {
    inherit fetchurl zlib e2fsprogs SDL alsaLib;
    stdenv = overrideGCC stdenv gcc34;
    kernelHeaders = kernelHeaders_2_6_21;
  };

  kvm49 = import ../os-specific/linux/kvm/49.nix {
    inherit fetchurl zlib e2fsprogs SDL alsaLib;
    stdenv = overrideGCC stdenv gcc34;
    kernelHeaders = kernelHeaders_2_6_23;
  };

  libcap = import ../os-specific/linux/libcap {
    inherit fetchurl stdenv;
  };

  libnscd = import ../os-specific/linux/libnscd {
    inherit fetchurl stdenv;
  };

  libvolume_id = import ../os-specific/linux/libvolume_id {
    inherit fetchurl stdenv;
  };

  lvm2 = import ../os-specific/linux/lvm2 {
    inherit fetchurl stdenv devicemapper;
  };

  lvm2Static = lowPrio (appendToName "static" (import ../os-specific/linux/lvm2 {
    inherit fetchurl stdenv;
    static = true;
    devicemapper = devicemapperStatic;
  }));

  mdadm = import ../os-specific/linux/mdadm {
    inherit fetchurl stdenv groff;
  };

  mingetty = import ../os-specific/linux/mingetty {
    inherit fetchurl stdenv;
  };

  mkinitrd = import ../os-specific/linux/mkinitrd {
    inherit fetchurl stdenv;
    popt = popt110;
  };

  module_init_tools = import ../os-specific/linux/module-init-tools {
    inherit fetchurl stdenv;
  };

  modutils = import ../os-specific/linux/modutils {
    inherit fetchurl bison flex;
    stdenv = overrideGCC stdenv gcc34;
  };

  nettools = import ../os-specific/linux/net-tools {
    inherit fetchurl stdenv;
  };

  nvidiaDrivers = import ../os-specific/linux/nvidia {
    inherit stdenv fetchurl kernel coreutils;
    xorg_server = xorg.xorgserver;
    inherit (xlibs) libX11 libXext;
  };

  gw6c = import ../os-specific/linux/gw6c {
    inherit fetchurl stdenv nettools openssl procps;
  };

  nss_ldap = import ../os-specific/linux/nss_ldap {
    inherit fetchurl stdenv openldap;
  };

  ov511 = import ../os-specific/linux/ov511 {
    inherit fetchurl kernel;
    stdenv = overrideGCC stdenv gcc34;
  };

  pam = import ../os-specific/linux/pam {
    inherit stdenv fetchurl cracklib flex;
  };

  pam_console = import ../os-specific/linux/pam_console {
    inherit stdenv fetchurl pam autoconf automake libtool pkgconfig bison;
    flex = if stdenv.system == "i686-linux" then flex else flex2533;
    inherit (gtkLibs) glib;
  };

  pam_devperm = import ../os-specific/linux/pam_devperm {
    inherit stdenv fetchurl pam;
  };

  pam_ldap = import ../os-specific/linux/pam_ldap {
    inherit stdenv fetchurl pam openldap;
  };

  pam_login = import ../os-specific/linux/pam_login {
    inherit stdenv fetchurl pam;
  };

  pam_unix2 = import ../os-specific/linux/pam_unix2 {
    inherit stdenv fetchurl pam libxcrypt;
  };

  powertop = import ../os-specific/linux/powertop {
    inherit fetchurl stdenv ncurses;
  };

  procps = import ../os-specific/linux/procps {
    inherit fetchurl stdenv ncurses;
  };

  pwdutils = import ../os-specific/linux/pwdutils {
    inherit fetchurl stdenv pam openssl libnscd;
  };

  reiserfsprogs = import ../os-specific/linux/reiserfsprogs {
    inherit fetchurl stdenv;
  };

  radeontools = import ../os-specific/linux/radeontools {
    inherit pciutils;
    inherit fetchurl stdenv;
  };

  shadowutils = import ../os-specific/linux/shadow {
    inherit fetchurl stdenv;
  };

  splashutils = import ../os-specific/linux/splashutils {
    inherit fetchurl stdenv klibc;
    zlib = zlibStatic;
    libjpeg = libjpegStatic;
  };

  squashfsTools = import ../os-specific/linux/squashfs {
    inherit fetchurl stdenv zlib;
  };

  sysklogd = import ../os-specific/linux/sysklogd {
    inherit fetchurl stdenv;
  };

  syslinux = import ../os-specific/linux/syslinux {
    inherit fetchurl stdenv nasm perl;
  };

  sysstat = import ../os-specific/linux/sysstat {
    inherit fetchurl stdenv gettext;
  };

  sysvinit = import ../os-specific/linux/sysvinit {
    inherit fetchurl stdenv;
  };

  sysvtools = import ../os-specific/linux/sysvinit {
    inherit fetchurl stdenv;
    withoutInitTools = true;
  };

  udev = import ../os-specific/linux/udev {
    inherit fetchurl stdenv;
  };

  uml = import ../os-specific/linux/kernel/linux-2.6.20.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    userModeLinux = true;
  };

  umlutilities = import ../os-specific/linux/uml-utilities {
    inherit fetchurl kernelHeaders stdenv;
    tunctl = true;
  };

  upstart = import ../os-specific/linux/upstart {
    inherit fetchurl stdenv;
  };

  usbutils = import ../os-specific/linux/usbutils {
    inherit fetchurl stdenv libusb;
  };

  utillinux = import ../os-specific/linux/util-linux {
    inherit fetchurl stdenv;
  };

  utillinuxStatic = lowPrio (appendToName "static" (import ../os-specific/linux/util-linux {
    inherit fetchurl;
    stdenv = makeStaticBinaries stdenv;
  }));

  wirelesstools = import ../os-specific/linux/wireless-tools {
    inherit fetchurl stdenv;
  };

  wpa_supplicant = import ../os-specific/linux/wpa_supplicant {
    inherit fetchurl stdenv openssl;
  };

  xorg_sys_opengl = import ../os-specific/linux/opengl/xorg-sys {
    inherit stdenv xlibs expat libdrm;
  };


  ### DATA


  bakoma_ttf = import ../data/fonts/bakoma-ttf {
    inherit fetchurl stdenv;
  };

  corefonts = import ../data/fonts/corefonts {
    inherit fetchurl stdenv cabextract;
  };

  docbook5 = import ../data/sgml+xml/schemas/docbook-5.0 {
    inherit fetchurl stdenv;
  };

  docbook_xml_dtd_412 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_42 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_43 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_ebnf_dtd = import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = docbook_xsl;

  docbook_xsl = import ../data/sgml+xml/stylesheets/xslt/docbook {
    inherit fetchurl stdenv;
  };

  docbook5_xsl = import ../data/sgml+xml/stylesheets/xslt/docbook5 {
    inherit fetchurl stdenv;
  };

  freefont_ttf = import ../data/fonts/freefont-ttf {
    inherit fetchurl stdenv;
  };

  manpages = import ../data/documentation/man-pages {
     inherit fetchurl stdenv;
  };

  shared_mime_info = import ../data/misc/shared-mime-info {
	inherit fetchurl stdenv perl perlXMLParser pkgconfig gettext libxml2;
	inherit (gtkLibs) glib;
  };

  iana_etc = import ../data/misc/iana-etc {
    inherit fetchurl stdenv;
  };

  ttf_bitstream_vera = import ../data/fonts/ttf-bitstream-vera {
    inherit fetchurl stdenv;
  };

  vistafonts = import ../data/fonts/vista-fonts {
    inherit fetchurl stdenv cabextract;
  };

  xkeyboard_config = import ../data/misc/xkeyboard-config {
    inherit fetchurl stdenv perl perlXMLParser;
    inherit (xlibs) xkbcomp;
  };


  ### APPLICATIONS


  aangifte2005 = import ../applications/taxes/aangifte-2005 {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext;
  };

  aangifte2006 = import ../applications/taxes/aangifte-2006 {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext;
  };

  abiword = import ../applications/office/abiword {
    inherit fetchurl stdenv pkgconfig fribidi libpng popt;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade libgnomeprint libgnomeprintui libgnomecanvas;
  };

  acroread = import ../applications/misc/acrobat-reader {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXt libXp libXext libX11 libXinerama;
    inherit (gtkLibs) glib pango atk gtk;
    libstdcpp5 = gcc33.gcc;
    xineramaSupport = true;
    fastStart = getConfig ["acroread" "fastStart"] true;
  };

  amsn = import ../applications/networking/instant-messengers/amsn {
    inherit fetchurl stdenv which tcl tk x11;
    libstdcpp = gcc33.gcc;
  };

  audacity = import ../applications/audio/audacity {
    inherit fetchurl libogg libvorbis libsndfile libmad 
	pkgconfig gettext;
	inherit (gtkLibs) gtk glib;
	wxGTK = wxGTK28deps;
    stdenv = overrideGCC stdenv gcc41NPTL;
	inherit builderDefs stringsWithDeps;
  };

  batik = import ../applications/graphics/batik {
    inherit fetchurl stdenv unzip;
  };

  # commented out because it's using the new configuration style proposal which is unstable
  #biew = import ../applications/misc/biew {
  #  inherit lib stdenv fetchurl ncurses;
  #};

  bmp = import ../applications/audio/bmp {
    inherit fetchurl stdenv pkgconfig libogg libvorbis alsaLib id3lib;
    inherit (gnome) esound libglade;
    inherit (gtkLibs) glib gtk;
  };

  bmp_plugin_musepack = import ../applications/audio/bmp-plugins/musepack {
    inherit fetchurl stdenv pkgconfig bmp libmpcdec taglib;
  };

  bmp_plugin_wma = import ../applications/audio/bmp-plugins/wma {
    inherit fetchurl stdenv pkgconfig bmp;
  };

  cdparanoiaIII = import ../applications/audio/cdparanoia {
    inherit fetchurl stdenv;
  };

  cdrtools = import ../applications/misc/cdrtools {
    inherit fetchurl stdenv;
  };

  cdrkit = import ../applications/misc/cdrkit {
    inherit fetchurl stdenv cmake libcap zlib;
  };

  chatzilla = 
    xulrunnerWrapper {
      launcher = "chatzilla";
      application = import ../applications/networking/irc/chatzilla {
          inherit fetchurl stdenv unzip;
        };
    };

  compiz = assert mesaSupported; import ../applications/window-managers/compiz {
    inherit fetchurl stdenv pkgconfig libpng mesa;
    inherit (xorg) libXcomposite libXfixes libXdamage libXrandr
      libXinerama libICE libSM libXrender xextproto;
    inherit (gnome) startupnotification libwnck GConf;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnome libgnomeui metacity
	      glib pango libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeprint
              libgnomeprintui gnomepanel;
    gnomegtk = gnome.gtk;
    inherit librsvg fuse;
  };
  
  compizExtra = import ../applications/window-managers/compiz/extra.nix {
    inherit fetchurl stdenv pkgconfig compiz perl perlXMLParser dbus;
    inherit (gnome) GConf;
    inherit (gtkLibs) gtk;
  };

  cua = import ../applications/editors/emacs-modes/cua {
    inherit fetchurl stdenv;
  };

  cvs = import ../applications/version-management/cvs {
    inherit fetchurl stdenv vim;
  };

  cvs2svn = import ../applications/version-management/cvs2svn {
    inherit fetchurl stdenv python bsddb3 makeWrapper;
  };

  d4x = import ../applications/misc/d4x {
    inherit fetchurl stdenv pkgconfig openssl boost;
    inherit (gtkLibs) gtk glib;
  };
  
  darcs = import ../applications/version-management/darcs {
    inherit fetchurl stdenv ghc zlib ncurses curl;
  };

  dia = import ../applications/graphics/dia {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser 
	libxml2 gettext python libxml2Python docbook5 docbook_xsl 
	libxslt;
    inherit (gtkLibs) gtk glib;
  };

  djvulibre = import ../applications/misc/djvulibre {
    inherit stdenv fetchurl libjpeg libtiff libungif zlib
	ghostscript libpng x11 mesa;
    qt = qt3;
    inherit (xlibs) libX11;
  };

  eclipse = plugins:
    import ../applications/editors/eclipse {
      inherit fetchurl stdenv makeWrapper jdk;
      inherit (gtkLibs) gtk glib;
      inherit (xlibs) libXtst;
      inherit plugins;
    };

  eclipsesdk = eclipse [];

  eclipseSpoofax = lowPrio (appendToName "with-spoofax" (eclipse [spoofax]));

  elinks = import ../applications/networking/browsers/elinks {
    inherit stdenv fetchurl python perl ncurses x11 zlib openssl;
  };

  emacs = emacs22;

  emacs21 = import ../applications/editors/emacs-21 {
    inherit fetchurl stdenv ncurses x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    xaw3dSupport = true;
  };

  emacs22 = import ../applications/editors/emacs-22 {
    inherit fetchurl stdenv ncurses pkgconfig x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    inherit (gtkLibs) gtk;
    xaw3dSupport = false;
    gtkGUI = true;
  };

  emacsUnicode = import ../applications/editors/emacs-unicode {
    inherit fetchurl stdenv ncurses pkgconfig x11 Xaw3d
      libpng libjpeg libungif libtiff;
    inherit (xlibs) libXaw libXpm libXft;
    inherit (gtkLibs) gtk;
    xawSupport = false;
    xaw3dSupport = false;
    gtkGUI = true;
    xftSupport = true;
  };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl;
  };

  wireshark = import ../applications/networking/sniffers/wireshark {
    inherit fetchurl stdenv perl pkgconfig libpcap;
    inherit (gtkLibs) gtk;
  };

  feh = import ../applications/graphics/feh {
    inherit fetchurl stdenv x11 imlib2 libjpeg libpng;
  };

  firefox = lowPrio (import ../applications/networking/browsers/firefox {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  });

  firefoxWrapper = wrapFirefox firefox;

  flac = import ../applications/audio/flac {
    inherit fetchurl stdenv libogg;
  };

  flashplayer = flashplayer9;

  flashplayer7 = import ../applications/networking/browsers/mozilla-plugins/flashplayer-7 {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXmu;
  };

  flashplayer9 = import ../applications/networking/browsers/mozilla-plugins/flashplayer-9 {
    inherit fetchurl stdenv zlib alsaLib;
  };

  flite = import ../applications/misc/flite {
    inherit fetchurl stdenv;
  };

  fspot = import ../applications/graphics/f-spot {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig mono
            libexif libjpeg sqlite lcms libgphoto2 monoDLLFixer;
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  pidgin = import ../applications/networking/instant-messengers/pidgin {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 openssl nss gtkspell GStreamer aspell gettext ncurses;
    inherit (gtkLibs) gtk;
    inherit (gnome) startupnotification;
    inherit (xlibs) libXScrnSaver;
  };

  pidginlatex = import ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
	inherit fetchurl stdenv tetex pkgconfig imagemagick ghostscript pidgin;
	inherit (gtkLibs) glib gtk;
  };

  pidginotr = import ../applications/networking/instant-messengers/pidgin-plugins/otr {
	inherit fetchurl stdenv libotr pidgin;
  };

  gimp = import ../applications/graphics/gimp {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libtiff libjpeg libpng libexif zlib perl perlXMLParser
      python pygtk gettext xlibs;
    inherit (gnome) gtk libgtkhtml libart_lgpl;
  };

  git = import ../applications/version-management/git {
    inherit fetchurl stdenv curl openssl zlib expat perl;
  };

  gnash = assert mesaSupported; import ../applications/video/gnash {
    inherit fetchurl stdenv SDL SDL_mixer GStreamer
            libogg libxml2 libjpeg mesa libpng;
    inherit (xlibs) libX11 libXext libXi libXmu;
  };

  gphoto2 = import ../applications/misc/gphoto2 {
    inherit fetchurl stdenv pkgconfig libgphoto2 libexif popt;
  };

  gqview = import ../applications/graphics/gqview {
    inherit fetchurl stdenv pkgconfig libpng;
    inherit (gtkLibs) gtk;
  };

  GStreamer = import ../applications/audio/GStreamer {
    inherit fetchurl stdenv perl bison flex pkgconfig libxml2;
    inherit (gtkLibs) glib;
  };

  gv = import ../applications/misc/gv {
    inherit fetchurl stdenv Xaw3d ghostscriptX;
  };
 
  haskellMode = import ../applications/editors/emacs-modes/haskell {
    inherit fetchurl stdenv;
  };

  hello = import ../applications/misc/hello/ex-1 {
    inherit fetchurl stdenv perl;
  };

  i810switch = import ../applications/misc/i810 {
    inherit fetchurl stdenv pciutils;
  };
  
  icewm = import ../applications/window-managers/icewm {
    inherit fetchurl stdenv gettext libjpeg libtiff libungif libpng imlib;
    inherit (xlibs) libX11 libXft libXext libXinerama libXrandr;
  };

  imagemagick = import ../applications/graphics/ImageMagick {
    inherit stdenv fetchurl bzip2 freetype graphviz 
	ghostscript libjpeg libpng libtiff libxml2 zlib;
    inherit (xlibs) libX11;
  };

  inkscape = import ../applications/graphics/inkscape {
    inherit fetchurl perl perlXMLParser pkgconfig zlib
      popt libxml2 libxslt libpng boehmgc fontconfig gtkmm
      glibmm libsigcxx lcms boost gettext;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libXft;
    stdenv = overrideGCC stdenv gcc34;
  };

  ion3 = import ../applications/window-managers/ion-3 {
	  inherit fetchurl stdenv x11 gettext groff;
	  lua = lua5;
  };

  irssi = import ../applications/networking/irc/irssi {
    inherit stdenv fetchurl pkgconfig ncurses openssl;
    inherit (gtkLibs) glib;
  };

  joe = import ../applications/editors/joe {
    inherit stdenv fetchurl;
  };

  kuickshow = import ../applications/graphics/kuickshow {
    inherit fetchurl stdenv kdelibs arts libpng libjpeg libtiff libungif imlib expat perl;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lame = import ../applications/audio/lame {
    inherit fetchurl stdenv ;
  };

  ladspaH = import ../applications/audio/ladspa-plugins/ladspah.nix {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
  };

  ladspaPlugins = import ../applications/audio/ladspa-plugins {
    inherit fetchurl stdenv builderDefs stringsWithDeps fftw ladspaH pkgconfig;
  };

  links = import ../applications/networking/browsers/links {
    inherit fetchurl stdenv;
  };

  lynx = import ../applications/networking/browsers/lynx {
    inherit fetchurl stdenv ncurses openssl;
  };

  maxima = import ../applications/misc/maxima {
    inherit fetchurl stdenv clisp;
  };

  mercurial = import ../applications/version-management/mercurial {
    inherit fetchurl stdenv python makeWrapper;
  };

  monodevelop = import ../applications/editors/monodevelop {
    inherit fetchurl stdenv file mono gtksourceviewsharp
            gtkmozembedsharp monodoc perl perlXMLParser pkgconfig;
    inherit (gnome) gnomevfs libbonobo libglade libgnome GConf glib gtk;
    mozilla = firefox;
    gtksharp = gtksharp2;
  };

  monodoc = import ../applications/editors/monodoc {
    inherit fetchurl stdenv mono pkgconfig;
    gtksharp = gtksharp1;
  };

  mozilla = import ../applications/networking/browsers/mozilla {
    inherit fetchurl pkgconfig stdenv perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  MPlayer = import ../applications/video/MPlayer {
    inherit fetchurl stdenv freetype x11 zlib libtheora libcaca freefont_ttf libdvdnav;
    inherit (xlibs) libX11 libXv libXinerama libXrandr;
    alsaSupport = true;
    alsa = alsaLib;
    theoraSupport = true;
    cacaSupport = true;
    xineramaSupport = true;
    randrSupport = true;
  };

 # commented out because it's using the new configuration style proposal which is unstable
 # should be the same as the nix expression above except support for esound :)
 /*
  MPlayer_new_config = import ../applications/video/MPlayer/newconfig.nix {
    inherit fetchurl stdenv freetype x11 zlib freefont_ttf lib;
    inherit (xlibs) libX11 xextproto;

    # optional features
    inherit alsaLib libtheora libcaca;
    inherit (gnome) esound;
    inherit (xlibs) libXv libXinerama;
    inherit (xlibs) libXrandr; # FIXME does this option exist? I couldn't find it as configure option
  };
  */


  MPlayerPlugin = import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
    inherit fetchurl stdenv pkgconfig firefox gettext;
    inherit (xlibs) libXpm;
    # !!! should depend on MPlayer
  };

  # commented out because it's using the new configuration style proposal which is unstable
  #mrxvt = import ../applications/misc/mrxvt {
    #inherit lib fetchurl stdenv;
    #inherit (xlibs) libXaw xproto libXt libX11 libSM libICE;
  #};

  mutt = import ../applications/networking/mailreaders/mutt {
    inherit fetchurl stdenv ncurses which openssl;
  };

  msmtp = import ../applications/networking/msmtp {
    inherit fetchurl stdenv;
  };

  mythtv = import ../applications/video/mythtv {
    inherit fetchurl stdenv which qt3 x11 lame zlib mesa;
    inherit (xlibs) libX11 libXinerama libXv libXxf86vm libXrandr libXmu;
  };

  nano = import ../applications/editors/nano {
    inherit fetchurl stdenv ncurses gettext;
  };

  nanoDiet = lowPrio (appendToName "diet" (import ../applications/editors/nano {
    inherit fetchurl gettext;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  }));

  nedit = import ../applications/editors/nedit {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXpm;
    motif = lesstif;
  };

  nxml = import ../applications/editors/emacs-modes/nxml {
    inherit fetchurl stdenv;
  };

  openoffice = import ../applications/office/openoffice {
    inherit fetchurl stdenv pam python tcsh libxslt
      perl perlArchiveZip perlCompressZlib zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2
      db4 sablotron curl libsndfile flex zip unzip libmspack
      getopt file neon cairo which icu boost jdk ant hsqldb
      cups;
    inherit (xlibs) libXaw libXext libX11 libXtst libXi libXinerama;
    inherit (gtkLibs) gtk;
    bison = bison23;
  };

  opera = import ../applications/networking/browsers/opera {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libX11 libSM libICE libXt libXext;
    qt = qt3;
    #motif = lesstif;
    libstdcpp5 = gcc33.gcc;
  };

  pan = import ../applications/networking/newsreaders/pan {
    inherit fetchurl stdenv pkgconfig perl pcre gmime gettext;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  pinfo = import ../applications/misc/pinfo {
    inherit fetchurl stdenv ncurses;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = import ../applications/misc/procmail {
    inherit fetchurl stdenv autoconf;
  };

  pstree = import ../applications/misc/pstree {
    inherit stdenv fetchurl;
  };

  pythonmagick = import ../applications/graphics/PythonMagick {
    inherit fetchurl stdenv pkgconfig imagemagick boost;
    python = python25;
  };

  ratpoison = import ../applications/window-managers/ratpoison {
    inherit fetchurl stdenv fontconfig readline;
    inherit (xlibs) libX11 inputproto libXt libXpm libXft
	libXtst xextproto;
  };

  rcs = import ../applications/version-management/rcs {
    inherit fetchurl stdenv;
  };

  RealPlayer = import ../applications/video/RealPlayer {
    inherit fetchurl stdenv;
    inherit (gtkLibs) glib pango atk gtk;
    inherit (xlibs) libX11;
    libstdcpp5 = gcc33.gcc;
  };

  rsync = import ../applications/networking/sync/rsync {
    inherit fetchurl stdenv;
  };

  rxvt = import ../applications/misc/rxvt {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libXt libX11;
  };

  # = urxvt
  rxvt_unicode = import ../applications/misc/rxvt_unicode {
    inherit lib fetchurl stdenv perl;
    inherit (xlibs) libXt libX11 libXft;
  };

  sbagen = import ../applications/misc/sbagen {
    inherit fetchurl stdenv;
  };

  skype_linux = import ../applications/networking/skype {
    inherit fetchurl stdenv;
    inherit glibc alsaLib freetype fontconfig libsigcxx gcc41;
    inherit (xlibs) libSM libICE libXi libXrender libXrandr libXfixes libXcursor 
                    libXinerama libXext libX11;
  };

  slim = import ../applications/display-managers/slim {
    inherit fetchurl stdenv x11 libjpeg libpng freetype pam;
    inherit (xlibs) libXmu;
  };

  sndFun = lib.sumArgs (import ../applications/audio/snd) {
  	inherit fetchurl stdenv builderDefs stringsWithDeps lib;
	inherit pkgconfig gmp gettext;
	inherit (xlibs) libXpm;
	inherit (gtkLibs) gtk glib;
  };

  snd = sndFun {
  	inherit guile mesa libtool;
  } null;

  # commented out because it's using the new configuration style proposal which is unstable
  /*
  sox = import ../applications/misc/audio/sox {
    inherit fetchurl stdenv lib mkDerivationByConfigruation;
    # optional features 
    inherit alsaLib; # libao
    inherit libsndfile libogg flac libmad lame libsamplerate;
     # Using the default nix ffmpeg I get this error when linking
     # .libs/libsox_la-ffmpeg.o: In function `audio_decode_frame':
     # /tmp/nix-7957-1/sox-14.0.0/src/ffmpeg.c:130: undefined reference to `avcodec_decode_audio2
     # That's why I'v added ffmpeg_svn
    ffmpeg = ffmpeg_svn;
  };
  */

  spoofax = import ../applications/editors/eclipse/plugins/spoofax {
    inherit fetchurl stdenv;
  };

  subversion = subversion14;

  subversion13 = import ../applications/version-management/subversion-1.3.x {
    inherit fetchurl stdenv openssl db4 expat swig zlib;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversion14 = import ../applications/version-management/subversion-1.4.x {
    inherit fetchurl stdenv apr aprutil neon expat swig zlib;
    bdbSupport = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversionWithJava = import ../applications/version-management/subversion-1.2.x {
    inherit fetchurl stdenv openssl db4 expat jdk;
    swig = swigWithJava;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    httpd = apacheHttpd;
    javahlBindings = true;
  };

  sylpheed = import ../applications/networking/mailreaders/sylpheed {
    inherit fetchurl stdenv pkgconfig openssl gpgme;
    inherit (gtkLibs) gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  thunderbird = thunderbird2;

  thunderbird1 = import ../applications/networking/mailreaders/thunderbird-1.x {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  };

  thunderbird2 = import ../applications/networking/mailreaders/thunderbird-2.x {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  };

  timidity = import ../tools/misc/timidity {
    inherit fetchurl stdenv alsaLib;
  };

  unison = import ../applications/networking/sync/unison {
    inherit fetchurl stdenv ocaml lablgtk makeWrapper;
    inherit (xorg) xset fontschumachermisc;
  };

  valknut = import ../applications/networking/p2p/valknut {
    inherit fetchurl stdenv perl x11 libxml2 libjpeg libpng openssl dclib;
    qt = qt3;
  };

  vim = import ../applications/editors/vim {
    inherit fetchurl stdenv ncurses lib;
  };

  vimDiet = lowPrio (appendToName "diet" (import ../applications/editors/vim-diet {
    inherit fetchurl;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  }));

  vimHugeX = import ../applications/editors/vim {
    inherit fetchurl stdenv lib ncurses pkgconfig;
    inherit (xlibs) libX11 libXext libSM libXpm
	libXt libXaw libXau;
    inherit (gtkLibs) glib gtk;
    flags = ["hugeFeatures" "gtkGUI" "x11Support"];
  };

  vlc = import ../applications/video/vlc {
    inherit fetchurl stdenv perl x11 wxGTK
            zlib mpeg2dec a52dec libmad ffmpeg
            libdvdread libdvdnav libdvdcss;
    inherit (xlibs) libXv;
    alsa = alsaLib;
  };

  w3m = import ../applications/networking/browsers/w3m {
    inherit fetchurl stdenv ncurses openssl boehmgc gettext zlib;
    graphicsSupport = false;
    inherit (gtkLibs1x) gdkpixbuf;
  };

  # I'm keen on wmiimenu only  >wmii-3.5 no longer has it... 
  wmiimenu = import ../applications/window-managers/wmii31 {
    libixp = libixp03;
    inherit fetchurl /* fetchhg */ stdenv gawk;
    inherit (xlibs) libX11;
  };

  wmiiSnap = import ../applications/window-managers/wmii {
    libixp = libixp_for_wmii;
    inherit fetchurl /* fetchhg */ stdenv gawk;
    inherit (xlibs) libX11;
  };

  wrapFirefox = firefox: import ../applications/networking/browsers/firefox-wrapper {
    inherit stdenv firefox;
    plugins = []
    ++ lib.optional (system == "i686-linux") flashplayer
    # RealPlayer is disabled by default for legal reasons.
    ++ lib.optional (system != "i686-linux" && getConfig ["firefox" "enableRealPlayer"] false) RealPlayer
    ++ lib.optional (getConfig ["firefox" "enableMPlayer"] true) MPlayerPlugin
    ++ lib.optional (supportsJDK && jrePlugin ? mozillaPlugin) jrePlugin;
  };

  xara = import ../applications/graphics/xara {
    inherit fetchurl stdenv autoconf automake libtool gettext cvs wxGTK
      pkgconfig libxml2 zip libpng libjpeg;
    inherit (gtkLibs) gtk;
  };

  xawtv = import ../applications/video/xawtv {
    inherit fetchurl stdenv ncurses libjpeg perl;
    inherit (xlibs) libX11 libXt libXft xproto libFS fontsproto libXaw libXpm libXext libSM libICE xextproto;
  };

  xchat = import ../applications/networking/irc/xchat {
    inherit fetchurl stdenv pkgconfig tcl;
    inherit (gtkLibs) gtk;
  };

  xchm = import ../applications/misc/xchm {
    inherit fetchurl stdenv wxGTK chmlib;
  };

  xfig = import ../applications/graphics/xfig {
    stdenv = overrideGCC stdenv gcc34;
    inherit fetchurl makeWrapper x11 Xaw3d libpng libjpeg;
    inherit (xlibs) imake libXpm libXmu libXi libXp;
  };

  xineUI = import ../applications/video/xine-ui {
    inherit fetchurl stdenv pkgconfig x11 xineLib libpng;
  };

  xmms = import ../applications/audio/xmms {
    inherit fetchurl libogg libvorbis alsaLib;
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
    stdenv = overrideGCC stdenv gcc34; # due to problems with gcc 4.x
  };

  xpdf = import ../applications/misc/xpdf {
    inherit fetchurl stdenv x11 freetype t1lib;
    motif = lesstif;
    base14Fonts = "${ghostscript}/share/ghostscript/fonts";
  };

  xterm = import ../applications/misc/xterm {
    inherit fetchurl stdenv ncurses;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE;
  };

  xmacro = import ../tools/X11/xmacro {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi 
	libXtst xextproto inputproto;
  };

  xmove = import ../applications/misc/xmove {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi imake libXau;
    inherit (xorg) xauth;
  };
  xvidcap = import ../applications/video/xvidcap {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (gnome) scrollkeeper libglade;
    inherit (xlibs) libXmu libXext;
  };

  zapping = import ../applications/video/zapping {
    inherit fetchurl stdenv pkgconfig perl python 
            gettext zvbi libjpeg libpng x11
            rte perlXMLParser;
    inherit (gnome) scrollkeeper libgnomeui libglade esound;
    inherit (xlibs) libXv libXmu libXext;
    teletextSupport = true;
    jpegSupport = true;
    pngSupport = true;
    recordingSupport = true;
  };


  ### GAMES


  exult = import ../games/exult {
    inherit fetchurl SDL SDL_mixer zlib libpng unzip;
    stdenv = overrideGCC stdenv gcc34;
  };

  fsg = import ../games/fsg {
	inherit stdenv fetchurl pkgconfig;
	inherit (gtkLibs) glib gtk;
	wxGTK = wxGTK28deps {unicode = false;};
  };
	
  fsgAltBuild = import ../games/fsg/alt-builder.nix {
	inherit stdenv fetchurl;
	wxGTK = wxGTK28deps {unicode = false;};
	stringsWithDeps = import ../lib/strings-with-deps.nix {
		inherit stdenv lib;
	};
	inherit builderDefs;
  };

  gemrb = import ../games/gemrb {
    inherit fetchurl stdenv SDL openal freealut zlib libpng python;
  };

  quake3demo = import ../games/quake3/wrapper {
    name = "quake3-demo";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    inherit fetchurl stdenv mesa;
    game = quake3game;
    paks = [quake3demodata];
  };

  quake3demodata = import ../games/quake3/demo {
    inherit fetchurl stdenv;
  };

  quake3game = import ../games/quake3/game {
    inherit fetchurl stdenv x11 SDL mesa openal;
  };

  rogue = import ../games/rogue {
    inherit fetchurl stdenv ncurses;
  };

  scummvm = import ../games/scummvm {
    inherit fetchurl stdenv SDL zlib mpeg2dec;
  };

  /*tpm = import ../games/thePenguinMachine {
    inherit stdenv fetchurl pil pygame SDL; 
    python24 = python;
  };*/

  ut2004demo = import ../games/ut2004demo {
    inherit fetchurl stdenv xlibs mesa;
  };

  zoom = import ../games/zoom {
    inherit fetchurl stdenv perl expat freetype;
    inherit (xlibs) xlibs;
  };

  keen4 = import ../games/keen4 {
    inherit fetchurl stdenv dosbox unzip;
  };


  ### DESKTOP ENVIRONMENTS


  gnome = recurseIntoAttrs (import ../desktops/gnome {
    inherit fetchurl stdenv pkgconfig audiofile
            flex bison popt zlib libxml2 libxslt
            perl perlXMLParser docbook_xml_dtd_42 docbook_xml_dtd_412
            gettext x11 libtiff libjpeg libpng gtkLibs xlibs bzip2
            libcm python dbus_glib ncurses which libxml2Python
            iconnamingutils;
  });

  kdelibs = import ../desktops/kde/kdelibs {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool
      expat freetype bzip2 cups;
    inherit (xlibs) libX11 libXt libXext;
    qt = qt3;
  };
  
  kdelibs4 = import ../desktops/kde-4/kdelibs {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool
	  expat freetype bzip2 cmake strigi shared_mime_info alsaLib libungif cups;
	inherit (xlibs)
	  inputproto kbproto scrnsaverproto xextproto xf86miscproto
	  xf86vidmodeproto xineramaproto xproto libICE libX11 libXau libXcomposite
	  libXcursor libXdamage libXdmcp libXext libXfixes libXft libXi libXpm
	  libXrandr libXrender libXScrnSaver libXt libXtst libXv libXxf86misc
	  libxkbfile;
    qt = qt4;
  };

  kdepimlibs4 = import ../desktops/kde-4/kdepimlibs {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool
	  expat freetype bzip2 cmake strigi shared_mime_info alsaLib libungif cups
	  boost gpgme;
	inherit (xlibs)
	  inputproto kbproto scrnsaverproto xextproto xf86miscproto
	  xf86vidmodeproto xineramaproto xproto libICE libX11 libXau libXcomposite
	  libXcursor libXdamage libXdmcp libXext libXfixes libXft libXi libXpm
	  libXrandr libXrender libXScrnSaver libXt libXtst libXv libXxf86misc
	  libxkbfile;
    qt = qt4;
	kdelibs = kdelibs4;
  };

  kdepim4 = import ../desktops/kde-4/kdepim {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool libusb
	  expat freetype bzip2 cmake strigi shared_mime_info alsaLib libungif cups
	  mesa gpgme boost;
	inherit (xlibs)
	  inputproto kbproto scrnsaverproto xextproto xf86miscproto
	  xf86vidmodeproto xineramaproto xproto libICE libX11 libXau libXcomposite
	  libXcursor libXdamage libXdmcp libXext libXfixes libXft libXi libXpm
	  libXrandr libXrender libXScrnSaver libXt libXtst libXv libXxf86misc
	  libxkbfile libXinerama;
	inherit (gtkLibs) glib;
    qt = qt4;
	kdelibs = kdelibs4;
	kdepimlibs = kdepimlibs4;
  };

  kdebase4 = import ../desktops/kde-4/kdebase {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool libusb
	  expat freetype bzip2 cmake strigi shared_mime_info alsaLib libungif cups
	  mesa;
	inherit (xlibs)
	  inputproto kbproto scrnsaverproto xextproto xf86miscproto
	  xf86vidmodeproto xineramaproto xproto libICE libX11 libXau libXcomposite
	  libXcursor libXdamage libXdmcp libXext libXfixes libXft libXi libXpm
	  libXrandr libXrender libXScrnSaver libXt libXtst libXv libXxf86misc
	  libxkbfile libXinerama;
	inherit (gtkLibs) glib;
    qt = qt4;
	kdelibs = kdelibs4;
	kdepimlibs = kdepimlibs4;
  };

  kdebase = import ../desktops/kde/kdebase {
    inherit
      fetchurl stdenv pkgconfig x11 xlibs zlib libpng libjpeg perl
      kdelibs openssl bzip2 fontconfig;
    qt = qt3;
  };
  

  ### MISC

  atari800 = import ../misc/emulators/atari800 {
    inherit fetchurl stdenv unzip zlib SDL;
  };

  ataripp = import ../misc/emulators/atari++ {
    inherit fetchurl stdenv x11 SDL;
  };
 
  auctex = import ../misc/tex/auctex {
    inherit stdenv fetchurl emacs tetex;
  };

  busybox = import ../misc/busybox {
    inherit fetchurl stdenv;
  };

  cups = import ../misc/cups {
    inherit fetchurl stdenv zlib libjpeg libpng libtiff pam;
  };

  dblatex = import ../misc/tex/dblatex {
    inherit fetchurl stdenv python libxslt tetex;
  };

  dosbox = import ../misc/emulators/dosbox {
    inherit fetchurl stdenv SDL;
  };

  generator = import ../misc/emulators/generator {
    inherit fetchurl stdenv SDL nasm zlib bzip2 libjpeg;
    inherit (gtkLibs1x) gtk;
  };

  ghostscript = import ../misc/ghostscript {
    inherit fetchurl stdenv libjpeg libpng zlib x11;
    x11Support = false;
  };

  ghostscriptX = lowPrio (appendToName "with-X" (import ../misc/ghostscript {
    inherit fetchurl stdenv libjpeg libpng zlib x11;
    x11Support = true;
  }));

  # commented out because it's using the new configuration style proposal which is unstable
  #gxemul = (import ../misc/gxemul) {
    #inherit lib stdenv fetchurl;
    #inherit (xlibs) libX11;
  #};

  # using the new configuration style proposal which is unstable
  /*
  jackaudio = import ../misc/jackaudio {
   inherit mkDerivationByConfiguration 
           ncurses lib stdenv fetchurl;
   flags = [ "posix_shm" "timestamps"];
  };
  */
 
  keynav = import ../tools/X11/keynav {
	inherit stdenv fetchurl;
	inherit (xlibs) libX11 xextproto libXtst 
		imake libXi libXext;
  };

  lazylist = import ../misc/tex/lazylist {
    inherit fetchurl stdenv tetex;
  };

  linuxwacom = import ../misc/linuxwacom {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi;
  };

  martyr = import ../development/libraries/martyr {
    inherit stdenv fetchurl apacheAnt;
  };

  maven = import ../misc/maven/maven-1.0.nix {
    inherit stdenv fetchurl jdk;
  };

  nix = import ../tools/package-management/nix {
    inherit fetchurl stdenv perl curl bzip2;
    aterm = aterm242fixes;
    db4 = db44;
  };

  nixStatic = import ../tools/package-management/nix-static {
    inherit fetchurl stdenv perl curl autoconf automake libtool;
    aterm = aterm242fixes;
    bdb = db4;
  };

  # The bleeding edge.
  nixUnstable = import ../tools/package-management/nix/unstable.nix {
    inherit fetchurl stdenv perl curl bzip2 openssl;
    aterm = aterm242fixes;
    db4 = db45;
  };

  ntfs3g = import ../misc/ntfs-3g {
    inherit fetchurl stdenv fuse pkgconfig;
  };

  pgf = import ../misc/tex/pgf {
    inherit fetchurl stdenv;
  };

  polytable = import ../misc/tex/polytable {
    inherit fetchurl stdenv tetex lazylist;
  };

  putty = import ../applications/networking/remote/putty {
    inherit stdenv fetchurl ncurses;
    inherit (gtkLibs1x) gtk;
  };

  rssglx = import ../misc/screensavers/rss-glx {
    inherit fetchurl stdenv x11 mesa;
  };

  saneBackends = import ../misc/sane-backends {
    inherit fetchurl stdenv libusb;
	gt68xxFirmware = 
		getConfig ["sane" "gt68xxFirmware"] null;
  };

  saneFrontends = import ../misc/sane-front {
    inherit fetchurl stdenv pkgconfig libusb
	saneBackends;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11;
  };

  synaptics = import ../misc/synaptics {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXi libXext;
    inherit (xorg) xorgserver;
  };

  tetex = import ../misc/tex/tetex {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
  };

  texFunctions = import ../misc/tex/nix {
    inherit stdenv perl tetex graphviz ghostscript;
  };

  toolbuslib = import ../development/libraries/toolbuslib {
    inherit stdenv fetchurl aterm;
  };

  trac = import ../misc/trac {
    inherit stdenv fetchurl python clearsilver makeWrapper sqlite;

    subversion = import ../applications/version-management/subversion-1.3.x {
      inherit fetchurl stdenv openssl db4 expat jdk swig zlib;
      localServer = true;
      httpServer = false;
      sslSupport = true;
      compressionSupport = true;
      httpd = apacheHttpd;
      pythonBindings = true; # Enable python bindings
    };

    pysqlite = import ../development/libraries/pysqlite {
      inherit stdenv fetchurl python sqlite;
    };
  };

  wine = import ../misc/emulators/wine {
    stdenv = overrideGCC stdenv gcc41NPTL;
    inherit fetchurl flex bison mesa ncurses
      libpng libjpeg alsaLib lcms xlibs freetype
      fontconfig fontforge;
  };

  xsane = import ../misc/xsane {
    inherit fetchurl stdenv pkgconfig libusb
	saneBackends saneFrontends;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11;
  };


}
