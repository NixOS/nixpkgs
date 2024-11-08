{
  lib,
  stdenv,
  windows,
  autoreconfHook,
  mingw_w64_headers,
  crt ? stdenv.hostPlatform.libc,
}:

assert lib.assertOneOf "crt" crt [
  "msvcrt"
  "ucrt"
  "cygwin"
];

stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit (mingw_w64_headers) version src meta;

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    (lib.enableFeature stdenv.targetPlatform.isMinGW "idl")
    (lib.enableFeature stdenv.targetPlatform.isMinGW "secure-api")
    (lib.enableFeature stdenv.targetPlatform.isCygwin "w32api")
    (lib.withFeatureAs true "default-msvcrt" crt)

    # Including other architectures causes errors with invalid asm
    (lib.enableFeature stdenv.hostPlatform.isi686 "lib32")
    (lib.enableFeature stdenv.hostPlatform.isx86_64 "lib64")
    (lib.enableFeature stdenv.hostPlatform.isAarch64 "libarm64")
  ];

  postInstall = lib.optionalString stdenv.targetPlatform.isCygwin ''
    cd $out/lib
    ln -fs w32api/libkernel32.a .
    ln -fs w32api/libuser32.a .
    ln -fs w32api/libadvapi32.a .
    ln -fs w32api/libshell32.a .
    ln -fs w32api/libgdi32.a .
    ln -fs w32api/libcomdlg32.a .
    ln -fs w32api/libntdll.a .
    ln -fs w32api/libnetapi32.a .
    ln -fs w32api/libpsapi.a .
    ln -fs w32api/libuserenv.a .
    ln -fs w32api/libnetapi32.a .
    ln -fs w32api/libdbghelp.a .
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ windows.mingw_w64_headers ];
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];
}
