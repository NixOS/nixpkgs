{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  libgcc,
  binutils,
  gnumake,
  gnugrep,
  gnused,
  gnutar,
  gzip,
}:
let
  inherit (import ./common.nix { inherit lib; }) pname meta;
  version = "1.2.5";

  src = fetchurl {
    url = "https://musl.libc.org/releases/musl-${version}.tar.gz";
    hash = "sha256-qaEYu+hNh2TaDqDSizqz+uhHf8fkCF2QECuFlvx8deQ=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gcc
      binutils
      gnumake
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
    # https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a3-intermediate-musl.nix
    sed -i 's|/bin/sh|${bash}/bin/bash|' \
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
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --syslibdir=$out/lib \
      --enable-wrapper
    gcc -c __stack_chk_fail_local.c -o __stack_chk_fail_local.o
    ar r libssp_nonshared.a __stack_chk_fail_local.o

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
    sed -i 's|/bin/sh|${bash}/bin/bash|' $out/bin/*
    ln -s ../lib/libc.so $out/bin/ldd
    cp libssp_nonshared.a $out/lib/
  ''
