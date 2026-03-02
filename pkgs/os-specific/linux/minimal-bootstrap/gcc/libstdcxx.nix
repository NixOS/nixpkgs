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
  gnused,
  gnugrep,
  gnupatch,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
  bzip2,
  xz,
  libc,
}:
let
  common = import ./common.nix {
    inherit
      lib
      bash
      fetchurl
      gnutar
      xz
      ;
  };
  pname = "libstdcxx";

  fixgthr = fetchurl {
    url = "https://github.com/gcc-mirror/gcc/commit/e5d853bbe9b05d6a00d98ad236f01937303e40c4.diff";
    hash = "sha256-e5WC3jxE5C2kLY2e3ORXej7vQ1PDhiaCz8FfTXoFB6E=";
  };
  binutilsTargetPrefix = lib.optionalString (
    buildPlatform.config != hostPlatform.config
  ) "${hostPlatform.config}-";
  dynamicLinkerGlob = common.dynamicLinkerGlob hostPlatform libc;
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
      gnupatch
    ];
  }
  ''
    # Unpack
    cp -R ${common.monorepoSrc} ./src
    chmod -R +w src
    pushd src/

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

    cat ${fixgthr} | tail -n 101 > newpatch.patch
    patch -Np1 newpatch.patch

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
      lib.optionalString (!libgcc.sharedAvailable) " -static-libgcc"
    } -Wl,-dynamic-linker=$dynamicLinker"
    export LDFLAGS="-B${binutils}/bin -B${libc}/lib -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version}${
      lib.optionalString (!libgcc.sharedAvailable) " -static-libgcc"
    } -Wl,-dynamic-linker=$dynamicLinker"
    export AR="${binutilsTargetPrefix}ar"
    export LD="${binutilsTargetPrefix}ld"
    export NM="${binutilsTargetPrefix}nm"
    export OBJCOPY="${binutilsTargetPrefix}objcopy"
    ../src/libstdc++-v3/configure \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
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
      ${lib.optionalString (!libgcc.sharedAvailable) "--disable-shared"}

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
  ''
