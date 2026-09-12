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
  bzip2,
  xz,
}:
let
  pname = "gcc";
  version = "15.3.0";

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-+lnBvu+JlfJ8TXHB3yJ1hxiTFdPm+v8btDBuYbDFMOs=";
  };

  gmpVersion = "6.3.0";
  gmp = fetchurl {
    url = "mirror://gnu/gmp/gmp-${gmpVersion}.tar.xz";
    hash = "sha256-o8K4AgG4nmhhb0rTC8Zq7kknw85Q4zkpyoGdXENTiJg=";
  };

  mpfrVersion = "4.2.2";
  mpfr = fetchurl {
    url = "mirror://gnu/mpfr/mpfr-${mpfrVersion}.tar.xz";
    hash = "sha256-tnugOD736KhWNzTi6InvXsPDuJigHQD6CmhprYHGzgE=";
  };

  mpcVersion = "1.4.1";
  mpc = fetchurl {
    url = "mirror://gnu/mpc/mpc-${mpcVersion}.tar.xz";
    hash = "sha256-kSBM0y8WS9O3yZLUpqjOZRlRGq2rMPeLaYLQv41z6TE=";
  };
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
      bzip2
      xz
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
    tar xf ${src}
    tar xf ${gmp}
    tar xf ${mpfr}
    tar xf ${mpc}
    cd gcc-${version}

    ln -s ../gmp-${gmpVersion} gmp
    ln -s ../mpfr-${mpfrVersion} mpfr
    ln -s ../mpc-${mpcVersion} mpc

    # Patch
    # force musl even if host triple is gnu
    sed -i 's|"os/gnu-linux"|"os/generic"|' libstdc++-v3/configure.host

    # Configure
    export CC="gcc -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export CXX="g++ -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export CFLAGS="-O1"
    export CXXFLAGS="-O1"
    export CFLAGS_FOR_TARGET="-O0 -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export CXXFLAGS_FOR_TARGET="$CFLAGS_FOR_TARGET"
    export LIBRARY_PATH="${musl}/lib"

    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --with-native-system-header-dir=${musl}/include \
      --with-sysroot=/ \
      --enable-languages=c,c++ \
      --enable-checking=release \
      --enable-static \
      --disable-shared \
      --disable-bootstrap \
      --disable-dependency-tracking \
      --disable-libsanitizer \
      --disable-libssp \
      --disable-libgomp \
      --disable-libquadmath \
      --disable-libitm \
      --disable-libvtv \
      --disable-libatomic \
      --disable-libstdcxx-pch \
      --disable-lto \
      --disable-multilib \
      --disable-nls \
      --disable-plugin \
      --without-isl

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install-strip

    # libstdc++ gdb pretty-printers + man pages are unused downstream.
    rm -rf $out/share/gcc-*/python $out/share/man $out/share/info

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
