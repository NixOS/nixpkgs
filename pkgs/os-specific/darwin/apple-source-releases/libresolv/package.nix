{
  lib,
  apple-sdk,
  mkAppleDerivation,
  stdenvNoCC,
}:

let
  configd = apple-sdk.sourceRelease "configd";
  dyld = apple-sdk.sourceRelease "dyld";
  Libinfo = apple-sdk.sourceRelease "Libinfo";
  Libnotify = apple-sdk.sourceRelease "Libnotify";
  xnu = apple-sdk.sourceRelease "xnu";

  # `arpa/nameser_compat.h` is included in the Libc source release instead of libresolv.
  Libc = apple-sdk.sourceRelease "Libc";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "libresolv-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/mach-o" \
        '${dyld}/include/mach-o/dyld_priv.h'

      substituteInPlace "$out/include/mach-o/dyld_priv.h" \
        --replace-fail ', bridgeos(3.0)' "" \
        --replace-fail '//@VERSION_DEFS@' 'const dyld_build_version_t dyld_2024_SU_E_os_versions = { 1 /* macOS */, 150400 };'
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
    mkdir arpa
    cp ${Libc}/include/arpa/nameser_compat.h arpa/nameser_compat.h
    cp nameser.h arpa
  '';

  xcodeHash = "sha256-yHNa6cpI3T4R/iakeHmL6S/c9p+VpYR4fudv2UXUpnY=";

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include -I${configd}/dnsinfo -I${Libinfo}/lookup.subproj -I${Libnotify}";

  postInstall = ''
    ln -s ../nameser.h "''${!outputDev}/include/arpa"
  '';

  meta = {
    description = "Libresolv implementation for Darwin";
    license = lib.licenses.apple-psl10;
  };
}
