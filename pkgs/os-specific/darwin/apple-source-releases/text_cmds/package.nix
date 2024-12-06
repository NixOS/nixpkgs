{
  lib,
  apple-sdk,
  apple-sdk_11,
  apple-sdk_13,
  bzip2,
  libbsd,
  libmd,
  libresolv,
  libutil,
  libxo,
  mkAppleDerivation,
  ncurses,
  pkg-config,
  shell_cmds,
  stdenvNoCC,
  xz,
  zlib,
}:

let
  Libc = apple-sdk.sourceRelease "Libc";
  Libc_13 = apple-sdk_13.sourceRelease "Libc";

  # The 10.12 SDK doesn’t have the files needed in the same places or possibly at all.
  # Just use the 11.0 SDK to make things easier.
  CommonCrypto = apple-sdk_11.sourceRelease "CommonCrypto";
  libplatform = apple-sdk_11.sourceRelease "libplatform";
  xnu = apple-sdk_11.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "text_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include" \
        '${libplatform}/private/_simple.h' \
        '${Libc_13}/include/vis.h'
      install -D -t "$out/include/os" \
        '${Libc}/os/assumes.h' \
        '${xnu}/libkern/os/base_private.h'
      install -D -t "$out/include/CommonCrypto" \
        '${CommonCrypto}/include/Private/CommonDigestSPI.h'

      # Prevent an error when using the old availability headers from the 10.12 SDK.
      substituteInPlace "$out/include/CommonCrypto/CommonDigestSPI.h" \
        --replace-fail 'API_DEPRECATED(CC_DIGEST_DEPRECATION_WARNING, macos(10.4, 10.13), ios(5.0, 11.0))' "" \
        --replace-fail 'API_DEPRECATED(CC_DIGEST_DEPRECATION_WARNING, macos(10.4, 10.15), ios(5.0, 13.0))' ""
      touch "$out/include/CrashReporterClient.h" # Needed by older SDK `os/assumes.h`
    '';
  };
in
mkAppleDerivation {
  releaseName = "text_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-dZ+yJyfflhmUyx3gitRXC115QxS87SGC4/HjMa199Ts=";

  patches = lib.optionals (lib.versionOlder (lib.getVersion apple-sdk) "11.0") [
    ./patches/0001-Use-availability-check-for-__collate_lookup_l.patch
  ];

  postPatch =
    ''
      # Improve compatiblity with libmd in nixpkgs.
      substituteInPlace md5/md5.c \
        --replace-fail '<sha224.h>' '<sha2.h>' \
        --replace-fail SHA224_Init SHA224Init \
        --replace-fail SHA224_Update SHA224Update \
        --replace-fail SHA224_End SHA224End \
        --replace-fail SHA224_Data SHA224Data \
        --replace-fail SHA224_CTX SHA2_CTX \
        --replace-fail '<sha384.h>' '<sha512.h>' \
        --replace-fail 'const void *, unsigned int, char *' 'const uint8_t *, size_t, char *'
    ''
    + lib.optionalString (lib.versionOlder (lib.getVersion apple-sdk) "13.0") ''
      # Backport vis APIs from the 13.3 SDK (needed by vis).
      cp '${Libc_13}/gen/FreeBSD/vis.c' vis/vis-libc.c
      # Backport errx APIs from the 13.3 SDK (needed by lots of things).
      mkdir sys
      cp '${Libc_13}/gen/FreeBSD/err.c' err-libc.c
      cp '${Libc_13}/include/err.h' err.h
      cp '${Libc_13}/fbsdcompat/sys/cdefs.h' sys/cdefs.h
      substituteInPlace err.h \
        --replace-fail '__cold' ""
      touch namespace.h un-namespace.h libc_private.h
    '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    libmd
    libresolv
    libutil
    libxo
    ncurses
    xz
    zlib
  ] ++ lib.optionals (lib.versionOlder (lib.getVersion apple-sdk) "11.0") [ libbsd ];

  postInstall = ''
    # Patch the shebangs to use `sh` from shell_cmds.
    HOST_PATH='${lib.getBin shell_cmds}/bin' patchShebangs --host "$out/bin"
  '';

  meta = {
    description = "Text commands for Darwin";
  };
}
