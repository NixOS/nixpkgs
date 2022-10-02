{ lib, stdenv, fetchurl, fetchpatch, pkg-config, musl-fts
, musl-obstack, m4, zlib, zstd, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs
, argp-standalone
, enableDebuginfod ? false, sqlite, curl, libmicrohttpd_0_9_70, libarchive
, gitUpdater
}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  pname = "elfutils";
  version = "0.187";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-5wsN++YQ+QxNH+DXGvFCpOJcPE7566uNLXK2UVnUVMg=";
  };

  patches = [
    ./debug-info-from-env.patch
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
      name = "musl-macros.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-macros.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "tp6O1TRsTAMsFe8vw3LMENT/vAu6OmyA8+pzgThHeA8=";
    })
    (fetchpatch {
      name = "musl-strndupa.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/elfutils/musl-strndupa.patch?id=2e3d4976eeffb4704cf83e2cc3306293b7c7b2e9";
      sha256 = "sha256-7daehJj1t0wPtQzTv+/Rpuqqs5Ng/EYnZzrcf2o/Lb0=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [ ./musl-error_h.patch ];

  postPatch = ''
    patchShebangs tests/*.sh
  '';

  outputs = [ "bin" "dev" "out" "man" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ]
    ++ lib.optional enableDebuginfod pkg-config;
  buildInputs = [ zlib zstd bzip2 xz ]
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

  configureFlags = [
    "--program-prefix=eu-" # prevent collisions with binutils
    "--enable-deterministic-archives"
    (lib.enableFeature enableDebuginfod "libdebuginfod")
    (lib.enableFeature enableDebuginfod "debuginfod")
  ];

  enableParallelBuilding = true;

  # Backtrace unwinding tests rely on glibc-internal symbol names.
  # Musl provides slightly different forms and fails.
  # Let's disable tests there until musl support is fully upstreamed.
  doCheck = !stdenv.hostPlatform.isMusl;
  doInstallCheck = !stdenv.hostPlatform.isMusl;

  passthru.updateScript = gitUpdater {
    url = "https://sourceware.org/git/elfutils.git";
    rev-prefix = "elfutils-";
  };

  meta = with lib; {
    homepage = "https://sourceware.org/elfutils/";
    description = "A set of utilities to handle ELF objects";
    platforms = platforms.linux;
    # https://lists.fedorahosted.org/pipermail/elfutils-devel/2014-November/004223.html
    broken = stdenv.hostPlatform.isStatic;
    # licenses are GPL2 or LGPL3+ for libraries, GPL3+ for bins,
    # but since this package isn't split that way, all three are listed.
    license = with licenses; [ gpl2Only lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ eelco r-burns ];
  };
}
