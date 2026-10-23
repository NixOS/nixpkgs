{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpad-noone";
  version = "0-unstable-2024-01-10";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = finalAttrs.pname;
    tag = "c3d1610";
    hash = "sha256-jDRyvbU9GsnM1ARTuwnoD7ZXlfBxne13UpSKRo7HHSY=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/xpad-noone"
  ];

  patches = [
    # https://github.com/medusalix/xpad-noone/pull/9
    (fetchpatch2 {
      name = "remove-usage-of-deprecated-ida-simple-xx-api.patch";
      url = "https://github.com/medusalix/xpad-noone/commit/e0f6ad5f2fabd5f8e74796a87154c92c8e9b6068.patch";
      hash = "sha256-7Ye/rd51RpzThgts8R5RT0CRVvx5bKmy5i0KPidic30=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail "/lib/modules/\$(shell uname -r)/build" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/medusalix/xpad-noone";
    description = "Xpad driver from the Linux kernel with support for Xbox One controllers removed";
    license = with lib.licenses; [
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "5.15";
  };
})
