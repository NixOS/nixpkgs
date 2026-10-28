{
  lib,
  stdenv,
  windows,
  autoreconfHook,
  mingw_w64_headers,
  crt ? stdenv.hostPlatform.libc,
}:

stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit (mingw_w64_headers) version src meta;

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    (lib.enableFeature true "idl")
    (lib.enableFeature true "secure-api")
    (lib.withFeatureAs true "default-msvcrt" crt)

    # Including other architectures causes errors with invalid asm
    (lib.enableFeature stdenv.hostPlatform.isi686 "lib32")
    (lib.enableFeature stdenv.hostPlatform.isx86_64 "lib64")
    (lib.enableFeature stdenv.hostPlatform.isAarch64 "libarm64")
  ];

  # MinGW has no pthreads of its own; threading goes through the Win32 API
  # declared by these headers. See `threadModel` in
  # pkgs/development/compilers/gcc/ng/common/libgcc/default.nix.
  passthru.threadModel = "win32";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ mingw_w64_headers ];
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];
}
