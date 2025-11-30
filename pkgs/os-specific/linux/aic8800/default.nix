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
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  patchPhase = ''
    runHook prePatch

    # Apply all patches in debian/patches
    dpkg-source --before-build .

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    make $makeFlags M="$PWD"/src/PCIE/driver_fw/driver/aic8800/aic8800_fdrv
    make $makeFlags M="$PWD"/src/SDIO/driver_fw/driver/aic8800
    make $makeFlags M="$PWD"/src/USB/driver_fw/drivers/aic8800
    make $makeFlags M="$PWD"/src/USB/driver_fw/drivers/aic_btusb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for varient in 'PCIE' 'SDIO' 'USB'
    do
      find ./src/"$varient"/ -name "*.ko" -exec install {} -Dm444 -v -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/aic8800_"$varient" \;
    done

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
