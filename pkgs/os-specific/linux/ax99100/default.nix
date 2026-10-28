{
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  kmod,
  lib,
  fetchzip,
  dos2unix,
}:

stdenv.mkDerivation {
  pname = "ax99100";
  version = "2.3.0";

  nativeBuildInputs = [
    dos2unix
    kmod
  ]
  ++ kernel.moduleBuildDependencies;

  src = fetchzip {
    url = "https://www.asix.com.tw/en/support/download/file/1956";
    sha256 = "sha256-acvKb+ohOFrfytgHp9KUVivqDRvgsFgK8bxxHkIh8PU=";
    extension = "tar.bz2";
  };

  makeFlags = kernelModuleMakeFlags ++ [ "KDIR='${kernel.dev}/lib/modules/${kernel.modDirVersion}'" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
    cp ax99100x.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
  '';

  meta = {
    description = "ASIX AX99100 Serial and Parallel Port driver";
    homepage = "https://www.asix.com.tw/en/product/Interface/PCIe_Bridge/AX99100";
    # According to the source code in the tarball, the license is gpl2.
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;

    # Older Linux versions need more patches to work.
    # Newer Linux versions switched from a ring buffer to fifo for serial,
    # which would require a lot of patching: see Linux commit https://github.com/torvalds/linux/commit/1788cf6a91d9fa9aa61fc2917afe192c23d67f6a.
    broken = (kernel.kernelOlder "5.4.0") || (kernel.kernelAtLeast "6.10");
  };
}
