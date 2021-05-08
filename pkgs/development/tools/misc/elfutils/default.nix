{ lib, stdenv, fetchurl, fetchpatch, pkg-config, autoreconfHook, musl-fts
, musl-obstack, m4, zlib, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs
, argp-standalone
, enableDebuginfod ? false, sqlite, curl, libmicrohttpd_0_9_70, libarchive
}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  pname = "elfutils";
  version = "0.182";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
    sha256 = "7MQGkU7fM18Lf8CE6+bEYMTW1Rdb/dZojBx42RRriFg=";
  };

  patches = [
    ./debug-info-from-env.patch
    ./musl-cdefs_h.patch
    (fetchpatch {
      name = "fix-aarch64_fregs.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/fix-aarch64_fregs.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "zvncoRkQx3AwPx52ehjA2vcFroF+yDC2MQR5uS6DATs=";
    })
    (fetchpatch {
      name = "musl-asm-ptrace-h.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-asm-ptrace-h.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "8D1wPcdgAkE/TNBOgsHaeTZYhd9l+9TrZg8d5C7kG6k=";
    })
    (fetchpatch {
      name = "musl-fts-obstack.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-fts-obstack.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "3lbC0UtscTIJgT7kOXnnjWrpPAVt2PYMbW+uJK6K350=";
    })
    (fetchpatch {
      name = "musl-macros.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-macros.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "tp6O1TRsTAMsFe8vw3LMENT/vAu6OmyA8+pzgThHeA8=";
    })
    (fetchpatch {
      name = "musl-qsort_r.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-qsort_r.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "FPWCkdtFT3zw8aNnz0Jz5Vmu8B/mRfNgfhbM/ej7d8M=";
    })
    (fetchpatch {
      name = "musl-strerror_r.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-strerror_r.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "QF6YwWkcT12dZHKzfqFgxy/1fkIllo0AAosbV0sM5PU=";
    })
    (fetchpatch {
      name = "musl-strndupa.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-strndupa.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "sha256-7daehJj1t0wPtQzTv+/Rpuqqs5Ng/EYnZzrcf2o/Lb0=";
    })
  ] ++ lib.optional stdenv.hostPlatform.isMusl [ ./musl-error_h.patch ];

  outputs = [ "bin" "dev" "out" "man" ];

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ]
    ++ lib.optional stdenv.hostPlatform.isMusl autoreconfHook
    ++ lib.optional (enableDebuginfod || stdenv.hostPlatform.isMusl) pkg-config;
  buildInputs = [ zlib bzip2 xz ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-fts
    musl-obstack
  ] ++ lib.optionals enableDebuginfod [
    sqlite
    curl
    libmicrohttpd_0_9_70
    libarchive
  ];

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -Wno-null-dereference"
  '';

  configureFlags = [
    "--program-prefix=eu-" # prevent collisions with binutils
    "--enable-deterministic-archives"
  ] ++ lib.optionals (!enableDebuginfod) [
    "--disable-libdebuginfod"
    "--disable-debuginfod"
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 out of 174 tests
  doInstallCheck = false; # fails 70 out of 174 tests

  meta = with lib; {
    homepage = "https://sourceware.org/elfutils/";
    description = "A set of utilities to handle ELF objects";
    platforms = platforms.linux;
    # licenses are GPL2 or LGPL3+ for libraries, GPL3+ for bins,
    # but since this package isn't split that way, all three are listed.
    license = with licenses; [ gpl2Only lgpl3Plus gpl3Plus ];
    maintainers = [ maintainers.eelco ];
  };
}
