{
  lib,
  apple-sdk,
  apple-sdk_11,
  apple-sdk_13,
  bzip2,
  libbsd,
  libresolv,
  libutil,
  libxo,
  mkAppleDerivation,
  shell_cmds,
  ncurses,
  pkg-config,
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

  xcodeHash = "sha256-DzLrQ8CbInXj7PrV9jp3nHfE84A09ZwS729c9WXFV4Y=";

  postPatch =
    ''
      # Fix format security errors
      sed -e 's/wprintw(\([^,]*\), \([^)]*\))/wprintw(\1, "%s", \2)/g' -i ee/ee.c
    '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
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
