{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "rtl88x2bu";
  version = "0-unstable-2026-10-27";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RinCat";
    repo = "RTL88x2BU-Linux-Driver";
    rev = "465ae7cb522a382adc85ea5c31f228af8d172148";
    hash = "sha256-+UDY9B6ZjwkDNbVoYhpwAiZ+cLd72/LMp/mQ6LJN5+0=";
  };

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail 'install -p -m 644 $(MODULE_NAME).ko  $(MODDESTDIR)' \
        '$(MAKE) -C $(KSRC) M=$(shell pwd) modules_install'
  '';

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=$(out)"
    "INSTALL_MOD_DIR=kernel/net/wireless"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

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
