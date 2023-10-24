{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, coreutils
, gcc
, musl
, binutils
, gnumake
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, gzip
, bzip2
, xz
}:
let
  pname = "gcc";
  version = "13.2.0";

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-4nXnZEKmBnNBon8Exca4PYYTFEAEwEE1KIY9xrXHQ9o=";
  };

  gmpVersion = "6.3.0";
  gmp = fetchurl {
    url = "mirror://gnu/gmp/gmp-${gmpVersion}.tar.xz";
    hash = "sha256-o8K4AgG4nmhhb0rTC8Zq7kknw85Q4zkpyoGdXENTiJg=";
  };

  mpfrVersion = "4.2.1";
  mpfr = fetchurl {
    url = "mirror://gnu/mpfr/mpfr-${mpfrVersion}.tar.xz";
    hash = "sha256-J3gHNTpnJpeJlpRa8T5Sgp46vXqaW3+yeTiU4Y8fy7I=";
  };

  mpcVersion = "1.3.1";
  mpc = fetchurl {
    url = "mirror://gnu/mpc/mpc-${mpcVersion}.tar.gz";
    hash = "sha256-q2QkkvXPiCt0qgy3MM1BCoHtzb7IlRg86TDnBsHHWbg=";
  };

  islVersion = "0.24";
  isl = fetchurl {
    url = "https://gcc.gnu.org/pub/gcc/infrastructure/isl-${islVersion}.tar.bz2";
    hash = "sha256-/PeN2WVsEOuM+fvV9ZoLawE4YgX+GTSzsoegoYmBRcA=";
  };
in
bash.runCommand "${pname}-${version}" {
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

  passthru.tests.hello-world = result:
    bash.runCommand "${pname}-simple-program-${version}" {
        nativeBuildInputs = [ binutils musl result ];
      } ''
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

  meta = with lib; {
    description = "GNU Compiler Collection, version ${version}";
    homepage = "https://gcc.gnu.org";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xf ${src}
  tar xf ${gmp}
  tar xf ${mpfr}
  tar xf ${mpc}
  tar xf ${isl}
  cd gcc-${version}

  ln -s ../gmp-${gmpVersion} gmp
  ln -s ../mpfr-${mpfrVersion} mpfr
  ln -s ../mpc-${mpcVersion} mpc
  ln -s ../isl-${islVersion} isl

  # Patch
  # force musl even if host triple is gnu
  sed -i 's|"os/gnu-linux"|"os/generic"|' libstdc++-v3/configure.host

  # Configure
  export CC="gcc -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
  export CXX="g++ -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
  export CFLAGS_FOR_TARGET="-Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
  export LIBRARY_PATH="${musl}/lib"

  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --with-native-system-header-dir=/include \
    --with-sysroot=${musl} \
    --enable-languages=c,c++ \
    --disable-bootstrap \
    --disable-libsanitizer \
    --disable-lto \
    --disable-multilib \
    --disable-plugin

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install-strip
''
