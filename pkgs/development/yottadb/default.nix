{
  lib,
  config,
  makeWrapper,
  stdenv,
  wrapperDir ? "/run/wrappers/bin",
  writeText,
  writeScript,

  cmake,
  coreutils-full,
  elfutils,
  fetchFromGitLab,
  git,
  glibcLocales,
  libxcrypt,
  icu,
  ncurses,
  openssl,
  pkg-config,
  tcsh,
  util-linux,
  zlib
}:

# To test this package, go to $NIXPKGS/nixos/tests and run:
#   $ $(nix-build -A driverInteractive yottadb.nix)/bin/nixos-test-driver -I
#   >>> test_script()

stdenv.mkDerivation rec {
  pname = "yottadb";
  version = "1.38";

  src = fetchFromGitLab {
    owner = "YottaDB";
    repo = "DB/YDB";
    rev = "r${version}";
    leaveDotGit = true;
    hash = "sha256-k6kAIdPW75cqdT+dXqjlS8TpT2NjQYBTceDzMvWD/oE=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = buildInputs ++ [
    cmake
    git
    icu.dev
    makeWrapper
    ncurses
    pkg-config
    tcsh
    zlib
  ];

  buildInputs = [
    coreutils-full
    elfutils.dev
    glibcLocales
    libxcrypt
    icu
    openssl
    util-linux
  ];

  # The version number is generated using git-describe
  # and any code patching makes this version number dirty.
  # Do not modify the git repo in any way!
  dontFixCmake = true;

  preConfigure = ''
    # The following cannot be passed to cmakeFlags directly due
    # to variable substitution
    cmakeFlags="$cmakeFlags -DYDB_INSTALL_DIR:STRING=$out/dist"
  '';

  preBuild = ''
    # Make sure that we can find all the runtime libs in order to
    # use the freshly built M compiler to build the M code...
    export LD_LIBRARY_PATH="${lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"

    # Revert any potential repo modifications to keep the release clean
    git reset --hard

    # =========
    # The following changes are not done as a conventional
    # patchset because we need to hardcode a fixed Nix store path
    # that is only known at package build time ($out).
    #
    # Background and motivation:
    #
    # gtmsecshr and gtmsecshr wrapper are two binaries that are
    # assumed to be SUID and owned by root user, they are also
    # assumed to be in $ydb_dist ($out/dist/gtmsecshr or
    # $out/dist/utf8/gtmsecshr) in case of gtmsecshr wrapper
    # and in $ydb_dist/gtmsecshrdir/gtmsecshr (or
    # $ydb_dist/utf8/gtmsecshrdir/gtmsecshr) in case of the
    # gtmsecshr daemon itself. The gtmsecshrdir is assumed to
    # be 0500 (but Nix store has all directories as 0555).
    #
    # The problem is that NixOS does not allow SUID binaries
    # in the Nix store itself, and all SUID has to be done
    # using security wrappers. These are stored outside of
    # the Nix store, which causes issues when the binary
    # assumes to be in a directory relative to the package
    # directory. Hardlinks are not possible because security
    # wrapper does not exist before package is installed
    # (chicken and egg problem), and softlinks are causing
    # realpath syscall to return path to the wrapper that
    # is outside of the package directory, breaking all the
    # runtime assertions.
    # Using makeBinWrapper that calls the security wrapper
    # does not fix this, because it only manipulates argv[0],
    # but YottaDB is using /proc/self/comm instead.
    #
    # Note that the changes below are developer enablers only,
    # and are NOT meant for production use until this is solved
    # properly. We don't know how is the YDB security model
    # affected by these changes...
    #
    # Changes required:
    #
    # (1) Nix Store does not support 500 on directories, only 555
    sed -ie s,0277,0222,g ../sr_unix/gtmsecshr_wrapper.c
    #
    # (2) gtmsecshr is SUID-wrapped and symlinked, so the realpath
    # and ydb_dist checks are not working correctly, so we need
    # to hack this a bit...
    fullSecshrPath="$out/${gtmsecshrSuidTargetRelative}"
    suffix="${gtmsecshrNosuidSuffix}"
    rndirLen=$((''${#fullSecshrPath}-''${#suffix}))
    sed -i \
        -e 's@rndir = realpath(PROCSELF, gtmsecshr_realpath);@rndir = realpath("'"$out/${gtmsecshrSuidTargetRelative}"'", gtmsecshr_realpath); rndir['$rndirLen'] = NULL;@g' \
        -e 's,path = ydb_dist,path = "'$out/dist'",g' \
        ../sr_unix/gtmsecshr.c
    # =========
  '';

  # NOTE: Setting exec_prefix=@@YDB_EXEDIR@@, includedir=@@YDB_INCDIR@@
  # and libdir=@@YDB_LIBDIR@@ breaks dependent software (YDBRust for
  # instance) for some reason.
  yottadbPkgConfigTemplate = writeText "yottadb.pc.in" ''
    prefix=@@YDB_DIST@@

    exec_prefix=''${prefix}
    includedir=''${prefix}
    libdir=''${exec_prefix}

    Name: YottaDB
    Description: YottaDB database library
    Version: ${version}
    Cflags: -I''${includedir}
    Libs: -L''${libdir} -lyottadb -Wl,-rpath,''${libdir}
  '';

  gtmsecshrNosuidSuffix = ".nosuid";
  gtmsecshrSuidName = "gtmsecshr";
  gtmsecshrSuidTargetRelative = "dist/gtmsecshrdir/gtmsecshr${gtmsecshrNosuidSuffix}";
  gtmsecshrWrapperSuidName = "gtmsecshr-wrapper";
  gtmsecshrWrapperSuidTargetRelative = "dist/gtmsecshr${gtmsecshrNosuidSuffix}";

  ydbGroup = "root";

  yottadbGde = writeScript "gde" ''
    #!/usr/bin/env bash
    # Use bin/yottadb, not dist/yottadb (see the note on yottadb-shell wrapper)
    exec @@YDB_PKG_DIR@@/bin/yottadb -r GDE "$@"
  '';

  postInstall = ''
    set -x
    # NOTE: In future, consider using a patched versions
    # of `ydbinstall` and `configure` scripts while
    # adding Nix-specific changes on top of that.

    mkdir -p $out/bin $out/lib $out/dist/utf8
    mkdir -p $out/lib/pkgconfig $out/include

    # We cannot set SUID for gtmsecshr wrapper, it has to be done
    # using Nix Security Wrapper (wrapping the wrapper)
    cd $out/dist
    # This is the gtmsecshr wrapper:
    mv gtmsecshr "$out/${gtmsecshrWrapperSuidTargetRelative}"
    # Can be symlink? We can't do hard-link before the wrapper is created!
    ln -rs "${wrapperDir}/${gtmsecshrWrapperSuidName}" gtmsecshr

    chmod 700 gtmsecshrdir
    cd $out/dist/gtmsecshrdir
    mv gtmsecshr "$out/${gtmsecshrSuidTargetRelative}"
    # Can be symlink? We can't do hard-link before the wrapper is created!
    ln -rs "${wrapperDir}/${gtmsecshrSuidName}" gtmsecshr
    chmod 500 $out/dist/gtmsecshrdir  # is this needed?
    cd $out/dist

    # Make sure we have ICU in library path (why is this needed only for ICU?)
    # NOTE: make{Binary}Wrapper can manipulate argv0, but not /proc/self/comm
    # so we will cheat a bit and have the following call structure:
    #   $out/bin/yottadb -> $out/dist/yottadb-shell -> $out/dist/yottadb
    makeWrapper "$out/dist/yottadb" "$out/dist/yottadb-shell" \
      --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath [ icu ]}" \
      --set-default ydb_dist $out/dist/utf8 \
      --set-default ydb_chset UTF-8 \
      --set-default ydb_icu_version $(icu-config --version) \
      --set-default LANG en_US.UTF-8 \
      --set-default LC_ALL en_US.UTF-8

    cd $out/dist
    ln -rs yottadb mumps
    sed -e "s,@@YDB_PKG_DIR@@,$out,g" "${yottadbGde}" > gde
    chmod a+x gde
    for utl in dse ftok gde gtcm_gnp_server gtcm_pkdisp gtcm_play gtcm_server gtcm_shmclean lke mupip semstat2 yottadb mumps ; do
      ln -rs $utl ../bin/
      ln -rs $utl ./utf8/
    done
    # The bin/yottadb will point to the yottadb-shell wrapper that
    # has most of the runtime environment vars set automatically
    # (also see the note on yottadb-shell makeWrapper)
    ln -rsf "$out/dist/yottadb-shell" $out/bin/yottadb
    ln -rsf "$out/dist/yottadb-shell" $out/bin/mumps
    ln -rs libyottadb.so ../lib/
    for inc in $(find -maxdepth 1 -mindepth 1 -name '*.h') ; do
      ln -rs $inc ../include/
      ln -rs $inc ./utf8/
    done
    ln -rs $out/dist/gtmsecshrdir $out/dist/utf8/gtmsecshrdir

    sed -e s,@@YDB_DIST@@,$out/dist,g \
        -e s,@@YDB_EXEDIR@@,$out/bin,g \
        -e s,@@YDB_INCDIR@@,$out/include,g \
        -e s,@@YDB_LIBDIR@@,$out/lib,g \
        ${yottadbPkgConfigTemplate} > $out/lib/pkgconfig/yottadb.pc

    # Embed source to OBJs, so that we can drop SRCs
    export ydb_compile="-embed_source -noignore"

    # Build M-mode dist
    export ydb_dist=$out/dist ydb_chset=M
    cd $ydb_dist
    $out/bin/yottadb -r %XCMD 'zhalt $s($zyre["r${version}":0,1:127)&$s($zch="M":0,1:126)'
    $out/bin/yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

    # Build UTF8-mode dist
    for rtn in *.m *.gld *.dat ; do
      ln -rs $rtn utf8/
    done
    unset ydb_chset ydb_icu_version ydb_dist
    cd $out/dist/utf8
    $out/bin/yottadb -r %XCMD 'zhalt $s($zyre["$r{version}":0,1:127)&$s($zch="UTF-8":0,1:126)'
    $out/bin/yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

    # Wipe SRCs as Nix is read-only and sets both .o and .m to the same mtime, so compiler tries to compile all the time, but cannot write
    rm -f $out/dist/*.m $out/dist/utf8/*.m

    # Also generate a single libyottadbutil.so to consolidate all system routines
    libYdbUtil=libyottadbutil
    isarmYdb=$(file $ydb_dist/yottadb | grep -wc "ARM" || true)
    ldflags="-shared"
    if [ "$isarmYdb" -eq 1 ] ; then
      ldcmd="cc"  # Linux on ARM builds shared ELFs only using 'cc', not 'ld'
    else
      ldcmd="ld.gold"
    fi
    cd $out/dist
    $ldcmd $ldflags -o $libYdbUtil.so *.o
    ln -rs $libYdbUtil.so ../lib/$libYdbUtil-m.so
    cd $out/dist/utf8
    $ldcmd $ldflags -o $libYdbUtil.so *.o
    ln -rs $libYdbUtil.so ../../lib/$libYdbUtil-utf8.so

    # Default is UTF-8
    cd $out/lib
    ln -rs $libYdbUtil-utf8.so $libYdbUtil.so
  '';

  meta = with lib; {
    description = "A proven Multi-Language NoSQL database engine";
    homepage = "https://gitlab.com/YottaDB/DB/YDB";
    license = licenses.agpl3;
    maintainers = [ maintainers.ztmr ];
    platforms = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" "x86_64-linux" ];
  };
}

