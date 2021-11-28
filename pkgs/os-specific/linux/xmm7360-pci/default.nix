{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel, perl, bc, breakpointHook }:

stdenv.mkDerivation rec {
  pname = "xmm7360-pci";
  version = "unstable-2021-07-19";

  src = fetchFromGitHub {
    owner = "xmm7360";
    repo = "xmm7360-pci";
    rev = "7086b80bb609180b1b89fb478751e5e8414ab64f";
    sha256 = "1wdb0phqg9rj9g9ycqdya0m7lx24kzjlh25yw0ifp898ddxrrr0c";
  };

  patches = [
    # Change xmm7360_tty_write_room to unsigned in xmm7360.c
    # https://github.com/xmm7360/xmm7360-pci/pull/139
    ./516617f9bb63900f1e1a96d8ef58105edb9808a8.patch

    # xmm7360: Drop put_tty_driver
    # https://github.com/xmm7360/xmm7360-pci/pull/152
    ./72e2d597d19d7b2a4e172637715aa0c14deaee71.patch

    # xmm7360: Add irq handler before device init
    # https://github.com/xmm7360/xmm7360-pci/pull/149
    ./704e1ca6421947183be4b1fe9f2f6c54213b60c2.patch
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  INSTALL_MOD_PATH = placeholder "out";
  installFlags = [ "DEPMOD=true" ];

  meta = with lib; {
    homepage = "https://github.com/xmm7360/xmm7360-pci";
    description = "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
    downloadPage = "https://github.com/xmm7360/xmm7360-pci";
    license = licenses.isc;
    maintainers = with maintainers; [ flokli hexa ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.10";
  };
}
