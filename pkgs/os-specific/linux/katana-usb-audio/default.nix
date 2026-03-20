{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  udevCheckHook,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "katana-usb-audio";
  version = "unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = pname;
    rev = "73783991f3044602197abd40f37650bdc5f8f030";
    hash = "sha256-oLpQS0N1IscKPL8QPfMtIQw2bbkIqWdolGQWF7o64Ks=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    udevCheckHook
  ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODULE_DIR=$(out)/lib/modules/${kernel.modDirVersion}/extras"
    "UDEV_RULES_DIR=$(out)/etc/udev/rules.d"
  ];

  patches = [ ./makefile.patch ];

  preBuild = ''
    substituteInPlace 99-katana-usb-audio.rules \
     --replace-fail "/bin/sh" "${lib.getExe bash}"
  '';

  meta = with lib; {
    description = "Linux kernel driver for the SoundBlaster X Katana USB soundbar";
    longDescription = ''
      Replaces the generic snd-usb-audio driver for Creative Labs SoundBlaster X
      Katana (USB) with a custom ALSA/USB kernel module that correctly handles
      volume control and audio playback for this device.
    '';
    homepage = "https://github.com/mrworf/katana-usb-audio";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.Svenum ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.15";
  };
}
