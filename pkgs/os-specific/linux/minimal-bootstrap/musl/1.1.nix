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
  version = "1.1.24";

  src = fetchurl {
    url = "https://musl.libc.org/releases/musl-${version}.tar.gz";
    hash = "sha256-E3DJqBKyzyp9koAlEMygBYzDfmanvt1wBR8KNAFQIqM=";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/d98f97e21413efc32c770d0356f1feda66025686/sysa/musl-1.1.24/musl-1.1.24.sh
  liveBootstrap = "https://github.com/fosslinux/live-bootstrap/raw/d98f97e21413efc32c770d0356f1feda66025686/sysa/musl-1.1.24";
  patches = [
    (fetchurl {
      url = "${liveBootstrap}/patches/avoid_set_thread_area.patch";
      hash = "sha256-TsbBZXk4/KMZG9EKi7cF+sullVXrxlizLNH0UHGXsPs=";
    })
    (fetchurl {
      url = "${liveBootstrap}/patches/avoid_sys_clone.patch";
      hash = "sha256-/ZmH64J57MmbxdfQ4RNjamAiBdkImMTlHsHdgV4gMj4=";
    })
    (fetchurl {
      url = "${liveBootstrap}/patches/set_thread_area.patch";
      hash = "sha256-RIZYqbbRSx4X/0iFUhriwwBRmoXVR295GNBUjf2UrM0=";
    })
    (fetchurl {
      url = "${liveBootstrap}/patches/sigsetjmp.patch";
      hash = "sha256-wd2Aev1zPJXy3q933aiup5p1IMKzVJBquAyl3gbK4PU=";
    })
    # liveBootstrap/sysa/musl-1.1.24/patches/stdio_flush_on_exit.patch with forward declarations added
    # to avoid `error: implicit declaration of function '__stdio_exit'`
    # Required to fix buffered stdout being truncated on exit
    ./stdio_flush_on_exit.patch
    ./avoid_pthread_x86_64.patch
    (fetchurl {
      url = "${liveBootstrap}/patches/va_list.patch";
      hash = "sha256-UmcMIl+YCi3wIeVvjbsCyqFlkyYsM4ECNwTfXP+s7vg=";
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
