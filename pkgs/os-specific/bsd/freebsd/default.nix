{ stdenv, lib, stdenvNoCC
, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget, pkgsHostHost, pkgsTargetTarget
, buildPackages, splicePackages, newScope
, bsdSetupHook, makeSetupHook
, fetchgit, fetchurl, coreutils, groff, mandoc, byacc, flex, which, m4, gawk, substituteAll, runtimeShell
, zlib, expat, libmd
, runCommand, writeShellScript, writeText, symlinkJoin
}:

let
  inherit (buildPackages.buildPackages) rsync;

  version = "13.1.0";

  # `BuildPackages.fetchgit` avoids some probably splicing-caused infinite
  # recursion.
  freebsdSrc = buildPackages.fetchgit {
    url = "https://git.FreeBSD.org/src.git";
    rev = "release/${version}";
    sha256 = "14nhk0kls83xfb64d5xy14vpi6k8laswjycjg80indq9pkcr2rlv";
  };

  freebsdSetupHook = makeSetupHook {
    name = "freebsd-setup-hook";
  } ./setup-hook.sh;

  otherSplices = {
    selfBuildBuild = pkgsBuildBuild.freebsd;
    selfBuildHost = pkgsBuildHost.freebsd;
    selfBuildTarget = pkgsBuildTarget.freebsd;
    selfHostHost = pkgsHostHost.freebsd;
    selfTargetTarget = pkgsTargetTarget.freebsd or {}; # might be missing
  };

  mkBsdArch = stdenv':  {
    x86_64 = "amd64";
    aarch64 = "arm64";
    i486 = "i386";
    i586 = "i386";
    i686 = "i386";
  }.${stdenv'.hostPlatform.parsed.cpu.name}
    or stdenv'.hostPlatform.parsed.cpu.name;

  install-wrapper = ''
    set -eu

    args=()
    declare -i path_args=0

    while (( $# )); do
      if (( $# == 1 )); then
        if (( path_args > 1)) || [[ "$1" = */ ]]; then
          mkdir -p "$1"
        else
          mkdir -p "$(dirname "$1")"
        fi
      fi
      case $1 in
        -C) ;;
        -o | -g) shift ;;
        -s) ;;
        -m | -l)
          # handle next arg so not counted as path arg
          args+=("$1" "$2")
          shift
          ;;
        -*) args+=("$1") ;;
        *)
          path_args+=1
          args+=("$1")
          ;;
      esac
      shift
    done
  '';

