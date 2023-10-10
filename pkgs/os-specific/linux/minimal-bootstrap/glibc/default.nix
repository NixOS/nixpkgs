{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, binutils
, linux-headers
, gnumake
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, python
, bison
, gnutar
, xz
}:
let
  pname = "glibc";
  version = "2.38";

  src = fetchurl {
    url = "mirror://gnu/libc/glibc-${version}.tar.xz";
    hash = "sha256-+4KZiZiyspllRnvBtp0VLpwwfSzzAcnq+0VVt3DvP9I=";
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
    python
    bison
    gnutar
    xz
  ];

  passthru.tests.hello-world = result:
    bash.runCommand "${pname}-simple-program-${version}" {
        nativeBuildInputs = [ gcc binutils ];
      } ''
        cat <<EOF >> test.c
        #include <stdio.h>
        int main() {
          printf("Hello World!\n");
          return 0;
        }
        EOF
        gcc \
          -Wl,--dynamic-linker=${result}/lib/ld-linux.so.2 \
          -B${result}/lib \
          -I${result}/include \
          -o test test.c
        ./test
        mkdir $out
      '';

  meta = with lib; {
    description = "The GNU C Library";
    homepage = "https://www.gnu.org/software/libc/";
    license = licenses.lgpl2Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.linux;
  };
} ''
  # Unpack
  tar xf ${src}
  cd glibc-${version}

  # Configure
  mkdir build
  cd build
  # libstdc++.so is built against musl and fails to link
  export CXX=false
  bash ../configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --with-headers=${linux-headers}/include

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES INSTALL_UNCOMPRESSED=yes install
  find $out/{bin,sbin,lib,libexec} -type f -exec strip --strip-unneeded {} + || true
''
