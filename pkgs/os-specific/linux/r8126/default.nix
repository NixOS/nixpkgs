{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r8126";
  version = "10.016.00";

  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "rtl8126";
    tag = finalAttrs.version;
    hash = "sha256-Smf512av6B8b5dAwOLVRelBf6goLdLqSJ0bLCf+f2b8=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek
    cp r8126.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/openwrt/rtl8126";
    description = "Realtek r8126 5G Ethernet driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.andresilva ];
  };
})
