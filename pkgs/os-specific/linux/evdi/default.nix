{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  libdrm,
  python3,
}:

let
  python3WithLibs = python3.withPackages (
    ps: with ps; [
      pybind11
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evdi";
  version = "1.14.7-unstable-2024-11-30";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "59a3a864f7476cd61d9c65bfd012d1e9ed90e2b1";
    hash = "sha256-0xEh0Tb5QFReW5lXO/Mb3gn1z87+baR8Tix+dQjUZMw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/DisplayLink/evdi/commit/e41240cf62d7188643bc95e5d69e1c4cfa6ddb84.patch?full_index=1";
      hash = "sha256-6V3QJZMAhXqfGLW2eWkIzJnOdBPvLLNVzg6DW1M3IaA=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
    "-Wno-error=discarded-qualifiers" # for Linux 4.19 compatibility
    "-Wno-error=sign-compare"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [
    kernel
    libdrm
    python3WithLibs
  ];

  makeFlags = kernel.makeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [
    "format"
    "pic"
    "fortify"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    broken = kernel.kernelOlder "4.19";
    changelog = "https://github.com/DisplayLink/evdi/releases/tag/v${finalAttrs.version}";
    description = "Extensible Virtual Display Interface";
    homepage = "https://www.displaylink.com/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
