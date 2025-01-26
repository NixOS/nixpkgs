{
  lib,
  apple-sdk,
  mkAppleDerivation,
  ncurses,
  pkg-config,
  stdenvNoCC,
}:

let
  iokitUser = apple-sdk.sourceRelease "IOKitUser";
  xnu = apple-sdk.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "IOKitTools-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/IOKit/" \
        '${iokitUser}/IOKitLibPrivate.h' \
        '${xnu}/iokit/IOKit/IOKitKeysPrivate.h'

      install -D -t "$out/include/Kernel/libkern" \
          '${xnu}/libkern/libkern/OSKextLibPrivate.h'

      mkdir -p "$out/include/perfdata"
      cat <<EOF > "$out/include/perfdata/perfdata.h"
      #pragma once
      typedef void* pdunit_t;

      #define PDUNIT_CUSTOM(x) ((void*)("#\"" x "\""))
      extern const pdunit_t pdunit_B;

      typedef void* pdwriter_t;
      extern pdwriter_t pdwriter_open(const char*, const char*, size_t, size_t);
      extern void pdwriter_close(pdwriter_t);
      extern void pdwriter_new_value(pdwriter_t, const char*, pdunit_t, double);
      extern void pdwriter_record_variable_str(pdwriter_t, char*, const char*);
      EOF
    '';
  };
in
mkAppleDerivation {
  releaseName = "IOKitTools";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-qFG4sB8NXNPTSvYTEX2E1ReOX+NcMBHrS2NuNBLO7zw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    apple-sdk.privateFrameworksHook
    ncurses
  ];

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "IOKit tools";
}
