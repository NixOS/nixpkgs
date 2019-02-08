{ stdenv, fetchcvs, lib, groff, mandoc, zlib, buildPackages
, yacc, flex, libressl, bash, less, writeText }:

let
  inherit (lib) optionalString replaceStrings;
  inherit (stdenv) hostPlatform;

  fetchNetBSD = path: version: sha256: fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/${path}";
    inherit sha256;
    tag = "netbsd-${builtins.replaceStrings ["."] ["-"] version}-RELEASE";
  };

  # Needed to support cross correctly. Splicing only happens when we
  # do callPackage, but sense everything is here, it needs to be done
  # by hand. All native build inputs should come from here.
  nbBuildPackages = buildPackages.netbsd;

  MACHINE_ARCH = {
    "i686" = "i386";
  }.${hostPlatform.parsed.cpu.name} or hostPlatform.parsed.cpu.name;

  MACHINE = {
    "x86_64" = "amd64";
    "aarch64" = "evbarm64";
    "i686" = "i386";
  }.${hostPlatform.parsed.cpu.name} or hostPlatform.parsed.cpu.name;

  netBSDDerivation = attrs: stdenv.mkDerivation ((rec {
    name = "netbsd-${attrs.pname or (baseNameOf attrs.path)}-${attrs.version}";
    src = attrs.src or fetchNetBSD attrs.path attrs.version attrs.sha256;

    extraPaths = [ ];
    setOutputFlags = false;

    nativeBuildInputs = [ yacc flex mandoc groff
                          nbBuildPackages.makeMinimal
                          nbBuildPackages.stat
                          nbBuildPackages.install
                          nbBuildPackages.tsort
                          nbBuildPackages.lorder ];
    buildInputs = [ nbPackages.compat ];
    installFlags = [ "includes" ];
    # TODO: eventually move this to a make.conf
    makeFlags = [
      "MACHINE=${MACHINE}"
      "MACHINE_ARCH=${MACHINE_ARCH}"

      "AR=${stdenv.cc.targetPrefix}ar"
      "CC=${stdenv.cc.targetPrefix}cc"
      "CPP=${stdenv.cc.targetPrefix}cpp"
      "CXX=${stdenv.cc.targetPrefix}c++"
      "LD=${stdenv.cc.targetPrefix}ld"
      "STRIP=${stdenv.cc.targetPrefix}strip"
    ] ++ (attrs.makeFlags or []);

    # Definitions passed to share/mk/*.mk. Should be pretty simple -
    # eventually maybe move it to a configure script.
    # TODO: don’t rely on DESTDIR, instead use prefix
    DESTDIR = "$(out)";
    TOOLDIR = "$(out)";
    USETOOLS = "never";
    NOCLANGERROR = "yes";
    NOGCCERROR = "yes";
    LEX = "flex";
    MKUNPRIVED = "yes";
    HOST_SH = "${buildPackages.bash}/bin/sh";
    OBJCOPY = if stdenv.isDarwin then "true" else "objcopy";
    RPCGEN_CPP = "${stdenv.cc.targetPrefix}cpp";

    MKPIC = if stdenv.isDarwin then "no" else "yes";
    MKRELRO = if stdenv.isDarwin then "no" else "yes";

    INSTALL_FILE = "install -U -c";
    INSTALL_DIR = "xinstall -U -d";
    INSTALL_LINK = "install -U -l h";
    INSTALL_SYMLINK = "install -U -l s";

    HOST_CC = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
    HOST_CXX  = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";

    # libs will be provided by cc-wrapper
    LIBCRT0 = "";
    LIBCRTI = "";
    LIBCRTEND = "";
    LIBCRTBEGIN = "";
    LIBC = "";
    LIBUTIL = "";
    LIBSSL = "";
    LIBCRYPTO = "";
    LIBCRYPT = "";
    LIBCURSES = "";
    LIBTERMINFO = "";
    LIBM = "";
    LIBL = "";
    _GCC_CRTBEGIN = "";
    _GCC_CRTBEGINS = "";
    _GCC_CRTEND = "";
    _GCC_CRTENDS = "";
    _GCC_LIBGCCDIR = "";
    _GCC_CRTI = "";
    _GCC_CRTDIR = "";
    _GCC_CRTN = "";

    "LIBDO.terminfo" = "_external";
    "LIBDO.curses" = "_external";

    # all dirs will be prefixed with DESTDIR
    BINDIR = "/bin";
    LIBDIR = "/lib";
    SHLIBDIR = "/lib";
    INCSDIR = "/include";
    MANDIR = "/share/man";
    INFODIR = "/share/info";
    DOCDIR = "/share/doc";
    LOCALEDIR = "/share/locale";
    X11BINDIR = "/bin";
    X11USRLIBDIR = "/lib";
    X11MANDIR = "/share/man";

    # NetBSD makefiles should be able to detect this
    # but without they end up using gcc on Darwin stdenv
    preConfigure = ''
      export HAVE_${if stdenv.cc.isClang then "LLVM" else "GCC"}=${lib.head (lib.splitString "." (lib.getVersion stdenv.cc.cc))}

      # Parallel building. Needs the space.
      export makeFlags+=" -j $NIX_BUILD_CORES"
    '';

    postUnpack = ''
      # merge together all extra paths
      # there should be a better way to do this
      sourceRoot=$PWD/$sourceRoot
      export NETBSDSRCDIR=$sourceRoot
      export BSDSRCDIR=$NETBSDSRCDIR
      export _SRC_TOP_=$NETBSDSRCDIR
      chmod -R u+w $sourceRoot
      for path in $extraPaths; do
        cd $path
        find . -type d -exec mkdir -p $sourceRoot/\{} \;
        find . -type f -exec cp -pr \{} $sourceRoot/\{} \;
        chmod -R u+w $sourceRoot
      done

      cd $sourceRoot
      if [ -d ${attrs.path} ]
        then sourceRoot=$sourceRoot/${attrs.path}
      fi
    '';

    preFixup = ''
      # Remove lingering /usr references
      if [ -d $out/usr ]; then
        cd $out/usr
        find . -type d -exec mkdir -p $out/\{} \;
        find . -type f -exec mv \{} $out/\{} \;
      fi

      find $out -type d -empty -delete
    '';

    meta = with lib; {
      maintainers = with maintainers; [matthewbauer];
      platforms = platforms.unix;
      license = licenses.bsd2;
    };
  }) // (removeAttrs attrs ["makeFlags"]));

  libutil = netBSDDerivation {
    path = "lib/libutil";
    version = "8.0";
    sha256 = "077syyxd303m4x7avs5nxzk4c9n13d5lyk5aicsacqjvx79qrk3i";
    extraPaths = [
      (fetchNetBSD "common/lib/libutil" "8.0" "0q3ixrf36lip1dx0gafs0a03qfs5cs7n0myqq7af4jpjd6kh1831")
    ];
  };

  libc = netBSDDerivation {
    path = "lib/libc";
    version = "8.0";
    sha256 = "0lgbc58qgn8kwm3l011x1ml1kgcf7jsgq7hbf0hxhlbvxq5bljl3";
    extraPaths = [
      (fetchNetBSD "common/lib/libc" "8.0" "1kbhj0vxixvdy9fvsr5y70ri4mlkmim1v9m98sqjlzc1vdiqfqc8")
    ];
  };

  make = netBSDDerivation {
    path = "usr.bin/make";
    sha256 = "103643qs3w5kiahir6cca2rkm5ink81qbg071qyzk63qvspfq10c";
    version = "8.0";
    postPatch = ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.prog.mk \
        --replace '-Wl,-dynamic-linker=''${_SHLINKER}' "" \
        --replace '-Wl,-rpath,''${SHLIBDIR}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.kinc.mk \
        --replace /bin/rm rm
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '-Wl,-soname,''${_LIB}.so.''${SHLIB_SOVERSION}' "" \
        --replace '-Wl,--whole-archive' "" \
        --replace '-Wl,--no-whole-archive' "" \
        --replace '-Wl,--warn-shared-textrel' "" \
        --replace '-Wl,-Map=''${_LIB}.so.''${SHLIB_SOVERSION}.map' "" \
        --replace '-Wl,-rpath,''${SHLIBDIR}' ""
    '';
    postInstall = ''
      make -C $NETBSDSRCDIR/share/mk FILESDIR=/share/mk install
    '';
    extraPaths = [
      (fetchNetBSD "share/mk" "8.0" "033q4w3rmvwznz6m7fn9xcf13chyhwwl8ijj3a9mrn80fkwm55qs")
    ];
  };

  libcurses = netBSDDerivation {
    path = "lib/libcurses";
    version = "8.0";
    sha256 = "0azhzh1910v24dqx45zmh4z4dl63fgsykajrbikx5xfvvmkcq7xs";
    buildInputs = [ nbPackages.libterminfo ];
    makeFlags = [ "INCSDIR=/include" ];
    NIX_CFLAGS_COMPILE = [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ] ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)=";
    propagatedBuildInputs = [ nbPackages.compat ];
    MKDOC = "no"; # missing vfontedpr
    postPatch = ''
      substituteInPlace printw.c \
        --replace "funopen2(win, NULL, winwrite, NULL, NULL, NULL)" NULL \
        --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
      substituteInPlace scanw.c \
        --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
    '';
  };

  libedit = netBSDDerivation {
    path = "lib/libedit";
    buildInputs = [ nbPackages.libterminfo libcurses ];
    propagatedBuildInputs = [ nbPackages.compat ];
    makeFlags = [ "INCSDIR=/include" ];
    postPatch = ''
      sed -i '1i #undef bool_t' el.h
      substituteInPlace config.h \
        --replace "#define HAVE_STRUCT_DIRENT_D_NAMLEN 1" ""
    '';
    NIX_CFLAGS_COMPILE = [
      "-D__noinline="
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
    ];
    version = "8.0";
    sha256 = "0pmqh2mkfp70bwchiwyrkdyq9jcihx12g1awd6alqi9bpr3f9xmd";
  };

  nbPackages = rec {

  ##
  ## BOOTSTRAPPING
  ##
  makeMinimal = netBSDDerivation rec {
    path = "tools/make";
    sha256 = "1xbzfd4i7allrkk1if74a8ymgpizyj0gkvdigzzj37qar7la7nc1";
    version = "8.0";

    buildInputs = [];
    nativeBuildInputs = [];

    postPatch = ''
      patchShebangs configure
      ${make.postPatch}
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
      cp -r $NETBSDSRCDIR/share/mk $out/share/mk

      runHook postInstall
    '';
    extraPaths = [ make.src ] ++ make.extraPaths;
  };

  compat = if hostPlatform.isNetBSD then null else netBSDDerivation rec {
    path = "tools/compat";
    sha256 = "050449lq5gpxqsripdqip5ks49g5ypjga188nd3ss8dg1zf7ydz3";
    version = "8.0";

    setupHooks = [
      ../../../build-support/setup-hooks/role.bash
      ./compat-setup-hook.sh
    ];

    # override defaults to prevent infinite recursion
    nativeBuildInputs = [ nbBuildPackages.makeMinimal ];
    buildInputs = [ zlib ];

    # temporarily use gnuinstall for bootstrapping
    # bsdinstall will be built later
    makeFlags = [ "INSTALL=${buildPackages.coreutils}/bin/install" ];
    installFlags = [];
    RENAME = "-D";

    patches = [ ./compat.patch ];

    postInstall = ''
      mv $out/include/compat/* $out/include
      rmdir $out/include/compat

      # why aren't these installed by netbsd?
      install -D compat_defs.h $out/include/compat_defs.h
      install -D $NETBSDSRCDIR/include/cdbw.h $out/include/cdbw.h
      install -D $NETBSDSRCDIR/sys/sys/cdbr.h $out/include/cdbr.h
      install -D $NETBSDSRCDIR/sys/sys/featuretest.h \
                 $out/include/sys/featuretest.h
      install -D $NETBSDSRCDIR/sys/sys/md5.h $out/include/md5.h
      install -D $NETBSDSRCDIR/sys/sys/rmd160.h $out/include/rmd160.h
      install -D $NETBSDSRCDIR/sys/sys/sha1.h $out/include/sha1.h
      install -D $NETBSDSRCDIR/sys/sys/sha2.h $out/include/sha2.h
      install -D $NETBSDSRCDIR/sys/sys/queue.h $out/include/sys/queue.h
      install -D $NETBSDSRCDIR/include/vis.h $out/include/vis.h
      install -D $NETBSDSRCDIR/include/db.h $out/include/db.h
      install -D $NETBSDSRCDIR/include/netconfig.h $out/include/netconfig.h
      install -D $NETBSDSRCDIR/include/rpc/types.h $out/include/rpc/types.h
      install -D $NETBSDSRCDIR/include/utmpx.h $out/include/utmpx.h
      install -D $NETBSDSRCDIR/include/tzfile.h $out/include/tzfile.h
      install -D $NETBSDSRCDIR/sys/sys/tree.h $out/include/sys/tree.h
      install -D $NETBSDSRCDIR/include/nl_types.h $out/include/nl_types.h
      install -D $NETBSDSRCDIR/include/stringlist.h $out/include/stringlist.h
   '' + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/include/ssp
      touch $out/include/ssp/ssp.h
   '' + ''
      mkdir -p $out/lib/pkgconfig
      substitute ${./libbsd-overlay.pc} $out/lib/pkgconfig/libbsd-overlay.pc \
        --subst-var-by out $out \
        --subst-var-by version ${version}

      # Remove lingering /usr references
      if [ -d $out/usr ]; then
        cd $out/usr
        find . -type d -exec mkdir -p $out/\{} \;
        find . -type f -exec mv \{} $out/\{} \;
      fi

      find $out -type d -empty -delete
    '';
    extraPaths = [ libc.src libutil.src
      (fetchNetBSD "include" "8.0" "128m77k16i7frvk8kifhmxzk7a37m7z1s0bbmja3ywga6sx6v6sq")
      (fetchNetBSD "external/bsd/flex" "8.0" "0yxcjshz9nj827qhmjwwjmzvmmqgaf0d25b42k7lj84vliwrgyr6")
      (fetchNetBSD "sys/sys" "8.0" "0b0yjjy0c0cvk5nyffppqwxlwh2s1qr2xzl97a9ldck00dibar94")
    ] ++ libutil.extraPaths ++ libc.extraPaths;
  };

  # HACK to ensure parent directories exist. This emulates GNU
  # install’s -D option. No alternative seems to exist in BSD install.
  install = let binstall = writeText "binstall" ''
    #!${stdenv.shell}
    for last in $@; do true; done
    mkdir -p $(dirname $last)
    xinstall "$@"
  ''; in netBSDDerivation {
    path = "usr.bin/xinstall";
    version = "8.0";
    sha256 = "1f6pbz3qv1qcrchdxif8p5lbmnwl8b9nq615hsd3cyl4avd5bfqj";
    extraPaths = [ mtree.src make.src ];
    nativeBuildInputs = [ nbBuildPackages.makeMinimal mandoc groff ];
    buildInputs = [ compat fts ];
    installPhase = ''
      runHook preInstall

      install -D install.1 $out/share/man/man1/install.1
      install -D xinstall $out/bin/xinstall
      install -D -m 0550 ${binstall} $out/bin/binstall
      ln -s $out/bin/binstall $out/bin/install

      runHook postInstall
    '';
  };

  fts = netBSDDerivation {
    pname = "fts";
    path = "include/fts.h";
    sha256 = "01d4fpxvz1pgzfk5xznz5dcm0x0gdzwcsfm1h3d0xc9kc6hj2q77";
    version = "8.0";
    nativeBuildInputs = [ ];
    propagatedBuildInputs = [ compat ];
    extraPaths = [
      (fetchNetBSD "lib/libc/gen/fts.c" "8.0" "1a8hmf26242nmv05ipn3ircxb0jqmmi66rh78kkyi9vjwkfl3qn7")
      (fetchNetBSD "lib/libc/include/namespace.h" "8.0" "1sjvh9nw3prnk4rmdwrfsxh6gdb9lmilkn46jcfh3q5c8glqzrd7")
      (fetchNetBSD "lib/libc/gen/fts.3" "8.0" "1asxw0n3fhjdadwkkq3xplfgqgl3q32w1lyrvbakfa3gs0wz5zc1")
    ];
    buildPhase = ''
      cc  -c -Iinclude -Ilib/libc/include lib/libc/gen/fts.c \
          -o lib/libc/gen/fts.o
      ar -rsc libfts.a lib/libc/gen/fts.o
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

  stat = netBSDDerivation {
    path = "usr.bin/stat";
    version = "8.0";
    sha256 = "0z4r96id2r4cfy443rw2s1n52n186xm0lqvs8s3qjf4314z7r7yh";
    nativeBuildInputs = [ nbBuildPackages.makeMinimal nbBuildPackages.install
                          mandoc groff ];
  };

  tsort = netBSDDerivation {
    path = "usr.bin/tsort";
    version = "8.0";
    sha256 = "1dqvf9gin29nnq3c4byxc7lfd062pg7m84843zdy6n0z63hnnwiq";
    nativeBuildInputs = [ nbBuildPackages.makeMinimal nbBuildPackages.install
                          mandoc groff ];
  };

  lorder = netBSDDerivation {
    path = "usr.bin/lorder";
    version = "8.0";
    sha256 = "0rjf9blihhm0n699vr2bg88m4yjhkbxh6fxliaay3wxkgnydjwn2";
    nativeBuildInputs = [ nbBuildPackages.makeMinimal nbBuildPackages.install
                          mandoc groff ];
  };
  ##
  ## END BOOTSTRAPPING
  ##

  mtree = netBSDDerivation {
    path = "usr.sbin/mtree";
    version = "8.0";
    sha256 = "0hanmzm8bgwz2bhsinmsgfmgy6nbdhprwmgwbyjm6bl17vgn7vid";
    extraPaths = [ mknod.src ];
  };

  mknod = netBSDDerivation {
    path = "sbin/mknod";
    version = "8.0";
    sha256 = "0vq66v0hj0r4z2r2z2d3l3c5vh48pvcdmddc8bhm8hzq2civ5df2";
  };

  getent = netBSDDerivation {
    path = "usr.bin/getent";
    sha256 = "1ylhw4dnpyrmcy8n5kjcxywm8qc9p124dqnm17x4magiqx1kh9iz";
    version = "8.0";
    patches = [ ./getent.patch ];
  };

  getconf = netBSDDerivation {
    path = "usr.bin/getconf";
    sha256 = "122vslz4j3h2mfs921nr2s6m078zcj697yrb75rwp2hnw3qz4s8q";
    version = "8.0";
  };

  dict = netBSDDerivation {
    path = "share/dict";
    version = "8.0";
    sha256 = "1pk0y3xc5ihc2k89wjkh33qqx3w9q34k03k2qcffvbqh1l6wm36l";
    makeFlags = [ "BINDIR=/share" ];
  };

  fingerd = netBSDDerivation {
    path = "libexec/fingerd";
    sha256 = "0blcahhgyj1lm0mimrbvgmq3wkjvqk5wy85sdvbs99zxg7da1190";
    version = "8.0";
  };

  libterminfo = netBSDDerivation {
    path = "lib/libterminfo";
    version = "8.0";
    sha256 = "14gp0d6fh6zjnbac2yjhyq5m6rca7gm6q1s9gilhzpdgl9m7vb9r";
    buildInputs = [ compat tic nbperf ];
    makeFlags = [ "INCSDIR=/include" ];
    postPatch = ''
      substituteInPlace term.c --replace /usr/share $out/share
      substituteInPlace setupterm.c --replace '#include <curses.h>' 'void use_env(bool);'

    '';
    postInstall = ''
      make -C $NETBSDSRCDIR/share/terminfo BINDIR=/share
      make -C $NETBSDSRCDIR/share/terminfo BINDIR=/share install
    '';
    extraPaths = [
      (fetchNetBSD "share/terminfo" "8.0" "18db0fk1dw691vk6lsm6dksm4cf08g8kdm0gc4052ysdagg2m6sm")
    ];
  };

  nbperf = netBSDDerivation {
    path = "usr.bin/nbperf";
    version = "8.0";
    sha256 = "0gzm0zv2400lasnsswnjw9bwzyizhxzdbrcjwcl1k65aj86aqyqb";
  };

  tic = netBSDDerivation {
    path = "tools/tic";
    version = "8.0";
    sha256 = "092y7db7k4kh2jq8qc55126r5qqvlb8lq8mhmy5ipbi36hwb4zrz";
    HOSTPROG = "tic";
    buildInputs = [ compat nbperf ];
    extraPaths = [
      libterminfo.src
      (fetchNetBSD "usr.bin/tic" "8.0" "0diirnzmdnpc5bixyb34c9rid9paw2a4zfczqrpqrfvjsf1nnljf")
      (fetchNetBSD "tools/Makefile.host" "8.0" "1p23dsc4qrv93vc6gzid9w2479jwswry9qfn88505s0pdd7h6nvp")
    ];
  };

  misc = netBSDDerivation {
    path = "share/misc";
    version = "8.0";
    sha256 = "0d34b3irjbqsqfk8v8aaj36fjyvwyx410igl26jcx2ryh3ispch8";
    makeFlags = [ "BINDIR=/share" ];
  };

  locale = netBSDDerivation {
    path = "usr.bin/locale";
    version = "8.0";
    sha256 = "0kk6v9k2bygq0wf9gbinliqzqpzs9bgxn0ndyl2wcv3hh2bmsr9p";
    patches = [ ./locale.patch ];
    NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
  };

  column = netBSDDerivation {
    path = "usr.bin/column";
    version = "8.0";
    sha256 = "0r6b0hjn5ls3j3sv6chibs44fs32yyk2cg8kh70kb4cwajs4ifyl";
  };

  };

in nbPackages
