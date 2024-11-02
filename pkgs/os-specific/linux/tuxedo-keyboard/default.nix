{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders, pahole }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.2.14";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L3NsUUKA/snUcRWwlZidsBiTznhfulNldidEDDmNOkw=";
  };

  buildInputs = [
    pahole
    linuxHeaders
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko tuxedo_keyboard.ko tuxedo_io/tuxedo_io.ko uniwill_wmi.ko; do
        mv src/$module $out/lib/modules/${kernel.modDirVersion}
    done

    runHook postInstall
  '';

  meta = {
    broken = stdenv.hostPlatform.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models).

      Can be used with the "hardware.tuxedo-keyboard" NixOS module.
    '';
    maintainers = [ lib.maintainers.blanky0230 ];
    platforms = lib.platforms.linux;
  };
})
