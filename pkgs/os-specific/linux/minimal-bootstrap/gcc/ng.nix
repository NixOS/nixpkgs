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
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnupatch,
  gnutar,
  gzip,
  bzip2,
  gmp,
  mpfr,
  mpc,
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
      xz
      ;
  };

  binutilsTargetPrefix = lib.optionalString (
    targetPlatform.config != hostPlatform.config
  ) "${targetPlatform.config}-";
  patches = [
    (fetchurl {
      name = "for_each_path-functional-programming.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/f23bac62f46fc296a4d0526ef54824d406c3756c.diff";
      hash = "sha256-J7SrypmVSbvYUzxWWvK2EwEbRsfGGLg4vNZuLEe6Xe0=";
    })
    (fetchurl {
      name = "find_a_program-separate-from-find_a_file.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-1-git@JohnEricson.me/raw";
      hash = "sha256-0gaWaeFZq+a8q7Bcr3eILNjHh1LfzL/Lz4F+W+H6XIU=";
    })
    (fetchurl {
      name = "simplify-find_a_program-and-find_a_file.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-2-git@JohnEricson.me/raw";
      hash = "sha256-ojdyszxLGL+njHK4eAaeBkxAhFTDI57j6lGuAf0A+N0=";
    })
    (fetchurl {
      name = "for_each_path-pass-machine-specific.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-3-git@JohnEricson.me/raw";
      hash = "sha256-C5jUSyNchmZcE8RTXc2dHfCqNKuBHeiouLruK9UooSM=";
    })
    (fetchurl {
      name = "find_a_program-search-with-machine-prefix.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-4-git@JohnEricson.me/raw";
      hash = "sha256-MwcO4OXPlcdaSYivsh5ru+Cfq6qybeAtgCgTEPGYg40=";
    })
  ]
  ++ lib.optional targetPlatform.isMusl (fetchurl {
    name = "libssp-nonshared.patch";
    url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/cd7cc21cfae56585beb41ed96844d44b60020c13/main/gcc/0018-Alpine-musl-package-provides-libssp_nonshared.a.-We-.patch";
    hash = "sha256-VwGXVDQlv140jyMXmVaoJWLDpwHF56vII9aPYI1ooHg=";
  });
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
      gnupatch
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
      # Unpack
      cp -R ${common.monorepoSrc} ./src
      chmod -R +w src
      touch ./src/gcc/gengtype-lex.cc

      # Patch
      pushd src
      ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}
      sed -i 's@basename(@lbasename(@' gcc/collect2.cc
      sed -i 's@noconfigdirs=""@noconfigdirs="$noconfigdirs $target_libraries"@' configure
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
      popd

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

      export LDFLAGS="-Wl,-rpath,${mpc}/lib,-rpath,${mpfr}/lib,-rpath,${gmp}/lib,-rpath-link,${libc}/lib"
      bash ../src/configure \
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
        --with-mpfr=${mpfr} \
        --with-gmp=${gmp} \
        --with-mpc=${mpc} \
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
