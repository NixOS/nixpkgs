{
  lib,
  makeWrapper,
  stdenv,
  writeText,
  writeScript,

  cmake,
  coreutils-full,
  elfutils,
  fetchFromGitLab,
  git,
  glibcLocales,
  icu,
  ncurses,
  openssl,
  pkg-config,
  tcsh,
  util-linux,
  zlib
}:

stdenv.mkDerivation rec {
  pname = "yottadb";
  version = "1.34";

  src = fetchFromGitLab {
    owner = "YottaDB";
    repo = "DB/YDB";
    rev = "r${version}";
    leaveDotGit = true;
    sha256 = "sha256-4J0skA8Ru6rcvHMqN5nTIKI75tsnB+pYaSECDe8qRzE=";
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

  yottadbGde = writeScript "gde" ''
    #!/usr/bin/env bash
    exec ''${0%/*}/yottadb -r GDE "$@"
  '';

  postInstall = ''
    mkdir -p $out/bin $out/lib $out/dist/utf8
    mkdir -p $out/lib/pkgconfig $out/include

    # We cannot set SUID for gtmsecshr, it has to be done using Nix Security Wrapper
    cd $out/dist
    mv gtmsecshr gtmsecshr.nosuid
    ln -rfs /run/wrappers/bin/gtmsecshr .

    # Make sure we have ICU in library path (why is this needed only for ICU?)
    wrapProgram $out/dist/yottadb \
      --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath [ icu ]}" \
      --set-default ydb_dist $out/dist/utf8 \
      --set-default ydb_chset UTF-8 \
      --set-default ydb_icu_version $(icu-config --version) \
      --set-default LANG en_US.UTF-8 \
      --set-default LC_ALL en_US.UTF-8

    cd $out/dist
    ln -rfs yottadb mumps
    cp ${yottadbGde} gde
    for utl in dse ftok gde gtcm_gnp_server gtcm_pkdisp gtcm_play gtcm_server gtcm_shmclean gtmsecshr lke mupip semstat2 yottadb mumps ; do
      ln -rfs $utl ../bin/
      ln -rfs $utl ./utf8/
    done
    ln -rfs libyottadb.so ../lib/
    for inc in $(find -maxdepth 1 -mindepth 1 -name '*.h') ; do
      ln -rfs $inc ../include/
      ln -rfs $inc ./utf8/
    done

    sed -e s,@@YDB_DIST@@,$out/dist,g \
        -e s,@@YDB_EXEDIR@@,$out/bin,g \
        -e s,@@YDB_INCDIR@@,$out/include,g \
        -e s,@@YDB_LIBDIR@@,$out/lib,g \
        ${yottadbPkgConfigTemplate} > $out/lib/pkgconfig/yottadb.pc

    # NOTE: This should not be needed starting from r1.36, see
    # the following issue: https://gitlab.com/YottaDB/DB/YDB/-/issues/491
    faketty () {
      script -qefc "$(printf "%q " "$@")" /dev/null
    }

    # Embed source to OBJs, so that we can drop SRCs
    export ydb_compile="-embed_source -noignore"

    # Build M-mode dist
    export ydb_dist=$out/dist ydb_chset=M
    cd $ydb_dist
    faketty ./yottadb -r %XCMD 'zhalt $s($zyre["r${version}":0,1:127)&$s($zch="M":0,1:126)'
    faketty ./yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

    # Build UTF8-mode dist
    for rtn in *.m *.gld *.dat ; do
      ln -rfs $rtn utf8/
    done
    unset ydb_chset ydb_icu_version ydb_dist
    cd $out/dist/utf8
    faketty ./yottadb -r %XCMD 'zhalt $s($zyre["$r{version}":0,1:127)&$s($zch="UTF-8":0,1:126)'
    faketty ./yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

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
    ln -rfs $libYdbUtil.so ../lib/$libYdbUtil-m.so
    cd $out/dist/utf8
    $ldcmd $ldflags -o $libYdbUtil.so *.o
    ln -rfs $libYdbUtil.so ../../lib/$libYdbUtil-utf8.so

    # Default is UTF-8
    cd $out/lib
    ln -rfs $libYdbUtil-utf8.so $libYdbUtil.so
  '';

  meta = with lib; {
    description = "A proven Multi-Language NoSQL database engine";
    homepage = "https://gitlab.com/YottaDB/DB/YDB";
    license = licenses.agpl3;
    maintainers = [ maintainers.ztmr ];
    platforms = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" "x86_64-linux" ];
  };
}

