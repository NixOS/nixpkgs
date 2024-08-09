{ lib, stdenv, fetchFromGitLab, kernel, linuxHeaders, pahole }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "tuxedocomputers";
    repo = "development/packages/tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WQy/5NB/N8JjOKEw00PisCTH0ITrQDQCXaKPl5P+6Wo=";
  };

  buildInputs = [
    pahole
    linuxHeaders
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko \
                  ite_829x/ite_829x.ko ite_8291/ite_8291.ko ite_8291_lb/ite_8291_lb.ko ite_8297/ite_8297.ko \
                  tuxedo_compatibility_check/tuxedo_compatibility_check.ko tuxedo_io/tuxedo_io.ko tuxedo_keyboard.ko \
                  tuxedo_nb02_nvidia_power_ctrl/tuxedo_nb02_nvidia_power_ctrl.ko \
                  tuxedo_nb04/tuxedo_nb04_kbd_backlight.ko tuxedo_nb04/tuxedo_nb04_keyboard.ko tuxedo_nb04/tuxedo_nb04_power_profiles.ko \
                  tuxedo_nb04/tuxedo_nb04_sensors.ko tuxedo_nb04/tuxedo_nb04_wmi_ab.ko tuxedo_nb04/tuxedo_nb04_wmi_bs.ko \
                  tuxedo_nb05/tuxedo_nb05_ec.ko tuxedo_nb05/tuxedo_nb05_fan_control.ko tuxedo_nb05/tuxedo_nb05_kbd_backlight.ko \
                  tuxedo_nb05/tuxedo_nb05_keyboard.ko tuxedo_nb05/tuxedo_nb05_power_profiles.ko tuxedo_nb05/tuxedo_nb05_sensors.ko \
                  uniwill_wmi.ko; do
        install -Dm444 src/$module -t $out/lib/modules/${kernel.modDirVersion}
    done

    runHook postInstall
  '';

  meta = {
    broken = stdenv.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    homepage = "https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models).

      Can be used with the "hardware.tuxedo-drivers" NixOS module.
    '';
    maintainers = [ lib.maintainers.blanky0230 ];
    platforms = lib.platforms.linux;
  };
})
