{ stdenv, lib, stdenvNoCC
, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget, pkgsHostHost, pkgsTargetTarget
, buildPackages, splicePackages, newScope
, bsdSetupHook, makeSetupHook, fetchcvs, groff, mandoc, byacc, flex
, zlib
, writeText, symlinkJoin
}:

let
  inherit (buildPackages.buildPackages) rsync;

  fetchNetBSD = path: version: sha256: fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/${path}";
    inherit sha256;
    tag = "netbsd-${lib.replaceStrings ["."] ["-"] version}-RELEASE";
  };

  netbsdSetupHook = makeSetupHook {
    name = "netbsd-setup-hook";
  } ./setup-hook.sh;

  otherSplices = {
    selfBuildBuild = pkgsBuildBuild.netbsd;
    selfBuildHost = pkgsBuildHost.netbsd;
    selfBuildTarget = pkgsBuildTarget.netbsd;
    selfHostHost = pkgsHostHost.netbsd;
    selfTargetTarget = pkgsTargetTarget.netbsd or {}; # might be missing
  };

  defaultMakeFlags = [
    "MKSOFTFLOAT=${if stdenv.hostPlatform.gcc.float or (stdenv.hostPlatform.parsed.abi.float or "hard") == "soft"
      then "yes"
      else "no"}"
  ];

