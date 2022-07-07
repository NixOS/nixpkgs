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

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  installFlags = [ "DEPMOD=true" ];

  meta = with lib; {
    homepage = "https://github.com/xmm7360/xmm7360-pci";
    description = "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
    downloadPage = "https://github.com/xmm7360/xmm7360-pci";
    license = licenses.isc;
    maintainers = with maintainers; [ flokli hexa ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.10" || kernel.kernelAtLeast "5.14";
  };
}
