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
];

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
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ windows.mingw_w64_headers ];
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];
}
