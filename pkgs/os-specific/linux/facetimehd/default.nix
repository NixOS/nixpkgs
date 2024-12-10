{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "facetimehd-${version}-${kernel.version}";
  version = "0.6.8.1";

  # Note: When updating this revision:
  # 1. Also update pkgs/os-specific/linux/firmware/facetimehd-firmware/
  # 2. Test the module and firmware change via:
  #    a. Give some applications a try (Skype, Hangouts, Cheese, etc.)
  #    b. Run: journalctl -f
  #    c. Then close the lid
  #    d. Then open the lid (and maybe press a key to wake it up)
  #    e. see if the module loads back (apps using the camera won't
  #       recover and will have to be restarted) and the camera
  #       still works.
  src = fetchFromGitHub {
    owner = "patjak";
    repo = "facetimehd";
    rev = version;
    sha256 = "sha256-h5Erga2hlDIWdDKQbkmkLY1aNCibFM7SVSnxVcoToaM=";
  };

  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '';

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    homepage = "https://github.com/patjak/bcwc_pcie";
    description = "Linux driver for the Facetime HD (Broadcom 1570) PCIe webcam";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      womfoo
      grahamc
      kraem
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
