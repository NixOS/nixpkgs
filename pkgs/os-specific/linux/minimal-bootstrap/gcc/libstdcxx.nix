{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gcc,
  libgcc,
  binutils,
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
  libc,
  dynamicLinkerGlob,
  staticLibgcc,
}: let
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
  pname = "libstdcxx";

  binutilsTargetPrefix = lib.optionalString (
    buildPlatform.config != hostPlatform.config
  ) "${hostPlatform.config}-";

  # FIXME: hack until we have a proper cross-compilation setup in minimal-bootstrap
  fakeBuildPlatform = lib.replaceString "-gnu" "-musl" buildPlatform.config;
  fakeHostPlatform = lib.replaceString "-gnu" "-musl" hostPlatform.config;
in
  bash.runCommand "${pname}-${common.version}"
  {
    inherit pname;
    inherit (common) version meta;

    nativeBuildInputs = [
      gcc
      binutils
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
  ''
    # Unpack
    pushd ${common.monorepoSrc}

    mkdir -p "$out/gcc" "$out/libgcc"
    cp gcc/BASE-VER gcc/DATESTAMP "$out/gcc"
    cp libgcc/gthr*.h "$out/libgcc"
    cp libgcc/unwind-pe.h "$out/libgcc"

    cp -r libstdc++-v3 "$out"

    cp -r libiberty "$out"
    cp -r include "$out"
    cp -r contrib "$out"

    cp -r config "$out"
    cp -r multilib.am "$out"

    cp config.guess "$out"
    cp config.rpath "$out"
    cp config.sub "$out"
    cp config-ml.in "$out"
    cp ltmain.sh "$out"
    cp install-sh "$out"
    cp mkinstalldirs "$out"

    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"
    popd

    # Configure
    if [[ -z '${dynamicLinkerGlob}' ]]; then
      echo "Don't know the name of the dynamic linker for platform '${hostPlatform.config}', so guessing instead."
      dynamicLinker="${libc}/lib/ld*.so.?"
    else
      dynamicLinker='${dynamicLinkerGlob}'
    fi
    dynamicLinker=($dynamicLinker)
    case ''${#dynamicLinker[@]} in
      0) echo "No dynamic linker found for platform '${hostPlatform.config}'.";;
      1) echo "Using dynamic linker: '$dynamicLinker'";;
      *) echo "Multiple dynamic linkers found for platform '${hostPlatform.config}'.";;
    esac

    mkdir build; cd build
    export CFLAGS="-B${binutils}/bin -B${libc}/lib -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version} -Wl,-dynamic-linker=$dynamicLinker"
    export CXXFLAGS="-B${binutils}/bin -B${libc}/lib -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version}${
      lib.optionalString staticLibgcc " -static-libgcc"
    } -Wl,-dynamic-linker=$dynamicLinker"
    export LDFLAGS="-B${binutils}/bin -B${libc}/lib -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version}${
      lib.optionalString staticLibgcc " -static-libgcc"
    } -Wl,-dynamic-linker=$dynamicLinker"
    export AR="${binutilsTargetPrefix}ar"
    export LD="${binutilsTargetPrefix}ld"
    export NM="${binutilsTargetPrefix}nm"
    export OBJCOPY="${binutilsTargetPrefix}objcopy"
    ${common.monorepoSrc}/libstdc++-v3/configure \
      --build=${fakeBuildPlatform} \
      --host=${fakeHostPlatform} \
      --prefix="$out" \
      --disable-dependency-tracking \
      gcc_cv_target_thread_file=posix \
      cross_compiling=true \
      --disable-multilib \
      --enable-clocale=gnu \
      --disable-libstdcxx-pch \
      --disable-vtable-verify \
      --enable-libstdcxx-visibility \
      --with-default-libstdcxx-abi=new \
      ${lib.optionalString staticLibgcc "--disable-shared"}

    # Build
    make -j $NIX_BUILD_CORES
    chmod -R +w "$out"

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

    # FIXME: hack until we have a proper cross-compilation setup in minimal-bootstrap
    ln -s "$out/include/c++/${common.version}/${fakeHostPlatform}" "$out/include/c++/${common.version}/${hostPlatform.config}"
  ''
