{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "xpad-noone";
  version = "0-unstable-2024-01-10";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = finalAttr.pname;
    tag = "c3d1610";
    hash = "sha256-jDRyvbU9GsnM1ARTuwnoD7ZXlfBxne13UpSKRo7HHSY=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags;

  postPatch = ''
    substituteInPlace Makefile --replace-fail "/lib/modules/\$(shell uname -r)/build" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  installPhase = ''
    runHook preInstall

    install *.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/xpad-noone

    runHook postInstall
  '';

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
