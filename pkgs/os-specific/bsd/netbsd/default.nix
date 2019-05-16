{ stdenv, stdenvNoCC, fetchcvs, lib, groff, mandoc, zlib, yacc, flex, bash
, writeText, buildPackages, splicePackages, symlinkJoin }:

let
  fetchNetBSD = path: version: sha256: fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/${path}";
    inherit sha256;
    tag = "netbsd-${lib.replaceStrings ["."] ["-"] version}-RELEASE";
  };

  # Splice packages so we get the correct package when using
  # nativeBuildInputs...
  nbSplicedPackages = splicePackages {
    pkgsBuildBuild = buildPackages.buildPackages.netbsd;
    pkgsBuildHost = buildPackages.netbsd;
    pkgsBuildTarget = {};
    pkgsHostHost = {};
    pkgsHostTarget = netbsd;
    pkgsTargetTarget = {};
  };

  netbsd = with nbSplicedPackages; {

  mkDerivation = lib.makeOverridable (attrs: let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in stdenv'.mkDerivation ({
    name = "${attrs.pname or (baseNameOf attrs.path)}-netbsd-${attrs.version}";
    src = attrs.src or fetchNetBSD attrs.path attrs.version attrs.sha256;

    extraPaths = [ ];

    nativeBuildInputs = [ makeMinimal install tsort lorder mandoc groff stat ];
    buildInputs = [ compat ];
    # depsBuildBuild = [ buildPackages.stdenv.cc ];

    OBJCOPY = if stdenv.isDarwin then "true" else "objcopy";
    HOST_SH = "${buildPackages.bash}/bin/sh";

    MACHINE_ARCH = {
      "i686" = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    MACHINE = {
      "x86_64" = "amd64";
      "aarch64" = "evbarm64";
      "i686" = "i386";
    }.${stdenv'.hostPlatform.parsed.cpu.name}
      or stdenv'.hostPlatform.parsed.cpu.name;

    AR = "${stdenv'.cc.targetPrefix or ""}ar";
    CC = "${stdenv'.cc.targetPrefix or ""}cc";
    CPP = "${stdenv'.cc.targetPrefix or ""}cpp";
    CXX = "${stdenv'.cc.targetPrefix or ""}c++";
    LD = "${stdenv'.cc.targetPrefix or ""}ld";
    STRIP = "${stdenv'.cc.targetPrefix or ""}strip";

    NETBSD_PATH = attrs.path;

    builder = ./builder.sh;

    meta = with lib; {
      maintainers = with maintainers; [matthewbauer];
      platforms = platforms.unix;
      license = licenses.bsd2;
    };
  } // lib.optionalAttrs stdenv'.isDarwin {
    MKRELRO = "no";
  } // lib.optionalAttrs (stdenv'.cc.isClang or false) {
    HAVE_LLVM = lib.head (lib.splitString "." (lib.getVersion stdenv'.cc.cc));
  } // lib.optionalAttrs (stdenv'.cc.isGNU or false) {
    HAVE_GCC = lib.head (lib.splitString "." (lib.getVersion stdenv'.cc.cc));
  } // lib.optionalAttrs (attrs.headersOnly or false) {
    installPhase = "includesPhase";
    dontBuild = true;
  } // attrs));

  ##
  ## START BOOTSTRAPPING
  ##
  makeMinimal = mkDerivation rec {
    path = "tools/make";
    sha256 = "1xbzfd4i7allrkk1if74a8ymgpizyj0gkvdigzzj37qar7la7nc1";
    version = "8.0";

    buildInputs = [];
    nativeBuildInputs = [];

    skipIncludesPhase = true;

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

  compat = if stdenv.hostPlatform.isNetBSD then stdenv else mkDerivation rec {
    path = "tools/compat";
    sha256 = "050449lq5gpxqsripdqip5ks49g5ypjga188nd3ss8dg1zf7ydz3";
    version = "8.0";

    setupHooks = [
      ../../../build-support/setup-hooks/role.bash
      ./compat-setup-hook.sh
    ];

    # override defaults to prevent infinite recursion
    nativeBuildInputs = [ makeMinimal ];
    buildInputs = [ zlib ];

    # temporarily use gnuinstall for bootstrapping
    # bsdinstall will be built later
    makeFlags = [
      "INSTALL=${buildPackages.coreutils}/bin/install"
      "TOOLDIR=$(out)"
    ];
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
    '';
    extraPaths = [ libc.src libutil.src
      (fetchNetBSD "include" "8.0" "128m77k16i7frvk8kifhmxzk7a37m7z1s0bbmja3ywga6sx6v6sq")
      (fetchNetBSD "external/bsd/flex" "8.0" "0yxcjshz9nj827qhmjwwjmzvmmqgaf0d25b42k7lj84vliwrgyr6")
      (fetchNetBSD "sys/sys" "8.0" "0b0yjjy0c0cvk5nyffppqwxlwh2s1qr2xzl97a9ldck00dibar94")
    ] ++ libutil.extraPaths ++ libc.extraPaths;
  };

  # HACK: to ensure parent directories exist. This emulates GNU
  # install’s -D option. No alternative seems to exist in BSD install.
  install = let binstall = writeText "binstall" ''
    #!${stdenv.shell}
    for last in $@; do true; done
    mkdir -p $(dirname $last)
    xinstall "$@"
  ''; in mkDerivation {
    path = "usr.bin/xinstall";
    version = "8.0";
    sha256 = "1f6pbz3qv1qcrchdxif8p5lbmnwl8b9nq615hsd3cyl4avd5bfqj";
    extraPaths = [ mtree.src make.src ];
    nativeBuildInputs = [ makeMinimal mandoc groff ];
    skipIncludesPhase = true;
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

  fts = mkDerivation {
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
    skipIncludesPhase = true;
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

  stat = mkDerivation {
    path = "usr.bin/stat";
    version = "8.0";
    sha256 = "0z4r96id2r4cfy443rw2s1n52n186xm0lqvs8s3qjf4314z7r7yh";
    nativeBuildInputs = [ makeMinimal install mandoc groff ];
  };

  tsort = mkDerivation {
    path = "usr.bin/tsort";
    version = "8.0";
    sha256 = "1dqvf9gin29nnq3c4byxc7lfd062pg7m84843zdy6n0z63hnnwiq";
    nativeBuildInputs = [ makeMinimal install mandoc groff ];
  };

  lorder = mkDerivation {
    path = "usr.bin/lorder";
    version = "8.0";
    sha256 = "0rjf9blihhm0n699vr2bg88m4yjhkbxh6fxliaay3wxkgnydjwn2";
    nativeBuildInputs = [ makeMinimal install mandoc groff ];
  };
  ##
  ## END BOOTSTRAPPING
  ##

  ##
  ## START COMMAND LINE TOOLS
  ##
  make = mkDerivation {
    path = "usr.bin/make";
    sha256 = "103643qs3w5kiahir6cca2rkm5ink81qbg071qyzk63qvspfq10c";
    version = "8.0";
    postPatch = ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.kinc.mk \
        --replace /bin/rm rm
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
    '';
    postInstall = ''
      make -C $NETBSDSRCDIR/share/mk FILESDIR=$out/share/mk install
    '';
    extraPaths = [
      (fetchNetBSD "share/mk" "8.0" "033q4w3rmvwznz6m7fn9xcf13chyhwwl8ijj3a9mrn80fkwm55qs")
    ];
  };

  mtree = mkDerivation {
    path = "usr.sbin/mtree";
    version = "8.0";
    sha256 = "0hanmzm8bgwz2bhsinmsgfmgy6nbdhprwmgwbyjm6bl17vgn7vid";
    extraPaths = [ mknod.src ];
  };

  mknod = mkDerivation {
    path = "sbin/mknod";
    version = "8.0";
    sha256 = "0vq66v0hj0r4z2r2z2d3l3c5vh48pvcdmddc8bhm8hzq2civ5df2";
  };

  getent = mkDerivation {
    path = "usr.bin/getent";
    sha256 = "1ylhw4dnpyrmcy8n5kjcxywm8qc9p124dqnm17x4magiqx1kh9iz";
    version = "8.0";
    patches = [ ./getent.patch ];
  };

  getconf = mkDerivation {
    path = "usr.bin/getconf";
    sha256 = "122vslz4j3h2mfs921nr2s6m078zcj697yrb75rwp2hnw3qz4s8q";
    version = "8.0";
  };

  locale = mkDerivation {
    path = "usr.bin/locale";
    version = "8.0";
    sha256 = "0kk6v9k2bygq0wf9gbinliqzqpzs9bgxn0ndyl2wcv3hh2bmsr9p";
    patches = [ ./locale.patch ];
    NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
  };

  rpcgen = mkDerivation {
    path = "usr.bin/rpcgen";
    version = "8.0";
    sha256 = "1kfgfx54jg98wbg0d95p0rvf4w0302v8fz724b0bdackdsrd4988";
  };

  genassym = mkDerivation {
    path = "usr.bin/genassym";
    version = "8.0";
    sha256 = "1acl1dz5kvh9h5806vkz2ap95rdsz7phmynh5i3x5y7agbki030c";
  };

  gencat = mkDerivation {
    path = "usr.bin/gencat";
    version = "8.0";
    sha256 = "1696lgh2lhz93247lklvpvkd0f5asg6z27w2g4bmpfijlgw2h698";
  };

  nbperf = mkDerivation {
    path = "usr.bin/nbperf";
    version = "8.0";
    sha256 = "0gzm0zv2400lasnsswnjw9bwzyizhxzdbrcjwcl1k65aj86aqyqb";
  };

  tic = mkDerivation {
    path = "tools/tic";
    version = "8.0";
    sha256 = "092y7db7k4kh2jq8qc55126r5qqvlb8lq8mhmy5ipbi36hwb4zrz";
    HOSTPROG = "tic";
    buildInputs = [ compat ];
    nativeBuildInputs = [ makeMinimal install mandoc groff nbperf ];
    makeFlags = [ "TOOLDIR=$(out)" ];
    extraPaths = [
      libterminfo.src
      (fetchNetBSD "usr.bin/tic" "8.0" "0diirnzmdnpc5bixyb34c9rid9paw2a4zfczqrpqrfvjsf1nnljf")
      (fetchNetBSD "tools/Makefile.host" "8.0" "1p23dsc4qrv93vc6gzid9w2479jwswry9qfn88505s0pdd7h6nvp")
    ];
  };
  ##
  ## END COMMAND LINE TOOLS
  ##

  ##
  ## START HEADERS
  ##
  include = mkDerivation {
    path = "include";
    version = "8.0";
    sha256 = "128m77k16i7frvk8kifhmxzk7a37m7z1s0bbmja3ywga6sx6v6sq";
    nativeBuildInputs = [ makeMinimal install mandoc groff nbperf rpcgen ];
    extraPaths = [ common.src ];
    headersOnly = true;
    noCC = true;
    # meta.platforms = lib.platforms.netbsd;
    makeFlags = [ "RPCGEN_CPP=${buildPackages.gcc-unwrapped}/bin/cpp" ];
  };

  common = mkDerivation {
    path = "common";
    version = "8.0";
    sha256 = "1fsm2b7p7zkhiz523jw75088cq2h39iknp0fp3di9a64bikwbhi1";
  };

  # The full kernel
  sys = mkDerivation {
    path = "sys";
    version = "8.0";
    sha256 = "123ilg8fqmp69bw6bs6nh98fpi1v2n9lamrzar61p27ji6sj7g0w";
    propagatedBuildInputs = [ include ];
    #meta.platforms = lib.platforms.netbsd;
    extraPaths = [ common.src ];
    MKKMOD = "no";
  };

  headers = symlinkJoin {
    name = "netbsd-headers-8.0";
    paths = [ include ] ++ map (pkg: pkg.override (_: {
      installPhase = "includesPhase";
      dontBuild = true;
      noCC = true;
      meta.platforms = lib.platforms.all;
    })) [ sys libpthread ];
  };
  ##
  ## END HEADERS
  ##

  ##
  ## START LIBRARIES
  ##
  libutil = mkDerivation {
    path = "lib/libutil";
    version = "8.0";
    sha256 = "077syyxd303m4x7avs5nxzk4c9n13d5lyk5aicsacqjvx79qrk3i";
    extraPaths = [ common.src ];
  };

  libedit = mkDerivation {
    path = "lib/libedit";
    version = "8.0";
    sha256 = "0pmqh2mkfp70bwchiwyrkdyq9jcihx12g1awd6alqi9bpr3f9xmd";
    buildInputs = [ libterminfo libcurses ];
    propagatedBuildInputs = [ compat ];
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
    version = "8.0";
    sha256 = "14gp0d6fh6zjnbac2yjhyq5m6rca7gm6q1s9gilhzpdgl9m7vb9r";
    buildInputs = [ compat ];
    postPatch = ''
      substituteInPlace term.c --replace /usr/share $out/share
      substituteInPlace setupterm.c \
        --replace '#include <curses.h>' 'void use_env(bool);'
    '';
    postInstall = ''
      make -C $NETBSDSRCDIR/share/terminfo BINDIR=$out/share install
    '';
    extraPaths = [
      (fetchNetBSD "share/terminfo" "8.0" "18db0fk1dw691vk6lsm6dksm4cf08g8kdm0gc4052ysdagg2m6sm")
    ];
  };

  libcurses = mkDerivation {
    path = "lib/libcurses";
    version = "8.0";
    sha256 = "0azhzh1910v24dqx45zmh4z4dl63fgsykajrbikx5xfvvmkcq7xs";
    buildInputs = [ libterminfo ];
    NIX_CFLAGS_COMPILE = [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ] ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)=";
    propagatedBuildInputs = [ compat ];
    MKDOC = "no"; # missing vfontedpr
    postPatch = lib.optionalString (!stdenv.isDarwin) ''
      substituteInPlace printw.c \
        --replace "funopen(win, NULL, __winwrite, NULL, NULL)" NULL \
        --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
      substituteInPlace scanw.c \
        --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
    '';
  };

  libkern = mkDerivation {
    path = "lib/libkern";
    version = "8.0";
    sha256 = "1wirqr9bms69n4b5sr32g1b1k41hcamm7c9n7i8c440m73r92yv4";
    meta.platforms = lib.platforms.netbsd;
  };

  column = mkDerivation {
    path = "usr.bin/column";
    version = "8.0";
    sha256 = "0r6b0hjn5ls3j3sv6chibs44fs32yyk2cg8kh70kb4cwajs4ifyl";
  };

  libossaudio = mkDerivation {
    path = "lib/libossaudio";
    version = "8.0";
    sha256 = "03azp5anavhjr15sinjlik9792lyf7w4zmkcihlkksrywhs05axh";
    meta.platforms = lib.platforms.netbsd;
    postPatch = ''
      substituteInPlace rpc/Makefile --replace /usr $out
    '';
  };

  librpcsvc = mkDerivation {
    path = "lib/librpcsvc";
    version = "8.0";
    sha256 = "14ri9w6gdhsm4id5ck133syyvbmkbknfa8w0xkklm726nskhfkj7";
    makeFlags = [ "INCSDIR=$(out)/include/rpcsvc" ];
    meta.platforms = lib.platforms.netbsd;
  };

  librt = mkDerivation {
    path = "lib/librt";
    version = "8.0";
    sha256 = "078qsi4mg1hyyxr1awvjs9b0c2gicg3zw4vl603g1m9vm8gfxw9l";
    meta.platforms = lib.platforms.netbsd;
  };

  libcrypt = mkDerivation {
    path = "lib/libcrypt";
    version = "8.0";
    sha256 = "0siqan1wdqmmhchh2n8w6a8x1abbff8n4yb6jrqxap3hqn8ay54g";
    meta.platforms = lib.platforms.netbsd;
  };

  libpthread = mkDerivation {
    path = "lib/libpthread";
    version = "8.0";
    sha256 = "0pcz61klc3ijf5z2zf8s78nj7bwjfblzjllx7vr4z5qv3m0sdb3j";
    meta.platforms = lib.platforms.netbsd;
  };

  libresolv = mkDerivation {
    path = "lib/libresolv";
    version = "8.0";
    sha256 = "11vpb3p2343wyrhw4v9gwz7i0lcpb9ysmfs9gsx56b5gkgipdy4v";
    meta.platforms = lib.platforms.netbsd;
  };

  libm = mkDerivation {
    path = "lib/libm";
    version = "8.0";
    sha256 = "0i22603cgj6n00gn2m446v4kn1pk109qs1g6ylrslmihfmiy2h1d";
    meta.platforms = lib.platforms.netbsd;
  };

  i18n_module = mkDerivation {
    path = "lib/i18n_module";
    version = "8.0";
    sha256 = "0w6y5v3binm7gf2kn7y9jja8k18rhnyl55cvvfnfipjqdxvxd9jd";
    meta.platforms = lib.platforms.netbsd;
  };

  csu = mkDerivation {
    path = "lib/csu";
    version = "8.0";
    sha256 = "0630lbvz6v4ic13bfg8ccwfhqkgcv76bfdw9f36rfsnwfgpxqsmq";
    meta.platforms = lib.platforms.netbsd;
    nativeBuildInputs = [ makeMinimal install mandoc groff flex
                          yacc genassym gencat lorder tsort stat ];
    extraPaths = [ sys.src ld_elf_so.src ];
  };

  ld_elf_so = mkDerivation {
    path  = "libexec/ld.elf_so";
    version = "8.0";
    sha256 = "1jmqpi0kg2daiqnvpwdyfy8rpnszxsm70sxizz0r7wn53xjr5hva";
    meta.platforms = lib.platforms.netbsd;
    USE_FORT = "yes";
    extraPaths = [ libc.src ] ++ libc.extraPaths;
  };

  libc = mkDerivation {
    path = "lib/libc";
    version = "8.0";
    sha256 = "0lgbc58qgn8kwm3l011x1ml1kgcf7jsgq7hbf0hxhlbvxq5bljl3";
    USE_FORT = "yes";
    MKPROFILE = "no";
    extraPaths = [ common.src i18n_module.src sys.src
                   ld_elf_so.src libpthread.src libm.src libresolv.src
                   librpcsvc.src libutil.src librt.src libcrypt.src ];
    buildInputs = [ buildPackages.netbsd.headers csu ];
    nativeBuildInputs = [ makeMinimal install mandoc groff flex
                          yacc genassym gencat lorder tsort stat ];
    NIX_CFLAGS_COMPILE = "-B${csu}/lib";
    meta.platforms = lib.platforms.netbsd;
    SHLIBINSTALLDIR = "$(out)/lib";
    NLSDIR = "$(out)/share/nls";
    makeFlags = [ "FILESDIR=$(out)/var/db"];
    postInstall = ''
      pushd ${buildPackages.netbsd.headers}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      pushd ${csu}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      NIX_CFLAGS_COMPILE+=" -B$out/lib"
      NIX_CFLAGS_COMPILE+=" -I$out/include"
      NIX_LDFLAGS+=" -L$out/lib"

      make -C $NETBSDSRCDIR/lib/libpthread $makeFlags
      make -C $NETBSDSRCDIR/lib/libpthread $makeFlags install

      make -C $NETBSDSRCDIR/lib/libm $makeFlags
      make -C $NETBSDSRCDIR/lib/libm $makeFlags install

      make -C $NETBSDSRCDIR/lib/libresolv $makeFlags
      make -C $NETBSDSRCDIR/lib/libresolv $makeFlags install

      make -C $NETBSDSRCDIR/lib/librpcsv $makeFlags
      make -C $NETBSDSRCDIR/lib/librpcsv $makeFlags install

      make -C $NETBSDSRCDIR/lib/i18n_module $makeFlags
      make -C $NETBSDSRCDIR/lib/i18n_module $makeFlags install

      make -C $NETBSDSRCDIR/lib/libutil $makeFlags
      make -C $NETBSDSRCDIR/lib/libutil $makeFlags install

      make -C $NETBSDSRCDIR/lib/librt $makeFlags
      make -C $NETBSDSRCDIR/lib/librt $makeFlags install

      make -C $NETBSDSRCDIR/lib/libcrypt $makeFlags
      make -C $NETBSDSRCDIR/lib/libcrypt $makeFlags install
    '';
    postPatch = ''
      substituteInPlace sys/Makefile.inc \
        --replace /usr/include/sys/syscall.h ${buildPackages.netbsd.headers}/include/sys/syscall.h
    '';
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
    version = "8.0";
    sha256 = "1pk0y3xc5ihc2k89wjkh33qqx3w9q34k03k2qcffvbqh1l6wm36l";
    makeFlags = [ "BINDIR=$(out)/share" ];
  };

  misc = mkDerivation {
    path = "share/misc";
    noCC = true;
    version = "8.0";
    sha256 = "0d34b3irjbqsqfk8v8aaj36fjyvwyx410igl26jcx2ryh3ispch8";
    makeFlags = [ "BINDIR=$(out)/share" ];
  };

  man = mkDerivation {
    path = "share/man";
    noCC = true;
    version = "8.0";
    sha256 = "0d34b3irjbqsqfk8v8aaj36fjyvwyx410igl26jcx2ryh3ispch0";
    makeFlags = [ "FILESDIR=$(out)/share" ];
  };
  #
  # END MISCELLANEOUS
  #

  };

in netbsd
