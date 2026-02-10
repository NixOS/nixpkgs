{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnupatch,
  gnused,
  gnugrep,
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

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/d98f97e21413efc32c770d0356f1feda66025686/sysa/musl-1.1.24/musl-1.1.24.sh
  liveBootstrap = "https://github.com/fosslinux/live-bootstrap/raw/d98f97e21413efc32c770d0356f1feda66025686/sysa/musl-1.1.24";
  patches = [
    # tinycc doesn't implement backward-jumping jecxz, and it would be hard to implement
    (fetchurl {
      url = "${liveBootstrap}/patches/sigsetjmp.patch";
      hash = "sha256-wd2Aev1zPJXy3q933aiup5p1IMKzVJBquAyl3gbK4PU=";
    })
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnupatch
      gnused
      gnugrep
      gnutar
      gzip
    ];
  }
  ''
    # Unpack
    tar xzf ${src}
    cd musl-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}
    # tcc does not support complex types
    rm -rf src/complex
    # Configure fails without this
    mkdir -p /dev
    # https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a3-intermediate-musl.nix
    sed -i 's|/bin/sh|${bash}/bin/bash|' \
      tools/*.sh
    chmod 755 tools/*.sh
    # patch popen/system to search in PATH instead of hardcoding /bin/sh
    sed -i 's|posix_spawn(&pid, "/bin/sh",|posix_spawnp(\&pid, "sh",|' \
      src/stdio/popen.c src/process/system.c
    sed -i 's|execl("/bin/sh", "sh", "-c",|execlp("sh", "-c",|'\
      src/misc/wordexp.c

    # @PLT specifier is not supported by tinycc.
    # Calls do go through PLT regardless.
    sed -i 's|@PLT||' src/math/x86_64/expl.s
    sed -i 's|@PLT||' src/signal/x86_64/sigsetjmp.s

    # TODO Implement the required asm constraints 'x' and 't' in tinycc.
    # For now, we just remove code using those constraints. musl automatically
    # polyfills with pure C implementations.
    rm src/math/i386/*.c
    rm src/math/x86_64/*.c

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-shared \
      CC=tcc

    # Build
    make AR="tcc -ar" RANLIB=true CFLAGS="-DSYSCALL_NO_TLS"

    # Install
    make install
    cp ${tinycc.libs}/lib/libtcc1.a $out/lib
  ''
