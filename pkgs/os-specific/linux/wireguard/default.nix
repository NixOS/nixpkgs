{ lib, stdenv, fetchzip, kernel, perl, wireguard-tools, bc }:

# wireguard upstreamed since 5.6 https://lists.zx2c4.com/pipermail/wireguard/2019-December/004704.html
assert lib.versionOlder kernel.version "5.6";

stdenv.mkDerivation rec {
  pname = "wireguard";
  version = "1.0.20220627";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${version}.tar.xz";
    sha256 = "sha256-skbho3e49lZ/GLp/JDQpf/yXIEjes86aYtw/dn6e0Uo=";
  };

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [ perl bc ] ++ kernel.moduleBuildDependencies;

  preBuild = "cd src";
  buildFlags = [ "module" ];
  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  INSTALL_MOD_PATH = placeholder "out";
  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  passthru = {
    # remove this when our kernel comes with native wireguard support
    # and our tests no longer tests this package
    inherit (wireguard-tools) tests;
  };

  meta = with lib; {
    inherit (wireguard-tools.meta) homepage license maintainers;
    description = "Kernel module for the WireGuard secure network tunnel";
    longDescription = ''
      Backport of WireGuard for kernels 3.10 to 5.5, as an out of tree module.
      (as WireGuard was merged into the Linux kernel for 5.6)
    '';
    downloadPage = "https://git.zx2c4.com/wireguard-linux-compat/refs/";
    platforms = platforms.linux;
  };
}
