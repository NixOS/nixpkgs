{
  enableShared,
  libc-headers,
  libc ? null,
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc-buildbuild,
  gcc,
  libgmp,
  libmpfr,
  libmpc,
  binutils-buildbuild,
  gnumake,
  gnupatch,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
  bzip2,
  xz,
  libiberty,
  binutils,
}:
let
  common = import ./common.nix {
    inherit
      lib
      bash
      fetchurl
      gnupatch
      gnutar
      xz
      ;
  };
  pname = "libgcc";

  binutilsTargetPrefix = lib.optionalString (
    buildPlatform.config != hostPlatform.config
  ) "${hostPlatform.config}-";
in
bash.runCommand "${pname}-${common.version}"
  {
    inherit pname;
    inherit (common) version meta;

    nativeBuildInputs = [
      gcc-buildbuild
      binutils
      binutils-buildbuild
      gnumake
      gnused
      gnugrep
      gawk
      diffutils
      findutils
      gnutar
      gzip
      bzip2
      xz
    ];
  }
  (
    ''
      # Configure
      mkdir -p build-${buildPlatform.config}/libiberty/
      ln -s ${libiberty}/lib/libiberty.a build-${buildPlatform.config}/libiberty/

      mkdir -p gcc/
      cd gcc/

      (
      export AS_FOR_BUILD=${lib.getExe' binutils-buildbuild "as"}
      export CC_FOR_BUILD="${lib.getExe' gcc-buildbuild "gcc"} -I${libgmp}/include -I${libmpfr}/include -I${libmpc}/include"
      export CPP_FOR_BUILD="${lib.getExe' gcc-buildbuild "cpp"} -I${libgmp}/include -I${libmpfr}/include -I${libmpc}/include"
      export CXX_FOR_BUILD="${lib.getExe' gcc-buildbuild "g++"} -I${libgmp}/include -I${libmpfr}/include -I${libmpc}/include"
      export LD_FOR_BUILD="${lib.getExe' binutils-buildbuild "ld"}"
      export OBJDUMP_FOR_BUILD=${lib.getExe' binutils-buildbuild "objdump"}

      export AS=$AS_FOR_BUILD
      export CC=$CC_FOR_BUILD
      export CPP=$CPP_FOR_BUILD
      export CXX=$CXX_FOR_BUILD
      export LD=$LD_FOR_BUILD
      export OBJDUMP=$OBJDUMP_FOR_BUILD

      export AS_FOR_TARGET=${lib.getExe' binutils "${binutilsTargetPrefix}as"}
      export CC_FOR_TARGET="${lib.getExe' gcc "${hostPlatform.config}-gcc"}"
      export CPP_FOR_TARGET=${lib.getExe' gcc "${binutilsTargetPrefix}cpp"}
      export LD_FOR_TARGET=${lib.getExe' binutils "${binutilsTargetPrefix}ld"}
      export OBJDUMP_FOR_TARGET=${lib.getExe' binutils "${binutilsTargetPrefix}objdump"}

      export CFLAGS_FOR_BUILD="-DGENERATOR_FILE=1"
      ${common.monorepoSrc}/gcc/configure \
        --build=${buildPlatform.config} \
        --host=${buildPlatform.config} \
        --target=${hostPlatform.config} \
        --disable-bootstrap \
        --disable-multilib \
        --enable-languages=c \
        --disable-fixincludes \
        --disable-gcov \
        --disable-intl \
        --disable-lto \
        --disable-libatomic \
        --disable-libbacktrace \
        --disable-libcpp \
        --disable-libssp \
        --disable-libquadmath \
        --disable-libgomp \
        --disable-libvtv \
        --disable-vtable-verify \
        --with-sysroot=/ \
        --with-native-system-headers=${libc-headers}/include

      sed -i 's,libgcc.mvars:.*$,libgcc.mvars:,' -i Makefile

      make \
        config.h \
        libgcc.mvars \
        tconfig.h \
        tm.h \
        options.h \
        insn-constants.h \
        version.h
      )
      mkdir -p include

      mkdir -p ${hostPlatform.config}/libgcc
      cd ${hostPlatform.config}/libgcc

      export AS_FOR_BUILD=${lib.getExe' binutils-buildbuild "as"}
      export CC_FOR_BUILD=${lib.getExe' gcc-buildbuild "gcc"}
      export CPP_FOR_BUILD=${lib.getExe' gcc-buildbuild "cpp"}
      export CXX_FOR_BUILD=${lib.getExe' gcc-buildbuild "g++"}
      export LD_FOR_BUILD=${lib.getExe' binutils-buildbuild "ld"}

      export AS=${lib.getExe' binutils "${binutilsTargetPrefix}as"}
      export CC="${lib.getExe' gcc "${hostPlatform.config}-gcc"}"
      export CPP=${lib.getExe' gcc "${binutilsTargetPrefix}cpp"}
      export LD=${lib.getExe' binutils "${binutilsTargetPrefix}ld"}
      export AS_FOR_TARGET=${lib.getExe' binutils "${binutilsTargetPrefix}as"}
      export CC_FOR_TARGET="${lib.getExe' gcc "${hostPlatform.config}-gcc"}"
      export CPP_FOR_TARGET=${lib.getExe' gcc "${binutilsTargetPrefix}-cpp"}
      export LD_FOR_TARGET=${lib.getExe' binutils "${binutilsTargetPrefix}ld"}
    ''
    + (lib.optionalString hostPlatform.isMusl ''

      export CFLAGS="-isystem ${gcc}/lib/gcc/${hostPlatform.config}/${common.version}/include-fixed"

    '')
    + ''
      ${common.monorepoSrc}/libgcc/configure --disable-dependency-tracking \
       --prefix="$out" \
       --build=${buildPlatform.config} \
       --host=${hostPlatform.config} \
        gcc_cv_target_thread_file=single \
        ${
          if enableShared then "--enable-shared --disable-static" else "--disable-shared --enable-static"
        } \
        cross_compiling=true

      export CFLAGS=""
      export LDFLAGS="${lib.optionalString (libc != null) "-B${libc}/lib"}"
      make -j $NIX_BUILD_CORES MULTIBUILDTOP:=../

      make -j $NIX_BUILD_CORES install-strip MULTIBUILDTOP:=../
      mkdir -p "$out/include"
      install -c -m 644 gthr-default.h "$out/include/"

      if [ -d "$out/lib64" ]; then
        shopt -s dotglob
        for lib in $out/lib64/*; do
          mv --no-clobber "$lib" "$out/lib/gcc/${hostPlatform.config}/${common.version}/"
        done
        shopt -u dotglob
        rm -rf "$out/lib64"
        ln -s lib "$out/lib64"
      fi
      # On 32-bit platforms, libs might be placed into $out/lib rather than lib64.
      # Move to unified directory, so that gcc-wrapper finds them
      shopt -s nullglob
      for lib in $out/lib/*.*; do
        mv --no-clobber "$lib" "$out/lib/gcc/${hostPlatform.config}/${common.version}/"
      done
      shopt -u nullglob

      if ! [ -e "$out/lib/gcc/${hostPlatform.config}/${common.version}/libgcc_eh.a" ]; then
        ln -s "$out/lib/gcc/${hostPlatform.config}/${common.version}/libgcc.a" "$out/lib/gcc/${hostPlatform.config}/${common.version}/libgcc_eh.a"
      fi
      find "$out/lib/gcc/${hostPlatform.config}/${common.version}/" -type f -exec ${binutilsTargetPrefix}strip --strip-debug {} + || true
    ''
  )
