{ stdenv, lib, stdenvNoCC
, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget, pkgsHostHost, pkgsTargetTarget
, buildPackages, splicePackages, newScope
, bsdSetupHook, makeSetupHook, fetchgit, fetchurl, groff, mandoc, byacc, flex
, zlib, expat, libbsd
, writeText, symlinkJoin, runCommand
}:

let
  version = "13.0.0";

  freebsdSrc = fetchgit {
    url = "https://git.FreeBSD.org/src.git";
    rev = "release/${version}";
    sha256 = "1r5v9i3ajgqmkrvgp4pdz98g2q6dagzjb2hxpbwcwndisvz28rnr";
  };

  otherSplices = {
    selfBuildBuild = pkgsBuildBuild.freebsd;
    selfBuildHost = pkgsBuildHost.freebsd;
    selfBuildTarget = pkgsBuildTarget.freebsd;
    selfHostHost = pkgsHostHost.freebsd;
    selfTargetTarget = pkgsTargetTarget.freebsd or {}; # might be missing
  };

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
  # See note in ../netbsd/default.nix.

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isNetBSD) libbsd;

  mkDerivation = lib.makeOverridable (attrs: let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in stdenv'.mkDerivation (rec {
    pname = "${attrs.pname or (baseNameOf attrs.path)}-freebsd";
    inherit version;
    src = runCommand "${pname}-filtered-src" {} ''
      for p in ${lib.concatStringsSep " " ([ attrs.path ] ++ attrs.extraPaths or [])}; do
        path=$out/$p
        mkdir -p "$path"
        cp -r "${freebsdSrc}/$p/." "$path"
      done
    '';

    extraPaths = [ ];

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
      makeMinimal
      install tsort lorder mandoc groff statHook
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

    MACHINE_CPUARCH = MACHINE_ARCH;

    BSD_PATH = attrs.path or null;

    strictDeps = true;

    meta = with lib; {
      maintainers = with maintainers; [ ericson2314 ];
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
  } // attrs));

  ##
  ## START BOOTSTRAPPING
  ##
  makeMinimal = mkDerivation rec {
    inherit (self.make) path;
    sha256 = "0fh0nrnk18m613m5blrliq2aydciv51qhc0ihsj4k63incwbk90n";
    version = "9.2";

    buildInputs = with self; [];
    nativeBuildInputs = with buildPackages.netbsd; [ bsdSetupHook ];

    skipIncludesPhase = true;

    postPatch = ''
      patchShebangs configure
      ${self.make.postPatch}
    '';

    buildPhase = ''
      runHook preBuild

      sh ./make-bootstrap.sh

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -D bmake $out/bin/bmake
      ln -s $out/bin/bmake $out/bin/make
      mkdir -p $out/share
      cp -r $BSDSRCDIR/share/mk $out/share/mk

      runHook postInstall
    '';

    extraPaths = with self; make.extraPaths;
  };

  # libbsd is a better base than NetBSD's libcompat for FreeBSD as only the
  # former includes some free-BSD-isms.
  compat = mkDerivation rec {
    pname = "freebsd-glue";
    version = "0.2.22";
    src = fetchgit {
      url = "https://salsa.debian.org/bsd-team/${pname}.git";
      rev = "cf59995384ae04b3cd906772abf1f0f9dfaea0c1";
      sha256 = "0aris7k6himp8gjdycj9w9s3lb1dc86d771yik28rd9a5iz9i8js";
    };
    patches = [
      (builtins.toFile "avoid-dpkg-architecture.path" ''
        diff --git a/src/freebsd-glue/Makefile b/src/freebsd-glue/Makefile
        index f34fc1a..bd7f1f1 100644
        --- a/src/freebsd-glue/Makefile
        +++ b/src/freebsd-glue/Makefile
        @@ -13,7 +13,7 @@ SRCS= \

         LDADD=	-lbsd

        -SYS!=	dpkg-architecture -qDEB_HOST_GNU_SYSTEM
        +SYS =	${if stdenv.hostPlatform.isFreeBSD then "kfreebsd-gnu" else "nope"}

         .if ''${SYS} == "kfreebsd-gnu"
         SRCS+=	\
      '')
    ];
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
      buildPackages.netbsd.makeMinimal
      #tsort
      #lorder
    ];
    #makeFlags = defaultMakeFlags ++ [ "-d x" ];
    buildInputs = [ libbsd expat zlib ];
    outputs = [ "out" "dev" ];
  };

  lorder = mkDerivation rec {
    path = "usr.bin/lorder";
    sha256 = "07zzaxlxvlxgmj4c5wcn2m58b68j95q9qsz8x0jvjhqc7pjgyb0b";
    noCC = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/bin" "$man/share/man"
      mv "$BSDSRCDIR/${path}/lorder.sh" "$out/bin/lorder"
      chmod +x "$out/bin/lorder"
      mv "$BSDSRCDIR/${path}/lorder.1" "$man/share/man"
      exit 0;
    '';
    nativeBuildInputs = [ bsdSetupHook ];
    buildInputs = [];
    outputs = [ "out" "man" ];
  };

  fts = mkDerivation {
    pname = "fts";
    path = "include/fts.h";
    sha256 = "1z1dc7kzzjwa460g3g81sfjifl7sbc2nfbwww13vadvh29bv5qly";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
    ];
    propagatedBuildInputs = [  ];
    extraPaths = with self; [
      "lib/libc/gen/fts.c"
      "lib/libc/include/namespace.h"
      "lib/libc/gen/fts.3"
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
      ./../netbsd/fts-setup-hook.sh
    ];
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
    sha256 = "1kdldj7qial9yry1d5dzfi925lp61hcnwbnj6p8dfi9fm0vxw164";
    #extraPaths = with self; [ mtree.src make.src ];
    #extraPaths = with self; [ make.src ];
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
      buildPackages.netbsd.makeMinimal mandoc groff
    ];
    skipIncludesPhase = true;
    buildInputs = with self; [ fts ];
    installPhase = ''
      runHook preInstall

      install -D install.1 $out/share/man/man1/install.1
      install -D xinstall $out/bin/xinstall
      install -D -m 0550 ${binstall} $out/bin/binstall
      ln -s $out/bin/binstall $out/bin/install

      runHook postInstall