in lib.makeScopeWithSplicing
  splicePackages
  newScope
  otherSplices
  (_: {})
  (_: {})
  (self: let
    inherit (self) mkDerivation;
  in {
  inherit freebsdSrc;

  # Why do we have splicing and yet do `nativeBuildInputs = with self; ...`?
  # See note in ../netbsd/default.nix.

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isFreeBSD) self.compat;

  mkDerivation = lib.makeOverridable (attrs: let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in stdenv'.mkDerivation (rec {
    pname = "${attrs.pname or (baseNameOf attrs.path)}-freebsd";
    inherit version;
    src = runCommand "${pname}-filtered-src" {
      nativeBuildInputs = [ rsync ];
    } ''
      for p in ${lib.concatStringsSep " " ([ attrs.path ] ++ attrs.extraPaths or [])}; do
        set -x
        path="$out/$p"
        mkdir -p "$(dirname "$path")"
        src_path="${freebsdSrc}/$p"
        if [[ -d "$src_path" ]]; then src_path+=/; fi
        rsync --chmod="+w" -r "$src_path" "$path"
        set +x
      done
    '';

    extraPaths = [ ];

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal
      install tsort lorder mandoc groff #statHook
    ];
    buildInputs = with self; compatIfNeeded;

    HOST_SH = stdenv'.shell;

    # Since STRIP below is the flag
    STRIPBIN = "${stdenv.cc.bintools.targetPrefix}strip";

    makeFlags = [
      "STRIP=-s" # flag to install, not command
    ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";

    # amd64 not x86_64 for this on unlike NetBSD
    MACHINE_ARCH = mkBsdArch stdenv';

    MACHINE = mkBsdArch stdenv';

    MACHINE_CPUARCH = MACHINE_ARCH;

    COMPONENT_PATH = attrs.path or null;

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

    buildInputs = with self; [];
    nativeBuildInputs = with buildPackages.netbsd; [ bsdSetupHook freebsdSetupHook ];

    skipIncludesPhase = true;

    makeFlags = [];

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

      install -D bmake "$out/bin/bmake"
      ln -s "$out/bin/bmake" "$out/bin/make"
      mkdir -p "$out/share"
      cp -r "$BSDSRCDIR/share/mk" "$out/share/mk"
      find "$out/share/mk" -type f -print0 |
        while IFS= read -r -d "" f; do
          substituteInPlace "$f" --replace 'usr/' ""
        done
      substituteInPlace "$out/share/mk/bsd.symver.mk" \
        --replace '/share/mk' "$out/share/mk"

      runHook postInstall
    '';

    postInstall = lib.optionalString (!stdenv.targetPlatform.isFreeBSD) ''
      boot_mk="$BSDSRCDIR/tools/build/mk"
      cp "$boot_mk"/Makefile.boot* "$out/share/mk"
      replaced_mk="$out/share/mk.orig"
      mkdir "$replaced_mk"
      mv "$out"/share/mk/bsd.{lib,prog}.mk "$replaced_mk"
      for m in bsd.{lib,prog}.mk; do
        cp "$boot_mk/$m" "$out/share/mk"
        substituteInPlace "$out/share/mk/$m" --replace '../../../share/mk' '../mk.orig'
      done
    '';

    extraPaths = with self; make.extraPaths;
  };

  # Wrap NetBSD's install
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''

    ${buildPackages.netbsd.install}/bin/xinstall "''${args[@]}"
  '');

  compat = mkDerivation rec {
    pname = "compat";
    path = "tools/build";
    extraPaths = [
      "lib/libc/db"
      "lib/libc/stdlib" # getopt
      "lib/libc/gen" # getcap
      "lib/libc/locale" # rpmatch
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
      "lib/libc/string" # strlcpy
      "lib/libutil"
    ] ++ [
      "contrib/libc-pwcache"
      "contrib/libc-vis"
      "sys/libkern"
      "sys/kern/subr_capability.c"

      # Take only individual headers, or else we will clobber native libc, etc.

      "sys/rpc/types.h"

      # Listed in Makekfile as INC
      "include/mpool.h"
      "include/ndbm.h"
      "include/err.h"
      "include/stringlist.h"
      "include/a.out.h"
      "include/nlist.h"
      "include/db.h"
      "include/getopt.h"
      "include/nl_types.h"
      "include/elf.h"
      "sys/sys/ctf.h"

      # Listed in Makekfile as SYSINC

      "sys/sys/capsicum.h"
      "sys/sys/caprights.h"
      "sys/sys/imgact_aout.h"
      "sys/sys/nlist_aout.h"
      "sys/sys/nv.h"
      "sys/sys/dnv.h"
      "sys/sys/cnv.h"

      "sys/sys/elf32.h"
      "sys/sys/elf64.h"
      "sys/sys/elf_common.h"
      "sys/sys/elf_generic.h"
      "sys/${mkBsdArch stdenv}/include"
    ] ++ lib.optionals stdenv.hostPlatform.isx86 [
      "sys/x86/include"
    ] ++ [

      "sys/sys/queue.h"
      "sys/sys/md5.h"
      "sys/sys/sbuf.h"
      "sys/sys/tree.h"
      "sys/sys/font.h"
      "sys/sys/consio.h"
      "sys/sys/fnv_hash.h"

      "sys/crypto/chacha20/_chacha.h"
      "sys/crypto/chacha20/chacha.h"
      # included too, despite ".c"
      "sys/crypto/chacha20/chacha.c"

      "sys/fs"
      "sys/ufs"
      "sys/sys/disk"

      "lib/libcapsicum"
      "lib/libcasper"
    ];

    patches = [
      ./compat-install-dirs.patch
      ./compat-fix-typedefs-locations.patch
    ];

    preBuild = ''
      NIX_CFLAGS_COMPILE+=' -I../../include -I../../sys'

      cp ../../sys/${mkBsdArch stdenv}/include/elf.h ../../sys/sys
      cp ../../sys/${mkBsdArch stdenv}/include/elf.h ../../sys/sys/${mkBsdArch stdenv}
    '' + lib.optionalString stdenv.hostPlatform.isx86 ''
      cp ../../sys/x86/include/elf.h ../../sys/x86
    '';

    setupHooks = [
      ../../../build-support/setup-hooks/role.bash
      ./compat-setup-hook.sh
    ];

    # This one has an ifdefed `#include_next` that makes it annoying.
    postInstall = ''
      rm ''${!outputDev}/0-include/libelf.h
    '';

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal
      boot-install

      which
    ];
    buildInputs = [ expat zlib ];

    makeFlags = [
      "STRIP=-s" # flag to install, not command
      "MK_WERROR=no"
      "HOST_INCLUDE_ROOT=${lib.getDev stdenv.cc.libc}/include"
      "INSTALL=boot-install"
    ];

    preIncludes = ''
      mkdir -p $out/{0,1}-include
      cp --no-preserve=mode -r cross-build/include/common/* $out/0-include
    '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      cp --no-preserve=mode -r cross-build/include/linux/* $out/1-include
    '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp --no-preserve=mode -r cross-build/include/darwin/* $out/1-include
    '';
  };

  libnetbsd = mkDerivation {
    path = "lib/libnetbsd";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal mandoc groff
      (if stdenv.hostPlatform == stdenv.buildPlatform
       then boot-install
       else install)
    ];
    patches = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
      ./libnetbsd-do-install.patch
      #./libnetbsd-define-__va_list.patch
    ];
    makeFlags = [
      "STRIP=-s" # flag to install, not command
      "MK_WERROR=no"
    ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
    buildInputs = with self; compatIfNeeded;
  };

  # HACK: to ensure parent directories exist. This emulates GNU
  # install’s -D option. No alternative seems to exist in BSD install.
  install = let binstall = writeShellScript "binstall" (install-wrapper + ''

    @out@/bin/xinstall "''${args[@]}"
  ''); in mkDerivation {
    path = "usr.bin/xinstall";
    extraPaths = with self; [ mtree.path ];
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal mandoc groff
      (if stdenv.hostPlatform == stdenv.buildPlatform
       then boot-install
       else install)
    ];
    skipIncludesPhase = true;
    buildInputs = with self; compatIfNeeded ++ [ libmd libnetbsd ];
    makeFlags = [
      "STRIP=-s" # flag to install, not command
      "MK_WERROR=no"
      "TESTSDIR=${builtins.placeholder "test"}"
    ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
    postInstall = ''
      install -D -m 0550 ${binstall} $out/bin/binstall
      substituteInPlace $out/bin/binstall --subst-var out
      mv $out/bin/install $out/bin/xinstall
      ln -s ./binstall $out/bin/install
    '';
    outputs = [ "out" "man" "test" ];
  };

  sed = mkDerivation {
    path = "usr.bin/sed";
    TESTSRC = "${freebsdSrc}/contrib/netbsd-tests";
    MK_TESTS = "no";
  };

  # Don't add this to nativeBuildInputs directly.  Use statHook instead.
  stat = mkDerivation {
    path = "usr.bin/stat";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff
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
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff
    ];
  };

  lorder = mkDerivation rec {
    path = "usr.bin/lorder";
    noCC = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/bin" "$man/share/man"
      mv "lorder.sh" "$out/bin/lorder"
      chmod +x "$out/bin/lorder"
      mv "lorder.1" "$man/share/man"
    '';
    nativeBuildInputs = [ bsdSetupHook freebsdSetupHook ];
    buildInputs = [];
    outputs = [ "out" "man" ];
  };

  ##
  ## END BOOTSTRAPPING
  ##

  ##
  ## START COMMAND LINE TOOLS
  ##
  make = mkDerivation {
    path = "contrib/bmake";
    version = "9.2";
    postPatch = ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace '-Wl,--fatal-warnings' "" \
        --replace '-Wl,--warn-shared-textrel' ""
    '';
    postInstall = ''
      make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
    '';
    extraPaths = [ "share/mk" ]
      ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "tools/build/mk";
  };
  mtree = mkDerivation {
    path = "contrib/mtree";
    extraPaths = with self; [ mknod.path ];
  };

  mknod = mkDerivation {
    path = "sbin/mknod";
  };

  rpcgen = mkDerivation rec {
    path = "usr.bin/rpcgen";
    patches = lib.optionals (stdenv.hostPlatform.libc == "glibc") [
      # `WUNTRACED` is defined privately `bits/waitflags.h` in glibc.
      # But instead of having a regular header guard, it has some silly
      # non-modular logic. `stdlib.h` will include it if `sys/wait.h`
      # hasn't yet been included (for it would first), and vice versa.
      #
      # The problem is that with the FreeBSD compat headers, one of
      # those headers ends up included other headers...which ends up
      # including the other one, this means by the first time we reach
      # `#include `<bits/waitflags.h>`, both `_SYS_WAIT_H` and
      # `_STDLIB_H` are already defined! Thus, we never ned up including
      # `<bits/waitflags.h>` and defining `WUNTRACED`.
      #
      # This hacks around this by manually including `WUNTRACED` until
      # the problem is fixed properly in glibc.
      ./rpcgen-glibc-hack.patch
    ];
  };

  gencat = mkDerivation {
    path = "usr.bin/gencat";
  };

  file2c = mkDerivation {
    path = "usr.bin/file2c";
    MK_TESTS = "no";
  };

  libnv = mkDerivation {
    path = "lib/libnv";
    extraPaths = [
      "sys/contrib/libnv"
      "sys/sys"
    ];
    MK_TESTS = "no";
  };

  libsbuf = mkDerivation {
    path = "lib/libsbuf";
    extraPaths = [
      "sys/kern"
    ];
    MK_TESTS = "no";
  };

  libelf = mkDerivation {
    path = "lib/libelf";
    extraPaths = [
      "contrib/elftoolchain/libelf"
      "contrib/elftoolchain/common"
      "sys/sys/elf32.h"
      "sys/sys/elf64.h"
      "sys/sys/elf_common.h"
    ];
    BOOTSTRAPPING = !stdenv.isFreeBSD;
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff

      m4
    ];
    MK_TESTS = "no";
  };

  libdwarf = mkDerivation {
    path = "lib/libdwarf";
    extraPaths = [
      "contrib/elftoolchain/libdwarf"
      "contrib/elftoolchain/common"
      "sys/sys/elf32.h"
      "sys/sys/elf64.h"
      "sys/sys/elf_common.h"
    ];
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff

      m4
    ];
    buildInputs = with self; compatIfNeeded ++ [
      libelf
    ];
    MK_TESTS = "no";
  };

  uudecode = mkDerivation {
    path = "usr.bin/uudecode";
    MK_TESTS = "no";
  };

  config = mkDerivation {
    path = "usr.sbin/config";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff

      flex byacc file2c
    ];
    buildInputs = with self; compatIfNeeded ++ [ libnv libsbuf ];
  };
  ##
  ## END COMMAND LINE TOOLS
  ##

  ##
  ## START HEADERS
  ##
  include = mkDerivation {
    path = "include";

    extraPaths = [
      "contrib/libc-vis"
      "etc/mtree/BSD.include.dist"
      "sys"
    ];

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal
      install
      mandoc groff rsync /*nbperf*/ rpcgen

      # HACK use NetBSD's for now
      buildPackages.netbsd.mtree
    ];

    patches = [
      ./no-perms-BSD.include.dist.patch
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

    makeFlags = [
      "RPCGEN_CPP=${buildPackages.stdenv.cc.cc}/bin/cpp"
    ];

    # multiple header dirs, see above
    postConfigure = ''
      makeFlags=''${makeFlags/INCSDIR/INCSDIR0}
    '';

    headersOnly = true;

    MK_HESIOD = "yes";

    meta.platforms = lib.platforms.freebsd;
  };

  ##
  ## END HEADERS
  ##

  csu = mkDerivation {
    path = "lib/csu";
    extraPaths = with self; [
      "lib/Makefile.inc"
      "lib/libc/include/libc_private.h"
    ];
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal
      install

      flex byacc gencat
    ];
    buildInputs = with self; [ include ];
    MK_TESTS = "no";
    meta.platforms = lib.platforms.freebsd;
  };

  libc = mkDerivation rec {
    pname = "libc";
    path = "lib/libc";
    extraPaths = [
      "etc/group"
      "etc/master.passwd"
      "etc/shells"
      "lib/libmd"
      "lib/libutil"
      "lib/msun"
      "sys/kern"
      "sys/libkern"
      "sys/sys"
      "sys/crypto/chacha20"
      "include/rpcsvc"
      "contrib/jemalloc"
      "contrib/gdtoa"
      "contrib/libc-pwcache"
      "contrib/libc-vis"
      "contrib/tzcode/stdtime"

      # libthr
      "lib/libthr"
      "lib/libthread_db"
      "libexec/rtld-elf"

      # librpcsvc
      "lib/librpcsvc"

      # librt
      "lib/librt"

      # libcrypt
      "lib/libcrypt"
      "lib/libmd"
      "sys/crypto/sha2"
    ];

    patches = [
      # Hack around broken propogating MAKEFLAGS to submake, just inline logic
      ./libc-msun-arch-subdir.patch

      # Don't force -lcompiler-rt, we don't actually call it that
      ./libc-no-force--lcompiler-rt.patch

      # Fix extra include dir to get rpcsvc headers.
      ./librpcsvc-include-subdir.patch
    ];

    postPatch = ''
      substituteInPlace $COMPONENT_PATH/Makefile --replace '.include <src.opts.mk>' ""
    '';

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal
      install

      flex byacc gencat rpcgen
    ];
    buildInputs = with self; [ include csu ];
    NIX_CFLAGS_COMPILE = "-B${self.csu}/lib";

    makeFlags = [
      "STRIP=-s" # flag to install, not command
      # lib/libc/gen/getgrent.c has sketchy cast from `void *` to enum
      "MK_WERROR=no"
    ];

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

    MK_TCSH = "no";
    MK_MALLOC_PRODUCTION = "yes";

    MK_TESTS = "no";

    postInstall = ''
      pushd ${self.include}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      pushd ${self.csu}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      sed -i -e 's| [^ ]*/libc_nonshared.a||' $out/lib/libc.so

      $CC -nodefaultlibs -lgcc -shared -o $out/lib/libgcc_s.so

      NIX_CFLAGS_COMPILE+=" -B$out/lib"
      NIX_CFLAGS_COMPILE+=" -I$out/include"
      NIX_LDFLAGS+=" -L$out/lib"

      make -C $BSDSRCDIR/lib/libthr $makeFlags
      make -C $BSDSRCDIR/lib/libthr $makeFlags install

      make -C $BSDSRCDIR/lib/msun $makeFlags
      make -C $BSDSRCDIR/lib/msun $makeFlags install

      make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
      make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install

      make -C $BSDSRCDIR/lib/libutil $makeFlags
      make -C $BSDSRCDIR/lib/libutil $makeFlags install

      make -C $BSDSRCDIR/lib/librt $makeFlags
      make -C $BSDSRCDIR/lib/librt $makeFlags install

      make -C $BSDSRCDIR/lib/libcrypt $makeFlags
      make -C $BSDSRCDIR/lib/libcrypt $makeFlags install
    '';

    meta.platforms = lib.platforms.freebsd;
  };

  ##
  ## Kernel
  ##

  libspl = mkDerivation {
    path = "cddl/lib/libspl";
    extraPaths = [
      "sys/contrib/openzfs/lib/libspl"
      "sys/contrib/openzfs/include"

      "cddl/compat/opensolaris/include"
      "sys/contrib/openzfs/module/icp/include"
      "sys/modules/zfs"
    ];
    # nativeBuildInputs = with buildPackages.freebsd; [
    #   bsdSetupHook freebsdSetupHook
    #   makeMinimal install mandoc groff

    #   flex byacc file2c
    # ];
    # buildInputs = with self; compatIfNeeded ++ [ libnv libsbuf ];
    meta.license = lib.licenses.cddl;
  };

  ctfconvert = mkDerivation {
    path = "cddl/usr.bin/ctfconvert";
    extraPaths = [
      "cddl/compat/opensolaris"
      "cddl/contrib/opensolaris"
      "sys/cddl/compat/opensolaris"
      "sys/cddl/contrib/opensolaris"
      "sys/contrib/openzfs"
    ];
    OPENSOLARIS_USR_DISTDIR = "$(SRCTOP)/cddl/contrib/opensolaris";
    OPENSOLARIS_SYS_DISTDIR = "$(SRCTOP)/sys/cddl/contrib/opensolaris";
    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff

      # flex byacc file2c
    ];
    buildInputs = with self; compatIfNeeded ++ [
      libelf libdwarf zlib libspl
    ];
    meta.license = lib.licenses.cddl;
  };

  xargs-j = substituteAll {
    name = "xargs-j";
    shell = runtimeShell;
    src = ../xargs-j.sh;
    dir = "bin";
    isExecutable = true;
  };

  sys = mkDerivation (let
    cfg = "MINIMAL";
  in rec {
    path = "sys";

    nativeBuildInputs = with buildPackages.freebsd; [
      bsdSetupHook freebsdSetupHook
      makeMinimal install mandoc groff

      config rpcgen file2c gawk uudecode xargs-j
      #ctfconvert
    ];

    patches = [
      ./sys-gnu-date.patch
      ./sys-no-explicit-intrinsics-dep.patch
    ];

    # --dynamic-linker /red/herring is used when building the kernel.
    NIX_ENFORCE_PURITY = 0;

    AWK = "${buildPackages.gawk}/bin/awk";

    CWARNEXTRA = "-Wno-error=shift-negative-value -Wno-address-of-packed-member";

    MK_CTF = "no";

    KODIR = "${builtins.placeholder "out"}/kernel";
    KMODDIR = "${builtins.placeholder "out"}/kernel";
    DTBDIR = "${builtins.placeholder"out"}/dbt";

    KERN_DEBUGDIR = "${builtins.placeholder "out"}/debug";
    KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
    KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

    skipIncludesPhase = true;

    configurePhase = ''
      runHook preConfigure

      for f in conf/kmod.mk contrib/dev/acpica/acpica_prep.sh; do
        substituteInPlace "$f" --replace 'xargs -J' 'xargs-j '
      done

      for f in conf/*.mk; do
        substituteInPlace "$f" --replace 'KERN_DEBUGDIR}''${' 'KERN_DEBUGDIR_'
      done

      cd ${mkBsdArch stdenv}/conf
      sed -i ${cfg} \
        -e 's/WITH_CTF=1/WITH_CTF=0/' \
        -e '/KDTRACE/d'
      config ${cfg}

      runHook postConfigure
    '';
    preBuild = ''
      cd ../compile/${cfg}
    '';
  });

})
