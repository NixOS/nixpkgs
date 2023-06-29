{ stdenv, lib, stdenvNoCC
, makeScopeWithSplicing, generateSplicesForMkScope
, buildPackages
, bsdSetupHook, makeSetupHook, fetchcvs, groff, mandoc, byacc, flex
, bmake
, writeText, symlinkJoin
}:

let
  openbsdVersion = "7.3";
  inherit (buildPackages.buildPackages) rsync;

  fetchOpenBSD = path: version: sha256: fetchcvs {
    cvsRoot = "anoncvs@anoncvs.usa.openbsd.org:/cvs";
    module = "src/${path}";
    inherit sha256;
    tag = "OPENBSD_${lib.replaceStrings ["."] ["_"] version}";
  };

  openbsdSetupHook = makeSetupHook {
    name = "openbsd-setup-hook";
  } ./setup-hook.sh;

  defaultMakeFlags = [
    "MKSOFTFLOAT=${if stdenv.hostPlatform.cc.float or (stdenv.hostPlatform.parsed.abi.float or "hard") == "soft"
      then "yes"
      else "no"}"
  ];

in makeScopeWithSplicing
  (generateSplicesForMkScope "openbsd")
  (_: {})
  (_: {})
  (self: let
    inherit (self) mkDerivation;
  in {

  # Why do we have splicing and yet do `nativeBuildInputs = with self; ...`?
  #
  # We use `makeScopeWithSplicing` because this should be used for all
  # nested package sets which support cross, so the inner `callPackage` works
  # correctly. But for the inline packages we don't bother to use
  # `callPackage`.
  #
  # We still could have tried to `with` a big spliced packages set, but
  # splicing is jank and causes a number of bootstrapping infinite recursions
  # if one is not careful. Pulling deps out of the right package set directly
  # side-steps splicing entirely and avoids those footguns.
  #
  # For non-bootstrap-critical packages, we might as well use `callPackage` for
  # consistency with everything else, and maybe put in separate files too.

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isOpenBSD) self.compat;

  mkDerivation = lib.makeOverridable (attrs: let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in stdenv'.mkDerivation ({
    pname = "${attrs.pname or (baseNameOf attrs.path)}-openbsd";
    inherit (attrs) version;
    src = fetchOpenBSD attrs.path attrs.version attrs.sha256;

    extraPaths = [ ];

    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      buildPackages.mandoc groff statHook rsync
    ];
    #buildInputs = with self; compatIfNeeded;

    HOST_SH = stdenv'.shell;

    MACHINE_ARCH = {
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    MACHINE = {
      x86_64 = "amd64";
      aarch64 = "arm64";
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    COMPONENT_PATH = attrs.path;

    makeFlags = defaultMakeFlags;

    strictDeps = true;

    meta = with lib; {
      maintainers = with maintainers; [ qbit ];
      platforms = platforms.unix;
      license = licenses.bsd2;
    };

  } // lib.optionalAttrs stdenv'.hasCC {
    # TODO should CC wrapper set this?
    CPP = "${stdenv'.cc.targetPrefix}cpp";
  } // lib.optionalAttrs stdenv'.isDarwin {
    MKRELRO = "no";
  } // lib.optionalAttrs (stdenv'.cc.isClang or false) {
    HAVE_LLVM = lib.versions.major (lib.getVersion stdenv'.cc.cc);
  } // lib.optionalAttrs (stdenv'.cc.isGNU or false) {
    HAVE_GCC = lib.versions.major (lib.getVersion stdenv'.cc.cc);
  } // lib.optionalAttrs (stdenv'.isx86_32) {
    USE_SSP = "no";
  } // lib.optionalAttrs (attrs.headersOnly or false) {
    installPhase = "includesPhase";
    dontBuild = true;
  } // attrs ));

  ##
  ## START BOOTSTRAPPING
  ##
  compat = mkDerivation (let
    version = openbsdVersion;
    commonDeps = [ ];
  in {
    path = "tools/compat";
    sha256 = "1vsxg7136nlhc72vpa664vs22874xh7ila95nkmsd8crn3z3cyn0";
    inherit version;

    setupHooks = [
      ../../../build-support/setup-hooks/role.bash
      ./compat-setup-hook.sh
    ];

    preConfigure = ''
      make include/.stamp configure nbtool_config.h.in defs.mk.in
    '';

    configurePlatforms = [ "build" "host" ];
    configureFlags = [
      "--cache-file=config.cache"
    ] ++ lib.optionals stdenv.hostPlatform.isMusl [
      # We include this header in our musl package only for legacy
      # compatibility, and compat works fine without it (and having it
      # know about sys/cdefs.h breaks packages like glib when built
      # statically).
      "ac_cv_header_sys_cdefs_h=no"
    ];

    nativeBuildInputs = with buildPackages.openbsd; commonDeps ++ [
      bsdSetupHook openbsdSetupHook
      rsync
    ];

    buildInputs = with self; commonDeps;

    # temporarily use gnuinstall for bootstrapping
    # bsdinstall will be built later
    makeFlags = defaultMakeFlags ++ [
      "INSTALL=${buildPackages.coreutils}/bin/install"
      "DATADIR=$(out)/share"
      # Can't sort object files yet
      "LORDER=echo"
      "TSORT=cat"
      # Can't process man pages yet
      "MKSHARE=no"
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # GNU objcopy produces broken .a libs which won't link into dependers.
      # Makefiles only invoke `$OBJCOPY -x/-X`, so cctools strip works here.
      "OBJCOPY=${buildPackages.darwin.cctools}/bin/strip"
    ];
    RENAME = "-D";

    passthru.tests = { openbsd-install = self.install; };

    patches = [
      ./compat-cxx-safe-header.patch
      ./compat-dont-configure-twice.patch
      ./compat-no-force-native.patch
    ];

    preInstall = ''
      makeFlagsArray+=('INSTALL_FILE=''${INSTALL} ''${COPY} ''${PRESERVE} ''${RENAME}')
      makeFlagsArray+=('INSTALL_DIR=''${INSTALL} -d')
      makeFlagsArray+=('INSTALL_SYMLINK=''${INSTALL} ''${SYMLINK} ''${RENAME}')
    '';

    postInstall = ''
      # why aren't these installed by openbsd?
      install -D compat_defs.h $out/include/compat_defs.h
      install -D $BSDSRCDIR/include/cdbw.h $out/include/cdbw.h
      install -D $BSDSRCDIR/sys/sys/cdbr.h $out/include/cdbr.h
      install -D $BSDSRCDIR/sys/sys/featuretest.h \
                 $out/include/sys/featuretest.h
      install -D $BSDSRCDIR/sys/sys/md5.h $out/include/md5.h
      install -D $BSDSRCDIR/sys/sys/rmd160.h $out/include/rmd160.h
      install -D $BSDSRCDIR/sys/sys/sha1.h $out/include/sha1.h
      install -D $BSDSRCDIR/sys/sys/sha2.h $out/include/sha2.h
      install -D $BSDSRCDIR/sys/sys/queue.h $out/include/sys/queue.h
      install -D $BSDSRCDIR/include/vis.h $out/include/vis.h
      install -D $BSDSRCDIR/include/db.h $out/include/db.h
      install -D $BSDSRCDIR/include/netconfig.h $out/include/netconfig.h
      install -D $BSDSRCDIR/include/utmpx.h $out/include/utmpx.h
      install -D $BSDSRCDIR/include/tzfile.h $out/include/tzfile.h
      install -D $BSDSRCDIR/sys/sys/tree.h $out/include/sys/tree.h
      install -D $BSDSRCDIR/include/nl_types.h $out/include/nl_types.h
      install -D $BSDSRCDIR/include/stringlist.h $out/include/stringlist.h

      # Collapse includes slightly to fix dangling reference
      install -D $BSDSRCDIR/common/include/rpc/types.h $out/include/rpc/types.h
      sed -i '1s;^;#include "nbtool_config.h"\n;' $out/include/rpc/types.h
   '' + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/include/ssp
      touch $out/include/ssp/ssp.h
   '' + ''
      mkdir -p $out/lib/pkgconfig
      substitute ${./libbsd-overlay.pc} $out/lib/pkgconfig/libbsd-overlay.pc \
        --subst-var-by out $out \
        --subst-var-by version ${version}
    '';
    extraPaths = with self; [ include.src libc.src libutil.src
      (fetchOpenBSD "external/bsd/flex" openbsdVersion "0h98jpfj7vx5zh7vd7bk6b1hmzgkcb757a8j6d9zgygxxv13v43m")
      (fetchOpenBSD "sys/sys" openbsdVersion "0zawhw51klaigqqwkx0lzrx3mim2jywrc24cm7c66qsf1im9awgd")
      (fetchOpenBSD "common/include/rpc/types.h" openbsdVersion "0n2df12mlc3cbc48jxq35yzl1y7ghgpykvy7jnfh898rdhac7m9a")
    ] ++ libutil.extraPaths ++ _mainLibcExtraPaths;
  });

  fts = mkDerivation {
    pname = "fts";
    path = "include/fts.h";
    sha256 = "01d4fpxvz1pgzfk5xznz5dcm0x0gdzwcsfm1h3d0xc9kc6hj2q77";
    version = openbsdVersion;
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook rsync
    ];
    #propagatedBuildInputs = with self; compatIfNeeded;
    extraPaths = with self; [
      (fetchOpenBSD "lib/libc/gen/fts.c" openbsdVersion "1a8hmf26242nmv05ipn3ircxb0jqmmi66rh78kkyi9vjwkfl3qn7")
      (fetchOpenBSD "lib/libc/include/namespace.h" openbsdVersion "0kksr3pdwdc1cplqf5z12ih4cml6l11lqrz91f7hjjm64y7785kc")
      (fetchOpenBSD "lib/libc/gen/fts.3" openbsdVersion "1asxw0n3fhjdadwkkq3xplfgqgl3q32w1lyrvbakfa3gs0wz5zc1")
    ];
    skipIncludesPhase = true;
    buildPhase = ''
      "$CC" -c -Iinclude -Ilib/libc/include lib/libc/gen/fts.c \
          -o lib/libc/gen/fts.o
      "$AR" -rsc libfts.a lib/libc/gen/fts.o
    '';
    installPhase = ''
      runHook preInstall

      install -D lib/libc/gen/fts.3 $out/share/man/man3/fts.3
      install -D include/fts.h $out/include/fts.h
      install -D lib/libc/include/namespace.h $out/include/namespace.h
      install -D libfts.a $out/lib/libfts.a

      runHook postInstall
    '';
    setupHooks = [
      ../../../build-support/setup-hooks/role.bash
      ./fts-setup-hook.sh
    ];
  };

  # Don't add this to nativeBuildInputs directly.  Use statHook instead.
  stat = mkDerivation {
    path = "usr.bin/stat";
    version = openbsdVersion;
    sha256 = "18nqwlndfc34qbbgqx5nffil37jfq9aw663ippasfxd2hlyc106x";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff rsync bmake
    ];
    buildPhase = ''
      ${bmake}/bin/bmake
      '';
  };

  # stat isn't in POSIX, and OpenBSD stat supports a completely
  # different range of flags than GNU stat, so including it in PATH
  # breaks stdenv.  Work around that with a hook that will point
  # OpenBSD's build system and OpenBSD stat without including it in
  # PATH.
  statHook = makeSetupHook {
    name = "openbsd-stat-hook";
  } (writeText "openbsd-stat-hook-impl" ''
    makeFlagsArray+=(TOOL_STAT=${self.stat}/bin/stat)
  '');

  tsort = mkDerivation {
    path = "usr.bin/tsort";
    version = openbsdVersion;
    sha256 = "1dqvf9gin29nnq3c4byxc7lfd062pg7m84843zdy6n0z63hnnwiq";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff rsync
    ];
  };

  lorder = mkDerivation {
    path = "usr.bin/lorder";
    version = openbsdVersion;
    sha256 = "0rjf9blihhm0n699vr2bg88m4yjhkbxh6fxliaay3wxkgnydjwn2";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff rsync
    ];
  };

  ##
  ## END BOOTSTRAPPING
  ##

  ##
  ## START COMMAND LINE TOOLS
  ##
  make = mkDerivation {
    path = "usr.bin/make";
    sha256 = "";
    version = openbsdVersion;

    buildInputs = with self; [ include ];

   postPatch = ''
     substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
       --replace '-o ''${LIBOWN}' "" \
       --replace '-g ''${LIBGRP}' "" \
       --replace '-o ''${DEBUGOWN}' "" \
       --replace '-g ''${DEBUGGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.man.mk \
       --replace '-o ''${MANOWN}' "" \
       --replace '-g ''${MANGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.prog.mk \
       --replace '-o ''${BINOWN}' "" \
       --replace '-g ''${BINGRP}' "" \
       --replace '-o ''${RUMPBINOWN}' "" \
       --replace '-g ''${RUMPBINGRP}' "" \
       --replace '-o ''${DEBUGOWN}' "" \
       --replace '-g ''${DEBUGGRP}' ""

      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

      substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
    '';

    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook rsync
    ];

    buildPhase = ''
      ${bmake}/bin/bmake
    '';

    postInstall = ''
      make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
    '';
    extraPaths = [
      (fetchOpenBSD "share/mk" openbsdVersion "0w9x77cfnm6zwy40slradzi0ip9gz80x6lk7pvnlxzsr2m5ra5sy")
    ];
  };

  mtree = mkDerivation {
    path = "usr.sbin/mtree";
    version = openbsdVersion;
    sha256 = "04p7w540vz9npvyb8g8hcf2xa05phn1y88hsyrcz3vwanvpc0yv9";
    extraPaths = with self; [ mknod.src ];
  };

  mknod = mkDerivation {
    path = "sbin/mknod";
    version = openbsdVersion;
    sha256 = "1d9369shzwgixz3nph991i8q5vk7hr04py3n9avbfbhzy4gndqs2";
  };

  getent = mkDerivation {
    path = "usr.bin/getent";
    sha256 = "1qngywcmm0y7nl8h3n8brvkxq4jw63szbci3kc1q6a6ndhycbbvr";
    version = openbsdVersion;
    patches = [ ./getent.patch ];
  };

  getconf = mkDerivation {
    path = "usr.bin/getconf";
    sha256 = "122vslz4j3h2mfs921nr2s6m078zcj697yrb75rwp2hnw3qz4s8q";
    version = openbsdVersion;
  };

  locale = mkDerivation {
    path = "usr.bin/locale";
    version = openbsdVersion;
    sha256 = "0kk6v9k2bygq0wf9gbinliqzqpzs9bgxn0ndyl2wcv3hh2bmsr9p";
    patches = [ ./locale.patch ];
    NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
  };

  rpcgen = mkDerivation {
    path = "usr.bin/rpcgen";
    version = openbsdVersion;
    sha256 = "1kfgfx54jg98wbg0d95p0rvf4w0302v8fz724b0bdackdsrd4988";
  };

  genassym = mkDerivation {
    path = "usr.bin/genassym";
    version = openbsdVersion;
    sha256 = "1acl1dz5kvh9h5806vkz2ap95rdsz7phmynh5i3x5y7agbki030c";
  };

  gencat = mkDerivation {
    path = "usr.bin/gencat";
    version = openbsdVersion;
    sha256 = "0gd463x1hg36bhr7y0xryb5jyxk0z0g7xvy8rgk82nlbnlnsbbwb";
  };

  tic = mkDerivation {
    path = "tools/tic";
    version = openbsdVersion;
    sha256 = "092y7db7k4kh2jq8qc55126r5qqvlb8lq8mhmy5ipbi36hwb4zrz";
    HOSTPROG = "tic";
    #buildInputs = with self; compatIfNeeded;
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff rsync
    ];
    makeFlags = defaultMakeFlags ++ [ "TOOLDIR=$(out)" ];
    extraPaths = with self; [
      libterminfo.src
      (fetchOpenBSD "usr.bin/tic" openbsdVersion "1mwdfg7yx1g43ss378qsgl5rqhsxskqvsd2mqvrn38qw54i8v5i1")
      (fetchOpenBSD "tools/Makefile.host" openbsdVersion "15b4ab0n36lqj00j5lz2xs83g7l8isk3wx1wcapbrn66qmzz2sxy")
    ];
  };

  uudecode = mkDerivation {
    path = "usr.bin/uudecode";
    version = openbsdVersion;
    sha256 = "00a3zmh15pg4vx6hz0kaa5mi8d2b1sj4h512d7p6wbvxq6mznwcn";
    NIX_CFLAGS_COMPILE = lib.optional stdenv.isLinux "-DNO_BASE64";
    NIX_LDFLAGS = lib.optional stdenv.isDarwin "-lresolv";
  };

  cksum = mkDerivation {
    path = "usr.bin/cksum";
    version = openbsdVersion;
    sha256 = "0msfhgyvh5c2jmc6qjnf12c378dhw32ffsl864qz4rdb2b98rfcq";
    meta.platforms = lib.platforms.openbsd;
  };

  config = mkDerivation {
    path = "usr.bin/config";
    version = openbsdVersion;
    sha256 = "1yz3n4hncdkk6kp595fh2q5lg150vpqg8iw2dccydkyw4y3hgsjj";
    NIX_CFLAGS_COMPILE = [ "-DMAKE_BOOTSTRAP" ];
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc byacc flex rsync
    ];
    #buildInputs = with self; compatIfNeeded;
    extraPaths = with self; [ cksum.src ];
  };
  ##
  ## END COMMAND LINE TOOLS
  ##

  ##
  ## START HEADERS
  ##
  includes = mkDerivation {
    path = "include";
    version = openbsdVersion;
    sha256 = "sha256-+N+0KJpXdWBGP2J5rfD2OgFR/8bihFwepQNNSBb5Dxo=";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      #mandoc groff rsync rpcgen
      bmake
    ];

    dontBuild = true;

    # The makefiles define INCSDIR per subdirectory, so we have to set
    # something else on the command line so those definitions aren't
    # overridden.
    postPatch = ''
      find "$BSDSRCDIR" -name Makefile -exec \
        sed -i -E \
          -e 's_/usr/include_''${INCSDIR0}_' \
          {} \;
    '';

    # multiple header dirs, see above
    postConfigure = ''
      makeFlags=''${makeFlags/INCSDIR/INCSDIR0}
    '';

    installPhase = ''
      runHook preInstall

      bmake includes

      runHook postInstall
    '';

    extraPaths = with self; [ ];
    headersOnly = true;
    noCC = true;
    meta.platforms = lib.platforms.openbsd;
    makeFlags = defaultMakeFlags;
  };

  sys-headers = mkDerivation {
    pname = "sys-headers";
    path = "sys";
    version = openbsdVersion;
    sha256 = "";

    # multiple header dirs, see above
    inherit (self.include) postPatch;

    CONFIG = "GENERIC";

    propagatedBuildInputs = with self; [ include ];
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      statHook rsync uudecode config genassym
    ];

    postConfigure = ''
      pushd arch/$MACHINE/conf
      config $CONFIG
      popd
    ''
      # multiple header dirs, see above
      + self.include.postConfigure;

    makeFlags = defaultMakeFlags ++ [ "FIRMWAREDIR=$(out)/libdata/firmware" ];
    hardeningDisable = [ "pic" ];
    MKKMOD = "no";
    NIX_CFLAGS_COMPILE = [ "-Wa,--no-warn" ];

    postBuild = ''
      make -C arch/$MACHINE/compile/$CONFIG $makeFlags
    '';

    postInstall = ''
      cp arch/$MACHINE/compile/$CONFIG/openbsd $out
    '';

    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ ];

    installPhase = "includesPhase";
    dontBuild = true;
    noCC = true;
  };

  # The full kernel. We do the funny thing of overridding the headers to the
  # full kernal and not vice versa to avoid infinite recursion -- the headers
  # come earlier in the bootstrap.
  sys = self.sys-headers.override {
    pname = "sys";
    installPhase = null;
    noCC = false;
    dontBuild = false;
  };

  headers = symlinkJoin {
    name = "openbsd-headers-7.2";
    paths = with self; [
      include
    ];
    meta.platforms = lib.platforms.openbsd;
  };
  ##
  ## END HEADERS
  ##

  ##
  ## START LIBRARIES
  ##
  libarch = mkDerivation {
    path = "lib/libarch";
    version = openbsdVersion;
    sha256 = "6ssenRhuSwp0Jn71ErT0PrEoCJ+cIYRztwdL4QTDZsQ=";
    meta.platforms = lib.platforms.openbsd;
  };

  libutil = mkDerivation {
    path = "lib/libutil";
    version = openbsdVersion;
    sha256 = "";
    extraPaths = with self; [ libc.src sys.src ];
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      byacc mandoc statHook rsync
    ];
    buildInputs = with self; [ headers ];
    SHLIBINSTALLDIR = "$(out)/lib";
  };

  libedit = mkDerivation {
    path = "lib/libedit";
    version = openbsdVersion;
    sha256 = "1wqhngraxwqk4jgrf5f18jy195yrp7c06n1gf31pbplq79mg1bcj";
    buildInputs = with self; [ libterminfo libcurses ];
    #propagatedBuildInputs = with self; compatIfNeeded;
    SHLIBINSTALLDIR = "$(out)/lib";
    makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${self.libterminfo}/lib" ];
    postPatch = ''
      sed -i '1i #undef bool_t' $COMPONENT_PATH/el.h
      substituteInPlace $COMPONENT_PATH/config.h \
        --replace "#define HAVE_STRUCT_DIRENT_D_NAMLEN 1" ""
      substituteInPlace $COMPONENT_PATH/readline/Makefile --replace /usr/include "$out/include"
    '';
    NIX_CFLAGS_COMPILE = [
      "-D__noinline="
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
    ];
  };

  libterminfo = mkDerivation {
    path = "lib/libterminfo";
    version = openbsdVersion;
    sha256 = "0pq05k3dj0dfsczv07frnnji92mazmy2qqngqbx2zgqc1x251414";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc statHook tic rsync
    ];
    #buildInputs = with self; compatIfNeeded;
    SHLIBINSTALLDIR = "$(out)/lib";
    postPatch = ''
      substituteInPlace $COMPONENT_PATH/term.c --replace /usr/share $out/share
      substituteInPlace $COMPONENT_PATH/setupterm.c \
        --replace '#include <curses.h>' 'void use_env(bool);'
    '';
    postBuild = ''
      make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share
    '';
    postInstall = ''
      make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share install
    '';
    extraPaths = with self; [
      (fetchOpenBSD "share/terminfo" openbsdVersion "1vh9rl4w8118a9qdpblfxmv1wkpm83rm9gb4rzz5bpm56i6d7kk7")
    ];
  };

  libcurses = mkDerivation {
    path = "lib/libcurses";
    version = openbsdVersion;
    sha256 = "0pd0dggl3w4bv5i5h0s1wrc8hr66n4hkv3zlklarwfdhc692fqal";
    buildInputs = with self; [ libterminfo ];
    NIX_CFLAGS_COMPILE = [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ] ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)=";
    #propagatedBuildInputs = with self; compatIfNeeded;
    MKDOC = "no"; # missing vfontedpr
    makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${self.libterminfo}/lib" ];
    postPatch = lib.optionalString (!stdenv.isDarwin) ''
      substituteInPlace $COMPONENT_PATH/printw.c \
        --replace "funopen(win, NULL, __winwrite, NULL, NULL)" NULL \
        --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
      substituteInPlace $COMPONENT_PATH/scanw.c \
        --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
    '';
  };

  column = mkDerivation {
    path = "usr.bin/column";
    version = openbsdVersion;
    sha256 = "0r6b0hjn5ls3j3sv6chibs44fs32yyk2cg8kh70kb4cwajs4ifyl";
  };

  libossaudio = mkDerivation {
    path = "lib/libossaudio";
    version = openbsdVersion;
    sha256 = "16l3bfy6dcwqnklvh3x0ps8ld1y504vf57v9rx8f9adzhb797jh0";
    meta.platforms = lib.platforms.openbsd;
  };

  librpcsvc = mkDerivation {
    path = "lib/librpcsvc";
    version = openbsdVersion;
    sha256 = "1q34pfiyjbrgrdqm46jwrsqms49ly6z3b0xh1wg331zga900vq5n";
    makeFlags = defaultMakeFlags ++ [ "INCSDIR=$(out)/include/rpcsvc" ];
    meta.platforms = lib.platforms.openbsd;
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      rpcgen statHook
    ];
  };

  librt = mkDerivation {
    path = "lib/librt";
    version = openbsdVersion;
    sha256 = "07f8mpjcqh5kig5z5sp97fg55mc4dz6aa1x5g01nv2pvbmqczxc6";
    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ libc.src ] ++ libc.extraPaths;
    postPatch = ''
      sed -i 's,/usr\(/include/sys/syscall.h\),${self.headers}\1,g' \
        $BSDSRCDIR/lib/{libc,librt}/sys/Makefile.inc
    '';
  };

  libcrypt = mkDerivation {
    path = "lib/libcrypt";
    version = openbsdVersion;
    sha256 = "0siqan1wdqmmhchh2n8w6a8x1abbff8n4yb6jrqxap3hqn8ay54g";
    SHLIBINSTALLDIR = "$(out)/lib";
    meta.platforms = lib.platforms.openbsd;
  };

  libpci = mkDerivation {
    pname = "libpci";
    path = "lib/libpci";
    version = openbsdVersion;
    sha256 = "+IOEO1Bw3/H3iCp3uk3bwsFZbvCqN5Ciz70irnPl8E8=";
    NIX_CFLAGS_COMPILE = [ "-I." ];
    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ sys.src ];
  };

  libpthread-headers = mkDerivation {
    pname = "libpthread-headers";
    path = "lib/libpthread";
    version = openbsdVersion;
    sha256 = "";
    installPhase = "includesPhase";
    dontBuild = true;
    noCC = true;
    meta.platforms = lib.platforms.openbsd;
  };

  libpthread = self.libpthread-headers.override {
    pname = "libpthread";
    installPhase = null;
    noCC = false;
    dontBuild = false;
    buildInputs = with self; [ headers ];
    SHLIBINSTALLDIR = "$(out)/lib";
    extraPaths = with self; [ libc.src librt.src sys.src ];
  };

  libresolv = mkDerivation {
    path = "lib/libresolv";
    version = openbsdVersion;
    sha256 = "1am74s74mf1ynwz3p4ncjkg63f78a1zjm983q166x4sgzps15626";
    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ libc.src ];
  };

  libm = mkDerivation {
    path = "lib/libm";
    version = openbsdVersion;
    sha256 = "1apwfr26shdmbqqnmg7hxf7bkfxw44ynqnnnghrww9bnhqdnsy92";
    SHLIBINSTALLDIR = "$(out)/lib";
    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ sys.src ];
  };

  i18n_module = mkDerivation {
    path = "lib/i18n_module";
    version = openbsdVersion;
    sha256 = "0w6y5v3binm7gf2kn7y9jja8k18rhnyl55cvvfnfipjqdxvxd9jd";
    meta.platforms = lib.platforms.openbsd;
    extraPaths = with self; [ libc.src ];
  };

  csu = mkDerivation {
    path = "lib/csu";
    version = openbsdVersion;
    sha256 = "0al5jfazvhlzn9hvmnrbchx4d0gm282hq5gp4xs2zmj9ycmf6d03";
    meta.platforms = lib.platforms.openbsd;
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff flex
      byacc genassym gencat statHook rsync
    ];
    buildInputs = with self; [ headers ];
    extraPaths = with self; [ sys.src ld_elf_so.src ];
  };

  ld_elf_so = mkDerivation {
    path  = "libexec/ld.elf_so";
    version = openbsdVersion;
    sha256 = "0ia9mqzdljly0vqfwflm5mzz55k7qsr4rw2bzhivky6k30vgirqa";
    meta.platforms = lib.platforms.openbsd;
    LIBC_PIC = "${self.libc}/lib/libc_pic.a";
    # Hack to prevent a symlink being installed here for compatibility.
    SHLINKINSTALLDIR = "/usr/libexec";
    USE_FORT = "yes";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/libexec" "CLIBOBJ=${self.libc}/lib" ];
    extraPaths = with self; [ libc.src ] ++ libc.extraPaths;
  };

  _mainLibcExtraPaths = with self; [
      i18n_module.src sys.src
      ld_elf_so.src libpthread.src libm.src libresolv.src
      librpcsvc.src libutil.src librt.src libcrypt.src
  ];

  libc = mkDerivation {
    path = "lib/libc";
    version = openbsdVersion;
    sha256 = "";
    USE_FORT = "yes";
    MKPROFILE = "no";
    nativeBuildInputs = with buildPackages.openbsd; [
      bsdSetupHook openbsdSetupHook
      mandoc groff flex
      byacc genassym gencat statHook rsync rpcgen
    ];
    buildInputs = with self; [ headers csu ];
    NIX_CFLAGS_COMPILE = "-B${self.csu}/lib -fcommon";
    meta.platforms = lib.platforms.openbsd;
    SHLIBINSTALLDIR = "$(out)/lib";
    MKPICINSTALL = "yes";
    NLSDIR = "$(out)/share/nls";
    makeFlags = defaultMakeFlags ++ [ "FILESDIR=$(out)/var/db"];
    postInstall = ''
      pushd ${self.headers}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      pushd ${self.csu}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      NIX_CFLAGS_COMPILE+=" -B$out/lib"
      NIX_CFLAGS_COMPILE+=" -I$out/include"
      NIX_LDFLAGS+=" -L$out/lib"

      make -C $BSDSRCDIR/lib/libpthread $makeFlags
      make -C $BSDSRCDIR/lib/libpthread $makeFlags install

      make -C $BSDSRCDIR/lib/libm $makeFlags
      make -C $BSDSRCDIR/lib/libm $makeFlags install

      make -C $BSDSRCDIR/lib/libresolv $makeFlags
      make -C $BSDSRCDIR/lib/libresolv $makeFlags install

      make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
      make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install

      make -C $BSDSRCDIR/lib/i18n_module $makeFlags
      make -C $BSDSRCDIR/lib/i18n_module $makeFlags install

      make -C $BSDSRCDIR/lib/libutil $makeFlags
      make -C $BSDSRCDIR/lib/libutil $makeFlags install

      make -C $BSDSRCDIR/lib/librt $makeFlags
      make -C $BSDSRCDIR/lib/librt $makeFlags install

      make -C $BSDSRCDIR/lib/libcrypt $makeFlags
      make -C $BSDSRCDIR/lib/libcrypt $makeFlags install
    '';
    inherit (self.librt) postPatch;
  };
  #
  # END LIBRARIES
  #

  #
  # START MISCELLANEOUS
  #
  dict = mkDerivation {
    path = "share/dict";
    noCC = true;
    version = openbsdVersion;
    sha256 = "0svfc0byk59ri37pyjslv4c4rc7zw396r73mr593i78d39q5g3ad";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
  };

  misc = mkDerivation {
    path = "share/misc";
    noCC = true;
    version = openbsdVersion;
    sha256 = "1j2cdssdx6nncv8ffj7f7ybl7m9hadjj8vm8611skqdvxnjg6nbc";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
  };

  man = mkDerivation {
    path = "share/man";
    noCC = true;
    version = openbsdVersion;
    sha256 = "1l4lmj4kmg8dl86x94sr45w0xdnkz8dn4zjx0ipgr9bnq98663zl";
    # man0 generates a man.pdf using ps2pdf, but doesn't install it later,
    # so we can avoid the dependency on ghostscript
    postPatch = ''
      substituteInPlace $COMPONENT_PATH/man0/Makefile --replace "ps2pdf" "echo noop "
    '';
    makeFlags = defaultMakeFlags ++ [
      "FILESDIR=$(out)/share"
      "MKRUMP=no" # would require to have additional path sys/rump/share/man
    ];
  };
  #
  # END MISCELLANEOUS
  #

})
