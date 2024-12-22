{
  apple-sdk,
  apple-sdk_10_13,
  apple-sdk_11,
  mkAppleDerivation,
  stdenvNoCC,
}:

let
  # The 10.12 SDK doesn’t have the files needed in the same places or possibly at all.
  # Just use the 11.x SDK to make things easier.
  xnu = apple-sdk_11.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "removefile-deps-private-headers";

    buildCommand = ''
      mkdir -p "$out/include/apfs"
      # APFS group is 'J' per https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/vfs/vfs_fsevents.c#L1054
      cat <<EOF > "$out/include/apfs/apfs_fsctl.h"
      #pragma once
      #include <stdint.h>
      #include <sys/ioccom.h>
      struct xdstream_obj_id {
        char* xdi_name;
        uint64_t xdi_xdtream_obj_id;
      };
      #define APFS_CLEAR_PURGEABLE 0
      #define APFSIOC_MARK_PURGEABLE _IOWR('J', 68, uint64_t)
      #define APFSIOC_XDSTREAM_OBJ_ID _IOR('J', 35, struct xdstream_obj_id)
      EOF
    '';
  };
in
mkAppleDerivation {
  releaseName = "removefile";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  xcodeHash = "sha256-pE92mVI0KTHOVKBA4T5R1rHy5//uipOimas7DaTVe0U=";

  postPatch = ''
    # Disable experimental bounds safety stuff that’s not available in LLVM 16.
    substituteInPlace removefile.h \
      --replace-fail '__ptrcheck_abi_assume_single()' "" \
      --replace-fail '__unsafe_indexable' ""
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "Darwin file removing library";
}
