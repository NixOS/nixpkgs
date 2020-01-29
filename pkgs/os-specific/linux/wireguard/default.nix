{ stdenv, fetchzip, kernel, perl, wireguard-tools }:

# module requires Linux >= 3.10 https://www.wireguard.io/install/#kernel-requirements
assert stdenv.lib.versionAtLeast kernel.version "3.10";
# wireguard upstreamed since 5.6 https://lists.zx2c4.com/pipermail/wireguard/2019-December/004704.html
assert stdenv.lib.versionOlder kernel.version "5.6";

stdenv.mkDerivation rec {
  pname = "wireguard";
  version = "0.0.20200121";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${version}.tar.xz";
    sha256 = "0h8jq8ki998jw4fynb7if4hcgnl0w6lbd5zwiy0xljj3mfqxdxvv";
  };

  preConfigure = ''
    cd src
    sed -i '/depmod/,+1d' Makefile
  '';

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";

  NIX_CFLAGS = ["-Wno-error=cpp"];

  nativeBuildInputs = [ perl ] ++ kernel.moduleBuildDependencies;

  buildFlags = [ "module" ];
  installTargets = [ "module-install" ];

  meta = with stdenv.lib; {
    inherit (wireguard-tools.meta) homepage license maintainers;
    description = "Kernel module for the WireGuard secure network tunnel";
    downloadPage = "https://git.zx2c4.com/wireguard-linux-compat/refs/";
    platforms = platforms.linux;
  };
}
