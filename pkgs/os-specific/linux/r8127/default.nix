{
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r8127";
  version = "11.015.00";

  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "rtl8127";
    tag = finalAttrs.version;
    hash = "sha256-U0i/IxB7EiiHGulwI4TdYeaOpHq8v4JBSTVZ0qMbcx0=";
  };

  hardeningDisable = [
    "pic"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail '$(shell uname -r)' "${kernel.modDirVersion}" \
      ;
  '';

  makeFlags = kernelModuleMakeFlags;

  enableParallelBuilding = true;

  buildFlags = [ "modules" ];

  installPhase =
    let
      modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/r8127";
    in
    ''
      runHook preInstall

      install -Dm0644 *.ko -t ${modDestDir}

      runHook postInstall
    '';

  meta = {
    description = "Realtek 8127 10G Ethernet driver";
    homepage = "https://github.com/openwrt/rtl8127";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.wwmoraes ];
    platforms = lib.platforms.linux;
  };
})
