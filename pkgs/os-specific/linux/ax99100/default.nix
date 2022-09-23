{ kernel, stdenv, kmod, lib, fetchzip }:
stdenv.mkDerivation
{
  pname = "ax99100";
  version = "1.8.0";
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;
  src = fetchzip {
    url = "https://www.asix.com.tw/en/support/download/file/1229";
    sha256 = "1rbp1m01qr6b3nbr72vpbw89pjh8mddc60im78z2yjd951xkbcjh";
    extension = "tar.bz2";
  };

  makeFlags = [ "KDIR='${kernel.dev}/lib/modules/${kernel.modDirVersion}/build'" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
    cp ax99100.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
  '';

  meta = {
    description = "ASIX AX99100 Serial and Parralel Port driver";
    homepage = "https://www.asix.com.tw/en/product/Interface/PCIe_Bridge/AX99100";
    # According to the source code in the tarball, the license is gpl2.
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    # currently, the build fails with kernels newer than 5.17
    broken = lib.versionAtLeast kernel.version "5.18.0";
  };
}
