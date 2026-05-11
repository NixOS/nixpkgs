{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gcc,
  glibc,
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
  version = "15.2.0";
  linkerName =
    {
      i686-linux = "ld-linux.so.2";
      x86_64-linux = "ld-linux-x86-64.so.2";
    }
    .${hostPlatform.system};

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-Q4/ZloJrDIJIWinaA6ctcdbjVBqD7HAt9Ccfb+Al0k4=";
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
          gcc -o test test.c
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
    tar xf ${isl}
    cd gcc-${version}

    ln -s ../gmp-${gmpVersion} gmp
    ln -s ../mpfr-${mpfrVersion} mpfr
    ln -s ../mpc-${mpcVersion} mpc
    ln -s ../isl-${islVersion} isl

    # Configure
    export CC="gcc -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"
    export CXX="g++ -Wl,-dynamic-linker -Wl,${musl}/lib/libc.so"

    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --with-native-system-header-dir=${glibc}/include \
      --enable-languages=c,c++ \
      --disable-bootstrap \
      --disable-dependency-tracking \
      --disable-libsanitizer \
      --disable-lto \
      --disable-multilib \
      --disable-plugin \
      --with-specs="%x{-dynamic-linker=${glibc}/lib/${linkerName}} %x{-L${glibc}/lib/} -B${glibc}/lib"

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install-strip
  ''
