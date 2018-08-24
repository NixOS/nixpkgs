with pkgs;

let
  ucm = fetchzip {
    url = "https://github.com/plbossart/UCM/archive/2050ca78a4d1a853d1ba050b591f42e6f97adfc0.tar.gz";
    sha256 = "1rs4mpz3b965nmz0yhy6j4ga3fdz320qnpkd7d61nvpv9c3i6zwj";
  };
in

{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
  ];

  # Sound only properly works out of the box on 4.18+ kernels.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Required for screen brightness control:
  boot.kernelParams = [ "acpi_backlight=vendor" ];

  # Sound requires a custom UCM config:
  system.replaceRuntimeDependencies = [{
    original = pkgs.alsaLib;

    replacement = pkgs.alsaLib.overrideAttrs (super: {
      postFixup = "cp -r ${ucm}/chtmax98090 $out/share/alsa/ucm";
    });
  }];
}
