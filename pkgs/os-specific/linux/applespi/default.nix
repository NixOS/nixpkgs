{ stdenv, fetchgit, pkgs }:
let
  version = "git";
  kernel = pkgs.linux;
in
stdenv.mkDerivation {
  name = "applespi-${version}-${kernel.version}";

  src = fetchgit {
    url = "https://github.com/cb22/macbook12-spi-driver.git";
    rev = "aeb7ca96eaf7c82418eb967aba5d991a33006899";
    sha256 = "04hcy8cfm2kdrqs1cyd9s37x4qh5az5vdy477y5lfw2f33rwid1l";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  installPhase = ''
    install -D -m 755 -t $out/lib/modules/${kernel.version}/kernel/drivers/input/misc/ applespi.ko
  '';

  meta = {
    description = "Experimental input driver for the SPI touchpad and keyboard found in some MacBooks";
    longDescription = ''
      To have the keyboard enabled during boot add the following to configuration.nix,
 
        boot = {
          initrd.availableKernelModules = [ "crc16" "spi_pxa2xx_platform" "spi_pxa2xx_pci" "intel_lpss_pci" ];
          extraModulePackages = with pkgs; [ applespi ];
          initrd.kernelModules = [ "applespi" ];
        }
    '';
    homepage = https://github.com/cb22/macbook12-spi-driver;
    license = pkgs.licenses.gpl2;
    maintainers = [ pkgs.maintainers.krav ];
  };
}
