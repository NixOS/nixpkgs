{ lib
, stdenv
, fetchFromGitHub
, kernel
, libdrm
, python3
}:

let
  python3WithLibs = python3.withPackages (ps: with ps; [
    pybind11
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evdi";
  version = "1.14.5";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-G+zNFwKWtAFr2AapQoukjFQlFItIP5Q5m5TWuvTMY8k=";
  };

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
    # This was removed in https://github.com/DisplayLink/evdi/commit/9884501a20346ff85d8a8e3782e9ac9795013ced#diff-5d2a962cad1c08060cbab9e0bba5330ed63958b64ac04024593562cec55f176dL52
    "CONFIG_DRM_EVDI=m"
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    broken = kernel.kernelOlder "4.19";
    changelog = "https://github.com/DisplayLink/evdi/releases/tag/v${finalAttrs.version}";
    description = "Extensible Virtual Display Interface";
    homepage = "https://www.displaylink.com/";
    license = with licenses; [ lgpl21Only gpl2Only ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
