{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  libgcc,
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
  binutilsTargetPrefix = lib.optionalString (
    hostPlatform.config != buildPlatform.config
  ) "${hostPlatform.config}-";
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

    passthru = {
      tests.hello-world =
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
            gcc -o test test.c
            ./test
            mkdir $out
          '';
    };

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

    export CFLAGS="-B${libgcc}/lib -L${libgcc}/lib -Wl,-rpath,${gcc}/lib,-rpath,${libgcc} -O2 -Wno-error=attribute-alias -Wno-error=maybe-uninitialized -fexceptions"
    export AR=${binutils}/bin/${hostPlatform.config}-ar
    export OBJCOPY=${binutils}/bin/${hostPlatform.config}-objcopy
    export OBJDUMP=${binutils}/bin/${hostPlatform.config}-objdump
    export NM=${binutils}/bin/${hostPlatform.config}-nm
    export READELF=${binutils}/bin/${hostPlatform.config}-readelf
    export STRIP=${binutils}/bin/${hostPlatform.config}-strip
    export LDFLAGS="-L${libgcc}/lib -L${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version} -B${libgcc}/lib -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version}"
    # libstdc++.so is built against musl and fails to link
    export CXX=false

    bash ../configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --with-headers=${linux-headers}/include \
      --disable-dependency-tracking \
      --with-binutils=${binutils}/bin

    # Build
    make -j $NIX_BUILD_CORES sysdep-LDFLAGS="$LDFLAGS"

    # Install
    make -j $NIX_BUILD_CORES INSTALL_UNCOMPRESSED=yes install
    ln -s $(ls -d ${linux-headers}/include/* | grep -v scsi\$) $out/include/
    find $out/{bin,sbin,lib,libexec} -type f -exec ${binutilsTargetPrefix}strip --strip-debug {} + || true
  ''
