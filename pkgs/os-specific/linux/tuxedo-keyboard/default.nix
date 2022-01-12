{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders }:

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "v${version}";
    sha256 = "HGN2CKJ76FzgKkOsU5pLMsRl7hEGMcZ8Loa2YP0P558=";
  };

  buildInputs = [ linuxHeaders ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko tuxedo_keyboard.ko tuxedo_io/tuxedo_io.ko; do
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
