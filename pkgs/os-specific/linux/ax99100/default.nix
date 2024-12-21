{
  kernel,
  stdenv,
  kmod,
  lib,
  fetchzip,
  dos2unix,
}:

stdenv.mkDerivation {
  pname = "ax99100";
  version = "1.8.0";

  nativeBuildInputs = [
    dos2unix
    kmod
  ] ++ kernel.moduleBuildDependencies;

  src = fetchzip {
    url = "https://www.asix.com.tw/en/support/download/file/1229";
    sha256 = "1rbp1m01qr6b3nbr72vpbw89pjh8mddc60im78z2yjd951xkbcjh";
    extension = "tar.bz2";
  };

  prePatch = ''
    # The sources come with Windows file endings and that makes
    # applying patches hard without first fixing the line endings.
    dos2unix *.c *.h
  '';

  # The patches are adapted from: https://aur.archlinux.org/packages/asix-ax99100
  #
  # We included them here instead of fetching them, because of line
  # ending issues that are easier to fix manually. Also the
  # set_termios patch needs to be applied for 6.1 not for 6.0.
  patches =
    [
      ./kernel-5.18-pci_free_consistent-pci_alloc_consistent.patch
      ./kernel-6.1-set_termios-const-ktermios.patch
    ]
    ++ lib.optionals (lib.versionAtLeast kernel.version "6.2") [
      ./kernel-6.2-fix-pointer-type.patch
      ./kernel-6.4-fix-define-semaphore.patch
    ];

  patchFlags = [ "-p0" ];

  makeFlags = [ "KDIR='${kernel.dev}/lib/modules/${kernel.modDirVersion}/build'" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
    cp ax99100.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/tty/serial
  '';

  meta = {
    description = "ASIX AX99100 Serial and Parallel Port driver";
    homepage = "https://www.asix.com.tw/en/product/Interface/PCIe_Bridge/AX99100";
    # According to the source code in the tarball, the license is gpl2.
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;

    # Older Linux versions need more patches to work.
    broken = lib.versionOlder kernel.version "5.4.0";
  };
}
