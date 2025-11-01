{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "morse-driver";
  version = "1.14.1-${kernel.version}";

  src = fetchFromGitHub {
    owner = "MorseMicro";
    repo = "morse_driver";
    rev = "33f0092d5c859d8589b99c6e9a77abc58c093648";
    hash = "sha256-VNw5OdxkP8GltYU2kDYdBUGKWIlPhr3tkzqtW+3MigE=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-fix-fix-conflicting-types-for-morse_firmware_init.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  makeFlags = [
    "ARCH=${kernel.arch or stdenv.hostPlatform.linuxArch}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

    # --- Morse-specific Kconfig options ---
    "CONFIG_WLAN_VENDOR_MORSE=m"
    "CONFIG_MORSE_SDIO=y"
    "CONFIG_MORSE_SDIO_ALIGNMENT=4"
    "CONFIG_MORSE_USER_ACCESS=y"
    "CONFIG_MORSE_VENDOR_COMMAND=y"
    "CONFIG_MORSE_COUNTRY=US"
    "CONFIG_MORSE_DEBUG_MASK=4"
    "CONFIG_MORSE_SDIO_RESET_TIME=400"
    "CONFIG_MORSE_POWERSAVE_MODE=0"
    "CONFIG_MORSE_WATCHDOG_RESET_DEFAULT_DISABLED=y"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    find . -name "*.ko" -exec cp {} $out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/ \;
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Morse Micro Wi-Fi driver";
    homepage = "https://github.com/MorseMicro/morse_driver";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ govindsi ];
  };
}
