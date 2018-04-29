{ stdenv, hostPlatform, fetchcvs, lib, groff, mandoc, zlib, coreutils
, yacc, flex, libressl, bash }:

let
  fetchNetBSD = path: version: sha256: fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/${path}";
    inherit sha256;
    tag = "netbsd-${builtins.replaceStrings ["."] ["-"] version}-RELEASE";
  };

  netBSDDerivation = attrs: stdenv.mkDerivation ((rec {
    name = "${attrs.pname or (baseNameOf attrs.path)}-netbsd-${attrs.version}";
    src = attrs.src or fetchNetBSD attrs.path attrs.version attrs.sha256;

    extraPaths = [ ];

    nativeBuildInputs = [ makeMinimal mandoc groff install stat
                          yacc flex tsort lorder ];
    buildInputs = [ compat ];
    installFlags = [ "includes" ];

    # Definitions passed to share/mk/*.mk. Should be pretty simple -
    # eventually maybe move it to a configure script.
    DESTDIR = "$(out)";
    TOOLDIR = "$(out)";
    USETOOLS = "never";
    NOCLANGERROR="yes";
    NOGCCERROR="yes";
    LEX = "flex";

    # libs will be provided by cc-wrapper
    LIBCRT0="";
    LIBCRTI="";
    LIBCRTEND="";
    LIBCRTBEGIN="";
    LIBC="";
    LIBUTIL="";
    LIBSSL = "";
    LIBCRYPTO = "";
    LIBCRYPT = "";
    LIBCURSES = "";
    LIBTERMINFO = "";
    LIBM = "";
    "LIBDO.terminfo" = "_external";
    "LIBDO.curses" = "_external";
    _GCC_CRTBEGIN = "";
    _GCC_CRTBEGINS = "";
    _GCC_CRTEND = "";
    _GCC_CRTENDS = "";
    _GCC_LIBGCCDIR = "";
    _GCC_CRTI = "";
    _GCC_CRTDIR = "";
    _GCC_CRTN = "";

    # all dirs will be prefixed with DESTDIR
    BINDIR = "/bin";
    LIBDIR = "/lib";
    SHLIBDIR = "/lib";
    MANDIR = "/share/man";
    INFODIR = "/share/info";
    DOCDIR = "/share/doc";
    LOCALEDIR = "/share/locale";
    X11BINDIR = "/bin";
    X11USRLIBDIR = "/lib";
    X11MANDIR = "/share/man";
    SHLINKDIR = "/usr/libexec";

    HOST_SH = "${bash}/bin/sh";

    SHLIB_WARNTEXTREL = "no";
    SHLIB_MKMAP = "no";
    PRESERVE = "-p";
    OBJCOPY = if stdenv.isDarwin then "true" else "objcopy";

    MACHINE_ARCH = hostPlatform.parsed.cpu.name;
    MACHINE_CPU = hostPlatform.parsed.cpu.name;

    # NetBSD makefiles should be able to detect this
    # but without they end up using gcc on Darwin stdenv
    preConfigure = ''
      export HAVE_${if stdenv.cc.isGNU then "GCC" else "LLVM"}=${lib.head (lib.splitString "." (lib.getVersion stdenv.cc.cc))}
      # Parallel building. Needs the space.
      export makeFlags+=" -j $NIX_BUILD_CORES"
    '';

    postUnpack = ''
      # merge together all extra paths
      # there should be a better way to do this
      sourceRoot=$PWD/$sourceRoot
      export NETBSDSRCDIR=$sourceRoot
      export BSDSRCDIR=$NETBSDSRCDIR
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

    # Need to create directories for xinstall to work. Unused ones
    # will be removed in the postInstall.
    preInstall = ''
      mkdir -p $out$BINDIR $out$LIBDIR $out$INFODIR \
               $out$DOCDIR $out$LOCALEDIR
      for i in 1 2 3 4 5 6 7 8 9; do
        mkdir -p $out$MANDIR/man$i $out$MANDIR/html$i \
                 $out$DOCDIR/reference/ref$i
      done
      mkdir -p $out/usr/include
    '';

    postInstall = ''
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
  }) // attrs);

  # BOOTSTRAPPING
  makeMinimal = netBSDDerivation rec {
    path = "tools/make";
    sha256 = "0l4794zwj2haark3azf9xwcwqlkbrifhb2glaa9iba4dkg2mklsb";
    version = "7.1.2";

    buildInputs = [];
    nativeBuildInputs = [];

    patchPhase = ''
      patchShebangs configure
      ${make.patchPhase}
    '';
    buildPhase = "sh ./buildmake.sh";
    installPhase = ''
      install -D nbmake $out/bin/nbmake
      ln -s $out/bin/nbmake $out/bin/make
      mkdir -p $out/share
      cp -r ../../share/mk $out/share/mk
    '';
    extraPaths = [ make.src ] ++ make.extraPaths;
  };

  compat = netBSDDerivation {
    path = "tools/compat";
    sha256 = "17phkfafybxwhzng44k5bhmag6i55br53ky1nwcmw583kg2fa86z";
    version = "7.1.2";

    setupHook = ./compat-setup-hook.sh;

    # override defaults to prevent infinite recursion
    nativeBuildInputs = [ makeMinimal ];
    buildInputs = [ zlib ];

    # temporarily use gnuinstall for bootstrapping
    # bsdinstall will be built later
    makeFlags = "INSTALL=${coreutils}/bin/install";
    RENAME = "-D";

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

      # Remove lingering /usr references
      if [ -d $out/usr ]; then
        cd $out/usr
        find . -type d -exec mkdir -p $out/\{} \;
        find . -type f -exec mv \{} $out/\{} \;
      fi

      find $out -type d -empty -delete
    '';
    extraPaths = [ libc.src libutil.src
      (fetchNetBSD "include" "7.1.2" "1vc58xrhrp202biiv1chhlh0jwnjr7k3qq91pm46k6v5j95j0qwp")
      (fetchNetBSD "external/bsd/flex" "7.1.2" "0m0m72r3zzc9gi432h3xkqdzspr4n0hj4m8h7j74pwbvpfg9d9qq")
      (fetchNetBSD "sys/sys" "7.1.2" "1vwnv5nk7rlgn5w9nkdqj9652hmwmfwqxj3ymcz0zk10abbaib93")
    ] ++ libutil.extraPaths ++ libc.extraPaths;
  };

  install = netBSDDerivation {
    path = "usr.bin/xinstall";
    version = "7.1.2";
    sha256 = "0nzhyh714m19h61m45gzc5dszkbafp5iaphbp5mza6w020fzf2y8";
    extraPaths = [ mtree.src make.src ];
    nativeBuildInputs = [ makeMinimal mandoc groff ];
    buildInputs = [ compat fts ];
    RENAME = "-D";
  };

  fts = netBSDDerivation {
    pname = "fts";
    path = "include/fts.h";
    sha256 = "01d4fpxvz1pgzfk5xznz5dcm0x0gdzwcsfm1h3d0xc9kc6hj2q77";
    version = "7.1.2";
    nativeBuildInputs = [ ];
    propagatedBuildInputs = [ compat ];
    extraPaths = [
      (fetchNetBSD "lib/libc/gen/fts.c" "7.1.2" "1yfd2liypj6xky2h0mgxi5lgpflmkkg4zf3ii3apz5cf8jq9gmn9")
      (fetchNetBSD "lib/libc/include/namespace.h" "7.1.2" "0kwd4v8y0mfjhmwplsk52pvzbcpvpp2qy2g8c0jmfraam63q6q1y")
      (fetchNetBSD "lib/libc/gen/fts.3" "7.1.2" "1asxw0n3fhjdadwkkq3xplfgqgl3q32w1lyrvbakfa3gs0wz5zc1")
    ];
    buildPhase = ''
      cc  -c -Iinclude -Ilib/libc/include lib/libc/gen/fts.c \
          -o lib/libc/gen/fts.o
      ar -rsc libfts.a lib/libc/gen/fts.o
    '';
    installPhase = ''
      install -D lib/libc/gen/fts.3 $out/share/man/man3/fts.3
      install -D include/fts.h $out/include/fts.h
      install -D lib/libc/include/namespace.h $out/include/namespace.h
      install -D libfts.a $out/lib/libfts.a
    '';
    setupHook = ./fts-setup-hook.sh;
  };

  stat = netBSDDerivation {
    path = "usr.bin/stat";
    version = "7.1.2";
    sha256 = "0z4r96id2r4cfy443rw2s1n52n186xm0lqvs8s3qjf4314z7r7yh";
    nativeBuildInputs = [ makeMinimal mandoc groff install ];
  };

  tsort = netBSDDerivation {
    path = "usr.bin/tsort";
    version = "7.1.2";
    sha256 = "1dqvf9gin29nnq3c4byxc7lfd062pg7m84843zdy6n0z63hnnwiq";
    nativeBuildInputs = [ makeMinimal mandoc groff install ];
  };

  lorder = netBSDDerivation {
    path = "usr.bin/lorder";
    version = "7.1.2";
    sha256 = "0rjf9blihhm0n699vr2bg88m4yjhkbxh6fxliaay3wxkgnydjwn2";
    nativeBuildInputs = [ makeMinimal mandoc groff install ];
  };
  # END BOOTSTRAPPING

  libutil = netBSDDerivation {
    path = "lib/libutil";
    version = "7.1.2";
    sha256 = "12848ynizz13mvn2kndrkq482xhkw323b7c8fg0zli1nhfsmwsm8";
    extraPaths = [
      (fetchNetBSD "common/lib/libutil" "7.1.2" "0q3ixrf36lip1dx0gafs0a03qfs5cs7n0myqq7af4jpjd6kh1831")
    ];
  };

  libc = netBSDDerivation {
    path = "lib/libc";
    version = "7.1.2";
    sha256 = "13rcx3mbx2644z01zgk9gggdfr0hqdbsvd7zrsm2l13yf9aix6pg";
    extraPaths = [
      (fetchNetBSD "common/lib/libc" "7.1.2" "1va8zd4lqyrc1d0c9q04r8y88cfxpkhwcxasggxxvhksd3khkpha")
    ];
  };

  make = netBSDDerivation {
    path = "usr.bin/make";
    sha256 = "0srkkg6qdzqlccfi4xh19gl766ks6hpss76bnfvwmd0zg4q4zdar";
    version = "7.1.2";
    patchPhase = ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

      # can't set owner or group in Nix build
      # maybe there is a better way to trick it?
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.prog.mk \
        --replace '-o ''${SCRIPTSOWN_''${.ALLSRC:T}:U''${SCRIPTSOWN}}' "" \
        --replace '-g ''${SCRIPTSGRP_''${.ALLSRC:T}:U''${SCRIPTSGRP}}' "" \
        --replace '-o ''${RUMPBINOWN} -g ''${RUMPBINGRP}' "" \
        --replace '-o ''${BINOWN} -g ''${BINGRP}' "" \
        --replace '-o ''${RUMPBINOWN} -g ''${RUMPBINGRP}' "" \
        --replace '-o ''${DEBUGOWN} -g ''${DEBUGGRP}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.doc.mk \
        --replace '-o ''${DOCOWN} -g ''${DOCGRP}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.links.mk \
        --replace '-o ''${LINKSOWN_''${.ALLSRC:T}:U''${LINKSOWN}}' "" \
        --replace '-g ''${LINKSGRP_''${.ALLSRC:T}:U''${LINKSGRP}}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.man.mk \
        --replace '-o ''${MANOWN} -g ''${MANGRP}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.files.mk \
        --replace '-o ''${FILESOWN_''${.ALLSRC:T}:U''${FILESOWN}}' "" \
        --replace '-g ''${FILESGRP_''${.ALLSRC:T}:U''${FILESGRP}}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.inc.mk \
        --replace '-o ''${BINOWN} -g ''${BINGRP}' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '-o ''${DEBUGOWN} -g ''${DEBUGGRP}' "" \
        --replace '-o ''${LIBOWN} -g ''${LIBGRP}' ""
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' ""
      substituteInPlace $NETBSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '-Wl,-soname,''${_LIB}.so.''${SHLIB_SOVERSION}' "" \
        --replace '-Wl,--whole-archive' "" \
        --replace '-Wl,--no-whole-archive' ""
    '';
    postInstall = ''
      (cd $NETBSDSRCDIR/share/mk && make install)
    '';
    extraPaths = [
      (fetchNetBSD "share/mk" "7.1.2" "0570v0siv0wygn8ygs1yy9pgk9xjw9x1axr5qg4xrddv3lskf9xa")
    ];
  };

  mtree = netBSDDerivation {
    path = "usr.sbin/mtree";
    version = "7.1.2";
    sha256 = "1dhsyfvcm67kf5zdbg5dmx5y8fimnbll6qxwp3gjfmbxqigmc52m";
  };

  who = netBSDDerivation {
    path = "usr.bin/who";
    version = "7.1.2";
    sha256 = "17ffwww957m3qw0b6fkgjpp12pd5ydg2hs9dxkkw0qpv11j00d88";
    patchPhase = ''
      substituteInPlace $NETBSDSRCDIR/usr.bin/who/utmpentry.c \
        --replace "strncpy(e->name, up->ut_name, sizeof(up->ut_name))" "strncpy(e->name, up->ut_user, sizeof(up->ut_user))" \
        --replace "utmptime = st.st_mtimespec" "utmptime = st.st_mtim" \
        --replace "timespeccmp(&st.st_mtimespec, &utmptime, >)" "st.st_mtim.tv_sec == utmptime.tv_sec ? st.st_mtim.tv_nsec > utmptime.tv_nsec : st.st_mtim.tv_sec > utmptime.tv_sec" \
        --replace "timespecclear(&utmptime)" "utmptime.tv_sec = utmptime.tv_nsec = 0"
    '';
  };

in rec {
  inherit compat install netBSDDerivation fts;

  getent = netBSDDerivation {
    path = "usr.bin/getent";
    sha256 = "1ylhw4dnpyrmcy8n5kjcxywm8qc9p124dqnm17x4magiqx1kh9iz";
    version = "7.1.2";
    patches = [ ./getent.patch ];
  };

  getconf = netBSDDerivation {
    path = "usr.bin/getconf";
    sha256 = "122vslz4j3h2mfs921nr2s6m078zcj697yrb75rwp2hnw3qz4s8q";
    version = "7.1.2";
  };

  games = netBSDDerivation {
    path = "games";
    sha256 = "04wjsang8f8kxsifiayklbxaaxmm3vx9rfr91hfbxj4hk8gkqzy1";
    version = "7.1.2";
    patchPhase = ''
      sed -i '1i #include <time.h>' adventure/save.c

      # Disable some games that don't build. They should be possible
      # to build but need to look at how to implement stuff in
      # Linux. macOS is missing gettime. TODO try to get these
      # working.
      disableGame() {
        substituteInPlace Makefile --replace $1 ""
      }

      disableGame atc
      disableGame boggle
      disableGame dm
      disableGame fortune
      disableGame hunt
      disableGame larn
      disableGame phantasia
      disableGame rogue
      disableGame sail
      disableGame trek
      disableGame dab
      ${lib.optionalString stdenv.isDarwin "disableGame adventure"}
      ${lib.optionalString stdenv.isDarwin "disableGame factor"}
      ${lib.optionalString stdenv.isDarwin "disableGame gomoku"}
      ${lib.optionalString stdenv.isDarwin "disableGame mille"}

      substituteInPlace Makefile.inc \
        --replace 2555 555 \
        --replace 2550 550
    '';
    NIX_CFLAGS_COMPILE = [
      "-D__noinline="
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-DOXTABS=XTABS"
      "-DRANDOM_MAX=RAND_MAX"
      "-DINFTIM=-1"
      (if hostPlatform.isMusl then "-include sys/ttydefaults.h -include sys/file.h" else "")
    ];
    postBuild = ''
      mkdir -p $out/usr/games $out/usr/share/games/ching \
               $out/usr/share/games/quiz.db \
               $out/usr/libexec/ching $out/var/games/hackdir
      touch $out/var/games/hackdir/perm
    '';
    preFixup = ''
      mkdir -p $out/bin
      mv $out/games/* $out/bin
      rmdir $out/games
    '';
    buildInputs = [ compat libcurses libterminfo libressl ];
    extraPaths = [
      (fetchNetBSD "share/dict" "7.1.2" "0nickhsjwgnr2h9nvwflvgfz93kqms5hzdnpyq02crpj35w98bh4")
      who.src
    ];
  };

  # finger = netBSDDerivation {
  #   path = "usr.bin/finger";
  #   sha256 = "0jl672z50f2yf7ikp682b3xrarm6bnrrx9vi94xnp2fav8m8zfyi";
  #   version = "7.1.2";
  #   extraPaths = [ who.src ];
  #   NIX_CFLAGS_COMPILE = [
  #     "-DSUPPORT_UTMP"
  #     "-USUPPORT_UTMPX"
  #   ];
  #   patchPhase = ''
  #     ${who.patchPhase}
  #   '';
  # };

  fingerd = netBSDDerivation {
    path = "libexec/fingerd";
    sha256 = "1hhdq70hrxxkjnjfmjm3w8w9g9xq2ngxaxk0chy4vm7chg9nfpmp";
    version = "7.1.2";
  };

  libedit = netBSDDerivation {
    path = "lib/libedit";
    buildInputs = [ libterminfo libcurses ];
    propagatedBuildInputs = [ compat ];
    postBuild = "mkdir -p $out/usr/include/readline";
    patchPhase = ''
      sed -i '1i #undef bool_t' el.h
      substituteInPlace config.h \
        --replace "#define HAVE_STRUCT_DIRENT_D_NAMLEN 1" ""
    '';
    NIX_CFLAGS_COMPILE = [
      "-D__noinline="
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
    ];
    version = "7.1.2";
    sha256 = "0qvr52j4qih10m7fa8nddn1psyjy9l0pa4ix02acyssjvgbz2kca";
  };

  libterminfo = netBSDDerivation {
    path = "lib/libterminfo";
    version = "7.1.2";
    sha256 = "06plg0bjqgbb0aghpb9qlk8wkp1l2izdlr64vbr5laqyw8jg84zq";
    buildInputs = [ compat tic nbperf ];
    MKPIC = if stdenv.isDarwin then "no" else "yes";
    extraPaths = [
      (fetchNetBSD "share/terminfo" "7.1.2" "1z5vzq8cw24j05r6df4vd6r57cvdbv7vbm4h962kplp14xrbg2h3")
    ];
  };

  libcurses = netBSDDerivation {
    path = "lib/libcurses";
    version = "7.1.2";
    sha256 = "04djah9dadzw74nswn0xydkxn900kav8xdvxlxdl50nbrynxg9yf";
    buildInputs = [ libterminfo ];
    NIX_CFLAGS_COMPILE = [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ] ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)=";
    propagatedBuildInputs = [ compat ];
    MKDOC = "no"; # missing vfontedpr
    MKPIC = if stdenv.isDarwin then "no" else "yes";
    patchPhase = lib.optionalString (!stdenv.isDarwin) ''
      substituteInPlace printw.c \
        --replace "funopen(win, NULL, __winwrite, NULL, NULL)" NULL \
        --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
      substituteInPlace scanw.c \
        --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
    '';
  };

  nbperf = netBSDDerivation {
    path = "usr.bin/nbperf";
    version = "7.1.2";
    sha256 = "0gzm0zv2400lasnsswnjw9bwzyizhxzdbrcjwcl1k65aj86aqyqb";
  };

  tic = netBSDDerivation {
    path = "tools/tic";
    version = "7.1.2";
    sha256 = "092y7db7k4kh2jq8qc55126r5qqvlb8lq8mhmy5ipbi36hwb4zrz";
    HOSTPROG = "tic";
    buildInputs = [ compat nbperf ];
    extraPaths = [
      libterminfo.src
      (fetchNetBSD "usr.bin/tic" "7.1.2" "1ghwsaag4gbwvgp3lfxscnh8hn27n8cscwmgjwp3bkx5vl85nfsa")
      (fetchNetBSD "tools/Makefile.host" "7.1.2" "076r3amivb6xranpvqjmg7x5ibj4cbxaa3z2w1fh47h7d55dw9w8")
    ];
  };

}
