{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gcc,
  musl,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
}:
let
  pname = "gcc-cxx";

  altSources = {
    release = {
      src = fetchurl {
        url = "mirror://gnu/gcc/gcc-${version}/gcc-4.7.4.tar.gz";
        sha256 = "sha256-3bqlg8XU5PCSi/Fdn2tsKDNJ4W7txHveceG4E/bzeBk=";
      };
      version = "4.7.4";
      dir = "gcc-4.7.4";
    };
    aarch64Backport = {
      src = fetchurl {
        url = "https://github.com/gcc-mirror/gcc/archive/9d2b63d100ae7c99ee8b128fb41086fd85c8f57d.tar.gz";
        hash = "sha256-i6BRucfi3o892X0Aks/9F8r+wuLi9w8ewXpslJcsj4A=";
      };
      version = "4.7.4-unstable-2013-05-07";
      dir = "gcc-9d2b63d100ae7c99ee8b128fb41086fd85c8f57d";
    };
  };
  altSource =
    {
      i686-linux = altSources.release;
      x86_64-linux = altSources.release;
      aarch64-linux = altSources.aarch64Backport;
    }
    .${buildPlatform.system};
  src = altSource.src;
  version = altSource.version;
  dir = altSource.dir;

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

  # config.sub was generated with outdated autotools, which get confused by
  # 4-component target tuples
  fakeBuildPlatform = lib.strings.removeSuffix "-musl" buildPlatform.config;
  fakeHostPlatform = lib.strings.removeSuffix "-musl" hostPlatform.config;
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

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
    ];

    passthru.tests.hello-world =
      result:
      bash.runCommand "${pname}-simple-program-${version}"
        {
          nativeBuildInputs = [
            binutils
            musl
            result
          ];
        }
        ''
          cat <<EOF >> test.c
          #include <stdio.h>
          int main() {
            printf("Hello World!\n");
            return 0;
          }
          EOF
          musl-gcc -o test test.c
          ./test
          mkdir $out
        '';

    meta = {
      description = "GNU Compiler Collection, version ${version}";
      homepage = "https://gcc.gnu.org";
      license = lib.licenses.gpl3Plus;
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = lib.platforms.unix;
      mainProgram = "gcc";
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    tar xzf ${gmp}
    tar xzf ${mpfr}
    tar xzf ${mpc}
    # Unpack even the release tarball for generated source files.
    tar xzf ${altSources.release.src}

    cd ${dir}/

    ln -s ../gmp-${gmpVersion} gmp
    ln -s ../mpfr-${mpfrVersion} mpfr
    ln -s ../mpc-${mpcVersion} mpc

    # Patch
    #
    # Generated source file that is excluded from Git tree; copy from release tarball.
    if test ! -e gcc/gengtype-lex.c; then
      cp ../${altSources.release.dir}/gcc/gengtype-lex.c gcc/gengtype-lex.c
    fi

    # doesn't recognise musl
    sed -i 's|"os/gnu-linux"|"os/generic"|' libstdc++-v3/configure.host

    # Configure
    export CC="gcc -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export CFLAGS_FOR_TARGET="-Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export C_INCLUDE_PATH="${musl}/include"
    export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"
    export LIBRARY_PATH="${musl}/lib"

    bash ./configure \
      --prefix=$out \
      --build=${fakeBuildPlatform} \
      --host=${fakeHostPlatform} \
      --with-native-system-header-dir=${musl}/include \
      --with-build-sysroot=${musl} \
      --disable-bootstrap \
      --disable-decimal-float \
      --disable-dependency-tracking \
      --disable-libatomic \
      --disable-libgomp \
      --disable-libitm \
      --disable-libmudflap \
      --disable-libquadmath \
      --disable-libssp \
      --disable-multiarch \
      --disable-multilib \
      --disable-nls \
      --disable-lto \
      --disable-lto-plugin \
      --disable-plugin \
      --disable-threads \
      --enable-initfini-array \
      --enable-languages=c,c++

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
