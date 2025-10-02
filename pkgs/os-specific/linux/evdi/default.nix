{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
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
  version = "1.14.11";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SxYUhu76vwgCQgjOYVpvdWsFpNcyzuSjZe3x/v566VU=";
  };

  prePatch = ''
    substituteInPlace module/Makefile \
      --replace-fail '/etc/os-release' '/dev/null'
  '';

  env.CFLAGS = toString [
    "-Wno-error"
    "-Wno-error=discarded-qualifiers" # for Linux 4.19 compatibility
    "-Wno-error=sign-compare"
  ];

  postBuild = ''
    # Don't use makeFlags for userspace stuff
    make library pyevdi
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [
    kernel
    libdrm
    python3WithLibs
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "module"
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
