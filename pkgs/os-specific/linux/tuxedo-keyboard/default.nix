{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders, pahole }:

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "unstable-2023-06-19";
  # using unstable for now to allow building on linux kernels >= 6.4
  # switch back to stable once a release containing 04112f65ec4099d43bca8c00acc61f3a2c0e185f is available

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "04112f65ec4099d43bca8c00acc61f3a2c0e185f";
    hash = "sha256-SkSv9XHIMU+DplzJBegifBB88/AEGSqOf01GX7rtvXM=";
  };

  patches = [ ./dmi_string_in.patch ];

  buildInputs = [
    pahole
    linuxHeaders
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko tuxedo_keyboard.ko tuxedo_io/tuxedo_io.ko uniwill_wmi.ko; do
        mv src/$module $out/lib/modules/${kernel.modDirVersion}
    done
  '';

  meta = with lib; {
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models).

      Can be used with the "hardware.tuxedo-keyboard" NixOS module.
    '';
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
    maintainers = [ maintainers.blanky0230 ];
  };
}
