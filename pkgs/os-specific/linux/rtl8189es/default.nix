{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "rtl8189es";
  version = "0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "81e7b8939cf2b4ba0a80da6786055ba0dc740362";
    hash = "sha256-bNZXeXPS3M7inWEGz3OuIt/6hTMvoqSpQob5cHhj0Xw=";
  };

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [
    "pic"
    "format"
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail 'install -p -m 644 $(MODULE_NAME).ko  $(MODDESTDIR)' \
        '$(MAKE) -C $(KSRC) M=$(shell pwd) modules_install'
  '';

  enableParallelBuilding = true;

  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    (
      "CONFIG_PLATFORM_I386_PC="
      + (if (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) then "y" else "n")
    )
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
    "INSTALL_MOD_PATH=$(out)"
    "INSTALL_MOD_DIR=kernel/net/wireless"
    "DEPMOD=true"
  ];

  meta = {
    description = "Driver for Realtek rtl8189es";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danielfullmer ];
  };
}
