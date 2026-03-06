{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  binutils,
  findutils,
  gnumake,
  gnugrep,
  gnupatch,
  gnused,
  gnutar,
  gzip,
  linux-headers,
  libgcc,
}:
let
  inherit (import ./common.nix { inherit lib; }) pname meta;
  version = "1.2.5";

  src = fetchurl {
    url = "https://musl.libc.org/releases/musl-${version}.tar.gz";
    hash = "sha256-qaEYu+hNh2TaDqDSizqz+uhHf8fkCF2QECuFlvx8deQ=";
  };

  patches = [
    (fetchurl {
      name = "locale-fix-1.patch";
      url = "https://www.openwall.com/lists/musl/2025/02/13/1/1";
      hash = "sha256-CJb821El2dByP04WXxPCCYMOcEWnXLpOhYBgg3y3KS4=";
    })
    (fetchurl {
      name = "locale-fix-2.patch";
      url = "https://www.openwall.com/lists/musl/2025/02/13/1/2";
      hash = "sha256-BiD87k6KTlLr4ep14rUdIZfr2iQkicBYaSTq+p6WBqE=";
    })
  ];

  binutilsTargetPrefix = lib.optionalString (
    hostPlatform.config != buildPlatform.config
  ) "${hostPlatform.config}-";
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gcc
      binutils
      findutils
      gnumake
      gnupatch
      gnused
      gnugrep
      gnutar
      gzip
    ];

    passthru = {
      tests.hello-world =
        result:
        bash.runCommand "${pname}-simple-program-${version}"
          {
            nativeBuildInputs = [
              gcc
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
            musl-gcc -o test test.c
            ./test
            mkdir $out
          '';
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd musl-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}
    # https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a3-intermediate-musl.nix
    sed -i 's|/bin/sh|${lib.getExe bash}|' \
      tools/*.sh
    # patch popen/system to search in PATH instead of hardcoding /bin/sh
    sed -i 's|posix_spawn(&pid, "/bin/sh",|posix_spawnp(\&pid, "sh",|' \
      src/stdio/popen.c src/process/system.c
    sed -i 's|execl("/bin/sh", "sh", "-c",|execlp("sh", "-c",|'\
      src/misc/wordexp.c

    # See: https://gitlab.alpinelinux.org/alpine/aports/-/blob/cd7cc21cfae56585beb41ed96844d44b60020c13/main/musl/APKBUILD
    cat <<EOF > __stack_chk_fail_local.c
      extern void __stack_chk_fail(void);
      void __attribute__((visibility ("hidden"))) __stack_chk_fail_local(void) { __stack_chk_fail(); }
    EOF

    # Configure
    export CC="${binutilsTargetPrefix}gcc -B${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version} -Wl,-rpath,${libgcc}/lib/gcc/${hostPlatform.config}/${libgcc.version}"
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --syslibdir=$out/lib

    # Build
    make -j $NIX_BUILD_CORES
    $CC -c __stack_chk_fail_local.c -o __stack_chk_fail_local.o
    ${binutilsTargetPrefix}ar r libssp_nonshared.a __stack_chk_fail_local.o

    # Install
    make -j $NIX_BUILD_CORES install
    mkdir -p $out/bin
    ln -s ../lib/libc.so $out/bin/ldd
    ln -s $(ls -d ${linux-headers}/include/* | grep -v scsi\$) $out/include/
    cp libssp_nonshared.a $out/lib/

    # Strip
    # Ignore failures, because strip may fail on non-elf files.
    find $out/{bin,lib} -type f -exec ${binutilsTargetPrefix}strip --strip-debug {} + || true
  ''
