{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders, pahole }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.2.7";
=======
stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q0wnejeLGLSDS0GPxQuYUKCAdzbYA66KT0DuWsEKIRs=";
=======
    rev = "v${version}";
    sha256 = "h6+br+JPEItym83MaVt+xo6o/zMtTv8+wsBoTeYa2AM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    pahole
    linuxHeaders
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
<<<<<<< HEAD
    runHook preInstall

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko tuxedo_keyboard.ko tuxedo_io/tuxedo_io.ko uniwill_wmi.ko; do
        mv src/$module $out/lib/modules/${kernel.modDirVersion}
    done
<<<<<<< HEAD

    runHook postInstall
  '';

  meta = {
    broken = stdenv.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = lib.licenses.gpl3Plus;
=======
  '';

  meta = with lib; {
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models).

      Can be used with the "hardware.tuxedo-keyboard" NixOS module.
    '';
<<<<<<< HEAD
    maintainers = [ lib.maintainers.blanky0230 ];
    platforms = lib.platforms.linux;
  };
})
=======
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
    maintainers = [ maintainers.blanky0230 ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
