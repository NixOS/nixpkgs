{ stdenv, fetchzip, kernel, perl, wireguard-tools, bc }:

# module requires Linux >= 3.10 https://www.wireguard.io/install/#kernel-requirements
assert stdenv.lib.versionAtLeast kernel.version "3.10";
# wireguard upstreamed since 5.6 https://lists.zx2c4.com/pipermail/wireguard/2019-December/004704.html
assert stdenv.lib.versionOlder kernel.version "5.6";

stdenv.mkDerivation rec {
  pname = "wireguard";
  version = "1.0.20210424";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${version}.tar.xz";
    sha256 = "sha256-VLtIxYh308X28c9EOeHx0eA7HP2aRlekPXRt015/qAg=";
  };

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [ perl bc ] ++ kernel.moduleBuildDependencies;

  preBuild = "cd src";
  buildFlags = [ "module" ];

  INSTALL_MOD_PATH = placeholder "out";
  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  passthru = {
    # remove this when our kernel comes with native wireguard support
    # and our tests no longer tests this package
    inherit (wireguard-tools) tests;
  };

  meta = with stdenv.lib; {
    inherit (wireguard-tools.meta) homepage license maintainers;
    description = "Kernel module for the WireGuard secure network tunnel";
    downloadPage = "https://git.zx2c4.com/wireguard-linux-compat/refs/";
    platforms = platforms.linux;
  };
}
