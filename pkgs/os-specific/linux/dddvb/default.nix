{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "dddvb";
  version = "0.9.38-pre.6";

  src = fetchFromGitHub {
    owner = "DigitalDevices";
    repo = "dddvb";
    tag = version;
    hash = "sha256-bt/vMnqRWDDChZ6R4JbCr77cz3nlSPkx6siC9KLSEqs=";
  };

  patches = [
    (fetchpatch {
      # pci_*_dma_mask no longer exists in 5.18
      url = "https://github.com/DigitalDevices/dddvb/commit/871821d6a0be147313bb52570591ce3853b3d370.patch";
      hash = "sha256-wY05HrsduvsIdp/KpS9NWfL3hR9IvGjuNCDljFn7dd0=";
    })
  ];

  postPatch = ''
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  INSTALL_MOD_PATH = placeholder "out";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/DigitalDevices/dddvb";
    description = "Device driver for all Digital Devices DVB demodulator and modulator cards";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.linux;
    broken = lib.versionAtLeast kernel.version "6.2";
  };
}
