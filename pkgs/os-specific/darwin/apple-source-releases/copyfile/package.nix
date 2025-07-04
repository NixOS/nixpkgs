{
  lib,
  apple-sdk,
  mkAppleDerivation,
  stdenvNoCC,
}:

let
  xnu = apple-sdk.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "copyfile-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/Kernel/sys" \
        '${xnu}/bsd/sys/decmpfs.h'

      install -D -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/content_protection.h' \
        '${xnu}/bsd/sys/fsctl.h'
      substituteInPlace "$out/include/System/sys/content_protection.h" \
        --replace-fail '#ifdef PRIVATE' '#if 1'

      mkdir -p "$out/include/xpc"
      cat <<EOF > "$out/include/xpc/private.h"
      #pragma once
      extern int _xpc_runtime_is_app_sandboxed();
      EOF

      # https://github.com/apple-oss-distributions/copyfile/blob/ed3f0a8bf8b6bac6838c92c297afcc826fec75f4/copyfile.c#L64-L74
      cat <<EOF > "$out/include/quarantine.h"
      #pragma once
      typedef void* qtn_file_t;
      #define QTN_SERIALIZED_DATA_MAX 4096
      #define qtn_file_alloc _qtn_file_alloc
      #define qtn_file_init_with_fd _qtn_file_init_with_fd
      #define qtn_file_init_with_path _qtn_file_init_with_path
      #define qtn_file_init_with_data _qtn_file_init_with_data
      #define qtn_file_free _qtn_file_free
      #define qtn_file_apply_to_fd _qtn_file_apply_to_fd
      #define qtn_error _qtn_error
      #define qtn_file_to_data _qtn_file_to_data
      #define qtn_file_clone _qtn_file_clone
      #define qtn_file_get_flags _qtn_file_get_flags
      #define qtn_file_set_flags _qtn_file_set_flags
      extern void * qtn_file_alloc(void);
      extern int qtn_file_init_with_fd(void *x, int y);
      extern int qtn_file_init_with_path(void *x, const char *path);
      extern int qtn_file_init_with_data(void *x, const void *data, size_t len);
      extern void qtn_file_free(void *);
      extern int qtn_file_apply_to_fd(void *x, int y);
      extern char *qtn_error(int x);
      extern int qtn_file_to_data(void *x, char *y, size_t *z);
      extern void *qtn_file_clone(void *x);
      extern uint32_t qtn_file_get_flags(void *x);
      extern int qtn_file_set_flags(void *x, uint32_t flags);
      #define qtn_xattr_name "com.apple.quarantine"
      #define QTN_FLAG_DO_NOT_TRANSLOCATE 0x100
      EOF
    '';
  };
in
mkAppleDerivation {
  releaseName = "copyfile";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  xcodeHash = "sha256-SYW6pBlCQkcbkBqCq+W/mDYZZ7/co2HlPZwXzgh/LnI=";

  postPatch = ''
    # Disable experimental bounds safety stuff that’s not available in LLVM 16.
    for header in copyfile.h xattr_flags.h; do
      substituteInPlace "$header" \
        --replace-fail '__ptrcheck_abi_assume_single()' "" \
        --replace-fail '__unsafe_indexable' ""
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "Darwin file copying library";
}
