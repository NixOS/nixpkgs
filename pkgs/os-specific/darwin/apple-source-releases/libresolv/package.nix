{
  lib,
  apple-sdk,
  mkAppleDerivation,
}:

let
  configd = apple-sdk.sourceRelease "configd";
  Libinfo = apple-sdk.sourceRelease "Libinfo";

  # `arpa/nameser_compat.h` is included in the Libc source release instead of libresolv.
  Libc = apple-sdk.sourceRelease "Libc";
in
mkAppleDerivation {
  releaseName = "libresolv";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  xcodeHash = "sha256-yHNa6cpI3T4R/iakeHmL6S/c9p+VpYR4fudv2UXUpnY=";

  postUnpack = ''
    mkdir -p "$sourceRoot/arpa"
    ln -s "$NIX_BUILD_TOP/$sourceRoot/nameser.h" "$sourceRoot/arpa/nameser.h"
  '';

  env.NIX_CFLAGS_COMPILE = "-I${configd}/dnsinfo -I${Libinfo}/lookup.subproj";

  postInstall = ''
    mkdir -p "$out/include/arpa"
    ln -s ../nameser.h "$out/include/arpa"
    cp ${Libc}/include/arpa/nameser_compat.h "$out/include/arpa"
  '';

  meta = {
    description = "Libresolv implementation for Darwin";
    license = lib.licenses.apple-psl10;
  };
}
