{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
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

  patches = [
    # Remove hardcoded NATIVE_SYSTEM_HEADER_DIR
    ./no-system-headers.patch
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
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

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
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
  }
  ''
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
    export CC="tcc -B ${tinycc.libs}/lib"
    export C_INCLUDE_PATH="${tinycc.libs}/include:$(pwd)/mpfr/src"
    export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"

    # Avoid "Link tests are not allowed after GCC_NO_EXECUTABLES"
    export lt_cv_shlibpath_overrides_runpath=yes
    export ac_cv_func_memcpy=yes
    export ac_cv_func_strerror=yes

    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --with-native-system-header-dir=${tinycc.libs}/include \
      --with-build-sysroot=${tinycc.libs}/include \
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
      --enable-languages=c \
      --enable-static \
      --disable-shared \
      --enable-threads=single \
      --disable-libstdcxx-pch \
      --disable-build-with-cxx

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
