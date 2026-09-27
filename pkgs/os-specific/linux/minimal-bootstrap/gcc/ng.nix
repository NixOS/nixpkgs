{
  lib,
  libc,
  buildPlatform,
  hostPlatform,
  targetPlatform,
  fetchurl,
  bash,
  gcc,
  gcc-buildbuild,
  libc-headers,
  binutils-buildbuild,
  binutils-buildtarget,
  binutils-hosttarget,
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
  libgmp,
  libmpfr,
  libmpc,
  libbacktrace,
  libiberty,
  xz,
}:
let
  pname = "gcc";
  common = import ./common.nix {
    inherit
      lib
      bash
      fetchurl
      gnutar
      gnupatch
      xz
      ;
  };

  binutilsTargetPrefix = lib.optionalString (
    targetPlatform.config != hostPlatform.config
  ) "${targetPlatform.config}-";
in
bash.runCommand "${pname}-${common.version}"
  {
    inherit (common) version meta;
    inherit pname;

    nativeBuildInputs = [
      gcc
      gcc-buildbuild
      binutils-buildbuild
      binutils-buildtarget
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
      mkdir -p build
      cd build

      mkdir -p libbacktrace/.libs
      cp ${libbacktrace}/lib/libbacktrace.a libbacktrace/.libs/
      cp -r ${libbacktrace}/lib/*.la libbacktrace/
      cp -r ${libbacktrace}/include/*.h libbacktrace/

      mkdir -p libiberty/pic
      cp ${libiberty}/lib/libiberty.a libiberty/
      cp -r ${libiberty}/lib/libiberty_pic.a libiberty/pic/
      touch libiberty/stamp-noasandir libiberty/stamp-h libiberty/stamp-picdir

      mkdir -p build-${hostPlatform.config}
      cp -r libiberty/ build-${hostPlatform.config}/libiberty
    ''
    +
      lib.optionalString (targetPlatform.config == hostPlatform.config && targetPlatform != hostPlatform)
        ''
          sed -i 's@is_cross_compiler=no@is_cross_compiler=yes@' configure
        ''
    + lib.optionalString (buildPlatform.config != hostPlatform.config) ''
      # We need to allow the configure script to inspect the binutils to correctly determine
      # support for e.g. ".hidden"
      export AS_FOR_TARGET="${lib.getExe' binutils-buildtarget "${binutilsTargetPrefix}as"}"
      export LD_FOR_TARGET="${lib.getExe' binutils-buildtarget "${binutilsTargetPrefix}ld"}"
    ''
    + ''
      # Our custom hook; see common.nix.
      export gccng_skip_target_lib_config=y

      export LDFLAGS="-Wl,-rpath,${libmpc}/lib,-rpath,${libmpfr}/lib,-rpath,${libgmp}/lib,-rpath-link,${libc}/lib"
      bash ${common.monorepoSrc}/configure \
        --prefix=$out \
        --build=${buildPlatform.config} \
        --host=${hostPlatform.config} \
        --target=${targetPlatform.config} \
        --enable-fast-install \
        --disable-serial-configure \
        --disable-analyzer \
        --disable-dependency-tracking \
        --disable-bootstrap \
        --disable-decimal-float \
        --disable-gcov \
        --disable-install-libiberty \
        --disable-multilib \
        --disable-nls \
        --disable-libssp \
        --enable-default-pie \
        --enable-languages=c,c++ \
        --without-headers \
        --without-included-gettext \
        --enable-linker-build-id \
        --with-as=${lib.getExe' binutils-hosttarget "${binutilsTargetPrefix}as"} \
        --with-ld=${lib.getExe' binutils-hosttarget "${binutilsTargetPrefix}ld"} \
        --with-gnu-as \
        --with-gnu-ld \
        --with-sysroot=/ \
        --with-native-system-header-dir=${libc-headers}/include \
        --with-mpfr=${libmpfr} \
        --with-gmp=${libgmp} \
        --with-mpc=${libmpc} \
        --without-isl \
        --disable-plugin \
        --disable-plugins \
        --disable-lto
      sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile

      # Build
      make -j $NIX_BUILD_CORES

      # Install
      make -j $NIX_BUILD_CORES install-strip
      if [ -d "$out/lib64" ]; then
        shopt -s dotglob
        for lib in $out/lib64/*; do
          mv --no-clobber "$lib" "$out/lib/"
        done
        shopt -u dotglob
        rm -rf "$out/lib64"
        ln -s lib "$out/lib64"
      fi
      # Prevent references to build-time dependencies
      rm -rf $out/libexec/gcc/*/*/install-tools
      rm -rf $out/lib/gcc/*/*/install-tools
    ''
  )
