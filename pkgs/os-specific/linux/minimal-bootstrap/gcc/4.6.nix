{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, glibc
, linux-headers
, binutils
, gnumake
, gnupatch
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, gzip
}:
let
  pname = "gcc";
  version = "4.6.4";

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-core-${version}.tar.gz";
    sha256 = "173kdb188qg79pcz073cj9967rs2vzanyjdjyxy9v0xb0p5sad75";
  };

  ccSrc = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-g++-${version}.tar.gz";
    sha256 = "1fqqk5zkmdg4vmqzdmip9i42q6b82i3f6yc0n86n9021cr7ms2k9";
  };

  patches = [
    # This patch enables building gcc-4.6.4 using gcc-2.95.3 and glibc-2.2.5
    # * Tweak Makefile to allow overriding NATIVE_SYSTEM_HEADER_DIR using #:makeflags
    # * Add missing limits.h include.
    # * Add SSIZE_MAX define.  The SSIZE_MAX define has been added to Mes
    #   upstream and can be removed with the next Mes release.
    # * Remove -fbuilding-libgcc flag, it assumes features being present from a
    #   newer gcc or glibc.
    # * [MES_BOOTSTRAP_GCC]: Disable threads harder.
    (fetchurl {
      url = "https://git.savannah.gnu.org/cgit/guix.git/plain/gnu/packages/patches/gcc-boot-4.6.4.patch?id=50249cab3a98839ade2433456fe618acc6f804a5";
      sha256 = "1zzd8gnihw6znrgb6c6pfsmm0vix89xw3giv1nnsykm57j0v3z0d";
    })
    ./libstdc++-target.patch
  ];

  # To reduce the set of pre-built bootstrap inputs, build
  # GMP & co. from GCC.
  gmpVersion = "4.3.2";
  gmp = fetchurl {
    url = "mirror://gnu/gmp/gmp-${gmpVersion}.tar.gz";
    sha256 = "15rwq54fi3s11izas6g985y9jklm3xprfsmym3v1g6xr84bavqvv";
  };

  mpfrVersion = "2.4.2";
  mpfr = fetchurl {
    url = "mirror://gnu/mpfr/mpfr-${mpfrVersion}.tar.gz";
    sha256 = "0dxn4904dra50xa22hi047lj8kkpr41d6vb9sd4grca880c7wv94";
  };

  mpcVersion = "1.0.3";
  mpc = fetchurl {
    url = "mirror://gnu/mpc/mpc-${mpcVersion}.tar.gz";
    sha256 = "1hzci2zrrd7v3g1jk35qindq05hbl0bhjcyyisq9z209xb3fqzb1";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gcc
    binutils
    gnumake
    gnupatch
    gnused
    gnugrep
    gawk
    diffutils
    findutils
    gnutar
    gzip
  ];

  # condition in ./libcpp/configure requires `env` which is not available in this coreutils
  am_cv_CXX_dependencies_compiler_type = "gcc";
  am_cv_CC_dependencies_compiler_type = "gcc";

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/gcc --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU Compiler Collection, version ${version}";
    homepage = "https://gcc.gnu.org";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xzf ${src}
  tar xzf ${ccSrc}
  tar xzf ${gmp}
  tar xzf ${mpfr}
  tar xzf ${mpc}
  cd gcc-${version}

  ln -s ../gmp-${gmpVersion} gmp
  ln -s ../mpfr-${mpfrVersion} mpfr
  ln -s ../mpc-${mpcVersion} mpc

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

  # Configure
  export C_INCLUDE_PATH="${gcc}/lib/gcc-lib/${hostPlatform.config}/${gcc.version}/include:${linux-headers}/include:${glibc}/include:$(pwd)/mpfr/src"
  export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"
  export LDFLAGS="-B${glibc}/lib -Wl,-dynamic-linker -Wl,${glibc}"
  export LDFLAGS_FOR_TARGET=$LDFLAGS
  export LIBRARY_PATH="${glibc}/lib:${gcc}/lib"
  export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --with-native-system-header-dir=${glibc}/include \
    --with-build-sysroot=${glibc}/include \
    --disable-bootstrap \
    --disable-decimal-float \
    --disable-libatomic \
    --disable-libcilkrts \
    --disable-libgomp \
    --disable-libitm \
    --disable-libmudflap \
    --disable-libquadmath \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --disable-lto \
    --disable-lto-plugin \
    --disable-multilib \
    --disable-plugin \
    --disable-threads \
    --enable-languages=c,c++ \
    --enable-static \
    --disable-shared \
    --enable-threads=single \
    --disable-libstdcxx-pch \
    --disable-build-with-cxx

  # Build
  make

  # Install
  make install
''