in lib.makeScopeWithSplicing
  splicePackages
  newScope
  otherSplices
  (_: {})
  (_: {})
  (self: let
    inherit (self) mkDerivation;
  in {

  # Why do we have splicing and yet do `nativeBuildInputs = with self; ...`?
  #
  # We use `lib.makeScopeWithSplicing` because this should be used for all
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

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isNetBSD) self.compat;

  mkDerivation = lib.makeOverridable (attrs: let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in stdenv'.mkDerivation ({
    name = "${attrs.pname or (baseNameOf attrs.path)}-netbsd-${attrs.version}";
    src = fetchNetBSD attrs.path attrs.version attrs.sha256;

    extraPaths = [ ];

    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install tsort lorder buildPackages.mandoc groff statHook rsync
    ];
    buildInputs = with self; compatIfNeeded;

    HOST_SH = stdenv'.shell;

    MACHINE_ARCH = {
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    MACHINE = {
      x86_64 = "amd64";
      aarch64 = "evbarm64";
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    BSD_PATH = attrs.path;

    makeFlags = defaultMakeFlags;

    strictDeps = true;

    meta = with lib; {
      maintainers = with maintainers; [ matthewbauer qyliss ];
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
  } // attrs // {
    postPatch = lib.optionalString (!stdenv'.hostPlatform.isNetBSD) ''
      # Files that use NetBSD-specific macros need to have nbtool_config.h
      # included ahead of them on non-NetBSD platforms.
      set +e
      grep -Zlr "^__RCSID
      ^__BEGIN_DECLS" | xargs -0r grep -FLZ nbtool_config.h |
          xargs -0tr sed -i '0,/^#/s//#include <nbtool_config.h>\n\0/'
      set -e
    '' + attrs.postPatch or "";
  }));

  ##
  ## START BOOTSTRAPPING
  ##
  makeMinimal = mkDerivation {
    path = "tools/make";
    sha256 = "sha256-FqS5OLNxmEmkhhEwiEPZkTWvBI4001XqCKaiMG22ADo=";
    version = "9.3";

    buildInputs = with self; [];
    nativeBuildInputs = with buildPackages.netbsd; [ bsdSetupHook netbsdSetupHook rsync ];

    skipIncludesPhase = true;

    postPatch = ''
      patchShebangs configure
      ${self.make.postPatch}
    '';

    buildPhase = ''
      runHook preBuild

      sh ./buildmake.sh

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -D nbmake $out/bin/nbmake
      ln -s $out/bin/nbmake $out/bin/make
      mkdir -p $out/share
      cp -r $BSDSRCDIR/share/mk $out/share/mk

      runHook postInstall
    '';

    extraPaths = with self; [ make.src ] ++ make.extraPaths;
  };

  compat = mkDerivation (let
    version = "9.3";
    commonDeps = [ zlib ];
  in {
    path = "tools/compat";
    sha256 = "wHo2/rCZoabrtCUpGg/s5CAh9CbGqLvFYZBaM8J5Xe8=";
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

    nativeBuildInputs = with buildPackages.netbsd; commonDeps ++ [
      bsdSetupHook netbsdSetupHook
      makeMinimal
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

    passthru.tests = { netbsd-install = self.install; };

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
      # why aren't these installed by netbsd?
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
      (fetchNetBSD "external/bsd/flex" "9.3" "dZA9wu79+fdTMxKpU85i8/0KwzJznbYP/KXvI92VKEE=")
      (fetchNetBSD "sys/sys" "9.3" "pgo1/fHIrYGC7/zHZ6SDJLcsEiPs/fR3rRHJI7CXZxo=")
      (fetchNetBSD "common/include/rpc/types.h" "9.3" "KtXDFGwZJQSdlcfv6e+D7/hAvy8Dd4kIW2wwWkVwTVg=")
    ] ++ libutil.extraPaths ++ _mainLibcExtraPaths;
  });

  # HACK: to ensure parent directories exist. This emulates GNU
  # install’s -D option. No alternative seems to exist in BSD install.
  install = let binstall = writeText "binstall" ''
    #!${stdenv.shell}
    for last in $@; do true; done
    mkdir -p $(dirname $last)
    xinstall "$@"
  ''; in mkDerivation {
    path = "usr.bin/xinstall";
    version = "9.3";
    sha256 = "sha256-ErtV2laEejaahiUYbNNClNu6aLnIxd4gywyHjcdf17g=";
    extraPaths = with self; [ mtree.src make.src ];
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      mandoc groff rsync
    ];
    skipIncludesPhase = true;
    buildInputs = with self; compatIfNeeded ++ [ fts ];
    installPhase = ''
      runHook preInstall

      install -D install.1 $out/share/man/man1/install.1
      install -D xinstall $out/bin/xinstall
      install -D -m 0550 ${binstall} $out/bin/binstall
      ln -s $out/bin/binstall $out/bin/install

      runHook postInstall
    '';
    setupHook = ./install-setup-hook.sh;
  };

  fts = mkDerivation {
    pname = "fts";
    path = "include/fts.h";
    sha256 = "sha256-52AhoWEzsQ7agKE6zfhvD3RQWSvf/l6m+++Gv/t1pAU=";
    version = "9.3";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook rsync
    ];
    propagatedBuildInputs = with self; compatIfNeeded;
    extraPaths = with self; [
      (fetchNetBSD "lib/libc/gen/fts.c" "9.3" "x+JB3eRyp+jnRAdmY2KtWILVWY7D3ljArlYQYYSrEKk=")
      (fetchNetBSD "lib/libc/include/namespace.h" "9.3" "bBZ0jiemSgmPC+lnTEOghlZGYBThF4fpZYE13u7Iek4=")
      (fetchNetBSD "lib/libc/gen/fts.3" "9.3" "gf3yOdBvKDfV2tnTwMXAgz78HL194Dl5U01CNyzgXas=")
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
    version = "9.3";
    sha256 = "sha256-3YDAPIWidafVvXEYw1XCTp5Bo3O2dPzWwmQw1yzl2KI=";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff rsync
    ];
  };

  # stat isn't in POSIX, and NetBSD stat supports a completely
  # different range of flags than GNU stat, so including it in PATH
  # breaks stdenv.  Work around that with a hook that will point
  # NetBSD's build system and NetBSD stat without including it in
  # PATH.
  statHook = makeSetupHook {
    name = "netbsd-stat-hook";
  } (writeText "netbsd-stat-hook-impl" ''
    makeFlagsArray+=(TOOL_STAT=${self.stat}/bin/stat)
  '');

  tsort = mkDerivation {
    path = "usr.bin/tsort";
    version = "9.3";
    sha256 = "OHJr4TAfWOPbHwQRVM+7woDm6GHdL8IGtjYJG19yG7c=";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff rsync
    ];
  };

  lorder = mkDerivation {
    path = "usr.bin/lorder";
    version = "9.3";
    sha256 = "sha256-wnLZvH2z8+GVirQ7A/uaUHpSEXpL5J2SsaBCGOlKTmY=";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff rsync
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
    sha256 = "sha256-mjE6kXt+BjYO7Od4OJUs9ZvO0klt44+FKHfVxaIfJ24=";
    version = "9.3";

   postPatch = ''
     substituteInPlace $BSDSRCDIR/share/mk/bsd.doc.mk \
       --replace '-o ''${DOCOWN}' "" \
       --replace '-g ''${DOCGRP}' ""
     for mk in $BSDSRCDIR/share/mk/bsd.inc.mk $BSDSRCDIR/share/mk/bsd.kinc.mk; do
       substituteInPlace $mk \
         --replace '-o ''${BINOWN}' "" \
         --replace '-g ''${BINGRP}' ""
     done
     substituteInPlace $BSDSRCDIR/share/mk/bsd.kmodule.mk \
       --replace '-o ''${KMODULEOWN}' "" \
       --replace '-g ''${KMODULEGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
       --replace '-o ''${LIBOWN}' "" \
       --replace '-g ''${LIBGRP}' "" \
       --replace '-o ''${DEBUGOWN}' "" \
       --replace '-g ''${DEBUGGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.lua.mk \
       --replace '-o ''${LIBOWN}' "" \
       --replace '-g ''${LIBGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.man.mk \
       --replace '-o ''${MANOWN}' "" \
       --replace '-g ''${MANGRP}' ""
     substituteInPlace $BSDSRCDIR/share/mk/bsd.nls.mk \
       --replace '-o ''${NLSOWN}' "" \
       --replace '-g ''${NLSGRP}' ""
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
      substituteInPlace $BSDSRCDIR/share/mk/bsd.kinc.mk \
        --replace /bin/rm rm
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
    '';
    postInstall = ''
      make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
    '';
    extraPaths = [
      (fetchNetBSD "share/mk" "9.3" "XheVSxVZ/07tvmdS0wH6L90I4m8qUw2I599U69g5PXE=")
    ];
  };

  mtree = mkDerivation {
    path = "usr.sbin/mtree";
    version = "9.3";
    sha256 = "aXvA7raK7/FZ9hoi5IOFtwDVhWMQPbT8vjb9DUjh5xI=";
    extraPaths = with self; [ mknod.src ];
  };

  mknod = mkDerivation {
    path = "sbin/mknod";
    version = "9.3";
    sha256 = "QuNmH/EfLre2Snb4S0CGZ+6CUQwpwWvH7/HxD3UyI7U=";
  };

  getent = mkDerivation {
    path = "usr.bin/getent";
    sha256 = "ea/FPGzWKIMDmyOy9fUwXBLc584L2QERtceDWhn3z+I=";
    version = "9.3";
    patches = [ ./getent.patch ];
  };

  getconf = mkDerivation {
    path = "usr.bin/getconf";
    sha256 = "GGny8eAWistzOSv7k4xkHx1QjRbZBpG0qwIOST7VW4g=";
    version = "9.3";
  };

  locale = mkDerivation {
    path = "usr.bin/locale";
    version = "9.3";
    sha256 = "N2Vdl4BwbMYF9c0C299K+l/8caQ2rpccB/j5JWbaZk4=";
    patches = [ ./locale.patch ];
    NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
  };

  rpcgen = mkDerivation {
    path = "usr.bin/rpcgen";
    version = "9.3";
    sha256 = "CCXSsm6TqbbAIuJ8h7YAA3Didga3pAbe4ig9SUp3z80=";
  };

  genassym = mkDerivation {
    path = "usr.bin/genassym";
    version = "9.3";
    sha256 = "DAwQ53rq+NJHLND6Cu/5uuWSrhJ/bgNQgQnuWX4LlKk=";
  };

  gencat = mkDerivation {
    path = "usr.bin/gencat";
    version = "9.3";
    sha256 = "i6+lLbWLWoHmy8jvfh74YHYvy/K5A38yXGY8GPowpD0=";
  };

  nbperf = mkDerivation {
    path = "usr.bin/nbperf";
    version = "9.3";
    sha256 = "OalaU6DZZ5bJ0YRova7c4GWqv/N4x4b9qFDWtwUYrNs=";
  };

  tic = mkDerivation {
    path = "tools/tic";
    version = "9.3";
    sha256 = "P3+yODQjrhuLr7AiTNGiG+OSjQilMIywFHCSeVY7XiQ=";
    HOSTPROG = "tic";
    buildInputs = with self; compatIfNeeded;
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff nbperf rsync
    ];
    makeFlags = defaultMakeFlags ++ [ "TOOLDIR=$(out)" ];
    extraPaths = with self; [
      libterminfo.src
      (fetchNetBSD "usr.bin/tic" "9.3" "IZaNIikco2HzxlU0vfHUXUOcC30aozO0HuSF7s9zjdc=")
      (fetchNetBSD "tools/Makefile.host" "9.3" "vmvxf8XG2LyuYjx0PqaOiJ43kO7i0yIBkJiaYcFSZJU=")
    ];
  };

  uudecode = mkDerivation {
    path = "usr.bin/uudecode";
    version = "9.3";
    sha256 = "lnH7q8F9L27uaSIUSKQOSzQUa1Fqgg9N3+TdEmD9QwE=";
    NIX_CFLAGS_COMPILE = lib.optional stdenv.isLinux "-DNO_BASE64";
  };

  cksum = mkDerivation {
    path = "usr.bin/cksum";
    version = "9.3";
    sha256 = "mLmM0hKrZfIxMYhq58TgsKEzmAjOSmxYlYIVuP2DTlc=";
    meta.platforms = lib.platforms.netbsd;
  };

  config = mkDerivation {
    path = "usr.bin/config";
    version = "9.3";
    sha256 = "UuoHhyfcz+YZa4JH9PDdoIRHCxbQlVTuNHM2ZiGx4/s=";
    NIX_CFLAGS_COMPILE = [ "-DMAKE_BOOTSTRAP" ];
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal install mandoc byacc flex rsync
    ];
    buildInputs = with self; compatIfNeeded;
    extraPaths = with self; [ cksum.src ];
  };
  ##
  ## END COMMAND LINE TOOLS
  ##

  ##
  ## START HEADERS
  ##
  include = mkDerivation {
    path = "include";
    version = "9.3";
    sha256 = "ATJXf7gbILIIDpRQQf8rj0upeB5dS5kSZjrOZYNj6ZU=";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff rsync nbperf rpcgen
    ];

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

    extraPaths = with self; [ common ];
    headersOnly = true;
    noCC = true;
    meta.platforms = lib.platforms.netbsd;
    makeFlags = defaultMakeFlags ++ [ "RPCGEN_CPP=${buildPackages.stdenv.cc.cc}/bin/cpp" ];
  };

  common = fetchNetBSD "common" "9.3" "jxOJQHvWv0qGuQ3omogh6ZUkLw9OVufSJp6fYIIi4Ts=";

  sys-headers = mkDerivation {
    pname = "sys-headers";
    path = "sys";
    version = "9.3";
    sha256 = "lzpJvMVPamMwxw7LIEpUuXfkOkZXtifukfBIaD1Ry6k=";

    patches = [
      # Fix this error when building bootia32.efi and bootx64.efi:
      # error: PHDR segment not covered by LOAD segment
      ./no-dynamic-linker.patch

      # multiple header dirs, see above
      ./sys-headers-incsdir.patch
    ];

    # multiple header dirs, see above
    inherit (self.include) postPatch;

    CONFIG = "GENERIC";

    propagatedBuildInputs = with self; [ include ];
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal install tsort lorder statHook rsync uudecode config genassym
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
      cp arch/$MACHINE/compile/$CONFIG/netbsd $out
    '';

    meta.platforms = lib.platforms.netbsd;
    extraPaths = with self; [ common ];

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
    name = "netbsd-headers-9.3";
    paths = with self; [
      include
      sys-headers
      libpthread-headers
    ];
    meta.platforms = lib.platforms.netbsd;
  };
  ##
  ## END HEADERS
  ##

  ##
  ## START LIBRARIES
  ##
  libutil = mkDerivation {
    path = "lib/libutil";
    version = "9.3";
    sha256 = "/+DVq/nZ7gC5s/oxC2LIEZRuOuonF1xyuRhB+Isq9Qk=";
    extraPaths = with self; [ common libc.src sys.src ];
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      byacc install tsort lorder mandoc statHook rsync
    ];
    buildInputs = with self; [ headers ];
    SHLIBINSTALLDIR = "$(out)/lib";
  };

  libedit = mkDerivation {
    path = "lib/libedit";
    version = "9.3";
    sha256 = "kq3wajqY3nXDcC9YA9i52ZcUvETBFZefJBPzrvKzEPM=";
    buildInputs = with self; [ libterminfo libcurses ];
    propagatedBuildInputs = with self; compatIfNeeded;
    SHLIBINSTALLDIR = "$(out)/lib";
    makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${self.libterminfo}/lib" ];
    postPatch = ''
      sed -i '1i #undef bool_t' el.h
      substituteInPlace config.h \
        --replace "#define HAVE_STRUCT_DIRENT_D_NAMLEN 1" ""
      substituteInPlace readline/Makefile --replace /usr/include "$out/include"
    '';
    NIX_CFLAGS_COMPILE = [
      "-D__noinline="
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
    ];
  };

  libterminfo = mkDerivation {
    path = "lib/libterminfo";
    version = "9.3";
    sha256 = "JJBQRA8Mvy/6ws9iLHz9qooUpbXZHbA/064B2cYsAF8=";
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal install tsort lorder mandoc statHook nbperf tic rsync
    ];
    buildInputs = with self; compatIfNeeded;
    SHLIBINSTALLDIR = "$(out)/lib";
    postPatch = ''
      substituteInPlace term.c --replace /usr/share $out/share
      substituteInPlace setupterm.c \
        --replace '#include <curses.h>' 'void use_env(bool);'
    '';
    postBuild = ''
      make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share
    '';
    postInstall = ''
      make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share install
    '';
    extraPaths = with self; [
      (fetchNetBSD "share/terminfo" "9.3" "Z87TTDSl3lX+z2S9VPNA9U4edu2OrttwUigExAnNCe4=")
    ];
  };

  libcurses = mkDerivation {
    path = "lib/libcurses";
    version = "9.3";
    sha256 = "VGEnkmGwOZ4VnfSPPSGxxmSIWOZBA1hi2YvwQd9roF0=";
    buildInputs = with self; [ libterminfo ];
    NIX_CFLAGS_COMPILE = [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ] ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)=";
    propagatedBuildInputs = with self; compatIfNeeded;
    MKDOC = "no"; # missing vfontedpr
    makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${self.libterminfo}/lib" ];
    postPatch = lib.optionalString (!stdenv.isDarwin) ''
      substituteInPlace printw.c \
        --replace "funopen(win, NULL, __winwrite, NULL, NULL)" NULL \
        --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
      substituteInPlace scanw.c \
        --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
    '';
  };

  column = mkDerivation {
    path = "usr.bin/column";
    version = "9.3";
    sha256 = "1LtItFSckTXBgRM9Jqb3YmhHiF4RMrP1kEPTYiUEy2Q=";
  };

  libossaudio = mkDerivation {
    path = "lib/libossaudio";
    version = "9.3";
    sha256 = "AMqTzoK/qeRQz2mf4jYBxYdGkb6gD7jptJizZrxbg5o=";
    meta.platforms = lib.platforms.netbsd;
  };

  librpcsvc = mkDerivation {
    path = "lib/librpcsvc";
    version = "9.3";
    sha256 = "tuANQFLvhzEeD7CDNb7xNBFdsc5cGlJxyy8v6aO7ZOA=";
    makeFlags = defaultMakeFlags ++ [ "INCSDIR=$(out)/include/rpcsvc" ];
    meta.platforms = lib.platforms.netbsd;
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install tsort lorder rpcgen statHook
    ];
  };

  librt = mkDerivation {
    path = "lib/librt";
    version = "9.3";
    sha256 = "hvXPcF37im0DeKUHpcxvhNVSnjvp6vLLi7NAzOStyB0=";
    meta.platforms = lib.platforms.netbsd;
    extraPaths = with self; [ libc.src ] ++ libc.extraPaths;
    postPatch = ''
      sed -i 's,/usr\(/include/sys/syscall.h\),${self.headers}\1,g' \
        $BSDSRCDIR/lib/{libc,librt}/sys/Makefile.inc
    '';
  };

  libcrypt = mkDerivation {
    path = "lib/libcrypt";
    version = "9.3";
    sha256 = "YQQgWEh291pRvVsoOqtf8kIgZKtM9ILef0TQEknBr/w=";
    SHLIBINSTALLDIR = "$(out)/lib";
    meta.platforms = lib.platforms.netbsd;
  };

  libpthread-headers = mkDerivation {
    pname = "libpthread-headers";
    path = "lib/libpthread";
    version = "9.3";
    sha256 = "Z1x3Xev0syS/sWDEJS71ed4g0UAXwU+EEtqD0/PL/H4=";
    installPhase = "includesPhase";
    dontBuild = true;
    noCC = true;
    meta.platforms = lib.platforms.netbsd;
  };

  libpthread = self.libpthread-headers.override {
    pname = "libpthread";
    installPhase = null;
    noCC = false;
    dontBuild = false;
    buildInputs = with self; [ headers ];
    SHLIBINSTALLDIR = "$(out)/lib";
    extraPaths = with self; [ common libc.src librt.src sys.src ];
  };

  libresolv = mkDerivation {
    path = "lib/libresolv";
    version = "9.3";
    sha256 = "RpgS9P1Pk25MwAOlKn9Q6Lhh3pTMkjs+tz64So4mp6o=";
    meta.platforms = lib.platforms.netbsd;
    extraPaths = with self; [ libc.src ];
  };

  libm = mkDerivation {
    path = "lib/libm";
    version = "9.3";
    sha256 = "8l6n2y2Qy/vubyr1GBFHjE+bSiGtbEVBmARacE0yvHc=";
    SHLIBINSTALLDIR = "$(out)/lib";
    meta.platforms = lib.platforms.netbsd;
    extraPaths = with self; [ sys.src ];
  };

  i18n_module = mkDerivation {
    path = "lib/i18n_module";
    version = "9.3";
    sha256 = "TabWd29Y3uis25uVQr2FGYWJlJTJHzuFe6fauMYu3nA=";
    meta.platforms = lib.platforms.netbsd;
    extraPaths = with self; [ libc.src ];
  };

  csu = mkDerivation {
    path = "lib/csu";
    version = "9.3";
    sha256 = "AzTjKvNJ1i90J/cVDAUS9YFGOmQr27phsp/C/ZWThSo=";
    meta.platforms = lib.platforms.netbsd;
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff flex
      byacc genassym gencat lorder tsort statHook rsync
    ];
    buildInputs = with self; [ headers ];
    extraPaths = with self; [ sys.src ld_elf_so.src ];
  };

  ld_elf_so = mkDerivation {
    path  = "libexec/ld.elf_so";
    version = "9.3";
    sha256 = "sha256-oEearm4RFw/SJNoyOwumAxhZQ7gH1CqYk4G25zUxjLA=";
    meta.platforms = lib.platforms.netbsd;
    LIBC_PIC = "${self.libc}/lib/libc_pic.a";
    # Hack to prevent a symlink being installed here for compatibility.
    SHLINKINSTALLDIR = "/usr/libexec";
    USE_FORT = "yes";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/libexec" "CLIBOBJ=${self.libc}/lib" ];
    extraPaths = with self; [ libc.src ] ++ libc.extraPaths;
  };

  _mainLibcExtraPaths = with self; [
      common i18n_module.src sys.src
      ld_elf_so.src libpthread.src libm.src libresolv.src
      librpcsvc.src libutil.src librt.src libcrypt.src
  ];

  libc = mkDerivation {
    path = "lib/libc";
    version = "9.3";
    sha256 = "NpfH0giJRLSNtppv2/G8xTrzb2OBU1ebq1/ErKr0K18=";
    USE_FORT = "yes";
    MKPROFILE = "no";
    extraPaths = with self; _mainLibcExtraPaths ++ [
      (fetchNetBSD "external/bsd/jemalloc" "9.3" "ayI7uhy9q6MdLnjAfs9Mc8XOqfjpsEd29wICxTUBBzM=")
    ];
    nativeBuildInputs = with buildPackages.netbsd; [
      bsdSetupHook netbsdSetupHook
      makeMinimal
      install mandoc groff flex
      byacc genassym gencat lorder tsort statHook rsync rpcgen
    ];
    buildInputs = with self; [ headers csu ];
    NIX_CFLAGS_COMPILE = "-B${self.csu}/lib";
    meta.platforms = lib.platforms.netbsd;
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
    version = "9.3";
    sha256 = "TY1XcBoNnThSyXWcbNLg/7BMGNlUS3/PiDmV6Rdgbms=";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
  };

  misc = mkDerivation {
    path = "share/misc";
    noCC = true;
    version = "9.3";
    sha256 = "bFnzpO274alDMKhuJGVTMNVDlz/uSOfQZtaa3rRuTMg=";
    makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
  };

  man = mkDerivation {
    path = "share/man";
    noCC = true;
    version = "9.3";
    sha256 = "nkcvtauvx7wz5ORxdTHtCZJoutkK/FEv6PMSHu/V+TI=";
    # man0 generates a man.pdf using ps2pdf, but doesn't install it later,
    # so we can avoid the dependency on ghostscript
    postPatch = ''
      substituteInPlace man0/Makefile --replace "ps2pdf" "echo noop "
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
