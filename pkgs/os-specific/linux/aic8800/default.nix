{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  dpkg,
  aic8800-firmware,
}:
stdenv.mkDerivation (finalAttr: {
  name = "aic8800";
  version = aic8800-firmware.version;
  src = aic8800-firmware.src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ dpkg ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  patchPhase = ''
    runHook prePatch

    dpkg-source --before-build .
    cp -fv ${./Makefile} ./Makefile

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    find . -name "*.ko" -exec install {} -Dm444 -v -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/aic8800 \;

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/radxa-pkg/aic8800";
    description = "Aicsemi aic8800 Wi-Fi driver";
    # https://github.com/radxa-pkg/aic8800/issues/54
    license = with lib.licenses; [
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.linux;
  };
})
