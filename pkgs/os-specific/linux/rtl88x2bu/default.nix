{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2026-10-27";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RinCat";
    repo = "RTL88x2BU-Linux-Driver";
    rev = "465ae7cb522a382adc85ea5c31f228af8d172148";
    hash = "sha256-+UDY9B6ZjwkDNbVoYhpwAiZ+cLd72/LMp/mQ6LJN5+0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \#
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/RinCat/RTL88x2BU-Linux-Driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      otavio
      claymorwan
    ];

    broken = kernel.kernelOlder "5.11";
  };
}
