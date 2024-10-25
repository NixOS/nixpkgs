{
  lib,
  apple-sdk_11,
  mkAppleDerivation,
}:

let
  configd = apple-sdk_11.sourceRelease "configd";
  Libinfo = apple-sdk_11.sourceRelease "Libinfo";

  # `arpa/nameser_compat.h` is included in the Libc source release instead of libresolv.
  Libc = apple-sdk_11.sourceRelease "Libc";
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

  # Remove unsupported availability annotations to support SDK without updated availability headers.
  postPatch = ''
    substituteInPlace dns_util.h \
      --replace-fail 'API_DEPRECATED_BEGIN("dns_util is deprecated.", macos(10.0, 13.0), ios(1.0, 16.0), watchos(1.0, 9.0), tvos(1.0, 16.0))' "" \
      --replace-fail API_DEPRECATED_END ""
  '';

  env.NIX_CFLAGS_COMPILE = "-I${configd}/dnsinfo -I${Libinfo}/lookup.subproj";

  postInstall = ''
    mkdir -p "$out/include/arpa"
    ln -s ../nameser.h "$out/include/arpa"
    cp ${Libc}/include/arpa/nameser_compat.h "$out/include/arpa"
  '';

  meta = {
    description = "libresolv implementation for Darwin";
    license = lib.licenses.apple-psl10;
  };
}
