{
  lib,
  fetchFromGitHub,
  mkAppleDerivation,
  sourceRelease,
  stdenvNoCC,
}:

let
  configd = sourceRelease "configd";
  dyld = sourceRelease "dyld";
  Libinfo = sourceRelease "Libinfo";
  Libnotify = sourceRelease "Libnotify";

  # `arpa/nameser_compat.h` is included in the Libc source release instead of libresolv.
  Libc = sourceRelease "Libc";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "libresolv-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/mach-o" \
        '${dyld}/include/mach-o/dyld_priv.h'

      substituteInPlace "$out/include/mach-o/dyld_priv.h" \
        --replace-fail ', bridgeos(3.0)' "" \
        --replace-fail '//@VERSION_DEFS@' 'const dyld_build_version_t dyld_2024_SU_E_os_versions = { 1 /* macOS */, 150400 };'

      # dyld_priv.h references TARGET_OS_EXCLAVEKIT (added in newer Xcode) under
      # -Werror=undef-prefix=TARGET_OS_. SDKs in nixpkgs don't define it yet.
      # Default to 0 (not an ExclaveKit target) to satisfy the compile.
      {
        printf '#ifndef TARGET_OS_EXCLAVEKIT\n#define TARGET_OS_EXCLAVEKIT 0\n#endif\n'
        cat "$out/include/mach-o/dyld_priv.h"
      } > "$out/include/mach-o/dyld_priv.h.new"
      mv "$out/include/mach-o/dyld_priv.h.new" "$out/include/mach-o/dyld_priv.h"
    '';
  };
in
mkAppleDerivation {
  releaseName = "libresolv";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  postPatch = ''
    cp ${Libc}/include/arpa/nameser_compat.h arpa/nameser_compat.h

    # Use CommonCrypto’s implementation of MD5. The upstream build appears to use corecrypto, which we can’t use.
    substituteInPlace hmac_link.c \
      --replace-fail '<md5.h>' '<CommonCrypto/CommonDigest.h>'
  '';

  xcodeHash = "sha256-pQ1eFMPnSy8M3pfvv+sPyale9xDlVCMif0EWO8PO7zg=";

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include -I${configd}/dnsinfo -I${Libinfo}/lookup.subproj -I${Libnotify}";

  postInstall = ''
    ln -s ../nameser.h "''${!outputDev}/include/arpa"
  '';

  meta = {
    description = "Libresolv implementation for Darwin";
    license = lib.licenses.apple-psl10;
  };
}
