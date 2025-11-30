{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "morse-driver";
  version = "1.16.4-${kernel.version}";

  src = fetchFromGitHub {
    owner = "MorseMicro";
    repo = "morse_driver";
    rev = "7f95fe37750a09259b4d2988a9cf22df60f76fdf";
    hash = "sha256-kMEFl1sfDGqh96t5emF9UtzOqauFClKXBsXrS1NZ33E=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-fix-build-compatibility-with-Linux-6.12-and-hardened.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags =
    kernelModuleMakeFlags
    ++ [
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
      "CONFIG_ANDROID=n"
      "CONFIG_MORSE_WATCHDOG_RESET_DEFAULT_DISABLED=y"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    install -D -m 644 morse.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/morse.ko"
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