path'';
  };

  stat = mkDerivation {
    path = "usr.bin/stat";
    sha256 = "1rnxr1364aip7dkf09mmwgw82a5vpa7873p9iid7g7gavlldgh04";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
      buildPackages.netbsd.makeMinimal install mandoc groff
    ];
  };

  tsort = mkDerivation {
    path = "usr.bin/tsort";
    sha256 = "0rbdw2a13fmp4xa6alqcrr4qd92qhxiakyhsbzcgnns25nxhgxkb";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook
      buildPackages.netbsd.makeMinimal install mandoc groff
    ];
    buildInputs = [];
  };

  ##
  ## END BOOTSTRAPPING
  ##

  make = mkDerivation {
    path = "contrib/bmake";
    sha256 = "0vi73yicbmbp522qzqvd979cx6zm5jakhy77xh73c1kygf8klccs";
    version = "9.2";
    postPatch = ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

      substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
        --replace '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
    '';
    postInstall = ''
      make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
    '';
    extraPaths = [ "share/mk" ];
  };

  rpcgen = mkDerivation rec {
    path = "usr.bin/rpcgen";
    sha256 = "1201cnbfkchin792d9rfagygp4ky2kxz10zavfcl1hkcq9ajdqwd";
    # for debugging
    # makeFlags = defaultMakeFlags ++ [ "-d x" ];
    # NIX_DEBUG = 7;
  };

  libc = mkDerivation rec {
    pname = "libc";

    #src = fetchFreeBSD "" "0rmq7jlymjq3k9d9j5yr85krk2lmmgyjfwzybb02h4dfyq0wssri";
    #src = runCommand "filtered-freebsd-src-root" {} ''
    #  mkdir -p $out/lib
    #  cp --no-preserve=mode -r  \
    #    ${fetchFreeBSD "lib/libc" "1baqzyy7pa4snplg0bgh77p76sqkz9j92r36lp1k8341im4w4sas"} \
    #    "$out/lib/libc"
    #  cp --no-preserve=mode -r  \
    #    ${fetchFreeBSD "lib/libmd" "083bpikmlq82xqz14g29bcsm8iaiy3n9xd1v725bvb1j2yc9xg5n"} \
    #    "$out/lib/libmd"
    #  cp --no-preserve=mode -r \
    #    ${fetchFreeBSD "lib/msun" "1bnz3vx380b6fqkd3jmfajazmsasrwmmjak7mgl3dmvhjyxsss6r"} \
    #    "$out/lib/msun"
    #  mkdir -p $out/sys
    #  cp --no-preserve=mode -r \
    #    ${fetchFreeBSD "sys/sys" "1qd3fb14z939sv46yyalpdqq3kw7rgki599aswibjc1mfxxsbsai"} \
    #    "$out/sys/sys"
    #  mkdir -p $out/contrib
    #  cp --no-preserve=mode -r \
    #    ${fetchFreeBSD "contrib/libc-pwcache" "0sydgas4dimym1sbaqp1as70a1bg83iqpllfhys51gmjzqis02na"} \
    #    "$out/contrib/libc-pwcache"
    #  cp --no-preserve=mode -r \
    #    ${fetchFreeBSD "contrib/libc-vis" "14d8jjrh4j3n51vqwf2bdvci19k8xpfdq97gyqch4cakwi1p1fn1"} \
    #    "$out/contrib/libc-vis"
    #'';

    postUnpack = ''
      sourceRoot+="/lib/libc";
    '';

    preConfigure = ''
      export SRCTOP=$(readlink -e ../..)
      touch src.opts.mk
    '';

    MK_SYMVER = "yes";
    MK_SSP = "yes";
    MK_NLS = "yes";
    MK_ICONV = "no"; # TODO make srctop
    MK_NS_CACHING = "yes";
    MK_INET6_SUPPORT = "yes";
    MK_HESIOD = "yes";
    MK_NIS = "yes";
    MK_HYPERV = "yes";
    MK_FP_LIBC = "yes";
  };

})
