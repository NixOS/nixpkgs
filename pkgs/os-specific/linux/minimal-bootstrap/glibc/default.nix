{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  binutils,
  linux-headers,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  python,
  bison,
  gnutar,
  xz,
}:
let
  pname = "glibc";
  version = "2.42";

  src = fetchurl {
    url = "mirror://gnu/libc/glibc-${version}.tar.xz";
    hash = "sha256-0XdeMuRijmTvkw9DW2e7Y691may2viszW58Z8WUJ8X8=";
  };

  linkerFile =
    {
      x86_64-linux = "ld-linux-x86-64";
      i686-linux = "ld-linux";
    }
    .${buildPlatform.system};

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
      python
      bison
      gnutar
      xz
    ];

    passthru.tests.hello-world =
      result:
      bash.runCommand "${pname}-simple-program-${version}"
        {
          nativeBuildInputs = [
            gcc
            binutils
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
          gcc \
            -Wl,--dynamic-linker=${result}/lib/${linkerFile}.so.2 \
            -B${result}/lib \
            -I${result}/include \
            -o test test.c
          ./test
          mkdir $out
        '';

    meta = {
      description = "The GNU C Library";
      homepage = "https://www.gnu.org/software/libc/";
      license = lib.licenses.lgpl2Plus;
      platforms = lib.platforms.linux;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
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
      --with-headers=${linux-headers}/include \
      --disable-dependency-tracking

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES INSTALL_UNCOMPRESSED=yes install
    ln -s $(ls -d ${linux-headers}/include/* | grep -v scsi\$) $out/include/
    find $out/{bin,sbin,lib,libexec} -type f -exec strip --strip-unneeded {} + || true
  ''
